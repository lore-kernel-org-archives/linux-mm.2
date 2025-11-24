Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15535CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475D06B009E; Mon, 24 Nov 2025 14:36:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4268F6B00A1; Mon, 24 Nov 2025 14:36:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33C926B00A4; Mon, 24 Nov 2025 14:36:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2210F6B009E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:36:01 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D90689923
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:35:59 +0000 (UTC)
X-FDA: 84146506038.28.C01547D
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf25.hostedemail.com (Postfix) with ESMTP id A6FF3A000A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:35:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=e5E0xdJG;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf25.hostedemail.com: domain of "prvs=41621b596=ilstam@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=41621b596=ilstam@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764012956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTUAL27vHZ3NBwiswOv5Gu7UmLHaKfmfIJ3jAQMndC4=;
	b=O3IhI5anZHnw2hbHekMQ3E789nPP8l/XU0vB3xKmf+aGniN3xGmivb2+FY1NcnL6euDfkb
	hiK1RS5M+vrL09M3Wb1zr3TmiHM16e8s1pGFSnyaX1pcaBO1rpRaucmNKHiXPRpcHKLULG
	VvpMGEBlyqbWZy+xGafjkywdImbDOkw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764012956; a=rsa-sha256;
	cv=none;
	b=umIDdOfQDZ2Od79QNSyB/fqXPS5vy3kaIrGUUN/GGciLCvjlPyNYkdSOnn3lO7ai8ZcwbP
	axm616teN9VbJDTaspoqOmIS+ejkAj0yWSApKv5xbuQV9VAdLyW3N0D7rnqh1nwfXbnbkx
	W0qYsO48LIFx2nrQO2lngOG+kdHr5AY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=e5E0xdJG;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf25.hostedemail.com: domain of "prvs=41621b596=ilstam@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=41621b596=ilstam@amazon.co.uk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1764012956; x=1795548956;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jTUAL27vHZ3NBwiswOv5Gu7UmLHaKfmfIJ3jAQMndC4=;
  b=e5E0xdJGaco0WJdRvguZD9A7VHAT11a1+MqL3+CdhGzDt7oI7BnrLw6N
   Vba+A5DhX0RvUyXz8s/mlmtUOXYb90PV9hGmPRgHfjb+5FO0SKHZdAfFf
   MoaZORY8BkOoQVqNIr5O1Gb9cHrkP/ws3WqC+AG480uNh3kC3XCIULX0N
   QNNh6WkLIsmO7Y08AWPr2Cqa2hUt/nblpI8rbz/Mn33IBx7Dzli30AItY
   S77BzijvaIHzQPJAccNbAcwH0cbOiQZiWjfT5bmt7Ia9o0YMioIUgkNsT
   qx7U5qIMGkGdOW38gHVG+vLyKncA+OAFbwIsBugW6ecCK3VeshRki8Py6
   Q==;
X-CSE-ConnectionGUID: g6T3dh5mRDOkX5xJYuVHXw==
X-CSE-MsgGUID: pWmLRHj3ScGmWcVqt4j5Ng==
X-IronPort-AV: E=Sophos;i="6.20,223,1758585600"; 
   d="scan'208";a="5730864"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 19:35:39 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:13041]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.10.60:2525] with esmtp (Farcaster)
 id 487a4344-89fa-4b77-b5e3-19d273764aff; Mon, 24 Nov 2025 19:35:39 +0000 (UTC)
X-Farcaster-Flow-ID: 487a4344-89fa-4b77-b5e3-19d273764aff
Received: from EX19D018EUA001.ant.amazon.com (10.252.50.145) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Mon, 24 Nov 2025 19:35:31 +0000
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19D018EUA001.ant.amazon.com (10.252.50.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Mon, 24 Nov 2025 19:35:31 +0000
Received: from EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1]) by
 EX19D018EUA002.ant.amazon.com ([fe80::7a11:7dbb:2190:e2c1%3]) with mapi id
 15.02.2562.029; Mon, 24 Nov 2025 19:35:31 +0000
From: "Stamatis, Ilias" <ilstam@amazon.co.uk>
To: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
CC: "nadav.amit@gmail.com" <nadav.amit@gmail.com>, "david@kernel.org"
	<david@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bhe@redhat.com" <bhe@redhat.com>, "huang.ying.caritas@gmail.com"
	<huang.ying.caritas@gmail.com>, "nh-open-source@amazon.com"
	<nh-open-source@amazon.com>
