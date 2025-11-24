Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E398CFD31D
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 09:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F466B0026; Mon, 24 Nov 2025 04:30:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE69E6B0027; Mon, 24 Nov 2025 04:30:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD54B6B0028; Mon, 24 Nov 2025 04:30:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B166F6B0026
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 04:30:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF246B7F98
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:29:57 +0000 (UTC)
X-FDA: 84144978834.19.F79CF6A
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1EDB02000A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:29:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763976595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WIEzxFEC/PnkxmuAIhUbJI67YAunydQmi9QG1iFd0E4=;
	b=Aw/epDZ4y+SDyVABL0a4L4oJ7aXfVZuMspnlYyDnLeuVO+dfbcMCkIEonRDRVIj42eCgaz
	4MRSqXRUS/fmz8Tl9HCusJmO7EPhPoEkvoMocmmiJiNZ39YuQq2MbMtqZkVwDwHMImnhu1
	zrbUzz5yz8ibmROtFF7JfwWM6wZKkEk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763976595; a=rsa-sha256;
	cv=none;
	b=ttIdZoNre6SBKwOTkNdlBxLZBh6CiViyM7jZr+QCj1yasQsmz8aXUOSyfWDOa/R9oHESgb
	ngvy3Ixpsivba3/mPqy6PkD4Ajy3hiLJEtoCnEldst5vWjbJS+4IjnPwjFy88eamgmC1Dq
	c5N5FwV14xRDNujUeHXmzu2pEJoBMgw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dFL9j2N5PzJ46lR;
	Mon, 24 Nov 2025 17:28:57 +0800 (CST)
