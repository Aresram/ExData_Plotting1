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

titlepw<-"Global_active_power"
##titled<-"Time"
##comp<-function(x,title)x[title]
##gap<-comp(data,titlepw)
##gap<-as.numeric(gap[[1]])

gap<-as.numeric(data[,"Global_active_power"])
datetime<-paste(data[,"Date"],data[,"Time"],sep=" ")
datetimes<-strptime(datetime,format=" %d/%m/%Y %H:%M:%S")

png(file="plot2.png")
plot(datetimes,gap,ylab="Global Active Power (kilowatts)", type="l",xlab="")
dev.off()




