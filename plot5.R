# rds files must be in the same directory as this script
library(ggplot2)
library(dplyr)
library(RColorBrewer)

print("Reading data....")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
myColors <- brewer.pal(4, "Set1")


# get coal codes
small_scc <- select(SCC, SCC, EI.Sector)
sectors <- unique(SCC$EI.Sector)
mobile_sectors_indx <- grep("*Mobile - On-Road *", sectors)
mobile_sectors <- sectors[mobile_sectors_indx]
mobile_codes <- SCC %>% filter(EI.Sector %in% mobile_sectors) %>% select(SCC)
mobile_emissions <- filter(NEI, SCC %in% mobile_codes$SCC)
mobile_emissions <- mobile_emissions %>% left_join(small_scc, by = c("SCC"))

tmp <- aggregate(mobile_emissions$Emissions, 
                 by = list(year = mobile_emissions$year, Source = mobile_emissions$EI.Sector),
                 FUN = sum)



#make chart
png(filename = "./plot5.png", width=480, height=480, units="px")


axis_labels <- pretty(1:150000, 7)
axis_lable_names <- pretty(1:150000, 7)

g <- ggplot(tmp, aes(year, x, group = Source, color = Source))


print(
     g + geom_point(size = 2) + 
          geom_line() + 
          labs(title = "PM2.5 Motor Vehicle Emissions per Year") + 
          labs(x = "Year") + 
          labs(y = "PM2.5 Motor Vehicle Emissions (tons)") +
          theme(plot.title = element_text(hjust = 0.5))  +
          theme(legend.position = "bottom", legend.direction = "vertical") + 
          scale_x_continuous(breaks = c(1999, 2002, 2005, 2008)) + 
          scale_y_continuous(limits = c(0, 175000), breaks = axis_labels, labels = scales::comma)
)

dev.off()
print("Output saved at plot5.png")
