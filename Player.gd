extends Node2D

@export var boxer_spritesheet: CompressedTexture2D
@export var flip: bool
@export var color: Color

var last_action = null
var attacking = false
var stops = false

const attacks_dict = {
	1: "jab",
	2: "upper",
	3:	"cross"
}

const defense_dict = {
	1: '2hands',
	2: 'crouch',
	3: 'dodge'
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = boxer_spritesheet
	$AnimationPlayer.play("idle")
	$PlayerHealth/fg.color = color
	if flip:
		$Sprite2D.flip_h = true
		$PlayerHealth.position.x = 14
		$Label.position.x = -12

func _input(event):
	if stops: 
		return
	if flip:
		if event.is_action_pressed("2jab_twohands"):
			last_action = 1
		if event.is_action_pressed("2cross_dodge"):
			last_action = 3
		if event.is_action_pressed("2upper_crouch"):
			last_action = 2
	else: 
		if event.is_action_pressed("jab_twohands"):
			last_action = 1
		if event.is_action_pressed("cross_dodge"):
			last_action = 3
		if event.is_action_pressed("upper_crouch"):
			last_action = 2
	set_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_label():
	if not last_action:
		return 
	$Label.text = attacks_dict[last_action] if attacking else defense_dict[last_action]
