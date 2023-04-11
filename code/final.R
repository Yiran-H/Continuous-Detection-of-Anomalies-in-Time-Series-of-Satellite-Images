# import package
library(raster)
library(sp)
library(rgdal)
library(TSA)
library(bfast)

# Crop image sequences and numerize them
data<-brick("F:/NDVI_layerstack_2000-2014.tif")
data1<-crop(data,extent(data,70,119,250,349))
data2<-getValues(data1)

#-----------------------------------------------------------------------------------

# bfast exception detection function
fun_bfast_detection<-function(x){
  if(anyNA(x))   return(NA)
  else{
    ts_data<-ts(x,frequency = 23,start = c(2000,4))
    bfast_md<-bfast01(ts_data,formula = response ~ harmon,bandwidth = 0.05)
    ifelse(bfast_md$breaks,return(bfast_md$breakpoints),return(NA))
  }
}

# ZSTR exception detection function
fun_ZSTR_detection<-function(x){     
  if(anyNA(x)) return(c(1:342)*NA)
  else{
    x<-(x-mean(x))/sd(x)
    data6<-ts(x,start=c(2000,4),frequency = 23)
    model1<-lm(data6~time(data6))
    har.<-harmonic(data6,3)
    model2<-lm(ts(residuals(model1),frequency = 23,start = c(2000,4))~har.)
    # error：model<-lm(data6~time(data6)+I(harmonic(data6,3)))
    data7<-residuals(model2)
    # Residual processing to remove 5%：rstudent(model2)
    index<-(data7>quantile(data7,0.05)&data7<quantile(data7,0.95))
    data71<-data7[index]
    sd<-1/length(data71)*sum(abs(data71))*sqrt(pi/2)
    z<-(data7-mean(data71))/sd
    zt<-ts(z,frequency = 23,start = c(2000,4))
    
    anomalies<-(zt < -3)
    anomalies[anomalies == FALSE]<-NA
    return(anomalies)
  }  
}

# ZSTR exception start moment function
fun_ZSTR_breakpoints<-function(x){
  return(which(x == TRUE)[1])
}

#-----------------------------------------------------------------------------------

# bfast anomaly detection batch processing
data2_bfast_rslt<-apply(data2,1,fun_bfast_detection)

# ZSTR anomaly detection batch processing
data2_ZSTR_rslt<-apply(data2,1,fun_ZSTR_detection)

#-----------------------------------------------------------------------------------

# bfast test result processing
data2_bfast_rslt1<-t(data2_bfast_rslt)  #？？

# Go back to the raster file and give geographic information
bfast_breakpoints<-raster(matrix(data2_bfast_rslt1,nrow=50,ncol=100,byrow = TRUE))
extent(bfast_breakpoints)<-extent(data1)
projection(bfast_breakpoints)<-projection(data1)

# Show the results of 302~308 band anomaly detection after bfast processing
for (i in c(302:308)) {
plot(bfast_breakpoints,col = gray.colors(256))
bbp_temp<-bfast_breakpoints
bbp_temp[bfast_breakpoints!=i]<-NA    # drawing No.302
plot(bbp_temp,col='red',add=TRUE,legend = FALSE)
mtext('E',at=134.24,line=0.95,side=1)
mtext('N',at=48.31,line=0.95,side=2)
}


#-----------------------------------------------------------------------------------

# ZSTR test result processing (2013 full year)
data2_ZSTR_rslt1<-t(data2_ZSTR_rslt)
data2_ZSTR_rslt1_2013<-data2_ZSTR_rslt1[,297:319]

# ZSTR exception start time batch calculation
data2_ZSTR_rslt1_2013_breakpoints<-apply(data2_ZSTR_rslt1_2013,1,fun_ZSTR_breakpoints)

# Go back to the raster file and give geographic information
ZSTR_breakpoints<-raster(matrix(data2_ZSTR_rslt1_2013_breakpoints,nrow=50,ncol=100,byrow = TRUE))
extent(ZSTR_breakpoints)<-extent(data1)
projection(ZSTR_breakpoints)<-projection(data1)

#----------------------------------------------------------------------------------

# Fig4.a  ZSTR image drawing
ZSTR_breakpoints[ZSTR_breakpoints < 6 | ZSTR_breakpoints > 20]<-NA
ZSTR_breakpoints[c(1,2)]<-c(6,20)
# Display NDVI background image
plot(data1[[312]],col = colorRampPalette(c("black","white"))(256),legend = FALSE)
# overlapping
plot(ZSTR_breakpoints,col = rainbow(15),add = TRUE)
mtext('E',at=134.28,line=0.95,side=1)
mtext('N',at=48.31,line=0.95,side=2)
#F ig4.b  bfast image drawing
bfast_breakpoints<-bfast_breakpoints - 296
bfast_breakpoints[bfast_breakpoints < 6 | bfast_breakpoints > 20]<-NA
bfast_breakpoints[c(1,2)]<-c(6,20)
# Display NDVI background image
plot(data1[[312]],col = colorRampPalette(c("black","white"))(256),legend = FALSE)
# overlapping
plot(bfast_breakpoints,col = rainbow(15),add = TRUE)
mtext('E',at=134.28,line=0.95,side=1)
mtext('N',at=48.31,line=0.95,side=2)