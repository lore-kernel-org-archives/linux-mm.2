Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53023EC046F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95A4F6B00A6; Tue,  3 Mar 2026 04:22:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931326B00AE; Tue,  3 Mar 2026 04:22:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB6A6B00B4; Tue,  3 Mar 2026 04:22:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 653116B00A6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:22:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 011E71402E7
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:22:25 +0000 (UTC)
X-FDA: 84504211092.22.CAA5CCF
Received: from gateway1.sungrowpower.com (unknown [202.111.193.14])
	by imf19.hostedemail.com (Postfix) with SMTP id 0015C1A0012
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:22:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of liying3@sungrowpower.com designates 202.111.193.14 as permitted sender) smtp.mailfrom=liying3@sungrowpower.com;
	dmarc=pass (policy=quarantine) header.from=sungrowpower.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772529744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references; bh=wgCgsAoIzHeBMnXD3PxHuJ9tRcqaahLwVKqf+CEbko0=;
	b=i91G2tz/RzUdjDrbXb3bT4lRV3eeU2PjVPM8WoDZ/aSuWXyveaEiTczhabiuU76HX/FbuR
	Z0WMpsXTLzqstGFgP/rB1s99+s6JICeJMFpBhWOhCld8IrW7hulsv2gwIRMPE42J6cs8rh
	8h/C6cLlDrBHFD4ZSeQecuWsUELd3PU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of liying3@sungrowpower.com designates 202.111.193.14 as permitted sender) smtp.mailfrom=liying3@sungrowpower.com;
	dmarc=pass (policy=quarantine) header.from=sungrowpower.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772529744; a=rsa-sha256;
	cv=none;
	b=kkitdrVWTt/AWc9C3HTLHH2XEOrQwnv67IrmGcULJBWansDu5SPLwM7eCWvd/vFSwS2ra6
	Fbioj1FgPtFwDekkALhj9YlhdFKnl2pG4xBPCq3BvhH7vdcLRbsjQseYYhzOfi2IVBSLnx
	qLxWk89336bYy5zFmAKGo6SaWTfpajc=
Received: from liying3-L1 (unknown [112.28.154.154])
	by email-gw.sungrowpower.com (MailData Gateway V2.8.8) with ESMTPSA id D72E720C474E2;
	Tue,  3 Mar 2026 17:21:55 +0800 (CST)
Date: Tue, 3 Mar 2026 17:21:55 +0800
X-MD-Sfrom: liying3@sungrowpower.com
X-MD-SrcIP: 112.28.154.154
From: "liying3@sungrowpower.com" <liying3@sungrowpower.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Matthew Wilcox" <willy@infradead.org>
Cc: akpm <akpm@linux-foundation.org>, 
	linux-mm <linux-mm@kvack.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	victor7q <victor7q@163.com>, 
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: Re: [BUG] mm/mempolicy: possible double-unlock in migrate_to_node() on 6.6
References: <2026030310525141773825@sungrowpower.com>, 
	<aaZgUNxAyKC2IwuG@casper.infradead.org>, 
	<f67087f4-d787-43b9-b3fe-7f0d5bb801c4@kernel.org>
X-Priority: 3
X-GUID: 40AEB2D0-C33A-488A-9B0A-AA2F1AAAF0D2
X-Has-Attach: no
X-Mailer: Foxmail 7.2.25.398[cn]
Mime-Version: 1.0
Message-ID: <2026030317215560288527@sungrowpower.com>
Content-Type: multipart/alternative;
	boundary="----=_001_NextPart261848388678_=----"
X-Stat-Signature: ctmg1afyf6b7bj7t7ugjs64wzwx8p5tu
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 0015C1A0012
X-HE-Tag: 1772529742-223644
X-HE-Meta: U2FsdGVkX18uf8jOMExllH78W6zWp8CkZldfCvevdaUCcvViCYhD7KYO6jqybW/jguDjVOVt/Ba5NfCNka4vaRgBjIlH+34vmRJGpPdGb720XoQBTEkDGm3k9CXDNUNYqvTNac2421XHskbbm14BP2dc7dn1yFKy5r+0pg67fhQUtsEJFsxqJG7RgASVqBf+Y5aMDD4E4ys+cnwsnwyigIa8WhJTYsOiO0PZG4hzc/POzafPWQCn0wdLzcCa5enmePLlgPByI4MyVpLR5+p7gGRfHGbX2kqNuokr8lCkkaC4LaJ96Km8dKS4REvizJ1T/4evhh5bxJWIcJ2ULBHYhHXAi8vSgqgIbHhiAedNvYFsW8kyPSoxajQEejZHr1ZL0CsKPEzdGsSTRX8JRb/TLdQt57VX8awy1eH3g2HjkxhkxoDU511EdSXUvDUv6FFc2foOcfGl52nezF9sejhA7RCQuNbbYdjkKfZufJajKXgrOU53JBSvhIZtIijpfwYI3BNUqfQ/oVMdfG1R9y4zTywVsvSMP0rJvpG6tRqOTGbGaYa3suQiqaHTAH37Kk8kiDRc3zAaE59krxKUqWz+wKDbsgZiHFfbBmaZb675tDwUriAve8rkOK7OPCiQj+F8xyMKK0J3254mRvVTfm8zVL6QALE6943qZGdQJA6gLboG0KPSo8qgyglA3bOM0hfLpqoNY3nO2daKHO8Y8RCjU7x4THbHHWZdQ6yXVmG0ezkeBcPsy7hvUOMSvt9cwTXjswbFHnJrGUhDzL4/0NjYmJiKrTU1Fsd5gbIdXUYezVtUJR4rQ35/M+dIh+52EeXiJp2gK4ZPiFogkhs2SbOXosp0f7Gz1cVNuHZ3taRrdxWxloCK0J74aammp5Up0BMrIAT4zT6pHp194kn6r8+R1hjAOuCFsgUbi8SVLiKdffGtqSzh31wKwByzWPDibmXy1m2XScCnK5Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.

------=_001_NextPart261848388678_=----
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: base64

