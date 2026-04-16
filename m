Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 932FCF88073
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 06:52:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10A76B0005; Thu, 16 Apr 2026 02:52:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC0A46B0089; Thu, 16 Apr 2026 02:52:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6946B008A; Thu, 16 Apr 2026 02:52:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE84D6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:52:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 71B3E1A05B0
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:52:04 +0000 (UTC)
X-FDA: 84663499368.04.C95031F
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by imf19.hostedemail.com (Postfix) with ESMTP id C4F841A000B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:52:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776322322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AodDOuHKaW/dnRlYdgj0BWvKBMcKpCstH7rwz/AJuaA=;
	b=rmll0zsvhI4Cnv0TkCf2lO5k3WgI8kn4AoEQlIUqrLYBJMQy6L/U6bBwh+NWWHAvVOH5wd
	GrRIg/9cv71beQMpDNuIOpMB5dqk6JF0j8v2zSe/lzDopOUjEPPHGgOlaLk7gDVCLIhvVv
	NAhdKDXsboYa662YwLNefOZm4w64+Gw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776322322; a=rsa-sha256;
	cv=none;
	b=Hv5RQllpBwE3bVOMVsFpt/kqrWoqIgYDnve+BLtlwwg0MUJ/Oi4clgkYfiP2aDnqpEDvD7
	fVpY8otLZ0fFV1gJnrMBM4zdSsSHCBNIzuxqdLpJFTZYjTHjQ4lq007lcJffNTqdifFKfv
	t4xjlX/pmiCfNbttWJpjdVC2/8lWEhU=
X-CSE-ConnectionGUID: hddVRI67RSaNY4fFggLQWg==
X-CSE-MsgGUID: N6ycaVZlTuSG4shGufmQFw==
X-IronPort-AV: E=Sophos;i="6.23,181,1770566400"; 
   d="scan'208,217";a="146833258"
From: =?gb2312?B?uN/P6A==?= <gaoxiang17@xiaomi.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Xiang Gao
	<gxxa03070307@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>
CC: "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
	<mhocko@suse.com>, "jackmanb@google.com" <jackmanb@google.com>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW0V4dGVybmFsIE1haWxdUmU6IFtQQVRDSF0gbW0vcGFnZV9hbGxv?=
 =?gb2312?B?YzogZml4IHNwYWNlcyB1c2VkIGZvciBpbmRlbnRhdGlvbiBpbnN0ZWFkIG9m?=
 =?gb2312?Q?_tabs?=
Thread-Topic: [External Mail]Re: [PATCH] mm/page_alloc: fix spaces used for
 indentation instead of tabs
Thread-Index: AQHczWv0LlrNGEw6ZU62cIxLQ8YBorXhP9eL
Date: Thu, 16 Apr 2026 06:51:59 +0000
Message-ID: <e1d5f34930ce42acbf16c8bf20b641e5@xiaomi.com>
References: <20260416021945.682234-1-gxxa03070307@gmail.com>,<0a578026-3bc8-480d-8992-c27c3496e15b@kernel.org>
In-Reply-To: <0a578026-3bc8-480d-8992-c27c3496e15b@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.88.13]
Content-Type: multipart/alternative;
	boundary="_000_e1d5f34930ce42acbf16c8bf20b641e5xiaomicom_"
