#------------------------------------------------------------------------------
# Programe Name: plot5.R
# Description  : 
#     This programe will download the required file if not already downloaded.
#     By utilizing the subset of the data, plots the graph and saves the graph 
#     as plot5.png
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
	
	# Get the types of vehicles available
	MvType <- unique(grep("Vehicles", SCC$EI.Sector, ignore.case = TRUE, value = TRUE))
	# Get the associated data
	MvSource <- SCC[SCC$EI.Sector %in% MvType, ]["SCC"]

	# Subset the data for Baltimore only
	MvBaltimore <- NEI[NEI$SCC %in% MvSource$SCC & NEI$fips == "24510",]

	# Get the emissions by motor vehicles in Baltimore by Year
	MvEmissions <- ddply(MvBaltimore, .(year), function(x) sum(x$Emissions))
	colnames(MvEmissions)[2] <- "Emissions"

	# Plot coal Combustion emissions per year using ggplot
	png(filename = "plot5.png", width = 480, height = 480, units = "px")	
	qplot(year, Emissions, data=MvEmissions, geom="line") + ggtitle("Baltimore PM2.5 Motor Vehicle Emissions by Year") + xlab("Year") + ylab("Total PM2.5 Emissions")
	dev.off()
	cat("plot5.png is saved at ", getwd())
		
	