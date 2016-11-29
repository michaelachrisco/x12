#--
#     This file is part of the X12Parser library that provides tools to
#     manipulate X12 messages using Ruby native syntax.
#
#     http://x12parser.rubyforge.org
#
#     Copyright (C) 2012 P&D Technical Solutions, LLC.
#
#     This library is free software; you can redistribute it and/or
#     modify it under the terms of the GNU Lesser General Public
#     License as published by the Free Software Foundation; either
#     version 2.1 of the License, or (at your option) any later version.
#
#     This library is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#     Lesser General Public License for more details.
#
#     You should have received a copy of the GNU Lesser General Public
#     License along with this library; if not, write to the Free Software
#     Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#++
#
require 'x12'
require 'test/unit'

class Test834Parse < Test::Unit::TestCase

  MESSAGE = "ISA*00*          *00*          *01*9012345720000  *01*9088877320000  *100822*1134*U*00200*000000007*0*T*:~
GS*BE*901234572000*908887732000*20100822*1615*7*X*005010X2220A1~
ST*834*0007*005010X220A1~
INS*Y*18*030*XN*A*E**FT~
REF*OF*152239999~
REF*1L*Blue~
DTP*336*D8*20070101~
NM1*IL*1*BLUTH*LUCILLE****34*152239999~
N3*224 N DES PLAINES*6TH FLOOR~
N4*CHICAGO*IL*60661*USA~
DMG*D8*19720121*F*M~
HD*030**VIS**EMP~
DTP*348*D8*20111016~
INS*N*19*030*XN*A*E***N*N~
REF*OF*152239999~
REF*1L*Blue~
DTP*357*D8*20111015~
NM1*IL*1*BLUTH*BUSTER~
N3*224 N DES PLAINES*6TH FLOOR~
N4*CHICAGO*IL*60661*USA~
DMG*D**19911015*M-HD*030**VIS~
DTP*348*D8*20110101~
DTP*349*D8*20111015~
SE*24*0007~
GE*1*7~
IEA*1*000000007~"

  MESSAGE1 = "ISA*00*          *00*          *01*9012345720000  *01*9088877320000  *100822*1134*U*00200*000000007*0*T*:~
GS*BE*901234572000*908887732000*20100822*1615*7*X*005010X2220A1~
ST*834*0007*005010X220A1~
INS*Y*18*030*XN*A*E**FT~
REF*OF*152239999~
REF*1L*Blue~
DTP*336*D8*20070101~
NM1*IL*1*BLUTH*LUCILLE****34*152239999~
N3*224 N DES PLAINES*6TH FLOOR~
N4*CHICAGO*IL*60661*USA~
DMG*D8*19720121*F*M~
HD*030**VIS**EMP~
DTP*348*D8*20111016~
INS*N*19*030*XN*A*E***N*N~
REF*OF*152239999~
REF*1L*Blue~
DTP*357*D8*20111015~
NM1*IL*1*BLUTH*BUSTER~
N3*224 N DES PLAINES*6TH FLOOR~
N4*CHICAGO*IL*60661*USA~
DMG*D**19911015*M-HD*030**VIS~
DTP*348*D8*20110101~
DTP*349*D8*20111015~
SE*24*0007~
GE*1*7~
IEA*1*000000007~"

  def setup
    # readable format
    @message = MESSAGE
    # make the result usable in the tests
    @message.gsub!(/\n/,'')

    @parser = X12::Parser.new('834.xml')
    @r = @parser.parse('834', @message)

    # second message for testing negatives
    @message1 = MESSAGE1
    @message1.gsub!(/\n/,'')
    @r1 = @parser.parse('834', @message1)
  end

  def teardown
    #nothing
  end

  def test_ISA_IEA
     assert_equal('ISA*00*          *00*          *01*9012345720000  *01*9088877320000  *100822*1134*U*00200*000000007*0*T*:', @r.ISA.to_s)
     assert_equal('5010TEST       ', @r.ISA.InterchangeSenderId)
     assert_equal('1', @r.IEA.NumberOfIncludedFunctionalGroups)
  end # test_ST

  def test_GS_GE
    assert_equal("BE", @r.GS.FunctionalIdentifierCode)
    assert_equal("45920001", @r.GS.GroupControlNumber)
    assert_equal(@r.GS.GroupControlNumber, @r.GE.GroupControlNumber)
  end

  def test_segment_each0
    assert_equal(3, @r.L1000A.PER.size)

    # loop through the PER segment and find the CX record
    @r.L1000A.PER.each do |per|
      if per.ContactFunctionCode == "CX"
        assert_equal("TE", per.CommunicationNumberQualifier1)
      end
    end

    #loop through the PER segment anf find the BL record
    @r.L1000A.PER.each do |per|
      if per.ContactFunctionCode == "BL"
        assert_equal("TE", per.CommunicationNumberQualifier1)
        assert_equal("TECHNICAL CONTACT", per.Name)
        assert_equal("EM", per.CommunicationNumberQualifier2)
        assert_equal("PAYER@PAYER.COM", per.CommunicationNumber2)

      end
    end

    #loop through and find the IC record
    @r.L1000A.PER.each do |per|
      if per.ContactFunctionCode == "IC"
        assert_equal("UR", per.CommunicationNumberQualifier1)
        assert_equal("WWW.PAYER.COM", per.CommunicationNumber1)
      end
    end

  end

  def test_L2000_loop
    assert_equal("1", @r.L2000.LX.AssignedNumber)
    assert_equal("CLP*EDI DENIAL*1*1088*0*1088*HM*CLAIMNUMBER1*21~", @r.L2000.L2100[0].CLP.to_s)
    assert_equal("CLP*EDI PAID*1*100*57.44*30*12*CLAIMNUMBER2*11~", @r.L2000[0].L2100[1].CLP.to_s)
  end


  # def test_negative
  #   # puts @r1.L2000[0].L2100[1].CLP.inspect
  #   assert_equal("-150", @r1.L2000[0].L2100[1].CLP.MonetaryAmount1)
  #   m1 = @r1.L2000[0].L2100[1].CLP.MonetaryAmount1
  #   assert_equal(-150, m1.to_i)
  #
  #   assert_equal("-45", @r1.L2000[0].L2100[1].CLP.MonetaryAmount2)
  #   assert_equal(-45, @r1.L2000[0].L2100[1].CLP.MonetaryAmount2.to_i)
  # end

  # def test_timing
  #   start = Time::now
  #   X12::TEST_REPEAT.times do
  #     @r = @parser.parse('834', @message)
  #   end
  #   finish = Time::now
  #   puts sprintf("Parses per second, 834: %.2f, elapsed: %.1f", X12::TEST_REPEAT.to_f/(finish-start), finish-start)
  # end # test_timing
end
