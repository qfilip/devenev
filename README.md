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

    # there are 2 Paq package managers (find them on Github)
    # run command to clone one
    git clone https://github.com/savq/paq-nvim.git %LOCALAPPDATA%\nvim-data\site\pack\paqs\start\paq-nvim
    # run :NeovideRegisterRightClick to register neovide in context menu
    # run :PaqInstall command within neovim to install packegs
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
