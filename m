Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A930FD5330
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 10:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C15BA6B0005; Fri, 27 Feb 2026 05:03:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC36B6B0088; Fri, 27 Feb 2026 05:03:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC23C6B0089; Fri, 27 Feb 2026 05:03:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 936FE6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 05:03:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9AE0859A70
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:03:20 +0000 (UTC)
X-FDA: 84489798960.11.53265A4
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf16.hostedemail.com (Postfix) with ESMTP id E629B180007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:03:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772186598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DzVxvddRh2QUlnOXI3bc/NykLIoe1hxtwnRWlKrigSY=;
	b=S3yk5tj0CGmDciyebUGujPRZ94JVNbmoOo0gyLgxCr5o/C54uE6jJCIJ8JS4nmZh8GcFjf
	t8biBTpAMjzfL+robyOWiu9KWfT64iIXtD+P/k53hZu/g6ay9aP6DR2zZU7FRInowYYs5T
	uxaisFMcHNaTcOlbXiFC4nVKyymIMsU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772186598; a=rsa-sha256;
	cv=none;
	b=yOPFWGzK+lrtwPluuyTEKFr4Cnc1I9xFEd10JggKTKuzNnddmUidA2UFt29SKsZETFWKXq
	rV4ELiIKU5GnuUxQgPy9w6ALz0KNy3Cizs3ajULvuOrSNCqSSyBNDrF5mylOP6wwkDFipQ
	qbvU1+IF/rb9cjdvImG6mh/pVa9hhD8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
Received: from w011.hihonor.com (unknown [10.68.20.122])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4fMkMM36XFzYlSqx;
	Fri, 27 Feb 2026 17:59:43 +0800 (CST)
Received: from a003.hihonor.com (10.68.18.8) by w011.hihonor.com
 (10.68.20.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Fri, 27 Feb
 2026 18:03:12 +0800
Received: from w002.hihonor.com (10.68.28.120) by a003.hihonor.com
 (10.68.18.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Fri, 27 Feb
 2026 18:03:11 +0800
Received: from w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3]) by
 w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3%14]) with mapi id
 15.02.2562.027; Fri, 27 Feb 2026 18:03:11 +0800
From: wangzicheng <wangzicheng@honor.com>
To: "T.J. Mercier" <tjmercier@google.com>, Yuanchu Xie <yuanchu@google.com>
CC: Barry Song <21cnbao@gmail.com>, "lsf-pc@lists.linux-foundation.org"
	<lsf-pc@lists.linux-foundation.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, wangxin 00023513 <wangxin23@honor.com>, gao xu
	<gaoxu2@honor.com>, wangtao <tao.wangtao@honor.com>, liulu 00013167
	<liulu.liu@honor.com>, zhouxiaolong <zhouxiaolong9@honor.com>, linkunli
	<linkunli@honor.com>, "kasong@tencent.com" <kasong@tencent.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "weixugc@google.com"
	<weixugc@google.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "willy@infradead.org"
	<willy@infradead.org>
Subject: RE: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and
 Challenges
Thread-Topic: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and
 Challenges
Thread-Index: AQHcpcuKJgNe9L/uMUapsJqAWXykl7WVB9+AgAAiK4CAAR5sgA==
Date: Fri, 27 Feb 2026 10:03:11 +0000
Message-ID: <2e1aea6dec5849fda1c9bfffc58f9be0@honor.com>
References: <e5c8b5b9e7574dce8e4d4744595123e2@honor.com>
 <CAGsJ_4zatnuLkCJyDe_o_yXmhngpc54kV6b7M3tu6JyvF-ZxDw@mail.gmail.com>
 <CAJj2-QEHAk-H6SSJY5OmLYuVyLRacSEgUupKaKefFFwGg7CftA@mail.gmail.com>
 <CABdmKX2mOD8CwAHPbn8Cha1uuMP8_mSXdH=914z5x_qTkJf7wA@mail.gmail.com>
