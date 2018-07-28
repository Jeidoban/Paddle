extends Area2D

export (int) var speed
signal hit
onready var rect_size = get_viewport_rect().size

func _ready():
	hide()

func _process(delta):
	if Input.is_mouse_button_pressed(1):
		position.x = get_viewport().get_mouse_position().x
		
	position.x = clamp(position.x, 50, rect_size.x - 30)
	
# When the ball hits the paddle.
func _on_Paddle_body_entered(body):
	if body.get_name() == "Ball": # Making sure the hit was the ball and not one of the walls...
		emit_signal("hit") # Calls _on_Paddle_hit in Main
		
		# Take the linear velocity vector of the ball, reflectsx it (goes in opposite direction),
		# rotate it randomly, and multiply the Y coordinate by small number.
		# This increases the Y velocity slightly every hit.
		body.linear_velocity = body.linear_velocity.reflect(Vector2(-1, 0)).rotated(rand_range(-0.35, 0.35)) * 1.05
		var x = body.linear_velocity.x
		var y = body.linear_velocity.y
		if (abs(x) / abs(y)) > 1.1:
			body.linear_velocity.x = y 
			body.linear_velocity.y = abs(x) * -1


	
