threads_count = ENV.fetch('MAX_THREADS') { 5 }.to_i
threads 0, threads_count

if ENV['SOCKET']
  bind "unix://#{ENV['SOCKET']}"
else
  bind "tcp://#{ENV.fetch('BIND', '127.0.0.1')}:#{ENV.fetch('PORT', 3000)}"
end

environment ENV.fetch('RAILS_ENV') { 'development' }

worker_num = ENV.fetch('WEB_CONCURRENCY') { 2 }.to_i
if worker_num > 1 then
  workers worker_num
  preload_app!
  on_worker_boot do
    ActiveSupport.on_load(:active_record) do
      ActiveRecord::Base.establish_connection
    end
  end
end

plugin :tmp_restart