In-Reply-To: <CABdmKX2mOD8CwAHPbn8Cha1uuMP8_mSXdH=914z5x_qTkJf7wA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E629B180007
X-Stat-Signature: zzmbkkpjorfs8x6sq7hijyr59pmchgad
X-Rspam-User: 
X-HE-Tag: 1772186597-506387
X-HE-Meta: U2FsdGVkX19KlspkL9LnbW3AdLKA9gBW+0dU0gO3NwjZ0Wke2i+sUS6jsMm2NzlGe1w7X3Gb8Gf8Efb3mMjL2BmNUcTUPPrlArjvfhNwVWev3yFeNHq8Qav9SjZsF7AsTX3Ffh1TtXSmlwmWjPqHSLBj10KSWXxDNMe7POAhT9IXYA/gjbMNKNKNw2Am5v8R4tuyWdQvIjp8UaIjaBl3tm0u3Oi2SqJca8Zqut4/HpKe8kiPlGLRiOVm474KP3soYhliaYg5c82tEwTYCrYZf+DpvN0zL7sxNpYoU4kkjSofP0y/fZVT5xcLxqO3R2OGAA2+H+p+CKI/wvAGUhJYlW9aMVkfxc8OAwgmO7LbobAKd2f/vDWWmh6ko5GRhq3fJD8maAwvTyiR+T30Jb3Kq0T7oAZG+1597n1bmRMNATNtSI+Z9R6HX/dIRI4f06/J2wW9Q4kAmP8SUfuLqgG0xgv5uDbxSwKj3ch/DdfMgnUiP4TmaroizSx9R81Pc4DPruvi8PlMqzgBEjbIVJTuKR9vxGHPSt5TfT7TH3Fo1wonjwqbgmJ/6nIF1gwThZUgeBQM22LM9Z/LE8s7CpZQE9UcfYzIknY4IIrbRskIeFe4cgRpEbWLf5aRQBeUZHMqz0kibNp8VzLTe7Rh23XAW5IVQ6TnPwkPL9jJj65mKYldp0kVREHBImrjzktcQXt19OjdH4KXFy5Y5ufD28RrIqXthQejdnYloi/ZAYMWCIlzfzj3qKXIF+cfGsP7skmiryVGOV8pwbgRLBfBH5KOX6Sz5X3nXJq7KIeZkIkTRADE2c//xHVR8nJ0h0Uc/kOjLkH3R/RjtQ8Xf/K473QWg8cApFV4Qp1hFKx2qX9eRlhgmtSqdJf5AYGyt7vn9HzaH4CqhErT+xj3cIWODqfBZ+yeDmF/c8Z4oXYwgctna86OJ8jU0w5M+fcRT1AXV9JsYsDCd0Xzh/4tr0/CC4n
 ByaJtBe2
 Aw60dJwKFt/UNGRAXnoFY7ogCUa05gDD2kvWQ3H130yUjLQa2xNxP63l6DaWSV98p7/L43mA1nvSUrBhqSv6DAX5RNArwJGWeXjcZ/q4DeCzsUPZh7bAB6GcqyTJHrSE9+ReFF5ES1wkaVgsVYWGfW+cNAAf+XuPFOkc6gCpgocLKp4axcROsy7utiMuGoO7ClXa9gDvRghP6q0m/X/j03Mh3pous1WKXTcpmNPfwTwAgkgRalwSngVidrSAE2KLcgF+gSIqYSfzPqjM4Z1F/pvA4Z719ZwI1ChHpLh3E0K1HW/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiA+ID4NCj4gPiA+IEJ1dCB0aGlzIGlzIG5vdCBzcGVjaWZpYyB0byBNR0xSVTsgaXQgY2FuIGFs
