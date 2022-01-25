Config = {}

Config.Locale = 'en'

Config.Price = {
	['omushroom'] = 350,
	['essence'] = 350

} -- ราคาที่ขายต่อ 1 แพ็ค 

Config.Locations = {
	{ x = -333.34, -2792.78, 5.0 } -- NPC
}

Config.CircleZones = {
	woodField = {coords = vector3(-2626.17, 2509.05, 3.16), name = _U('blip_mushroomfield'), color = 71, sprite = 564, radius = 2.0},
	woodCut = {coords = vector3(-1886.02, 629.92, 130.0), name = _U('blip_mushroomPack'), color = 71, sprite = 564, radius = 1.0},	
	woodSell = {coords = vector3(318.33, 2623.98, 44.47), name = _U('blip_mushroomSell'), color = 71, sprite = 564, radius = 1.0},	
	OilField = {coords = vector3(536.94, 2925.7, 39.88), name = '~y~[Buôn dầu]~s~ Mỏ dầu', color = 5, sprite = 436},
	OilProgress1 = {coords = vector3(2762.97, 1487.93, 24.5), name = '~y~[Buôn dầu]~s~ Lọc dầu thô', color = 5, sprite = 436},
	OilProgress2 = {coords = vector3(265.75, -3013.39, 5.53), name = '~y~[Buôn dầu]~s~ Chiết xuất xăng', color = 5, sprite = 436},
	SellOil = {coords = vector3(477.76, -2165.56, 6.32), name = '~y~[Buôn dầu]~s~ Bán xăngwwww', color = 5, sprite = 436},

}
