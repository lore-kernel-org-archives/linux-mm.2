Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E47C2CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BEB86B0024; Mon, 24 Nov 2025 05:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496516B0026; Mon, 24 Nov 2025 05:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AC4F6B0027; Mon, 24 Nov 2025 05:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 297BF6B0024
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:00:19 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E34F012FDFC
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:00:18 +0000 (UTC)
X-FDA: 84145055316.30.A5533B3
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id CC8E11C0006
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:00:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763978416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bwk8PA2yKVbF2g//UG4+ZcDnvf9i2Q2+xtDKUf5v46M=;
	b=DlC+QLkg60pcgQU1vZxr2PyGRgt+AX3acLxXMO0Dz2HaCq6lo6E9jg40zONKVRh1NPjwVo
	yBkAsKkNv+cJCOhPT6gsPmCyon8Mm8SjhxjRVdugR5l1RayVTWfV1VzSqj64u/9MRDCl5R
	QdC9FAhE6IXLKIwEs9pndWEus7cnTow=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763978416; a=rsa-sha256;
	cv=none;
	b=3asbqFSVtcpTHpiFTYIwEYYAS/kjYfHRCWJCpmnBnS0+PFOvFV6dyOGsCZt3CQd+hmqX3y
	/MM99Os+PA5LoGPyoW0S0Rleaa3rbZhKimoRLJeYU6KnnC3WhULwOXrIg3PqmbQ9GRo7xt
	bIOt+TzZRuqX/u0AaYiNRUfrortkM14=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dFLrl6KdFzJ46dd;
	Mon, 24 Nov 2025 17:59:19 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id A89871400D3;
	Mon, 24 Nov 2025 18:00:11 +0800 (CST)