Subject: Re: [PATCH] Reinstate "resource: avoid unnecessary lookups in
 find_next_iomem_res()"
Thread-Topic: [PATCH] Reinstate "resource: avoid unnecessary lookups in
 find_next_iomem_res()"
Thread-Index: AQHcXXPvH1LA4deF/EiE1v+Bldr5grUCN+QA
Date: Mon, 24 Nov 2025 19:35:31 +0000
Message-ID: <f3fe7efd74c6011ddb35e1f1e90eba43af864aa4.camel@amazon.co.uk>
References: <20251124165349.3377826-1-ilstam@amazon.com>
	 <20251124085816.07dbf5a4ec6235b2943840a0@linux-foundation.org>
	 <c7411175b332f3befb5bebb6a75c7b91f2c1dbbc.camel@amazon.co.uk>
	 <aSSqIzJWKTe9hs2f@smile.fi.intel.com>
In-Reply-To: <aSSqIzJWKTe9hs2f@smile.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.106.83.8]
Content-Type: text/plain; charset="utf-8"
Content-ID: <52654673D5BA1F40B99E5779349563A4@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Stat-Signature: rbyjz9t4km6f8787foa7jf4tr3h1ar9j
X-Rspam-User: 
X-Rspamd-Queue-Id: A6FF3A000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1764012956-709753
X-HE-Meta: U2FsdGVkX19UWNXMg6gimYi6miQvpcA+re+HQP10PAmCpY51VzBOfcc3iWFYe1ZzIuHs0zm9e/wa66DeaeVbvZE5Q/KNCv1637p1APk/Z2YpXMTts/RZtvKGPS1+3G7ZFiKbflUj4ocF+Epw0lKouRChyfBTvPeyfHdwsveQStybpc/d9+d6VnQdzzmH2nr9I8CQr9ixWchd9+3/3Gz5Wl+Aky8MUuX1gRVvqoTu8AnGjkpsfP4zzYbM+vK5DCs1ExpOl8sXiKbR2sKgoAn7ZDyi+OBZViNEgDhbnWSbPfc4gFhNl4JpqRH9FP3gNa/iGpBQgNFaOhmBzb34ovPWPKDku7/b15gjUTN+SdlA6PnEzVQjnX0Xaou4VQyv58p8zkPYpCznNfsIu14nf1rukCR+yRtRMswcKAmFZPAHMd7FXYz6D10aVcuOQHVHeq5PuNhQMI5f7yzTWiX6KXHzsJuu3lRuNLIdPHb9wmgrcUPykfFrxj+lwwGTQ7bh2+0pAmIxFAZF+8iONdx9e79LfxWJqPjNkov9oAENByCJ7h2fXHKxiAxC7PNA6iejeq7P37/Tq+nwNUdEQRMyRUgo3QFJeVDMiXmDpsh4GET0iECw3nal+8Tc62U9Crpr4WCzSJuHNNRvOEfaCKBkM903jLnmrHGqccGyr75z8UVhuFACnbeHRSqa5dApebQfNY7Nly4XviG5GLQ9sH5OhLdwGnA+an6ntuCQLvj/g5YdhkWf+xGMcy3eYvASi/NHi8eRbvnDmr8aFKEAVLzfv4Wmh19lh319/Yanp/7Z3JiYZz0LvtC3JFrrBIvyfNVXnRVq7ckY5849MmedHl3QluMA9OWw2W+KgKBWcziLggqEEtk3O1cukQvNAaudaIM8WY6BLSndskViN+MCEtacubSFnyyJCecE7dDH8U9XINjQOwRps2RgE3NpWDqIz4Uu7UU5dk/YXBiMPY+dHvTMBbK
 /k6mlXa7
 6BxqNq4BwLVq9Twoog7mWmzdltxx+W7fjg5GlebVJNRFyGWqBwAwQalSFwo+XfbSGLLt2lOAa4cyWgWijdNnWhNvVBmSjwXbv8a6UbVO98gbqMDapw3lAjvXK03j0xzpJ9LoaF2JaWAnggzJQz6Pg4aJB5GU8Lqpu220b+l27gr+IEhQFmIiEuD26/sAg3So2xFozP6Io4aVjXjucGPDnkA3o0/LaVQ/LOti+aa0hDTyi7UUsreHiDZNcyGzXAWjQX/Jfn3N1VtEgpHhtgNjfCpLtvmgCeroGl46HywlyNqbLlsOG1CKyupI0Ht4GHQrlXsbWuQgBGXdSE95I8CpTyea5SXNLitK0zPGcf2DV5gyj4tGHjvhNHfik5vEbFXBwiMg6+WEGV4At8NNTN7mnIg1hsSHrVb8YdjqMfdkng45V/oW2jq87LHsuBaIvVZRglCmxqbQG6pQ0tINv0TUeOaCd18MqSoXM2fClaFnmIRFWNHvnmm1JGalUZZo9PjSTP3A5vnQcsVtCEACbJ68dkRJsR4XsMXjPHkg+4jOryUDzdmj3nK1H3wKIkXv+kkI6Rpo2wFCAOGUz1yP0tBKr39x5Xx3575Y0Soyk88/kX2d5m3oy5/M1nRzif273y2NH4UZSa+0YEoUyLqFk+JaVWN3pxloYTKrDLglUXvYZCSDRPPHVrC056uAB1OnxcF3VROUGOdlXES3Bc7lzFf4V68+JYv5WKkDwGALG2tbfoIt8vZUf8vofkCsEZj9Lg/S17VJmGeziLeTEWO694tzee4SI5dUQUHwVbaZ6e+8YsuM553WNZQ3ZX3n6E8sJ+Ozx4I/TvpS6RWQbNhzdl/IWO6mbMNmHnSFfwU3k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gTW9uLCAyMDI1LTExLTI0IGF0IDIwOjU1ICswMjAwLCBhbmRyaXkuc2hldmNoZW5rb0BsaW51
