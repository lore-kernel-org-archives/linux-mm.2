Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47590CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 07:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A44E6B0005; Tue, 26 May 2026 03:37:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555666B0088; Tue, 26 May 2026 03:37:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492036B008A; Tue, 26 May 2026 03:37:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 37B486B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:37:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B906D12030A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:37:55 +0000 (UTC)
X-FDA: 84808766910.29.E184616
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1145FA0010
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:37:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L7b0uVcj;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779781074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AFTxR5ySWon/y84xP5MLzZ2dJM80HXA9pXBJd4f3+d8=;
	b=DB5heqMtdHjsYcH4h4ym5KHiziwQvQbbkDaDOoFFaIJJsNmt7lutbu1fh17DdphUkGFL6W
	tI7mnLHmXywVbGUjV3ReFAQo0RpY98OCm7hqPPcUXUUAJZozhbnD+sg/Len2DFGNGbbNm4
	I8SunCHuvc8GzlopMoDsX0Xx94T9njU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779781074; a=rsa-sha256;
	cv=none;
	b=n0JejUxyOo290wiAO0bxtkHNXStwEWS8A+klBmxDJErZA7i+QVd/nz1UO5pQ3HZu7N+Bgo
	p/XVXZ15iBWmM948g5nS1HsaZBG/cP9rfTL1fnOatxrvBhFyCBXrOtsduNmRPTkcoAWf/E
	xLsblu6Uz93GdoKlauG0P7D0ogCx0IU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L7b0uVcj;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 279F2402F1;
	Tue, 26 May 2026 07:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02FC1F000E9;
	Tue, 26 May 2026 07:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779781073;
	bh=AFTxR5ySWon/y84xP5MLzZ2dJM80HXA9pXBJd4f3+d8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=L7b0uVcjAkOy6GkkkR88gUBB1Y8TfGqrfO/PXhNhgTSL0GQqbZkVuPBz5UysPyx2U
	 0gp6a70UEV0QsGiiOL6TquyuyoeX7w+9OOdaF3nF6KvZ7onrw28Ij/Xr4ZHP1ghZQ6
	 qjkT0/tftACmsAUImbZNgoEAOhNyx7bs01LGwyYoY3qY89uXzFTAyXVi/hhdDjesy2
	 BZcTjExidnRRPk8RLBoXiBsLBt9O8dqYZGyGFRTmdXALCQ0nKSrOODxYM/XZPRytxe
	 k7ZWaqRb47UtC8dNtc6D8Pwarv8SL1wpbLUrNhuLc3eE+GdMV2QqPjM/WD9xg77YuR
	 Q6cvr/ZafO4Bg==
Message-ID: <deb9b3eb-2569-48d0-8ecd-f35d78bd8207@kernel.org>
Date: Tue, 26 May 2026 16:37:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: batch-detach node partial slabs
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260525032233.10847-1-hao.li@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260525032233.10847-1-hao.li@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------HGVndVDD6Zf0wBTPu1sTrfOC"
X-Rspamd-Server: rspam11
X-Stat-Signature: hgjfqwnxds8mk8e798thjfeto96rnebt
X-Rspamd-Queue-Id: 1145FA0010
X-Rspam-User: 
X-HE-Tag: 1779781073-321257
X-HE-Meta: U2FsdGVkX1942ba4GQvT7mcXfWq/BccseEi/+QedILXw3Fd0ef30KT0xZTTUjgq9IHrC1eFuV/ep5408OyPcVYWPiTkw9/V0gry3c937T8TgK94M/Rz3wIwd0Kc3IWKDhH6+TkDkFrw3bQ5ZWIoOjy7Ls7obqC4VBlCiUlmjyOMKXOj7yP4KeksS80BlVrEeL+Mt1m8HRjNgumDbGPTpEm49CYqpPyENt8zG6HRRkHvismoAwWnV5G6bPhlWwC3Q+LAn9dn5UVa+9MC0NWr1cU9AWjraG6LSppRDExLpnNLxpcxFKrheGIqJ68pTahCmRxKnOR/DtYtQF6sL6fer16NAIjpEr9Phf7a1Mh6Ek6aYtw2l13NFqzbaPEt8kXjQ7RPzmkJCMtcFzklXddBCbbFD4Q0FkrQwTE0EghBnG6zHp34s8S7534j9xLrkkjPDcVS44sBDl35pIv+0Dwi1A+88jihNj+miygPs4M1q+DnVk3FajEtp2VJ/3vIA/TkiDp/PpoHkj9Bp8pPnCK3AFqT5Y/ReQUwJr1pTc/H1o49+Yps/V4eqZ76vOhKE9uOoB1SJ/uqWv2mpoyL2yO9HnjLUKtYiJELgowfcoW+qQt1DXX4VpjHksWd5BdTFXMhP5/8rPa507T6NXfNeYD7oUPq1iqX5I3UIxpzwZPj0dBruorYxkdUplB+gG2+e49VfoIGPG38bI2zk/fqHCYN6V9ztT3BPt2q/HGsTy/rQkYyW+tXRxt6quhZqvmPN0osxV1AbFs7cDaymqxbK4m5URgt0lJF+O2FKXKKgQQi2l6Rk9Pn4pKMq6G+n1yiYPSD1BCYX1JlPtcG6h/zxaEK5dfwtGvqBNTN6EiZ1HdN2f5el+KrmCgD+bIpP/kzjoOlPtkG1CCQ7qO53vl20kIZrLSspcebiz/hJmAdX2h+6GXz1S2Sujs0rUC6DbaJbVWBHv8Rzjdm3Aa3QWRHH3MW
 z6Flvc2v
 S2xHj6je+owQzDi++fxWyPf6AKSHWM2micOJJvIHwd4F51yWVwMy6Z5ImgUclxcFNPISmgPqBR2PzulyXTWCCx0HtfjTRYlu8cZVNC8FPlIw7d4riGL43tI7dYMplUqjMW1/3gEePlvThghSIDQNop12FpUPmduk2hAxKeAoM3V9HZ5MseHr2N9lObElC9PiZFFwETv3cMQnm25oUZoDLlWjbCcqpqGHElzSbj5OC99KLV3EBUQrcewg2/cTmvGnXVPiDjJmeAeE4gKpR7YArDBwePCovgbIJhBcDoigOwY/zMTZ8EIbME/V6nJZSZYTmVsebu80xELTqV0/kgbHTg1DCHinvk/815M0lrxghX12UzSoiqNYulVT7MhlJIogCRE7WY6A42D16u3yi+f+B4hnUuzFcCBuif8ePuYyLuy0oxSoF44hChePUdnCGFnV0J6rCdHe+jF/DSI506NoYlbZbTCPTbSh2A2otcpdQf2qIcGgZdyF74kCvZW24o/y2iTVuvXvGtG/p2J9exmSYb0v8ITICxVrlU8kC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------HGVndVDD6Zf0wBTPu1sTrfOC
