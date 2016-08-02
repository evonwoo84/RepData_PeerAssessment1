#Title: Reproducible Research Assigment
=======================================
This dataset collected from a personal activity monitoring device on number of steps taken in 5 minute intervals each day of an 
an anonymous individual during the months of October and November, 2012.
Analysis below covered:
1. Code for reading in the dataset and/or processing the data
2. Histogram of the total number of steps taken each day
3. Mean and median number of steps taken each day
4. Time series plot of the average number of steps taken
5. The 5-minute interval that, on average, contains the maximum number of steps
6. Code to describe and show a strategy for inputing missing data
7. Histogram of the total number of steps taken each day after missing values are inputed
8. Panel plot comparing the average number of steps taken per 5-minute interval across weekdays and weekends



##Step1: Loading and preprocessing the data


```r
rawData <- read.csv("activity.csv", header = TRUE);
```



##Step2: What is mean total number of steps taken per day?

- Calculate Total steps taken per day, mean and median:

```r
totalVal <- aggregate(rawData$steps, list(date = rawData$date),FUN=sum)
```

- Histogram of total number of steps taken per day
![](ReproducibleResearchWeek2Quiz_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

- Mean 

```
## [1] 10766.19
```

- Median

```
## [1] 10765
```



##Step3: What is the average daily activity pattern?

- Time series plot: Average Daily Activity

```r
avgDaily <- aggregate(steps ~ interval, data=rawData, FUN=mean, na.action = na.pass, na.rm = TRUE)
plot(avgDaily, type="l", main="Average daily activity pattern")
```

![](ReproducibleResearchWeek2Quiz_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

- Maximum number of steps:

```r
max(meanVal, na.rm = TRUE)
```

```
## [1] 10766.19
```



##Step4: Imputing missing values

- Total rows of NA

```r
sum(is.na(rawData$steps))
```

```
## [1] 2304
```

- Replace NA with 0

```r
processedData <- rawData 
processedData[is.na(processedData)] <- 0
head(processedData)
```

```
##   steps       date interval
## 1     0 2012-10-01        0
## 2     0 2012-10-01        5
## 3     0 2012-10-01       10
## 4     0 2012-10-01       15
## 5     0 2012-10-01       20
## 6     0 2012-10-01       25
```

- After imputting missing data, recalculate total steps per day, mean and median. 

```r
totalVal2 <- aggregate(processedData$steps, list(date = processedData$date),FUN=sum)
```

- Histogram of total number of steps taken per day

```r
hist(totalVal2$x, main="Total number of steps taken per day", xlab="steps", ylab="day")
```

![](ReproducibleResearchWeek2Quiz_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

- Mean 

```
## [1] 9354.23
```

- Median

```
## [1] 10395
```



##Step5: Are there differences in activity patterns between weekdays and weekends?

- add variable to indicate day of the week, weekend or weekdays

```r
processedData$day <- as.POSIXlt(processedData$date)$wday
processedData$day[processedData$day == 0] <- "weekend"
processedData$day[processedData$day >= 1 & processedData$day <= 5] <- "weekday"
processedData$day[processedData$day == 6] <- "weekend"
```

- Plot: time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis)

```r
library(ggplot2)
avgDaily2 <- aggregate(processedData$steps, list((processedData$interval),processedData$day), FUN = "mean")
head(avgDaily2)
```

```
##   Group.1 Group.2          x
## 1       0 weekday 2.02222222
## 2       5 weekday 0.40000000
## 3      10 weekday 0.15555556
## 4      15 weekday 0.17777778
## 5      20 weekday 0.08888889
## 6      25 weekday 1.31111111
```

```r
names(avgDaily2) <- c("interval", "wday", "steps")
ggplot(data=avgDaily2, aes(interval, steps)) + geom_line() + facet_wrap(~ wday)
```

![](ReproducibleResearchWeek2Quiz_files/figure-html/unnamed-chunk-15-1.png)<!-- -->
