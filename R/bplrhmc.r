#' Fit a HTLR Model (Internal API)
#'
#' This function trains linear logistic regression models with HMC in restricted Gibbs sampling.
#' It also makes predictions for test cases if \code{X_ts} are provided.
#'
#' @param y_tr Vector of response variables. Must be coded as non-negative integers, 
#' e.g., 1,2,\ldots,C for C classes, label 0 is also allowed.
#' @param X_tr Input matrix, of dimension nobs by nvars; each row is an observation vector.
#' @param fsel Subsets of features selected before fitting, such as by univariate screening.
#' @param stdzx Logical; if \code{TRUE}, the original feature values are standardized to have \code{mean = 0} 
#' and \code{sd = 1}.
#' 
#' @param iters_h A positive integer specifying the number of warmup (aka burnin).
#' @param iters_rmc A positive integer specifying the number of iterations after warmup.
#' @param thin A positive integer specifying the period for saving samples.
#' 
#' @param leap_L The length of leapfrog trajectory in sampling phase.
#' @param leap_L_h The length of leapfrog trajectory in burnin phase.
#' @param leap_step The stepsize adjustment multiplied to the second-order partial derivatives of log posterior.
#' 
#' @param initial_state The initial state of Markov Chain; can be a previously 
#' fitted \code{fithtlr} object, or a user supplied initial state vector, or 
#' a character string matches the following:  
#' \itemize{
#'   \item "lasso" - (Default) Use Lasso initial state with \code{lambda} chosen by 
#'   cross-validation. Users may specify their own candidate \code{lambda} values via 
#'   optional argument \code{lasso.lambda}. Further customized Lasso initial 
#'   states can be generated by \code{\link{lasso_deltas}}.    
#'   \item "bcbcsfrda" - Use initial state generated by package \code{BCBCSF} 
#'   (Bias-corrected Bayesian classification). Further customized BCBCSF initial 
#'   states can be generated by \code{\link{bcbcsf_deltas}}. WARNING: This type of 
#'   initial states can be used for continuous features such as gene expression profiles, 
#'   but it should not be used for categorical features such as SNP profiles.
#'   \item "random" - Use random initial values sampled from N(0, 1).     
#' } 
#' 
#' @param ptype The prior to be applied to the model. Either "t" (student-t, default), 
#' "ghs" (horseshoe), or "neg" (normal-exponential-gamma).
#' 
#' @param sigmab0 The \code{sd} of the normal prior for the intercept.
#' @param alpha The degree freedom of t/ghs/neg prior for coefficients.
#' @param s The log scale of priors (logw) for coefficients.
#' @param eta The \code{sd} of the normal prior for logw. When it is set to 0, logw is fixed. 
#' Otherwise, logw is assigned with a normal prior and it will be updated during sampling. 
#' 
#' @param hmc_sgmcut The coefficients smaller than this criteria will be fixed in 
#' each HMC updating step.
#' 
#' @param silence Setting it to \code{FALSE} for tracking MCMC sampling iterations. 
#' @param pre.legacy Logical; if \code{TRUE}, the output produced in \code{HTLR} versions up to 
#' legacy-3.1-1 is reproduced. The speed would be typically slower than non-legacy mode on
#' multi-core machine.  
#' 
#' @param X_ts Test data which predictions are to be made.
#' @param predburn,predthin For prediction base on \code{X_ts} (when supplied), \code{predburn} of 
#' Markov chain (super)iterations will be discarded, and only every \code{predthin} are used for inference.
#' 
#' @param alpha.rda A user supplied alpha value for \code{\link{bcbcsf_deltas}} when
#' setting up BCBCSF initial state. Default: 0.2. 
#' @param lasso.lambda - A user supplied lambda sequence for \code{\link{lasso_deltas}} when 
#' setting up Lasso initial state. Default: \{.01, .02, \ldots, .05\}. Will be ignored if 
#' \code{pre.legacy} is set to \code{TRUE}. 
#' 
#' @return A list of fitting results. If \code{X_ts} is not provided, the list is an object 
#' with S3 class \code{htlrfit}.  
#' 
#' @references
#' Longhai Li and Weixin Yao (2018). Fully Bayesian Logistic Regression 
#' with Hyper-Lasso Priors for High-dimensional Feature Selection.
#' \emph{Journal of Statistical Computation and Simulation} 2018, 88:14, 2827-2851.
#' 
#' @useDynLib HTLR
#' @import Rcpp stats
#' 
#' @export
#' @keywords internal
#' 
htlr_fit <- function (
    X_tr, y_tr, fsel = 1:ncol(X_tr), stdzx = TRUE, ## data
    ptype = c("t", "ghs", "neg"), sigmab0 = 2000, alpha = 1, s = -10, eta = 0,  ## prior
    iters_h = 1000, iters_rmc = 1000, thin = 1,  ## mc iterations
    leap_L = 50, leap_L_h = 5, leap_step = 0.3,  hmc_sgmcut = 0.05, ## hmc
    initial_state = "lasso", silence = TRUE, pre.legacy = TRUE, 
    alpha.rda = 0.2, lasso.lambda = seq(.05, .01, by = -.01),
    X_ts = NULL, predburn = NULL, predthin = 1)
{
  #------------------------------- Input Checking -------------------------------#
  
  stopifnot(iters_rmc > 0, iters_h >= 0, thin > 0, leap_L > 0, leap_L_h > 0,
            alpha > 0, eta >= 0, sigmab0 >= 0,
            ptype %in% c("t", "ghs", "neg"))
  
  if (length(y_tr) != nrow(X_tr)) stop ("'y' and 'X' mismatch")
  
  yfreq <- table(y_tr)
  if (length(yfreq) < 2)
    stop("less than 2 classes of response")
  if (any(yfreq < 2)) 
    stop("less than 2 cases in some group")

  #----------------------------- Data preprocessing -----------------------------#
  y1 <- as.numeric(y_tr)
  if (min(y1) == 0)
    y1 <- y1 + 1
  
  ybase <- as.integer(y1 - 1)
  ymat <- model.matrix( ~ factor(y1) - 1)[, -1]
  C <- length(unique(ybase))
  K <- C - 1
  
  ## feature selection
  X_tr <- X_tr[, fsel, drop = FALSE]
  names(fsel) <- colnames(X_tr) 
  p <- length(fsel)
  n <- nrow(X_tr)
  
  ## standardize selected features
  nuj <- rep(0, length(fsel))
  sdj <- rep(1, length(fsel))
  if (stdzx == TRUE & !is.numeric(initial_state))
  {
    nuj <- apply(X_tr, 2, median)
    sdj <- apply(X_tr, 2, sd)
    X_tr <- sweep(X_tr, 2, nuj, "-")
    X_tr <- sweep(X_tr, 2, sdj, "/")
  }
  
  ## add intercept
  X_addint <- cbind(1, X_tr)
  if (!is.null(colnames(X_tr)))
    colnames(X_addint) <- c("Intercept", colnames(X_tr))
  
  ## stepsize for HMC from data
  DDNloglike <- 1 / 4 * colSums(X_addint ^ 2)

  #---------------------- Markov chain state initialization ----------------------#

  if (is.list(initial_state)) # use the last iteration of markov chain
  {
    no.mcspl <- length(initial_state$mclogw)
    deltas <- matrix(initial_state$mcdeltas[, , no.mcspl], nrow = p + 1)
    sigmasbt <- initial_state$mcsigmasbt[, no.mcspl]
    s <- initial_state$mclogw[no.mcspl]
    init.type <- "htlr"
  }
  else
  {
    if (is.matrix(initial_state)) # user supplied deltas
    {
      deltas <- initial_state
      if (nrow(deltas) != p + 1 || ncol(deltas) != K)
      {
        stop(
          sprintf(
            "Initial `deltas' mismatch data. Expected: nrow=%d, ncol=%d; Actual: nrow=%d, ncol=%d.",
            p + 1, K, nrow(deltas), ncol(deltas))
        )        
      }
      init.type <- "customized"
    }
    else if (initial_state == "lasso")
    {
      if (pre.legacy) 
        lasso.lambda <- NULL # will be chosen by CV
      deltas <- lasso_deltas(X_tr, y1, lambda = lasso.lambda, verbose = !silence)
      init.type <- "lasso"
    }
    else if (substr(initial_state, 1, 4) == "bcbc")
    {
      deltas <- bcbcsf_deltas(X_tr, y1, alpha.rda)
      init.type <- "bcbc"
    }
    else if (initial_state == "random")
    {
      deltas <- matrix(rnorm((p + 1) * K) * 2, p + 1, K)
      init.type <- "random"
    }
    else stop("not supported init type")
    
    vardeltas <- comp_vardeltas(deltas)[-1]
    sigmasbt <- c(sigmab0, spl_sgm_ig(alpha, K, exp(s), vardeltas))
  }
    
  #-------------------------- Do Gibbs sampling --------------------------#

  fit <- htlr_fit_helper(
      ## data
      p = p, K = K, n = n,
      X = as.matrix(X_addint), 
      ymat = as.matrix(ymat), 
      ybase = as.vector(ybase),
      ## prior
      ptype = ptype, alpha = alpha, s = s, eta = eta,
      ## sampling
      iters_rmc = iters_rmc, iters_h = iters_h, thin = thin, 
      leap_L = leap_L, leap_L_h = leap_L_h, leap_step = leap_step, 
      hmc_sgmcut = hmc_sgmcut, DDNloglike = as.vector(DDNloglike),
      ## fit result
      deltas = deltas, logw = s, sigmasbt = sigmasbt,
      ## other control
      silence = as.integer(silence), legacy = pre.legacy)
  
  # add prior hyperparameter info
  fit$prior <- htlr_prior(ptype, alpha, s, sigmab0)
  
  # add initial state info
  fit$mc.param$init <- init.type
  
  # add data preprocessing info
  fit$feature <- list("y" = y_tr, "X" = X_addint, "stdx" = stdzx,
                      "fsel" = fsel, "nuj" = nuj, "sdj" = sdj)
  
  # add call
  fit$call <- match.call()
  
  # register S3
  attr(fit, "class") <- "htlrfit"
        
  #---------------------- Prediction for test cases ----------------------#
  if (!is.null(X_ts))
  {
    fit$probs_pred <- htlr_predict(
      X_ts = X_ts,
      fithtlr = fit,
      burn = predburn,
      thin = predthin
    )
  }
  
  return(fit)
}

