Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF12C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 17:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 490A66B008A; Fri,  1 Aug 2025 13:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A846B008C; Fri,  1 Aug 2025 13:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302F56B0092; Fri,  1 Aug 2025 13:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1CC846B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 13:33:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C04B21A0298
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:33:07 +0000 (UTC)
X-FDA: 83728884414.21.2908340
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4440912000C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:33:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754069585; a=rsa-sha256;
	cv=none;
	b=Kb3pHDLRY/lcaDmwzPaUJhFez/NdLLsa+JV1GYCoSl3Icl6h93c1xhhQOK4n96OUbqNumm
	st3SxW1DEfZh9eu+39tUV8IRfQ34f9+UeFgumjjN6AVTifdw2CrijcbO77fqEsayROMEQk
	gDxy/i/gE37YPS5oA18FKhIwiC+nofA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754069585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S/6oJy7AwWjk5WWn/SdrcVe0148J1pYjzgLA1lyfg0I=;
	b=jrTGCVkTStCIHXofXLIJVRwfPa/aM9EnNz505ptVoIHhuLqxQnOFUl1sGg4YGoLSbgUz3n
	W/F8rkRTpNATAE0yBVyoGlVhhWyHzuXqZe/9TN71LFxb0LKTxbnP5JZhC1YlOxo5tIT4Eh
	gOXMvFcx1o3Yp+/l4C0Ae2SkKMWn4xw=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bttGK4H7pz6L4t9;
	Sat,  2 Aug 2025 01:28:41 +0800 (CST)
Received: from frapeml500006.china.huawei.com (unknown [7.182.85.219])
	by mail.maildlp.com (Postfix) with ESMTPS id B99701402EF;
	Sat,  2 Aug 2025 01:33:00 +0800 (CST)
