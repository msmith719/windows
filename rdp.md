# Remote Desktop

## Display RDP Session ***only*** on Specific Monitors
Natively, you can only have your RDP session on either 1 monitor, all monotors, or no monitors. I like a bit more Ctrl and tell my RDP session to only display on certain monitors that I specify.

To get RDP on specific monitors (not all), edit your .rdp file. Right-click the .rdp file open with a text editor like Notepad. Add the lines
```
use multimon:i:1
selectedmonitors:s:1,4,5
```
between the `screen mode` and the `desktopwidth` lines. Like this
```
screen mode id:i:2
use multimon:i:1
selectedmonitors:s:1,4,5
desktopwidth:i:1920
desktopheight:i:1080
```
You will need to change the numbers listed after `selectedmonitors:s:` to match the screen numbers that you want to want the RDP machine to use. For me, my numbers matched the display/screen numbers shown in the Windows Display Settings (Settings App > System > Display)....but YMMV. This put the RDP windows on 3 of my monitors.

So glad that Microsoft added in this support. Thanks Microsoft! :thumbsup: :100: