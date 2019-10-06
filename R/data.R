#' Colon tissues data
#'
#' In this dataset, expression levels of 40 tumor and 22 normal colon tissues 
#' for 6500 human genes are measured using the Affymetrix technology. 
#' A selection of 2000 genes with highest minimal intensity across the samples
#' has been made by Alon et al. (1999). The data is preprocessed by carrying out 
#' a base 10 logarithmic transformation and standardizing each tissue sample to 
#' zero mean and unit variance across the genes.
#'
#' @docType data
#' 
#' @keywords datasets
#'
#' @format A list contains data matrix \code{X} and response vector \code{y}:
#' \describe{
#'   \item{X}{A matrix with 66 rows (observations) and 2000 columns (features).}
#'   \item{y}{A binary vector where 0 indicates normal colon tissues and 1 indicates tumor colon tissues.}
#' }
#' 
#' @usage data("colon")
#' 
#' @source \url{ftp://stat.ethz.ch/Manuscripts/dettling/bagboost.pdf}
#' 
#' @references Dettling Marcel, and Peter Bühlmann (2002). Supervised clustering of genes.
#' \emph{Genome biology}, 3(12), research0069-1.
#' 
"colon"