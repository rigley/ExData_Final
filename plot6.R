# rds files must be in the same directory as this script

print("Reading data....")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

baltimore_filter <- "24510"
la_filter <- "06037"
filter_list <- c(baltimore_filter, la_filter)

cities <- subset(NEI, NEI$fips %in% filter_list)
tmp <- aggregate(cities$Emissions, by = list(year = cities$year, fips = cities$fips), FUN = sum)


png(filename = "./plot6.png", width=480, height=480, units="px")

axis_labels <- pretty(1:50000, 5)
axis_lable_names <- pretty(1:50000, 5)
g <- ggplot(tmp, aes(year, x, group = fips, color = factor(fips, labels = c("Baltimore City, MD", "Los Angeles County, CA"))))


print(
     g + geom_point(size = 2) + 
          geom_line() + 
          labs(title = "PM2.5 Motor Vehicle Emissions\nBaltimore City, MD compared to Los Angeles County, CA") + 
          labs(x = "Year") + 
          labs(y = "PM2.5 Motor Vehicle Emissions (tons)") +
          labs(color = "Source") + 
          theme(plot.title = element_text(hjust = 0.5))  +
          scale_x_continuous(breaks = c(1999, 2002, 2005, 2008)) + 
          scale_y_continuous(limits = c(0, 50000), breaks = axis_labels, labels = scales::comma) 
)


dev.off()
print("Output saved at plot2.png")
