## Índice

[1. Introdução](#introdução)

[2. Tarefa de Negócios](#tarefa-de-negócios)

[3. Dados](#dados)

[4. Processamento e Exploração](#processamento-e-exploração)

[5. Análise e Visualização](#análise-e-visualização)

[6. Conclusão e recomendações](#conclusão-e-recomendações)

## Introdução

Este estudo de caso foi elaborado pela Google em parceria com a Coursera, como projeto final para obtenção do [Certificado Profissional Google Data Analytics](https://grow.google/certificates/data-analytics/#?modal_active=none). O cenário consiste na análise dos dados fornecida pela empresa [Bellabeat](https://bellabeat.com/).

Fundada em 2013, a Bellabeat é uma empresa de alta tecnologia que desenvolve dispositivos de rastreamento de bem-estar para mulheres. Em 2016, a Bellabeat lançou vários produtos e expandiu seus negócios globalmente. Os produtos passaram a ser disponibilizados em seu próprio canal de e-commerce, bem como em varejistas online. A Bellabeat se concentra extensivamente no marketing digital, incluindo a Pesquisa do Google, páginas ativas no Facebook e Instagram, além de engajar os consumidores de forma consistente no Twitter. Além disso, a Bellabeat exibe anúncios em vídeo no Youtube e anúncios gráficos na rede de display do Google para apoiar campanhas em datas importantes de marketing.

Bellabeat possui 5 produtos:

Aplicativo Bellabeat: o aplicativo Bellabeat fornece aos usuários dados de saúde relacionados à sua atividade, sono, estresse, ciclo menstrual e hábitos de atenção plena. Ele ajuda os usuários a entender melhor seus hábitos atuais e a tomar decisões saudáveis.

Leaf: É uma smartwatch que funciona basicamente como um rastreador de bem-estar que pode ser usado como pulseira, colar ou clipe. Ele se conecta ao aplicativo Bellabeat para rastrear atividade, sono e estresse.

Time: este relógio de bem-estar combina a aparência atemporal de um relógio clássico com tecnologia inteligente para rastrear a atividade, o sono e o estresse do usuário. Ele se conecta ao aplicativo Bellabeat para fornecer informações sobre seu bem-estar diário.

Spring: Esta é uma garrafa de água que rastreia a ingestão diária de água usando tecnologia inteligente para garantir que você esteja adequadamente hidratado ao longo do dia. Ele se conecta ao aplicativo Bellabeat para monitorar seus níveis de hidratação.

Planos da Bellabeat: Bellabeat também oferece um programa de associação baseado em assinatura para usuários. Ele oferece aos usuários acesso 24 horas por dia, 7 dias por semana, a orientação totalmente personalizada sobre nutrição, atividade, sono, saúde e beleza e atenção plena com base em seu estilo de vida e objetivos.


Urška Sršen, Cofundadora e CEO da Bellabeat, sabe que uma análise dos dados de consumo disponíveis da Bellabeat revelaria mais oportunidades de crescimento. Ela pediu à equipe de análise de marketing para se concentrar em um produto da Bellabeat e analisar os dados de uso de dispositivos inteligentes para obter informações sobre como as pessoas já estão usando seus dispositivos inteligentes. Assim, por meio dessas informações, ela gostaria de conferir excelentes recomendações sobre como essas tendências podem nortear a estratégia de marketing da Bellabeat.

## Tarefa de negócios

  * Quais são algumas das tendências no uso de dispositivos inteligentes?
  * Como essas tendências podem se aplicar aos clientes da Bellabeat?
  * Como essas tendências podem ajudar a influenciar a estratégia de marketing da Bellabeat?

>**Objetivo**: Limpar, analisar e visualizar os dados para identificar oportunidades potenciais de crescimento e recomendações para a melhoria da estratégia de marketing da Bellabeat com base nas tendências de uso de dispositivos inteligentes.</p>


## Dados

* **Fonte de dados**: A [fonte de dados](https://www.kaggle.com/datasets/arashnic/fitbit) usada o estudo de caso é o FitBit Fitness Tracker Data. Este conjunto de dados está armazenado no Kaggle e foi disponibilizado através do Mobius;
* **Acessibilidade e privacidade de dados**: O proprietário dedicou o trabalho ao domínio público renunciando a todos os seus direitos sobre o trabalho em todo o mundo sob a lei de direitos autorais, incluindo todos os direitos relacionados e conexos, na medida permitida por lei. É possível copiar, modificar, distribuir e executar o trabalho, mesmo para fins comerciais, tudo sem pedir permissão.    
* **Tamanho e formato**: 18 arquivos no formato ```CSV``` (322 MB, descompactado);
* **Intervalo dos dados da análise**: Março de 2016 à Maio de 2016; 
* **Mais informações**: 
  * O conjunto de dados possui registros 30 usuários elegíveis do Fitbit que consentiram com o envio de dados pessoais do smartwatch, incluindo atividade física por minuto, frequência cardíaca e monitoramento do sono;
  * Cada usuário tem ID exclusivo;
  * Cada arquivo CSV apresenta diferentes dados quantitativos;
  * Os dados são registrados por dia e hora.
* **Pontos negativos** da base de dados: 
  * De início, e baseada em informações preeliminares, a base destacava 30 usuários. Mas com a analise, foram identificados 33;
  * É uma base de dados pequena;
  * Alguns usuários não registraram suas atividades em determinados momentos;
  * Dos 33 usuários, 24 registraram informações de sono e 8 de peso.

## Processamento e Exploração

### Carregando Pacotes:

```
library(tidyverse)
library(lubridate)
library(dplyr)
library(ggplot2)
library(tidyr)
```

Com os devidos pacotes carregados, a exploração pode seguir.

### Importando datasets

```
atividade <- read.csv("C:/Users/welin/Desktop/GOOGLE/Estudos de caso/2/bellabeat/dailyActivity_merged.csv")
calorias <- read.csv("C:/Users/welin/Desktop/GOOGLE/Estudos de caso/2/bellabeat/hourlyCalories_merged.csv")
intensidade <- read.csv("C:/Users/welin/Desktop/GOOGLE/Estudos de caso/2/bellabeat/hourlyIntensities_merged.csv")
sono <- read.csv("C:/Users/welin/Desktop/GOOGLE/Estudos de caso/2/bellabeat/sleepDay_merged.csv")
peso <- read.csv("C:/Users/welin/Desktop/GOOGLE/Estudos de caso/2/bellabeat/weightLogInfo_merged.csv")
```

Antes de começar a exploração, foram identificadas colunas que exibem data e hora fora de padrão ("ActivityHour", "ActivityDate" e "SleepDay"). 

### Ajustando a formatação de data e hora:

```
#Intensidade:
intensidade$ActivityHour=as.POSIXct(intensidade$ActivityHour, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
intensidade$time <- format(intensidade$ActivityHour, format = "%H:%M:%S")
intensidade$date <- format(intensidade$ActivityHour, format = "%m/%d/%y")
#Calorias:
calorias$ActivityHour=as.POSIXct(calorias$ActivityHour, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
calorias$time <- format(calorias$ActivityHour, format = "%H:%M:%S")
calorias$date <- format(calorias$ActivityHour, format = "%m/%d/%y")
# atividade:
atividade$ActivityDate=as.POSIXct(atividade$ActivityDate, format="%m/%d/%Y", tz=Sys.timezone())
atividade$date <- format(atividade$ActivityDate, format = "%m/%d/%y")
#Sono:
sono$SleepDay=as.POSIXct(sono$SleepDay, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
sono$date <- format(sono$SleepDay, format = "%m/%d/%y")
```

Aparentemente temos dados prontos para exploração.

### Explorando e resumindo dados:

```
n_distinct(atividade$Id)
n_distinct(calorias$Id)
n_distinct(intensidade$Id)
n_distinct(sono$Id)
n_distinct(peso$Id)
```

```
[1] 33
[1] 33
[1] 33
[1] 24
[1] 8
```

**Percepções**

* Temos 33 usuários nos datasets de atividade, calorias e intensidade. 
* 24 usuários no dataset de sono e apenas 8 de peso. 
* Temos um conjunto de dados minúculo e diante dessas informações, os dados de peso não são significativos para fazer recomendações e conclusões. 


### Estatísticas resumidas dos conjuntos de dados:

```
# Explorando os minutos sedentários:
  atividade %>%  
  select(SedentaryMinutes) %>%
  summary()

# Explorando minutos ativos por categoria:
  atividade %>%
  select(VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes) %>%
  summary()

# Explorando os dataset's de calorias, sono e peso
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
```

```
SedentaryMinutes
 Min.   :   0.0  
 1st Qu.: 729.8  
 Median :1057.5  
 Mean   : 991.2  
 3rd Qu.:1229.5  
 Max.   :1440.0
```

```
 VeryActiveMinutes FairlyActiveMinutes LightlyActiveMinutes
 Min.   :  0.00    Min.   :  0.00      Min.   :  0.0       
 1st Qu.:  0.00    1st Qu.:  0.00      1st Qu.:127.0       
 Median :  4.00    Median :  6.00      Median :199.0       
 Mean   : 21.16    Mean   : 13.56      Mean   :192.8       
 3rd Qu.: 32.00    3rd Qu.: 19.00      3rd Qu.:264.0       
 Max.   :210.00    Max.   :143.00      Max.   :518.0       
    Calories     
 Min.   : 42.00  
 1st Qu.: 63.00  
 Median : 83.00  
 Mean   : 97.39  
 3rd Qu.:108.00  
 Max.   :948.00  
 TotalSleepRecords TotalMinutesAsleep TotalTimeInBed 
 Min.   :1.000     Min.   : 58.0      Min.   : 61.0  
 1st Qu.:1.000     1st Qu.:361.0      1st Qu.:403.0  
 Median :1.000     Median :433.0      Median :463.0  
 Mean   :1.119     Mean   :419.5      Mean   :458.6  
 3rd Qu.:1.000     3rd Qu.:490.0      3rd Qu.:526.0  
 Max.   :3.000     Max.   :796.0      Max.   :961.0  
    WeightKg           BMI       
 Min.   : 52.60   Min.   :21.45  
 1st Qu.: 61.40   1st Qu.:23.96  
 Median : 62.50   Median :24.39  
 Mean   : 72.04   Mean   :25.19  
 3rd Qu.: 85.05   3rd Qu.:25.56  
 Max.   :133.50   Max.   :47.54  
```

**Percepções**


* Temos que, segundo a média das 3 categorias de atividades, a "lightly active" (levemente ativos) são a maioria.

* O tempo médio sedentário é de 991 minutos ou 16 horas. Segundo o [Australian Physical Activity and Sedentary Behaviour Guidelines](https://www.health.gov.au/topics/physical-activity-and-exercise/physical-activity-and-exercise-guidelines-for-all-australians?utm_source=health.gov.au&utm_medium=callout-auto-custom&utm_campaign=digital_transformation), ser sedentário não é o mesmo que não praticar atividade física suficiente. Mesmo se você estiver fazendo bastante atividade física, ficar sentado por mais de 7 a 10 horas por dia pode ser ruim para sua saúde. Os usários da pesquisa ultrapassam bastante esse número. 

* A média total de passos por dia dos usuários pesquisados é de 7.638, um pouco menos para ter benefícios para a saúde, de acordo com a pesquisa do [Centers for Disease Control and Prevention (CDC)](https://www.medicalnewstoday.com/articles/how-many-steps-should-you-take-a-day#for-general-health). Eles descobriram que dar 8.000 passos por dia estava associado a um risco 51% menor de mortalidade por todas as causas (ou morte por todas as causas). Dar 12.000 passos por dia foi associado a um risco 65% menor em comparação com dar 4.000 passos.

* Em média, os participants dormem 419.5 minutos ou praticamente 7 horas por noite. Segundo o [American Academy of Sleep Medicine (AASM) e Sleep Research Society (SRS)](https://aasm.org/seven-or-more-hours-of-sleep-per-night-a-health-necessity-for-adults/) é recomendado que os adultos tenham sete ou mais horas de sono por noite para evitar os riscos à saúde de sono inadequado crônico.



## Mesclando dados

```
dados_mesclados <- merge(sono, atividade, by=c('Id', 'date'))
```

**Considerações importantes aqui:**

* Poderia ser usada a função ```"rbind()"``` para combinar as tabelas, mas a função ```"merge()"``` optimiza isso, pois ela combina e não repete colunas. Bem semelhante a um JOIN em SQL;
* A função "merge()" trouxe as colunas "date" e "id" sem que ocorram repetições;
* Poderiamos usar todas as colunas do estudo de caso, mas por serem mais completas, a decisão de mesclar os datasets "sono" e "atividade" é mais assertada. Além de reduzir o tamanho e ganhar desempenho.


## Conversões

### Criando novas colunas que representam valores originais em minutos para horas:

```
dados_mesclados$TotalHoursAsleep <- dados_mesclados$TotalMinutesAsleep / 60
dados_mesclados$TotalHoursInBed <- dados_mesclados$TotalTimeInBed / 60
dados_mesclados$SedentaryHours <- dados_mesclados$SedentaryMinutes / 60
```

### Criando a coluna latência do Sono:

```
dados_mesclados$SleepLatency <- dados_mesclados$TotalTimeInBed - dados_mesclados$TotalMinutesAsleep

summary(dados_mesclados$SleepLatency)
```


**Percepções**
* Latência de sono é o tempo que o indviduo leva para adormercer de fato após deitar-se.
* Embora a amostra seja pequena, temos que os números dos participantes do estudo estão acima do recomendado pela [SleepFoundation.org](https://www.sleepfoundation.org/how-sleep-works/sleep-latency#:~:text=Sleep%20latency%2C%20or%20sleep%20onset,20%20minutes%20to%20fall%20asleep). Enquanto uma latência do sono inferior a oito minutos pode indicar um distúrbio do sono como a narcolepsia, as pessoas que demoram mais de 20 minutos para adormecer podem ter insônia. Logo, uma latência entre 8 e 20 minutos é o ideal. A média dos pesquisados é de 39 minutos. 


### Agrupamento de registros

```
#O agrupamento de registros foi feito por meio de médias cada registro nas categorias de "Sedentary", "Lightly Active", "Fairly Active", "Very Active". 
dados_tipo_usuario <- dados_mesclados %>%
  summarise(
    user_type = factor(case_when(
      SedentaryMinutes > mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Sedentary",
      SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes > mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Lightly Active",
      SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes > mean(FairlyActiveMinutes) & VeryActiveMinutes < mean(VeryActiveMinutes) ~ "Fairly Active",
      SedentaryMinutes < mean(SedentaryMinutes) & LightlyActiveMinutes < mean(LightlyActiveMinutes) & FairlyActiveMinutes < mean(FairlyActiveMinutes) & VeryActiveMinutes > mean(VeryActiveMinutes) ~ "Very Active",
    ),levels=c("Sedentary", "Lightly Active", "Fairly Active", "Very Active")), Calories, .group=Id) %>%
  drop_na()
```

**Considerações importantes aqui:**

* Todos os registros foram divididos em 4 grupos: Sedentário, Levemente Ativo, Consideralvemente ativo e Muito ativo;
* A classificação se dá por meio de médias e comparações;
* Esse agrupamento foi feito para ser exibido graficamente mais a frente.

### Criando a coluna dia da semana

```
dados_mesclados$dia_semana <- weekdays(as.Date(dados_mesclados$SleepDay))
```

## Análise e Visualização

### Distribuição dos registros por tipo de usuário

```
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
```

<img src="https://github.com/welingtonfonsec/Bellabeat/blob/main/Graficos/Distribui%C3%A7aoXtipousuario.png?raw=true" alt="" width="50%">

**Percepções**

* Esse agrupamento não tem como intenção definir o usuário como pertencente a determinada categoria. Mas apenas definir o registro diário. Por exemplo, um determinado usuário pode ter hoje um registro de atividade diária  como sedentário e amanhã como muito ativo.

* Segundo o gráfico, temos que os usuários se comportam na maior parte dos registros como sendentários e levemente ativos. Juntos somam mais de 80%.

* A Bellabeat pode usar essa informação para mostrar ao usuário qual a categoria que seu dia foi alocada e dar dicas de como manter ou melhorar a situação. Exemplo: usuário teve dia classificado como sedentário, a Bellabeat o notifica.

### Passos e tempo sedentário por dia da semana

### Passos por dia da semana

```
media_totalsteps <- aggregate(TotalSteps ~ dia_semana, data = dados_mesclados, FUN = mean)

grafico_media_totalsteps <- ggplot(media_totalsteps, aes(x = dia_semana, y = TotalSteps)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(title = "Média de Total de Passos x Dia da Semana",
       x = "Dia da Semana",
       y = "Média de Total de Passos") +
  theme_minimal()

print(grafico_media_totalsteps)
```
<img src="https://github.com/welingtonfonsec/Bellabeat/blob/main/Graficos/passosXdiadasemana.png?raw=true" alt="" width="50%">


### Minutos sedentárias por dia da semana

```
media_sedentary <- aggregate(SedentaryMinutes ~ dia_semana, data = dados_mesclados, FUN = mean)

grafico_media_sedentary <- ggplot(media_sedentary, aes(x = dia_semana, y = SedentaryMinutes)) +
  geom_bar(stat = "identity", fill = "red") +
  labs(title = "Média de Minutos Sedentários x Dia da Semana",
       x = "Dia da Semana",
       y = "Média de Minutos Sedentários") +
  theme_minimal()

print(grafico_media_sedentary)
```
<img src="https://github.com/welingtonfonsec/Bellabeat/blob/main/Graficos/minsedentariosXdiadasemana.png?raw=true" alt="" width="50%">


**Percepções**

* Os gráficos de barras mostram que o sábado é o dia ótimo. Pois em média, é  o que mais os usuários dão passos e o que menos tem minutos sendentários.
* Informação útil para o aplicativo notificar de uma maneira mais assertiva o usuário a fazer exercicios em dias em que historicamente ele não tem bons números de atividades fisicas e sedentarismo.

