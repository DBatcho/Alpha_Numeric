# Minitab

MyApp.ps1

PowerShell script that reads the contents of a file with comma separated values from disk and
prints the numeric and/or alphabetic values from the file depending on what the user requests.

Takes 3 parameters:
1. Path to the file on disk
2. String value which defines the type of sorted values requested. Valid values are: "alpha",
"numeric", "both"
3. String value which defines the sort order. Valid values are: "ascending", "descending"