VGhhbmtzIGZvciB5b3VyIGNvbmZpcm0sIHBsZWFzZSBoZWxwIHRvIHByb2Nlc3MgaXQuDQoNCg0K
DQpCZXN0IFJlZ2FyZHMsDQpMaSBZaW5nICwgTGlnaHQgU3RvcmFnZSBHcm91cC4gIFNlbmlvciBF
bWJlZGRlZCBTb2Z0d2FyZSBFbmdpbmVlcg0KVGVsOiAt77ybIEZheDogLQ0KTW9iaWxlOiArODYt
MTU2NTE5NjM5ODENCmxpeWluZzNAc3VuZ3Jvd3Bvd2VyLmNvbSANCnd3dy5zdW5ncm93cG93ZXIu
Y29tDQpTVU5HUk9XIFBPV0VSIFNVUFBMWSBDby4sIEx0ZC4gDQpBZGQ6IE5vLjE2OTkgWGl5b3Ug
UmQuLCBOZXcgJiBIaWdoIFRlY2hub2xvZ3kgSW5kdXN0cmlhbCBEZXZlbG9wbWVudCBab25lLCBI
ZWZlaSwgUC4gUi4gQ2hpbmEuLCAyMzAwODgNCiANCkZyb206IERhdmlkIEhpbGRlbmJyYW5kIChB
cm0pDQpEYXRlOiAyMDI2LTAzLTAzIDE3OjA0DQpUbzogTWF0dGhldyBXaWxjb3g7IGxpeWluZzNA
c3VuZ3Jvd3Bvd2VyLmNvbQ0KQ0M6IGFrcG07IGxpbnV4LW1tOyBsaW51eC1rZXJuZWw7IHZpY3Rv
cjdxOyBHcmVnIEtyb2FoLUhhcnRtYW4NClN1YmplY3Q6IFJlOiBbQlVHXSBtbS9tZW1wb2xpY3k6
IHBvc3NpYmxlIGRvdWJsZS11bmxvY2sgaW4gbWlncmF0ZV90b19ub2RlKCkgb24gNi42DQpPbiAz
LzMvMjYgMDU6MTUsIE1hdHRoZXcgV2lsY294IHdyb3RlOg0KPiBPbiBUdWUsIE1hciAwMywgMjAy
NiBhdCAxMDo1Mjo1MUFNICswODAwLCBsaXlpbmczQHN1bmdyb3dwb3dlci5jb20gd3JvdGU6DQo+
PiBIaSBBbmRyZXcsDQo+Pg0KPj4gSSBmb3VuZCB0aGF0IGEgZml4IGlzIHJlcXVpcmVkIGZvciB0
aGlzIHN1Ym1pc3Npb24gaW4gYnJhbmNoIDYuNi4NCj4+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcv
cHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3N0YWJsZS9saW51eC5naXQvY29tbWl0Lz9pZD1hMTNi
MmI5YjBiMGIwNDYxMmM3ZDgxZTNiM2RmYjQ4NWM1ZjdhYmMzIA0KPiANCj4gQWdyZWVkLCBhbHRo
b3VnaCB5b3VyIGVtYWlsIHNob3VsZCBtb3JlIHByb3Blcmx5IGhhdmUgYmVlbiBkaXJlY3RlZCB0
bw0KPiBEYXZpZCBhbmQgcG9zc2libHkgR3JlZy4gIEFyZSB5b3UgZ29pbmcgdG8gc3VibWl0IGEg
cGF0Y2ggdG8gZml4IHRoaXMsDQo+IG9yIGRvIHlvdSBwcmVmZXIgdGhhdCBzb21lYm9keSBlbHNl
IGRvZXMgaXQ/DQo+IA0KPj4gUmVnYXJkaW5nIHRoZSBkaWZmZXJlbmNlIGJldHdlZW4gYnJhbmNo
ZXMgNi42IGFuZCA2LjEyLCBpbiBicmFuY2ggNi42LCBtbWFwX3JlYWRfbG9jaygpIGFuZCBtbWFw
X3JlYWRfdW5sb2NrKCkgYXJlIGNhbGxlZCBvdXRzaWRlIHRoZSBtaWdyYXRlX3RvX25vZGUoKSBm
dW5jdGlvbi4gDQo+PiBUaGVyZWZvcmUsIG1tYXBfcmVhZF91bmxvY2sobW0pIHNob3VsZCBub3Qg
YmUgaW52b2tlZCBpbnNpZGUgbWlncmF0ZV90b19ub2RlKCk7IG90aGVyd2lzZSwgaXQgd291bGQg
cmVzdWx0IGluIGEgZG91YmxlIHVubG9jayBvZiB0aGUgbW0uDQo+PiBkaWZmIC0tZ2l0IGEvbW0v
bWVtcG9saWN5LmMgYi9tbS9tZW1wb2xpY3kuYw0KPj4gaW5kZXggNTRmMWI3OGQxYjJjMGYuLjk0
Yzc0YzU5NGQxMDJhIDEwMDY0NA0KPj4gLS0tIGEvbW0vbWVtcG9saWN5LmMNCj4+ICsrKyBiL21t
L21lbXBvbGljeS5jDQo+PiBAQCAtMTA3MSw2ICsxMDcxLDEwIEBAIHN0YXRpYyBsb25nIG1pZ3Jh
dGVfdG9fbm9kZShzdHJ1Y3QgbW1fc3RydWN0ICptbSwgaW50IHNvdXJjZSwgaW50IGRlc3QsDQo+
PiBWTV9CVUdfT04oIShmbGFncyAmIChNUE9MX01GX01PVkUgfCBNUE9MX01GX01PVkVfQUxMKSkp
Ow0KPj4gdm1hID0gZmluZF92bWEobW0sIDApOw0KPj4gKyBpZiAodW5saWtlbHkoIXZtYSkpIHsN
Cj4+ICsgbW1hcF9yZWFkX3VubG9jayhtbSk7IC8vIHRoaXMgbGluZSBzaG91bGQgYmUgZGVsZXRl
ZA0KPj4gKyByZXR1cm4gMDsNCj4+ICsgfQ0KIA0KUmlnaHQsIHRoYXQgdW5sb2NrIG11c3QgZ28u
IExldCBtZSBrbm93IGlmIEkgc2hvdWxkIHByZXBhcmUgYSBmaXguDQogDQotLSANCkNoZWVycywN
CiANCkRhdmlkDQo=

------=_001_NextPart261848388678_=----
Content-Type: text/html;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; charse=
t=3DUTF-8"><style>body { line-height: 1.5; }blockquote { margin-top: 0px; =
margin-bottom: 0px; margin-left: 0.5em; }p { margin-top: 0px; margin-botto=
m: 0px; }body { font-size: 14px; font-family: "Microsoft YaHei UI"; color:=
 rgb(0, 0, 0); line-height: 1.5; }</style></head><body>=0A<div><span></spa=
n>Thanks for your confirm, please help to process it.</div>=0A<div><br></d=
iv><hr style=3D"width: 210px; height: 1px;" color=3D"#b5c4df" size=3D"1" a=
lign=3D"left">=0A<div><span><div style=3D"margin: 10px;"><!--[if gte mso 9=
]><xml>=0A <o:OfficeDocumentSettings>=0A  <o:TargetScreenSize>800x600</o:T=
argetScreenSize>=0A </o:OfficeDocumentSettings>=0A</xml><![endif]-->=0A<!-=
-[if gte mso 9]><xml>=0A <w:WordDocument>=0A  <w:View>Normal</w:View>=0A  =
<w:Zoom>0</w:Zoom>=0A  <w:TrackMoves></w:TrackMoves>=0A  <w:TrackFormattin=
g></w:TrackFormatting>=0A  <w:PunctuationKerning></w:PunctuationKerning>=
=0A  <w:DrawingGridVerticalSpacing>7.8 =E7=A3=85</w:DrawingGridVerticalSpa=
cing>=0A  <w:DisplayHorizontalDrawingGridEvery>0</w:DisplayHorizontalDrawi=
ngGridEvery>=0A  <w:DisplayVerticalDrawingGridEvery>2</w:DisplayVerticalDr=
awingGridEvery>=0A  <w:ValidateAgainstSchemas></w:ValidateAgainstSchemas>=
=0A  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>=0A  <w:IgnoreMixedCont=
ent>false</w:IgnoreMixedContent>=0A  <w:AlwaysShowPlaceholderText>false</w=
:AlwaysShowPlaceholderText>=0A  <w:DoNotPromoteQF></w:DoNotPromoteQF>=0A  =
<w:LidThemeOther>EN-US</w:LidThemeOther>=0A  <w:LidThemeAsian>ZH-CN</w:Lid=
ThemeAsian>=0A  <w:LidThemeComplexScript>X-NONE</w:LidThemeComplexScript>=
=0A  <w:Compatibility>=0A   <w:SpaceForUL></w:SpaceForUL>=0A   <w:BalanceS=
ingleByteDoubleByteWidth></w:BalanceSingleByteDoubleByteWidth>=0A   <w:DoN=
otLeaveBackslashAlone></w:DoNotLeaveBackslashAlone>=0A   <w:ULTrailSpace><=
/w:ULTrailSpace>=0A   <w:DoNotExpandShiftReturn></w:DoNotExpandShiftReturn=
>=0A   <w:AdjustLineHeightInTable></w:AdjustLineHeightInTable>=0A   <w:Bre=
akWrappedTables></w:BreakWrappedTables>=0A   <w:SnapToGridInCell></w:SnapT=
oGridInCell>=0A   <w:WrapTextWithPunct></w:WrapTextWithPunct>=0A   <w:UseA=
sianBreakRules></w:UseAsianBreakRules>=0A   <w:DontGrowAutofit></w:DontGro=
wAutofit>=0A   <w:SplitPgBreakAndParaMark></w:SplitPgBreakAndParaMark>=0A =
  <w:EnableOpenTypeKerning></w:EnableOpenTypeKerning>=0A   <w:DontFlipMirr=
