Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42532CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 12:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A54B6B03BB; Wed, 27 Aug 2025 08:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356246B03BC; Wed, 27 Aug 2025 08:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292F16B03BD; Wed, 27 Aug 2025 08:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1330C6B03BB
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:33:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B47991DE3A8
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:33:51 +0000 (UTC)
X-FDA: 83822479062.11.9F6385A
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	by imf09.hostedemail.com (Postfix) with ESMTP id C6653140008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:33:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756298030; a=rsa-sha256;
	cv=none;
	b=L3VcsK3ACo2VNbun4ca2b/vy3ErB445HvMUs4B9niSaxm1EaLhvixh3B1NaIq0v8xd2azG
	aj8izWg9em/H34qtkbzlB3wIEhLST/Lv6fjUkRY22kvdwXS+sMDsLGLm94XruTiIc1UpDC
	zWOtQEb4lC4PMOvaiiuM320KSSqJvU4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756298030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=Yx0kr1wXhgSaAx25bJJouKIIwYnGwEseD+c/vd2eMho=;
	b=U0a2WbQgu2zlqJ+Cq5dXk50QSrAYY5ZQQ5CXFfy6WfXSYXvLgDTxWU5QJGSzMWSWxPtcoJ
	5LQtDgpPlQMhG5dy3Vt9qOwYVCBCvZLp82X8y3iuu2P9LQgYac2FiOqQxDJoMk0JYMtwlB
	7YltFMfuyU3c/rd3/MRRvjVd8ljAQI0=
From: "Li,Rongqing" <lirongqing@baidu.com>
To: David Hildenbrand <david@redhat.com>, "muchun.song@linux.dev"
	<muchun.song@linux.dev>, "osalvador@suse.de" <osalvador@suse.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "giorgitchankvetadze1997@gmail.com"
	<giorgitchankvetadze1997@gmail.com>
CC: "Xu,Wenjie(ACG CCN)" <xuwenjie04@baidu.com>
Subject: RE: Re: [PATCH] mm/hugetlb: two-phase hugepage allocation when
 reservation is high
Thread-Topic: Re: [PATCH] mm/hugetlb: two-phase hugepage allocation when
 reservation is high
