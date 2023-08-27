## Índice

[1. Introdução](#introdução)

[2. Tarefa de Negócios](#tarefa-de-negócios)

[3. Dados](#dados)

[4. Processamento e Análise](#processamento-e-limpeza)

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
* **Tamanho e formato**: 18 arquivos no formato CSV (322 MB, descompactado);
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

## Processamento e Análise

```
#Carregando Pacotes:

library(tidyverse)
library(lubridate)
library(dplyr)
library(ggplot2)
library(tidyr)
```

```
#Importando datasets

atividade <- read.csv("C:/Users/welin/Desktop/GOOGLE/Estudos de caso/2/bellabeat/dailyActivity_merged.csv")
calorias <- read.csv("C:/Users/welin/Desktop/GOOGLE/Estudos de caso/2/bellabeat/hourlyCalories_merged.csv")
intensidade <- read.csv("C:/Users/welin/Desktop/GOOGLE/Estudos de caso/2/bellabeat/hourlyIntensities_merged.csv")
sono <- read.csv("C:/Users/welin/Desktop/GOOGLE/Estudos de caso/2/bellabeat/sleepDay_merged.csv")
peso <- read.csv("C:/Users/welin/Desktop/GOOGLE/Estudos de caso/2/bellabeat/weightLogInfo_merged.csv")
```
