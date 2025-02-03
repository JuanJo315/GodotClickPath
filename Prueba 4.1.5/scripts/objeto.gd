extends Area2D

@export var description: String = "Es un objeto interactuable."

func interact():
	# Mostrar diálogo o mensaje sobre el objeto
	show_dialogue(description)

func show_dialogue(text):
	# Cambia "/root/DialogManager" por la ruta al sistema de diálogo en tu juego
	get_node("/root/DialogManager").show_text(text)
