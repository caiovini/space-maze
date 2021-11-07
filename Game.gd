extends Container

var speed = 0
var score = 0
var velocity = 5
var stars = []
var walls = []
var rng = RandomNumberGenerator.new()
const screen_size = OS.window_size

onready var joystick = get_node("JoystickController/JoystickButton")
onready var boost_button = get_node("BoostButton")
onready var rocket = get_node("Rocket")
onready var area_2d = get_node("Area2D")
onready var label_score = get_node("LabelScore")
onready var label_game_over = get_node("LabelGameOver")
onready var button_restart = get_node("ButtonRestart")

func _ready():
# warning-ignore:unused_variable
	for s in range(200):
		stars.append({ "x" : rng.randf_range(0, screen_size.x) *1.5,
					   "y" : rng.randf_range(0, screen_size.y) *1.5,
					   "radius" : rng.randf_range(0.5, 1.5)})
					
	var wall = {"left": { "from": Vector2(800, screen_size.y-610), \
					 		"to": Vector2(800, screen_size.y+10)},
				"right": {"from": Vector2(1400, screen_size.y-610), \
					 		"to": Vector2(1400, screen_size.y+10)}}
	append_new_wall(wall)
	
	
func _draw():
	
	for star in stars:
		
		draw_circle(Vector2(star.x, star.y), star.radius, Color.white)
		star.y += cos(rocket.rocket_texture.rotation) * speed
		star.x -= sin(rocket.rocket_texture.rotation) * speed
		
		if star.y > screen_size.y:
			star.y -= screen_size.y * 1.5
		if star.y < 0:
			star.y += screen_size.y * 1.5
		if star.x > screen_size.x:
			star.x -= screen_size.x * 1.5
		if star.x < 0:
			star.x += screen_size.x * 1.5
			
	for wall in walls:
		for e in wall:
			if typeof(wall[e]) != TYPE_BOOL:
				draw_line(wall[e].from, wall[e].to, Color.white, 6.0)
				draw_circle(Vector2(wall[e].from.x, wall[e].from.y), 10, Color.royalblue)
				
				wall[e].from.y += cos(rocket.rocket_texture.rotation) * speed
				wall[e].from.x -= sin(rocket.rocket_texture.rotation) * speed
				wall[e].to.y += cos(rocket.rocket_texture.rotation) * speed
				wall[e].to.x -= sin(rocket.rocket_texture.rotation) * speed
				wall[e].collision_shape.position = Vector2((wall[e].from.x+wall[e].to.x)/2, wall[e].from.y+310)
			
		if wall.right.from.y > rocket.position.y and !wall.scored:
			wall.scored = true
			score += 1
			velocity += 0.1
			label_score.text = "SCORE: %s" % score
				
 
	var w = walls[-1]
	if w.right.from.y > 0:
		
		var random_maze = rng.randi_range(-800, 800)
		var wall = {"left": { "from": Vector2(w.left.from.x+random_maze, w.left.from.y-610), \
						 		"to": Vector2(w.left.from.x, w.left.from.y)},
					"right": {"from": Vector2(w.right.from.x+random_maze, w.right.from.y-610), \
						 		"to": Vector2(w.right.from.x, w.right.from.y)}}
								
		append_new_wall(wall)
	
						
func append_new_wall(wall):
		
	var walls_to_append = {}
	for side in wall:
		
		var coll_shape = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		
		coll_shape.position = Vector2((wall[side].from.x+wall[side].to.x)/2,
								 wall[side].from.y+310)
		shape.extents = Vector2(5, sqrt(pow(wall[side].from.x-wall[side].to.x, 2)+
							pow(wall[side].from.y-wall[side].to.y, 2))/2)
							
		coll_shape.set_shape(shape)
		coll_shape.rotation_degrees = -rad2deg(atan2(wall[side].from.x-
					wall[side].to.x, wall[side].from.y-wall[side].to.y))
		area_2d.add_child(coll_shape)
		
		walls_to_append[side] = {"from": Vector2(wall[side].from.x, wall[side].from.y), \
						 		   "to": Vector2(wall[side].to.x, wall[side].to.y), \
								   "collision_shape": coll_shape}
					
	walls_to_append["scored"] = false			
	walls.append(walls_to_append)
	
# warning-ignore:unused_argument
func _process(delta):
	
	if !area_2d.get_overlapping_bodies():
		update()
		
		if joystick.is_pressed():
			rocket.set_rocket_position(joystick.get_value())
			
	else:
		button_restart.visible = true
		label_game_over.visible = true

func _on_ButtonRestart_pressed():
	return get_tree().reload_current_scene()


func _on_BoostButton_pressed():
	speed = velocity * 2
	joystick.boost_pressed = true
	rocket.rocket_particles.set_param(1, 70) # Param 1 -> velocity


func _on_BoostButton_released():
	speed = velocity
	joystick.boost_pressed = false
	rocket.rocket_particles.set_param(1, 36.3)
