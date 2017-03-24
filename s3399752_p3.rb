require 'json'
require 'thor'
class Trends < Thor

 #The description of all available options
  desc "list_trends","Lists all of the countries trending on Twitter"

  #Options declaration for the command line
  method_options :'api-key' => :String
  method_options :'format-oneline' => :boolean
  method_options :'no-country-code' =>:boolean

  #The method that processes the functions (for trying to avoid saying main method)
  #The keyword argument is to search for specific countries beginning with the keyword
  #It is initialized for the purpose of allowing the user to enter the program without supplying arguments
  def list_trends(keyword = "")
    #variable passers, is a variable that becomes false, thereby the option is activated,
    standard_passer = true
    oneline_passer = true
    no_country_code_passer = true

    #checking if the api-key was entered, and that it is of the right format, e.g.
    #containing a number, a letter, and is at least 8 chars long, using regex
    if options[:'api-key'] =~ /\D/ && options[:'api-key'] =~ /\d/ && options[:'api-key'].size >=8
      #checking if the option format-oneline was selected
      unless options[:'format-oneline']
        oneline_passer = false
      end
      #checking if the option no-country-code was selected
      unless options[:'no-country-code']
        no_country_code_passer = false
      end
      #if neither oneline_passer or no_country_code_passer selected, standard_passer is activated
      #standard_passer is the regular was of printing out the trends
      if oneline_passer || no_country_code_passer
        standard_passer = false
      end
      # print method which prints in various ways, according to options selected. It is defined below
      loop_and_print(keyword,oneline_passer,no_country_code_passer,standard_passer)
    #If the API wasn't entered, or was entered incorrectly
    else
      puts "Invalid API, aborting..."
    end
  end
end
#The method definition for various ways of printing, as for options
def loop_and_print (keyword,oneline_passer,no_country_code_passer,standard_passer)
  #Accesses, reads, and converts to a manageable hashmap the json file with the data (trends)
  json = File.read('trends.json')
  data_hash = JSON.parse(json)
  json = File.read('trends.json')
  data_hash = JSON.parse(json)
  #loops through each line of data, and prints out everything that is required according to the format specified
  data_hash.each do |i|
    #The keyword is downcased, so that input "Chi" and "chi" will yield the same results
    if (i['country'].downcase).include? (keyword.downcase)
      #If oneline_passer is selected, prints in this format, but WITH the country code.
      if oneline_passer && !no_country_code_passer
        puts "#{i['country']} #{i['countryCode']} #{i['name']}"
      end
      #If no_country_code_passer is selected, prints in this format, but NOT in one line.
      if no_country_code_passer && !oneline_passer
        puts "Trend Country: #{i['country']}"
        puts "Trend Location Name: #{i['name']}"
        puts "Trend Location Place Type: #{i['placeType']['name']}"
        puts "----------------------------------------------------------"
      end
      #If oneline_passer and no_country_code_passer are selected, prints in this format, both in one line, and
      #without the country code.
      if no_country_code_passer && oneline_passer
        puts "#{i['country']} - #{i['name']}"
      end
      #finally, if none of those options were selected, it prints the trends standardly.
      if standard_passer
        puts "Trend Country: #{i['country']}"
        puts "Trend Country Code: #{i['countryCode']}"
        puts "Trend Location Name: #{i['name']}"
        puts "Trend Location Place Type: #{i['placeType']['name']}"
        puts "----------------------------------------------------------"
      end
    end
  end
end
#The main method in order to run the program with thor.
Trends.start
