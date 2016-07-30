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

```{r eval=TRUE, echo=TRUE}
rawData <- read.csv("activity.csv", header = TRUE);
```



##Step2: What is mean total number of steps taken per day?

- Calculate Total steps taken per day, mean and median:
```{r eval=TRUE, echo=TRUE}
totalVal <- aggregate(rawData$steps, list(date = rawData$date),FUN=sum)
```

- Histogram of total number of steps taken per day
```{r eval=TRUE, echo=FALSE}
hist(totalVal$x, main="Total number of steps taken per day", xlab="steps", ylab="day")
```

- Mean 
```{r eval=TRUE, echo=FALSE}
meanVal <- mean(totalVal$x, na.rm = TRUE)
print(meanVal)
```

- Median
```{r eval=TRUE, echo=FALSE}
medianVal <- median(totalVal$x, na.rm = TRUE)
print(medianVal)
```



##Step3: What is the average daily activity pattern?

- Time series plot: Average Daily Activity
```{r eval=TRUE, echo=TRUE}
avgDaily <- aggregate(steps ~ interval, data=rawData, FUN=mean, na.action = na.pass, na.rm = TRUE)
plot(avgDaily, type="l", main="Average daily activity pattern")
```

- Maximum number of steps:
```{r eval=TRUE, echo=TRUE}
max(meanVal, na.rm = TRUE)
```



##Step4: Imputing missing values

- Total rows of NA
```{r eval=TRUE, echo=TRUE}
sum(is.na(rawData$steps))
```

- Replace NA with 0
```{r eval=TRUE, echo=TRUE}
processedData <- rawData 
processedData[is.na(processedData)] <- 0
head(processedData)
```

- After imputting missing data, recalculate total steps per day, mean and median. 
```{r eval=TRUE, echo=TRUE}
totalVal2 <- aggregate(processedData$steps, list(date = processedData$date),FUN=sum)
```

- Histogram of total number of steps taken per day
```{r eval=TRUE, echo=TRUE}
hist(totalVal2$x, main="Total number of steps taken per day", xlab="steps", ylab="day")
```

- Mean 
```{r eval=TRUE, echo=FALSE}
meanVal2 <- mean(totalVal2$x, na.rm = TRUE)
print(meanVal2)
```

- Median
```{r eval=TRUE, echo=FALSE}
medianVal2 <- median(totalVal2$x, na.rm = TRUE)
print(medianVal2)
```



##Step5: Are there differences in activity patterns between weekdays and weekends?

- add variable to indicate day of the week, weekend or weekdays
```{r eval=TRUE, echo=TRUE}
processedData$day <- as.POSIXlt(processedData$date)$wday
processedData$day[processedData$day == 0] <- "weekend"
processedData$day[processedData$day >= 1 & processedData$day <= 5] <- "weekday"
processedData$day[processedData$day == 6] <- "weekend"
```

- Plot: time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis)
```{r eval=TRUE, echo=TRUE}
library(ggplot2)
avgDaily2 <- aggregate(processedData$steps, list((processedData$interval),processedData$day), FUN = "mean")
head(avgDaily2)
names(avgDaily2) <- c("interval", "wday", "steps")
ggplot(data=avgDaily2, aes(interval, steps)) + geom_line() + facet_wrap(~ wday)
```
