m1 <- 16
n1 <- 14964
m2 <- 62
n2 <- 4902
p1 <- m1/n1
p2 <- m2/n2
eff1 <- 1-p1/p2
cat( "Efficiency:", eff1, " Rounded:", sprintf("%.1f", 100*eff1))

test1 <- rbinom(10000,n1, p1)
test2 <- rbinom(10000,n2, p2)
cat( "Sim. means 1,2 (model1): ", mean(test1)/n1, "  ", mean(test2)/n2)

test_eff <- 1- (test1/n1)/(test2/n2)
cat( "Sim. efficiency mean (model1)", sprintf("%.1f", 100*mean(test_eff)))

alf1 <- 0.05
cat( "95%CI  (model1)", sprintf("%.1f", 100*quantile( test_eff, c(alf1/2, 1-alf1/2))))


##Размывание, учитывающее точность определения вероятностей, 
##в нулевом приближении для распреления частот принимаем нормальное распределение
sd1 <- sqrt(p1*n1)/n1
sd2 <- sqrt(p2*n2)/n2

testp1 <- rnorm(1000, p1, sd1)
testp2 <- rnorm(1000, p2, sd2)
test1a <- unlist( lapply( testp1, function(x){ rbinom(100,n1, x)}))
test2a <- unlist( lapply( testp2, function(x){ rbinom(100,n2, x)}))
cat( "Sim. means 1,2  (model2):",  mean(test1a)/n1, " ", mean(test2a)/n2)

test_eff2 <- 1- (test1a/n1)/(test2a/n2)
cat( "Sim. efficiency mean (model2)", sprintf("%.1f", 100*mean(test_eff2)))
cat( "95%CI (model2)", sprintf("%.1f", 100*quantile( test_eff2, c(alf1/2, 1-alf1/2))))

library(ggplot2)
ggplot( data.frame( eff2=test_eff2), aes(x=eff2))+
  stat_ecdf(aes(x=eff2, color="Efficiency ECF"))+
  theme_minimal() +
  xlim(0.7,1)+ scale_color_manual(values = c("#E7B800")) +
  ggtitle("Monte-Carlo estimate of CDF of Gam-Covid-Vac efficiency") + 
  xlab("Efficiency") +
  ylab( "CDF") + labs(color="Legend") +
  geom_hline(yintercept = alf1/2, linetype= "dotted") +
  geom_hline(yintercept = 1-alf1/2, linetype= "dotted")
  
