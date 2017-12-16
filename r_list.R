#Deliverable - a list with the following components:
#Character: Machine name
#Vector: (min, mean, max)Utilization fro the month(excluding unknown hours)
#Logical: Has utilization ever fallen below 90%? TRUE/FALSE
#VectorL All hours where utilization is unknown(NA's)
#Dataframe: For this machine
#PlotL For all machines

util <- read.csv("Machine-Utilization.csv")
str(util)
summary(util)
#Derive utilizaiton column
util$Utilization = 1 - util$Percent.Idle
head(util, 10)


#Handleing Data-Times in R
?POSIXct
util$PosixTime <- as.POSIXct(util$Timestamp, format = "%d/%m/%Y %H:%M")
head(util,12)
#TIP: how to rearrange columns in a df
util$Timestamp <- NULL
head(util, 12)
util <- util[,c(4,1,2,3)]
head(util)


#What is a list
#sbuset
RL1 <- util[util$Machine == "RL1",]
3

#Construct list
util_stats_rl1 <- c(min(RL1$Utilization,na.rm = T),
                    mean(RL1$Utilization, na.rm = T),
                    max(RL1$Utilization, na.rm = T))
util_stats_rl1
RL1$Utilization < 0.90
which(RL1$Utilization < 0.90)
length(which(RL1$Utilization < 0.90))
util_under_90_flag <- length(which(RL1$Utilization < 0.90)) >0
list_rl1 <- list("RL1", util_stats_rl1, util_under_90_flag)
list_rl1
rm(util_under_90)

names(list_rl1) <- c("Machine", "Stats", "Threshold")
list_rl1
rm(list_rl1)
#another way
list_rl1 <- list(Machine = "RL1", Stats = util_stats_rl1, LowTHreshold = util_under_90_flag)
list_rl1
#extracting components of a list
#three ways
#[] - will always return a list
#[[]] - will always return the actual object
#$ - same as [[]] but prettier
list_rl1
list_rl1[1]
list_rl1[[1]]
list_rl1$Machine


list_rl1[2]
typeof(list_rl1[2])
typeof(list_rl1[[2]])
list_rl1$Stats
#how to access the 3rd elements of the vector (max utilization)?
list_rl1[[2]][3]


list_rl1[3]
list_rl1[[3]]
list_rl1[[3]][1]
list_rl1$LowTHreshold
list_rl1$LowTHreshold[1]


#Adding and deleting list componets
list_rl1
list_rl1[4] <- "New Information"
#Vector: All hours where uti"lization is unknown (NA's)
list_rl1$UnknownHours <- RL1[is.na(RL1$Utilization), "PosixTime"]

RL1[is.na(RL1$Utilization), "PosixTime"]
list_rl1


#Remove a component. Use the NULL method:
list_rl1[4] <- NULL
list_rl1
#UnknownHours becomes the 4th element

#Add another component:
#Dataframe: FOr this machine
list_rl1$Data <- RL1
summary(RL1)
summary(list_rl1)
str(list_rl1)

#subset list
list_rl1[1:2]
list_rl1[c(1,4)]
#Pay attention to single square bracket
#double square brackets are NOT for subsetting


#Building a timeseries plt
#facet
#geom_line
library(ggplot2)
p <- ggplot(data = util)
myplot <- p + geom_line(aes(x=PosixTime, y = Utilization, color=Machine), size =0.5) + 
  facet_grid(Machine~.) +
  geom_hline(yintercept = 0.90,
            color = "black", size = 1.2,
            linetype=4)
#save a plot to a list
list_rl1$plot <- myplot
list_rl1
#get plot information in a plot
str(list_rl1)
