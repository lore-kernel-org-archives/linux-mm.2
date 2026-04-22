Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D931F9EDC5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 13:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DF846B008A; Wed, 22 Apr 2026 09:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6CD6B008C; Wed, 22 Apr 2026 09:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CD226B0092; Wed, 22 Apr 2026 09:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7CAB06B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:03:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15CC91601AE
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 13:03:37 +0000 (UTC)
X-FDA: 84686208474.20.9D6FF67
Received: from mailgw2.hygon.cn (unknown [101.204.27.37])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1312FA000A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 13:03:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of liuyibin@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=liuyibin@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776863015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UCVUeGdlFfGlA93XmYUteXT3qdaKxKb/nR4f2YXDczw=;
	b=hVJ+JaKP4dNAJaMccvsT9um4EOwh5cXp7Vt80fIX84wB4YnhhtNXRhFvk7OmU1ToM4aCji
	A1+7oVybOQdX/1Z4Ep7efIILb4SlhUtyeI2fk67OIygaUSFIY0BON0BTfjJ5DLe0maGayn
	GsAmRTZgFgRYX4pLftqpWQbKSEr/oo4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776863015; a=rsa-sha256;
	cv=none;
	b=jzx88JSXAXl/k9g6YuFcveWE/+/vmEkbTJEHS2EKYGHJvlLFh4uCz1tvjT5Tsay18cs6Zf
	tFH71qX4LfpyiDQwdjrT7mNtmZnjHvjqYE8st7oJemjdrlnGCjiCy1U3lheAinht5y7H+3
	VUTFrKBbWN0/LZAYXWy/o2Uar1waIeo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of liuyibin@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=liuyibin@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4g0ztT6lWXz1YQpmJ;
	Wed, 22 Apr 2026 21:03:29 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4g0ztS3Mx8z1YQpmJ;
	Wed, 22 Apr 2026 21:03:28 +0800 (CST)
Received: from cncheex05.Hygon.cn (unknown [172.23.18.115])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id E658932B354C;
	Wed, 22 Apr 2026 21:03:24 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex05.Hygon.cn
 (172.23.18.115) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 22 Apr
 2026 21:03:19 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Wed, 22 Apr 2026 21:03:19 +0800
From: Yibin Liu <liuyibin@hygon.cn>
To: Mateusz Guzik <mjguzik@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "brauner@kernel.org" <brauner@kernel.org>,
	Jianyong Wu <wujianyong@hygon.cn>, Huangsj <huangsj@hygon.cn>, Yuan Zhong
	<zhongyuan@hygon.cn>, "jack@suse.cz" <jack@suse.cz>, "jlayton@kernel.org"
	<jlayton@kernel.org>, "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
	"alex.aring@gmail.com" <alex.aring@gmail.com>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIG1tOiBBZGQgUldIX1JNQVBfRVhDTFVERSBmbGFn?=
 =?utf-8?Q?_to_exclude_files_from_rmap_sharing?=
Thread-Topic: [PATCH] mm: Add RWH_RMAP_EXCLUDE flag to exclude files from rmap
 sharing
Thread-Index: AQHc0ceWdlrDL8nbPE+Fpw0BQ/z5wrXrCmTg
Date: Wed, 22 Apr 2026 13:03:19 +0000
Message-ID: <67a71b489eb3413ab0907351d3c56d31@hygon.cn>
References: <20260421020932.3212532-1-liuyibin@hygon.cn>
 <CAGudoHHki3gv-HXXMALePDoC+tmao4oWcYgCo9kXNDkEhW4E4g@mail.gmail.com>
