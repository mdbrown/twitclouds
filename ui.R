library(shiny)
library("ROAuth")
library("twitteR")
library("wordcloud")
library("tm")


# Define UI for random distribution application 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Fun with twitter wordclouds"),
  
  # Sidebar with controls to select the random distribution type
  # and number of observations to generate. Note the use of the br()
  # element to introduce extra vertical spacing
  sidebarPanel(
    textInput("searchTerm", "Twitter search query:", '#seahawks OR seahawks'),# '#Redfin OR redfin OR @redfin'
    
    selectInput("city", "Choose a city:",
                 list("Seattle",
                      "Boston",       
                      "Chicago",      
                      "Los Angeles", 
                      "Miami",      
                      "New York",     
                      "Phoenix",  
                      "Portland", 
                      "San Francisco",
                      "none")),
    helpText(p("If a city is chosen, only tweets within 25 miles of the city center will be included in the search. ")),
    br(),
    actionButton(inputId = "gogogo", "Create wordcloud!"), 
    br(), 
    br(), 
    p(" "),
    HTML("<p>Created by mdbrown. <a href='https://github.com/mdbrown/twitteRedfin'>Source code on Github</a></p>")
    
    #numericInput("radius", 
     #           "radius", 
      #          value = 500,
       #         min = 1, 
        #        max = 1000)
  ),
  
  # Show a tabset that includes a plot, summary, and table view
  # of the generated distribution
  mainPanel(
    tags$head(tags$style(type="text/css",
                         '#progressIndicator {',
                         '  position: fixed; top: 100px; right: 8px; width: 200px; height: 50px;',
                         '  padding: 8px; border: 1px solid #CCC; border-radius: 8px;',
                         '}'
    )),
    tags$head(
      tags$script(src = 'https://c328740.ssl.cf1.rackcdn.com/mathjax/2.0-latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML', type = 'text/javascript') ,
      tags$title('Table Formatting'),
      tags$link(rel = 'stylesheet', type = 'text/css', href = 'stylesheet.css')
    ),
    tabsetPanel(
      tabPanel("wordcloud", htmlOutput("tweetCount"), plotOutput("wordcloud", height = "800px")), 
      tabPanel("table", h3("Top 25 words..."), tableOutput("table")), 
      tabPanel("notes", p("To reconfigure a wordcloud once it has been created, try resizing your browser screen."), br(), 
               HTML("<p>This app was built using <a href = \"http://www.rstudio.com/shiny/\">shiny</a> and the <a href = \"http://cran.r-project.org/web/packages/twitteR/index.html\">twitteR</a> R package. Also thanks to Dave for <a href = \"http://davetang.org/muse/2013/04/06/using-the-r_twitter-package/\"> this</a> helpful blog post.</p>" ))
    ), 
    conditionalPanel("updateBusy() || $('html').hasClass('shiny-busy')",
                   id='progressIndicator',
                   "Calculation IN PROGRESS...",
                   div(id='progress',includeHTML("timer.js"))
    )
  )
))