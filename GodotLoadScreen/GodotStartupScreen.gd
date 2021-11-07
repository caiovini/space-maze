extends ColorRect

onready var godotTXT = get_node("Control/Godot")
onready var lightFlikceringSound = get_node("LightFlickerSound")
onready var godotSprite = get_node("Control/GodotAnimatedSprite")
onready var tween = get_node("Tween")
onready var change_scene_timer = get_node("ChangeSceneTimer")
onready var start_game_button = get_node("Control/StartGameButton")

var color_alpha = 1
const game_scene = preload("res://Game.tscn")

func _ready():
	lightFlikceringSound.play()
	tween.interpolate_property(godotTXT, 'modulate', Color(1,1,1,0), Color(1,1,1,1),
	 1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()


func _on_AnimationPlayTimer_timeout():
	godotSprite.play()

func _on_GodotAnimatedSprite_animation_finished():
	change_scene_timer.start()

func _on_ChangeSceneTimer_timeout():
	start_game_button.visible = true

func _on_StartGameButton_pressed():
	return get_tree().change_scene("res://Game.tscn")