Received: from frapeml500007.china.huawei.com (7.182.85.172) by
 frapeml500006.china.huawei.com (7.182.85.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 1 Aug 2025 19:33:00 +0200
Received: from frapeml500007.china.huawei.com ([7.182.85.172]) by
 frapeml500007.china.huawei.com ([7.182.85.172]) with mapi id 15.01.2507.039;
 Fri, 1 Aug 2025 19:33:00 +0200
From: Shiju Jose <shiju.jose@huawei.com>
To: Shiju Jose <shiju.jose@huawei.com>, Daniel Ferguson
	<danielf@os.amperecomputing.com>, "rafael@kernel.org" <rafael@kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "tony.luck@intel.com" <tony.luck@intel.com>,
	"lenb@kernel.org" <lenb@kernel.org>, "leo.duran@amd.com" <leo.duran@amd.com>,
	"Yazen.Ghannam@amd.com" <Yazen.Ghannam@amd.com>, "mchehab@kernel.org"
	<mchehab@kernel.org>
CC: Jonathan Cameron <jonathan.cameron@huawei.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, Linuxarm <linuxarm@huawei.com>, "rientjes@google.com"
	<rientjes@google.com>, "jiaqiyan@google.com" <jiaqiyan@google.com>,
	"Jon.Grimm@amd.com" <Jon.Grimm@amd.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "naoya.horiguchi@nec.com"
	<naoya.horiguchi@nec.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"jthoughton@google.com" <jthoughton@google.com>, "somasundaram.a@hpe.com"
	<somasundaram.a@hpe.com>, "erdemaktas@google.com" <erdemaktas@google.com>,
	"pgonda@google.com" <pgonda@google.com>, "duenwen@google.com"
	<duenwen@google.com>, "gthelen@google.com" <gthelen@google.com>,
	"wschwartz@amperecomputing.com" <wschwartz@amperecomputing.com>,
	"dferguson@amperecomputing.com" <dferguson@amperecomputing.com>,
	"wbs@os.amperecomputing.com" <wbs@os.amperecomputing.com>,
	"nifan.cxl@gmail.com" <nifan.cxl@gmail.com>, tanxiaofei
	<tanxiaofei@huawei.com>, "Zengtao (B)" <prime.zeng@hisilicon.com>, "Roberto
 Sassu" <roberto.sassu@huawei.com>, "kangkang.shen@futurewei.com"
	<kangkang.shen@futurewei.com>, wanghuiqiang <wanghuiqiang@huawei.com>,
	"vanshikonda@os.amperecomputing.com" <vanshikonda@os.amperecomputing.com>
Subject: RE: [PATCH v9 2/2] ras: mem: Add memory ACPI RAS2 driver
Thread-Topic: [PATCH v9 2/2] ras: mem: Add memory ACPI RAS2 driver
Thread-Index: AQHb36LyCBzLg1T4lUmQbc9HcxtQS7RDI7AAgAYEALCABSzmsA==
Date: Fri, 1 Aug 2025 17:33:00 +0000
Message-ID: <9802cc9c80e745e9a4fffa0685a65f79@huawei.com>
References: <20250617161417.1681-1-shiju.jose@huawei.com>
 <20250617161417.1681-3-shiju.jose@huawei.com>
 <547ed8fb-d6b7-4b6b-a38b-bf13223971b1@os.amperecomputing.com>
 <a1df7aa762954b35bc5fe2b1f6d9ed78@huawei.com>
In-Reply-To: <a1df7aa762954b35bc5fe2b1f6d9ed78@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.195.32.206]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4440912000C
X-Stat-Signature: zb5f87ocwaz37tgzy65z378fe6fns6op
X-HE-Tag: 1754069585-474864
X-HE-Meta: U2FsdGVkX19F4hVUD+CzqVGy9w5AMpbNDZk+sFFjagW8E1U824PwfqsZHxNBWiH5ILITNU+J1a+Hc+KjzxbRi1ESPj1SSeN3hcxO/JnnA8V1qOIjNDf4b0h0U5zZtDx+WrkUe4GoJMvr9gSYz/WzOmCp8oa4GRQp/p5qo0ks3PqkwkSo5dY+07ecZcvtG5AP+UiwKCklqlFakw4s06OzQ9iQ2kktvgq/A4rx9erzoaEP+We7/qgfU7sMyLt5pembCpCMDssCWnfzWQLBOQ4OWVZJzqbWqC4bLP74wKYHyIt8QnNbfmWWmFeLGj7a3iNEbkuhEWo9L8w7k4r5ZqU2Sh5sfsiqzJuz5iw6LjRRpIGeycumMnv+5k/JPWmuLormkCksXSWIoKkh0smSWnMfsle/gYR2rLlG6BE2wBmxZ9PZ+x+j5GU1GH2q19PuRtfnXwDhzNaLSZC7Y8RbUsvuSiD15k7jKGaE7ek38ZHMONZZdKywLReWYHAcRAq0pIB96412TJ45ilI9H6/mhI5sliafcAdfHjoxqdLbcjyRbCVQooESgYXWGSJCFp+zojwV8rTypt9xbl4KyOwA4r750Hq9lPND64QvDJy755Ml9Jphe93vyjC5iiOdgcXqR8k8/yoO4/VqtAzGyshl0MHPQOz4FS/YOUAIAJD4Q0v985Nn9cSBqpcwM0hSoluE9XWCH3DjLBaTCyQwmimflEQzm6k6ZusIwdmkxk1YLQ8U9EWkrDEDDGNAbGzs8HFiKKIpPcUV14I4PED9LbTMCVgcF3r1kK3mXkMkbIUBTaifi7w+yc5TihqAccGWxBMUr5LvkT+DkWrjYvhzHD+V6BpIzOOy9z8tEe1m7WKQ0kp7pMHDtVZnmBBW+gqwfBnj2VmsWdpH5TX9ODRv0Z2YObXAYMUfFsnw0gcP+QzhHAEbIMAb4Vn+VD2RVyz1y2ILHESKei9/9HhTKxHjO1c3eXn
 BfP/mIMa
 hs4UcCrrtL1aw06cWgErrSnaPr4ycbg+V8xRbfo6mXcoOZDTYGXoKbq86SV2BI5Kx8k1GbixxkW2LNVkmBrnUEQR3cD1BR5lGowY893T3S7dGkgc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogU2hpanUgSm9zZSA8c2hpanUuam9z
