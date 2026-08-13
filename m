Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70EE0C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 12:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1246B0253; Thu, 13 Aug 2026 08:48:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862586B0285; Thu, 13 Aug 2026 08:48:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A09C6B0287; Thu, 13 Aug 2026 08:48:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5DA166B0253
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:48:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3991A0102
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:47:53 +0000 (UTC)
X-FDA: 85096223226.01.15B5A9F
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by imf09.hostedemail.com (Postfix) with ESMTP id 070FC14000F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:47:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf09.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786625271;
	b=U2rDaz8x4+Dcz6zCUWAS6jNT53u5RAXCbV+7IRnrOsz/Ec4Ge+kSaUd9jBwRs4cF4DG9i1
	/ZwWWfUGVaW7vRa3zqsk7FV99QUxOfn9PldZiJW/8rm07uA91nzckQ3CAAJzSrWyFxk8LV
	32rEy5lo1dQhaaxBrLVHc3aAx25ylQo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf09.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786625271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pBl4fnEad2veb9GwA+Oq2e1FTTCRDdbhX8m/rSQrPv0=;
	b=ObmnCMxKLcQtZlDrhXXGHsXwaZnkUqUNG0DhvoGVwMtJyrt66LIeAIOso7RGScRJUeiOYa
	PeEjH5aAdQD3q2YKS/wO8nmTu2XvQCO9C8+YNyj74fzJGgogx/m0mUaLA1jGbELMHCo/4j
	8Nt0Pblg68C++/TZ/Q65p3QJYIBLvaQ=
X-CSE-ConnectionGUID: c5621pPWRM6wYrLjDcR13g==
X-CSE-MsgGUID: Na/adh9sRPqCsXDWisqs8w==
X-IronPort-AV: E=Sophos;i="6.25,221,1779120000"; 
   d="scan'208,217";a="159198204"
From: =?gb2312?B?uN/P6A==?= <gaoxiang17@xiaomi.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Xiang Gao <gxxa03070307@gmail.com>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lorenzo Stoakes <ljs@kernel.org>, gao xu <gaoxu2@honor.com>,
	=?gb2312?B?06G0sw==?= <yinchuang1@xiaomi.com>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: =?gb2312?B?tPC4tDogW0V4dGVybmFsIE1haWxdUmU6IFtSRkNdIHRyYWNpbmc6IGFnZ3Jl?=
 =?gb2312?Q?gate_ring-buffer_usage_statistics?=
Thread-Topic: [External Mail]Re: [RFC] tracing: aggregate ring-buffer usage
 statistics
Thread-Index: AQHdKZr3AIp7eq0PuUyEknsvZXxszLaaZZoy//+kuACAAeZA1w==
Date: Thu, 13 Aug 2026 12:47:44 +0000
Message-ID: <d5bb28119dbb4ff1ab1059bb2564ad29@xiaomi.com>
References: <20260811114818.1449933-1-gaoxiang17@xiaomi.com>
	<20260811100830.7976bbe8@gandalf.local.home>
	<cd441eb194d54265b1bf9ab659716c45@xiaomi.com>,<20260812114704.2f61bc5a@gandalf.local.home>
In-Reply-To: <20260812114704.2f61bc5a@gandalf.local.home>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.88.13]
Content-Type: multipart/alternative;
	boundary="_000_d5bb28119dbb4ff1ab1059bb2564ad29xiaomicom_"
