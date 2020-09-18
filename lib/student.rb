require_relative "../config/environment.rb"

class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new(row[1], row[2], row[0])
    student
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1
      SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
        SQL
        DB[:conn].execute(sql, self.name, self.grade)

        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      end
  end

  def update
    sql = <<-SQL
      UPDATE students
      SET name = ?, grade = ?
      WHERE id = ?
      SQL

      DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
# class Student

#   # Remember, you can access your database connection anywhere in this class
#   #  with DB[:conn]

#   attr_accessor :name, :grade
#   attr_accessor :id

#   def initialize(name, grade, id = nil)
#     @name = name
#     @grade = grade
#     @id = id
#   end

#   def self.create_table
#     sql = <<-SQL
#     CREATE TABLE IF NOT EXISTS students (
#       id INTEGER PRIMARY KEY,
#       name TEXT,
#       grade TEXT
#     )
#     SQL
#     DB[:conn].execute(sql)
#   end

#   def self.drop_table
#     sql = <<-SQL
#     DROP TABLE students
#     SQL
#     DB[:conn].execute(sql)
#     # DB[:conn].execute("DROP TABLE IF EXISTS students")
#   end

#   def self.create(name, grade)
#     student = Student.new(name, grade)
#     student.save
#     student
#   end

#   def self.new_from_db(row)
#     student = Student.new(row[0], row[1], row[2])
#     student
#   end

#   def save
#     if self.id
#       self.update
#     else
#       sql = <<-SQL
#         INSERT INTO students (name, grade)
#         VALUES (?, ?)
#         SQL
#         DB[:conn].execute(sql, self.name, self.grade)

#         @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
#       end
#   end

#   # def save
#   #   sql = <<-SQL
#   #   INSERT INTO students(name, grade)
#   #   VALUES (?, ?)
#   #   SQL
#   #   DB[:conn].execute(sql, self.name, self.grade)

#   #   @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]

#   # end
  
#   def self.find_by_name(name)
#     sql = <<-SQL
#     SELECT * 
#     FROM students 
#     WHERE name = ?
#     LIMIT 1
#     SQL
#     # result = DB[:conn].execute(sql, name)[0]
#     # self.new_from_db(result)
#     DB[:conn].execute(sql, name).map do |row|
#       self.new_from_db(row)
#     end.first
#   end

#   # def self.new_from_db(row)
#   #   id = row[0]
#   #   name = row[1]
#   #   grade = row[2]
#   #   self.new(id, name, grade)
#   # end 

#   # def self.find_by_name
#   #   sql = <<-SQL
#   #   SELECT * 
#   #   FROM students 
#   #   WHERE name = ?
#   #   SQL
#   #   DB[:conn].execute(sql, name).map { |row| new_from_db(row) }.first
#   # end

#   def update
#     sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
#     DB[:conn].execute(sql, self.name, self.grade, self.id)
#   end
# end

