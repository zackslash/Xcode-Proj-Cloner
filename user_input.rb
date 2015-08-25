#
#  Static methods for console IO
#
class UserInput

  # Prompt for user to enter xcode project path
  #
  # @return [String]
  def self.get_project_path
    system "clear" or system "cls"
    puts "Enter Xcode project root path"
    in_path = gets.chomp
  
    unless in_path.length > 0
        return get_project_path()
      else
        return in_path
    end
  end

  # prompts for user to enter the new name for the
  # cloned copy of the project
  #
  # @return [String]
  def self.get_project_clone_name
    system "clear" or system "cls"
    puts "Enter a new project name for the cloned project"
    in_name = gets.chomp
  
    unless in_name.length > 0
      return get_project_clone_name()
    else
      return in_name
    end
  end
  
  # prompts for user to select the project name from 
  # a list of options
  #
  # @return [String]
  def self.select_project_name(options)
    system "clear" or system "cls"
    puts "Enter number of the project name to clone\n"
	count = 1
    for name in options
      puts format('%i. %s',count,name)
      count += 1
    end
    
    in_selection = gets.chomp
    unless in_selection.length > 0 && is_number?(in_selection) && Integer(in_selection) <= options.length && Integer(in_selection) > 0
      return select_project_name(options)
    else
      return options[(Integer(in_selection)-1)]
    end
  end
  
  # checks that string contains a valid number
  #
  # @return [Boolean]
  def self.is_number? string
    true if Float(string) rescue false
  end
  
end
