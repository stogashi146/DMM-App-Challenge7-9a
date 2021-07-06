class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      # referencesで外部キーでか型を設定、
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
      # 同じペア同時で重複しないようにする設定
      t.index [:follower_id,:followed_id],unique: true
    end
  end
end
