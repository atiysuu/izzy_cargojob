Config = {
    Framework = "qb", -- Your Framework (esx / qb)
    MySQL = "oxmysql", -- Your mysql (oxmysql / mysql-async / ghmattimysql)
    BotToken = "MTA5MTc3Nzc2NjQ1OTk2OTY4OA.G0-CEv.CUa1Z2Iu3O1qJX1MjCNJzburlUNeXhqQKGirdw", -- Your discord bot token for profile photo

    Levels = {
        {
            level = 0,
            label = "Box Ville",
            subtitle = "5 Package Capacity, Fast",
            car = 'boxville4',
            package = 1,
            experience = 20,
            money = 1000,
            bgsrc = "boxville.png",
        },

        {
            level = 1,
            label = "Box Ville 2",
            subtitle = "10 Package Capacity, Fast",
            car = 'boxville2',
            package = 10,
            experience = 5,
            money = 1000,
            bgsrc = "boxville.png",
        },

        {
            level = 2,
            label = "Utilli Truck",
            subtitle = "20 Package Capacity, Fast",
            car = 'utillitruck3',
            package = 20,
            experience = 10,
            money = 1000,
            bgsrc = "boxville.png",
        },

        {
            level = 3,
            label = "Box Ville",
            subtitle = "20 Package Capacity, Fast",
            car = 'utillitruck3',
            package = 20,
            experience = 10,
            money = 1000,
            bgsrc = "boxville.png",
        },
    },

    Routes = { -- Delivery Points
        vector3(1219.5577, -3201.2737, 5.5281),
        vector3(1180.8629, -3113.6348, 6.0280),
        vector3(861.3380, -3184.6233, 6.0350),
        vector3(1222.3136, -2995.9792, 5.8654),
    },

    VehicleSpawnCoords = { -- Places that vehicle will be spawned
        vector4(1178.0, -3298.1855, 5.5577, 89.6580),
        vector4(1178.0, -3288.6909, 5.5520, 90.4612),
        vector4(1178.37, -3281.17, 6.03, 92.13),
    },

    Ped = {
        coord = vector4(1184.0671, -3303.9219, 7.0952, 95.3521),
        hash = "s_m_m_ups_01",
        Blip = {
            sprite = 67,
            color = 0,
            blipName = "Cargo Job"
        }
    },

    Texts = {
        -- Before delivery starts 

        cargojob_menu = 'Open Cargo Job Menu',
        car_spawn_areas_notclear = 'ALL AREAS IS BUSY',
        take_package_from_start = "Press ~INPUT_CONTEXT~ to take package", -- Don't change ~INPUT_CONTEXT~
        put_package_to_car = "Press ~INPUT_CONTEXT~ to put package", -- Don't change ~INPUT_CONTEXT~
        take_package_deliver = "Get out of the car to take package",    
        put_package = "Get out of the car to put package",
        delivery_not_started = "You have to put the packages in to the car before you start delivering",

        -- In delivery 

        deliver_started = "Vehicle is fully loded, head to the delivery point.",
        take_package_from_car = "Get out and get the package from car.",
        take_package_from_car2 = "Press ~INPUT_CONTEXT~ to take the package", -- Don't change ~INPUT_CONTEXT~
        go_to_delivery_point = "Go to the deliver point.",
        deliver_package = "Deliver the package",
        new_delivery_point = "Go to the new deliver point.",

        -- After delivery is done

        delivery_done = "You are out of packages, get back and deliver the vehice",
        delivery_complete = 'Vehicle delivered, you got',
        delivery_complete2 = " experience and ",
        delivery_complete3 = " money.",

        -- Others

        deliver_car = 'Deliver the car',
        vehicle_not_working = "Oh! it looks like your engine is not working, your vehicle getting pulled soon.",
    },

    deliverBlipName = "Delivery",
    BankOrCash = "bank", -- Payment method (bank and cash for qb, bank and money for esx)
    carInteractPart = "platelight", -- The place where marker sets to change that : https://docs.fivem.net/natives/?_0xFB71170B7E76ACBA
    PackageStorageCoord = vector3(1177.5303, -3313.4436, 6.0288),
    timeBeforeCarDelete = 5000 -- 1000 = 1 second do max 10, over 10 can make some issue (when the engine is not working anymore car is dissappearing this is the time how long gonna take to dissappear)
}

