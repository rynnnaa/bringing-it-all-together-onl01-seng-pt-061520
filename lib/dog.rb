class Dog 
  attr_accessor :id, :name, :breed
  
  def initialize(attributes)
    attributes.each {|key, value| self.send(("#{key}="), value)}
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs(id INTEGER PRIMARY KEY,
    name TEXT, 
    breed TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"
    DB[:conn].execute(sql)
  end
  
  def save
    sql = <<-SQL
    INSERT INTO dogs(name, breed)
    VALUES(?,?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end
  
  def self.create(attributes)
    dog = Dog.new(attributes)
    dog.save
    dog
  end
  
  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    breed = row[2]
    self.new(id: id, name: name, breed: breed)
  end
  
  def self.find_by_id(id)
    sql = <<-SQL
    SELECT * FROM dogs
    WHERE id = ?
    LIMIT 1 
    SQL
    DB[:conn].execute(sql, id).map do |row|
      self.new_from_db(row)
    end.first 
  end
  
def self.find_or_create_by(attributes)
        dog = DB[:conn].execute("SELECT * FROM dogs
        WHERE name = ? AND breed = ?", attributes[:name], attributes[:breed])
        if !dog.empty?
            dog_data = dog[0]
            self.new_from_db(dog_data)
        else
            self.create(attributes)
        end
    end
  
  
end