MIME-Version: 1.0
X-Rspamd-Queue-Id: 070FC14000F
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: q4y74reqke6uokmd4rinze3pxj94ywt9
X-HE-Tag: 1786625269-562263
X-HE-Meta: U2FsdGVkX19JQDNOK8Fmpyv3ctThx8yTcHN1qWr2ZaM6IQjlaIAFSV4np4D2OUntKwa7WhkN1EgXYRydhlEPBaPFQ8JyD2wQ0+1wU2cOqt8/t23Sj2WX2ypDgYU6SkVYlOGoM8lWlNU1IYqSkjqOYhOrYubsNLxVVRNOiXZSt/AcV/nissEaCn6NjhmUpw9WK/iNUgg8mIFCrzOGqxjLsbuJJvOqAJ6QbD0lUnLo7xNCruximgL7nlzNWex3IMkHC90U1BXobE961NUvfOngndEIbmobtJgL/n+N1Baesa8vls1JCji4cPV9XxEtN+hAdPU+K8vETdMKptDKaR+SMJNMpKnGm7R3G7VVBzzyWlkkUCrSFYQ15yja0ORjzP8yS/xBVJqkC9/89lFThfWLF+lrU6mZ6Eo2HSwcHdIlqgCR8IEcf/s8wSIX6QOXIS5LE321NL1m8F6AWnSaIM5+ZdDgaB9XEGbKJd5JNArCXy8Y9LS+EFUIrOU1sNMuI3kbxF2Qwv7K891XwCONtD0JW0J9aOUwtZi1Wfs2GDF4lTKnWiUZ7WDmT5HCMepcl388WgoIwIYPxvw3c1MqOhlqdHUpDsXY70usA2SMmQ145r6Y8VAera7x9sKDj3z3HxPM7vBn35uy7coDhSD8bHh8g4E43a2+jj3Pht+NIez6EcEDLgo22S8zWsriFnERJ6iHyBUJpXraY51koBV7Gbd6/LAGgSEvvSWQQkBfL6rjvbtvY8rwB9eD7kysSKeydJ4Dqio9jfMJl496Od8oSsvUkdgAflTa0joLzUew9TW+yN3lo40QWaYGQg4QLzVwUS+BjkjcCrQQjo0Bnt09KhXYyGm5PNRbUI4XRV1BVk6bEYyNF1j/AvwiRzDipAMSACq+OtDU1rQMoceDJ/UL9XCWHRBlWNZJWmPpgirRAsprIcQtYqQ9iehBNBZISGu+8bJfWgKvrH4m9UNb14tOS/W
 uav6by+O
 tGaeOhxTgt07J4CIzURBATaJienjwfMwBm5rEFEDJJgc+NH0j922scttr1d5JdLwt4Q6edTRMBrSwNfjh3oIeE0aup4xSWwpmHFlfCSQRAecQCHpaW7dx5xat0orYPbLsBqdDv8HO33p3WoCqR2Q+N/yyiJFDg5sJHC98LyvA07FnxwlV2VjkuXfqCq0rt+yK4Rq1wm603NDQfUfkHywryLER1hIZZi5qUUfm49G/WftyJ/qxrHHfdPsS312ZLx0qyhsKrnmb7M4mkUV2mcMjJYoaOEYIHxSzcLbqVMsquGwnCSt8oGHZuwZA8z5YvHUC3yzvEgcVO6niBNdPlIFGTSTpSgewM7zDXk+kiJp0ri2A2CXpn3vFjbxYxnX0uBAutDdjgrAYGUWFnTlVmt18fnTc0T1u9vC7XKICG8sAn6X5UI9ayjmwOVzFQmy3QZO0RTY8h2Wgt3a8EJ1BZTpki1giOXD8bBrNOfEStXth5nLFzdbOFfVpX80+Vr+koKrZ93OYpt1gUJXs9V4tzhEsini3pAsMnJxYQPgj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_d5bb28119dbb4ff1ab1059bb2564ad29xiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

