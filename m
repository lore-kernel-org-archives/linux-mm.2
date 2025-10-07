Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E57CBCCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 07:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35A938E000F; Tue,  7 Oct 2025 03:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3320F8E0005; Tue,  7 Oct 2025 03:07:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 221198E000F; Tue,  7 Oct 2025 03:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E0D78E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:07:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C12B4160841
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:07:24 +0000 (UTC)
X-FDA: 83970437208.21.216F694
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf12.hostedemail.com (Postfix) with ESMTP id 83C5A40014
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:07:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=p2Q9bgjL;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf12.hostedemail.com: domain of "prvs=3686b0949=acsjakub@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=3686b0949=acsjakub@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759820842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRhaLNGyZU7w5yRcM/FXYdLrSM4H89YmLx4vMGpLR80=;
	b=IFBGKJM7YktLsYySOeX9huDfhMldKgVwBH1n8qeSyT+yopGzz02+RH79Ov/RRlsw6WNEMN
	5ilHkeCzwDkGmm7ZpI+52zZn4sROPJTm6UCvX+bLISk9U1p0wXTMypEj+9jEw7nAnKX2ps
	eJK3IhMYI1FgH+ftxHssA69lDzsGB1A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759820842; a=rsa-sha256;
	cv=none;
	b=D8+nyR6WAafvCHY1MRnx279HIUsqAEm07lLNdJUfMFn5qvaKDUmApLhmxfEqK9ciCwpsH0
	uzLhiNQQG6mX9dHz++sVZ2FrspB4XOrUOcVsDwCCyTXx4U9jNUMiE8YQqwSlRds2pmwtZ1
	hrX7Pz6IFlrtkcAJJlzcQxa2Bz87O1o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=p2Q9bgjL;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf12.hostedemail.com: domain of "prvs=3686b0949=acsjakub@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=3686b0949=acsjakub@amazon.de"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1759820842; x=1791356842;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=PRhaLNGyZU7w5yRcM/FXYdLrSM4H89YmLx4vMGpLR80=;
  b=p2Q9bgjLFbNPx4R5s+nwVRezVecq82XFhx5RXczJOyZmCsBfe5ioSSac
   IYFbRcicsYnkEZMjr7RTamFIHe9h3sJr+BoNuGMpwVrncvd75i6Vxs/Kq
   pvy6MxxstrR0r1SgbJWwz42n3GYzbiJF6AalL1zNh6WGv7Au35T/iw88L
   3851qEhR1lmgrhZXSywv4wPtoJ6qlH33mdBRQSTlqWwyeg14xhrXzUkHn
   mka00orPcG9DntEVk/PmEW40c11EkSr+qzrzyWdauAN4yJ0cr/QDyDfqo
   8ghZNAEbfoCAl9UCFbBdYqii9BSnx2ipQ+Lvx0PgJMzsAQZVqDqbTgkCd
   g==;
X-CSE-ConnectionGUID: cPL34nEPQyC4pIgpm4tsig==
X-CSE-MsgGUID: 7S4WtF34QK6dV8dXaOE8Yw==
X-IronPort-AV: E=Sophos;i="6.18,321,1751241600"; 
   d="scan'208";a="4313107"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2025 07:07:19 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.38.20:63969]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.35.225:2525] with esmtp (Farcaster)
 id 99f6e941-b7d0-4ce2-94cd-e7e14d176133; Tue, 7 Oct 2025 07:07:19 +0000 (UTC)
X-Farcaster-Flow-ID: 99f6e941-b7d0-4ce2-94cd-e7e14d176133
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 7 Oct 2025 07:07:18 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Tue, 7 Oct 2025
 07:07:17 +0000
Date: Tue, 7 Oct 2025 07:07:14 +0000
From: Jakub Acs <acsjakub@amazon.de>
To: John Hubbard <jhubbard@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda
	<miguel.ojeda.sandonis@gmail.com>, kernel test robot <lkp@intel.com>,
	<llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>, "Linux Memory
 Management List" <linux-mm@kvack.org>, <rust-for-linux@vger.kernel.org>
Subject: Re: [linux-next:master 13069/13300] error[E0425]: cannot find value
 `VM_MERGEABLE` in crate `bindings`
