Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0208BF9EDC5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 12:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FFE86B0088; Wed, 22 Apr 2026 08:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B1146B0092; Wed, 22 Apr 2026 08:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7126B0093; Wed, 22 Apr 2026 08:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F4536B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:51:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DECB1B1570
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:51:36 +0000 (UTC)
X-FDA: 84686178192.08.42DB31B
Received: from mailgw2.hygon.cn (unknown [101.204.27.37])
	by imf27.hostedemail.com (Postfix) with ESMTP id 451DC40005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:51:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of liuyibin@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=liuyibin@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776862294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FbWrEtMT6Sl1f+Ova3sk6iYyCjKrFCZqgD7p8fcRdVc=;
	b=cmSRpT/nyDxKDGf0VeRA1bQiO8jmiKzg9Ac+tvWacn680pdsaJQTVWqQGD4XJJcFEi8iZc
	OGpD+eidwyZX0rgSBwGdZoqWQaQGCO8w4uY7hK9Q6HISUGx5U8vgTLJPEaK9C4Qpda5APL
	SBqhZ9unScvNPjirBCIsD0Q+FHkeGVg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of liuyibin@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=liuyibin@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776862294; a=rsa-sha256;
	cv=none;
	b=xcRZYan3+k9qtAlTsqlnzDqu5wt8nOky0BkQf5zs1p3ZJ+ZN+v3i2Nu4WULAf78lnXCeWm
	wQELxmTtUpmt2IkW1lWuxlxgVl74kMLgYSqWSuW9hV5VHqW+jE/fu/Cq0RVaoRHiENGI55
	LOs293sP9lZjU0cD5f4nSfieagAMtXw=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4g0zcP68v7z1YQpmG;
	Wed, 22 Apr 2026 20:51:17 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4g0zcM4DVvz1YQpmG;
	Wed, 22 Apr 2026 20:51:15 +0800 (CST)
Received: from cncheex05.Hygon.cn (unknown [172.23.18.115])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id A69D75943;
	Wed, 22 Apr 2026 20:51:08 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex05.Hygon.cn
 (172.23.18.115) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 22 Apr
 2026 20:51:06 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Wed, 22 Apr 2026 20:51:06 +0800
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
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBtbTogQWRkIFJXSF9STUFQX0VYQ0xVREUgZmxhZyB0?=
 =?gb2312?Q?o_exclude_files_from_rmap_sharing?=
Thread-Topic: [PATCH] mm: Add RWH_RMAP_EXCLUDE flag to exclude files from rmap
 sharing
Thread-Index: AQHc0kWjdlrDL8nbPE+Fpw0BQ/z5wrXrBF9Q
Date: Wed, 22 Apr 2026 12:51:06 +0000
Message-ID: <bc514883d6154420b3cfde4ab25a20c7@hygon.cn>
References: <20260421020932.3212532-1-liuyibin@hygon.cn>
 <aeikm2e5Gh5reJ30@lucifer>
