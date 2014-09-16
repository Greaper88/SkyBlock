-- Stores informations of the player

cPlayerInfo = {}
cPlayerInfo.__index = cPlayerInfo

function cPlayerInfo.new(a_Player)
    local self = setmetatable({}, cPlayerInfo)
    
    self.playerName = a_Player:GetName()
    self.islandNumber = -1 -- Set to -1 for no island
    self.playerFile = PLUGIN:GetLocalDirectory() .. "/players/" .. a_Player:GetUUID() .. ".ini"
    self.isLevel = LEVELS[1].levelName -- Set first level
    self.completedChallenges = {}
    self.completedChallenges[self.isLevel] = {}
        
    self.Load(self, a_Player) -- Check if there is a player file, if yes load it
    return self
end

function cPlayerInfo.HasCompleted(self, a_Level, a_ChallengeName)
    if (self.completedChallenges[a_Level] == nil) then
        return false
    end
    
    if (self.completedChallenges[a_Level][a_ChallengeName] == nil) then
        return false
    end
    
    return true
end

function cPlayerInfo.Save(self) -- Save PlayerInfo
    if (self.islandNumber == -1) then -- Only save player info, if he has an island
        return
    end

    local PlayerInfoIni = cIniFile()
    PlayerInfoIni:SetValue("Player", "Name", self.playerName, true)
    PlayerInfoIni:SetValue("Island", "Number", self.islandNumber, true)
    
    for i = 1, #LEVELS do
        local res = ""
        local first = true
        if (self.completedChallenges[LEVELS[i].levelName] == nil) then
            break
        end
        
        for index, value in pairs(self.completedChallenges[LEVELS[i].levelName]) do
            if (first) then
                first = false
            else
                res = res .. ":"
            end
            res = res .. index;
        end
        
        PlayerInfoIni:SetValue("Completed", LEVELS[i].levelName, res, true)
    end
    PlayerInfoIni:SetValue("Player", "IsLevel", self.isLevel, true)
    PlayerInfoIni:WriteFile(self.playerFile)
end

function cPlayerInfo.Load(self, a_Player) -- Load PlayerInfo
    local PlayerInfoIni = cIniFile()
    
    -- Check for old file, backward compability
    if (cFile:Exists(PLUGIN:GetLocalDirectory() .. "/players/" .. a_Player:GetName() .. ".ini")) then -- Rename file if exists
        cFile:Rename(PLUGIN:GetLocalDirectory() .. "/players/" .. a_Player:GetName() .. ".ini", self.playerFile)
    end
    
    if (PlayerInfoIni:ReadFile(self.playerFile) == false) then
        return
    end
    
    self.islandNumber = PlayerInfoIni:GetValueI("Island", "Number")
    
    for l = 1, #LEVELS do
        self.completedChallenges[LEVELS[l].levelName] = {}
        local list = PlayerInfoIni:GetValue("Completed", LEVELS[l].levelName)
        if (list == nil) then
            break
        end
            
        local values = StringSplit(list, ":")
    
        for i = 1, #values do
            self.completedChallenges[LEVELS[l].levelName][values[i]] = true
        end
    end
    self.isLevel = PlayerInfoIni:GetValue("Player", "IsLevel")
    if (self.isLevel == "") then
        self.isLevel = LEVELS[1].levelName
    end
end
