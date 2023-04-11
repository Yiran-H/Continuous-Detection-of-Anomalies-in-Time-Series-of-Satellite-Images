# Continuous-Detection-of-Anomalies-in-Time-Series-of-Satellite-Images

## background
Natural disasters such as forest fires, floods, and deforestation, as well as human activities, can cause anomalies or disturbances in land cover. In studying the spatiotemporal processes of land changes, continuous detection of anomalies is crucial and effective. However, many time series analysis methods (such as extended Kalman filter methods and Gaussian processes or based on some harmonic models) may be suitable for monitoring interannual changes or detecting land cover changes, as well as monitoring land cover disturbances and anomalies. There are few methods that focus on continuously monitoring changes and anomalies in any satellite image time series to obtain spatiotemporal changes in land cover.

This study provides a simple method for continuously monitoring anomalies in satellite image time series based on the Z-value of seasonal trend model residuals, called ZSTR. ZSTR is based on a very well-known method for detecting land cover changes called Breaks For Additive Season and Trend (BFAST). Both methods can continuously monitor spatiotemporal anomalies in areas affected by floods.

The results of this experiment mainly demonstrate the ability and good performance of ZSTR to continuously monitor anomalies in satellite time series.

## data
Study area: Tongjiang River Basin in Heilongjiang Province, China, covering an area of 6,000 square kilometers (120 km * 50 km).
<br>Time period: February 2000 to February 2015.
<br>Data: NDVI images from Terra/MODIS, 23 images per year.
<br>Anomalies: 2013 summer flood and a riverbank breach on August 23, 2013, causing floods in a large area.

## purpose
Designing the ZSTR method to achieve continuous surveillance of dynamic anomalies.

## method
Z-scores of Season-Trend model Residuals（ZSTR）
<br>1. Decompose time series by a season-trend model
<br>2. Detect anomaly based on z-scores of model residuals

## code
[final comparison](https://github.com/Yiran-H/Continuous-Detection-of-Anomalies-in-Time-Series-of-Satellite-Images/blob/main/code/final.R)
[The analysing graph](https://github.com/Yiran-H/Continuous-Detection-of-Anomalies-in-Time-Series-of-Satellite-Images/blob/main/code/Intermediate_results.R)

## report
[Chinese version](https://github.com/Yiran-H/Continuous-Detection-of-Anomalies-in-Time-Series-of-Satellite-Images/blob/main/report.pdf)
 with visualization graph and formula
