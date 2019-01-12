# Module server functions should be named like their corresponding module UI functions, but without 
# the 'Input/Output/UI' suffix. Since our UI function was called 'csvFileInput', we'll call our server function 'csvFile':

# Module server function
csvFile <- function(input, output, session, stringsAsFactors) {
  # The selected file, if any
  userFile <- reactive({
    # If no file is selected, don't do anything
    validate(need(input$file, message = FALSE))
    input$file
  })
  
  # The user's data, parsed into a data frame
  dataframe <- reactive({
    read.csv(userFile()$datapath,
             header = input$heading,
             quote = input$quote,
             stringsAsFactors = stringsAsFactors)
  })
  
  # We can run observers in here if we want to
  observe({
    msg <- sprintf("File %s was uploaded", userFile()$name)
    cat(msg, "\n")
  })
  
  # Return the reactive that yields the data frame
  return(dataframe)
}

# You may notice a lot of similarities to a regular Shiny server function. The first three parameters-'input', 
# 'output', and 'session'-should be familiar. They're required in every module's server function 
# ('session' isn't optional, as it is in a Shiny app server function). The next parameter is specific to this example; 
# you can have as many or as few additional parameters as you want, including ... if it makes sense, and you can use 
# them for whatever you want inside the function body.

# Inside the function body, we can use 'input$file' to refer to the 'ns("file")' component in the UI function. 
# If this example had outputs, we could similarly match up 'ns("plot")' with 'output$plot', for example. The 'input', 
# 'output', and 'session' objects we're provided with are special, in that they are scoped to the specific namespace 
# that matches up with our UI function.

# On the flip side, the 'input', 'output', and 'session' cannot be used to access inputs/outputs that are 
# outside of the namespace, nor can they directly access reactive expressions and reactive values from 
# elsewhere in the application (OK, technically, lexically scoped reactive expressions/values can be used, but that's it).

# These restrictions are by design, and they are important. The goal is not to prevent modules from 
# interacting with their containing apps, but rather, to make these interactions explicit. If a module needs 
# to use a reactive expression, take the reactive expression as a function parameter. If a module 
# wants to return reactive expressions to the calling app, then return a list of reactive expressions from the function.

# If a module needs to access an input that isn't part of the module, the containing app should pass the input value wrapped in a reactive expression (i.e. 'reactive(...)'):
callModule(myModule, "myModule1", reactive(input$checkbox1))