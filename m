Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9959CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 01:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12016B01A0; Sun, 31 May 2026 21:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2836B01A1; Sun, 31 May 2026 21:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8A886B01A2; Sun, 31 May 2026 21:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1DB36B01A0
	for <linux-mm@kvack.org>; Sun, 31 May 2026 21:28:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5EBF61C087D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:28:39 +0000 (UTC)
X-FDA: 84829609158.26.160E0E7
Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	by imf04.hostedemail.com (Postfix) with SMTP id E7FE940008
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:28:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=Z+pYqbKm;
	spf=pass (imf04.hostedemail.com: domain of "prvs=md160644C0C7=lirongqing@baidu.com" designates 220.181.50.185 as permitted sender) smtp.mailfrom="prvs=md160644C0C7=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780277317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3N3V29pMushKp1K2JrVyDY0/Gr3rXOOVNFYfNNJgcQ=;
	b=FxVai3jg6osh7rOmG/d7NytbBGGl6LJ9AFwdanICa46vXtbHmFBCWpum9rOYMnPz2QLvnS
	H5yEhf5mtoqgApO48UYw/+PsE8JD057F/G0snJBQuRTQDEcn8mFTNFb5jUEhEMC6aTZPf8
	v3gwiW4qyLz08BD1Fqjz+xi5xfa2Fss=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=Z+pYqbKm;
	spf=pass (imf04.hostedemail.com: domain of "prvs=md160644C0C7=lirongqing@baidu.com" designates 220.181.50.185 as permitted sender) smtp.mailfrom="prvs=md160644C0C7=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780277317; a=rsa-sha256;
	cv=none;
	b=aWvJZSq1H9wJeMXfE6YCiwh79ROTQS+V0I4W/TFsDmnllkuvoebFFtRjOzZttl9lt9mdJw
	lJm9BsvjTF+m/ftYBL1ZmSjWWeyc9Vx6FRpLjsXJ3KarEq+EveXXF4kYh6Io+E7nn9Lv3L
	Msx6RgujVu8X7Dud/Ds7nUpe+thShrc=
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.3.12
From: "Li,Rongqing(ACG CCN)" <lirongqing@baidu.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Usama Arif
	<usama.arif@linux.dev>
CC: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Hao
 Li" <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes
	<rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTogW+WklumDqOmCruS7tl0gUmU6IFtQ?=
 =?utf-8?B?QVRDSF0gbW0vbWVtcG9vbDogdXNlIHN0YXRpYyBrZXkgZm9yIGJvb3QtdGlt?=
 =?utf-8?Q?e_debug_enablement?=
Thread-Topic: =?utf-8?B?562U5aSNOiDnrZTlpI06IFvlpJbpg6jpgq7ku7ZdIFJlOiBbUEFUQ0hdIG1t?=
 =?utf-8?B?L21lbXBvb2w6IHVzZSBzdGF0aWMga2V5IGZvciBib290LXRpbWUgZGVidWcg?=
 =?utf-8?Q?enablement?=
Thread-Index: AQHc7cYaHc/KlS0U5Emb14FdSgycW7YhUMwAgAFsxkD///uqgIAAiCNA//+gpYCAAVpxgIAEs1yw
Date: Mon, 1 Jun 2026 01:28:15 +0000
Message-ID: <d22239c31657481483e25ab347231d53@baidu.com>
References: <20260527104634.2434-1-lirongqing@baidu.com>
 <20260527130337.983366-1-usama.arif@linux.dev>
 <fcf5585aba18414cbd0ab01935eeb1df@baidu.com>
 <ddb499d5-6821-4fa7-9fec-563bdfbc8cbc@linux.dev>
 <b9d53cb0be024778b09e1bb1ef7d0211@baidu.com>
 <6ca2af4a-90ed-4d7e-9c21-42ebffddc3fe@linux.dev>
 <2c1b8eff-f613-4407-b5f3-4d8b12d34321@kernel.org>
