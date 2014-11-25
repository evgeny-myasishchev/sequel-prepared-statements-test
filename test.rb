gem 'pg'
gem 'sequel'
require 'yaml'
require 'logger'
require 'sequel'

Log = Logger.new STDOUT

def assert_data(expected, actual)
  expected_string = expected.join(' ')
  actual_string = actual.join(' ')
  if expected_string != actual_string
    Log.error "Wrong data persisted.\nExpected bytes: #{expected_string}\n  Actual bytes: #{actual_string}"
  else
    Log.info 'Data persisted correctly'
  end
end

db_config = YAML.load_file File.join(__dir__, 'database.yml')
Log.info 'Database config loaded'

db = Sequel.connect db_config
db.loggers << Log
db.sql_log_level = :debug

db.create_table! :binary_store do |table|
  primary_key :id
  File :data
end


binary_data = []
256.times { |b| binary_data << b }
binary_store = db[:binary_store]

Log.info 'Inserting using direct insert...'
id = binary_store.insert data: Sequel.blob(binary_data.pack('C*'))
assert_data binary_data, binary_store[id: id][:data].unpack('C*')

binary_store.prepare(:insert, :insert_binary_data, { data: :$data })

Log.info 'Inserting using prepared statement...'
id = db.call(:insert_binary_data, data: Sequel.blob(binary_data.pack('C*')))
assert_data binary_data, binary_store[id: id][:data].unpack('C*')