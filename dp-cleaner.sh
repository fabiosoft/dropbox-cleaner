#!/bin/bash

#Thx, http://stackoverflow.com/questions/20723868/batch-rename-dropbox-conflict-files

#Point to where you want the script to look and where it should backup files it replaces
folder="$(pwd)"
backup=~/Desktop/Dropbox.backup

#colors
red='\033[0;31m'
purple='\033[1;35m'
NC='\033[0m' # No Color

clear


echo "This script will climb through the $folder tree and repair conflict files by deleting the OLDER of the the conflicted file and its counterpart"
if [[ $1 == "replace" ]]; then
    echo -e "${red}This is NOT a drill.${NC} The script will backup the older of the conflicted files and then delete it from the Dropbox directory."
else
    echo -e "${purple}This is a dry run.${NC} You'll see what files would be replaced. Run \"./Dropbox.sh replace\" to make it run for real."
fi
echo "Press any key to continue..."
echo "------------------------------"
read -n 1

find "$folder" -type f -print0 | while read -d $'\0' file; do
    newname=$(echo "$file" | sed 's/ (.*conflitto.*)//')

    if [ "$file" != "$newname" ]; then
        if [ -f "$newname" ];then
            # determine which is newer
            if [ "$newname" -nt "$file" ]; then
                echo "$newname is NEWER than $file"
                file_to_move="$file"
                file_to_keep="$newname"
            else
                echo "$newname is OLDER than $file"
                file_to_move="$newname"
                file_to_keep="$file"
            fi

            backupname=${newname/"$folder"/"$backup"}

            if [[ $1 != "replace" ]]; then
                echo "Would have moved $file_to_move to $backupname"
            else
                echo "Moving $file_to_move to $backupname"
                mkdir -p "$(dirname "$backupname")"
                cp "$file_to_move" "$backupname"
                mv "$file_to_keep" "$newname"
            fi
        else
            # if the unconflicted version isn't there for some reason, just rename the original
            if [[ $1 != "replace" ]]; then
                echo "Didn't see an unconflicted counterpart for $file, so would have just renamed file"
            else
                echo "Didn't see an unconflicted counterpart for $file, so will replace"
                mv "$file" "$newname"
            fi
        fi
    fi
done
