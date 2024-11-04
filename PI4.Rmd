---
title: "2024-PI4_Univesp"
author: "Kobayashi&Kobayashi"
date: "2024-09-01"
output:
  pdf_document: default
  html_document: default
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Introdução e Contexto

Este estudo se relaciona ao Projeto Integrador 4 (PI4), envolve todos os alunos que ingressaram no segundo ciclo em Ciência de Dados e Engenharia de Computação da Universidade Virtual de São Paulo (Univesp), com a carga horária de 80 horas no semestre.

Objetivo: desenvolver análise de dados em escala utilizando algum conjunto de dados existentes ou capturados por IoT, e aprendizagem de máquina. Preparar uma interface para visualização dos resultados.

Ementa: Resolução de Problemas. Visualização de dados. Nuvem. Projeto IoT. Aprendizagem de Máquina.

## Proposta

Dentro da proposta discutida no grupo, foi escolhido o tema de estudos sobre a Qualidade do Ar, com os dados obtidos pelas estações de monitoramento (automaticas e manuais) da CETESB <https://cetesb.sp.gov.br/wp-content/uploads/2024/03/LEIA_ME_ESTACOES_LOCAL.pdf> tendo como escopo inicial é estação de São Bernardo do Campo - Centro.

A CETESB é uma empresa pública que aderiu à política de dados abertos conforme disposto em <https://dados.gov.br/dados/conteudo/politica-de-dados-abertos>. No entanto, o acesso aos dados das estações de medição é pelo através do Sistema de Informações QUALAR <https://qualar.cetesb.sp.gov.br/>

Esta é a documentação do estudo exploratório.

## Engenharia de Dados

Para automação do processo de obtenção dos dados, foi utilizado o pacote qualR <https://github.com/ropensci/qualR>

Instalação de lib "devtools" como pré-requisito

```{r}

# processo de instalação do pacote qualR
# Pre-requisito:

install.packages("devtools")

```

Instalação do quaR via Devtools

```{r}

# processo de instalação do pacote qualR
# Pre-requisito:
devtools::install_github("ropensci/qualR")

```

Dentro do ambiente do sistema QUALAR, são disponibilizadas tabelas com as:

estações de medições meteorológicas, que aqui trataremos por AQS (air quality station)

Parâmetros / variáveis de observação das estações de medições meteorológicas

```{r}
library(qualR)

# To see all CETESB AQS names with their codes and lat lon
cetesb_aqs

# To see all CETESB AQS parameters with their codes and abbreviation
cetesb_param

```


Para gerenciamento das credenciais de acesso, foi usado o pacote `usethis`, gravado usuário e senha no ambiente global. Nas chamadas, será usado o `Sys.getenv()`.

```{r}
library(usethis)

edit_r_environ()
```

Downloading dos parâmetros meteorológicos e critério de poluente de um AQS (air quality station)

```{r}
library(qualR)

# cetesb_aqs 
    # Checar na tabela o cód da estação desejada (no caso: S.Bernardo-Centro aqs_code) 
# cetesb_param 
    # Checar na tabela o cód da poluente Ozone pol_code
 
# my_user_name <- "evylyn-word@hotmail.com"
# my_password <- "Minhasenhae10"

pin_code <- 272 # S.Bernardo-Centro
start_date <- "01/01/2024"
end_date <- "31/01/2024"

SBC_centro_all <- cetesb_retrieve_met_pol(
                       # my_user_name,
                       # my_password,
                       Sys.getenv("QUALAR_USER") # calling your user
                       ,Sys.getenv("QUALAR_PASS") # calling your password 
                       ,pin_code  # A entrada também poderia ser: "S.Bernardo-Centro"
                       ,start_date
                       ,end_date
                       ,to_csv = TRUE # caso queira que o output seja em CSV
                       )


```

Para checagem da distribuição espacial de um poluente do ar específico, é possível fazer o download de todas as AQS disponíveis. Neste exemplo abaixo, será feito do :

| nome do parametro                  | unidade | código |
|:-----------------------------------|:-------:|:------:|
| TEMP (Temperatura do Ar)           |  ºC     |   25   |
| UR (Umidade Relativa do Ar)        |  %      |   28   |
| MP2.5 (Partículas Inaláveis Finas) |  ug/m3  |   57   |
| MP10 (Partículas Inaláveis)        |  ug/m3  |   12   |

: tabela de dados do ar e poluentes, com unidade e código

```{r}


```


```{r}


```

Para checagem da distribuição espacial de um poluente do ar específico, é possível fazer o download de mais de uma AQS disponíveis. Neste exemplo abaixo, será feito da Santa Gertrudes, Diadema, S.André Capuava, Mauá:


```{r}
library(qualR)


# Definir os códigos de AQS, intervalo de datas e credenciais
pin_codes <- c(273, 92, 100, 65) # cód p/ AQS "Santa Gertrudes, Diadema, S.André Capuava, Mauá"
start_date <- "21/08/2024"
end_date <- "01/09/2024"

# Nome do arquivo CSV onde os dados serão salvos
output_file <- "comp_reg_data.csv"

# Função para salvar os dados em CSV com append
append_to_csv <- function(data, file_name) {
  if (file.exists(file_name)) {
    # Se o arquivo já existe, anexa os dados
    write.table(data, file_name, sep = ",", row.names = FALSE, col.names = FALSE, append = TRUE)
  } else {
    # Se o arquivo não existe, cria o arquivo e salva os dados
    write.table(data, file_name, sep = ",", row.names = FALSE, col.names = TRUE)
  }
}

# Iterar sobre os códigos de AQS e coletar os dados
for (pin_code in pin_codes) {
  # Coletar os dados para o código de AQS atual
  comp_reg <- cetesb_retrieve_met_pol(
    Sys.getenv("QUALAR_USER"),
    Sys.getenv("QUALAR_PASS"),
    pin_code,
    start_date,
    end_date,
    to_csv = FALSE # Não salvar diretamente em CSV
  )
  
  # Salvar os dados em CSV com append
  append_to_csv(comp_reg, output_file)
}

```


