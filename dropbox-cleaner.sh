#!/bin/bash
'''References:
http://stackoverflow.com/questions/20723868/batch-rename-dropbox-conflict-files
https://community.spiceworks.com/how_to/111611-how-to-change-all-files-folders-to-lowercase-unix
'''

clear

#Point to where you want the script to look and where it should backup files it replaces
folder="$(pwd)"

#make all folder names lowercase recursively (directories deep in folder tree) .sh below is a minimal fork from https://gist.github.com/painejake/838544
bash convert_to_lower-case.sh


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