In-Reply-To: <CAGudoHHki3gv-HXXMALePDoC+tmao4oWcYgCo9kXNDkEhW4E4g@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.22.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Queue-Id: 1312FA000A
X-Rspamd-Server: rspam07
X-Stat-Signature: acrars7hry8jawatxs5me6hrcbukdwji
X-Rspam-User: 
X-HE-Tag: 1776863012-681584
X-HE-Meta: U2FsdGVkX19YUvrEVUwS/HXIiE4xCMeL8tGJVMTXifleCM0w5GouKQHw93YFYNCEa+IwSojXw8zOOZYrb3scZqLwnjK76ObzQ6AH1UPc3xEoihfma88aCK52rXKN8N+/vID+NQ4V76yZFXlqPcJytMRcfbGqccwn5u2OQlNs3+pvPioAHuwvDqJCfPy5fPRIPuF4130GLrART8Ji20K+eDdtVpAjVghjAAkCMsE9Ony/HT9jL/gHmHsbHhIbYNhXQXkMv+VMDIip1zxbFHdMgiWazYAMvGRuVsVQbS2BKW0yVyDHvNSdV8b66mYP9ODyRA8QILh200IyYKaHexPsARjFR6sAAdkTETfG4m3XhEFVINYoErrOtzUKl9ByvGvPuwTasbOqVp+gxYKIHI5j2K/3TGkdC/NdmZduTiqUK1iut2tcd6UVTVNAWr5cQc3QiBwETF1mNkKLgwFmD605+husDuM/Oe4+f8mxLtzXGPhxyFXH1Mlun2dES8GVdHoZXI6HU5UCR7Sj/r6568k2avidG1ReY+LPplu5aj8XftDrpPFmJ69ycS3++C94DqutRbCOnXxJz9DD7T376uf+vIM+uaE8dB7Z3h9x+al+YJAFZmAUHIVaHjnc6bHZdyt5esLyZ/URwrJTwKi9bQz5qV1F0PlxB9ax0k1Bv/ieA5E4kGnpBY3Tyfh2mTpyfqVIkmPf0fHyl2+6idH4tMoF1qLCagI4+ilRmO7BAQA8TVUdPJKIazP+Ge2Youc7nq6Uy0Xt/WZ0tTsOmlbUXjPGzRFhJaDQfRy1D6xmchd5at/wtgvXeibJex7XY4E7en6yt/YNJtlZ59W1X+vZGSBKbAM9s6+Jx2jlRYCr81Dgn1LX39h0M30skcrFH0ZmDLG3GkEVYVVhMzT8/shbgMsdxIvgZLqFhKjFGnDTei5MRtnb9c/qux8UQmjIFMPmNt82ws5Gmx8ZJ+742V0VZNL
 JjBFWuSa
 MslaCjPLGMXug7NPT7+95BExm4jChE1CDBD78L1iYDShsmEFiGvzd8+JEbjFNdqw9XnzDohHfyg8A66ruUPx6vUT2Qka7MiAUjYJ23NJx00spgVMxVdrNODTQrLrCFVe4JfHARvq4CWZ88DND10btAIS/STsnDv8RVjYdrhglQI8pm8z9Pr/Z6BSBm6slC0P3CsYeIwjjFWbntLZ3aeXdqA61wcIO7bsN9j/3Xg1yDhOCsPJ/BmVp0Qpdfy7QHd4WAPlJuAupYkmtBc+yrlptDvszRCLOTej4tcObQFNbFjYXB53oWHZrHFc9LUY/yJVgWgNQ+I3Q3iER0nh+bAAspQIxQvALWU30B2iiPu74FrVt9dfoC3smYG8umockt0szrd2pSS817VwgH5JQLamYiF4UIsT6/A6T6bkfSyVD+oHfPTtGdvapmlLNZDVA/bNxeyoRtuKw2oQjpnGwNFXesL+fDK5UIn9McrZ7yWOgwiQIxnIIBafCvHnIfCezAd5SFY7qx/2W+qEXzHBiQDrEqVbfDt6Ch9RVqdb4wlot2QZHgsiraN+6U/EwhPwwcrpiE9MI7mLBZ1OB+/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBPbiBUdWUsIEFwciAyMSwgMjAyNiBhdCA0OjEx4oCvQU0gWWliaW4gTGl1IDxsaXV5aWJpbkBo