Received: from dubpeml500006.china.huawei.com (unknown [7.214.146.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 1BE031400D3;
	Mon, 24 Nov 2025 17:29:49 +0800 (CST)
Received: from dubpeml100008.china.huawei.com (7.214.145.227) by
 dubpeml500006.china.huawei.com (7.214.146.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 24 Nov 2025 09:29:48 +0000
Received: from dubpeml100008.china.huawei.com ([7.214.145.227]) by
 dubpeml100008.china.huawei.com ([7.214.145.227]) with mapi id 15.02.1544.036;
 Mon, 24 Nov 2025 09:29:48 +0000
From: Shiju Jose <shiju.jose@huawei.com>
To: Randy Dunlap <rdunlap@infradead.org>, "rafael@kernel.org"
	<rafael@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "rppt@kernel.org"
	<rppt@kernel.org>, "dferguson@amperecomputing.com"
	<dferguson@amperecomputing.com>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"tony.luck@intel.com" <tony.luck@intel.com>, "lenb@kernel.org"
	<lenb@kernel.org>, "leo.duran@amd.com" <leo.duran@amd.com>,
	"Yazen.Ghannam@amd.com" <Yazen.Ghannam@amd.com>, "mchehab@kernel.org"
	<mchehab@kernel.org>
CC: Jonathan Cameron <jonathan.cameron@huawei.com>, Linuxarm
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
Subject: RE: [PATCH v13 2/2] ras: mem: Add ACPI RAS2 memory driver
Thread-Topic: [PATCH v13 2/2] ras: mem: Add ACPI RAS2 memory driver
Thread-Index: AQHcWxSpDw4Z/LYIh0qhRo3faUcQr7T+KJmAgANquEA=
Date: Mon, 24 Nov 2025 09:29:48 +0000
Message-ID: <9165f50de6fa43edba7a3e6d99eebe8b@huawei.com>
References: <20251121182825.237-1-shiju.jose@huawei.com>
 <20251121182825.237-3-shiju.jose@huawei.com>
 <af7b6cdc-c0a7-4896-ba6b-6bb933898d37@infradead.org>
In-Reply-To: <af7b6cdc-c0a7-4896-ba6b-6bb933898d37@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.195.247.74]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Stat-Signature: 66eyaut8b6k4upr3rteaiqxpw4t6tm5h
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EDB02000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1763976594-391824
X-HE-Meta: U2FsdGVkX1+1mtqvetfvf9fbPTcndWys/yBc7eRkyyx8XoWjPrHEUJmW/2oNYSqIc42BjGac4989piEAVvhAXxtqSyWm+4wwQgdJXKc0Ic04fQaHAmY9iudnHcV90/3AQTkLtrLlpfzvTv9Unqxhc4yZsQSWDuY3VZ3QG65BsM7NEpm4TfIn/6UwOkcsShAvEpZZ/7aqjSpNNxIaliBTeH6XPx5EF9/qRpMj1a0vpMiONPxHehSm7mANTMIz4Co95AokawD6eKeKJhNayWguOvDiTw3QQRJfQCTRnGbeBVWpbNYpcNYLL7uPe/Qx5Bf9qFXZ88N4rM8ftDnM/0rpThmYPxEXmMvApvrvWfUF7hsLJQ+fiRuL5Lo1djxNnT0tbLNztOpZH7NEibDwT488+9Mze1oyhVRNbCfFsOAvj1ZhiXfzoKTJR02CWD0WiFKSU5eYtWbMgRXHgg9OGwvaAKDNPOY1nBYyfYXQBlu2+fwQx9KALsiDjRD+461OG4kMWOxVHjCQLa2L88t3sjBA2uZ+EdJOGFhUBeNq/y/OuJyKP2rUqUUHt5aWyhzyYilQLm6+yX4VKXJYIbhW2sbH8XGr/hUb7lsoa8JMivPA7u6rYHjbKuSz/Q3J8dbhjf49PwdjBDVpXJOiBTZ+ogqONsLrzq24G42iAoRExuYS/+RbFqaJbqZsspLlTuRGNDK4s4ZXP9KmztEOtVfgoFz5UninarRi7QMqra8SqDMrvr2cMVyNXsrIzMxGcnwVabQJaXd16JbvX4yMdTUXWB14j7cSTnleVhSoZ4imIhlyuvjZIQDHR+hps71kgA4dlaoeqvLee3o9xjCYHZ18Bl5HZO1zPlxbe2knLoC3UkMtAhCX1alMxbqtaaLGNfyUxjoYG/ugt8FZCq/t2QG9iu8bg0Dz1rmAjjTMxMbqE+EnujtxNbYnCgF8SQKP8X8B04hZCqCNVExD46cRFxDsd2Z
 7oQ8YZ+n
 gE1KAcU1nPl/OpXEyBXYXu61DoonZl57sgnXnuvS+H+4SsZY01vyNnUm1tr1+oojqlnhc1tqwr4aw2c8BqFCAlfnXpSX/xlUdJEa4f4sgPaMHjBIn8SnUas3KmBKfB+XJuHTENj7Ds42GyGdO0ucpIwT0Os58mzQ7eBim4KyNdFlg1kCM+57mmW7NnMXceI+e0mGa90F0kcP5l0JrqkvWXtpBzl73pKaRO9rM5w2+IHo/3OmYVr6pv2vYsFaaSutOBCLTLcFjFlb/Yux0NXB3d5JjfRzDxQBfXSnBeCozZ5qURlGWBHJ5w6184WJQfO7J/ZgVsEfnK946SU8rES/lIXtUvovsOLEOI6hBnZ4dwcmQXcNMQxgi3t2W+Wt9gWE14jEWF9d2gqFHBejeEV4pRJxEUrE8DBzwjl6GdMsMgADErAjAh5TmmieZ7uvrFj7LsAA2hTpsrzL3R3EBmaxyEHsddyHLV3ZlJ6SPw05MiuQlMweQ9w8UYi9jZzmU8aTQ6ezw7ECQ7vyFL9JQqy+cbOMvjdyAFpjjY6bVShrluRWAtGqrNqjf4mN2uCyqARImSWfeqaFBuq00oCOzjKO2FmzmXzDHjLxd/PnS8uOw0mbcxXh5mbIryhjTRtJDZZRVsMar+TMsVsGQx178JmtpdOUxqUF+gdsGFYaWaIxsav1Pl8Ez/aXnG4ThM87CzawIjqTced5qoSEDVhcBAIsfF9fb+aYLtZPptfFiLhnPATFnm3uP0ueoF1q0kNuoGyU74q8s9OrPslYBb3VwvDMyCWZiSd0qSEKOiCVYUmGVAnN379ySAAKfgac+b38hmkAswAYoyNkMxUmuG4/Wgk6lLc+0Y8xcHf+b0OqEzlq8tV/i/ra9cI+ZLUJOXRyGBGzOvHVYXZVfj97K/8ytkQt3s58o9DPSfNaCLZ3ZCSEbP7RCuw02Y6ZwIl2AIfx3KC4c3AwIwNzxZgjBl7pwxLWzHQD1gKon
 ZneT70Gm
 UMG3F0ZixFXyBT8Bvpf2sg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQo+LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj5Gcm9tOiBSYW5keSBEdW5sYXAgPHJkdW5s
YXBAaW5mcmFkZWFkLm9yZz4NCj5TZW50OiAyMiBOb3ZlbWJlciAyMDI1IDA1OjE4DQo+VG86IFNo
aWp1IEpvc2UgPHNoaWp1Lmpvc2VAaHVhd2VpLmNvbT47IHJhZmFlbEBrZXJuZWwub3JnOyBicEBh
bGllbjguZGU7DQo+YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsgcnBwdEBrZXJuZWwub3JnOw0K
PmRmZXJndXNvbkBhbXBlcmVjb21wdXRpbmcuY29tOyBsaW51eC1lZGFjQHZnZXIua2VybmVsLm9y
ZzsgbGludXgtDQo+YWNwaUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsgbGlu
dXgtZG9jQHZnZXIua2VybmVsLm9yZzsNCj50b255Lmx1Y2tAaW50ZWwuY29tOyBsZW5iQGtlcm5l
bC5vcmc7IGxlby5kdXJhbkBhbWQuY29tOw0KPllhemVuLkdoYW5uYW1AYW1kLmNvbTsgbWNoZWhh
YkBrZXJuZWwub3JnDQo+Q2M6IEpvbmF0aGFuIENhbWVyb24gPGpvbmF0aGFuLmNhbWVyb25AaHVh
d2VpLmNvbT47IExpbnV4YXJtDQo+PGxpbnV4YXJtQGh1YXdlaS5jb20+OyByaWVudGplc0Bnb29n
bGUuY29tOyBqaWFxaXlhbkBnb29nbGUuY29tOw0KPkpvbi5HcmltbUBhbWQuY29tOyBkYXZlLmhh
bnNlbkBsaW51eC5pbnRlbC5jb207DQo+bmFveWEuaG9yaWd1Y2hpQG5lYy5jb207IGphbWVzLm1v
cnNlQGFybS5jb207IGp0aG91Z2h0b25AZ29vZ2xlLmNvbTsNCj5zb21hc3VuZGFyYW0uYUBocGUu
Y29tOyBlcmRlbWFrdGFzQGdvb2dsZS5jb207IHBnb25kYUBnb29nbGUuY29tOw0KPmR1ZW53ZW5A
Z29vZ2xlLmNvbTsgZ3RoZWxlbkBnb29nbGUuY29tOw0KPndzY2h3YXJ0ekBhbXBlcmVjb21wdXRp
bmcuY29tOyB3YnNAb3MuYW1wZXJlY29tcHV0aW5nLmNvbTsNCj5uaWZhbi5jeGxAZ21haWwuY29t
OyB0YW54aWFvZmVpIDx0YW54aWFvZmVpQGh1YXdlaS5jb20+OyBaZW5ndGFvIChCKQ0KPjxwcmlt
ZS56ZW5nQGhpc2lsaWNvbi5jb20+OyBSb2JlcnRvIFNhc3N1IDxyb2JlcnRvLnNhc3N1QGh1YXdl
aS5jb20+Ow0KPmthbmdrYW5nLnNoZW5AZnV0dXJld2VpLmNvbTsgd2FuZ2h1aXFpYW5nIDx3YW5n
aHVpcWlhbmdAaHVhd2VpLmNvbT4NCj5TdWJqZWN0OiBSZTogW1BBVENIIHYxMyAyLzJdIHJhczog
bWVtOiBBZGQgQUNQSSBSQVMyIG1lbW9yeSBkcml2ZXINCj4NCj4NCj4NCj5PbiAxMS8yMS8yNSAx
MDoyOCBBTSwgc2hpanUuam9zZUBodWF3ZWkuY29tIHdyb3RlOg0KPj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvcmFzL0tjb25maWcgYi9kcml2ZXJzL3Jhcy9LY29uZmlnDQo+PiBpbmRleCBmYzRmNGJi
OTRhNGMuLjdlN2FmZDJiMmJhNyAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvcmFzL0tjb25maWcN
Cj4+ICsrKyBiL2RyaXZlcnMvcmFzL0tjb25maWcNCj4+IEBAIC00Niw0ICs0NiwxNiBAQCBjb25m
aWcgUkFTX0ZNUE0NCj4+ICAJICBNZW1vcnkgd2lsbCBiZSByZXRpcmVkIGR1cmluZyBib290IHRp
bWUgYW5kIHJ1biB0aW1lIGRlcGVuZGluZyBvbg0KPj4gIAkgIHBsYXRmb3JtLXNwZWNpZmljIHBv
bGljaWVzLg0KPj4NCj4+ICtjb25maWcgTUVNX0FDUElfUkFTMg0KPj4gKwl0cmlzdGF0ZSAiTWVt
b3J5IEFDUEkgUkFTMiBkcml2ZXIiDQo+PiArCWRlcGVuZHMgb24gQUNQSV9SQVMyDQo+PiArCWRl
cGVuZHMgb24gRURBQw0KPj4gKwlkZXBlbmRzIG9uIEVEQUNfU0NSVUINCj4+ICsJaGVscA0KPj4g
KwkgIFRoZSBkcml2ZXIgYmluZHMgdG8gdGhlIGF1eGlsaWFyeSBkZXZpY2UgYWRkZWQgYnkgdGhl
IEFDUEkgUkFTMg0KPj4gKwkgIGZlYXR1cmUgdGFibGUgcGFyc2VyLiBUaGUgZHJpdmVyIHVzZXMg
YSBQQ0MgY2hhbm5lbCBzdWJzcGFjZSB0bw0KPj4gKwkgIGNvbW11bmljYXRpbmcgd2l0aCB0aGUg
QUNQSS1jb21wbGlhbnQgcGxhdGZvcm0gYW5kIHByb3ZpZGVzDQo+DQo+CSAgY29tbXVuaWNhdGUg
d2l0aA0KVGhhbmtzIFJhbmR5IGZvciByZXZpZXdpbmcuIEkgd2lsbCBmaXguDQoNCj4NCj4+ICsJ
ICBjb250cm9sIG9mIHRoZSBIVy1iYXNlZCBtZW1vcnkgc2NydWJiZXIgcGFyYW1ldGVycyB0byB0
aGUgdXNlcg0KPj4gKwkgIHRocm91Z2ggdGhlIEVEQUMgc2NydWIgaW50ZXJmYWNlLg0KPg0KPi0t
DQo+flJhbmR5DQo+DQoNClRoYW5rcywNClNoaWp1DQo=

