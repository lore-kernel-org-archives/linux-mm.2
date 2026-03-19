Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 878C21075294
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 10:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5BB06B045F; Thu, 19 Mar 2026 06:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C336A6B0460; Thu, 19 Mar 2026 06:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B493C6B0461; Thu, 19 Mar 2026 06:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EAF16B045F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:12:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3319F160488
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:12:59 +0000 (UTC)
X-FDA: 84562399278.12.3B41F01
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8471F4000D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:12:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=QIr6+U7+;
	spf=pass (imf17.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773915177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYfUUB2w8MkGPd5J5lEXHMkkvm0S/zMakRbGMP1txFA=;
	b=rguW3mxkI6f7Vs3lCLjY1ONmQYjrzserPNVmpLpUTh5tA1wt/YAQHrkfrgpfH5xzA+9/gy
	GQM2rO3v2iVikjaRgrlycVezqk795lXP4OoLL7YmtTOYAucCUKJGa85TDI/tuVLjJMxuE7
	qq9PQIHyrFW+JTz2l12VQ0A3ELqjHNk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=QIr6+U7+;
	spf=pass (imf17.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773915177; a=rsa-sha256;
	cv=none;
	b=dgJkqOQyN9jfXCZ4aOLhHay1As+JvaRXJOurmblFnwe/2XTZ5JamKAYZ/F3Bf8FfVhyfe7
	UVQ/1nrhgmNpE0VN26fy2JLpxdbRXArhSycuLyMMpy5ABKgaxFtGNaghuEpvsitsiIoEZL
	F97lcYrRgyGivqrQ6D1ZFKQWQYEAfnY=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=pYfUUB2w8MkGPd5J5lEXHMkkvm0S/zMakRbGMP1txFA=;
	b=QIr6+U7+oxB+hLvLgA2YEtsd0/pGOkJVUrOzrUU4LKO4FH1oRkOwxeUCQt6i7HOmOXfYav3Kg
	172dxrDXlrzQ/OzAb4zxDJfUnWbLvfC18aFaXfz5ex4NsiTfe7JAWe7xeDC6m0pfKu08/hjBWUU
	VbzafivWuu/ilyGtvpDhAzA=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4fc1d95ybkzYlKBG;
	Thu, 19 Mar 2026 18:09:17 +0800 (CST)
Received: from TA005.hihonor.com (10.72.0.137) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 19 Mar
 2026 18:12:50 +0800
Received: from TA012.hihonor.com (10.77.228.68) by TA005.hihonor.com
 (10.72.0.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Thu, 19 Mar
 2026 18:12:19 +0800
Received: from TA012.hihonor.com ([fe80::9e31:9fdb:69fb:928c]) by
 TA012.hihonor.com ([fe80::9e31:9fdb:69fb:928c%8]) with mapi id
 15.02.2562.017; Thu, 19 Mar 2026 18:12:45 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Barry Song <21cnbao@gmail.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Lei
 Liu" <liulei.rjpt@vivo.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, Tangquan Zheng
	<zhengtangquan@oppo.com>, wangtao <tao.wangtao@honor.com>, liulu 00013167
	<liulu.liu@honor.com>
Subject: RE: [PATCH RFC] mm/mglru: lazily activate folios while folios are
 really mapped
Thread-Topic: [PATCH RFC] mm/mglru: lazily activate folios while folios are
 really mapped
Thread-Index: AQHcprbIkLI8koBjtkqDPEnVc1b3J7WU7U8wgAA7mwCAAsHsUIAApfGAgB0Th/A=
Date: Thu, 19 Mar 2026 10:12:45 +0000
Message-ID: <d11be6d7aaf14d6e8542c5bfb56bb0c1@honor.com>
References: <20260225223712.3685-1-21cnbao@gmail.com>
 <2558f7d82b9a482387960f45409e1b76@honor.com>
 <CAGsJ_4wV=OpV-ntZQGKQawrO0kemwdT8byySBCCZiOOgugcQtw@mail.gmail.com>
 <adfc0959cf294aa4ab71c60ee1e35720@honor.com>
 <CAGsJ_4xUA9MfzYbTdpGsLsWoRb5ORV=_Vi6-jDh6VC=guOdcbQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4xUA9MfzYbTdpGsLsWoRb5ORV=_Vi6-jDh6VC=guOdcbQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Queue-Id: 8471F4000D
X-Stat-Signature: ajzikfc99cek3s3hugtf7hur8n8fyuwm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773915176-788276
X-HE-Meta: U2FsdGVkX1/enCiE/Ae9GlDrRqC4YRSKJUGq4vz0R4Z8GnHtJUAgBKBe2C38kX1vPvbIGmxHRIlLdqpPftOOM/Ummt+l8PdfsIe0fqeNeXaz9s2MXVDc9acNHIF6VDiTH4mcoGq6xzodhqoZRu1sx5Mr/avER7JvOGrSNJ7Je4H/VJD+yib4BrHBv2aqlBUpX/RClKjbaSgrbGi2qJ1o34ZGTlBUm8otbGrAawuoaVibBO5W+mjmpsuyZV75/xjzAAbSGIQhBUOw6+UKkKV46i5itXd0/FhVkU8PTbW7Y728Hu9AfoLksC4x+NGLbjfzjWX6c3MWHNIDXq3G9hG78vpSo9DxaJAukeRwaEb428/0fQclI0TXJkRs3ZK+W6/338Fu0N8mB57NwgjT80R4Sn0/AYVUklvaYmG+pwJGAADLKiNm6Vg4TyKpnGnSwLKChbm0fXnEuTpDTisgB4ObwvREdeU2l9Wayf1HEBFMDDc/nh2QYkycYR6OP7DGMI4LH4Rre99MBFghLxIOs06AbBDUzXkgfo5BlzPhihZ0oHl6E+zYauvDJiRTijaElwfcxPNYHoB14HOuNwbl/vZFZf23OtA4GtvD+vGRw/NLonFlWPDNszQXDngt6LBF6NTxWaSfXqdUhH29O56dJikmr5gsQAfRTIuZNfFxN5iA/lJVMRZ7AvJuBgpF9SOaTMemq/ZnojrLOw2ZTYsWiiCnPylC1MuUSQgs63aQ+orJgiYl7vBq2kVGeG9oZiSAK2h+OtbW36uYx0vNzQ/4kYLapdJ6GkIUONMjew/A585MulKHYvyPKtaA0tUqBUxOv+OjQGHXCmyhdaxtQ6eIS7J08Xb/i9a+5cx7Efb0KAKXdka+uvZLgwroHry3iiuxWEtvmcMvr0kYqS72N2jFEw5c7pqFHeVf7/zokIqw8p5Wu7aayNRFNgiaJ+i86vWDQLRJIpjVJXaFvSYK4jiLEHO
 igbAReot
 qn/NPkyMf1skG9dtPURpRh62dU0FOEPcpGYzFvskQtGOy21DQx/MbxR3sgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgQmFycnksDQoNClRoYW5rIHlvdSBmb3IgdGhlIHN1Z2dlc3Rpb24uDQoNCkkgaGF2ZSByZS1k
ZXNpZ25lZCB0aGUgd29ya2xvYWQgYW5kIGdldCB0aGUgcmVsYXRpdmUgcHJvbWlzaW5nIHJlc3Vs
dHMuDQpUaGUgd29ya2xvYWQgcmVwZWF0ZWRseSBsYXVuY2hlcyBhbmQgc3dpdGNoZXMgYmV0d2Vl
biAzMCBhcHBzDQpmb3IgNTAwIHJvdW5kcy4gU2luY2UgdGhlIHRlc3QgdGFrZXMgcXVpdGUgYSBs
b25nIHRpbWUsIHRoZSBmaW5hbCByZXN1bHRzDQphcHBlYXIgcmVsYXRpdmVseSBzdGFibGUgYWNy
b3NzIHJ1bnMuDQoNClRoZSB0ZXN0aW5nIHdhcyBkb25lIG9uIGFuIEFuZHJvaWQgMTYgZGV2aWNl
IHdpdGgga2VybmVsIDYuNi44OSwNCjhHQiBSQU0sIE1HTFJVIGVuYWJsZWQuDQoNCkhvd2V2ZXIs
IHRoZSByZXN1bHRzIGFyZSBub3QgdmVyeSBlYXN5IHRvIGludGVycHJldC4NCg0KQXZlcmFnZSBu
dW1iZXIgb2Yga2VwdC1hbGl2ZSBhcHBzOiDCsTAuMDggYXBwcw0KQXZlcmFnZSBhdmFpbGFibGUg
bWVtb3J5IChzYW1wbGVkIGFmdGVyIGVhY2ggYXBwIGxhdW5jaCk6DQpiYXNlbGluZSB2cyBwYXRj
aGVkOiAyMjE2TUIgdnMgMjIxOE1CICh+Mk1CIGRpZmZlcmVuY2UpDQoNCkJlbG93IGlzIHRoZSB2
bXN0YXQgY29tcGFyaXNvbiAocGF0Y2hlZCB2cyBiYXNlbGluZSk6DQoNCk1ldHJpYyAgICAgICAg
ICAgICAgICAgICAgICAgQ2hhbmdlDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gIC0tLS0t
LS0tDQpwZ3BnaW4gICAgICAgICAgICAgICAgICAgICAgICsyLjA2JQ0KcGdwZ291dCAgICAgICAg
ICAgICAgICAgICAgICArMy4xMCUNCnBzd3BpbiAgICAgICAgICAgICAgICAgICAgICAgKzE0LjEz
JQ0KcHN3cG91dCAgICAgICAgICAgICAgICAgICAgICArNC41NSUNCnBnZmF1bHQgICAgICAgICAg
ICAgICAgICAgICAgLTMuMTklDQpwZ21hamZhdWx0ICAgICAgICAgICAgICAgICAgICsxMi43NSUN
CndvcmtpbmdzZXRfcmVmYXVsdF9hbm9uICAgICAgKzE0Ljc3JQ0Kd29ya2luZ3NldF9yZWZhdWx0
X2ZpbGUgICAgICArMy40OCUNCndvcmtpbmdzZXRfYWN0aXZhdGVfYW5vbiAgICAgLTMuNDUlDQp3
b3JraW5nc2V0X2FjdGl2YXRlX2ZpbGUgICAgIC0xNy43NiUNCndvcmtpbmdzZXRfcmVzdG9yZV9h
bm9uICAgICAgLTMuNDQlDQp3b3JraW5nc2V0X3Jlc3RvcmVfZmlsZSAgICAgIC0xOS4xMyUNCg0K
SW4gdjYuNiwgd2hlbiBQR19hY3RpdmUgaXMgc2V0LCBwYWdlcyBnbyB0byB0aGUgeW91bmdlc3Qg
Z2VuZXJhdGlvbiwNCndoaWxlIHBhZ2VzIHdpdGhvdXQgUEdfYWN0aXZlIGdvIHRvIHRoZSBzZWNv
bmQgb2xkZXN0IGdlbmVyYXRpb24uDQpgYGANCnN0YXRpYyBpbmxpbmUgYm9vbCBscnVfZ2VuX2Fk
ZF9mb2xpbygNCi4uLg0KICAgICAgICAgICAgICBpZiAoZm9saW9fdGVzdF9hY3RpdmUoZm9saW8p
KQ0KCQlzZXEgPSBscnVnZW4tPm1heF9zZXE7DQoJLi4uDQoJZWxzZQ0KCQlzZXEgPSBscnVnZW4t
Pm1pbl9zZXFbdHlwZV0gKyAxOw0KYGBgDQoNCk15IHJvdWdoIGV4cGVjdGF0aW9uIHdhcyB0aGF0
IHRoZSBwYXRjaCBzaG91bGQgbWFrZSBmaWxlIHBhZ2VzIG1vcmUNCnByb25lIHRvIHJlY2xhaW0g
YW5kIG1ha2UgZmlsZSBwYWdlIGhvdC9jb2xkIGFnaW5nIG1vcmUgYWNjdXJhdGUsIHNvDQpib3Ro
IGZpbGUgcmVmYXVsdCBhbmQgYW5vbiByZWZhdWx0IG1pZ2h0IGRlY3JlYXNlLiBCdXQgaGVyZSBh
bm9uIHJlZmF1bHQNCmluY3JlYXNlcyBpbnN0ZWFkLg0KDQpJ4oCZbSBub3Qgc3VyZSBpZiB0aGlz
IGFzc3VtcHRpb24gaXMgY29ycmVjdC4gQ291bGQgeW91IHNoYXJlIHlvdXIgdGhvdWdodHMNCm9u
IGhvdyB0byBpbnRlcnByZXQgdGhlc2UgcmVzdWx0cz8NCg0KVGhhbmtzLA0KWmljaGVuZw0KDQo+
IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IG93bmVyLWxpbnV4LW1tQGt2YWNr
Lm9yZyA8b3duZXItbGludXgtbW1Aa3ZhY2sub3JnPiBPbiBCZWhhbGYNCj4gT2YgQmFycnkgU29u
Zw0KPiBTZW50OiBTdW5kYXksIE1hcmNoIDEsIDIwMjYgMTI6MTYgUE0NCj4gVG86IHdhbmd6aWNo
ZW5nIDx3YW5nemljaGVuZ0Bob25vci5jb20+DQo+IENjOiBha3BtQGxpbnV4LWZvdW5kYXRpb24u
b3JnOyBsaW51eC1tbUBrdmFjay5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3Jn
OyBTdXJlbiBCYWdoZGFzYXJ5YW4gPHN1cmVuYkBnb29nbGUuY29tPjsgTGVpIExpdQ0KPiA8bGl1
bGVpLnJqcHRAdml2by5jb20+OyBNYXR0aGV3IFdpbGNveCAoT3JhY2xlKSA8d2lsbHlAaW5mcmFk
ZWFkLm9yZz47DQo+IEF4ZWwgUmFzbXVzc2VuIDxheGVscmFzbXVzc2VuQGdvb2dsZS5jb20+OyBZ
dWFuY2h1IFhpZQ0KPiA8eXVhbmNodUBnb29nbGUuY29tPjsgV2VpIFh1IDx3ZWl4dWdjQGdvb2ds
ZS5jb20+OyBLYWlydWkgU29uZw0KPiA8a2Fzb25nQHRlbmNlbnQuY29tPjsgVGFuZ3F1YW4gWmhl
bmcgPHpoZW5ndGFuZ3F1YW5Ab3Bwby5jb20+Ow0KPiB3YW5ndGFvIDx0YW8ud2FuZ3Rhb0Bob25v
ci5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggUkZDXSBtbS9tZ2xydTogbGF6aWx5IGFjdGl2
YXRlIGZvbGlvcyB3aGlsZSBmb2xpb3MgYXJlDQo+IHJlYWxseSBtYXBwZWQNCj4gDQo+IE9uIFNh
dCwgRmViIDI4LCAyMDI2IGF0IDY6MjjigK9QTSB3YW5nemljaGVuZyA8d2FuZ3ppY2hlbmdAaG9u
b3IuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IEhpIEJhcnJ5LA0KPiA+ID4NCj4gPiA+IEkgZmlu
ZCB5b3VyIGNvbmNlcm4gYSBiaXQgc3VycHJpc2luZy4gSWYgSSB1bmRlcnN0YW5kIGNvcnJlY3Rs
eSwNCj4gPiA+IHlvdeKAmXJlIG9ic2VydmluZyB0aGF0IGZpbGUgZm9saW9zIGFyZSBjdXJyZW50
bHkgYmVpbmcgb3Zlci1yZWNsYWltZWQuDQo+ID4gPiBJbiB0aGF0IGNhc2UsIHBsYWNpbmcgaG90
IHBhZ2VzIGF0IHRoZSB0YWlsIG1pZ2h0IG1ha2UgdGhlbSBoYXJkZXINCj4gPiA+IHRvIHJlY2xh
aW0gYWZ0ZXIgUFRFIHNjYW5uaW5nIChzaW5jZSB0aGV5IG1heSBzdGlsbCBiZSB5b3VuZyksIGJ1
dA0KPiA+ID4gdGhpcyBzZWVtcyB0byB2aW9sYXRlIHRoZSBmdW5kYW1lbnRhbCBwcmluY2lwbGUg
b2YgTFJVLiBNb3Jlb3ZlciwNCj4gPiA+IHdoZW4gc2Nhbm5pbmcgZW5jb3VudGVycyB5b3VuZyBm
aWxlIGZvbGlvcywgcmVjbGFpbSB3aWxsIHNpbXBseQ0KPiA+ID4gY29udGludWUgc2Nhbm5pbmcg
bW9yZSBmb2xpb3MgdG8gZmluZCByZWNsYWltYWJsZSBvbmVzLCBzbyBzY2FubmluZw0KPiA+ID4g
aG90IGZvbGlvcyBvbmx5IHdhc3RlcyBDUFUgdGltZS4NCj4gPiA+IFNpbmNlIHJlYWQtYWhlYWQg
Y29sZCBmb2xpb3MgYXJlIHBsYWNlZCBhdCB0aGUgaGVhZCwgcmVsYXRpdmVseSBob3R0ZXINCj4g
PiA+IGZvbGlvcyBtYXkgYmUgcmVjbGFpbWVkIGluc3RlYWQsIGNhdXNpbmcgcmVmYXVsdHMgYW5k
IGZ1cnRoZXIgdHJpZ2dlcmluZw0KPiA+ID4gcmVjbGFpbSwgd2hpY2ggY2FuIHdvcnNlbiB0aGUg
c2l0dWF0aW9uLg0KPiA+ID4NCj4gPiBUaGFuayB5b3UgZm9yIHRoZSBkZXRhaWxlZCBleHBsYW5h
dGlvbi4NCj4gPiA+ID4NCj4gPiA+ID4gV2UnbGwgdGVzdCB0aGlzIHdoZW4gYXZhaWxhYmxlIGFu
ZCByZXBvcnQgYmFjay4gV2UgaG9wZSB0byBoYXZlIGENCj4gPiA+ID4gY2hhbmNlIHRvIGRpc2N1
c3MgdGhpcyB0b3BpYyBhdCBMU0YvTU0vQlBGLg0KPiA+ID4gPg0KPiA+ID4NCj4gPiA+IFN1cmUs
IHRoYW5rcyENCj4gPiA+DQo+ID4gPiBCYXJyeQ0KPiA+DQo+ID4gRm9yIGV2YWx1YXRpb24gSeKA
mW0gdXNpbmcgYSB3b3JrbG9hZCB0aGF0IHJlcGVhdGVkbHkgY29sZC1zdGFydHMgYW5kDQo+ID4g
ZHJpdmVzIHNhbWUgdXNlciBhY3Rpb25zIGluIDIwKyBhcHBzIG9uIEFuZHJvaWQuDQo+ID4gSeKA
mW0gY29tcGFyaW5nIGJhc2VsaW5lKHY2LjYpIHZzLiB0aGUgcGF0Y2hlZCBrZXJuZWwgYW5kIHdh
dGNoaW5nDQo+ID4gYC9wcm9jL3Ztc3RhdCAtPiB3b3JraW5nc2V0X3JlZmF1bHRfZmlsZWAsIGV4
cGVjdGluZyBpdCB0byBnbyBkb3duLg0KPiA+DQo+ID4gSSByYW4gMyBydW5zIHBlciBrZXJuZWws
IGJ1dCBgd29ya2luZ3NldF9yZWZhdWx0X2ZpbGVgIGlzIHF1aXRlIG5vaXN5LA0KPiA+IHRoZSBD
b2VmZmljaWVudCBvZiBWYXJpYXRpb24gaXMgYXJvdW5kIDQwJSwgc28gdGhlIHJlc3VsdCBkb2Vz
buKAmXQgbG9vaw0KPiA+IHN0YXRpc3RpY2FsbHkgc29saWQuDQo+ID4NCj4gPiBEbyB5b3UgaGF2
ZSBhbnkgc3VnZ2VzdGlvbnMgb24gaG93IHRvIG1lYXN1cmUgdGhlIGJlbmVmaXQgbW9yZQ0KPiA+
IHJvYnVzdGx5PyBGb3IgZXhhbXBsZToNCj4gPiAtIGRpZmZlcmVudCBvciBsb25nZXItcnVubmlu
ZyB3b3JrbG9hZHMsDQo+ID4gLSBiZXR0ZXIgbm9ybWFsaXphdGlvbiBmb3IgcmVmYXVsdHMgKHBl
ciB0aW1lLCBwZXIgZmF1bHRzLCBldGMuKSwNCj4gPiAtIG9yIG90aGVyIHZtc3RhdCBtZXRyaWNz
IHRoYXQgeW91IGZvdW5kIG1vcmUgc3RhYmxlIGluIHByYWN0aWNlPw0KPiANCj4gSSd2ZSBjYydl
ZCBUYW5ncXVhbiwgYW5kIGhlIG1heSBiZSBhYmxlIHRvIHNoYXJlIGhvdyBoZSB3YXMgdGVzdGlu
Zy4NCj4gQmFzaWNhbGx5LCB5b3UgbWF5IHdhbnQgdG8gZGlzYWJsZSBXaS1GaSwgYXMgaXQgY2Fu
IGludHJvZHVjZSBhIGxvdCBvZg0KPiB2YXJpYWJpbGl0eSBiZXR3ZWVuIHJ1bnMuIEFzaWRlIGZy
b20gcmVmYXVsdCBtZXRyaWNzLCB5b3Ugc2hvdWxkIGFsc28NCj4gc2VlIHJlZHVjZWQgSS9PIGxv
YWQgYW5kIGZld2VyIHN3YXAtb3V0L2luIGV2ZW50cyBpZiB5b3UgcnVuIHRoZSBzYW1lDQo+IHNl
cXVlbmNlIG9mIGFwcHMgY29uc2lzdGVudGx5Lg0KPiANCj4gPg0KPiA+IEnigJltIGFsc28gY29u
c2lkZXJpbmcgaW5jcmVhc2luZyB0aGUgbnVtYmVyIG9mIHJ1bnMgYW5kIHVzaW5nIGEgdC10ZXN0
LA0KPiA+IG9yIGNvbXBhcmluZyB0aGUgQ0RGIGJldHdlZW4gYmFzZWxpbmUgYW5kIHBhdGNoZWQg
a2VybmVscy4NCj4gPiBJZiB5b3UgaGF2ZSBhIHByZWZlcnJlZCBtZXRob2RvbG9neSwgSeKAmWQg
bGlrZSB0byBhbGlnbiB3aXRoIHRoYXQuDQo+ID4NCj4gDQo+IFRoYW5rcw0KPiBCYXJyeQ0KDQo=