MIME-Version: 1.0
X-Stat-Signature: 93ek9o8st3dpta8azyg4woid4eo4k4rn
X-Rspamd-Queue-Id: C4F841A000B
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776322321-316173
X-HE-Meta: U2FsdGVkX19jS/85SWgJMCDSINKo44Veim6U011MtBhu5kfe1E1+Um80LKJTZoyzjTk3Y5Z2cCsiIMsKfbsrrs3Jo0PFZ/qwgus/6DPF3U/7TFr3IheIDR9ur/RtnNN3+QHDLHqw2Q4FaO8O2pTShnpDUfiCKV8YHT6sqqM8Ez8TpKJgv5YXcx675O02E45A8rfWJInaqNqC9UN6qhuDrEdaDIbPvUcAl9IzfkClHAxPsA+HzJ1/jLd0Qf8LLFG7Bm4+zGvN4LQB1csK3yn13uhndZYvkukKmUhKvEJlesCb1iWSa06isRVTqDchuF5o46H3+KBzzV5lpND9BC6yglY2rO/I0EJpVCoT/L88pxQUPeTf58jQc2oeManXoQ+uzjrjTCHmsEbcgQaczgOLhHCBzLttJ3hZgdhbNviyaav7XimPElXiNg+jui3l57BIUG3GYv7ZW2csSGn3BsJucEKyreev+J/HD4TZTkA8Z7R0XUZpuCUh57fvkvgg7s1TL3wdLr4u6pMdlxRqxhfCWqQZ68LCnxXmH9pChhlMSyO13nU738IM1j30dPLjiX4vb3cY1Tzqo1FE8jRpNd8Eit3Tb+FdPZHOugNjV8RfmmtHvLuMvMUpbGrYrCFa6e4/ZRlci6NnJq4V94Y/i7DQ0gX4X2vEfnpKQw/TkaYgfWeSRpn4VZivZxgkbqG2pOnVRtZJ8fgFBOuZm4MzdxlaPIWZj99JOPZRd05SygGR/LxwHYxYjI9Eo9ns6Y29WFZwz+FyR7ZFG5A62A8a+gXnluQOQbEN17nZy9KsWaLOdqLB/tCoZeltbsTSOLTJVipDpE30EkXHkkYT6yNi02IfOr4eMWe7xWGmtNmi4NoInY18CgCLW090HMVwDW55llG9PU8H/5pMFxX2SWTsBzlWXi4DAJAktRLLsfQT4ntU8egEScQKeaqpAuKPZRQgQzbzXnzXK3+PuUiaKgp3r3A
 gRoJlkB9
 3IIvmB7ZuPCEE2aW6CCf+myK/ki8byPPwHmjanaphjOsE1lLjQPouetfLulFNg/c6h+1LFCQ0xhLY9M8mxI1cZgxOxYqslOWRR6xXZ7Z89v0VsuSGmV2/y4lI+T8Y/U5uTPbze/fTLaUAiZwJ951UByDqvGLCnnWazxk6fVGDWvevs+RSJaV2o1nKUReQe0prqqD9RJPn4xPkfzPsOCwyfRUtX6Y0aW3p1Vkl+0Pv+p1PiO1o9kgs5bzzpp13fEagQTbPtly/TXCEWmHGPtFqsK/btuLO1lLr2Ow+E1xrD7f+OC2MgYRJuLo8LZJrUUBYQevok965Zzv5ZAlZD5hYqfXh5HY3ecovSEuEGuWoSkOmCIxMiBmdZNoC04B6dhXYvH872B5Z3fxTqUJn6pALPLNAnoD/1YRyAya0XyRTqi+PspD6aklRn25WMsHFtvgxXGuvTDiVYRDPdfMNgud+WoBRTgI5ZS5QVPTkDzjORT5s/zsUEX17npFrE69z2+AX9wxdJDGjurTMoDYqYizxRwsUTbTkodfHDlT02KMLdUHju9hKl/l50h2W1meaVmrIM3Wk3x3O1qrcCgLTJHj/36Ky2fv5gaAnD8IDAxv2qeYlPL9/lRAkCzj53Qqneir3YcbWfP9OnKF6hUf0ynkWIKpbUQBl4Gq4hdZq7FQCzfxcR2CgbkJDhAT2uGlwPmdO8BWb7bTWNhYCRHU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_e1d5f34930ce42acbf16c8bf20b641e5xiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

