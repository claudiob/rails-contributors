'.:lib:test:config'.split(':').each { |x| $: << x }

require 'application'

TEST_CNT  = (ENV['KO1TEST_CNT'] || 1_000).to_i
TEST_PATH = ENV['KO1TEST_PATH'] || '/'

Rails.application.initialize!

class NullLog
  def write str
  end
end
$null_logger = NullLog.new

def rackenv path
  {
    "GATEWAY_INTERFACE" => "CGI/1.1",
    "PATH_INFO"         => path,
    "QUERY_STRING"      => "",
    "REMOTE_ADDR"       => "127.0.0.1",
    "REMOTE_HOST"       => "localhost",
    "REQUEST_METHOD"    => "GET",
    "REQUEST_URI"       => "http://localhost:3000#{path}",
    "SCRIPT_NAME"       => "",
    "SERVER_NAME"       => "localhost",
    "SERVER_PORT"       => "3000",
    "SERVER_PROTOCOL"   => "HTTP/1.1",
    "SERVER_SOFTWARE"   => "WEBrick/1.3.1 (Ruby/1.9.3/2011-04-14)",
    "HTTP_USER_AGENT"   => "curl/7.19.7 (universal-apple-darwin10.0) libcurl/7.19.7 OpenSSL/0.9.8l zlib/1.2.3",
    "HTTP_HOST"         => "localhost:3000",
    "HTTP_ACCEPT"       => "*/*",
    "rack.version"      => [1, 1],
    "rack.input"        => StringIO.new,
    "rack.errors"       => $null_logger,
    "rack.multithread"  => true,
    "rack.multiprocess" => false,
    "rack.run_once"     => false,
    "rack.url_scheme"   => "http",
    "HTTP_VERSION"      => "HTTP/1.1",
    "REQUEST_PATH"      => path
  }
end

TESTENV = rackenv TEST_PATH

def do_test_task app
  _, _, body = app.call(TESTENV)
  body.each { |_| }
  body.close
end

task :allocated_objects do
  app = Rails.application
  app.app
  do_test_task(app)

  GC.start
  GC.disable

  start = ObjectSpace.count_objects
  c = Hash.new(0)
  imem = 0
  ObjectSpace.each_object(String) do |s|
    c[s] -= 1
    imem += s.length
  end

  TEST_CNT.times { do_test_task(app) }
  finish = ObjectSpace.count_objects

  fmem = 0
  ObjectSpace.each_object(String) do |s|
    c[s] += 1
    fmem += s.length
  end

  c.keys.sort_by {|a, b| c[b] <=> c[a]}.each do |k|
    puts "#{k} => #{per_request(c[k])}" if per_request(c[k]) > 3000
  end

  GC.enable

  finish.each do |k, v|
    p k => per_request(v - start[k])
  end

  puts "string mem per request: #{per_request(fmem - imem)}"
end

def per_request(amount)
  amount/TEST_CNT.to_f
end