orIndents></w:DontFlipMirrorIndents>=0A   <w:OverrideTableStyleHps></w:Ove=
rrideTableStyleHps>=0A   <w:UseFELayout></w:UseFELayout>=0A  </w:Compatibi=
lity>=0A  <w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel>=0A  =
<m:mathPr>=0A   <m:mathFont m:val=3D"Cambria Math"></m:mathFont>=0A   <m:b=
rkBin m:val=3D"before"></m:brkBin>=0A   <m:brkBinSub m:val=3D"&#45;-"></m:=
brkBinSub>=0A   <m:smallFrac m:val=3D"off"></m:smallFrac>=0A   <m:dispDef>=
</m:dispDef>=0A   <m:lMargin m:val=3D"0"></m:lMargin>=0A   <m:rMargin m:va=
l=3D"0"></m:rMargin>=0A   <m:defJc m:val=3D"centerGroup"></m:defJc>=0A   <=
m:wrapIndent m:val=3D"1440"></m:wrapIndent>=0A   <m:intLim m:val=3D"subSup=
"></m:intLim>=0A   <m:naryLim m:val=3D"undOvr"></m:naryLim>=0A  </m:mathPr=
></w:WordDocument>=0A</xml><![endif]--><!--[if gte mso 9]><xml>=0A <w:Late=
ntStyles DefLockedState=3D"false" DefUnhideWhenUsed=3D"false"=0A  DefSemiH=
idden=3D"false" DefQFormat=3D"false" DefPriority=3D"99"=0A  LatentStyleCou=
nt=3D"375">=0A  <w:LsdException Locked=3D"false" Priority=3D"0" QFormat=3D=
"true" Name=3D"Normal"></w:LsdException>=0A  <w:LsdException Locked=3D"fal=
se" Priority=3D"9" QFormat=3D"true" Name=3D"heading 1"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"9" SemiHidden=3D"true"=
=0A   UnhideWhenUsed=3D"true" QFormat=3D"true" Name=3D"heading 2"></w:LsdE=
xception>=0A  <w:LsdException Locked=3D"false" Priority=3D"9" SemiHidden=
=3D"true"=0A   UnhideWhenUsed=3D"true" QFormat=3D"true" Name=3D"heading 3"=
></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"9" Sem=
iHidden=3D"true"=0A   UnhideWhenUsed=3D"true" QFormat=3D"true" Name=3D"hea=
ding 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D=
"9" SemiHidden=3D"true"=0A   UnhideWhenUsed=3D"true" QFormat=3D"true" Name=
=3D"heading 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prio=
rity=3D"9" SemiHidden=3D"true"=0A   UnhideWhenUsed=3D"true" QFormat=3D"tru=
e" Name=3D"heading 6"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" Priority=3D"9" SemiHidden=3D"true"=0A   UnhideWhenUsed=3D"true" QFormat=
=3D"true" Name=3D"heading 7"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"9" SemiHidden=3D"true"=0A   UnhideWhenUsed=3D"true"=
 QFormat=3D"true" Name=3D"heading 8"></w:LsdException>=0A  <w:LsdException=
 Locked=3D"false" Priority=3D"9" SemiHidden=3D"true"=0A   UnhideWhenUsed=
=3D"true" QFormat=3D"true" Name=3D"heading 9"></w:LsdException>=0A  <w:Lsd=
Exception Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A =
  Name=3D"index 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" =
SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"index 2"></w:LsdE=
xception>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideW=
henUsed=3D"true"=0A   Name=3D"index 3"></w:LsdException>=0A  <w:LsdExcepti=
on Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=
=3D"index 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHi=
dden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"index 5"></w:LsdExcepti=
on>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUse=
d=3D"true"=0A   Name=3D"index 6"></w:LsdException>=0A  <w:LsdException Loc=
ked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"ind=
ex 7"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D=
"true" UnhideWhenUsed=3D"true"=0A   Name=3D"index 8"></w:LsdException>=0A =
 <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"tr=
ue"=0A   Name=3D"index 9"></w:LsdException>=0A  <w:LsdException Locked=3D"=
false" Priority=3D"39" SemiHidden=3D"true"=0A   UnhideWhenUsed=3D"true" Na=
me=3D"toc 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priori=
ty=3D"39" SemiHidden=3D"true"=0A   UnhideWhenUsed=3D"true" Name=3D"toc 2">=
</w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"39" Sem=
iHidden=3D"true"=0A   UnhideWhenUsed=3D"true" Name=3D"toc 3"></w:LsdExcept=
ion>=0A  <w:LsdException Locked=3D"false" Priority=3D"39" SemiHidden=3D"tr=
ue"=0A   UnhideWhenUsed=3D"true" Name=3D"toc 4"></w:LsdException>=0A  <w:L=
sdException Locked=3D"false" Priority=3D"39" SemiHidden=3D"true"=0A   Unhi=
deWhenUsed=3D"true" Name=3D"toc 5"></w:LsdException>=0A  <w:LsdException L=
ocked=3D"false" Priority=3D"39" SemiHidden=3D"true"=0A   UnhideWhenUsed=3D=
"true" Name=3D"toc 6"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" Priority=3D"39" SemiHidden=3D"true"=0A   UnhideWhenUsed=3D"true" Name=
=3D"toc 7"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"39" SemiHidden=3D"true"=0A   UnhideWhenUsed=3D"true" Name=3D"toc 8"></=
w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"39" SemiH=
idden=3D"true"=0A   UnhideWhenUsed=3D"true" Name=3D"toc 9"></w:LsdExceptio=
n>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"Normal Indent"></w:LsdException>=0A  <w:LsdExceptio=
n Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=
=3D"footnote text"></w:LsdException>=0A  <w:LsdException Locked=3D"false" =
SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"annotation text">=
</w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true"=
 UnhideWhenUsed=3D"true"=0A   Name=3D"header"></w:LsdException>=0A  <w:Lsd=
Exception Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A =
  Name=3D"footer"></w:LsdException>=0A  <w:LsdException Locked=3D"false" S=
emiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"index heading"></w=
:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"35" SemiHi=
dden=3D"true"=0A   UnhideWhenUsed=3D"true" QFormat=3D"true" Name=3D"captio=
n"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"tr=
ue" UnhideWhenUsed=3D"true"=0A   Name=3D"table of figures"></w:LsdExceptio=
n>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"envelope address"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Nam=
e=3D"envelope return"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"footnote refer=
ence"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D=
"true" UnhideWhenUsed=3D"true"=0A   Name=3D"annotation reference"></w:LsdE=
xception>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideW=
henUsed=3D"true"=0A   Name=3D"line number"></w:LsdException>=0A  <w:LsdExc=
eption Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   N=
ame=3D"page number"></w:LsdException>=0A  <w:LsdException Locked=3D"false"=
 SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"endnote referenc=
e"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"tr=
ue" UnhideWhenUsed=3D"true"=0A   Name=3D"endnote text"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"table of authorities"></w:LsdException>=0A  <w:LsdE=
xception Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A  =
 Name=3D"macro"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Sem=
iHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"toa heading"></w:Lsd=
Exception>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Unhide=
WhenUsed=3D"true"=0A   Name=3D"List"></w:LsdException>=0A  <w:LsdException=
 Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D=
"List Bullet"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiH=
idden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"List Number"></w:LsdEx=
ception>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWh=
enUsed=3D"true"=0A   Name=3D"List 2"></w:LsdException>=0A  <w:LsdException=
 Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D=
"List 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=
=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"List 4"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"List 5"></w:LsdException>=0A  <w:LsdException Locke=
d=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"List =
Bullet 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidde=
n=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"List Bullet 3"></w:LsdExce=
ption>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhen=
Used=3D"true"=0A   Name=3D"List Bullet 4"></w:LsdException>=0A  <w:LsdExce=
ption Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Na=
me=3D"List Bullet 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false=
" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"List Number 2">=
</w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true"=
 UnhideWhenUsed=3D"true"=0A   Name=3D"List Number 3"></w:LsdException>=0A =
 <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"tr=
ue"=0A   Name=3D"List Number 4"></w:LsdException>=0A  <w:LsdException Lock=
ed=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"List=
 Number 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"10" QFormat=3D"true" Name=3D"Title"></w:LsdException>=0A  <w:LsdExcept=
