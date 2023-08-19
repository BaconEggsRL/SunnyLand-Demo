extends Node2D


var cherry = preload("res://collectables/cherry.tscn")
var frog = preload("res://mobs/frog.tscn")

func _on_timer_timeout():
	pass
	# cherries
#	var cherryTemp = cherry.instantiate()
#	var rng = RandomNumberGenerator.new()
#	var randx = rng.randi_range(64, 2048)
#	var randy = rng.randi_range(300, 500)
#	cherryTemp.position = Vector2(randx, randy)
#	get_node("cherries").add_child(cherryTemp)
	# mobs
#	var frogTemp = frog.instantiate()
#	var rng2 = RandomNumberGenerator.new()
#	var randx2 = rng2.randi_range(64, 2048)
#	var randy2 = rng2.randi_range(300, 500)
#	frogTemp.position = Vector2(randx2, randy2)
#	get_node("../mobs/frogs").add_child(frogTemp)
