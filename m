Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78247C5DF67
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 04:33:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB3D6B0334; Sat, 15 Aug 2026 00:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8ABF6B0335; Sat, 15 Aug 2026 00:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7996B0337; Sat, 15 Aug 2026 00:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 954CF6B0334
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:33:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14E30C02F6
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 04:33:26 +0000 (UTC)
X-FDA: 85102234812.24.26B3FCE
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by imf29.hostedemail.com (Postfix) with ESMTP id C78F0120002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 04:33:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf29.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786768404;
	b=lSUGaUR62zD8Rrne/+3T/Ng+QjTcYHn0k2X0g0MiO3w19Rk64bp7wlV6j+VPDFLG4B8yg8
	fzgmZLCMHuQbFnlrGHtfY5pyTy1dHaFp3i0Td1K5x1EBoiiJtu2QQWAhKRuxLSLG0zCdKM
	xnOJQQZDLcuupnV0flMNKfMkDBPjP/c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf29.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786768404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YdGDigePpZDlgBoQC/bKgGw9DA07yIWnfFyyUDtJ1vg=;
	b=VMQkVelt1kD5SSH9mmidSnG1/ZlrzXgmcOxdBYPJSoFEV1u9NIlIEotDuP6cz9ra7K6qY/
	31Mh/gfoWNLqSxOmHbwssb3pE9xVI5OtcU3+LcTPrbAHSG2Ah69ATTEnK5kneaGaBzbfto
	U5FGcsYjDeIB979r/g73d3wDc1GiUrU=
X-CSE-ConnectionGUID: fAdLGRqES7qYJ4x+DeuqEA==
X-CSE-MsgGUID: n3jJJlQNR+mF9QNC1hHnSA==
X-IronPort-AV: E=Sophos;i="6.25,224,1779120000"; 
   d="scan'208,217";a="185703118"
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
Thread-Index: AQHdKZr3AIp7eq0PuUyEknsvZXxszLaaZZoy//+kuACAAeZA14ACmlvf
Date: Sat, 15 Aug 2026 04:33:14 +0000
Message-ID: <0e42953988164786aafe175ef0f4e745@xiaomi.com>
References: <20260811114818.1449933-1-gaoxiang17@xiaomi.com>
	<20260811100830.7976bbe8@gandalf.local.home>
	<cd441eb194d54265b1bf9ab659716c45@xiaomi.com>,<20260812114704.2f61bc5a@gandalf.local.home>,<d5bb28119dbb4ff1ab1059bb2564ad29@xiaomi.com>
In-Reply-To: <d5bb28119dbb4ff1ab1059bb2564ad29@xiaomi.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.8.164]
Content-Type: multipart/alternative;
	boundary="_000_0e42953988164786aafe175ef0f4e745xiaomicom_"
