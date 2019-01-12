# Using modules

# Assuming the above csvFileInput and csvFile functions are loaded (more on that in a moment), this is how you'd use them in a Shiny app:

library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      csvFileInput("datafile", "User data (.csv format)")
    ),
    mainPanel(
      dataTableOutput("table")
    )
  )
)

server <- function(input, output, session) {
  datafile <- callModule(csvFile, "datafile",
                         stringsAsFactors = FALSE)
  
  output$table <- renderDataTable({
    datafile()
  })
}

shinyApp(ui, server)

#The UI function csvFileInput is called directly, using "datafile" as the id. In this case, we're inserting the generated UI into the sidebar.

# The module server function is not called directly; instead, call the 'callModule' function, and provide 
# the module server function as the first argument. The second argument to 'callModule' is the ID that 
# we will use as the namespace; this must be exactly the same as the 'id' argument we passed to 'csvFileInput'. 
# The 'callModule' function is responsible for creating the namespaced 'input', 'output', and 'session' arguments.

# Like all Shiny modules, csvFileInput can be embedded in a single app more than once. Each call 
# must be passed a unique id, and each call must have a corresponding callModule on the server side with that same id.