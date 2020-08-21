class Dog 
  attr_accessor :id, :name, :breed
  
  def initialize(attributes)
    attributes.each {|key, value| self.send(("#{key}="), value)}
  end
  
  def self.create_table
    sql = CREATE TABLE IF NOT EXISTS dogs(id INTEGER PRIMARY KEY,
    name TEXT, 
    breed TEXT
    )
    db.execute(sql)
  end
end