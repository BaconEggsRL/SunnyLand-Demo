extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -325.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Input.get_axis("ui_left", "ui_right")
var knockback = Vector2(0,0)
var hurt = false

# Store the animation node so we can access it in functions later at runtime
var anim 
var frogs
var cherries
func _ready():
	anim = get_node("AnimationPlayer")
	Game.maxFrogs = get_tree().get_nodes_in_group("mob").size()
	Game.maxCherries = get_tree().get_nodes_in_group("collectable").size()
	Game.maxGold = Game.maxFrogs * Game.frogValue + Game.maxCherries * Game.cherryValue
	print(Game.maxGold)

func _physics_process(delta):

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Actions only when not hurt
	if not hurt:
		
		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			anim.play("Jump")
			
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		direction = Input.get_axis("ui_left", "ui_right")
		
		# flip direction of animation
		if direction == -1:
			get_node("AnimatedSprite2D").flip_h = true
		elif direction == 1:
			get_node("AnimatedSprite2D").flip_h = false
		
		if direction: # true if vector is non-zero (-1 or 1)
			velocity.x = (direction * SPEED)
			if velocity.y == 0:
					anim.play("Run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0:
				anim.play("Idle")
			
		if velocity.y > 0:
			anim.play("Fall")
	
	# add knockback and hurt animation
	else:
		# print(knockback.x)
		anim.play("Hurt")
		velocity.x = knockback.x
		knockback.x = move_toward(knockback.x, 0, delta*SPEED)
		if knockback.x == 0:
			hurt = false
	
	# velocity prior to collision
	move_and_slide()
	
	# death / restart
	if Game.playerHP <= 0 or Input.is_key_pressed(KEY_R):
		queue_free()
		Utils.resetGame()
		get_tree().change_scene_to_file("res://main.tscn")
