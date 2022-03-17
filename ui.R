library(ggplot2)
library(dplyr)
library(shiny)
library(forcats)
library(plotly)


shinyUI(navbarPage(inverse=TRUE,
                   "Test Narkotykowy",
                   
                   
                   tabPanel("Dane",
                            sidebarLayout( sidebarPanel(
                              "Dane pochodza z https://www.kaggle.com/steveahn/memory-test-on-drugged-islanders-data"
                            ),
                            # Show a plot of the generated distribution
                            mainPanel(
                              tabsetPanel(
                                tabPanel('Tabela', tableOutput("table1")),
                                tabPanel('Wykres', plotOutput("Plot1"))
                              ))
                            
                            
                            )),
                   
                   
                   tabPanel("Testy",
                            sidebarLayout( sidebarPanel(
                              "Wybierz ktore wyniki testow wyswietlic:",
                              checkboxInput("Przed", "Przed podaniem narkotykow", TRUE),
                              checkboxInput("Po", "Po podaniu narkotykow", TRUE),
                            ),
                            # Show a plot of the generated distribution
                            mainPanel(
                              tabPanel('Plot', plotlyOutput("Plot2"))
                              
                            ))),
                   tabPanel("Roznica pomiedzy testami",
                            sidebarLayout( sidebarPanel(
                              radioButtons("typ","Wybierz typ wykresu:", choices=c("Alprazolam (Xanax)","tabletka z cukru (Placebo)","Triazolam (Halcion)"))
                            ),
                            # Show a plot of the generated distribution
                            mainPanel(
                              tabPanel('rysunek', plotOutput("Plot3"))
                              
                            ))),
                   
                   
                   tabPanel("Analiza danych",
                            sidebarLayout( sidebarPanel(
                              selectInput("Drug", label="Wybierz narkotyk:",
                                          c("Alprazolam (Xanax)" = "A",
                                            "Triazolam (Halcion)" = "T",
                                            "tabletka z cukru (Placebo)" = "S"))
                            ),
                            
                            # Show a plot of the generated distribution
                            mainPanel(
                              tabsetPanel(
                                tabPanel('Wykresy pudelkowe', plotOutput('Plot4')),      
                                tabPanel('Tabela obserwcji', tableOutput('table3'))
                                
                                
                              ))))   
                   
))