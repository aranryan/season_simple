
library(stringr)
library(plyr) #Hadley said if you load plyr first it should be fine
library(dplyr)
library(reshape2)
library(ggplot2)
#library(zoo)
library(xts)
library(lubridate)
#library(forecast) # added so I could use monthdays() which also works for quarters
library(seasonal)
Sys.setenv(X13_PATH = "C:/Aran Installed/x13as")
checkX13()


########
#
# load data
#

# setting up the cl object, which is character for the date column (3), then three columns of integers (4), then another character
# and then the three numeric columns
cl <- c("NULL", "numeric", "character", "integer")[c(3, 4, 4, 4, 3, 2, 2, 2)] # rep(2,3))]
# access the file using a relative path
m_input <- read.zoo("input_data/m_input.csv", 
                    format = "%m/%d/%Y", header = TRUE, sep=",", colClasses=cl, index.column = 1, na.strings="N/A") 
# I was getting an error message saying "expected a real", I had to format the number columns as number in Excel to fix it
m_input <- as.xts(m_input)

rm(cl)
