


slope.ci <- function(x, y, alpha=.05, epsilon=.01) {
  
  compute.k <- function(n, p, alpha = 0.05)
  {
    k <- qbinom(alpha/2, n, p)
    if(k > 0) {
      k <- k - 1
    }
    k0 <- k
    beta <- 0
    while(beta < alpha) {
      gama <- beta
      beta <- pbinom(k, n, p) + 1 - pbinom(n - k - 1, n, p) 
      k <- k + 1
    }
    k <-  k - 1
    d1 <- beta - alpha
    d2 <- alpha - gama
    if(d1 > d2) {
      k <- k - 1
      beta <- gama
    }
    return(k)
  }
  
  compute.c <- function(eps) {
    b2 <- qnorm(.5/(1-eps))
    d1 <- 0
    if(eps==0.010) d1 <- .019
    if(eps==0.025) d1 <- .046
    if(eps==0.050) d1 <- .096
    if(eps==0.100) d1 <- .198
    if(eps==0.150) d1 <- .339
    if(eps==0.200) d1 <- .505
    if(eps==0.250) d1 <- .73
    if(d1 == 0) stop("can't use that epsilon")
    b1 <- qnorm(.5/(1-eps))*(d1 + sqrt(1 + d1^2))
    # b1 = max bias centercept of RMS
    # b2 = max bias median
    p1 <- pnorm(b1)
    p2 <- pnorm(b2)
    return( p1 + p2 - 2 * p1 * p2 )
  }
  
  p <- (1-epsilon)*compute.c(epsilon)
  n <- length(x)
  k <- compute.k(n=n, p=p, alpha=alpha)
  slope <- repeated.r(x=x, y=y)
  inte <- median( y - slope * (x - median(x)) )
  w <- sort((y - inte)/(x - median(x)))
  return( c(w[k+1], w[n-k]) )
}



repeated.r <- function(x, y) {
  
  n <- length(y)
  a <- rep(0,n)
  for(i in 1:n) {
    tmp <- (x[-i] != x[i] )
    tmp.x <- (x[-i])[tmp]
    tmp.y <- (y[-i])[tmp]
    a[i] <- median( (y[i] - tmp.y) / (x[i] - tmp.x))
  }
  return(median(a))
  
}



