Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D43DF433FE
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 06:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 868A36B0005; Thu, 16 Apr 2026 02:48:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8010B6B008A; Thu, 16 Apr 2026 02:48:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 716D66B008C; Thu, 16 Apr 2026 02:48:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6134D6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:48:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00413C1B19
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:48:19 +0000 (UTC)
X-FDA: 84663489960.09.6353AF9
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by imf13.hostedemail.com (Postfix) with ESMTP id 62CE120009
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:48:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776322098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wRsBsu3PPxde9Q4UZ/UDZXrjvMGbc72/BCnOVK4pd7I=;
	b=a14vUf8bAonlOR2AWXD9eRWgYTDzySSZtTAPkQWIvoDRH3GR3fUPs/RHQQ98t669JISJp7
	U1krIr9qrrTaLduM06btfIiDKUe7txxtGxhgH8XQTlkzkOhuO56jfjeZPaqJUjUXF0CqFk
	Fp8WhdsEzn+YbsSh6LCBxWKA9R9hCnA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776322098; a=rsa-sha256;
	cv=none;
	b=hcF0O1qVqpvUGoUQTIDmiM/9dRw6o2BkLmE0KetN5qEG5MFCYvUYfYtbWgQ2/I7aQwQ28O
	VmnAjXhkpvifjIyC5xhb0wu1Lu0kHuSqu6xpctyXPBc6ZiXJ0SOyJxw+NB5n8KnnXUXURS
	kpWwqaXfLY061QsXH1UXhhzJHFWemHk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
X-CSE-ConnectionGUID: wxc+fogXSIOVirraaFfRxQ==
X-CSE-MsgGUID: nsAemFJQQNmgBCQWaQTCtA==
X-IronPort-AV: E=Sophos;i="6.23,181,1770566400"; 
   d="scan'208,217";a="173029610"
From: =?gb2312?B?uN/P6A==?= <gaoxiang17@xiaomi.com>
To: Dev Jain <dev.jain@arm.com>, Xiang Gao <gxxa03070307@gmail.com>, "Andrew
 Morton" <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "donet.tom@gmail.com" <donet.tom@gmail.com>
Subject: =?gb2312?B?tPC4tDogW0V4dGVybmFsIE1haWxdUmU6IFtQQVRDSCB2Ml0gbW0vcGFnZV9h?=
 =?gb2312?B?bGxvYzogZml4IHNwYWNlcyB1c2VkIGZvciBpbmRlbnRhdGlvbiBpbnN0ZWFk?=
 =?gb2312?Q?_of_tabs?=
Thread-Topic: [External Mail]Re: [PATCH v2] mm/page_alloc: fix spaces used for
 indentation instead of tabs
Thread-Index: AQHczWsmgtvV5a4JfUiaaR93D3nOhbXhPqQ2
Date: Thu, 16 Apr 2026 06:48:14 +0000
Message-ID: <e301fb41e3a24915b48334a8a555f5c0@xiaomi.com>
References: <20260416021945.682234-1-gxxa03070307@gmail.com>
 <20260416052752.713821-1-gxxa03070307@gmail.com>,<0eed63fd-4119-44e8-90e9-79bca1620826@arm.com>
In-Reply-To: <0eed63fd-4119-44e8-90e9-79bca1620826@arm.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.88.13]
Content-Type: multipart/alternative;
	boundary="_000_e301fb41e3a24915b48334a8a555f5c0xiaomicom_"
