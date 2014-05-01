require "nokogiri"
require "ruby_kml"

#Open XML file and then parse it
f = File.open("traces.xml")
doc = Nokogiri::XML(f)
f.close

builder = Nokogiri::XML::Builder.new do |xml|
xml.gpx {
  xml.products {
  
      doc.xpath("//FlightRecord").each do |p|
        agl=p.attr('AGL')
        msl=p.attr('MSL')
        date=p.attr('date')
        inner = Nokogiri::XML(p.to_s)
        lat=inner.xpath("//Point").attr('lat')
        lon=inner.xpath("//Point").attr('lon')
        heading=inner.xpath("//Heading").attr('angle')
        speed=inner.xpath("//GroundSpeed").attr('kmPerHour')
            
      xml.send('trkpt', lat: lat, lon: lon) {
        xml.ele msl
        xml.time date
        xml.speed speed
      } 
    end
  }
}
end
#Save GPX file
File.open("output.gpx", 'w') { |file| file.write(builder.to_xml) } 
