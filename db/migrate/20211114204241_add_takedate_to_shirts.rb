class AddTakedateToShirts < ActiveRecord::Migration[6.1]
  def change
    add_column :shirts, :takedate, :datetime
  end
end
