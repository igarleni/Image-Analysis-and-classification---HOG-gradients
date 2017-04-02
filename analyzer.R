#


#read files
trainBackground <- read.csv("trainBackground.csv", header = F)
trainPedestrian <- read.csv("trainPedestrian.csv", header = F)

testBackground <- read.csv("testBackground.csv", header = F)
testPedestrian <- read.csv("testPedestrian.csv", header = F)


#class ---> 1 = pedestrian, 0 ---> background
class <- as.factor(seq(0,0,length.out = dim(trainBackground)[1]))
trainBackground <- cbind(trainBackground, class)
class <- as.factor(seq(1,1,length.out = dim(trainPedestrian)[1]))
trainPedestrian <- cbind(trainPedestrian, class)

class <- as.factor(seq(0,0,length.out = dim(testBackground)[1]))
testBackground <- cbind(testBackground, class)
class <- as.factor(seq(1,1,length.out = dim(testPedestrian)[1]))
testPedestrian <- cbind(testPedestrian, class)


#mix background and Pedestrian
trainData <- rbind(trainBackground, trainPedestrian)
trainDataShuffled <- trainData[sample(nrow(trainData)),]

testData <- rbind(testBackground, testPedestrian)
testDataShuffled <- testData[sample(nrow(testData)),]


#classification algorithm
library(randomForest)
model <- randomForest::randomForest(class ~ ., data = trainDataShuffled, ntree = 100)
prediction <- predict(model, newdata = testDataShuffled[, -3781])

#Results
accuracyMatrix <- cbind( testDataShuffled[, 3781], prediction, testDataShuffled[, 3781] == prediction)
colnames(accuracyMatrix) <- c('Real', 'Prediction', 'True')
positives <- accuracyMatrix[which(grepl(2, accuracyMatrix[,'Real'])),] #pedestrian
negatives <- accuracyMatrix[which(grepl(1, accuracyMatrix[,'Real'])),] #background

accuracy <- sum(accuracyMatrix[,1] == accuracyMatrix[,2]) / dim(accuracyMatrix)[1]
accuracy

truePositives <- sum(positives[,3] == 1) / dim(positives)[1]
trueNegatives <- sum(negatives[,3] == 1) / dim(negatives)[1]

predictionPossitive <- accuracyMatrix[which(grepl(2,accuracyMatrix[,'Prediction'])),]
predictionNeggative <- accuracyMatrix[which(grepl(1,accuracyMatrix[,'Prediction'])),]
FalsePositives <- nrow(predictionPossitive[which(grepl(0,predictionPossitive[,3])),]) / dim(predictionPossitive)[1]
FalseNegatives <- nrow(predictionNeggative[which(grepl(0,predictionNeggative[,3])),]) / dim(predictionNeggative)[1]
