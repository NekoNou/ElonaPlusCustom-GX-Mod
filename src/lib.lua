DeepCopyTable = function(tab)
    local newTab = {}
    for k, v in pairs(tab) do
        if (type(v) == "table") then
            newTab[k] = DeepCopyTable(v);
        else
            newTab[k] = v;
        end
    end
    return newTab
end

RemoveEmptyTable = function(table, key)
    local inner = key and table[key] or table
    if not inner then
        return
    end

    for k, v in pairs(inner) do
        if type(v) == "table" then
            RemoveEmptyTable(inner, k)
        end
    end

    if key and not next(inner) then
        table[key] = nil
    end
end

IsFileExist = function(filePath)
    local file = io.open(filePath)

    if file then
        file:close()
        return true
    else
        return false
    end
end

IsDirExist = function(dirPath)
    return os.execute("cd " .. dirPath) == 0
end

MakeDir = function(path)
    if (not IsDirExist(path)) then
        os.execute("mkdir \"" .. path .. "\"")
    end
end

DeleteFile = function(path)
    if (IsFileExist(path)) then
        os.execute("del \"" .. path .. "\"");
    end
end

ToString = function(var, tab)
    if (var == nil) then return "nil" end
    if (type(var) == "table") then
        if (tab == nil) then tab = 1; end
        local str = "{\n"
        for k, v in pairs(var) do
            for i = 1, tab, 1 do str = str .. "\t"; end
            str = str .. "[" .. ToString(k) .. "] = " .. ToString(v, tab + 1) .. ",\n"
        end
        for i = 1, tab - 1, 1 do str = str .. "\t"; end
        return str .. "}"
    end
    if (type(var) == "string") then return "\"" .. var .. "\"" end

    return tostring(var)
end
