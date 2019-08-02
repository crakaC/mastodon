class Pool
  def initialize(size)
    @size = size
    @queue = Queue.new
    @threads = []
  end

  def execute(&job)
    @queue.push(job)
    @threads << create_thread if @threads.size < @size
  end

  def shutdown
    until @queue.empty?
      sleep(0.01)
    end
    @threads.each{|t| t.kill}
  end

  private
  def create_thread
    Thread.start(@queue) do |q|
      loop do
        job = q.pop
        job.call
      end
    end
  end
end
