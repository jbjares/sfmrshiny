makeList <- function(vec) {
  len <- length(vec[-1])
  out <- as.list(rep(as.numeric(vec[1]), len))
  names(out) <- as.character(vec[-1])
  out
}