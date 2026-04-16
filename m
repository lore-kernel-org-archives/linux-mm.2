Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 251EDF433E2
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 05:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B9936B0092; Thu, 16 Apr 2026 01:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 669986B0093; Thu, 16 Apr 2026 01:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F636B0095; Thu, 16 Apr 2026 01:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 441A86B0092
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:20:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD4611A0779
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:20:03 +0000 (UTC)
X-FDA: 84663267486.24.DCAC4C6
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by imf28.hostedemail.com (Postfix) with ESMTP id A1484C0006
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:20:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf28.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776316802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v0PEnlXukZrm7Z+s9KPrQETPAxibKFw1lTW9SYEqsNs=;
	b=r88ANYx7IpuT1XQRsRXWJUaBQvSq34zQNcAb6wdeEjHvZK/tLFBSwjBDabLt5TfZCCI/Py
	vZ54JFDaENwVrEvNFHGgAv3WM/jBSPK12mcm/neMQtPN3WeuxF9ApRnNjSvBUrv4ysAj/o
	HGxn+iG8EGB18qp296XUhcIVVHIafm0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf28.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776316802; a=rsa-sha256;
	cv=none;
	b=s6chFtk6jkWvZT8MolSUHXPcVwcZcq9or6VXOoNTKFkolI5sZBA4T6pdC0glSanDyGEG+3
	TFxuFgJL0mt02aW6yjuskCj43fvhd5p4Y7ZZreo1pn0xtODN2pkmPOE2WdEjIk9M3dROJB
	FovX1YPUGTnt6MwqHI1IEYiT4Xo06Nk=
X-CSE-ConnectionGUID: v/PXY4VhTIWaR96mBjcK3w==
X-CSE-MsgGUID: s58fslSvSIaaNkgbrIB6UA==
X-IronPort-AV: E=Sophos;i="6.23,181,1770566400"; 
   d="scan'208,217";a="146821715"
