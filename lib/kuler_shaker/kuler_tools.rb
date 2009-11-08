module KulerShaker
	class Tools
		
		# Function: brightness
		# returns the brightness of a swatch.
		#
		# Parameters:
		# swatch - calculations are performed on a swatch
		#
		# Returns:
		# returns the brightness as a numeric value
		def self.brightness swatch

			b = (((swatch.hex_color[0..1].to_i(16) / 255.0) * 299.0) +
			     ((swatch.hex_color[0..1].to_i(16) / 255.0) * 587.0) +
			     ((swatch.hex_color[0..1].to_i(16) / 255.0) * 114.0)) / 1000.0

			return b
		end
		
		# Function: complementary
		# returns a swatch that has the complementary colour for the swtach that is passed in.
		#
		# Parameters:
		# swatch - get the complementary colour for this swatch
		#
		# Return:
		# a KulerSwatch containing the complementary colour.
		def self.complementary swatch
			
			rgbswatch = swatch.dup
			
			# clobber swatch to rgb
			if rgbswatch.color_mode != 'rgb'
				rgbswatch.color_mode = 'rgb'
				rgbswatch.channel_1 = swatch.hex_color[0..1].to_i(16) / 255.0
				rgbswatch.channel_2 = swatch.hex_color[2..3].to_i(16) / 255.0
				rgbswatch.channel_3 = swatch.hex_color[4..5].to_i(16) / 255.0
				rgbswatch.channel_4 = 0
			end
			
			hslswatch = swatch_to_hsl rgbswatch
			hslswatch.channel_1 += 180.0
			hslswatch.channel_1 -= 360.0 if hslswatch.channel_1 >= 360.0
			
			rgbswatch = swatch_to_rgb hslswatch
			
			hex = [(rgbswatch.channel_1 * 255.0).to_i.to_s(16), 
						 (rgbswatch.channel_2 * 255.0).to_i.to_s(16),
						 (rgbswatch.channel_3 * 255.0).to_i.to_s(16)]

			rgbswatch.color_mode = "rgb"
		  rgbswatch.hex_color = ""
			
			hex.collect do |x| 
				x = "0" + x if x.length == 1
				rgbswatch.hex_color += x
			end
			
			return rgbswatch
		end
		
		def self.readable_complementary swatch
			
			
			c = complementary swatch
			
			
		
		end
		
		
		# Function: swatch_to_hsl
		# will calculate the hsl values for the swatch that is passed in. used info from:
		# http://www.mjijackson.com/2008/02/rgb-to-hsl-and-rgb-to-hsv-color-model-conversion-algorithms-in-javascript
		# to get this.
		#
		# Parameters:
		# swatch - get the HSL values for this swatch.
		#
		# Returns:
		# a swatch containing the colour as hsl
		def self.swatch_to_hsl swatch
			
			hslswatch = swatch.dup
			
			if hslswatch.color_mode == 'rgb'
				h = s = l = 0
				r = hslswatch.channel_1
				g = hslswatch.channel_2
				b = hslswatch.channel_3
				max = [r, g, b].max
				min = [r, g, b].min
				
				l = (max + min) / 2.0
				
				if max != min
					
					d = max - min
					
					s = l > 0.5 ? d / (2.0 - max - min) :  d / (max + min)
					
					case max
						when r
							h = (g - b) / d + (g < b ? 6.0 : 0)
						when g
							h = (b - r) / d + 2.0
						when b
							h = (r - g) / d + 4.0
					end
					
					h = h * 60.0
					h = h + 360.0 if h < 0

				end
				
				hslswatch.color_mode = 'hsl'
				hslswatch.channel_1 = h
				hslswatch.channel_2 = s
				hslswatch.channel_3 = l
				hslswatch.channel_4 = 0
			end
			
			return hslswatch
		end
		
		
		
		# Function: swatch_to_rgb
		# will calculate the rgb values for the swatch that is passed in. used info from
		# http://130.113.54.154/~monger/hsl-rgb.html to write this.
		#
		# Parameters:
		# swatch - the swatch to convert
		#
		# Returns:
		# an rgb version of the input swatch
		def self.swatch_to_rgb swatch
			
			rgbswatch = swatch.dup
			
			if rgbswatch.color_mode == 'hsl'
				r = g = b = 0
				rgb = [r, g, b]
				h = rgbswatch.channel_1 / 360.0
				s = rgbswatch.channel_2
				l = rgbswatch.channel_3
				
				if s == 0
					r = g = b = l
				else
					
					q = l <= 0.5 ? l * (1 + s) : l + s  - (l * s)
					p = 2 * l - q
					
					[h + 1.0/3.0, h, h - 1.0/3.0].each_with_index do |t, i|
						t = t + 1.0 if t < 0
						t = t - 1.0 if t > 1.0
						
						if t < 1.0/6.0 
							rgb[i] = p + (q - p) * 6 * t
						elsif t < 1.0/2.0
							rgb[i] = q
						elsif t < 2.0/3.0
							rgb[i] = p + (q - p) * (2.0/3.0 - t) * 6.0
						else
							rgb[i] = p
						end
					end
				end
			end
			
			rgbswatch.color_mode = 'rgb'
			rgbswatch.channel_1 = rgb[0]
			rgbswatch.channel_2 = rgb[1]
			rgbswatch.channel_3 = rgb[2]
			rgbswatch.channel_4 = 0
			return rgbswatch
		end

	end
end