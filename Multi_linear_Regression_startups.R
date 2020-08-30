startup=read.csv("C:/Users/Shinkar/Desktop/vss 2020/Excelr/Assignments/Multi linear Regression/50_Startups.csv")
startup
attach(startup)
summary(startup)
pairs(startup)
library(dummies)
dummy_data_state=dummy(startup$State,sep="_")
data=cbind(startup[,-4],dummy_data_state)
summary(data)
pairs(data)
cor(data)
library(corpcor)
cor2pcor(cor(data))
model.startup<-lm(Profit~.,data=data)
summary(model.startup)
model.startupA<-lm(Profit~Administration,data)
summary(model.startupA) #insignificant
model.startupM<-lm(Profit~Marketing.Spend)
summary(model.startupM) #Significant
model.startupS<-lm(Profit~State_California+State_Florida+State_New_York,data)
summary(model.startupS) #insignificant
model.startupAS<-lm(Profit~Administration+State_California+State_Florida+State_New_York,data)
summary(model.startupAS) #both insignificant
model.startupAM<-lm(Profit~Administration+Marketing.Spend)
summary(model.startupAM) #both significant
model.startupMS<-lm(Profit~Marketing.Spend+State_California+State_Florida+State_New_York,data)
summary(model.startupMS) #Only marketing is significant
library(car)
influenceIndexPlot(model.startup,id.n=3)
influencePlot(model.startup,id.n=3)
#Regression after deleting 50th observation
model.startup1<-lm(Profit~.,data=data[-50,])
summary(model.startup1)
#Regression after deleting 50th and 49th observation
model.startup2<-lm(Profit~.,data=data[-c(49,50),])
summary(model.startup2)
#Regression after deleting 50th,49th,46th observation
model.startup3<-lm(Profit~.,data=data[-c(46,49,50),])
summary(model.startup3)
#Still all are not significant. So,we delete Administration
model.startup4<-lm(Profit~R.D.Spend+Marketing.Spend+State_California+State_Florida+State_New_York,data[-c(49,50,46),])
summary(model.startup4)
#Still all are not significant. So,we delete States
model.startup5<-lm(Profit~R.D.Spend+Marketing.Spend+log(Administration),data[-c(49,50,46),])
summary(model.startup5)
#Still all are not significant. So,we delete Administration and States
final_model<-lm(Profit~R.D.Spend+Marketing.Spend,data[-c(49,50,46),])
summary(final_model)
vif(final_model)
avPlots(final_model)
influenceIndexPlot(final_model,id.n=3)
sqrt(mean(final_model$residuals**2))
install.packages("caTools")
library(caTools)
startup1<-data[-c(49,50,46),]
split<-sample.split(startup1$Profit,SplitRatio=0.70)
split
table(split)
startup1.train<-subset(startup1,split==TRUE)
startup1.test<-subset(startup1,split==FALSE)

#Building training model
model.train<-lm(Profit~R.D.Spend+Marketing.Spend,startup1.train)
summary(model.train)
sum(model.train$residuals)
mean(model.train$residuals)
training_RMSE<-sqrt(mean(model.train$residuals**2))
training_RMSE

#Predicting test data
predtest<-predict(model.train,startup1.test[,-Profit])
predtest
testing_error<-startup1.test$Profit-predtest

test_RMSE<-sqrt(mean(testing_error**2))
test_RMSE
training_RMSE
