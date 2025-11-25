Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99C30CFD37A
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 09:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0234A6B0089; Tue, 25 Nov 2025 04:57:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15B26B008A; Tue, 25 Nov 2025 04:57:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E53036B008C; Tue, 25 Nov 2025 04:57:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D4D6D6B0089
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:57:01 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 935B21406FA
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:57:01 +0000 (UTC)
X-FDA: 84148675842.11.02EB3A3
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 07F10160009
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:56:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="jzUme/e1";
	spf=pass (imf08.hostedemail.com: domain of "prvs=417c28214=ilstam@amazon.co.uk" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=417c28214=ilstam@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764064619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lvfFnaHJc50PXFyNkhTbbl06/AiVLemOeyMXEWeBus0=;
	b=cghRPL+jC9yAUHV/kEoWU0QbnKRpFPUww2asv7cqtGPnR1aoIhPUtQoBZWcs4cfjZwOZOQ
	2JgAq7JFukvis9UovczcNyCIZoTaqD2fTM9Psz2HWC6P0xAP68YpjrrouwMjPAf8f4pUar
	A/gS35OzvNEnSOd23f1gX8YIKcQ1mLg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764064619; a=rsa-sha256;
	cv=none;
	b=OKsbF/1fODSnbv5oRmip8FgL3zIRBrgT6MYmYyS+WKS9h9425u1soLJD4bkjFdOXzDTD1L
	qAyl40FbpZ3NWTSh3emeIhC/Y2LYzytbsJ6+SUVezUgswuDm+WUjSGTXXJX8WzA8YTQOMZ
	IyN72L4/J49hpVW+3o0oGNqr6xmO9Ko=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="jzUme/e1";
	spf=pass (imf08.hostedemail.com: domain of "prvs=417c28214=ilstam@amazon.co.uk" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=417c28214=ilstam@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1764064619; x=1795600619;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=lvfFnaHJc50PXFyNkhTbbl06/AiVLemOeyMXEWeBus0=;
  b=jzUme/e138fM/SiUb5J+8hvTtSWEFi7qL/D4AE4K5jLZHhN+I2kXiyXz
   7neapBF9n+inPRMCVHZ3xn0X5Gz2BO2GhkGfznps4mZfWL0ZUGsQKI+tA
   Zh+YMylObSY18PjzC/uNnS+sm4KxQb7mIJ74AAHgDmJ2Jfhq250FRx8jP
   3VB+oOrdATMSNmEHyqYBh9ylQ4PWCFh1h/vCDbV6dGFmw23nIyWL/SKsi
   fPemRKSmp2Dsf8xbyaj+sGHruBJSPYuwP9jjG1eY4xLhMaNQCV+ismr+9
   e0ltc4yDdfRPay4vscLQmwkLz1lFaObykvmePmir2SzA3b/qkVugowULl
   A==;
X-CSE-ConnectionGUID: rmVkJ54mQoeAgU23db22Kw==
X-CSE-MsgGUID: PhQFXvu6SLeANkKzvIJS+g==
X-IronPort-AV: E=Sophos;i="6.20,225,1758585600"; 
   d="scan'208";a="5646938"
Subject: Re: [PATCH] Reinstate "resource: avoid unnecessary lookups in
 find_next_iomem_res()"
Thread-Topic: [PATCH] Reinstate "resource: avoid unnecessary lookups in
 find_next_iomem_res()"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 09:56:41 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:21774]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.44.247:2525] with esmtp (Farcaster)
 id 0067e011-8743-4a86-818e-4601528d31ff; Tue, 25 Nov 2025 09:56:40 +0000 (UTC)
X-Farcaster-Flow-ID: 0067e011-8743-4a86-818e-4601528d31ff
Received: from EX19D018EUA001.ant.amazon.com (10.252.50.145) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Tue, 25 Nov 2025 09:56:37 +0000
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19D018EUA001.ant.amazon.com (10.252.50.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Tue, 25 Nov 2025 09:56:36 +0000
Received: from EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1]) by
 EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1%3]) with mapi id
 15.02.2562.029; Tue, 25 Nov 2025 09:56:36 +0000
