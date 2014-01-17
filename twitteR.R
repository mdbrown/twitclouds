

library("ROAuth")
library("twitteR")
library("wordcloud")
library("tm")




getTwitterOAuth( '7DZa3p2y5RpDgA4kiRk95g', 
                 '19gphclTC6lcTmklK3hxnp3IZiorJZAGrKjDQ4DfNHs')



reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "7DZa3p2y5RpDgA4kiRk95g"
consumerSecret <- "19gphclTC6lcTmklK3hxnp3IZiorJZAGrKjDQ4DfNHs"
twitCred <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret,
                             requestURL=reqURL,
                             accessURL=accessURL,
                             authURL=authURL)
twitCred$handshake(cainfo="cacert.pem")

registerTwitterOAuth(twitCred)
save(twitCred, file = "my_oauth.Rdata") 


#load("my_oauth.Rdata")
registerTwitterOAuth(twitCred)


search_raw <- searchTwitter('#Redfin OR redfin OR @redfin', n = 1500, 
                            geocode='47.6097,-122.3331,25mi', 
                            cainfo="cacert.pem")

search_raw



#save text
r_stats_text <- sapply(search_raw, function(x) x$getText())
#create corpus
r_stats_text_corpus <- Corpus(VectorSource(r_stats_text))
#clean up
r_stats_text_corpus <- tm_map(r_stats_text_corpus, tolower) 
r_stats_text_corpus <- tm_map(r_stats_text_corpus, removePunctuation)
r_stats_text_corpus <- tm_map(r_stats_text_corpus, function(x)removeWords(x,stopwords()))
wordcloud(r_stats_text_corpus)

pal2 <- brewer.pal(8,"Dark2")
wordcloud(r_stats_text_corpus,min.freq=2,max.words=150, random.order=T, colors=pal2)

wordcloud(r_stats_text_corpus,min.freq=2,max.words=100, random.order=T, colors=pal2)


latlongdat <- read.csv("citylatlong.csv")


td <- TermDocumentMatrix(r_stats_text_corpus)
sorted.freq <- rev(sort(slam::row_sums(td)))
data.frame(sorted.freq[sorted.freq>5])