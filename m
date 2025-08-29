Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E00CA1001
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5406B000D; Fri, 29 Aug 2025 11:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CA98E000C; Fri, 29 Aug 2025 11:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4098E0001; Fri, 29 Aug 2025 11:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 323556B000D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:20:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4943BA6F9
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:20:58 +0000 (UTC)
X-FDA: 83830157796.23.17391A7
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	by imf30.hostedemail.com (Postfix) with ESMTP id BF0FE8001C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:20:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756480856; a=rsa-sha256;
	cv=none;
	b=NalDxsz032PQBZP8CBTt1H9h7L2luiS0+m/A1xol8Sh4Dittu9PPy7UQSaJ2m1gllG0r/j
	dtpv+6YcP12yF3/gb8lLutpDnEM1QwYXvPaadM1D6Ap3GQQtxzfFHrbPG/40hxIu4cDv+7
	aQENsmPoLkFVYLVOWIOAvdlMv2WYjzA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756480856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=0BYq9Ath32/GzxTKvFxYgqSTN1wYyZb6k+KxvfGhV6M=;
	b=DaHGQebP2sSKRboOgH0bz1eQsabLpZFq8C8Am4iPDc5DWc5JzVJnkF0QD9tiTX89wxqLqw
	09QHfOEKwCkcDunp0vaO+RIom7DuwkMe6Phd+CdfZ8lIj6LqQMmQIjQFJN2knsV2GjW8mE
	ccKbJ57TjrgZQ97y/yIAE7+exFKFxJQ=
From: "Li,Rongqing" <lirongqing@baidu.com>
To: David Hildenbrand <david@redhat.com>, "muchun.song@linux.dev"
	<muchun.song@linux.dev>, "osalvador@suse.de" <osalvador@suse.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "giorgitchankvetadze1997@gmail.com"
	<giorgitchankvetadze1997@gmail.com>
Subject: RE:  Re: [PATCH][v3] mm/hugetlb: Retry to allocate for early boot
 hugepage allocation
Thread-Topic: Re: [PATCH][v3] mm/hugetlb: Retry to allocate for early boot
 hugepage allocation
Thread-Index: AdwY9uGXrnuAuxl1TGyGaxSR6Bk9Gw==
Date: Fri, 29 Aug 2025 15:20:47 +0000
Message-ID: <8c6e91ecb80c4707a52c253481cba51c@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.127.72.24]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.3.13
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BF0FE8001C
X-Stat-Signature: oq499juq676cj6jwtu1dq99c86ezre87
X-Rspam-User: 
X-HE-Tag: 1756480855-699711
X-HE-Meta: U2FsdGVkX19hKInUlVP9UxoXBJ8FLM8H5r+EeDijb6U7pgZ3yUW0a/pGuWK637aD4jZNDHnkvXha93nWoLTwIswnXltRRe320C/opsorUjsIIONj7Z3SruJpKN/izLkjePSvUROp7oOQuFJJ0cRE8uYl2BYY+tkiNRLB+Or36tQnAPIqmsn4WHAHFvTpvBgF8KDngOmd3R1WZyIN5tose9CX/J0H2SiqTZ4WDVReVvUStb2eGtJvaQFwZH1yzcOFfWzCRi/4GzC7iNIRTxdKd9atXroKjhnIcuSfaBEOvoAAzgH4F5HSqVqb4WUOz22aR3WJtBXeEu7tr/lZTIMWHN0nChMydW0u8Rk9BWjZrolaWVeG7nM3m590eKjb1ISYLN6K+oxjy/TYE9gVc+lu4PhKIvWhGL88hD2zFV5By9qiOv6VtTebMVrD3PdiRz8ZKSM+LRCDdddJq1XYFABRr2TOINuJ3PCSXFYeDWJ/UeIyfk5cxeQZEQko1AEteKDp3usDyLEeQ8P+7TR8IooTR1qJB85nciZe6XpNX4FtOG9d3VkYrHLuBf7e/kptVGKKtDYindUWhjSX7bOQ3H82lW9yOC6zQnXmGeDSa6t0Mf24WJyQPR/IQInRwPEzaZqcbAy8ZQzBWEglzi3KihB1uDxkP8w2IpkmBhDcmgZzxrx8DSXhfufYGWZ/VfrmIz0qxkMJCpsw3U2A4JBDs7MR8dEKLGEP8SZmbo2sbAk2mYq8UUbYL2jANqqtao6t1fBYMwR3GHiVGYFdJFM1lnQt1imtpzXTvC9MfyMxHmTPN5zMJU5x2BfPlSR2+gFNOZ3iI6rMg4mhQuwedxNRqP/R5BOSorxh3m11j3ZvCNl6fTlf43LfBiEmyuJhJx/Vl5YtGhlaPflCxsNh8PA3CcnnJE3jPfiKVMngDNWMFwPhEAW9WCg0Sh5PzDUJONeXC5Hrh+z4KthztBuvlZtMLTR
 km+wUE7U
 VDrmDxLHHcuqU8ipxrU04/jkkXwO1lB0B0a1bv3iXokYmEq9OB/eYZTfj/mxOyl+NNAwZZYJGbK8MH/C0wZLPZhvyV/HaZsd1BAKhrhTyUw8a7UfqyERFpVEfKjUxLl0jpYfYDUlE4lEjweUwtfpgvkkWicKSVaNcOwcY5FL4FVrK23rYcsJcA8wAbMflENhVTSFBKXDyW7XRqlRpVIKVPua2hJt6WPGIwRp4gzHB4toj2JG5qry3c3L+d/bjMGYlvx3SPZ1giUmnTvFKzGjXO8D++2DB8AvOn51LLjQaYkKEeALltqYiWltf7UH2nKzTzDoR5Vvsj0QX26hyJKla1DMFPNj3LhSZAx2jsptadqEnTQ0hvXy501+bByiBGWpV2eEq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQoNCj4gT24gMjkuMDguMjUgMTE6NTIsIGxpcm9uZ3Fpbmcgd3JvdGU6DQo+ID4gRnJvbTogTGkg
