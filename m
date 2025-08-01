Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8063EC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 17:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20FA56B007B; Fri,  1 Aug 2025 13:28:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E76B6B0089; Fri,  1 Aug 2025 13:28:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123FA6B008A; Fri,  1 Aug 2025 13:28:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 031916B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 13:28:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5A53804A2
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:28:55 +0000 (UTC)
X-FDA: 83728873830.14.BFC66ED
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2AF9B40005
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:28:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754069333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nNK+o9lNVo8S1GnlSlbxobKU6Z76gp38twuMxB5gaMo=;
	b=0I30W+ASgMzXJN2guf0AT44eTbOWJhSeC2rkohtN80DUVXCF9zU6r1g/ZiH/pvIc2D+Dnf
	S6kN/d7bqwPfQn8dSCwNI6tGi1EJFwBlty0U69J+YQkLoUqtPGExns4qRxwigPzZkF8xUE
	DCgYVyPYQz2lzs8seOH3sYoGned5esU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754069333; a=rsa-sha256;
	cv=none;
	b=NItPgdlRZ/XkVwz/lWDUQHQDTSJxvuiFXcgLmUazK24icDQdS2/QTzH61qn3vGSQsXJ4ko
	xPf9QYaCApx1umtzbcqbdBiY5QhX5d/7lnI5/tRYa/72VJxgEJo8ETQoY/uNsUpSjVS/YU
	oT/Q3BIZ+urYBAdFTg12x8zn6s3b67M=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bttDc0ynzz67Ldy;
	Sat,  2 Aug 2025 01:27:12 +0800 (CST)
Received: from frapeml500005.china.huawei.com (unknown [7.182.85.13])
	by mail.maildlp.com (Postfix) with ESMTPS id 5F76F1402EF;
	Sat,  2 Aug 2025 01:28:51 +0800 (CST)
