<#
.SYNOPSIS
Compresses files in a directory and its subdirectories that are older than a specified number of days.

.DESCRIPTION
This script compresses all files in the specified directory and its subdirectories that are older than a specified number of days. The compressed files are saved in the same directory with the same name as the original file, but with a .zip extension.

.PARAMETER Directory
Specifies the directory to search for files to compress.

.PARAMETER Days
Specifies the number of days for which files should be compressed.

.PARAMETER RemoveOriginal
Specifies whether to remove the original files after compression.

.PARAMETER Recurse
Specifies whether to include subdirectories.

.EXAMPLE
# Compresses all files in the specified directory and its subdirectories that are older than 30 days.
Compress-Files -Directory "C:\Path\To\Directory" -Days 30

# Compress files in the specified directory and its subdirectories
Compress-Files -Directory "C:\MyDirectory" -Days 7 -Recurse -Verbose

# Compress files in the specified directory only (no subdirectories)
Compress-Files -Directory "C:\MyDirectory" -Days 7 -Verbose

.NOTES
This script requires PowerShell version 5.0 or later.

Author: Mamdoh Alhabeeb
Created 2023-03-08
#>

function Compress-Files {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_ -PathType 'Container'})]
        [string]$Directory,

        [Parameter(Mandatory=$true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$Days,

        [switch]$RemoveOriginal,
        [switch]$Recurse
    )

    # Get all files in the specified directory (and optionally its subdirectories) that are older than $days
    $childItemParams = @{
        Path = $Directory
        File = $true
        Recurse = $Recurse.IsPresent
    }

    $filesToCompress = Get-ChildItem @childItemParams | Where-Object {$_.Extension -ne ".zip" -and $_.LastWriteTime -lt (Get-Date).AddDays(-$Days)}

    # Compress each file using the zip format
    foreach ($file in $filesToCompress) {
        $zipPath = Join-Path -Path $file.DirectoryName -ChildPath ($file.BaseName + ".zip")
        try {
            Compress-Archive -Path $file.FullName -DestinationPath $zipPath -Force
            Write-Verbose "Compressed $($file.FullName) to $($zipPath)"
            if ($RemoveOriginal) {
                Remove-Item $file.FullName -Force
                Write-Verbose "Removed original file $($file.FullName)"
            }
        } catch {
            Write-Error "Failed to com-press $($file.FullName). Error: $_"
        }
    }
}

# Uncomment the following line to enable verbose output
$VerbosePreference = 'Continue'

# Call the Compress-Files function with the specified parameters
Compress-Files -Directory "/Users/Downloads" -Days 180 -RemoveOriginal
