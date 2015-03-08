text="household_power_consumption.txt"
startDate<-as.Date("2007-02-01")
endDate<-as.Date("2007-02-02")
##myrange<-function(x) x=="2007-02-01"||x=="2007-02-02"
dates<-c(endDate,startDate)
n<-read.csv(text,nrow=1,sep=";",stringsAsFactors=FALSE)
colClasses<-lapply(data,class)
colClasses<-lapply(n,class)
names<-names(n)
chunkSize<-100000
curr<-1
rep<-1
num<-2075259
data<-NULL
tf<-NULL
datab<-NULL
while(curr<=num+chunkSize)
{	

datab<-read.csv(text,colClasses=colClasses,col.names=names,nrow=chunkSize,skip=curr,sep=";",na.strings="?",stringsAsFactors=FALSE)

dt<-as.Date(datab$Date,format="%d/%m/%Y")
##tf<-sapply(dt,myrange)


holder<-datab[dt==dates[1]|dt==dates[2],]
data<-rbind(data,holder)
holder<-NULL
datab<-NULL
tf<-NULL
rep<-rep+1
curr<-curr+chunkSize
if(length(data[[1]])>=length(dates)*1440)
break
}
title<-"Global_active_power"
comp<-function(x,title)x[title]
gap<-comp(data,title)
gap<-as.numeric(gap[[1]])
png(file="plot1.png")
hist(gap, xlab="Global Active Power (kilowatts)", col="red", main="Global Active Power")
dev.off()




