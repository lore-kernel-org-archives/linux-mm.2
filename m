Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 605C3CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 09:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4EA8E0008; Thu,  4 Sep 2025 05:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B553C8E0002; Thu,  4 Sep 2025 05:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A929C8E0008; Thu,  4 Sep 2025 05:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9590F8E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 05:36:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 43DD01DF583
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:36:16 +0000 (UTC)
X-FDA: 83851061952.25.04E780D
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2C6C710000F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:36:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=L50PUVgt;
	spf=pass (imf05.hostedemail.com: domain of "prvs=335c1cc80=epetron@amazon.de" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=335c1cc80=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756978574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wjGzphpQSmdgD73ekPijlgtAxRIRaR7CsFHs0fRNlso=;
	b=Q6N7QKRPnDymAq72hFgIKDtQYYt/R+B03RWawBmxMXjYWXVPHdbshudMFgMAZpAyFlV3mF
	mwtaX096aV18MXIgOlF48dbxXZNW6kawSwd3KyO/VWQIaDCFtC7Mqn8nTHY6F1e/6k3Mpu
	JwV06vColETf7USDEPnOcZKbau0XFc8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=L50PUVgt;
	spf=pass (imf05.hostedemail.com: domain of "prvs=335c1cc80=epetron@amazon.de" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=335c1cc80=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756978574; a=rsa-sha256;
	cv=none;
	b=YMXaNV/r3hpDLkfvDQxfYoRxP2xUWKQAhJQIniCvSxdLAUR1n50Q6nLfykp1PxtGMihrzR
	Otypg1gDSmi8JWuMJWbiNAOd+GgpaZZ/Y7VQYRs+zIhv7cE3tvYZMnEmmS1O+8xpXQ3NMR
	d1T/x3388MQ9T8dAUrR2FaQQq9BCV9M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1756978574; x=1788514574;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wjGzphpQSmdgD73ekPijlgtAxRIRaR7CsFHs0fRNlso=;
  b=L50PUVgtDx/6tL/IYEinWF/jRXz2wJ8sqPIGOkDU/4qRtAFjkQiJo1MF
   J5P1VlO0hud78GA4G0t8riCj6cVzDN/hWRqxMzM8LRyNBCv/5o5NrrtGi
   5KoBDoDEkWf/FnsHttrQvZPsIcHI03o2WusxqTGRL7Nck95z8Y2HZyT1p
   LdSI+Dw+XhKcQAaORCxqmeNsFTlo0M2sGBorHyIKzpW26aEDp946qyrMa
   3dg/GVJlrtitQ3xKe4/hsbgEk20hqbUCYFX9VQQBmiq4e8LwCantodsR1
   XCY7g9iGI2pBDBt51/9AJ9PSKqDx/8+6p2VJJWeap5rCctbrG/XfgNdhm
   w==;
X-CSE-ConnectionGUID: bjc+8o0ZQjSAH2UyMvYysw==
X-CSE-MsgGUID: 4EwNZJGCR2GA8AZ5/CtUCA==
X-IronPort-AV: E=Sophos;i="6.18,238,1751241600"; 
   d="scan'208";a="2272356"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 09:36:11 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.21.151:47410]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.63.19:2525] with esmtp (Farcaster)
 id 67cfe508-291c-474a-991f-c5f04ba32975; Thu, 4 Sep 2025 09:36:10 +0000 (UTC)
X-Farcaster-Flow-ID: 67cfe508-291c-474a-991f-c5f04ba32975
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 4 Sep 2025 09:36:10 +0000
Received: from dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com
 (10.253.109.105) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 4 Sep 2025
 09:36:08 +0000
From: Evangelos Petrongonas <epetron@amazon.de>
To: <ardb@kernel.org>, Evangelos Petrongonas <epetron@amazon.de>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <bhe@redhat.com>, <changyuanl@google.com>, <graf@amazon.com>,
	<kexec@lists.infradead.org>, <linux-efi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<nh-open-source@amazon.com>, <rppt@kernel.org>
