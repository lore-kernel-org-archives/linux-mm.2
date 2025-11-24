Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F4A6CFD365
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 23:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916D76B000C; Mon, 24 Nov 2025 18:31:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7776B000D; Mon, 24 Nov 2025 18:31:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6376B0022; Mon, 24 Nov 2025 18:31:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 62CFD6B000C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:31:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 882674F977
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 23:31:07 +0000 (UTC)
X-FDA: 84147098574.06.2761ADD
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf01.hostedemail.com (Postfix) with ESMTP id D32D840011
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 23:31:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=HvRYMXjB;
	spf=pass (imf01.hostedemail.com: domain of "prvs=41621b596=ilstam@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=41621b596=ilstam@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764027065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aisn6Pk8NA/+cMWU/3Y8SP19PewgjB2juoIqZj4cvsc=;
	b=GPvCzJzozldeV98duGl72DaNzETEskga77HY7kIa5SpVi6RSKtmErC0N6sCadt9uxilwFZ
	V+pzd7MmZ1RVlSDVdIrjPskeFP1uWAXThn8XtryXigmltJpRd4lGEE9VCRWK4nVo89tjEG
	2aZGK+clEbegEDsFzNSDd3AnmHKTCeg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=HvRYMXjB;
	spf=pass (imf01.hostedemail.com: domain of "prvs=41621b596=ilstam@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=41621b596=ilstam@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764027065; a=rsa-sha256;
	cv=none;
	b=q2nCzm9UHYxfOub/ZNGBgsNm5XvWinM1mV8FTTQFnJGGD2ji5CP+NnQArqbBhddeVVMxq5
	/ppH/XVI2Xlp+SR9chVPogtUgErcVCTOGtP0EPPIut6BmQI3y18riBEdWovexD9Rsn7dH+
	Jv87Dv7TNe7bdGs4RwFde4whKLBbAcc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1764027064; x=1795563064;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aisn6Pk8NA/+cMWU/3Y8SP19PewgjB2juoIqZj4cvsc=;
  b=HvRYMXjBsPI1+xwQykOLAyxb2UAl1gvKVL210/wjiypISIWR0qzL7GSS
   /jKSZxobHBz2DvPgECqsvFHzU197jz7te7Yo6oIbxeIfmwon+rQsZDR+z
   SRsICeVD0acjnlsN0m+V7CZypdF7oWOTqrS2pSEpjotW3cTuaZfMzNvrH
   Ic4wbZ9ikqCCl9lvkfsRI4XIuY3SyQiQVoV/jd8d+YaLd2b/RCf4FiUti
   AIzUEjI8pdifrVIx7kHIxsPvSE0oSW4iJ3ii7INKMQpT7KajhfSm2FCh/
   cp05Eh2uU2xVzsdexW4S86cJVNgCZ/6pd2wMd7L1WTCSz8CTeUqXJz73Z
   w==;
X-CSE-ConnectionGUID: 1B8FQPzgTlWU3G1B3tbuHQ==
X-CSE-MsgGUID: zCznPV5BR0OjzYpfMl70nA==
X-IronPort-AV: E=Sophos;i="6.20,224,1758585600"; 
   d="scan'208";a="5626380"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 23:30:47 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:12552]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.21.117:2525] with esmtp (Farcaster)
 id 5a4667fc-053e-44c3-ac8d-4ece5559f81e; Mon, 24 Nov 2025 23:30:47 +0000 (UTC)
X-Farcaster-Flow-ID: 5a4667fc-053e-44c3-ac8d-4ece5559f81e
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Mon, 24 Nov 2025 23:30:46 +0000
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Mon, 24 Nov 2025 23:30:46 +0000
Received: from EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1]) by
 EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1%3]) with mapi id
 15.02.2562.029; Mon, 24 Nov 2025 23:30:46 +0000
From: "Stamatis, Ilias" <ilstam@amazon.co.uk>
To: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
CC: "nadav.amit@gmail.com" <nadav.amit@gmail.com>, "david@kernel.org"
	<david@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"huang.ying.caritas@gmail.com" <huang.ying.caritas@gmail.com>,
	"bhe@redhat.com" <bhe@redhat.com>, "nh-open-source@amazon.com"
	<nh-open-source@amazon.com>
