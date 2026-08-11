Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1F83C5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 03:44:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 687EB6B007B; Mon, 10 Aug 2026 23:44:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638BE6B0092; Mon, 10 Aug 2026 23:44:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54ED96B0093; Mon, 10 Aug 2026 23:44:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 294C06B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:44:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A09BF140304
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:44:21 +0000 (UTC)
X-FDA: 85087595922.10.5518317
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by imf04.hostedemail.com (Postfix) with ESMTP id 72A2440004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:44:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786419859;
	b=7mgMeht0zDgyB0zk0WChbVp9uGE4TuJKirCKCdZhVv3toiiBvWuqsEABZqu1D942DKUkz/
	SQHlSOenL3pffIm0vlsMpcRofN7aRvA0DzIXFv6ZXqTgfJKJru6Q52gVtHcJFPDM6cgOHp
	I0FypG3QOFZZCW6qhEvJbZwW1WmADjU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786419859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VonqKvldCrkUyligtN8Gvi46kZFY93tCK0jioWFDuDQ=;
	b=qnZgYkTE3e4ULRH3IevK0Yj3bJ2xXA8K3FRjgiqQ1lR0sWdjQp40D5PHrpWw8SgTkl0HPl
	eyyklGNPi5xsJkSQunM52yIM6xeh8DIMWOdn0wPqPNQjvgEWh2gMmYsNzXJhLlZwf9SyRI
	ZotmuwJaA8awUh1csWuPM3GtDmVVPM0=
X-CSE-ConnectionGUID: HAQN1pDURu+Lyx/90+wdUQ==
X-CSE-MsgGUID: QSVbw6vcRAOqplVqFX1egw==
X-IronPort-AV: E=Sophos;i="6.25,217,1779120000"; 
   d="scan'208,217";a="158901089"
From: =?gb2312?B?uN/P6A==?= <gaoxiang17@xiaomi.com>
To: Steven Rostedt <rostedt@goodmis.org>, "Lorenzo Stoakes (ARM)"
	<ljs@kernel.org>
CC: "David Hildenbrand (Arm)" <david@kernel.org>, Xiang Gao
	<gxxa03070307@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, "liam@infradead.org" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW0V4dGVybmFsIE1haWxdUmU6IFtQQVRDSF0gdHJhY2luZzogcmVw?=
 =?gb2312?Q?ort_buffer_memory_in_/proc/meminfo?=
Thread-Topic: [External Mail]Re: [PATCH] tracing: report buffer memory in
 /proc/meminfo
Thread-Index: AQHdKLZzT3khsFLQtUm92nWB2iV8YLaWnZaAgAA76gCAAVrIXA==
Date: Tue, 11 Aug 2026 03:44:14 +0000
Message-ID: <b1378a355ce648a7b994d1ec8d56f10d@xiaomi.com>
References: <20260810094025.136705-1-gaoxiang17@xiaomi.com>
	<69df3080-a719-4131-a247-62bf47bda8a6@kernel.org>
	<anm0SMuVpBz7wLac@lucifer>,<20260810105710.6ee5e493@gandalf.local.home>
In-Reply-To: <20260810105710.6ee5e493@gandalf.local.home>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.88.13]
Content-Type: multipart/alternative;
	boundary="_000_b1378a355ce648a7b994d1ec8d56f10dxiaomicom_"
