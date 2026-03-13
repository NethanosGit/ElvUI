local E, L, V, P, G = unpack(select(2, ...));
local UF = E:GetModule("UnitFrames")

function UF:Construct_ClassIcon(frame)
    local ClassIcon = frame.RaisedElementParent.TextureParent:CreateTexture(nil, "ARTWORK")
    ClassIcon:Size(16, 16)
    ClassIcon:Point("LEFT", frame, "RIGHT")
    return ClassIcon
end

function UF:Configure_ClassIcon(frame)
    local ClassIcon = frame.ClassIcon
    ClassIcon:ClearAllPoints()
    ClassIcon:Point(frame.db.classIcon.anchorPoint or "LEFT", frame.Health, frame.db.classIcon.anchorPoint or "LEFT",
        frame.db.classIcon.xOffset or 0, frame.db.classIcon.yOffset or 0)

    local scale = frame.db.classIcon.scale or 1
    ClassIcon:Size(16 * scale)

    if frame.db.classIcon.enable and not frame:IsElementEnabled("ClassIcon") then
        frame:EnableElement("ClassIcon")
    elseif not frame.db.classIcon.enable and frame:IsElementEnabled("ClassIcon") then
        frame:DisableElement("ClassIcon")
    end
end
