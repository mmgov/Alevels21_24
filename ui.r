library("DT")
library("tidyverse")
library("shinycustomloader")
library("shinythemes")
library("leaflet")

shinythemes::themeSelector()

navbarPage(
  
"A level Attainment in England 2021/22, 2022/23 and 2023/24",



tabPanel(
  "Mean A Level Attainment",
  mainPanel(
    strong("Mean A Level Attainment 21/22,22/23 and 23/24", style = "font-size: 30px;"),
    br(),
    br(),
    
    p("
    This app displays the attainment at A Level for every school/college in England for the exam diets 21/22,22/23 and 23/24. The specific attainment measure used is TALLPPE_ALEV_1618, which is the average point score per A level entry, which I understand to be a score
      which represents the attainment for each person/pupil who sat A level examinations that academic year. The analysis presented here uses the mean (or average) TALLPPE_ALEV_1618 for
        each indvidual school/college.
      The table shows the mean TALLPPE_ALEV_1618 for all schools/colleges for each of the years 18/19,21/22 and 22/23
      
      "),

    br(),
    strong("Mean A Level Attainment 21/22,22/23 and 23/24"),
    br(),
    br(),
  ),
  fluidPage(
    theme = shinythemes::shinytheme("cerulean"),
    tableOutput("tb")
 
  )

),




tabPanel(
  "A Level Attainment By School",
  mainPanel(
    strong("A Level Attainment By School", style = "font-size: 30px;"),
    br(),
    br(),
    p("The below allows you to search for the TALLPPE_ALEV_1618 of any individual school, from the 21/22,22/23 and 23/24 exam diet. 
    You can also download the entire DfE dataset from the 23/24 exam diet from the Download Data button."),  
    p("The DfE also converts the raw TALLPPE_ALEV_1618 into a grade categorization, where A+ represents the highest category and E represents the lowest"),

    br(),
    br(),
    br(),
    strong("TALLPPE_ALEV_1618 Score by Individual School 21/22, 22/23 and 23/24"),
    br(),
    br(),
    br(),
  ),
  fluidPage(
    downloadButton("download_scores",
                   label= "Download data"),
    ##withLoader(
      DTOutput("Search")
      ##)
  )
),


tabPanel(
  "Map of 23/24 Attainment Grade",
  mainPanel(
    strong("Map of 23/24 Attainment Grade", style = "font-size: 30px;"),
    br(),
    br(),
    p("The below map displays the TALLPPE_ALEV_1618 of all individual schools from the 23/24 exam diet.
    The pop up displays the name of the school, its postcode and its 23/24 grade categorization. Light green represents A, Dark green represents B. Yellow represents C.  Light Red represents D. Dark Red represents E "),
    br(),
    br(),
    br(),
    strong("Map of 23/24 Attainment Grade"),
    br(),
    br(),
    br(),
  
  ),
  fluidPage(
    leafletOutput(outputId = "uk_map")
  )
),

collapsible = TRUE
)


