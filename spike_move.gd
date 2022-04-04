extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed = Vector3.ZERO
var const_speed = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	speed.z = const_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(speed,Vector3.UP)
