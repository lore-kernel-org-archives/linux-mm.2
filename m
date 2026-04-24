Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF5FFDEE58
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 01:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C84A6B0088; Thu, 23 Apr 2026 21:08:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1527D6B008A; Thu, 23 Apr 2026 21:08:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0472C6B008C; Thu, 23 Apr 2026 21:08:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E33D66B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:08:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF18E1A0BDA
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 01:08:55 +0000 (UTC)
X-FDA: 84691665030.17.1EA7F08
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf24.hostedemail.com (Postfix) with ESMTP id C178A18000D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 01:08:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of liuyibin@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=liuyibin@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776992933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rnq4RWnsTy4lXDa/rQB6twwAVqU3G0R+DkIdM741GHA=;
	b=rK+GzsqvOokeABlimplwH5TkIbTo/pT8eSlfDTrqMkyb2x+8yMOf6F9B6Ri1ALsR0HinVt
	polsP1KWuQdk+/zCYmsnfe9aNQvDlpNQPFerc7Sj/qSQKQe3th3TLmWMYNfFe+obwIsrCB
	TtM8euyt5XfJrw94TmlSRaUYO2ULyhA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776992933; a=rsa-sha256;
	cv=none;
	b=7cj4Dr/JMyb+bTH/4qwRbzQb00FqhD4aRt9CiZFRZxhNr9C7spHAiCGCurp5VUgi300gBZ
	QwqOFXCLW0FA4DyxvdfUFxueW6NU1jHEMZs8gVF952DeyVh7hf6PKQ06gY8an96UG8F4ZA
	ojW6JjO2++Tvv1Dk+UkvCR1QXmwuH2g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of liuyibin@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=liuyibin@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4g1vwq6lpCz4r78b;
	Fri, 24 Apr 2026 09:08:43 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4g1vwq243jz4r78b;
	Fri, 24 Apr 2026 09:08:43 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 03A6D3006724;
	Fri, 24 Apr 2026 09:08:37 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 24 Apr
 2026 09:08:35 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Fri, 24 Apr 2026 09:08:35 +0800
From: Yibin Liu <liuyibin@hygon.cn>
To: Lorenzo Stoakes <ljs@kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "brauner@kernel.org" <brauner@kernel.org>,
	"mjguzik@gmail.com" <mjguzik@gmail.com>, Jianyong Wu <wujianyong@hygon.cn>,
	Huangsj <huangsj@hygon.cn>, Yuan Zhong <zhongyuan@hygon.cn>, "jack@suse.cz"
	<jack@suse.cz>, "jlayton@kernel.org" <jlayton@kernel.org>,
	"chuck.lever@oracle.com" <chuck.lever@oracle.com>, "alex.aring@gmail.com"
	<alex.aring@gmail.com>, "vbabka@kernel.org" <vbabka@kernel.org>,
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRDSF0gbW06IEFkZCBSV0hfUk1BUF9FWENM?=
 =?utf-8?Q?UDE_flag_to_exclude_files_from_rmap_sharing?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIG1tOiBBZGQgUldIX1JNQVBfRVhDTFVERSBmbGFn?=
 =?utf-8?Q?_to_exclude_files_from_rmap_sharing?=
Thread-Index: AQHc0kWjdlrDL8nbPE+Fpw0BQ/z5wrXrBF9Q//+3pQCAAqdBAA==
Date: Fri, 24 Apr 2026 01:08:35 +0000
Message-ID: <a96c20b74b874248bc0cdc2b926a43fe@hygon.cn>
References: <20260421020932.3212532-1-liuyibin@hygon.cn>
 <aeikm2e5Gh5reJ30@lucifer> <bc514883d6154420b3cfde4ab25a20c7@hygon.cn>
 <aejzSsiXZBK1emv7@lucifer>