In-Reply-To: <aeikm2e5Gh5reJ30@lucifer>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.22.229]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 451DC40005
X-Stat-Signature: aduzr6tr94wi4wcje9ppwqsiyrfyy53k
X-Rspam-User: 
X-HE-Tag: 1776862289-939416
X-HE-Meta: U2FsdGVkX189izHb2/S4QUfu8aNsBDaidIPr+LFeiUtDOxpXDpqbaj9t720Arp6t7TfBhUCOU0VfZObnNAPfuTntLnm1DP1FOOwPOXgo5b3yuiAVSNqcT15fileqby7doruk2KF2bzBCq6jqVYZwvPCiSFOOqRV5NdeF4s6kb8s8FBYooicM+kzF8JiQ9JcWVyZW9c047ajRFBHLfGbH3WsHP4haPF1mD+2wV8NuCOisJK26JULalKBg1Nn48Tqhv9o8n64zO3w7XbJV0DXSq4wEZd65HhwXUYoS8b+S+wmV5CqR7Bwga2ILdv86vd/5BCMBpaDqhTg/aI97ZPd5TOtKyQvqhaz3Qp6idGTazMttsXRgyneSACAoCTq21QyUSSZ1ADCroY6jHhi0LtJGT6QhGXNlQ9+m5xdg2mIOe9M3aXZrMLztqVAmxEjMMrgM7+KftSljVZNHdeWn+Uke9GitQmIFy7WtWy6wT7ExtiWA1M2o8R5gyaKKBC1o8xnNHjIAEyZcwvVpMI5d3cDh4gWh5IpqttZ1jz4c5NjiqMpQOIPqzgLvVvmlNIXPt9K9gq5gHz/5H/QRz2jZwRTxwZ9rLRHfcNxHBFjIzB45ZE1jwvAmkU1UKCcZLBf3bkByLR3cgHpQmT/RuS9qZ2KTb9MyPgG4YDWovVcgLSy2VrqlWm8XtBvPiTGSVmX1yypT9AAw8mYNR/yru/NBpD/rHgD0pHZuV+qylRdEtPCixGbJlpr0ntFTJ3Ztcij3SQwBjaBwmuasoDlDxrkUK03u9GWOD+6TFDCiHP6S3PNMr1Wy6ad9YxiK3Q++WnUMWe2J/cihQGzrFm6EViwfvSxcV0bW8ucQZqL3sekURw2ILjr0eowE8GH/X2pr24Tw3aQo4PcsS9yPcqPcazqHRgOA3tq333YWbBGGga5wPS+UamqvZZiQ0XOOkEigXsxynMx45HLkSACbTOA2nnbyFfP
 qzj0zJje
 H1leo4upIsWOHqgE6tQuCZMb2pY8uBDDYsex/2KpzHALHsV6ZouDPC4rDhYbjjhWoHecs5T8l1wb68mH81G+4qQEx08a+SR+67+kfZZZRAFTydXRgSIef2wkkciMv7SEpl9NEuw9DdgW8Pd89ZnNrNIuTEx2c1BGBhRoD3NAp8Pwv4yl79X8AcMyN6lhif75JGK2yveuYsUp2/j7DKWNmmTkUOkmj9HhG0rgdb1+2AWqoJUNfDFi6V8tdHj2PWP2XGhxdj9J3WNqerdGeNvV+r73rMCNMLNI0tE4/D8t/0XxLv5PjxCbjhAkQ7xEK+ZMjztgJ5NxJCKf6JLT8Ugxq34pN8ADQ1vfBN9XzoDmjvd2osvMql37676K+weambgVAg3ahswFApdTNvVClt14yzMysn+pE5xPnpbWEmZgirXhHqcciXIP1Y4CUPoMBQLLde4i38K4FN0IU/rCW/igPhzSyECbhUkSOlXzw9xSITM+9aLf9ROvserga9oUr/9MgrjpcQKYMUjKYtpe3tfr7r0oQujCyEFaTW0OtY7/jWtB/nWgrqlsG8C7mpEsVRGbSYkTlJfFkD9jh5N2uuQjdk5lYIFzkqH76ZW9u+eRoqal7gmxBfnTVR4IVVekO06FfvPppUCqbO8AxvBJR6b8ia52195ysw0vhBJ5ymDGCRONDJpPGE6hy6/0yydxbbeXUDHmHlsCRd9abgBQwRDIPYKrOvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rmlyc3Qgb2YgYWxsLCBJIGFtIHRydWx5IHNvcnJ5IGZvciBub3QgdXNpbmcgUkZDLg0KU2Vjb25k
