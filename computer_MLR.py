import pandas as pd
import numpy as np
import matplotlib as plt
computer=pd.read_csv("C:\\Users\\Shinkar\\Desktop\\vss 2020\\Excelr\\Assignments\\Multi linear Regression\\Computer_Data (1).csv")
computer.head()
#pd.get_dummies(computer.cd,prefix='cd')
#computer.head()
#computer['cd_dummy']=computer.cd.map({'yes':1,'no':0})
computer1=pd.get_dummies(computer,columns=['cd','multi','premium'],drop_first=True)
computer1.head()
final_data=computer1.iloc[:,1:]
corr=final_data.corr()
corr #no collinearity

import seaborn as sns
sns.pairplot(final_data)
final_data.columns

import statsmodels.formula.api as smf # for regression model
ml1 = smf.ols('price~speed+hd+ram+screen+ads+trend+cd_yes+multi_yes+premium_yes',data=final_data).fit()
ml1.summary()  #R^2= 0.776
price_pred1= ml1.predict(final_data[['speed','hd','ram','screen','ads','trend','cd_yes','multi_yes','premium_yes']])
price_pred1
ml1r= smf.ols('price~speed+hd+ram+screen+ads+trend+cd_yes+multi_yes+premium_yes',data=final_data).fit().rsquared
vif1=1/(1-ml1r)
vif1
ml1_resid=price_pred1-final_data.price
ml1_rmse=np.sqrt(np.mean(ml1_resid**2))
ml1_rmse

ml2 = smf.ols('price~np.sqrt(speed)+np.sqrt(hd)+np.sqrt(ram)+screen+np.sqrt(ads)+trend+cd_yes+multi_yes+premium_yes',data=final_data).fit()
ml2.summary() #R^2=0.794
price_pred2= ml2.predict(final_data[['speed','hd','ram','screen','ads','trend','cd_yes','multi_yes','premium_yes']])
price_pred2
ml2r=smf.ols('price~np.sqrt(speed)+np.sqrt(hd)+np.sqrt(ram)+screen+np.sqrt(ads)+trend+cd_yes+multi_yes+premium_yes',data=final_data).fit().rsquared
vif2=1/(1-ml2r)
vif2
ml2_resid=price_pred2-final_data.price
ml2_rmse=np.sqrt(np.mean(ml2_resid**2))
ml2_rmse


ml3= smf.ols('price~np.log(speed)+np.log(hd)+np.log(ram)+screen+np.log(ads)+trend+cd_yes+multi_yes+premium_yes',data=final_data).fit()
ml3.summary() #R^2=  0.769
price_pred3= ml3.predict(final_data[['speed','hd','ram','screen','ads','trend','cd_yes','multi_yes','premium_yes']])
price_pred3
ml3r= smf.ols('price~np.log(speed)+np.log(hd)+np.log(ram)+screen+np.log(ads)+trend+cd_yes+multi_yes+premium_yes',data=final_data).fit().rsquared
vif3=1/(1-ml3r)
vif3
ml3_resid=price_pred3-final_data.price
ml3_rmse=np.sqrt(np.mean(ml3_resid**2))
ml3_rmse
    

import statsmodels.api as sm
#sm.graphics.plot_partregress_grid(ml2)

#We use second model.
from sklearn.model_selection import train_test_split
computer_train,computer_test=train_test_split(final_data,test_size=0.3) # 30% size

model_train = smf.ols("price~np.sqrt(speed)+np.sqrt(hd)+np.sqrt(ram)+screen+np.sqrt(ads)+trend+cd_yes+multi_yes+premium_yes",data=computer_train).fit()

train_pred= model_train.predict(computer_train)

train_resid= train_pred-computer_train.price

train_rmse= np.sqrt(np.mean(train_resid*train_resid))
train_rmse

test_pred=model_train.predict(computer_test)

test_resid=test_pred-computer_test.price

test_rmse=np.sqrt(np.mean(test_resid*test_resid))
test_rmse
