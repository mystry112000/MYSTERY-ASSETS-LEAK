-- Saved by MYSTERY!-ASSETS LEAK
  (Join to Copy Games) https://discord.gg/9F7sxKb7

local saveinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/mystry112000/MYSTERY-ASSETS-LEAK/main/saveinstance.lua", true))()

-- First, save ALL visual settings into a model that gets captured
local visualBackup = Instance.new("Model")
visualBackup.Name = "__VisualBackup"
visualBackup.Parent = workspace

-- 1. SAVE LIGHTING
local lighting = game:GetService("Lighting")
local lightingData = Instance.new("Folder")
lightingData.Name = "LightingData"

-- Store every lighting property
for _, prop in ipairs({
    "Ambient", "Brightness", "ColorShift_Bottom", "ColorShift_Top",
    "ExposureCompensation", "FogColor", "FogEnd", "FogStart",
    "GlobalShadows", "OutdoorAmbient", "Outlines",
    "ShadowSoftness", "Technology", "TimeOfDay",
    "ClockTime", "GeographicLatitude", "EnvironmentDiffuseScale",
    "EnvironmentSpecularScale"
}) do
    local value = Instance.new("StringValue")
    value.Name = prop
    pcall(function()
        value.Value = tostring(lighting[prop])
    end)
    value.Parent = lightingData
end

-- Save Lighting effects (Bloom, ColorCorrection, SunRays, etc.)
for _, child in ipairs(lighting:GetChildren()) do
    if child:IsA("PostEffect") or child:IsA("Sky") or child:IsA("Atmosphere") then
        local clone = child:Clone()
        clone.Parent = lightingData
    end
end

lightingData.Parent = visualBackup

-- 2. SAVE TERRAIN PAINT DATA (custom colors on terrain)
local terrain = workspace.Terrain
if terrain then
    local terrainData = Instance.new("Folder")
    terrainData.Name = "TerrainVisuals"
    
    -- Save terrain appearance properties
    for _, prop in ipairs({
        "Appearance", "Decoration", "MaterialColors", "MaterialPatterns",
        "WaterColor", "WaterReflectance", "WaterTransparency",
        "WaterWaveSize", "WaterWaveSpeed"
    }) do
        local success, result = pcall(function()
            local value = Instance.new("StringValue")
            value.Name = prop
            value.Value = tostring(terrain[prop])
            value.Parent = terrainData
        end)
    end
    
    -- Save custom material colors (painted terrain)
    local scanBounds = Region3int16.new(
        Vector3int16.new(-256, 0, -256),
        Vector3int16.new(256, 64, 256)
    )
    
    local success, materialArray = pcall(function()
        return terrain:ReadVoxels(scanBounds, 4)
    end)
    
    if success and materialArray then
        local colorsValue = Instance.new("StringValue")
        colorsValue.Name = "MaterialColorsPalette"
        colorsValue.Value = game:GetService("HttpService"):JSONEncode({
            terrain.MaterialColors
        })
        colorsValue.Parent = terrainData
    end
    
    terrainData.Parent = visualBackup
end

-- 3. SAVE WORKSPACE VISUAL SETTINGS
local wsData = Instance.new("Folder")
wsData.Name = "WorkspaceVisuals"

for _, prop in ipairs({
    "CurrentCamera", "DistributedGameTime", "Gravity",
    "StreamingEnabled", "StreamingMinRadius", "StreamingTargetRadius",
    "Terrain", "ViewportFocused", "WorldPaused"
}) do
    local value = Instance.new("StringValue")
    value.Name = prop
    pcall(function()
        value.Value = tostring(workspace[prop])
    end)
    value.Parent = wsData
end

wsData.Parent = visualBackup

-- 4. SAVE CAMERA SETTINGS (field of view, etc.)
local camera = workspace.CurrentCamera
if camera then
    local camData = Instance.new("Folder")
    camData.Name = "CameraData"
    
    for _, prop in ipairs({
        "FieldOfView", "CameraType", "CameraSubject",
        "HeadScale", "VRDeviceModel"
    }) do
        local value = Instance.new("StringValue")
        value.Name = prop
        pcall(function()
            value.Value = tostring(camera[prop])
        end)
        value.Parent = camData
    end
    
    camData.Parent = visualBackup
end

-- 5. NOW RUN SAVEINSTANCE WITH ENHANCED OPTIONS
saveinstance({
    SaveTerrain = true,
    StreamOnly = false,
    Scripts = false,
    RemoveDefaultTags = true,
    RemoveCollision = false,
    Compress = true
})

-- Cleanup
visualBackup:Destroy()

print("✅ Game saved with full visual data!")