VGhhbmtzLCBTdGV2ZS4NCg0KVW5kZXJzdG9vZC4NCg0KSSB3aWxsIGFkZDoNCg0KICAvc3lzL2tl
cm5lbC90cmFjaW5nL3RyYWNlX3N0YXRzL3RvdGFsX21lbW9yeV9rYg0KDQpUaGUgZmlsZSB3aWxs
IHJlcG9ydDoNCg0KICB0b3RhbDoNCiAgYnVmZmVyc19tZW06DQogIHNuYXBzaG90X2J1ZmZlcnNf
bWVtOg0KDQpUaGUgdmFsdWVzIHdpbGwgY292ZXIgdGhlIG1haW4gYW5kIHNuYXBzaG90IGJ1ZmZl
cnMgb2YgdGhlIGdsb2JhbCB0cmFjZQ0KYXJyYXkgYW5kIGFsbCB0cmFjaW5nIGluc3RhbmNlcyBh
Y3Jvc3MgYWxsIHRyYWNpbmcgQ1BVcy4NCg0KRm9yIHRoZSBwZXItQ1BVIHZpZXcsIEkgd2lsbCBm
b2xsb3cgdGhlIGV4aXN0aW5nIHRyYWNlZnMgbGF5b3V0IGFuZCBhZGQ6DQoNCiAgL3N5cy9rZXJu
ZWwvdHJhY2luZy90cmFjZV9zdGF0cy9wZXJfY3B1L2NwdU4vdG90YWxfbWVtb3J5X2tiDQoNCkVh
Y2ggcGVyLUNQVSBmaWxlIHdpbGwgcmVwb3J0IG9ubHkgdGhlIGNvcnJlc3BvbmRpbmcgQ1BVJ3Mg
YnVmZmVycw0KYWNyb3NzIHRoZSBnbG9iYWwgdHJhY2UgYXJyYXkgYW5kIGFsbCB0cmFjaW5nIGlu
c3RhbmNlcy4NCg0KVGhhbmtzLA0KWGlhbmcNCg0KDQoNCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fDQq3orz+yMs6IFN0ZXZlbiBSb3N0ZWR0IDxyb3N0ZWR0QGdvb2RtaXMub3JnPg0K
t6LLzcqxvOQ6IDIwMjbE6jjUwjEyyNUgMjM6NDc6MDQNCsrVvP7IyzoguN/P6A0Ks63LzTogWGlh
bmcgR2FvOyBNYXNhbWkgSGlyYW1hdHN1OyBNYXRoaWV1IERlc25veWVyczsgTG9yZW56byBTdG9h
a2VzOyBnYW8geHU7INOhtLM7IGxpbnV4LXRyYWNlLWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxp
bnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZw0K1vfM4jogUmU6
IFtFeHRlcm5hbCBNYWlsXVJlOiBbUkZDXSB0cmFjaW5nOiBhZ2dyZWdhdGUgcmluZy1idWZmZXIg
dXNhZ2Ugc3RhdGlzdGljcw0KDQpbzeKyv9PKvP5dILTL08q8/sC01LTT2tChw9e5q8u+zeKyv6Os
x+u998n3tKbA7aGjyPS21NPKvP6wssir0NS05tLJo6zH672r08q8/teqt6K4+G1pc2VjQHhpYW9t
aS5jb229+NDQt7TAoQ0KDQpPbiBXZWQsIDEyIEF1ZyAyMDI2IDEzOjIxOjI5ICswMDAwDQq438/o
IDxnYW94aWFuZzE3QHhpYW9taS5jb20+IHdyb3RlOg0KDQo+IFRoYW5rcywgU3RldmUuDQo+DQo+
IEZvciB0aGUgaW5pdGlhbCBpbXBsZW1lbnRhdGlvbiwgSSBwbGFuIHRvIGFkZDoNCj4NCj4gICAv
c3lzL2tlcm5lbC90cmFjaW5nL3RyYWNlX3N0YXRzL3RvdGFsX21lbW9yeV9rYg0KPg0KPiBUaGUg
ZmlsZSB3b3VsZCB1c2UgYW4gZXh0ZW5zaWJsZSBrZXkvdmFsdWUgZm9ybWF0LiBJbml0aWFsbHkg
aXQgd291bGQNCj4gcmVwb3J0IHRoZSByaW5nLWJ1ZmZlciBkYXRhIGNhcGFjaXR5Og0KPg0KPiAg
IHRvdGFsOiAgICAgICAgICAgICAgICAgICAzOTU2NjQNCj4gICByaW5nX2J1ZmZlcjogICAgICAg
ICAgICAgMzk1NjY0DQo+ICAgcmluZ19idWZmZXJfbGl2ZTogICAgICAgIDM5NTU0NA0KPiAgIHJp
bmdfYnVmZmVyX3NuYXBzaG90OiAgICAgICAxMjANCg0KWW91IGNhbiByZW5hbWUgdGhlIGFib3Zl
IHRvOg0KDQogICB0b3RhbDoNCiAgIGJ1ZmZlcnNfbWVtOg0KICAgc25hcHNob3RfYnVmZmVyc19t
ZW06DQoNCk5vIG5lZWQgdG8gdXNlICJyaW5nIiBhbmQgaXQga2VlcHMgY29uc2lzdGVudCB3aXRo
ICJidWZmZXJfc2l6ZV9rYiIuDQoNCkkgYWRkZWQgdGhlICJtZW0iIHBhcnQgdG8gZGlzdGluZ3Vp
c2ggdGhlIGRpZmZlcmVuY2UgYmV0d2VlbiB0aGVzZSBudW1iZXJzDQphbmQgdGhlIGJ1ZmZlcl9z
aXplX2tiLCBhcyB0aGVzZSBudW1iZXJzIGFyZSBhYm91dCB0b3RhbCBtZW1vcnkgd2hlcmVhcw0K
dGhlICJidWZmZXJfc2l6ZV9rYiIgaXMgYWJvdXQgdXNhYmxlIG1lbW9yeS4NCg0KVGhlcmUncyBh
bHJlYWR5IGEgdG90YWwgZm9yIGFsbCBtZW1vcnkgbGlzdGVkLiBXZSBkb24ndCBuZWVkIHRvIGhh
dmUgYQ0KdG90YWwgZm9yIHRoZSAibGl2ZSIgYW5kICJzbmFwc2hvdCIuDQoNCj4NCj4gSGVyZSwg
cmluZ19idWZmZXIgaXMgdGhlIHN1bSBvZiByaW5nX2J1ZmZlcl9saXZlIGFuZA0KPiByaW5nX2J1
ZmZlcl9zbmFwc2hvdC4gVGhlIHZhbHVlcyBjb3ZlciB0aGUgZ2xvYmFsIHRyYWNlIGFycmF5IGFu
ZCBhbGwNCj4gdHJhY2luZyBpbnN0YW5jZXMgYWNyb3NzIGFsbCB0cmFjaW5nIENQVXMuDQo+DQo+
IEFkZGl0aW9uYWwgYWNjb3VudGVkIGNhdGVnb3JpZXMsIHN1Y2ggYXMgZXZlbnQgbWVtb3J5LCBj
b3VsZCBiZSBhcHBlbmRlZA0KPiBsYXRlciBhbmQgaW5jbHVkZWQgaW4gdG90YWwuIFBlci1DUFUg
c3RhdGlzdGljcyBjb3VsZCBiZSBleHBvc2VkDQo+IHNlcGFyYXRlbHkgdW5kZXIgdHJhY2Vfc3Rh
dHMvcGVyX2NwdS9jcHVOLyB0byBhdm9pZCBtaXhpbmcgYWdncmVnYXRlIGFuZA0KPiBwZXItQ1BV
IHZhbHVlcyBpbiBvbmUgZmlsZS4NCg0KQWdyZWVkLCB0aGlzIGZpbGUgc2hvdWxkIGV4aXN0IGlu
IHRoZSBjcHVOLyBkaXJlY3RvcmllcyBhbmQgYmUgb25seSBmb3INCnRob3NlIGluc3RhbmNlcy4N
Cg0KPg0KPiBVc2Vyc3BhY2Ugd291bGQgcGFyc2UgZmllbGRzIGJ5IG5hbWUgYW5kIGlnbm9yZSB1
bmtub3duIGZpZWxkcywgc28gbmV3DQo+IGNhdGVnb3JpZXMgY2FuIGJlIGFkZGVkIHdpdGhvdXQg
Y2hhbmdpbmcgdGhlIGV4aXN0aW5nIGZvcm1hdC4NCg0KUmlnaHQuIEkgd291bGQgZXhwZWN0IGFk
ZGl0aW9uYWwgaXRlbXMgdG8gYmUgYWRkZWQgaGVyZS4NCg0KPg0KPiBEb2VzIHRoaXMgaW5pdGlh
bCBmb3JtYXQgbG9vayByZWFzb25hYmxlPw0KPg0KDQpZZXMsIHRoYW5rcyBmb3IgZG9pbmcgdGhp
cy4NCg0KLS0gU3RldmUNCg==

