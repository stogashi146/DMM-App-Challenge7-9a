class Book < ApplicationRecord
	belongs_to :user
	has_many :favorites,dependent: :destroy
	# book.find(1).fav_users ⇒　book :id1がfavoriteにあるuser:idを持ってくる
	has_many :fav_users,through: :favorites,source: :user
	has_many :post_comments,dependent: :destroy

	# 引数で渡されたユーザーIDが、Favoritesテーブル内に存在するか調べる
	def favorited_by?(user)
		favorites.where(user_id:user.id).exists?
	end

	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}

	  # いいねソート
  def self.fav_sort
  	now = Time.current
  	from = now.ago(6.day)
  	# book_idがfa
  	Book.includes(:fav_users).
  		sort{|a,b|
  					b.fav_users.includes(:favorites).where(created_at: from...now).size <=>
  					a.fav_users.includes(:favorites).where(created_at: from...now).size
  		}
  end


	def self.search_for(content, method)
		if method == "perfect"
      Book.where(title: content)
    elsif method == "partial"
      Book.where("title LIKE ?","%" + content + "%")
    elsif method == "forward"
      Book.where("title LIKE ?",content + "%")
    elsif method == "backward"
      Book.where("title LIKE ?","%" + content)
     end
   end

	def self.favsort
  # 		week = Time.zone.today.in_time_zone.all_week
		# favsort = includes(:fav_users).where(created_at: week).sort{|a,b| b.fav_users.size <=> a.fav_users.size}
	end



end
