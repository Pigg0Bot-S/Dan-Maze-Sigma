extends Area3D




func _on_body_entered(body):
	PlayerData.add_coins(1)
	queue_free()
