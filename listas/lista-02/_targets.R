library(targets)

#Carrega os pacotes que as funções precisam
tar_option_set(packages = c("dplyr", "ggplot2", "readr"))

#Carrega as funções criadas no exercício anterior
source(here::here("R/funcoes.R"))

list(
#Arquvio de dados de entrada	
tar_target(
	arquivo_dados,
	"/home/yanni/tdr-material-lista-02/tdr-material/dados/airquality.csv",
	format = "file"),

#Dados lidos
	tar_target(
	dados_lidos,
	leitor_de_dados(arquivo_dados)),

#Médias mensais
	tar_target(
	medias,
	resume_dados(dados_lidos)),

#Modelo
	tar_target(
	modelo,
	ajusta_modelo(dados_lidos)),

#Figura
	tar_target(
	figura,
	desenha_grafico(dados_lidos, "saidas/grafico.png"),
	format = "file"),

#CSV com médias, exportado para saídas
	tar_target(
	csv_medias,
	exporta_medias_csv(medias, "saidas/medias.csv"),
	format = "file"))
