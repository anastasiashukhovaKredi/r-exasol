\name{exa.readData}
\alias{exa.readData}
\title{
Execute a SQL query on an EXASolution database and read results in a fast way.
}
\description{
This function executes the given SQL query using a given RODBC connection and returns the results as a data frame.

The results are transfered via a proprietary high speed channel from the database optimized for bulk transfer. The EXPORT ... INTO CSV AT ... statement is used internally to transfer the results as a csv. This is significantly faster than RODBC.
On the R-side, the results are parsed per default via read.csv. You can also use arbitrary readers, processing the incoming csv records according to your needs.
}
\usage{
exa.readData(channel, query, reader = function(...) read.csv(..., stringsAsFactors = FALSE, blank.lines.skip = FALSE), server = NA)
}
\arguments{
  \item{channel}{
The RODBC connection channel, typically created via odbcConnect.
}
  \item{query}{
A string with the SQL query to be executed on EXASolution.
}
  \item{reader}{
This is a function reading and processing the results coming from the database. The read.csv function is used per default.

The input for the reader is an R file connection object (as returned by the file function) containing the CSV input, as it is returned by the internall call of EXPORT TO LOCAL CSV.

The following custom reader function would simply read and return the CSV formatted text:

> myReader <- function(fileConnection) {readLines(fileConnection)}
}
  \item{server}{
This parameter is only relevant in rare cases where you want to customize the address of the data channel. Per default, the data channel uses the same host and port as the RODBC connection.
}
}
\value{
The return value is the return value of the reader function. If the default read.csv is used, the result will be a dataframe as it is returned read.csv.
}
\author{
EXASOL AG <support@exasol.com>
}

\examples{

require(RODBC)
require(exasol)

# Connect via RODBC with configured DSN
C <- odbcConnect("exasolution")

# Read results
tables <- exa.readData(C, "SELECT * FROM EXA_ALL_TABLES")

# Work with the data frame returned (examples)
print(nrow(tables))      # print number of rows
print(colnames(tables))  # print names of columns
print(tables[1,])        # print first row
print(tables$TABLE_NAME[1])  # print first value of specified column


}

