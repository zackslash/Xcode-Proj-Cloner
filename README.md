# Xcode-Proj-Cloner
Clone your Xcode projects with this ruby script.

This tool will clone your full project into a new one with a new name; it will also replace all old name references in the clone with the shiny new one.

## Usage
1. In terminal run ```ruby xcode_project_cloner.rb``` from this repos directory.
2. The script will prompt you to enter the root path of the project you would like to clone 
  e.g.```/Users/luke/Desktop/myproject1```.
3. You will be prompted to enter the new name for the project's clone e.g.```awesomeproject```.
4. If the script detects more than one project in the root folder it will prompt you to select the primary project for cloning if there is only a single project this step will be skipped.
5. Your project is now sucessfully cloned into a new project with the new name and all references to the old name in the new project will have been replaced with the new name. You will find your new cloned project directory on the same level as the original.