From: =?gb2312?B?uN/P6A==?= <gaoxiang17@xiaomi.com>
To: Donet Tom <donettom@linux.ibm.com>, Xiang Gao <gxxa03070307@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "vbabka@kernel.org"
	<vbabka@kernel.org>
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
Thread-Index: AQHczVin8cJ6zIqEdk6/BznFxOZCYrXhJpd+
Date: Thu, 16 Apr 2026 05:19:57 +0000
Message-ID: <5456c776468a4cb98fc24fbded24e441@xiaomi.com>
References: <20260416021945.682234-1-gxxa03070307@gmail.com>,<54b0f31f-6720-4e39-a182-ba11948cb024@linux.ibm.com>
In-Reply-To: <54b0f31f-6720-4e39-a182-ba11948cb024@linux.ibm.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.8.163]
Content-Type: multipart/alternative;
	boundary="_000_5456c776468a4cb98fc24fbded24e441xiaomicom_"
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A1484C0006
X-Stat-Signature: u6wuo6ayouoq41ywoznjbd84t9uznkf6
X-HE-Tag: 1776316800-833419
X-HE-Meta: U2FsdGVkX1/nL7VPWpio1geD+8xdHqNdRJljbXutSRL6uWye06SpOXdPrwqnO3hakaaBPjQzV1P55mYzL5wUQ4mhtcShiV0a0FHzWv8VLe4TLAOBGpLLcCfPRH52CEgbpssgwjj5xo4nmPf/aU3FZqJMzrRCjyUZNkGJYVAX5J6n/7JPU1HkT57TqPFIEX0YzTVUnvOlyjbsTqPyINET0f7dvqEh6qx9NebpWrbhpzlDc0ePy96cnkQxgD8+abh/4a7ntdrGn76bjXskHEr2WGi62vMUZOYX2v8b4rF1e8sjrR48cYG0jTHP6SqK8unc1X0ko61yjRxW7i0wnJpSKpZAapcR7TELAV5jkMhBIX7KH6S84h5WNFQ2RQrP5K7dphpneNdzMZ3fRA/voFnydjHIkPOluxRY+WB19SaF5JKImkLZyLRmZepquGaLXdKnLS8cGa0X6lPWgdCFz+eJ4su8cLAVDIgtCCNgsSxFZhZO7cLcaWlkDw71jYQBR0DAOWdBiERvsLmc+rhBRxPpKNoCFqIdyIEFwGBEuYXyBy8ASb1kFB7tfpS4y0akvuVtOGQFJTaSMJd4y2/nVwPMTkS5Zae5o2S5Qv8bffR2TeZkXTdIh3rQrzBbZ0Xx9iVB6Dxzjm8Hkzx+TCQdtd1DJshgYPZ6ALiuoqcCGoEd1AayZzTkKy1s/POYbioqkuAvt+DhDij3Vvk6AJRKsKtJBIznYDFKaGNbpZzr7iaQPcGBVUT2Zeqmz3UEAZaI8UcN+Tju6d+puk21xCwCEE4xE00na/thDZvjk8Abq04CoW34ww+zb3I0CT9KBCyfBuf3uE7pAVc+FkH8BHsN02OhSiNcXq2H3Eiyt3oPz8aUzevqmJEN3f2OGFhzeJiZMmqYSXQFV6NYUH3i+YNeJVxafcevDi7x9ayzI5yC+OcAmBnfvLD6ERzehUJLIdPZOCngPi+7cYVcp2oG57Azc7w
 yrDO7DAH
 uunyoTLKkwEFOuD5qLzYAfUubfdKCPH4m27ap1Kz+DSLU0+yi2Szv8afHRzj9EC0ENNP/2t5TngEFVWjHGy83e2/2fLDk/xk4BV03F0IuRwOW8LI1C1udH3YsvPn8s4BSx5V7rSTCbp0FWTaVAzEbV39X+fiSAXCAjZf56S3nluyFtu62PgdcwTELznEXXqjPOg4ZsJkGRJTMa0pvURxAFxm6s+5gd9g9TQLPb4WIgwSJ5mneKKLXxaZd37B6YLntcD0rSAowiBCZCPh/ySOWyvgj5B+YIh/shcVM/efbIUWPPCnRj/963rdkQwqCHYe/1I3lWkkL7mlwPG9qGjuh/FhbRXmxolI3hoczsWcmBKlX9h037iUoJ8j8WsCdUhCGhytgxfrjYaNsAJuDAtda1Yos/yHxt9Kroej788WuMzTfguXaFofsLjxSfdepRKfHWV+Sr4InAF992wTErL2R/9Otu+e/NKiTHSl5R1+QpM7VKePJr+NuGh+BwtBs1pDbq7LMTmWrNPGQA8sCXPZyRIRYR9s1E7PkE95qtJc8g+d5EVQXZ7maPNBhHES9up1QZTfV8IeCMcRhKXOJgXHgg+CO4obW2TNC39vfQlpoN81AZuyaTfztHU8UZ+r/w/q1fD3cqAVuz7rygbIgWBnXjb+jByElLBj5VjU0CUycS72LmCKFuM4MkUrt3ctHkznZsnjPqAqVTN6WCbZGJPNsJxOl4vCRw58cabkiUB1kh4vVi76Aei5jNTHIzFMNqiHc6PgWWUFKgQpEcFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_5456c776468a4cb98fc24fbded24e441xiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

