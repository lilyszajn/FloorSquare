get '/' do
  response['Access-Control-Allow-Origin'] = '*'
  erb :front
end

#   ADMIN
#---------------------------------------

get '/admin/' do
end

get '/admin/apps' do
end

get '/admin/apps/new' do
	# We should use datamapper's builtin api key field for this...
	# https://github.com/datamapper/dm-types/blob/master/lib/dm-types/api_key.rb
end

post '/admin/apps/new' do
end

get '/admin/apps/:id/' do
end

get '/admin/apps/:id/edit' do
end

put '/admin/apps/:id' do
end

delete '/admin/apps/:id' do
end

get '/admin/devices' do
end

get '/admin/devices/new' do
end

post '/admin/devices/new' do
end

get '/admin/devices/:id' do
end

get '/admin/devices/:id/edit' do
end

put '/admin/devices/:id' do
end

delete '/admin/devices/:id' do
end

# this should be a post
post '/swipe/new' do
	netid = params[:netid]
	app_id = params[:app_id]
	device_id = params[:device_id]
	extra = params[:extra]

	user = User.get(netid)
	if not user
		return('get off the floor, yo!')
	
	else
		@swipe = Swipe.create()
		@swipe.netid= netid
		@swipe.app_id= app_id
		@swipe.device_id= device_id
		@swipe.extra= {"app_id_"+app_id => extra }
		@swipe.save()

		extra= user.extra["app_id_"+app_id]
		# content_type :json
	  	data= { :name => user.name, :photo => user.photo, :netid => netid, :extra => extra, :swipeid=> @swipe.id}
		
		response['Access-Control-Allow-Origin'] = '*'

	  	# return JSONP data
	  	return data.to_json
	end
end

# Allows extra data to be added to a swipe, after the swipe occurs. Makes sense from a user perspective (swipe first, then do something)
post '/swipe/:id' do
	netid = params[:netid]
	app_id = params[:app_id]
	extra = params[:extra]
	id = params[:id]

	user = User.get(netid)
	if not user
		return('get off the floor, yo!')
	
	else
		swipe = Swipe.get(id)
		if swipe.extra
			new_extra= swipe.extra["app_id_"+app_id].merge(extra)
			swipe.extra = {"app_id_"+app_id => new_extra }

		else
			swipe.extra = {"app_id_"+app_id => extra }
		end

		swipe.save()
		response['Access-Control-Allow-Origin'] = '*'
	  	return swipe.to_json
	end
end


post '/user/:netid' do
	response['Access-Control-Allow-Origin'] = '*'

	netid = params[:netid]
	app_id = params[:app_id]
	extra = params[:extra]

	user = User.get(netid)
	if not user
		response['Access-Control-Allow-Origin'] = '*'
		return('get off the floor, yo!')
	else
		if user.extra
			new_extra= user.extra["app_id_"+app_id].merge(extra)
			user.extra = {"app_id_"+app_id => new_extra }
		else
			user.extra = {"app_id_"+app_id => extra }
		end

		user.save()

		response['Access-Control-Allow-Origin'] = '*'
	  	return user.to_json
	end
end

get '/swipes/' do

	app_id = params[:app_id]
	# extra = params[:extra]
	
	app_swipes= Swipe.all(:app_id=>app_id)


	response['Access-Control-Allow-Origin'] = '*'

	if app_swipes.length > 0
		return app_swipes.to_json
	else
		return 'no swipes found'
	end


end


#   SASS
#---------------------------------------

get '/stylesheets/style.css' do
  scss :style
end

#   404
#---------------------------------------

not_found do
  erb :notfound
end