From: "Stamatis, Ilias" <ilstam@amazon.co.uk>
To: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
CC: "nadav.amit@gmail.com" <nadav.amit@gmail.com>, "david@kernel.org"
	<david@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bhe@redhat.com" <bhe@redhat.com>, "huang.ying.caritas@gmail.com"
	<huang.ying.caritas@gmail.com>, "nh-open-source@amazon.com"
	<nh-open-source@amazon.com>
Thread-Index: AQHcXXPvH1LA4deF/EiE1v+Bldr5grUCN+QAgAAFBoCAADzNAIAAeugAgAAzyAA=
Date: Tue, 25 Nov 2025 09:56:36 +0000
Message-ID: <b9f8623fb383ef21bb47e6c9716c2c389581d12d.camel@amazon.co.uk>
References: <20251124165349.3377826-1-ilstam@amazon.com>
	 <20251124085816.07dbf5a4ec6235b2943840a0@linux-foundation.org>
	 <c7411175b332f3befb5bebb6a75c7b91f2c1dbbc.camel@amazon.co.uk>
	 <aSSqIzJWKTe9hs2f@smile.fi.intel.com>
	 <f3fe7efd74c6011ddb35e1f1e90eba43af864aa4.camel@amazon.co.uk>
	 <aSS3kXfoBppO1a-Q@smile.fi.intel.com>
	 <de5d9d0658a8966ad8e523a84185398c216726fc.camel@amazon.co.uk>
	 <aSVRrEDV1hWKhRmp@smile.fi.intel.com>
