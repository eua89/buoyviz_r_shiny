 library(shiny)

shinyUI(fluidPage(
  titlePanel("Buoy information"),
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput("select1", label = ('Select the buoy that you want to plot'),
                  choices = list ("ACFS1", "ANRN6", "BRIM2", "CHQO3", "CQUC1",
                                  "CVQV2", "DBQS1", "GDQM6", "GDWV2", "GTQF1",
                                  "JCQN4", "JCTN4", "KCHA2", "LTQM2", "MAQT2",
                                  "NIQS1", "OWQO1", "PBLW1","SCQC1", "SLOO3",
                                  "TIBC1", "WAQM3"), selected = "WAQM3"),
      br(),
      selectInput("select2", label = ("Select which measurement you want to plot"),
                  choices = list ("DEPTH","OTMP", "COND", "SAL", "O2", "O2PPM", 
                                  "CLCON", "TURB", "PH", "EH"), selected = "COND")
      
      
    
    ),
    
    mainPanel(
      textOutput("text"),
      plotOutput("plot"),
      tableOutput("table"))
    
  )
))