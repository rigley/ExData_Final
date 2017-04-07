# rds files must be in the same directory as this script

print("Reading data....")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

tmp <- aggregate(NEI$Emissions, by = list(year = NEI$year), FUN = sum)

#put emissions in millions of tons
tmp$x <- tmp$x / 1000000

png(filename = "./plot1.png", width=480, height=480, units="px")

plot(tmp$year, tmp$x, xlim=c(1998, 2009), ylim = c(0, 10), axes = FALSE, 
     main = "PM2.5 Emissions per Year", xlab = "Year", ylab = "PM2.5 Emissions (millions of tons)", 
     pch = 20, cex  = 2)
axis(1, at = c(1999, 2002, 2005, 2008))
axis(2, at = c(0:10))


dev.off()
print("Output saved at plot1.png")