In-Reply-To: <aejzSsiXZBK1emv7@lucifer>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.22.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Queue-Id: C178A18000D
X-Rspamd-Server: rspam07
X-Stat-Signature: nn7qqjthehmegcpy9u9gimh9iom8xasq
X-Rspam-User: 
X-HE-Tag: 1776992929-915248
X-HE-Meta: U2FsdGVkX19fLhOCwiANqZADvM2DbAvZa6DZyeZ2eo7O48qQZNE/nL5ofPeEEU4LahUKCJyr/HPfKuu8VsLzBMVUOJI9AQkGfIKhPkY2fGCtdHDV0dK7+Rydv44JZUI6mfuD1/j9cyWUHVfhfr2xiMKccNxY9iVM+hA/UNYWdX1kXjewul8f6kg7amOwwgxUiPaQUNYHFfLVJIIdGr57m4gb95iQFunODzLW+y0zXlXt//1n7oifbL6j4oP1CfdV61qkMzzYuRgTZt1k3IvBecVE+12k8z4/BibWo1lXE+lwhkevuKgC20xVD0xMNBtrYYM0aKmUv9fizsC8FF5TyhY0/A2W91CxHhg3jeawJ924pUBA6btdMGDdiN/OeSPbWDDAOG6rAQA6eCNj3EwCoHDuBPw9YCriqA0RJymAdEWiCm6dLTZc8d+yzEmDOT2NLvU5iPW72jM4mRiFtVrOGW2xLwsUJd3jKvftbjEku8ZQkYWft26uN6e4bJmk8i/QSRvzKJAGzbqilatBNRJ0s2cdE28xCH1c5Am3pY/Bp8T8UwJmHvjZLQldYgLCi+pvAP6PTFwJWYCEjFEmRsg6BXd70veH4cKPzaJAqkBCrgccCYAn5rLtxWHXdG0mxeKx9G9yi1hjYPaWS5qLmsfjW2igEacyFLPR+kzfUsFGt2yerTtVC90Si0eRgW0b5dYWGcheapB6Zq/GU1J38Qbj9VUrOFbQOB5urcC5oHuJ1i3QbFABchFoVETODAmXJSPgNGkOm/aJplp378P9h2/LQT8lnjLQ8Xd6ydNtDISxuNVBQGAnAmnz5ejoGGlqv3gt3tLivuSVgqkX+LSbuXYdYeEzfjFLyCzmNzAl6zVjTKZZq+F4dXykQO9H8SLPkNnLVCma77SqpC6QbN0Y6me00miIO1uLR+it8GKd63znh8FM9/HTZR17VhnEUwsr/fZgCoJ6UJIcvP9Ii4tbtyL
 mLcioC77
 dcUYx2lxCKvaZYoJeXJo+fa9GjG5MmZg5JS8FFVPgzX/vutKAYEel5McR+CgGOzLFfkJZNRChQL6LbZGYzaukhZrO/8ob77Z4HZ8h+2zUa+N78Qf8W1uf9eToFKbAIFhgNaCdBQIl608FrAcRohj33Czvw5Bf9d6sMcVrQdPtduqcDtyhP12Nas9TlyIkwro1k1STf1CUHzWZUqw0ZH5kUEJD6afsWnGZdLSRAtMPjUpdKtKnNlKACyXEo5OuLo8okkEYVEM+1m+CPc9FbkwYmAbSfYU7P2l2qRtxCJbO3Se7uB6PgdesOt9/KG+EEYa5kXS1WEEOGSy6B3GKKynTMmK6p4T6KZ5G0UM2zZWUMuhbMS55O3nzd1c5PdRgPuMaiTcUaUt+v8GEeQumci3lRv3X76y/C+2E70xdflUlRJT7/R2JKd+hVzmF5Wgiiz1VvzLOYwMN4UZftWKoPLVzUZQkxIxFCrsAKLT2QUraq1jbsNYpbZ6ntBBH+dO/QAkybUfBzJdu/TzDZyt8bzYZw2XJyTWu6c3GjKUG2QTzMbBYa0+sJy6HBkRjuUiDsoW3tWEfzGTbl+QL7vrZ7v+1EkTVBWEkrIuLPwIiawkCLsfNXDUBt5+J7SVfaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBPbiBXZWQsIEFwciAyMiwgMjAyNiBhdCAxMjo1MTowNlBNICswMDAwLCBZaWJpbiBMaXUgd3Jv