ZUBodWF3ZWkuY29tPg0KPlNlbnQ6IDAxIEF1Z3VzdCAyMDI1IDE4OjI5DQo+VG86IERhbmllbCBG
ZXJndXNvbiA8ZGFuaWVsZkBvcy5hbXBlcmVjb21wdXRpbmcuY29tPjsgcmFmYWVsQGtlcm5lbC5v
cmc7DQo+bGludXgtZWRhY0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFjcGlAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC0NCj5kb2NAdmdlci5rZXJuZWwub3JnOyBicEBhbGllbjguZGU7IHRvbnkubHVj
a0BpbnRlbC5jb207IGxlbmJAa2VybmVsLm9yZzsNCj5sZW8uZHVyYW5AYW1kLmNvbTsgWWF6ZW4u
R2hhbm5hbUBhbWQuY29tOyBtY2hlaGFiQGtlcm5lbC5vcmcNCj5DYzogSm9uYXRoYW4gQ2FtZXJv
biA8am9uYXRoYW4uY2FtZXJvbkBodWF3ZWkuY29tPjsgbGludXgtDQo+bW1Aa3ZhY2sub3JnOyBM
aW51eGFybSA8bGludXhhcm1AaHVhd2VpLmNvbT47IHJpZW50amVzQGdvb2dsZS5jb207DQo+amlh
cWl5YW5AZ29vZ2xlLmNvbTsgSm9uLkdyaW1tQGFtZC5jb207IGRhdmUuaGFuc2VuQGxpbnV4Lmlu
dGVsLmNvbTsNCj5uYW95YS5ob3JpZ3VjaGlAbmVjLmNvbTsgamFtZXMubW9yc2VAYXJtLmNvbTsg
anRob3VnaHRvbkBnb29nbGUuY29tOw0KPnNvbWFzdW5kYXJhbS5hQGhwZS5jb207IGVyZGVtYWt0
YXNAZ29vZ2xlLmNvbTsgcGdvbmRhQGdvb2dsZS5jb207DQo+ZHVlbndlbkBnb29nbGUuY29tOyBn
dGhlbGVuQGdvb2dsZS5jb207DQo+d3NjaHdhcnR6QGFtcGVyZWNvbXB1dGluZy5jb207IGRmZXJn
dXNvbkBhbXBlcmVjb21wdXRpbmcuY29tOw0KPndic0Bvcy5hbXBlcmVjb21wdXRpbmcuY29tOyBu
aWZhbi5jeGxAZ21haWwuY29tOyB0YW54aWFvZmVpDQo+PHRhbnhpYW9mZWlAaHVhd2VpLmNvbT47
IFplbmd0YW8gKEIpIDxwcmltZS56ZW5nQGhpc2lsaWNvbi5jb20+OyBSb2JlcnRvDQo+U2Fzc3Ug
PHJvYmVydG8uc2Fzc3VAaHVhd2VpLmNvbT47IGthbmdrYW5nLnNoZW5AZnV0dXJld2VpLmNvbTsN
Cj53YW5naHVpcWlhbmcgPHdhbmdodWlxaWFuZ0BodWF3ZWkuY29tPjsNCj52YW5zaGlrb25kYUBv
cy5hbXBlcmVjb21wdXRpbmcuY29tDQo+U3ViamVjdDogUkU6IFtQQVRDSCB2OSAyLzJdIHJhczog
bWVtOiBBZGQgbWVtb3J5IEFDUEkgUkFTMiBkcml2ZXINCj4NCj4+LS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCj4+RnJvbTogRGFuaWVsIEZlcmd1c29uIDxkYW5pZWxmQG9zLmFtcGVyZWNvbXB1
dGluZy5jb20+DQpbLi4uXQ0KPj4zKSBUaGlzIGlzIGEgc3BlY2lhbCBjYXNlIG9mICMyLiBEdXJp
bmcgZHJpdmVyIGxvYWQsIHJhczJfcHJvYmUgaXNzdWVzDQo+PmEgR0VUX1BBVFJPTF9QQVJBTUVU
RVJTIHVzaW5nIGEgYmFzZSBhbmQgc2l6ZSBlcXVhbCB0byAwLiBUaGUgYmFzZSBhbmQNCj4+c2l6
ZSBhcmUgemVybyBiZWNhdXNlIHJlcXVlc3RlZF9hZGRyZXNzX3JhbmdlIGlzIGFsbG9jYXRlZCB3
aXRoDQo+Pmt6YWxsb2MuIEluIHRoaXMgY2FzZSwgd2UgbWF5IG5vdCBiZSBnZXR0aW5nIHRoZSBp
bml0aWFsIHZhbHVlcyBmcm9tIHRoZSBjb3JyZWN0DQo+cmFuZ2UuDQo+SW4gdGhlIHByb2JlIHN0
YWdlLCB3aGlsZSBpc3N1ZSBHRVRfUEFUUk9MX1BBUkFNRVRFUlMsIGRyaXZlciBoYXMgbm8NCj5p
bmZvcm1hdGlvbiBhYm91dCB0aGUgICdyZXF1ZXN0ZWRfYWRkcmVzc19yYW5nZScgc3VwcG9zZWQg
dG8gc2V0IG90aGVyIHRoYW4NCj5zZXQgdG8gMCBiZWNhdXNlDQo+UkFTMiAoJ1JBUzIgUGxhdGZv
cm0gQ29tbXVuaWNhdGlvbiBDaGFubmVsIFNoYXJlZCBNZW1vcnkgUmVnaW9uJyB0YWJsZT8pDQo+
ZG9lcyBub3QgZGVmaW5lIGZpZWxkcyBmb3IgdGhlIHBsYXRmb3JtIHRvIGFkdmVydGlzZSB0aGUg
c3VwcG9ydGVkIGZ1bGwgYWRkcmVzcw0KPnJhbmdlIGZvciBhIHNjcnViYmVyLg0KUGxlYXNlIGln
bm9yZSB0aGlzIGFzIGl0IHdhcyBzb2x2ZWQuDQoNCj4+DQo+PlByb3Bvc2VkIFNvbHV0aW9uOg0K
Pj5XaGF0IHdlIHByb3Bvc2UsIGlzIHRvIGluc3RlYWQgb2YgemVyb2luZyBvdXQgdGhlIGJhc2Ug
YW5kIHNpemUgYWZ0ZXINCj4+YW4gZXJyb3IsIHVzZSB0aGUgZnVsbCByYW5nZSBvZiB0aGUgY3Vy
cmVudCBOVU1BIG5vZGUuIFdlIGJlbGlldmUgdGhhdA0KPj5hIHN1cGVyc2V0IG9mIGEgY3VycmVu
dGx5IGFjdGl2ZSBzY3J1YiByYW5nZSBjYW4gcHJvcGVybHkgcmVwb3J0IGFsbA0KPj50aGUgcmVs
ZXZhbnQgYW5kIGNvcnJlY3QgaW5mb3JtYXRpb24uDQo+PlRvIGJlIGNvbXBsaWFudCB3aXRoIHRo
ZSBzcGVjaWZpY2F0aW9uLCBGVyBzaG91bGQgc2V0ICJGbGFncyIgZmllbGQgaWYNCj4+dGhlcmUg
aXMgYW55IG9uLWRlbWFuZCBzY3J1YiBpbiBwcm9ncmVzcyBvbiBhbnkgbWVtb3J5IHJhbmdlIGlu
IHRoZQ0KPj5OVU1BIG5vZGUuIEFnYWluLCB0aGlzIHNvbHV0aW9uIGFzc3VtZXMgdGhhdCB0aGUg
ZHJpdmVyIGRvZXMgbm90IGFsbG93DQo+Pm1vcmUgdGhhbiBvbmUgc2NydWJiZXIgdG8gcnVuIHdp
dGhpbiBhIHNpbmdsZSBOVU1BIG5vZGUuIEFsbCB0aHJlZQ0KPj5wcm9ibGVtcyBjYW4gYmUgc29s
dmVkIGluIHRoZSBzYW1lIHdheS4NCj4+DQo+PldoYXQgZG8geW91IHRoaW5rPw0KPkhpIERhbmll
bCwNCj4NCj5QbGVhc2UgY2hlY2sgdGhlIHYxMCBvZiB0aGUgUkFTMiBzZXJpZXMgc2VudCB3aXRo
IGNoYW5nZXMgZm9yIHlvdXINCj5yZXF1aXJlbWVudHMuDQo+YW5kIHJlcXVlc3QgcGxlYXNlIHRl
c3QgaW4geW91ciBzeXN0ZW0gYW5kIHNoYXJlIHRoZSBmZWVkYmFjay4NCj4NCj5odHRwczovL2xv
cmUua2VybmVsLm9yZy9hbGwvMjAyNTA4MDExNzIwNDAuMjE3NS0xLXNoaWp1Lmpvc2VAaHVhd2Vp
LmNvbS8NCj4+DQo+PlJlZ2FyZHMsDQo+Pn5EYW5pZWwNCj4NCj5UaGFua3MsDQo+U2hpanUNCg==