VGhhbmsgeW91IGZvciB0aGUgZmVlZGJhY2suIEkgdW5kZXJzdGFuZCChqiBjaGVja3BhdGNoIHNo
b3VsZCBvbmx5IGJlIHVzZWQgb24gcGF0Y2hlcywgbm90IHRvIGZpbmQgYW5kIGZpeCBwcmUtZXhp
c3Rpbmcgc3R5bGUgaXNzdWVzIGluIGV4aXN0aW5nIGNvZGUuIEknbGwga2VlcCB0aGlzIGluIG1p
bmQgZm9yIGZ1dHVyZSBzdWJtaXNzaW9ucy4gU29ycnkgZm9yIHRoZSBub2lzZS4NCg0KX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18NCreivP7IyzogVmxhc3RpbWlsIEJhYmthIChTVVNF
KSA8dmJhYmthQGtlcm5lbC5vcmc+DQq3osvNyrG85DogMjAyNsTqNNTCMTbI1SAxNDo0MDozMQ0K
ytW8/sjLOiBYaWFuZyBHYW87IGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcNCrOty806IHN1cmVu
YkBnb29nbGUuY29tOyBtaG9ja29Ac3VzZS5jb207IGphY2ttYW5iQGdvb2dsZS5jb207IGhhbm5l
c0BjbXB4Y2hnLm9yZzsgeml5QG52aWRpYS5jb207IGxpbnV4LW1tQGt2YWNrLm9yZzsgbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZzsguN/P6A0K1vfM4jogW0V4dGVybmFsIE1haWxdUmU6IFtQ
QVRDSF0gbW0vcGFnZV9hbGxvYzogZml4IHNwYWNlcyB1c2VkIGZvciBpbmRlbnRhdGlvbiBpbnN0
ZWFkIG9mIHRhYnMNCg0KW83isr/Tyrz+XSC0y9PKvP7AtNS009rQocPXuavLvs3isr+jrMfrvffJ
97SmwO2ho8j0ttTTyrz+sLLIq9DUtObSyaOsx+u9q9PKvP7XqreiuPhtaXNlY0B4aWFvbWkuY29t
vfjQ0Le0wKENCg0KT24gNC8xNi8yNiAwNDoxOSwgWGlhbmcgR2FvIHdyb3RlOg0KPiBGcm9tOiBY
aWFuZyBHYW8gPGdhb3hpYW5nMTdAeGlhb21pLmNvbT4NCj4NCj4gY2hlY2twYXRjaC5wbCByZXBv
cnRzIHR3byBpbmRlbnRhdGlvbiBlcnJvcnMgaW4gcGFnZV9hbGxvYy5jIHdoZXJlDQo+IHNwYWNl
cyBhcmUgdXNlZCBpbnN0ZWFkIG9mIHRhYnM6DQoNCmNoZWNrcGF0Y2ggc2hvdWxkIG5vdCBiZSB1
c2VkIG9uIGV4aXN0aW5nIHNvdXJjZSBmaWxlcywgb25seSBvbiBwYXRjaGVzDQpjaGFuZ2luZyB0
aGVtIGZvciBhbm90aGVyIHJlYXNvbi4gVGhlcmUgYXJlIG1hbnkgcHJlLWV4aXN0aW5nIHRoaW5n
cyB0aGF0DQp3b3VsZCBiZSBmbGFnZ2VkIGFuZCB3ZSBkb24ndCB3YW50IHRoZSBjaHVybi4gU28g
d2Ugb25seSB1c2UgY2hlY2twYXRjaCB0bw0KYXZvaWQgaW50cm9kdWNpbmcgbmV3IG1pc3Rha2Vz
LCBhbmQgb25seSBmaXggdGhlIHByZS1leGlzdGluZyBvbmVzIHdoZW4NCmNoYW5naW5nIHRoZSBj
b2RlIGZvciBhbm90aGVyIHJlYXNvbi4NCg0KPiAgIEVSUk9SOiBjb2RlIGluZGVudCBzaG91bGQg
dXNlIHRhYnMgd2hlcmUgcG9zc2libGUNCj4gICAjODg3OiBGSUxFOiBtbS9wYWdlX2FsbG9jLmM6
ODg3Og0KPiAgICsgICAgICAgIFZNX1dBUk5fT05DRShnZXRfcGFnZWJsb2NrX21pZ3JhdGV0eXBl
KHBhZ2UpICE9IG1pZ3JhdGV0eXBlLCQNCj4NCj4gICBFUlJPUjogY29kZSBpbmRlbnQgc2hvdWxk
IHVzZSB0YWJzIHdoZXJlIHBvc3NpYmxlDQo+ICAgIzY2MjY6IEZJTEU6IG1tL3BhZ2VfYWxsb2Mu
Yzo2NjI2Og0KPiAgICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgc3lzY3RsX21pbl91bm1hcHBlZF9yYXRpbykgLyAxMDA7JA0KPg0KPiBJbiBfX2Rl
bF9wYWdlX2Zyb21fZnJlZV9saXN0KCksIHRoZSBWTV9XQVJOX09OQ0UgYXQgbGluZSA4ODcgdXNl
cyA4DQo+IHNwYWNlcyBmb3IgaW5kZW50YXRpb24gaW5zdGVhZCBvZiBhIHRhYi4gVGhlIGlkZW50
aWNhbCBWTV9XQVJOX09OQ0UNCj4gY2FsbHMgaW4gX19hZGRfdG9fZnJlZV9saXN0KCkgYW5kIG1v
dmVfdG9fZnJlZV9saXN0KCkgYm90aCBjb3JyZWN0bHkNCj4gdXNlIGEgdGFiLg0KPg0KPiBJbiBz
ZXR1cF9taW5fdW5tYXBwZWRfcmF0aW8oKSwgdGhlIGNvbnRpbnVhdGlvbiBsaW5lIGF0IDY2MjYg
dXNlcyA2DQo+IHRhYnMgKyA5IHNwYWNlcyBmb3IgYWxpZ25tZW50LiBSZXBsYWNlIHRoZSBleGNl
c3Mgc3BhY2VzIHdpdGggNiB0YWJzDQo+ICsgMSBzcGFjZSB0byBjb3JyZWN0bHkgYWxpZ24gd2l0
aCB0aGUgb3BlbmluZyBwYXJlbnRoZXNpcyBvbiB0aGUNCj4gcHJldmlvdXMgbGluZS4NCj4NCj4g
U2lnbmVkLW9mZi1ieTogZ2FveGlhbmcxNyA8Z2FveGlhbmcxN0B4aWFvbWkuY29tPg0KPiAtLS0N
Cj4gIG1tL3BhZ2VfYWxsb2MuYyB8IDQgKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4NCj4gZGlmZiAtLWdpdCBhL21tL3BhZ2VfYWxsb2Mu
YyBiL21tL3BhZ2VfYWxsb2MuYw0KPiBpbmRleCAyZDRiNmYxYTU1NGUuLjc1MjY3M2E5YjQzYyAx
MDA2NDQNCj4gLS0tIGEvbW0vcGFnZV9hbGxvYy5jDQo+ICsrKyBiL21tL3BhZ2VfYWxsb2MuYw0K
PiBAQCAtODg0LDcgKzg4NCw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBfX2RlbF9wYWdlX2Zyb21f
ZnJlZV9saXN0KHN0cnVjdCBwYWdlICpwYWdlLCBzdHJ1Y3Qgem9uZSAqem9uDQo+ICB7DQo+ICAg
ICAgIGludCBucl9wYWdlcyA9IDEgPDwgb3JkZXI7DQo+DQo+IC0gICAgICAgIFZNX1dBUk5fT05D
RShnZXRfcGFnZWJsb2NrX21pZ3JhdGV0eXBlKHBhZ2UpICE9IG1pZ3JhdGV0eXBlLA0KPiArICAg
ICBWTV9XQVJOX09OQ0UoZ2V0X3BhZ2VibG9ja19taWdyYXRldHlwZShwYWdlKSAhPSBtaWdyYXRl
dHlwZSwNCj4gICAgICAgICAgICAgICAgICAgICJwYWdlIHR5cGUgaXMgJWQsIHBhc3NlZCBtaWdy
YXRldHlwZSBpcyAlZCAobnI9JWQpXG4iLA0KPiAgICAgICAgICAgICAgICAgICAgZ2V0X3BhZ2Vi
bG9ja19taWdyYXRldHlwZShwYWdlKSwgbWlncmF0ZXR5cGUsIG5yX3BhZ2VzKTsNCj4NCj4gQEAg
LTY2MjMsNyArNjYyMyw3IEBAIHN0YXRpYyB2b2lkIHNldHVwX21pbl91bm1hcHBlZF9yYXRpbyh2
b2lkKQ0KPg0KPiAgICAgICBmb3JfZWFjaF96b25lKHpvbmUpDQo+ICAgICAgICAgICAgICAgem9u
ZS0+em9uZV9wZ2RhdC0+bWluX3VubWFwcGVkX3BhZ2VzICs9ICh6b25lX21hbmFnZWRfcGFnZXMo
em9uZSkgKg0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgc3lzY3RsX21pbl91bm1hcHBlZF9yYXRpbykgLyAxMDA7DQo+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3lzY3RsX21pbl91bm1hcHBlZF9y
YXRpbykgLyAxMDA7DQo+ICB9DQo+DQo+DQoNCg==

