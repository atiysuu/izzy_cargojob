function mysqlQuery(query, params)
	if Config.MySQL == "oxmysql" then
		return exports["oxmysql"]:query_async(query, params)
	elseif Config.MySQL == "mysql-async" then
		local p = promise.new()

		exports['mysql-async']:mysql_execute(query, params, function(result)
			p:resolve(result)
		end)

		return Citizen.Await(p)
	elseif Config.MySQL == "ghmattimysql" then
		return exports['ghmattimysql']:executeSync(query, params)
	end
end

function getPlayerData(player)
	local user_license = getPlayerIdentifiers(player)["license"]

	local user = mysqlQuery("SELECT * FROM hy_cargojob WHERE user_license = ?", {
		user_license
	})[1]

	if not user then
		local result = mysqlQuery(
			"INSERT INTO hy_cargojob (user_license) VALUES (?)",
			{
				user_license,
			})

		return mysqlQuery("SELECT * FROM hy_cargojob WHERE id = ?", {
			result.insertId
		})[1]
	end

	return user
end

function getPlayerIdentifiers(player)
	local identifiers = {}
	local numId = GetNumPlayerIdentifiers(player) - 1

	for i = 0, numId, 1 do
		local identifier = {}

		for id in string.gmatch(GetPlayerIdentifier(player, i), "([^:]+)") do
			table.insert(identifier, id)
		end

		identifiers[identifier[1]] = identifier[2]
	end

	return identifiers
end

function registerServerCallback(...)
	if Config.Framework == "qb" then
		Framework.Functions.CreateCallback(...)
	else
		Framework.RegisterServerCallback(...)
	end
end

function getPlayerAvatar(player)
	local discord = getPlayerIdentifiers(player)["discord"]
	local avatar

	if discord then
		local p = promise.new()

		PerformHttpRequest("https://discordapp.com/api/users/" .. discord, function(statusCode, data)
			if statusCode == 200 then
				data = json.decode(data or "{}")

				if data.avatar then
					local animated = data.avatar:gsub(1, 2) == "a_"

					avatar = "https://cdn.discordapp.com/avatars/" ..
						discord .. "/" .. data.avatar .. (animated and ".gif" or ".png")
				end
			end

			p:resolve()
		end, "GET", "", {
			Authorization = "Bot " .. Config.BotToken
		})

		Citizen.Await(p)
	end

	return avatar
end