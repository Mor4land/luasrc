--[[
    Menu.lua
    Меню в стиле gamesense/skeet
]]

local Menu = {}
local Core = require(script.Parent.Core)
local DrawingModule = require(script.Parent.Drawing)

local function createWindow()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SkeetMenu"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = Core.Services.CoreGui
    
    -- Главное окно
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 600, 0, 400)
    main.Position = UDim2.new(0.5, -300, 0.5, -200)
    main.BackgroundColor3 = Core.Colors.DarkBackground
    main.BorderSizePixel = 0
    main.Visible = false
    main.Active = true
    main.Parent = screenGui
    
    -- Обводка как в skeet
    local outline = Instance.new("Frame")
    outline.Size = UDim2.new(1, 2, 1, 2)
    outline.Position = UDim2.new(0, -1, 0, -1)
    outline.BackgroundColor3 = Core.Colors.Accent
    outline.BorderSizePixel = 0
    outline.BackgroundTransparency = 0.5
    outline.Parent = main
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 25)
    title.BackgroundColor3 = Core.Colors.Accent
    title.Text = "gamesense.club | silent aim"
    title.TextColor3 = Core.Colors.Text
    title.TextSize = 12
    title.Font = Enum.Font.Code
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = main
    
    -- Табы
    local tabs = {"AIMBOT", "VISUALS", "MISC", "CONFIG"}
    local tabButtons = {}
    local tabContents = {}
    
    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 75, 0, 20)
        btn.Position = UDim2.new(0, 5 + (i-1)*80, 0, 30)
        btn.BackgroundColor3 = Core.Colors.DarkBackground
        btn.Text = tabName
        btn.TextColor3 = Core.Colors.Text
        btn.TextSize = 11
        btn.Font = Enum.Font.Code
        btn.Parent = main
        
        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, -10, 1, -60)
        content.Position = UDim2.new(0, 5, 0, 55)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.ScrollBarThickness = 4
        content.ScrollBarImageColor3 = Core.Colors.Accent
        content.CanvasSize = UDim2.new(0, 0, 0, 0)
        content.Visible = i == 1
        content.Parent = main
        
        tabContents[tabName] = content
        
        btn.MouseButton1Click:Connect(function()
            for _, v in pairs(tabContents) do
                v.Visible = false
            end
            content.Visible = true
        end)
        
        table.insert(tabButtons, btn)
    end
    
    -- Функции создания элементов
    function Menu.createCheckbox(parent, text, y, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 20)
        frame.Position = UDim2.new(0, 5, 0, y)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local box = Instance.new("Frame")
        box.Size = UDim2.new(0, 15, 0, 15)
        box.Position = UDim2.new(0, 0, 0.5, -7.5)
        box.BackgroundColor3 = default and Core.Colors.Accent or Core.Colors.DarkBackground
        box.BorderSizePixel = 1
        box.BorderColor3 = Core.Colors.Accent
        box.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 1, 0)
        label.Position = UDim2.new(0, 20, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Core.Colors.Text
        label.TextSize = 11
        label.Font = Enum.Font.Code
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = frame
        
        local state = default
        btn.MouseButton1Click:Connect(function()
            state = not state
            box.BackgroundColor3 = state and Core.Colors.Accent or Core.Colors.DarkBackground
            callback(state)
        end)
    end
    
    function Menu.createSlider(parent, text, y, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 30)
        frame.Position = UDim2.new(0, 5, 0, y)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 15)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. default
        label.TextColor3 = Core.Colors.Text
        label.TextSize = 11
        label.Font = Enum.Font.Code
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, -10, 0, 4)
        bg.Position = UDim2.new(0, 0, 0, 20)
        bg.BackgroundColor3 = Core.Colors.DarkBackground
        bg.BorderColor3 = Core.Colors.Accent
        bg.BorderSizePixel = 1
        bg.Parent = frame
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Core.Colors.Accent
        fill.BorderSizePixel = 0
        fill.Parent = bg
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = bg
        
        local dragging = false
        local value = default
        
        btn.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        Core.Services.UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        Core.Services.UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = Core.Services.UserInputService:GetMouseLocation()
                local absPos = bg.AbsolutePosition
                local relX = math.clamp(mousePos.X - absPos.X, 0, bg.AbsoluteSize.X)
                local percent = relX / bg.AbsoluteSize.X
                value = min + (max - min) * percent
                value = math.floor(value * 10) / 10
                fill.Size = UDim2.new(percent, 0, 1, 0)
                label.Text = text .. ": " .. value
                callback(value)
            end
        end)
    end
    
    function Menu.createKeybind(parent, text, y, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 20)
        frame.Position = UDim2.new(0, 5, 0, y)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 100, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Core.Colors.Text
        label.TextSize = 11
        label.Font = Enum.Font.Code
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 60, 0, 15)
        btn.Position = UDim2.new(1, -65, 0.5, -7.5)
        btn.BackgroundColor3 = Core.Colors.DarkBackground
        btn.BorderColor3 = Core.Colors.Accent
        btn.BorderSizePixel = 1
        btn.Text = "MOUSE2"
        btn.TextColor3 = Core.Colors.Text
        btn.TextSize = 10
        btn.Font = Enum.Font.Code
        btn.Parent = frame
        
        local listening = false
        btn.MouseButton1Click:Connect(function()
            listening = true
            btn.Text = "..."
        end)
        
        Core.Services.UserInputService.InputBegan:Connect(function(input)
            if listening then
                listening = false
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    btn.Text = "MOUSE1"
                    callback(Enum.UserInputType.MouseButton1)
                elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                    btn.Text = "MOUSE2"
                    callback(Enum.UserInputType.MouseButton2)
                elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                    btn.Text = "MOUSE3"
                    callback(Enum.UserInputType.MouseButton3)
                elseif input.KeyCode ~= Enum.KeyCode.Unknown then
                    btn.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                    callback(input.KeyCode)
                end
            end
        end)
    end
    
    -- Заполняем вкладки
    local yPos = 0
    
    -- Aimbot tab
    Menu.createCheckbox(tabContents.AIMBOT, "Enable Aimbot", yPos, Core.Settings.Aimbot.Enabled, function(val)
        Core.Settings.Aimbot.Enabled = val
    end)
    yPos = yPos + 25
    
    Menu.createCheckbox(tabContents.AIMBOT, "Silent Aim", yPos, Core.Settings.Aimbot.Silent, function(val)
        Core.Settings.Aimbot.Silent = val
    end)
    yPos = yPos + 25
    
    Menu.createCheckbox(tabContents.AIMBOT, "Team Check", yPos, Core.Settings.Aimbot.TeamCheck, function(val)
        Core.Settings.Aimbot.TeamCheck = val
    end)
    yPos = yPos + 25
    
    Menu.createCheckbox(tabContents.AIMBOT, "Toggle Mode", yPos, Core.Settings.Aimbot.ToggleMode, function(val)
        Core.Settings.Aimbot.ToggleMode = val
    end)
    yPos = yPos + 25
    
    Menu.createSlider(tabContents.AIMBOT, "FOV", yPos, 0, 360, Core.Settings.Aimbot.FOV, function(val)
        Core.Settings.Aimbot.FOV = val
    end)
    yPos = yPos + 35
    
    Menu.createSlider(tabContents.AIMBOT, "Prediction", yPos, 0, 1, Core.Settings.Aimbot.Prediction, function(val)
        Core.Settings.Aimbot.Prediction = val
    end)
    yPos = yPos + 35
    
    Menu.createKeybind(tabContents.AIMBOT, "Trigger Key", yPos, Core.Settings.Aimbot.TriggerKey, function(val)
        Core.Settings.Aimbot.TriggerKey = val
    end)
    yPos = yPos + 25
    
    tabContents.AIMBOT.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
    
    -- Visuals tab
    yPos = 0
    
    Menu.createCheckbox(tabContents.VISUALS, "Show FOV", yPos, true, function(val)
        -- визуал
    end)
    yPos = yPos + 25
    
    Menu.createCheckbox(tabContents.VISUALS, "Show Target Line", yPos, true, function(val)
        -- визуал
    end)
    yPos = yPos + 25
    
    Menu.createCheckbox(tabContents.VISUALS, "Show Target Dot", yPos, true, function(val)
        -- визуал
    end)
    yPos = yPos + 25
    
    tabContents.VISUALS.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
    
    -- Обработка открытия/закрытия
    Core.Services.UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            Core.State.menuOpen = not Core.State.menuOpen
            main.Visible = Core.State.menuOpen
            
            -- Показываем/скрываем курсор
            Core.Services.UserInputService.MouseIconEnabled = Core.State.menuOpen
            Core.Mouse.Icon = Core.State.menuOpen and "" or "rbxasset://textures\\MouseLockedCursor.png"
        end
    end)
    
    return main
end

Menu.Window = createWindow()
return Menu
