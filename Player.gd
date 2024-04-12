extends CharacterBody3D

var SPEED = 5.0
const JUMP_VELOCITY = 4.5
var sensitivity = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var viewbob := $Neck/Camera3D/Flashlight/ViewBob
@onready var flashbob := $Neck/Camera3D/Flashlight/FlashlightBob
@onready var ui = get_node("Neck/UI")


func _unhandled_input(event: InputEvent) -> void:
	
	# This block of code allows you to click into the game and exit out easier. 
	# "ui_cancel" = esc key. EventMouseButton just means that you clicked into the game
	# It's more self explanatory once you actually get into the game
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	# If you are clicked in, it lets things work
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.005 * sensitivity)
			camera.rotate_x(-event.relative.y * 0.005 * sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
			

func _physics_process(delta):
	# Add the gravity.
	
	if Input.is_action_pressed("sprint") && ui.stamina.value > 0:
		SPEED = 8.0
		ui.stamina.value -= .3
		ui.can_regen = false
	else:
		SPEED = 5.0
	
	if not is_on_floor():
		velocity.y -= gravity * delta

		# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if direction != Vector3():
		viewbob.play("ViewBobbing")
		flashbob.play("FlashlightBobbing")
		viewbob.speed_scale = SPEED / 7
		flashbob.speed_scale = SPEED / 7
	else:
		viewbob.stop()
		flashbob.stop()
		

	move_and_slide()
