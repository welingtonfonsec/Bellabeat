#Carregando Pacotes

library(tidyverse)
library(lubridate)
library(dplyr)
library(ggplot2)
library(tidyr)




## Importando datasets

atividade <- read.csv("C:/Users/welin/Desktop/GOOGLE/Estudos de caso/2/bellabeat/dailyActivity_merged.csv")
calorias <- read.csv("C:/Users/welin/Desktop/GOOGLE/Estudos de caso/2/bellabeat/hourlyCalories_merged.csv")
intensidade <- read.csv("C:/Users/welin/Desktop/GOOGLE/Estudos de caso/2/bellabeat/hourlyIntensities_merged.csv")
sono <- read.csv("C:/Users/welin/Desktop/GOOGLE/Estudos de caso/2/bellabeat/sleepDay_merged.csv")
peso <- read.csv("C:/Users/welin/Desktop/GOOGLE/Estudos de caso/2/bellabeat/weightLogInfo_merged.csv")


head(atividade)
head(calorias)
head(intensidade)
head(sono)
head(peso)


Antes de começar a exploração, foram identificadas colunas que exibem data e hora fora de padrão ("ActivityHour", "ActivityDate" e "SleepDay") . 

# Ajustando a formatação de data e hora 

# intensities
intensidade$ActivityHour=as.POSIXct(intensidade$ActivityHour, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
intensidade$time <- format(intensidade$ActivityHour, format = "%H:%M:%S")
intensidade$date <- format(intensidade$ActivityHour, format = "%m/%d/%y")
# calories
calorias$ActivityHour=as.POSIXct(calorias$ActivityHour, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
calorias$time <- format(calorias$ActivityHour, format = "%H:%M:%S")
calorias$date <- format(calorias$ActivityHour, format = "%m/%d/%y")
# activity
atividade$ActivityDate=as.POSIXct(atividade$ActivityDate, format="%m/%d/%Y", tz=Sys.timezone())
atividade$date <- format(atividade$ActivityDate, format = "%m/%d/%y")
# sleep
sono$SleepDay=as.POSIXct(sono$SleepDay, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
sono$date <- format(sono$SleepDay, format = "%m/%d/%y")


#Aparentemente temos dados prontos para exploração.


## Explorando e resumindo dados

n_distinct(atividade$Id)
n_distinct(calorias$Id)
n_distinct(intensidade$Id)
n_distinct(sono$Id)
n_distinct(peso$Id)

### Percepções

#Temos 33 usuários nos datasets de atividade, calorias e intensidade. 
#24 usuários no dataset de sono e apenas 8 de peso. 
#Temos um conjunto de dados minúculo e diante dessas informações, os 
#dados de peso não são significativos para fazer recomendações e conclusões. 


## Estatísticas resumidas dos conjuntos de dados:
  
# Atividade
  atividade %>%  
  select(TotalSteps,
         TotalDistance,
         SedentaryMinutes, Calories) %>%
  summary()

# Explorando minutos ativos por categoria:
  atividade %>%
  select(VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes) %>%
  summary()

# calorias
calorias %>%
  select(Calories) %>%
  summary()
# sono
sono %>%
  select(TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed) %>%
  summary()
# peso
peso %>%
  select(WeightKg, BMI) %>%
  summary()

## Percepções

#Temos que, segundo a média, a maioria dos participants são "lightly active" (levemente ativos).

#O tempo médio sedentário é de 991 minutos ou 16 horas. Segundo o Australian 
#Physical Activity and Sedentary Behaviour Guidelines, ser sedentário não é o 
#mesmo que não praticar atividade física suficiente. Mesmo se você estiver fazendo 
#bastante atividade física, ficar sentado por mais de 7 a 10 horas por dia pode ser  
#ruim para sua saúde. Os usários da pesquisa ultrapassam bastante esse número. 
#Link da pesquisa sobre sedentarismo
#https://www.health.gov.au/topics/physical-activity-and-exercise/physical-activity-and-exercise-guidelines-for-all-australians?utm_source=health.gov.au&utm_medium=callout-auto-custom&utm_campaign=digital_transformation


#A média total de passos por dia dos usuários pesquisados é de 7.638, um pouco menos para ter benefícios 
#para a saúde, de acordo com a pesquisa do Centers for Disease Control and Prevention (CDC). Eles descobriram que dar 8.000 
#passos por dia estava associado a um risco 51% menor de mortalidade por todas 
#as causas (ou morte por todas as causas). Dar 12.000 passos por dia foi 
#associado a um risco 65% menor em comparação com dar 4.000 passos.
#link da pesquisa dos passos. 
#https://www.medicalnewstoday.com/articles/how-many-steps-should-you-take-a-day#for-general-health


#Em média, os participants dormem 419.5 minutos ou praticamente 7 horas por noite.
#Segundo o American Academy of Sleep Medicine (AASM) e Sleep Research Society (SRS)  
#é recomendado que os adultos tenham sete ou mais horas de sono por noite para evitar 
#os riscos à saúde de sono inadequado crônico.
#link da pesquisa do sono
#https://aasm.org/seven-or-more-hours-of-sleep-per-night-a-health-necessity-for-adults/



## Mesclando dados

dados_mesclados <- merge(sono, atividade, by=c('Id', 'date'))
head(dados_mesclados)
view(dados_mesclados)

#Consideração importante aqui:

#Poderia ser usada a função "rbind()" para combinar as tabelas, 
#mas a função "merge()" optimiza isso, pois ela combina e 
#não repete colunas. Bem semelhante a um JOIN em SQL;

#A função "merge()" trouxe as colunas "date" e "id" sem que ocorram repetições;

#Poderiamos usar todas as colunas do estudo de caso, mas por serem mais completas,
#a decisão de mesclar os datasets "sono" e "atividade" é mais assertada. Além de 
#reduzir o tamanho e ganhar desempenho.


#Conversões

# Criando novas colunas que representam valores originais em minutos para horas:

dados_mesclados$TotalHoursAsleep <- dados_mesclados$TotalMinutesAsleep / 60
dados_mesclados$TotalHoursInBed <- dados_mesclados$TotalTimeInBed / 60
dados_mesclados$SedentaryHours <- dados_mesclados$SedentaryMinutes / 60

view(dados_mesclados)

# Criando a coluna que mostra em quanto tempo após deitar, o indivíduo dorme. (Latência do Sono):

dados_mesclados$SleepLatency <- dados_mesclados$TotalTimeInBed - dados_mesclados$TotalMinutesAsleep
view(dados_mesclados)

summary(dados_mesclados$SleepLatency)


#percepções
#Embora a amostra seja pequena, temos que os números dos participantes do estudo estão
#acima do recomendado. Enquanto uma latência do sono inferior a oito minutos pode 
#indicar um distúrbio do sono como a narcolepsia, as pessoas que demoram mais de 20 minutos 
#para adormecer podem ter insônia. Logo, uma latência entre 8 e 20 minutos é o ideal.
#A média dos pesquisados é de 39 minutos. 

LINK DE ESTUDO DA LATENCIA
https://www.sleepfoundation.org/how-sleep-works/sleep-latency#:~:text=Sleep%20latency%2C%20or%20sleep%20onset,20%20minutes%20to%20fall%20asleep.


# Agrupando por meio de médias cada registro nas categorias de "Sedentary", "Lightly Active", "Fairly Active", "Very Active". 

dados_tipo_usuario <- dados_mesclados %>%
  summarise(
    user_type = factor(case_when(
      SedentaryMinutes > mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Sedentary",
      SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes > mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Lightly Active",
      SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes > mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Fairly Active",
      SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes > mean(VeryActiveMinutes) ~ "Very Active",
    ),levels=c("Sedentary", "Lightly Active", "Fairly Active", "Very Active")), Calories, .group=Id) %>%
  drop_na()

#Esse agrupamento foi feito para ser exibido graficamente mais a frente.

# Criando a coluna dia da semana

dados_mesclados$dia_semana <- weekdays(as.Date(dados_mesclados$SleepDay))




view(dados_mesclados)



## Visualização


# Distribuição dos registros por tipo de usuário

dados_tipo_usuario %>%
  group_by(user_type) %>%
  summarise(total = n()) %>%
  mutate(totals = sum(total)) %>%
  group_by(user_type) %>%
  summarise(total_percent = total / totals) %>%
  ggplot(aes(user_type,y=total_percent, fill=user_type)) +
  geom_col()+
  scale_y_continuous(labels = scales::percent) +
  theme(legend.position="none") +
  labs(title="User type distridution", x=NULL) +
  theme(legend.position="none", text = element_text(size = 20),plot.title = element_text(hjust = 0.5))

#Percepções

# Esse agrupamento não tem como intenção definir o usuário como pertencente
# a determinada categoria. Mas apenas definir o registro diário. Por exemplo,
# um determinado usuário pode ter hoje um registro de atividade diária
# como sedentário e amanhã como muito ativo.

# Segundo o gráfico, temos que os usuários se comportam na maior parte dos
# registros como sendentários e levemente ativos. Juntos somam mais de 80%.

# A Bellabeat pode usar essa informação para mostrar ao usuário qual a categoria
# que seu dia foi alocada e dar dicas de como manter ou melhorar a situação.
# Exemplo: usuário teve dia classificado como sedentário, a Bellabeat o notifica.




# Relação quantidade de passos X calorias queimadas

ggplot(dados_mesclados, aes(x=TotalSteps, y=Calories)) + 
  geom_point() + geom_smooth() + 
  labs(title="Calorias Queimadas X Total de Passos", x="Total de Passos", y="Calorias queimadas")

#Percepções

#Quantos mais passos dados, mais calorias queimadas. Aqui não há nada de novo,
#essa correlação positiva é algo óbvio. Mas do ponto de vista analítico é um 
#item importante para a validação da qualidade dos dados da pesquisa. 


# Relação tempo na cama X tempo de sono efetivo

ggplot(data=dados_mesclados, aes(x=TotalMinutesAsleep, y=TotalTimeInBed)) + 
  geom_point() + geom_smooth() + 
  labs(title="Minutos na Cama X Minutos Dormindo", x="Horas Dormindo", y="Horas na Cama")


#Percepções

# Essa relação implica dizer que quanto mais tempo os usuários passaram na cama,
#mais horas de sono tiveram. O que se conclui que os individuos do estudo tem grandes
#chances de melhorar a quantidade sono ao irem deitar mais cedo. Mais uma vez
#há nada de novo aqui, mas existe uma janela de oportunidade para o aplicativo e/ou
#o smartwash entrarem em cena e alertar o usuário para que se prepare para dormir em
#um horário otimizado de acordo com sua rotina.


# Horário Médio das Atividades Físicas 

intensidade_horario_medio <- intensidade %>%
  group_by(time) %>%
  drop_na() %>%
  summarise(mean_total_int = mean(TotalIntensity))

ggplot(data=intensidade_horario_medio, aes(x=time, y=mean_total_int)) + geom_histogram(stat = "identity", fill='darkblue') +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title="Horário Preferido")

# Percepções

# Ao criar um novo dataset filtrando apenas a quantidade média de exercicios por horário,
# é perceptivel que, em média, a prática de execício das pessoas tem uma crescente 
# das 5 às 19 horas. Após isso, vai decaindo até entrar na madrugada. Acredito que esse 
# dado pode ser util para que o aplicativo e/ou o smartwash indicar uma probabilidade de
# quais horários, por exemplo, a academia tem chances de estar lotada ou não. Isso pode
# ajudar tanto uma pessoa que quer socializar ou não. Ou até otimizar o tempo gasto na 
# academia. Mas obviamente isso pode ser aprimorado com outras variáveis, 
# como dados de localização, por exemplo.

# O aplicativo com essa informação e cruzando com outros dados pessoais
# do cotidiano, pode eleger o horário chave para notificar o usuário para 
# ir fazer a atividade física.


# Relação de qualidade do sono e tempo sedentário


ggplot(data=dados_mesclados, aes(x=TotalMinutesAsleep, y=SedentaryMinutes)) + 
  geom_point(color='darkblue') + geom_smooth() +
  labs(title="Minutos Dormindo X Minutos Sedentários")

ggplot(data=dados_mesclados, aes(x=SleepLatency, y=SedentaryMinutes)) + 
  geom_point(color='darkblue') + geom_smooth() +
  labs(title="Minutos Sedentário X Latência de sono (minutos)")

# Percepções 

# Aqui é claramente é notificado o estrago que o sedentarismo pode ter sobre
# a qualidade de sono. Ambos os gráficos mostram a relação negativa do sedentarismo
# tanto com a latência do sono (tempo até adormecer após deitado) quanto com o tempo 
# de fato dormindo. 

# A oportunidade para a Bellabeat seria notificar o usuário quando ele passar
# muito tempo sedentário. Para assim ele se movimentar de alguma forma.

# Importante: É necessário apoiar esses insights com mais dados e variáveis,
# pois correlação não significa causa. 



# Relacionando as intensidades de atividade física como sono

ggplot(data=dados_mesclados, aes(x=TotalMinutesAsleep, y=LightlyActiveMinutes)) + 
  geom_point(color='darkblue') + geom_smooth() +
  labs(title="Levemente Ativo (minutos) X Tempo de sono (minutos)")


ggplot(data=dados_mesclados, aes(x=TotalMinutesAsleep, y=FairlyActiveMinutes)) + 
  geom_point(color='darkblue') + geom_smooth() +
  labs(title="Consideravelmente Ativo (minutos) X Tempo de sono (minutos)")

ggplot(data=dados_mesclados, aes(x=TotalMinutesAsleep, y=VeryActiveMinutes)) + 
  geom_point(color='darkblue') + geom_smooth() +
  labs(title="Muito Ativo (minutos) X Tempo de sono (minutos)")

# Percepções
# Ao examinar essas variaveis, esperava-se uma correlação de quanto mais intensa é 
# a atividade fisica, maior seria qualidade do sono. 
# Mas isso não foi claramente constatado diante dos dados disponíveis.


# Relacionando as intensidades de atividade física com a latência

ggplot(data=dados_mesclados, aes(x=SleepLatency, y=LightlyActiveMinutes)) + 
  geom_point(color='darkblue') + geom_smooth() +
  labs(title="Levemente Ativo (minutos) X Latência do sono (minutos)")

ggplot(data=dados_mesclados, aes(x=SleepLatency, y=FairlyActiveMinutes)) + 
  geom_point(color='darkblue') + geom_smooth() +
  labs(title="Consideravelmente Ativo (minutos) X Latência do sono (minutos)")

ggplot(data=dados_mesclados, aes(x=SleepLatency, y=VeryActiveMinutes)) + 
  geom_point(color='darkblue') + geom_smooth() +
  labs(title="Muito Ativo (minutos) X Latência do sono (minutos)")

# Percepções
# Era esperada uma correlação mais forte de que quanto mais intensa
# for a atividade fisica, menos tempo um indivíduo gasta para adormecer.
# Porém, de acordo com os dados disponíveis, essa correlação não foi encontrada.


# Passos e tempo sedentário por dia da semana

# Passos por dia da semana

media_totalsteps <- aggregate(TotalSteps ~ dia_semana, data = dados_mesclados, FUN = mean)

grafico_media_totalsteps <- ggplot(media_totalsteps, aes(x = dia_semana, y = TotalSteps)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(title = "Média de Total de Passos x Dia da Semana",
       x = "Dia da Semana",
       y = "Média de Total de Passos") +
  theme_minimal()

print(grafico_media_totalsteps)

# Minutos sedentárias por dia da semana

media_sedentary <- aggregate(SedentaryMinutes ~ dia_semana, data = dados_mesclados, FUN = mean)

grafico_media_sedentary <- ggplot(media_sedentary, aes(x = dia_semana, y = SedentaryMinutes)) +
  geom_bar(stat = "identity", fill = "red") +
  labs(title = "Média de Minutos Sedentários x Dia da Semana",
       x = "Dia da Semana",
       y = "Média de Minutos Sedentários") +
  theme_minimal()

print(grafico_media_sedentary)


# Percepções

# Os gráficos de barras mostram que o sábado é o dia ótimo. Pois em média, é
# o que mais os usuários dão passos e o que menos tem minutos sendentários.
# # Informação útil para o aplicativo notificar de uma maneira mais assertiva
# o usuário a fazer exercicios em dias em que historicamente ele não tem 
# bons números de atividades fisicas e sedentarismo.



# Calorias Queimadas por Total de Passos

ggplot(data=dados_mesclados, aes(x = TotalSteps , y = Calories, color = SedentaryMinutes)) +
  geom_point() + 
  stat_smooth(method = lm) +
  scale_color_gradient(low = "blue", high = "red") +
  labs(title = "Calorias Queimadas X Passos",
       x = "Total de Passos",
       y = "Calorias Queimadas")

# Percepções 

# Quantos mais passos uma pessoa dá, mais ativa e mais calorias ela queimará.
# Isso é uma uma certeza que é observada no gráfico. Mas indo além, e relacionando
# com a variavel "Sedentary Minutes", é evidenciado alguns usuários claramente sedentários
# queimando mais calorias do que os mais ativos.

# Isso pode ser usado a título de incentivo pela Bellabeat aos seus usuários mais
# sedentários. 


##Conclusão e recomendações

###Conclusões da análise:

#Na análise dos dados, os usuários se comportaram na maior parte dos registros como sedentários e levemente ativos. Com uma pequena vantagem dos sedentários. Juntos somam mais de 80%;
#O tempo médio diário que os usuários passaram em estado de sedentarismo é de 991 minutos ou 16 horas;
#Em média, os participantes dormiram 419.5 minutos ou praticamente 7 horas por noite;
#A média de tempo entre deitar na cama e adormecer (latência do sono) que os pesquisados gastaram foi de 39 minutos;
#Dentre os dados da pesquisa, em média, o dia ótimo quando levado em consideração o maior número de passos e as menor quantidade de minutos sedentários, foi o sábado. A sexta foi o dia mais sedentário de todos.
#A prática de exercícios físicos dos usuários tiveram trajetória ascendente entre às 5 e 19 horas. Após isso, decaiu até entrar na madrugada. O pico aconteceu às 18 horas. Às 3 da madrugada é o horário de menor atividade;
#Foi evidenciada uma correlação negativa entre o tempo que os usuários passaram sedentários e o tempo de sono. Ou seja, quanto mais sedentário, menos minutos de sono tiveram;
#Também foi evidenciada uma correlação negativa entre a latência do sono e o tempo que os usuários passam sedentários. Em outras palavras, quanto mais sedentário, mais os usuários demoraram para adormecer;
#Não foi identificada correlação entre o tipo de intensidade de exercícios e a quantidade minutos de sono. Quando relacionada com a latência, também não houve algo satisfatório.

###Recomendações para o aplicativo/smartwatch

#A Bellabeat pode usar a informação diária do usuário para mostrar qual a categoria que o dia foi alocada e dar dicas de como manter ou melhorar a situação.
#Podem ser criados alertas do aplicativo e/ou smartwatch para o usuário se preparar para dormir em um horário otimizado de acordo com informações de sua rotina;
#De acordo com informações do usuário, o aplicativo pode eleger o horário chave para notificar o usuário para ir fazer a atividade física;
#Notificar o usuário quando ele passar muito tempo sedentário. Para assim ele se movimentar de alguma forma;
#Incentivar de uma maneira mais assertiva o usuário a fazer exercícios em dias em que historicamente ele não tem bons números de atividades físicas e sedentarismo.
#De acordo com as opções de estilo de vida e desejos do usuário e cruzando com informações de peso e IMC, o aplicativo pode ajudar no controle do consumo de calorias sugerindo opções de alimentos de ganho de massa ou de perda de gordura, por exemplo.
#Possibilitar aos usuários comparar seu desempenho com usuários de perfil similar.

###Recomendações de marketing para expansão global:

#Obter mais variáveis e uma amostra de dados maior para uma análise mais precisa;
#No estudo foi evidenciado vários casos de usuários sedentários com um gasto calórico maior do que usuários que praticam atividades físicas. O aplicativo poderia utilizar informações como essa a título de incentivo.
#Campanha educativa de estilo saudável para incentivar os usuários a fazerem exercícios ativos curtos durante a semana, mais longos nos finais de semana. Especificamente onde historicamente a incidência é baixa;
#A campanha educacional do item anterior pode ser combinada com um sistema de incentivo de premiação de pontos. Os usuários que completarem o exercício da semana inteira receberão pontos Bellabeat em produtos/assinaturas;
#Fazer parcerias com eventos esportivos, e usar a tecnologia Bellabeat para monitorar atletas durante as competições.
#Patrocinar atletas para que eles usem a tecnologia e exponham a qualidade.