In-Reply-To: <2c1b8eff-f613-4407-b5f3-4d8b12d34321@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.31.62.19]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1780277309;
	bh=k3N3V29pMushKp1K2JrVyDY0/Gr3rXOOVNFYfNNJgcQ=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=Z+pYqbKmNIAo4+VHcQDGerokfxs1sLQBIYcgRYluISe9F9mHtBG23Kbwi3GfCkwIe
	 LPq5q6x5pnNb2ImzT1bqdjmai6exOP2yN3G9XqWXJ4CBvu0118D6grhq1ZPBCSjY7b
	 ZMVknPAD+1AOkQyfWB3oqckSy7p+ypYCwSa/Gp20ZFoEsmCMF6pK/ZsGbHNU9kVx6N
	 cVV5xGgEn23yrm1/WfhSwM31DlYEK8ErKf0vrJG+g/rIDUClqEy1fxHuL5nVbtQwcV
	 xahYNAb8wRohLSSYKOhG5eByi01IsOtHEl7iBja4I63UHA3dj7ih+P61y/zfyWRhoT
	 QP0Y26xJKQLqA==
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E7FE940008
X-Stat-Signature: 3s6pzp3a1htbfrd3buezpujnw9ttb8ke
X-HE-Tag: 1780277313-557212
X-HE-Meta: U2FsdGVkX1+hx8GFqCvKT0zv5p2FHNpBXwpnsUMnezr5yjYif96TvX6jZ2WiGHF8UGE+/3OwTQD/kACmY6NvXF0lzzfmKwOlq6ziad4QzOPlHXiLtq8jY9vYVN3ly6ZuhAS6wq//27Q1xVc412Z3sFs0dRnGgvXRiyjgIu/NvJyYKDcaNEl42iJimQ0rqk2Elye978mg0KVuQHQn8aHEXecFRL/UZ55FAc1PePs7PH4qV6xVNS66ykK7wQ96epE+5rmXaO64K7sBCkg+ALzaTCOtYu/Qg997ndcsp/aLEGg1p2HReL0EghlA+ukARnXsWW4h7vwosY7B2y27LvyieDwjSZ5KnLbaaLJ3dpc8tOmUMtws9mbw3dG8WH3leRkhkqbGPlRC7dRITgfAuDiiBTyn9VmA/a5CWIfFEXLZCbeM7Kq5CwXDBj02eQffC3WYmp8d5dLLTBvg/0ZyTCFIi3rRUoONs1BIL49exeRMD6iwqk+Tat3DIo763p5kUW1nD7LVWuHzH8UyuzDZixeVAvNCHRwOb5HJ4bUpEQUEbcxjNhG+k/48AT7/46UNxql+czal0oiOlLSc2cRIVonmy/22GFd0sBCy8BCu98sTXN5zPQqSgavnydT/71XeMzvfxymMVXIdL7PZ33zOHKtCJBYascIcxf/9HRaAbXmVs2IFj4xoC2olER7tRrOnsgVhKWWM3D83INoE/Fpbve6egPssOQ0sFJ0DI4OnqTDP3P7IijO2vMC/tUSoD8MJ/zyNI6l/C3mbvyaKEl0bZHOGZeV/OyyeB55vKT+pKoxtBfgdQW77AqkG6Qo+3IWOL8bAG9YpAp+jopjAazMoo2lP1+zer/4hnZUR5zdaJq6GuWbIeL/X7FcxV/5+3ZKhszo6ukDm6DDtWeYdV72AUcacdtnIHP5v1OWXY+MUhACPR3GubvsxaiSOMt8GWhK0lQyHRYJ24FZMReJwBIfS7FL
 ytLcW/rC
 iBL8kBfys/7KqxsyN0TQMP14DXhu9JqFJL/7hLRDX81W04ZYmm5Z76ck1qw5MXVkWxen7CE1CvqGuJY/vDGnHYAo21sMxuhQLZqnV4X2PnrVrE/Er4LWqlz55MCtk1VUgBqAL1t8wOwh7feSS6UR7a+R+04meLqFKOppQro414xf6vpbhKEFeT26BzYdAXNunbVAIvNmSI6itfqQHkyXc0cVxnUEv77CEkkpujabUg2HLioHZk5hyHn6lzOkp+N3pd+Gpy0ld4dAqH1nofsWNEOwPNd7b++3Gkal2yRUBgOnkk/Y3O1Xexd+M+YosQ1NyY9ZiM1wqS4k3U8qKzJb3yRxQAXIWKwuoy+CVvt5kH9BMfqW3MPfNv0vprBkfm9MeNB5CMqkR+I5g7ucRwLVndMvRDB3GrmVWPcyiBCIZ15wunpjg/VKc0HG1IHFjTfNjqXbkVtDbFAU8oipaApsIRaeksW1d8uuHx7yPdstRsF8uYrgHp11/ic2Nm3zWioTKHqY6l18BTT6nKdM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBPbiA1LzI4LzI2IDE0OjU5LCBVc2FtYSBBcmlmIHdyb3RlOg0KPiA+DQo+ID4NCj4gPiBPbiAy
