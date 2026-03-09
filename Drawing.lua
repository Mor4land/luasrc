--[[
    Drawing.lua
    Визуальные элементы (FOV круг, линии)
]]

local DrawingModule = {}
local Core = require(script.Parent.Core)

function DrawingModule.new()
    local self = {}
    
    self.FOVCircle = Drawing.new("Circle")
    self.FOVCircle.Thickness = 2
    self.FOVCircle.NumSides = 64
    self.FOVCircle.Filled = false
    self.FOVCircle.Color = Core.Colors.Red
    self.FOVCircle.Transparency = 1
    self.FOVCircle.Visible = false
    
    self.TargetLine = Drawing.new("Line")
    self.TargetLine.Thickness = 1
    self.TargetLine.Color = Core.Colors.Accent
    self.TargetLine.Visible = false
    
    self.Snaplines = {} -- для нескольких линий
    
    function self:updateFOV(pos, radius, locked)
        self.FOVCircle.Position = pos
        self.FOVCircle.Radius = radius
        self.FOVCircle.Color = locked and Core.Colors.Green or Core.Colors.Red
        self.FOVCircle.Visible = Core.Settings.Aimbot.Enabled
    end
    
    function self:drawTargetDot(pos)
        local dot = Drawing.new("Square")
        dot.Size = Vector2.new(6, 6)
        dot.Position = Vector2.new(pos.X - 3, pos.Y - 3)
        dot.Filled = true
        dot.Color = Core.Colors.Accent
        dot.Visible = true
        dot.Transparency = 1
        Core.Services.RunService.RenderStepped:Wait()
        dot:Remove()
    end
    
    function self:drawTargetLine(from, to)
        self.TargetLine.From = from
        self.TargetLine.To = to
        self.TargetLine.Visible = true
    end
    
    function self:hideTargetLine()
        self.TargetLine.Visible = false
    end
    
    return self
end

return DrawingModule