MIME-Version: 1.0
X-Rspamd-Queue-Id: C78F0120002
X-Rspam-User: 
X-Stat-Signature: 8gcpqynm65i3bp699uh57mi91znh1z7b
X-Rspamd-Server: rspam06
X-HE-Tag: 1786768402-985293
X-HE-Meta: U2FsdGVkX1+aoe0+uqwCNYz76M4BeL9sB2reAjjpF9ORAmKdeKo8dFNpWGrAkDLsddSDMurMF3oECqdgsBtMkmkqe571Khlf0V4N0G5Wy/OUgoDHAF8fKKLZU7RgTn/rwElah9oe1Qrf2EWsGo4QUEvA/VCKhb2ZDPwWIi97U4yHFQ5f1lfk0PaNpfSOLAXXGnh3cF037e8Ez7GrW3Et8mYbo0TfRj/7wJ3WgQNGyj9yaKJesXbpktpknY/azFTbs7uMHLTV17DfAcu1TrleowQQOTz50PGOVT5PemRyrqE1Qrw5XqanuT6NdBW5WzHlKUGb6qPUOLGv3i5s8SNyryrZTWHrrg+Lgr+1KsfKQ25ybDj/6ohWtT0GKkCpVi3Nn7P9jHPtxElV0+ZrOlLzqMLHNDgTAtBII3aasI5E6Hx3EBRxlkbF3GFJjk5gjJwKlIU3vGnd28HgbhfMCv7v/JYs3I5YDAIVUvCH5+CEvMlRgVk+BFDa8TTnveNbd48BPkfdoo4gkv9EBgdrJOLDNBuTgTGxY6m+TX6Ai40EtUyOyJkOVXP5+IlHaexMQr09Vw7p7u270MbW3XmLQZKM7mgAcWMFDPUAnDcK2OtY+h4UEF6PV0EVnuhW8Ia95o12v0E77Uq627HbiVJYCMA5cTaZVynNHFfkl+EB5NNyYTLPCINobHbDIHklBwuoDUu8+fwFz/Q+MANA7gXTXOLxnvk5LdrsrQPnIa/BQK5nE1orPdmWpO387h5hzpOa0aV5TqDE2Q/JK84AIAYTbeFHOOERrG1IK7Ln1pY4Hi96ZgxVP6ciyF8FHtud/6FtNfR7iNe9MMOHoL6SbAw5wvuMh7WK/TG3t4odhgBfZ2BZX4Sco1I8GPI/K/ATL1D/f/OBGinZHM7q/0hbDyedVjtg9SUkuOw2FyAa/P7gzTBQ+999HIMY3948MusEILjuVEmvhdXK3Q/HV9C6xgTnCNx
 Ulfr60Up
 V22IYWc5JHoCesXL5fMgFvgmA0M5iSzPR4RZYhjucWtK/fvAc941ZyQAcoULaWOi1XGHGS0Yaf4bL0Oj/FW6tiahCaZcbyxcpBbN13dnRsBa4QmkmkMbuqqH5J35V3lSXqLuC9CuElb6fqgixaGLheGKMyhCK96w+GcARlWadiFrSbDnkB7+7DBqUvhf9a7aC3PneRSXvyLM/5kZwYYksNH05xnajo0g9i4HI84xPSSNUuDz4Z3X1NOOwyqdX9/0kBoGigojEIr/Bpme2+NZ0m7yzx34vozstdWjbvEcIRqV9RGq45ObH2Ei0wx3g7TvabIMBb0KelepcHXN1mO114Pab2lrFXKn+22HLEpLqq78CIA5Xi/L70DTvROAmfygV8R28KP0KbajVW69gL0pzpJRvi/buxAJF1SZbfDJJ2vPFS28NEPfG69NZJ4TuAW9AE9gnV/a7mOQjuheMERdzT1rsH4meSbuILBHNvnVeXkQH00bYQR9GxjMgTQAgz9M+LitBSFFqXgkhySbfgOPDvpt+NbRPAFu3JRZu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_0e42953988164786aafe175ef0f4e745xiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGksIFN0ZXZlLg0KDQoNCk9uZSBhY2NvdW50aW5nIGRldGFpbCBJIHdvdWxkIGxpa2UgdG8gY2xh
