@tool
class_name GDScript_RotationAdjustment
extends SkeletonModification3D

@export var rotation_adjustment:Vector3;
@export var bone_idx:int;

func setup_modification(_stack):
	#print ("Setup called from GDScript!");
	pass;

func execute(_delta):
	var stack : SkeletonModificationStack3D = get_modification_stack();
	var skeleton : Skeleton3D = stack.get_skeleton();
	
	if bone_idx > 0 and bone_idx < skeleton.get_bone_count():
		var local_override_trans = skeleton.get_bone_local_pose_override(bone_idx);
		
		local_override_trans.basis *= Basis(Vector3(1, 0, 0), deg2rad(rotation_adjustment.x));
		local_override_trans.basis *= Basis(Vector3(0, 1, 0), deg2rad(rotation_adjustment.y));
		local_override_trans.basis *= Basis(Vector3(0, 0, 1), deg2rad(rotation_adjustment.z));
		
		skeleton.set_bone_local_pose_override(bone_idx, local_override_trans, stack.strength, self.enabled);
		skeleton.force_update_bone_child_transform(bone_idx);
	
	#print ("Executed custom modification!");
