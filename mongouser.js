conn = new Mongo();
db = conn.getDB("admin");
db.createUser(
  {
    user: "$MONGO_USER",
    pwd: "$MONGO_PASS",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)
