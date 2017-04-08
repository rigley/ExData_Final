# rds files must be in the same directory as this script
library(ggplot2)
library(dplyr)
library(RColorBrewer)

print("Reading data....")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
myColors <- brewer.pal(4, "Set1")


# get coal codes
sectors <- unique(SCC$EI.Sector)
mobile_sectors_indx <- grep("*Mobile - On-Road *", sectors)
mobile_sectors <- sectors[mobile_sectors_indx]
mobile_codes <- SCC %>% filter(EI.Sector %in% mobile_sectors) %>% select(SCC)
mobile_emissions <- filter(NEI, SCC %in% mobile_codes$SCC)

tmp <- aggregate(mobile_emissions$Emissions, 
                 by = list(year = mobile_emissions$year, type = mobile_emissions$type),
                 FUN = sum)



#make chart
png(filename = "./plot5.png", width=480, height=480, units="px")

axis_labels <- c(0, 150000, 300000, 450000, 600000)
axis_lable_names <- c("0", "150,000", "300,000", "450,000", "600,000")
g <- ggplot(tmp, aes(year, x, group = type, color = type))


print(
     g + geom_point(size = 2) + 
          geom_line() + 
          labs(title = "PM2.5 Motor Vehicle Emissions per Year") + 
          labs(x = "Year") + 
          labs(y = "PM2.5 Motor Vehicle Emissions (tons)") +
          theme(plot.title = element_text(hjust = 0.5))  +
          scale_x_continuous(breaks = c(1999, 2002, 2005, 2008)) + 
          scale_y_continuous(limits = c(0, 600000), breaks = axis_labels, labels = axis_lable_names)
)

dev.off()
print("Output saved at plot5.png")
