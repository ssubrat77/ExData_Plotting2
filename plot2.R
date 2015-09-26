#------------------------------------------------------------------------------
# Programe Name: plot2.R
# Description  : 
#     This programe will download the required file if not already downloaded.
#     By utilizing the subset of the data, plots the graph and saves the graph 
#     as plot2.png
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

	#Plot2
	MarylandData <- NEI[which(NEI$fips == "24510"),]
	# Calculate the sum of Emissions by year
	TotEmissions <- with(MarylandData, aggregate(Emissions, by = list(year), sum))
	colnames(TotEmissions) <- c("Year", "Emissions")	
	# Plot the graph using base plot
	png(filename = "plot2.png", width = 480, height = 480, units = "px")
	plot(TotEmissions$Year, TotEmissions$Emissions, type = "b", col = "green", ylab = "Emissions", xlab = "Year", main = "Baltimore Emissions By Year")
	dev.off()
	cat("plot2.png is saved at ", getwd())
	