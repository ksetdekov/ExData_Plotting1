#download if missing
if (!file.exists("./data/household_power_consumption.txt"))
{
        dir.create("./data")
        fileUrl <-
                "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl, destfile = "./data/power.zip")
        dateDownloaded <- date()
        unzip("./data/power.zip", exdir = "./data")
}


#read
library(readr)
power <- read_delim(
        "data/household_power_consumption.txt",
        ";",
        escape_double = FALSE,
        col_types = cols(Time = col_time(format = "%H:%M:%S")),
        na = "?",
        trim_ws = TRUE
)
# format and select days
head(power)
power$Date <- as.Date(power$Date, "%d/%m/%Y")
power2 <- na.omit(power)
library(lubridate)
power2$datetime <- (with(power2, ymd(Date) + hms(Time)))
head(power2)
power3 <-
        power2[power2$Date == "2007-02-01" | power2$Date == "2007-02-02", ]
head(power3)
rm(power2)
gc()


#perform task
png(
        file = "plot3.png",
        width = 480,
        height = 480,
        bg = "white"
)
plot(power3$datetime,power3$Sub_metering_1,type = "o", pch=NA, lty=1, ylab = "Energy sub metering", xlab = NA)
points(power3$datetime,power3$Sub_metering_2,type = "o", pch=NA, lty=1, col = "RED")
points(power3$datetime,power3$Sub_metering_3,type = "o", pch=NA, lty=1, col = "Blue")

legend("topright", lty =1,  pch=c(NA,NA,NA), col=c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

dev.off()

#plot the same to view
plot(power3$datetime,power3$Sub_metering_1,type = "o", pch=NA, lty=1, ylab = "Energy sub metering", xlab = NA)
points(power3$datetime,power3$Sub_metering_2,type = "o", pch=NA, lty=1, col = "RED")
points(power3$datetime,power3$Sub_metering_3,type = "o", pch=NA, lty=1, col = "Blue")

legend("topright", lty =1,  pch=c(NA,NA,NA), col=c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
