class HaplotypeBlock < ApplicationRecord
  belongs_to :region
  belongs_to :assembly
  belongs_to :haplotype_set
  belongs_to :first_feature, class_name: :Feature, foreign_key: :first_feature
  belongs_to :last_feature,  class_name: :Feature, foreign_key: :last_feature
end
