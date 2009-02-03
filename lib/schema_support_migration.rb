module SchemaSupport
  module MigrationFix
    def self.included(base)
      base.extend(SchemaSupport::MigrationFix::ClassMethods)
    end
    
    module ClassMethods
      def set_schema_name(schema_name)
        self.execute("set search_path to #{schema_name},public")
      end
    end

  end
end
