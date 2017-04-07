# rds files must be in the same directory as this script

print("Reading data....")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

baltimore_filter <- "24510"

baltimore <- subset(NEI, NEI$fips == baltimore_filter)
tmp <- aggregate(baltimore$Emissions, by = list(year = baltimore$year), FUN = sum)


png(filename = "./plot2.png", width=480, height=480, units="px")

plot(tmp$year, tmp$x, xlim=c(1998, 2009), ylim = c(0, 5000), xaxt="n", 
     main = "PM2.5 Emissions per Year\nBaltimore City, Maryland", 
     xlab = "Year", ylab = "PM2.5 Emissions (tons)", 
     pch = 20, cex  = 2)
axis(1, at = c(1999, 2002, 2005, 2008))


dev.off()
print("Output saved at plot2.png")