In-Reply-To: <aSVRrEDV1hWKhRmp@smile.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.106.83.29]
Content-Type: text/plain; charset="utf-8"
Content-ID: <269742B11AF0E94AAB26CD3B38F12FA8@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 07F10160009
X-Stat-Signature: g73kchc54cwiiic4jzg7fz5bqy4cbwtj
X-Rspam-User: 
X-HE-Tag: 1764064618-823871
X-HE-Meta: U2FsdGVkX1+lJ1Nb1r9A58KewU1bhj0cNUSnIyA6iGhSWHztt2zrchR9n6gbN7xqxORwgxsLv39n+Z50zo4ntcqH4xCLKh6sxCNiAafN80fH1PrutipnXqoALk/LLlLGNS1T1TQIR5O7cdMYdvu6LZ+H2855rbWvIGtyaw8jXdy4dx4OK3z06l1jF+yLB7wWWzdVlUoh4q8hcMxsqhCSz1IZRocG08P4KlmbynKe1xbmQOVT8myDycgTT5qKaF4+LSjdqtTUCWswZ8GW+hom37YuUgaaiinloslsToSFYWPVoJCS56DOiEwmyctxtP93Jk41+7YcnYhY2xmhsoQXT/GhRV6Y/zh8dl3qQVZT6XCTuj1ku4posd1RNHBoWEJz2T8LkGCuu8iu8N7SwUb9dZEwS5iRuuXbPU+WO/80PcPIxNxuOLxZJu9Ak6LAEVqeggiBkZWDdO9VoK/XDpCagR/J9OjQNJciEIwhpuwWRnKC6ZEBmB6e8sWmrquN9xEdoL5GifSlwJA8UQ1MWvNHdIdJoSRYxC7lvjkGdK/E23Rj2TtARIBCh4ZRQjVKHfcghcS4rpIpFweTX7XpRshEjjaSSBtZ1SiFeoZpgdS2styUs66WAX20/xDQsQspLm0V0k31D1+9OpFybVtp/0eAceNVqUWJY5elmSDFc4hGikZA7YR2lVbNvzcsSWUpaYd+6T3EdIPWaOzgOAj+FEFzG+bNaTuGYS+R0l790LzfxgZzMwovuxzAJOdVLfo8IEbegIV6djVDnY6xiYaZq84A/jQWqt9xvvGyOf5pP0jV+Q05zbqBfF4TV3c1P39BQLBRfh9M3xZGRwOQr9EGzcq53NQNtybDdWPSrrcFmoLvwEWdZDL1Wa1mxslrDiUgctjpRWqPtZi6d/E/745ZgBEqdm0t55qDxJIyDyyuK9AuCoWT451kUTitG3C5DIP3oH2IBevDM16zhgziKYcCpqQ
 U0QXoa9z
 76tpyVdBaMok7kv+cubGBA/5Xj5r/GUM7q7e41QR6qPem0/ZHchiBxCm8MToIZX2LTp+r9Rd6HE5st92aE8OP4VJwIIbF61zZngcLI8NxL5y+ln3oMhNCv5OwbtQxdZ+lIikmDw80v/7FvjZaV+mx3aHkEjU+dBldFfd58f9xTj3b5d5EvrW16DC0PIZBXZ5ZkoEDuTiDUv3zuI8LBsntuppUhLwxf95TtBbYhQ9G1KqcUlNtiQ83VPrH4P1FpQeUIo1Oiy+366y3gjQCkDLlNq7puqR3Gk94TsQ7RDbBBJE4pG8guVXlzGT6/tgIQ0sbYZtam9A1WD7I1nc8bJnF26AXbBMWY6dU7gcqWiCza8VaecWagqAXLUMpcCYuy05ZaUeJVIV3ZQ9VGrNkALu9yGAUrj1T0AYLyD75XGwYucrGD2XChSGmwX6vNNS8p7bzSwiUQlk9K6Z/QSB4K3F7EhUSiHTfSOAKsqzbDmvwJ/IMYiN9uBIweqLhTw17MI0Kw5aDHfaz0HFOrtIphnUuA1rFFZu7Ywr5FG6LXniU37hf65gUhXNynUIStlyBDhmiAbaLJsYSpeVFqi/i0Uv2nkMKxrq4qR+ZnNn0/dI5rOxky3PrVwWFGP+PbPGvuc7z9+OP7I4+sq31Mv7FwhZ/6YN5Ot5iHIuuIgJsWXNLzUKZBGs6HckixtRi2p0ivERZuyTPhDYV8SQMl+rBU5qUcVnwmOP8GNWTALCS+Pbqj682hu6p78wc868k8a7iiK0CW9wtoR7HMBNex1G1QzRg1tlTpMNeWp5jvjtVZRdtfdIyjdjtI1vLzkH+8kh2pfGVDEFC7awb/t1vZwnKiIWBB75BHMIrglG8vr1javXlkWcN4N4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVHVlLCAyMDI1LTExLTI1IGF0IDA4OjUwICswMjAwLCBhbmRyaXkuc2hldmNoZW5rb0BsaW51