ion Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=
=3D"Closing"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHi=
dden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Signature"></w:LsdExcep=
tion>=0A  <w:LsdException Locked=3D"false" Priority=3D"0" SemiHidden=3D"tr=
ue"=0A   UnhideWhenUsed=3D"true" Name=3D"Default Paragraph Font"></w:LsdEx=
ception>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWh=
enUsed=3D"true"=0A   Name=3D"Body Text"></w:LsdException>=0A  <w:LsdExcept=
ion Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=
=3D"Body Text Indent"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"List Continue"=
></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true=
" UnhideWhenUsed=3D"true"=0A   Name=3D"List Continue 2"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"List Continue 3"></w:LsdException>=0A  <w:LsdExcept=
ion Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=
=3D"List Continue 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false=
" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"List Continue 5=
"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"tru=
e" UnhideWhenUsed=3D"true"=0A   Name=3D"Message Header"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"11" QFormat=3D"true" Nam=
e=3D"Subtitle"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Semi=
Hidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Salutation"></w:LsdEx=
ception>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWh=
enUsed=3D"true"=0A   Name=3D"Date"></w:LsdException>=0A  <w:LsdException L=
ocked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"B=
ody Text First Indent"></w:LsdException>=0A  <w:LsdException Locked=3D"fal=
se" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Body Text Fir=
st Indent 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHi=
dden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Note Heading"></w:LsdEx=
ception>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWh=
enUsed=3D"true"=0A   Name=3D"Body Text 2"></w:LsdException>=0A  <w:LsdExce=
ption Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Na=
me=3D"Body Text 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" =
SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Body Text Indent =
2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"tr=
ue" UnhideWhenUsed=3D"true"=0A   Name=3D"Body Text Indent 3"></w:LsdExcept=
ion>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUs=
ed=3D"true"=0A   Name=3D"Block Text"></w:LsdException>=0A  <w:LsdException=
 Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D=
"Hyperlink"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHid=
den=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"FollowedHyperlink"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"22" QFormat=
=3D"true" Name=3D"Strong"></w:LsdException>=0A  <w:LsdException Locked=3D"=
false" Priority=3D"20" QFormat=3D"true" Name=3D"Emphasis"></w:LsdException=
>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"Document Map"></w:LsdException>=0A  <w:LsdException=
 Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D=
"Plain Text"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHi=
dden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"E-mail Signature"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Unhi=
deWhenUsed=3D"true"=0A   Name=3D"HTML Top of Form"></w:LsdException>=0A  <=
w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true=
"=0A   Name=3D"HTML Bottom of Form"></w:LsdException>=0A  <w:LsdException =
Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"=
Normal (Web)"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiH=
idden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"HTML Acronym"></w:LsdE=
xception>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideW=
henUsed=3D"true"=0A   Name=3D"HTML Address"></w:LsdException>=0A  <w:LsdEx=
ception Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   =
Name=3D"HTML Cite"></w:LsdException>=0A  <w:LsdException Locked=3D"false" =
SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"HTML Code"></w:Ls=
dException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Unhid=
eWhenUsed=3D"true"=0A   Name=3D"HTML Definition"></w:LsdException>=0A  <w:=
LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=
=0A   Name=3D"HTML Keyboard"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"HTML P=
reformatted"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHi=
dden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"HTML Sample"></w:LsdExc=
eption>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhe=
nUsed=3D"true"=0A   Name=3D"HTML Typewriter"></w:LsdException>=0A  <w:LsdE=
xception Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A  =
 Name=3D"HTML Variable"></w:LsdException>=0A  <w:LsdException Locked=3D"fa=
lse" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Normal Table=
"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"tru=
e" UnhideWhenUsed=3D"true"=0A   Name=3D"annotation subject"></w:LsdExcepti=
on>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUse=
d=3D"true"=0A   Name=3D"No List"></w:LsdException>=0A  <w:LsdException Loc=
ked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Out=
line List 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHi=
dden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Outline List 2"></w:Lsd=
Exception>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Unhide=
WhenUsed=3D"true"=0A   Name=3D"Outline List 3"></w:LsdException>=0A  <w:Ls=
dException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A=
   Name=3D"Table Simple 1"></w:LsdException>=0A  <w:LsdException Locked=3D=
"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Sim=
ple 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=
=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Simple 3"></w:LsdExce=
ption>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhen=
Used=3D"true"=0A   Name=3D"Table Classic 1"></w:LsdException>=0A  <w:LsdEx=
ception Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   =
Name=3D"Table Classic 2"></w:LsdException>=0A  <w:LsdException Locked=3D"f=
alse" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Class=
ic 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D=
"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Classic 4"></w:LsdExcept=
ion>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUs=
ed=3D"true"=0A   Name=3D"Table Colorful 1"></w:LsdException>=0A  <w:LsdExc=
eption Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   N=
ame=3D"Table Colorful 2"></w:LsdException>=0A  <w:LsdException Locked=3D"f=
alse" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Color=
ful 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=
=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Columns 1"></w:LsdExc=
eption>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhe=
nUsed=3D"true"=0A   Name=3D"Table Columns 2"></w:LsdException>=0A  <w:LsdE=
xception Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A  =
 Name=3D"Table Columns 3"></w:LsdException>=0A  <w:LsdException Locked=3D"=
false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Colu=
mns 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=
=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Columns 5"></w:LsdExc=
eption>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhe=
nUsed=3D"true"=0A   Name=3D"Table Grid 1"></w:LsdException>=0A  <w:LsdExce=
ption Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Na=
me=3D"Table Grid 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false"=
 SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Grid 3"></=
w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" U=
nhideWhenUsed=3D"true"=0A   Name=3D"Table Grid 4"></w:LsdException>=0A  <w=
:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=
=0A   Name=3D"Table Grid 5"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table =
Grid 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=
=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Grid 7"></w:LsdExcept=
ion>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUs=
ed=3D"true"=0A   Name=3D"Table Grid 8"></w:LsdException>=0A  <w:LsdExcepti=
on Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=
=3D"Table List 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" S=
emiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table List 2"></w:=
LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Unh=
ideWhenUsed=3D"true"=0A   Name=3D"Table List 3"></w:LsdException>=0A  <w:L=
sdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=
=0A   Name=3D"Table List 4"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table =
List 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=
=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table List 6"></w:LsdExcept=
ion>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUs=
ed=3D"true"=0A   Name=3D"Table List 7"></w:LsdException>=0A  <w:LsdExcepti=
on Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=
=3D"Table List 8"></w:LsdException>=0A  <w:LsdException Locked=3D"false" S=
emiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table 3D effects 1=
"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"tru=
e" UnhideWhenUsed=3D"true"=0A   Name=3D"Table 3D effects 2"></w:LsdExcepti=
on>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUse=
d=3D"true"=0A   Name=3D"Table 3D effects 3"></w:LsdException>=0A  <w:LsdEx=
ception Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   =
Name=3D"Table Contemporary"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table =
Elegant"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=
=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Professional"></w:Lsd=
Exception>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Unhide=
WhenUsed=3D"true"=0A   Name=3D"Table Subtle 1"></w:LsdException>=0A  <w:Ls=
dException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A=
   Name=3D"Table Subtle 2"></w:LsdException>=0A  <w:LsdException Locked=3D=
"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Web=
 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"t=
rue" UnhideWhenUsed=3D"true"=0A   Name=3D"Table Web 2"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=
=3D"true"=0A   Name=3D"Table Web 3"></w:LsdException>=0A  <w:LsdException =
Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"=
Balloon Text"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prior=
ity=3D"39" Name=3D"Table Grid"></w:LsdException>=0A  <w:LsdException Locke=
d=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Table=
 Theme"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=
=3D"true" Name=3D"Placeholder Text"></w:LsdException>=0A  <w:LsdException =
Locked=3D"false" Priority=3D"1" QFormat=3D"true" Name=3D"No Spacing"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"60" Name=3D"=
Light Shading"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prio=
rity=3D"61" Name=3D"Light List"></w:LsdException>=0A  <w:LsdException Lock=
ed=3D"false" Priority=3D"62" Name=3D"Light Grid"></w:LsdException>=0A  <w:=
LsdException Locked=3D"false" Priority=3D"63" Name=3D"Medium Shading 1"></=
w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"64" Name=
=3D"Medium Shading 2"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" Priority=3D"65" Name=3D"Medium List 1"></w:LsdException>=0A  <w:LsdExce=
ption Locked=3D"false" Priority=3D"66" Name=3D"Medium List 2"></w:LsdExcep=
tion>=0A  <w:LsdException Locked=3D"false" Priority=3D"67" Name=3D"Medium =
Grid 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D=
"68" Name=3D"Medium Grid 2"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"69" Name=3D"Medium Grid 3"></w:LsdException>=0A  <w=
:LsdException Locked=3D"false" Priority=3D"70" Name=3D"Dark List"></w:LsdE=
xception>=0A  <w:LsdException Locked=3D"false" Priority=3D"71" Name=3D"Col=
orful Shading"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prio=
rity=3D"72" Name=3D"Colorful List"></w:LsdException>=0A  <w:LsdException L=
ocked=3D"false" Priority=3D"73" Name=3D"Colorful Grid"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"60" Name=3D"Light Shadin=
g Accent 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priorit=
y=3D"61" Name=3D"Light List Accent 1"></w:LsdException>=0A  <w:LsdExceptio=
n Locked=3D"false" Priority=3D"62" Name=3D"Light Grid Accent 1"></w:LsdExc=
eption>=0A  <w:LsdException Locked=3D"false" Priority=3D"63" Name=3D"Mediu=
m Shading 1 Accent 1"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" Priority=3D"64" Name=3D"Medium Shading 2 Accent 1"></w:LsdException>=0A=
  <w:LsdException Locked=3D"false" Priority=3D"65" Name=3D"Medium List 1 A=