Subject: Re: Re: [PATCH v3 2/2] efi: Support booting with kexec handover (KHO)
Date: Thu, 4 Sep 2025 09:34:09 +0000
Message-ID: <20250904093455.73184-1-epetron@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAMj1kXFzKzpoqczq7Rk-u+kKLFO057XEXMD+KM=iRMMsoUZbJA@mail.gmail.com>
References: <cover.1755721529.git.epetron@amazon.de> <b34da9fd50c89644cd4204136cfa6f5533445c56.1755721529.git.epetron@amazon.de> <CAMj1kXFQwOHyQg2LtabMA3qxiBn_AVV_JNfki2WPSg8u_XbBcg@mail.gmail.com> <CAMj1kXFzKzpoqczq7Rk-u+kKLFO057XEXMD+KM=iRMMsoUZbJA@mail.gmail.com>
MIME-Version: 1.0
X-Originating-IP: [10.253.109.105]
X-ClientProxiedBy: EX19D044UWA003.ant.amazon.com (10.13.139.43) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Rspamd-Queue-Id: 2C6C710000F
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: w5e94i1ybitsrmwseoxbakin91qbsej4
X-HE-Tag: 1756978573-800920
X-HE-Meta: U2FsdGVkX1+VAihxxWFpII5blygdSmxIbLT1UrF4HmCKm6CTvywbkncubXQjfkX2DRHGmC4oKKEwpCsbtWmIXmohPW+aDA7SRzYeJcLcF2d2CY7RXttHZGOefjyD3MQYGUX8gFBebh4v5LIRCViKAnDkI8A4rB0Pn8Yip7MjYAtorhQUY3ciiOS3GMKc/PIM35gYVtvZ5WLNwEsVjqwtju0hdw6+ZFFBU6OYna+sHRsETLjO2UoBJqTetyNrgLO9da4i/WzEMOMYCwZDjlHm2GlVd3SB73cvwYcJQ6wUa1VBhgvd4594ILNTvJRQMcklD9buxJRvQ/04OnVXNKAMcfIoQp8M7sEAnqPKqPATTdy2K3M9TJ+p0XYFceEcbBV4Muw5c99U0sSrbCApgrcgDjC2w4mrafwvpcNvMdVV62/nsrarOhdcoO1kBqAHzsG3175Y9G9ScXl3C9gYQqx5cuaLen7sGaAfWNyIhfF70RBdRXbiTTWl39BUPwds6xwcWUxxICYNfRRxs5Ro4PBAgKAjaCol3NUBvgJtEHVqSgHuMsI86G3sB8zk2LUhghZSty+ny25xrX+n3SNxip27nT/VGyOXPrj9Rg6o+UnU4Ufmc8iFXSh2eEMJ6P6LS7dpYs5iCNp8ge4H0sZmbUeAX4a8EfAbdMHHTkf7ImtFfzItg1PYBF1uw6z2ZyW4kuoQl6WDPKd9M2/+sHCpymrgwRXrybklj+IUlCicT7Ra2YsujJLrrFc0Xqc/huhk1pDHzLHVEBwLC3EtoiIRL8wwUpppKvQdXkrJxiUUc9vmwYBFVm2YY0AezXf5HJHe6QLEv/4sfqpySQN1GTWsSPrF99rxslamsmdCBcW3Y3vIh3DvKVhQur67svXuWjjxsl2NcKcGLRA3UrMyMOdbe8ICyV9dmTr5kDOrpXW+daqswpHSv9LmI4sUxAWDD8sZPoacQAsO93lbmTO/VfktFL8
 pSfrEixR
 0cs71SGFbHCR2gUy45GWFKiTTLd6EwdkFtPNQVNeID8LiHFnUoANH0Duyok7I1LBO54n9zPiRVRciPt4dchVfgaqAbll+MZcSXczdI+FL4XMCwFh+jIO4cLdfH1zYSU7Ah25+/Kvgv4xQRKHILRYrPVp5H2LqX33OdOYlf3MTLbpU9w+IBXian3yEH4zzSLLBWHs9TCpxeZyam3RwvDFwS0glazBbuQPBG1MNOrMSU4vjPTwXBZ+sP9JOMOf7nxgQ1Y335uR/6dwRtzgMN4okM503Od2L47XNyyx7SZ9VKdI7dGhvPg7M67vzfvvPxS8MJbMvHPTB9fv7g/PGapU2s1R/UlhsdXJfutBVTbk4HL+AAJHmJb0MD0hocWTk+VZsjtoMQbonLjc8l7ab1o7jWBOof6Ng1iSicrAIukHYo3e7p0584sfclGc7B1sDFKGAYx4efeMxGUmrHMXFUU7X5drrTf0hCs2c/dmflXBEgIZeS29DDAMf1DjLH6c9Mds2BYFhh3oRbz3/alYnqbLrp1xp2T0BZN+gH0wM67fVAQHF5N1vmvkzxBf0vMeKvb8BpDjPvMLDh1+51iTbwWQU/epbSXJR610wajdi1CfDDeSnCy9AF8fBdnXKLcdb5ATP44i6cSlHwFMSz3bzBztXhbagHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCA0IFNlcCAyMDI1IDA5OjE5OjIxICswMjAwLCBBcmQgQmllc2hldXZlbCA8YXJkYkBr