MIME-Version: 1.0
X-Rspamd-Queue-Id: 62CE120009
X-Rspamd-Server: rspam07
X-Stat-Signature: a7enetzm9sxdoaydwtgbmb8rh7rg1odz
X-Rspam-User: 
X-HE-Tag: 1776322096-167129
X-HE-Meta: U2FsdGVkX1+NaVLSRxmO/HRXmdomA1g52saZ/mh4YqJ1NKjtj1MMRaTaWMttnJQ1y9svLkdSfrfalEZXAz4kfdqofFEDVQiPZm9qbUG5bToJYLz9ZXwVjP1s2qBzqyvnVC8Nd2p3uGxY56j1CyqqptH56Z/hivL0Sb9gaxaF91tqAxcS0aejyO3hZ6huoBoiLeCq1BAnR5cvf5RCk+oewnrvtop5Ev6yjWo6AbzUihN6lRXT+Z0sWM+uYDPlj6LAQfF7tgsdLPcIujzwq7/8B8CYnqShfeqm09+BsXcllhEh+jdV2ucKFVptsb6PlDdVn/J8U/RAkeWTcqRl38kqa4pVNjIh3zp3dQeZHSNln1tsQUG1ozX9uf+MRXWTWYOlhpjumSop6EMwtc/iS+06hlg9gvpLFbHKt08vUx70paJbmU6niXaCmrY0j/MQ3evpyW9uIduZlVhH8KZkuNdndaDCSo8BpJevN/oZVD6JDDWMmfMwInmd4g6SL0zSDY0CFcXVq/QfWlLFx+6aSHEfIdDA9rSgy68Jf7tSUsQj1r71HmkR80KSILjGY65Zu3NBoqdTe6tTCp4AP9b8SC/MDl6SggkjQsw9NHLj2/3zpawwJRbzMna/SBfLxhA28G2LCcl4tKiuZ6Yfk3kZvpGOkSRyFiJiNa1pS0a8VBVqFczyRHafEgVHqMczmFbtiA8TUHPSFYgrQz4iI46JLEhDD/1A6e8vujAUot7Hgp0uGXbnUGxEexDm7eyGBZNDZPQ7I/7g7XBg86H6FpgiBfHNpwcqcvv68v/ZJ2LGoIYgMThZknMkN71uWLye8hP2Zoa5VJWcrFTCI31NUAQ9B5ZsRY3/4scTWqildLQD8Anyc34yqgldH/sS6SbIZmlzX4EFr1cDOU7U7Z6mpzmnZwttJyLz7CDCOELFJbIT+gYEJ4PhODkp5sw061OZJOSYfVzETaWkjiXG8lp+NTxe+be
 yWy3QUc2
 GcwB8q+7FbtuIj2R1vXTIwQCzuvw8tvXpMceFUSybvPAk34wb3yxVXEGhGs4VuUqRTXbGhLFCrlF5c6ROnZmgztkDjbFjRP3fy87HpnEHLHcojL3V1f7ya3tbRyJq45Na7oui2fVjMAP1pW6L6iILBRUVmN8l4jOjzpgH8HoQY2MpLzkeilj32ZGJ9OBI2fDUpVBsG59ilFKwUGtJCOOGFWXxbkHc9ofbdjrHgrSFOJu1lEF2W0EKnqRh3rFAD/GGu984frz1d7Gxv6VnTzV2wi+oxTU189jhQpAkmhfg6ODuf0covUrGrRo74iK1aDhpb3j3sY1JV3wes6NYh7KInQOS53I3ssNXT1g5gJJJedKbdpk1TJlj/1acyIMr9GUjmK+4h6l0eMJdY01yUCYy77VS95Ia2F1yOEyxt9R8zjYhOa/4g9E2SKtHbsCS5cbR7JPOtI7ayql4K57DmiVkbcLQuwPkHpTjGOOklRQpEnI1IbMiPXIAVEGZLIzzh3os2aMELpbUkGalf1OPc69LGJG633duoVjpXCZFyvq7e/yVDFjY4JXQEIcQ8qyXIKpIaSAeEnIMUHDO9xwmg6wr37S0FhdIcvd8L4UpMdP5rq5xrr3/5yAt3mSijrCz6dp4H8XUKI2eZS1/XrlloN7v36DU5xtdyyRASkoSlZ2QYJo9iyYNnbsq0hbawnKCmoWwHsEsaohZEQMMrAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_e301fb41e3a24915b48334a8a555f5c0xiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

