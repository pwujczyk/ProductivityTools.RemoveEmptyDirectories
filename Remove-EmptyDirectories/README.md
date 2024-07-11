# Remove-EmptyDirectories PowerShell Module

This PowerShell module provides a function to recursively find and remove empty directories. It includes a special option to handle directories that only contain a `Thumbs.db` file, making them eligible for removal.

## Features

-   Remove empty directories from a specified path.
-   Optionally recurse through subdirectories.
-   Optionally remove `Thumbs.db` from otherwise empty directories before checking for emptiness.
-   Supports `-WhatIf` and `-Verbose` common parameters for safe and transparent execution.

## Functions

### `Remove-EmptyDirectories`

This is the main function exported by the module.

#### Parameters

-   `-Path <string>`: (Optional) The path to start searching for empty directories. Defaults to the current directory if not provided.
-   `-Recurse`: A switch parameter to enable recursive searching through subdirectories.
-   `-FirstRemoveThumbDbFromEmptyDirectories`: A switch parameter. If present, the script will first find directories containing only a `Thumbs.db` file and remove that file. This allows the parent directory to be subsequently removed if it becomes empty.

## How to Use

1.  **Import the Module**

    ```powershell
    Import-Module .\Remove-EmptyDirectories.psm1 -Force
    ```

2.  **Run the command**

    Change to your target directory or specify it using the `-Path` parameter.

    **Example 1: Recursively remove empty directories from a specific path**

    ```powershell
    Remove-EmptyDirectories -Path "C:\Users\YourUser\Downloads" -Recurse
    ```

    **Example 2: Clean up a photo library, including directories with only `Thumbs.db`**

    ```powershell
    Remove-EmptyDirectories -Path "D:\Photographs\Processing" -Recurse -FirstRemoveThumbDbFromEmptyDirectories -Verbose
    ```

    **Example 3: See what would be removed without actually deleting anything (`-WhatIf`)**

    ```powershell
    Remove-EmptyDirectories -Path "D:\Photographs\Processing" -Recurse -FirstRemoveThumbDbFromEmptyDirectories -WhatIf
    ```