computer=read.csv("C:/Users/Shinkar/Desktop/vss 2020/Excelr/Assignments/Multi linear Regression/Computer_Data (1).csv")
computer
attach(computer)
summary(computer)
library(dummies)
computer$cdcode[computer$cd=="no"]<-0
computer$cdcode[computer$cd=="yes"]<-1
computer$multicode[computer$multi=="no"]<-0
computer$multicode[computer$multi=="yes"]<-1
computer$premiumcode[computer$premium=="no"]<-0
computer$premiumcode[computer$premium=="yes"]<-1
#dummy_data_cd=ifelse(computer[,7]=="no",0,ifelse(computer[,7]=="yes",1))
#dummy_data_cd=dummy(computer$cd,sep="_")
#dummy_data_multi=dummy(multi,sep = "_")
#dummy_data_premium=dummy(premium,sep = "_")
#dummy_data=cbind(computer,dummy_data_cd,dummy_data_multi,dummy_data_premium)
#View(dummy_data)
final_data=computer[,-c(1,7,8,9)]
head(final_data)
pairs(final_data)
cor(final_data)
#There is no problem of Collinearity.
library(GGally)
library(stringi)
ggpairs(final_data) 

#Partial Correlation matrix- Pure correlation between the variables.
library(corpcor)
cor2pcor(cor(final_data))

#Linear model
model.computer<-lm(price~.,data=final_data)
summary(model.computer) #R^2= 0.7756 
library(car)
mean(model.computer$residuals)
sqrt(mean(model.computer$residuals**2)) #RMSE=  275.1298
vif(model.computer)
avPlots(model.computer)
#influence.measures(model.computer)
#influenceIndexPlot(model.computer,id.n=3)
#influencePlot(model.computer,id.n=3)
#model.computer1<-lm(price~.,data=final_data[-1701,])
#summary(model.computer1)

#sqrt transformation
computer_sqrt<-lm(price~sqrt(speed)+sqrt(hd)+ram+sqrt(trend)+screen+sqrt(ads)+cdcode+multicode+premiumcode,data = final_data)
summary(computer_sqrt) # R^2= 0.7895
library(car)
vif(computer_sqrt)
avPlots(computer_sqrt)
mean(computer_sqrt$residuals)
sqrt(mean(computer_sqrt$residuals**2)) #RMSE= 266.4796

#log transformation
computer_log<-lm(price~log(speed)+log(hd)+ram+log(trend)+screen+log(ads)+cdcode+multicode+premiumcode,data = final_data)
summary(computer_log) #R^2= 0.7775
vif(computer_log)
avPlots(computer_log)
mean(computer_log$residuals)
sqrt(mean(computer_log$residuals**2)) #RMSE= 273.9625

#Splitting the data into train and test
library(caTools)
split<-sample.split(computer$price,SplitRatio = 0.70)
split
table(split)
computer.train<-subset(computer,split==TRUE)
computer.test<-subset(computer,split==FALSE)
model.train<-lm(price~sqrt(speed)+sqrt(hd)+ram+sqrt(trend)+screen+sqrt(ads)+cdcode+multicode+premiumcode,computer.train)
summary(model.train) #R^2=  0.7857
sum(model.train$residuals)
mean(model.train$residuals)
training_RMSE<-sqrt(mean(model.train$residuals**2))
training_RMSE #RMSE= 270.1825
plot(model.train)

predtest<-predict(model.train,computer.test[,-price])
predtest

testing_error<-computer.test$price-predtest

test_RMSE<-sqrt(mean(testing_error**2))
test_RMSE #RMSE=257.6144
