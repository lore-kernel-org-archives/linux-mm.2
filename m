Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CEDEC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 06:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7305A6B008C; Tue, 11 Aug 2026 02:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0A76B0092; Tue, 11 Aug 2026 02:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F8966B0093; Tue, 11 Aug 2026 02:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 381B86B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:23:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD2331A0358
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:23:05 +0000 (UTC)
X-FDA: 85087995930.30.4DA6264
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf23.hostedemail.com (Postfix) with ESMTP id 040D0140004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:23:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf23.hostedemail.com: domain of gaoxu2@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=gaoxu2@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786429383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zpn9Q6wCbwmAi1LjmnjfD/IaDhZQ0R7Hf16niZw3nMU=;
	b=W8+rbRKrGjC5C1Q2qMzBv7fSOwjYbYGbH1jH6YuAb/0aXSM0Nju87ZkM7G8Mpauff+e3Ac
	xy9tpTo3Jm4JV5GbES1pC+F0d65T12qwIYTRb9brts/gYZ6qatps+mFxp64J67ZenG1x6N
	/z9ztocJhnvznu5Bb/arMYi5kNfygCE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf23.hostedemail.com: domain of gaoxu2@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=gaoxu2@honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786429383;
	b=tbLelN7VcjqBg1R/LYyzwkQ5upKSCObX4n22K2lChH+LLen/U8YOR/g1s6whKPZSeOttAl
	mVz0c+Q41ukncoN5bBS5QiK7CSzoJfNpn1tleKTjOhGjPAI2nGaxdwF1nJQlhQqe6AUSjU
	4jBBUxzR1k9HgPXHw+9WUS93n3Q6EFg=
Received: from TW001.hihonor.com (unknown [10.77.229.151])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4hK1l66fMXzYl1n1;
	Tue, 11 Aug 2026 14:22:58 +0800 (CST)
