clear
cd $PSScriptRoot
Import-Module .\Remove-EmptyDirectories.psm1 -Force
cd "d:\Photographs\Processing\"
Remove-EmptyDirectories  -Recurse -FirstRemoveThumbDbFromEmptyDirectories -Verbose
