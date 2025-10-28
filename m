Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 526D3CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 13:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8376C8E0192; Tue, 28 Oct 2025 09:01:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80F7B8E0016; Tue, 28 Oct 2025 09:01:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 724ED8E0192; Tue, 28 Oct 2025 09:01:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6052D8E0016
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:01:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E05F11A0468
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:01:19 +0000 (UTC)
X-FDA: 84047533878.01.E71B934
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9058410000F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:01:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=R8GjW6zi;
	spf=pass (imf14.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761656477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=k+AJi12b9ShCywXsEOZYDh1wDvCvTun+vAJjGLYogTI=;
	b=IBGMQz4FTLUNGJIiBtoP0W2GzOY58OVPvu182mChLCjO3S3kVcBMxNhOHyqF6jvs8E2xJQ
	IYzgxGGTI7/dqBcLj9ViBLw1XC6VzK90ux16eoD9zz/t1UfYasG1beggecFIFcORM1Felv
	2BjRoektLOGsRkdESJQvEiVouN2NJqc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=R8GjW6zi;
	spf=pass (imf14.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761656477; a=rsa-sha256;
	cv=none;
	b=KPl3X79EtHn82eAw3vRGhObuowUKgntb2PWaE7uLX7z9xn4VFEYCXOgjFRl7g5rReClbPC
	xwjA4K/0Gh+0BU3EAJTPUAg7v7xmPGbZPmbzs5MF1sRqfu7hbQvpbfUHMZXbTzB6Fv+cnj
	10p4G1Ml6F/ekbAvGZGa55kBLi8jGBM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=k+AJi12b9ShCywXsEOZYDh1wDvCvTun+vAJjGLYogTI=;
	b=R8GjW6zi0SMB2/pC62WwzpzpIo1as9fnKH/d2Xj38ptlxYdouvIvVWb+hSBDb98qYXGno1/1A
	j8W3X7k72w9km32VypvNVjiA1aCm/bldCL12o6MY12TQOtitH8kNHME/EBZj/0xRSVbKLN31PQP
	EvRR0rSwlAdfSVVy7XcsrFo=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cwr8G3Wj0znTVF;
	Tue, 28 Oct 2025 21:00:30 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 2F7131A0188;
	Tue, 28 Oct 2025 21:01:08 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (7.185.36.8) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Oct 2025 21:01:07 +0800
Received: from dggpemf500012.china.huawei.com ([7.185.36.8]) by
 dggpemf500012.china.huawei.com ([7.185.36.8]) with mapi id 15.02.1544.011;
 Tue, 28 Oct 2025 21:01:07 +0800
From: zhangqilong <zhangqilong3@huawei.com>
To: David Hildenbrand <david@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Wangkefeng (OS Kernel Lab)"
	<wangkefeng.wang@huawei.com>, Sunnanyong <sunnanyong@huawei.com>
Subject: Re: [RFC PATCH 3/3] mm/mremap: Use can_pte_batch_count() instead of
 folio_pte_batch() for pte batch
Thread-Topic: [RFC PATCH 3/3] mm/mremap: Use can_pte_batch_count() instead of
 folio_pte_batch() for pte batch
Thread-Index: AdxIAGeAcYzt2zsxR72Jnu3gPSGDrA==
Date: Tue, 28 Oct 2025 13:01:07 +0000
Message-ID: <c484887a684e42c3a775f13af93c3a9f@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.174.177.115]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Queue-Id: 9058410000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: xafr6aj19wfahiw1ueth67p3yg5bdxa8
X-HE-Tag: 1761656475-645506
X-HE-Meta: U2FsdGVkX18YNqVoFfLwl+ern1orAWRMA7ctP/j38BYy8ak36e+n5PmPj3V5LyDiUL9t6EULjskr/7QbILZKlb5PJYTktHdYxOaPPQ5mk6nkQDPwAxBobx5QBosm0/ZnEjr8Dncm/hzGNxcKm6u3q9paDEqAz2lhpE3d9Ns43RqSRJ0QSJL3ijp4Z+ujJaugnyiygSmPIMw2lNWyUh3/OHK4mqDnCyRBtj1NiHPjQqMxLr1H203W9GJ2eKW6bgjRvQDIFPlb0Nr4ZozxVvB3Zgm+UqHDmgydnCuNIBu8i0+4hDFRPghdhX7J3nwWOzA0EHpiKdVG35eq2RXsK3at40lqFNmv6jgYy8J6qjfpEqs6o6sVYR9Cspv22f8rbdP501mZ8A1HcTM+wMN4A5QcHrTQmaTvbYuViBIq5lF0A2/v85IcZuNoDUQPk/1guKbWLonqrHkR/fYPEwmOWthc9zXNAsineHayq4mB5ULCWTYDiguo3MWj+O1KbQ6WOLB7c4gooeBUnh1/NI5r83DIHddJALkAxOFocz1YIKYLRyXnWBfLXuy8Nlpl6e8IgxBZzgog5HWbS+ZPSQkZc+/tAraWDH8ss57Uu4okPyNDzvWszwDSizLYVtiuUU5evkSXMYJ69m3aHyH0qofXWRR9FcvrF92JQgeFq0TFgaZ9AoOZ7ikKIF6N7PZtLAEsPnAo+DAsxGR+hjQrl+w0pIjL5/mCbYl62vl0dm6fKU0pBJikJYJNT+dkFi58kGbwNPdGvsot5I46IDBn28WgRKKx17roTRYzIOLswW2D45oaLloZzChVFaSfq8vhNT/vlA0gKbUNOr4O+EaH2vHN2HzWfm36XVOmu9d+/4CvUVtVjVtG4LIGSTWuq4TtUKiKnoMyivg0oqb3UEoUyx2UppAMXvByQl9wFZhSnoGuE/ghStspvaA3/lH/E7kgoh+buJR7cnE2WFUspdpAjXPbH/n
 b01nmOSH
 boeAhzlMSEzx+f4H5/MXPZw+vN2McuYIJn4rGF9nQ2fZjx85aDaEXiwi0flC3JA9ksWAQGJr7OdPQ/4SCvojs5jtaNFHHeK/BXYwHpyRaJGlODexV236LvSzWoVI4SByS6ERkv68DilQHxterSevOSF2noDGWlhcp7ICvXQiT+uPhL9mwUVxMTFv5MmEQpl8WtHTz56Z3ygUVEefK2uZ3jYMkgI4bLWOIslV5cBz/HwoIz8QDN9a3qvWBLbLcUTkZhqxhM1Q+CKLIBZnkdct8KEVjIQm266xbOWg7ZRpkTO2xbPDnxmWTTuuhYtroa5bxn7BRRI3hfkvgmVeorS/CKgv4XGmnvzW/mivCgezFBKsEHeJJznxXm1Zs2DiJXYHtUp/i/9O/olYAyBfRN2zyOL+gn0GYL02NezyvZKkMsHkJRcLuD/ordN9i2WE6B6seYzWvEDO/R2ry8dnMRNYp2DGVrAgiBZffP/CQt1LxxfDf6M9AyXRs9huRtR33jxujtsPa4LB2ikV7dxIrxbXPJpD7qeh/QnzbSQ5uiCtLrifxO5BzCHhYK34RfkaCcOCbUMDVLR/wDKTsDAI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gMjcuMTAuMjUgMTU6MDMsIFpoYW5nIFFpbG9uZyB3cm90ZToNCj4gPiBJbiBjdXJyZW50IG1y
ZW1hcF9mb2xpb19wdGVfYmF0Y2goKSwgMSkgcHRlX2JhdGNoX2hpbnQoKSBhbHdheXMgcmV0dXJu
DQo+ID4gb25lIHB0ZSBpbiBub24tQVJNNjQgbWFjaGluZSwgaXQgaXMgbm90IGVmZmljaWVudC4g
MikgTmV4dCwgaXQgbmVlZCB0bw0KPiA+IGFjcXVpcmUgYSBmb2xpbyB0byBjYWxsIHRoZSBmb2xp
b19wdGVfYmF0Y2goKS4NCj4gPg0KPiA+IER1ZSB0byBuZXcgYWRkZWQgY2FuX3B0ZV9iYXRjaF9j
b3VudCgpLCB3ZSBqdXN0IGNhbGwgaXQgaW5zdGVhZCBvZg0KPiA+IGZvbGlvX3B0ZV9iYXRjaCgp
LiBBbmQgdGhlbiByZW5hbWUgbXJlbWFwX2ZvbGlvX3B0ZV9iYXRjaCgpIHRvDQo+ID4gbXJlbWFw
X3B0ZV9iYXRjaCgpLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogWmhhbmcgUWlsb25nIDx6aGFu
Z3FpbG9uZzNAaHVhd2VpLmNvbT4NCj4gPiAtLS0NCj4gPiAgIG1tL21yZW1hcC5jIHwgMTYgKysr
LS0tLS0tLS0tLS0tLQ0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMTMg
ZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvbW0vbXJlbWFwLmMgYi9tbS9tcmVt
YXAuYyBpbmRleA0KPiA+IGJkNzMxNDg5OGVjNS4uZDExZjkzZjE2MjJmIDEwMDY0NA0KPiA+IC0t
LSBhL21tL21yZW1hcC5jDQo+ID4gKysrIGIvbW0vbXJlbWFwLmMNCj4gPiBAQCAtMTY5LDI3ICsx
NjksMTcgQEAgc3RhdGljIHB0ZV90IG1vdmVfc29mdF9kaXJ0eV9wdGUocHRlX3QgcHRlKQ0KPiA+
ICAgCQlwdGUgPSBwdGVfc3dwX21rc29mdF9kaXJ0eShwdGUpOw0KPiA+ICAgI2VuZGlmDQo+ID4g
ICAJcmV0dXJuIHB0ZTsNCj4gPiAgIH0NCj4gPg0KPiA+IC1zdGF0aWMgaW50IG1yZW1hcF9mb2xp
b19wdGVfYmF0Y2goc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsDQo+ID4gdW5zaWduZWQgbG9u
ZyBhZGRyLA0KPiA+ICtzdGF0aWMgaW50IG1yZW1hcF9wdGVfYmF0Y2goc3RydWN0IHZtX2FyZWFf
c3RydWN0ICp2bWEsIHVuc2lnbmVkIGxvbmcNCj4gPiArYWRkciwNCj4gPiAgIAkJcHRlX3QgKnB0
ZXAsIHB0ZV90IHB0ZSwgaW50IG1heF9ucikNCj4gPiAgIHsNCj4gPiAtCXN0cnVjdCBmb2xpbyAq
Zm9saW87DQo+ID4gLQ0KPiA+ICAgCWlmIChtYXhfbnIgPT0gMSkNCj4gPiAgIAkJcmV0dXJuIDE7
DQo+ID4NCj4gPiAtCS8qIEF2b2lkIGV4cGVuc2l2ZSBmb2xpbyBsb29rdXAgaWYgd2Ugc3RhbmQg
bm8gY2hhbmNlIG9mIGJlbmVmaXQuICovDQo+ID4gLQlpZiAocHRlX2JhdGNoX2hpbnQocHRlcCwg
cHRlKSA9PSAxKQ0KPiA+IC0JCXJldHVybiAxOw0KPiA+IC0NCj4gPiAtCWZvbGlvID0gdm1fbm9y
bWFsX2ZvbGlvKHZtYSwgYWRkciwgcHRlKTsNCj4gPiAtCWlmICghZm9saW8gfHwgIWZvbGlvX3Rl
c3RfbGFyZ2UoZm9saW8pKQ0KPiA+IC0JCXJldHVybiAxOw0KPiA+IC0NCj4gPiAtCXJldHVybiBm
b2xpb19wdGVfYmF0Y2goZm9saW8sIHB0ZXAsIHB0ZSwgbWF4X25yKTsNCj4gPiArCXJldHVybiBj
YW5fcHRlX2JhdGNoX2NvdW50KHZtYSwgcHRlcCwgJnB0ZSwgbWF4X25yLCAwKTsNCj4gPiAgIH0N
Cj4gPg0KPiA+ICAgc3RhdGljIGludCBtb3ZlX3B0ZXMoc3RydWN0IHBhZ2V0YWJsZV9tb3ZlX2Nv
bnRyb2wgKnBtYywNCj4gPiAgIAkJdW5zaWduZWQgbG9uZyBleHRlbnQsIHBtZF90ICpvbGRfcG1k
LCBwbWRfdCAqbmV3X3BtZCkNCj4gPiAgIHsNCj4gPiBAQCAtMjc4LDExICsyNjgsMTEgQEAgc3Rh
dGljIGludCBtb3ZlX3B0ZXMoc3RydWN0DQo+IHBhZ2V0YWJsZV9tb3ZlX2NvbnRyb2wgKnBtYywN
Cj4gPiAgIAkJICogbWFrZSBzdXJlIHRoZSBwaHlzaWNhbCBwYWdlIHN0YXlzIHZhbGlkIHVudGls
DQo+ID4gICAJCSAqIHRoZSBUTEIgZW50cnkgZm9yIHRoZSBvbGQgbWFwcGluZyBoYXMgYmVlbg0K
PiA+ICAgCQkgKiBmbHVzaGVkLg0KPiA+ICAgCQkgKi8NCj4gPiAgIAkJaWYgKHB0ZV9wcmVzZW50
KG9sZF9wdGUpKSB7DQo+ID4gLQkJCW5yX3B0ZXMgPSBtcmVtYXBfZm9saW9fcHRlX2JhdGNoKHZt
YSwgb2xkX2FkZHIsDQo+IG9sZF9wdGVwLA0KPiA+ICsJCQlucl9wdGVzID0gbXJlbWFwX3B0ZV9i
YXRjaCh2bWEsIG9sZF9hZGRyLCBvbGRfcHRlcCwNCj4gPiAgIAkJCQkJCQkgb2xkX3B0ZSwNCj4g
bWF4X25yX3B0ZXMpOw0KPiA+ICAgCQkJZm9yY2VfZmx1c2ggPSB0cnVlOw0KPiA+ICAgCQl9DQo+
ID4gICAJCXB0ZSA9IGdldF9hbmRfY2xlYXJfcHRlcyhtbSwgb2xkX2FkZHIsIG9sZF9wdGVwLCBu
cl9wdGVzKTsNCj4gDQo+IGdldF9hbmRfY2xlYXJfcHRlcygpIGRvY3VtZW50czogIkNsZWFyIHBy
ZXNlbnQgUFRFcyB0aGF0IG1hcCBjb25zZWN1dGl2ZQ0KPiBwYWdlcyBvZiB0aGUgc2FtZSBmb2xp
bywgY29sbGVjdGluZyBkaXJ0eS9hY2Nlc3NlZCBiaXRzLiINCg0KT2gsIGdvb2QgY2F0Y2guIE15
IGZvY3VzIHdhcyBzb2xlbHkgb24gdGhlIGltcGxlbWVudGF0aW9ucyBvZiBnZXRfYW5kX2NsZWFy
X3B0ZXMoKQ0KYW5kIHNldF9wdGVzKCkgYW5kIHJlZ2FyZGluZyB0aGVpciBtdWx0aS1mb2xpbyBQ
VEVzIGhhbmRsaW5nLCBhbmQgSSBtaXNzZWQgdGhpcyBjb21tZW50Lg0KZ2V0X2FuZF9jbGVhcl9w
dGVzKCkgd2lsbCBjb2xsZWN0IGRpcnR5L2FjY2Vzc2VkIGJpdHMgaW4gYmF0Y2ggcmFuZ2VzLCBh
bmQgc2V0IGluIGxhdGVyLg0KDQo+IA0KPiBBbmQgYXMgY2FuX3B0ZV9iYXRjaF9jb3VudCgpIHdp
bGwgbWVyZ2UgYWNjZXNzL2RpcnR5IGJpdHMsIHlvdSB3b3VsZCBzaWxlbnRseQ0KPiBzZXQgcHRl
cyBkaXJ0eS9hY2Nlc3NlZCB0aGF0IGJlbG9uZyB0byBvdGhlciBmb2xpb3MsIHdoaWNoIHNvdW5k
cyB2ZXJ5IHdyb25nLg0KDQpZZWFyLCB5b3VyIGFuYWx5c2lzIGlzIHZlcnkgdGhvcm91Z2guIFRo
ZSBhY2Nlc3MvZGlydHkgYml0IHdpbGwgYmUgbWVyZ2VkIGJldHdlZW4NCm5laWdoYm9yaW5nIGJh
dGNoZWQgZm9saW9zIGR1ZSB0byBnZXRfYW5kX2NsZWFyX3B0ZXMoKS4NCg0KSWYgY2FsbGVyIGRv
bid0IHdhbnQgdG8gbWVyZ2UgYWNjZXNzL2RpcnR5IGJpdHMgYmV0d2VlbiBmb2xpb3MobWVhbnMg
bm90IGlnbm9yZSBhbnkgYml0cyksIA0KdGhleSBzaG91bGQgY2FsbCBmb2xpb19wdGVfYmF0Y2go
KSBvciB0aGUgbmV3IGludGVyZmFjZSB3aXRoICdmbGFnIHwgRlBCX1JFU1BFQ1RfRElSVFkgJw0K
KGFjY2VzcyBiaXQgaXMgZGVmYXVsdCBiZSByZXNwZWN0ZWQpLg0KDQo+IA0KPiBTdGFyaW5nIGF0
IHRoZSBjb2RlLCBJIHdvbmRlciBpZiB0aGVyZSBpcyBhbHNvIGEgcHJvYmxlbSB3aXRoIHRoZSB3
cml0ZSBiaXQsIGhhdmUNCj4gdG8gZGlnIGludG8gdGhhdC4NCg0KVGhlIHdyaXRlIGJpdCBpcyBo
YW5kbGVkIHNpbWlsYXJseSB0byBkaXJ0eSBiaXQuIElmIGNhbGxlZCBkb24ndCB3YW50IG1lcmdl
IHdyaXRlIGJldHdlZW4gZm9saW9zLCB3ZQ0KY291bGQgY2FsbCB0aGUgbmV3IGludGVyZmFjZSB3
aXRoICdmbGFnIHwgRlBCX1JFU1BFQ1RfV1JJVEUnLCBhbmQgcHRlX3NhbWUoKSB3aWxsIGNvbXBh
cmUgdGhlIHdyaXRlIGJpdA0Kd2l0aCB0aGUgbmV4dCBuZWlnaGJvcmluZyBmb2xpbyBwdGUuICBJ
ZiBpdCdzIGRpZmZlcmVudCwgaXQgd2lsbCBicmVhay4NCg0KVGhhbmtzIGZvciB0aGUgaW4tZGVw
dGggcmV2aWV3Lg0KIA0KPiAtLQ0KPiBDaGVlcnMNCj4gDQo+IERhdmlkIC8gZGhpbGRlbmINCj4g
DQoNCg==

