Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7934CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50AEC6B000D; Thu,  4 Sep 2025 08:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B4AA6B000E; Thu,  4 Sep 2025 08:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A32B6B0011; Thu,  4 Sep 2025 08:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26D486B000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:39:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC40984522
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:39:20 +0000 (UTC)
X-FDA: 83851523280.25.E433AFB
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf21.hostedemail.com (Postfix) with ESMTP id 56A051C000F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:39:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=Tvlxv7OT;
	spf=pass (imf21.hostedemail.com: domain of "prvs=335a05013=suschako@amazon.de" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=335a05013=suschako@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756989558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ULScby5e7nfE21eIVPMtirUeTHzPiyrQ91q0FcQlkHM=;
	b=e59gwnnniSwUvIs3dvLeQl1qvN7ljVqVPnkTndM1/UVQFV9cHlKFP4N0AcWf832Vqmro/6
	6Dzg8ftdODz6T+HN4EVrQfBO2e3NU7ElNum8ut8kARDoEtMkzDwSz0hN4jk+rcisN1SDFL
	9vjcPKOdAiYluVPtYUpnzBq2Z6oAjJI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=Tvlxv7OT;
	spf=pass (imf21.hostedemail.com: domain of "prvs=335a05013=suschako@amazon.de" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=335a05013=suschako@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756989558; a=rsa-sha256;
	cv=none;
	b=4K8ATV/57im59V06MLAEDCIZHB7N/hs8j4DOsJturXuyltxNxUyFS39MvLUMF0Lk2Mkts9
	MprJXVN3HaYZC9Myf3dOv9H5E/Zp/GHIZhO7CTnfrb/jKI4MlFkaAm6nUJZNvI2FmWTzhX
	xrbTVYFL+ML3N915+W+Cac0aMaCCAsg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1756989558; x=1788525558;
  h=from:to:cc:date:message-id:references:in-reply-to:
   mime-version:content-transfer-encoding:subject;
  bh=ULScby5e7nfE21eIVPMtirUeTHzPiyrQ91q0FcQlkHM=;
  b=Tvlxv7OT5/R+n/tjOWA08AZomPW/t4bpMORNKodGH64P6yckaE02+9Fm
   lgrL2JyNEYG6sAv+GB4/xY2oyRgB1HLOU1DQhOpv9j8HdJDaUNw/SRIkm
   LeAQHmatYGEbUhhk45YGG+KzdfXi4x68uh4dxz8dRj1Z8BymbjBw3u+tF
   iEDLuOSd2qaFyuSecsMYMUEUaSycESeFm1XTjcUxmn2GU8d+/Uv25RdAu
   LZ7nkOsXZxN377w4EhEt4nIUv+ZNkDBweQcckCwAq2tAEgtI/JII1eFju
   puLPx5RXsMtvySHQvTTzenuJ2FsFPKEK0bQNQcwy9tEsf//A0m5T4oyfW
   Q==;
X-CSE-ConnectionGUID: zSYct0lzSkaIIBnxJlsWUQ==
X-CSE-MsgGUID: siHY+fGUQ/eEuX1zssW6cw==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1639693"
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
Thread-Topic: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 12:39:08 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:13862]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.43.161:2525] with esmtp (Farcaster)
 id 2da87af0-5385-40d0-9937-3670b0b57a6f; Thu, 4 Sep 2025 12:39:08 +0000 (UTC)
