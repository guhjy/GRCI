
source('rci-pub.R')
set.seed(123)
n <- 30
x <- rexp(n, rate=.5)
y <- 2 - x + rnorm(n, sd=.7)
# 95% CI, protected against up to 5% of outliers
slope.ci(x=x, y=y, alpha=.05, epsilon=.05)
# plot the data and the MM- and LS-fits, both coincide
plot(y ~ x, pch=19, col='gray', cex=1.5, ylim=c(-6, 6))
library(robustbase)
abline(lmrob(y~x), lwd=6, col='steelblue')
abline(lm(y~x), lwd=2, col='red')

# add outliers
ou <- rbinom(n, size=1, prob=.05)
y[ou==1] <- rnorm(sum(ou), mean=5, sd=.1)
x[ou==1] <- rnorm(sum(ou), mean=7, sd=.1)
# 95% CI, protected against up to 5% of outliers
slope.ci(x=x, y=y, alpha=.05, epsilon=.05)
# plot the contaminated data and the MM- and LS-fits, quite different now
points(y[ou==1] ~ x[ou==1], pch=19, col='gray30', cex=1.5)
abline(lmrob(y~x), lwd=6, col='lightblue')
abline(lm(y~x), lwd=2, col='orange')

# Note that the asymptotic CI based on the MM-estimator
# does not contain the true slope (-1)
summary(lmrob(y~x))
# However, using the FRB SE's works well
library(FRB)
sqrt(diag(frb(lmrob(y~x))))
