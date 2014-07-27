function CommandChallenges(a_Split, a_Player) -- Handle the command challenges.    
    if (#a_Split == 1) then -- List all challenge names, light gray for completed and light green for not
        local pi = PLAYERS[a_Player:GetName()]
        
        for index, level in pairs(LEVELS) do
            a_Player:SendMessageInfo("--- Level: " .. level.levelName .. " ---")
            
            local first = true
            local list = ""
            for name, ci in pairs(level.challenges) do
                    if (first) then
                    first = false
                else
                    list = list .. ", "
                end
                
                if (pi:HasCompleted(level.levelName, name)) then
                    list = list .. cChatColor.LightGreen .. name
                else
                    list = list .. cChatColor.LightGray .. name
                end
            end
            a_Player:SendMessageInfo(list)
        end
        
        return true
    end
        
    if (a_Split[2] == "info") then -- List all infos to a challenge
        if (#a_Split == 2) then
            a_Player:SendMessageInfo("/challenges info <name>")
            return true
        end
        
        local ci = GetChallenge(a_Split[3])
        if (ci == nil) then
            a_Player:SendMessageFailure("There is no challenge with that name.")
            return true
        end
        a_Player:SendMessage("--- " .. cChatColor.Green .. ci.challengeName .. cChatColor.White .. " ---")
        a_Player:SendMessage(cChatColor.LightBlue .. ci.description)
        a_Player:SendMessage(cChatColor.LightGreen .. "Gather this items: " .. cChatColor.White .. ci.requiredText)
        a_Player:SendMessage(cChatColor.Gold .. "You get for completion: " .. cChatColor.White .. ci.rewardText)            
        return true
    end
    
    if (a_Split[2] == "complete") then -- Complete a challenge
        local pi = PLAYERS[a_Player:GetName()]
        if (pi:GetIslandNumber() == -1) then
            a_Player:SendMessageFailure("You have no island. Type /skyblock play first.")
            return true
        end
        if (#a_Split == 2) then
            a_Player:SendMessageInfo("/challenges complete <name>")
            return true
        end
        
        local ci = GetChallenge(a_Split[3])
        if (ci == nil) then
            a_Player:SendMessageFailure("There is no challenge with that name.")
            return true
        end
        
        ci:IsCompleted(a_Player)
        return true
    end
    
    a_Player:SendMessageFailure("Unknwown argument.")
    return true
end

