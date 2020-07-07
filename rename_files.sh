#! /usr/bin/env bash
#
# Name: rename_files.sh
#
# Brief: Command-line Bash script to remove common text in multiple LibreOffice
# .odt filenames in 1 directory - so filenames are shorter & easier-to-read.

# Takes in 3 parameters at command line, e.g.,
# Directory Path:       /Users/kimlew/Sites/bash_projects/test_rename_files
# Old Text:    'Inkscape Essent Train-'
# New Text:   nothing or ''

# OR gives user prompts if 0 arguments given.

# Author: Kim Lew

check_for_arguments() {
  # Check if command-line arguments given. If user gives:
  # 3+ arguments - see message with hint that this is wrong.
  # 3 arguments - passes in the all args with $@.
  # 1 or 2 arguments - see message with hint of what is wrong.s
  # 0 arguments - display user prompts for each of 3 required inputs.

  if [ $# -gt 3 ]; then 
    # Case of 4 or more parameters given.
    echo "Give 3 command-line arguments. Or give 0 arguments & get prompts."
    exit 1
  fi

  if [ "$#" -eq 0 ]; then # Show prompts.
    # Save old IFS value & restore it after last read command.
    OLD_IFS=$IFS
    IFS=''
    
    echo "Type the directory path: "
    read -r directory_path
  
    echo "Type the old text: "
    read -r old_text

    echo "Type the new text: "
    read -r new_text
    IFS=$OLD_IFS
  elif [ $# -lt 3 ]; then # Not enough command-line arguments given. Requires 3.
    echo "$need_single_quotes"
    echo "3 arguments are required."
    if [ $# -lt 2 ]; then # Show message when user only gives 1 command-line argument.
      echo "You are missing 2 arguments."
    else
      # Show message when user only gives 2 command-line arguments. 
      echo "You are missing 1 argument."
    fi
    # Note: You must give '' empty string as 3rd argument if you want to replace 
    # with nothing , i.e., remove text.
    exit 1
  else # Gave required 3 command-line arguments.
    directory_path="$1"
    old_text="$2"
    new_text="$3"
  fi
}

print_arguments() {
  directory_path=${directory_path}

  echo "Checking:"
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

need_single_quotes="If argument has SPACES, place argument within single quotes."
check_for_arguments "$@"
print_arguments

echo "Checking files..."
file_sort_counter=0
start=$(date +%s)

while read -r a_file_name; do
  # Replace only 1st match: ${string/pattern/replacement}
  # NOTE: Tricky since pattern must be in the specific format above & CANNOT be 
  # a variable.
  # -e - flag for indicating the pattern you want to match against.

  if (echo "$a_file_name" | grep -q -e "$old_text"); then
    echo "FOUND $old_text IN:" "$(basename "$a_file_name")"
    new_file_name="${a_file_name/$old_text/$new_text}"
    mv "$a_file_name" "$new_file_name"
    file_sort_counter="$((file_sort_counter+1))"
  fi
done  < <(find "${directory_path}" -maxdepth 1 -type f -name '*.odt')
echo
echo "DONE. Number of files renamed: " "${file_sort_counter}"

end=$(date +%s)
difference=$((end - start))
echo "Processing Time:" $((difference/60)) "min(s)" $((difference%60)) "sec(s)" 

if [ "${file_sort_counter}" -eq 0 ]; then
  echo "$old_text was NOT found in filenames or there are NO .odt files at the top-level of the path."
fi
echo

exit 0
