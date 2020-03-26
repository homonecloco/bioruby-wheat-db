require 'bio-pangenome'

class HaplotypeSetController < ApplicationController
  def index
  end

  

  def find_longest_block(blocks)
    longest = blocks.first
    blocks.each { |e| longest = e if longest.length < e.length  }
    longest
  end

  def show_single
    chr_name = params[:chr_name] 
    species  = params[:species]
    hap_set  = params[:hap_set]    

    @blocks = Rails.cache.fetch("blocks/#{species}/#{chr_name}/#{hap_set}", expires_in: 5.seconds) do
      tmp_B = HaplotypeSetHelper.find_calculated_block(hap_set, chromosome:chr_name, species: species)
      HaplotypeSetHelper.to_blocks(tmp_B)
    end

    asm = "IWGSCv1.1"
    @s_blocks = Rails.cache.fetch("blocks/#{species}/#{chr_name}/#{hap_set}/#{asm}", expires_in: 5.seconds) do
      tmp = HaplotypeSetHelper.scale_blocks(@blocks, target: asm, species: species)
      tmp.sort!
    end


    @blocks_csv = Array.new
    @blocks_csv   << ["assembly","reference","chromosome","start","end","block_no", "chr_length"].join(",")
    @s_blocks.each do |e| 
      @blocks_csv << [e.assembly, e.reference, e.chromosome,e.start, e.end, e.block_no, e.chr_length].join(",")
    end

    respond_to do |format|
      format.csv do
        send_data @blocks_csv.join("\n"), filename: "#{species}_#{hap_set}_#{chr_name}.csv" 
      end
    end
  end
  
  def show
    @chr = params[:chr_name] 
    @species  = params[:species]

    hap_sets = HaplotypeSetHelper.find_hap_sets(species: @species, chr: @chr)
#http://localhost:3000/haplotype_set/Wheat/haps/6A.csv
    @hap_set  = hap_sets.first    

    @csv_path = "/#{@species}/haplotype/#{@chr}/#{@hap_set.name}.csv"

    asm = params[:asm]

  	respond_to do |format|
      format.html
      format.csv do 
        @blocks_csv = Array.new
        @blocks_csv << ["assembly","chromosome","start","end","block_no", "chr_length"].join(",")
        
        #@blocks = @blocks.sort!
        @s_blocks = Rails.cache.fetch("#{hap_set}/#{chr_name}/#{asm}") do
          tmp = HaplotypeSetHelper.scale_blocks(@blocks, target: asm)
          tmp.sort!
        end

        @s_blocks.each do |e| 
          @blocks_csv << [e.assembly, e.chromosome,e.start, e.end, e.block_no, e.chr_length].join(",")
        end
        send_data @blocks_csv.join("\n"), filename: "#{params[:name]}.csv" 
      end 
    end
  end
end