Received: from frapeml500007.china.huawei.com (7.182.85.172) by
 frapeml500005.china.huawei.com (7.182.85.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 1 Aug 2025 19:28:51 +0200
Received: from frapeml500007.china.huawei.com ([7.182.85.172]) by
 frapeml500007.china.huawei.com ([7.182.85.172]) with mapi id 15.01.2507.039;
 Fri, 1 Aug 2025 19:28:51 +0200
From: Shiju Jose <shiju.jose@huawei.com>
To: Daniel Ferguson <danielf@os.amperecomputing.com>, "rafael@kernel.org"
	<rafael@kernel.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"tony.luck@intel.com" <tony.luck@intel.com>, "lenb@kernel.org"
	<lenb@kernel.org>, "leo.duran@amd.com" <leo.duran@amd.com>,
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
Thread-Index: AQHb36LyCBzLg1T4lUmQbc9HcxtQS7RDI7AAgAYEALA=
Date: Fri, 1 Aug 2025 17:28:51 +0000
Message-ID: <a1df7aa762954b35bc5fe2b1f6d9ed78@huawei.com>
References: <20250617161417.1681-1-shiju.jose@huawei.com>
 <20250617161417.1681-3-shiju.jose@huawei.com>
 <547ed8fb-d6b7-4b6b-a38b-bf13223971b1@os.amperecomputing.com>
In-Reply-To: <547ed8fb-d6b7-4b6b-a38b-bf13223971b1@os.amperecomputing.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.195.32.206]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Stat-Signature: shkwy9f4wqkparkdufwpm9ctqest5fe6
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2AF9B40005
X-Rspam-User: 
X-HE-Tag: 1754069332-277198
X-HE-Meta: U2FsdGVkX1+eE/eBFRSx4zsy6HzDtrVim1xQ6cplu+KPIWaM4+PC888+lxSo4kKjeYxDHAwZn4IgfSdcz18HQoRM8XzKkiyNjmS4zGGcmP/hqundhL/nW31i5YXvH82TNmzjGj2IVb//7qDR64C0dD4bTOglAlz3HvfI62znhiQrwU3r9oXVxG0+LgBYFDC5Krth2ET3HKeU/XK3JcYZ/Cmm3OKORNPdF1C5iL+Ht8cI66Kt5wXSrCYWPQqSo3lrW+b6WJPkZ44gnoJMcEgwosJIvR69lp3oc6vRWvKVBbnh/pPDUqkIccm+ecnGqtldSv8VXu7u+B4akIdMJRrateR0uPEK8FBA0HT20FXQdDjXQredPNUNtZelOpuK8iXaFMXpy/pJPUsjDoCGVty8kkCuMSQcnVbL8EEaFpQh3OivoaaZ0AN+AhfTUI0zc4QZGtvxrji2qJcXXIs8dleUsFEF2tWlqWPL8imW/Txh/7hrVkogONUf5IGriBOtwMM3Dy1FHF/5zvItAb0GHtVoUzo7Hl3bOfSWkcXIkj9ZlEt56we+WY/PFo0A6atzZE8j4cfJGrNceDDlGw7TPOqMu+yXOjmFW1Nlcj4gQsREy4bafdj7pgsrlIOXasCYXGRkOUk9BgEGRW4r0YkMsU4hqFxeFU2u/n4AYUAbmPp5rW7hLsbLXHAEVuEyt0D1Rv31eTGHMpctGDsQwN8bBpUXod0SVK6kGoov90Yy0Se/XpaiNcEwWZr8mg49YAnaVGi0BC4r2WiUDIZGfAIwg5x6uNtSApoT+SYy3E3wPqztSIHJ7d4WZXIkMw1eifvPzgbTJUSeg6G2+j65h1R6q/WiIqc6yo2qtugYxiXI2GNzYnyZHoeuITLXW9hy15ArGQM2mvTFPUK3r3Dzb/C46BPxWWs4hyhT9KtPDeAoWkybHqPYBsWyTp+JblkKmdXa15ez1BsZ5jUZ3vwAItrC/kS
 JXOlfGgC
 Xn/e6DxGbYr+KrpZ+t9DNscsSvWQge4nP/PHV7g0yIEYsBlGVBgjaHII0TwdXv8O6vlWm/5jyxx43+nQXIOr+8EdWtdVsmFbBGSy5gURo0+6onR/eDI1XA2zYevWZeb2uD9uq21qOHAN/eE2sLZ/ZVWI4u0odJrTxR4Zf+k9aoFPNU2Rm+3v4RmCp4A8FOIksAPGiTjURO3etWRXcGGjQbfcCfgWHsu4UFquH2lxYPput4Ye1vSVWOu7xZy4/rD4Cfvxzh6x3Zp++6ylPytVEt9JsMM2P2PP83yvjeG0Amxdv4b57BztHGvuRVWf4CP6cwx+c+x75QXyN3RGHGla6ISb+IqJfVC6GOHE49K0IO5GAo/Tym9jbXZedfNjXIy/DpHZuJCFTsHRDD7D3Z2ylBeqMfn1l6TeaXCJazsaj+wpHTdOFB4h5FL+z3/n6fL/SlWJV+Eh8j7aCsbx/3zsLhmS4ZqAPDh/pUtF+cHfLHVPbKfdmUYvBFkqnUPW+A7eBMoTxAqM3HsyQjcrAeokDuJfDksIlFmN8vVh4B5VXNBVjCk7DhHoYuFzkkHDB8F7+BILaPGnFFcfRFksGXp7Lv9/KDW7BhROpnnzK2+5DpykEKoAT+N62oi/omU/PaPOsdAHkdderITOs1W8h4wivJmAJ8nDxJfT7bibaDzlvjCBE0thDk5PNxiixy2cmhbuA1AcIfu5czhdU6z6H4lZOZftqaR30iXmvxJLdbtfz/Vl8Bl+3cCzS7rPmnVZjwOpnyrGfFBj++XFmrPr5e1ixV6nkekCNF3WSRhO+DJozZmBpE0QVWI3Oo2ejvofbuGotTEe8ghYHe0oeQ+rmePknKxzuWEXWAvVWN+FV2SRBp/Jh7P4qkOfoWxTBb7j3dxAr1ogz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogRGFuaWVsIEZlcmd1c29uIDxkYW5p
