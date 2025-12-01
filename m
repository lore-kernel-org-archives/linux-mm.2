Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 685C1D116E2
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 06:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80C786B0008; Mon,  1 Dec 2025 01:50:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BC656B000C; Mon,  1 Dec 2025 01:50:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB566B000D; Mon,  1 Dec 2025 01:50:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56B666B0008
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 01:50:27 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F2BA98AF63
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 06:50:26 +0000 (UTC)
X-FDA: 84169978452.18.73BE352
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4EC0880010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 06:50:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf02.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764571825; a=rsa-sha256;
	cv=none;
	b=kU8k4sXtAguex0DI1yMjnQTfHjk97352Vsc6AZCk4kKqQULaQsc5ZCTB54GZ1cm8tVQrTW
	nyXNP5VloV3VktkLhORc5Rg4IDsD7YNsvV3BBNJZjT2vv57H3ytkfjFEHE4LAfZFhWKFSJ
	wGa1UUPxxPlzLunDvQ5/ChXzM9dSYpo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf02.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764571825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eGlWUGAG7s6EVRk38wAAIjcC4lcOcxHd2i9TUzWkFf0=;
	b=oayvM3QE36H4gZY13dgTynPNz3mq94NHxJeS9Oq9use8QzGLaE2Uu1gZPrRFc4rxco2lZq
	XoIoWA7FrBXMJ+r9AqCNMYPP3wAKMEXTSPqYlQo/efan0CT9JKlSWJj2+fazMBnWGr7wix
	ntBzfqfjLGt0oSQuh1+XZpi8aioK1EU=
Received: from w011.hihonor.com (unknown [10.68.20.122])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4dKZGg5FmSzYsjNR;
	Mon,  1 Dec 2025 14:47:55 +0800 (CST)
Received: from w007.hihonor.com (10.68.16.91) by w011.hihonor.com
 (10.68.20.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Mon, 1 Dec
 2025 14:50:18 +0800
Received: from w002.hihonor.com (10.68.28.120) by w007.hihonor.com
 (10.68.16.91) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Mon, 1 Dec
 2025 14:50:18 +0800
Received: from w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3]) by
 w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3%14]) with mapi id
 15.02.2562.027; Mon, 1 Dec 2025 14:50:18 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Barry Song <21cnbao@gmail.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "david@redhat.com" <david@redhat.com>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "yuanchu@google.com"
	<yuanchu@google.com>, "mhocko@kernel.org" <mhocko@kernel.org>,
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"weixugc@google.com" <weixugc@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, wangtao <tao.wangtao@honor.com>, "wangzhen
 00021541" <wangzhen5@honor.com>, zhongjinji 00025326 <zhongjinji@honor.com>
Subject: RE: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
Thread-Topic: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
Thread-Index: AQHcYBJK8KKXMResfEqv9fHMnnJz9rUHrbeAgAAP74CAA+3ugIAApiiQ
Date: Mon, 1 Dec 2025 06:50:17 +0000
Message-ID: <86c62472b5874ea2833587f1847958df@honor.com>
References: <20251128025315.3520689-1-wangzicheng@honor.com>
 <aSm800KsCAptVZKu@casper.infradead.org>
 <ti7h5cbrg5s3zf7surof3zmxb6supnl34x7hsbziqutm7r2laf@zuunap5hwsbx>
 <CAGsJ_4xJ5qMght93FQOYrk1OiJTh-wFC4e8Nd4K0A156N3ZEBQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4xJ5qMght93FQOYrk1OiJTh-wFC4e8Nd4K0A156N3ZEBQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4EC0880010
