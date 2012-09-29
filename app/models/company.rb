class Company < ActiveRecord::Base
  attr_accessible :name, :offices_attributes, :email_address, :founded_year, :description,
                  :homepage_url, :twitter, :facebook, :jobs_url, :hiring, :image,
                  :investments_type_id, :employees_type_id

  belongs_to  :user

  belongs_to  :investments_type

  belongs_to  :employees_type

  has_many :offices, :dependent => :destroy

  accepts_nested_attributes_for :offices

  has_and_belongs_to_many :tags

  has_attached_file :image,
                    :styles => {
                        :thumbnail => "128x128>",
                        :medium => "256x256>"
                    },
                    :url  => ':class/:id/image/:style',
                    :path => ':rails_root/uploads/:class/:id_partition/:style.:extension'


  validates_presence_of :name, :email_address, :founded_year

  validates_numericality_of :founded_year, :less_than_or_equal_to => Time.now.year

  scope :founded_from,
        lambda {|year|
          where("`companies`.founded_year >= ?", year)
        }

  scope :founded_to,
        lambda {|year|
          where("`companies`.founded_year <= ?", year)
        }


  scope :tagged_as,
        lambda {|tag_code|
          joins(:tags).where("`tags`.code = ?", tag_code)
        }


  scope :are_hiring, where("`companies`.hiring = true")

  scope :employee_type,
        lambda {|employee_id|
          where("`companies`.employees_type_id = ?", employee_id)
        }

  scope :investment_type,
        lambda {|investment_id|
          where("`companies`.investments_type_id = ?", investment_id)
        }

  def number_of_employees
    employees_type.name
  end

  def tags_list
    tags.map(&:code).join(", ")
  end

end
