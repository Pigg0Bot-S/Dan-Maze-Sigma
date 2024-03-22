extends Area3D

@export var give_amount : int = 1


func _on_body_entered(body):
	PlayerData.add_coins(give_amount)
	queue_free()