WW91J3JlIHJpZ2h0LCAiNiB0YWJzICsgOSBzcGFjZXMiIGlzIGVmZmVjdGl2ZWx5ICI3IHRhYnMg
KyAxIHNwYWNlIiBzaW5jZSA4IG9mIHRob3NlIHNwYWNlcyBlcXVhbCBvbmUgdGFiIHdpZHRoLiBU
aGUgZGVzY3JpcHRpb24gaW4gdGhlIGNvbW1pdCBtZXNzYWdlIHNob3VsZCBoYXZlIHBocmFzZWQg
aXQgdGhhdCB3YXkuIFRoZSBhY3R1YWwgY29kZSBjaGFuZ2UgaXMgY29ycmVjdCChqiB0aGUgcmVz
dWx0IGlzIDYgdGFicyArIDEgc3BhY2UgdG8gYWxpZ24gd2l0aCB0aGUgb3BlbmluZyBwYXJlbnRo
ZXNpcyBvbiB0aGUgcHJldmlvdXMgbGluZS4gVGhhbmsgeW91IGZvciB0aGUgcmV2aWV3Lg0KDQoN
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQq3orz+yMs6IERldiBKYWluIDxkZXYu
amFpbkBhcm0uY29tPg0Kt6LLzcqxvOQ6IDIwMjbE6jTUwjE2yNUgMTQ6MzQ6NDINCsrVvP7Iyzog
WGlhbmcgR2FvOyBBbmRyZXcgTW9ydG9uDQqzrcvNOiBsaW51eC1tbUBrdmFjay5vcmc7IGxpbnV4
LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGRvbmV0LnRvbUBnbWFpbC5jb207ILjfz+gNCtb3zOI6
IFtFeHRlcm5hbCBNYWlsXVJlOiBbUEFUQ0ggdjJdIG1tL3BhZ2VfYWxsb2M6IGZpeCBzcGFjZXMg
dXNlZCBmb3IgaW5kZW50YXRpb24gaW5zdGVhZCBvZiB0YWJzDQoNClvN4rK/08q8/l0gtMvTyrz+
wLTUtNPa0KHD17mry77N4rK/o6zH6733yfe0psDtoaPI9LbU08q8/rCyyKvQ1LTm0smjrMfrvavT
yrz+16q3orj4bWlzZWNAeGlhb21pLmNvbb340NC3tMChDQoNCk9uIDE2LzA0LzI2IDEwOjU3IGFt
LCBYaWFuZyBHYW8gd3JvdGU6DQo+IEZyb206IFhpYW5nIEdhbyA8Z2FveGlhbmcxN0B4aWFvbWku
Y29tPg0KPg0KPiBjaGVja3BhdGNoLnBsIHJlcG9ydHMgdHdvIGluZGVudGF0aW9uIGVycm9ycyBp
biBwYWdlX2FsbG9jLmMgd2hlcmUNCj4gc3BhY2VzIGFyZSB1c2VkIGluc3RlYWQgb2YgdGFiczoN
Cj4NCj4gICBFUlJPUjogY29kZSBpbmRlbnQgc2hvdWxkIHVzZSB0YWJzIHdoZXJlIHBvc3NpYmxl
DQo+ICAgIzg4NzogRklMRTogbW0vcGFnZV9hbGxvYy5jOjg4NzoNCj4gICArICAgICAgICBWTV9X
QVJOX09OQ0UoZ2V0X3BhZ2VibG9ja19taWdyYXRldHlwZShwYWdlKSAhPSBtaWdyYXRldHlwZSwk
DQo+DQo+ICAgRVJST1I6IGNvZGUgaW5kZW50IHNob3VsZCB1c2UgdGFicyB3aGVyZSBwb3NzaWJs
ZQ0KPiAgICM2NjI2OiBGSUxFOiBtbS9wYWdlX2FsbG9jLmM6NjYyNjoNCj4gICArICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN5c2N0bF9taW5fdW5t
YXBwZWRfcmF0aW8pIC8gMTAwOyQNCj4NCj4gSW4gX19kZWxfcGFnZV9mcm9tX2ZyZWVfbGlzdCgp
LCB0aGUgVk1fV0FSTl9PTkNFIGF0IGxpbmUgODg3IHVzZXMgOA0KPiBzcGFjZXMgZm9yIGluZGVu
dGF0aW9uIGluc3RlYWQgb2YgYSB0YWIuIFRoZSBpZGVudGljYWwgVk1fV0FSTl9PTkNFDQo+IGNh
bGxzIGluIF9fYWRkX3RvX2ZyZWVfbGlzdCgpIGFuZCBtb3ZlX3RvX2ZyZWVfbGlzdCgpIGJvdGgg
Y29ycmVjdGx5DQo+IHVzZSBhIHRhYi4NCj4NCj4gSW4gc2V0dXBfbWluX3VubWFwcGVkX3JhdGlv
KCksIHRoZSBjb250aW51YXRpb24gbGluZSBhdCA2NjI2IHVzZXMgNg0KPiB0YWJzICsgOSBzcGFj
ZXMgZm9yIGFsaWdubWVudC4gUmVwbGFjZSB0aGUgZXhjZXNzIHNwYWNlcyB3aXRoIDYgdGFicw0K
DQo2IHRhYnMgKyA5IHNwYWNlcyAtPiA3IHRhYnMgKyAxIHNwYWNlLg0KDQoNCj4gKyAxIHNwYWNl
IHRvIGNvcnJlY3RseSBhbGlnbiB3aXRoIHRoZSBvcGVuaW5nIHBhcmVudGhlc2lzIG9uIHRoZQ0K
PiBwcmV2aW91cyBsaW5lLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBYaWFuZyBHYW8gPGdhb3hpYW5n
MTdAeGlhb21pLmNvbT4NCj4gLS0tDQo+ICBtbS9wYWdlX2FsbG9jLmMgfCA0ICsrLS0NCj4gIDEg
ZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYg
LS1naXQgYS9tbS9wYWdlX2FsbG9jLmMgYi9tbS9wYWdlX2FsbG9jLmMNCj4gaW5kZXggMmQ0YjZm
MWE1NTRlLi43NTI2NzNhOWI0M2MgMTAwNjQ0DQo+IC0tLSBhL21tL3BhZ2VfYWxsb2MuYw0KPiAr
KysgYi9tbS9wYWdlX2FsbG9jLmMNCj4gQEAgLTg4NCw3ICs4ODQsNyBAQCBzdGF0aWMgaW5saW5l
IHZvaWQgX19kZWxfcGFnZV9mcm9tX2ZyZWVfbGlzdChzdHJ1Y3QgcGFnZSAqcGFnZSwgc3RydWN0
IHpvbmUgKnpvbg0KPiAgew0KPiAgICAgICBpbnQgbnJfcGFnZXMgPSAxIDw8IG9yZGVyOw0KPg0K
PiAtICAgICAgICBWTV9XQVJOX09OQ0UoZ2V0X3BhZ2VibG9ja19taWdyYXRldHlwZShwYWdlKSAh
PSBtaWdyYXRldHlwZSwNCj4gKyAgICAgVk1fV0FSTl9PTkNFKGdldF9wYWdlYmxvY2tfbWlncmF0
ZXR5cGUocGFnZSkgIT0gbWlncmF0ZXR5cGUsDQo+ICAgICAgICAgICAgICAgICAgICAicGFnZSB0
eXBlIGlzICVkLCBwYXNzZWQgbWlncmF0ZXR5cGUgaXMgJWQgKG5yPSVkKVxuIiwNCj4gICAgICAg
ICAgICAgICAgICAgIGdldF9wYWdlYmxvY2tfbWlncmF0ZXR5cGUocGFnZSksIG1pZ3JhdGV0eXBl
LCBucl9wYWdlcyk7DQo+DQo+IEBAIC02NjIzLDcgKzY2MjMsNyBAQCBzdGF0aWMgdm9pZCBzZXR1
cF9taW5fdW5tYXBwZWRfcmF0aW8odm9pZCkNCj4NCj4gICAgICAgZm9yX2VhY2hfem9uZSh6b25l
KQ0KPiAgICAgICAgICAgICAgIHpvbmUtPnpvbmVfcGdkYXQtPm1pbl91bm1hcHBlZF9wYWdlcyAr
PSAoem9uZV9tYW5hZ2VkX3BhZ2VzKHpvbmUpICoNCj4gLSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN5c2N0bF9taW5fdW5tYXBwZWRfcmF0aW8p
IC8gMTAwOw0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHN5c2N0bF9taW5fdW5tYXBwZWRfcmF0aW8pIC8gMTAwOw0KPiAgfQ0KPg0KPg0KDQo=

