require 'schema_support'
require 'schema_support_migration'
ActiveRecord::Base.send(:include, SchemaSupport)
ActiveRecord::Migration.send(:include, SchemaSupport::MigrationFix)





