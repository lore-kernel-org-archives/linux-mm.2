Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 197E1D44C54
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FD3B6B0088; Thu, 15 Jan 2026 09:35:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D4706B0089; Thu, 15 Jan 2026 09:35:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0B56B008C; Thu, 15 Jan 2026 09:35:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5CFE16B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:35:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 034178B669
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:35:12 +0000 (UTC)
X-FDA: 84334445706.05.E318D7B
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id BA8011C0004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:35:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768487711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GsnesY46C7txOMXSi1RG0Noxnsupye4L9XuEAcDVyC0=;
	b=TU+XgbocQ0xie9XDShCGIg6EJ96gXifQBeX65JBdwtSiEdjhGMkVzefDni8wAgULhTEngK
	bPGj2U2seNQsOZXlD6ykUGWQF26oFiyhTzocIbbO7o0OLDvo5++Psv5SY/4vP8d++D+fvR
	zMlwoIAeY333KgxxM2f0BIpgd8xei2U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768487711; a=rsa-sha256;
	cv=none;
	b=N1efPRxc/zzFTxDGxg4iPOKuEa5xLkEra7TgQyHWfBlQYYgq03O93CNQTeRfX6GC1r2IsI
	ayR9t0FFBNnYmcMYtbPT7HJGwpecWmEMa+52QV0tEq8iCo3ysJ5fUeQLrCrDwTtw3FOZpv
	baT+DDCRjwjdjwVwiTV2XNXxIQczIsI=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dsQVh2NPfzJ46C6;
	Thu, 15 Jan 2026 22:34:52 +0800 (CST)
Received: from dubpeml100006.china.huawei.com (unknown [7.214.145.132])
	by mail.maildlp.com (Postfix) with ESMTPS id B579340584;
	Thu, 15 Jan 2026 22:35:08 +0800 (CST)
