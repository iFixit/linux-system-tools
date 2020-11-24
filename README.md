This is a collection of handy scripts for iFixiters running Linux on
their local dev machines.

## `bin`:
`upscale`  Resizes whatever image is on the clipboard to be large
enough to be accepted by Overlord. The resulting image is returned to
the clipboard.

`overlord_icon` Creates an icon in the style of our dev Overlord
tiles. Pass it the hex value of a unicode emoji (all lowercase), and
it fetches the appropriate emoji from Twemoji and converts it into a
tile. The resulting tile is placed on the clipboard and also opened in
a `display` window, which allows you to preview it. If you don't like
the background color, run the script again; the colors are randomly
selected.

## `tools`:
`gather.py` This script gathers up various information about a system
which corresponds to the things that we want to know for our security
checkups. It's not able to answer _all_ the questions, but it can get
a lot of them. Pull requests welcome to increase its coverage!
