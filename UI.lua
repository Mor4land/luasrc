--[[
    МОДУЛЬ 2 - UI ELEMENTS
    Сохрани как "UI.lua"
]]

local UI = {}
local Core = require(script.Parent.Core)

function UI.createButton(parent, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 150, 0, 30)
    button.Position = position
    button.BackgroundColor3 = Core.Settings.Menu.BackgroundColor
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Core.Settings.Menu.TextColor
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    
    local hoverColor = Core.Settings.Menu.AccentColor:Lerp(Color3.new(1,1,1), 0.3)
    
    button.MouseEnter:Connect(function()
        Core.TweenService:Create(button, Core.TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        Core.TweenService:Create(button, Core.TweenInfo.new(0.2), {BackgroundColor3 = Core.Settings.Menu.BackgroundColor}):Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

function UI.createSlider(parent, text, position, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 50)
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Core.Settings.Menu.TextColor
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 4)
    sliderBg.Position = UDim2.new(0, 0, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 2)
    corner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Core.Settings.Menu.AccentColor
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = sliderFill
    
    local value = default
    local dragging = false
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(1, 0, 1, 0)
    sliderButton.BackgroundTransparency = 1
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    Core.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    Core.UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = Core.UserInputService:GetMouseLocation()
            local absPos = sliderBg.AbsolutePosition
            local relX = math.clamp(mousePos.X - absPos.X, 0, sliderBg.AbsoluteSize.X)
            local percent = relX / sliderBg.AbsoluteSize.X
            value = min + (max - min) * percent
            value = math.floor(value * 10) / 10
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = text .. ": " .. value
            callback(value)
        end
    end)
    
    return frame
end

function UI.createToggle(parent, text, position, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 30)
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 20, 0, 20)
    box.Position = UDim2.new(0, 0, 0.5, -10)
    box.BackgroundColor3 = default and Core.Settings.Menu.AccentColor or Color3.fromRGB(50, 50, 50)
    box.BorderSizePixel = 0
    box.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = box
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Position = UDim2.new(0, 30, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Core.Settings.Menu.TextColor
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = frame
    
    local toggled = default
    
    button.MouseButton1Click:Connect(function()
        toggled = not toggled
        box.BackgroundColor3 = toggled and Core.Settings.Menu.AccentColor or Color3.fromRGB(50, 50, 50)
        callback(toggled)
    end)
    
    return frame
end

return UI
