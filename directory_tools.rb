require 'fileutils'

#
#  Static methods for reading/writing to the project directory structure
#
class DirectoryTools

  # Result is an array with paths for all files
  # including files of sub folders
  #
  # @param [String] path
  #
  # @return [Array<String>]
  def self.get_folder_content(path)
    #clean path
    path.strip!
    unless path.end_with? "/" # adds trailing '/' if missing
      path << "/"
    end
    
    folder_path = format('%s**/*.*',path)
    file_listing = Dir[folder_path]
  end
  
  # creates a new directory on the same level as an existing one
  #
  # @param [String] original_location
  # @param [String] new_directory_name
  #
  # @return [String]
  def self.new_dir_on_same_level(original_location,new_directory_name)
    parent_dir = File.expand_path("..", original_location)
    clone_location = format("%s/%s/",parent_dir,new_directory_name)
    
    begin
      Dir.mkdir clone_location
    rescue Errno::EEXIST
      puts format("Directory '%s' already exists: try a fresh project name",new_directory_name)
      exit
    end
    return clone_location
  end
  
  # Copies file create directory if its missing
  #
  # @param [String] source
  # @param [String] destination
  def self.copy_file_with_path(source, destination)
    FileUtils.mkdir_p(File.dirname(destination))
    FileUtils.cp(source, destination)
  end
  
end
