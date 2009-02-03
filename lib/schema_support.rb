# SchemaSupport
module SchemaSupport

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
   def acts_as_schema_support
      ActiveRecord::Migration.send(:extend, MigrationFix)
      begin
        ActiveRecord::ConnectionAdapters::JdbcAdapter.send(:include, JdbcFix)
      rescue
        # nao ta usando o jdbc adapter
      end
      extend  SchemaSupport::SingletonMethods
   end
  end

  module SingletonMethods
    def set_schema_name(schema_name)
      @@schema_name = schema_name
    end

    def schema_name
      @@schema_name
    end

    def columns
      unless defined?(@columns) && @columns
        # pega o nome das colunas usando o novo metodo que criei no JDBC adapter
        @columns = connection.get_columns(table_name, "#{name} Columns",schema_name) 
        @columns.each { |column| column.primary = column.name == primary_key }
      end
      @columns
    end
  end

  # novo metodo de instancia para o JdbcAdapter
  module JdbcFix
    def get_columns(table_name, name=nil, schema_name=nil)
      schema_name = "public" if schema_name.nil?
      @connection.columns_internal(table_name, name, schema_name)
    end
  end


end