Thread-Index: AdwXTo2D4t8VzJOQTS+wEMkzEbc86Q==
Date: Wed, 27 Aug 2025 12:33:35 +0000
Message-ID: <73da268715754133b787f22e016a903c@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.127.72.28]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.50.12
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C6653140008
X-Stat-Signature: qf5dfak6zup51doyh4d9ezwzqyktnt7x
X-Rspam-User: 
X-HE-Tag: 1756298028-718533
X-HE-Meta: U2FsdGVkX1/YYAIh1dLWm0ClQe9iDLDde20lzW9pYxNfI+KZ9atX2/43u9BLpbUbCNtocNeS5VyqLHmeQLds0knAtbiiHg7o7tbJOyB2Z6rVhhMZkNi0Bm+gnHLpouqp3o08G6XdzjN9bywLgLBYmhedsxKxiMlVweuz9Ab1iDGb2Ei6PL28vb/bgUfcL9tbtWdo1XZJK5LRLNYfYX+2WCX5j1R9Ed+55N8OWuChs1gT5+SpzjFwpNOsHzZoiKe3ssEe7pta/JuamXzGmSgx64ZXf2nal9LjzmlQMXDhXmo4JSk9g0MBhT0zSxR21IwEPO1NDqBAJ4uLdqfSFkAwssYFnupNHkFwqm0d12u3yklQ6qrLsBy/ldxXi7C4wq3uLgUM1ygH+jMziBw+BLMQl5fBSb3MhX4zHs+Q0rFGgwN5rd2sURUf8nljblyYVYjL3VQomi314wlDVtYfsweAFjeNbWreV5yJ+nNs+b6A9z8qMQ0q98DcvFwq3mInQhxMplyvg+Xb9HfjgUpsw0cY3hazpElmyV/HJJvapcyClcc8KbRWpZEaBqvC1h53Au37CMxoLaPNA19Skkv+KNOuPuvEdCRwRDzymjGTCkasTbh6gx+hAcRfSZZz9NjeB4ndcd6MTqr3p3AJSfFnaORP1869FtRrWfVAscz/DJX6hJTe/xNtjJ9Oj5BUcVgZxQmTgbF8C7gnyLCDMt+yJJgap2ZS1KcmldwQgX8TtZOHLW9uuC2or4ke/iPB2/ys4U0lOLIJ2LAjo/SDGCVOgw7AEB3lNMv4mNJ+qqAroSpt62bSna0ktPtCKzl34cYBQyMXpSKBMu2P35Xr0v8hbiSU+B0BYTCsM1gsLaiD+OQx1uu64956p4GLTSI10SgqRAkX/LYgclh87NHj05aeCVmMtkmZpc1PO6dPPnGMbJ+E7nbm7NVX4jukEh+IJnHc7MzhhQMJ2X0pdw8GuTyxndZ
 7S3noHBn
 1jzIw9a3zhCjONLH3i1yXg0Tz8oSlFUdr8M/eJNtq7lmjXmTeiqpcnvH42sg0DJ7Q/IrLJadvs77/VcFzzAl6WA/VM111o4j9hE7Kvy+D9gx2Xuvk2LMKwoHmN+gwGY25s7INbGuHfHu9N4V8lWpZDXXOjITNeKinDClc//IpK+vSnoeGYcSBin7bav3xZy4yMCDu0e93vatJ3RvIEw2MKPx8bf9BFf3jQQtdci0e+VUHM+yKO/gio1q8cSB1lDMIt68Qi8ZU1pnSGzF7WSuV16f5Vt8qxHzOvFwP0GYw7WIiLghuu5Otx0GHybTWbjGXhoWQjgNadMzlpenrJTLDNbM+RdWReOz9IitqVwIg+y/Gxv649wRs4hbrm/UQVQwdWzPOm1Y2ZqyahqjmQLM4obAnm5FanAsaOKUv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBOb3Qgc3VyZSBpZiBzb21ldGhpbmcgbGlrZSB0aGUgZm9sbG93aW5nIGNvdWxkIGZseToNCj4g
