class Line < ActiveRecord::Base
	belongs_to :wildtype, :class_name => "Line", :foreign_key => "wildtype_id", :autosave => true
	belongs_to :species, :autosave => true
end
