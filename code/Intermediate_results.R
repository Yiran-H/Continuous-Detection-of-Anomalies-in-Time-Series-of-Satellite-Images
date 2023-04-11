data1=brick("C:/keyanying/Data/layerstack/NDVI_layerstack_2000-2014.tif")
opar=par(no.readonly = T)
par(mfrow=c(2,1))
plot(data1[[312]])
plot(data1[[312]],col=gray(0:255/256))
plot(data1[[312]],col=gray(0:9/10))
par(opar)
data2=as.array(data1)
data3=ts(data2[79,275,],start=c(2000,4),frequency = 23)
plot(data3,type='o'）

plot(time(data3),192655.30477+time(data3)*(-94.57414),type = "l")     
model<-lm(data3~time(data3)+I(harmonic(data3,3)))
plot(ts(fitted(model),frequency = 23,start = c(2000,4)),ylab="Season")     
plot(ts(residuals(model),frequency = 23,start = c(2000,4)),type='h',ylab="Residuals")
model$coefficients

plot(ts(rstudent(model),frequency = 23,start = c(2000,4)),type='h',ylim=c(-10,5),ylab="Z-sorces")
a=rstudent(model)< -3
b=ts(rstudent(model),frequency = 23,start=c(2000,4))
abline(h=3,lty=3,col="red")
abline(h=-3,lty=3,col="red")
text(time(b)[30],4,labels="Upper boundary",col="red")
text(time(b)[30],-4,labels="Lower boundary",col="red")
points(time(b)[a],b[a],pch=16,col="red")
points(time(b)[5],-9,pch=16,col="red")
text(time(b)[30],-9,labels="Anomaly",col="red")
