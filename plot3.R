# rds files must be in the same directory as this script
library(ggplot2)
library(RColorBrewer)

print("Reading data....")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
myColors <- brewer.pal(4, "Set1")

baltimore_filter <- "24510"

baltimore <- subset(NEI, NEI$fips == baltimore_filter)
tmp <- aggregate(baltimore$Emissions, by = list(year = baltimore$year, type = baltimore$type), FUN = sum)


png(filename = "./plot3.png", width=480, height=480, units="px")

g <- ggplot(tmp, aes(year, x, group = type, color = type))

print(
     g + geom_point(size = 2) + 
          geom_line() + 
          labs(title = "PM2.5 Emissions by Type per Year\nBaltimore City, Maryland") + 
          labs(x = "Year") + 
          labs(y = "PM2.5 Emissions (tons)") +
          theme(plot.title = element_text(hjust = 0.5))  +
          scale_x_continuous(breaks = c(1999, 2002, 2005, 2008))
)

dev.off()
print("Output saved at plot3.png")