Received: from dubpeml100008.china.huawei.com (7.214.145.227) by
 dubpeml100006.china.huawei.com (7.214.145.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 15 Jan 2026 14:35:08 +0000
Received: from dubpeml100008.china.huawei.com ([7.214.145.227]) by
 dubpeml100008.china.huawei.com ([7.214.145.227]) with mapi id 15.02.1544.036;
 Thu, 15 Jan 2026 14:35:08 +0000
From: Shiju Jose <shiju.jose@huawei.com>
To: Borislav Petkov <bp@alien8.de>
CC: "rafael@kernel.org" <rafael@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"dferguson@amperecomputing.com" <dferguson@amperecomputing.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "tony.luck@intel.com" <tony.luck@intel.com>,
	"lenb@kernel.org" <lenb@kernel.org>, "leo.duran@amd.com" <leo.duran@amd.com>,
	"Yazen.Ghannam@amd.com" <Yazen.Ghannam@amd.com>, "mchehab@kernel.org"
	<mchehab@kernel.org>, Jonathan Cameron <jonathan.cameron@huawei.com>,
	Linuxarm <linuxarm@huawei.com>, "rientjes@google.com" <rientjes@google.com>,
	"jiaqiyan@google.com" <jiaqiyan@google.com>, "Jon.Grimm@amd.com"
	<Jon.Grimm@amd.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "naoya.horiguchi@nec.com"
	<naoya.horiguchi@nec.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"jthoughton@google.com" <jthoughton@google.com>, "somasundaram.a@hpe.com"
	<somasundaram.a@hpe.com>, "erdemaktas@google.com" <erdemaktas@google.com>,
	"pgonda@google.com" <pgonda@google.com>, "duenwen@google.com"
	<duenwen@google.com>, "gthelen@google.com" <gthelen@google.com>,
	"wschwartz@amperecomputing.com" <wschwartz@amperecomputing.com>,
	"wbs@os.amperecomputing.com" <wbs@os.amperecomputing.com>,
	"nifan.cxl@gmail.com" <nifan.cxl@gmail.com>, tanxiaofei
	<tanxiaofei@huawei.com>, "Zengtao (B)" <prime.zeng@hisilicon.com>, "Roberto
 Sassu" <roberto.sassu@huawei.com>, "kangkang.shen@futurewei.com"
	<kangkang.shen@futurewei.com>, wanghuiqiang <wanghuiqiang@huawei.com>
Subject: RE: [PATCH v14 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature
 table
Thread-Topic: [PATCH v14 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature
 table
Thread-Index: AQHcaRwzowtPaYFfVka45sLtxZNoVLVO16oAgAE3y4CAA3WoUA==
Date: Thu, 15 Jan 2026 14:35:08 +0000
Message-ID: <d310566a0d6544eeb57a43b110782118@huawei.com>
References: <20251209145742.297-1-shiju.jose@huawei.com>
 <20251209145742.297-2-shiju.jose@huawei.com>
 <20260112150552.GGaWUN0Ex8KgfqEEi5@fat_crate.local>
 <20260113094149.GAaWYTXf6qH4zleOOQ@fat_crate.local>
In-Reply-To: <20260113094149.GAaWYTXf6qH4zleOOQ@fat_crate.local>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.195.246.32]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: 7jkpo5nd9b3ipfsbewmoq37rhtmpr9so
X-Rspamd-Queue-Id: BA8011C0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1768487710-360637
X-HE-Meta: U2FsdGVkX1+2v/ExCtpUy7IXsxoxHeUxjwTkcWvXeVwjY82NF5WUWb7MHr4phFJPJc/fH7CS5ihYaBu3xUY4Ljm1gYxil5YhYET/r8LGWM0hNVUiAjmro8E7Mt7ocFUV9VDTBg/dLWaRImFIP8Y6sXwOvauzUGU9YPXN2BBp6rXazR5BYuiKMj/wEiSGrYqp5VhrsTWkrtKEMvpKs823+HydvfKhRoMAEdj4KZVfHun7B3tpeI1znySTcEywNEhSZNUf/POjGt0fh4+y6gyZ/MN6hK4DYpyYHRYu+cIdUgC0UvoZ4g5OoJ56q05s60TQhlAL4PoEo+rFW0pvGixfhwMUPHWupo5ht4J7eamWGDntZ0P/94WA5kt6nayurfvALjyazObY4Eng82OYgu9WFWHbKpHXpsegP2px2/7fZWl8QT1ArmN610g8/ZeVM1E6+tPTSHd0a5vxlKJP7A5efwUL9jznj24Mkn21Y+7zuJjzAWD0ovpcOA3kNaA6Yi2HsZBJuUEyVODsdpfuXQ0V3FNjTkNgl8DtU7X1/FJRO019JJL5d5VQckGAb6uhEfVcuyH8VCATBmpjqi+a7+qIhmCdZupf1zWPPNyu6hreEY69vgTuC7Xm7fgBUIfFGaVsF6F3SN3hOlJNgGSYkw1SVgHsvGVP6cEUl3U8opwM49PM6clFTQaE3gAeNrV2SdyZrC+Xrazy4hyEydJyDVwoFzaZtrT3yPHed/UxW19y5GAWsNd1CMp6CaY6ZTi0Fdwv1Yly+8ru5CCeS0Vd37x4TjY+8hJPkfIuzAkCiW02maiOkxlta7IdE9Wzk1FzpiuGJsu+trJ58hSix81rf/DFNjZMsBVhjdEItbfuHjE3GJWy9RJXrQezk83yRK+4jS0eVUsI4VbxDfAk+kOddhF1D5ehNWKftmdxPSTtmTRXBTd+7C4mHnjZi1QfyK6IsfNkZY9Mwx6BoLLufOW2MEX
 PtDD5nKX
 XRWOHXXxKf6+g7zblLy7IxI6PW7MFrrTocOPKu50KNuVS0M4zJryEcll0C39+2zOeRnfegXtkenHxGDUFcmP2J1Ye4azHxKw5PycQg1HqPkBj92JGbghimVGl9LjMvly+4Gx28rQWfQpWjlUo3uHk8RT9BiFO8UO5RRRLDTIwQY0z9hzs4Wf9slhOdVozmoB7wWb29yquPzKi0MZvcFlFBjS/rbS2E/s6nWG2VG3oeHp38vfnKFufYdQKB47mcyTzNcgUXChz60flmY4tWlWg7+goK1amFA5rbifHeJRH6+YN6IBP6jK4JUJ//OHjVIa6jvpyFUFIx5s4Q989UhNcC5B1gfQi0yczD/kLfuxe6l8QiDvaXuHlbHpks0LHcEuJXF6CcwSA0kjyZCIuA5Yt9WDm8U7l1yGC/4a4diA9Vd4hX+e8G73ZhAklpHnOgKw7od//7gy9LTqXUpwi4AOBLep0tzebb7lokuJg6cY1XccaW0JAORcyZnHhy8p4xSSvlGENI19V0rvFnkjfXp++6Bh3AqajLuHeGVLDVyMfzBhn9nhg2xNeszB2yCPqZrzw7K5/Ol/a9oIfGtaikU+5r2khfdakfYt4m1m8/EJCBusuDvp/TLCA8iJnabHwQgllqoHFB08eCs4bYwObPNwnNpASOt1aiAI0wIZ9+dGyTpWH9jRzwVgk8Uu79J9VI3MeiuoLuTaO6Ju6Q7W7RSftbDZtU1WAtmtDBr7aZSgz85zTSORMRIzUStPMDXRHo3obprpNmv4SPPbEq9etDICBatO8MWPQNJWhnKNfVbgVc5nHDS/QdxwzxMRhyKleoI4q2qC9MD03feIo7+vuXcvrvMe295ceb3Isl/zOGnJrakjoeJ97gf2R6o83d6t76Z9s8Yrp0UX918uDNwlOuOg0eI2d2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogQm9yaXNsYXYgUGV0a292IDxicEBh
bGllbjguZGU+DQo+U2VudDogMTMgSmFudWFyeSAyMDI2IDA5OjQyDQo+VG86IFNoaWp1IEpvc2Ug
PHNoaWp1Lmpvc2VAaHVhd2VpLmNvbT4NCj5DYzogcmFmYWVsQGtlcm5lbC5vcmc7IGFrcG1AbGlu
dXgtZm91bmRhdGlvbi5vcmc7IHJwcHRAa2VybmVsLm9yZzsNCj5kZmVyZ3Vzb25AYW1wZXJlY29t
cHV0aW5nLmNvbTsgbGludXgtZWRhY0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPmFjcGlAdmdl
ci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7IGxpbnV4LWRvY0B2Z2VyLmtlcm5lbC5v
cmc7DQo+dG9ueS5sdWNrQGludGVsLmNvbTsgbGVuYkBrZXJuZWwub3JnOyBsZW8uZHVyYW5AYW1k
LmNvbTsNCj5ZYXplbi5HaGFubmFtQGFtZC5jb207IG1jaGVoYWJAa2VybmVsLm9yZzsgSm9uYXRo
YW4gQ2FtZXJvbg0KPjxqb25hdGhhbi5jYW1lcm9uQGh1YXdlaS5jb20+OyBMaW51eGFybSA8bGlu
dXhhcm1AaHVhd2VpLmNvbT47DQo+cmllbnRqZXNAZ29vZ2xlLmNvbTsgamlhcWl5YW5AZ29vZ2xl
LmNvbTsgSm9uLkdyaW1tQGFtZC5jb207DQo+ZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29tOyBu
YW95YS5ob3JpZ3VjaGlAbmVjLmNvbTsNCj5qYW1lcy5tb3JzZUBhcm0uY29tOyBqdGhvdWdodG9u
QGdvb2dsZS5jb207IHNvbWFzdW5kYXJhbS5hQGhwZS5jb207DQo+ZXJkZW1ha3Rhc0Bnb29nbGUu
Y29tOyBwZ29uZGFAZ29vZ2xlLmNvbTsgZHVlbndlbkBnb29nbGUuY29tOw0KPmd0aGVsZW5AZ29v
Z2xlLmNvbTsgd3NjaHdhcnR6QGFtcGVyZWNvbXB1dGluZy5jb207DQo+d2JzQG9zLmFtcGVyZWNv
bXB1dGluZy5jb207IG5pZmFuLmN4bEBnbWFpbC5jb207IHRhbnhpYW9mZWkNCj48dGFueGlhb2Zl
aUBodWF3ZWkuY29tPjsgWmVuZ3RhbyAoQikgPHByaW1lLnplbmdAaGlzaWxpY29uLmNvbT47IFJv
YmVydG8NCj5TYXNzdSA8cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tPjsga2FuZ2thbmcuc2hlbkBm
dXR1cmV3ZWkuY29tOw0KPndhbmdodWlxaWFuZyA8d2FuZ2h1aXFpYW5nQGh1YXdlaS5jb20+DQo+
U3ViamVjdDogUmU6IFtQQVRDSCB2MTQgMS8yXSBBQ1BJOlJBUzI6IEFkZCBkcml2ZXIgZm9yIHRo
ZSBBQ1BJIFJBUzIgZmVhdHVyZQ0KPnRhYmxlDQo+DQo+T24gTW9uLCBKYW4gMTIsIDIwMjYgYXQg
MDQ6MDU6NTJQTSArMDEwMCwgQm9yaXNsYXYgUGV0a292IHdyb3RlOg0KPj4gUGxlYXNlIGdvIG92
ZXIgYWxsIG15IHJldmlldyBjb21tZW50cyBmcm9tIGhlcmU6DQo+Pg0KPj4gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvci8yMDI1MTEyNTA3MzYyNy5HTGFTVmNlN2hCcUdIMWEzbmlAZmF0X2NyYXRl
Lg0KPj4gbG9jYWwNCj4+DQo+PiBhbmQgZWl0aGVyIGluY29ycG9yYXRlIHRoZW0gb3Igc2F5IHdo
eSB5b3UgZG9uJ3QgYWdyZWUuDQo+Pg0KPj4gSWdub3JpbmcgdGhlbSBpcyBOT1Qgc29tZXRoaW5n
IHlvdSBzaG91bGQgZG8gYmVjYXVzZSB0aGlzIGdvZXMgYm90aCB3YXlzLg0KPj4NCj4+IElnbm9y
aW5nIHRoaXMgc3VibWlzc2lvbiBub3cuDQo+DQo+SSB0YWtlIHRoYXQgYmFjayAtIEkgZm9yZ290
IHRoYXQgdGhlcmUgd2FzIGFuIGluLWZsaWdodCByZXZpZXcgd2hlbiB5b3Ugc2VudCB5b3VyDQo+
djE0LiBTb3JyeS4NCj4NCj5TbyBwbGVhc2UgaW5jb3Jwb3JhdGUgKmFsbCogZmVlZGJhY2sgYW5k
IHNlbmQgYSBuZXcgdmVyc2lvbiBzbyB0aGF0IEkgY2FuIHRha2UgYQ0KPmxvb2suDQoNCkhpIEJv
cmlzbGF2LA0KDQpTdXJlLiBWMTUgc2VyaWVzIGhhcyBwb3N0ZWQgaW5jb3Jwb3JhdGluZyB5b3Vy
IGNvbW1lbnRzLiANCg0KVGhhbmtzLA0KU2hpanUNCg0KPg0KPlRoeC4NCj4NCj4tLQ0KPlJlZ2Fy
ZHMvR3J1c3MsDQo+ICAgIEJvcmlzLg0KPg0KPmh0dHBzOi8vcGVvcGxlLmtlcm5lbC5vcmcvdGds
eC9ub3Rlcy1hYm91dC1uZXRpcXVldHRlDQo=