DQo+IGRpZmYgLS1naXQgYS9tbS9odWdldGxiLmMgYi9tbS9odWdldGxiLmMgaW5kZXgNCj4gMWY0
MjE4NmE4NWVhNC4uZGZiNGQ3MTdiOGEwMiAxMDA2NDQNCj4gLS0tIGEvbW0vaHVnZXRsYi5jDQo+
ICsrKyBiL21tL2h1Z2V0bGIuYw0KPiBAQCAtMzU5NSw4ICszNTk1LDYgQEAgc3RhdGljIHVuc2ln
bmVkIGxvbmcgX19pbml0DQo+IGh1Z2V0bGJfcGFnZXNfYWxsb2NfYm9vdChzdHJ1Y3QgaHN0YXRl
ICpoKQ0KPiAgICAgICAgICB1bnNpZ25lZCBsb25nIGppZmZpZXNfZW5kOw0KPiANCj4gICAgICAg
ICAgam9iLnRocmVhZF9mbiAgID0gaHVnZXRsYl9wYWdlc19hbGxvY19ib290X25vZGU7DQo+IC0g
ICAgICAgam9iLnN0YXJ0ICAgICAgID0gMDsNCj4gLSAgICAgICBqb2Iuc2l6ZSAgICAgICAgPSBo
LT5tYXhfaHVnZV9wYWdlczsNCj4gDQo+ICAgICAgICAgIC8qDQo+ICAgICAgICAgICAqIGpvYi5t
YXhfdGhyZWFkcyBpcyAyNSUgb2YgdGhlIGF2YWlsYWJsZSBjcHUgdGhyZWFkcyBieSBkZWZhdWx0
Lg0KPiBAQCAtMzYyMCwxMCArMzYxOCwyNCBAQCBzdGF0aWMgdW5zaWduZWQgbG9uZyBfX2luaXQN
Cj4gaHVnZXRsYl9wYWdlc19hbGxvY19ib290KHN0cnVjdCBoc3RhdGUgKmgpDQo+ICAgICAgICAg
IH0NCj4gDQo+ICAgICAgICAgIGpvYi5tYXhfdGhyZWFkcyA9IGh1Z2VwYWdlX2FsbG9jYXRpb25f
dGhyZWFkczsNCj4gLSAgICAgICBqb2IubWluX2NodW5rICAgPSBoLT5tYXhfaHVnZV9wYWdlcyAv
DQo+IGh1Z2VwYWdlX2FsbG9jYXRpb25fdGhyZWFkczsNCj4gDQo+ICAgICAgICAgIGppZmZpZXNf
c3RhcnQgPSBqaWZmaWVzOw0KPiAtICAgICAgIHBhZGF0YV9kb19tdWx0aXRocmVhZGVkKCZqb2Ip
Ow0KPiArICAgICAgIC8qIFRPRE86IGNvbW1lbnQgd2h5IHdlIHJldHJ5IGFuZCBob3cgaXQgaW50
ZXJhY3RzIHdpdGgNCj4gdm1lbW1hcCBvcC4gKi8NCj4gKyAgICAgICB3aGlsZSAoaC0+bnJfaHVn
ZV9wYWdlcyAhPSBoLT5tYXhfaHVnZV9wYWdlcykgew0KPiArICAgICAgICAgICAgICAgdW5zaWdu
ZWQgbG9uZyByZW1haW5pbmcgPSBoLT5tYXhfaHVnZV9wYWdlcyAtDQo+ICsgaC0+bnJfaHVnZV9w
YWdlczsNCj4gKw0KPiArICAgICAgICAgICAgICAgam9iLnN0YXJ0ICAgICAgID0gaC0+bnJfaHVn
ZV9wYWdlczsNCj4gKyAgICAgICAgICAgICAgIGpvYi5zaXplICAgICAgICA9IHJlbWFpbmluZzsN
Cj4gKyAgICAgICAgICAgICAgIGpvYi5taW5fY2h1bmsgICA9IHJlbWFpbmluZyAvDQo+IGh1Z2Vw
YWdlX2FsbG9jYXRpb25fdGhyZWFkczsNCj4gKyAgICAgICAgICAgICAgIHBhZGF0YV9kb19tdWx0
aXRocmVhZGVkKCZqb2IpOw0KPiArDQo+ICsgICAgICAgICAgICAgICBpZiAoaHVnZXRsYl92bWVt
bWFwX29wdGltaXphYmxlKGgpKQ0KPiArICAgICAgICAgICAgICAgICAgICAgICBicmVhazsNCg0K
SXQgc2hvdWxkIGJlOg0KICAgICAgICAgICBpZiAoIWh1Z2V0bGJfdm1lbW1hcF9vcHRpbWl6YWJs
ZShoKSkNCiAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KDQpvdGhlciBpcyBmaW5lIHRvIG1l
DQoNCnRoYW5rcw0KDQotTGkNCg0KDQo+ICsNCj4gKyAgICAgICAgICAgICAgIC8qIFN0b3AgaWYg
dGhlcmUgaXMgbm8gcHJvZ3Jlc3MuICovDQo+ICsgICAgICAgICAgICAgICBpZiAocmVtYWluaW5n
ID09IGgtPm1heF9odWdlX3BhZ2VzIC0gaC0+bnJfaHVnZV9wYWdlcykNCj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgYnJlYWs7DQo+ICsgICAgICAgfQ0KPiAgICAgICAgICBqaWZmaWVzX2VuZCA9
IGppZmZpZXM7DQo+IA0KPiAgICAgICAgICBwcl9pbmZvKCJIdWdlVExCOiBhbGxvY2F0aW9uIHRv
b2sgJWRtcyB3aXRoDQo+IGh1Z2VwYWdlX2FsbG9jYXRpb25fdGhyZWFkcz0lbGRcbiIsDQo+IA0K
PiANCj4gLS0NCj4gQ2hlZXJzDQo+IA0KPiBEYXZpZCAvIGRoaWxkZW5iDQoNCg==

