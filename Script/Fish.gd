extends Area2D

onready var sprite = $Sprite
onready var tween = $Tween

var flotteur:Node2D

var catch := false

# Called when the node enters the scene tree for the first time.
func _ready():
	tween.interpolate_property(sprite, "modulate:a", null, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _process(delta):
	if !catch:
		look_at(flotteur.position)
	
		position += Vector2(20 * delta, 0).rotated(rotation)
#	pass

func reparent():
	monitoring = false
	var loc_pos = flotteur.to_local(position)
	get_parent().remove_child(self)
	flotteur.add_child(self)
	position = loc_pos

func _on_Fish_area_entered(area):
	if area.name == "Flotteur":
		catch = true
		flotteur.aspiration(0.5)
		call_deferred("reparent")
