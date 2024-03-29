#This files contains the R code without any markdown


wine <- read.csv("wine2.csv")
wine = na.omit(wine)
#View(wine)

#1. Using the data in wine.csv, use one of the supervised classification algorithms we learned (logistic
#regression or KNN) to determine the class of the wine (white or red) based on the variables given.
#Use an 80/20 split to test your model.

#First column is messed up, needs to be removed
df = wine[,-1]
#View(df)

#95 white, 33 red

#Normalize Data
df[,1] = c(rep(1,95), rep(2,33))
for(x in 2:13){
  df[,x]=(df[,x]-mean(df[,x]))/sd(df[,x])
}

#Sample size will be 80% of our set size, AKA how many training points it should have
sampleSize = floor(0.80 * nrow(df))
#sampleSize
#nrow(df)
#Sample size is 100 for training

#set.seed(1)
#important to note that about 75% of data set is white

#Returns random indexes for rows of data, which will be the 'training' set
randSamples = sample(1:(nrow(df)), size = sampleSize)
#randSamples

#Turn those rows into training and testing sets
train = df[randSamples, ]
#train[,1]
test = df[-randSamples, ]
#test[,1]

#View(df)

#Returns the indexes of the closest k data points to the input data point
MIN=function(X,k)
{
  Y=X
  values=rep(0,k)
  for (i in 1:k)
  {
    
    values[i]=which.min(Y)
    Y[values[i]]=Inf
  }
  return (values)
}

k=3
amountTrain = nrow(train)
amountTest = nrow(test)

#View(train)

class = rep(0,amountTest)
for(i in 1:(amountTest)){ #i represents a test point
  D = rep(0,amountTrain)
  for(j in 1:amountTrain){ #j represents a training point. A single i will be compared to every j
    
    D[j]=sum((test[i,-1]-train[j,-1])^2) #D[] is full of test i minus every training point. Smallest k (3) of these are what it is looking for
    
  }
  values=MIN(D,k) #returns indexes of k closest points to the test point
  #print(values)
  values=train[values,1] #Gets the classification of those points, 1 or 2, AKA white or red wine
  #print(values)
  class[i]=values[as.integer(which.max(table(values)))] #the test point is assigned to Whichever class is the most present out of k (2/3)
  
  
  
}


#The guessed types of wine using KNN:  


class #Print the classes of the test data

#The correct types:  

test[,1] #Print the correct class of the data

#The percent of correctly guessed wine types:  

sum(test[,1]==class)/26*100 #% of data guessed correctly (Should be around 92-100)

#2. Use the data in wine.csv again, this time ignore the class and run a clustering algorithm to see if you
#can find the 2 clusters, Does the clustering algorithm think 2 is the correct number of clusters?

clusterDF = df[,-1]
#View(clusterDF)

#R's built in k-means test
#kmeans(clusterDF, 2)

#pick k
k = 2#3

###########Randomly pick two points in space
#Space will be 12 dimensional, use max and min of each normalized data point to set the range
min=1
max=2

spaceRange = matrix(rep(0,24), nrow=k, ncol=12) #Will define the range of random variable points for clustering
#spaceRange

#Finds the min and max of each column, creates a 'range' for random points to be placed.
for(i in 1:12){ 
  spaceRange[min,i] = min(clusterDF[,i])
}
for(i in 1:12){
  spaceRange[max,i] = max(clusterDF[,i])
}

#

randPoints = matrix(rep(0,(12*k)), nrow=k,ncol=12)
for(i in 1:12){
  
  v = runif(k, spaceRange[min,i], spaceRange[max,i])
  #print(v)

  #v now holds 2 twelve dimensional points. Apply the rest of the clustering algorithm
  randPoints[, i] = v
  #Find all points closet to each cluster point. Loop through everything in data and check which one it is closer to.
  #print(v)
}
#print(randPoints)
#each row of randPoints is a point in the 12 dimensional space. Compare to the rest of the data
###########

#Distance 1, 2, 3
D1 = 0
D2 = 0
#D3 = 0#