X-Stat-Signature: eiab59dqibne49whybdx9yzodxz99ju3
X-Rspam-User: 
X-HE-Tag: 1764571823-947964
X-HE-Meta: U2FsdGVkX1/2/gm48xLIx9ANIuh6aRaf01UawHLQahbin3KgM98oBsNU6aERrfGZTlzkkUsYxm5/JO6/wPElkNV6AudkbaLUid1m7bUzDlifCcVr0fOf1rfvUBn5Et+NMtrRRZd4PVJGeHE0bALVoCyDwSo3E6VBoLB7a0qlF2d40rxXzj1uhRWdaoBYwcUifgu4txvyVkAI1XJLbo3hqtUOO9SkltG01qzjNYrzWy/j+sPMuUZznm8cwN/tiKwodawHFwlcRMxVt/y4eUVjvosJj/mR2qPOgmIvXI07W98tymifKycaAmpMdQkAckFd33WFs7khl7DNGk7LvEftTo60OkMjlCHIlveReA0JULi09mJSKlI/n21/PsWbw2OJfjTI+fmBos1S/Y5B0xYrCrmDxR+lXGxolKCfQ/P+TDrDlMPE4qaf2ZFSmk4GiiwLnAGA7/4yg/lof+uxq6xo4vrlduzf6zvxfwW7RpFEfE8hYoAeeUZNsmMYuGVyY7hlNyzsce885vMe6Y+zV5IwIa1Og9GvTsA3uy4QeELQp4U8bKc8fK5AyU6JROsYWzTHnvs59WrI+KkXnd9qxIWZdg5tNYW0kHG0trGOK3UTzUoWMFSEdSKUetRN8J4MV63a/A8s9cf5W3xJj1bu0MGvjlNNulAnJgR1Nk2flF5i8scrZuTeIXE/+oQx2AhDa54U17gIfl2M7FDfLy4m8JtxTJxBiTVC7rAyIg15kQ1XIVYygcQbntlRe7GOkNy/fzaou6g+UfOhv5i5s9SlWtz1wl/DRnhUjh+Z5mBs9aTtKUxxJ4ilf0D5V3+aG78h8r8bfjivn/kKCN/YgR/GOBecf4EWo2qebg/uBDooHu9fq6M2bo9vsIFwTenqI9z+tnfJBRXismse79JxWt678f8uonwxTAjJMIgOux3fDNUNDacVbEh29lOpwN5vsEO21pk1JkVsN92oMytm+zqkV5g
 kIS79FSf
 4oELJpDRgd8LkXxskH0BW2qrJ1XbBfD+L/+NC8YU2RlPeTcBEuRuyI0Hk4KAxl1MCSOJxFFZzQOIMVo2hqan8sOrAHYncfpHznRzLMQZ/pqLF+WgPN9oYNpFk5BcRKe5I2EbNP7Bm9AFj/TXXVWzhSYWS3JYz56ZEDn71hgeLaO7PmvZg1CBY5oOxdY8Kebb9GeOhpMmx2qN9jdExBcRTjQi1iwmkpwILdw40VL1mXeaHRNdRWARggzyz2E31zWaAsRWwY9vJUrN6HMtiFE6H6DSG3RJVSaI+ovcg5uxv8NES2CjaT39ZtAAGk/RJshj/n3fdFMjfngWpgwR8CSixceeu7J2XQ47srKJT9RKQRwfoZ0XbAObehU1oEbjn/BkUo+aDJO74W3EapX9PeH2i++c6jniz9vbBhCOAJLJrvLWaPXKoCFULuvO9H55UaO/ihqLgXs+Br5nAWbl9JaCZn4Mc5ysplVM7fDUQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgQmFycnksDQoNCj4gSGkgTGlhbSwNCj4gDQo+IEkgc2F3IHlvdSBtZW50aW9uZWQgbWUsIHNv
