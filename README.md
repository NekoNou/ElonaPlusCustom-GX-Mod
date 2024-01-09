This document was translated by deepl. The original [Chinese version](README_ZH.md).
# ElonaPlusCustom-GX Mod

A mod framework based on [Hsp Mod Manager](https://github.com/NekoNou/Hsp-Mod-Manager) and [ElonaPlusCustom-GX](https://github.com/JianmengYu/ElonaPlusCustom-GX), designed to provide mod functionality for E+CGX.

However, now there's nothing.

# Previews
1. Install [Elona+ Custom-GX 2.21](https://github.com/JianmengYu/ElonaPlusCustom-GX)
2. Download [preview](https://github.com/NekoNou/ElonaPlusCustom-GX-Mod/releases/tag/Previews), unzip to E+CGX folder and overwrite all files
3. Run Hsp Mod Manager.exe

A simple script is built in to make the PC immune and reflect all damage.

# Install
1. Install[Elona+ Custom-GX 2.21](https://github.com/JianmengYu/ElonaPlusCustom-GX)
2. Install[Hsp Mod Manager](https://github.com/NekoNou/Hsp-Mod-Manager)
3. Download this project and unzip it into the mod folder
4. Add "E+CGX MOD" to the requireList.

# EXTRA DATA
Provide the ability to save data to gdata, cdata, inv, which are saved with the game at once. Currently not perfect.
```lua
function ExtraData.tryGetGdata(key, modName)
function ExtraData.tryGetCdata(page, key, modName)
function ExtraData.tryGetInv(page, key, modName)
```
- Tries to read the specified value and returns nil if it is not there.
- The modName can be omitted and defaults to the modName of the function that called it.

```lua
function ExtraData.getGdata(modName)
function ExtraData.getCdata(page, modName)
function ExtraData.getInv(page, modName)
```
- Get a table, you can read and write the table to save the data in the specified location.