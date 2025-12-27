# Discord Auth - FiveM

Sistema de autenticação via Discord para servidores FiveM. Verifica se o jogador está no servidor Discord e possui a role necessária antes de permitir a entrada.

## Funcionalidades

- Verifica se o Discord está conectado ao FiveM
- Valida se o jogador está no servidor Discord
- Verifica se o jogador possui a role necessária (whitelist)
- Mensagens personalizáveis
- Sistema de debug para diagnóstico
- Suporte a ConVar para link do Discord (exporta para outros scripts poderem usar também)

## Instalação

1. Clone ou baixe este repositório para a pasta `resources` do seu servidor
2. Adicione `ensure discord-auth` ao seu `server.cfg`
3. Configure o recurso seguindo as instruções abaixo

## Configuração

### 1. Criar Bot do Discord

1. Acesse [Discord Developer Portal](https://discord.com/developers/applications)
2. Clique em "New Application" e dê um nome ao seu bot
3. Vá em "Bot" no menu lateral
4. Clique em "Reset Token" e copie o token gerado
5. Em "Privileged Gateway Intents", ative:
   - SERVER MEMBERS INTENT
   - MESSAGE CONTENT INTENT (opcional)

### 2. Adicionar Bot ao Servidor

1. No Developer Portal, vá em "OAuth2" > "URL Generator"
2. Selecione os scopes:
   - `bot`
3. Selecione as permissões:
   - Read Messages/View Channels
4. Copie a URL gerada e acesse no navegador
5. Selecione seu servidor Discord e autorize o bot

### 3. Pegar IDs Necessários

#### Guild ID (ID do Servidor):
1. Ative o Modo Desenvolvedor no Discord: `Configurações` > `Avançado` > `Modo de desenvolvedor`
2. Clique com botão direito no seu servidor
3. Clique em "Copiar ID"

#### Role ID (ID do Cargo):
1. Vá nas configurações do servidor > Funções
2. Clique com botão direito na role desejada
3. Clique em "Copiar ID"

### 4. Configurar config.lua

Edite o arquivo `config.lua`:

```lua
-- Token do Bot (obtido na etapa 1)
Config.BotToken = "SEU_TOKEN_AQUI"

-- ID do Servidor Discord (obtido na etapa 3)
Config.GuildId = "SEU_GUILD_ID_AQUI"

-- ID da Role Necessária (obtido na etapa 3)
Config.RequiredRoleId = "SEU_ROLE_ID_AQUI"

-- Nome da Role (apenas para exibir)
Config.RoleName = "Membro"

-- Nome do Servidor (apenas para exibir)
Config.ServerName = "Seu Servidor"
```

### 5. Configurar server.cfg

Adicione a varíavel global do link do seu servidor ao seu `server.cfg`:

```cfg
# Discord Auth
ensure discord-auth
set DISCORD_LINK "https://discord.gg/seu-convite"
```

## Configurações Adicionais

### Mensagens Personalizadas

Você pode personalizar as mensagens no `config.lua`:

```lua
Config.Messages = {
    NoDiscord = "Mensagem quando não tem Discord conectado",
    NotInServer = "Mensagem quando não está no servidor",
    NoRole = "Mensagem quando não tem a role",
    Checking = "Mensagem durante verificação",
    ApiError = "Mensagem de erro de API",
    Success = "Mensagem de sucesso",
}
```

### Debug

Para ativar logs detalhados no console do servidor:

```lua
Config.Debug = true
```

### Timeout

Ajustar tempo limite das requisições (em milissegundos):

```lua
Config.Timeout = 5000
```

## Como os Jogadores Conectam o Discord

Os jogadores precisam ter o Discord conectado ao FiveM:

1. Conectar seguindo: [Guia Oficial CFX](https://support.cfx.re/hc/en-us/articles/18919080288412-How-to-link-your-Cfx-Account-to-the-FiveM-client)
