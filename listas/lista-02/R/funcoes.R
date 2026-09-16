library(here)
library(targets)
library(tarchetypes)
library(dplyr)
library(ggplot2)


## Lê o arquivo .csv e o converte o mês em fator
leitor_de_dados <- function(caminho) {
	dados <- read.csv(caminho)
	dados$Month <- factor(
		dados$Month,
		levels =5:9,
		labels = c("Maio", "Junho", "Julho", "Agosto", "Setembro")
		)
	return(dados)
}


## Resume a média mensal de ozônio e vento
resume_dados <- function(dados) {
	resumo <- dados |>
	group_by(Month) |>
	summarise(
	media_ozonio = mean(Ozone, na.rm = TRUE),
	media_vento = mean(Wind, na.rm = TRUE))
	return(resumo)
}

## Ajusta o modelo linear de ozônio em função do vento 
ajusta_modelo <- function(dados) {
	modelo <- lm(Ozone ~ Wind, data = dados)
	return(modelo)
}

## Desenha o g

desenha_grafico <- function(dados, caminho_saida) {
	grafico <- ggplot(dados, aes(x = Wind, y = Ozone)) +
			geom_point(pch = 19, color = "gray30", alpha = 0.7) +
			geom_smooth(method = "lm", color = "blue", se = FALSE) +
			theme_minimal() +
			labs(x = "Velocidade do Vento (mph)", y = "Ozônio (ppb)")

	ggsave(caminho_saida, plot = grafico, width = 7, height = 5, bg = "white")

#Exigência do targets: a função que salva o arquivo deve retornar o caminho
	return(caminho_saida)
}