eWdvbi5jbj4gd3JvdGU6DQo+ID4NCj4gPiBVbml4QmVuY2ggZXhlY2wvc2hlbGxzY3JpcHQgKGR5
bmFtaWNhbGx5IGxpbmtlZCBiaW5hcmllcykgYXQgNjQrIGNvcmVzIGFyZQ0KPiA+IGJvdHRsZW5l
Y2tlZCBvbiB0aGUgaV9tbWFwX3J3c2VtIHNlbWFwaG9yZSBkdWUgdG8gaGVhdnkgdm1hDQo+IGlu
c2VydC9yZW1vdmUNCj4gPiBvcGVyYXRpb25zIG9uIHRoZSBpX21tYXAgdHJlZSwgd2hlcmUgbGli
Yy5zby42IGlzIHRoZSBtb3N0IGZyZXF1ZW50LA0KPiA+IGZvbGxvd2VkIGJ5IGxkLWxpbnV4LXg4
Ni02NC5zby4yIGFuZCB0aGUgdGVzdCBleGVjdXRhYmxlIGl0c2VsZi4NCj4gPg0KPiA+IFRoaXMg
cGF0Y2ggbWFya3Mgc3VjaCBmaWxlcyB0byBza2lwIHJtYXAgb3BlcmF0aW9ucywgYXZvaWRpbmcg
ZnJlcXVlbnQNCj4gPiBpbnRlcnZhbCB0cmVlIGluc2VydC9yZW1vdmUgdGhhdCBjYXVzZSBpX21t
YXBfcndzZW0gbG9jayBjb250ZW50aW9uLg0KPiA+IFRoZSBkb3duc2lkZSBpcyB0aGVzZSBmaWxl
cyBjYW4gbm8gbG9uZ2VyIGJlIHJlY2xhaW1lZCAoYWxvbmcgd2l0aCBjb21wYWN0DQo+ID4gYW5k
IGtzbSksIGJ1dCBzaW5jZSB0aGV5IGFyZSBzbWFsbCBhbmQgcmVzaWRlbnQgYW55d2F5LCBpdCdz
IGFjY2VwdGFibGUuDQo+ID4gV2hlbiBhbGwgbWFwcGluZyBwcm9jZXNzZXMgZXhpdCwgZmlsZXMg
Y2FuIHN0aWxsIGJlIHJlY2xhaW1lZCBub3JtYWxseS4NCj4gPg0KPiA+IFBlcmZvcm1hbmNlIHRl
c3Rpbmcgc2hvd3MgfjgwJSBpbXByb3ZlbWVudCBpbiBVbml4QmVuY2ggZXhlY2wvc2hlbGxzY3Jp
cHQNCj4gPiBzY29yZXMgb24gSHlnb24gNzQ5MCwgQU1EIHplbjQgOTc1NCBhbmQgSW50ZWwgZW1l
cmFsZCByYXBpZHMgcGxhdGZvcm0uDQo+ID4NCj4gDQo+IFRoZSBvdGhlciByZXNwb25kZXJzIGhh
dmUgYmVlbiBhIGxpdHRsZSBoYXJzaCBhbmQgZGVzcGl0ZSByYWlzaW5nDQo+IHZhbGlkIHBvaW50
cyBJIGRvbid0IHRoaW5rIHRoZXkgZ2F2ZSBhIHByb3BlciByZXZpZXcuDQo+IA0KPiBUaGUgYmln
Z2VyIHBpY3R1cmUgaXMgdGhhdCB0aGUgcHJvYmxlbWF0aWMgcndzZW0gaXMgdGFrZW4gc2V2ZXJh
bA0KPiB0aW1lcyBkdXJpbmcgZm9yayArIGV4ZWMgKyBleGl0IGN5Y2xlLiBOb3JtYWxseSB5b3Ug
ZW5kIHVwIHdpdGggNQ0KPiBkaXN0aW5jdCBtYXBwaW5ncyBwZXIgYmluYXJ5L3NvLCBlYWNoIGNy
ZWF0ZWQgd2l0aCBhIHNlcGFyYXRlIGxvY2sNCj4gYWNxdWlyZS4NCj4gDQo+IFNvbWUgdGltZSBh
Z28gSSBwYXRjaGVkIGV4aXQgdG8gYmF0Y2ggcHJvY2Vzc2luZywgbGVhdmluZyAxIGFjcXVpcmUg
aW4NCj4gdGhhdCBjb2RlcGF0aC4gZm9yayBjYW4gYW5kIHNob3VsZCBiZSBwYXRjaGVkIGluIGEg
c2ltaWxhciB2ZWluLCBidXQgSQ0KPiBkb24ndCBrbm93IGlmIHVuaXhiZW5jaCBydW5zIGl0IGlu
IHRoaXMgYmVuY2htYXJrIChpLmUuLCByZWFsDQo+IHdvcmtsb2FkcyBjZXJ0YWlubHkgc3VmZmVy
IGZyb20gaXQsIEkgZG9uJ3Qga25vdyBpZiB0aGlzIHBhcnRpY3VsYXINCj4gYmVuY2ggaW5jbHVk
ZXMgdGhhdCBhc3BlY3QpLiBUaGlzIGlzIG9uIHRvcCBvZiBmb3JraW5nIGl0c2VsZiBiZWluZw0K
PiBhdm9pZGFibGUgc2hvdWxkIHRoZSBrZXJuZWwgZ3JvdyBhIGJldHRlciBpbnRlcmZhY2UgZm9y
IGV4ZWN1dGluZw0KPiBiaW5hcmllcy4NCj4gDQpUaGFuayB5b3UgZm9yIHlvdXIgb3BuaW9ucyBh
bmQgYWR2aWNlcywgSSdsbCB0cnkgdGhpcyB3YXkNCj4gVGhpcyBsZWF2ZXMgdXMgd2l0aCBtYXBw
aW5nIGNyZWF0aW9uIG9uIGV4ZWMuIFRoaXMgcHJvYmxlbSBpcw0KPiB1bmZpeGFibGUgd2l0aG91
dCBpbnRyb2R1Y3Rpb24gb2YgYmV0dGVyIEFQSXMgZm9yIHVzZXJzcGFjZSwgd2hpY2gNCj4gY29u
c3RpdHV0ZXMgcXVpdGUgYSBjaGFsbGVuZ2UuDQo+IA0KPiBUaGUgZW5kIHJlc3VsdCBpcyB0aGUg
YWJzb2x1dGVseSBob3JyaWJsZSBjYXNlIG9mIG11bHRpcGxlIGFjcXVpcmVzIG9mDQo+IHRoZSBz
YW1lIGxvY2sgcGVyIGl0ZXJhdGlvbi4NCj4gDQo+IE9uZSBjb21tb24gaWRlYSBob3cgdG8gcmVk
dWNlIGNvbnRlbnRpb24gYm9pbHMgZG93biB0byBzaG9ydGVuaW5nIGxvY2sNCj4gaG9sZCB0aW1l
LiBUaGlzIGhhcyB2ZXJ5IGxpbWl0ZWQgZWZmZWN0IGluIGZhY2Ugb2YgdGhlIGFmb3JlbWVudGlv
bmVkDQo+IG11bHRpcGxlIGFjcXVpcmVzIGFuZCBpcyBhdCBiZXN0IGEgc3RvcCBnYXAgLS0gbm8g
bWF0dGVyIHdoYXQsIHRoZQ0KPiBjZWlsaW5nIGlzIGRpY3RhdGVkIGJ5IHRoZSBleHRyYSBhY3F1
aXJlcyBhbmQgaXQgaXMgaW5jcmVkaWJseSBsb3cuDQo+IA0KPiBZb3VyIHBhdGNoIGtlZXBzIHRo
ZSBwcm9ibGVtYXRpYyBhY3F1aXJlIHBhdHRlcm4gaW50YWN0IGFuZCB3aGlsZSB0aGUNCj4gODAl
IHdpbiBtaWdodCBzb3VuZCBlbmNvdXJhZ2luZywgdGhlIGVuZCByZXN1bHQgaXMgc3RpbGwgc2V2
ZXJlbHkNCj4gdW5kZXJwZXJmb3JtaW5nIGV2ZW4gYSBzdGF0ZSB3aGVyZSB0aGUgbG9jayBpcyB0
YWtlbiBvbmNlIGluIHRvdGFsDQo+IGR1cmluZyBleGVjLg0KPiANCj4gQmVzaWRlcyB0aGF0LCB0
aGUgaW50ZXJuYWxseS12aXNpYmxlIHNpZGUgZWZmZWN0IG9mIG5vbi1mdW5jdGlvbmFsDQo+IHJt
YXAgaXMgcHJldHR5IGJhZCAoYW5kIHRodXMgZS5nLiwgdHJ1bmNhdGUpIGlzIHByZXR0eSBiYWQg
aW4gaXRzIG93bg0KPiByaWdodCwgYnV0IGxldCdzIGlnbm9yZSBpdC4gVGhlIHByaW1hcnkgcHJv
YmxlbSBoZXJlIGlzIHRoYXQgdGhlIHBhdGNoDQo+IGV4cG9zZXMgYSBtZWNoYW5pc20gZm9yIHVz
ZXJzcGFjZSB0byBkaWN0YXRlIHRoaXMgaW4gdGhlIGZpcnN0IHBsYWNlLg0KPiBFdmVuIGlnbm9y
aW5nIHRoZSBxdWVzdGlvbiBvZiB3aG8gc2hvdWxkIGJlIHVzaW5nIGl0IGFuZCB3aGVuLCB0aGUN
Cj4gcmVhbCBzb2x1dGlvbiB0byB0aGUgcHJvYmxlbSB3b3VsZCBiZSBjb25maW5lZCB0byB0aGUg
a2VybmVsLiBTdXBwb3NlDQo+IHRoaXMgcGF0Y2ggbGFuZHMgYW5kIHN1Y2ggYSBzb2x1dGlvbiBp
cyBpbXBsZW1lbnRlZCBsYXRlciAtLSBub3cgdGhlDQo+IGtlcm5lbCBpcyBzdHVjayBoYXZpbmcg
dG8gc3VwcG9ydCBhIG5vdy11c2VsZXNzIChpZiBub3Qgb3V0cmlnaHQNCj4gaGFybWZ1bCkgZmVh
dHVyZS4NCk9LLiBJIHVuZGVyc3RhbmQgaXQgbm93Lg0KPiANCj4gV2hhdCB3aWxsIGZpeCB0aGUg
cHJvYmxlbSBpcyBzaGFyZGluZyB0aGUgc3RhdGUgaW4gc29tZSBjYXBhY2l0eSwNCj4gcHJvdmlk
ZWQgbm8gdW5maXhhYmxlIHN0b3BnYXAgc2hvd3MgdXAuDQo+IA0KPiBBbnkgb3RoZXIgYXBwcm9h
Y2ggaXMgcHV0dGluZyBzbWFsbCBiYW5kYWlkcyBvbiBpdCBhbmQgY2FuIGJlIGENCj4gY29uc2lk
ZXJhdGlvbiBvbmx5IGlmIHRoZSBkZWNlbnRyYWxpemluZyBsb2NraW5nIGlzIHByb3ZlbiB0b28N
Cj4gcHJvYmxlbWF0aWMuDQo+IA0KPiBQZWRybyBhcHBhcmVudGx5IHZvbHVudGVlcmVkIHRvIGRv
IHRoZSB3b3JrLCBzbyBJIHRoaW5rIHdlIGNhbiB3YWl0IHRvDQo+IHNlZSB3aGF0IGhlIGlzIGdv
aW5nIHRvIGVuZCB1cCBjb29raW5nLg0KPiANCj4gSSBob3BlIHRoaXMgaGVscHMuDQo+IA0KDQo=


