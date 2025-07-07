extends Node

@export var ray_cast_max_distance: float = 500.0 # 레이캐스트 최대 거리
@export var camera: Node3D = null
var selected_crashable: Node = null

func _ready() -> void:
	# 카메라 노드가 지정되지 않은 경우, 부모에서 Camera3D를 자동으로 찾음
	if not camera:
		camera = get_parent().get_node("Camera3D")

func ray_cast() -> Dictionary:
	# 카메라가 없으면 raycast 불가
	if camera == null:
		print("Camera3D not found!")
		return {}

	# 마우스 위치에서 레이 시작점과 끝점 계산
	var mouse_pos = get_viewport().get_mouse_position()
	var space_state = camera.get_world_3d().direct_space_state
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_cast_max_distance

	# 레이캐스트 파라미터 생성 및 충돌 검사
	var params = PhysicsRayQueryParameters3D.new()
	params.from = from
	params.to = to
	var result = space_state.intersect_ray(params)

	# 충돌이 없으면 빈 딕셔너리 반환
	if not result:
		selected_crashable = null
		return {}

	# Crashable 타입이 아니면 무시
	var collider = result.get("collider")
	if not collider or not collider is Crashable:
		selected_crashable = null
		return {}

	# Crashable 오브젝트와 충돌 좌표 반환
	selected_crashable = collider
	return {"collider": collider, "position": result.get("position")}

func _show_ray(from: Vector3, to: Vector3):
	
	# 레이 시각화 필요 시 활성화
	var mesh = ImmediateMesh.new()
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	mesh.surface_add_vertex(from)
	mesh.surface_add_vertex(to)
	mesh.surface_end()

	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = "DebugRay"
	get_parent().add_child(mesh_instance)

	await get_tree().create_timer(0.2).timeout
	if mesh_instance and mesh_instance.is_inside_tree():
		mesh_instance.queue_free()
	