eC5pbnRlbC5jb20gd3JvdGU6DQo+IE9uIE1vbiwgTm92IDI0LCAyMDI1IGF0IDA2OjAxOjM1UE0g
KzAwMDAsIFN0YW1hdGlzLCBJbGlhcyB3cm90ZToNCj4gPiBPbiBNb24sIDIwMjUtMTEtMjQgYXQg
MDg6NTggLTA4MDAsIEFuZHJldyBNb3J0b24gd3JvdGU6DQo+ID4gPiBPbiBNb24sIDI0IE5vdiAy
MDI1IDE2OjUzOjQ5ICswMDAwIElsaWFzIFN0YW1hdGlzIDxpbHN0YW1AYW1hem9uLmNvbT4gd3Jv
dGU6DQo+ID4gPiANCj4gPiA+ID4gQ29tbWl0IDk3NTIzYTRlZGI3YiAoImtlcm5lbC9yZXNvdXJj
ZTogcmVtb3ZlIGZpcnN0X2x2bCAvIHNpYmxpbmdzX29ubHkNCj4gPiA+ID4gbG9naWMiKSByZW1v
dmVkIGFuIG9wdGltaXphdGlvbiBpbnRyb2R1Y2VkIGJ5IGNvbW1pdCA3NTYzOTg3NTBlMTENCj4g
PiA+ID4gKCJyZXNvdXJjZTogYXZvaWQgdW5uZWNlc3NhcnkgbG9va3VwcyBpbiBmaW5kX25leHRf
aW9tZW1fcmVzKCkiKS4gVGhhdA0KPiA+ID4gPiB3YXMgbm90IGNhbGxlZCBvdXQgaW4gdGhlIG1l
c3NhZ2Ugb2YgdGhlIGZpcnN0IGNvbW1pdCBleHBsaWNpdGx5IHNvIGl0J3MNCj4gPiA+ID4gbm90
IGVudGlyZWx5IGNsZWFyIHdoZXRoZXIgcmVtb3ZpbmcgdGhlIG9wdGltaXphdGlvbiBoYXBwZW5l
ZA0KPiA+ID4gPiBpbmFkdmVydGVudGx5IG9yIG5vdC4NCj4gPiA+ID4gDQo+ID4gPiA+IEFzIHRo
ZSBvcmlnaW5hbCBjb21taXQgbWVzc2FnZSBvZiB0aGUgb3B0aW1pemF0aW9uIGV4cGxhaW5zIHRo
ZXJlIGlzIG5vDQo+ID4gPiA+IHBvaW50IGNvbnNpZGVyaW5nIHRoZSBjaGlsZHJlbiBvZiBhIHN1
YnRyZWUgaW4gZmluZF9uZXh0X2lvbWVtX3JlcygpIGlmDQo+ID4gPiA+IHRoZSB0b3AgbGV2ZWwg
cmFuZ2UgZG9lcyBub3QgbWF0Y2guIFJlaW5zdGF0aW5nIHRoZSBvcHRpbWl6YXRpb24gcmVzdWx0
cw0KPiA+ID4gPiBpbiBzaWduaWZpY2FudCBwZXJmb3JtYW5jZSBpbXByb3ZlbWVudHMgaW4gc3lz
dGVtcyB3aXRoIHZlcnkgbGFyZ2UgaW9tZW0NCj4gPiA+ID4gbWFwcyB3aGVuIG1tYXBpbmcgL2Rl
di9tZW0uDQo+ID4gPiANCj4gPiA+IEl0IHdvdWxkIGJlIGdyZWF0IGlmIHdlIGNvdWxkIHF1YW50
aWZ5ICJzaWduaWZpY2FudCBwZXJmb3JtYW5jZQ0KPiA+ID4gaW1wcm92ZW1lbnRzIj8NCj4gPiAN
Cj4gPiBIaSBBbmRyZXcgYW5kIEFuZHksDQo+ID4gDQo+ID4gWW91IGFyZSByaWdodCB0byBjYWxs
IHRoYXQgb3V0IGFuZCBhcG9sb2dpZXMgZm9yIGxlYXZpbmcgaXQgdmFndWUuDQo+ID4gDQo+ID4g
SSd2ZSBkb25lIG15IHRlc3Rpbmcgd2l0aCBvbGRlciBrZXJuZWwgdmVyc2lvbnMgaW4gc3lzdGVt
cyB3aGVyZSBgd2MgLWwNCj4gPiAvcHJvYy9pb21lbWAgY2FuIHJldHVybiB+NWsuIEluIHRoYXQg
ZW52aXJvbm1lbnQgSSBzZWUgbW1hcGluZyBwYXJ0cyBvZg0KPiA+IC9kZXYvbWVtIHRha2luZyA3
MDAtMTUwMM68cyB3aXRob3V0IHRoZSBvcHRpbWlzYXRpb24gYW5kIDEwLTUwzrxzIHdpdGggdGhl
DQo+ID4gb3B0aW1pc2F0aW9uLg0KPiA+IA0KPiA+IFRoZSByZWFsLXdvcmxkIHVzZSBjYXNlIHdl
IGNhcmUgYWJvdXQgaXMgaHlwZXJ2aXNvciBsaXZlIHVwZGF0ZSB3aGVyZSBoYXZpbmcgdG8NCj4g
PiBkbyBsb3RzIG9mIHRoZXNlIG1tYXBzKCkgc2VyaWFsbHkgY2FuIHNpZ25pZmljYW50bHkgYWZm
ZWN0IHRoZSBndWVzdCBkb3dudGltZQ0KPiA+IGlmIHRoZSBjb3N0IGlzIDIwLTMweC4NCj4gDQo+
IFRoYW5rcyBmb3IgcHJvdmlkaW5nIHRoaXMgaW5mb3JtYXRpb24uDQo+IA0KPiA+ID4gSXQgYWxz
byB3b3VsZCBiZSBnb29kIHRvIGtub3cgd2hpY2ggZXhhY3QgZnVuY3Rpb24ocykgaXMgYSBib3R0
bGVuZWNrLg0KPiA+IA0KPiA+IFBlcmYgdHJhY2luZyBzaG93cyB0aGF0IH45NSUgb2YgQ1BVIHRp
bWUgaXMgc3BlbnQgaW4gZmluZF9uZXh0X2lvbWVtX3JlcygpLA0KPiANCj4gSGF2ZSB5b3UgaW52
ZXN0aWdhdGVkIHBvc3NpYmlsaXR5IHRvIHJldHVybiB0aGF0IGNoZWNrIGRpcmVjdGx5IGludG8N
Cj4gdGhlIGN1bHByaXQ/DQo+IA0KPiANCg0KSSdtIHNvcnJ5LCBJIGRvbid0IHVuZGVyc3RhbmQg
dGhpcy4gQ291bGQgeW91IHBsZWFzZSBjbGFyaWZ5IHdoYXQgeW91IG1lYW4/DQpXaGF0IGRvIHlv
dSBjb25zaWRlciB0byBiZSB0aGUgY3VscHJpdCBhbmQgd2hpY2ggY2hlY2sgZG8geW91IHJlZmVy
IHRvPw0K

