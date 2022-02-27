class Movie < ActiveRecord::Base
    
    def self.all_ratings
        return ['G','PG','PG-13','R']
    end
    
    def self.with_ratings(ratings)
        return Movie.where("rating = ?", ['G', 'PG'])
    end
end
