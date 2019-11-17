#! /usr/bin/env bash
#
# Name: replace_substring_in_filenames.sh
#
# Brief: Command-line Bash script to remove repeated substring in multiple 
# LibreOffice .odt files in 1 directory - so filenames are shorter & 
# easier-to-read. Takes in 3 parameters at command line, e.g.,
# directory path:       /Users/kimlew/Sites/bash_projects/test_rename_files
# string to replace:    'Inkscape Essent Train-'
# replacement_string:   nothing or ''
#
# REMEMBER: If command-line arguments have spaces, put in single-quotes!
# Note: Script processes only a single directory. 
#
# Author: Kim Lew

# Check if arguments are provided. If no arguments given, display user prompts 
# of what to enter.
if [ $# -eq 0 ]; then
  # Save old IFS value & restore it after last read command.
  OLD_IFS=$IFS
  IFS=''
  echo "Type the directory path for filenames that need changes: "
  read directory_path
  
  echo "Type the string to replace: "
  read string_to_replace

  echo "Type the replacement string: "
  read replacement_string
  IFS=$OLD_IFS
else
  if [ ! "$1" ]; then
    echo "Enter the directory path as the 1st parameter." 
    exit 1
  fi
  if [ ! "$2" ]; then
    echo "Enter the string to replace as the 2nd parameter." 
    exit 1
  fi
  
  # Note: If no 3rd argument given, then is interpreted as '' empty string.
  # if [ ! "$3" ]; then
  #  replacement_string=''
  # fi
  directory_path=$1
  string_to_replace=$2
  replacement_string=$3
fi

echo "Directory path you typed: $directory_path"
echo "String to replace you typed: $string_to_replace"
echo "Replacement string you typed: $replacement_string"
echo

if [ ! -d "$directory_path" ] 
then
    echo "This directory does NOT exist."
    exit 1
fi

echo "Filename change in progress..."
echo "..."

find "$directory_path" -type f -name '*.odt' |
while read a_file_name; do
  # Replace only 1st match: ${string/pattern/replacement}
  # NOTE: Tricky since pattern must be in the specific format above & CANNOT be 
  # a variable.

  new_file_name="${a_file_name/$string_to_replace/$replacement_string}"
  mv "$a_file_name" "$new_file_name"
done
echo "Done."

exit 0