MIME-Version: 1.0
X-Rspamd-Queue-Id: 72A2440004
X-Stat-Signature: 3u4546pxreiz43ujfoizhk9scu5otzwp
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786419858-381486
X-HE-Meta: U2FsdGVkX1+n/yrKmvFkp46wCj2RF7Q7MwFnkzuVZliHQoefp7C35PAc663TnC0y+xeSwsx2pg3ZWIITQwqgabZqf8noSbVyCAssaU/B5VEbw5noElkfxqaF51W3mHGtv/i2BXRUbJN2U1p0yAe8E7UDByFVE20z8C67Pm6kVJxHaKpiEth6UoBCfhqQZHRG7U0VUpoNZbUm5ADV4wx+tNAzheN4UkB+0p5RSkkl0lURTk6KrSYHAry/1D4spkatumTRPsGSam+D8nHEpXJ9EZ5nQBP+OxsPmVTjXGsuYnLyJuAoarYmFvDttbdsjdWZuki1SSrxyBeD1+lJ+gADyCsxOsihYD1VR/uxqvqb2oI5d1VOxQzoeYSm/YghGbFG59VemwuIKOeusA02ioMGNnBcKEKkYHjWWUh343ayCuUSwLxDejvEPzzL8fGeeWrlvLyWcyWEQ12pCq0XOSdaqUgZU7ziPLPIQMgFgXYDGiRQ68Far900FYEqIaM+VHiTywbd81h140VHGRJx6KSXtdZO/paqxm2FCwX7TQZix5tzFd/EbDI1tf/fi1k2Rvvfr+i23VnSOV9ZRV0n0UfdZHOlrs4S4pJTZlD4IcYmEB3VEXkvh+2an+c9u2EqPGeF7KJGmMayGHmn548qfS10nkcVwG9C5kVlkeLabfkhFA/Bid/TPUhyjj/T4TgXjj9FQLhJJJOZPMJmoNf9NuW+i1FLz84GcMGGULbG/gzDr3bJabpENz4ZHXPorn2KOuNZqo88+MN+bwZzLDAhXZsr7j1MMlc3DoFTdexWNFh1B48P2hFNLdw0PE2JbsxbT4XSBiEIG2Eow0fqOEYZfD3ko6jlJHDT+Kd4qLrK11txr2d7gMSeRHXQpCUS0AV+1Rr0LJmvTe00KQTTjaXW+POxbm78oMpgXUrZ8ghukgLrLWUZDtE4d157jMRAKGQNyMyreggDY50861I6n4QVEsG
 53L1pL+Q
 A7muvyuWEoOQxRwlHXTdTcYBIqVQK4/dDthLB/fhkLT8K+RIMYEqTvDdLJ6nXCBuwPLKcIsfYJmoeUZZygcZbR/YCxp+mju6b5v+2BWzMhOrnrk8DyCLCu+f5/SICZc6+mY/QWnRK7qCXWmZPkejBvTCxfkAcX7y7xj+2q3kOHzMq5U81qp7yVkmdtGLoCY4PzajUbgVKqzqhKcmZk/ybzH4ufj3q7kqzh3BdBzejkRBk+SuPcf+9tKCLpOZ+o73Cj6cPPpsJx04bj04uSASY+IfdcG4+JsfZ6W2RvuzkE2JmoeXPZebjWTglG8lvZB7mybN0rjpN40HvccNwuQnB50g0LQ2+vsyVgv4kK42ao3QNxqV7stE01FlRwWQpGVHsHzuF7XDhh9rP8LpX+dq3sQC45Z5tPh7d71aEekfEUDEcdpXmCHu73s8MmpXOZnUBUN7VdokF83+mdnSEuSXHOM1cymrXSvv7yoSQFvy884a+VNhjYT7jzJqwh/ZhoXbDc06g8A6fz71h4kFJKL3FwGv8khQKaF5mXLbgcxLpGNFajBPM7mpI4QkysmofUfa7GXziKVNdgTTRQ+93R1MUvMbGcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_b1378a355ce648a7b994d1ec8d56f10dxiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