c28gYmUgYW4gaXNzdWUgZm9yIHRoZQ0KPiA+ID4gYWN0aXZlL2luYWN0aXZlIExSVT8NCj4gPg0K
PiA+IFBhcmRvbiBteSBsYWNrIG9mIGZhbWlsaWFyaXR5IHdpdGggdGhlIHVzZSBjYXNlLCBpbiB3
aGF0IHdheXMgYXJlDQo+ID4gZXhpc3RpbmcgbWVtY2cgcHJvdGVjdGlvbiBmZWF0dXJlcyBpbnN1
ZmZpY2llbnQ/DQo+IA0KPiBJIHRoaW5rIGhlIG1lYW5zIHRoYXQgd2hpY2hldmVyIG1lbWNnIGlz
IG5leHQgdXAgb24gdGhlIG1lbWNnIExSVSBpcw0KPiB0aGUgb25lIHRoYXQgZ2V0cyByZWNsYWlt
ZWQgZnJvbSBmaXJzdCwgcmVnYXJkbGVzcyBvZiB3aGV0aGVyIHRoYXQNCj4gbWVtY2cgaXMgZm9y
IGEgZm9yZWdyb3VuZCBhcHAuIEJlY2F1c2UgdGhlcmUgaXMgY3VycmVudGx5IG5vIHN0cm9uZw0K
PiByZWxhdGlvbnNoaXAgYmV0d2VlbiBtZW1jZyBMUlUgb3JkZXJpbmcgYW5kIEFuZHJvaWQgYXBw
IHN0YXRlLiBBbmRyb2lkDQo+IHVwZGF0ZXMgb29tX3Njb3JlX2FkaiBvbiBhcHAgc3RhdGUgdHJh
bnNpdGlvbnMsIHNvIGl0J2QgYmUgcG9zc2libGUNCj4gZm9yIHRoZSBrZXJuZWwgdG8gdXNlIHRo
YXQgaW5mb3JtYXRpb24gZnJvbSB1c2Vyc3BhY2UgdG8gaW5mbHVlbmNlDQo+IG1lbWNnIExSVSBv
cmRlcmluZywgYnV0IEknbSBub3QgcmVhbGx5IGEgZ3JlYXQgZmFuIG9mIHRoYXQgaWRlYS4NCj4g
DQo+IFJpZ2h0LCByZWNsYWltIGZyb20gZm9yZWdyb3VuZCBhcHBzIGlzIG5vdCBleGNsdXNpdmVs
eSBhIE1HTFJVDQo+IHByb2JsZW0uIFRoZXJlIGlzIGFuIGVmZm9ydCBpbiBib3RoIE1HTFJVIGFu
ZCBhY3RpdmUvaW5hY3RpdmUgTFJVIHRvDQo+IHByb3ZpZGUgc29tZSBzb3J0IG9mIGZhaXJuZXNz
IChub3cgYm90aCBhcmUgZXZlbnR1YWxseS1mYWlyKSBmb3INCj4gZ2xvYmFsIHJlY2xhaW0sIHNv
IHRoYXQgbm8gbWVtY2cgaXMgdGhlIHN1YmplY3Qgb2YgZGlzcHJvcG9ydGlvbmF0ZQ0KPiByZWNs
YWltLg0KSGkgVC5KLiwNCg0KWWVzLCBleGFjdGx5Lg0KDQo+IA0KPiBJJ20gcGxhbm5pbmcgdG8g
aW52ZXN0aWdhdGUgYXBwbHlpbmcgbWVtb3J5LmxvdyB0byBmb3JlZ3JvdW5kIC8NCj4gdG9wLWFw
cCBmb3IgcmVkdWNpbmcgdGhlIGFtb3VudCBvZiByZWNsYWltIGZyb20gZm9yZWdyb3VuZCBhcHBz
Lg0KPiBIb3dldmVyIGF0IHRoZSBzYW1lIHRpbWUsIHdlIGFyZSBhbHNvIHdvcmtpbmcgb24gYXBw
bHlpbmcgbWVtb3J5DQo+IGxpbWl0cyB0byBhbGwgYXBwcyAobWVtb3J5LmhpZ2gpIHNvIHRoYXQg
bm8gc2luZ2xlIGFwcCAoaW5jbHVkaW5nIGENCj4gZm9yZWdyb3VuZCBhcHApIGNhbiB1c2UgYWxs
IHRoZSBzeXN0ZW0gbWVtb3J5IGFzIGEgbWF0dGVyIG9mIEFuZHJvaWQNCj4gcG9saWN5Lg0KPiAN
Cj4gVGhhbmtzLA0KPiBULkouDQpUaGF0IHNvdW5kcyBnb29kIHRvIG1lLiBXZSdyZSBhbHNvIGV4
cGVyaW1lbnRpbmcgd2l0aCBhIHNpbWlsYXIgYXBwcm9hY2guDQoNCkluIG15IG9waW5pb24sIHRo
ZXNlIGtub2JzIGFyZSBhIGdvb2Qgb3Bwb3J0dW5pdHkgdG8gY29tYmluZSBzb21lIE1MDQphbmQg
YXV0b3R1bmluZyAoaW4gdXNlcnNwYWNlLCBub3QgaW4ga2VybmVsIHNwYWNlIGFzIHRoZSBrZXJu
ZWwtTUwNCnBhdGNoZXMgZGlkKToNCi0gZXhwbG9yZSBhIHJlYXNvbmFibGUgbWVtb3J5LmxvdyAv
IG1lbW9yeS5oaWdoIHJhbmdlIGZvciBhIGdpdmVuIGFwcCwNCiAgdG8gYm90aCBzYXZlIG1lbW9y
eSBhbmQgc3RpbGwga2VlcCBnb29kIFVYIChob3QgbGF1bmNoIC8gYW5pbWF0aW9ucyk7DQotIGNs
YXNzaWZ5IGFwcHMgaW50byBhIGZldyBjYXRlZ29yaWVzLCBhbmQgdGhlbiByZXVzZSB0aGUgdHVu
ZWQgbGltaXRzDQogIGZvciBhcHBzIGluIHRoZSBzYW1lIGNsYXNzLg0KDQpCZXN0LA0KWmljaGVu
Zw0KDQo+IA0KPiA+ID4gQWRkaXRpb25hbGx5LCBJ4oCZZCBsaWtlIHRvIGFkZCBRNSBiYXNlZCBv
biBteSBvYnNlcnZhdGlvbnM6DQo+ID4gPiBRNToNCj4gPiA+IE1HTFJVIHBsYWNlcyByZWFkYWhl
YWQgZm9saW9zIGluIHRoZSBuZXdlc3QgZ2VuZXJhdGlvbi4gRm9yIGV4YW1wbGUsIGlmDQo+ID4g
PiBhIHBhZ2UgZmF1bHQgb2NjdXJzIGF0IGFkZHJlc3MgNSwgcmVhZGFoZWFkIGZldGNoZXMgYWRk
cmVzc2VzIDHigJMxNiwgYW5kDQo+ID4gPiBhbGwgMTYgZm9saW9zIGFyZSBwdXQgaW4gdGhlIHlv
dW5nZXN0IGdlbmVyYXRpb24sIGV2ZW4gdGhvdWdoIG1hbnkgbWF5DQo+ID4gPiBub3QgYmUgbmVl
ZGVkLiBUaGlzIGNhbiBzZXJpb3VzbHkgaW1wYWN0IHJlY2xhbWF0aW9uIHBlcmZvcm1hbmNlLCBh
cw0KPiA+ID4gdGhlc2UgY29sZCByZWFkYWhlYWQgZm9saW9zIG9jY3VweSBhY3RpdmUgc2xvdHMu
DQo+ID4gPg0KPiA+ID4gU2VlIHRoZSBjb2RlIGJlbG93IGFuZCB0aGUgY2hlY2tzIHBlcmZvcm1l
ZCBieSBscnVfZ2VuX2luX2ZhdWx0KCkuDQo+ID4gPg0KPiA+ID4gdm9pZCBmb2xpb19hZGRfbHJ1
KHN0cnVjdCBmb2xpbyAqZm9saW8pDQo+ID4gPiB7DQo+ID4gPiAgICAgICAgIC4uLg0KPiA+ID4g
ICAgICAgICAvKiBzZWUgdGhlIGNvbW1lbnQgaW4gbHJ1X2dlbl9mb2xpb19zZXEoKSAqLw0KPiA+
ID4gICAgICAgICBpZiAobHJ1X2dlbl9lbmFibGVkKCkgJiYgIWZvbGlvX3Rlc3RfdW5ldmljdGFi
bGUoZm9saW8pICYmDQo+ID4gPiAgICAgICAgICAgICBscnVfZ2VuX2luX2ZhdWx0KCkgJiYgIShj
dXJyZW50LT5mbGFncyAmIFBGX01FTUFMTE9DKSkNCj4gPiA+ICAgICAgICAgICAgICAgICBmb2xp
b19zZXRfYWN0aXZlKGZvbGlvKTsNCj4gPiA+DQo+ID4gPiAgICAgICAgIGZvbGlvX2JhdGNoX2Fk
ZF9hbmRfbW92ZShmb2xpbywgbHJ1X2FkZCk7DQo+ID4gPiB9DQo+ID4gPiBFWFBPUlRfU1lNQk9M
KGZvbGlvX2FkZF9scnUpOw0KPiA+ID4NCj4gPiA+IEkgY291bGQgaGF2ZSBzdWJtaXR0ZWQgYSBw
YXRjaHNldCB0byBhZGRyZXNzIHRoaXMgYnkgaW5pdGlhbGx5IG1hcmtpbmcNCj4gPiA+IG9ubHkg
YWRkcmVzcyA1IGFzIGFjdGl2ZSwgYW5kIGFjdGl2YXRpbmcgdGhlIG90aGVyIGFkZHJlc3NlcyBs
YXRlciB3aGVuDQo+ID4gPiB0aGV5IGFyZSBhY3R1YWxseSBtYXBwZWQgb3IgYWNjZXNzZWQuDQo+
ID4NCj4gPiBJIG5lZWQgdG8gcmVhZCBpdCBtb3JlIGNsb3NlbHkgYnV0IHRoYXQncyBhIGdvb2Qg
aWRlYS4NCj4gPg0KPiA+IFRoYW5rcywNCj4gPiBZdWFuY2h1DQo+ID4NCg==