Subject: Re: [PATCH] Reinstate "resource: avoid unnecessary lookups in
 find_next_iomem_res()"
Thread-Topic: [PATCH] Reinstate "resource: avoid unnecessary lookups in
 find_next_iomem_res()"
Thread-Index: AQHcXXPvH1LA4deF/EiE1v+Bldr5grUCN+QAgAAFBoCAADzNAA==
Date: Mon, 24 Nov 2025 23:30:46 +0000
Message-ID: <de5d9d0658a8966ad8e523a84185398c216726fc.camel@amazon.co.uk>
References: <20251124165349.3377826-1-ilstam@amazon.com>
	 <20251124085816.07dbf5a4ec6235b2943840a0@linux-foundation.org>
	 <c7411175b332f3befb5bebb6a75c7b91f2c1dbbc.camel@amazon.co.uk>
	 <aSSqIzJWKTe9hs2f@smile.fi.intel.com>
	 <f3fe7efd74c6011ddb35e1f1e90eba43af864aa4.camel@amazon.co.uk>
	 <aSS3kXfoBppO1a-Q@smile.fi.intel.com>
In-Reply-To: <aSS3kXfoBppO1a-Q@smile.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.106.83.8]
Content-Type: text/plain; charset="utf-8"
Content-ID: <39FD5075390C944E959E693449CB2E76@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D32D840011
X-Stat-Signature: zfzgw6554z7zq48pn739okt91gcwhf36
X-Rspam-User: 
X-HE-Tag: 1764027064-778778
X-HE-Meta: U2FsdGVkX1+Z0Ah0RH0Ito7rdkW1dxRt5RtZA5E9Uf3KgWWP5aFXLvaQepOv1PmD69n6SKBVuts4Z+ti3e8LpTk8/QD9DPOZ/DmdSi9FmymKhngsJsHTzmSoWXuuRjnxQZ00ZXGAYRAHkNjFevg8z8l2LyzStHevwoP96RqTic11FAyMs97XoF5/6YbXomR0moIiqddk1CWtR5UTz90IIswvz3/jKZQsaq7fgqxdop9CPzTVI4tEbZpPJ3qNpVA/EuVKCaCQ80sGQdog3b8m7Xv4d62AtRJ66rHUo4zKyHPJCeoHgAJQ1xCu1JLl9bOqd1MZqnE6HSEmXXvmmoPN5xScH3JMXArzww3HXbDtQbMGV8hQcvQsJsKc5pPBfpRSEOY7DOQ37e/NF/4hyq7eQkPSC5ogOsJyJ5TnO3DiZbbcnzqg552bCXJ4EQe3GXtAivbcLJVCiNb3C5X0dzfyEOVrDc5wyaaYrqVAOQTyZ9lkc2clna53/SEtrRisWKImM6cO/zYDKqvlCl6ZLGOOz34MJZHIzM7dppAVD3wAdq+QpmXZYk1NG/4V7Z3/XAra1nIvRbQOsmsZ7RJhIWDe7gnj697HRvhbEw+749A/EduRo3AQlLwsQifCwJHs6wQdOEhXwNcIFG8ge/VpYgoOfZdvsloKZCLvXcf3B0cRkAw39Yr8PDwRU5GNJ62u+yrkWaEEMUZe0djLG8KlD5WOeWmxi9foE+VN/VdfXgYkMG+HWV7xv5OlpwMir7vKkPf7c/xrclKgj5hBf0Y4Py85IhJdSWgHCme737PkgU1TbZ7Spt8rkfTi6J6isAE6gAteS3JpyVOX940p2gjRXstbMZQUPT4Lxyz4NINQ4bcRaqlqsWxkNd8CLqldnVj+GjXZVYEpR32EOcvFJiAEIhz5UyhT7VRGwDeWfdVw+w20K3jsQc3bW8HHiYDU3iGKXWOBr2LqOPoKxGh4V3A33xB
 m8ZL+yIX
 BVXfNk8eqYzgQzEEX8sgIt3SbCZtTaPrs1KntMsKEzVp6Jr+EApBVWM9cqA3pnknwtiU9LL+qibIdQS/1YhMymdWat3kMZiP+hZq0G7cmEMtnZAG5AzhoWiaynzYVZRr4/bY6nB3mmB6/d4wyuzbg/v7ePWKCyTpMyk5WhfyWWru1+k6xkIoIHEs65LxiF42LGqDu1t4n32+EqD753YjShmV5INZ3ck/7YDJerFbzLgIWrDbZfPgnwS+BTdKUJ2U8odvZp3GtLo3sUDCy5gXMnHTR+KRP4mPZZqqvWT4UY1wUpSZh3r4DUB9y+cofWDVvpr4mfvVoWCB2t3vKi6n/6irL1yGYXtPvE5fCdgeYoMAyOnhsLeOAWtXce2Hy3rvXy7lGBCZDbneSooLqYlD2cPyrcwX1eEtPn0B+FVbDWdIshRyehF+J6X3vTH82w8QRo10XGCffYpZBefF5OGNt7wm55gMTOaUrcphIenBcBZ7YHKo+fCTy+OVNyiaA7aZ+k3105daMTTBg9JZNCbx56p9VqYjaJEerO713+/cZIbIrzJSn4mVQXKJCD/4YpQvjmrBqJY+iPz5p06wztWo4KikkBilxWva0v2VvABfUBKo+uYctyL4cvDy0Lt2oKKxEEPj28UTppvGCftTusT9BAqHxsk2bcToeGvRkYnq7PZFJfA0xznv2kEe39REj1WMhLJGCo37AWoAy4+og16tmKFfVlNQnm5NZc0B4PJWMa77q5sjs60TmDzOrMQhWQQFrsz2wU+gPSv+zA6WoE1DZ8tC1WYQbn6O+Zny1o21vi0h7qVnsm34N3VaPBf/4MJ8eSrQIUo6LlyjTm/WaN2gwwFV4NyJnqqnAdTueJwutp4H10NA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gTW9uLCAyMDI1LTExLTI0IGF0IDIxOjUyICswMjAwLCBhbmRyaXkuc2hldmNoZW5rb0BsaW51
