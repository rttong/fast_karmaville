class User < ActiveRecord::Base
  has_many :karma_points

  attr_accessible :first_name, :last_name, :email, :username, :total_karma_points

  validates :first_name, :presence => true
  validates :last_name, :presence => true

  validates :username,
            :presence => true,
            :length => {:minimum => 2, :maximum => 32},
            :format => {:with => /^\w+$/},
            :uniqueness => {:case_sensitive => false}

  validates :email,
            :presence => true,
            :format => {:with => /^[\w+\-.]+@[a-z\d\-.]+\.[a-z]+$/i},
            :uniqueness => {:case_sensitive => false}

  def self.by_karma
    # joins(:karma_points).group('users.id').order('SUM(karma_points.value) DESC')
    order('total_karma_points DESC')
  end

  def total_karma
    # self.karma_points.sum(:value)
    self.total_karma_points
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.populate
    User.all.each do |user|
      user.update_attribute(:total_karma_points, user.karma_points.sum(:value))
    end
  end

end