VGhhbmtzIGZvciB0aGUgc3VnZ2VzdGlvbi4NCg0KDQpUaGUgb3JpZ2luYWwgbW90aXZhdGlvbiBp
cyBBbmRyb2lkIGxvc3QtUkFNIGF0dHJpYnV0aW9uLiBGdHJhY2UNCnJpbmctYnVmZmVyIGRhdGEg
cGFnZXMgYXJlIG5vdCByZXByZXNlbnRlZCBhcyBhIHNlcGFyYXRlIG1lbW9yeQ0KY2F0ZWdvcnks
IHNvIHVzZXJzcGFjZSBjYW4gY291bnQgdGhlbSBhcyBsb3N0IFJBTS4NCg0KDQpUaGUgYnVmZmVy
cyBjYW4gYmUgc3ByZWFkIGFjcm9zcyB0aGUgZ2xvYmFsIHRyYWNlIGFycmF5LCBtdWx0aXBsZQ0K
aW5zdGFuY2VzLCBhbmQgc25hcHNob3QgYnVmZmVycy4gVXNlcnNwYWNlIGN1cnJlbnRseSBoYXMg
dG8gZGlzY292ZXINCmFuZCBzdW0gZXZlcnkgaW5zdGFuY2UsIGFuZCBzbmFwc2hvdCBjYXBhY2l0
eSBpcyBub3QgYXZhaWxhYmxlIHRocm91Z2gNCnRoZSBzYW1lIHBlci1pbnN0YW5jZSB0b3RhbC4g
T24gb25lIEFuZHJvaWQgZGV2aWNlLCB0aGUgZ2xvYmFsIGJ1ZmZlcg0KYW5kIDI0IGluc3RhbmNl
cyBhY2NvdW50ZWQgZm9yIDM5NSw2NjQga0IsIHNvIHRoZSBtaXNzaW5nIGF0dHJpYnV0aW9uDQp3
YXMgc2lnbmlmaWNhbnQuDQoNCg0KSSBhZ3JlZSB0aGF0IC9wcm9jL21lbWluZm8gaXMgbm90IHRo
ZSByaWdodCBpbnRlcmZhY2UuIEkgd2lsbCByZXdvcmsNCnRoaXMgYXMgYW4gUkZDIHVuZGVyIHRy
YWNlZnMsIHdpdGggdGhlIHRyYWNpbmcgbWVtb3J5IHVzYWdlIGJyb2tlbiBkb3duDQpieSBjYXRl
Z29yeS4NCg0KDQpUaGFua3MuDQoNCg0KDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xw0Kt6K8/sjLOiBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBnb29kbWlzLm9yZz4NCreiy83Ksbzk
OiAyMDI2xOo41MIxMMjVIDIyOjU3OjEwDQrK1bz+yMs6IExvcmVuem8gU3RvYWtlcyAoQVJNKQ0K
s63LzTogRGF2aWQgSGlsZGVuYnJhbmQgKEFybSk7IFhpYW5nIEdhbzsgQW5kcmV3IE1vcnRvbjsg
TWFzYW1pIEhpcmFtYXRzdTsgTWF0aGlldSBEZXNub3llcnM7IGxpYW1AaW5mcmFkZWFkLm9yZzsg
Vmxhc3RpbWlsIEJhYmthOyBNaWtlIFJhcG9wb3J0OyBTdXJlbiBCYWdoZGFzYXJ5YW47IE1pY2hh
bCBIb2NrbzsgbGludXgtdHJhY2Uta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3Zh
Y2sub3JnOyBsaW51eC1mc2RldmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZzsguN/P6A0K1vfM4jogW0V4dGVybmFsIE1haWxdUmU6IFtQQVRDSF0gdHJhY2lu
ZzogcmVwb3J0IGJ1ZmZlciBtZW1vcnkgaW4gL3Byb2MvbWVtaW5mbw0KDQpbzeKyv9PKvP5dILTL
08q8/sC01LTT2tChw9e5q8u+zeKyv6Osx+u998n3tKbA7aGjyPS21NPKvP6wssir0NS05tLJo6zH
672r08q8/teqt6K4+G1pc2VjQHhpYW9taS5jb229+NDQt7TAoQ0KDQpPbiBNb24sIDEwIEF1ZyAy
MDI2IDEyOjIyOjQzICswMTAwDQoiTG9yZW56byBTdG9ha2VzIChBUk0pIiA8bGpzQGtlcm5lbC5v
cmc+IHdyb3RlOg0KDQo+IE9uIE1vbiwgQXVnIDEwLCAyMDI2IGF0IDEyOjUyOjM4UE0gKzAyMDAs
IERhdmlkIEhpbGRlbmJyYW5kIChBcm0pIHdyb3RlOg0KPiA+IE9uIDgvMTAvMjYgMTE6NDAsIFhp
YW5nIEdhbyB3cm90ZToNCj4gPiA+IFJlcG9ydCB0aGUgZGF0YSBjYXBhY2l0eSBvZiBhbGwgZnRy
YWNlIHJpbmcgYnVmZmVycyB0aHJvdWdoIGEgbmV3IEZ0cmFjZQ0KPiA+ID4gZmllbGQgaW4gL3By
b2MvbWVtaW5mby4gSW5jbHVkZSB0aGUgbWFpbiBhbmQgc25hcHNob3QgYnVmZmVycyBvZiB0aGUN
Cj4gPiA+IGdsb2JhbCB0cmFjZSBhcnJheSBhbmQgYWxsIHRyYWNpbmcgaW5zdGFuY2VzLCB3aGls
ZSBsZWF2aW5nIHJpbmctYnVmZmVyDQo+ID4gPiBtZXRhZGF0YSBhY2NvdW50ZWQgZm9yIGJ5IFNs
YWIuDQo+ID4NCj4gPiB3aHk/IDopDQo+ID4NCj4gPiBUbyByZXBvcnQgYSBoYW5kZnVsIG9mIEtp
QiBhcyBpbiB5b3VyIGV4YW1wbGUgYmVsb3c/IERvZXNuJ3Qgc291bmQgc3VwZXIgaGVscGZ1bA0K
PiA+IFRCSC4NCj4NCj4gWWVhaCBJIHRoaW5rIHdlIG5lZWQgdG8gc3RvcCB3aXRoIGFsbCB0aGUg
cHJvcG9zZWQgYWRkaXRpb25zIHRvIC9wcm9jL21lbWluZm8gOikNCj4NCj4gQWxzbyBzb21ldGhp
bmcgbGlrZSB0aGlzIHdoZXJlIHlvdSBhcmUgbWFraW5nIGEgY2hhbmdlIGluIG91dHB1dCB0aGF0
IGl0IGlzIGp1c3QNCj4geW91ciBvcGluaW9uIHRoYXQgaXQgaXMgdXNlZnVsIHNob3VsZCBiZSBh
biBSRkMgdG8gc2VlIHdoYXQgdGhlIGNvbW11bml0eSB0aGlua3MNCj4gZmlyc3QuDQoNCkFncmVl
ZC4gVGhpcyBkb2Vzbid0IGJlbG9uZyBpbiB0aGUgbWVtaW5mby4gSWYgeW91IHdhbnQgbWVtb3J5
IHN0YXRpc3RpY3MNCmZvciB0cmFjaW5nLCBJIG1heSBiZSBPSyBpZiB5b3UgYWRkIGEgInRvdGFs
X21lbW9yeV9rYiIgZmlsZSBpbiB0aGUNCi9zeXMva2VybmVsL3RyYWNpbmcvdHJhY2Vfc3RhdHMv
IGRpcmVjdG9yeS4NCg0KQW5kIGJyZWFrIGl0IHVwIGZvciBtZW1vcnkgdXNlZC4gUmluZyBidWZm
ZXJzLCBldmVudHMsIGV0Yy4NCg0KUGVyaGFwcyBldmVuIGFkZCBvbmUgcGVyIENQVSBhcyB3ZWxs
Lg0KDQpJJ20gYWx3YXlzIGNvbnNjaWVuY2UgYWJvdXQgaG93IG11Y2ggbWVtb3J5IHRyYWNpbmcg
aXMgdGFraW5nIHVwIGluIHRoZQ0Kc3lzdGVtLg0KDQotLSBTdGV2ZQ0K

