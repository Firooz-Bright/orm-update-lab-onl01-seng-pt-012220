require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id 
  
  def initialize(name,grade,id=nil)
    @name=name
    @grade=grade
    @id=id 
  end 
  
 def self.create_table
  
   sql= <<-SQL 
    CREATE TABLE IF NOT EXISTS students( 
    id INEGER PRIMARY KEY,
    name TEXT,
    grade TEXT
    )
     SQL
     
     DB[:conn].execute(sql)
  end  
  
  def self.drop_table
   sql =  <<-SQL 
       DROP TABLE students
        SQL
    DB[:conn].execute(sql) 
 end 
 
 def save 
   
   if !self.id 
      sql= <<-SQL
      INSERT INTO  students (name,grade)
      VALUES (?,?)
      SQL
    
       DB[:conn].execute(sql,self.name,self.grade)
       @id= DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
       else
       self.update
    end
  
 end 
 
  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
    student
  end
  
  def self.new_from_db(row)
    student = Student.new(row[1],row[2], row[0])
   
  end

   def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"

     self.new_from_db( DB[:conn].execute(sql, name)[0])
  end
  
  def update
    sql = "UPDATE students SET name = ? WHERE id = ?"
    DB[:conn].execute(sql, @name, @id)
   
  end

 
  
end