Received: from TA008-1.hihonor.com (10.72.0.148) by TW001.hihonor.com
 (10.77.229.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 11 Aug
 2026 14:22:58 +0800
Received: from TA008-1.hihonor.com (10.72.0.148) by TA008-1.hihonor.com
 (10.72.0.148) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 11 Aug
 2026 14:22:58 +0800
Received: from TA008-1.hihonor.com ([fe80::e1cf:9270:9b1f:2b7]) by
 TA008-1.hihonor.com ([fe80::e1cf:9270:9b1f:2b7%17]) with mapi id
 15.02.2562.045; Tue, 11 Aug 2026 14:22:58 +0800
From: gao xu <gaoxu2@honor.com>
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
	<linux-kernel@vger.kernel.org>, Xiang Gao <gaoxiang17@xiaomi.com>
Subject: RE: [PATCH] tracing: report buffer memory in /proc/meminfo
Thread-Topic: [PATCH] tracing: report buffer memory in /proc/meminfo
Thread-Index: AQHdKKxQUSjNT0U+CkilnXunKM92XraWlUIAgAAIaICAADvrAIABWdpw
Date: Tue, 11 Aug 2026 06:22:58 +0000
Message-ID: <9bd98f51abd44d81a569d95e907070c6@honor.com>
References: <20260810094025.136705-1-gaoxiang17@xiaomi.com>
	<69df3080-a719-4131-a247-62bf47bda8a6@kernel.org>	<anm0SMuVpBz7wLac@lucifer>
 <20260810105710.6ee5e493@gandalf.local.home>
In-Reply-To: <20260810105710.6ee5e493@gandalf.local.home>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.166.85.101]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 040D0140004
X-Stat-Signature: taqjb5eyqmkhjo4c1ys7ukh3jmfdztwa
X-Rspam-User: 
X-HE-Tag: 1786429382-265871
X-HE-Meta: U2FsdGVkX19HvE3w+mV5PxZw3n1N5XVCOLi6U/JXo2FMK8bbQ+2mkCLM9SR5sWsLaa1hb202T/LeAo3bXn3EfQtOoj7bbRi21zIW2D3MTDhN/vhn0MiIX9l2lWGqcqvDmhiapj0J9v5OFeOYw1wQ+0GEGB9rnZVccapJaovWeC5WPN/z+QMWQIyXYbQwpVjpvAZT6aUDfxhTzVEeYu4w5ms+X5tr5U6yyfoGxOXxnq1Q00tJQZiZix1ttegigar5tQ8cFbRqnpQOEYcgm3WeE17OD+QM2UL1OJeXS7rEhof5S8auuMDM3gvOfnRbvDooA1W3G2NKdt8DEwitswRMYa0RxG2n1VWE1v0caoTuOMz63i8sk6KHt1IdkKCqL7z3RNnpksZd6bknaeS21JbeGw1yhyTPhLgMhyeNRkPFI4jVl48yZ2p3JYVTc5NKYWGemi/0rB56SyDScANwFIv3Mb8UOtdrix76Lxs98k8QdtgKGTjPTpjIkFMlEoBf89YO2lmhdAUbJJgxzT9Nl25V3yWpqXuL8lMr0F18zkozBZdFYgX1pqWXukZ7WflIuPxue4WXhS2xepxb+bDC0dQDXPHICi5kalVEuuiLqINtDQp3AtH+wLzygknChz1ojwSuilokVnHaA+tHLUEowUuU/gJzeT3zJ4SCfM1z+yXgKOytYX1TL6FXFXoUsMIjeU9Za1xnYpMjZGNfB9mJEC1feDsOfP364SgEQfIs6w9PNkp338bCe3PBLjKt1RaEJY1df75o4DQ1XuRACzwdZZqaKU6CGdnBaECu8xO/uQmduaoz0udmn4nAzeb4oOFE6oNKJS2CjqzEXk345rp+Y5vLDRx2ZQy7SS1hV8Az8Gkg9C4VJMa/RBMM2dtlISgUggYI5k7O5E7QXTK5zyIhUrdl/Qnqnpz0Dr2AYFv3/IITg1+aLNXeefeCp5iwo1+SrZmUCYy4m838NK2MfjUFsUO
 CCJupyaw
 HPwuuVxZ+7GQNGsbWSgJhBCS3OLFTFoAeK3qwKXOWjUegtCJLV+HM1u7Qmqof1GbOzG/Oxyh6IsCwCHKOqagkX0xegWaZqPyHSRqYMF9J3pBJXjQxR3WtoT9okFZtemGaja7WAZ9iDo7+yxC5l7bdJPle+5Tf4xq3h3LjvvFhT93oBSl5Bj3toCgFVi2iHaEitMbkj4m1bVwElVsURbk17ymWkUIS/qGqo9CJ9uhtSfGpO2hlWr5IpqPubyZ58PNOG2V/anP3vN+ijLuaemoLZJppbuzblAN88HABECeMb6/bxjq1Pd8Q/D9gWdh61Zflyex3y8i7rQ8uGXirfqNgTSWfySHfvA94ILNTy3w51F2iejAUTwKJu8uMgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBPbiBNb24sIDEwIEF1ZyAyMDI2IDEyOjIyOjQzICswMTAwDQo+ICJMb3JlbnpvIFN0b2FrZXMg
KEFSTSkiIDxsanNAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiA+IE9uIE1vbiwgQXVnIDEwLCAy
MDI2IGF0IDEyOjUyOjM4UE0gKzAyMDAsIERhdmlkIEhpbGRlbmJyYW5kIChBcm0pIHdyb3RlOg0K
PiA+ID4gT24gOC8xMC8yNiAxMTo0MCwgWGlhbmcgR2FvIHdyb3RlOg0KPiA+ID4gPiBSZXBvcnQg
dGhlIGRhdGEgY2FwYWNpdHkgb2YgYWxsIGZ0cmFjZSByaW5nIGJ1ZmZlcnMgdGhyb3VnaCBhIG5l
dw0KPiA+ID4gPiBGdHJhY2UgZmllbGQgaW4gL3Byb2MvbWVtaW5mby4gSW5jbHVkZSB0aGUgbWFp
biBhbmQgc25hcHNob3QNCj4gPiA+ID4gYnVmZmVycyBvZiB0aGUgZ2xvYmFsIHRyYWNlIGFycmF5
IGFuZCBhbGwgdHJhY2luZyBpbnN0YW5jZXMsIHdoaWxlDQo+ID4gPiA+IGxlYXZpbmcgcmluZy1i
dWZmZXIgbWV0YWRhdGEgYWNjb3VudGVkIGZvciBieSBTbGFiLg0KPiA+ID4NCj4gPiA+IHdoeT8g
OikNCj4gPiA+DQo+ID4gPiBUbyByZXBvcnQgYSBoYW5kZnVsIG9mIEtpQiBhcyBpbiB5b3VyIGV4
YW1wbGUgYmVsb3c/IERvZXNuJ3Qgc291bmQNCj4gPiA+IHN1cGVyIGhlbHBmdWwgVEJILg0KPiA+
DQo+ID4gWWVhaCBJIHRoaW5rIHdlIG5lZWQgdG8gc3RvcCB3aXRoIGFsbCB0aGUgcHJvcG9zZWQg
YWRkaXRpb25zIHRvDQo+ID4gL3Byb2MvbWVtaW5mbyA6KQ0KPiA+DQo+ID4gQWxzbyBzb21ldGhp
bmcgbGlrZSB0aGlzIHdoZXJlIHlvdSBhcmUgbWFraW5nIGEgY2hhbmdlIGluIG91dHB1dCB0aGF0
DQo+ID4gaXQgaXMganVzdCB5b3VyIG9waW5pb24gdGhhdCBpdCBpcyB1c2VmdWwgc2hvdWxkIGJl
IGFuIFJGQyB0byBzZWUgd2hhdA0KPiA+IHRoZSBjb21tdW5pdHkgdGhpbmtzIGZpcnN0Lg0KPiAN
Cj4gQWdyZWVkLiBUaGlzIGRvZXNuJ3QgYmVsb25nIGluIHRoZSBtZW1pbmZvLiBJZiB5b3Ugd2Fu
dCBtZW1vcnkgc3RhdGlzdGljcyBmb3INCj4gdHJhY2luZywgSSBtYXkgYmUgT0sgaWYgeW91IGFk
ZCBhICJ0b3RhbF9tZW1vcnlfa2IiIGZpbGUgaW4gdGhlDQo+IC9zeXMva2VybmVsL3RyYWNpbmcv
dHJhY2Vfc3RhdHMvIGRpcmVjdG9yeS4NCldvdWxkIGl0IGJlIHBvc3NpYmxlIHRvIGluY2x1ZGUg
dGhpcyBpbmZvIGluIHNob3dfbWVtKCk/DQpUaGlzIHdvdWxkIGJlIGhlbHBmdWwgZm9yIGFuYWx5
emluZyBsb3ctbWVtb3J5IGFuZCBPT00gaXNzdWVzLg0KPiANCj4gQW5kIGJyZWFrIGl0IHVwIGZv
ciBtZW1vcnkgdXNlZC4gUmluZyBidWZmZXJzLCBldmVudHMsIGV0Yy4NCj4gDQo+IFBlcmhhcHMg
ZXZlbiBhZGQgb25lIHBlciBDUFUgYXMgd2VsbC4NCj4gDQo+IEknbSBhbHdheXMgY29uc2NpZW5j
ZSBhYm91dCBob3cgbXVjaCBtZW1vcnkgdHJhY2luZyBpcyB0YWtpbmcgdXAgaW4gdGhlDQo+IHN5
c3RlbS4NCj4gDQo+IC0tIFN0ZXZlDQoNCg==

