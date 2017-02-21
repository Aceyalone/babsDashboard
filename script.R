library(plyr)
library(reshape2)
library(tidyr)

dat <- read.csv(file = 'data/201508_trip_data.csv', stringsAsFactors = FALSE)
names(dat) <- c("id", "dur", "bDate","bStation", "bTerm", "eDate", "eStation", "eTerm", "bike", "subType", "zip")
lu <- read.csv(file = 'data/201508_station_data.csv', stringsAsFactors = FALSE)
names(lu)[2] <- "bStation"
lu$bStation[lu$bStation == "Post at Kearney"] <- "Post at Kearny"
dat <- join(dat, lu, by = "bStation", type = "left")

dat <- subset(dat, dat$landmark == "San Francisco")


res <- aggregate(!is.na(id) ~ bStation + eStation, sum, data = dat)
names(res)[3] <- "count"
new <- spread(res, bStation, count)

rownames(new) <- new[,1]
new <- new[,-1]
new[is.na(new)] <- 0

d3heatmap(new, scale = "column")