--_000_e1d5f34930ce42acbf16c8bf20b641e5xiaomicom_
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
<div class=3D"x_ace-line x_ace-line x_old-record-id-CkWCd1zxToQKxHx26WVcApx=
Cnwd">Thank you for the feedback. I understand =A1=AA checkpatch should onl=
y be used on patches, not to find and fix pre-existing style issues in exis=
ting code. I'll keep this in mind for future
 submissions. Sorry for the noise.</div>
</div>
<p></p>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" =
color=3D"#000000" style=3D"font-size:11pt"><b>=B7=A2=BC=FE=C8=CB:</b> Vlast=
imil Babka (SUSE) &lt;vbabka@kernel.org&gt;<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2026=C4=EA4=D4=C216=C8=D5 14:40:31<br>
<b>=CA=D5=BC=FE=C8=CB:</b> Xiang Gao; akpm@linux-foundation.org<br>
<b>=B3=AD=CB=CD:</b> surenb@google.com; mhocko@suse.com; jackmanb@google.co=
m; hannes@cmpxchg.org; ziy@nvidia.com; linux-mm@kvack.org; linux-kernel@vge=
r.kernel.org; =B8=DF=CF=E8<br>
<b>=D6=F7=CC=E2:</b> [External Mail]Re: [PATCH] mm/page_alloc: fix spaces u=
sed for indentation instead of tabs</font>
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
On 4/16/26 04:19, Xiang Gao wrote:<br>
&gt; From: Xiang Gao &lt;gaoxiang17@xiaomi.com&gt;<br>
&gt;<br>
&gt; checkpatch.pl reports two indentation errors in page_alloc.c where<br>
&gt; spaces are used instead of tabs:<br>
<br>
checkpatch should not be used on existing source files, only on patches<br>
changing them for another reason. There are many pre-existing things that<b=
r>
would be flagged and we don't want the churn. So we only use checkpatch to<=
br>
avoid introducing new mistakes, and only fix the pre-existing ones when<br>
changing the code for another reason.<br>
<br>
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
&gt; &#43; 1 space to correctly align with the opening parenthesis on the<b=
r>
&gt; previous line.<br>
&gt;<br>
&gt; Signed-off-by: gaoxiang17 &lt;gaoxiang17@xiaomi.com&gt;<br>
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

--_000_e1d5f34930ce42acbf16c8bf20b641e5xiaomicom_--

