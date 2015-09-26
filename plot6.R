#------------------------------------------------------------------------------
# Programe Name: plot6.R
# Description  : 
#     This programe will download the required file if not already downloaded.
#     By utilizing the subset of the data, plots the graph and saves the graph 
#     as plot6.png
#------------------------------------------------------------------------------  
	# Load required Libraries
	library(plyr)
	library(ggplot2)
	library(grid)
	
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
	
	# Get the types of vehicles available
	MvType <- unique(grep("Vehicles", SCC$EI.Sector, ignore.case = TRUE, value = TRUE))
	# Get the associated data
	MvSource <- SCC[SCC$EI.Sector %in% MvType, ]["SCC"]

	# Subset the data for Baltimore only
	MvBaltimore <- NEI[NEI$SCC %in% MvSource$SCC & NEI$fips == "24510",]
	# Subset the data for Baltimore only
	MvLA <- NEI[NEI$SCC %in% MvSource$SCC & NEI$fips == "06037",]
	# Combine LA & Baltimore data sets
	MvCombine <- rbind(MvBaltimore, MvLA)
	
	# Get the emissions due to motor vehicles in Baltimore and LA County by Year
	MvYRCounty <- aggregate (Emissions ~ fips * year, data =MvCombine, FUN = sum ) 
	MvYRCounty$county <- ifelse(MvYRCounty$fips == "06037", "Los Angeles", "Baltimore")

	# Plot emissions per year using ggplot
	png(filename = "plot6.png", width = 480, height = 480, units = "px")	
	qplot(year, Emissions, data=MvYRCounty, geom="line", color=county) + ggtitle(expression("Motor Vehicle Emission in Los Angeles County and Baltimore")) + xlab("Year") + ylab("Levels of PM2.5 Emissions")
	dev.off()
	cat("plot6.png is saved at ", getwd())
		
	