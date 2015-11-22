require 'sinatra'
require 'pg'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: "grocery_list")
    yield(connection)
  ensure
    connection.close
  end
end

get '/groceries' do

  table = db_connection { |item|
    item.exec("SELECT groceries.id,
    groceries.grocery_name FROM groceries")}

  erb :index, locals: {table: table}

end

post '/groceries' do

  grocery_name = params["grocery_name"]

  db_connection do |entry|
    entry.exec("
    INSERT INTO groceries(grocery_name)
    values('#{params["grocery_name"]}')")
    #.exec_params("INSERT INTO groceries(grocery_name)values($1)",[grocery_name])
  end

  redirect '/groceries'

end