ccent 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" SemiHidden=
=3D"true" Name=3D"Revision"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"34" QFormat=3D"true"=0A   Name=3D"List Paragraph"><=
/w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"29" QFor=
mat=3D"true" Name=3D"Quote"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"30" QFormat=3D"true"=0A   Name=3D"Intense Quote"></=
w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"66" Name=
=3D"Medium List 2 Accent 1"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"67" Name=3D"Medium Grid 1 Accent 1"></w:LsdExceptio=
n>=0A  <w:LsdException Locked=3D"false" Priority=3D"68" Name=3D"Medium Gri=
d 2 Accent 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prior=
ity=3D"69" Name=3D"Medium Grid 3 Accent 1"></w:LsdException>=0A  <w:LsdExc=
eption Locked=3D"false" Priority=3D"70" Name=3D"Dark List Accent 1"></w:Ls=
dException>=0A  <w:LsdException Locked=3D"false" Priority=3D"71" Name=3D"C=
olorful Shading Accent 1"></w:LsdException>=0A  <w:LsdException Locked=3D"=
false" Priority=3D"72" Name=3D"Colorful List Accent 1"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"73" Name=3D"Colorful Gri=
d Accent 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priorit=
y=3D"60" Name=3D"Light Shading Accent 2"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" Priority=3D"61" Name=3D"Light List Accent 2"></w:Lsd=
Exception>=0A  <w:LsdException Locked=3D"false" Priority=3D"62" Name=3D"Li=
ght Grid Accent 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" =
Priority=3D"63" Name=3D"Medium Shading 1 Accent 2"></w:LsdException>=0A  <=
w:LsdException Locked=3D"false" Priority=3D"64" Name=3D"Medium Shading 2 A=
ccent 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"65" Name=3D"Medium List 1 Accent 2"></w:LsdException>=0A  <w:LsdExcept=
ion Locked=3D"false" Priority=3D"66" Name=3D"Medium List 2 Accent 2"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"67" Name=3D"=
Medium Grid 1 Accent 2"></w:LsdException>=0A  <w:LsdException Locked=3D"fa=
lse" Priority=3D"68" Name=3D"Medium Grid 2 Accent 2"></w:LsdException>=0A =
 <w:LsdException Locked=3D"false" Priority=3D"69" Name=3D"Medium Grid 3 Ac=
cent 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D=
"70" Name=3D"Dark List Accent 2"></w:LsdException>=0A  <w:LsdException Loc=
ked=3D"false" Priority=3D"71" Name=3D"Colorful Shading Accent 2"></w:LsdEx=
ception>=0A  <w:LsdException Locked=3D"false" Priority=3D"72" Name=3D"Colo=
rful List Accent 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false"=
 Priority=3D"73" Name=3D"Colorful Grid Accent 2"></w:LsdException>=0A  <w:=
LsdException Locked=3D"false" Priority=3D"60" Name=3D"Light Shading Accent=
 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"61"=
 Name=3D"Light List Accent 3"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"62" Name=3D"Light Grid Accent 3"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"63" Name=3D"Medium Shadi=
ng 1 Accent 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prio=
rity=3D"64" Name=3D"Medium Shading 2 Accent 3"></w:LsdException>=0A  <w:Ls=
dException Locked=3D"false" Priority=3D"65" Name=3D"Medium List 1 Accent 3=
"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"66" N=
ame=3D"Medium List 2 Accent 3"></w:LsdException>=0A  <w:LsdException Locke=
d=3D"false" Priority=3D"67" Name=3D"Medium Grid 1 Accent 3"></w:LsdExcepti=
on>=0A  <w:LsdException Locked=3D"false" Priority=3D"68" Name=3D"Medium Gr=
id 2 Accent 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prio=
rity=3D"69" Name=3D"Medium Grid 3 Accent 3"></w:LsdException>=0A  <w:LsdEx=
ception Locked=3D"false" Priority=3D"70" Name=3D"Dark List Accent 3"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"71" Name=3D"=
Colorful Shading Accent 3"></w:LsdException>=0A  <w:LsdException Locked=3D=
"false" Priority=3D"72" Name=3D"Colorful List Accent 3"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"73" Name=3D"Colorful Gri=
d Accent 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priorit=
y=3D"60" Name=3D"Light Shading Accent 4"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" Priority=3D"61" Name=3D"Light List Accent 4"></w:Lsd=
Exception>=0A  <w:LsdException Locked=3D"false" Priority=3D"62" Name=3D"Li=
ght Grid Accent 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" =
Priority=3D"63" Name=3D"Medium Shading 1 Accent 4"></w:LsdException>=0A  <=
w:LsdException Locked=3D"false" Priority=3D"64" Name=3D"Medium Shading 2 A=
ccent 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"65" Name=3D"Medium List 1 Accent 4"></w:LsdException>=0A  <w:LsdExcept=
ion Locked=3D"false" Priority=3D"66" Name=3D"Medium List 2 Accent 4"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"67" Name=3D"=
Medium Grid 1 Accent 4"></w:LsdException>=0A  <w:LsdException Locked=3D"fa=
lse" Priority=3D"68" Name=3D"Medium Grid 2 Accent 4"></w:LsdException>=0A =
 <w:LsdException Locked=3D"false" Priority=3D"69" Name=3D"Medium Grid 3 Ac=
cent 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D=
"70" Name=3D"Dark List Accent 4"></w:LsdException>=0A  <w:LsdException Loc=
ked=3D"false" Priority=3D"71" Name=3D"Colorful Shading Accent 4"></w:LsdEx=
ception>=0A  <w:LsdException Locked=3D"false" Priority=3D"72" Name=3D"Colo=
rful List Accent 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false"=
 Priority=3D"73" Name=3D"Colorful Grid Accent 4"></w:LsdException>=0A  <w:=
LsdException Locked=3D"false" Priority=3D"60" Name=3D"Light Shading Accent=
 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"61"=
 Name=3D"Light List Accent 5"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"62" Name=3D"Light Grid Accent 5"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"63" Name=3D"Medium Shadi=
ng 1 Accent 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prio=
rity=3D"64" Name=3D"Medium Shading 2 Accent 5"></w:LsdException>=0A  <w:Ls=
dException Locked=3D"false" Priority=3D"65" Name=3D"Medium List 1 Accent 5=
"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"66" N=
ame=3D"Medium List 2 Accent 5"></w:LsdException>=0A  <w:LsdException Locke=
d=3D"false" Priority=3D"67" Name=3D"Medium Grid 1 Accent 5"></w:LsdExcepti=
on>=0A  <w:LsdException Locked=3D"false" Priority=3D"68" Name=3D"Medium Gr=
id 2 Accent 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prio=
rity=3D"69" Name=3D"Medium Grid 3 Accent 5"></w:LsdException>=0A  <w:LsdEx=
ception Locked=3D"false" Priority=3D"70" Name=3D"Dark List Accent 5"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"71" Name=3D"=
Colorful Shading Accent 5"></w:LsdException>=0A  <w:LsdException Locked=3D=
"false" Priority=3D"72" Name=3D"Colorful List Accent 5"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"73" Name=3D"Colorful Gri=
d Accent 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priorit=
y=3D"60" Name=3D"Light Shading Accent 6"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" Priority=3D"61" Name=3D"Light List Accent 6"></w:Lsd=
Exception>=0A  <w:LsdException Locked=3D"false" Priority=3D"62" Name=3D"Li=
ght Grid Accent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false" =
Priority=3D"63" Name=3D"Medium Shading 1 Accent 6"></w:LsdException>=0A  <=
w:LsdException Locked=3D"false" Priority=3D"64" Name=3D"Medium Shading 2 A=
ccent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"65" Name=3D"Medium List 1 Accent 6"></w:LsdException>=0A  <w:LsdExcept=
ion Locked=3D"false" Priority=3D"66" Name=3D"Medium List 2 Accent 6"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"67" Name=3D"=
Medium Grid 1 Accent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"fa=
lse" Priority=3D"68" Name=3D"Medium Grid 2 Accent 6"></w:LsdException>=0A =
 <w:LsdException Locked=3D"false" Priority=3D"69" Name=3D"Medium Grid 3 Ac=
