local show3DText = Config.Default3DTextEnabled
local players_data = {}
local GetScreenCoordFromWorldCoord_ = GetScreenCoordFromWorldCoord
local SendNUIMessage_ = SendNUIMessage
local localplayer = PlayerPedId()
local pcoords = GetEntityCoords(localplayer)
local Window = { screen = {} }
local static_screen = {}
Window.screen.w, Window.screen.h = GetActiveScreenResolution()
local dropped_count = 0

CreateThread(function()
    while true do
        localplayer = PlayerPedId()
        pcoords = GetEntityCoords(localplayer)
        Wait(1000)
    end
end)

Window.screen.w, Window.screen.h = GetActiveScreenResolution()
CreateThread(function()
    SendNUIMessage({
        type = "resolution",
        screen = Window.screen
    })
    while true do
        Wait(2500)
        if not fixed_nui_size then
            Window.screen.w, Window.screen.h = GetActiveScreenResolution()
            if static_screen.w ~= Window.screen.w or static_screen.h ~= Window.screen.h then
                SendNUIMessage({
                    type = "resolution",
                    screen = Window.screen
                })
                static_screen.w = Window.screen.w
                static_screen.h = Window.screen.h
            end
        end
    end
end)

RegisterNuiCallback("fixed_nui_size", function()
    fixed_nui_size = true
    Wait(1000)
    Window.screen.w, Window.screen.h = 1920, 1080
end)

RegisterNetEvent("antiCL:show")
AddEventHandler("antiCL:show", function()
    if show3DText then
        show3DText = false
    else
        show3DText = true
        if Config.AutoDisableDrawing then
            Wait(Config.AutoDisableDrawingTime)
            show3DText = false
        end
    end
end)
RegisterNetEvent("antiCL")
AddEventHandler("antiCL", function(id, crds, identifier, reason)
    players_data[id] = {
        crds = {},
        identifier = identifier,
        reason = reason
    }
    dropped_count = dropped_count + 1
    Display(id, crds, identifier, reason)
end)

function Display(id, crds, identifier, reason)
    local displaying = true

    CreateThread(function()
        Wait(Config.DrawingTime)
        players_data[id] = nil
        dropped_count = dropped_count - 1
        displaying = false
    end)

    CreateThread(function()
        while displaying do
            Wait(15)
            if show3DText and #(crds - pcoords) < 15.0 and displaying then
                local onScreen,_x,_y=GetScreenCoordFromWorldCoord_(crds.x, crds.y, crds.z)
                if players_data[id] then
                    players_data[id].crds = { x = _x, y = _y }
                end
            else
                if players_data[id] then players_data[id].crds = nil end
                Wait(2000)
            end
        end
    end)
end
CreateThread(function()
    Wait(1000)
    SendNUIMessage_({
        type = "translation",
        translation = Config.Translation
    })
    SendNUIMessage_({
        type = "colours",
        colours = Config.Colours
    })
    Wait(100)
    while true do
        Wait(15)
        if dropped_count > 0 then
            SendNUIMessage_({
                type = "dropped_coords",
                players = players_data
            })
        else
            SendNUIMessage_({
                type = "clear_canvas"
            })
            Wait(2000)
        end
    end
end)
