class Dog 
  attr_accessor :id, :name, :breed
  
  def initialize(attributes)
    attributes.each {|key, value| self.send(("#{key}="), value)}
  end
  
  def self.create_table
end