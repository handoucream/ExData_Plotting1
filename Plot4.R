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

# Plot4
png(filename = "plot4.png", width = 480, height = 480, units = "px", pointsize = 12, bg = "white",  res = NA)
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))

# plot-topleft
plot(energy$Date_time, energy$Global_active_power, type="l", col="black", xlab="", ylab="Global Active Power (kilowatts)", xaxt = "n")
max <- as.numeric(max(energy$Date_time))
min <- as.numeric(min(energy$Date_time))
axis(side = 1, at = c(min, min + (max-min)/2, max), labels = c("Thu", "Fri", "Sat"))

# plot-topright
plot(energy$Date_time, energy$Voltage, type="l", col="black", xlab="datetime", ylab="Voltage", xaxt = "n")
max <- as.numeric(max(energy$Date_time))
min <- as.numeric(min(energy$Date_time))
axis(side = 1, at = c(min, min + (max-min)/2, max), labels = c("Thu", "Fri", "Sat"))

# plot-bottomleft
plot(energy$Date_time, energy$Sub_metering_1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering", xaxt = "n")
max <- as.numeric(max(energy$Date_time))
min <- as.numeric(min(energy$Date_time))
axis(side = 1, at = c(min, min + (max-min)/2, max), labels = c("Thu", "Fri", "Sat"))
points(energy$Date_time, energy$Sub_metering_2, type = "l", col = "red")
points(energy$Date_time, energy$Sub_metering_3, type = "l", col = "blue")
legend("topright", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = 1, bty = "n")

# plot-bottomright
plot(energy$Date_time, energy$Global_reactive_power, type="l", col="black", xlab="datetime", ylab="Global_reactive_power", xaxt = "n")
max <- as.numeric(max(energy$Date_time))
min <- as.numeric(min(energy$Date_time))
axis(side = 1, at = c(min, min + (max-min)/2, max), labels = c("Thu", "Fri", "Sat"))

dev.off()