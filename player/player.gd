extends CharacterBody2D

signal mute

const SPEED := 200.0
const JUMP_VELOCITY := -325.0


# coyote timer and jump buffer
var is_jumping = false
@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer = $JumpBuffer

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

# actions to perform when jumping (both player controlled or frog hopping)
func jump(vel : float = self.JUMP_VELOCITY):
	# prevent double jumps
	jump_buffer.stop()
	coyote_timer.stop()
	# jump
	velocity.y = vel
	anim.play("Jump")
	is_jumping = true


func _physics_process(delta):

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if velocity.y >= 0:
		is_jumping = false
		
	# Perform actions only when not hurt
	if not hurt:
		
		# Handle Jump.
		if Input.is_action_just_pressed("ui_up"):
			if is_on_floor() or !coyote_timer.is_stopped():
				self.jump()
			else:
				jump_buffer.start()
			
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		direction = Input.get_axis("ui_left", "ui_right")
		
		# flip direction of animation
		if direction < 0:
			get_node("AnimatedSprite2D").flip_h = true
		elif direction > 0:
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
	
	# coyote
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor and !is_on_floor() and !is_jumping:
		coyote_timer.start()
	if is_on_floor() and !jump_buffer.is_stopped() and !is_jumping:
		self.jump()

	# death / restart
	if Game.playerHP <= 0 or Input.is_action_just_pressed("restart") or position.y > 2048:
		queue_free()
		Utils.resetGame()
		get_tree().change_scene_to_file("res://main.tscn")
		
	# mute / unmute sounds
	if Input.is_action_just_pressed("mute"):
		mute.emit()
