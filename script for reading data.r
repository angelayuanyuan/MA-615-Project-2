

##########################
##### Data Importing######
##########################


### Ship data: 2001-2017
### Region: Altanic Europe Region
### LAT (-20, +3); LON (35, 70)

library(dplyr)

title <- c("YR", "MO", "DY", "HR", "LAT", "LON", "IT", "AT", "SI", "SST")

read_single_file<-function(file_name){
	data<-readLines(file_name)
	df<-NULL
	for (i in 1:length(data)){
		tmp<-data[i]
		subtmp<-paste0(substr(tmp,1,21), substr(tmp, 69, 73), substr(tmp, 84, 89))
		df<-rbind(df, subtmp)
	}
	data.clean<-read.fwf(textConnection(df),widths=c(4,2,2,4,5,4,1,4,2,4))
	names(data.clean)<-title
	data.clean$LON<-as.numeric(data.clean$LON)
	data.clean<-data.clean %>% filter(LAT>-2000 & LAT<300 & LON<70 & LON>35)
	print(file_name)
	return(data.clean)
}


read_single_dir<-function(pattern){
  file_list = list.files(pattern = pattern)
  print(file_list)
  Alldata = data.frame(matrix(nrow = 0,ncol = 10))
  for (file in file_list) {
    dfdat = read_single_file(file_name = file.path(file))
    Alldata<-rbind(Alldata, dfdat)
  }
  colnames(Alldata) = title
  return(Alldata)
}

Alldf.1<-read_single_dir(pattern = "200[0-9][01][0-9].txt")
Alldf.2<-read_single_dir(pattern = "201[0-9][01][0-9].txt")

Alldata<-rbind.data.frame(Alldf.1,Alldf.2)

write.csv(Alldata,"Alldata.csv")