bHksIEkgb21pdHRlZCBtYW55IG1haW50YWluZXJzIGJlY2F1c2UgSSB3YW50ZWQgdG8gobBub3Qg
ZGlzdHVyYiB0b28gbWFueSBwZW9wbGWhsSwgDQphbmQgSSBhcG9sb2dpemUgZGVlcGx5IGZvciB0
aGF0LiBJIHdpbGwgZnVsbHkgZm9sbG93IHRoZXNlIHR3byBydWxlcyBmcm9tIG5vdyBvbi4NCg0K
QXMgZm9yIHRoaXMgcGF0Y2gsIGluZGVlZCwgYXMgTWF0dGhldyBzYWlkLCB0aGUgdHJ1bmNhdGUg
cGFydCBpcyBub3QgZmVhc2libGUuIA0KTXkgb3JpZ2luYWwgaW50ZW50aW9uIHdhcyB0byBhcHBs
eSB0aGlzIHRvIGZyZXF1ZW50bHkgdXNlZCBsaWJyYXJ5IGZpbGVzIGxpa2UgbGliYyBhbmQgbGQu
DQpDb250ZW50aW9uIG9uIHRoZSBpX21tYXBfcndzZW0gbG9jayAod2hpY2ggZXZlbnR1YWxseSB0
dXJucyBpbnRvIG9zcV9sb2NrKSBjYXVzZWQgYnkNCnRoZXNlIHR3byBmaWxlcyBhbG9uZSByZWFj
aGVzIHVwIHRvIDcwJSBpbiB0aGUgobAyNTYtY29yZSBleGVjbKGxIGNhc2UsIGFzIG9ic2VydmVk
IGZyb20NCmZsYW1lIGdyYXBocy4gQmVzaWRlcywgbm8gb25lIHBlcmZvcm1zIHRydW5jYXRlIG9w
ZXJhdGlvbnMgb24gbGliYyBhbmQgbGQgYW55d2F5Lg0KDQpTbyBJIHdhbnRlZCB0byB0cnkgc2tp
cHBpbmcgcm1hcCBmb3IgdGhlbS4gU2luY2UgdGhleSBhcmUgc21hbGwsIGV2ZW4gaWYgdGhleSBj
YW5ub3QNCmJlIHJlY2xhaW1lZCBvciBtaWdyYXRlZCwgSSBhc3N1bWVkIGl0IHdvdWxkIG5vdCBj
YXVzZSBtdWNoIHRyb3VibGUuIE9mIGNvdXJzZSwNCnRoaXMgaWRlYSB3YXMgdG90YWxseSB3cm9u
ZywgYW5kIEkgd2lsbCBkZWZpbml0ZWx5IG1hcmsgc3VjaCBpbnNhbmUgcHJvcG9zYWxzIHdpdGgg
UkZDIGluIHRoZSBmdXR1cmUuDQoNClRoZXNlIGlkZWFzIGFyZSBpbnNwaXJlZCBieSBNYXRldXN6
oa9zIHdvcmsgYW5kIHRob3VnaHRzDQooaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtbW0v
Q0FHdWRvSEVmaU9QSjJWR0VWM2ZEVDljRHN1b0hCLXdrOGpnLWstRUs2SmhXZ2lIa1d3QG1haWwu
Z21haWwuY29tLyksDQpzbyBJIHNwZWNpZmljYWxseSBDQ6GvZCBoaW0gdG8gc2VlayBtb3JlIG9w
aW5pb25zIGFuZCBpbnNpZ2h0cy4NCg0KTGFzdGx5LCBJIHNpbmNlcmVseSBhcG9sb2dpemUgZm9y
IHRoZSB0cm91YmxlIEkgaGF2ZSBjYXVzZWQgdGhlIGNvbW11bml0eS4NCkkgd2lsbCBzdHJpY3Rs
eSBmb2xsb3cgY29tbXVuaXR5IGNvbnZlbnRpb25zIHdoZW4gc2VuZGluZyBwYXRjaGVzIGluIHRo
ZSBmdXR1cmUuDQoNCj4gTkFLIG9idmlvdXNseS4NCj4gDQo+IEkgaGF0ZSB0byBrZWVwIHNheWlu
ZyB0aGlzIHRvIHBlb3BsZSwgYnV0IHlvdSd2ZSBnb3Qgbm8gZXhjdXNlIGF0IHRoaXMgc3RhZ2UN
Cj4gaXQncyBiZWVuIGEgeWVhciBvciBzbyBzaW5jZSB3ZSBhZGRlZCBtbSBtYWludGFpbmVycy9y
ZXZpZXdlcnMgYW5kIHlvdSdyZSBub3QNCj4gc2VuZGluZyB0aGlzIHRvIHRoZSByaWdodCBwZW9w
bGUuDQo+IA0KPiBIb3cgaGFyZCBpcyBkb2luZzoNCj4gDQo+ICQgc2NyaXB0cy9nZXRfbWFpbnRh
aW5lci5wbCAtLW5vLWdpdCBmcy9mY250bC5jIGZzL29wZW4uYyBpbmNsdWRlL2xpbnV4L2ZzLmgg
XA0KPiAJaW5jbHVkZS91YXBpL2xpbnV4L2ZjbnRsLmggbW0vbW1hcC5jIG1tL3ZtYS5jDQo+IEpl
ZmYgTGF5dG9uIDxqbGF5dG9uQGtlcm5lbC5vcmc+IChtYWludGFpbmVyOkZJTEUgTE9DS0lORyAo
ZmxvY2soKSBhbmQNCj4gZmNudGwoKS9sb2NrZigpKSkNCj4gQ2h1Y2sgTGV2ZXIgPGNodWNrLmxl
dmVyQG9yYWNsZS5jb20+IChtYWludGFpbmVyOkZJTEUgTE9DS0lORyAoZmxvY2soKSBhbmQNCj4g
ZmNudGwoKS9sb2NrZigpKSkNCj4gQWxleGFuZGVyIEFyaW5nIDxhbGV4LmFyaW5nQGdtYWlsLmNv
bT4gKHJldmlld2VyOkZJTEUgTE9DS0lORyAoZmxvY2soKSBhbmQNCj4gZmNudGwoKS9sb2NrZigp
KSkNCj4gQWxleGFuZGVyIFZpcm8gPHZpcm9AemVuaXYubGludXgub3JnLnVrPiAobWFpbnRhaW5l
cjpGSUxFU1lTVEVNUyAoVkZTIGFuZA0KPiBpbmZyYXN0cnVjdHVyZSkpDQo+IENocmlzdGlhbiBC
cmF1bmVyIDxicmF1bmVyQGtlcm5lbC5vcmc+IChtYWludGFpbmVyOkZJTEVTWVNURU1TIChWRlMg
YW5kDQo+IGluZnJhc3RydWN0dXJlKSkNCj4gSmFuIEthcmEgPGphY2tAc3VzZS5jej4gKHJldmll
d2VyOkZJTEVTWVNURU1TIChWRlMgYW5kIGluZnJhc3RydWN0dXJlKSkNCj4gQW5kcmV3IE1vcnRv
biA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4gKG1haW50YWluZXI6TUVNT1JZDQo+IE1BUFBJ
TkcpDQo+ICJMaWFtIFIuIEhvd2xldHQiIDxMaWFtLkhvd2xldHRAb3JhY2xlLmNvbT4gKG1haW50
YWluZXI6TUVNT1JZDQo+IE1BUFBJTkcpDQo+IExvcmVuem8gU3RvYWtlcyA8bGpzQGtlcm5lbC5v
cmc+IChtYWludGFpbmVyOk1FTU9SWSBNQVBQSU5HKQ0KPiBWbGFzdGltaWwgQmFia2EgPHZiYWJr
YUBrZXJuZWwub3JnPiAocmV2aWV3ZXI6TUVNT1JZIE1BUFBJTkcpDQo+IEphbm4gSG9ybiA8amFu
bmhAZ29vZ2xlLmNvbT4gKHJldmlld2VyOk1FTU9SWSBNQVBQSU5HKQ0KPiBQZWRybyBGYWxjYXRv
IDxwZmFsY2F0b0BzdXNlLmRlPiAocmV2aWV3ZXI6TUVNT1JZIE1BUFBJTkcpDQo+IGxpbnV4LWZz
ZGV2ZWxAdmdlci5rZXJuZWwub3JnIChvcGVuIGxpc3Q6RklMRSBMT0NLSU5HIChmbG9jaygpIGFu
ZCBmY250bCgpL2xvY2tmKCkpKQ0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnIChvcGVu
IGxpc3QpDQo+IGxpbnV4LW1tQGt2YWNrLm9yZyAob3BlbiBsaXN0Ok1FTU9SWSBNQVBQSU5HKQ0K
PiANCj4gPw0KPiANCj4gWW91J3JlIHNlbmRpbmcgYW4gaW5zYW5lIHBhdGNoIHRoYXQgYnJlYWtz
IGNvcmUgbW0gYW5kIHlvdSBjYW4ndCBldmVuIHNlbmQgaXQNCj4gdG8NCj4gdGhlIHJpZ2h0IHBl
b3BsZS4uLg0KPiANCj4gKEFuZCB5ZXQgTWF0ZXVzeiBpcyBzb21laG93IGNjJ2QgKGhlIGxvdmVz
IHRoYXQgOikpDQo+IA0KPiBUaGlzIGtpbmQgb2YgY3JhemluZXNzIHNob3VsZCBiZSBhbiBSRkMg
YWxzbyBhcyBEYXZpZCBzYWlkLg0KPiANCj4gQm90aCBvZiB0aGVzZSB0aGluZ3MgYXJlIGp1c3Qg
cnVkZSBhbmQgbm90IGhlbHBmdWwgd3J0IHVwc3RyZWFtLg0KPiAuLi4gLi4uDQo+IC4uLiAuLi4N
Cj4gVGhpcyBpZGVhIGlzIHRvdGFsbHkgYnJva2VuLg0KPiANCj4gSWYgeW91IHdhbnQgdG8gY29u
dHJpYnV0ZSB1c2VmdWxseSwgUExFQVNFIGRyb3AgdGhpcyBzaWxseSBpZGVhLCBjb21lIGJhY2sg
d2l0aA0KPiBzb21lIE5VTUJFUlMgYWJvdXQgdGhlIGNvbnRlbnRpb24geW91IHNlZSwgYW5kIGxl
dCdzIGhhdmUgYSBzZW5zaWJsZQ0KPiBkaXNjdXNzaW9uDQo+IGFib3V0IHdoYXQgd2UgY2FuIGRv
IHRvIGFkZHJlc3MgdGhhdD8NCj4gDQo+IEFsc28gZm9sbG93IHN0YW5kYXJkIHVwc3RyZWFtIGtl
cm5lbCBwcm9jZWR1cmVzIC0gZmlndXJlIG91dCB3aG8gdG8gZW1haWwNCj4gcHJvcGVybHksIFJG
QyBpbnNhbmUgaWRlYXMsIGV0Yy4NCj4gDQo+IFRoYW5rcywgTG9yZW56bw0KDQo=


