# == Schema Information
#
# Table name: dictionaries
#
#  id    :integer(4)      not null, primary key
#  key   :string(16)      not null
#  value :string(1024)
#

# The dictionary is a key-value storage for miscelanous things.
#
class Dictionary < ActiveRecord::Base

  validates_presence_of :key
  validates_presence_of :value

### Shortcuts ###

  def self.[](k)
    entry = first(:conditions => {:key => k}, :select => [:value])
    entry && entry.value
  end

  def self.[]=(k,v)
    k = connection.quote(k)
    v = connection.quote(v)
    stmt = "INSERT INTO dictionaries(`key`, `value`) VALUES (#{k}, #{v}) ON DUPLICATE KEY UPDATE `value`=#{v}"
    connection.insert_sql(stmt)
  end

end