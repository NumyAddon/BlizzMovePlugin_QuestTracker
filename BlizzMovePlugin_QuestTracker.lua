-- upvalue the globals
local _G = getfenv(0);
local CreateFrame = _G.CreateFrame;
local ObjectiveTrackerFrame = _G.ObjectiveTrackerFrame;
local BlizzMoveAPI = _G.BlizzMoveAPI;
local print = _G.print;
local IsAddOnLoaded = _G.IsAddOnLoaded;
local UIParent = _G.UIParent;

local name = ... or 'BlizzMovePlugin_QuestTracker';

_G.BlizzMovePlugin_QuestTracker = {};
local Plugin = _G.BlizzMovePlugin_QuestTracker;

local frame = CreateFrame('Frame');
frame:HookScript('OnEvent', function(_, _, addonName) Plugin:ADDON_LOADED(addonName); end);
frame:RegisterEvent('ADDON_LOADED');

Plugin.frameTable = {
    [name] = {
        ["ObjectiveTrackerFrame"] = {
            MinVersion = 30000, -- added when?
            IgnoreMouse = true,
            SubFrames = {
                ['BlizzMovePlugin_QuestTracker.MoveHandleFrame'] = {
                    MinVersion = 30000, -- added when?
                },
            },
        },
    },
};

function Plugin:CreateMoveHandleAtPoint(parentFrame, anchorPoint, relativePoint, offX, offY)
    if (not parentFrame) then return nil; end

    local handleFrame = CreateFrame('Frame', nil, UIParent);
    handleFrame:SetPoint(anchorPoint, parentFrame, relativePoint, offX, offY);
    handleFrame:SetHeight(16);
    handleFrame:SetWidth(16);
    handleFrame:SetFrameStrata(parentFrame:GetFrameStrata());

    handleFrame.texture = handleFrame:CreateTexture();
    handleFrame.texture:SetTexture('Interface/Buttons/UI-Panel-BiggerButton-Up');
    handleFrame.texture:SetTexCoord(0.15, 0.85, 0.15, 0.85);
    handleFrame.texture:SetAllPoints();

    return handleFrame;
end

function Plugin:ADDON_LOADED(addonName)
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


