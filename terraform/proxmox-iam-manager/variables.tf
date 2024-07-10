variable "pamlist" {
  type = list(object({
    group_comment = optional(string, "")
    group_name    = string
    acls = list(object({
      group_path        = optional(string, "/")
      group_propagate   = optional(bool, true)
      associate_role_id = list(string)
    }))
  }))
}

variable "userlist" {
  type = list(object({
    user_comment           = optional(string, "")
    password               = optional(string, "")
    user_id                = string
    user_enabled           = optional(bool, true)
    user_group_association = optional(list(string), [""])
    first_name             = optional(string, "")
    last_name              = optional(string, "")
    email                  = optional(string, "")
    keys                   = optional(string, "")
    expiration_date        = optional(string)
  }))
    validation {
      condition = alltrue([ for ul in var.userlist : can(regex("@company.com$", ul.email)) ])
      error_message = "Must be a company email."
  }
}

variable "rolelist" {
  type = list(object({
    role_name       = string
    role_privileges = list(string)
  }))
}