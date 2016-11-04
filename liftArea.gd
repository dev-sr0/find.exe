extends Area2D

export var liftForce = 10
var inside = false
var player

func _ready():
	set_fixed_process(true)

func _on_Area2D_body_enter( body ):
	if(body.get_name() == "player"):
		inside = true
		player = body

func _on_Area2D_body_exit( body ):
	if(body.get_name() == "player"):
		inside = false
		player = body

func _fixed_process(delta):
	if(inside):
		player.velocity.y += -liftForce * delta
		print (player.velocity.y)