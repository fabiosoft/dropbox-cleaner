## Fix Dropbox conflicts automatically

This script will climb through the **folder tree** and repair all conflict files in that folder IN BULK

Andrew's patch takes script from [ciri](https://stackoverflow.com/users/3263897/ciri) and adds a global name conversion of all directories in folder tree to fix sed case sensitive rename bug caused by Case Conflict syntax in new Dropbox versions (2022)

### Recommended

Make `dropbox-cleaner.sh` file global by declaring its path on .bashrc

Give it an alias in .bashrc i.e. `alias dbox-cleaner='/path-to-dropbox-cleaner/dropbox-cleaner.sh'`

### Usage (with recommendations above)

```ruby 
cd foldertree-with-case-conflict-folders
dbox-cleaner
```



