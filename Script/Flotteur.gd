extends Area2D
class_name Flotteur

signal finishLancer

onready var tween = $Tween
onready var timer = $Timer
onready var sprite = $Sprite
onready var audio = $AudioStreamPlayer2D

enum State {Lancer = 0, WaitingFish, Aspiration, WaitingCatch, Catch, Loose}

var state = State.Lancer

func lancer(force:float):
	tween.interpolate_property(self, "position:y", null, position.y - force, 3, Tween.TRANS_QUART, Tween.EASE_OUT)
	timer.start(2)
	tween.start()

func _on_Tween_tween_all_completed():
	match(state):
		State.Lancer:
			state = State.WaitingFish
			monitorable = true
			timer.start(1) #rand_range(3, 5))
		State.Aspiration:
			state = State.WaitingCatch
			timer.start(1)
		State.Loose:
			state = State.WaitingFish
			timer.start(1)

func aspiration(force:float):
	tween.interpolate_property(sprite, "self_modulate", Color.white, Color(0.3, 0.3, 0.3, 1), force, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(sprite, "scale", Vector2(0.5, 0.5), Vector2(0.25, 0.25), force, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func remonte():
	tween.interpolate_property(sprite, "self_modulate", null, Color.white, 1.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.interpolate_property(sprite, "scale", null, Vector2(0.5, 0.5), 1.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()

func _on_Timer_timeout():
	match(state):
		State.Lancer:
			audio.play()
		State.WaitingFish:
			aspiration(0.5)
			state = State.Aspiration
		State.WaitingCatch:
			remonte()
			state = State.Loose

func isInWater() -> bool:
	return state != State.Lancer

func canCatch() -> bool:
	return state == State.WaitingCatch
	
func doCatch():
	tween.stop_all()
	state = State.Catch

func reset():
	if state == State.Aspiration:
		tween.stop_all()
		remonte()
		state = State.Loose

func kill_me():
	queue_free()
