extends SpotLight3D

var flashlight = true
# Called when the node enters the scene tree for the first time.

func _unhandled_key_input(event):
	
	if event.is_action_pressed("flashlight_toggle"):
		flashlight = !flashlight


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if flashlight:
		visible = true
	elif !flashlight:
		visible = false
	
	pass
