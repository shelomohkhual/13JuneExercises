require "employee"

class Startup
    attr_accessor :name,:funding,:salaries,:employees
    def initialize(name,funding,salaries)
        @name = name
        @funding = funding
        @salaries = salaries
        @employees = []
    end
    def valid_title?(title)
        @salaries.keys.any? title
    end
    def >(another_startup)
        self.funding > another_startup.funding
    end
    def hire(employee_name,title)
        if valid_title?(title) != true
            error                                   # i don't even know why it's working
        else
            @employees.push Employee.new(employee_name,title)
        end
    end
    def size
        @employees.size
    end
    def pay_employee(employee)
        if @funding >= @salaries[employee.title]
            Employee.pay(@salaries[employee.title])
            @funding -= @salaries[employee.title]
        else
            error
        end
    end
    def payday
    end
    def average_salary
    end
    def close
    end
    def acquire
    end

end
