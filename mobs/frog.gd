extends CharacterBody2D

const SPEED = 50.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var direction = Vector2(0,0)
var chase = false
var dying = false

func _ready():
	get_node("AnimatedSprite2D").play("Idle")

func _physics_process(delta):
	if get_node("AnimatedSprite2D").animation != "Death":
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
		# get player vector for chase.
		if chase:
			get_node("AnimatedSprite2D").play("Jump")
			player = get_node("../../../player/player")
			direction = (player.position - self.position).normalized()
			# print(direction)
			# flip direction of animation
			if direction.x > 0:
				get_node("AnimatedSprite2D").flip_h = true
			elif direction.x < 0:
				get_node("AnimatedSprite2D").flip_h = false
			velocity.x = direction.x * SPEED
		else:
			get_node("AnimatedSprite2D").play("Idle")
			velocity.x = 0.0
		move_and_slide()
		
func _on_player_detection_body_entered(body):
	if body.name == "player":
		chase = true
		
func _on_player_detection_body_exited(body):
	if body.name == "player":
		chase = false

func _on_player_death_body_entered(body):
	if body.name == "player" and dying == false:
		# give the player a slight jump boost
		body.jump(body.JUMP_VELOCITY - 75)
		# kill frog
		death()

func _on_player_death_body_exited(_body):
	pass
	
func _on_player_collision_body_entered(body):
	if body.name == "player" and dying == false:
		# add knockback here
		Game.playerHP -= 3
		body.hurt = true
		# knockback direction
		if direction.x > 0:
			body.knockback.x = 200
		elif direction.x < 0:
			body.knockback.x = -200
		# kill frog
		death()
		
		

func death():
	dying = true
	Game.playerGold += Game.frogValue
	# Utils.saveGame()
	chase = false
	get_node("CollisionShape2D").set_deferred("disabled", true)
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()