cmlmeSBiZWZvcmUgaW1wbGVtZW50aW5nIHRoaXM6DQpzaG91bGQgYnVmZmVyc19tZW0gYW5kIHNu
YXBzaG90X2J1ZmZlcnNfbWVtIGluY2x1ZGUgYWxsIG1lbW9yeSBvd25lZCBieQ0KdGhlIGJ1ZmZl
cnMsIGluY2x1ZGluZyBzbGFiLWFsbG9jYXRlZCByaW5nLWJ1ZmZlciBtZXRhZGF0YSBhbmQgcmVh
ZGVyDQpwYWdlcywgb3Igb25seSB0aGUgZnVsbCBwYWdlcyBiYWNraW5nIHRoZSByaW5nLWJ1ZmZl
ciBkYXRhPw0KDQoNCk15IG9yaWdpbmFsIGxvc3QtUkFNIHVzZSBjYXNlIHByaW1hcmlseSBuZWVk
cyB0aGUgbm9uLXNsYWIgcGFnZSBtZW1vcnksDQpzaW5jZSBzbGFiIGlzIGFscmVhZHkgYWNjb3Vu
dGVkIGZvciBzZXBhcmF0ZWx5LiBCdXQgSSB1bmRlcnN0YW5kDQoiYnVmZmVyc19tZW0iIGFuZCAi
dG90YWwgbWVtb3J5IiBtYXkgYmUgaW50ZW5kZWQgdG8gaW5jbHVkZSBib3RoIHBhZ2UNCmFuZCBz
bGFiIGFsbG9jYXRpb25zLg0KDQoNClRoYW5rcywNClhpYW5nDQoNCg0KDQpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXw0Kt6K8/sjLOiC438/oDQq3osvNyrG85DogMjAyNsTqONTCMTPI
1SAyMDo0Nzo0NA0KytW8/sjLOiBTdGV2ZW4gUm9zdGVkdA0Ks63LzTogWGlhbmcgR2FvOyBNYXNh
bWkgSGlyYW1hdHN1OyBNYXRoaWV1IERlc25veWVyczsgTG9yZW56byBTdG9ha2VzOyBnYW8geHU7
INOhtLM7IGxpbnV4LXRyYWNlLWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZw0K1vfM4jogtPC4tDogW0V4dGVybmFs
IE1haWxdUmU6IFtSRkNdIHRyYWNpbmc6IGFnZ3JlZ2F0ZSByaW5nLWJ1ZmZlciB1c2FnZSBzdGF0
aXN0aWNzDQoNCg0KVGhhbmtzLCBTdGV2ZS4NCg0KVW5kZXJzdG9vZC4NCg0KSSB3aWxsIGFkZDoN
Cg0KICAvc3lzL2tlcm5lbC90cmFjaW5nL3RyYWNlX3N0YXRzL3RvdGFsX21lbW9yeV9rYg0KDQpU
aGUgZmlsZSB3aWxsIHJlcG9ydDoNCg0KICB0b3RhbDoNCiAgYnVmZmVyc19tZW06DQogIHNuYXBz
aG90X2J1ZmZlcnNfbWVtOg0KDQpUaGUgdmFsdWVzIHdpbGwgY292ZXIgdGhlIG1haW4gYW5kIHNu
YXBzaG90IGJ1ZmZlcnMgb2YgdGhlIGdsb2JhbCB0cmFjZQ0KYXJyYXkgYW5kIGFsbCB0cmFjaW5n
IGluc3RhbmNlcyBhY3Jvc3MgYWxsIHRyYWNpbmcgQ1BVcy4NCg0KRm9yIHRoZSBwZXItQ1BVIHZp
ZXcsIEkgd2lsbCBmb2xsb3cgdGhlIGV4aXN0aW5nIHRyYWNlZnMgbGF5b3V0IGFuZCBhZGQ6DQoN
CiAgL3N5cy9rZXJuZWwvdHJhY2luZy90cmFjZV9zdGF0cy9wZXJfY3B1L2NwdU4vdG90YWxfbWVt
b3J5X2tiDQoNCkVhY2ggcGVyLUNQVSBmaWxlIHdpbGwgcmVwb3J0IG9ubHkgdGhlIGNvcnJlc3Bv
bmRpbmcgQ1BVJ3MgYnVmZmVycw0KYWNyb3NzIHRoZSBnbG9iYWwgdHJhY2UgYXJyYXkgYW5kIGFs
bCB0cmFjaW5nIGluc3RhbmNlcy4NCg0KVGhhbmtzLA0KWGlhbmcNCg0KDQoNCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fDQq3orz+yMs6IFN0ZXZlbiBSb3N0ZWR0IDxyb3N0ZWR0QGdv
b2RtaXMub3JnPg0Kt6LLzcqxvOQ6IDIwMjbE6jjUwjEyyNUgMjM6NDc6MDQNCsrVvP7IyzoguN/P
6A0Ks63LzTogWGlhbmcgR2FvOyBNYXNhbWkgSGlyYW1hdHN1OyBNYXRoaWV1IERlc25veWVyczsg
TG9yZW56byBTdG9ha2VzOyBnYW8geHU7INOhtLM7IGxpbnV4LXRyYWNlLWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9y
Zw0K1vfM4jogUmU6IFtFeHRlcm5hbCBNYWlsXVJlOiBbUkZDXSB0cmFjaW5nOiBhZ2dyZWdhdGUg
cmluZy1idWZmZXIgdXNhZ2Ugc3RhdGlzdGljcw0KDQpbzeKyv9PKvP5dILTL08q8/sC01LTT2tCh
w9e5q8u+zeKyv6Osx+u998n3tKbA7aGjyPS21NPKvP6wssir0NS05tLJo6zH672r08q8/teqt6K4
+G1pc2VjQHhpYW9taS5jb229+NDQt7TAoQ0KDQpPbiBXZWQsIDEyIEF1ZyAyMDI2IDEzOjIxOjI5
ICswMDAwDQq438/oIDxnYW94aWFuZzE3QHhpYW9taS5jb20+IHdyb3RlOg0KDQo+IFRoYW5rcywg
U3RldmUuDQo+DQo+IEZvciB0aGUgaW5pdGlhbCBpbXBsZW1lbnRhdGlvbiwgSSBwbGFuIHRvIGFk
ZDoNCj4NCj4gICAvc3lzL2tlcm5lbC90cmFjaW5nL3RyYWNlX3N0YXRzL3RvdGFsX21lbW9yeV9r
Yg0KPg0KPiBUaGUgZmlsZSB3b3VsZCB1c2UgYW4gZXh0ZW5zaWJsZSBrZXkvdmFsdWUgZm9ybWF0
LiBJbml0aWFsbHkgaXQgd291bGQNCj4gcmVwb3J0IHRoZSByaW5nLWJ1ZmZlciBkYXRhIGNhcGFj
aXR5Og0KPg0KPiAgIHRvdGFsOiAgICAgICAgICAgICAgICAgICAzOTU2NjQNCj4gICByaW5nX2J1
ZmZlcjogICAgICAgICAgICAgMzk1NjY0DQo+ICAgcmluZ19idWZmZXJfbGl2ZTogICAgICAgIDM5
NTU0NA0KPiAgIHJpbmdfYnVmZmVyX3NuYXBzaG90OiAgICAgICAxMjANCg0KWW91IGNhbiByZW5h
bWUgdGhlIGFib3ZlIHRvOg0KDQogICB0b3RhbDoNCiAgIGJ1ZmZlcnNfbWVtOg0KICAgc25hcHNo
b3RfYnVmZmVyc19tZW06DQoNCk5vIG5lZWQgdG8gdXNlICJyaW5nIiBhbmQgaXQga2VlcHMgY29u
c2lzdGVudCB3aXRoICJidWZmZXJfc2l6ZV9rYiIuDQoNCkkgYWRkZWQgdGhlICJtZW0iIHBhcnQg
dG8gZGlzdGluZ3Vpc2ggdGhlIGRpZmZlcmVuY2UgYmV0d2VlbiB0aGVzZSBudW1iZXJzDQphbmQg
dGhlIGJ1ZmZlcl9zaXplX2tiLCBhcyB0aGVzZSBudW1iZXJzIGFyZSBhYm91dCB0b3RhbCBtZW1v
cnkgd2hlcmVhcw0KdGhlICJidWZmZXJfc2l6ZV9rYiIgaXMgYWJvdXQgdXNhYmxlIG1lbW9yeS4N
Cg0KVGhlcmUncyBhbHJlYWR5IGEgdG90YWwgZm9yIGFsbCBtZW1vcnkgbGlzdGVkLiBXZSBkb24n
dCBuZWVkIHRvIGhhdmUgYQ0KdG90YWwgZm9yIHRoZSAibGl2ZSIgYW5kICJzbmFwc2hvdCIuDQoN
Cj4NCj4gSGVyZSwgcmluZ19idWZmZXIgaXMgdGhlIHN1bSBvZiByaW5nX2J1ZmZlcl9saXZlIGFu
ZA0KPiByaW5nX2J1ZmZlcl9zbmFwc2hvdC4gVGhlIHZhbHVlcyBjb3ZlciB0aGUgZ2xvYmFsIHRy
YWNlIGFycmF5IGFuZCBhbGwNCj4gdHJhY2luZyBpbnN0YW5jZXMgYWNyb3NzIGFsbCB0cmFjaW5n
IENQVXMuDQo+DQo+IEFkZGl0aW9uYWwgYWNjb3VudGVkIGNhdGVnb3JpZXMsIHN1Y2ggYXMgZXZl
bnQgbWVtb3J5LCBjb3VsZCBiZSBhcHBlbmRlZA0KPiBsYXRlciBhbmQgaW5jbHVkZWQgaW4gdG90
YWwuIFBlci1DUFUgc3RhdGlzdGljcyBjb3VsZCBiZSBleHBvc2VkDQo+IHNlcGFyYXRlbHkgdW5k
ZXIgdHJhY2Vfc3RhdHMvcGVyX2NwdS9jcHVOLyB0byBhdm9pZCBtaXhpbmcgYWdncmVnYXRlIGFu
ZA0KPiBwZXItQ1BVIHZhbHVlcyBpbiBvbmUgZmlsZS4NCg0KQWdyZWVkLCB0aGlzIGZpbGUgc2hv
dWxkIGV4aXN0IGluIHRoZSBjcHVOLyBkaXJlY3RvcmllcyBhbmQgYmUgb25seSBmb3INCnRob3Nl
IGluc3RhbmNlcy4NCg0KPg0KPiBVc2Vyc3BhY2Ugd291bGQgcGFyc2UgZmllbGRzIGJ5IG5hbWUg
YW5kIGlnbm9yZSB1bmtub3duIGZpZWxkcywgc28gbmV3DQo+IGNhdGVnb3JpZXMgY2FuIGJlIGFk
ZGVkIHdpdGhvdXQgY2hhbmdpbmcgdGhlIGV4aXN0aW5nIGZvcm1hdC4NCg0KUmlnaHQuIEkgd291
bGQgZXhwZWN0IGFkZGl0aW9uYWwgaXRlbXMgdG8gYmUgYWRkZWQgaGVyZS4NCg0KPg0KPiBEb2Vz
IHRoaXMgaW5pdGlhbCBmb3JtYXQgbG9vayByZWFzb25hYmxlPw0KPg0KDQpZZXMsIHRoYW5rcyBm
b3IgZG9pbmcgdGhpcy4NCg0KLS0gU3RldmUNCg==

