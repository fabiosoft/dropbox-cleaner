#!/bin/bash
'''References:
http://stackoverflow.com/questions/20723868/batch-rename-dropbox-conflict-files
https://community.spiceworks.com/how_to/111611-how-to-change-all-files-folders-to-lowercase-unix
'''

clear

#Point to where you want the script to look and where it should backup files it replaces
folder="$(pwd)"

#make all folder names (including case conflict folders yes) lowercase
rename 'y/A-Z/a-z/' *


echo "This script will climb through the $folder tree and repair conflict files"
echo "Press a key to continue..."
read -n 1
echo "------------------------------"

find "$folder" -type f -print0 | while read -d $'\0' file; do
    newname=$(echo "$file" | sed 's/ (.*case conflict.*)//')   

    if [ "$file" != "$newname" ]; then
        echo "Found conflict file - $file"
        
        if test -f "$newname"
        then
            backupname=$newname.backup
            echo " "
            echo "File with original name already exists, backup as $backupname"
            mv "$newname" "$backupname"
        fi

        echo "moving $file to $newname"

        mv "$file" "$newname"

        echo
fi
done

#make all folder names uppercase (if desired or needed)
rename 'y/a-z/A-Z/' *