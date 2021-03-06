\name{exa.writeData}
\alias{exa.writeData}
\title{
Write data frame from R to an EXASolution table.
}
\description{
This function writes the given data frame to a database table.

The data are transfered to the database via a proprietary transfer channel which is optimized for high speed bulk transfer. To be more detailed, the IMPORT INTO ... FROM CSV AT ... statement is used internally. On the R-side, the data.frame is converted to csv format and written to a file connection, streaming the data to the database. You can also use arbitrary writers, processing the data frame according to your needs.
}
\usage{
exa.writeData(channel, data, tableName, tableColumns = NA, writer = function(data, conn) write.table(data, file = conn, row.names = FALSE, col.names = FALSE, na = "", sep = ",", qmethod = "double"), server = NA)
}
\arguments{
  \item{channel}{
The RODBC connection channel, typically created via odbcConnect.
}
  \item{data}{
The data frame to be written to the table specified in tableName.

Please make sure that the column names and types of the data frame are consistent with the names and types in the EXASolution table.
}
  \item{tableName}{
Name of the table to write the data to.
The table has to exist and the records will be appended.
}
  \item{tableColumns}{
If your data frame contains only a subset of the columns you can specify these here. The columns and types have to be specified as a vector of strings like:
c("col1 INT", "col2 VARCHAR(20)")

Please look at the documentation of the cols parameter in IMPORT INTO in the EXASolution manual for details.
}
  \item{writer}{
This parameter is for the rare cases where you want to customize the writer receiving the data frame and writing the data to the communication channel.
}
  \item{server}{
This parameter is only relevant in rare cases where you want to customize the address of the data channel. Per default, the data channel uses the same host and port as the RODBC connection.
}
}
\value{
The function returns the value returned by the writer, which is by default NULL.
}
\author{
EXASOL AG <support@exasol.com>
}

\examples{
require(RODBC)
require(exasol)

# Connect via RODBC with configured DSN
C <- odbcConnect("exasolution")

# Generate example data frame with two groups
# of random values with different means.
valsMean0  <- rnorm(10, 0)
valsMean50 <- rnorm(10, 50)
twogroups <- data.frame(group=rep(1:2, each=10), value=c(valsMean0, valsMean50))

# Write example data to a table
odbcQuery(C, "CREATE SCHEMA test")
odbcQuery(C, "CREATE TABLE test.twogroups (groupid INT, val DOUBLE)")
exa.writeData(C, twogroups, tableName = "test.twogroups")


}
