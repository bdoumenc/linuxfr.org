class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.references :user
      t.string   :login, :limit => 40,  :null => false
      t.string   :email, :limit => 100, :null => false
      t.string   :state,                :null => false, :default => 'passive'
      t.string   :crypted_password,     :null => false
      t.string   :password_salt,        :null => false
      t.string   :persistence_token,    :null => false
      t.string   :single_access_token,  :null => false
      t.string   :perishable_token,     :null => false
      t.integer  :login_count,          :null => false, :default => 0
      t.integer  :failed_login_count,   :null => false, :default => 0
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string   :current_login_ip
      t.string   :last_login_ip
      t.string   :stylesheet
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end