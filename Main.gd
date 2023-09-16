extends Node2D

var jab_damage = 100
var cross_damage = 200
var upper_damage = 350

var attacking = 1
@onready var p1 = $Player1
@onready var p2 = $Player2
@onready var attacks_dict = p1.attacks_dict 
@onready var defense_dict = p1.defense_dict 
var damage_dict = {
	"jab": 100,
	"cross": 200,
	"upper": 350
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$timerLabel/Timer.start()
	set_attacking()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time = $timerLabel/Timer.time_left
	$timerLabel.text = "%.1f" % time
	
func get_turn_state():
	pass

func _on_timer_timeout():
	p1.stops = true
	p2.stops = true
	$timerLabel/Timer.stop()
	var attackingPlayer = p1 if attacking == 1 else p2
	var deffendingPlayer = p1 if attacking == 2 else p2
	var hits = is_attack_blocked(attackingPlayer.last_action, deffendingPlayer.last_action)
	
	set_animations(hits)
	var attack = get_attack_by_action(attackingPlayer.last_action)
	
	if hits: 
		deffendingPlayer.get_node('PlayerHealth').health -= damage_dict[attack]
	
	attacking = 1 if attacking == 2 else 2
	set_attacking()
	await get_tree().create_timer(1.2).timeout
	reset()

func set_attacking():
	p1.attacking = false
	p2.attacking = false
	
	if attacking == 1:
		p1.attacking = true
	else:
		p2.attacking = true

func is_attack_blocked(attack, defense): 
	if not attack:
		return false
	if not defense and attack: 
		return true

	var punch = attacks_dict[attack]
	var guard =  defense_dict[defense]
	
	match [punch, guard]:
		['jab', '2hands'], ['jab', 'crouch'], ['cross', 'dodge'], ['cross', 'crouch'], ['upper', 'dodge'], ['upper', '2hands']:
			return true
		_:
			return false

func set_animations(hits):
	if attacking == 1:
		$Player1/AnimationPlayer.play(attacks_dict[p1.last_action])
		if hits: 
			$Player2/AnimationPlayer.play('h' + attacks_dict[p1.last_action])
		else:
			$Player2/AnimationPlayer.play(defense_dict[p2.last_action])
			
	if attacking == 2:
		$Player2/AnimationPlayer.play(attacks_dict[p2.last_action])
		if hits: 
			$Player1/AnimationPlayer.play('h' + attacks_dict[p2.last_action])
		else:
			$Player1/AnimationPlayer.play(defense_dict[p1.last_action])

func get_attack_by_action(action_number):
	return attacks_dict[action_number]
	
func reset():
	p1.stops = false
	p2.stops = false
	$timerLabel/Timer.start()
	$Player1/AnimationPlayer.play('idle')
	$Player2/AnimationPlayer.play('idle')
	
