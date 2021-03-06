
# ----------------------------------------------#
# Structure and map                          ####
# ----------------------------------------------#

#' @title Structure and map occurence table
#' @description Function takes inn a datatable where the columns correspond exactly to the database columns and returns an occurrence dataframe ready to be upserted.
#' @param data Data to be structured.
#' @param conn DB connection with access permission (see \code{natron_connect()}).
#' @param location_table location table (see \code{location_table()}).

#' @return Occurrence data (dataframe) that is ready to be upserted to Natron.

#' @import RPostgreSQL
#' @import dplyr
#'
#' @examples
#' \dontrun{
#' data("setesdal")
#' myConnection <- natron_connect("myUserName")
#' myLocationTable(data = setesdal, conn = myConnection)
#' #map_location(myLocationTable)
#' myOccurences <- str_map_occ(data = setesdal,
#'                             conn = myConnection,
#'                             location_table = myLocationTable)
#' }

#' @export




#-------------------------------------------------#
# structure and map occurrence table ----------####
#-------------------------------------------------#

str_map_occ <- function(data, conn, location_table) {

  tableinfo <- RPostgreSQL::dbGetQuery(conn,
                          "select table_name,column_name,data_type
                        from information_schema.columns
                        where table_name = 'Events' OR
                        table_name = 'Occurrences' OR
                        table_name = 'Locations'
                        ;")


   # select terms for occurrence table
  occurrence_db_terms <- tableinfo$column_name[tableinfo$table_name=="Occurrences"]
  occurrence_terms <- names(data)[names(data) %in% occurrence_db_terms]
  occurrence_terms[length(occurrence_terms)+1] <- "locality"
  occurrence_data_temp <- data[occurrence_terms]


  # create empty dataframe with all event table terms
  occurrence_data <- data.frame(matrix(ncol = length(occurrence_db_terms), nrow = 0))
  colnames(occurrence_data) <- occurrence_db_terms

  # rowbind event data from import to the empty data.frame
  occurrence_data <- bind_rows(occurrence_data,occurrence_data_temp)
  occurrence_data$locationID <- location_table$locationID[match(occurrence_data$locality,location_table$locality)]

  # NOTE! Empty columns turns out as bolean (logical data type).
  # Need to convert these to character before db import
  is_character <- as.character(lapply(occurrence_data,mode))=="logical"
  occurrence_data[is_character] <- lapply(occurrence_data[,is_character], as.character)

  # set modified date to data if not given
  occurrence_data$modified <- as.character(occurrence_data$modified)
  occurrence_data$modified <- ifelse(is.na(occurrence_data$modified),
                                     as.character(Sys.Date()),
                                     occurrence_data$modified)
  # remove locality column
  dplyr::select(occurrence_data,-locality)




  #******************************************************************************
  # Warnings ect:
  cat(
    "
  ************************************************************\n
  The following columns have been transferred to the occurence table\n

    ")

  print(occurrence_terms)


  cat(
    "
  ************************************************************\n
  The following columns have been cut away\nfrom the original dataset to whan making the occurence table.\n")

  print(names(data)[!names(data) %in% occurrence_terms])

  cat(
    "\n
  ***Please check that this is correct.***\n \n
  If you think one of these should be in the occurence table,\n
  then edit that column name in 'data' to match the corresponding \n
  NaTRON column name. The available NaTRON columns for\n
  occurence tables are:\n" )

  print(occurrence_db_terms)



  if(any(duplicated(location_table$locality)))     cat("\n*****\nWarning: the location table has duplicates in the 'locality' column. This NEEDS TO BE UNIQUE. Don't upsert this occurence table as it is now!\n*****")

  if(anyNA(occurrence_data$locationID))    cat("\n*****\nWarning: Not all rows have assigned locationIDs\n*****")

  if(anyNA(occurrence_data$occurenceID))    cat("\n*****\nWarning: Not all rows have assigned occurenceIDs\n*****")

  return(occurrence_data)

}





