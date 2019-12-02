class AddMarkerAliasRefToMarkerName < ActiveRecord::Migration[6.0]
  def change
    add_reference :marker_names, :marker_alias_detail, index: true, foreign_key: true
#    add_foreign_key :marker_names, :aliases
  end
end
