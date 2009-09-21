# == Schema Information
#
# Table name: wiki_pages
#
#  id         :integer(4)      not null, primary key
#  state      :string(255)     default("public"), not null
#  title      :string(255)
#  cache_slug :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

# The wiki have pages, with the content that can't go anywhere else.
#
class WikiPage < Content
  validates_presence_of :title, :message => "Le titre est obligatoire"
  validates_presence_of :body,  :message => "Le corps est obligatoire"

  wikify :body, :as => :wikified_body

### SEO ###

  has_friendly_id :title

### Sphinx ####

  define_index do
    indexes title, body
    indexes user.name, :as => :user
    where "state = 'public'"
    set_property :field_weights => { :title => 15, :user => 1, :body => 5 }
    set_property :delta => :datetime, :threshold => 1.hour
  end

### Versioning ###

  attr_accessor :commit_message
  attr_accessor :committer

  versioning(:title, :body) do |v|
    v.repository = Rails.root.join('git_store', 'wiki.git')
    v.message    = lambda { |page| page.commit_message }
    v.committer  = lambda { |page| [page.committer.name, page.committer.email] }
  end

### ACL ###

  def creatable_by?(user)
    user # && user.karma > 0
  end

  def editable_by?(user)
    user && (state == "public" || user.amr?)
  end

  def deletable_by?(user)
    user && user.amr?
  end

  def commentable_by?(user)
    user && readable_by?(user)
  end

### Interest ###

  def self.interest_coefficient
    5
  end

end
