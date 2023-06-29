RegisterCommand(ServerConfig.ShowCommand, function(source, args, rawcmd)
    TriggerClientEvent("antiCL:show", source)
end)

local function PlayerIdentifier(player)
    local identifier = "None"
    for k, v in ipairs(GetPlayerIdentifiers(player)) do
        if v:match(ServerConfig.Identifier..":") then
            identifier = v
            break
        end
    end
    return identifier
end

AddEventHandler("playerDropped", function(reason)
    local crds = GetEntityCoords(GetPlayerPed(source))
    local id = source
    local identifier = PlayerIdentifier(source)

    TriggerClientEvent("antiCL", -1, tostring(id), crds, identifier, reason)
    if ServerConfig.LogSystem then
        SendLog(id, crds, identifier, reason)
    end
end)

function SendLog(id, crds, identifier, reason)
    local name = GetPlayerName(id)
    local date = os.date('*t')
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
    local embeds = {
        {
            ["title"] = "Player Disconnected",
            ["type"]="rich",
            ["color"] = 4777493,
            ["fields"] = {
                {
                    ["name"] = "Identifier",
                    ["value"] = identifier,
                    ["inline"] = true,
                },{
                    ["name"] = "Nickname",
                    ["value"] = name,
                    ["inline"] = true,
                },{
                    ["name"] = "Player's ID",
                    ["value"] = id,
                    ["inline"] = true,
                },{
                    ["name"] = "Cordinates",
                    ["value"] = "X: "..crds.x..", Y: "..crds.y..", Z: "..crds.z,
                    ["inline"] = true,
                },{
                    ["name"] = "Reason",
                    ["value"] = reason,
                    ["inline"] = true,
                },
            },
            ["footer"]=  {
                ["icon_url"] = "https://forum.fivem.net/uploads/default/original/4X/7/5/e/75ef9fcabc1abea8fce0ebd0236a4132710fcb2e.png",
                ["text"]= "Sent: " ..date.."",
            },
        }
    }
    PerformHttpRequest(ServerConfig.Webhook, function(err, text, headers) end, 'POST', json.encode({ username = ServerConfig.LogBotName,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end