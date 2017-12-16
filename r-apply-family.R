#read data
#row.names = 1 can subsitute row name as lable
Chicago <- read.csv("Chicago-F.csv", row.names = 1)
NewYork <- read.csv("NewYork-F.csv", row.names = 1)
Houston <- read.csv("Houston-F.csv", row.names = 1)
SanFrancisco <- read.csv("SanFrancisco-F.csv", row.names = 1)
#check
Chicago
NewYork
Houston
SanFrancisco
is.data.frame(Chicago)

#Convert to matrix
Chicago <- as.matrix(Chicago)
NewYork <- as.matrix(NewYork)
Houston <- as.matrix(Houston)
SanFrancisco <- as.matrix(SanFrancisco)
is.matrix(Chicago)

#conbine into one list
Weather <- list(Chicago=Chicago, NewYork =NewYork, Houston =Houston, SanFrancisco=SanFrancisco)
Weather$SanFrancisco

#Apply family
#apply(M, 1, mean) 1 --> row
#apply(M, 1, mean) 2 --> column

#Using apply function
apply(Chicago, 1, mean)
#check:
mean(Chicago["DaysWithPrecip", ])
apply(Chicago, 1, max)
apply(Chicago, 1, min)

apply(Chicago, 2, max)#doesn;t make much sense, byt good exercise
apply(Chicago, 2, min)

#compare
apply(Chicago, 1, mean)
apply(Houston, 1, mean)
apply(SanFrancisco, 1, mean)
apply(NewYork, 1, mean)


#Recreating the apply function with loops(advanced topic)
#find the mean of every row:
#1. via loops
output<- NULL
for(i in 1:5){
  output[i] <-mean(Chicago[i,])
}
output
typeof(output)
names(output) <- rownames(Chicago)
output

#2. via apply function
apply(Chicago, 1, mean)


#Using lapply()
Chicago
t(Chicago)
lapply(Weather, t) #list(t(Weather$Chicago), t(Weather$NewYorrk), t(Weather$Houston), t(Weather$SanFrancisco))

rbind(Chicago, NewRow=1:12)
lapply(Weather, rbind, NewRow=1:12)
rowMeans(Chicago)
lapply(Weather, rowMeans)
#rowMeans
#rowSums
#colMeans
#colSums

#Combining lapply with the [] operator
Weather[[1]][1,1]
lapply(Weather, "[", 1,1)
lapply(Weather, "[", 1,)
lapply(Weather, "[", , 3)

#Adding functions
lapply(Weather, rowMeans)
lapply(Weather, function(x)x[1,])
lapply(Weather, function(x)x[5,])
lapply(Weather, function(x)x[,12])
lapply(Weather, function(z) z[1,]-z[2,])
lapply(Weather, function(z) round((z[1,]-z[2,])/z[2,],2))


#Using sapply()
#AvgHigh_F for July
lapply(Weather, "[", 1, 7)
sapply(Weather, "[", 1, 7)

lapply(Weather, "[", 1, 10:12)
sapply(Weather, "[", 1, 10:12))

lapply(Weather, rowMeans)
sapply(Weather, rowMeans)
round(sapply(Weather, rowMeans),2)

lapply(Weather, function(z) round((z[1,]-z[2,])/z[2,],2))
sapply(Weather, function(z) round((z[1,]-z[2,])/z[2,],2))

sapply(Weather, rowMeans, simplify = FALSE)#Same as lapply


#Nesting Apply Functions
lapply(Weather, rowMeans)
apply(Chicago, 1, max)
#apply across whole list
lapply(Weather, apply, 1, max) #preferred approach
lapply(Weather, function(x)apply(x, 1, max))


sapply(Weather, apply, 1, max) #preferred approach
sapply(Weather, function(x)apply(x, 1, max))

#Very advanced tutorial!
#which.max
#for list and return the name of the list
which.max(Chicago[1,])
names(which.max(Chicago[1,]))
apply(Chicago, 1, function(x)names(which.max(x)))
#complicated
lapply(Weather, function(x)apply(x, 1, function(x)names(which.max(x))))
sapply(Weather, function(x)apply(x, 1, function(x)names(which.max(x))))
