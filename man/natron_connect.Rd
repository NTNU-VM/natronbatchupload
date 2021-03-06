% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/natron_connect.R
\name{natron_connect}
\alias{natron_connect}
\title{Connect to NaTron}
\usage{
natron_connect(username, database = "natron_sandbox")
}
\arguments{
\item{username}{This is your NaTron username}

\item{database}{What database do you want to connect to? Options are "natron" and "natron_sandbox" (default). OBS: always test your upload to the sandbox before uploading to natron.}
}
\value{
Formal class PostgreSQLConnection
}
\description{
\code{natron_connect} establishes a connection between R and NaTron.
}
\details{
You need to be connected via the NTNU network, either through eduroam or a vpn.
}
\examples{
\dontrun{
myUserName <- "JohnD"
myConnection <- natron_connect(myUserName)
}
}
