tool
extends Node3D

export (String) var bone_name = null
export (int, "World to Bone", "Bone to World", "LookAt", "LocalPoseOverride") var mode = 0;
export (bool) var enabled = false;

var _skeleton : Skeleton3D = null;
var _bone_id = 0;

func _ready():
	_skeleton = get_parent();
	_bone_id = _skeleton.find_bone(bone_name);

func _process(delta):
	if enabled == false:
		if (_bone_id != -1):
			_skeleton.clear_bones_global_pose_override()
		return;
	
	if mode == 0:
		var bone_trans = _skeleton.world_transform_to_bone_transform(global_transform)
		_skeleton.set_bone_global_pose_override(_bone_id, bone_trans, 1, true);
	elif mode == 1:
		var bone_trans = _skeleton.get_bone_global_pose(_bone_id)
		global_transform = _skeleton.bone_transform_to_world_transform(bone_trans);
	elif mode == 2:
		var bone_trans = _skeleton.get_bone_modification(_bone_id);
		
		bone_trans = bone_trans.looking_at(
			_skeleton.world_transform_to_bone_transform(global_transform).origin,
			_skeleton.global_transform.basis.y.normalized()
		);
		bone_trans.basis.rotate(bone_trans.basis.x.normalized(), -PI / 2.0);
		_skeleton.set_bone_modification(_bone_id, bone_trans);
	elif mode == 3:
		var bone_trans = _skeleton.world_transform_to_bone_transform(global_transform);
		bone_trans = _skeleton.bone_transform_to_local_bone_transform(_bone_id, bone_trans);
		_skeleton.set_bone_local_pose_override(_bone_id, bone_trans, 1, true);
