% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/upsert_locations.R
\name{upsert_locations}
\alias{upsert_locations}
\title{Location upsert}
\usage{
upsert_locations(location_data, conn)
}
\arguments{
\item{location_data}{Location table to be upserted/uploaded to NaTron (see \code{?location_table})}

\item{conn}{Database connection object with write permissions (see \code{?natron_connect}). It's the connection object that determines if the data is upserted to the sandbox or not.}
}
\value{
Pushes and upserts data to database. Returns nothing.
}
\description{
Upserts location tables to the NaTron database.
}
\examples{
\dontrun{
upsert_location(location_data = myLocationTable, conn = myConnection)
}

}
\seealso{
Other upsert functions: \code{\link{upsert_events}},
  \code{\link{upsert_occ}}
}
\concept{upsert functions}
