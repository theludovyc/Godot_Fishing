extends Area2D
class_name Flotteur

var Fish = preload("res://Scene/Fish.tscn")

signal finishLancer

onready var tween = $Tween
onready var timer = $Timer
onready var sprite = $Sprite
onready var audio = $AudioStreamPlayer2D

enum State {Lancer = 0, Move, WaitingPop, WaitingFish, Aspiration, WaitingCatch, Catch, Loose}

var state = State.Lancer

var hasFish := false

var catch_fish

func lancer(force:float):
	tween.interpolate_property(self, "position:y", null, position.y - force, 2, Tween.TRANS_QUART, Tween.EASE_OUT)
	timer.start(1)
	tween.start()

func aspiration(force:float):
	tween.interpolate_property(sprite, "self_modulate", Color.white, Color(0.3, 0.3, 0.3, 1), force, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(sprite, "scale", Vector2(0.5, 0.5), Vector2(0.25, 0.25), force, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func remonte():
	tween.interpolate_property(sprite, "self_modulate", null, Color.white, 1.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.interpolate_property(sprite, "scale", null, Vector2(0.5, 0.5), 1.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()

func _on_Tween_tween_all_completed():
	match(state):
		State.Aspiration:
			state = State.WaitingCatch
#			timer.start(1)
		State.Loose:
			state = State.WaitingFish
			timer.start(1)

func _on_Timer_timeout():
	match(state):
		State.Lancer:
			tween.remove(self)
			audio.play()
			state = State.WaitingPop
			monitoring = true
			timer.start(2)
		State.WaitingPop:
			var fish = Fish.instance()
			fish.position = position - Vector2(100, 0)
			fish.flotteur = self
			get_parent().add_child(fish)
			state = State.WaitingCatch
#		State.WaitingCatch:
#			remonte()
#			state = State.Loose

func isInWater() -> bool:
	return state != State.Lancer

func doMove():
	match(state):
		State.Aspiration:
			remonte()
			catch_fish.queue_free()
	
	state = State.Move

func canCatch() -> bool:
	return state == State.Aspiration
	
func doCatch():
	tween.stop_all()
	state = State.Catch

func isCatch() -> bool:
	return state == State.Catch

func reset():
	if state == State.Aspiration:
		tween.stop_all()
		remonte()
		state = State.Loose

func reparent(area):
	var loc_pos = to_local(area.position)
	get_parent().remove_child(area)
	add_child(area)
	area.position = loc_pos

func _on_area_entered(area):
	if area.name == "Fish" and catch_fish == null:
		catch_fish = area
		area.catch = true
		state = State.Aspiration
		aspiration(0.5)
		call_deferred("reparent", area)
	pass # Replace with function body.

func kill_me():
	queue_free()
