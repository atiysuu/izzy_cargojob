Framework = Config.Framework == "esx" and exports["es_extended"]:getSharedObject() 
                or exports['qb-core']:GetCoreObject()
                
registerServerCallback("hy_cargojob:getPlayerData", function(source, cb)
    local arr = {
        data = getPlayerData(source),
        avatar = getPlayerAvatar(source)
    }
    cb(arr)
end)

RegisterServerEvent("hy_cargojob:server:finishJob", function(packageDelivered, exp, money)
    local src = source
    local finalExp = exp * packageDelivered
    local finalMoney = money * packageDelivered 

    mysqlQuery("UPDATE hy_cargojob SET experience = experience + ? WHERE user_license = ?", {
        finalExp,
       getPlayerIdentifiers(src)["license"]
    })

    local xPlayer = Config.Framework == "esx" and Framework.GetPlayerFromId(src) or Framework.Functions.GetPlayer(src)

    if Config.Framework == "esx" then
        xPlayer.addAccountMoney(Config.BankOrCash, finalMoney)
    else
        xPlayer.Functions.AddMoney(Config.BankOrCash, finalMoney)
    end
end)