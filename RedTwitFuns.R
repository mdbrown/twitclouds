## function to take in city name, number of tweets, and city radius and it will print out a wordcloud of tweets 

twitter_corpus <- function(term, cityName, radius= 25){
  
  
  if(cityName=="none"){
    
    search_raw <- searchTwitter(term, n = 1500,
                                cainfo="cacert.pem")
  }else{
      
    
    geocode <- latlongdat[which(latlongdat$city==cityName),2]
    geocode <- paste(geocode, ",", radius, 'mi', sep="")
    
    search_raw <- searchTwitter(term, n = 1500, 
                            geocode=geocode, 
                            cainfo="cacert.pem")
    }
    
    
  #save text
  mytext <- sapply(search_raw, function(x) x$getText())
  #create corpus
  mytext_corpus <- Corpus(VectorSource(mytext))
  #clean up
  mytext_corpus <- tm_map(mytext_corpus, tolower) 
  mytext_corpus <- tm_map(mytext_corpus, removePunctuation)

  mytext_corpus <- tm_map(mytext_corpus, function(x)removeWords(x,strsplit(term, " ")[[1]]))
  
  mytext_corpus <- tm_map(mytext_corpus, function(x)removeWords(x,stopwords()))

  return(mytext_corpus)

  
}
  
corpus_maketable <- function(mycorpus, min.freq = 5){
  
  
  td <- TermDocumentMatrix(mycorpus)
  sorted.freq <- rev(sort(slam::row_sums(td)))
  tmp <- sorted.freq[sorted.freq>min.freq]
  
  outtable = data.frame(word = names(tmp), frequency = tmp)[1:25,]
  row.names(outtable) = NULL
  
  list(table = outtable, 
       sumWords = sum(sorted.freq))
  
}