dGU6DQo+ID4gRmlyc3Qgb2YgYWxsLCBJIGFtIHRydWx5IHNvcnJ5IGZvciBub3QgdXNpbmcgUkZD
Lg0KPiA+IFNlY29uZGx5LCBJIG9taXR0ZWQgbWFueSBtYWludGFpbmVycyBiZWNhdXNlIEkgd2Fu
dGVkIHRvIOKAnG5vdCBkaXN0dXJiIHRvbw0KPiBtYW55IHBlb3BsZeKAnSwNCj4gPiBhbmQgSSBh
cG9sb2dpemUgZGVlcGx5IGZvciB0aGF0LiBJIHdpbGwgZnVsbHkgZm9sbG93IHRoZXNlIHR3byBy
dWxlcyBmcm9tIG5vdyBvbi4NCj4gPg0KPiA+IEFzIGZvciB0aGlzIHBhdGNoLCBpbmRlZWQsIGFz
IE1hdHRoZXcgc2FpZCwgdGhlIHRydW5jYXRlIHBhcnQgaXMgbm90IGZlYXNpYmxlLg0KPiA+IE15
IG9yaWdpbmFsIGludGVudGlvbiB3YXMgdG8gYXBwbHkgdGhpcyB0byBmcmVxdWVudGx5IHVzZWQg
bGlicmFyeSBmaWxlcyBsaWtlIGxpYmMNCj4gYW5kIGxkLg0KPiA+IENvbnRlbnRpb24gb24gdGhl
IGlfbW1hcF9yd3NlbSBsb2NrICh3aGljaCBldmVudHVhbGx5IHR1cm5zIGludG8gb3NxX2xvY2sp
DQo+IGNhdXNlZCBieQ0KPiA+IHRoZXNlIHR3byBmaWxlcyBhbG9uZSByZWFjaGVzIHVwIHRvIDcw
JSBpbiB0aGUg4oCcMjU2LWNvcmUgZXhlY2zigJ0gY2FzZSwgYXMNCj4gb2JzZXJ2ZWQgZnJvbQ0K
PiA+IGZsYW1lIGdyYXBocy4gQmVzaWRlcywgbm8gb25lIHBlcmZvcm1zIHRydW5jYXRlIG9wZXJh
dGlvbnMgb24gbGliYyBhbmQgbGQNCj4gYW55d2F5Lg0KPiANCj4gSW50ZXJlc3RpbmcsIHdvdWxk
IGJlIGdvb2QgdG8gc2VlIHRoZXNlPyBBbmQgbW9yZSBkZXRhaWxzIG9uIHRoZSBzY2VuYXJpbz8N
Cj4gDQo+IFdoYXQgd29ya2xvYWRzIGFyZSBjb250ZW5kaW5nIHRoYXQgZXhhY3RseT8NCj4gDQoN
Ckl0IGlzIGdvb2QgdG8gc2VlLg0KT24gYW4gSW50ZWwgRW1lcmFsZCBSYXBpZHMgc2VydmVyICgx
MTIgY29yZXMpLCBydW4gdGhlIGV4ZWNsIGJlbmNobWFyayBmcm9tDQpVbml4QmVuY2ggd2l0aCB0
aGUgY29tbWFuZDogLi9SdW4gLWMgMjIwIGV4ZWNsDQpUaGVuIHBlcmYgdG9wIHNob3dzOg0KDQog
IDkxLjUzJSAgW2tlcm5lbF0gICAgICAgICAgICAgICAgICAgIFtrXSBvc3FfbG9jaw0KICAgMC41
MCUgIFtrZXJuZWxdICAgICAgICAgICAgICAgICAgICBba10gcndzZW1fc3Bpbl9vbl9vd25lcg0K
ICAgMC40NSUgIHBlcmYgICAgICAgICAgICAgICAgICAgICAgICBbLl0gcXVldWVfZXZlbnQNCiAg
IDAuNDIlICBba2VybmVsXSAgICAgICAgICAgICAgICAgICAgW2tdIHZtYV9pbnRlcnZhbF90cmVl
X2luc2VydA0KICAgMC4zNiUgIFtrZXJuZWxdICAgICAgICAgICAgICAgICAgICBba10gbmV4dF91
cHRvZGF0ZV9mb2xpbw0KICAgMC4yNSUgIFtrZXJuZWxdICAgICAgICAgICAgICAgICAgICBba10g
X196YXBfdm1hX3JhbmdlDQoNCkFsbCB0aGUgb3NxX2xvY2sgb3ZlcmhlYWQgaGVyZSBjb21lcyBm
cm9tIHJ3c2VtX29wdGltaXN0aWNfc3BpbiwgYW5kDQpyd3NlbV9vcHRpbWlzdGljX3NwaW4gaGFz
IG1hbnkgY2FsbCBzb3VyY2VzLg0KVGhlIGJyZWFrZG93biBpcyByb3VnaGx5IGFzIGZvbGxvd3M6
DQoNCjYuMTMlICBfZGxfbWFpbi0tPm1wcm90ZWN0LS0+Li4uLS0+X19zcGxpdF92bWEtLT52bWFf
cHJlcGFyZS0tPmRvd25fd3JpdGUoJm1hcHBpbmctPmlfbW1hcF9yd3NlbSkNCjYuMTUlICBicHJt
X2V4ZWN2ZS0tPi4uLi0tPmV4aXRfbW1hcC0tPi4uLi0tPnVubGlua19maWxlX3ZtYV9iYXRjaF9w
cm9jZXNzLS0+ZG93bl93cml0ZSgmbWFwcGluZy0+aV9tbWFwX3J3c2VtKQ0KMjQuNzElIHZtYV9s
aW5rX2ZpbGUtLT4uLi4tLT5kb3duX3dyaXRlKCZtYXBwaW5nLT5pX21tYXBfcndzZW0pDQoyNC44
MiUgbW1hcF9yZWdpb24tLT4uLi4tLT5mcmVlX3BndGFsYmVzLS0+dW5saW5rX2ZpbGVfdm1hX2Jh
dGNoX3Byb2Nlc3MtLT5kb3duX3dyaXRlKCZtYXBwaW5nLT5pX21tYXBfcndzZW0pDQoxOC41JSAg
bW1hcF9yZWdpb24tLT4uLi4tLT5fX3NwbGl0X3ZtYS0+dm1hX3ByZWFwcmUtLT5kb3duX3dyaXRl
KCZtYXBwaW5nLT5pX21tYXBfcndzZW0pDQoxMi40NCUgX2RsX21hcF9wcm9qZWN0LS0+bXByb3Rl
Y3QtLT4uLi4tLT5fX3NwbGl0X3ZtYS0tPnZtYV9wcmVwYXJlLS0+ZG93bl93cml0ZSgmbWFwcGlu
Zy0+aV9tbWFwX3J3c2VtKQ0KDQpBbmQgQU1EIFplbjUoOTc1NSkgcGVyZm9ybXMgcHJldHR5IG11
Y2ggdGhlIHNhbWUgd2F5ICh0ZXN0ZWQgd2l0aCAuL1J1biAtYyAyNTAgZXhlY2wpLg0KDQo+ID4N
Cj4gPiBTbyBJIHdhbnRlZCB0byB0cnkgc2tpcHBpbmcgcm1hcCBmb3IgdGhlbS4gU2luY2UgdGhl
eSBhcmUgc21hbGwsIGV2ZW4gaWYgdGhleQ0KPiBjYW5ub3QNCj4gPiBiZSByZWNsYWltZWQgb3Ig
bWlncmF0ZWQsIEkgYXNzdW1lZCBpdCB3b3VsZCBub3QgY2F1c2UgbXVjaCB0cm91YmxlLiBPZg0K
PiBjb3Vyc2UsDQo+ID4gdGhpcyBpZGVhIHdhcyB0b3RhbGx5IHdyb25nLCBhbmQgSSB3aWxsIGRl
ZmluaXRlbHkgbWFyayBzdWNoIGluc2FuZSBwcm9wb3NhbHMNCj4gd2l0aCBSRkMgaW4gdGhlIGZ1
dHVyZS4NCj4gPg0KPiA+IFRoZXNlIGlkZWFzIGFyZSBpbnNwaXJlZCBieSBNYXRldXN64oCZcyB3
b3JrIGFuZCB0aG91Z2h0cw0KPiA+DQo+IChodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1t
bS9DQUd1ZG9IRWZpT1BKMlZHRVYzZkRUOWNEc3VvSEItd2s4amctaw0KPiAtRUs2SmhXZ2lIa1d3
QG1haWwuZ21haWwuY29tLyksDQo+ID4gc28gSSBzcGVjaWZpY2FsbHkgQ0PigJlkIGhpbSB0byBz
ZWVrIG1vcmUgb3BpbmlvbnMgYW5kIGluc2lnaHRzLg0KPiANCj4gSSB0aGluayB0aGUgYmVzdCB0
aGluZyBpbiBnZW5lcmFsIGdvaW5nIGZvcndhcmRzIGlzIHRvIGJyaW5nIHVwIHRoaXMgaXNzdWVz
IGluDQo+IGFkdmFuY2UsIHdlJ3JlIG1vcmUgdGhhbiBoYXBweSB0byBsb29rIGludG8gdGhpbmdz
IGFuZCB2ZXJ5IGludGVyZXN0ZWQgaW4gaXNzdWVzDQo+IHdpdGggbG9jayBjb250ZW50aW9uLCBs
YXRlbmN5LCBldGMuDQo+IA0KPiBBbmQgdGhhdCB3YXkgeW91IGNhbiBkaXNjdXNzIGlkZWFzIHlv
dSBtaWdodCBoYXZlIHRvIHRhY2tsZSB1cCBmcm9udCBhbmQgd2UgY2FuDQo+IGdpdmUgeW91IGVh
cmx5IGZlZWRiYWNrLCB3aGljaCBzaG91bGQgc2F2ZSB0aW1lIGFsbCByb3VuZCBhbmQgaGVscCBn
ZXQgdXMgdG8gYQ0KPiBnb29kIHNvbHV0aW9uIDopDQo+IA0KPiBKdXN0IHNlbmQgd2l0aCBhIFtE
SVNDVVNTSU9OXSBwcmVmYWNlIGFuZCBjYy0gcGVvcGxlIHlvdSBmZWVsIGFyZSByZWxldmFudCAo
dXNlDQo+IE1BSU5UQUlORVJTIHRvIGZpZ3VyZSBvdXQgZS5nLiBtYWludGFpbmVycyBvZiByZWxl
dmFudCB0aGluZ3MsIGxpa2Ugcm1hcCwNCj4gbW1hcCwNCj4gZXRjLikNCj4gDQo+ID4NCj4gPiBM
YXN0bHksIEkgc2luY2VyZWx5IGFwb2xvZ2l6ZSBmb3IgdGhlIHRyb3VibGUgSSBoYXZlIGNhdXNl
ZCB0aGUgY29tbXVuaXR5Lg0KPiA+IEkgd2lsbCBzdHJpY3RseSBmb2xsb3cgY29tbXVuaXR5IGNv
bnZlbnRpb25zIHdoZW4gc2VuZGluZyBwYXRjaGVzIGluIHRoZQ0KPiBmdXR1cmUuDQo+IA0KPiBJ
dCdzIG5vIHByb2JsZW0sIGJldHRlciB0byBiZSBkaXJlY3QgYWJvdXQgdGhpcyAtIGl0J3MgbW9y
ZSB1c2VmdWwgdG8gZGlzY3Vzcw0KPiByYXRoZXIgdGhhbiB0byBqdW1wIHRvIGEgc29sdXRpb24g
d2l0aG91dCBjb21tdW5pdHkgaW52b2x2ZW1lbnQsIHdoaWNoIG1pZ2h0DQo+IG5vdA0KPiB3b3Jr
IG91dC9jb25mbGljdCB3aXRoIG90aGVyIHN0dWZmIGV0Yy4NCj4gDQo+IFRoYW5rcywgTG9yZW56
bw0KDQpUaGFua3MgZm9yIHRoZSBraW5kIGFkdmljZS4NCg0KSSB3aWxsIHN0YXJ0IGEgZGlzY3Vz
c2lvbiBmaXJzdCB3aXRoIGEgW0RJU0NVU1NJT05dIHRhZyBhbmQgaW52b2x2ZSByZWxldmFudA0K
bWFpbnRhaW5lcnMgZm9yIHNpbWlsYXIgaWRlYXMgaW4gdGhlIGZ1dHVyZS4NCg0KVGhhbmtzLCBZ
aWJpbg0K


