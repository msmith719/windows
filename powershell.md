# PowerShell (PoSh)

## winget
winget is the Windows package manager. You can get help with the command and list all of the related commands by running`winget --help`.

Learn more about winget in [Microsoft's documentation](https://learn.microsoft.com/en-us/windows/package-manager/winget/)

### Upgrade all packages 
``` ps1
winget upgrade -h --all
```

### Installing Packages
You can search for packages using `winget search <appname>`. For example `winget search vscode` to search for the Microsoft Visual Studio Code package.

To install the package, you need to specify the package Id. Examples:
``` ps1
winget install Balena.Etcher
winget install Brave.Brave
winget install Greenshot.Greenshot
winget install Microsoft.VisualStudioCode
winget install Microsoft.Powertoys
```