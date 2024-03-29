

#Version 3



ui <- dashboardPage(
  skin = "black",
  title = "Check-the-Facts: Higher Education",
  
  dashboardHeader(
    title = span(img(src = "check the facts logo.svg", height = 35), "Check-The-Facts: Higher Education"),
    titleWidth = 600,
    dropdownMenu(
      type = "notifications", 
      headerText = strong("HELP"), 
      icon = icon("question"), 
      badgeStatus = NULL,
      notificationItem(
        text = (help$text[1])),
      notificationItem(
        text = (help$text[2]))
    ),
    tags$li(
      a(
        strong("More about Check The Facts"),
        height = 40,
        href = "https://data.overheid.nl/community/application/4638",
        title = "",
        target = "_blank"
      ),
      class = "dropdown"
    )),
  
  dashboardSidebar(
    width = 350,
    div(class = "inlay", style = "height:15px;width:100%;background-color: #ecf0f5;"),
    menuItem(
      "Download Data",
      tabName = "download",
      icon = icon("download"),
      textInput(
        inputId = "filename",
        placeholder = "Name download file",
        label = ""
      ),
      div(
        downloadButton(
          outputId = "downloadData",
          label = "Save data",
          icon = icon("download"),
          style = "color: black; margin-left: 15px; margin-bottom: 5px;"
        )
      )
   ),
    br(),
    selectizeInput("crohoInput", label = h5("Select area of study"),
                   choices = sort(unique(data4$CROHO.ONDERDEEL)), selected = sort(unique(data4$CROHO.ONDERDEEL)), multiple = TRUE, 
                   options = list(plugins= list('remove_button'))),
    selectizeInput("wohboInput", label = h5("Select WO/HBO"),
                   br(),
                   choices = sort(unique(data4$HO.type)), selected = sort(unique(data4$HO.type)), multiple = TRUE, 
                   options = list(plugins= list('remove_button'))),
    selectizeInput("languageInput", label = h5("Select language of study"),
                   choices = sort(unique(data4$language)), selected = sort(unique(data4$language)), multiple = TRUE, 
                   options = list(plugins= list('remove_button'))),
    pickerInput("locationInput", h5("Select Location"), choices=sort(unique(data4$GEMEENTENAAM.x)), multiple = TRUE,
                selected = sort(unique(data4$GEMEENTENAAM.x)),
                options = list(`actions-box` = TRUE, size = 8, `live-search`= TRUE)),
    selectizeInput("levelInput", label = h5("Select level of study"),
                   choices = sort(unique(data4$TYPE.HOGER.ONDERWIJS)), selected = sort(unique(data4$TYPE.HOGER.ONDERWIJS)), multiple = TRUE, 
                   options = list(plugins= list('remove_button'))),
    selectizeInput("fullpartInput", label = h5("Select Full/Part-time"),
                   choices = sort(unique(data4$OPLEIDINGSVORM)), selected = sort(unique(data4$OPLEIDINGSVORM)), multiple = TRUE, 
                   options = list(plugins= list('remove_button'))),
    pickerInput("instituteInput", h5("Select Institute"), choices=sort(unique(data4$INSTELLINGSNAAM)), multiple = TRUE,
                selected = sort(unique(data4$INSTELLINGSNAAM)),
                options = list(`actions-box` = TRUE, size = 8, `live-search`= TRUE)),
    
    br() ),
  
  dashboardBody(
   
    tags$head(
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "CTF_style.css")
    ),

    useShinyjs(),
    
    # MAIN BODY ---------------------------------------------------------------
    
    fluidRow(
      column(
        width = 12,
          bsButton("studyprograms",
                   label = "Study Programs",
                   icon = icon("user-graduate"),
                   style = "primary"),
          bsButton("jobmarket",
                   label = "Job Market",
                   icon = icon("briefcase"),
                   style = "primary"),
          bsButton("analytics",
                   label = "Analytics",
                   icon = icon("chart-line"),
                   style = "primary"),
          bsButton("sources",
                   label = "Sources",
                   icon = icon("table"),
                   style = "primary")
      )
    ), 
    br(),
    fluidRow(id = "Studyprograms_panel", 
             tabBox(title = "Study program registrations", id = "tabsetinsch", width = 6, height = 650,
                    tabPanel("Overview", textOutput("selected_var_stream"), streamgraphOutput("ins_stream")%>%shinycssloaders::withSpinner(type = 4,color = "#6db2f2", size = 0.7 ), 
                             selectInput("streamin",
                                         label = "Choose option",
                                         choices = c("INSTELLINGSNAAM", "OPLEIDINGSNAAM.ACTUEEL","CROHO.ONDERDEEL", "GESLACHT"),
                                         selected = "INSTELLINGSNAAM",
                                         width = "300")),
                    tabPanel("Registrations per Year", textOutput("selected_var_bar"), plotlyOutput("bar_studies")%>%shinycssloaders::withSpinner(type = 4,color = "#6db2f2", size = 0.7 ),
                             fluidRow(
                               column(width = 6, sliderInput(inputId = "YearInput",label = "Select year", min = min(data4$Year),max =  max(data4$Year),value = max(data4$Year), step = 1, sep = ""
                               )),
                               column(width = 6, selectInput("barin",
                                                             label = "Choose an option",
                                                             choices = c("INSTELLINGSNAAM", "OPLEIDINGSNAAM.ACTUEEL","CROHO.ONDERDEEL", "GESLACHT"),
                                                             selected = "INSTELLINGSNAAM",
                                                             width = "300"))
                               
                             )),
                    
                    h6("If the image isn't clear enough, try to use the filters in the sidebar to get a clearer view!")
                    
                    
             ),
             
             tabBox(title = "Map", id = "tabsetmap", width = 6, height = 650,
                    tabPanel("HO locations", leafletOutput("map1", height = 550)%>%shinycssloaders::withSpinner(type = 4,color = "#6db2f2", size = 0.7 )),
                    tabPanel("Useful Locations", pickerInput("map2input", h5("Select Location"), choices=sort(unique(data4$GEMEENTENAAM.x)), multiple = FALSE,
                                                             selected = "Eindhoven"),leafletOutput("map2", height = 450)%>%shinycssloaders::withSpinner(type = 4,color = "#6db2f2", size = 0.7 ))
             ), br(),
             
             
             
             tabBox(title = "Studies",id = "tabsetstud", width = 12,
                    tabPanel("Study Program Table", DT::dataTableOutput("studies_table")%>%shinycssloaders::withSpinner(type = 4,color = "#6db2f2", size = 0.7 )),
                    tabPanel("Matrix", "doorstroommatrix", "Use the filters to view the matrix", DT::dataTableOutput("matrix")%>%shinycssloaders::withSpinner(type = 4,color = "#6db2f2", size = 0.7 ))), br()
             
             
             
             
    ),
    
    fluidRow(id = "Jobmarket_panel", br(), 
             tabBox(title = "Job market data",  id = "tabsetjob",  width = 12, height = 650,
                    tabPanel("x", textOutput("selected_var_job"), plotlyOutput("jobs1")%>%shinycssloaders::withSpinner(type = 4,color = "#6db2f2", size = 0.7 ),
                             fluidRow(
                               column(width = 6, sliderInput(inputId = "jobyearInput",label = "Select Year", min = min(L_market$Perioden),max =  max(L_market$Perioden),value = max(L_market$Perioden), step = 1, sep = ""
                               )),
                               column(width = 6, selectInput("jobin",
                                                             label = "Choose option",
                                                             choices = c("Studierichting", "Perioden","Arbeidsmarktpositie", "UitstromersHoMetEnZonderDiploma"),
                                                             selected = "Studierichting",
                                                             width = "300")))
                             
                    )
                    
             )),
    
    
    
    
    fluidRow(id = "Analytics_panel", br(),
             tabBox(title = "What was the effect of the loan system that was introduced in 2015 on students?", id = "tabsetLoan2015", width = 6,
                    tabPanel("Plot 1", img(src = "2015inschrijv.jpeg", height = 300), br(),
                             "From this plot we see that student write-ins have actually increased since 2015. However, this does not necessarily mean that this is a result of the change in loan system! 
                             This could also be because of an overall trend in education in the Netherlands. Check the next tab to see a continuation of this investigation."),
                    tabPanel("..."))),
    
    fluidRow(id = "Sources_panel", br(),
               box(title = "Sources", "This table shows the original sources used. These are all openly available (open data).",
                 br(), width = 12, tableOutput("source_table")
             ))
    
    ))


        
  

 