for(j in 1:100){#Times to refine the mean of the clusters
  ##starts empty, will become a list of the indexes of points, points in D1List will be cluster 1, D2List is cluster 2
  D1List = c()
  D2List = c()
  #D3List = c()#
  ##
  for(i in 1:128){
    
    #Take data points of entry i, finds the distance between points and randomly generated points
    D1=dist(rbind(clusterDF[i,], randPoints[1,]))
    D2=dist(rbind(clusterDF[i,], randPoints[2,]))
    #D3=dist(rbind(clusterDF[i,], randPoints[3,]))#

    
    #####Testing with k=3. Can ignore.
    #a = sort(c(D1,D2,D3))#
    #if(a[1] == D1){
    #  D1List = append(D1List, i)
    #}
    #if(a[1] == D2){
    #  D2List = append(D2List, i)
    #}
    #if(a[1] == D3){
    #  D3List = append(D3List, i)
    #}
    ######
    
    #Cluster assignment based on proximity
    if(D1 < D2){
      D1List = append(D1List, i)
    }
    else{
      D2List = append(D2List, i)
    }
    
    
    
    #compare to each randomly generated point
    #somehow label which point it belongs to "cluster" it
    
  }

  #D1List and D2List now have indexes of each cluster. Find mean, and redo cluster process with that mean point
  Cluster1 = clusterDF[D1List, ]
  Cluster2 = clusterDF[D2List, ]
  #Cluster3 = clusterDF[D3List, ]#
  
  ###Testing if mean points are being found correctly. Can ignore.
  #meanPoint1 = colMeans(Cluster1)
  #print(meanPoint1)
  #meanPoint2 = colMeans(Cluster2)
  #print(meanPoint2)
  ###
  
  randPoints[1,] = colMeans(Cluster1)
  randPoints[2,] = colMeans(Cluster2)
  #randPoints[3,] = colMeans(Cluster3)# For k=3 testing

}


#Note that indexes 1-95 are actually white wine, and 96-128 are red wine

#The 1st cluster produced by k-means clustering:  

#print("D1List: ")
print(D1List)


The 2nd cluster produced by k-means clustering:

#print("D2List: ")
print(D2List)
#print("D3List: ")#
#print(D3List)

#print("Randpoint1: ")
#print(randPoints[1,])
#print("Randpoint2: ")
#print(randPoints[2,])
#print("Randpoint3: ")#
#print(randPoints[3,])

#The actual indexes of the types of wines: 

#white:  

whiteIndexes = which(df[,1] == 1)
redIndexes = which(df[,1] == 2)
whiteIndexes

#red:  

redIndexes
#print(D2List)

#Or more useful,

#The percentage of white wine in cluster 1 vs cluster 2:  

#which(D2List == which(df[,1] == 1))

q = (D1List %in% whiteIndexes)
sum(q)/length(whiteIndexes)

q = (D2List %in% whiteIndexes)
sum(q)/length(whiteIndexes)

#The percentage of red wine in cluster 1 vs cluster 2:  

q = (D1List %in% redIndexes)
sum(q)/length(redIndexes)

q = (D2List %in% redIndexes)
sum(q)/length(redIndexes)



#The main take-away is that it is inconsistent, which is in-line for an unsupervised model. The red wine data almost always stays together, no matter which cluster it ends up in. From my observations, one of two things tends to happen: either one cluster is
#mostly red wine andthe other is mostly white wine, or one cluster has mostly red wine but also about half of the white wine, and the other cluster has the other half of white wine. 
#This also seems to be the case for R's built in k-means test. In the former situation, yes, two clusters is absolutely correct, that is what you would want from this algorithm. For the later situation it's trickier, but I would still say yes due to the nature of k-means clustering.

#3. A mouse is placed in a 4 × 4 square grid. The mouse can vertically and horizontally through the
#grid, but can’t leave the grid. The mouse moves with equal probably to any adjacent cell (the mouse
#has to move).
#The mouse is placed into location (1,1). In location (4,4) is a large piece of cheese. In cell’s (3,2)
#and (2,4) is a trap in which the mouse will get stuck in that cell.

#Make a transition matrix where (4,4), (3,2) and (2,4) are absorbing.
#This is given the maze rooms are denoted like this:
# 1  2  3  4
# 5  6  7  8
# 9  10 11 12
# 13 14 15 16
#You can travel from one room to another if the difference is 1 or 4, with the exception of 4-5, 8-9, and 12-13 . Calculated below:

tM = matrix(rep(0,16*16), ncol = 16, nrow = 16)
for(i in 1:16){
  for(j in 1:16){
    
    if(i == j+1 || j == i+1){
      tM[i,j] = tM[i,j] + 1
    }
    else if(i == j + 4 || j == i+4){
      tM[i,j] = tM[i,j] + 1
    }
    
  }
}

tM[4,5] = 0
tM[5,4] = 0
#tM[8,9] = 0 Adjusted Later Anyways
tM[9,8] = 0
tM[12,13] = 0
tM[13,12] = 0

