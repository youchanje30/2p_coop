extends Node

@export var selector: Node = null

func _input(event: InputEvent) -> void:
	if not selector: return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var result = selector.ray_cast()
		if not result or not result.has("collider") or not result.has("position"): return
		var crashable = result["collider"]
		var hit_position = result["position"]

		var excavation_sphere = CSGSphere3D.new()
		
		excavation_sphere.radius = 1.0
		excavation_sphere.operation = CSGShape3D.OPERATION_SUBTRACTION
		excavation_sphere.position = crashable.to_local(hit_position)
		crashable.add_child(excavation_sphere)
