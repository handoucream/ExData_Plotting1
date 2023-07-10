library(tidyr, dplyr, lubridate)

# get data
wd <- getwd()
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file <- "data.zip"
download.file(fileurl, destfile = paste(wd, "/", file, sep = ""), method = "curl")
unzip(file)
unlink(file)

# Read data set into R
colNames <- c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
energy <- read.csv2(paste(wd, "/household_power_consumption.txt", sep = ""), header = FALSE, skip = 66637, nrows = 2880, col.names = colNames, na.strings="?")
energy <- tibble(energy)

# Prepare data for plotting
## transform the character column 3:9 into numeric type
energy[, 3:9] <- sapply(energy[, 3:9], as.numeric)
## transform date and time into one date format column
energy$Date_time <- strptime(paste(energy$Date, energy$Time, sep = " "), "%d/%m/%Y %H:%M:%S")

# plot1
png(filename = "plot1.png", width = 480, height = 480, units = "px", pointsize = 12, bg = "white",  res = NA)
hist(energy$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
dev.off()