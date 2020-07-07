# Bash script to rename multiple files in 1 directory

Name: `rename_files.sh`

Command-line Bash script to replace a common substring in multiple files, 
e.g., removes part of filename that is common to several .odt files.

Makes filenames shorter & easier-to-read. 

Takes 3 arguments at command line, e.g.,
- Directory Path: `/Users/kimlew/Sites/bash_projects/test_rename_files`
- Old Text: `'Inkscape Essent Train-'`
- New Text: nothing or `''`

OR gives user prompts if 0 arguments given.