--_000_b1378a355ce648a7b994d1ec8d56f10dxiaomicom_
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
<div></div>
<div>Thanks for the suggestion.<br>
<br>
<br>
The original motivation is Android lost-RAM attribution. Ftrace<br>
ring-buffer data pages are not represented as a separate memory<br>
category, so userspace can count them as lost RAM.<br>
<br>
<br>
The buffers can be spread across the global trace array, multiple<br>
instances, and snapshot buffers. Userspace currently has to discover<br>
and sum every instance, and snapshot capacity is not available through<br>
the same per-instance total. On one Android device, the global buffer<br>
and 24 instances accounted for 395,664 kB, so the missing attribution<br>
was significant.<br>
<br>
<br>
I agree that /proc/meminfo is not the right interface. I will rework<br>
this as an RFC under tracefs, with the tracing memory usage broken down<br>
by category.<br>
<br>
<br>
Thanks.<br>
<br>
</div>
<br>
<p></p>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" =
color=3D"#000000" style=3D"font-size:11pt"><b>=B7=A2=BC=FE=C8=CB:</b> Steve=
n Rostedt &lt;rostedt@goodmis.org&gt;<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2026=C4=EA8=D4=C210=C8=D5 22:57:10<br>
<b>=CA=D5=BC=FE=C8=CB:</b> Lorenzo Stoakes (ARM)<br>
<b>=B3=AD=CB=CD:</b> David Hildenbrand (Arm); Xiang Gao; Andrew Morton; Mas=
ami Hiramatsu; Mathieu Desnoyers; liam@infradead.org; Vlastimil Babka; Mike=
 Rapoport; Suren Baghdasaryan; Michal Hocko; linux-trace-kernel@vger.kernel=
