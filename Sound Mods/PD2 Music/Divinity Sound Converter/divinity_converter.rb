## By Vivex (steam: kejento), 8/7/2014




require 'fileutils'
WEM_CODEBOOKS="packed_codebooks_aoTuV_603.bin"

#File.directory?("name") and/or File.file?("name").
def convert_all_to_ogg	
	mass_extension_renamer(:wem,:_wem)
	
	
	Dir.glob("*.bnk").each do |file|
		puts "Converting #{file}..."
		`bnkextr.exe #{file}`		
	end
	
	mass_extension_renamer(:wav,:wem)
	
	Dir.glob("*.wem").each do |file|
		puts "Converting #{file} to .ogg..."
		`ww2ogg.exe #{file} --pcb #{WEM_CODEBOOKS}`		
	end
	
	remove_by_extension(:wem) #sanitation
	
	
	Dir.glob("*.ogg").each do |file|
		puts "Converting #{file} to a better .ogg format (?)..."
		`revorb.exe #{file}`
		FileUtils.mv(file, "NON-NUMBERED")
	end
	
	Dir.glob("*._wem").each do |file|
		puts "Converting #{file} to .ogg..."
		`ww2ogg.exe #{file} --pcb #{WEM_CODEBOOKS}`
	end
	
	Dir.glob("*.ogg").each do |file|
		puts "Converting #{file} to a better .ogg format (?)..."
		`revorb.exe #{file}`
		FileUtils.mv(file, "NUMBERED")
	end
	mass_extension_renamer(:'._wem', :wem)
	
end

def remove_by_extension(ext)
	FileUtils.rm(Dir.glob("*.#{ext.to_s}"), :force=>true)
end

def mass_extension_renamer(from, to) #extension name (from -> to)
	Dir.glob("*.#{from.to_s}").each do |file|		
		File.rename(file, file.gsub(/\.(#{from.to_s})/, ".#{to.to_s}"))	
	end
end


def main()
	convert_all_to_ogg()	
end

main()