fin <- read.csv("Future-500.csv", na.strings = c(""))
finT <- fin
summary(fin)
head(fin)
tail(fin)
str(fin)
colnames(fin)



fin$ID <- factor(fin$ID)
summary(fin$ID)

fin$Inception <- factor(fin$Inception)
str(fin)


#Factor Variable Trap
#Converting into Numeric for Characters
a <- c("12", "13", "14")
a
typeof(a)
b <- as.numeric(a)
typeof(b)
z <- factor(a)
z

as.numeric(as.character(z))

#FVT example
#integer to factor
fin$Profit <- factor(fin$Profit)
str(fin)
summary(fin)
fin$Profit <- as.numeric(as.character(fin$Profit))
str(fin)


#sub and gsub()
fin$Expenses <- gsub("Dollars", "", fin$Expenses)
fin$Expenses <- gsub(",", "", fin$Expenses)
head(fin)
str(fin)

#pay attention to $ sign, needed escape
fin$Revenue <- gsub("\\$", "", fin$Revenue)
fin$Revenue <- gsub(",", "", fin$Revenue)
head(fin)

#Growth
fin$Growth <- gsub("%", "", fin$Growth)
head(fin)
str(fin)


fin$Revenue <- as.numeric(fin$Revenue)
fin$Expenses <- as.numeric(fin$Expenses)
fin$Growth <- as.numeric(fin$Growth)

str(fin)
summary(fin)

fin.na <- sort(sapply(fin, function(x){sum(is.na(x))}), decreasing = T)
fin.na

#what is NA
TRUE == TRUE
FALSE == TRUE
NA == NA
NA== FALSE


#locate missing value
#check is there NA in one row
complete.cases(fin)
#subseting
fin[!complete.cases(fin),]
#why some missing value is empty?
#one way to impute string empty as NA
fin <- read.csv("Future-500.csv", na.strings = c("") )

#power of which
#which() can filter missing value
head(fin)
fin[fin$Revenue == 9746272,]#without which(), we find NA in the result
#which can filter NA
fin[which(fin$Revenue == 9746272),]#with which(), we find no NA appear in the result


#is.na
head(fin,24)
fin[is.na(fin$Revenue)==T,]
sum(is.na(fin$Expenses))


#removing records with missing data
fin[!complete.cases(fin),]
fin[is.na(fin$Industry),]
fin[!is.na(fin$Industry),]#subseting and opposite logic
fin <- fin[!is.na(fin$Industry),]
head(fin, 24)

#resetting row index names of dataframe
rownames(fin) <- c(1:498)
rownames(fin) <- c(3:500)
rownames(fin) <- NULL
rownames(fin)



#replacing missing data: factual analysis method
fin[!complete.cases(fin),]
head(fin,24)
fin[is.na(fin$State) & fin$City =="New York", "State"] <- "NY"
#check
fin[is.na(fin$State) & fin$City =="New York", ]
fin[is.na(fin$State) & fin$City =="San Francisco", "State"] <- "CA"
#check
fin[is.na(fin$State) & fin$City =="San Francisco",]


#impute missing value using mean and median 
#impute by similar information using domain knowledge
med_empl_retail <- median(fin[ fin$Industry == "Retail","Employees"], na.rm = T)
fin[is.na(fin$Employees) & fin$Industry == "Retail","Employees"] <- med_empl_retail


#industry -- Financial Services
#pay attention to capital
mean(fin[fin$Industry == "Financial Services", "Employees"], na.rm = T)
med_empl_finserv <- median(fin[fin$Industry == "Financial Services", "Employees"], na.rm = T)
fin[is.na(fin$Employees) & fin$Industry =="Financial Services", "Employees"] <- med_empl_finserv
fin[!complete.cases(fin), ]

med_growth_constr <- median(fin[fin$Industry == "Construction", "Growth"], na.rm =T)
fin[is.na(fin$Growth) & fin$Industry == "Construction", "Growth"] <- med_growth_constr

med_rev_constr <- median(fin[fin$Industry == "Construction", "Revenue"], na.rm = T)
fin[is.na(fin$Revenue) & fin$Industry == "Construction", "Revenue"] <- med_rev_constr 
#check
fin[!complete.cases(fin), ]



#impute expense but do not touch profit is not empty
med_exp_constr <- mean(fin[fin$Industry == "Construction", "Expenses"], na.rm =T)
fin[is.na(fin$Expenses) & fin$Industry == "Construction"  & is.na(fin$Profit),"Expenses"] <-med_exp_constr


#Pay attention to the relationship between variable
#Replacing Missing Data: deriving values
#Revenue - Expenses = Profit
#Expenses = Revenue - Profit
#impute profit
fin[is.na(fin$Profit), "Profit"] <- fin[is.na(fin$Profit), "Revenue"] - fin[is.na(fin$Profit), "Expenses"]
#impute expenses
fin[is.na(fin$Expenses), "Expenses"] <- fin[is.na(fin$Expenses), "Revenue"] - fin[is.na(fin$Expenses), "Profit"]

#visualization
library(ggplot2)
qplot(data = fin, x = Inception)
qplot(data = fin, x = Industry)
plot(density(fin$Employees))

#A scatterplot classified by industry showing revenue, expenses, profit
p <- ggplot(data=fin)
p+geom_point(aes(x=Revenue, y=Expenses, color=Industry, size=Profit))

#A scatterplot that includes industry trends for the expenses
d <- ggplot(data=fin, aes(x=Revenue, y=Expenses, color=Industry))
d +geom_point() + geom_smooth(fill=NA, size=1)

#boxplot
f <- ggplot(data=fin, aes(x=Industry, y=Growth, color=Industry))
f+geom_boxplot(size =1)

#Extra:
f+geom_jitter() +geom_boxplot(size = 1, alpha = 0.5, outlier.color = NA)

