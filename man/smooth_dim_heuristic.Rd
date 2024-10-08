% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RtGam.R
\name{smooth_dim_heuristic}
\alias{smooth_dim_heuristic}
\title{Propose total smoothing basis dimension from the number of data points}
\usage{
smooth_dim_heuristic(n)
}
\arguments{
\item{n}{An integer, the dimension of the data.}
}
\value{
An integer, the proposed \emph{total} smooth basis dimensionality
available to the \link{RtGam} model.
}
\description{
Return a reasonable value for the \code{k} argument of \link{RtGam} (the \emph{total} smooth
basis dimension of the model's one or more smooth predictors) based on the
number of data points. The smooth basis dimension controls the maximum
degrees of freedom (and by proxy the "wiggliness") of the smooth predictors.
The estimation procedure leans toward providing an excess number of degrees
of freedom to the model. The consequence is slower model fits, but a better
chance of avoiding avoiding non-convergence due to undersmoothing. If
manually supplying a value to \code{k} rather than relying on the default
estimate, see \emph{When to use a different value} for \link{RtGam}-specific
implementation guidance and \link[mgcv:choose.k]{mgcv::choose.k} for more general debugging
guidance from the underlying model fitting package. Note that \code{k} may be a
minimum of 2 or a maximum of the number of data points.
}
\section{How \code{k} is used}{
The model is composed of one or more smooth predictors, depending the
specifics of the model specification. In a simple model with only one smooth
predictor, all the degrees of freedom from \code{k} would be applied to that
single smooth. In a more complex model composed of multiple smooth
predictors, the total degrees degrees of freedom made available by \code{k} would
be partitioned between the different smooths.
}

\section{When to use a different value}{
\subsection{Model non-convergence}{

When an \link{RtGam} model does not converge, a reasonable first debugging step is
to increase the value of \code{k} and refit the model. Commonly, GAMs exhibit
diagnostic issues when the model does not have enough flexibility to
represent the underlying data generating process. Increasing \code{k} above the
default estimate provides more flexibility.

However, insufficient flexibility is not the only source of non-convergence.
When increasing \code{k} does not improve the default model diagnostics, manual
model checking via \code{\link[mgcv:gam.check]{mgcv::gam.check()}} may be needed. Also see
\link[mgcv:choose.k]{mgcv::choose.k} for guidance.
}

\subsection{Slow model fits}{

\link{RtGam} models usually fit faster when the model has less flexibility (lower
values of \code{k}). The guess from \code{\link[=smooth_dim_heuristic]{smooth_dim_heuristic()}} leans toward
providing excess degrees of freedom, so model fits may take a little longer
than needed. If models are taking a long time to converge, it would be
reasonable to set \code{k} to a small value, checking for convergence, and
increasing \code{k} if needed until the model convergences. This approach may or
may not be faster than simply waiting for a model with a higher \code{k} to fit.
}

\subsection{Very wiggly data}{

If running models in a setting where the data seem quite wiggly, exhibiting
sharp jumps or drops, a model with more flexibility than normal may be
needed. \code{k} should be increased to the maximum possible value. When running
pre-set models in production, it would also be reasonable to fix the value of
\code{k} above the default. Because GAMs penalize model wiggliness, the fit to
both wiggly and non-wiggly data is likely to be satisfactory, at the cost of
increased runtime.
}
}

\section{Implementation details}{
The algorithm to pick \code{k} is a piecewise function. When \eqn{n \le 10}, then
the returned value is \eqn{n}. When \eqn{n > 10}, then the returned value is
\eqn{ \lceil \sqrt{10n} \rceil }. This approach is loosely inspired by Ward
et al., 2021. As in Ward et al. the degrees of freedom of the spline (1) is
set to a reasonably high value to avoid oversmoothing and (2) scales with the
dimension of the data to accommodate changing trends over time.

\code{\link[=smooth_dim_heuristic]{smooth_dim_heuristic()}} uses a piecewise function because each smooth
parameter needs its own degrees of freedom, which adds a fixed initial setup
cost. When the dimension of the data is small, the default value of \code{k}
increases linearly with the data to accommodate this fixed setup cost. When
the dimension of the data is larger, the default value of \code{k} increases with
the square root of the data to balance having sufficient basis dimension to
fit to changing trends over time without having so many dimensions that model
fits are very slow.
}

\examples{
cases <- 1:10
k <- smooth_dim_heuristic(length(cases))
}
\references{
Ward, Thomas, et al. "Growth, reproduction numbers and factors
affecting the spread of SARS-CoV-2 novel variants of concern in the UK from
October 2020 to July 2021: a modelling analysis." BMJ open 11.11 (2021):
e056636.
}
\seealso{
\code{\link[=RtGam]{RtGam()}} for the use-case and additional documentation as well as
\link[mgcv:choose.k]{mgcv::choose.k} and \link[mgcv:gam.check]{mgcv::gam.check} for more general guidance from
\code{mgcv}.
}