#Of course, absorbing states are an exception. There is no 'from' room 10, 8, or 16.

tM[10,] = c(0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0)
tM[8,] = c(0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0)
tM[16,] = c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1)

#tM

#The relevant (non-zero) contents of each row will be identical. Divide them by the sum of their row to get the probability.
for(i in 1:16){
  tM[i,] = tM[i,]/sum(tM[i,])
}

#The probability of getting to the cheese should be given by the steady state solution.
#tM to a high power, high enough to stop the numbers from changing further, should suffice

library(expm)

steadyState = ((tM%^%10000)[1,])

#The steady state for each of the 16 rooms. The only non-zeros are the absorbing states.

steadyState

#(a) What is the probability the mouse makes it to the the Cheese.

steadyState[16]

#(b) What is the expected number of steps until the mouse is either trapped or gets to the cheese?

#To find the amount of steps until it is absorbed, use the formula I-Q
tM = t(tM)

Q = tM[-c(8,10,16),-c(8,10,16)] #Removes the absorbing states from the matrix, since they will not be used
  
IminusQ = solve(diag(rep(1,13))-Q)

sum(IminusQ[,1])

#4. Using the swiss data set built into r,

#(a) Determine which of the following (Fertility, Agriculture, Examination, Catholic, Infant.Mortality)
#are significant when estimating Education with a linear model.

#Plot of Education vs Fertility, Agriculture, Examination, Catholic, and Infant.Mortality respectively:   

#View(swiss)
#pairs(swiss)
#Only Infant.Mortality is insignificant
#summary(lm(Education~., data = swiss))
plot(Education~Fertility, data = swiss)
fit1=lm(Education~Fertility, data = swiss)
abline(fit1,col="red")

plot(Education~Agriculture, data = swiss)
fit1=lm(Education~Agriculture, data = swiss)
abline(fit1,col="red")

plot(Education~Examination, data = swiss)
fit1=lm(Education~Examination, data = swiss)
abline(fit1,col="red")

plot(Education~Catholic, data = swiss)
fit1=lm(Education~Catholic, data = swiss)
abline(fit1,col="red")

plot(Education~Infant.Mortality, data = swiss)
fit1=lm(Education~Infant.Mortality, data = swiss)
abline(fit1,col="red")


fit1=lm(Education~., data = swiss)#Need to use all variables
#summary(fit1)
#plot(fit1)

#The p-values of Fertility, Agriculture, Examination, Catholic, and Infant.Mortality respectively within the linear model:  


summary(fit1)$coefficients["Fertility","Pr(>|t|)"]

summary(fit1)$coefficients["Agriculture","Pr(>|t|)"]

summary(fit1)$coefficients["Examination","Pr(>|t|)"]

summary(fit1)$coefficients["Catholic","Pr(>|t|)"]

summary(fit1)$coefficients["Infant.Mortality","Pr(>|t|)"]


#Fertility, Agriculture, and Examination and Catholic are significant, as they are less than the alpha value (0.05).

#(b) Using only the variables that are significant, construct a multiple regression model to estimate Education.

model=lm(Education~Fertility+Agriculture+Examination+Catholic, data = swiss)
summary(model)
#plot(model)

#(c) Estimate the education level for a draftee using only the significant variables from the full list
#of variables and the values below.

#Fertility 60.00  
#Agriculture 55.00  
#Examination 20.00  
#Catholic 4.15  
#Infant.Mortality 15.20  

#Significant variables:  

df = data.frame(Fertility=60, Agriculture =55, Examination=20, Catholic=4.15)
df

#Estimated education level:  

predict(model,newdata=df)


#5. Let X1, X2, . . . be iid normal random variables with mean 100 and sd 15.

#(a) What is P (85 < X1 < 115)?

#Normal Distribution
p = pnorm(115,100,15) - pnorm(85,100,15)
p

#(b) If we take a random sample of 20 of these rv’s, what is the probability that at least 15 of these random variables will fall between 85 and 115?

#Binomial Distribution
#1 - the prob that 14 rv's or under fall between 85 and 115
#or just add all the dbinom
1-pbinom(14,20,p)

#(c) If we take one rv at a time and we let Y be the first time that a rv’s value falls within [85, 115].

#i. What is the distribution of Y ?

#Y is a geometric distribution as it is performed until the 1st success (a value within [85, 115]), the trials are independent, the result is either success or failure, and each trial has the same probability of success.

#ii. What is the mean number of rv’s needed to get a value in [85,115]?

#The mean of a geometric distribution is given by 1/p, p being the probability of success:  

#Geometric Distribution
1/p
