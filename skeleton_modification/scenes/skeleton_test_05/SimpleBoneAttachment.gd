@tool
extends Node3D

var skeleton:Skeleton3D;
@export var bone_name : StringName;
var bone_idx = -1;

# Called when the node enters the scene tree for the first time.
func _ready():
	skeleton = get_parent() as Skeleton3D;
	if (skeleton != null):
		bone_idx = skeleton.find_bone(bone_name);

func _process(delta):
	if (bone_idx > -1):
		global_transform = skeleton.global_pose_to_world_transform(
			skeleton.get_bone_global_pose(bone_idx)
		);
