# PowerShell
Collection of PowerShell scripts for various automation tasks.

1. **rsyncPS.ps1:** This script synchronizes files between source and target directories, creating subdirectories as needed. It uses PowerShell to provide functionality similar to rsync in Unix-based systems. The script can be used to sync files between on-premises directories and Azure storage, or between directories within a local network. Each file synchronization is logged to a log file with the date and time.

2. **Compress.ps1:** This script compresses files in a specified directory and its subdirectories that are older than a specified number of days. The compressed files are saved in the same directory with the same name as the original file, but with a .zip extension. It includes options to remove the original files after compression and to include subdirectories in the compression process. This script requires PowerShell version 5.0 or later.
