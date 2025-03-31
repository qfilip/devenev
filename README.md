# devenev
development environment setup

## Package management

- Install [scoop](https://scoop.sh)
    ```
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
    ```

- Basic packages
    - common
    ```
    scoop install extras/rancher-desktop
    scoop install extras/powertoys
    ```

    - neovim
    ```
    scoop install main/make
    scoop install main/mingw
    scoop install main/ripgrep
    scoop install main/python
    scoop install fzf
    scoop install rga
    scoop install extras/psfzf
    scoop install nodejs-lts
    scoop install extras/lazygit
    scoop install main/neovim
    scoop install extras/neovide
    scoop install extras/warp-terminal

    # there are 2 Paq package managers (find them on Github)
    # run command to clone one
    git clone https://github.com/savq/paq-nvim.git %LOCALAPPDATA%\nvim-data\site\pack\paqs\start\paq-nvim
    # run :NeovideRegisterRightClick to register neovide in context menu
    # run :PaqInstall command within neovim to install packegs
    ```

## Editors

### Neovide

Install Neovide:

`scoop bucket add extras`

Open Neovide and add it to the context menu with `:NeovideRegisterRightClick` command. Neovim configs are in `AppData/Local/nvim` (create if not present).


### VSCodium

Enable marketplace by adding `product.json` at `C:\Users\{username}\AppData\Roaming\VSCodium\` and put in:
```json
{
	"extensionsGallery": {
	  "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
	  "itemUrl": "https://marketplace.visualstudio.com/items",
	  "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
	  "controlUrl": ""
	}
}
```

If installed via `scoop` create `ctx_menu.reg` file with:
```
Windows Registry Editor Version 5.00

; Open files
[HKEY_CLASSES_ROOT\*\shell\Open with VS Code]
@="Edit with VS Code"
"Icon"="C:\\Users\\{username}\\scoop\\apps\\vscode\\current\\Code.exe,0"

[HKEY_CLASSES_ROOT\*\shell\Open with VS Code\command]
@="\"C:\\Users\\{username}\\scoop\\apps\\vscode\\current\\Code.exe\" \"%1\""

; This will make it appear when you right click ON a folder
; The "Icon" line can be removed if you don't want the icon to appear

[HKEY_CLASSES_ROOT\Directory\shell\vscode]
@="Open Folder as VS Code Project"
"Icon"="\"C:\\Users\\{username}\\scoop\\apps\\vscode\\current\\Code.exe\",0"

[HKEY_CLASSES_ROOT\Directory\shell\vscode\command]
@="\"C:\\Users\\{username}\\scoop\\apps\\vscode\\current\\Code.exe\" \"%1\""

; This will make it appear when you right click INSIDE a folder
; The "Icon" line can be removed if you don't want the icon to appear

[HKEY_CLASSES_ROOT\Directory\Background\shell\vscode]
@="Open Folder as VS Code Project"
"Icon"="\"C:\\Users\\{username}\\scoop\\apps\\vscode\\current\\Code.exe\",0"

[HKEY_CLASSES_ROOT\Directory\Background\shell\vscode\command]
@="\"C:\\Users\\{username}\\scoop\\apps\\vscode\\current\\Code.exe\" \"%V\""
```


## Terminal


### Powershell Core

- Setup
    ```
    scoop install main/pwsh
    
    ## check if profile exists:
    test-path $profile

    ## if false, set up new profile
    New-Item -Path $profile -Type File -Force
    
    ## find profile path
    $profile

    ```

- Customize

    - Add folder icons:

        `Install-Module -Name Terminal-Icons -Repository PSGallery`

        Add to `$profile` file:

        `Import-Module -Name Terminal-Icons`
    
    - Add autocmpletion (`CTRL+Space`)

        `Install-Module PSReadLine -AllowPrerelease -Force`

        Update `$Profile` file:

        ```
        if ($host.Name -eq 'ConsoleHost')
        {
            Import-Module PSReadLine

            # Binding for moving through history by prefix
            Set-PSReadLineKeyHandler -Key UpArrow - HistorySearchBackward
            Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
        }
        ```
    
    - Add fuzzy finder:

        `scoop install main/fzf`

        `Install-Module PSFzf`

        Update `$profile` file:

        ```
        Import-Module PSFzf

        # Override PSReadLine's history search
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' `
                        -PSReadlineChordReverseHistory 'Ctrl+r'

        # Override default tab completion
        Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
        ```
[source](https://www.damirscorner.com/blog/posts/20211119-PowerShellModulesForABetterCommandLine.html#:~:text=It%20integrates%20the%20well-known%20fuzzy%20finder%2C%20fzf%2C%20into,Tab%20enables%20fuzzy%20search%20for%20tab%20completion.%20)

### Warp Terminal

You can ask Warp Terminal to add itself to context menu. It will generate the following script (just change `$warpPath` variable in it):
```
<#
.SYNOPSIS
Adds Warp terminal to the Windows context menu.

.DESCRIPTION
This script adds an "Open with Warp" option to the Windows context menu for directories.
When clicked, it opens the Warp terminal in the selected directory.

.NOTES
Requires administrative privileges to modify the registry.
#>

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "This script requires administrative privileges. Attempting to restart with elevated permissions..." -ForegroundColor Yellow
    try {
        Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    }
    catch {
        Write-Host "Failed to restart with administrative privileges: $_" -ForegroundColor Red
        Write-Host "Please run this script as an administrator." -ForegroundColor Red
        exit 1
    }
    exit 0
}

