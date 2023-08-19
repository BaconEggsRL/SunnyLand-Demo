extends Area2D

var collected = false

func _on_body_entered(body):
	if body.name == "player" and collected == false:
		collected = true
		Game.playerGold += 9
		var tween = get_tree().create_tween()
		var tween1 = get_tree().create_tween()
		tween.tween_property(self, "position", position - Vector2(0,25), 0.3)
		tween1.tween_property(self, "modulate:a", 0, 0.3)
		tween1.tween_callback(queue_free)