X-Farcaster-Flow-ID: 2da87af0-5385-40d0-9937-3670b0b57a6f
Received: from EX19D024EUA001.ant.amazon.com (10.252.50.75) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 4 Sep 2025 12:39:08 +0000
Received: from EX19D024EUA004.ant.amazon.com (10.252.50.30) by
 EX19D024EUA001.ant.amazon.com (10.252.50.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 4 Sep 2025 12:39:07 +0000
Received: from EX19D024EUA004.ant.amazon.com ([fe80::4608:828c:c80b:ca72]) by
 EX19D024EUA004.ant.amazon.com ([fe80::4608:828c:c80b:ca72%3]) with mapi id
 15.02.2562.020; Thu, 4 Sep 2025 12:39:07 +0000
From: "Uschakow, Stanislav" <suschako@amazon.de>
To: David Hildenbrand <david@redhat.com>, Jann Horn <jannh@google.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "trix@redhat.com"
	<trix@redhat.com>, "ndesaulniers@google.com" <ndesaulniers@google.com>,
	"nathan@kernel.org" <nathan@kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "muchun.song@linux.dev" <muchun.song@linux.dev>,
	"mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"liam.howlett@oracle.com" <liam.howlett@oracle.com>, "osalvador@suse.de"
	<osalvador@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Index: AQHcGOKArPRLx5Gss0qhHb9N9ZVPl7R+LN+AgAAH1gCABJSBfQ==
Date: Thu, 4 Sep 2025 12:39:07 +0000
Message-ID: <355102b559a747fe9a09142d46852551@amazon.de>
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de>
 <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>,<2dcf12d0-e29c-4c9b-aeac-a0b803d2c2fd@redhat.com>
In-Reply-To: <2dcf12d0-e29c-4c9b-aeac-a0b803d2c2fd@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.51.153]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Stat-Signature: 36ow3oj59f57qp6zr3u9rx9a6j6r4hxk
X-Rspam-User: 
X-Rspamd-Queue-Id: 56A051C000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1756989558-589403
X-HE-Meta: U2FsdGVkX1+rxLWW5pF94H3Z+lQSS2B52qQthnki5FjPAwqmL9v0a75Kqim+bk4BDfzEeOsn2W9ZZC5JXE/wJ6yGRW+00rpIa7SJXBvJjpi9Y/bWAkLA/qoVDf9v8QPNwULonNOxjh2JAymQXhBQhZjrifPrQW5FZAxgx1rcJqDasdrZGMrRRlZK207w3DlO7nC6wXIp/NbBHp+m/obIU9cE21Zd1MMXmqwbHDiSNtE7sElxL8Cdwg5MriAef1p2QnBCFebNp63Ff9Rs64wJxkz6PsewPsLfsfT30YlCsKgmh+qW36PMzVvgybKoeAwHgy9BTF6SRzLXCcwVX56x/ygTiciCgx9QW8e1QmFtrABprVar0kvgVwWrv3RBk7Fg9o36TFANHBc5n+Zex52GT/tiBMuxO++XHr3UA/36MGtzCbD7ZMpsKg+jXw5I+XjG9OjcHPgub6PKM0wghwmkJRr+7nWN5FrN09om+e3rAgktZd+CGKJAQH0iQEC8qyowPlHUQaiwhCr90n4qGwWpcC5h76ILgrm4C4FYdMFmZWmyCiQgc4YNyKTWg9dTwBxEs4wRuj2sg5ZufD5LIhVwa4KbSlovqWWeFGszqAwS+1YZh890rA9ujJ8DtmnND0sK369P6/zRA4mnIVdTSMH/AA8uOYAXTbirNgUljjCCxTY2NmEaIjqDXhwzJOsBBSvTcVjspR6T62+lI0MbKKJMqorL61Dpg9+za4stYrOrrvJrjJaIL3/Q9dKIuKC4tw1YvjM83XBeMTDEBj2ZPFXp2432jqGJb+DM0m0woEibQ4lRmDBQ4goSNvsAdvazYJ2ngohuZZuwZoxAker7f3I7cQ87fUE0MQYaREjcbYwQmNwH+qm39T/DYQZxYaBkuLQ7euOtMy4KaTSas3BK0MS/16aee1AlK867T3wSYTp419Z0QgeOhHqVN5mm+Ta2blWPz1+le7QfRO+4wLVoKcJ
 zMGlz+XC
 8gfQOPLhExly5kVKFpPFnpNSc1nBVUw0jiFu5kfLrv75WxBBV/BrHTOnbH9cU1GD03Q83fpejKzNjmIYeqv7VVivh3IT+b1faGG2bPwOTvYh/Z9GirH07bG87gG4/mlV07Azv56uTb6PSO1KDVIhTmvCqiR53MsUUUkMhtnPC0mta6puaaZy4fwTXB+w/m51DHKuk/Q7g6otHPVdf5Lo3NOPRxxVV8Po+vN8nHDWd5yHwM0jeJ5u2KL4p12YnlBUxiB0tvZRLCl7Qxe/7Qi6zCnTA5fFBoQ9fa8C6D6ZfRtHs5GXARjsuId/tb2+4U8fGsNFaWwLCgvbJONqdt1bC3EDjNI+sBuvIWqdOOBjgbtYmLoGod0gOwO1KAWF8uApJm8NRPmGAAai/PpcnwnM3wzw1ueSJZ1lrMmKalTAgeJZ1c6HUyCLWmTh7gGaKQs/scA79Koe/19wWGbgsegCzXJjGHB5M/xcqJ2mlCUKcB7F+LqZqyalZodlmyCCG7PCHp+tpjTCy9bo4PRjOCe5GqFgJCkb7ydsbESnvhmZVG9sTsVAqMf93hFiy9Z3yVjTu/izeXYCG/z24b+PP18gbt3MsGHdvjYEmC7fDqncQH+c/PkvPDrSM9HDXh2mD33v5FVvxS4+zq3u+zkLHS+xXA8o/1CoT8KLFkkxQxOaqSTrXb+sRQqFoeZ38VfsILf6/rqxD3PGVA3eu9J7iRzc+JwBB2/U66LrLi0VV38aYTRJMRV0evpSrYER5eGqjJQWUVP8SvfZmQhS5cky/b1odusSam4rqq562DBrSr2+tdl5N/k39VV9k2+gMV/QQEXvEEt3cM2HlqNynw/y0h2IwINdBkq9fcyU/c2VE4xbG2zGJTVrQNIaoq/iIWglruM/Ore0waVC0pm1rwtGHkwIn45fUpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgRGF2aWQsDQoNCj4gRnJvbTogRGF2aWQgSGlsZGVuYnJhbmQgPGRhdmlkQHJlZGhhdC5jb20+
