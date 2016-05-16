class AddViewcountToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :viewcount, :integer
  end
end
