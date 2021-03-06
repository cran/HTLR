% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{diabetes392}
\alias{diabetes392}
\title{Pima Indians Diabetes}
\format{
A list contains data matrix \code{X} and response vector \code{y}:
\describe{
  \item{X}{A matrix with 392 rows (observations) and 8 columns (features).}
  \item{y}{A binary vector where 1 indicates diabetes patients and 0 for otherwise.}
}
}
\source{
\url{https://www.kaggle.com/uciml/pima-indians-diabetes-database}
}
\usage{
data("diabetes392")
}
\description{
This dataset is originally from the National Institute of Diabetes and Digestive and Kidney Diseases.
The objective of the dataset is to diagnostically predict whether or not a patient has diabetes, 
based on certain diagnostic measurements included in the dataset. Several constraints were placed 
on the selection of these instances from a larger database. In particular, all patients here are 
females at least 21 years old of Pima Indian heritage. Different from the UCI original version, 
the dataset has been preprocessed such that rows with missing values are removed, and features are scaled.
}
\references{
Smith, J.W., Everhart, J.E., Dickson, W.C., Knowler, W.C., & Johannes, R.S. (1988). 
Using the ADAP learning algorithm to forecast the onset of diabetes mellitus. 
\emph{In Proceedings of the Symposium on Computer Applications and Medical Care} (pp. 261--265). 
IEEE Computer Society Press.
}
\seealso{
\url{https://avehtari.github.io/modelselection/diabetes.html}
}
\keyword{datasets}
