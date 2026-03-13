--[[
# Element: Class Icon

Handles the visibility and updating of an indicator based on the unit's class.

## Widget

ClassIcon - A `Texture` used to display the unit's class icon.

## Notes

This element updates by changing the texture and coordinates based on the unit's class.

## Examples

    -- Position and size
    local ClassIcon = self:CreateTexture(nil, 'ARTWORK', nil, 1)
    ClassIcon:SetSize(16, 16)
    ClassIcon:SetPoint('LEFT', self, 'RIGHT')

    -- Register it with oUF
    self.ClassIcon = ClassIcon
--]]

local _, ns = ...
local oUF = ns.oUF

local UnitIsPlayer = UnitIsPlayer
local UnitClass = UnitClass

local CLASS_ICON_PATH = "Interface\\Addons\\ElvUI\\Media\\Icons\\ToxiClasses.blp"

local function GetToxiClassCoords(col, row)
    local width, height = 64, 64
    local x1 = (col - 1) * width
    local x2 = col * width
    local y1 = (row - 1) * height
    local y2 = row * height
    return x1, x2, y1, y2
end

local CLASS_ICON_TCOORDS = {
    ["WARRIOR"]     = { GetToxiClassCoords(1, 1) },
    ["MAGE"]        = { GetToxiClassCoords(2, 1) },
    ["ROGUE"]       = { GetToxiClassCoords(3, 1) },
    ["DRUID"]       = { GetToxiClassCoords(4, 1) },
    ["HUNTER"]      = { GetToxiClassCoords(1, 2) },
    ["SHAMAN"]      = { GetToxiClassCoords(2, 2) },
    ["PRIEST"]      = { GetToxiClassCoords(3, 2) },
    ["WARLOCK"]     = { GetToxiClassCoords(4, 2) },
    ["PALADIN"]     = { GetToxiClassCoords(1, 3) },
    ["DEATHKNIGHT"] = { GetToxiClassCoords(2, 3) },
}

local function Update(self, event, unit)
    if (unit ~= self.unit) then return end

    local element = self.ClassIcon

    if (element.PreUpdate) then
        element:PreUpdate(unit)
    end

    local status
    if UnitIsPlayer(unit) then
        local _, class = UnitClass(unit)
        local coords = CLASS_ICON_TCOORDS[class]
        if coords then
            element:SetTexture(CLASS_ICON_PATH)
            element:SetTexCoord(coords[1] / 512, coords[2] / 512, coords[3] / 512, coords[4] / 512)
            element:Show()
            status = class
        else
            element:Hide()
        end
    else
        element:Hide()
    end

    if (element.PostUpdate) then
        return element:PostUpdate(unit, status)
    end
end

local function Path(self, ...)
    return (self.ClassIcon.Override or Update)(self, ...)
end

local function ForceUpdate(element)
    return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
    local element = self.ClassIcon
    if (element) then
        element.__owner = self
        element.ForceUpdate = ForceUpdate

        self:RegisterEvent('UNIT_NAME_UPDATE', Path)

        return true
    end
end

local function Disable(self)
    local element = self.ClassIcon
    if (element) then
        element:Hide()

        self:UnregisterEvent('UNIT_NAME_UPDATE', Path)
    end
end

oUF:AddElement('ClassIcon', Path, Enable, Disable)