DQpIaSwNCg0KVGhhbmtzIGZvciBjYXRjaGluZyB0aGlzLiBJJ2xsIGZpeCB0aGUgU2lnbmVkLW9m
Zi1ieSBuYW1lIG1pc21hdGNoIGFuZCBzZW5kIGEgdjIuDQoNCkJlc3QgcmVnYXJkcyxYaWFuZyBH
YW8NCg0KDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0Kt6K8/sjLOiBEb25ldCBU
b20gPGRvbmV0dG9tQGxpbnV4LmlibS5jb20+DQq3osvNyrG85DogMjAyNsTqNNTCMTbI1SAxMjoy
MjoxMQ0KytW8/sjLOiBYaWFuZyBHYW87IGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc7IHZiYWJr
YUBrZXJuZWwub3JnDQqzrcvNOiBzdXJlbmJAZ29vZ2xlLmNvbTsgbWhvY2tvQHN1c2UuY29tOyBq
YWNrbWFuYkBnb29nbGUuY29tOyBoYW5uZXNAY21weGNoZy5vcmc7IHppeUBudmlkaWEuY29tOyBs
aW51eC1tbUBrdmFjay5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7ILjfz+gNCtb3
zOI6IFtFeHRlcm5hbCBNYWlsXVJlOiBbUEFUQ0hdIG1tL3BhZ2VfYWxsb2M6IGZpeCBzcGFjZXMg
dXNlZCBmb3IgaW5kZW50YXRpb24gaW5zdGVhZCBvZiB0YWJzDQoNClvN4rK/08q8/l0gtMvTyrz+
wLTUtNPa0KHD17mry77N4rK/o6zH6733yfe0psDtoaPI9LbU08q8/rCyyKvQ1LTm0smjrMfrvavT
yrz+16q3orj4bWlzZWNAeGlhb21pLmNvbb340NC3tMChDQoNCkhpDQoNCk9uIDQvMTYvMjYgNzo0
OSBBTSwgWGlhbmcgR2FvIHdyb3RlOg0KPiBGcm9tOiBYaWFuZyBHYW8gPGdhb3hpYW5nMTdAeGlh
b21pLmNvbT4NCj4NCj4gY2hlY2twYXRjaC5wbCByZXBvcnRzIHR3byBpbmRlbnRhdGlvbiBlcnJv
cnMgaW4gcGFnZV9hbGxvYy5jIHdoZXJlDQo+IHNwYWNlcyBhcmUgdXNlZCBpbnN0ZWFkIG9mIHRh
YnM6DQo+DQo+ICAgIEVSUk9SOiBjb2RlIGluZGVudCBzaG91bGQgdXNlIHRhYnMgd2hlcmUgcG9z
c2libGUNCj4gICAgIzg4NzogRklMRTogbW0vcGFnZV9hbGxvYy5jOjg4NzoNCj4gICAgKyAgICAg
ICAgVk1fV0FSTl9PTkNFKGdldF9wYWdlYmxvY2tfbWlncmF0ZXR5cGUocGFnZSkgIT0gbWlncmF0
ZXR5cGUsJA0KPg0KPiAgICBFUlJPUjogY29kZSBpbmRlbnQgc2hvdWxkIHVzZSB0YWJzIHdoZXJl
IHBvc3NpYmxlDQo+ICAgICM2NjI2OiBGSUxFOiBtbS9wYWdlX2FsbG9jLmM6NjYyNjoNCj4gICAg
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN5c2N0
bF9taW5fdW5tYXBwZWRfcmF0aW8pIC8gMTAwOyQNCj4NCj4gSW4gX19kZWxfcGFnZV9mcm9tX2Zy
ZWVfbGlzdCgpLCB0aGUgVk1fV0FSTl9PTkNFIGF0IGxpbmUgODg3IHVzZXMgOA0KPiBzcGFjZXMg
Zm9yIGluZGVudGF0aW9uIGluc3RlYWQgb2YgYSB0YWIuIFRoZSBpZGVudGljYWwgVk1fV0FSTl9P
TkNFDQo+IGNhbGxzIGluIF9fYWRkX3RvX2ZyZWVfbGlzdCgpIGFuZCBtb3ZlX3RvX2ZyZWVfbGlz
dCgpIGJvdGggY29ycmVjdGx5DQo+IHVzZSBhIHRhYi4NCj4NCj4gSW4gc2V0dXBfbWluX3VubWFw
cGVkX3JhdGlvKCksIHRoZSBjb250aW51YXRpb24gbGluZSBhdCA2NjI2IHVzZXMgNg0KPiB0YWJz
ICsgOSBzcGFjZXMgZm9yIGFsaWdubWVudC4gUmVwbGFjZSB0aGUgZXhjZXNzIHNwYWNlcyB3aXRo
IDYgdGFicw0KPiArIDEgc3BhY2UgdG8gY29ycmVjdGx5IGFsaWduIHdpdGggdGhlIG9wZW5pbmcg
cGFyZW50aGVzaXMgb24gdGhlDQo+IHByZXZpb3VzIGxpbmUuDQo+DQo+IFNpZ25lZC1vZmYtYnk6
IGdhb3hpYW5nMTcgPGdhb3hpYW5nMTdAeGlhb21pLmNvbT4NCj4NCkkgYW0gc2VlaW5nIGJlbG93
IGlzc3VlIHdpdGggY2hlY2twYXRjaC5wbA0KDQouL3NjcmlwdHMvY2hlY2twYXRjaC5wbCAtLXN0
cmljdA0KMDAwMS1tbS1wYWdlX2FsbG9jLWZpeC1zcGFjZXMtdXNlZC1mb3ItaW5kZW50YXRpb24t
aW5zdGVhLnBhdGNoDQpXQVJOSU5HOiBGcm9tOi9TaWduZWQtb2ZmLWJ5OiBlbWFpbCBuYW1lIG1p
c21hdGNoOiAnRnJvbTogWGlhbmcgR2FvDQo8Z2FveGlhbmcxN0B4aWFvbWkuY29tPicgIT0gJ1Np
Z25lZC1vZmYtYnk6IGdhb3hpYW5nMTcNCjxnYW94aWFuZzE3QHhpYW9taS5jb20+Jw0KDQotRG9u
ZXQNCg0KPiAtLS0NCj4gICBtbS9wYWdlX2FsbG9jLmMgfCA0ICsrLS0NCj4gICAxIGZpbGUgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEv
bW0vcGFnZV9hbGxvYy5jIGIvbW0vcGFnZV9hbGxvYy5jDQo+IGluZGV4IDJkNGI2ZjFhNTU0ZS4u
NzUyNjczYTliNDNjIDEwMDY0NA0KPiAtLS0gYS9tbS9wYWdlX2FsbG9jLmMNCj4gKysrIGIvbW0v
cGFnZV9hbGxvYy5jDQo+IEBAIC04ODQsNyArODg0LDcgQEAgc3RhdGljIGlubGluZSB2b2lkIF9f
ZGVsX3BhZ2VfZnJvbV9mcmVlX2xpc3Qoc3RydWN0IHBhZ2UgKnBhZ2UsIHN0cnVjdCB6b25lICp6
b24NCj4gICB7DQo+ICAgICAgIGludCBucl9wYWdlcyA9IDEgPDwgb3JkZXI7DQo+DQo+IC0gICAg
ICAgIFZNX1dBUk5fT05DRShnZXRfcGFnZWJsb2NrX21pZ3JhdGV0eXBlKHBhZ2UpICE9IG1pZ3Jh
dGV0eXBlLA0KPiArICAgICBWTV9XQVJOX09OQ0UoZ2V0X3BhZ2VibG9ja19taWdyYXRldHlwZShw
YWdlKSAhPSBtaWdyYXRldHlwZSwNCj4gICAgICAgICAgICAgICAgICAgICJwYWdlIHR5cGUgaXMg
JWQsIHBhc3NlZCBtaWdyYXRldHlwZSBpcyAlZCAobnI9JWQpXG4iLA0KPiAgICAgICAgICAgICAg
ICAgICAgZ2V0X3BhZ2VibG9ja19taWdyYXRldHlwZShwYWdlKSwgbWlncmF0ZXR5cGUsIG5yX3Bh
Z2VzKTsNCj4NCj4gQEAgLTY2MjMsNyArNjYyMyw3IEBAIHN0YXRpYyB2b2lkIHNldHVwX21pbl91
bm1hcHBlZF9yYXRpbyh2b2lkKQ0KPg0KPiAgICAgICBmb3JfZWFjaF96b25lKHpvbmUpDQo+ICAg
ICAgICAgICAgICAgem9uZS0+em9uZV9wZ2RhdC0+bWluX3VubWFwcGVkX3BhZ2VzICs9ICh6b25l
X21hbmFnZWRfcGFnZXMoem9uZSkgKg0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgc3lzY3RsX21pbl91bm1hcHBlZF9yYXRpbykgLyAxMDA7
DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3lzY3Rs
X21pbl91bm1hcHBlZF9yYXRpbykgLyAxMDA7DQo+ICAgfQ0KPg0KPg0K