eC5pbnRlbC5jb20gd3JvdGU6DQo+IE9uIE1vbiwgTm92IDI0LCAyMDI1IGF0IDExOjMwOjQ2UE0g
KzAwMDAsIFN0YW1hdGlzLCBJbGlhcyB3cm90ZToNCj4gPiBPbiBNb24sIDIwMjUtMTEtMjQgYXQg
MjE6NTIgKzAyMDAsIGFuZHJpeS5zaGV2Y2hlbmtvQGxpbnV4LmludGVsLmNvbSB3cm90ZToNCj4g
PiA+IE9uIE1vbiwgTm92IDI0LCAyMDI1IGF0IDA3OjM1OjMxUE0gKzAwMDAsIFN0YW1hdGlzLCBJ
bGlhcyB3cm90ZToNCj4gPiA+ID4gT24gTW9uLCAyMDI1LTExLTI0IGF0IDIwOjU1ICswMjAwLCBh
bmRyaXkuc2hldmNoZW5rb0BsaW51eC5pbnRlbC5jb20gd3JvdGU6DQo+ID4gPiA+ID4gT24gTW9u
LCBOb3YgMjQsIDIwMjUgYXQgMDY6MDE6MzVQTSArMDAwMCwgU3RhbWF0aXMsIElsaWFzIHdyb3Rl
Og0KPiA+ID4gPiA+ID4gT24gTW9uLCAyMDI1LTExLTI0IGF0IDA4OjU4IC0wODAwLCBBbmRyZXcg
TW9ydG9uIHdyb3RlOg0KPiA+ID4gPiA+ID4gPiBPbiBNb24sIDI0IE5vdiAyMDI1IDE2OjUzOjQ5
ICswMDAwIElsaWFzIFN0YW1hdGlzIDxpbHN0YW1AYW1hem9uLmNvbT4gd3JvdGU6DQo+ID4gPiA+
ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+IENvbW1pdCA5NzUyM2E0ZWRiN2IgKCJrZXJuZWwvcmVz
b3VyY2U6IHJlbW92ZSBmaXJzdF9sdmwgLyBzaWJsaW5nc19vbmx5DQo+ID4gPiA+ID4gPiA+ID4g
bG9naWMiKSByZW1vdmVkIGFuIG9wdGltaXphdGlvbiBpbnRyb2R1Y2VkIGJ5IGNvbW1pdCA3NTYz
OTg3NTBlMTENCj4gPiA+ID4gPiA+ID4gPiAoInJlc291cmNlOiBhdm9pZCB1bm5lY2Vzc2FyeSBs
b29rdXBzIGluIGZpbmRfbmV4dF9pb21lbV9yZXMoKSIpLiBUaGF0DQo+ID4gPiA+ID4gPiA+ID4g
d2FzIG5vdCBjYWxsZWQgb3V0IGluIHRoZSBtZXNzYWdlIG9mIHRoZSBmaXJzdCBjb21taXQgZXhw
bGljaXRseSBzbyBpdCdzDQo+ID4gPiA+ID4gPiA+ID4gbm90IGVudGlyZWx5IGNsZWFyIHdoZXRo
ZXIgcmVtb3ZpbmcgdGhlIG9wdGltaXphdGlvbiBoYXBwZW5lZA0KPiA+ID4gPiA+ID4gPiA+IGlu
YWR2ZXJ0ZW50bHkgb3Igbm90Lg0KPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+IEFz
IHRoZSBvcmlnaW5hbCBjb21taXQgbWVzc2FnZSBvZiB0aGUgb3B0aW1pemF0aW9uIGV4cGxhaW5z
IHRoZXJlIGlzIG5vDQo+ID4gPiA+ID4gPiA+ID4gcG9pbnQgY29uc2lkZXJpbmcgdGhlIGNoaWxk
cmVuIG9mIGEgc3VidHJlZSBpbiBmaW5kX25leHRfaW9tZW1fcmVzKCkgaWYNCj4gPiA+ID4gPiA+
ID4gPiB0aGUgdG9wIGxldmVsIHJhbmdlIGRvZXMgbm90IG1hdGNoLiBSZWluc3RhdGluZyB0aGUg
b3B0aW1pemF0aW9uIHJlc3VsdHMNCj4gPiA+ID4gPiA+ID4gPiBpbiBzaWduaWZpY2FudCBwZXJm
b3JtYW5jZSBpbXByb3ZlbWVudHMgaW4gc3lzdGVtcyB3aXRoIHZlcnkgbGFyZ2UgaW9tZW0NCj4g
PiA+ID4gPiA+ID4gPiBtYXBzIHdoZW4gbW1hcGluZyAvZGV2L21lbS4NCj4gPiA+ID4gPiA+ID4g
DQo+ID4gPiA+ID4gPiA+IEl0IHdvdWxkIGJlIGdyZWF0IGlmIHdlIGNvdWxkIHF1YW50aWZ5ICJz
aWduaWZpY2FudCBwZXJmb3JtYW5jZQ0KPiA+ID4gPiA+ID4gPiBpbXByb3ZlbWVudHMiPw0KPiA+
ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBIaSBBbmRyZXcgYW5kIEFuZHksDQo+ID4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiA+IFlvdSBhcmUgcmlnaHQgdG8gY2FsbCB0aGF0IG91dCBhbmQgYXBvbG9naWVz
IGZvciBsZWF2aW5nIGl0IHZhZ3VlLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBJJ3ZlIGRv
bmUgbXkgdGVzdGluZyB3aXRoIG9sZGVyIGtlcm5lbCB2ZXJzaW9ucyBpbiBzeXN0ZW1zIHdoZXJl
IGB3YyAtbA0KPiA+ID4gPiA+ID4gL3Byb2MvaW9tZW1gIGNhbiByZXR1cm4gfjVrLiBJbiB0aGF0
IGVudmlyb25tZW50IEkgc2VlIG1tYXBpbmcgcGFydHMgb2YNCj4gPiA+ID4gPiA+IC9kZXYvbWVt
IHRha2luZyA3MDAtMTUwMM68cyB3aXRob3V0IHRoZSBvcHRpbWlzYXRpb24gYW5kIDEwLTUwzrxz
IHdpdGggdGhlDQo+ID4gPiA+ID4gPiBvcHRpbWlzYXRpb24uDQo+ID4gPiA+ID4gPiANCj4gPiA+
ID4gPiA+IFRoZSByZWFsLXdvcmxkIHVzZSBjYXNlIHdlIGNhcmUgYWJvdXQgaXMgaHlwZXJ2aXNv
ciBsaXZlIHVwZGF0ZSB3aGVyZSBoYXZpbmcgdG8NCj4gPiA+ID4gPiA+IGRvIGxvdHMgb2YgdGhl
c2UgbW1hcHMoKSBzZXJpYWxseSBjYW4gc2lnbmlmaWNhbnRseSBhZmZlY3QgdGhlIGd1ZXN0IGRv
d250aW1lDQo+ID4gPiA+ID4gPiBpZiB0aGUgY29zdCBpcyAyMC0zMHguDQo+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gVGhhbmtzIGZvciBwcm92aWRpbmcgdGhpcyBpbmZvcm1hdGlvbi4NCj4gPiA+ID4g
PiANCj4gPiA+ID4gPiA+ID4gSXQgYWxzbyB3b3VsZCBiZSBnb29kIHRvIGtub3cgd2hpY2ggZXhh
Y3QgZnVuY3Rpb24ocykgaXMgYSBib3R0bGVuZWNrLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
PiBQZXJmIHRyYWNpbmcgc2hvd3MgdGhhdCB+OTUlIG9mIENQVSB0aW1lIGlzIHNwZW50IGluIGZp
bmRfbmV4dF9pb21lbV9yZXMoKSwNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBIYXZlIHlvdSBpbnZl
c3RpZ2F0ZWQgcG9zc2liaWxpdHkgdG8gcmV0dXJuIHRoYXQgY2hlY2sgZGlyZWN0bHkgaW50bw0K
PiA+ID4gPiA+IHRoZSBjdWxwcml0Pw0KPiA+ID4gPiANCj4gPiA+ID4gSSdtIHNvcnJ5LCBJIGRv
bid0IHVuZGVyc3RhbmQgdGhpcy4gQ291bGQgeW91IHBsZWFzZSBjbGFyaWZ5IHdoYXQgeW91IG1l
YW4/DQo+ID4gPiA+IFdoYXQgZG8geW91IGNvbnNpZGVyIHRvIGJlIHRoZSBjdWxwcml0IGFuZCB3
aGljaCBjaGVjayBkbyB5b3UgcmVmZXIgdG8/DQo+ID4gPiANCj4gPiA+IFRoZSBtZW50aW9uZWQg
cGF0Y2ggcmVtb3ZlZCB0aGUgY2hlY2sgZm9yIHNpYmxpbmdzIGZyb20gbmV4dF9yZXNvdXJjZSgp
Lg0KPiA+ID4gVGhlIGZ1bmN0aW9uIHRoYXQgeW91ciB0ZXN0IGNhc2UgY29tcGxhaW5zIGFib3V0
IGlzIGZpbmRfbmV4dF9pb21lbV9yZXMoKS4NCj4gPiA+IEhlbmNlLCBoYXZlIHlvdSB0cmllZCB0
byByZWluc3RhbnRpYXRlIHRoZSAocmVtb3ZlZCkgY2hlY2sgZnJvbSBuZXh0X3Jlc291cmNlKCkN
Cj4gPiA+IGluIGZpbmRfbmV4dF9pb21lbV9yZXMoKSBhbmQgc2VlIGlmIGl0IGhlbHBzPw0KPiA+
IA0KPiA+IG5leHRfcmVzb3VyY2UoKSBkb2VzIGFjY2VwdCBhICdza2lwX2NoaWxkcmVuJyBwYXJh
bWV0ZXIgaW4gdGhlIGxhdGVzdCBrZXJuZWwNCj4gPiB0b2RheSB3aGljaCBpcyBlcXVpdmFsZW50
IHRvIHRoZSAnc2libGluZ19vbmx5JyBwYXJhbWV0ZXIgaW4gdGhlIG9sZGVyDQo+ID4ga2VybmVs
cy4NCj4gDQo+IEl0IHVzZWQgdG8gYmUNCj4gDQo+ICAgICAgICBpZiAoc2libGluZ19vbmx5KQ0K
PiAgICAgICAgICAgICAgICByZXR1cm4gcC0+c2libGluZzsNCj4gDQo+ICAgICAgICBpZiAocC0+
Y2hpbGQpDQo+ICAgICAgICAgICAgICAgIHJldHVybiBwLT5jaGlsZDsNCj4gICAgICAgIC4uLg0K
PiANCg0KVGhpcyByZXR1cm5zIHAtPnNpYmxpbmcgaWYgc2libGluZ19vbmx5ID09IHRydWUuIA0K
VGhlIHJldHVybiB2YWx1ZSBtaWdodCBhbHNvIGJlIE5VTEwuDQoNCj4gDQo+IGFuZCBiZWNvbWUg
KGluIHRoZSBsYXRlc3Qga2VybmVscykNCj4gDQo+ICAgICAgICBpZiAoIXNraXBfY2hpbGRyZW4g
JiYgcC0+Y2hpbGQpDQo+ICAgICAgICAgICAgICAgIHJldHVybiBwLT5jaGlsZDsNCj4gICAgICAg
IC4uLg0KPiANCj4gDQoNCglpZiAoIXNraXBfY2hpbGRyZW4gJiYgcC0+Y2hpbGQpDQoJCXJldHVy
biBwLT5jaGlsZDsNCgl3aGlsZSAoIXAtPnNpYmxpbmcgJiYgcC0+cGFyZW50KSB7DQoJCXAgPSBw
LT5wYXJlbnQ7DQoJCWlmIChwID09IHN1YnRyZWVfcm9vdCkNCgkJCXJldHVybiBOVUxMOw0KCX0N
CglyZXR1cm4gcC0+c2libGluZzsNCg0KVGhpcyBpcyB0aGUgZnVsbCBmdW5jdGlvbiBvbiB0aGUg
bGF0ZXN0IGtlcm5lbC4gSWYgc2tpcF9jaGlsZHJlbiA9PSB0cnVlIGFuZA0KdGhlcmUgaXMgYSBz
aWJsaW5nLCBpdCBhbHNvIHJldHVybnMgcC0+c2libGluZy4NCg0KSWYgcC0+c2libGluZyBpcyBO
VUxMLCBpdCdsbCB0cnkgdG8gZ2V0IHRoZSBwYXJlbnQuIEluIHRoZSBjYXNlIG9mDQpmaW5kX25l
eHRfaW9tZW1fcmVzKCkgdGhlIHBhcmVudCB3aWxsIGJlIGlvbWVtX3Jlc291cmNlLCBpbiB3aGlj
aCBjYXNlIHRoZSBpZg0KKHAgPT0gc3VidHJlZV9yb290KSBwYXRoIGlzIHRha2VuIGFuZCB3ZSBy
ZXR1cm4gTlVMTCAoc2FtZSBhcyB0aGUgY2FzZSBvZiANCnAtPnNpYmxpbmcgYmVpbmcgTlVMTCBh
Ym92ZSkuIA0KDQoNCj4gQ2FuIHlvdSBlbGFib3JhdGUgaG93IGFyZSB0aGV5IGludGVyb3BlcmFi
bGU/DQo+IA0KPiBUTDtEUjogSSBkb24ndCB0aGluayBpdCdzIGFuIGVxdWl2YWxlbnQuDQoNCg==

