extends Node

signal coin_set(amount : int)
signal coin_animation(amount : int)


var save = {"player": {"coins": 0}}


var Player # Set by the player when added to tree


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


