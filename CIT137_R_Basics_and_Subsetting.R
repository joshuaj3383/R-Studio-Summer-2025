# This code removes all of the data in memory 
rm(list=ls())

# Store the value of 15 into the object x
x <- 15

# This is just a comment, where text is appended with the "#" character.  


###########################################################################
# Libraries and Packages
#
# to install a package, use the install.packages() function.  This will install "dplyr" on your local hard drive
install.packages("dplyr")

# to make a library accessible by R, you need to turn it on. You can do this with library() or require()
# We will now turn on dplyr which will allow the function in the library to be used
library("dplyr")

# the ? modifier searches local libraries for the functions.  In this case filter is in two libraries
?filter

# so which function is used?  The last library loaded.  If you notice in your R console, there is a line
# The following objects are masked from 'package:stats': filter, lag
# this means filter from the dplyr library will be used.  If you want to use filter from the stats library, 
# you can use filter::stats() the double colon tells R to load the function from that specific library.
###########################################################################



###########################################################################
# 5 Different types of atomic classes

w <- "This is a character vector"
x <- "12"
class(w)
class(x)

# This is a numeric vector
y <- 24L
class(y)

# An Integer
z <- 13L
class(z)

# A complex
comp <- 3 + 5i
class(comp)

# A boolean
bool <-  TRUE
class(bool)
###########################################################################



###########################################################################
# coercion
# R has something called "coercion" which coerces the data into the lowest common field

# What do you think will happen?  We have three different data types.
x <-  c(5, TRUE, "Hello")
class(x)

# How about here?
x <-  c(5, TRUE, FALSE)
class(x)

# Here?
x <-  c(TRUE, "Hello")

# Notice how R changes the data into the lowest common field? 
###########################################################################




# args() gives a list of the input arguments for a function (you can also hover with cursor over name)
args(lm)

###########################################################################
# Mathematical Functions
#
# Lets look at math functions
w <- 2.5
w <- 2/3
w

# Note exp() is the natural exponential or "e" it is not to the power of
exp(1)

# log() is the natural logaritm "ln", it is not the log
log(exp(1))
log(100)

# to get the log base 10, you use:
log10(100)

# for log base2 you use
log2(64)

# Square root
sqrt(144)

# Absolute Value
abs(-15)


# Rounding Functions
round(22.500000001)
floor(23.9)
floor(-23.9)
ceiling(-23.9)

# For pi, it isn't a function, but a declared constant in R
pi()
pi

# There are a few build in constants in R
LETTERS
letters
month.abb
month.name
pi

# store sequential numbers
x <- c(1:20)
y <- seq(0,20,2)
###########################################################################



###########################################################################
# Conditionals
# Give a true or false value
#
x
x==15
x>15
x!=15
5<7 & 6>9
5<7 | 6>9
new_var <- x<5 | x >15
x[x<5 | x >15]
x[new_var]
###########################################################################


###########################################################################
# Building data structures
# 

# build a matrix
y <- matrix(1:20, nrow=4, ncol=5)
y

# build it by column instead of row
z <- matrix(1:20, nrow=4, ncol=5, byrow = TRUE)
z

# create a vector of names for both rows and columns
rnames <- c("r1", "r2", "r3", "r4")
cnames <- c("r1", "r2", "r3", "r4", "r5")

# use the vectors to give the rows and columns a name
zz <- matrix(1:20, nrow=4, ncol=5, byrow = TRUE, dimnames = list(rnames, cnames))
zz
rownames(zz)
class(zz)

# Build a data frame
d <- c(1,2,3,4)
e <- c("red", "blue", "green", NA)
f <- c(T, T, F, T)
mydata <- data.frame(d, e, f)
class(mydata)
###########################################################################


###########################################################################
# Subsetting data
#
# run this line of code to import the chicago dataset.

chi<- read.csv("https://sites.google.com/site/cit137sp17/week3/chicago-nmmaps.csv")

# examing the structure of the data
str(chi)

# To get the average temperature
mean(chi$temp)

# to get the minimun temperature
min(chi$temp)

# find the maximum death count from the dataset
max(chi$death)

# Note, which.max(data column) gives you the INDEX number (row) where the data element occurs.  You can use this 
# row to get other data such as the date when the max temp occured
which.max(chi$death)
chi[which.max(chi$death),]

# You can create a new dataset by slicing the existing set.
chi_NA <- chi[is.na(chi$pm10),]

# getting winter data which only have NAs.  
chi_NA_winter <- chi[is.na(chi$pm10)&chi$season=="winter",]

# you can save the opposite with the NOT operator ("!")
chi_complete <- chi[!is.na(chi$pm10),]

# You can also extract the seasons and date when the NA objects appeared
chi_NA_season <- chi[is.na(chi$pm10),c('date','season')]

###########################################################################

