Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4BFED5C0C1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 02:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFBAB6B008A; Mon, 15 Dec 2025 21:24:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD32C6B008C; Mon, 15 Dec 2025 21:24:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD27C6B0092; Mon, 15 Dec 2025 21:24:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7CA86B008A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:24:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 661E41A046A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:24:49 +0000 (UTC)
X-FDA: 84223741098.21.A0B4273
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf11.hostedemail.com (Postfix) with ESMTP id CC90D4000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:24:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=av1WV9Yw;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765851887; a=rsa-sha256;
	cv=none;
	b=1VaHIRWzcVD47qm8ND17ASN8li/lRyVmYmYgaQrHPFDdYS4TOcdraBWg/vwnoZY5068qBI
	+AJqNI4rC1XJc+vSGWqfUx9Yg9p+HTmWc9Gs+GIJKl7x9HgQvYPdFED9C7L2vgdu0D9wzo
	olSP/7UQxrU23ba94OapXYMOM3XEmYU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=av1WV9Yw;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765851887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=08VCGfxGBygDebj0UMTfZAR9kmbn/DHWW65lHjjH7YM=;
	b=bik5RltnhGZ3rYKe+bYNHrOPp55f+fbGPEf0qhye/DsYxtyBB4hdUhwI9XmiE8TCbufBj0
	Rud6IoMYaSqQr7hFM69Kvr2oyzvNk9uMc35jRQ9COZPAIgx4kF9WKCq5i/VCVK/x7/IXcN
	RTYvtGuOvhzHake1MbShHNQZpYewUaI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=08VCGfxGBygDebj0UMTfZAR9kmbn/DHWW65lHjjH7YM=;
	b=av1WV9Ywogbj1/c5oRY0v5UH3ZyXMk/jKVGrT17rK+MVE4czYV3UMfh5AdcE4i0o8RVzlR48k
	o4bHnfZHAodkgWTSH2jcnBrI24HfRvhI4UP4WCX6gOlWKejm6j5Wo7qavaf3D+W0/PYUGcVYthr
	dwB5h6Apavo4QhSoPY1kQ+w=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dVggg3j5Fz1prKH;
	Tue, 16 Dec 2025 10:22:39 +0800 (CST)
Received: from dggpemf100007.china.huawei.com (unknown [7.185.36.214])
	by mail.maildlp.com (Postfix) with ESMTPS id BC283140132;
	Tue, 16 Dec 2025 10:24:40 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (7.185.36.8) by
 dggpemf100007.china.huawei.com (7.185.36.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Dec 2025 10:24:40 +0800
Received: from dggpemf500012.china.huawei.com ([7.185.36.8]) by
 dggpemf500012.china.huawei.com ([7.185.36.8]) with mapi id 15.02.1544.011;
 Tue, 16 Dec 2025 10:24:40 +0800
From: zhangqilong <zhangqilong3@huawei.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Matthew Wilcox
	<willy@infradead.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "npache@redhat.com"
	<npache@redhat.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"dev.jain@arm.com" <dev.jain@arm.com>, "baohua@kernel.org"
	<baohua@kernel.org>, "lance.yang@linux.dev" <lance.yang@linux.dev>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"Wangkefeng (OS Kernel Lab)" <wangkefeng.wang@huawei.com>, Sunnanyong
	<sunnanyong@huawei.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH next 0/2] THP COW support for private executable file mmap
Thread-Topic: [PATCH next 0/2] THP COW support for private executable file
 mmap
