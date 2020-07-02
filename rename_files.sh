#! /usr/bin/env bash
#
# Name: rename_files.sh
#
# Brief: Command-line Bash script to remove common text in multiple LibreOffice
# .odt filenames in 1 directory - so filenames are shorter & easier-to-read.
# Takes in 3 parameters at command line, e.g.,
# directory path:       /Users/kimlew/Sites/bash_projects/test_rename_files
# string to replace:    'Inkscape Essent Train-'
# replacement_string:   nothing or ''
#
# Author: Kim Lew

check_for_arguments() {
  # Passes in the all 3 args with $@.
  # Check if arguments are provided. If no arguments given, display user prompts.
  if [ $# -gt 3 ]; then 
    # Case of 4 or more parameters given.
    echo "Give 3 command-line arguments. Or give 0 arguments & get prompts."
    exit 1
  fi

  if [ "$#" -eq 0 ]; then # Show prompts.
    # Save old IFS value & restore it after last read command.
    OLD_IFS=$IFS
    IFS=''
    
    echo "$need_single_quotes"
    echo "Type the directory path: "
    read -r directory_path
  
    echo "Type the old text: "
    read -r old_text

    echo "Type the new text: "
    read -r new_text
    IFS=$OLD_IFS
  elif [ $# -lt 3 ]; then # Not enough command-line arguments given. Need 2 or 3.
    echo "$need_single_quotes"
    if [ $# -lt 2 ]; then # If given 1 command-line argument.
      echo "For parameter 2: Type the old text."
    fi
    # If given 2 command-line arguments. 
    # Note: If no 3rd argument given, it is interpreted as '' empty string, i.e.,
    # if [ ! "$3" ]; then
    #  replacement_string=''
    # fi
    echo "For parameter 3: Type the new text."
    exit 1
  else # Gave required 3 command-line arguments.
    directory_path="$1"
    old_text="$2"
    new_text="$3"
  fi
}

print_arguments() {
  echo "Directory path: $directory_path"
  check_directory "$directory_path"

  echo "Old text: $old_text"
  echo "New text: $new_text"
  echo
}

check_directory() {
  if [ ! -d "$directory_path" ] 
  then
    echo "This directory does NOT exist."
    exit 1
  fi
}

need_single_quotes='If the path or text has ANY spaces, put entire argument in single-quotes.'
check_for_arguments "$@" # For the actual arguments. # For number of args, use $#.
print_arguments

echo "Checking files..."
file_sort_counter=0
start=$(date +%s)

while read -r a_file_name; do
  # Replace only 1st match: ${string/pattern/replacement}
  # NOTE: Tricky since pattern must be in the specific format above & CANNOT be 
  # a variable.
  echo "Looking at file:" "$a_file_name"

  # TODO: 
  # if ($old_text found in this file); then
  #   echo "$old_text was found in $a_file_name"
  #   new_file_name="${a_file_name/$old_text/$new_text}"
  #   mv "$a_file_name" "$new_file_name"
  #   file_sort_counter="$((file_sort_counter+1))"
  # fi
done  < <(find "${directory_path%/}" -maxdepth 1 -type f -name '*.odt')
echo
echo "DONE. Number of files renamed: " "${file_sort_counter}"

end=$(date +%s)
difference=$((end - start))
echo "Renaming files took:" $((difference/60)) "min(s)" $((difference%60)) "sec(s)" 

if [ "${file_sort_counter}" -eq 0 ]; then
  echo "$old_text was not found in filenames or there are no .odt files at the top-level of the path."
fi
echo

exit 0
