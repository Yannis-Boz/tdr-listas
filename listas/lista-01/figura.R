pacotes <- c("lintr", "styler")
pacotes_faltantes <- pacotes[!(pacotes %in% installed.packages()[, "Package"])]

if (length(pacotes_faltantes) > 0) {
  lib_dir <- Sys.getenv("R_LIBS_USER")
  if (!dir.exists(lib_dir)) {
    dir.create(lib_dir, recursive = TRUE, showWarnings = FALSE)
  }
  install.packages(pacotes_faltantes, repos = "https://cloud.r-project.org", lib = lib_dir)
}

dados <- read.csv("airquality.csv")

dados$Month <- factor(
  dados$Month,
  levels = 5:9,
  labels = c("Mai", "Jun", "Jul", "Ago", "Set")
)

pdf("figura.pdf", width = 7, height = 5)

boxplot(
  Temp ~ Month,
  data = dados,
  col = "lightblue",
  border = "darkblue",
  main = "Distribuição da Temperatura por Mês",
  xlab = "Mês",
  ylab = "Temperatura (°F)"
)

dev.off()
