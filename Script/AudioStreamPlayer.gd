extends AudioStreamPlayer

var sounds = {
	"water" : preload("res://Art/water.mp3"),
	"reel" : preload("res://Art/reel.wav")
}

func load_sound(s:String):
	stream = sounds[s]
