-- a basic ATM implementation
local lang = vRP.lang
local cfg = module("cfg/atms")
local atms = cfg.atms
local onesync = GetConvar('onesync', nil)
local function play_atm_enter(player)
    vRPclient.playAnim(player, {false,
                                {{"amb@prop_human_atm@male@enter", "enter"},
                                 {"amb@prop_human_atm@male@idle_a", "idle_a"}}, false})
end

local function play_atm_exit(player)
    vRPclient.playAnim(player, {false, {{"amb@prop_human_atm@male@exit", "exit"}}, false})
end

local function atm_choice_deposit(player, choice)
    play_atm_enter(player) -- anim

    vRP.prompt(source, lang.atm.deposit.prompt(), "", function(player, v)
        play_atm_exit(player)

        v = parseInt(v)

        if v > 0 then
            local user_id = vRP.getUserId(source)
            if user_id ~= nil then
                if vRP.tryDeposit(user_id, v) then
                    vRPclient.notify(source, {lang.atm.deposit.deposited({v})})
                else
                    vRPclient.notify(source, {lang.money.not_enough()})
                end
            end
        else
            vRPclient.notify(source, {lang.common.invalid_value()})
        end
    end)
end


RegisterNetEvent('VRP:Withdraw')
AddEventHandler('VRP:Withdraw', function(amount)
    local source = source
    amount = parseInt(amount)
    if onesync ~= "off" then    
        --Onesync allows extra security behind events should enable it if it's not already.
        local ped = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(ped)
        for i, v in pairs(cfg.atms) do
            local coords = vec3(v[1], v[2], v[3])
            if #(playerCoords - coords) <= 5.0 then
                if amount > 0 then
                    local user_id = vRP.getUserId(source)
                    if user_id ~= nil then
                        if vRP.tryWithdraw(user_id, amount) then
                            vRPclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
                            webhook = "https://discord.com/api/webhooks/938627333135409172/t-QU_LfC7TB7gyLzGrh_l3CQj3KHOtUCawVPsieFNLx7MPzpPu8Auhb9vzYZDEveU3cB"
                            PerformHttpRequest(webhook, function(err, text, headers) 
                            end, "POST", json.encode({username = "Galaxy Roleplay", embeds = {
                                {
                                    ["color"] = "15158332",
                                    ["title"] = "",
                                    ["description"] = "Name: **" .. GetPlayerName(source) .. "** \nUser ID: **" .. vRP.getUserId(source) .. "** \nWithdrawed: **£" .. tostring(amount) .. '**',
                                    ["footer"] = {
                                        ["text"] = "Time - "..os.date("%x %X %p"),
                                    }
                            }
                        }}), { ["Content-Type"] = "application/json" })
                        else
                            vRPclient.notify(source, {lang.atm.withdraw.not_enough()})
                        end
                    end
                else
                    vRPclient.notify(source, {lang.common.invalid_value()})
                end
            end
        end
    else
        if amount > 0 then
            local user_id = vRP.getUserId(source)
            if user_id ~= nil then
                if vRP.tryWithdraw(user_id, amount) then
                    vRPclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
                else
                    vRPclient.notify(source, {lang.atm.withdraw.not_enough()})
                end
            end
        else
            vRPclient.notify(source, {lang.common.invalid_value()})
        end
    end
end)


RegisterNetEvent('VRP:Deposit')
AddEventHandler('VRP:Deposit', function(amount)
    local source = source
    amount = parseInt(amount)
    if onesync ~= "off" then    
        --Onesync allows extra security behind events should enable it if it's not already.
        local ped = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(ped)
        for i, v in pairs(cfg.atms) do
            local coords = vec3(v[1], v[2], v[3])
            if #(playerCoords - coords) <= 5.0 then
                if amount > 0 then
                    local user_id = vRP.getUserId(source)
                    if user_id ~= nil then
                        if vRP.tryDeposit(user_id, amount) then
                            vRPclient.notify(source, {lang.atm.deposit.deposited({amount})})
                            webhook = "https://discord.com/api/webhooks/938627333135409172/t-QU_LfC7TB7gyLzGrh_l3CQj3KHOtUCawVPsieFNLx7MPzpPu8Auhb9vzYZDEveU3cB"
                            PerformHttpRequest(webhook, function(err, text, headers) 
                            end, "POST", json.encode({username = "Galaxy Roleplay", embeds = {
                                {
                                    ["color"] = "15158332",
                                    ["title"] = "",
                                    ["description"] = "Name: **" .. GetPlayerName(source) .. "** \nUser ID: **" .. vRP.getUserId(source) .. "** \nDeposit: **£" .. tostring(amount) .. '**',
                                    ["footer"] = {
                                        ["text"] = "Time - "..os.date("%x %X %p"),
                                    }
                            }
                        }}), { ["Content-Type"] = "application/json" })
                        else
                            vRPclient.notify(source, {lang.money.not_enough()})
                        end
                    end
                else
                    vRPclient.notify(source, {lang.common.invalid_value()})
                end
            end
        end
    else
        if amount > 0 then
            local user_id = vRP.getUserId(source)
            if user_id ~= nil then
                if vRP.tryDeposit(user_id, amount) then
                    vRPclient.notify(source, {lang.atm.deposit.deposited({amount})})
                else
                    vRPclient.notify(source, {lang.money.not_enough()})
                end
            end
        else
            vRPclient.notify(source, {lang.common.invalid_value()})
        end
    end
end)

local function atm_choice_withdraw(player, choice)
    play_atm_enter(player)

    vRP.prompt(source, lang.atm.withdraw.prompt(), "", function(player, v)
        play_atm_exit(player) -- anim

        v = parseInt(v)

        if v > 0 then
            local user_id = vRP.getUserId(source)
            if user_id ~= nil then
                if vRP.tryWithdraw(user_id, v) then
                    vRPclient.notify(source, {lang.atm.withdraw.withdrawn({v})})
                else
                    vRPclient.notify(source, {lang.atm.withdraw.not_enough()})
                end
            end
        else
            vRPclient.notify(source, {lang.common.invalid_value()})
        end
    end)
end

local atm_menu = {
    name = lang.atm.title(),
    css = {
        top = "75px",
        header_color = "rgba(0,255,125,0.75)"
    }
}

atm_menu[lang.atm.deposit.title()] = {atm_choice_deposit, lang.atm.deposit.description()}
atm_menu[lang.atm.withdraw.title()] = {atm_choice_withdraw, lang.atm.withdraw.description()}

local function atm_enter()
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        atm_menu[lang.atm.info.title()] = {function()
        end, lang.atm.info.bank({vRP.getBankMoney(user_id)})}
        vRP.openMenu(source, atm_menu)
    end
end

local function atm_leave()
    vRP.closeMenu(source)
end

local function build_client_atms(source)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        for k, v in pairs(atms) do
            local x, y, z = table.unpack(v)

            vRPclient.addBlip(source, {x, y, z, 108, 4, lang.atm.title()})
            vRPclient.addMarker(source, {x, y, z - 1, 0.7, 0.7, 0.5, 0, 255, 125, 125, 150})

            vRP.setArea(source, "vRP:atm" .. k, x, y, z, 1, 1.5, atm_enter, atm_leave)
        end
    end
end

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
     --   build_client_atms(source)
     -- Old atms now deprecated.
    end
end)
