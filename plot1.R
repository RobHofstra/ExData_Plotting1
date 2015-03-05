## We want to skip all records before 01/02/2007, but then we loose the headers.
## So instead, we first read the headers.
headers<-read.table(file="household_power_consumption.txt",sep=";",header=TRUE,na.strings="?",nrows=1)
## We now also have the start date-time and we know there is one observation per minute.
## From this, we can calculate the number of rows to skip.
skiprows<-difftime(as.POSIXct(strptime("01/02/2007 00:00:00",format="%d/%m/%Y %H:%M:%S",tz="")),as.POSIXct(strptime(paste(headers[1,1],headers[1,2],sep=" "),format="%d/%m/%Y %H:%M:%S",tz="")),units="mins")
## We only want the observations for two days, so we can calculate the number of rows to read.
hpc<-read.table(file="household_power_consumption.txt",sep=";",header=TRUE,na.strings="?",skip=skiprows,nrows=(2*24*60),stringsAsFactors=FALSE)
## Now we have the observations, we can restore the original headings.
names(hpc)<-names(headers)
## Next, we transform the Date column to a POSIXct date-time format, 
## rendering the Time column superfluous 
hpc$Date<-as.POSIXct(strptime(paste(hpc$Date,hpc$Time,sep=" "),format="%d/%m/%Y %H:%M:%S",tz=""))
hpc<-hpc[,-2]
## Now that the data is ready, we can create the plot.
png(file="plot1.png",bg="transparent")
hist(hpc$Global_active_power,col="Red",xlab="Global Active Power (kilowatts)",main="Global Active Power")
dev.off()