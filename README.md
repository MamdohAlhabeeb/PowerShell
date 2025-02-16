# PowerShell Utilities
Collection of PowerShell scripts for various automation tasks.

1. **rsyncPS.ps1:** This script synchronizes files between source and target directories, creating subdirectories as needed. It uses PowerShell to provide functionality similar to rsync in Unix-based systems. The script can be used to sync files between on-premises directories and Azure storage, or between directories within a local network. Each file synchronization is logged to a log file with the date and time.

### Parameters for rsyncPS.ps1
----------------------------------------------------------------------------------------------------------------------------------------------
| Parameter   | Description                                                                                       | Required | Default Value |
|-------------|---------------------------------------------------------------------------------------------------|----------|---------------|
| `source`    | The source directory path.                                                                        | Yes      | N/A           |
| `target`    | The target directory path.                                                                        | Yes      | N/A           |
| `syncMode`  | The synchronization mode (1 for one-way sync, 2 for two-way sync).                                | No       | 1             |
| `debug`     | Enable or disable debug mode.                                                                     | No       | $false        |
| `log`       | Enable or disable logging of file synchronization details.                                        | No       | $false        |
----------------------------------------------------------------------------------------------------------------------------------------------

2. **Compress.ps1:** This script compresses files in a specified directory and its subdirectories that are older than a specified number of days. The compressed files are saved in the same directory with the same name as the original file, but with a .zip extension. It includes options to remove the original files after compression and to include subdirectories in the compression process. This script requires PowerShell version 5.0 or later.

### Parameters for Compress.ps1
----------------------------------------------------------------------------------------------------------------------------------------------
| Parameter              | Description                                                                            | Required | Default Value |
|------------------------|----------------------------------------------------------------------------------------|----------|---------------|
| `Directory`            | Specifies the directory to search for files to compress.                               | Yes      | N/A           |
| `DestinationDirectory` | Specifies the directory where the compressed files should be saved. If not specified,  | No       | Same as source|
|                        | the compressed files will be saved in the same directory as the original files.        |          |               |
| `Days`                 | Specifies the number of days for which files should be compressed.                     | Yes      | N/A           |
| `RemoveOriginal`       | Specifies whether to remove the original files after compression.                      | No       | $false        |
| `Recurse`              | Specifies whether to include subdirectories.                                           | No       | $false        |
----------------------------------------------------------------------------------------------------------------------------------------------
