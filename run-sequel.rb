gem 'pg'
gem 'sequel'
require 'yaml'
require 'logger'
require 'sequel'

logger = Logger.new STDOUT
db_config = YAML.load_file File.join(__dir__, 'database.yml')
logger.info 'Database config loaded'

db = Sequel.connect db_config
db.loggers << logger
db.sql_log_level = :debug