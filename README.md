# devenev
development environment setup

## Package management

- Install [scoop](https://scoop.sh)

## Terminal

### Powershell Core

- Setup

    `scoop install main/pwsh`
    
    Check if profile exists:

    `test-path $profile`

    If false, set up new profile

    `New-Item -Path $profile -Type File -Force`

    Find profile path

    `$profile`

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