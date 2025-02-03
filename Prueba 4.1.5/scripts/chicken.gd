extends CharacterBody2D

# Velocidad de movimiento del personaje
var speed: float = 60.0

# Referencias:
var Tile_map: TileMap                   # Referencia al TileMap ("Terreno")
var Astar: AStarGrid2D                  # Referencia al AStarGrid del TileMap
var current_id_path: Array[Vector2i] = []  # Lista de celdas (IDs) de la ruta calculada

func _ready() -> void:
	# Ajusta la ruta al nodo "Terreno" según la estructura de tu escena.
	Tile_map = get_parent().get_node("Terreno")
	Astar = Tile_map.AstarGrid

# Captura el click y calcula la ruta
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("RightClick"):
		calcular_ruta()

func calcular_ruta() -> void:
	# Convierte la posición actual del personaje a coordenadas de celda
	var start_point = Tile_map.local_to_map(global_position)
	# Convierte la posición del mouse a coordenadas de celda
	var end_point = Tile_map.local_to_map(get_global_mouse_position())
	# Solicita la ruta más corta (devuelve un Array de Vector2i)
	current_id_path = Astar.get_id_path(start_point, end_point)
	# Si el primer nodo es la posición actual, lo eliminamos para evitar quedarse parado
	if current_id_path.size() > 0:
		current_id_path = current_id_path.slice(1)
	# print("Ruta calculada: ", current_id_path)

# Mueve el personaje a lo largo de la ruta
func _physics_process(delta: float) -> void:
	if current_id_path.is_empty():
		return
	
	# Toma el primer nodo (celda) de la ruta
	var target_cell = current_id_path[0]
	# Convierte la celda a una posición en el TileMap (usando map_to_local)
	var target_position = Tile_map.map_to_local(target_cell)
	
	# Si el personaje está cerca del centro de la celda, elimina ese nodo y pasa al siguiente
	if global_position.distance_to(target_position) < 2.0:
		current_id_path.pop_front()
		if current_id_path.is_empty():
			return
		target_position = Tile_map.map_to_local(current_id_path[0])
	
	# Calcula la dirección hacia el target y mueve el personaje
	var direction = (target_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