--_000_0e42953988164786aafe175ef0f4e745xiaomicom_
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
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;font=
-family:Calibri,Helvetica,sans-serif;" dir=3D"ltr">
<p></p>
<div>Hi, Steve.<br>
<br>
<br>
One accounting detail I would like to clarify before implementing this:<br>
should buffers_mem and snapshot_buffers_mem include all memory owned by<br>
the buffers, including slab-allocated ring-buffer metadata and reader<br>
pages, or only the full pages backing the ring-buffer data?<br>
<br>
<br>
My original lost-RAM use case primarily needs the non-slab page memory,<br>
since slab is already accounted for separately. But I understand<br>
&quot;buffers_mem&quot; and &quot;total memory&quot; may be intended to inc=
lude both page<br>
and slab allocations.<br>
<br>
<br>
Thanks,<br>
Xiang<br>
<br>
</div>
<br>
<p></p>
</div>
<hr style=3D"display:inline-block;width:98%" tabindex=3D"-1">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" st=
yle=3D"font-size:11pt" color=3D"#000000"><b>=B7=A2=BC=FE=C8=CB:</b> =B8=DF=
=CF=E8<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2026=C4=EA8=D4=C213=C8=D5 20:47:44<br>
<b>=CA=D5=BC=FE=C8=CB:</b> Steven Rostedt<br>
<b>=B3=AD=CB=CD:</b> Xiang Gao; Masami Hiramatsu; Mathieu Desnoyers; Lorenz=
o Stoakes; gao xu; =D3=A1=B4=B3; linux-trace-kernel@vger.kernel.org; linux-=
kernel@vger.kernel.org; linux-mm@kvack.org<br>
<b>=D6=F7=CC=E2:</b> =B4=F0=B8=B4: [External Mail]Re: [RFC] tracing: aggreg=
ate ring-buffer usage statistics</font>
<div>&nbsp;</div>
</div>
<div>
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
</span></font></div>
</body>
</html>

--_000_0e42953988164786aafe175ef0f4e745xiaomicom_--

