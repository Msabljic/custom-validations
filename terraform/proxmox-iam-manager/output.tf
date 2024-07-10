output "user_name" {
  value = [for user_name in proxmox_virtual_environment_user.user_identities : user_name.user_id]
}

output "group_name" {
  value = [for group_name in proxmox_virtual_environment_group.group_identities : group_name.group_id]
}

output "role_name" {
  value = [for role_name in proxmox_virtual_environment_role.role_creator : role_name.role_id]
}