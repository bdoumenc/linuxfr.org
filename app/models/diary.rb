# == Schema Information
# Schema version: 20090110185148
#
# Table name: diaries
#
#  id         :integer(4)      not null, primary key
#  state      :string(255)     default("published"), not null
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class Diary < Content
  validates_presence_of :title, :message => "Le titre est obligatoire"
  validates_presence_of :body,  :message => "Vous ne pouvez pas poster un journal vide"

### Body ###

  def body
    b = body_before_type_cast
    b.blank? ? "" : WikiCreole.creole_parse(b)
  end

### ACL ###

  def creatable_by?(user)
    user # && user.karma > 0
  end

  def editable_by?(user)
    user && (user.moderator? || user.admin?)
  end

  def deletable_by?(user)
    user && (user.moderator? || user.admin?)
  end

end