ZXJuZWwub3JnPiB3cm90ZToKPiBPbiBTYXQsIDIzIEF1ZyAyMDI1IGF0IDIzOjQ3LCBBcmQgQmll
c2hldXZlbCA8YXJkYkBrZXJuZWwub3JnPiB3cm90ZToKPiA+Cj4gPiAoY2MgSWxpYXMpCj4gPgo+
ID4gTm90ZSB0byBha3BtOiBwbGVhc2UgZHJvcCB0aGlzIHNlcmllcyBmb3Igbm93Lgo+ID4KPiA+
IE9uIEZyaSwgMjIgQXVnIDIwMjUgYXQgMDQ6MDAsIEV2YW5nZWxvcyBQZXRyb25nb25hcyA8ZXBl
dHJvbkBhbWF6b24uZGU+IHdyb3RlOgo+ID4gPgo+ID4gPiBXaGVuIEtITyAoS2V4ZWMgSGFuZE92
ZXIpIGlzIGVuYWJsZWQsIGl0IHNldHMgdXAgc2NyYXRjaCBtZW1vcnkgcmVnaW9ucwo+ID4gPiBl
YXJseSBkdXJpbmcgZGV2aWNlIHRyZWUgc2Nhbm5pbmcuIEFmdGVyIGtleGVjLCB0aGUgbmV3IGtl
cm5lbAo+ID4gPiBleGNsdXNpdmVseSB1c2VzIHRoaXMgcmVnaW9uIGZvciBtZW1vcnkgYWxsb2Nh
dGlvbnMgZHVyaW5nIGJvb3QgdXAgdG8KPiA+ID4gdGhlIGluaXRpYWxpemF0aW9uIG9mIHRoZSBw
YWdlIGFsbG9jYXRvcgo+ID4gPgo+ID4gPiBIb3dldmVyLCB3aGVuIGJvb3Rpbmcgd2l0aCBFRkks
IEVGSSdzIHJlc2VydmVfcmVnaW9ucygpIHVzZXMKPiA+ID4gbWVtYmxvY2tfcmVtb3ZlKDAsIFBI
WVNfQUREUl9NQVgpIHRvIGNsZWFyIGFsbCBtZW1vcnkgcmVnaW9ucyBiZWZvcmUKPiA+ID4gcmVi
dWlsZGluZyB0aGVtIGZyb20gRUZJIGRhdGEuIFRoaXMgZGVzdHJveXMgS0hPIHNjcmF0Y2ggcmVn
aW9ucyBhbmQKPiA+ID4gdGhlaXIgZmxhZ3MsIHRodXMgY2F1c2luZyBhIGtlcm5lbCBwYW5pYywg
YXMgdGhlcmUgYXJlIG5vIHNjcmF0Y2gKPiA+ID4gbWVtb3J5IHJlZ2lvbnMuCj4gPiA+Cj4gPiA+
IEluc3RlYWQgb2Ygd2hvbGVzYWxlIHJlbW92YWwsIGl0ZXJhdGUgdGhyb3VnaCBtZW1vcnkgcmVn
aW9ucyBhbmQgb25seQo+ID4gPiByZW1vdmUgbm9uLUtITyBvbmVzLiBUaGlzIHByZXNlcnZlcyBL
SE8gc2NyYXRjaCByZWdpb25zLCB3aGljaCBhcmUKPiA+ID4gZ29vZCBrbm93biBtZW1vcnksIHdo
aWxlIHN0aWxsIGFsbG93aW5nIEVGSSB0byByZWJ1aWxkIGl0cyBtZW1vcnkgbWFwLgo+ID4gPgo+
ID4gPiBBY2tlZC1ieTogTWlrZSBSYXBvcG9ydCAoTWljcm9zb2Z0KSA8cnBwdEBrZXJuZWwub3Jn
Pgo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBFdmFuZ2Vsb3MgUGV0cm9uZ29uYXMgPGVwZXRyb25AYW1h
em9uLmRlPgo+ID4gPiAtLS0KPiA+ID4gQ2hhbmdlcyBpbiB2MzoKPiA+ID4gICAgICAgICAtIElt
cHJvdmUgdGhlIGNvZGUgY29tbWVudHMsIGJ5IHN0YXRpbmcgdGhhdCB0aGUgc2NyYXRjaCByZWdp
b25zIGFyZQo+ID4gPiAgICAgICAgIGdvb2Qga25vd24gbWVtb3J5Cj4gPiA+Cj4gPiA+IENoYW5n
ZXMgaW4gdjI6Cj4gPiA+ICAgICAgICAgLSBSZXBsYWNlIHRoZSBmb3IgbG9vcCB3aXRoIGZvcl9l
YWNoX21lbV9yZWdpb24KPiA+ID4gICAgICAgICAtIEZpeCBjb21tZW50IGluZGVudGF0aW9uCj4g
PiA+ICAgICAgICAgLSBBbWVuZCBjb21taXQgbWVzc2FnZSB0byBzcGVjaWZ5IHRoYXQgc2NyYXRj
aCByZWdpb25zCj4gPiA+ICAgICAgICAgYXJlIGtub3duIGdvb2QgcmVnaW9ucwo+ID4gPgo+ID4g
PiAgZHJpdmVycy9maXJtd2FyZS9lZmkvZWZpLWluaXQuYyB8IDI5ICsrKysrKysrKysrKysrKysr
KysrKysrKystLS0tCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMjUgaW5zZXJ0aW9ucygrKSwgNCBk
ZWxldGlvbnMoLSkKPiA+ID4KPiA+Cj4gPiBJJ2QgcmF0aGVyIGRyb3AgdGhlIG1lbWJsb2NrX3Jl
bW92ZSgpIGVudGlyZWx5IGlmIHBvc3NpYmxlLiBDb3VsZCB3ZQo+ID4gZ2V0IHNvbWUgaW5zaWdo
dCBpbnRvIHdoZXRoZXIgbWVtYmxvY2tzIGFyZSBnZW5lcmFsbHkgYWxyZWFkeQo+ID4gcG9wdWxh
dGVkIGF0IHRoaXMgcG9pbnQgZHVyaW5nIHRoZSBib290Pwo+ID4KPiA+Cj4gCj4gUGluZz8KCkhl
eSBBcmQgSSB3YXMgQUZLIHRyYXZlbGxpbmcuIEkgYW0gYmFjayBub3cgYW5kIHdpbGwgZ2V0IHRv
IGl0LgpQUzogS2VlbiB0byBtZWV0IHlvdSBsYXRlciB0b2RheSBpbiB0aGUgS1ZNIEZvcnVtLgoK
S2luZCBSZWdhcmRzLApFdmFuZ2Vsb3MKCgoKCkFtYXpvbiBXZWIgU2VydmljZXMgRGV2ZWxvcG1l
bnQgQ2VudGVyIEdlcm1hbnkgR21iSApUYW1hcmEtRGFuei1TdHIuIDEzCjEwMjQzIEJlcmxpbgpH
ZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVp
bmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAyNTc3NjQg
QgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAzNjUgNTM4IDU5Nwo=