Received: from dubpeml100008.china.huawei.com (7.214.145.227) by
 dubpeml500005.china.huawei.com (7.214.145.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 24 Nov 2025 10:00:11 +0000
Received: from dubpeml100008.china.huawei.com ([7.214.145.227]) by
 dubpeml100008.china.huawei.com ([7.214.145.227]) with mapi id 15.02.1544.036;
 Mon, 24 Nov 2025 10:00:11 +0000
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
Thread-Index: AQHcWxSpDw4Z/LYIh0qhRo3faUcQr7T+KfGAgANpz1A=
Date: Mon, 24 Nov 2025 10:00:11 +0000
Message-ID: <78ee1bf7cfe34909bf09b429e81e63a7@huawei.com>
References: <20251121182825.237-1-shiju.jose@huawei.com>
 <20251121182825.237-3-shiju.jose@huawei.com>
 <26083ba9-1979-4d14-8465-3f54f2f96d23@infradead.org>
In-Reply-To: <26083ba9-1979-4d14-8465-3f54f2f96d23@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.195.247.74]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CC8E11C0006
X-Stat-Signature: s9dkop933u4pj7xmge1gziprm4fbn81r
X-Rspam-User: 
X-HE-Tag: 1763978415-203403
X-HE-Meta: U2FsdGVkX1+c0FmFybupz58ahQ0/c4hdgDkoHR7mbwhaigucq6gGEnd/kvyPb5h+s1PKw7HMfg8uzmqnBrT46YQ2q+iie4K5eR1gdwAM7NrJyoh17/TpR1B9sKyWy3f1ji3Icok5aKY/rezWiW8fHH/F2jApzifaeJd9ORJv7W3IOjyVoNyDMH0AG+PBuEjA1TVEN+vGtZ36DGOC7/zamyPmRwZDRL+TY3i/11FDfu5OISSYRY1gSOx646lyba9XfDpT4+BRM/K+o8BkZuT/ZlcLNhr/kQerD4IAHI+/nEyduLH8hjw4hsJNf3HCyX1k/MQdqPXR09iZWG6OEcOjFmD3trtvXW55Wx6UQwtEmybamta4emt19VRoPiTyHdov/bAfBOX1cg5Ivkw6Uzw1zK8zXVowqh4nmI24dXr03kGl4BISs9/iihZ/AzCIG+ig4CcwaNZP9zrVBdvbvlfzgdL12OEUnRu806l5DqFukIAdDKuq8DXHnuIbQ0GOLUW+O0M62wYuQNMGyjtR70RcxAH0gbNWQn9FJDd302lbq7rcknEP0ScJbHYpfE3zUQjwk5zM4saanSKduDklaNYJXlI8803ahp/tz4ToMzsZaoaJ6TXS9f5ZvL1WAKzbcdVuZDmAnB4Zppa/9EuGmG6nHmBiM1WlXMnjcCXvl1cJ7++av7ZRgNJHLDAZtz++vV6wd2zu4auXeRt9yLKpxONztGJ2ZCRe52fEmL1TzjSJeonKuxj5NrURjR/5Hr5eXII6q5GDWX0yYEIa3+OktDFGL6ZfiVXVtL2b67Amv/YV4IiQ7JqW84i1UmryjEUBqj7W0g20D94KGs+TWl6IULqtMfsovrOh6KOCq693yGeUOhz8yRFYMqL+jEpC6RM53WEtQFYI15HOUcLDOssKGJkpmWxwePZmSqIcrnqsE3XQgdHGqppa4/pqY8O5Xiv2O20erulZKm88gvQzkxGYXUB
 3Xi8Zd2n
 tLlitLG0w8l5m4Xp31j+52Il3FS6NsfcIdYBIT1rNlnjHRdbgNGWpm8r53B0leo8TAyKMvmVMRsI8wDTAzgdEmINtWIWe+N+dDK7ZRopb9PH8jvVDSGUu+aotFSLPb2hE+F5GxY3FaG6QLgmFkGj0c8TXwPgFhpCsDLuEyOdQ6fVk3QjGiSGIx5d9kBI5VPNaNyxuBVEFacrMJHTsQpNgNPzxU2kMbOp0BhtXTxONfyyR8lF3Ux2/cX3Wr/PJotMjSDf0kRgXuDG5TcVxIeg2fHJNzzSkIwRqnVdZywi3B7JqJb59pnnl9gWvxypwTPviH1gf51iOg8Sh+368hdONDi1ZSlJvQBs5eGPC8Aws8vmi876u7c729Tv32tVuK91shHdGO+dnhbspeXKGvHgYsz4miOlO0mOk3vWovqJ6QL1DXWdGclLu8RT984puqjiTTmu2+xWU5vwosHbc+/PsaXRIIWpSXO63NDlm0XPXUBCzaQzBz0l6/3pM0fnlM37rKpkHPJMQfZU/FvBgN1eh638Xqv2qHkJ1XJ+inl6PxI6ps5L/iToquTa6HMD7gIBDzud65tn31u31KTus2s99Sh/iceOjozJH9ivjMkDFboeA84SBSYbiqbY4/4zWdpxUEdB8u4hc8zLZAtoMpeRmC2vWvKjmDiBa9dqpeI4kKCvssotA2l4fGviNJc42VWa6GH2p2VREqN9BhA0Eu6jnAYmYajApCc7ynNw5hLa9qKdIF5sGc4ixmyDApe2ISFa9bUevt3JiIVj8BDTKdYzshi//HwBPWAOt11rPOaRN12IkbWlhvrHPepI9OI1XLvxXXI4mjfJTRb5ibJmdYxRy7hEflHHFSy4UYrdIYdwo+LHY+MAsy8AkjMRvqeyrDY+C5WmRZhyhOdPNVYxidc7V2G+OcnRmCs4slmuUnHjupDqdxvWb7xp2Wz66P/SnSEoaqGcvFBjTQQD4zOb6XdTb0+Wqkfc1
 ai71XHJD
 8f6WLIPc8A3NrsaBZsczuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IFJhbmR5IER1bmxhcCA8cmR1
