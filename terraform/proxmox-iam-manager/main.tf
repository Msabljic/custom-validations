resource "proxmox_virtual_environment_group" "group_identities" {
  for_each = { for group in var.pamlist : group.group_name => group }
  comment  = each.value.group_comment
  group_id = each.value.group_name

  dynamic "acl" {
    for_each = { for acl in local.roles : acl.role => acl if acl.group == each.value.group_name }
    content {
      path      = acl.value.path
      propagate = acl.value.propagate
      role_id   = acl.value.role
    }
  }
  depends_on = [proxmox_virtual_environment_role.role_creator]
}

resource "proxmox_virtual_environment_user" "user_identities" {
  for_each        = { for user in var.userlist : user.user_id => user }
  comment         = each.value.user_comment
  password        = each.value.password != "" ? each.value.password : random_password.password.result
  user_id         = "${each.value.user_id}@pve"
  enabled         = each.value.user_enabled
  groups          = each.value.user_group_association
  email           = each.value.email
  expiration_date = each.value.expiration_date
  first_name      = each.value.first_name
  last_name       = each.value.last_name
  keys            = each.value.keys
  depends_on      = [proxmox_virtual_environment_group.group_identities]
}

resource "random_password" "password" {
  length           = 18
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?/"
}

resource "proxmox_virtual_environment_role" "role_creator" {
  for_each   = { for role in var.rolelist : role.role_name => role }
  role_id    = each.value.role_name
  privileges = each.value.role_privileges
}


locals {
  roles = flatten([for group in var.pamlist : [for acls in group.acls : [for role in acls.associate_role_id : {
    group     = group.group_name
    role      = role
    path      = acls.group_path
    propagate = acls.group_propagate
  }]]])
}