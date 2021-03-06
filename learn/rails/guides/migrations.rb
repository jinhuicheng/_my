# 1 Anatomy of a Migration
class CreateProducts < ActiveRecord::Migration
	def self.up
		create_table :products do |t|
			t.string :name
			t.text :description

			t.timestamps
		end
	end

	def self.down
		drop_table :products
	end
end

# You can also use them to fix bad data in the database or populate new fields
class AddReceiveNewsletterToUsers < ActiveRecord::Migration
	def self.up
		change_table :users do |t|
			t.boolean :receive_newsletter, :default => false
		end
		User.update_all ["receive_newsletter = ?", true]
	end

	def self.down
		remove_column :users, :receive_newsletter
	end
end

#The methods that perform common data definition tasks in a database independent way:
methods = %w[
				create_table
				change_table
				drop_table
				add_column
				change_column
				rename_column
				add_index
				remove_index
				]

#Migrations are stored in files in db/migrate, one for each migration class
#The name of the file is of the form YYYYMMDDHHMMSS_create_products.rb
#The name of the migration class (CamelCased version) should match the latter part of the file name

#db:migrate
#db:rollback


#Creating a Model
rails generate model Product name:string description:text

#Creating a Standalone Migration
rails generate migration AddPartNumberToProducts

#iIf the migration name is of the form “AddXXXToYYY” or “RemoveXXXFromYYY” and is followed by a list of column names and types then a migration containing the appropriate add_column and remove_column statements will be created.
#rails generate migration AddPartNumberToProducts part_number:string
class AddPartNumberToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :part_number, :string
  end
 
  def self.down
    remove_column :products, :part_number
  end
end

#rails generate migration RemovePartNumberFromProducts part_number:string
class RemovePartNumberFromProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :part_number
  end
 
  def self.down
    add_column :products, :part_number, :string
  end
end

#rails generate migration AddDetailsToProducts part_number:string price:decimal


##Creating a Table
create_table :products do |t|
  t.string :name
end

create_table :products do |t|
	t.column :name, :String, :null => false
end

create_table :rpoducts do |t|
	t.string :name, :null => false
end

types = [
:primary_key,
:string,
:text,
:integer,
:float,
:decimal,
:datetime,
:timestamp,
:time,
:date,
:binary,
:boolean
]

#You can create columns of types not supported by Active Record when using the non-sexy syntax, for example
create_table :products do |t|
	t.column :name, 'polygon', :null => false
end

##Changing Tables
change_table :products do |t|
	t.remove :description, :name
	t.string :part_number
	t.index :part_number
	t.rename :upccode, :upc_code
end

##Special Helpers
#timestamps
create_table :products do |t|
	t.timestamps
end

change_table :products do |t|
	t.timestamps
end

#references
#belongs_to
create_table :products do |t|
	#create a category_id column of the appropriate type.
	t.references :category
end

# If you have polymorphic belongs_to associations then references will add both of the columns required
create_table :products do |t|
	#add an attachment_id column and a string attachment_type column with a default value of ‘Photo’.
	t.references :attachment, :polymorphic => {:default => 'Photo'}
end

##Writing Your down Method
class ExampleMigration < ActiveRecord::Migration
 
  def self.up
    create_table :products do |t|
      t.references :category
    end
    #add a foreign key
    execute <<-SQL
      ALTER TABLE products
        ADD CONSTRAINT fk_products_categories
        FOREIGN KEY (category_id)
        REFERENCES categories(id)
    SQL
 
    add_column :users, :home_page_url, :string
 
    rename_column :users, :email, :email_address
  end
 
  def self.down
    rename_column :users, :email_address, :email
    remove_column :users, :home_page_url
    execute "ALTER TABLE products DROP FOREIGN KEY fk_products_categories"
    drop_table :products
  end
end

#Note that running the db:migrate also invokes the db:schema:dump task, which will update your db/schema.rb file to match the structure of your database

#If you specify a target version, Active Record will run the required migrations (up or down) until it has reached the specified version
rake db:migrate VERSION=20080906120000

#Rolling Back
rake db:rollback
rake db:rollback STEP=3


rake db:migrate:redo STEP=3

#Lastly, the db:reset task will drop the database, recreate it and load the current schema into it.
db:reset

rake db:migrate:up VERSION=20080906120000
rake db:migrate:down VERSION=20080906120000

#suppress_messages suppresses any output generated by its block
#say outputs text (the second argument controls whether it is indented or not)
#say_with_time outputs text along with how long it took to run its block. If the block returns an integer it assumes it is the number of rows affected.
class CreateProducts < ActiveRecord::Migration
  def self.up
    suppress_messages do
      create_table :products do |t|
        t.string :name
        t.text :description
        t.timestamps
      end
    end
    say "Created a table"
    suppress_messages {add_index :products, :name}
    say "and an index!", true
    say_with_time 'Waiting for a while' do
      sleep 10
      250
    end
  end
 
  def self.down
    drop_table :products
  end
end