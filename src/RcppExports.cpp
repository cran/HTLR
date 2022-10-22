// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// sample_trunc_norm
Rcpp::NumericVector sample_trunc_norm(const int n, const double lb, const double ub, const bool verbose);
RcppExport SEXP _HTLR_sample_trunc_norm(SEXP nSEXP, SEXP lbSEXP, SEXP ubSEXP, SEXP verboseSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const int >::type n(nSEXP);
    Rcpp::traits::input_parameter< const double >::type lb(lbSEXP);
    Rcpp::traits::input_parameter< const double >::type ub(ubSEXP);
    Rcpp::traits::input_parameter< const bool >::type verbose(verboseSEXP);
    rcpp_result_gen = Rcpp::wrap(sample_trunc_norm(n, lb, ub, verbose));
    return rcpp_result_gen;
END_RCPP
}
// sample_post_ichi
Rcpp::NumericVector sample_post_ichi(const int n, const Rcpp::NumericVector& sigmasq, const double alpha1, const double alpha0, const double w0, const bool verbose);
RcppExport SEXP _HTLR_sample_post_ichi(SEXP nSEXP, SEXP sigmasqSEXP, SEXP alpha1SEXP, SEXP alpha0SEXP, SEXP w0SEXP, SEXP verboseSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const int >::type n(nSEXP);
    Rcpp::traits::input_parameter< const Rcpp::NumericVector& >::type sigmasq(sigmasqSEXP);
    Rcpp::traits::input_parameter< const double >::type alpha1(alpha1SEXP);
    Rcpp::traits::input_parameter< const double >::type alpha0(alpha0SEXP);
    Rcpp::traits::input_parameter< const double >::type w0(w0SEXP);
    Rcpp::traits::input_parameter< const bool >::type verbose(verboseSEXP);
    rcpp_result_gen = Rcpp::wrap(sample_post_ichi(n, sigmasq, alpha1, alpha0, w0, verbose));
    return rcpp_result_gen;
END_RCPP
}
// sample_trunc_beta
Rcpp::NumericVector sample_trunc_beta(const int n, const double alpha, const double beta, const double lb, const double ub, const bool verbose);
RcppExport SEXP _HTLR_sample_trunc_beta(SEXP nSEXP, SEXP alphaSEXP, SEXP betaSEXP, SEXP lbSEXP, SEXP ubSEXP, SEXP verboseSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const int >::type n(nSEXP);
    Rcpp::traits::input_parameter< const double >::type alpha(alphaSEXP);
    Rcpp::traits::input_parameter< const double >::type beta(betaSEXP);
    Rcpp::traits::input_parameter< const double >::type lb(lbSEXP);
    Rcpp::traits::input_parameter< const double >::type ub(ubSEXP);
    Rcpp::traits::input_parameter< const bool >::type verbose(verboseSEXP);
    rcpp_result_gen = Rcpp::wrap(sample_trunc_beta(n, alpha, beta, lb, ub, verbose));
    return rcpp_result_gen;
END_RCPP
}
// htlr_fit_helper
Rcpp::List htlr_fit_helper(int p, int K, int n, arma::mat& X, arma::mat& ymat, arma::uvec& ybase, std::string ptype, double alpha, double s, double eta, int iters_rmc, int iters_h, int thin, int leap_L, int leap_L_h, double leap_step, double hmc_sgmcut, arma::mat& deltas, arma::vec& sigmasbt, bool keep_warmup_hist, int silence, bool legacy);
RcppExport SEXP _HTLR_htlr_fit_helper(SEXP pSEXP, SEXP KSEXP, SEXP nSEXP, SEXP XSEXP, SEXP ymatSEXP, SEXP ybaseSEXP, SEXP ptypeSEXP, SEXP alphaSEXP, SEXP sSEXP, SEXP etaSEXP, SEXP iters_rmcSEXP, SEXP iters_hSEXP, SEXP thinSEXP, SEXP leap_LSEXP, SEXP leap_L_hSEXP, SEXP leap_stepSEXP, SEXP hmc_sgmcutSEXP, SEXP deltasSEXP, SEXP sigmasbtSEXP, SEXP keep_warmup_histSEXP, SEXP silenceSEXP, SEXP legacySEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< int >::type p(pSEXP);
    Rcpp::traits::input_parameter< int >::type K(KSEXP);
    Rcpp::traits::input_parameter< int >::type n(nSEXP);
    Rcpp::traits::input_parameter< arma::mat& >::type X(XSEXP);
    Rcpp::traits::input_parameter< arma::mat& >::type ymat(ymatSEXP);
    Rcpp::traits::input_parameter< arma::uvec& >::type ybase(ybaseSEXP);
    Rcpp::traits::input_parameter< std::string >::type ptype(ptypeSEXP);
    Rcpp::traits::input_parameter< double >::type alpha(alphaSEXP);
    Rcpp::traits::input_parameter< double >::type s(sSEXP);
    Rcpp::traits::input_parameter< double >::type eta(etaSEXP);
    Rcpp::traits::input_parameter< int >::type iters_rmc(iters_rmcSEXP);
    Rcpp::traits::input_parameter< int >::type iters_h(iters_hSEXP);
    Rcpp::traits::input_parameter< int >::type thin(thinSEXP);
    Rcpp::traits::input_parameter< int >::type leap_L(leap_LSEXP);
    Rcpp::traits::input_parameter< int >::type leap_L_h(leap_L_hSEXP);
    Rcpp::traits::input_parameter< double >::type leap_step(leap_stepSEXP);
    Rcpp::traits::input_parameter< double >::type hmc_sgmcut(hmc_sgmcutSEXP);
    Rcpp::traits::input_parameter< arma::mat& >::type deltas(deltasSEXP);
    Rcpp::traits::input_parameter< arma::vec& >::type sigmasbt(sigmasbtSEXP);
    Rcpp::traits::input_parameter< bool >::type keep_warmup_hist(keep_warmup_histSEXP);
    Rcpp::traits::input_parameter< int >::type silence(silenceSEXP);
    Rcpp::traits::input_parameter< bool >::type legacy(legacySEXP);
    rcpp_result_gen = Rcpp::wrap(htlr_fit_helper(p, K, n, X, ymat, ybase, ptype, alpha, s, eta, iters_rmc, iters_h, thin, leap_L, leap_L_h, leap_step, hmc_sgmcut, deltas, sigmasbt, keep_warmup_hist, silence, legacy));
    return rcpp_result_gen;
END_RCPP
}
// log_sum_exp
arma::vec log_sum_exp(const arma::mat& A);
RcppExport SEXP _HTLR_log_sum_exp(SEXP ASEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const arma::mat& >::type A(ASEXP);
    rcpp_result_gen = Rcpp::wrap(log_sum_exp(A));
    return rcpp_result_gen;
END_RCPP
}
// spl_sgm_ig
arma::vec spl_sgm_ig(double alpha, int K, double w, const arma::vec& vardeltas);
RcppExport SEXP _HTLR_spl_sgm_ig(SEXP alphaSEXP, SEXP KSEXP, SEXP wSEXP, SEXP vardeltasSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< double >::type alpha(alphaSEXP);
    Rcpp::traits::input_parameter< int >::type K(KSEXP);
    Rcpp::traits::input_parameter< double >::type w(wSEXP);
    Rcpp::traits::input_parameter< const arma::vec& >::type vardeltas(vardeltasSEXP);
    rcpp_result_gen = Rcpp::wrap(spl_sgm_ig(alpha, K, w, vardeltas));
    return rcpp_result_gen;
END_RCPP
}
// std_helper
Rcpp::List std_helper(const arma::mat& A);
RcppExport SEXP _HTLR_std_helper(SEXP ASEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const arma::mat& >::type A(ASEXP);
    rcpp_result_gen = Rcpp::wrap(std_helper(A));
    return rcpp_result_gen;
END_RCPP
}
// comp_vardeltas
arma::vec comp_vardeltas(const arma::mat& deltas);
RcppExport SEXP _HTLR_comp_vardeltas(SEXP deltasSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const arma::mat& >::type deltas(deltasSEXP);
    rcpp_result_gen = Rcpp::wrap(comp_vardeltas(deltas));
    return rcpp_result_gen;
END_RCPP
}
// comp_lsl
arma::vec comp_lsl(arma::mat& A);
RcppExport SEXP _HTLR_comp_lsl(SEXP ASEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::mat& >::type A(ASEXP);
    rcpp_result_gen = Rcpp::wrap(comp_lsl(A));
    return rcpp_result_gen;
END_RCPP
}
// log_normcons
double log_normcons(arma::mat& A);
RcppExport SEXP _HTLR_log_normcons(SEXP ASEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::mat& >::type A(ASEXP);
    rcpp_result_gen = Rcpp::wrap(log_normcons(A));
    return rcpp_result_gen;
END_RCPP
}
// gendata_FAM_helper
Rcpp::List gendata_FAM_helper(int n, arma::mat& muj, const arma::mat& muj_rep, const arma::mat& A, double sd_g, bool stdx);
RcppExport SEXP _HTLR_gendata_FAM_helper(SEXP nSEXP, SEXP mujSEXP, SEXP muj_repSEXP, SEXP ASEXP, SEXP sd_gSEXP, SEXP stdxSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< int >::type n(nSEXP);
    Rcpp::traits::input_parameter< arma::mat& >::type muj(mujSEXP);
    Rcpp::traits::input_parameter< const arma::mat& >::type muj_rep(muj_repSEXP);
    Rcpp::traits::input_parameter< const arma::mat& >::type A(ASEXP);
    Rcpp::traits::input_parameter< double >::type sd_g(sd_gSEXP);
    Rcpp::traits::input_parameter< bool >::type stdx(stdxSEXP);
    rcpp_result_gen = Rcpp::wrap(gendata_FAM_helper(n, muj, muj_rep, A, sd_g, stdx));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_HTLR_sample_trunc_norm", (DL_FUNC) &_HTLR_sample_trunc_norm, 4},
    {"_HTLR_sample_post_ichi", (DL_FUNC) &_HTLR_sample_post_ichi, 6},
    {"_HTLR_sample_trunc_beta", (DL_FUNC) &_HTLR_sample_trunc_beta, 6},
    {"_HTLR_htlr_fit_helper", (DL_FUNC) &_HTLR_htlr_fit_helper, 22},
    {"_HTLR_log_sum_exp", (DL_FUNC) &_HTLR_log_sum_exp, 1},
    {"_HTLR_spl_sgm_ig", (DL_FUNC) &_HTLR_spl_sgm_ig, 4},
    {"_HTLR_std_helper", (DL_FUNC) &_HTLR_std_helper, 1},
    {"_HTLR_comp_vardeltas", (DL_FUNC) &_HTLR_comp_vardeltas, 1},
    {"_HTLR_comp_lsl", (DL_FUNC) &_HTLR_comp_lsl, 1},
    {"_HTLR_log_normcons", (DL_FUNC) &_HTLR_log_normcons, 1},
    {"_HTLR_gendata_FAM_helper", (DL_FUNC) &_HTLR_gendata_FAM_helper, 6},
    {NULL, NULL, 0}
};

RcppExport void R_init_HTLR(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
