require_relative "room"
#======================== HOTEL ============================
class Hotel
    # attr_accessor   
    attr_reader :name, :rooms, :room_name, :capacities 
    def initialize(name,*rooms)
        @name = name
        @rooms = Hash.new{|room_name,capacities|room_name[capacities]=[]}
    end
    def name
        @name.split.map(&:capitalize).join(' ')
    end 
    def rooms
        @rooms = @rooms[@room_name]=[@capacities]
    end





    # def room_exists?(room_name)
    #     @rooms.include? room_name
    # end
    # def check_in(person,room_name)
    #     case room_exists?(room_name)
    #     when true 
    #         Room.add_occupant(person) == true ? "Check in Successful!" : "Sorry, Room is Full!"
    #     else puts "Sorry, Room does not exist!"
    #     end
    # end
    # def has_vacancy?
    #     Room.full? != true ? true : false
    # end
    # def list_rooms
    #     puts @rooms
    # end
end


