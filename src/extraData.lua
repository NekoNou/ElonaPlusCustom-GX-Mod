ExtraData = {}

local saveDir = nil
local doFmode = {}
local shopId = nil

ExtraData.data = {}
local data = ExtraData.data

local initExtraSaveData = function()
    saveDir = "save\\" .. playerid[0] .. "\\mod"
    MakeDir(saveDir)
end

local getPath = function(dataType)
    return saveDir .. "\\" .. dataType .. ".lua"
end

local initData = function(dataType, modName, page)
    if (saveDir == nil) then
        error("EXTRA SAVE DATA ERROR: Save not loaded.")
    end
    if (not data[dataType]) then
        data[dataType] = {}
    end
    if (not data[dataType][modName]) then
        data[dataType][modName] = {}
    end
    if (page and not data[dataType][modName][page]) then
        data[dataType][modName][page] = {}
    end
end

local hasExtraData = function(dataType, modName, page)
    if (saveDir == nil) then
        return false
    end
    if (not data[dataType]) then
        return false
    end
    if (modName and not data[dataType][modName]) then
        return false
    end
    if (page and not data[dataType][modName][page]) then
        return false
    end
    return true
end

local saveData = function(dataType)
    RemoveEmptyTable(data, dataType)
    if (not data[dataType]) then
        DeleteFile(saveDir .. "\\" .. dataType .. ".lua")
        return
    end

    local file = io.open(getPath(dataType), "w+")
    if file then
        file:write("data[\"" .. dataType .. "\"] = ")
        file:write(ToString(data[dataType]))
        file:close()
    end
end

local loadData = function(dataType)
    if (IsFileExist(getPath(dataType))) then
        LoadSrc(getPath(dataType), ExtraData)
    end
end

local removeData = function(dataType)
    data[dataType] = nil
end

local deleteData = function(dataType)
    removeData(dataType)
    saveData(dataType)
end

local getItemType = function(page)
    if (page >= RANGE_INV1) then
        return shopId and EXTRA_SHOP_INV .. shopId or EXTRA_MAP_INV .. mid[0]
    else
        return EXTRA_INV
    end
end

local getCharaType = function(page)
    if (page >= MAX_CHARA_NC) then
        return EXTRA_MAP_CDATA .. mid[0]
    else
        return EXTRA_CDATA
    end
end

local removePageData = function(page, getTypeByPage)
    local dataType = getTypeByPage(page)
    if (not hasExtraData(dataType)) then return end

    for modName, modData in pairs(data[dataType]) do
        modData[page] = nil
    end
end

local removeItemData = function(page) removePageData(page, getItemType) end
local removeCharaData = function(page) removePageData(page, getCharaType) end

local copyPageData = function(from, to, getTypeByPage)
    removePageData(to, getTypeByPage)

    local fromType = getTypeByPage(from)
    if (not hasExtraData(fromType)) then return end

    local toType = getTypeByPage(to)
    for modName, modData in pairs(data[fromType]) do
        if (modData[from]) then
            initData(toType, modName, to)
            data[toType][modName][to] = DeepCopyTable(modData[from])
        end
    end
end
local copyItemData = function(from, to) copyPageData(from, to, getItemType) end
local copyCharaData = function(from, to) copyPageData(from, to, getCharaType) end
local fullcopyCharaData = function(from, to)
    copyCharaData(from, to)
    inv_getheader(from)
    local fromInvHead = invhead[0]
    local invRange = invrange[0]
    inv_getheader(to)
    local toInvHead = invhead[0]

    for i = 0, invRange - 1, 1 do
        copyItemData(fromInvHead + i, toInvHead + i)
    end
end

local initMapData = function()
    removeData(EXTRA_MAP_CDATA .. mid[0])
    removeData(EXTRA_MAP_INV .. mid[0])
end

local removeAreaData = function(area)
    for dataType in pairs(data) do
        if (string.find(dataType, " " .. area .. "_%d+$")) then
            removeData(dataType)
        end
    end
end

doFmode[1] = function()
    loadData(EXTRA_MAP_CDATA .. mid[0])
end
doFmode[3] = function()
    local file = Hsp.read("file")
    if file == EXTRA_SHOP_TMP then
        shopId = nil
    else
        local id, times = string.gsub(file, "shop(%d+)%.s2", "%1")
        if times == 1 then
            shopId = id
            loadData(EXTRA_SHOP_INV .. shopId)
            return
        end
    end

    loadData(EXTRA_MAP_INV .. mid[0])
