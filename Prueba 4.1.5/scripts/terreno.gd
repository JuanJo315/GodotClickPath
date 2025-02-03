extends TileMap

var AstarGrid: AStarGrid2D

func _ready() -> void:
	assigning_astar()

func assigning_astar():
	# Obtiene el rectángulo que abarca todas las celdas usadas
	var used_rect = get_used_rect()
	
	# Crea la grilla y configura la región y el tamaño de celda
	AstarGrid = AStarGrid2D.new()
	AstarGrid.region = used_rect
	AstarGrid.cell_size = tile_set.tile_size
	AstarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

	# Inicializa la grilla (esto prepara la grilla para modificaciones)
	AstarGrid.update()
	
	# Recorre cada celda usada para marcar las celdas no transitables
	# IMPORTANTE: asegúrate de usar el índice de capa correcto; en este ejemplo se usa 0.
	for x in range(used_rect.size.x):
		for y in range(used_rect.size.y):
			var tile_position = Vector2i(x + used_rect.position.x, y + used_rect.position.y)
			var tile_data = get_cell_tile_data(0, tile_position)
			if tile_data == null:
				continue
			elif tile_data.get_custom_data("Walkable") == false:
				AstarGrid.set_point_solid(tile_position)
	
	# Vuelve a actualizar la grilla para que tome en cuenta los cambios
	AstarGrid.update()
