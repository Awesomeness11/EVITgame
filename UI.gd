extends Control

@onready var stamina = $StaminaBar


var can_regen = false
var time_to_wait = 2
var s_timer = 0
var can_start_stimer = true



# Called when the node enters the scene tree for the first time.
func _ready():
	stamina.value = stamina.max_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_regen == false && stamina.value != 50:
		can_start_stimer = true
		if can_start_stimer:
			s_timer += delta
			if s_timer >= time_to_wait:
				can_regen = true
				can_start_stimer = false
				s_timer = 0
				
	if stamina.value == 50:
		can_regen = false
		
	if can_regen == true:
		stamina.value += 0.1
		can_start_stimer = false
		s_timer = 0
