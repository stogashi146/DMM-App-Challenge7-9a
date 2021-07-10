class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites,dependent: :destroy
  has_many :post_comments,dependent: :destroy
  has_many :view_counts,dependent: :destroy

  ##followed:フォロされた人　follower:フォローした人
  #userがRelationshipのどのカラムを参照するか
  has_many :reverse_of_relationships,class_name:"Relationship",foreign_key:"followed_id",dependent: :destroy
  # reverse_of_relationshipsを経由して（through）、関連付け元のカラムを参照（source）
  has_many :followers,through: :reverse_of_relationships,source: :follower
  #userがRelationshipのどのカラムを参照するか
  has_many :relationships,class_name:"Relationship",foreign_key:"follower_id",dependent: :destroy
  # reverse_of_relationshipsを経由して（through）、カラムを参照（source）
  has_many :followings,through: :relationships,source: :followed


  # フォローする
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  # フォローを外す
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  #フォロー確認を行う
  def following?(user)
    followings.include?(user)
  end

  attachment :profile_image, destroy: false
  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction,length:{maximum:50}

  def self.search_for(content,method)
    if method == "perfect"
      # name:がcontent(検索ワード)のものを取得
      User.where(name: content)
    elsif method == "partial"
      User.where("name LIKE ?","%" + content + "%")
    elsif method == "forward"
      User.where("name LIKE ?",content+"%")
    elsif method == "backward"
      User.where("name LIKE ?","%"+content)
    end
  end


end
