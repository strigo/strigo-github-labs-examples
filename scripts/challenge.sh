# Description: Create a file in the home directory
touch ~/strigo.txt
# Validate the file was created
ls -l ~/strigo.txt
# If the file was created, ls should result in code 0
exit $?
