# PowerShell Utilities
Collection of PowerShell scripts for various automation tasks.

1. **rsyncPS.ps1:** This script synchronizes files between source and target directories, creating subdirectories as needed. It uses PowerShell to provide functionality similar to rsync in Unix-based systems. The script can be used to sync files between on-premises directories and Azure storage, or between directories within a local network. Each file synchronization is logged to a log file with the date and time.

### Parameters for rsyncPS.ps1
------------------------------------------------------------------------------------------------------------------------------
| Parameter   | Description                                                                                       | Required |
|-------------|---------------------------------------------------------------------------------------------------|----------|
| `source`    | The source directory path.                                                                        | Yes      |
| `target`    | The target directory path.                                                                        | Yes      |
| `syncMode`  | The synchronization mode (1 for one-way sync, 2 for two-way sync).                                | No       |
| `debug`     | Enable or disable debug mode.                                                                     | No       |
| `log`       | Enable or disable logging of file synchronization details.                                        | No       |
------------------------------------------------------------------------------------------------------------------------------

2. **Compress.ps1:** This script compresses files in a specified directory and its subdirectories that are older than a specified number of days. The compressed files are saved in the same directory with the same name as the original file, but with a .zip extension. It includes options to remove the original files after compression and to include subdirectories in the compression process. This script requires PowerShell version 5.0 or later.

### Parameters for Compress.ps1
______________________________________________________________________________________________________________________________
| Parameter              | Description                                                                            | Required |
|------------------------|---------------------------------------------------------------------------------------------------|
| `Directory`            | Specifies the directory to search for files to compress.                               | Yes      |
| `DestinationDirectory` | Specifies the directory where the compressed files should be saved. If not specified,  | NO       |
|                          the compressed files will be saved in the same directory as the original files.        |          |
| `Days`                 | Specifies the number of days for which files should be compressed.                     | Yes      |
| `RemoveOriginal`       | Specifies whether to remove the original files after compression.                      | No       |
| `Recurse`              | Specifies whether to include subdirectories.                                           | No       |
------------------------------------------------------------------------------------------------------------------------------
