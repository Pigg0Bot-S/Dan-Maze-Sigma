extends Resource
class_name PlayerData
## Used to get and set data from Main.save.player



## Coin Manipulation functions
static func set_coins(new_amount: int):
	Main.save.player.coins = new_amount
	return get_coins()

static func get_coins():
	return Main.save.player.coins

static func add_coins(add_amount: int):
	Main.save.player.coins += add_amount
	
	coin_anim(add_amount)
	
	return get_coins()

static func coin_anim(coin_amount):
	pass
