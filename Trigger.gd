extends Area2D
signal trigger

# When ball hits the trigger
func _on_Trigger_body_entered(body):
	emit_signal("trigger")
