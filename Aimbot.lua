--[[
    Aimbot.lua
    Поиск целей и Silent Aim
]]

local Aimbot = {}
local Core = require(script.Parent.Core)

function Aimbot.findTarget()
    local mousePos = Core.Services.UserInputService:GetMouseLocation()
    local closestDist = Core.Settings.Aimbot.FOV
    local closestPlayer = nil
    local closestPos = nil
    
    for _, player in ipairs(Core.Services.Players:GetPlayers()) do
        if player == Core.LocalPlayer then
            continue
        end
        
        if Core.Settings.Aimbot.TeamCheck and player.Team == Core.LocalPlayer.Team then
            continue
        end
        
        local character = player.Character
        if character then
            local part = character:FindFirstChild(Core.Settings.Aimbot.AimPart) or character:FindFirstChild("Head")
            local humanoid = character:FindFirstChild("Humanoid")
            local root = character:FindFirstChild("HumanoidRootPart")
            
            if part and humanoid and humanoid.Health > 0 then
                local targetPos = part.Position
                if root and Core.Settings.Aimbot.Prediction > 0 then
                    targetPos = targetPos + root.Velocity * Core.Settings.Aimbot.Prediction
                end
                
                local pos, onScreen = Core.Camera:WorldToViewportPoint(targetPos)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = player
                        closestPos = Vector2.new(pos.X, pos.Y)
                    end
                end
            end
        end
    end
    
    return closestPlayer, closestPos
end

-- Silent Aim hook
do
    local oldNamecall
    local success, result = pcall(function()
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if method == "FireServer" and Core.Settings.Aimbot.Enabled and Core.State.aimbotActive and Core.State.currentTarget then
                if Core.Settings.Aimbot.Silent and Core.State.currentTarget.Character then
                    local aimPart = Core.State.currentTarget.Character:FindFirstChild(Core.Settings.Aimbot.AimPart) or Core.State.currentTarget.Character:FindFirstChild("Head")
                    if aimPart and math.random(1, 100) <= Core.Settings.Aimbot.HitChance then
                        if #args > 0 and typeof(args[1]) == "Vector3" then
                            args[1] = aimPart.Position
                            return oldNamecall(self, unpack(args))
                        end
                    end
                end
            end
            
            return oldNamecall(self, ...)
        end)
    end)
    
    if not success then
        print("Silent Aim не поддерживается, используем визуальный аим")
        Core.Settings.Aimbot.Silent = false
    end
end

-- Обработка ввода
Core.Services.UserInputService.InputBegan:Connect(function(input)
    if Core.State.typing then return end
    
    if input.UserInputType == Core.Settings.Aimbot.TriggerKey then
        if Core.Settings.Aimbot.ToggleMode then
            Core.State.aimbotActive = not Core.State.aimbotActive
        else
            Core.State.aimbotActive = true
        end
    end
end)

Core.Services.UserInputService.InputEnded:Connect(function(input)
    if Core.State.typing then return end
    
    if input.UserInputType == Core.Settings.Aimbot.TriggerKey and not Core.Settings.Aimbot.ToggleMode then
        Core.State.aimbotActive = false
    end
end)

return Aimbot
