<#
.SYNOPSIS
    Synchronize files between source and target directories, creating subdirectories as needed.

.DESCRIPTION
    This script uses PowerShell to synchronize files between two directories, similar to rsync functionality in Unix-based systems.
    lIt ogs each file synchronization to a README file with the date and time.

.PARAMETER source
    The source directory path.

.PARAMETER target
    The target directory path.

.PARAMETER syncMode
    The synchronization mode (1 for one-way sync, 2 for two-way sync).

.PARAMETER debug
    Enable or disable debug mode.
.EXAMPLE
    pwsh -File "r:\ps\rsyncPS.ps1" -source "T:\sourceFolder" -target "\\stg.file.core.windows.net\backup" -syncMode 1 -debug:$false
.NOTES
    Developed by: Mamdoh Alhabeeb
    Date: 2025-02-05
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$source,

    [Parameter(Mandatory=$true)]
    [string]$target,

    [Parameter(Mandatory=$false)]
    [int]$syncMode = 1,

    [Parameter(Mandatory=$false)]
    [switch]$debug1
)

function rsync ($source,$target, $syncMode = 1, $debug = $false)
 {
  
    azcopy login --identity
  # Create the destination folder if it does not exist
    if (-not (Test-Path -Path $target)) {
        try {
            New-Item -Path $target -ItemType Directory | Out-Null
            
        } catch {
            Write-Output "Error creating the folder '$target'. Error: $_"
            exit 1
        }
    } 

    #Path to Logfile
    $readmeFilePath = Join-Path -Path $target -ChildPath "logfile.txt"

    # Create README file with the date and time of folder creation
    if (-not (Test-Path -Path $readmeFilePath)) {
    
    $currentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $readmeContent = "This folder was created on $currentDateTime"
    Set-Content -Path $readmeFilePath -Value $readmeContent
    }

  $sourceFiles = Get-ChildItem -Path $source -Recurse
  $targetFiles = Get-ChildItem -Path $target -Recurse

  if ($debug -eq $true) {
    Write-Output "Source=$source, Target=$target"
    Write-Output "sourcefiles = $sourceFiles"
    Write-Output "TargetFiles = $targetFiles"
  }
    
 
  if ($sourceFiles -eq $null -and $targetFiles -eq $null) {
    Write-Host "Empty Directory encountered. Skipping file Copy."
  } else {
  
    $diff = Compare-Object -ReferenceObject $sourceFiles -DifferenceObject $targetFiles

    foreach ($f in $diff) {
      if ($f.SideIndicator -eq "<=") {
        $fullSourceObject = $f.InputObject.FullName
        #$fullTargetObject = $f.InputObject.FullName.Replace($source,$target)
        $relativePath = $fullSourceObject.Substring($source.Length)
        $fullTargetObject = Join-Path -Path $target -ChildPath $relativePath
        #write-host "Directory '$target'" -ForegroundColor Yellow  

       
         # Ensure the source and target are not the same

                if ($fullSourceObject -ne $fullTargetObject) {
                    # Check if the target file exists and if the source file is newer
                    if (-not (Test-Path -Path $fullTargetObject) -or (Get-Item $fullSourceObject).LastWriteTime -gt (Get-Item $fullTargetObject).LastWriteTime) {
                        # Create subdirectory if it does not exist
                        $targetDir = Split-Path $fullTargetObject -Parent
                        if (-not (Test-Path -Path $targetDir)) {
                            try {
                                New-Item -Path $targetDir -ItemType Directory | Out-Null
                            } catch {
                                Write-Output "Error creating the folder '$targetDir'. Error: $_"
                                continue
                            }
                        }
                     
                              
                    $currentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss" 
                    Write-Host "Attempt to copy the following:  $fullSourceObject " -NoNewline;write-host "$currentDateTime" -ForegroundColor Yellow 
                   #Write-Host "Attempt to copy the following: " $fullSourceObject
                    Copy-Item -Path $fullSourceObject -Destination $fullTargetObject -Force

                   
                    # Log file sync details in README file                    
                    $logContent = "Copied $fullSourceObject to $fullTargetObject at $currentDateTime`n"
                   # Add-Content -Path $readmeFilePath -Value $logContent
                  }
                }
            }

      if ($f.SideIndicator -eq "=>" -and $syncMode -eq 2) {
        $fullSourceObject = $f.InputObject.FullName
        #$fullTargetObject = $f.InputObject.FullName.Replace($target,$source)
        $relativePath = $fullSourceObject.Substring($source.Length)
        $fullTargetObject = Join-Path -Path $target -ChildPath $relativePath
        #write-host "Directory '$target'" -ForegroundColor Yellow 

                # Ensure the source and target are not the same
                if ($fullSourceObject -ne $fullTargetObject) {
                    # Check if the target file exists and if the source file is newer
                    if (-not (Test-Path -Path $fullTargetObject) -or (Get-Item $fullSourceObject).LastWriteTime -gt (Get-Item $fullTargetObject).LastWriteTime) {
                        
                         # Create subdirectory if it does not exist
                        $sourceDir = Split-Path $fullTargetObject -Parent
                        if (-not (Test-Path -Path $sourceDir)) {
                            try {
                                New-Item -Path $sourceDir -ItemType Directory | Out-Null
                            } catch {
                                Write-Output "Error creating the folder '$sourceDir'. Error: $_"
                                continue
                            }
                         }   
                
                        $currentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss" 
                        Write-Host "Attempt to copy the following:  $fullSourceObject " -NoNewline;write-host "$currentDateTime" -ForegroundColor Yellow 
       
                        Copy-Item -Path $fullSourceObject -Destination $fullTargetObject -force
                       
                         # Log file sync details in README file
                        $currentDateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                        $logContent = "Copied $fullSourceObject to $fullTargetObject at $currentDateTime`n"
                        #Add-Content -Path $readmeFilePath -Value $logContent
                        }
                    }
                }
            }
        }
}


rsync -source $source -target $target -syncMode $syncMode -debug:$debug1