Message-ID: <20251007070611.GA88971@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
References: <202510030449.VfSaAjvd-lkp@intel.com>
 <20251002141925.ab86656b1d50f6e27f216209@linux-foundation.org>
 <CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com>
 <20251002152753.c756678dfdcf739e2fbf74f7@linux-foundation.org>
 <CANiq72kWWPAZ3gq2ktMpVeMKpWOU1nAmYi-4d-BgbuDti77ggg@mail.gmail.com>
 <20251002154323.ca15e98421255ae2978e8d6b@linux-foundation.org>
 <cd2ea7d4-6b12-4933-b1ae-cd4db18d3671@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <cd2ea7d4-6b12-4933-b1ae-cd4db18d3671@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D039UWA002.ant.amazon.com (10.13.139.32) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Transfer-Encoding: base64
X-Rspamd-Server: rspam01
X-Stat-Signature: rodqhagaysh6u8s53wnns1dzfcbqgx8z
X-Rspam-User: 
X-Rspamd-Queue-Id: 83C5A40014
X-HE-Tag: 1759820842-535885
X-HE-Meta: U2FsdGVkX1/lxua/YiMs1UUlPGkjohiHSuwrXwd4E8kH3yc7TKMll8FSHRbZXCcOeBVevVQFpmNd44nXSRV4ucJsB1uywaPbKg8mrEXy3bJ7rJe3D7qrdPnsvNfoRyzBXo0Qy13O45MPaQNfWXcdTEBcc1OBAnVdYfSTlx8ADFaNXl/GGo34nNVqhvb7UwAw7vsuO7g4l0GigNbkHzoxeXc4TsJjsPTeyroyYAAf7WkP6EZXuWFOskYr2n6LeqGftWtNnv6p/AAn11EsU8jaIcXFNNnc9OJ6u0xXw75hLWIKHsmTIOL4bnJVYju3G6QTkrtZdl73irGTjGJXANS5B1i7+sowOyB1U7gR/F2LSoZy4I1OvrAFdF0+QHwPg+FZng0HzUWQSleCE0lEYPOqp/IJltRVqpC2jIGhb6w0vLzzLI4qMaBgtAmFetoVlNz8se4RMP0S0tWTPEeAkv23mlhFZnZ5tHtOkAOFxt2z+SBlUp0rtGIyE6De2Vz9Y794OjYOa104mWNlsMiQDbngVCx5+qzhTtWWGwZmJ9F3FxJSB0L8d+b+h9bZZfH3eTmKpTYWTo+kx7KsMm1usyumTzASWpuvDZUj8MCfmlO/OXhUBgqg0Mjcqbjcc5PKrpV58Z3xCYdykD9yhSl5YidWjJjc+Fg049TJth4L9psZtQAuLaK99CgRS4Kej2xpTIubfesMB8Ffz/5Qvy0Ex00j3m35VfXLUiq0CRWGQg44lg4yzzdph0t7TDQQ9zeeOQRDwQlS+sS+m7mZ6p+FhP9bY8qoXA5QsWNRBl5ogPwIS303JDggYBW0ljbTVcg1EkZgdKDGT3JnCPWvFI4mh6iTt6WRChHJwvVe88OJKTQBKxJF6BU7tLObdl4+hP3hSc7o3Rm7LU2vQ+jtBD2VJytB/5GF0dk3AkPdffgULsjX8C+EiZYI8t95lKlsVxn/5Xc6oQvc+MPLYnis27hO3YI
 MnhDtcKD
 aJ5aTF3aAzPh17mwOwwDbyWLeWm8l3cOzxY6rcD2m7ZqnnF+XhH6DqIIDwRkxDcz1dMD0K22PhIVLxumicjWrHZeRMftJlWmlGyIOQEt4J5n1yAl9+bZzTNloTLSqbe3ljjeVLJoEd372NO9n4u+avOoZiA3n0RqLhbfjaN9tyu45dV4fdB+0EIBJQXd/i2jJ/qnXciS74HSOZivAQyAVlmJhrUYjybBEQRdBxSuab1jnB2cWwWwarrTAaYi8Ujbihe4l6jL+8Um5qoTtJo7VF84lM6P/vSdDWtOomsJcpgP3yzVcnqqqlPQLuGpAYqCVlPM56cQw2C2fwaWOIiLzgpHTELElfrBS3xf0Byo1Sl6IdUdaSabjradgJ8mnSDwMhFQCVphYvICIJ3qqMtQ+ciNUm8E8U4UgDPNv1QZ06vCI+BWCgN8T7ZNrBt6fclnLQA6CYSkYcWUkX0QSZ3IG9PIblYw4hQUM5g4zOtoDQpy5rg9cv7idZGJ5s5/SVcuuXe9+08KaQh4W1cBb38sjr603cVE8bbBDd9IqxrnY6ZHxDwR9YfPjLe3wKgl1GEvFoliAg6SMOaiTX3nshfX7ccv4fED+DYNe5Ct9mHLHdIqhtXQDQTtxu9u5Q/LUGzjkDIH+LoEFulKU4xXZ4OQOdayDnuFY6EYSP7ECrIcl7V4gVsT9BIG75xwhxT16qH2Rj/XOvxMtQgG4cujkTwWRZtE9WBpvd1NGwDfp//q1tm+PPlXn/13/4X5MStcT1YxbKuR/IdvN8ayyco0/CsXXsj5Rx0Wa+CasVwl7obZMtcE9Fwkz2yk9by2+kfIGBmHSQrGHE6/o8VGZ58CZ4Rws4qn7Z+HvYY/vKrI5Y6HN1VacX70/jP89N885JeEC+aXLMYSw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCBPY3QgMDIsIDIwMjUgYXQgMDU6MjQ6NDhQTSAtMDcwMCwgSm9obiBIdWJiYXJkIHdy