DQo+IFNlbnQ6IE1vbmRheSwgU2VwdGVtYmVyIDEsIDIwMjUgMToyNiBQTQ0KPiBUbzogSmFubiBI
b3JuOyBVc2NoYWtvdywgU3RhbmlzbGF2DQo+IENjOiBsaW51eC1tbUBrdmFjay5vcmc7IHRyaXhA
cmVkaGF0LmNvbTsgbmRlc2F1bG5pZXJzQGdvb2dsZS5jb207IG5hdGhhbkBrZXJuZWwub3JnOyBh
a3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnOyBtdWNodW4uc29uZ0BsaW51eC5kZXY7IG1pa2Uua3Jh
dmV0ekBvcmFjbGUuY29tOyBsb3JlbnpvLnN0b2FrZXNAb3JhY2xlLmNvbTsgbGlhbS5ob3dsZXR0
QG9yYWNsZS5jb207IG9zYWx2YWRvckBzdXNlLmRlOyB2YmFia2FAc3VzZS5jejsgc3RhYmxlQHZn
ZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSRTogW0VYVEVSTkFMXSBCdWc6IFBlcmZvcm1hbmNl
IHJlZ3Jlc3Npb24gaW4gMTAxM2FmNGY1ODVmOiBtbS9odWdldGxiOiBmaXggaHVnZV9wbWRfdW5z
aGFyZSgpIHZzIEdVUC1mYXN0IHJhY2UNCj4gwqAgICANCj4gQ0FVVElPTjogVGhpcyBlbWFpbCBv
cmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBub3QgY2xpY2sg
bGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGNhbiBjb25maXJtIHRoZSBzZW5k
ZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4gDQo+IA0KPiANCj4gT24gMDEuMDku
MjUgMTI6NTgsIEphbm4gSG9ybiB3cm90ZToNCj4gPiBIaSENCj4gPg0KPiA+IE9uIEZyaSwgQXVn
IDI5LCAyMDI1IGF0IDQ6MzDigK9QTSBVc2NoYWtvdywgU3RhbmlzbGF2IDxzdXNjaGFrb0BhbWF6
b24uZGU+IHdyb3RlOg0KPiA+PiBXZSBoYXZlIG9ic2VydmVkIGEgaHVnZSBsYXRlbmN5IGluY3Jl
YXNlIHVzaW5nIGBmb3JrKClgIGFmdGVyIGluZ2VzdGluZyB0aGUgQ1ZFLTIwMjUtMzgwODUgZml4
IHdoaWNoIGxlYWRzIHRvIHRoZSBjb21taXQgYDEwMTNhZjRmNTg1ZjogbW0vaHVnZXRsYjogZml4
IGh1Z2VfcG1kX3Vuc2hhcmUoKSB2cyBHVVAtZmFzdCByYWNlYC4gT24gbGFyZ2UgbWFjaGluZXMg
d2l0aCAxLjVUQiBvZiBtZW1vcnkgd2l0aCAxOTYgY29yZXMsIHdlIGlkZW50aWZpZWQgIG1tYXBw
aW5nIG9mIDEuMlRCIG9mIHNoYXJlZCBtZW1vcnkgYW5kIGZvcmtpbmcgaXRzZWxmIGRvemVucyBv
ciBodW5kcmVkcyBvZiB0aW1lcyB3ZSBzZWUgYSBpbmNyZWFzZSBvZiBleGVjdXRpb24gdGltZXMg
b2YgYSBmYWN0b3Igb2YgNC4gVGhlIHJlcHJvZHVjZXIgaXMgYXQgdGhlIGVuZCBvZiB0aGUgZW1h
aWwuDQo+ID4NCj4gPiBZZWFoLCBldmVyeSAxRyB2aXJ0dWFsIGFkZHJlc3MgcmFuZ2UgeW91IHVu
c2hhcmUgb24gdW5tYXAgd2lsbCBkbyBhbg0KPiA+IGV4dHJhIHN5bmNocm9ub3VzIElQSSBicm9h
ZGNhc3QgdG8gYWxsIENQVSBjb3Jlcywgc28gaXQncyBub3QgdmVyeQ0KPiA+IHN1cnByaXNpbmcg
dGhhdCBkb2luZyB0aGlzIHdvdWxkIGJlIGEgYml0IHNsb3cgb24gYSBtYWNoaW5lIHdpdGggMTk2
DQo+ID4gY29yZXMuDQo+IA0KPiBXaGF0IGlzIHRoZSB1c2UgY2FzZSBmb3IgdGhpcyBleHRyZW1l
IHVzYWdlIG9mIGZvcmsoKSBpbiB0aGF0IGNvbnRleHQ/DQo+IElzIGl0IGp1c3Qgc29tZXRoaW5n
IHBlb3BsZSBub3RpY2VkIGFuZCBpdCdzIHN1Ym9wdGltYWwsIG9yIGlzIHRoaXMgYQ0KPiByZWFs
IHByb2JsZW0gZm9yIHNvbWUgdXNlIGNhc2VzPw0KPiANCg0KWWVzLCB3ZSBoYXZlIGN1c3RvbWVy
IHJlcG9ydGluZyBodWdlIHBlcmZvcm1hbmNlIHJlZ3Jlc3Npb25zIG9uIHRoZWlyIHdvcmtsb2Fk
cy4gSSBkb24ndCBrbm93IHRoZSBzb2Z0d2FyZSBhcmNoaXRlY3R1cmUgb3IgYWN0dWFsIHVzZSBj
YXNlIGZvciB0aGVpciBhcHBsaWNhdGlvbiB0aG91Z2guIEEgZXhlY3V0aW9uIHRpbWUgaW5jcmVh
c2Ugb2YgYXQgbGVhc3QgYSBmYWN0b3Igb2YgNCBpcyBub3RpY2VhYmxlIGV2ZW4gd2l0aCBmZXcg
Zm9ya3MoKSBvbiB0aG9zZSBtYWNoaW5lcy4NCg0KPiAtLQ0KPiBDaGVlcnMNCj4gDQo+IERhdmlk
IC8gZGhpbGRlbmINCg0KDQpUaGFua3MNCg0KU3RhbmlzbGF2DQoNCiAgICAKCgoKQW1hem9uIFdl
YiBTZXJ2aWNlcyBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJIClRhbWFyYS1EYW56LVN0
ci4gMTMKMTAyNDMgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdl
ciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1
cmcgdW50ZXIgSFJCIDI1Nzc2NCBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDM2NSA1MzggNTk3
Cg==