######################## some functions not used currently ###################

# htlr_ci <- function (fithtlr, usedmc = NULL)
# {
#     mcdims <- dim (fithtlr$mcdeltas)
#     p <- mcdims [1] - 1
#     K <- mcdims [2]
#     no_mcspl <- mcdims[3]
# 
#     ## index of mc iters used for inference
# 
#     mcdeltas <- fithtlr$mcdeltas[,,usedmc, drop = FALSE]
#     
#     cideltas <- array (0, dim = c(p+1, K, 3))
#     for (j in 1:(p+1))
#     {
#         for (k in 1:K) {
#           cideltas [j,k,] <- 
#             quantile (mcdeltas[j,k,], probs = c(1-cp, 1, 1 + cp)/2)
#         }
#     }
#     
#     cideltas
# }
# 
# ## this function plots confidence intervals
# htlr_plotci <- function (fithtlr, usedmc = NULL, 
#                          cp = 0.95, truedeltas = NULL,   ...)
# {
#     
#     cideltas <- htlr_coefs (fithtlr, usedmc = usedmc, showci = TRUE, cp = cp)
#     K <- dim (cideltas)[2]
#     
#     for (k in 1:K)
#     {
#         plotmci (cideltas[,k,], truedeltas = truedeltas[,k], 
#                  main = sprintf ("%d%% MC C.I. of Coefs (Class %d)", 
#                                  cp * 100, k+1),
#                 ...)
#         
#     }
#     
#     return (cideltas)
# }
# 
# 
# htlr_outpred <- function (x,y,...)
# {
#   X_ts <- cbind (x, rep (y, each = length (x)))
#   probs_pred <- htlr_predict (X_ts = X_ts, ...)$probs_pred[,2] 
#   matrix (probs_pred, nrow = length (x) )
# }
# 
# 
# norm_coef <- function (deltas)
# {
#   slope <- sqrt (sum(deltas^2))
#   deltas/slope
# }
# 
# pie_coef <- function (deltas)
# {
#   slope <- sum(abs(deltas))
#   deltas/slope
# }
# 
# norm_mcdeltas <- function (mcdeltas)
# {
#   sqnorm <- function (a) sqrt(sum (a^2))
#   dim_mcd <- dim (mcdeltas)
#     
#   slopes <- apply (mcdeltas[-1,,,drop=FALSE], MARGIN = c(2,3), sqnorm)
#     
#   mcthetas <- sweep (x = mcdeltas, MARGIN = c(2,3), STATS = slopes, FUN = "/")
#   
#   list (mcthetas = mcthetas, slopes = as.vector(slopes))
# }
# 
# pie_mcdeltas <- function (mcdeltas)
# {
#   sumabs <- function (a) sum (abs(a))
#   dim_mcd <- dim (mcdeltas)
#     
#   slopes <- apply (mcdeltas[-1,,,drop=FALSE], MARGIN = c(2,3), sumabs)
#     
#   mcthetas <- sweep (x = mcdeltas, MARGIN = c(2,3), STATS = slopes, FUN = "/")
#   
#   list (mcthetas = mcthetas, slopes = as.vector(slopes))
# }
# 
# plotmci <- function (CI, truedeltas = NULL, ...)
# {
#     p <- nrow (CI) - 1
# 
#     plotargs <- list (...)
#     
#     if (is.null (plotargs$ylim)) plotargs$ylim <- range (CI)
#     if (is.null (plotargs$pch))  plotargs$pch <- 4 
#     if (is.null (plotargs$xlab)) 
#        plotargs$xlab <- "Feature Index in Training Data"
#     if (is.null (plotargs$ylab)) plotargs$ylab <- "Coefficient Value"
#     
#     do.call (plot, c (list(x= 0:p, y=CI[,2]), plotargs))
#     
#     abline (h = 0)
#     
#     for (j in 0:p)
#     {
#         
#         points (c(j,j), CI[j+1,-2], type = "l", lwd = 2)
#     }
#     
#     if (!is.null (truedeltas))
#     {
#         points (0:p, truedeltas, col = "red", cex = 1.2, pch = 20)
#     }
# 
# }
# 
# 
# 
# 
# htlr_plotleapfrog <- function ()
# {
#         if (looklf & i_mc %% iters_imc == 0 & i_mc >=0 )
#         {
#            if (!file.exists ("leapfrogplots")) dir.create ("leapfrogplots")
# 
#            postscript (file = sprintf ("leapfrogplots/ch%d.ps", i_sup),
#            title = "leapfrogplots-ch", paper = "special",
#            width = 8, height = 4, horiz = FALSE)
#            par (mar = c(5,4,3,1))
#            plot (-olp$nenergy_trj + olp$nenergy_trj[1],
#                 xlab = "Index of Trajectory", type = "l",
#                 ylab = "Hamiltonian Value",
#                 main =
#                 sprintf (paste( "Hamiltonian Values with the Starting Value",
#                 "Subtracted\n(P(acceptance)=%.2f)", sep = ""),
#                 min(1, exp(olp$nenergy_trj[L+1]-olp$nenergy_trj[1]) )
#                 )
#            )
#            abline (h = c (-1,1))
#            dev.off()
# 
#            postscript (file = sprintf ("leapfrogplots/dd%d.ps", i_sup+1),
#            title = sprintf("leapfrogplots-dd%d", i_sup + 1), 
#            paper = "special",
#            width = 8, height = 4, horiz = FALSE)
#            par (mar = c(5,4,3,1))
#            plot (olp$ddeltas_trj, xlab = "Index of Trajectory",type = "l",
#                  ylab = "square distance of Deltas",
#                  main = "Square Distance of `Deltas'")
#            dev.off ()
# 
#            postscript (file = sprintf ("leapfrogplots/ll%d.ps", i_sup),
#            title = "leapfrogplots-ll", paper = "special",
#            width = 8, height = 4, horiz = FALSE)
#            par (mar = c(5,4,3,1))
#            plot (olp$loglike_trj, xlab = "Index of Trajectory", type = "l",
#                  ylab = "log likelihood",
#                  main = "Log likelihood of Training Cases")
#            dev.off()
#         }
# }
