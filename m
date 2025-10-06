Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C642BCCA472
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 10:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0502A8E0003; Mon,  6 Oct 2025 06:37:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0274C8E0002; Mon,  6 Oct 2025 06:37:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA6548E0003; Mon,  6 Oct 2025 06:37:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D73878E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:37:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 40D741A0522
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:37:46 +0000 (UTC)
X-FDA: 83967338532.02.3CB766C
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 50FC910000D
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:37:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759747064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5a0V+ktkM0zmP/i/KvTfiBf3YEBIe7ryg6F09ELHLbA=;
	b=AL/JTikR3uqGQEV3wV8VW/feoXcD2jspwDHvmfv+lpLCv5+N3mbS4SkzmUHjJYQKM5n2Pv
	AxM641Di/olejV6np+jfIc8VK+qNUKQbV+VNnH/PnFSSmS5rcesk9ZLeQfJUf3dvZXsh4u
	d8Qaq6RbWgoM70yL4J4f/v+C5/gwZCo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759747064; a=rsa-sha256;
	cv=none;
	b=5OCfflx14/I9wPvKh5tGyngXYV1tdZjU1Njc+o3sNyPKl8yuTd4oWzfoTFBfFvF3d9MCkl
	RrJYA/z3o250Ky7j2cJO5H+tYWoaPTPQoCDIrJPB6p3UFzcBzfgl94o4As+bb3rqncW1JX
	4Fxf5LkxsXmqoBtmthNmkmNPLG5jOKY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cgG0z0LfWz6L4xs;
	Mon,  6 Oct 2025 18:37:07 +0800 (CST)
Received: from dubpeml500006.china.huawei.com (unknown [7.214.146.138])
	by mail.maildlp.com (Postfix) with ESMTPS id BC60F1402CB;
	Mon,  6 Oct 2025 18:37:39 +0800 (CST)
