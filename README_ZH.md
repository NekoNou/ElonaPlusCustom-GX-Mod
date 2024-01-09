# ElonaPlusCustom-GX Mod

一个基于[Hsp Mod Manager](https://github.com/NekoNou/Hsp-Mod-Manager)  和[ElonaPlusCustom-GX](https://github.com/JianmengYu/ElonaPlusCustom-GX)的MOD框架，旨在为E+CGX提供mod功能。

# 安装
1. 安装[Elona+ Custom-GX 2.21](https://github.com/JianmengYu/ElonaPlusCustom-GX)
2. 安装[Hsp Mod Manager](https://github.com/NekoNou/Hsp-Mod-Manager)
3. 下载此项目，解压到mod文件夹
4. 在mod依赖中添加"E+CGX MOD"

# EXTRA DATA
提供将数据保存到gdata、cdata、inv的功能，这些数据会随游戏一次保存。目前并不完善。
```lua
function ExtraData.tryGetGdata(key, modName)
function ExtraData.tryGetCdata(page, key, modName)
function ExtraData.tryGetInv(page, key, modName)
```
- 尝试读取指定的值，没有时返回nil
- modName可以省略，默认为调用这些函数的modName

```lua
function ExtraData.getGdata(modName)
function ExtraData.getCdata(page, modName)
function ExtraData.getInv(page, modName)
```
- 获取一个table，可以读写这个table将数据保存在指定位置