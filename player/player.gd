extends KinematicBody2D

export var jumpHeight = 10
export var walkSpeed = 5

var velocity = Vector2(0,0)
var walkMovement = Vector2(0,0)
var gravity = 100
var grounded = false
var jumping = false
var groundCast
var animator

func _ready():
	# setting up other functions
	set_fixed_process(true)
	set_process_input(true)

func _input(event):
	if (event.is_action_pressed("up") and !event.is_echo() && grounded):
		jumping = true

func _fixed_process(delta):

	# Getting the stuff
	groundCast = get_node("./groundCast")
	animator = get_node("./animator")

	# Getting controls
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")

	# Am I grounded?
	grounded = groundCast.is_colliding()

	# Applying gravity
	if (!grounded):
		velocity.y += gravity * delta

	# Walking logic
	if (left && right):
		walkMovement = Vector2(0,0)
	elif(left):
		walkMovement = Vector2(-1, 0)
	elif(right):
		walkMovement = Vector2(1, 0)
	else:
		walkMovement = Vector2(0,0)

	# When not moving, stop, idiot
	if (walkMovement.x == 0 && grounded):
		velocity.x = 0
		#velocity.x = velocity.x * 0.5 * delta

	# Set the player's velocity to walkSpeed in the direction of walkMovement
	velocity.x = walkMovement.x * walkSpeed

	# If you're jumping, fucking jump
	if (jumping):
		velocity.y = -jumpHeight
		jumping = false

	var motion = velocity * delta

	# If the player is colliding with an object, make them slide
	if (is_colliding()):
		motion = get_collision_normal().slide(motion)
		if (!jumping):
			velocity = get_collision_normal().slide(velocity)

	move(motion)

	################
	## ANIMATIONS ##
	################

	# Directional logic
	if (left && right):
		pass
	elif(left):
		find_node("Sprite").set_scale(Vector2(-1,1))
	elif(right):
		find_node("Sprite").set_scale(Vector2(1,1))

	# walking or idle or jumping?
	if (abs(walkMovement.x) > 0 && grounded):
		if(animator.get_current_animation() != "run"):
			animator.play("run")
	elif (grounded):
		animator.play("idle")
	else:
		animator.play("jump")