Thread-Index: AdxuMYKVGEAb2cBdSXaqz2NhdGENWw==
Date: Tue, 16 Dec 2025 02:24:40 +0000
Message-ID: <e133c19e47324cce97a1c8f3752489c1@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.174.177.115]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Queue-Id: CC90D4000B
X-Rspamd-Server: rspam03
X-Stat-Signature: 8cdshj3ejqjnnecykz85sf6epiqi3oz8
X-Rspam-User: 
X-HE-Tag: 1765851885-112781
X-HE-Meta: U2FsdGVkX18cIjS/LcBLtECvfO7//K04ImDAlIO0x2cBN0MED9lW6/7lnhw4Ab6nTeMJDMqKanMBM7mSBj+F/6DfGCOJGsEAdoRrXJHgacAqQprrFoh8gplcp6NQ7VI9zdPUWgoCsXSF9uWFWlxjiOI4R662x32050jQcKKEKcUkhvMqoAa4lak5s42+EyiRF9/eQYlAxYVTowbMpm+o/au7W64GTIrz+37FfAk/RHx1WyOZUEXB9SfIPwm5SHB9lD9T71x8C+vF7/dDdzJkdeQ+yZecdxpZpP0UIIJNmkAK+oHl+qyFwH6q2hN5Rmwm0DKGKLP7xpIPJVYMxZXriOWbnLZUKN7z6k4/HDptfYPI897NnLl5KDhxxArqNKgC0K4jE3GDQnP1Ai9VfKS9xl1hNUugaeYbWX41z1/eznCkTdsQCEalUBiwQekHKOakgPwSjBFj4RBwg0nMN2x8dNM47zrF81HbZfpk/ulFwE+J08H6fQmPymf2FMnbGYNCYJzseHnqHKl6x100PFzK5lJ4iXtCE2pojXGOlE+fnX0lZCXRToncHYHqkVOXrOatoCTDpT+SwED2Vg4nGHJobmlBr/CmPNmWGZs74S8noqTayxDfgtOzihAsZDy2SXVwK/FNr6sboRGKeBEPG3jY2WP9XPDuXQ2Iu+8rj+qlUMoibBGMB5CKygmaDTpz5G8QsA/8Vp+7JjdxMRJ7jKhCIlTWiEPYqdXRr1Ynad8Z5MONZTt9M6b7AV7xj/zLDW6+m63sG3Caqq7E+1C8bujJ0Kch+K6aHHUGwU2jGAJ08j5It3A6OjinoKTqwsYrm2wFungbGNGz9RZNrm/j6OsCVXRCueiKHb4k7xy4pmQZSJtx5dfg6v3FillT5D+mUBZ7WDDbKq3I+8nZbd7e8JxImMLEQO1vDEoKW6SjnkpjoCxodfofN+Ogjmi2U3XcVwL1bjT//L7CUv2QcXwwsRU
 IbURvhm+
 PS/UIONfx/ZqYDu34DaBg+rakZ2tvmvfTOSzB8tmjpQBx5wAkgpeFrlmAHWkqwIsuD9m1PX/s5NjcydNtOSVAJeYL2bC/kxPoUg8XVeEr00PEtPfyq+H1Y1/LvGiUvmY5m5ouW1/+aRLV83B4vffhiKTZoUv2m1YaL/TmFK5OZQ4TT5xvfcbQlvzdwd6Idhw0Xs/No5p/9/7Qt2gcMxn2z1QL9ZJKzJvRiFMqTVpfr8ocbrF6/42YGo6N1ZNYxUhlHP1g63vm9BOu8TFxkK1saYZsaByOl1bnvTuCB6472HkUCG6Lqw7r2Z2XBOhEZgehlmXLUm6cdf4ZTrD6lqyQVRpZpEfuFSlAql9Ctw7QDzjQEGt+/wyF8f/n2x7Ki86kJgVwFXFGxxSEWmsVJNXr/kOiE2P4yEZRRGBZWsB859h4CF/M2LxyIASitMr649gAPYg1IkLh1+GfThEBq4UKGFf426XAxNlp/wMrj7qdFE5P4DqvIaQX4fBKOfXRX5gHPGjj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ID4gT24gMTIvMTUvMjUgMTU6MDAsIE1hdHRoZXcgV2lsY294IHdyb3RlOg0KPiA+IE9uIE1vbiwg
