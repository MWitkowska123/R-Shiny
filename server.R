library(ggplot2)
library(dplyr)
library(shiny)
library(forcats)
library(plotly)


dane1 <- read.csv(file="dane.csv",head=TRUE,sep=",", colClasses=c("factor", "factor", "numeric", "factor", "factor", 
                                                                  "factor", "numeric", "numeric", "numeric"))
dane1$numer <- seq(1, 198)

dane <- dane1 %>%
  select(numer, first_name,last_name,Drug,Dosage,Mem_Score_Before,Mem_Score_After, Diff) %>%
  mutate(Name_Surname = paste(first_name,last_name)) %>%
  select(-c(first_name,last_name))

superfunkcja <- function(.Drug){
  dane %>% 
    filter(Drug == .Drug) %>% 
    mutate(Dosage = forcats::fct_inorder(Dosage))
}


shinyServer(function(input, output, session) {
  
  output$table1 <- renderTable({
    dane
  })
  

  output$Plot1 <- renderPlot({
    ggplot(dane, aes(x = Drug, y = Diff, size = Dosage, color = Dosage)) + geom_jitter(alpha = 0.5) + labs(
      caption = 
        "A - Alprazolam (Xanax) [1mg/3mg/5mg]
  T - Triazolam (Halcion) [0.25mg/0.5mg/0.75mg]
  S- Sugar Tablet (Placebo) [1 tab/2tabs/3tabs]"
    )+
      scale_size_discrete(name = "Dawka")+
      scale_color_discrete(name = "Dawka")+
      xlab("Narkotyk") +
      ylab("Roznice w wyniku testu")
  })
  
  
  
  output$Plot2<-renderPlotly({
    
    if(input$Przed == TRUE){
      if(input$Po == TRUE){
        ggplot(dane, aes(x = numer)) +
          geom_line(aes(y=Mem_Score_After, color = "red")) +
          geom_line(aes(y=Mem_Score_Before, color = "blue"))+
          geom_vline(xintercept  = c(67.5,133.5)) +
          geom_vline(xintercept  = c(23.5, 45.5, 89.5, 111.5, 155.5, 177.5), colour="green", linetype = "longdash") +
          xlab("numer") + 
          ylab("Wynik testu")
        
      }else {
        ggplot(dane, aes(x = numer)) +
          geom_line(aes(y = Mem_Score_After, color = "red"))+
          geom_vline(xintercept  = c(67.5,133.5)) +
          geom_vline(xintercept  = c(23.5, 45.5, 89.5, 111.5, 155.5, 177.5), colour="green", linetype = "longdash") +
          xlab("numer") + 
          ylab("Wynik testu")
      }
    } else{
      if(input$Po == TRUE){
        ggplot(dane, aes(x = numer)) +
          geom_line(aes(y = Mem_Score_Before, color = "blue"))+
          geom_vline(xintercept  = c(67.5,133.5)) +
          geom_vline(xintercept  = c(23.5, 45.5, 89.5, 111.5, 155.5, 177.5), colour="green", linetype = "longdash") +
          xlab("numer") + 
          ylab("Wynik testu")
      } else {
        ggplot()
      }
    }
  })
  
  output$Plot3 <- renderPlot({
    
    if (input$typ=="Alprazolam (Xanax)"){
      d <- superfunkcja("A") 
      ggplot(d, aes(x = numer, y = Diff)) +
        geom_line()+
        geom_vline(xintercept  = c(23.5, 45.5), colour="red", linetype = 4) +
        xlab("Dawka") + 
        ylab("Roznice w wyniku testu")
    }
    else if(input$typ=="Triazolam (Halcion)"){
      d <- superfunkcja("T") 
      ggplot(d, aes(x = numer, y = Diff)) +
        geom_vline(xintercept  = c(155.5, 177.5), colour="red", linetype = 4) +
        geom_line()+
        xlab("Dawka") + 
        ylab("Roznice w wyniku testu")
    }
    else{
      d <- superfunkcja("S") 
      ggplot(d, aes(x = numer, y = Diff)) +
        geom_line()+
        geom_vline(xintercept  = c(89.5, 111.5), colour="red", linetype = 4) +
        xlab("Dawka") + 
        ylab("Roznice w wyniku testu")
    }
  })
  
  output$Plot4 <- renderPlot({
    d <- superfunkcja(input$Drug)  
    ggplot(d, aes(x = Dosage, y = Diff)) +
      geom_boxplot() +
      xlab("Dawka") + 
      ylab("Roznica pomiedzy testami")
  })
  
  output$table3 <- renderTable({
    superfunkcja(input$Drug) 
  })
  
})








