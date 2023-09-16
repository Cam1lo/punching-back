extends Control

const max_health = 1000
var health = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$fg.size.x = get_fg_with_given_health()

func get_fg_with_given_health():
	return (float(health)/max_health)*$bg.size.x
