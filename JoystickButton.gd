extends TouchScreenButton


var radius = Vector2(32, 32)
var return_accel = 20
var boundary = 96
var threshold = 10

var boost_pressed = false

func get_value():
	if get_button_pos().length() > threshold:
		return get_button_pos().normalized()
	return Vector2(0, 0)

func get_button_pos():
	return position + radius

func _process(delta):
	if !is_pressed():
		var pos_difference = (Vector2(0, 0) - radius) - position
		position += pos_difference * return_accel * delta
		
func _input(event):
	if is_pressed() and event is InputEventScreenDrag and !boost_pressed:
		
		set_global_position(event.position - radius * global_scale)
		
		if get_button_pos().length() > boundary:
			set_position( get_button_pos().normalized() * boundary - radius)
