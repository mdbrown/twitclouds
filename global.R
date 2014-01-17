library("ROAuth")
library("twitteR")
library("wordcloud")
library("tm")
#city data
latlongdat <- read.csv("citylatlong.csv", stringsAsFactors=FALSE)

load("my_oauth.Rdata")
registerTwitterOAuth(twitCred)
