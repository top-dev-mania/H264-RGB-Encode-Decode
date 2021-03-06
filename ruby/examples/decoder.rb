require '../h264_rgb'

if ARGV.size < 2
  puts "Usage: #{__FILE__} [in_file.h264] [out_file.rgb]"
  exit
end

in_file_name = ARGV[0]
out_file_name = ARGV[1]

out_file = File.open(out_file_name, "wb")

count = 0

in_buf = "0" * 65535

decoder = H264_RGB::Decoder.new
File.open(in_file_name, "rb") do |f|
  while len = f.read(in_buf.bytesize, in_buf)
    frames = decoder.parse(in_buf)
    frames.each do |output|
      count += 1
      puts "Written [#{count}]: #{output.bytesize}"
      out_file.write output
    end
  end
  frames = decoder.flush
  frames.each do |output|
    count += 1
    puts "Written [delayed] [#{count}]: #{output.bytesize}"
    out_file.write output
  end
end

decoder.dispose
out_file.close
