require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_secure_password
    validates :mail,
        presence: true,
        format: {with:/\A.+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+\z/}
    validates :password,
        presence: true,
        format: {with:/(?=.*?[a-z])(?=.*?[0-9])/},
        length: {in: 5..10}
    has_many :tasks
end

class Task < ActiveRecord::Base
    validates :title,
        presence: true
    validates :date_start,
        presence: true
    validates :date_end,
        presence: true
    validates :quantity,
        presence: true
    validates :color,
        presence: true
    validates :importance,
        presence: true
    validates :unit,
        presence: true,
        length: {in: 1..5}
    belongs_to :user
    
    def required_days
        return (date_end - date_start).to_i + 1
    end
    
    def splited_task
        return (quantity / required_days).to_s
    end
end