bmxhcEBpbmZyYWRlYWQub3JnPg0KPlNlbnQ6IDIyIE5vdmVtYmVyIDIwMjUgMDU6MjMNCj5Ubzog
U2hpanUgSm9zZSA8c2hpanUuam9zZUBodWF3ZWkuY29tPjsgcmFmYWVsQGtlcm5lbC5vcmc7IGJw
QGFsaWVuOC5kZTsNCj5ha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnOyBycHB0QGtlcm5lbC5vcmc7
DQo+ZGZlcmd1c29uQGFtcGVyZWNvbXB1dGluZy5jb207IGxpbnV4LWVkYWNAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC0NCj5hY3BpQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3JnOyBs
aW51eC1kb2NAdmdlci5rZXJuZWwub3JnOw0KPnRvbnkubHVja0BpbnRlbC5jb207IGxlbmJAa2Vy
bmVsLm9yZzsgbGVvLmR1cmFuQGFtZC5jb207DQo+WWF6ZW4uR2hhbm5hbUBhbWQuY29tOyBtY2hl
aGFiQGtlcm5lbC5vcmcNCj5DYzogSm9uYXRoYW4gQ2FtZXJvbiA8am9uYXRoYW4uY2FtZXJvbkBo
dWF3ZWkuY29tPjsgTGludXhhcm0NCj48bGludXhhcm1AaHVhd2VpLmNvbT47IHJpZW50amVzQGdv
b2dsZS5jb207IGppYXFpeWFuQGdvb2dsZS5jb207DQo+Sm9uLkdyaW1tQGFtZC5jb207IGRhdmUu
aGFuc2VuQGxpbnV4LmludGVsLmNvbTsNCj5uYW95YS5ob3JpZ3VjaGlAbmVjLmNvbTsgamFtZXMu
bW9yc2VAYXJtLmNvbTsganRob3VnaHRvbkBnb29nbGUuY29tOw0KPnNvbWFzdW5kYXJhbS5hQGhw
ZS5jb207IGVyZGVtYWt0YXNAZ29vZ2xlLmNvbTsgcGdvbmRhQGdvb2dsZS5jb207DQo+ZHVlbndl
bkBnb29nbGUuY29tOyBndGhlbGVuQGdvb2dsZS5jb207DQo+d3NjaHdhcnR6QGFtcGVyZWNvbXB1
dGluZy5jb207IHdic0Bvcy5hbXBlcmVjb21wdXRpbmcuY29tOw0KPm5pZmFuLmN4bEBnbWFpbC5j
b207IHRhbnhpYW9mZWkgPHRhbnhpYW9mZWlAaHVhd2VpLmNvbT47IFplbmd0YW8gKEIpDQo+PHBy
aW1lLnplbmdAaGlzaWxpY29uLmNvbT47IFJvYmVydG8gU2Fzc3UgPHJvYmVydG8uc2Fzc3VAaHVh
d2VpLmNvbT47DQo+a2FuZ2thbmcuc2hlbkBmdXR1cmV3ZWkuY29tOyB3YW5naHVpcWlhbmcgPHdh
bmdodWlxaWFuZ0BodWF3ZWkuY29tPg0KPlN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEzIDIvMl0gcmFz
OiBtZW06IEFkZCBBQ1BJIFJBUzIgbWVtb3J5IGRyaXZlcg0KPg0KPg0KPg0KPk9uIDExLzIxLzI1
IDEwOjI4IEFNLCBzaGlqdS5qb3NlQGh1YXdlaS5jb20gd3JvdGU6DQo+PiBkaWZmIC0tZ2l0IGEv
RG9jdW1lbnRhdGlvbi9lZGFjL3NjcnViLnJzdA0KPj4gYi9Eb2N1bWVudGF0aW9uL2VkYWMvc2Ny
dWIucnN0IGluZGV4IDJjZmE3NGZhMWZmZC4uNzM3YTEwZGEyMjRmIDEwMDY0NA0KPj4gLS0tIGEv
RG9jdW1lbnRhdGlvbi9lZGFjL3NjcnViLnJzdA0KPj4gKysrIGIvRG9jdW1lbnRhdGlvbi9lZGFj
L3NjcnViLnJzdA0KPj4gQEAgLTM0MCwzICszNDAsNjEgQEAgY29udHJvbGxlciBvciBwbGF0Zm9y
bSB3aGVuIHVuZXhwZWN0ZWRseSBoaWdoIGVycm9yDQo+cmF0ZXMgYXJlIGRldGVjdGVkLg0KPj4N
Cj4+ICBTeXNmcyBmaWxlcyBmb3Igc2NydWJiaW5nIGFyZSBkb2N1bWVudGVkIGluDQo+PiBgRG9j
dW1lbnRhdGlvbi9BQkkvdGVzdGluZy9zeXNmcy1lZGFjLWVjc2ANCj4+ICsNCj4+ICszLiBBQ1BJ
IFJBUzIgSGFyZHdhcmUtYmFzZWQgTWVtb3J5IFNjcnViYmluZw0KPj4gKw0KPj4gKzMuMS4gT24g
ZGVtYW5kIHNjcnViYmluZyBmb3IgYSBzcGVjaWZpYyBtZW1vcnkgcmVnaW9uLg0KPj4gKw0KPj4g
KzMuMS4xLiBRdWVyeSB0aGUgc3RhdHVzIG9mIGRlbWFuZCBzY3J1YmJpbmcNCj4+ICsNCj4+ICsj
IGNhdCAvc3lzL2J1cy9lZGFjL2RldmljZXMvYWNwaV9yYXNfbWVtMC9zY3J1YjAvZW5hYmxlX2Rl
bWFuZA0KPj4gKw0KPj4gKzANCj4+ICsNCj4+ICszLjEuMi4gUXVlcnkgd2hhdCBpcyBkZXZpY2Ug
ZGVmYXVsdC9jdXJyZW50IHNjcnViIGN5Y2xlIHNldHRpbmcuDQo+PiArDQo+PiArQXBwbGljYWJs
ZSB0byBib3RoIGRlbWFuZCBhbmQgYmFja2dyb3VuZCBzY3J1YmJpbmcuDQo+PiArDQo+PiArIyBj
YXQNCj4+ICsvc3lzL2J1cy9lZGFjL2RldmljZXMvYWNwaV9yYXNfbWVtMC9zY3J1YjAvY3VycmVu
dF9jeWNsZV9kdXJhdGlvbg0KPj4gKw0KPj4gKzM2MDAwDQo+PiArDQo+DQo+V2hhdCB1bml0cyAo
YWJvdmUpPw0KSW4gc2Vjb25kcy4NCg0KPg0KPj4gKzMuMS4zLiBRdWVyeSB0aGUgcmFuZ2Ugb2Yg
ZGV2aWNlIHN1cHBvcnRlZCBzY3J1YiBjeWNsZSBmb3IgYSBtZW1vcnkgcmVnaW9uLg0KPj4gKw0K
Pj4gKyMgY2F0IC9zeXMvYnVzL2VkYWMvZGV2aWNlcy9hY3BpX3Jhc19tZW0wL3NjcnViMC9taW5f
Y3ljbGVfZHVyYXRpb24NCj4+ICsNCj4+ICszNjAwDQo+PiArDQo+PiArIyBjYXQgL3N5cy9idXMv
ZWRhYy9kZXZpY2VzL2FjcGlfcmFzX21lbTAvc2NydWIwL21heF9jeWNsZV9kdXJhdGlvbg0KPj4g
Kw0KPj4gKzg2NDAwDQo+PiArDQo+DQo+ZGl0dG8uDQpVbml0IC0gIFNlY29uZHMuDQo+DQo+PiAr
My4xLjQuIFByb2dyYW0gc2NydWJiaW5nIGZvciB0aGUgbWVtb3J5IHJlZ2lvbiBpbiBSQVMyIGRl
dmljZSB0bw0KPj4gK3JlcGVhdCBldmVyeQ0KPj4gKzQzMjAwIHNlY29uZHMgKGhhbGYgYSBkYXkp
Lg0KPj4gKw0KPj4gKyMgZWNobyA0MzIwMCA+DQo+PiArL3N5cy9idXMvZWRhYy9kZXZpY2VzL2Fj
cGlfcmFzX21lbTAvc2NydWIwL2N1cnJlbnRfY3ljbGVfZHVyYXRpb24NCj4+ICsNCj4+ICszLjEu
NS4gU3RhcnQgJ2RlbWFuZCBzY3J1YmJpbmcnLg0KPj4gKw0KPj4gK1doZW4gYSBkZW1hbmQgc2Ny
dWIgaXMgc3RhcnRlZCwgYW55IGJhY2tncm91bmQgc2NydWIgY3VycmVudGx5IGluDQo+PiArcHJv
Z3Jlc3Mgd2lsbCBiZSBzdG9wcGVkIGFuZCB0aGVuIGF1dG9tYXRpY2FsbHkgcmVzdGFydGVkIG9u
Y2UgdGhlDQo+PiArZGVtYW5kIHNjcnViIGhhcyBjb21wbGV0ZWQuDQo+DQo+V2lsbCBpdCByZXN0
YXJ0IHdoZXJlIGl0IGxlZnQgb2ZmIG9yIGF0IHRoZSBiZWdpbm5pbmc/DQpJbiB0aGlzIGNhc2Us
IHByZXNlbnRseSBrZXJuZWwgc2VuZCAnU1RBUlRfUEFUUk9MX1NDUlVCQkVSICcgY29tbWFuZCAg
dG8gcmVzdGFydA0KdGhlIGJhY2tncm91bmQgc2NydWJiaW5nIGFuZCB0aHVzIHJlc3RhcnRzIGF0
IHRoZSBiZWdpbm5pbmcgdW5sZXNzIEkgdGhpbmsgZmlybXdhcmUNCmhhcyBzb21lIGltcGxlbWVu
dGF0aW9uIHRvIGRldGVjdCB0aGlzIGNhc2UgYW5kICAncmVzdW1lJyBiYWNrZ3JvdW5kIHNjcnVi
YmluZw0Kd2hlcmUgaXQgaGFzIHN0b3BwZWQuIE90aGVyd2lzZSBJIHRoaW5rIFJBUzIgbWF5IGRl
ZmluZSBzb21lIG5ldyBjb21tYW5kcyB0bw0KJ3BhdXNlJyBhbmQgJ3Jlc3VtZScgc2NydWJiaW5n
IGlmIHRoYXQgbWFrZSBzZW5zZSBzbyB0aGF0IGtlcm5lbCBjb3VsZCBzZW5kIHRob3NlDQpjb21t
YW5kcyB0byB0aGUgZmlybXdhcmUgZm9yIHRoaXMgY2FzZS4NCj4NCj4+ICsNCj4+ICsjIGVjaG8g
MSA+IC9zeXMvYnVzL2VkYWMvZGV2aWNlcy9hY3BpX3Jhc19tZW0wL3NjcnViMC9lbmFibGVfZGVt
YW5kDQo+PiArDQo+PiArMy4yLiBCYWNrZ3JvdW5kIHNjcnViYmluZyB0aGUgZW50aXJlIG1lbW9y
eQ0KPj4gKw0KPj4gKzMuMi4xLiBRdWVyeSB0aGUgc3RhdHVzIG9mIGJhY2tncm91bmQgc2NydWJi
aW5nLg0KPj4gKw0KPj4gKyMgY2F0IC9zeXMvYnVzL2VkYWMvZGV2aWNlcy9hY3BpX3Jhc19tZW0w
L3NjcnViMC9lbmFibGVfYmFja2dyb3VuZA0KPj4gKw0KPj4gKzANCj4+ICsNCj4+ICszLjIuMi4g
UHJvZ3JhbSBiYWNrZ3JvdW5kIHNjcnViYmluZyBmb3IgUkFTMiBkZXZpY2UgdG8gcmVwZWF0IGlu
DQo+PiArZXZlcnkgMjE2MDAgc2Vjb25kcyAocXVhcnRlciBvZiBhIGRheSkuDQo+PiArDQo+PiAr
IyBlY2hvIDIxNjAwID4NCj4+ICsvc3lzL2J1cy9lZGFjL2RldmljZXMvYWNwaV9yYXNfbWVtMC9z
Y3J1YjAvY3VycmVudF9jeWNsZV9kdXJhdGlvbg0KPj4gKw0KPj4gKzMuMi4zLiBTdGFydCAnYmFj
a2dyb3VuZCBzY3J1YmJpbmcnLg0KPj4gKw0KPj4gKyMgZWNobyAxID4NCj4+ICsvc3lzL2J1cy9l
ZGFjL2RldmljZXMvYWNwaV9yYXNfbWVtMC9zY3J1YjAvZW5hYmxlX2JhY2tncm91bmQNCj4NCj4t
LQ0KPn5SYW5keQ0KDQpUaGFua3MsDQpTaGlqdQ0KDQo=