Received: from dubpeml100008.china.huawei.com (7.214.145.227) by
 dubpeml500006.china.huawei.com (7.214.146.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 6 Oct 2025 11:37:39 +0100
Received: from dubpeml100008.china.huawei.com ([7.214.145.227]) by
 dubpeml100008.china.huawei.com ([7.214.145.227]) with mapi id 15.02.1544.011;
 Mon, 6 Oct 2025 11:37:39 +0100
From: Shiju Jose <shiju.jose@huawei.com>
To: Borislav Petkov <bp@alien8.de>, Jonathan Cameron
	<jonathan.cameron@huawei.com>
CC: "rafael@kernel.org" <rafael@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"dferguson@amperecomputing.com" <dferguson@amperecomputing.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "tony.luck@intel.com" <tony.luck@intel.com>,
	"lenb@kernel.org" <lenb@kernel.org>, "Yazen.Ghannam@amd.com"
	<Yazen.Ghannam@amd.com>, "mchehab@kernel.org" <mchehab@kernel.org>, Linuxarm
	<linuxarm@huawei.com>, "rientjes@google.com" <rientjes@google.com>,
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
Subject: RE: [PATCH v12 1/2] ACPI:RAS2: Add ACPI RAS2 driver
Thread-Topic: [PATCH v12 1/2] ACPI:RAS2: Add ACPI RAS2 driver
Thread-Index: AQHcHC9WuMPoKRXbY02Oy+WxUZ/jerSMt+SAgAK0t2CAABfigIAEdNLAgAOLbYCAABR4AIACsFkAgBrSt9A=
Date: Mon, 6 Oct 2025 10:37:39 +0000
Message-ID: <6ac4ad35975142df986bfcb27d1e9b2c@huawei.com>
References: <20250902173043.1796-1-shiju.jose@huawei.com>
 <20250902173043.1796-2-shiju.jose@huawei.com>
 <20250910192707.GAaMHRCxWx37XitN3t@fat_crate.local>
 <9dd5e9d8e9b04a93bd4d882ef5d8b63e@huawei.com>
 <20250912141155.GAaMQqK4vS8zHd1z4_@fat_crate.local>
 <9433067c142b45d583eb96587b929878@huawei.com>
 <20250917162253.GCaMrgXYXq2T4hFI0w@fat_crate.local>
 <20250917183608.000038c4@huawei.com>
 <20250919103950.GCaM0y9r6R6b5jfx8z@fat_crate.local>
In-Reply-To: <20250919103950.GCaM0y9r6R6b5jfx8z@fat_crate.local>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.48.146.252]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 50FC910000D
X-Stat-Signature: oxwb7qd1xttntc3p4unw3us65bn1ijbx
X-Rspam-User: 
X-HE-Tag: 1759747063-222201
X-HE-Meta: U2FsdGVkX1+6WDEZ86sQFW50CT93kqvNFGh7DbjOEDTqPczxDKyraGgA5O2yPmY7rt+TlyiHqqeQtuaUFNFO8NPhfkUMW67wLxRmArMpge33zYF+YDt9lOvsUYxuUfNLdNrmDdJCIb91ctw0PQBCmZVGY7VIh16wgIyEXrSUh0vWXtqxs45tquXn7UJExdtZmjhOo1H7QGbrxpHgW0Etg2C1ioBx3aI1Bd//xspWPnu68tluoIQvsEMI5FsOn8d6uF/hHFapfvdBcBi6eMsBMRIP0DzuhphUcUKJpbiibRwPnvZMEFRTcB23oNH/jlpnTwvYa2rkqL08FPS9Tdm6/3+q4EVimQ10G1X+ZjOWAjAZK7N/kdHrI/Tm1cK96LLiEC1NAQ7TZReo1n/2WPLaRUZziVGJ/3JwDX39pi/Yq/jQSNNSjcdkg9DJKSrGySoR/1BD0LqBzlEqCruwdMPGhkEF+WuNciDR9rwPQgLggD1V7gJevfY0ZhBsO7U0ASp/+Wma+gNZXI9aYYjJxCwJRikUvm2opjVDBx7+FbQhxbDFZG0egfiaLVh01QPYBUFG/QROu24t5rOrzp3XVJZPRglDyTl4NB4cwJraBJhcVQhzSVUPUzFnfLSbKOYyU6iSa+zT/mh0Cj+4tqlCkvQHl8RDS18WmSS9GLCyn39iauGhn8hXWRociCb2PZeOVLYKjIjF3hPpgLrG77DX01mjudR4+e+gQAWHxVHbSG1Q6vCv+z+s1eo7KXvNLLn/aEnwTmvlk2uTP7o1INmsqw8SDvG8dkAw+Gx5rHaVArskpFearzsrgajOw/mqUaTGPW+5JZzPjJTaDol9gln/IpciRPDBGie/wA7EkwmpLz1FPUfW4UxuMdW+n9BoVAe1Ibo1tUuR4jkZ+9XKRkSAnQ9YrVfiW0kPZSjhn3iAa8dQT8TGQqy5tOB3VETh/s4noFWIksC0xlbT4hzmCmMsE/l
 6GqRZk3W
 oq/6yvZXGx0WhE8TXL/QaADn8IiDv55QZAwbH5J+zPkHgZ7Lo+x+IT6WG3Z6MRR6EIl46It4eBLJ8PsGe6YI1Q1rtUAl53aDWvrbUv37ECJlVWlU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogQm9yaXNsYXYgUGV0a292IDxicEBh
