class RemoveCountFromBooks < ActiveRecord::Migration[5.2]
  def change
    remove_column :books, :Count, :integer
  end
end
