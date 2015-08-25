#!/usr/bin/env ruby
# Creates a clone of an xcode project updating the 
# project paths and and all project references

$LOAD_PATH << '.'
require 'directory_tools'
require 'user_input'

# Extracts available project names from '.pbxproj' files
# 
# @param [Array<String>] file_array
#
# @return [Array<String>]
#
def get_available_project_names(file_array)
  name_results = Array.new
  for project_file in file_array
    if project_file.end_with? ".pbxproj"
      file = File.open(project_file, "rb")
      file_contents = file.read
      results = file_contents.scan(/productName = ([^;]*);|PRODUCT_NAME = ([^;]*);/)
      name_results.concat(results)
    end
  end
  
  clean_name_results = name_results.flatten(1).uniq
  clean_name_results -= %w{"$(TARGET_NAME)"} #Remove irrelevant items
  
  if clean_name_results.length > 1 #If there are multiple results remove 'tests' if it wont leave 0 items
  	test_count = 0
	
	for matched_project_name in file_array
	  if matched_project_name.end_with? "Tests"
        test_count += 1
	  end
	end
	
	if test_count < clean_name_results.length
      clean_name_results.delete_if {|i| i.to_s == ''}
  	  clean_name_results.delete_if {|i| i.end_with? "Tests"}
  	end
  end
  
  return clean_name_results
end

# Clone a file from the original project into new location replacing references if relevant
# 
# @param [String] original_name
# @param [String] new_name
# @param [Boolean] only_folders
# @param [String] original_project_path
# @param [String] original_file_path
# @param [String] new_clone_directory
#
def clone_project_file(original_name,new_name,only_folders,original_project_path,original_file_path,new_clone_directory)
  file_name = original_file_path.sub(original_project_path,"")
  
  #substitute old file names for new ones
  file_name.gsub! original_name, new_name
  
  new_file_location = format('%s/%s',new_clone_directory,file_name)
  new_file_location.gsub! '//','/'
    
  if File.directory?(original_file_path)
    FileUtils.mkdir_p new_file_location
  else
    if not only_folders
      DirectoryTools.copy_file_with_path(original_file_path,new_file_location)
      
      # Replace references
      if original_file_path.end_with? ".pbxproj" or original_file_path.end_with? ".xcscheme"
        fileres = File.open(original_file_path, "rb")
        file_contents = fileres.read
        file_contents.gsub! original_name,new_name
    
        begin
          file = File.open(new_file_location, "w")
          file.write(file_contents) 
        rescue IOError => e
          puts 'Error writing to the new project location'
          exit
        ensure
          file.close unless file.nil?
        end
      end
    end
  end
  
  puts new_file_location
end

xcode_project_path = UserInput.get_project_path()
project_clone_name = UserInput.get_project_clone_name()
xcode_project_files = DirectoryTools.get_folder_content(xcode_project_path)
project_names = get_available_project_names(xcode_project_files)
project_name = ''

if project_names.length > 0
  if project_names.length == 1
    # Take only name
    project_name = project_names[0]
  else
    # Prompt user to select name
    project_name = UserInput.select_project_name(project_names)
  end
else
  puts 'No project names found: Check your input path is for an xcode project.'
  exit
end

# Create new project directory
xcode_clone_path = DirectoryTools.new_dir_on_same_level(xcode_project_path,project_clone_name)

# Clone directory structure
xcode_project_files.each { |x| clone_project_file(project_name,project_clone_name,true,xcode_project_path,x,xcode_clone_path) } 

# Clone files replacing project references
xcode_project_files.each { |x| clone_project_file(project_name,project_clone_name,false,xcode_project_path,x,xcode_clone_path) }

puts "Complete..."