Content-Type: multipart/mixed; boundary="------------0pfAF50SZy9x3xfzcCG09C7w";
 protected-headers="v1"; hp="clear"
Message-ID: <deb9b3eb-2569-48d0-8ecd-f35d78bd8207@kernel.org>
Date: Tue, 26 May 2026 16:37:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: batch-detach node partial slabs
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260525032233.10847-1-hao.li@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260525032233.10847-1-hao.li@linux.dev>

--------------0pfAF50SZy9x3xfzcCG09C7w
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

DQoNCk9uIDUvMjUvMjYgMTI6MjIgUE0sIEhhbyBMaSB3cm90ZToNCj4gZ2V0X3BhcnRpYWxf
bm9kZV9idWxrKCkgdXNlZCB0byBtb3ZlIGVhY2ggc2VsZWN0ZWQgc2xhYiBmcm9tIHRoZSBu
b2RlDQo+IHBhcnRpYWwgbGlzdCB0byB0aGUgbG9jYWwgcGMtPnNsYWJzIGxpc3QgdXNpbmcg
YSByZW1vdmVfcGFydGlhbCgpIGFuZA0KPiBsaXN0X2FkZCgpIHBhaXIuIEluIHByYWN0aWNl
LCB0aGUgbG9vcCBvZnRlbiBkZXRhY2hlcyBzZXZlcmFsIGFkamFjZW50DQo+IHNsYWJzLCBz
byB0aGlzIHJlcGVhdGVkbHkgbWFuaXB1bGF0ZXMgbGlzdCBwb2ludGVycyB3aGlsZSBob2xk
aW5nDQo+IG4tPmxpc3RfbG9jaywgd2hpY2ggY2F1c2VzIHVubmVjZXNzYXJ5IGNodXJuLg0K
PiANCj4gSW5zdGVhZCwgdHJhY2sgY29udGlndW91cyBydW5zIG9mIG1hdGNoaW5nIHNsYWJz
IGFuZCBtb3ZlIGVhY2ggcnVuIHdpdGgNCj4gbGlzdF9idWxrX21vdmVfdGFpbCgpIGluIG9u
ZSBvcGVyYXRpb24uDQoNClRJTCBsaXN0X2J1bGtfbW92ZV90YWlsKCkgOkQNCg0KID4gVGhp
cyByZWR1Y2VzIGxpc3QgcG9pbnRlciBjaHVybj4gaW5zaWRlIHRoZSBsb2NrIGNyaXRpY2Fs
IHNlY3Rpb24uDQoNClNpbWlsYXIgdG8gdGhpcywgY2FuIHdlIHJldHVybiBhbGwgc2xhYnMg
aW4gcGMtPnNsYWJzIGF0IG9uY2Ugd2hlbiANCnJldHVybmluZyB0aG9zZSBzbGFicyB0byB0
aGUgbGlzdD8gLi4uIEkgc2VlIFZsYXN0aW1pbCByZW1vdmVkICduciBvZiANCmVtcHR5IHNs
YWJzJyBjaGVjayBpbiB0aGUgb3RoZXIgc2VyaWVzIGFscmVhZHkuDQoNCk5vdyB0aGF0IGl0
IGluc2VydHMgc2xhYnMgdG8gdGhlIHRhaWwgd2l0aCBWbGFzdGltaWwncyBwYXRjaHNldCwg
bGV0J3MgDQpkbyBhIGxpc3Rfc3BsaWNlX3RhaWwoKSBpbnN0ZWFkPw0KDQo+IFRoZSBtbWFw
MiB0ZXN0Y2FzZSBzaG93cyBhIDUlIGltcHJvdmVtZW50IGFmdGVyIGFwcGx5aW5nIHRoaXMg
cGF0Y2guDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBIYW8gTGkgPGhhby5saUBsaW51eC5kZXY+
DQo+IC0tLQ0KPiAgIG1tL3NsdWIuYyB8IDIyICsrKysrKysrKysrKysrKysrKy0tLS0NCj4g
ICAxIGZpbGUgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9tbS9zbHViLmMgYi9tbS9zbHViLmMNCj4gaW5kZXggMDQ2OTJh
NmY5MTI4Li4xODA5NzNhNGEzZDIgMTAwNjQ0DQo+IC0tLSBhL21tL3NsdWIuYw0KPiArKysg
Yi9tbS9zbHViLmMNCj4gQEAgLTM3NzUsMTUgKzM3ODMsMjEgQEAgc3RhdGljIGJvb2wgZ2V0
X3BhcnRpYWxfbm9kZV9idWxrKHN0cnVjdCBrbWVtX2NhY2hlICpzLA0KPiAgIAkJICAgICYm
IHRvdGFsX2ZyZWUgKyBzbGFiX2ZyZWUgPiBwYy0+bWF4X29iamVjdHMpDQo+ICAgCQkJYnJl
YWs7DQo+ICAgDQo+IC0JCXJlbW92ZV9wYXJ0aWFsKG4sIHNsYWIpOw0KPiAtDQo+IC0JCWxp
c3RfYWRkKCZzbGFiLT5zbGFiX2xpc3QsICZwYy0+c2xhYnMpOw0KPiArCQlpZiAoIWZpcnN0
KQ0KPiArCQkJZmlyc3QgPSBzbGFiOw0KPiArCQlsYXN0ID0gc2xhYjsNCg0KPiArCQlzbGFi
X2NsZWFyX25vZGVfcGFydGlhbChzbGFiKTsNCj4gKwkJbi0+bnJfcGFydGlhbC0tOw0KDQpQ
ZXJoYXBzIGZhY3RvciBvdXQgdGhvc2UgdHdvIHN0YXRlbWVudHMgaW50byB0byBhIGNvbW1v
biBmdW5jdGlvbiBhbmQgDQpjYWxsIGl0IGluIGdldF9wYXJ0aWFsX25vZGVfYnVsaygpIGFu
ZCByZW1vdmVfcGFydGlhbCgpPw0KPiAgIAkJdG90YWxfZnJlZSArPSBzbGFiX2ZyZWU7DQo+
ICAgCQlpZiAodG90YWxfZnJlZSA+PSBwYy0+bWF4X29iamVjdHMpDQo+ICAgCQkJYnJlYWs7
DQo+ICAgCX0NCj4gICANCj4gKwlpZiAoZmlyc3QpDQo+ICsJCWxpc3RfYnVsa19tb3ZlX3Rh
aWwoJnBjLT5zbGFicywgJmZpcnN0LT5zbGFiX2xpc3QsDQo+ICsJCQkJICAgICZsYXN0LT5z
bGFiX2xpc3QpOw0KPiArDQo+ICAgCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJm4tPmxpc3Rf
bG9jaywgZmxhZ3MpOw0KPiAgIAlyZXR1cm4gdG90YWxfZnJlZSA+IDA7DQo+ICAgfQ0KDQot
LSANCkNoZWVycywNCkhhcnJ5IC8gSHllb25nZ29uDQoNCg==

--------------0pfAF50SZy9x3xfzcCG09C7w--

--------------HGVndVDD6Zf0wBTPu1sTrfOC
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEARYKADkWIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCahVNyhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwwLDMACgkQhlwTeq3OUtYYUAD/Z0OseCqkH5KbGYeiskGQ
p7hT71SJvXCQgt0B+etSczIBAPG43Z+2a6Dwq2vZv3c6h+L6ockKJ5pg9DPA4MEI
Zb4H
=9Vi6
-----END PGP SIGNATURE-----

--------------HGVndVDD6Zf0wBTPu1sTrfOC--