RGVjIDE1LCAyMDI1IGF0IDA4OjM0OjA1UE0gKzA4MDAsIFpoYW5nIFFpbG9uZyB3cm90ZToNCj4g
Pj4gVGhpcyBwYXRjaCBzZXJpZXMgaW1wbGVtZW50YXRlIFRIUCBDT1cgZm9yIHByaXZhdGUgZXhl
Y3V0YWJsZSBmaWxlDQo+ID4+IG1tYXAuIEl0J3MgbWFqb3IgZGVzaWduZWQgdG8gaW5jcmVhc2Ug
dGhlIGlUTEIgY2FjaGUgaGl0IHJhdGUgZm9yIGhvdA0KPiA+PiBwYXRjaGluZyBhcHBsaWNhdGlv
biwgYW5kIHdlIGFkZCBhIG5ldyBzeXNmcyBrbm9iIHRvIGRpc2FibGUgb3INCj4gPj4gZW5hYmxl
IGl0Lg0KPiA+DQo+ID4gWW91J3JlIGdvaW5nIHRvIGhhdmUgdG8gcHJvdmlkZSBkYXRhIHRvIGdl
dCB0aGlzIHBhdGNoIGluLiAgV2UndmUNCj4gPiBkZWxpYmVyYXRlbHkgbm90IGRvbmUgdGhpcyBp
biB0aGUgcGFzdCBkdWUgdG8gbWVtb3J5IGNvbnN1bXB0aW9uDQo+IG92ZXJoZWFkLg0KPiA+IFNv
IHlvdSBuZWVkIHRvIHByb3ZlIHRoYXQncyBub3cgdGhlIHdyb25nIGRlY2lzaW9uIHRvIG1ha2Uu
DQo+ID4NCj4gPiBNaWNyb2JlbmNobWFya3Mgd291bGQgYmUgYSBiYXJlIG1pbmltdW0sIGJ1dCB3
aGF0IGFyZSByZWFsbHkgbmVlZGVkDQo+ID4gYXJlIG51bWJlcnMgZnJvbSBhY3R1YWwgd29ya2xv
YWRzLg0KPiANCj4gSW4gYWRkaXRpb24sIHRoZSBzeXNmcyB0b2dnbGUgaXMgcmF0aGVyIGhvcnJp
YmxlLiBJdCdzIHJhdGhlciBjbGVhciB0aGF0IHRoaXMgaXMgbm90IGENCj4gc3lzdGVtLXdpZGUg
c2V0dGluZyB0byBiZSBtYWRlLCBhcyB5b3UgbGlrZWx5IG9ubHkgd2FudCB0aGF0IGJlaGF2aW9y
IChpZiBhdA0KPiBhbGwgLi4uKSBmb3IgYSBoYW5kZnVsIG9mIHNwZWNpYWwgcHJvY2Vzc2VzIEkg
YXNzdW1lPw0KDQpZZWFyLCBpdCdzIG5vdCBhIHN5c3RlbS13aWRlIHNldHRpbmcuIFdlIGNvbnNp
ZGVyIGVuYWJsaW5nIHRoaXMgb3B0aW9uIG9ubHkgd2hlbg0KYXBwbHlpbmcgaG90IHBhdGNoZXMg
dG8gc3BlY2lhbCBwcm9jZXNzZXMuIElmIHRoZSBzeXNmcyB0b2dnbGUgaXMgdW5hdmFpbGFibGUs
IHdlIHdpbGwNCmV2YWx1YXRlIHRoZSBvdmVyYWxsIG1lbW9yeSBpbXBhY3Qgb24gdGhlIHN5c3Rl
bSBhZnRlciByZW1vdmluZyBpdC4gVGhhbmtzIHZlcnkNCm11Y2ggZm9yIHlvdXIgc3VnZ2VzdGlv
bi4NCg0KPiANCj4gLS0NCj4gQ2hlZXJzDQo+IA0KPiBEYXZpZA0KDQo=