.org; linux-mm@kvack.org; linux-fsdevel@vger.kernel.org;
 linux-kernel@vger.kernel.org; =B8=DF=CF=E8<br>
<b>=D6=F7=CC=E2:</b> [External Mail]Re: [PATCH] tracing: report buffer memo=
ry in /proc/meminfo</font>
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
On Mon, 10 Aug 2026 12:22:43 &#43;0100<br>
&quot;Lorenzo Stoakes (ARM)&quot; &lt;ljs@kernel.org&gt; wrote:<br>
<br>
&gt; On Mon, Aug 10, 2026 at 12:52:38PM &#43;0200, David Hildenbrand (Arm) =
wrote:<br>
&gt; &gt; On 8/10/26 11:40, Xiang Gao wrote:<br>
&gt; &gt; &gt; Report the data capacity of all ftrace ring buffers through =
a new Ftrace<br>
&gt; &gt; &gt; field in /proc/meminfo. Include the main and snapshot buffer=
s of the<br>
&gt; &gt; &gt; global trace array and all tracing instances, while leaving =
ring-buffer<br>
&gt; &gt; &gt; metadata accounted for by Slab.<br>
&gt; &gt;<br>
&gt; &gt; why? :)<br>
&gt; &gt;<br>
&gt; &gt; To report a handful of KiB as in your example below? Doesn't soun=
d super helpful<br>
&gt; &gt; TBH.<br>
&gt;<br>
&gt; Yeah I think we need to stop with all the proposed additions to /proc/=
meminfo :)<br>
&gt;<br>
&gt; Also something like this where you are making a change in output that =
it is just<br>
&gt; your opinion that it is useful should be an RFC to see what the commun=
ity thinks<br>
&gt; first.<br>
<br>
Agreed. This doesn't belong in the meminfo. If you want memory statistics<b=
r>
for tracing, I may be OK if you add a &quot;total_memory_kb&quot; file in t=
he<br>
/sys/kernel/tracing/trace_stats/ directory.<br>
<br>
And break it up for memory used. Ring buffers, events, etc.<br>
<br>
Perhaps even add one per CPU as well.<br>
<br>
I'm always conscience about how much memory tracing is taking up in the<br>
system.<br>
<br>
-- Steve<br>
</div>
</span></font>
</body>
</html>

--_000_b1378a355ce648a7b994d1ec8d56f10dxiaomicom_--

