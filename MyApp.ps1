param
(
    # Path to the input file
    [Parameter(Mandatory=$true)]
    [string]$filePath,

    # Type of values to be filtered
    [Parameter(Mandatory=$true)]
    [ValidateSet("alpha", "numeric", "both")]
    [string]$valueType,

    #Order in which to sort the filtered values
    [Parameter(Mandatory=$true)]
    [ValidateSet("ascending", "descending")]
    [string]$sortOrder
)

# Verify that the file exists
if (-not (Test-Path $filePath)) 
{
    Write-Error "File does not exist."
    return
}

# Load file contents into a variable
$contents = Get-Content -Path $filePath

# Validate that the file isn't empty or only contains whitespace
if ($contents -match "^\s*$") {
    Write-Error "The file is empty or only contains whitespace."
    return
}

<# 
Determine the delimiter used in the file.
If the contents contain a comma followed by a space (", "), that's our delimiter.
Otherwise, it's just a comma (",").
#>
$delimiter = if ($contents -like "*, *") { ", " } else { "," }

# Split, Trim, and Process the values
$values = $contents -split $delimiter | 
    ForEach-Object { $_.Trim() } |
    ForEach-Object {
    # If value can be cast to double, do so. Otherwise, leave it as string. (solves exponent)
    if ($_ -match "^-?\d*\.?\d+([eE][-+]?\d+)?$") {
        [double]$_
    } else {
        $_
    }
  }

# Filter the values based on the specified valueType
$sortValues = switch ($valueType) 
{
    "alpha" 
    {
        $values | Where-Object { $_ -match "^[a-zA-Z]+$" -or $_ -match "^'.*'$" }
    }
    "numeric" 
    {
        $values | Where-Object { $_ -is [double] }
    }
    "both" 
    {
        $values
    }
}

# Verify that there are values of the specified type after filtering
if ($sortValues.Count -eq 0) {
    Write-Error "After filtering, the file contains no values of $valueType."
    return
}

# Sort the values based on the specified sortOrder
$sortValues = if ($sortOrder -eq "ascending") 
{
    $sortValues | Sort-Object { $_ }
} 
else  
{
    $sortValues | Sort-Object { $_ } -Descending
}

# Display the sorted values
$sortValues -join $delimiter