--_000_d5bb28119dbb4ff1ab1059bb2564ad29xiaomicom_
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
<div>Thanks, Steve.</div>
<div><br>
</div>
<div>Understood.</div>
<div><br>
</div>
<div>I will add:</div>
<div><br>
</div>
<div>&nbsp; /sys/kernel/tracing/trace_stats/total_memory_kb</div>
<div><br>
</div>
<div>The file will report:</div>
<div><br>
</div>
<div>&nbsp; total:</div>
<div>&nbsp; buffers_mem:</div>
<div>&nbsp; snapshot_buffers_mem:</div>
<div><br>
</div>
<div>The values will cover the main and snapshot buffers of the global trac=
e</div>
<div>array and all tracing instances across all tracing CPUs.</div>
<div><br>
</div>
<div>For the per-CPU view, I will follow the existing tracefs layout and ad=
d:</div>
<div><br>
</div>
<div>&nbsp; /sys/kernel/tracing/trace_stats/per_cpu/cpuN/total_memory_kb</d=
iv>
<div><br>
</div>
<div>Each per-CPU file will report only the corresponding CPU's buffers</di=
v>
<div>across the global trace array and all tracing instances.</div>
<div><br>
</div>
<div>Thanks,</div>
<div>Xiang</div>
<div><br>
</div>
<br>
<p></p>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" =
color=3D"#000000" style=3D"font-size:11pt"><b>=B7=A2=BC=FE=C8=CB:</b> Steve=
n Rostedt &lt;rostedt@goodmis.org&gt;<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2026=C4=EA8=D4=C212=C8=D5 23:47:04<br>
<b>=CA=D5=BC=FE=C8=CB:</b> =B8=DF=CF=E8<br>
<b>=B3=AD=CB=CD:</b> Xiang Gao; Masami Hiramatsu; Mathieu Desnoyers; Lorenz=
o Stoakes; gao xu; =D3=A1=B4=B3; linux-trace-kernel@vger.kernel.org; linux-=
kernel@vger.kernel.org; linux-mm@kvack.org<br>
<b>=D6=F7=CC=E2:</b> Re: [External Mail]Re: [RFC] tracing: aggregate ring-b=
uffer usage statistics</font>
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
On Wed, 12 Aug 2026 13:21:29 &#43;0000<br>
=B8=DF=CF=E8 &lt;gaoxiang17@xiaomi.com&gt; wrote:<br>
<br>
&gt; Thanks, Steve.<br>
&gt;<br>
&gt; For the initial implementation, I plan to add:<br>
&gt;<br>
&gt;&nbsp;&nbsp; /sys/kernel/tracing/trace_stats/total_memory_kb<br>
&gt;<br>
&gt; The file would use an extensible key/value format. Initially it would<=
br>
&gt; report the ring-buffer data capacity:<br>
&gt;<br>
&gt;&nbsp;&nbsp; total:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 395664<br>
&gt;&nbsp;&nbsp; ring_buffer:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; 395664<br>
&gt;&nbsp;&nbsp; ring_buffer_live:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; 395544<br>
&gt;&nbsp;&nbsp; ring_buffer_snapshot:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
120<br>
<br>
You can rename the above to:<br>
<br>
&nbsp;&nbsp; total:<br>
&nbsp;&nbsp; buffers_mem:<br>
&nbsp;&nbsp; snapshot_buffers_mem:<br>
<br>
No need to use &quot;ring&quot; and it keeps consistent with &quot;buffer_s=
ize_kb&quot;.<br>
<br>
I added the &quot;mem&quot; part to distinguish the difference between thes=
e numbers<br>
and the buffer_size_kb, as these numbers are about total memory whereas<br>
the &quot;buffer_size_kb&quot; is about usable memory.<br>
<br>
There's already a total for all memory listed. We don't need to have a<br>
total for the &quot;live&quot; and &quot;snapshot&quot;.<br>
<br>
&gt;<br>
&gt; Here, ring_buffer is the sum of ring_buffer_live and<br>
&gt; ring_buffer_snapshot. The values cover the global trace array and all<=
br>
&gt; tracing instances across all tracing CPUs.<br>
&gt;<br>
&gt; Additional accounted categories, such as event memory, could be append=
ed<br>
&gt; later and included in total. Per-CPU statistics could be exposed<br>
&gt; separately under trace_stats/per_cpu/cpuN/ to avoid mixing aggregate a=
nd<br>
&gt; per-CPU values in one file.<br>
<br>
Agreed, this file should exist in the cpuN/ directories and be only for<br>
those instances.<br>
<br>
&gt;<br>
&gt; Userspace would parse fields by name and ignore unknown fields, so new=
<br>
&gt; categories can be added without changing the existing format.<br>
<br>
Right. I would expect additional items to be added here.<br>
<br>
&gt;<br>
&gt; Does this initial format look reasonable?<br>
&gt;<br>
<br>
Yes, thanks for doing this.<br>
<br>
-- Steve<br>
</div>
</span></font>
</body>
</html>

--_000_d5bb28119dbb4ff1ab1059bb2564ad29xiaomicom_--