eC5pbnRlbC5jb20gd3JvdGU6DQo+IE9uIE1vbiwgTm92IDI0LCAyMDI1IGF0IDA3OjM1OjMxUE0g
KzAwMDAsIFN0YW1hdGlzLCBJbGlhcyB3cm90ZToNCj4gPiBPbiBNb24sIDIwMjUtMTEtMjQgYXQg
MjA6NTUgKzAyMDAsIGFuZHJpeS5zaGV2Y2hlbmtvQGxpbnV4LmludGVsLmNvbSB3cm90ZToNCj4g
PiA+IE9uIE1vbiwgTm92IDI0LCAyMDI1IGF0IDA2OjAxOjM1UE0gKzAwMDAsIFN0YW1hdGlzLCBJ
bGlhcyB3cm90ZToNCj4gPiA+ID4gT24gTW9uLCAyMDI1LTExLTI0IGF0IDA4OjU4IC0wODAwLCBB
bmRyZXcgTW9ydG9uIHdyb3RlOg0KPiA+ID4gPiA+IE9uIE1vbiwgMjQgTm92IDIwMjUgMTY6NTM6
NDkgKzAwMDAgSWxpYXMgU3RhbWF0aXMgPGlsc3RhbUBhbWF6b24uY29tPiB3cm90ZToNCj4gPiA+
ID4gPiANCj4gPiA+ID4gPiA+IENvbW1pdCA5NzUyM2E0ZWRiN2IgKCJrZXJuZWwvcmVzb3VyY2U6
IHJlbW92ZSBmaXJzdF9sdmwgLyBzaWJsaW5nc19vbmx5DQo+ID4gPiA+ID4gPiBsb2dpYyIpIHJl
bW92ZWQgYW4gb3B0aW1pemF0aW9uIGludHJvZHVjZWQgYnkgY29tbWl0IDc1NjM5ODc1MGUxMQ0K
PiA+ID4gPiA+ID4gKCJyZXNvdXJjZTogYXZvaWQgdW5uZWNlc3NhcnkgbG9va3VwcyBpbiBmaW5k
X25leHRfaW9tZW1fcmVzKCkiKS4gVGhhdA0KPiA+ID4gPiA+ID4gd2FzIG5vdCBjYWxsZWQgb3V0
IGluIHRoZSBtZXNzYWdlIG9mIHRoZSBmaXJzdCBjb21taXQgZXhwbGljaXRseSBzbyBpdCdzDQo+
ID4gPiA+ID4gPiBub3QgZW50aXJlbHkgY2xlYXIgd2hldGhlciByZW1vdmluZyB0aGUgb3B0aW1p
emF0aW9uIGhhcHBlbmVkDQo+ID4gPiA+ID4gPiBpbmFkdmVydGVudGx5IG9yIG5vdC4NCj4gPiA+
ID4gPiA+IA0KPiA+ID4gPiA+ID4gQXMgdGhlIG9yaWdpbmFsIGNvbW1pdCBtZXNzYWdlIG9mIHRo
ZSBvcHRpbWl6YXRpb24gZXhwbGFpbnMgdGhlcmUgaXMgbm8NCj4gPiA+ID4gPiA+IHBvaW50IGNv
bnNpZGVyaW5nIHRoZSBjaGlsZHJlbiBvZiBhIHN1YnRyZWUgaW4gZmluZF9uZXh0X2lvbWVtX3Jl
cygpIGlmDQo+ID4gPiA+ID4gPiB0aGUgdG9wIGxldmVsIHJhbmdlIGRvZXMgbm90IG1hdGNoLiBS
ZWluc3RhdGluZyB0aGUgb3B0aW1pemF0aW9uIHJlc3VsdHMNCj4gPiA+ID4gPiA+IGluIHNpZ25p
ZmljYW50IHBlcmZvcm1hbmNlIGltcHJvdmVtZW50cyBpbiBzeXN0ZW1zIHdpdGggdmVyeSBsYXJn
ZSBpb21lbQ0KPiA+ID4gPiA+ID4gbWFwcyB3aGVuIG1tYXBpbmcgL2Rldi9tZW0uDQo+ID4gPiA+
ID4gDQo+ID4gPiA+ID4gSXQgd291bGQgYmUgZ3JlYXQgaWYgd2UgY291bGQgcXVhbnRpZnkgInNp
Z25pZmljYW50IHBlcmZvcm1hbmNlDQo+ID4gPiA+ID4gaW1wcm92ZW1lbnRzIj8NCj4gPiA+ID4g
DQo+ID4gPiA+IEhpIEFuZHJldyBhbmQgQW5keSwNCj4gPiA+ID4gDQo+ID4gPiA+IFlvdSBhcmUg
cmlnaHQgdG8gY2FsbCB0aGF0IG91dCBhbmQgYXBvbG9naWVzIGZvciBsZWF2aW5nIGl0IHZhZ3Vl
Lg0KPiA+ID4gPiANCj4gPiA+ID4gSSd2ZSBkb25lIG15IHRlc3Rpbmcgd2l0aCBvbGRlciBrZXJu
ZWwgdmVyc2lvbnMgaW4gc3lzdGVtcyB3aGVyZSBgd2MgLWwNCj4gPiA+ID4gL3Byb2MvaW9tZW1g
IGNhbiByZXR1cm4gfjVrLiBJbiB0aGF0IGVudmlyb25tZW50IEkgc2VlIG1tYXBpbmcgcGFydHMg
b2YNCj4gPiA+ID4gL2Rldi9tZW0gdGFraW5nIDcwMC0xNTAwzrxzIHdpdGhvdXQgdGhlIG9wdGlt
aXNhdGlvbiBhbmQgMTAtNTDOvHMgd2l0aCB0aGUNCj4gPiA+ID4gb3B0aW1pc2F0aW9uLg0KPiA+
ID4gPiANCj4gPiA+ID4gVGhlIHJlYWwtd29ybGQgdXNlIGNhc2Ugd2UgY2FyZSBhYm91dCBpcyBo
eXBlcnZpc29yIGxpdmUgdXBkYXRlIHdoZXJlIGhhdmluZyB0bw0KPiA+ID4gPiBkbyBsb3RzIG9m
IHRoZXNlIG1tYXBzKCkgc2VyaWFsbHkgY2FuIHNpZ25pZmljYW50bHkgYWZmZWN0IHRoZSBndWVz
dCBkb3dudGltZQ0KPiA+ID4gPiBpZiB0aGUgY29zdCBpcyAyMC0zMHguDQo+ID4gPiANCj4gPiA+
IFRoYW5rcyBmb3IgcHJvdmlkaW5nIHRoaXMgaW5mb3JtYXRpb24uDQo+ID4gPiANCj4gPiA+ID4g
PiBJdCBhbHNvIHdvdWxkIGJlIGdvb2QgdG8ga25vdyB3aGljaCBleGFjdCBmdW5jdGlvbihzKSBp
cyBhIGJvdHRsZW5lY2suDQo+ID4gPiA+IA0KPiA+ID4gPiBQZXJmIHRyYWNpbmcgc2hvd3MgdGhh
dCB+OTUlIG9mIENQVSB0aW1lIGlzIHNwZW50IGluIGZpbmRfbmV4dF9pb21lbV9yZXMoKSwNCj4g
PiA+IA0KPiA+ID4gSGF2ZSB5b3UgaW52ZXN0aWdhdGVkIHBvc3NpYmlsaXR5IHRvIHJldHVybiB0
aGF0IGNoZWNrIGRpcmVjdGx5IGludG8NCj4gPiA+IHRoZSBjdWxwcml0Pw0KPiA+IA0KPiA+IEkn
bSBzb3JyeSwgSSBkb24ndCB1bmRlcnN0YW5kIHRoaXMuIENvdWxkIHlvdSBwbGVhc2UgY2xhcmlm
eSB3aGF0IHlvdSBtZWFuPw0KPiA+IFdoYXQgZG8geW91IGNvbnNpZGVyIHRvIGJlIHRoZSBjdWxw
cml0IGFuZCB3aGljaCBjaGVjayBkbyB5b3UgcmVmZXIgdG8/DQo+IA0KPiBUaGUgbWVudGlvbmVk
IHBhdGNoIHJlbW92ZWQgdGhlIGNoZWNrIGZvciBzaWJsaW5ncyBmcm9tIG5leHRfcmVzb3VyY2Uo
KS4NCj4gVGhlIGZ1bmN0aW9uIHRoYXQgeW91ciB0ZXN0IGNhc2UgY29tcGxhaW5zIGFib3V0IGlz
IGZpbmRfbmV4dF9pb21lbV9yZXMoKS4NCj4gSGVuY2UsIGhhdmUgeW91IHRyaWVkIHRvIHJlaW5z
dGFudGlhdGUgdGhlIChyZW1vdmVkKSBjaGVjayBmcm9tIG5leHRfcmVzb3VyY2UoKQ0KPiBpbiBm
aW5kX25leHRfaW9tZW1fcmVzKCkgYW5kIHNlZSBpZiBpdCBoZWxwcz8NCj4gDQoNCm5leHRfcmVz
b3VyY2UoKSBkb2VzIGFjY2VwdCBhICdza2lwX2NoaWxkcmVuJyBwYXJhbWV0ZXIgaW4gdGhlIGxh
dGVzdCBrZXJuZWwNCnRvZGF5IHdoaWNoIGlzIGVxdWl2YWxlbnQgdG8gdGhlICdzaWJsaW5nX29u
bHknIHBhcmFtZXRlciBpbiB0aGUgb2xkZXIga2VybmVscy4NCkFuZCB0aGUgZm9yX2VhY2hfcmVz
b3VyY2UoKSBtYWNybyBjdXJyZW50bHkgdXNlZCBpbiBmaW5kX25leHRfaW9tZW1fcmVzKCkgY2Fs
bHMNCm5leHRfcmVzb3VyY2UoKS4NCg0KSG9wZSB0aGF0IG1ha2VzIHNlbnNlLg0K

