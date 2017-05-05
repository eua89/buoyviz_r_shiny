read_csv <- function(input){
  fn = paste("http://localhost:5000/",input,".csv", sep="")
  f = read.csv(fn,header=T, sep=",")
  f$Date <- format(as.POSIXct(paste(f$X.YY, f$MM, f$DD, f$hh ,f$mm, sep = "/"), format= "%Y/%m/%d/%H/%M"))
  f
}
