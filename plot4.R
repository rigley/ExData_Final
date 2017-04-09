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
coal_sectors_indx <- grep("*Coal *", sectors)
coal_sectors <- sectors[coal_sectors_indx]
coal_codes <- SCC %>% filter(EI.Sector %in% coal_sectors) %>% select(SCC)
coal_emissions <- filter(NEI, SCC %in% coal_codes$SCC)
coal_emissions <- coal_emissions %>% left_join(small_scc, by = c("SCC"))


tmp <- aggregate(coal_emissions$Emissions, 
                 by = list(year = coal_emissions$year, Source = coal_emissions$EI.Sector),
                 FUN = sum)



#make chart
png(filename = "./plot4.png", width=480, height=480, units="px")

axis_labels <- c(0, 150000, 300000, 450000, 600000)
axis_lable_names <- c("0", "150,000", "300,000", "450,000", "600,000")
g <- ggplot(tmp, aes(year, x, group = Source, color = Source))


print(
     g + geom_point(size = 2) + 
          geom_line() + 
          labs(title = "PM2.5 Coal Emissions per Year by Source") + 
          labs(x = "Year") + 
          labs(y = "PM2.5 Coal Emissions (tons)") +
          theme(plot.title = element_text(hjust = 0.5))  +
          theme(legend.position = "bottom", legend.direction = "vertical") + 
          scale_x_continuous(breaks = c(1999, 2002, 2005, 2008)) + 
          scale_y_continuous(limits = c(0, 600000), breaks = axis_labels, labels = axis_lable_names)
)

dev.off()
print("Output saved at plot4.png")