OC8wNS8yMDI2IDExOjUwLCBMaSxSb25ncWluZyhBQ0cgQ0NOKSB3cm90ZToNCj4gPj4NCj4gPj4N
Cj4gPj4+DQo+ID4+PiBPbiAyOC8wNS8yMDI2IDA0OjAwLCBMaSxSb25ncWluZyhBQ0cgQ0NOKSB3
cm90ZToNCj4gPj4+DQo+ID4+PiBJIHRoaW5rIDMyIGJpdCBBUk0gZG9lc250Pw0KPiA+Pg0KPiA+
PiBZb3UgYXJlIHJpZ2h0LCAzMi1iaXQgQVJNIGRvZXNuJ3QuDQo+ID4+DQo+ID4+IEhvd2V2ZXIs
IHRoZSBjb3JyZWN0IGFyY2hpdGVjdHVyYWwgYXBwcm9hY2ggc2hvdWxkIGJlIGZpeGluZyB0aGUg
Ym9vdA0KPiA+PiBzZXF1ZW5jZSBpbnNpZGUgYXJjaC9hcm0vIHRvIG1hdGNoIGFybTY0ICwgcG93
ZXJwYyBhbmQgbTY4aywgcmF0aGVyDQo+ID4+IHRoYW4gY29tcHJvbWlzaW5nIGNvcmUgTU0gY29k
ZSB3aXRoIHRlbXBvcmFyeSBib2lsZXJwbGF0ZSB2YXJpYWJsZXMuDQo+ID4+DQo+ID4+IEkgcHJl
ZmVyIHRvIGtlZXAgdGhlIG1lbXBvb2wgaW1wbGVtZW50YXRpb24gY2xlYW4uIElmIEFSTTMyIHRy
aWdnZXJzDQo+ID4+IHRoZSB3YXJuaW5nLCB0aGUgcHJvcGVyIHJlbWVkeSBpcyBhIGZvbGxvdy11
cCBwYXRjaCB0byBhbGlnbiBpdHMNCj4gPj4gc2V0dXBfYXJjaCgpIG9yZGVyaW5nLg0KPiA+Pg0K
PiA+PiBXaGF0IGRvIHlvdSB0aGluaz8NCj4gPj4NCj4gPg0KPiA+IEkgdGhpbmsgaXQgd291bGQg
YmUgYSBwcmVyZXF1aXNpdGUgcmF0aGVyIHRoYW4gYSBmb2xsb3cgdXAgcGF0Y2gNCj4gPiBpbm9y
ZGVyIHRvIG5vdCBicmVhayAzMiBiaXQgYXJtLiBJIHdpbGwgbGV0IEFSTSBhbmQgc2xhYiBtYWlu
dGFpbmVycyBkZWNpZGUNCj4gb24gdGhpcy4NCj4gDQo+IFllYWggd2Ugc2hvdWxkbid0IGp1c3Qg
a25vd2luZ2x5IGJyZWFrIGl0Lg0KPiBCdXQgSSBraW5kIG9mIGRvdWJ0IHRoZSBhcmd1bWVudCB0
aGF0IGNydWNpYWwgbWVtcG9vbCBhbGxvY2F0aW9ucyBoYXBwZW4NCj4gdGhhdCBlYXJseSBpbiB0
aGUgYm9vdCBhbmQgd2UgY291bGQgbWlzcyBlcnJvcnMgaW4gdGhlbT8gVGhleSBhcmUgbW9zdGx5
DQo+IHN0b3JhZ2UgZHJpdmVycywgQUZBSUNTLiBTbyBJIGRvbid0IHRoaW5rIHdlIG5lZWQgdGhl
IGRlYnVnZ2luZyB0byBiZSBlbmFibGVkDQo+IGVhcmx5Lg0KPiANCkFmdGVyIHNvbWUgZ3JlcCBp
biBrZXJuZWzvvIxJIGFncmVlIHdpdGggeW91LiANClVzaW5nIF9fc2V0dXAgc2hvdWxkIGJlIHBl
cmZlY3RseSBmaW5lIGZvciB0aGlzIG1lbXBvb2wgcGFyYW1ldGVyLg0KDQpUaGFua3MgDQoNCltM
aSxSb25ncWluZ10gDQo=