ZWxmQG9zLmFtcGVyZWNvbXB1dGluZy5jb20+DQo+U2VudDogMjUgSnVseSAyMDI1IDE3OjM2DQo+
VG86IFNoaWp1IEpvc2UgPHNoaWp1Lmpvc2VAaHVhd2VpLmNvbT47IHJhZmFlbEBrZXJuZWwub3Jn
OyBsaW51eC0NCj5lZGFjQHZnZXIua2VybmVsLm9yZzsgbGludXgtYWNwaUB2Z2VyLmtlcm5lbC5v
cmc7IGxpbnV4LWRvY0B2Z2VyLmtlcm5lbC5vcmc7DQo+YnBAYWxpZW44LmRlOyB0b255Lmx1Y2tA
aW50ZWwuY29tOyBsZW5iQGtlcm5lbC5vcmc7IGxlby5kdXJhbkBhbWQuY29tOw0KPllhemVuLkdo
YW5uYW1AYW1kLmNvbTsgbWNoZWhhYkBrZXJuZWwub3JnDQo+Q2M6IEpvbmF0aGFuIENhbWVyb24g
PGpvbmF0aGFuLmNhbWVyb25AaHVhd2VpLmNvbT47IGxpbnV4LQ0KPm1tQGt2YWNrLm9yZzsgTGlu
dXhhcm0gPGxpbnV4YXJtQGh1YXdlaS5jb20+OyByaWVudGplc0Bnb29nbGUuY29tOw0KPmppYXFp
eWFuQGdvb2dsZS5jb207IEpvbi5HcmltbUBhbWQuY29tOyBkYXZlLmhhbnNlbkBsaW51eC5pbnRl
bC5jb207DQo+bmFveWEuaG9yaWd1Y2hpQG5lYy5jb207IGphbWVzLm1vcnNlQGFybS5jb207IGp0
aG91Z2h0b25AZ29vZ2xlLmNvbTsNCj5zb21hc3VuZGFyYW0uYUBocGUuY29tOyBlcmRlbWFrdGFz
QGdvb2dsZS5jb207IHBnb25kYUBnb29nbGUuY29tOw0KPmR1ZW53ZW5AZ29vZ2xlLmNvbTsgZ3Ro
ZWxlbkBnb29nbGUuY29tOw0KPndzY2h3YXJ0ekBhbXBlcmVjb21wdXRpbmcuY29tOyBkZmVyZ3Vz
b25AYW1wZXJlY29tcHV0aW5nLmNvbTsNCj53YnNAb3MuYW1wZXJlY29tcHV0aW5nLmNvbTsgbmlm
YW4uY3hsQGdtYWlsLmNvbTsgdGFueGlhb2ZlaQ0KPjx0YW54aWFvZmVpQGh1YXdlaS5jb20+OyBa
ZW5ndGFvIChCKSA8cHJpbWUuemVuZ0BoaXNpbGljb24uY29tPjsgUm9iZXJ0bw0KPlNhc3N1IDxy
b2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+OyBrYW5na2FuZy5zaGVuQGZ1dHVyZXdlaS5jb207DQo+
d2FuZ2h1aXFpYW5nIDx3YW5naHVpcWlhbmdAaHVhd2VpLmNvbT47DQo+dmFuc2hpa29uZGFAb3Mu
YW1wZXJlY29tcHV0aW5nLmNvbQ0KPlN1YmplY3Q6IFJlOiBbUEFUQ0ggdjkgMi8yXSByYXM6IG1l
bTogQWRkIG1lbW9yeSBBQ1BJIFJBUzIgZHJpdmVyDQo+DQo+DQo+PiArc3RhdGljIGludCByYXMy
X2h3X3NjcnViX3dyaXRlX2FkZHIoc3RydWN0IGRldmljZSAqZGV2LCB2b2lkDQo+PiArKmRydl9k
YXRhLCB1NjQgYmFzZSkgew0KPj4gKwlzdHJ1Y3QgcmFzMl9tZW1fY3R4ICpyYXMyX2N0eCA9IGRy
dl9kYXRhOw0KPj4gKwlzdHJ1Y3QgYWNwaV9yYXMyX3BzX3NoYXJlZF9tZW0gX19pb21lbSAqcHNf
c20gPQ0KPj4gKwkJVE9fQUNQSV9SQVMyX1BTX1NITUVNKHJhczJfY3R4LT5jb21tX2FkZHIpOw0K
Pj4gKwlib29sIHJ1bm5pbmc7DQo+PiArCWludCByZXQ7DQo+PiArDQo+PiArCWlmIChyYXMyX2N0
eC0+Ymdfc2NydWIpDQo+PiArCQlyZXR1cm4gLUVCVVNZOw0KPj4gKw0KPj4gKwlndWFyZChtdXRl
eCkocmFzMl9jdHgtPnBjY19sb2NrKTsNCj4+ICsJcHNfc20tPmNvbW1vbi5zZXRfY2Fwc1swXSA9
IFJBUzJfU1VQUE9SVF9IV19QQVJUT0xfU0NSVUI7DQo+PiArDQo+PiArCWlmICghcmFzMl9jdHgt
PnNpemUpIHsNCj4+ICsJCWRldl93YXJuKHJhczJfY3R4LT5kZXYsDQo+PiArCQkJICIlczogSW52
YWxpZCBhZGRyZXNzIHJhbmdlLCBiYXNlPTB4JWxseCBzaXplPTB4JWxseFxuIiwNCj4+ICsJCQkg
X19mdW5jX18sIGJhc2UsIHJhczJfY3R4LT5zaXplKTsNCj4+ICsJCXJldHVybiAtRVJBTkdFOw0K
Pj4gKwl9DQo+PiArDQo+PiArCXJldCA9IHJhczJfZ2V0X3BhdHJvbF9zY3J1Yl9ydW5uaW5nKHJh
czJfY3R4LCAmcnVubmluZyk7DQo+PiArCWlmIChyZXQpDQo+PiArCQlyZXR1cm4gcmV0Ow0KPj4g
Kw0KPj4gKwlpZiAocnVubmluZykNCj4+ICsJCXJldHVybiAtRUJVU1k7DQo+PiArDQo+PiArCXJh
czJfY3R4LT5iYXNlID0gYmFzZTsNCj4+ICsJcHNfc20tPnBhcmFtcy5zY3J1Yl9wYXJhbXNfaW4g
Jj0gflJBUzJfUFNfU0NfSFJTX0lOX01BU0s7DQo+PiArCXBzX3NtLT5wYXJhbXMuc2NydWJfcGFy
YW1zX2luIHw9DQo+RklFTERfUFJFUChSQVMyX1BTX1NDX0hSU19JTl9NQVNLLA0KPj4gKwkJCQkJ
CSAgICByYXMyX2N0eC0+c2NydWJfY3ljbGVfaHJzKTsNCj4+ICsJcHNfc20tPnBhcmFtcy5yZXFf
YWRkcl9yYW5nZVswXSA9IHJhczJfY3R4LT5iYXNlOw0KPj4gKwlwc19zbS0+cGFyYW1zLnJlcV9h
ZGRyX3JhbmdlWzFdID0gcmFzMl9jdHgtPnNpemU7DQo+PiArCXBzX3NtLT5wYXJhbXMuc2NydWJf
cGFyYW1zX2luICY9IH5SQVMyX1BTX0VOX0JBQ0tHUk9VTkQ7DQo+PiArCXBzX3NtLT5wYXJhbXMu
Y29tbWFuZCA9IFJBUzJfU1RBUlRfUEFUUk9MX1NDUlVCQkVSOw0KPj4gKw0KPj4gKwlyZXQgPSBy
YXMyX3NlbmRfcGNjX2NtZChyYXMyX2N0eCwgUENDX0NNRF9FWEVDX1JBUzIpOw0KPj4gKwlpZiAo
cmV0KSB7DQo+PiArCQlkZXZfZXJyKHJhczJfY3R4LT5kZXYsICJGYWlsZWQgdG8gc3RhcnQgZGVt
YW5kIHNjcnViYmluZw0KPnJjKCVkKVxuIiwgcmV0KTsNCj4+ICsJCWlmIChyZXQgIT0gLUVCVVNZ
KSB7DQo+PiArCQkJcHNfc20tPnBhcmFtcy5yZXFfYWRkcl9yYW5nZVswXSA9IDA7DQo+PiArCQkJ
cHNfc20tPnBhcmFtcy5yZXFfYWRkcl9yYW5nZVsxXSA9IDA7DQo+PiArCQkJcmFzMl9jdHgtPmJh
c2UgPSAwOw0KPj4gKwkJCXJhczJfY3R4LT5zaXplID0gMDsNCj4+ICsJCQlyYXMyX2N0eC0+b2Rf
c2NydWJfc3RzID0gT0RfU0NSVUJfU1RTX0lETEU7DQo+PiArCQl9DQo+PiArCQlyZXR1cm4gcmV0
Ow0KPj4gKwl9DQo+PiArCXJhczJfY3R4LT5vZF9zY3J1Yl9zdHMgPSBPRF9TQ1JVQl9TVFNfQUNU
SVZFOw0KPj4gKw0KPj4gKwlyZXR1cm4gcmFzMl91cGRhdGVfcGF0cm9sX3NjcnViX3BhcmFtc19j
YWNoZShyYXMyX2N0eCk7DQo+PiArfQ0KPg0KPkFmdGVyIGEgbG90IG1vcmUgZGlzY3Vzc2lvbiB3
aXRoaW4gQW1wZXJlLCBJJ3ZlIGNvbWUgdG8gYmVsaWV2ZSB0aGF0IHVzaW5nDQo+YmFzZT09MCAm
JiBzaXplPT0wIGFzIGEgc3BlY2lhbCBjYXNlLCB3aGVuIGludm9raW5nDQo+R0VUX1BBVFJPTF9Q
QVJBTUVURVJTIGFmdGVyIGFuIGVycm9yLCBpcyBub3QgYSBnb29kIGlkZWEuDQo+DQo+VGhlcmUg
YXJlIHRocmVlIHByb2JsZW1zIHdpdGggdGhlIGN1cnJlbnQgc29sdXRpb24uDQo+DQo+MSkgVGhp
cyBpcyB1bmRlZmluZWQgYmVoYXZpb3IgYW5kIHdpbGwgbGlrZWx5IGJlaGF2ZSBkaWZmZXJlbnRs
eSBvbiBkaWZmZXJlbnQNCj5pbXBsZW1lbnRhdGlvbnMuIEZvciBleGFtcGxlLCAwIGlzIGFuIGlu
dmFsaWQgcGh5c2ljYWwgYWRkcmVzcyBvZiB0aGUgQW1wZXJlDQo+c3lzdGVtcywgY291bGQgYmUg
YSB2YWxpZCBhZGRyZXNzIG9uIHNvbWUgc3lzdGVtcywgb3IgY291bGQgYmUgZGV2aWNlIG1lbW9y
eQ0KPm9uIGFub3RoZXIuIEluIGNhc2UgaXQgaXMgYSB2YWxpZCBERFIgYWRkcmVzcywgdGhlIGZp
cm13YXJlIGNhbiBmaWxsIGluIHRoZSBTY3J1Yg0KPlBhcmFtZXRlcnMsIEV4dGVuZGVkIERhdGEg
UmVnaW9uIChBQ1BJIDYuNikgd2l0aCBwcm9wZXIgaW5mb3JtYXRpb24uIEJ1dCBpbg0KPmNhc2Ug
aXQgaXMgYW4gaW52YWxpZCBhZGRyZXNzLCBvciBkZXZpY2UgbWVtb3J5LCB0aGUgZmlybXdhcmUg
aGFzIHRvIGluZGljYXRlIGFuDQo+ZXJyb3IgdG8gcHJldmVudCB0aGUgT1MgZnJvbSBjb25zdW1p
bmcgYmFkIGRhdGEgcmVwb3J0ZWQgdGhyb3VnaCB0aGVzZSBvdXRwdXQNCj5wYXJhbWV0ZXJzLg0K
Pg0KPjIpIFByZXRlbmQgeW91IGFyZSB1c2luZyBhY3BpX3JhczJfbWVtMC9zY3J1YjEsIHdoaWNo
IGNvcnJlc3BvbmRzIHRvIHRoZSAybmQNCj5OVU1BIG5vZGUgaW4gdGhlIHN5c3RlbS4gSWYgd2Ug
dXNlIHRoZSBjdXJyZW50IE9TIGRyaXZlciBpbXBsZW1lbnRhdGlvbiBhcy1pcw0KPmFuZCB6ZXJv
IG91dCBiYXNlIGFuZCBzaXplIGFmdGVyIGFuIGVycm9yLCB0aGVuIHdoZW4gd2UgaXNzdWUgdGhl
IG5leHQNCj5HRVRfUEFUUk9MX1BBUkFNRVRFUlMgd2Ugd2lsbCBoYXZlIHJldHJpZXZlZCB0aGUg
cGFyYW1ldGVycw0KPmNvcnJlc3BvbmRpbmcgdG8gdGhlIHdyb25nIE5VTUEgbm9kZS4gVGhlIGRy
aXZlciB3aWxsIGhhdmUgZmV0Y2hlZCB0aGUNCj5wYXJhbWV0ZXJzIGZvciBOVU1BIG5vZGUgMSwg
ZXZlbiB0aG91Z2ggd2UgYXJlIGludGVyYWN0aW5nIHdpdGggdGhlIHNjcnViYmVyDQo+Y29ycmVz
cG9uZGluZyB0byBOVU1BIG5vZGUgMi4NCj5UaGlzIGNvdWxkIGJlIHByb2JsZW1hdGljIGluIGEg
c2l0dWF0aW9uIHdoZXJlIHBhdHJvbCBwYXJhbWV0ZXJzIGRpZmZlciBhY3Jvc3MNCj5kaWZmZXJl
bnQgTlVNQSBub2Rlcy4gQWRkaXRpb25hbGx5LCBhbmQgcGVyaGFwcyBtb3N0IGltcG9ydGFudGx5
LCB1c2luZyB0aGUNCj5HRVRfUEFUUk9MX1BBUkFNRVRFUlMgdG8gZGV0ZXJtaW5lIGlmIGEgU2Ny
dWJiZXIgaXMgcnVubmluZyByZXF1aXJlIHRoZQ0KPmNvcnJlY3QgYWRkcmVzcyByYW5nZS4gVGhl
IGN1cnJlbnQgaW1wbGVtZW50YXRpb24gaXMgbm90IGdldHRpbmcgdGhlIHJ1bm5pbmcNCj5zdGF0
dXMgb2YgdGhlIGNvcnJlY3QgcmFuZ2UuDQo+DQo+MykgVGhpcyBpcyBhIHNwZWNpYWwgY2FzZSBv
ZiAjMi4gRHVyaW5nIGRyaXZlciBsb2FkLCByYXMyX3Byb2JlIGlzc3VlcyBhDQo+R0VUX1BBVFJP
TF9QQVJBTUVURVJTIHVzaW5nIGEgYmFzZSBhbmQgc2l6ZSBlcXVhbCB0byAwLiBUaGUgYmFzZSBh
bmQgc2l6ZQ0KPmFyZSB6ZXJvIGJlY2F1c2UgcmVxdWVzdGVkX2FkZHJlc3NfcmFuZ2UgaXMgYWxs
b2NhdGVkIHdpdGgga3phbGxvYy4gSW4gdGhpcyBjYXNlLA0KPndlIG1heSBub3QgYmUgZ2V0dGlu
ZyB0aGUgaW5pdGlhbCB2YWx1ZXMgZnJvbSB0aGUgY29ycmVjdCByYW5nZS4NCkluIHRoZSBwcm9i
ZSBzdGFnZSwgd2hpbGUgaXNzdWUgR0VUX1BBVFJPTF9QQVJBTUVURVJTLCBkcml2ZXIgaGFzIG5v
IGluZm9ybWF0aW9uDQphYm91dCB0aGUgICdyZXF1ZXN0ZWRfYWRkcmVzc19yYW5nZScgc3VwcG9z
ZWQgdG8gc2V0IG90aGVyIHRoYW4gc2V0IHRvIDAgYmVjYXVzZQ0KUkFTMiAoJ1JBUzIgUGxhdGZv
cm0gQ29tbXVuaWNhdGlvbiBDaGFubmVsIFNoYXJlZCBNZW1vcnkgUmVnaW9uJyB0YWJsZT8pIGRv
ZXMgbm90DQpkZWZpbmUgZmllbGRzIGZvciB0aGUgcGxhdGZvcm0gdG8gYWR2ZXJ0aXNlIHRoZSBz
dXBwb3J0ZWQgZnVsbCBhZGRyZXNzIHJhbmdlIGZvciBhIHNjcnViYmVyLg0KPg0KPlByb3Bvc2Vk
IFNvbHV0aW9uOg0KPldoYXQgd2UgcHJvcG9zZSwgaXMgdG8gaW5zdGVhZCBvZiB6ZXJvaW5nIG91
dCB0aGUgYmFzZSBhbmQgc2l6ZSBhZnRlciBhbiBlcnJvciwNCj51c2UgdGhlIGZ1bGwgcmFuZ2Ug
b2YgdGhlIGN1cnJlbnQgTlVNQSBub2RlLiBXZSBiZWxpZXZlIHRoYXQgYSBzdXBlcnNldCBvZiBh
DQo+Y3VycmVudGx5IGFjdGl2ZSBzY3J1YiByYW5nZSBjYW4gcHJvcGVybHkgcmVwb3J0IGFsbCB0
aGUgcmVsZXZhbnQgYW5kIGNvcnJlY3QNCj5pbmZvcm1hdGlvbi4NCj5UbyBiZSBjb21wbGlhbnQg
d2l0aCB0aGUgc3BlY2lmaWNhdGlvbiwgRlcgc2hvdWxkIHNldCAiRmxhZ3MiIGZpZWxkIGlmIHRo
ZXJlIGlzIGFueQ0KPm9uLWRlbWFuZCBzY3J1YiBpbiBwcm9ncmVzcyBvbiBhbnkgbWVtb3J5IHJh
bmdlIGluIHRoZSBOVU1BIG5vZGUuIEFnYWluLA0KPnRoaXMgc29sdXRpb24gYXNzdW1lcyB0aGF0
IHRoZSBkcml2ZXIgZG9lcyBub3QgYWxsb3cgbW9yZSB0aGFuIG9uZSBzY3J1YmJlciB0bw0KPnJ1
biB3aXRoaW4gYSBzaW5nbGUgTlVNQSBub2RlLiBBbGwgdGhyZWUgcHJvYmxlbXMgY2FuIGJlIHNv
bHZlZCBpbiB0aGUgc2FtZQ0KPndheS4NCj4NCj5XaGF0IGRvIHlvdSB0aGluaz8NCkhpIERhbmll
bCwNCg0KUGxlYXNlIGNoZWNrIHRoZSB2MTAgb2YgdGhlIFJBUzIgc2VyaWVzIHNlbnQgd2l0aCBj
aGFuZ2VzIGZvciB5b3VyIHJlcXVpcmVtZW50cy4NCmFuZCByZXF1ZXN0IHBsZWFzZSB0ZXN0IGlu
IHlvdXIgc3lzdGVtIGFuZCBzaGFyZSB0aGUgZmVlZGJhY2suDQoNCmh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2FsbC8yMDI1MDgwMTE3MjA0MC4yMTc1LTEtc2hpanUuam9zZUBodWF3ZWkuY29tLw0K
Pg0KPlJlZ2FyZHMsDQo+fkRhbmllbA0KDQpUaGFua3MsDQpTaGlqdQ0K

