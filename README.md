## nvim-fade-color
Fade RGB color between two given colors by percentage.


## Installation

#### Using packer in lua
```lua
use ("ksk0/nvim-fade-color")
```
#### Using vim-plug in vimscript
```
Plug 'ks0/nvim-fade-color'
```


## Usage
```
faded_color = require("fade-color").fade(src_color, dst_color, fade)
```

#### where:

- `fade` is number from 0 to 1 (representing percentage)
- src_color is color to be faded
- dst_color color to achieve when fade is 100% (fade = 1)
- faded_color is resulting (faded) color

#### Value of `src_color`, `dst_color` and `fade_color`

Input values cane be given either as number:
```
src_color = 34563345
```
or as list of RGB values:
```
src_color = {126, 224, 68}
```
while `faded_color` format depends of format of `src_value`. If number,
`fade_color` will be number, and if `src_value` is list, `fade_color`
will also be list of **RGB** values.


## How and why
Fading can be done, by adjusting each **RGB** color separately in range between
**source** and **destination** color. If faded that way, at 0% faded color will
be equal to source color and when fade for 100% faded color will be equal
to destination color. By fading this way, in full transition we will cross
entire color spectrum between source and destination color.

This plugin uses **HSL** (Hue Saturation Lightness) color representation for
faded color calculation. In **HSL** representation, **Hue** represents color,
while **Saturation** and **Lightness** basically represent **intensity** of
a color.

Calculation is done on **HSL** values, and later converted to **RGB** values.
The formula is:
```
faded_S = (1-fade) * source_S + fade * destination_S
faded_L = (1-fade) * source_L + fade * destination_L
faded_H = source_H
```
Where `fade` is value between 0 and 1 (1 being 100%). By changing only
**Saturation** and **Lightness** we achieve that, base color is preserved,
and only **intensity** of color is changed. When `fade = 0` faded color is
same as source color. When `fade = 1` faded color **DOES NOT** equal to
destination color. Only **S** and **L** values are equal to that of
destination color, thus faded color is equal in **intensity** to destination,
but with same color as source one.

This yields good results, when used to fade text to the background color,
preserving color of the text, but fading it to the background color intensity.
The quality of the result depends on, foreground and background colors.

You can test the results with this script:
```
local fader = require("fade-color")

local hi_normal = vim.api.nvim_get_hl_by_name("Normal", true)
local hi_error  = vim.api.nvim_get_hl_by_name("ErrorMsg", true)

local src_col = hi_error.foreground
local dst_col = hi_normal.background
local shades  = 10

for i = 0, shades do
  local fade = i * (1 / shades)
  local faded_col = fader.fade(src_col, dst_col, fade)
  local hi_name   = string.format("FaderTestHighlight_%02d", i)

  vim.cmd("highlight " .. hi_name .. " guifg=#" .. string.format("%06x", faded_col))
  vim.cmd("hi " .. hi_name)
end
```
Script will create 10 `Highlights` and in command line print their definition,
thus showing how text in **ErrorMsg** color, fades into **Normal** background.

More info on **HSL** representation here: [wiki page](https://en.wikipedia.org/wiki/HSL_and_HSV)

