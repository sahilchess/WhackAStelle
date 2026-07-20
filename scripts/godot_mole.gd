extends Area2D

signal update_score

@onready var timer: Timer = $Timer
@export var bonk_height := 32
# how high mole moves
@export var ease_value := 0.5
# ^^ higher number > faster movement of mole
var rand_int : int
var hitable : bool = false
var mouse_in : bool = false
var init_pos : Vector2

func _ready():
	timer.start()
	init_pos = global_position
	update_score.connect(get_parent().score_update)
	randomize()

func _on_timer_timeout() -> void:
	rand_int = randi() % 10 + 1
	if rand_int > 5 and hitable == false:
		hitable = true
		move_up()
	elif rand_int <= 5 and hitable == true:
		hitable = false
		move_down()

func move_up():
	$CollisionShape2D.disabled = false
	var tween = create_tween()
	tween.tween_property(self, "position", position - Vector2(0, bonk_height), 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	timer.start()

func move_down():
	$CollisionShape2D.disabled = true
	var tween = create_tween()
	tween.tween_property(self, "position", init_pos, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	timer.start()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and mouse_in == true and hitable == true:
			move_down()
			update_score.emit()

func _on_mouse_entered() -> void:
	mouse_in = true

func _on_mouse_exited() -> void:
	mouse_in = false