end
doFmode[4] = function()
    local file = Hsp.read("file")
    local shop, times = string.gsub(file, "shop(%d+)%.s2", "%1")
    if times == 1 then
        saveData(EXTRA_SHOP_INV .. shop)
    end
end
doFmode[7] = function()
    initExtraSaveData()

    loadData(EXTRA_GDATA)
    loadData(EXTRA_CDATA)
    loadData(EXTRA_INV)
end
doFmode[8] = function()
    saveData(EXTRA_GDATA)
    saveData(EXTRA_CDATA)
    saveData(EXTRA_INV)
end
doFmode[9] = function()
    RemoveDir("save\\" .. playerid[0] .. "\\mod")
end
doFmode[10] = function()
    ExtraData.data = {}
    data = ExtraData.data
end
doFmode[11] = function()
    removeData(EXTRA_MAP_CDATA .. mid[0])
    removeData(EXTRA_MAP_INV .. mid[0])
end
doFmode[13] = function()
    removeAreaData(area[0])
end
doFmode[16] = function()
    removeData(EXTRA_MAP_INV .. mid[0])
end

Hsp.hookGosub(GAME_CTRLFILE, function()
    local fun = doFmode[fmode[0]]
    if fun then fun() end
end)

Hsp.hookGosub(SHOP_RESTOCK, function()
    removeData(EXTRA_SHOP_INV .. cdata[{ CDATA_ROLE_FILE_ID, Hsp.read("tc") }])
end)

Hsp.hookGosub(GAME_SAVE, function()
    initExtraSaveData()

    saveData(EXTRA_MAP_CDATA .. mid[0])
    saveData(EXTRA_MAP_INV .. mid[0])

    for flag, mapId in string.gmatch(filemod[0], "([*#])[^\n]-cdata_(.-)%.s2[^*#]") do
        local cdataType = EXTRA_MAP_CDATA .. mapId
        local invType = EXTRA_MAP_INV .. mapId
        if (flag == "#") then
            deleteData(cdataType)
            deleteData(invType)
        end
        if (flag == "*") then
            saveData(cdataType)
            saveData(invType)
        end
    end

    for flag, shop in string.gmatch(filemod[0], "([*#])[^\n]shop(%d+)%.s2[^*#]") do
        if (flag == "#") then
            deleteData(EXTRA_SHOP_INV .. shop)
        end
        if (flag == "*") then
            saveData(EXTRA_SHOP_INV .. shop)
        end
    end
end)

Hsp.hookFunReturn("item_copy", copyItemData)
Hsp.hookFunction("item_delete", removeItemData)
Hsp.hookFunction("copy_chara", copyCharaData)
Hsp.hookFunction("del_chara", removeCharaData)
Hsp.hookFunction("relocate_chara", fullcopyCharaData)
Hsp.hookFunction("map_initialize", initMapData)

ExtraData.tryGetGdata = function(key, modName)
    modName = modName or getfenv(2).ModName
    return hasExtraData(EXTRA_GDATA, modName) and data[EXTRA_GDATA][modName][key] or nil
end

ExtraData.getGdata = function(modName)
    modName = modName or getfenv(2).ModName
    initData(EXTRA_GDATA, modName)
    return data[EXTRA_GDATA][modName]
end

ExtraData.tryGetCdata = function(page, key, modName)
    modName = modName or getfenv(2).ModName
    return hasExtraData(getCharaType(page), modName, page) and data[getCharaType(page)][modName][page][key] or nil
end

ExtraData.getCdata = function(page, modName)
    modName = modName or getfenv(2).ModName
    local dataType = getCharaType(page)
    initData(dataType, modName, page)
    return data[dataType][modName][page]
end

ExtraData.tryGetInv = function(page, key, modName)
    modName = modName or getfenv(2).ModName
    return hasExtraData(getItemType(page), modName, page) and data[getItemType(page)][modName][page][key] or nil
end

ExtraData.getInv = function(page, modName)
    modName = modName or getfenv(2).ModName
    local dataType = getItemType(page)
    initData(dataType, modName, page)
    return data[dataType][modName][page]
end
