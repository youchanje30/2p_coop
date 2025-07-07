extends Area3D

@export var move_speed : float = 10
var move_dir : Vector3i = Vector3i.FORWARD


func _process(delta: float) -> void: # 이동 방향으로의 지속 이동
	global_position += move_dir * move_speed * delta

func _on_body_entered(body: Node3D) -> void: # 충돌 발생으로 인한 이동 방향 반전
	move_dir *= -1
