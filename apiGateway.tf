provider "aws" {
  region = "us-east-1"
}

resource "aws_api_gateway_rest_api" "user_management_api" {
  name        = "UserManagementAPI"
  description = "API for User Management"

  body = <<EOF
{
  "openapi": "3.0.1",
  "info": {
    "title": "Usermanagement",
    "version": "v0"
  },
  "servers": [
    {
      "url": "http://lassistusrmgt2sep-1056336277.us-east-1.elb.amazonaws.com/api/UserManagement",
      "description": "Generated server url"
    }
  ],
  "paths": {
    "/passwordreset": {
      "post": {
        "tags": ["user-management-controller"],
        "operationId": "resetPassword",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "\$ref": "#/components/schemas/PasswordResetRequest"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {}
            }
          }
        }
      }
    },
    "/passwordreset-request": {
      "post": {
        "tags": ["user-management-controller"],
        "operationId": "requestPasswordReset",
        "parameters": [
          {
            "name": "email",
            "in": "query",
            "required": true,
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {}
            }
          }
        }
      }
    },
    "/logout": {
      "post": {
        "tags": ["auth-controller"],
        "operationId": "logout",
        "parameters": [
          {
            "name": "Authorization",
            "in": "header",
            "required": true,
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {}
            }
          }
        }
      }
    },
    "/login": {
      "post": {
        "tags": ["auth-controller"],
        "operationId": "login",
        "parameters": [
          {
            "name": "username",
            "in": "query",
            "required": true,
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "password",
            "in": "query",
            "required": true,
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {}
            }
          }
        }
      }
    },
    "/api/usermanagement/profile/update": {
      "post": {
        "tags": ["user-profile-controller"],
        "operationId": "updateUserProfile",
        "parameters": [
          {
            "name": "Authorization",
            "in": "header",
            "required": true,
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {}
            }
          }
        }
      }
    },
    "/UserManagement/register-user": {
      "post": {
        "tags": ["user-controller"],
        "operationId": "registerUser",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "\$ref": "#/components/schemas/User"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": {
                  "\$ref": "#/components/schemas/User"
                }
              }
            }
          }
        }
      }
    },
    "/healthcheck": {
      "get": {
        "tags": ["health-check-controller"],
        "operationId": "checkHealth",
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {}
            }
          }
        }
      }
    },
    "/api/usermanagement/profile": {
      "get": {
        "tags": ["user-profile-controller"],
        "operationId": "getUserProfile",
        "parameters": [
          {
            "name": "Authorization",
            "in": "header",
            "required": false,
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": {
                  "\$ref": "#/components/schemas/User"
                }
              }
            }
          }
        }
      }
    },
    "/api/audit/user/{userId}": {
      "get": {
        "tags": ["user-activity-audit-controller"],
        "operationId": "getActivitiesByUserId",
        "parameters": [
          {
            "name": "userId",
            "in": "path",
            "required": true,
            "schema": {
              "type": "integer",
              "format": "int64"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "additionalProperties": {
                      "type": "object"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "PasswordResetRequest": {
        "type": "object",
        "properties": {
          "token": {
            "type": "string"
          },
          "newPassword": {
            "type": "string"
          }
        }
      },
      "User": {
        "type": "object",
        "properties": {
          "userId": {
            "type": "integer",
            "format": "int64"
          },
          "username": {
            "type": "string"
          },
          "email": {
            "type": "string"
          },
          "passwordHash": {
            "type": "string"
          },
          "createdAt": {
            "type": "string",
            "format": "date-time"
          },
          "updatedAt": {
            "type": "string",
            "format": "date-time"
          },
          "resetToken": {
            "type": "string"
          },
          "tokenExpiry": {
            "type": "string",
            "format": "date-time"
          },
          "firstName": {
            "type": "string"
          },
          "lastName": {
            "type": "string"
          }
        }
      }
    }
  }
}
EOF
}

resource "aws_api_gateway_resource" "user_management_resource" {
  rest_api_id = aws_api_gateway_rest_api.user_management_api.id
  parent_id   = aws_api_gateway_rest_api.user_management_api.root_resource_id
  path_part   = "passwordreset"
}

resource "aws_api_gateway_method" "post_passwordreset" {
  rest_api_id   = aws_api_gateway_rest_api.user_management_api.id
  resource_id   = aws_api_gateway_resource.user_management_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "passwordreset_integration" {
  rest_api_id = aws_api_gateway_rest_api.user_management_api.id
  resource_id = aws_api_gateway_resource.user_management_resource.id
  http_method = aws_api_gateway_method.post_passwordreset.http_method
  integration_http_method = "POST"
  type                = "HTTP"
  uri                 = "http://lassistusrmgt2sep-1056336277.us-east-1.elb.amazonaws.com/api/UserManagement/passwordreset"
}

resource "aws_api_gateway_method_response" "post_passwordreset_response" {
  rest_api_id = aws_api_gateway_rest_api.user_management_api.id
  resource_id = aws_api_gateway_resource.user_management_resource.id
  http_method = aws_api_gateway_method.post_passwordreset.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "post_passwordreset_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.user_management_api.id
  resource_id = aws_api_gateway_resource.user_management_resource.id
  http_method = aws_api_gateway_method.post_passwordreset.http_method
  status_code = "200"
  selection_pattern = ""
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_method.post_passwordreset,
    aws_api_gateway_integration.passwordreset_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.user_management_api.id
  stage_name  = "v1"
}