# Define the path to Warp executable
$warpPath = "C:\Users\PC\scoop\apps\warp-terminal\0.2025.02.24.20.50.stable_04\warp.exe"

# Check if Warp executable exists
if (-not (Test-Path $warpPath)) {
    Write-Host "Warp executable not found at: $warpPath" -ForegroundColor Red
    Write-Host "Please update the script with the correct path to warp.exe" -ForegroundColor Red
    exit 1
}

# Prompt for confirmation
$confirmation = Read-Host "This will add 'Open with Warp' to your context menu. Continue? (Y/N)"
if ($confirmation -ne 'Y' -and $confirmation -ne 'y') {
    Write-Host "Operation cancelled by user." -ForegroundColor Yellow
    exit 0
}

try {
    # Add "Open with Warp" to directory context menu
    Write-Host "Adding 'Open with Warp' to directory context menu..." -ForegroundColor Cyan
    
    # Create registry key for directory context menu
    $dirContextPath = "Registry::HKEY_CLASSES_ROOT\Directory\shell\WarpHere"
    New-Item -Path $dirContextPath -Force | Out-Null
    New-ItemProperty -Path $dirContextPath -Name "(Default)" -PropertyType String -Value "Open with Warp" -Force | Out-Null
    New-ItemProperty -Path $dirContextPath -Name "Icon" -PropertyType String -Value "$warpPath" -Force | Out-Null
    
    # Create command subkey
    $dirCommandPath = "$dirContextPath\command"
    New-Item -Path $dirCommandPath -Force | Out-Null
    New-ItemProperty -Path $dirCommandPath -Name "(Default)" -PropertyType String -Value "`"$warpPath`" --cwd `"%V`"" -Force | Out-Null
    
    # Add "Open with Warp" to directory background context menu
    Write-Host "Adding 'Open with Warp' to directory background context menu..." -ForegroundColor Cyan
    
    # Create registry key for directory background context menu
    $bgContextPath = "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\WarpHere"
    New-Item -Path $bgContextPath -Force | Out-Null
    New-ItemProperty -Path $bgContextPath -Name "(Default)" -PropertyType String -Value "Open with Warp" -Force | Out-Null
    New-ItemProperty -Path $bgContextPath -Name "Icon" -PropertyType String -Value "$warpPath" -Force | Out-Null
    
    # Create command subkey
    $bgCommandPath = "$bgContextPath\command"
    New-Item -Path $bgCommandPath -Force | Out-Null
    New-ItemProperty -Path $bgCommandPath -Name "(Default)" -PropertyType String -Value "`"$warpPath`" --cwd `"%V`"" -Force | Out-Null
    
    Write-Host "Successfully added 'Open with Warp' to the context menu!" -ForegroundColor Green
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    Write-Host "Failed to add Warp to the context menu." -ForegroundColor Red
    exit 1
}

# Prompt user to test the context menu
Write-Host "`nRight-click on a folder or in the background of a directory to see the 'Open with Warp' option." -ForegroundColor Cyan
```