cent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D=
"70" Name=3D"Dark List Accent 6"></w:LsdException>=0A  <w:LsdException Loc=
ked=3D"false" Priority=3D"71" Name=3D"Colorful Shading Accent 6"></w:LsdEx=
ception>=0A  <w:LsdException Locked=3D"false" Priority=3D"72" Name=3D"Colo=
rful List Accent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false"=
 Priority=3D"73" Name=3D"Colorful Grid Accent 6"></w:LsdException>=0A  <w:=
LsdException Locked=3D"false" Priority=3D"19" QFormat=3D"true"=0A   Name=
=3D"Subtle Emphasis"></w:LsdException>=0A  <w:LsdException Locked=3D"false=
" Priority=3D"21" QFormat=3D"true"=0A   Name=3D"Intense Emphasis"></w:LsdE=
xception>=0A  <w:LsdException Locked=3D"false" Priority=3D"31" QFormat=3D"=
true"=0A   Name=3D"Subtle Reference"></w:LsdException>=0A  <w:LsdException=
 Locked=3D"false" Priority=3D"32" QFormat=3D"true"=0A   Name=3D"Intense Re=
ference"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"33" QFormat=3D"true" Name=3D"Book Title"></w:LsdException>=0A  <w:LsdE=
xception Locked=3D"false" Priority=3D"37" SemiHidden=3D"true"=0A   UnhideW=
henUsed=3D"true" Name=3D"Bibliography"></w:LsdException>=0A  <w:LsdExcepti=
on Locked=3D"false" Priority=3D"39" SemiHidden=3D"true"=0A   UnhideWhenUse=
d=3D"true" QFormat=3D"true" Name=3D"TOC Heading"></w:LsdException>=0A  <w:=
LsdException Locked=3D"false" Priority=3D"41" Name=3D"Plain Table 1"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"42" Name=3D"=
Plain Table 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prio=
rity=3D"43" Name=3D"Plain Table 3"></w:LsdException>=0A  <w:LsdException L=
ocked=3D"false" Priority=3D"44" Name=3D"Plain Table 4"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"45" Name=3D"Plain Table =
5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"40" =
Name=3D"Grid Table Light"></w:LsdException>=0A  <w:LsdException Locked=3D"=
false" Priority=3D"46" Name=3D"Grid Table 1 Light"></w:LsdException>=0A  <=
w:LsdException Locked=3D"false" Priority=3D"47" Name=3D"Grid Table 2"></w:=
LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"48" Name=3D=
"Grid Table 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prio=
rity=3D"49" Name=3D"Grid Table 4"></w:LsdException>=0A  <w:LsdException Lo=
cked=3D"false" Priority=3D"50" Name=3D"Grid Table 5 Dark"></w:LsdException=
>=0A  <w:LsdException Locked=3D"false" Priority=3D"51" Name=3D"Grid Table =
6 Colorful"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priorit=
y=3D"52" Name=3D"Grid Table 7 Colorful"></w:LsdException>=0A  <w:LsdExcept=
ion Locked=3D"false" Priority=3D"46"=0A   Name=3D"Grid Table 1 Light Accen=
t 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"47=
" Name=3D"Grid Table 2 Accent 1"></w:LsdException>=0A  <w:LsdException Loc=
ked=3D"false" Priority=3D"48" Name=3D"Grid Table 3 Accent 1"></w:LsdExcept=
ion>=0A  <w:LsdException Locked=3D"false" Priority=3D"49" Name=3D"Grid Tab=
le 4 Accent 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Prio=
rity=3D"50" Name=3D"Grid Table 5 Dark Accent 1"></w:LsdException>=0A  <w:L=
sdException Locked=3D"false" Priority=3D"51"=0A   Name=3D"Grid Table 6 Col=
orful Accent 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Pri=
ority=3D"52"=0A   Name=3D"Grid Table 7 Colorful Accent 1"></w:LsdException=
>=0A  <w:LsdException Locked=3D"false" Priority=3D"46"=0A   Name=3D"Grid T=
able 1 Light Accent 2"></w:LsdException>=0A  <w:LsdException Locked=3D"fal=
se" Priority=3D"47" Name=3D"Grid Table 2 Accent 2"></w:LsdException>=0A  <=
w:LsdException Locked=3D"false" Priority=3D"48" Name=3D"Grid Table 3 Accen=
t 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"49=
" Name=3D"Grid Table 4 Accent 2"></w:LsdException>=0A  <w:LsdException Loc=
ked=3D"false" Priority=3D"50" Name=3D"Grid Table 5 Dark Accent 2"></w:LsdE=
xception>=0A  <w:LsdException Locked=3D"false" Priority=3D"51"=0A   Name=
=3D"Grid Table 6 Colorful Accent 2"></w:LsdException>=0A  <w:LsdException =
Locked=3D"false" Priority=3D"52"=0A   Name=3D"Grid Table 7 Colorful Accent=
 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"46"=
=0A   Name=3D"Grid Table 1 Light Accent 3"></w:LsdException>=0A  <w:LsdExc=
eption Locked=3D"false" Priority=3D"47" Name=3D"Grid Table 2 Accent 3"></w=
:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"48" Name=
=3D"Grid Table 3 Accent 3"></w:LsdException>=0A  <w:LsdException Locked=3D=
"false" Priority=3D"49" Name=3D"Grid Table 4 Accent 3"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"50" Name=3D"Grid Table 5=
 Dark Accent 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Pri=
ority=3D"51"=0A   Name=3D"Grid Table 6 Colorful Accent 3"></w:LsdException=
>=0A  <w:LsdException Locked=3D"false" Priority=3D"52"=0A   Name=3D"Grid T=
able 7 Colorful Accent 3"></w:LsdException>=0A  <w:LsdException Locked=3D"=
false" Priority=3D"46"=0A   Name=3D"Grid Table 1 Light Accent 4"></w:LsdEx=
ception>=0A  <w:LsdException Locked=3D"false" Priority=3D"47" Name=3D"Grid=
 Table 2 Accent 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" =
Priority=3D"48" Name=3D"Grid Table 3 Accent 4"></w:LsdException>=0A  <w:Ls=
dException Locked=3D"false" Priority=3D"49" Name=3D"Grid Table 4 Accent 4"=
></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"50" Na=
me=3D"Grid Table 5 Dark Accent 4"></w:LsdException>=0A  <w:LsdException Lo=
cked=3D"false" Priority=3D"51"=0A   Name=3D"Grid Table 6 Colorful Accent 4=
"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"52"=
=0A   Name=3D"Grid Table 7 Colorful Accent 4"></w:LsdException>=0A  <w:Lsd=
Exception Locked=3D"false" Priority=3D"46"=0A   Name=3D"Grid Table 1 Light=
 Accent 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"47" Name=3D"Grid Table 2 Accent 5"></w:LsdException>=0A  <w:LsdExcepti=
on Locked=3D"false" Priority=3D"48" Name=3D"Grid Table 3 Accent 5"></w:Lsd=
Exception>=0A  <w:LsdException Locked=3D"false" Priority=3D"49" Name=3D"Gr=
id Table 4 Accent 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false=
" Priority=3D"50" Name=3D"Grid Table 5 Dark Accent 5"></w:LsdException>=0A=
  <w:LsdException Locked=3D"false" Priority=3D"51"=0A   Name=3D"Grid Table=
 6 Colorful Accent 5"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" Priority=3D"52"=0A   Name=3D"Grid Table 7 Colorful Accent 5"></w:LsdExc=
eption>=0A  <w:LsdException Locked=3D"false" Priority=3D"46"=0A   Name=3D"=
Grid Table 1 Light Accent 6"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"47" Name=3D"Grid Table 2 Accent 6"></w:LsdException=
>=0A  <w:LsdException Locked=3D"false" Priority=3D"48" Name=3D"Grid Table =
3 Accent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priorit=
y=3D"49" Name=3D"Grid Table 4 Accent 6"></w:LsdException>=0A  <w:LsdExcept=
ion Locked=3D"false" Priority=3D"50" Name=3D"Grid Table 5 Dark Accent 6"><=
/w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"51"=0A  =
 Name=3D"Grid Table 6 Colorful Accent 6"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" Priority=3D"52"=0A   Name=3D"Grid Table 7 Colorful A=
