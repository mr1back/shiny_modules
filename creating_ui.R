### https://shiny.rstudio.com/articles/modules.html

# Module UI function
csvFileInput <- function(id, label = "CSV file") {
  # Create a namespace function using the provided id
  ns <- NS(id)
  
  tagList(
    fileInput(ns("file"), label),
    checkboxInput(ns("heading"), "Has heading"),
    selectInput(ns("quote"), "Quote", c(
      "None" = "",
      "Double quote" = "\"",
      "Single quote" = "'"
    ))
  )
}


# 1. The function body starts with the statement 'ns <- NS(id)'. All UI function bodies should start with this line. It takes the string 'id' and creates a namespace function.
# 2. Anything input or output ID of any kind that appears in the function body needs to be wrapped in a call to 'ns()'. This example shows 'inputId' arguments being wrapped in 'ns()'; you also want to use 'ns()' when declaring a 'plotOutput' brush ID, for example.
# 3. The results are wrapped in 'tagList', instead of 'fluidPage', 'pageWithSidebar', etc. You only need to use 'tagList' if you want to return a UI fragment that consists of multiple UI objects; if you were just returning a 'div' or some specific input, you could skip 'tagList'.

#Admittedly, the 'ns()' mechanism isn't very elegant. What it buys us makes it worth it, though. Thanks to the namespacing, we only need to make sure that the IDs "file", "heading", and "quote" are unique within this function, rather than unique across the entire app.

