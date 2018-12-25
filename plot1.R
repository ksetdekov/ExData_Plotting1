if(!file.exists("./data/power.zip"))
{
        dir.create("./data")
        fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl,destfile = "./data/power.zip")   
        dateDownloaded<-date()  
}


unzip("./data/power.zip",exdir="./data")

library(readr)
power <- read_delim("data/household_power_consumption.txt", 
                    ";", escape_double = FALSE, col_types = cols(Time = col_time(format = "%H:%M:%S")), 
                    na = "?", trim_ws = TRUE)
head(power)

power2 <- na.omit(power)
power2$Timen <- as.numeric(power2$Time)
#power2 <- power2[1:100000,]
library(party)
 cfit3<-ctree(Voltage~Global_intensity,data=power2)
plot(cfit3)

power2$prederuptions <- predict(cfit3, power2)
library(InformationValue)
library(MLmetrics)
#plotROC(faithful$eruptions, faithful$prederuptions)
Gini(power2$prederuptions , power2$Voltage)