ccent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"46" Name=3D"List Table 1 Light"></w:LsdException>=0A  <w:LsdException =
Locked=3D"false" Priority=3D"47" Name=3D"List Table 2"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"48" Name=3D"List Table 3=
"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"49" N=
ame=3D"List Table 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false=
" Priority=3D"50" Name=3D"List Table 5 Dark"></w:LsdException>=0A  <w:LsdE=
xception Locked=3D"false" Priority=3D"51" Name=3D"List Table 6 Colorful"><=
/w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"52" Name=
=3D"List Table 7 Colorful"></w:LsdException>=0A  <w:LsdException Locked=3D=
"false" Priority=3D"46"=0A   Name=3D"List Table 1 Light Accent 1"></w:LsdE=
xception>=0A  <w:LsdException Locked=3D"false" Priority=3D"47" Name=3D"Lis=
t Table 2 Accent 1"></w:LsdException>=0A  <w:LsdException Locked=3D"false"=
 Priority=3D"48" Name=3D"List Table 3 Accent 1"></w:LsdException>=0A  <w:L=
sdException Locked=3D"false" Priority=3D"49" Name=3D"List Table 4 Accent 1=
"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"50" N=
ame=3D"List Table 5 Dark Accent 1"></w:LsdException>=0A  <w:LsdException L=
ocked=3D"false" Priority=3D"51"=0A   Name=3D"List Table 6 Colorful Accent =
1"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"52"=
=0A   Name=3D"List Table 7 Colorful Accent 1"></w:LsdException>=0A  <w:Lsd=
Exception Locked=3D"false" Priority=3D"46"=0A   Name=3D"List Table 1 Light=
 Accent 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"47" Name=3D"List Table 2 Accent 2"></w:LsdException>=0A  <w:LsdExcepti=
on Locked=3D"false" Priority=3D"48" Name=3D"List Table 3 Accent 2"></w:Lsd=
Exception>=0A  <w:LsdException Locked=3D"false" Priority=3D"49" Name=3D"Li=
st Table 4 Accent 2"></w:LsdException>=0A  <w:LsdException Locked=3D"false=
" Priority=3D"50" Name=3D"List Table 5 Dark Accent 2"></w:LsdException>=0A=
  <w:LsdException Locked=3D"false" Priority=3D"51"=0A   Name=3D"List Table=
 6 Colorful Accent 2"></w:LsdException>=0A  <w:LsdException Locked=3D"fals=
e" Priority=3D"52"=0A   Name=3D"List Table 7 Colorful Accent 2"></w:LsdExc=
eption>=0A  <w:LsdException Locked=3D"false" Priority=3D"46"=0A   Name=3D"=
List Table 1 Light Accent 3"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"47" Name=3D"List Table 2 Accent 3"></w:LsdException=
>=0A  <w:LsdException Locked=3D"false" Priority=3D"48" Name=3D"List Table =
3 Accent 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priorit=
y=3D"49" Name=3D"List Table 4 Accent 3"></w:LsdException>=0A  <w:LsdExcept=
ion Locked=3D"false" Priority=3D"50" Name=3D"List Table 5 Dark Accent 3"><=
/w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"51"=0A  =
 Name=3D"List Table 6 Colorful Accent 3"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" Priority=3D"52"=0A   Name=3D"List Table 7 Colorful A=
ccent 3"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=
=3D"46"=0A   Name=3D"List Table 1 Light Accent 4"></w:LsdException>=0A  <w=
:LsdException Locked=3D"false" Priority=3D"47" Name=3D"List Table 2 Accent=
 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"48"=
 Name=3D"List Table 3 Accent 4"></w:LsdException>=0A  <w:LsdException Lock=
ed=3D"false" Priority=3D"49" Name=3D"List Table 4 Accent 4"></w:LsdExcepti=
on>=0A  <w:LsdException Locked=3D"false" Priority=3D"50" Name=3D"List Tabl=
e 5 Dark Accent 4"></w:LsdException>=0A  <w:LsdException Locked=3D"false" =
Priority=3D"51"=0A   Name=3D"List Table 6 Colorful Accent 4"></w:LsdExcept=
ion>=0A  <w:LsdException Locked=3D"false" Priority=3D"52"=0A   Name=3D"Lis=
t Table 7 Colorful Accent 4"></w:LsdException>=0A  <w:LsdException Locked=
=3D"false" Priority=3D"46"=0A   Name=3D"List Table 1 Light Accent 5"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"47" Name=3D"=
List Table 2 Accent 5"></w:LsdException>=0A  <w:LsdException Locked=3D"fal=
se" Priority=3D"48" Name=3D"List Table 3 Accent 5"></w:LsdException>=0A  <=
w:LsdException Locked=3D"false" Priority=3D"49" Name=3D"List Table 4 Accen=
t 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"50=
" Name=3D"List Table 5 Dark Accent 5"></w:LsdException>=0A  <w:LsdExceptio=
n Locked=3D"false" Priority=3D"51"=0A   Name=3D"List Table 6 Colorful Acce=
nt 5"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"5=
2"=0A   Name=3D"List Table 7 Colorful Accent 5"></w:LsdException>=0A  <w:L=
sdException Locked=3D"false" Priority=3D"46"=0A   Name=3D"List Table 1 Lig=
ht Accent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"false" Priori=
ty=3D"47" Name=3D"List Table 2 Accent 6"></w:LsdException>=0A  <w:LsdExcep=
tion Locked=3D"false" Priority=3D"48" Name=3D"List Table 3 Accent 6"></w:L=
sdException>=0A  <w:LsdException Locked=3D"false" Priority=3D"49" Name=3D"=
List Table 4 Accent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"fal=
se" Priority=3D"50" Name=3D"List Table 5 Dark Accent 6"></w:LsdException>=
=0A  <w:LsdException Locked=3D"false" Priority=3D"51"=0A   Name=3D"List Ta=
ble 6 Colorful Accent 6"></w:LsdException>=0A  <w:LsdException Locked=3D"f=
alse" Priority=3D"52"=0A   Name=3D"List Table 7 Colorful Accent 6"></w:Lsd=
Exception>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Unhide=
WhenUsed=3D"true"=0A   Name=3D"Mention"></w:LsdException>=0A  <w:LsdExcept=
ion Locked=3D"false" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=
=3D"Smart Hyperlink"></w:LsdException>=0A  <w:LsdException Locked=3D"false=
" SemiHidden=3D"true" UnhideWhenUsed=3D"true"=0A   Name=3D"Hashtag"></w:Ls=
dException>=0A  <w:LsdException Locked=3D"false" SemiHidden=3D"true" Unhid=
eWhenUsed=3D"true"=0A   Name=3D"Unresolved Mention"></w:LsdException>=0A <=
/w:LatentStyles>=0A</xml><![endif]-->=0A<!--[if gte mso 10]>=0A<style>=0A =
/* Style Definitions */=0A table.MsoNormalTable=0A	{mso-style-name:=E6=99=
=AE=E9=80=9A=E8=A1=A8=E6=A0=BC;=0A	mso-tstyle-rowband-size:0;=0A	mso-tstyl=
e-colband-size:0;=0A	mso-style-noshow:yes;=0A	mso-style-priority:99;=0A	ms=
o-style-parent:"";=0A	mso-padding-alt:0cm 5.4pt 0cm 5.4pt;=0A	mso-para-mar=
gin:0cm;=0A	mso-para-margin-bottom:.0001pt;=0A	mso-pagination:widow-orphan=
;=0A	font-size:10.0pt;=0A	font-family:"Times New Roman",serif;}=0A</style>=
=0A<![endif]-->=0A<!--StartFragment-->=0A<p class=3D"MsoNormal" style=3D"m=
argin: 0cm 0cm 0.0001pt; line-height: 16pt; background-image: initial; bac=
kground-position: initial; background-size: initial; background-repeat: in=
itial; background-attachment: initial; background-origin: initial; backgro=
und-clip: initial; text-align: justify;"><font color=3D"#969696" face=3D"A=
rial, sans-serif"><span style=3D"font-size: 12px;">Best Regards,</span></f=
ont></p><p class=3D"MsoNormal" style=3D"margin: 0cm 0cm 0.0001pt; line-hei=
ght: 16pt; background-image: initial; background-position: initial; backgr=
ound-size: initial; background-repeat: initial; background-attachment: ini=
tial; background-origin: initial; background-clip: initial; text-align: ju=
stify;"><font color=3D"#969696" face=3D"Arial, sans-serif"><span style=3D"=
font-size: 12px;">Li Ying , Light Storage Group.&nbsp; Senior Embedded Sof=
tware Engineer</span></font></p><p class=3D"MsoNormal" style=3D"margin: 0c=
m 0cm 0.0001pt; line-height: 16pt; background-image: initial; background-p=
osition: initial; background-size: initial; background-repeat: initial; ba=
ckground-attachment: initial; background-origin: initial; background-clip:=
 initial; text-align: justify;"><font color=3D"#969696" face=3D"Arial, san=