--_000_5456c776468a4cb98fc24fbded24e441xiaomicom_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
</head>
<body dir=3D"ltr">
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;font=
-family:Calibri,Helvetica,sans-serif;" dir=3D"ltr">
<p><br>
</p>
<meta content=3D"text/html; charset=3DUTF-8">
<div dir=3D"ltr">
<div id=3D"x_divtagdefaultwrapper" dir=3D"ltr" style=3D"font-size: 12pt; co=
lor: rgb(0, 0, 0); font-family: Calibri, Helvetica, sans-serif, EmojiFont, =
&quot;Apple Color Emoji&quot;, &quot;Segoe UI Emoji&quot;, NotoColorEmoji, =
&quot;Segoe UI Symbol&quot;, &quot;Android Emoji&quot;, EmojiSymbols;">
<p><span id=3D"x_ms-rterangepaste-start"></span></p>
<div style=3D"font-family:Calibri,Helvetica,sans-serif,serif,EmojiFont; fon=
t-size:16px">
Hi,</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif,serif,EmojiFont; fon=
t-size:16px">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif,serif,EmojiFont; fon=
t-size:16px">
Thanks for catching this. I'll fix the Signed-off-by name mismatch and send=
 a v2.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif,serif,EmojiFont; fon=
t-size:16px">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif,serif,EmojiFont; fon=
t-size:16px">
Best regards,Xiang Gao</div>
<span id=3D"x_ms-rterangepaste-end"></span><br>
<p></p>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" =
color=3D"#000000" style=3D"font-size:11pt"><b>=B7=A2=BC=FE=C8=CB:</b> Donet=
 Tom &lt;donettom@linux.ibm.com&gt;<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2026=C4=EA4=D4=C216=C8=D5 12:22:11<br>
