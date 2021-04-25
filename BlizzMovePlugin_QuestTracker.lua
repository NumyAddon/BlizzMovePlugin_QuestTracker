-- upvalue the globals
local _G = getfenv(0);
local CreateFrame = _G.CreateFrame;
local ObjectiveTrackerFrame = _G.ObjectiveTrackerFrame;
local BlizzMoveAPI = _G.BlizzMoveAPI;
local print = _G.print;
local IsAddOnLoaded = _G.IsAddOnLoaded;

local name = ...;

_G.BlizzMovePlugin_QuestTracker = {};
local plugin = _G.BlizzMovePlugin_QuestTracker;

local frame = CreateFrame('Frame');
frame:HookScript('OnEvent', function(_, _, addonName) plugin:ADDON_LOADED(addonName); end);
frame:RegisterEvent('ADDON_LOADED');

plugin.frameTable = {
    [name] = {
        ["ObjectiveTrackerFrame"] = {
            MinVersion = 20000,
            IgnoreMouse = true,
            SubFrames = {
                ['BlizzMovePlugin_QuestTracker.MoveHandleFrame'] = {
                    MinVersion = 20000,
                },
            },
        },
    },
};

function plugin:CreateMoveHandleAtPoint(parentFrame, anchorPoint, relativePoint, offX, offY)
    if (not parentFrame) then return nil; end

    local handleFrame = CreateFrame('Frame');
    handleFrame:SetPoint(anchorPoint, parentFrame, relativePoint, offX, offY);
    handleFrame:SetHeight(16);
    handleFrame:SetWidth(16);

    handleFrame.texture = handleFrame:CreateTexture();
    handleFrame.texture:SetTexture('Interface/Buttons/UI-Panel-BiggerButton-Up');
    handleFrame.texture:SetTexCoord(0.15, 0.85, 0.15, 0.85);
    handleFrame.texture:SetAllPoints();

    return handleFrame;
end

function plugin:ADDON_LOADED(addonName)
    if (addonName == 'BlizzMove' or (addonName == name and IsAddOnLoaded('BlizzMove'))) then
        if (not BlizzMoveAPI or not BlizzMoveAPI.RegisterAddOnFrames) then
            print(name .. ' - Incompatible BlizzMove version is installed, please update BlizzMove!');
            return;
        end
        self.MoveHandleFrame = self:CreateMoveHandleAtPoint(
                ObjectiveTrackerFrame,
                'CENTER',
                'TOPRIGHT',
                8,
                -12
        )
        BlizzMoveAPI:RegisterAddOnFrames(self.frameTable);
    end
end


