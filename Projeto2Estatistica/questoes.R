# Integrantes:
# Gustavo Farani de Farias (gff)
# Thayná Cavalcante (tecs)
# Izael Effemberg da Costa (iec)

# Questão 1

# dados <- read.csv("/Users/izaeleffemberg/Projects/projeto-2-estatistica/Projeto2Estatistica/Detalhes de Albuns.csv", stringsAsFactors = F)

dados = data.frame(Detalhes_de_Albuns)
print(dados)

# Questão 2
mean(dados$Qnt..de.Albuns.Vendidos)

sd(dados$Qnt..de.Albuns.Vendidos)

statMode <- function (y) {
  freq <- table(y)
  maxFreq <- max(freq)
  if (all(freq == maxFreq))
    return ("Amodal")
  else
    return (names(freq)[freq == maxFreq])
}

statMode(dados$Qnt..de.Albuns.Vendidos)

# Questão 3
names <- c(Detalhes_de_Albuns_Página1$`Artista`)
dates <- c(Detalhes_de_Albuns_Página1$`Ano`)
publish2018 <- c()
publish2019 <- c()
contador = 1

for(x in names){
  if(dates[contador] == 2018) {
    publish2018 = c(publish2018, x)
    
  }else
    publish2019 = c(publish2019, x)
  contador = contador + 1
}
publish2018 = unique(publish2018, incomparables = FALSE)
publish2019 = unique(publish2019, incomparables = FALSE)
resposta = c(match(publish2018, publish2019))

for(i in resposta){
  if(!is.na(i))
    print(publish2019[i])
}

# Questão 4
argminSD <- function (keys, values) {
  single <- unique(keys)
  map <- match(keys, single)
  tab <- matrix(NA, length(keys), length(single))
  for (i in 1:length(keys)) {
    tab[i, map[i]] <- values[i]
  }
  stdDev <- rep(NA, times = length(single))
  for (j in 1:length(single)) {
    stdDev[j] <- sd(tab[, j], na.rm = TRUE)
  }
  posMin <- which.min(stdDev)
  return (single[posMin])
}

argminSD(dados$Artista, dados$Qnt..de.Albuns.Vendidos)

# Questão 5
getAlbumMaisVendidoEmUmAno <- function(ano) {
  vendas = max(dados[dados$Ano == ano,][[5]])
  album = dados[dados[5] == vendas,]["Album"]
  banda = dados[dados[[5]] == vendas,]["Artista"]
  return (merge(album, banda))
}

getAlbumMenosVendidoEmUmAno <- function(ano) {
  vendas = min(dados[dados$Ano == ano,][[5]])
  album = dados[dados[5] == vendas,]["Album"]
  banda = dados[dados[5] == vendas,]["Artista"]
  return (merge(album, banda))
}

getAlbuns <- function(ano) {
  maisVendidoEmUmAno = getAlbumMaisVendidoEmUmAno(ano)
  menosVendidoEmUmAno = getAlbumMenosVendidoEmUmAno(ano)
  return(rbind(maisVendidoEmUmAno, menosVendidoEmUmAno))
}

print(getAlbuns(2019))

# Questão 6
names <- c(Detalhes_de_Albuns_Página1$`Artista`)
year <- c(Detalhes_de_Albuns_Página1$`Ano`)
data <- list()

unity = 0
contador = 0
contador2 = 1

for(i in names){
  for(j in names){
    if(j == i)
      contador = contador + 1
  }
  if(contador == 1){
    unity = unity + 1
    data[unity] <- paste("Artista:", i, "||", "Ano:", year[contador2], sep = " ", collapse = NULL) #Concatena e insere
  }
  contador2 <- contador2 + 1
  contador <- 0
}
data

# Questão 7
get_quantidade_de_artistas_por_empresa <- function(artistas_por_empresa){
  length(unique(artistas_por_empresa))
}
empresa_num_artistas <- aggregate(Artista ~ Empresa, dados, get_quantidade_de_artistas_por_empresa)
print(empresa_num_artistas)

# Questão 8
topFreq <- function(scores) {
  contingency <- as.data.frame(table(scores))
  names(contingency) = c("keys", "freq")
  podium <- order(contingency$freq, decreasing = TRUE)[1:3]
  return (as.vector(contingency$keys[podium]))
}

produtivos <- data.frame("Artista" = topFreq(dados$Artista), 
                         "Total de Vendas" = rep(0, 3))
for (j in 1:3) {
  vendas <- dados$Qnt..de.Albuns.Vendidos[dados$Artista == produtivos$Artista[j]]
  produtivos$Total.de.Vendas[j] <- sum(vendas)
}

shuffle <- produtivos[order(produtivos$Total.de.Vendas, decreasing = TRUE), ]
produtivos <- data.frame("Artista" = shuffle$Artista, "Total de Vendas" = shuffle$Total.de.Vendas)

# Questão 9
get_album_mais_vendido_por_empresa <- function(empresa, data) {
  album_vendas <- subset(data, Empresa == empresa, c("Album", "Qnt..de.Albuns.Vendidos", "Empresa", "Artista"))
  album_vendas[which.max(album_vendas[, "Qnt..de.Albuns.Vendidos"]),]
}

print(get_album_mais_vendido_por_empresa('BigHit', dados))

# lapply = Map
empresas_distintas <- unique(dados[,"Empresa"])
empresa_artista_album_vendas <- do.call(rbind, lapply(empresas_distintas, get_album_mais_vendido_por_empresa, dados))

empresa_artista_album_vendas_ordem <- order(empresa_artista_album_vendas[, "Qnt..de.Albuns.Vendidos"], decreasing = T)
empresa_artista_album_vendas_ordenado <- empresa_artista_album_vendas[empresa_artista_album_vendas_ordem, ]

print(empresa_artista_album_vendas_ordenado)

# Questão 10
vendasAnuais <- function(gravadora) {
  lancamentos <- dados$Ano[dados$Empresa == gravadora]
  return (hist(lancamentos, 
               main = paste(gravadora, ": Produção Anual"),
               xlab = "Ano",
               ylab = "Lançamentos",
               col = "red",
               border = "black",
               xlim = c(2017, 2020),
               ylim = c(0, 5),
               las = 1,
               breaks = seq(2017.5, 2019.5, 1)))
}