--[[
    МОДУЛЬ 1 - CORE
    Сохрани как "Core.lua"
]]

local Core = {}

-- Сервисы
Core.Players = game:GetService("Players")
Core.RunService = game:GetService("RunService")
Core.UserInputService = game:GetService("UserInputService")
Core.TweenService = game:GetService("TweenService")
Core.CoreGui = game:GetService("CoreGui")
Core.LocalPlayer = Core.Players.LocalPlayer
Core.Camera = workspace.CurrentCamera

-- Настройки по умолчанию
Core.Settings = {
    Aimbot = {
        Enabled = true,
        TeamCheck = true,
        WallCheck = false,
        HitChance = 100,
        Prediction = 0.15,
        AimPart = "Head",
        FOV = 150,
        Silent = true,
        TriggerKey = Enum.UserInputType.MouseButton2,
        ToggleMode = true
    },
    Visuals = {
        ShowFOV = true,
        FOVColor = Color3.fromRGB(255, 0, 0),
        FOVLockedColor = Color3.fromRGB(0, 255, 0),
        FOVThickness = 2,
        FOVFilled = false,
        FOVTransparency = 1,
        ShowTargetDot = true,
        DotColor = Color3.fromRGB(255, 255, 255),
        ShowTargetLine = true,
        LineColor = Color3.fromRGB(255, 255, 255)
    },
    Menu = {
        AccentColor = Color3.fromRGB(0, 170, 255),
        BackgroundColor = Color3.fromRGB(25, 25, 25),
        TextColor = Color3.fromRGB(255, 255, 255)
    }
}

Core.aimbotActive = false
Core.menuOpen = false
Core.currentTarget = nil
Core.connections = {}

return Core