s-serif"><span style=3D"font-size: 12px;">Tel: -=EF=BC=9B Fax: -</span></f=
ont></p><p class=3D"MsoNormal" style=3D"margin: 0cm 0cm 0.0001pt; line-hei=
ght: 16pt; background-image: initial; background-position: initial; backgr=
ound-size: initial; background-repeat: initial; background-attachment: ini=
tial; background-origin: initial; background-clip: initial; text-align: ju=
stify;"><font color=3D"#969696" face=3D"Arial, sans-serif"><span style=3D"=
font-size: 12px;">Mobile: +86-15651963981</span></font></p><p class=3D"Mso=
Normal" style=3D"margin: 0cm 0cm 0.0001pt; line-height: 16pt; background-i=
mage: initial; background-position: initial; background-size: initial; bac=
kground-repeat: initial; background-attachment: initial; background-origin=
: initial; background-clip: initial; text-align: justify;"><font color=3D"=
#969696" face=3D"Arial, sans-serif"><span style=3D"font-size: 12px;">liyin=
g3@sungrowpower.com&nbsp;</span></font></p><p class=3D"MsoNormal" style=3D=
"margin: 0cm 0cm 0.0001pt; line-height: 16pt; background-image: initial; b=
ackground-position: initial; background-size: initial; background-repeat: =
initial; background-attachment: initial; background-origin: initial; backg=
round-clip: initial; text-align: justify;"><font color=3D"#969696" face=3D=
"Arial, sans-serif"><span style=3D"font-size: 12px;">www.sungrowpower.com<=
/span></font></p><p class=3D"MsoNormal" style=3D"margin: 0cm 0cm 0.0001pt;=
 line-height: 16pt; background-image: initial; background-position: initia=
l; background-size: initial; background-repeat: initial; background-attach=
ment: initial; background-origin: initial; background-clip: initial; text-=
align: justify;"><font color=3D"#969696" face=3D"Arial, sans-serif"><span =
style=3D"font-size: 12px;">SUNGROW POWER SUPPLY Co., Ltd.&nbsp;</span></fo=
nt></p><p class=3D"MsoNormal" style=3D"margin: 0cm 0cm 0.0001pt; line-heig=
ht: 16pt; background-image: initial; background-position: initial; backgro=
und-size: initial; background-repeat: initial; background-attachment: init=
ial; background-origin: initial; background-clip: initial; text-align: jus=
tify;"><font color=3D"#969696" face=3D"Arial, sans-serif"><span style=3D"f=
ont-size: 12px;">Add: No.1699 Xiyou Rd., New &amp; High Technology Industr=
ial Development Zone, Hefei, P. R. China., 230088</span></font></p><p clas=
s=3D"MsoNormal" align=3D"left" style=3D"font-size: 10.5pt; font-family: &q=
uot;Times New Roman&quot;, serif; margin: 0cm 0cm 0.0001pt; text-align: ju=
stify; line-height: 15pt;"><!--EndFragment--></p></div></span></div>=0A<bl=
ockquote style=3D"margin-Top: 0px; margin-Bottom: 0px; margin-Left: 0.5em;=
 margin-Right: inherit"><div>&nbsp;</div><div style=3D"border:none;border-=
top:solid #B5C4DF 1.0pt;padding:3.0pt 0cm 0cm 0cm"><div style=3D"PADDING-R=
IGHT: 8px; PADDING-LEFT: 8px; FONT-SIZE: 12px;FONT-FAMILY:tahoma;COLOR:#00=
0000; BACKGROUND: #efefef; PADDING-BOTTOM: 8px; PADDING-TOP: 8px"><div><b>=
From:</b>&nbsp;<a href=3D"mailto:david@kernel.org">David Hildenbrand (Arm)=
</a></div><div><b>Date:</b>&nbsp;2026-03-03&nbsp;17:04</div><div><b>To:</b=
>&nbsp;<a href=3D"mailto:willy@infradead.org">Matthew Wilcox</a>; <a href=
=3D"mailto:liying3@sungrowpower.com">liying3@sungrowpower.com</a></div><di=
v><b>CC:</b>&nbsp;<a href=3D"mailto:akpm@linux-foundation.org">akpm</a>; <=
a href=3D"mailto:linux-mm@kvack.org">linux-mm</a>; <a href=3D"mailto:linux=
-kernel@vger.kernel.org">linux-kernel</a>; <a href=3D"mailto:victor7q@163.=
com">victor7q</a>; <a href=3D"mailto:gregkh@linuxfoundation.org">Greg Kroa=
h-Hartman</a></div><div><b>Subject:</b>&nbsp;Re: [BUG] mm/mempolicy: possi=
ble double-unlock in migrate_to_node() on 6.6</div></div></div><div><div>O=
n 3/3/26 05:15, Matthew Wilcox wrote:</div>=0A<div>&gt; On Tue, Mar 03, 20=
26 at 10:52:51AM +0800, liying3@sungrowpower.com wrote:</div>=0A<div>&gt;&=
gt; Hi Andrew,</div>=0A<div>&gt;&gt;</div>=0A<div>&gt;&gt; I found that a =
fix is required for this submission in branch 6.6.</div>=0A<div>&gt;&gt; h=
ttps://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=
=3Da13b2b9b0b0b04612c7d81e3b3dfb485c5f7abc3 </div>=0A<div>&gt; </div>=0A<d=
iv>&gt; Agreed, although your email should more properly have been directe=
d to</div>=0A<div>&gt; David and possibly Greg.&nbsp; Are you going to sub=
mit a patch to fix this,</div>=0A<div>&gt; or do you prefer that somebody =
else does it?</div>=0A<div>&gt; </div>=0A<div>&gt;&gt; Regarding the diffe=
rence between branches 6.6 and 6.12, in branch 6.6, mmap_read_lock() and m=
map_read_unlock() are called outside the migrate_to_node() function. </div=
>=0A<div>&gt;&gt; Therefore, mmap_read_unlock(mm) should not be invoked in=
side migrate_to_node(); otherwise, it would result in a double unlock of t=
he mm.</div>=0A<div>&gt;&gt; diff --git a/mm/mempolicy.c b/mm/mempolicy.c<=
/div>=0A<div>&gt;&gt; index 54f1b78d1b2c0f..94c74c594d102a 100644</div>=0A=
<div>&gt;&gt; --- a/mm/mempolicy.c</div>=0A<div>&gt;&gt; +++ b/mm/mempolic=
y.c</div>=0A<div>&gt;&gt; @@ -1071,6 +1071,10 @@ static long migrate_to_no=
de(struct mm_struct *mm, int source, int dest,</div>=0A<div>&gt;&gt; VM_BU=
G_ON(!(flags &amp; (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)));</div>=0A<div>&gt;&=
gt; vma =3D find_vma(mm, 0);</div>=0A<div>&gt;&gt; + if (unlikely(!vma)) {=
</div>=0A<div>&gt;&gt; + mmap_read_unlock(mm); // this line should be dele=
ted</div>=0A<div>&gt;&gt; + return 0;</div>=0A<div>&gt;&gt; + }</div>=0A<d=
iv>&nbsp;</div>=0A<div>Right, that unlock must go. Let me know if I should=
 prepare a fix.</div>=0A<div>&nbsp;</div>=0A<div>-- </div>=0A<div>Cheers,<=
/div>=0A<div>&nbsp;</div>=0A<div>David</div>=0A</div></blockquote>=0A</bod=
y></html>
------=_001_NextPart261848388678_=------
david@kernel.org;willy@infradead.org;akpm@linux-foundation.org;linux-mm@kvack.org;linux-kernel@vger.kernel.org;victor7q@163.com;gregkh@linuxfoundation.org;

