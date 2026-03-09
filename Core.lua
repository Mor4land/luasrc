--[[
    Core.lua
    Базовые сервисы и настройки
]]

local Core = {}

Core.Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    CoreGui = game:GetService("CoreGui"),
    VirtualInputManager = game:GetService("VirtualInputManager")
}

Core.LocalPlayer = Core.Services.Players.LocalPlayer
Core.Camera = workspace.CurrentCamera
Core.Mouse = Core.LocalPlayer:GetMouse()

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
    Colors = {
        Accent = Color3.fromRGB(255, 255, 0),    -- Желтый как в skeet
        Background = Color3.fromRGB(20, 20, 20),
        DarkBackground = Color3.fromRGB(10, 10, 10),
        Text = Color3.fromRGB(240, 240, 240),
        Red = Color3.fromRGB(255, 70, 70),
        Green = Color3.fromRGB(70, 255, 70)
    }
}

Core.State = {
    aimbotActive = false,
    menuOpen = false,
    currentTarget = nil,
    typing = false
}

return Core
