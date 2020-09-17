# Student
#   attributes
#     has a name and a grade (FAILED - 1)
#     has an id that defaults to `nil` on initialization (FAILED - 2)
#   .create_table
#     creates the students table in the database (FAILED - 3)
#   .drop_table
#     drops the students table from the database (FAILED - 4)
#   #save
#     saves an instance of the Student class to the database and then sets the given students `id` attribute (FAILED - 5)
#     updates a record if called on an object that is already persisted (FAILED - 6)
#   .create
#     creates a student with two attributes, name and grade, and saves it into the students table. (FAILED - 7)
#   .new_from_db
#     creates an instance with corresponding attribute values (FAILED - 8)
#   .find_by_name
#     returns an instance of student that matches the name from the DB (FAILED - 9)
#   #update
#     updates the record associated with a given instance (FAILED - 10)

require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students;"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?;"
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    else
      sql = "INSERT INTO students (name, grade) VALUES (?, ?);"
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0]
    end
  end

  def self.create(name, grade)
    new_student = self.new(name, grade)
    new_student.save
    new_student
  end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?;"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end