IEkganVzdCB3YW50ZWQgdG8gam9pbiBpbiA6LSkNCj4gDQo+IE9uIFNhdCwgTm92IDI5LCAyMDI1
IGF0IDEyOjE24oCvQU0gTGlhbSBSLiBIb3dsZXR0IDxMaWFtLkhvd2xldHRAb3JhY2xlLmNvbT4N
Cj4gd3JvdGU6DQo+ID4NCj4gPiAqIE1hdHRoZXcgV2lsY294IDx3aWxseUBpbmZyYWRlYWQub3Jn
PiBbMjUxMTI4IDEwOjE2XToNCj4gPiA+IE9uIEZyaSwgTm92IDI4LCAyMDI1IGF0IDEwOjUzOjEy
QU0gKzA4MDAsIFppY2hlbmcgV2FuZyB3cm90ZToNCj4gPiA+ID4gQ2FzZSBzdHVkeToNCj4gPiA+
ID4gQSB3aWRlbHkgb2JzZXJ2ZWQgaXNzdWUgb24gQW5kcm9pZCBpcyB0aGF0IGFmdGVyIGFwcGxp
Y2F0aW9uDQo+ID4gPiA+IGxhdW5jaCwNCj4gPg0KPiA+IFdoYXQgZG8geW91IG1lYW4gYnkgYXBw
bGljYXRpb24gbGF1bmNoPyAgV2hhdCBkb2VzIHRoaXMgbWVhbiBpbiB0aGUNCj4gPiBrZXJuZWwg
Y29udGV4dD8NCj4gDQo+IEkgdGhpbmsgdGhlcmUgYXJlIHR3byBjYXNlcy4gRmlyc3QsIGEgY29s
ZCBzdGFydDogYSBuZXcgcHJvY2VzcyBpcyBmb3JrZWQgdG8NCj4gbGF1bmNoIHRoZSBhcHAuIFNl
Y29uZCwgd2hlbiB0aGUgYXBwIHN3aXRjaGVzIGZyb20gYmFja2dyb3VuZCB0bw0KPiBmb3JlZ3Jv
dW5kLCBmb3IgZXhhbXBsZSB3aGVuIHdlIGJyaW5nIGl0IGJhY2sgdG8gdGhlIHNjcmVlbiBhZnRl
ciBpdCBoYXMNCj4gYmVlbiBydW5uaW5nIGluIHRoZSBiYWNrZ3JvdW5kLg0KPiANCj4gSW4gdGhl
IGZpcnN0IGNhc2UsIHlvdSByZWJvb3QgeW91ciBwaG9uZSBhbmQgdGFwIHRoZSBZb3VUdWJlIGlj
b24gdG8gc3RhcnQNCj4gdGhlIGFwcCAoY29sZCBsYXVuY2gpLiBJbiB0aGUgc2Vjb25kIGNhc2Us
IHlvdSBhcmUgd2F0Y2hpbmcgYSB2aWRlbyBpbg0KPiBZb3VUdWJlLCB0aGVuIHN3aXRjaCB0byBG
YWNlYm9vaywgYW5kIGxhdGVyIHRhcCB0aGUgWW91VHViZSBpY29uIGFnYWluIHRvDQo+IGJyaW5n
IGl0IGZyb20gYmFja2dyb3VuZCB0byBmb3JlZ3JvdW5kLg0KPiANClRoYW5rcyBmb3IgdGhlIGV4
cGxhaW4sIHRoYXQncyBleGFjdGx5IHdoYXQgSSBtZWFudC4gIA0KDQpBbmRyb2lkIGxpZmVjeWNs
ZSBtb2RlbCBpc24ndCBvYnZpb3VzIG91dHNpZGUgdGhlIEFuZHJvaWQgY29udGV4dC4gSeKAmWxs
IG1ha2UgdGhhdCANCmNsZWFyZXIgaW4gdGhlIG5leHQgdmVyc2lvbi4NCj4gPg0KPiA+ID4gPiB0
aGUgb2xkZXN0IGFub24gZ2VuZXJhdGlvbiBvZnRlbiBiZWNvbWVzIGVtcHR5LCBhbmQgZmlsZSBw
YWdlcyBhcmUNCj4gPiA+ID4gb3Zlci1yZWNsYWltZWQuDQo+ID4gPg0KPiA+ID4gWW91IHNob3Vs
ZCBmaXggdGhlIGJ1Zywgbm90IG1vdmUgdGhlIGRlYnVnIGludGVyZmFjZSB0byBwcm9jZnMuICBO
QUNLLg0KPiA+DQo+ID4gQmFycnkgcmVjZW50bHkgc2VudCBhbiBSRkMgWzFdIHRvIGFmZmVjdCBM
UlUgaW4gdGhlIGV4aXQgcGF0aCBmb3INCj4gPiBBbmRyb2lkLiAgVGhpcyB3YXMgcHJvdmVuIGlu
Y29ycmVjdCBieSBKb2hhbm5lcywgaWlyYywgaW4gYW5vdGhlcg0KPiA+IHRocmVhZCBJIGNhbm5v
dCBmaW5kIChkZXN0cm95cyBwZXJmb3JtYW5jZSBvZiBjYWxsaW5nIHRoZSBzYW1lIGNvbW1hbmQp
Lg0KPiANCj4gTXkgdW5kZXJzdGFuZGluZyBpcyB0aGF0IGFmZmVjdGluZyB0aGUgTFJVIGluIHRo
ZSBleGl0IHBhdGggaXMgbm90IGdlbmVyYWxseQ0KPiBjb3JyZWN0LCBidXQgaXQgc3RpbGwgaGln
aGxpZ2h0cyBhIHJlcXVpcmVtZW50OiBMaW51eCBMUlUgbmVlZHMgYSB3YXkgdG8NCj4gdW5kZXJz
dGFuZCBhcHAtY3ljbGluZyBiZWhhdmlvciBpbiBhbiBBbmRyb2lkLWxpa2Ugc3lzdGVtLg0KPiAN
Cj4gPg0KPiA+IFRoZXNlIGlkZWFzIHNlZW0gYm90aCByZWxhdGVkIGFzIGl0IHBvaW50cyB0byBh
IHN1Ym9wdGltYWwgTFJVIGluIHRoZQ0KPiA+IEFuZHJvaWQgZWNvc3lzdGVtLCBhdCBsZWFzdC4g
IEl0IHNlZW1zIHRvIHN0ZW0gZnJvbSBBbmRyb2lkcyBsaWZlDQo+ID4gKGN5Y2xlKSBjaG9pY2Vz
IDopDQo+ID4NCj4gPiBJIHN0cm9uZ2x5IGFncmVlIHdpdGggV2lsbHkuICBXZSBkb24ndCB3YW50
IGFub3RoZXIgdXNlcnNwYWNlIGRhZW1vbg0KPiA+IGFuZC9vciBpbnRlcmZhY2UsIGJ1dCB0aGlz
IHRpbWUgdG8gcGxheSB3aXRoIHRoZSBMUlUgdG8gYXZvaWQgdHJ5aW5nDQo+ID4gdG8gZGVmaW5l
IGFuZCBmaXggdGhlIHByb2JsZW0uDQo+ID4NCj4gPiBEbyB5b3Uga25vdyBpZiB0aGlzIGFmZmVj
dHMgb3RoZXJzIG9yIHdoeSBpdCBpcyBhbmRyb2lkIHNwZWNpZmljPw0KPiANCj4gVGhlIGJlaGF2
aW9yIFppY2hlbmcgcHJvYmFibHkgd2FudHMgaXMgYSBwcm9hY3RpdmUgbWVtb3J5IHJlY2xhbWF0
aW9uDQo+IGludGVyZmFjZS4gRm9yIGV4YW1wbGUsIHNpbmNlIGVhY2ggYXBwIG1heSBiZSBpbiBh
IGRpZmZlcmVudCBtZW1jZywgaWYgYW4NCj4gYXBwIGhhcyBiZWVuIGluIHRoZSBiYWNrZ3JvdW5k
IGZvciBhIGxvbmcgdGltZSwgaGUgd2FudHMgdG8gcmVjbGFpbSBpdHMNCj4gbWVtb3J5IHByb2Fj
dGl2ZWx5IHJhdGhlciB0aGFuIHdhaXRpbmcgdW50aWwga3N3YXBkIGhpdHMgdGhlIHdhdGVybWFy
a3MuDQo+IA0KPiBUaGlzIG1heSBoZWxwIGEgbmV3bHkgbGF1bmNoZWQgYXBwIG9idGFpbiBtZW1v
cnkgbW9yZSBxdWlja2x5LCBhdm9pZGluZw0KPiBkZWxheXMgZnJvbSByZWNsYW1hdGlvbiwgc2lu
Y2UgYSBuZXcgYXBwIHR5cGljYWxseSByZXF1aXJlcyBhIHN1YnN0YW50aWFsDQo+IGFtb3VudCBv
ZiBtZW1vcnkuDQo+IA0KPiBaaWNoZW5nLCBwbGVhc2UgbGV0IG1lIGtub3cgaWYgSeKAmW0gbWlz
dW5kZXJzdGFuZGluZyBhbnl0aGluZy4NCg0KWWVzLCBidXQgbm90IGxlYXN0Lg0KDQoxLiBwcm9h
Y3RpdmUgbWVtb3J5IHJlY2xhaW06IHllcywgdGhhdCdzIHdlIGFyZSBhZnRlci4gDQpXaGVuIGFu
IGFwcCBpcyBzd2lwZWQgYXdheSBhbmQga2VwdCBpbiB0aGUgYmFja2dyb3VuZCBhbmQgbm90IHVz
ZSBmb3IgYSB3aGlsZSwgDQpwcm9hY3RpdmVseSByZWNsYWltaW5nIGl0cyBtZW1jZyBjYW4gaGVs
cCBuZXcgZm9yZWdyb3VuZCBhcHBzIGdldCBtZW1vcnkgDQpmYXN0ZXIgKGluc3RlYWQgb2YgcGF5
aW5nIHRoZSBjb3N0IG9mIGRpcmVjdCByZWNsYWltKS4NCg0KMi4gQW5vbiB2LnMuIEZpbGU6ICpi
aWFzIG1vcmUgdG93YXJkcyBhbm9ueW1vdXMqIHBhZ2VzIGZvciBiYWNrZ3JvdW5kIGFwcHMuDQpX
aXRoIG1nbHJ1LCBob3dldmVyLCB0aGUgb2xkZXN0IGdlbmVyYXRpb25zIG9mdGVuIGNvbnRhaW4g
YWxtb3N0IG5vIGFub24gcGFnZXMsDQpzbyBzaW1wbHkgdHVuaW5nIHN3YXBwaW5lc3MgY2Fubm90
IGFjaGlldmUgdGhhdCAtLSByZWNsYWltIHdpbGwgc3RpbGwgY2xlYXIgZmlsZSBjYWNoZQ0KaW4g
dGhlIG9sZCBnZW5lcmF0aW9ucyBmaXJzdC4NClRvIHNvbWUgZXh0ZW50LCBmaWxlIGNhY2hlcyBh
cmUgYG92ZXItcmVjbGFpbWVkYCBpbiBzdWNoIHNlbmFyaW8sIGxlYWRpbmcgdG8gYSBkaXNhc3Rl
cg0Kd2hlbiB1c2Vy4oCRaW50ZXJhY3Rpb24gdGhyZWFkcyBnZXQgc3R1Y2sgaW4gZGlyZWN0IHJl
Y2xhaW0gb2YgYW5vbiBwYWdlcy4NCg0KU2VlIHRoZSBjYXNlIGluIHRoZSBjb3ZlciBsZXR0ZXIu
DQpgYGANCm1lbWNnICAgIDU0IC9hcHBzL3NvbWVfYXBwDQpub2RlICAgICAwDQoxICAgICAxMTk4
MDQgICAgICAgICAgMCAgICAgICA4NTQ2MQ0KMiAgICAgMTE5ODA0ICAgICAgICAgIDAgICAgICAg
ICAgIDUNCjMgICAgIDExOTgwNCAgICAgMTgxNzE5ICAgICAgIDE4NjY3DQo0ICAgICAgIDE3NTIg
ICAgICAgIDM5MiAgICAgICAgIDI0NA0KYGBgDQoNCj4gDQo+ID4NCj4gPiBbMV0uDQo+ID4gaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjUwNTE0MDcwODIwLjUxNzkzLTEtMjFjbmJhb0Bn
bWFpbC5jb20vDQo+ID4NCj4gDQo+IFRoYW5rcw0KPiBCYXJyeQ0KDQpTaW5jZSB0aGUgc2VtYW50
aWMgZ2FwIGJldHdlZW4gdXNlci9rZXJuZWwgc3BhY2Ugd2lsbCBhbHdheXMgZXhpc3QuDQpJdCB3
b3VsZCBiZSBncmVhdCBiZW5lZml0cyBmb3IgbGVhdmluZyBzb21lIEFQSXMgZm9yIHVzZXIgaGlu
dHMsIGp1c3QgbGlrZSANCm1tYWR2aXNlL3VzZXJmYXVsdC9wYXJhLXZpcnR1YWxpemF0aW9uLg0K
RXhwb3Npbmcgc3VjaCBoaW50cyB0byB0aGUga2VybmVsIGNhbiBoZWxwIGltcHJvdmUgb3ZlcmFs
bCBzeXN0ZW0gcGVyZm9ybWFuY2UuDQoNCkJlc3QsDQpaaWNoZW5nIA0K

