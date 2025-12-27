
local function DebugPrint(message)
    if Config.Debug then
        print("^3[Discord-Auth]^7 " .. message)
    end
end

local function GetDiscordId(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in pairs(identifiers) do
        if string.match(identifier, "discord:") then
            return string.gsub(identifier, "discord:", "")
        end
    end
    return nil
end

local function CheckDiscordMember(discordId, deferrals)
    local endpoint = ("https://discord.com/api/v10/guilds/%s/members/%s"):format(Config.GuildId, discordId)
    
    DebugPrint("Verificando membro: " .. discordId)
    
    PerformHttpRequest(endpoint, function(statusCode, response, headers)
        if statusCode == 200 then
            local data = json.decode(response)
            
            if data and data.roles then
                DebugPrint("Membro encontrado. Roles: " .. json.encode(data.roles))
                
                -- Verifica se o jogador tem a role necessária
                local hasRole = false
                for _, roleId in pairs(data.roles) do
                    if roleId == Config.RequiredRoleId then
                        hasRole = true
                        break
                    end
                end
                
                if hasRole then
                    DebugPrint("Role necessária encontrada!")
                    deferrals.done()
                else
                    DebugPrint("Role necessária não encontrada")
                    deferrals.done(Config.Messages.NoRole)
                end
            else
                DebugPrint("Dados inválidos retornados da API")
                deferrals.done(Config.Messages.ApiError)
            end
        elseif statusCode == 404 then
            DebugPrint("Jogador não está no servidor Discord")
            deferrals.done(Config.Messages.NotInServer)
        elseif statusCode == 401 then
            print("^1[Discord-Auth] ERRO: Token do bot inválido! Verifique o Config.BotToken^7")
            deferrals.done(Config.Messages.ApiError)
        elseif statusCode == 403 then
            print("^1[Discord-Auth] ERRO: Bot sem permissões! Certifique-se que o bot tem permissão 'Read Members'^7")
            deferrals.done(Config.Messages.ApiError)
        else
            print("^1[Discord-Auth] ERRO: Status code " .. statusCode .. " - " .. response .. "^7")
            deferrals.done(Config.Messages.ApiError)
        end
    end, "GET", "", {
        ["Authorization"] = "Bot " .. Config.BotToken,
        ["Content-Type"] = "application/json"
    })
end

-- Event Handler para quando um jogador tenta se conectar
AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
    local source = source
    deferrals.defer()
    
    Wait(0)
    deferrals.update(Config.Messages.Checking)
    
    -- Verifica se o bot token está configurado
    if Config.BotToken == "SEU_BOT_TOKEN_AQUI" or Config.BotToken == "" then
        print("^1[Discord-Auth] ERRO: Bot token não configurado! Edite o arquivo config.lua^7")
        deferrals.done("❌ Sistema de autenticação Discord não está configurado corretamente.")
        return
    end
    
    -- Verifica se o Guild ID está configurado
    if Config.GuildId == "SEU_GUILD_ID_AQUI" or Config.GuildId == "" then
        print("^1[Discord-Auth] ERRO: Guild ID não configurado! Edite o arquivo config.lua^7")
        deferrals.done("❌ Sistema de autenticação Discord não está configurado corretamente.")
        return
    end
    
    -- Verifica se o Role ID está configurado
    if Config.RequiredRoleId == "SEU_ROLE_ID_AQUI" or Config.RequiredRoleId == "" then
        print("^1[Discord-Auth] ERRO: Role ID não configurado! Edite o arquivo config.lua^7")
        deferrals.done("❌ Sistema de autenticação Discord não está configurado corretamente.")
        return
    end
    
    -- Pega o Discord ID do jogador
    local discordId = GetDiscordId(source)
    
    if not discordId then
        DebugPrint("Jogador " .. playerName .. " não tem Discord conectado")
        deferrals.done(Config.Messages.NoDiscord)
        return
    end
    
    DebugPrint("Jogador " .. playerName .. " conectando com Discord ID: " .. discordId)
    
    -- Verifica se o jogador está no servidor e tem a role
    CheckDiscordMember(discordId, deferrals)
end)

-- Comando de teste (apenas admin)
RegisterCommand("testdiscord", function(source, args)
    if source == 0 then
        local discordId = args[1]
        if not discordId then
            print("^3Uso: testdiscord <discord_id>^7")
            return
        end
        
        print("^2Testando Discord ID: " .. discordId .. "^7")
        print("^2Guild ID: " .. Config.GuildId .. "^7")
        print("^2Role ID: " .. Config.RequiredRoleId .. "^7")
        
        local endpoint = ("https://discord.com/api/v10/guilds/%s/members/%s"):format(Config.GuildId, discordId)
        
        PerformHttpRequest(endpoint, function(statusCode, response, headers)
            print("^2Status Code: " .. statusCode .. "^7")
            print("^2Response: " .. response .. "^7")
            
            if statusCode == 200 then
                local data = json.decode(response)
                if data and data.roles then
                    print("^2Roles do usuário:^7")
                    for _, roleId in pairs(data.roles) do
                        print("  - " .. roleId)
                        if roleId == Config.RequiredRoleId then
                            print("    ^2✓ ROLE NECESSÁRIA ENCONTRADA!^7")
                        end
                    end
                end
            end
        end, "GET", "", {
            ["Authorization"] = "Bot " .. Config.BotToken,
            ["Content-Type"] = "application/json"
        })
    end
end, true)

print("^2[Discord-Auth] Sistema de autenticação Discord iniciado!^7")
print("^3[Discord-Auth] Guild ID: " .. Config.GuildId .. "^7")
print("^3[Discord-Auth] Role Necessária: " .. Config.RoleName .. " (" .. Config.RequiredRoleId .. ")^7")
print("^3[Discord-Auth] Link Discord: " .. Config.DiscordLink .. "^7")

-- Exporta a funcao para outros recursos pegarem o link do Discord
exports('GetDiscordLink', function()
    return Config.DiscordLink
end)
