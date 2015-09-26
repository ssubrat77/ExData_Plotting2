#------------------------------------------------------------------------------
# Programe Name: plot4.R
# Description  : 
#     This programe will download the required file if not already downloaded.
#     By utilizing the subset of the data, plots the graph and saves the graph 
#     as plot4.png
#------------------------------------------------------------------------------  
	# Load required Libraries
	library(plyr)
	library(ggplot2)
	
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
	
	# Get coal combustion related sources from SCC.Level.Three variable
	CoalSCC.NEI <- NEI[NEI$SCC %in% SCC[grep("Coal", SCC$EI.Sector), 1], ]
	CoalSCC.NEI1 <- SCC[, c(1, 4)]
	CoalData <- merge(CoalSCC.NEI, CoalSCC.NEI1, by.x = "SCC", by.y = "SCC")[, c(4, 6, 7)]
	# Plot coal Combustion emissions per year using ggplot
	png(filename = "plot4.png", width = 800, height = 700, units = "px")	
	g1 <- ggplot(CoalData, aes(x = year, y = Emissions))
	g1 + geom_point(aes(color = EI.Sector), size = 10, alpha = 0.3) + facet_grid(. ~ EI.Sector) + geom_smooth(size = 2, color = "black", linetype = 1, method = "lm", se = FALSE)
	dev.off()
	cat("plot4.png is saved at ", getwd())
	
	
	