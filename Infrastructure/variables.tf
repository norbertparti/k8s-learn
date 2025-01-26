variable "backend_image" {
  description = "Backend application Docker image"
  type        = string
  default     = "backend-api:latest"  # Update this with your actual image
}

variable "backend_port" {
  description = "Backend application port"
  type        = number
  default     = 8000  # Update this with your actual port
}

variable "replica_count" {
  description = "Number of backend pod replicas"
  type        = number
  default     = 2
}