b3RlOgo+IE9uIDEwLzIvMjUgMzo0MyBQTSwgQW5kcmV3IE1vcnRvbiB3cm90ZToKPiA+IE9uIEZy
aSwgMyBPY3QgMjAyNSAwMDozOToxNiArMDIwMCBNaWd1ZWwgT2plZGEgPG1pZ3VlbC5vamVkYS5z
YW5kb25pc0BnbWFpbC5jb20+IHdyb3RlOgo+ID4+IE9uIEZyaSwgT2N0IDMsIDIwMjUgYXQgMTI6
MjfigK9BTSBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPiB3cm90ZToK
PiAuLi4KPiA+IEZyb206IEFuZHJldyBNb3J0b24gPGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+
Cj4gPiBTdWJqZWN0OiBtbS1rc20tZml4LWZsYWctZHJvcHBpbmctYmVoYXZpb3ItaW4ta3NtX21h
ZHZpc2UtZml4Cj4gPiBEYXRlOiBUaHUgT2N0ICAyIDAzOjM3OjQ3IFBNIFBEVCAyMDI1Cj4gPiAK
PiA+IFJ1c3QgYmluZGdlbiB3YXNuJ3QgYWJsZSB0byBoYW5kbGUgdGhlIEJJVCgpIG1hY3JvLiAg
QWRkIGEgaGVscGVyIChmcm9tCj4gPiBNaWd1ZWwpIHRvIGZpeCB0aGlzLgo+ID4gCj4gPiBSZXBv
cnRlZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+Cj4gPiBDbG9zZXM6IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL29lLWtidWlsZC1hbGwvMjAyNTEwMDMwNDQ5LlZmU2FBanZk
LWxrcEBpbnRlbC5jb20vCj4gPiBDYzogQXhlbCBSYXNtdXNzZW4gPGF4ZWxyYXNtdXNzZW5AZ29v
Z2xlLmNvbT4KPiA+IENjOiBDaGVuZ21pbmcgWmhvdSA8Y2hlbmdtaW5nLnpob3VAbGludXguZGV2
Pgo+ID4gQ2M6IERhdmlkIEhpbGRlbmJyYW5kIDxkYXZpZEByZWRoYXQuY29tPgo+ID4gQ2M6IEph
a3ViIEFjcyA8YWNzamFrdWJAYW1hem9uLmRlPgo+ID4gQ2M6IFBldGVyIFh1IDxwZXRlcnhAcmVk
aGF0LmNvbT4KPiA+IENjOiBTZW9uZ0phZSBQYXJrIDxzakBrZXJuZWwub3JnPgo+ID4gQ2M6IFh1
IFhpbiA8eHUueGluMTZAenRlLmNvbS5jbj4KPiA+IENjOiBNaWd1ZWwgT2plZGEgPG1pZ3VlbC5v
amVkYS5zYW5kb25pc0BnbWFpbC5jb20+Cj4gPiBDYzogQWxpY2UgUnlobCA8YWxpY2VyeWhsQGdv
b2dsZS5jb20+Cj4gPiBTaWduZWQtb2ZmLWJ5OiBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZv
dW5kYXRpb24ub3JnPgo+ID4gLS0tCj4gPiAKPiA+ICBydXN0L2JpbmRpbmdzL2JpbmRpbmdzX2hl
bHBlci5oIHwgICAgMSArCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCj4gPiAK
PiA+IC0tLSBhL3J1c3QvYmluZGluZ3MvYmluZGluZ3NfaGVscGVyLmh+bW0ta3NtLWZpeC1mbGFn
LWRyb3BwaW5nLWJlaGF2aW9yLWluLWtzbV9tYWR2aXNlLWZpeAo+ID4gKysrIGEvcnVzdC9iaW5k
aW5ncy9iaW5kaW5nc19oZWxwZXIuaAo+ID4gQEAgLTk5LDMgKzk5LDQgQEAgY29uc3QgeGFfbWFy
a190IFJVU1RfQ09OU1RfSEVMUEVSX1hBX1BSRQo+ID4gIAo+ID4gIGNvbnN0IGdmcF90IFJVU1Rf
Q09OU1RfSEVMUEVSX1hBX0ZMQUdTX0FMTE9DID0gWEFfRkxBR1NfQUxMT0M7Cj4gPiAgY29uc3Qg
Z2ZwX3QgUlVTVF9DT05TVF9IRUxQRVJfWEFfRkxBR1NfQUxMT0MxID0gWEFfRkxBR1NfQUxMT0Mx
Owo+ID4gK2NvbnN0IHZtX2ZsYWdzX3QgUlVTVF9DT05TVF9IRUxQRVJfVk1fTUVSR0VBQkxFID0g
Vk1fTUVSR0VBQkxFOwo+ID4gXwo+IAo+IFllcywgdGhpcyBmaXhlcyB0aGUgYnVpbGQgb24gbXkg
c3lzdGVtIHRvbywgc286Cj4gCj4gVGVzdGVkLWJ5OiBKb2huIEh1YmJhcmQgPGpodWJiYXJkQG52
aWRpYS5jb20+Cj4gCj4gLi4ub2YgY291cnNlLCB3ZSdsbCBoYXZlIHRvIHVuZG8gdGhpcyBsYXRl
ciwgYXMgcGFydCBvZiB0aGUgZml4Cj4gZm9yIHRoZSBSdXN0IGZvciBMaW51eCBidWlsZCBzeXN0
ZW0sIHRvIGhhbmRsZSBCSVQoKSBhbmQgc2ltaWxhcgo+IG1hY3JvcyBpbiBiaW5kZ2VuLgo+IAoK
SGksIAoKc29ycnkgZm9yIHRoZSBpc3N1ZXMgdGhpcyBoYXMgY2F1c2VkLiBXZSdyZSBhbHNvIGNo
YW5naW5nIHRoZSBvdGhlcgpkZWZpbmVzIHRvIEJJVCgpIGZvciBjb25zaXN0ZW5jeSwgaXQgd2Fz
IGFwcGxpZWQgdG8gbW0tbmV3IGluIFsxXS4gSQphc3N1bWUgdGhpcyB3aWxsIGhhdmUgdGhlIHNh
bWUgYnJlYWtpbmcgZWZmZWN0LiBOb3Qgc3VyZSB3aGF0IGlzIHRoZQpzb2x1dGlvbiAtIHdoZXRo
ZXIgdG8gd2FpdCBmb3IgdGhlIGZpeCBtZW50aW9uZWQgYnkgSm9obiBvciBhZGQgc2ltaWxhcgpk
ZWZpbnRpb25zIHRvIGEvcnVzdC9iaW5kaW5ncy9iaW5kaW5nc19oZWxwZXIuaCBmb3IgYWxsIGNv
bnN0cz8KClsxXTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjUxMDAyMjAyMTEyLkMy
MjkzQzRDRUY0QHNtdHAua2VybmVsLm9yZy8KCktpbmQgUmVnYXJkcywKSmFrdWIKCgoKQW1hem9u
IFdlYiBTZXJ2aWNlcyBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJIClRhbWFyYS1EYW56
LVN0ci4gMTMKMTAyNDMgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxh
ZWdlcgpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIg
MjU3NzY0IEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMzY1IDUzOCA1OTcK


