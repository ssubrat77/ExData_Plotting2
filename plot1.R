#------------------------------------------------------------------------------
# Programe Name: plot1.R
# Description  : 
#     This programe will download the required file if not already downloaded.
#     By utilizing the subset of the data, plots the graph and saves the graph 
#     as plot1.png
#------------------------------------------------------------------------------
	# Load required Libraries
	library(plyr)	
	
	# Download the data file if not yet downloaded & Unzip it	  
	if(!file.exists("exdata-data-NEI_data.zip")) {
		fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
		download.file(fileUrl,destfile="exdata-data-NEI_data.zip")
		unzip(zipfile="./exdata-data-NEI_data.zip")
	} else {
		unzip(zipfile="./exdata-data-NEI_data.zip")
	}
		
	# Load the data set
	NEI <- readRDS("summarySCC_PM25.rds")
	SCC <- readRDS("Source_Classification_Code.rds")
	
	# Calculate the sum of Emissions by year
	TotEmissions <- c(sum(NEI$Emissions[which(NEI$year == 1999)]),sum(NEI$Emissions[which(NEI$year == 2002)]),sum(NEI$Emissions[which(NEI$year == 2005)]),sum(NEI$Emissions[which(NEI$year == 2008)]))
	Years <- as.factor(unique(NEI$year))
	DataDF <- data.frame(TotalEmissions = TotEmissions, Years)
	# Plot the graph using base plot
	png(filename = "plot1.png", width = 480, height = 480, units = "px")
	plot(DataDF, type = "b", col = "Blue", ylab = "TotalEmissions", xlab = "Years", main = "Total PM2.5 emissions by Year")
	dev.off()
	cat("plot1.png is saved at ", getwd())
	