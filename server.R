library(shiny)

source("RedTwitFuns.R")


# Define server logic for random distribution application
shinyServer(function(input, output) {
  
  # Reactive expression to generate the requested distribution. This is 
  # called whenever the inputs change. The renderers defined 
  # below then all use the value computed from this expression
  my_corpus <- reactive({ 
    
    isolate
    if(input$gogogo!=0){
      return(isolate({  
        twitter_corpus(input$searchTerm, input$city)
        }))

    }else NULL
   
  })
  
  output$tweetCount <- renderText({
    
    numTweets <- length(my_corpus())
    
    return(HTML(paste("<em>Twitter's API returned", numTweets, "tweets matching your search criteria!</em>")))
    
  })
  output$wordcloud <- renderPlot({
    
    if(input$gogogo!=0){
    pal2 <- brewer.pal(8,"Dark2")
    wordcloud(my_corpus(),min.freq=2,max.words=150, random.order=FALSE, colors=pal2, scale = c(7,.8))
    }else NULL
  })
  
  
  # Generate an HTML table view of the data
  output$table <- renderTable({
    if(input$gogogo!=0){
    
      corpus_maketable(my_corpus())$table
    }else NULL
  })
})