Um9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiA+DQo+ID4gSW4gY2xvdWQgZW52aXJv
bm1lbnRzIHdpdGggbWFzc2l2ZSBodWdlcGFnZSByZXNlcnZhdGlvbnMgKDk1JSsgb2YNCj4gPiBz
eXN0ZW0gUkFNKSwgc2luZ2xlLWF0dGVtcHQgYWxsb2NhdGlvbiBkdXJpbmcgZWFybHkgYm9vdCBv
ZnRlbiBmYWlscw0KPiA+IGR1ZSB0byBtZW1vcnkgcHJlc3N1cmUuDQo+ID4NCj4gPiBDb21taXQg
OTFmMzg2YmYwNzcyICgiaHVnZXRsYjogYmF0Y2ggZnJlZWluZyBvZiB2bWVtbWFwIHBhZ2VzIikN
Cj4gPiBpbnRlbnNpZmllZCB0aGlzIGJ5IGRlZmVycmluZyBwYWdlIGZyZWVzLCBpbmNyZWFzZSBw
ZWFrIG1lbW9yeSB1c2FnZSBkdXJpbmcNCj4gYWxsb2NhdGlvbi4NCj4gPg0KPiA+IEludHJvZHVj
ZSBhIHJldHJ5IG1lY2hhbmlzbSB0aGF0IGxldmVyYWdlcyB2bWVtbWFwIG9wdGltaXphdGlvbg0K
PiA+IHJlY2xhaW0gKH4xLjYlIG1lbW9yeSkgd2hlbiBhdmFpbGFibGUuIFVwb24gaW5pdGlhbCBh
bGxvY2F0aW9uDQo+ID4gZmFpbHVyZSwgdGhlIHN5c3RlbSByZXRyaWVzIHVudGlsIHN1Y2Nlc3Nm
dWwgb3Igbm8gZnVydGhlciBwcm9ncmVzcyBpcw0KPiA+IG1hZGUsIGVuc3VyaW5nIHJlbGlhYmxl
IGh1Z2VwYWdlIGFsbG9jYXRpb24gd2hpbGUgcHJlc2VydmluZyBiYXRjaGVkDQo+IHZtZW1tYXAg
ZnJlZWluZyBiZW5lZml0cy4NCj4gPg0KPiA+IFRlc3Rpbmcgb24gYSAyNTZHIG1hY2hpbmUgYWxs
b2NhdGluZyAyNTJHIG9mIGh1Z2VwYWdlczoNCj4gPiBCZWZvcmU6IDEyODA1Ni8xMjkwMjQgaHVn
ZXBhZ2VzIGFsbG9jYXRlZA0KPiA+IEFmdGVyOiAgU3VjY2Vzc2Z1bGx5IGFsbG9jYXRlZCBhbGwg
MTI5MDI0IGh1Z2VwYWdlcw0KPiA+DQo+ID4gU3VnZ2VzdGVkLWJ5OiBEYXZpZCBIaWxkZW5icmFu
ZCA8ZGF2aWRAcmVkaGF0LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBMaSBSb25nUWluZyA8bGly
b25ncWluZ0BiYWlkdS5jb20+DQo+ID4gLS0tDQo+ID4gRGlmZiB3aXRoIHYyOiBhdXRvIHJldHJ5
IG1lY2hhbmlzbQ0KPiA+IERpZmYgd2l0aCB2MTogYWRkIGxvZyBpZiB0d28tcGhhc2UgaHVnZXBh
Z2UgYWxsb2NhdGlvbiBpcyB0cmlnZ2VyZWQNCj4gPiAJCWFkZCB0aGUga25vZCB0byBjb250cm9s
IHNwbGl0IHJhdGlvDQo+ID4NCj4gPiAgIG1tL2h1Z2V0bGIuYyB8IDI3ICsrKysrKysrKysrKysr
KysrKysrKysrLS0tLQ0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKyksIDQg
ZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvbW0vaHVnZXRsYi5jIGIvbW0vaHVn
ZXRsYi5jIGluZGV4IDc1M2Y5OWIuLjE4ZTU0ZWEgMTAwNjQ0DQo+ID4gLS0tIGEvbW0vaHVnZXRs
Yi5jDQo+ID4gKysrIGIvbW0vaHVnZXRsYi5jDQo+ID4gQEAgLTM1ODksMTAgKzM1ODksOSBAQCBz
dGF0aWMgdW5zaWduZWQgbG9uZyBfX2luaXQNCj4gPiBodWdldGxiX3BhZ2VzX2FsbG9jX2Jvb3Qo
c3RydWN0IGhzdGF0ZSAqaCkNCj4gPg0KPiA+ICAgCXVuc2lnbmVkIGxvbmcgamlmZmllc19zdGFy
dDsNCj4gPiAgIAl1bnNpZ25lZCBsb25nIGppZmZpZXNfZW5kOw0KPiA+ICsJdW5zaWduZWQgbG9u
ZyByZW1haW5pbmc7DQo+ID4NCj4gPiAgIAlqb2IudGhyZWFkX2ZuCT0gaHVnZXRsYl9wYWdlc19h
bGxvY19ib290X25vZGU7DQo+ID4gLQlqb2Iuc3RhcnQJPSAwOw0KPiA+IC0Jam9iLnNpemUJPSBo
LT5tYXhfaHVnZV9wYWdlczsNCj4gPg0KPiA+ICAgCS8qDQo+ID4gICAJICogam9iLm1heF90aHJl
YWRzIGlzIDI1JSBvZiB0aGUgYXZhaWxhYmxlIGNwdSB0aHJlYWRzIGJ5IGRlZmF1bHQuDQo+ID4g
QEAgLTM2MTYsMTAgKzM2MTUsMzAgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcgX19pbml0DQo+IGh1
Z2V0bGJfcGFnZXNfYWxsb2NfYm9vdChzdHJ1Y3QgaHN0YXRlICpoKQ0KPiA+ICAgCX0NCj4gPg0K
PiA+ICAgCWpvYi5tYXhfdGhyZWFkcwk9IGh1Z2VwYWdlX2FsbG9jYXRpb25fdGhyZWFkczsNCj4g
PiAtCWpvYi5taW5fY2h1bmsJPSBoLT5tYXhfaHVnZV9wYWdlcyAvDQo+IGh1Z2VwYWdlX2FsbG9j
YXRpb25fdGhyZWFkczsNCj4gPg0KPiA+ICAgCWppZmZpZXNfc3RhcnQgPSBqaWZmaWVzOw0KPiA+
IC0JcGFkYXRhX2RvX211bHRpdGhyZWFkZWQoJmpvYik7DQo+ID4gKwlkbyB7DQo+ID4gKwkJcmVt
YWluaW5nID0gaC0+bWF4X2h1Z2VfcGFnZXMgLSBoLT5ucl9odWdlX3BhZ2VzOw0KPiA+ICsNCj4g
PiArCQlqb2Iuc3RhcnQgICAgID0gaC0+bnJfaHVnZV9wYWdlczsNCj4gPiArCQlqb2Iuc2l6ZSAg
ICAgID0gcmVtYWluaW5nOw0KPiA+ICsJCWpvYi5taW5fY2h1bmsgPSByZW1haW5pbmcgLyBodWdl
cGFnZV9hbGxvY2F0aW9uX3RocmVhZHM7DQo+ID4gKwkJcGFkYXRhX2RvX211bHRpdGhyZWFkZWQo
JmpvYik7DQo+ID4gKw0KPiA+ICsJCWlmIChoLT5ucl9odWdlX3BhZ2VzID09IGgtPm1heF9odWdl
X3BhZ2VzKQ0KPiA+ICsJCQlicmVhazsNCg0KSWYgYWxsIHBhZ2VzIGFyZSBhbGxvY2F0ZWQsIGl0
IHdpbGwgYnJlYWsgb3V0IGZyb20gaGVyZS4gU2luY2UgaW4gbW9zdCBjYXNlcyB0aGUgZmlyc3Qg
YWxsb2NhdGlvbiBpcyBzdWNjZXNzZnVsLCBJIGhhdmUgbW92ZWQgdGhpcyBjaGVjayB0byB0aGUg
dmVyeSBiZWdpbm5pbmcuDQoNCj4gPiArDQo+ID4gKwkJLyoNCj4gPiArCQkgKiBSZXRyeSBhbGxv
Y2F0aW9uIGlmIHZtZW1tYXAgb3B0aW1pemF0aW9uIGlzIGF2YWlsYWJsZSwgdGhlDQo+ID4gKwkJ
ICogb3B0aW1pemF0aW9uIGZyZWVzIH4xLjYlIG9mIG1lbW9yeSBvZiBodWdlcGFnZXMsIHRoaXMg
cmVjbGFpbWVkDQo+ID4gKwkJICogbWVtb3J5IGVuYWJsZXMgYWRkaXRpb25hbCBodWdlcGFnZSBh
bGxvY2F0aW9ucw0KPiANCj4gQXMgSSBzYWlkLCBwbGVhc2UgcmVtb3ZlIGFueSBjYWxjdWxhdGlv
biBkZXRhaWxzIGFib3V0IHRoZSB2bWVtbWFwLg0KPiBUaGF0J3Mgbm90IHRoZSBwbGFjZSB0byBo
YXZlIHN1Y2ggY2FsY3VsYXRpb25zIGVhc2lseSBiZWNvbWUgc3RhbGUuDQo+IA0KPiBTb21ldGhp
bmcgbGlrZSB0aGUgZm9sbG93aW5nOg0KPiANCj4gLyoNCj4gICAqIFJldHJ5IG9ubHkgaWYgdGhl
IHZtZW1tYXAgb3B0aW1pemF0aW9uIG1pZ2h0IGhhdmUgYmVlbiBhYmxlIHRvIGZyZWUNCj4gICAq
IHNvbWUgbWVtb3J5IGJhY2sgdG8gdGhlIHN5c3RlbS4NCj4gICAqLw0KPiANCg0KVGhhbmtzLCBJ
IHdpbGwgZml4IGl0DQoNCj4gPiArCQkgKi8NCj4gPiArCQlpZiAoIWh1Z2V0bGJfdm1lbW1hcF9v
cHRpbWl6YWJsZShoKSkNCj4gPiArCQkJYnJlYWs7DQo+ID4gKw0KPiA+ICsJLyogQ29udGludWUg
aWYgcHJvZ3Jlc3Mgd2FzIG1hZGUgaW4gbGFzdCBpdGVyYXRpb24gKi8NCj4gDQo+IENvbW1lbnQg
d3JvbmdseSBpbmRlbnRlZC4NCj4gDQoNCmNoZWNrcGF0Y2ggZGlkIG5vdCByZXBvcnQgZXJyb3Is
IEkgd2lsbCBmaXggaXQgDQoNCj4gPiArCX0gd2hpbGUgKHJlbWFpbmluZyAhPSAoaC0+bWF4X2h1
Z2VfcGFnZXMgLSBoLT5ucl9odWdlX3BhZ2VzKSk7DQo+IA0KPiBXaHkgd291bGQgeW91IHdhbnQg
dG8gcmV0cnkgaWYgeW91IGFsbG9jYXRlZCBhbGwgcGFnZXMgKElPVyB0aGUgY29tbW9uDQo+IGNh
c2UpPw0KPiANCg0KU2VlIHRoZSByZXBseSBiZWZvcmUgImlmIChoLT5ucl9odWdlX3BhZ2VzID09
IGgtPm1heF9odWdlX3BhZ2VzKSINCg0KVGhhbmtzDQoNCg0KPiBFLmcuLA0KPiANCj4gcmVtYWlu
aW5nID09IDENCj4gaC0+bWF4X2h1Z2VfcGFnZXMgPT0gMQ0KPiBoLT5ucl9odWdlX3BhZ2VzID09
IDENCj4gDQo+IHdoaWxlICgxICE9IDEgLTEpIC0+IHdoaWxlICgxICE9IDApDQo+IA0KPiANCj4g
eW91IHNob3VsZCBwcm9iYWJseSBkbw0KPiANCj4gZG8gew0KPiAJLi4uDQo+IA0KPiAJLyogU3Rv
cCBpZiB0aGVyZSBpcyBubyBwcm9ncmVzcyAqLw0KPiAJaWYgKHJlbWFpbmluZyA9PSBoLT5tYXhf
aHVnZV9wYWdlcyAtIGgtPm5yX2h1Z2VfcGFnZXMpDQo+IAkJYnJlYWs7DQo+IH0gKGgtPm1heF9o
dWdlX3BhZ2VzICE9IGgtPm5yX2h1Z2VfcGFnZXMpOw0KPiANCj4gLS0NCj4gQ2hlZXJzDQo+IA0K
PiBEYXZpZCAvIGRoaWxkZW5iDQoNCg==