--_000_e301fb41e3a24915b48334a8a555f5c0xiaomicom_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<meta name=3D"Generator" content=3D"Microsoft Exchange Server">
<!-- converted from text --><style><!-- .EmailQuote { margin-left: 1pt; pad=
ding-left: 4pt; border-left: #800000 2px solid; } --></style>
</head>
<body>
<meta content=3D"text/html; charset=3DUTF-8">
<style type=3D"text/css" style=3D"">
<!--
p
	{margin-top:0;
	margin-bottom:0}
-->
</style>
<div dir=3D"ltr">
<div id=3D"x_divtagdefaultwrapper" dir=3D"ltr" style=3D"font-size:12pt; col=
or:#000000; font-family:Calibri,Helvetica,sans-serif">
<p></p>
<div>
<div class=3D"x_ace-line x_ace-line x_old-record-id-IQqId0MmzoalaLxzNX1c31q=
Unrh">You're right, &quot;6 tabs &#43; 9 spaces&quot; is effectively &quot;=
7 tabs &#43; 1 space&quot; since 8 of those spaces equal one tab width. The=
 description in the commit message should have phrased it that
 way. The actual code change is correct =A1=AA the result is 6 tabs &#43; 1=
 space to align with the opening parenthesis on the previous line. Thank yo=
u for the review.</div>
</div>
<span class=3D"x_lark-record-clipboard"></span><br>
<p></p>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" =
color=3D"#000000" style=3D"font-size:11pt"><b>=B7=A2=BC=FE=C8=CB:</b> Dev J=
ain &lt;dev.jain@arm.com&gt;<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2026=C4=EA4=D4=C216=C8=D5 14:34:42<br>
<b>=CA=D5=BC=FE=C8=CB:</b> Xiang Gao; Andrew Morton<br>
<b>=B3=AD=CB=CD:</b> linux-mm@kvack.org; linux-kernel@vger.kernel.org; done=
t.tom@gmail.com; =B8=DF=CF=E8<br>
<b>=D6=F7=CC=E2:</b> [External Mail]Re: [PATCH v2] mm/page_alloc: fix space=
s used for indentation instead of tabs</font>
<div>&nbsp;</div>
</div>
</div>
<font size=3D"2"><span style=3D"font-size:10pt;">
<div class=3D"PlainText">[=CD=E2=B2=BF=D3=CA=BC=FE] =B4=CB=D3=CA=BC=FE=C0=
=B4=D4=B4=D3=DA=D0=A1=C3=D7=B9=AB=CB=BE=CD=E2=B2=BF=A3=AC=C7=EB=BD=F7=C9=F7=
=B4=A6=C0=ED=A1=A3=C8=F4=B6=D4=D3=CA=BC=FE=B0=B2=C8=AB=D0=D4=B4=E6=D2=C9=A3=
=AC=C7=EB=BD=AB=D3=CA=BC=FE=D7=AA=B7=A2=B8=F8misec@xiaomi.com=BD=F8=D0=D0=
=B7=B4=C0=A1<br>
<br>
On 16/04/26 10:57 am, Xiang Gao wrote:<br>
&gt; From: Xiang Gao &lt;gaoxiang17@xiaomi.com&gt;<br>
&gt;<br>
&gt; checkpatch.pl reports two indentation errors in page_alloc.c where<br>
&gt; spaces are used instead of tabs:<br>
&gt;<br>
&gt;&nbsp;&nbsp; ERROR: code indent should use tabs where possible<br>
&gt;&nbsp;&nbsp; #887: FILE: mm/page_alloc.c:887:<br>
&gt;&nbsp;&nbsp; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; VM_WARN_ON=
CE(get_pageblock_migratetype(page) !=3D migratetype,$<br>
&gt;<br>
&gt;&nbsp;&nbsp; ERROR: code indent should use tabs where possible<br>
&gt;&nbsp;&nbsp; #6626: FILE: mm/page_alloc.c:6626:<br>
&gt;&nbsp;&nbsp; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; sysctl_min_unmapped_ratio) / 100;$<br>
&gt;<br>
&gt; In __del_page_from_free_list(), the VM_WARN_ONCE at line 887 uses 8<br=
>
&gt; spaces for indentation instead of a tab. The identical VM_WARN_ONCE<br=
>
&gt; calls in __add_to_free_list() and move_to_free_list() both correctly<b=
r>
&gt; use a tab.<br>
&gt;<br>
&gt; In setup_min_unmapped_ratio(), the continuation line at 6626 uses 6<br=
>
&gt; tabs &#43; 9 spaces for alignment. Replace the excess spaces with 6 ta=
bs<br>
<br>
6 tabs &#43; 9 spaces -&gt; 7 tabs &#43; 1 space.<br>
<br>
<br>
&gt; &#43; 1 space to correctly align with the opening parenthesis on the<b=
r>
&gt; previous line.<br>
&gt;<br>
&gt; Signed-off-by: Xiang Gao &lt;gaoxiang17@xiaomi.com&gt;<br>
&gt; ---<br>
&gt;&nbsp; mm/page_alloc.c | 4 &#43;&#43;--<br>
&gt;&nbsp; 1 file changed, 2 insertions(&#43;), 2 deletions(-)<br>
&gt;<br>
&gt; diff --git a/mm/page_alloc.c b/mm/page_alloc.c<br>
&gt; index 2d4b6f1a554e..752673a9b43c 100644<br>
&gt; --- a/mm/page_alloc.c<br>
&gt; &#43;&#43;&#43; b/mm/page_alloc.c<br>
&gt; @@ -884,7 &#43;884,7 @@ static inline void __del_page_from_free_list(s=
truct page *page, struct zone *zon<br>
&gt;&nbsp; {<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int nr_pages =3D 1 &lt;&lt; order;=
<br>
&gt;<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; VM_WARN_ONCE(get_pageblock=
_migratetype(page) !=3D migratetype,<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp; VM_WARN_ONCE(get_pageblock_migratetype(p=
age) !=3D migratetype,<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;page type is %d, passed m=
igratetype is %d (nr=3D%d)\n&quot;,<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; get_pageblock_migratetype(page)=
, migratetype, nr_pages);<br>
&gt;<br>
&gt; @@ -6623,7 &#43;6623,7 @@ static void setup_min_unmapped_ratio(void)<b=
r>
&gt;<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for_each_zone(zone)<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; zone-&gt;zone_pgdat-&gt;min_unmapped_pages &#43;=3D (zone_man=
aged_pages(zone) *<br>
&gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; sysctl_min_unmapped_ratio) / 100;<br>
&gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sysctl_min_unmapped=
_ratio) / 100;<br>
&gt;&nbsp; }<br>
&gt;<br>
&gt;<br>
<br>
</div>
</span></font>
</body>
</html>

--_000_e301fb41e3a24915b48334a8a555f5c0xiaomicom_--

