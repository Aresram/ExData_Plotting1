text="household_power_consumption.txt"
startDate<-as.Date("2007-02-01")
endDate<-as.Date("2007-02-02")
##myrange<-function(x) x=="2007-02-01"||x=="2007-02-02"
dates<-c(endDate,startDate)

##set paramerters
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
##get a chunk of the file
datab<-read.csv(text,colClasses=colClasses,col.names=names,nrow=chunkSize,skip=curr,sep=";",na.strings="?",stringsAsFactors=FALSE)

##filter out wrong dates and add to data
dt<-as.Date(datab$Date,format="%d/%m/%Y")
holder<-datab[dt==dates[1]|dt==dates[2],]
data<-rbind(data,holder)

##free memory and increment
holder<-NULL
datab<-NULL
tf<-NULL
rep<-rep+1
curr<-curr+chunkSize

##if we have collected one observation per minute in the 2 days
if(length(data[[1]])>=length(dates)*1440)
break

}


##plot graph

titleeng<-"Energy sub metering"
titlev<-"Voltage"
titlerp<-"Global_reactive_power"
t1<-"Sub_metering_1"
t2<-"Sub_metering_2"
t3<-"Sub_metering_3"
mfrow<-2
mfcol<-2

esm1<-as.numeric(data[,t1])
esm2<-as.numeric(data[,t2])
esm3<-as.numeric(data[,t3])
gap<-as.numeric(data[,"Global_active_power"])
v<-as.numeric(data[,titlev])
grp<-as.numeric(data[,titlerp])
datetime<-paste(data[,"Date"],data[,"Time"],sep=" ")
datetimes<-strptime(datetime,format=" %d/%m/%Y %H:%M:%S")

png(file="plot4.png")
par(mfcol=c(mfrow,mfcol))
plot(datetimes,gap,ylab="Global Active Power", type="l",xlab="")
plot(datetimes,esm1,ylab=titleeng, type="l",xlab="")
lines(datetimes,esm2,col="red",type="l",ylab=titleeng,xlab="")
lines(datetimes,esm3,col="blue",type="l",ylab=titleeng,xlab="")
legend("topright",col=c("black","red","blue"),legend=c(t1,t2,t3),lty=c(1,1,1),bty="n")
plot(datetimes,v,ylab=titlev, type="l",xlab="datetime")
plot(datetimes,grp,ylab=titlerp, type="l",xlab="datetime")

dev.off()




