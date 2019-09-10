# Run through example

#*************************
devtools::load_all(".")
#*************************
?natronbatchupload


?setesdal
#*************************
data("setesdal")
#*************************


?natron_connect
#*************************
conn <- natron_connect("AndersK")
#*************************


?location_table
#*************************
myLocTab <- location_table(data = setesdal, conn)
#*************************



anyDuplicated(myLocTab$decimalLatitude)
anyDuplicated(myLocTab$decimalLongitude)
# and they are all unique.
# there is a warning if they are are missing or they are not numeric:
myLocTab2 <- setesdal
myLocTab3 <- setesdal
myLocTab4 <- setesdal
myLocTab5 <- setesdal

myLocTab2$decimalLatitude[5] <- NA
myLocTab3$decimalLongitude[8] <- NA
myLocTab4$decimalLatitude[4] <- "This is text"
myLocTab5$decimalLongitude[50] <- "This is text"

test <- location_table(data = myLocTab2, conn)
test <- location_table(data = myLocTab3, conn)
test <- location_table(data = myLocTab4, conn)
test <- location_table(data = myLocTab5, conn)




# 'locality' must be unique because thats how we get the locationID from the locationTable to the other tables.
anyDuplicated(myLocTab$locality)
# add warning to location_table() ********************
myLocTab6 <- setesdal
myLocTab6$locality[1] <- myLocTab6$locality[2]
any(duplicated(myLocTab6$locality))
test <- location_table(data = myLocTab6, conn)
rm(myLocTab2, myLocTab3, myLocTab4, myLocTab5, myLocTab6, test)




?radius_scan
#*************************
scan <- radius_scan(locationTable = myLocTab, conn, radius = 8000)
#*************************


?map_locations
#*************************
map_locations(data = myLocTab)
map_locations(data = myLocTab, compare = scan)
map_locations(data = myLocTab, compare = scan, vertical = T)
#*************************



decimalLatitude <- c(59.02936, 59.03352, 59.04758)
decimalLongitude <- c(7.278987, 7.267469, 7.184718)
myData <- data.frame(decimalLatitude, decimalLongitude)
map_locations(data = myData)
map_locations(data = myData, vertical = T)


decimalLatitude2 <- c(59.03347)
decimalLongitude2 <- c(7.268134)
myData2 <- data.frame(decimalLatitude = decimalLatitude2,decimalLongitude = decimalLongitude2)

map_locations(data = myData, compare = myData2)



?upsert_locations
#*************************
upsert_locations(location_data = myLocTab, conn = conn)
#*************************
# NOT WORKING



?str_map_events
#*************************
myEvents <- str_map_events(data = setesdal, conn = conn, location_table = myLocTab)
#*************************

myLocTab2 <- myLocTab
myLocTab2$locality[1] <- myLocTab2$locality[2]
any(duplicated(myLocTab2$locality))
# this should give a warning:
myEvents2 <- str_map_events(data = setesdal, conn = conn, location_table = myLocTab2)



?upsert_event
#*************************
upsert_events(data = myEvents, conn = conn)
#*************************

?str_map_occ
#*************************
myOccurence <- str_map_occ(data = setesdal, conn = conn, location_table = myLocTab)
#*************************
setesdal2 <- setesdal
colnames(setesdal2)[colnames(setesdal2) == "scientificName"] <- "organimsName"
myOccurence <- str_map_occ(data = setesdal, conn = conn, location_table = myLocTab)



#*************************
?upsert_occ
upsert_occ(myOccurence, conn)

