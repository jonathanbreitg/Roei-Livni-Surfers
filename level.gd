extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var copy
var offset = 30
var dist = 8
var i
onready var floor_obj = $floor
onready var player = $player/KinematicBody
var spike_scene = preload("res://spike.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	i = 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	floor_obj.global_transform.origin.z = player.global_transform.origin.z


func _on_Timer_timeout():
	copy = spike_scene.instance()
	self.add_child(copy)
	copy.global_transform.origin.z = -70 + -i * offset
	copy.global_transform.origin.x = -8 + (randi() % 3) * 8
	copy.global_transform.origin.y = 3.5
	i += 1
	
	
