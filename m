Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BA7DD5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 07:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91C576B0005; Tue, 16 Dec 2025 02:42:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F9C76B0089; Tue, 16 Dec 2025 02:42:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3836B008A; Tue, 16 Dec 2025 02:42:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 70DCA6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:42:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 139D21A0560
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:42:54 +0000 (UTC)
X-FDA: 84224542668.21.E0D4A66
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf25.hostedemail.com (Postfix) with ESMTP id B8721A000C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:42:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CU+jXv4v;
	spf=pass (imf25.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765870972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/ZdW0RTzwMImTVMjvdyw8BTiP7546TOTsFudL2sFvQg=;
	b=4voiuH8EZb2rTw3iLe2KUhjScJ3aIFV5853/a7ibh/aGXbBQynZICMqxwbeLftD5mi4uc2
	0aBrVdGsA+TIZkzMr5FfgKuC7IHLE6vlGV2QVAenqwfbDCEeVMzDNepbdgvLfjYPs8RSvk
	Aqb4jnmA7VM9HqPlhdQ7KW5nGgjbOxg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CU+jXv4v;
	spf=pass (imf25.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765870972; a=rsa-sha256;
	cv=none;
	b=AzUZMI/wYg2s6fCthj03zUs+1Ac+gzpjRDq8IOd33BMCgVxlmtNEnie8kU+k3TYnvRaUw+
	bsSuzkNzqeLqYE9HTusvTtO1Bqp88qOMM2sc+zDi4+q9DGwLjo4etMO+axpRU7MLLzdoaE
	MjNe/kuQlxWbmZmI3PrKYgdv4RrSlU4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/ZdW0RTzwMImTVMjvdyw8BTiP7546TOTsFudL2sFvQg=;
	b=CU+jXv4vbzZQPYmJs+5boLCKM9sdZvLpdtGfynJp62/WcLvcCQyXL7uH7Nvb767Sm1S4INVgk
	BhLXm6sCbyXBwGQr1TlsjXanBbIU1sAXLKEzXA1hM/GFFIT4WZ6YAkc+qLpY+4zVs+7+LBjFv21
	ukavIPJxT9IZZbUD/LKOfX0=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4dVpkh63MjzLlVV;
	Tue, 16 Dec 2025 15:40:44 +0800 (CST)
Received: from dggpemf500009.china.huawei.com (unknown [7.185.36.50])
	by mail.maildlp.com (Postfix) with ESMTPS id 805301A016C;
	Tue, 16 Dec 2025 15:42:44 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (7.185.36.8) by
 dggpemf500009.china.huawei.com (7.185.36.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Dec 2025 15:42:44 +0800
Received: from dggpemf500012.china.huawei.com ([7.185.36.8]) by
 dggpemf500012.china.huawei.com ([7.185.36.8]) with mapi id 15.02.1544.011;
 Tue, 16 Dec 2025 15:42:44 +0800
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
Thread-Index: AdxuX44yGEAb2cBdSXaqz2NhdGENWw==
Date: Tue, 16 Dec 2025 07:42:44 +0000
Message-ID: <0ce50058e6254a29baee1271ae0ef31c@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.174.177.115]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam02
X-Stat-Signature: 7srbeyd11gktoe7fj8j5y1uwry9a4yor
X-Rspam-User: 
X-Rspamd-Queue-Id: B8721A000C
X-HE-Tag: 1765870970-652199
X-HE-Meta: U2FsdGVkX1/JW2Rgbg9e2edsA4DhPL4cDRdPOmgoM/q5ditJbtflDeR9ul0qwgy+TEKYV9wtibT6Z7MCGuspe5kIuSH19s5G25aqeDDLg5OVt7y5CMIYiPqNh6Y3/vPvg9b2r0TVcOu1kw21CCpKXtlR74QV2+rb/65iD2JlozdX9h/WrBZeXy1x55gQ/pnDgFKAgcVV6FUX484JUkYxBgPJPmpIXcWZi58MnaRPJWGSuzmERiQn+qJy9mPsHnbQbzuw2STu0hB13J1Mk27zMtKUYs81KTp2YbZyHupRad4ApKaeog2Z6R45CfhC6vokc7cX2BYOGufBv49FRLbq7zWsLpFmqi0xvTI7YRS88qB0MbjLFdhk7UPAhBtYGgG+/ObKi2bXPoqQHyPVr96hQL0U+E3foxt4DfRSLnfpHG1Z8OswlMsJl/Y9mErQbWPGMzrWD7qcH+7LLD8B2fZo02el1dbElBRrif86x7ODtlm1K6nIqR0Nrts3h2v60zP27Wmv6cazXgGLDEgsyhYHKlUiSNyX4IItsUusDRSlFGqqHigObt+K+ri8uo7b6+GaHvY+iNNaagxunp7ZXZ7PBzzftql9O9beWVwx4CUm7ElCC/KVYq2KrrspZlkmObExNkEY77J6ceIvIQcP1lj57qhH6QA6jedQiUjvSo12xcam43SDKpVpOXV8xu1bQMLXipDKGzP8DzPuyWUvCGr46kR04lpGeSlcUVaRCw/UMjjUbjIG2X5+dN8zmMwWPp16WyJpWG9Dj938K0URYqjW1HgnJq60zBHm29lN0+xLbdZ72B5WKUjqqLT33quSO4pFuo4XGNrFdaKGr8GOgoxOFUUmF40qRDD4QNIPelOqciFFcR+wZ9kcxDjwz3jVUIKfML+ZM/yRTZhJKQlPo0ohNeofD8zgC1cTFa/8aBu1he9b3PCXDyz2L0BQImQNaYyfzddqSeHpj/U+HkyZ5SV
 BxatOAM+
 L5NyMnlaaQac1vZSKy3YybeGCDzNQbn9tT6+Ojl5/FSjXVHjNMC2Yhc5Z5VVg2J33X2m9JMX9dUboo0TYwVZ3OWQ7aHok8RNzc0bzY3nk5fZcwrFPHGeuBzTdYY/lw2hEW/bPgaYYNeGbLf5aECCJ0+yoyoMTmv1K5lgFIGf/Dp860Wn5mkbhWQn5wAI2AantVB/X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBPbiAxMi8xNi8yNSAwMzoyNCwgemhhbmdxaWxvbmcgd3JvdGU6DQo+ID4gICA+IE9uIDEyLzE1
LzI1IDE1OjAwLCBNYXR0aGV3IFdpbGNveCB3cm90ZToNCj4gPj4+IE9uIE1vbiwgRGVjIDE1LCAy
MDI1IGF0IDA4OjM0OjA1UE0gKzA4MDAsIFpoYW5nIFFpbG9uZyB3cm90ZToNCj4gPj4+PiBUaGlz
IHBhdGNoIHNlcmllcyBpbXBsZW1lbnRhdGUgVEhQIENPVyBmb3IgcHJpdmF0ZSBleGVjdXRhYmxl
IGZpbGUNCj4gPj4+PiBtbWFwLiBJdCdzIG1ham9yIGRlc2lnbmVkIHRvIGluY3JlYXNlIHRoZSBp
VExCIGNhY2hlIGhpdCByYXRlIGZvcg0KPiA+Pj4+IGhvdCBwYXRjaGluZyBhcHBsaWNhdGlvbiwg
YW5kIHdlIGFkZCBhIG5ldyBzeXNmcyBrbm9iIHRvIGRpc2FibGUgb3INCj4gPj4+PiBlbmFibGUg
aXQuDQo+ID4+Pg0KPiA+Pj4gWW91J3JlIGdvaW5nIHRvIGhhdmUgdG8gcHJvdmlkZSBkYXRhIHRv
IGdldCB0aGlzIHBhdGNoIGluLiAgV2UndmUNCj4gPj4+IGRlbGliZXJhdGVseSBub3QgZG9uZSB0
aGlzIGluIHRoZSBwYXN0IGR1ZSB0byBtZW1vcnkgY29uc3VtcHRpb24NCj4gPj4gb3ZlcmhlYWQu
DQo+ID4+PiBTbyB5b3UgbmVlZCB0byBwcm92ZSB0aGF0J3Mgbm93IHRoZSB3cm9uZyBkZWNpc2lv
biB0byBtYWtlLg0KPiA+Pj4NCj4gPj4+IE1pY3JvYmVuY2htYXJrcyB3b3VsZCBiZSBhIGJhcmUg
bWluaW11bSwgYnV0IHdoYXQgYXJlIHJlYWxseQ0KPiBuZWVkZWQNCj4gPj4+IGFyZSBudW1iZXJz
IGZyb20gYWN0dWFsIHdvcmtsb2Fkcy4NCj4gPj4NCj4gPj4gSW4gYWRkaXRpb24sIHRoZSBzeXNm
cyB0b2dnbGUgaXMgcmF0aGVyIGhvcnJpYmxlLiBJdCdzIHJhdGhlciBjbGVhcg0KPiA+PiB0aGF0
IHRoaXMgaXMgbm90IGEgc3lzdGVtLXdpZGUgc2V0dGluZyB0byBiZSBtYWRlLCBhcyB5b3UgbGlr
ZWx5IG9ubHkNCj4gPj4gd2FudCB0aGF0IGJlaGF2aW9yIChpZiBhdCBhbGwgLi4uKSBmb3IgYSBo
YW5kZnVsIG9mIHNwZWNpYWwgcHJvY2Vzc2VzIEkgYXNzdW1lPw0KPiA+DQo+ID4gWWVhciwgaXQn
cyBub3QgYSBzeXN0ZW0td2lkZSBzZXR0aW5nLiBXZSBjb25zaWRlciBlbmFibGluZyB0aGlzIG9w
dGlvbg0KPiA+IG9ubHkgd2hlbiBhcHBseWluZyBob3QgcGF0Y2hlcyB0byBzcGVjaWFsIHByb2Nl
c3Nlcy4gSWYgdGhlIHN5c2ZzDQo+ID4gdG9nZ2xlIGlzIHVuYXZhaWxhYmxlLCB3ZSB3aWxsIGV2
YWx1YXRlIHRoZSBvdmVyYWxsIG1lbW9yeSBpbXBhY3Qgb24NCj4gPiB0aGUgc3lzdGVtIGFmdGVy
IHJlbW92aW5nIGl0LiBUaGFua3MgdmVyeSBtdWNoIGZvciB5b3VyIHN1Z2dlc3Rpb24uDQo+IA0K
PiBJIGRvbid0IHRoaW5rIHdlIHdhbnQgdGhpcyBhcyBhbnkga2luZCBvZiBkZWZhdWx0IGJlaGF2
aW9yLiBCdXQgdGhlIHN5c3RlbQ0KPiB0b2dnbGUgaXMgcmVhbGx5IGFsc28gbm90IHdoYXQgd2Ug
d2FudC4gQ291bGQgd2UgdXNlIHNvbWUgcGVyLVZNQSBvciBwZXItDQo+IGZpbGUgaGludHMgdG8g
YWZmZWN0IHRoZSBwb2xpY3k/DQoNCkl0J3MgcmVhbGx5IGEgZ29vZCBpZGVhLiBNYXliZSBjb3Vs
ZCBzZXR0aW5nIGEgeHggZmxhZyB0byBWTUEsIGJ1dCBpdCBuZWVkIGhvbGQgd3JpdGUNCmxvY2sg
YW5kIHRvdWNoIFZNQS4gbGV0IG1lIGhhdmUgYSB0aGluayBob3cgdG8gaW1wbGVtZW50IHBlci1W
TUEgb3IgcGVyLWZpbGUgcG9saWN5DQpvciBvdGhlciBiZXR0ZXIgaGludHMuDQoNCkkgaGF2ZSBh
IHRob3VnaHQgdGhhdCwgaG93IGFib3V0IGFkZGluZyBhIG5ldyBmbGFnKGluIHB0cmFjZSwgdXBy
b2Jlcy4uLikgYW5kIHBhc3NpbmcNCnRvIGZhdWx0aW5fcGFnZSgpIHRvIG1hcmsgdGhlIGV4ZWMg
UE1EIENPVyBwb2xpY3k/DQoNCj4gDQo+IE5vdGUgdGhhdCB5b3VyIHByb3Bvc2FsIHdpbGwgbGlr
ZWx5IGludGVyYWN0IGluIGJhZCB3YXlzIHdpdGggdXByb2JlcywgYWZ0ZXINCj4gcmVtb3Zpbmcg
dXByb2JlcyBhZ2Fpbi4NCg0KWWVhciwgZ29vZCBjYXRjaCBoZXJlLCBpdCdzIHJlYWxseSBuZWVk
IGJlIHNlcmlvdXNseSBjb25zaWRlcmVkLiANCg0KPiANCj4gLS0NCj4gQ2hlZXJzDQo+IA0KPiBE
YXZpZA0K

