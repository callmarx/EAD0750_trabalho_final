## Carregar a base filtrada pelo Ruby
enem_2018 <- read.table('./data/enem.2018.sao_paulo.19anos.csv', sep = ",", header = TRUE)


## restringe a categoria de formação educacional do pai para binário:
##  até ensino médio ou pelo menos graduação
levels(enem_2018$Q001) <- c('0','0','0','0','0','1','1')
enem_2018$Q001 <- as.numeric(levels(enem_2018$Q001))[enem_2018$Q001]

## restringe a categoria de formação educacional do mãe para binário:
##  até ensino médio ou pelo menos graduação
levels(enem_2018$Q002) <- c('0','0','0','0','0','1','1')
enem_2018$Q002 <- as.numeric(levels(enem_2018$Q002))[enem_2018$Q002]

## Transformar as labels em valor maximo do intervalo que representa
enem_2018$Q006 <- factor(enem_2018$Q006, 
			 levels =  c('B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q'),
			 labels= c('954',
				  '1431',
				  '1908',
				  '2385',
				  '2862',
				  '3816',
				  '4770',
				  '5724',
				  '6678',
				  '7632',
				  '8586',
				  '9540',
				  '11448',
				  '14310',
				  '19.080',
				  '40.000'))
## altera a label aplicado pelo seu valor numerico
enem_2018$Q006 <- as.numeric(levels(enem_2018$Q006))[enem_2018$Q006]

## alterar a label de caracter para numerico
levels(enem_2018$Q025) <- c('0','1')
enem_2018$Q025 <- as.numeric(levels(enem_2018$Q025))[enem_2018$Q025]

## restringe a categoria de escola publica, privada, parcial, com ou sem bolsa para binario:
##  somente escola publica ou parte/integral em escola particular (com ou sem bolsa)
levels(enem_2018$Q027) <- c('0','1','1','1','1')
enem_2018$Q027 <- as.numeric(levels(enem_2018$Q027))[enem_2018$Q027]

## Normalize a variavel de renda para que ela fique no intervalo [0,1]
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}
enem_2018$Q006 <- normalize(enem_2018$Q006)

## Data.frame que será utilizado pelo kNN
enem_math <- enem_2018

## Divide a nota de matematica em quartis
library(gtools)
enem_math$NU_NOTA_MT <- quantcut(enem_math$NU_NOTA_MT, q=4)
## Restringe os quartis à binário:
## 0 - primeiro e segundo quartil, 1 - terceiro e quarto quartil
levels(enem_math$NU_NOTA_MT) <- c('0','0','1','1')

## escolhe, aleatoriamente, 80% das observações para treino e 20% para teste
set.seed(364)
sample <- sample(nrow(enem_math),floor(nrow(enem_math)*0.8))

train <- enem_math[sample,]
test <- enem_math[-sample,]

## Verifica se as propoções da nota de matemática (agora binária) estão
## de acordo
prop.table(table(enem_math$NU_NOTA_MT))
prop.table(table(train$NU_NOTA_MT))
prop.table(table(test$NU_NOTA_MT))

train_knn <- train[-c(6)]
test_knn <- test[-c(6)]

## Aplica o kNN
library(class)
pred <- knn(train_knn, test_knn, train$NU_NOTA_MT, k = 5)


#Verificação dos resultados
library(gmodels)
CrossTable(x = test$NU_NOTA_MT, y = pred, prop.chisq = FALSE)

library(caret)
confusionMatrix(pred, test$NU_NOTA_MT)


# verifica as correlações das variaveis com NU_NOTA_MT
cor.test(enem_2018$Q001,enem_2018$NU_NOTA_MT)
cor.test(enem_2018$Q002,enem_2018$NU_NOTA_MT)
cor.test(enem_2018$Q006,enem_2018$NU_NOTA_MT)
cor.test(enem_2018$Q025,enem_2018$NU_NOTA_MT)
cor.test(enem_2018$Q027,enem_2018$NU_NOTA_MT)