bGllbjguZGU+DQo+U2VudDogMTkgU2VwdGVtYmVyIDIwMjUgMTE6NDANCj5UbzogSm9uYXRoYW4g
Q2FtZXJvbiA8am9uYXRoYW4uY2FtZXJvbkBodWF3ZWkuY29tPg0KPkNjOiBTaGlqdSBKb3NlIDxz
aGlqdS5qb3NlQGh1YXdlaS5jb20+OyByYWZhZWxAa2VybmVsLm9yZzsgYWtwbUBsaW51eC0NCj5m
b3VuZGF0aW9uLm9yZzsgcnBwdEBrZXJuZWwub3JnOyBkZmVyZ3Vzb25AYW1wZXJlY29tcHV0aW5n
LmNvbTsgbGludXgtDQo+ZWRhY0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFjcGlAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7IGxpbnV4LQ0KPmRvY0B2Z2VyLmtlcm5lbC5vcmc7
IHRvbnkubHVja0BpbnRlbC5jb207IGxlbmJAa2VybmVsLm9yZzsNCj5ZYXplbi5HaGFubmFtQGFt
ZC5jb207IG1jaGVoYWJAa2VybmVsLm9yZzsgTGludXhhcm0NCj48bGludXhhcm1AaHVhd2VpLmNv
bT47IHJpZW50amVzQGdvb2dsZS5jb207IGppYXFpeWFuQGdvb2dsZS5jb207DQo+Sm9uLkdyaW1t
QGFtZC5jb207IGRhdmUuaGFuc2VuQGxpbnV4LmludGVsLmNvbTsNCj5uYW95YS5ob3JpZ3VjaGlA
bmVjLmNvbTsgamFtZXMubW9yc2VAYXJtLmNvbTsganRob3VnaHRvbkBnb29nbGUuY29tOw0KPnNv
bWFzdW5kYXJhbS5hQGhwZS5jb207IGVyZGVtYWt0YXNAZ29vZ2xlLmNvbTsgcGdvbmRhQGdvb2ds
ZS5jb207DQo+ZHVlbndlbkBnb29nbGUuY29tOyBndGhlbGVuQGdvb2dsZS5jb207DQo+d3NjaHdh
cnR6QGFtcGVyZWNvbXB1dGluZy5jb207IHdic0Bvcy5hbXBlcmVjb21wdXRpbmcuY29tOw0KPm5p
ZmFuLmN4bEBnbWFpbC5jb207IHRhbnhpYW9mZWkgPHRhbnhpYW9mZWlAaHVhd2VpLmNvbT47IFpl
bmd0YW8gKEIpDQo+PHByaW1lLnplbmdAaGlzaWxpY29uLmNvbT47IFJvYmVydG8gU2Fzc3UgPHJv
YmVydG8uc2Fzc3VAaHVhd2VpLmNvbT47DQo+a2FuZ2thbmcuc2hlbkBmdXR1cmV3ZWkuY29tOyB3
YW5naHVpcWlhbmcgPHdhbmdodWlxaWFuZ0BodWF3ZWkuY29tPg0KPlN1YmplY3Q6IFJlOiBbUEFU
Q0ggdjEyIDEvMl0gQUNQSTpSQVMyOiBBZGQgQUNQSSBSQVMyIGRyaXZlcg0KPg0KPk9uIFdlZCwg
U2VwIDE3LCAyMDI1IGF0IDA2OjM2OjA4UE0gKzAxMDAsIEpvbmF0aGFuIENhbWVyb24gd3JvdGU6
DQo+PiBUaGlzICdmaXJzdCBjb250aWd1b3VzIHJhbmdlJyBpcyBhbiBhdHRlbXB0IHRvIERUUlQg
aW4gYSBjb3JuZXIgY2FzZQ0KPj4gdGhhdCBpcyByZWFsIGJ1dCB3aGVyZSB0aGVyZSBpcyBub3Qg
YW4gb2J2aW91cyByaWdodCB0aGluZyBkdWUgdG8gc3BlYw0KPmxpbWl0YXRpb25zLg0KPg0KPlRo
YW5rcyBmb3IgdGFraW5nIHRoZSB0aW1lIHRvIGV4cGFuZC4gVGhlIGdpc3Qgb2YgdGhpcyBuZWVk
cyB0byBiZSBpbiBhIGNvbW1pdA0KPm1lc3NhZ2UgZm9yIGZ1dHVyZSByZWZlcmVuY2UuDQo+DQo+
SE9XRVZFUiwgSSdtIHN0aWxsIG5vdCBjbGVhciAqd2h5KiB3ZSdyZSBqdW1waW5nIHRocm91Z2gg
aG9vcHMgd2hpY2ggd2UNCj5wcm9iYWJseSBzZXQgdXAgb3Vyc2VsdmVzIHdpdGhvdXQgZXZlbiBr
bm93aW5nIHdoeS4uLiBhdCBsZWFzdCBpdCBsb29rcyBsaWtlIHRoaXMNCj5mcm9tIHdoZXJlIEkn
bSBzdGFuZGluZy4NCj4NCj5TbyB3aHkgbm90IHN0YXJ0IGEgc2NydWIgb24gdGhlIHdob2xlIHN5
c3RlbT8gV2h5IGRvIHdlIGNhcmU/DQo+DQo+U2NydWIgaXMgImNoZWFwIiBpbiB0aGUgc2Vuc2Ug
dGhhdCBpdCBydW5zIGluIHRoZSBiYWNrZ3JvdW5kIGFuZCBpcyB0aGUgbG93ZXN0DQo+cHJpb3Jp
dHkgYW5kIGV2ZXJ5dGhpbmcgZWxzZSBvdmVycmlkZXMgaXQuDQo+DQo+U28gd2h5IGRlc2lnbiBh
biBpbnRlcmZhY2Ugb25seSB3aGVuIHRoZXJlJ3MgYSBuZWVkIHRvIGRlc2lnbiBvbmUgYW5kIGRv
IHRoZQ0KPnNpbXBsZXN0IHRoaW5nIG5vdywgZm9yIHN0YXJ0ZXJzPyBHYXRoZXIgc29tZSBleHBl
cmllbmNlIGFuZCB0aGVuIGltcnBvdmUgaXQgYnkNCj5hY3R1YWxseSBkZXNpZ25pbmcgYW4gaW50
ZXJmYWNlLi4uDQoNCkhpIEJvcmlzLA0KDQpTb3JyeSBmb3IgdGhlIGRlbGF5IGluIHJlcGxheWlu
Zy4NCg0KV2UgaGF2ZSBhIHByb3RvdHlwZSBsb29raW5nIHRvIHNpbXBsaWZ5IHRoaW5ncyBhcyBm
b2xsb3dzIChsZWF2aW5nIHBlciBub2RlIGFuZA0KcmFuZ2UgY29udHJvbCBmb3IgZnV0dXJlIHdv
cmspLCBidXQgYmVmb3JlIEkgcG9zdCBpdCAod2FpdGluZyBmb3IgcmMxKSBJJ2QgbGlrZSB0byBk
aXNjdXNzDQp0aGUgYXBwcm9hY2ggYW5kIGEgZmV3IG9wZW4gcXVlc3Rpb25zIg0KDQoxLlNjcnVi
IHJhdGUNCjEuMS4gU2NydWIgcmF0ZSBpcyBjb21tb24gYWNyb3NzIHRoZSBOVU1BIG5vZGUgZG9t
YWlucy4NCjEuMi4gQ29tbW9uIG1pbiBzY3J1YiByYXRlIGlzIG1heCBvZiBtaW4gc2NydWIgcmF0
ZXMgYWNyb3NzIG5vZGVzLg0KMS4zLiBDb21tb24gbWF4IHNjcnViIHJhdGUgaXMgbWluIG9mIG1h
eCBzY3J1YiByYXRlcyBhY3Jvc3Mgbm9kZXMuDQoxLjQuIFNjcnViIHJhdGUgYWxsb3dlZCB0byBj
aGFuZ2Ugb25seSBpZiBOTyBkZW1hbmQgYW5kIHBhdHJvbA0KICAgc2NydWJiaW5nIGlzIGluIHBy
b2dyZXNzIGFuZCBzaG91bGQgYmUgd2l0aGluIG1pbiBhbmQgbWF4DQogICByYW5nZSBvZiBzY3J1
YiByYXRlcy4NCg0KMi4gRGVtYW5kIHNjcnViYmluZyBhbmQgQmFja2dyb3VuZCAocGF0cm9sKSBz
Y3J1YmJpbmcNCjIuMS4gQmFja2dyb3VuZCBzY3J1YmJpbmcgcmVxdWVzdCBlbmFibGVzIEJHIHNj
cnViYmluZw0KICAgICBvbiBhbGwgTlVNQSBub2Rlcy4NCg0KMi4yLiBGb3IsIGRlbWFuZCBzY3J1
YmJpbmcgcmVxdWVzdCAyIG9wdGlvbnMgYXJlIGlkZW50aWZpZWQsDQogICAgIHdpdGggKGIpIHRy
aWVkLiBQbGVhc2Ugc3VnZ2VzdCB0aGUgcmlnaHQgYXBwcm9hY2g/DQphKSBFbmFibGUgZGVtYW5k
IHNjcnViYmluZyBvbiBhbGwgTlVNQSBub2RlcywgaG9wZSBmb3INCiAgICAgdGhlICdSZXF1ZXN0
ZWQgQWRkcmVzcyBSYW5nZShJTlBVVCknIGZpZWxkLCBjYW4gdXNlDQogICAgIGFkZHJlc3Mgc2V0
IHRvIHNjcnViIGFuZCBQQUdFX1NJWkUob3Igc2ltaWxhcikgZm9yIGFsbCB0aGUNCiAgICAgbm9k
ZXMuIEZvciBSQVMyLCBvbmx5ICdhZGRyJyBzeXNmcyBhdHRyaWJ1dGUgaXMgYWRkZWQgbm93DQog
ICAgIGFuZCAnc2l6ZScgc3lzZnMgYXR0cmlidXRlIGlzIHJlbW92ZWQuDQpiKSBFbmFibGUgZGVt
YW5kIHNjcnViYmluZyBvbiBhIE5VTUEgbm9kZSBmb3Igd2hpY2gNCiAgICAgdGhlIHJlcXVlc3Rl
ZCBhZGRyZXNzIHRvIHNjcnViIGlzIHdpdGhpbiB0aGUgUEEgcmFuZ2Ugb2YNCiAgICAgdGhhdCBu
b2RlLg0KDQoyLjMuIERlbWFuZCBzY3J1YmJpbmcgaXMgbm90IGFsbG93ZWQgd2hlbiBiYWNrZ3Jv
dW5kIHNjcnViYmluZw0KICAgICBpcyBpbiBwcm9ncmVzcy4NCg0KMi40LiBJZiAyLjIuIChiKSBp
cyBjaG9zZW4sIHNob3VsZCBrZXJuZWwgYWxsb3cgQkcNCiAgICAgIHNjcnViYmluZyBvbiByZXN0
IG9mIHRoZSBub2Rlcywgd2hlbiBkZW1hbmQgc2NydWJiaW5nIG9uDQogICAgICBzb21lIG5vZGUv
cyBpcyBpbiBwcm9ncmVzcz8NCg0KMi41IFRoZSBzdGF0dXMgb2YgdGhlIEJHIHNjcnViYmluZyBl
eHBvc2VkIHRvIHRoZSB1c2VyIHNwYWNlDQogICAgaW4gJ2VuYWJsZV9iYWNrZ3JvdW5kJyBzeXNm
cyBhdHRyaWJ1dGUuDQoNCjIuNiBUaGUgc3RhdHVzIG9mIHRoZSBkZW1hbmQgc2NydWJiaW5nIGV4
cG9zZWQgdG8gdGhlDQogICAgICAgdXNlciBzcGFjZSBpbiAnYWRkcicgc3lzZnMgYXR0cmlidXRl
LiBIb3dldmVyIHdoZW4gdGhlDQogICAgICAgZGVtYW5kIHNjcnViYmluZyBpcyBvbiBtdWx0aXBs
ZS9hbGwgbm9kZXMgYXJlIGluIHByb2dyZXNzLA0KICAgICAgIHdoaWNoIGRlbWFuZCBzY3J1YmJp
bmcgc3RhdHVzIGFuZCBhZGRyZXNzIGluICdhZGRyJyBzeXNmcyBhdHRyaWJ1dGUNCiAgICAgICBh
cyBzdGF0dXMgc2hvdWxkIGJlIGV4cG9zZWQgdG8gdGhlIHVzZXIgc3BhY2U/DQphKSBNYXkgYmUg
dGhlIHN0YXR1cyBvZiB0aGUgZmlyc3QgZGV0ZWN0ZWQgbm9kZSB3aXRoIGRlbWFuZCBzY3J1YmJp
bmcNCiAgICAgaXMgaW4gcHJvZ3Jlc3M/DQpiKSBEb2VzIG5vdCBzaG93IHRoZSBzdGF0dXMgYXQg
YWxsLCBqdXN0IGZhaWwgdGhlIHJlcXVlc3QgaWYgdGhlDQogICAgZGVtYW5kIHNjcnViYmluZyBp
cyBhbHJlYWR5IGluIHByb2dyZXNzIG9uIGEgbm9kZS9hbGwgbm9kZXM/DQpjKSAgQW55IG90aGVy
IHN1Z2dlc3Rpb24/DQoNClRoYW5rcywNClNoaWp1DQoNCj4NCj5UaHguDQo+DQo+LS0NCj5SZWdh
cmRzL0dydXNzLA0KPiAgICBCb3Jpcy4NCj4NCj5odHRwczovL3Blb3BsZS5rZXJuZWwub3JnL3Rn
bHgvbm90ZXMtYWJvdXQtbmV0aXF1ZXR0ZQ0KDQo=

