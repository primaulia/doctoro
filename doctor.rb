require 'sqlite3'
require 'pry-byebug'
DB = SQLite3::Database.new("db/doctors.db") # link to the db file
DB.results_as_hash = true

class Doctor
  attr_accessor :id
  attr_reader :name, :specialty, :age

  def initialize(attributes)
    @id = attributes[:id]
    @name = attributes[:name]
    @specialty = attributes[:specialty]
    @age = attributes[:age]
  end

  def self.find(id)
    # find the doctor records in the db based on the id
    query = <<-SQL
      SELECT *
      FROM doctors
      WHERE id = #{id}
    SQL

    results = DB.execute(query).first

    new_doctor = Doctor.new(
      id: results["id"],
      name: results["name"],
      specialty: results["specialty"],
      age: results["age"]
    )

    return new_doctor
  end

  def move_dept(new_department)
    query = <<-SQL
      UPDATE doctors
      SET specialty = '#{new_department}'
      WHERE id = #{self.id}
    SQL

    DB.execute(query)

    # return Doctor.find(self.id)
  end

  def save
    # execute insert
    # update the id based on what
    # the db says
    command = <<-SQL
      INSERT INTO doctors
      (name, age, specialty)
      VALUES ('#{self.name}', #{self.age}, '#{self.specialty}')
    SQL

    DB.execute(command)
    self.id = DB.last_insert_row_id
    # binding.pry

  end
end

# create in memory
prima = Doctor.new(
  name: 'Prima',
  specialty: 'Radiologist',
  age: 28
)

prima.save

p prima.id



# eli = Doctor.find(3)
# puts 'eli before'
# p eli
# puts

# puts 'eli after moving dept'
# eli.move_dept('Cardiology')
# # eli = Doctor.find(3)
# p eli









