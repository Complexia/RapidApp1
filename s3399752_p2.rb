require 'thor'

class Greet < Thor #The class is a thor
  #Thor style command line description of available options
  desc "welcome", "Prints 'Welcome ${name}' to the console"

  #requires an argument to work, otherwise will return error
  def welcome(name)
   #Welcomes the name
   puts "Welcome #{name}!" 
  end
end
#The main method in order to run the program with thor.
Greet.start
