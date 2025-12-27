Config = Config or {}

-- Token do Bot do Discord
-- Para criar um bot: https://discord.com/developers/applications
-- Adicione o bot ao seu servidor com permissões de "Read Members"
Config.BotToken = ""

-- ID do Servidor Discord
-- Para pegar: Ative o Modo Desenvolvedor no Discord > Clique com botão direito no servidor > Copiar ID
Config.GuildId = ""

-- ID da Role Necessária
-- Para pegar: Clique com botão direito na role > Copiar ID
Config.RequiredRoleId = ""

-- Nome da Role (para exibir)
Config.RoleName = ""

-- Nome do Servidor (para exibir)
Config.ServerName = ""

-- Link de help para conectar o Discord ao FiveM (recomendo não alterar)
Config.CFXHelp = "https://support.cfx.re/hc/en-us/articles/18919080288412-How-to-link-your-Cfx-Account-to-the-FiveM-client"

Config.Messages = {
    NoDiscord = "\n\n❌ Você precisa ter o Discord conectado ao FiveM para entrar neste servidor!\n\nSaiba mais: " .. Config.CFXHelp,
    NotInServer = "\n\n❌ Você não está no servidor Discord: " .. Config.ServerName .. "\n\nDiscord: " .. Config.DiscordLink,
    NoRole = "\n\n❌ Você não possui o cargo necessário: " .. Config.RoleName .. "\n\nFaça a whitelist no Discord: " .. Config.DiscordLink,
    Checking = "\n\n🔄 Verificando autenticação Discord...",
    ApiError = "\n\n❌ Erro ao verificar Discord. Tente novamente em alguns instantes.\n\nDiscord: " .. Config.DiscordLink,
    Success = "\n\n✅ Autenticação Discord concluída com sucesso!",
}

-- Para ver logs detalhados no console
Config.Debug = false

-- Tempo de timeout para requisições
Config.Timeout = 5000