<b>=CA=D5=BC=FE=C8=CB:</b> Xiang Gao; akpm@linux-foundation.org; vbabka@ker=
nel.org<br>
<b>=B3=AD=CB=CD:</b> surenb@google.com; mhocko@suse.com; jackmanb@google.co=
m; hannes@cmpxchg.org; ziy@nvidia.com; linux-mm@kvack.org; linux-kernel@vge=
r.kernel.org; =B8=DF=CF=E8<br>
<b>=D6=F7=CC=E2:</b> [External Mail]Re: [PATCH] mm/page_alloc: fix spaces u=
sed for indentation instead of tabs</font>
<div>&nbsp;</div>
</div>
</div>
<font size=3D"2"><span style=3D"font-size:10pt">
<div class=3D"PlainText">[=CD=E2=B2=BF=D3=CA=BC=FE] =B4=CB=D3=CA=BC=FE=C0=
=B4=D4=B4=D3=DA=D0=A1=C3=D7=B9=AB=CB=BE=CD=E2=B2=BF=A3=AC=C7=EB=BD=F7=C9=F7=
=B4=A6=C0=ED=A1=A3=C8=F4=B6=D4=D3=CA=BC=FE=B0=B2=C8=AB=D0=D4=B4=E6=D2=C9=A3=
=AC=C7=EB=BD=AB=D3=CA=BC=FE=D7=AA=B7=A2=B8=F8misec@xiaomi.com=BD=F8=D0=D0=
=B7=B4=C0=A1<br>
<br>
Hi<br>
<br>
On 4/16/26 7:49 AM, Xiang Gao wrote:<br>
&gt; From: Xiang Gao &lt;gaoxiang17@xiaomi.com&gt;<br>
&gt;<br>
&gt; checkpatch.pl reports two indentation errors in page_alloc.c where<br>
&gt; spaces are used instead of tabs:<br>
&gt;<br>
&gt;&nbsp;&nbsp;&nbsp; ERROR: code indent should use tabs where possible<br=
>
&gt;&nbsp;&nbsp;&nbsp; #887: FILE: mm/page_alloc.c:887:<br>
&gt;&nbsp;&nbsp;&nbsp; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; VM_W=
ARN_ONCE(get_pageblock_migratetype(page) !=3D migratetype,$<br>
&gt;<br>
&gt;&nbsp;&nbsp;&nbsp; ERROR: code indent should use tabs where possible<br=
>
&gt;&nbsp;&nbsp;&nbsp; #6626: FILE: mm/page_alloc.c:6626:<br>
&gt;&nbsp;&nbsp;&nbsp; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
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
&gt;<br>
I am seeing below issue with checkpatch.pl<br>
<br>
./scripts/checkpatch.pl --strict<br>
0001-mm-page_alloc-fix-spaces-used-for-indentation-instea.patch<br>
WARNING: From:/Signed-off-by: email name mismatch: 'From: Xiang Gao<br>
&lt;gaoxiang17@xiaomi.com&gt;' !=3D 'Signed-off-by: gaoxiang17<br>
&lt;gaoxiang17@xiaomi.com&gt;'<br>
<br>
-Donet<br>
<br>
&gt; ---<br>
&gt;&nbsp;&nbsp; mm/page_alloc.c | 4 &#43;&#43;--<br>
&gt;&nbsp;&nbsp; 1 file changed, 2 insertions(&#43;), 2 deletions(-)<br>
&gt;<br>
&gt; diff --git a/mm/page_alloc.c b/mm/page_alloc.c<br>
&gt; index 2d4b6f1a554e..752673a9b43c 100644<br>
&gt; --- a/mm/page_alloc.c<br>
&gt; &#43;&#43;&#43; b/mm/page_alloc.c<br>
&gt; @@ -884,7 &#43;884,7 @@ static inline void __del_page_from_free_list(s=
truct page *page, struct zone *zon<br>
&gt;&nbsp;&nbsp; {<br>
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
&gt;&nbsp;&nbsp; }<br>
&gt;<br>
&gt;<br>
</div>
</span></font></div>
</body>
</html>

--_000_5456c776468a4cb98fc24fbded24e441xiaomicom_--

