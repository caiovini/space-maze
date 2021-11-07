extends KinematicBody2D


var rotation_speed = -1
var rocket_position = Vector2(0, 0)
var rotation_dir = 0
var velocity = Vector2()
var is_dragging = false

onready var rocket_texture = get_node("cohete_off")
onready var rocket_particles = get_node("RocketParticles")
onready var rocket_collision_shape = get_node("CollisionShape2D")

func _physics_process(delta):

	if is_dragging:
		is_dragging = false
		var angle = rad2deg(atan2(-rocket_position.x, -rocket_position.y))
		var rot = angle * rotation_speed * delta
		if rocket_texture.rotation != rot:
			rocket_texture.rotation = rot/2
			rocket_particles.rotation = rot/2
			rocket_collision_shape.rotation = rot/2
			rocket_particles.position = get_rotate_point(rocket_texture.position, \
			 								rocket_texture.rotation*-1)

func set_rocket_position(vect):
	is_dragging = true
	rocket_position = vect
	
func get_rotate_point(p, angle):
	return Vector2((p.x + rad2deg(sin(angle) * 2.5)), (p.y - rad2deg(cos(angle)) * -2.5))
	
