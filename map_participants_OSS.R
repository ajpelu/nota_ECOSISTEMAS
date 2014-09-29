# Title: Maps of Participants at OSS2014
# authors: AJ P??rez-Luque (@ajpelu) and S. Varela
# date: sep 2014 

# Create map of participant at OSS2014 based in the idea of T. Assal

# set directory 
di  <- '/Users/ajpelu/Dropbox/MS/nota_ECOSISTEMAS'

# load library
library('ggmap')
library('ggplot2')
library('grid')

# read table 
mydata <- read.csv(paste(di,'/data/participants.csv', sep=''),header=T, sep=';')

# Create a name with city and Country 
mydata$location <- paste(mydata$city, mydata$country, sep=', ')

# Get coordinates from Google Maps API (see geocode function)
mydata$long <- geocode(mydata$location)[,1]
mydata$lat <- geocode(mydata$location)[,2]

# Aggregate by city
mycities <- aggregate(mydata$city, by=list(mydata$city, mydata$country, mydata$lat, 
                                           mydata$long, mydata$center),
                      FUN = length)
names(mycities) <- c('city','country','lat','long','center','count')

# Plot a map of Participantes 
# colour world map 
micolor <- 'gray80'
color.nceas <- '#41ab5d'
color.renci <- '#d7301f'

# Get a world map
wm <- map_data('world')

p <- ggplot() + geom_polygon(data=wm, aes(x=long, y=lat, group=group), fill=micolor)
p1 <- p + geom_point(data=mycities,aes(x=long, y=lat, size=factor(count), shape=center, color=center)) + 
  scale_shape_manual(name='Center', values=c(15,16))+ 
  scale_size_manual(values=c(3,4,5), guide=FALSE)+ 
  scale_colour_manual(name='Center', values=c(color.nceas,color.renci))+
  theme_bw() + theme(panel.grid.major=element_blank(), 
                     panel.grid.minor.y = element_blank(),
                     legend.key.size = unit(1.2, "cm"),
                     legend.key=element_blank())+
  guides(colour = guide_legend(override.aes = list(size=5))) # To increase the size of points in legend
p1
