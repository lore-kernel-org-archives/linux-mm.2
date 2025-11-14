Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D360CE7A8C
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 09:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9835F8E0014; Fri, 14 Nov 2025 04:01:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9341C8E0011; Fri, 14 Nov 2025 04:01:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A6A8E0014; Fri, 14 Nov 2025 04:01:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 739748E0011
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:01:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38B31581A7
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:01:32 +0000 (UTC)
X-FDA: 84108619224.15.2A93836
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	by imf30.hostedemail.com (Postfix) with ESMTP id C5B3D8001E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:01:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=lDkSCWvG;
	spf=pass (imf30.hostedemail.com: domain of "prvs=406d4a272=graf@amazon.de" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=406d4a272=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763110890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EaIGl6EhlQ4V9CUY31LrgRIkIsFC5ga8p6ILWDzFD84=;
	b=Km26EC6I5KoU5wRYtzr4zigR40BrXcdRSq3wEV7iNp/aSv1fYx7/f0bjZTKo1ijRyGs6Ul
	vdJ9zwuMYP1Y6cG5xznynZmbCD/81dX31Xf3GIBxNyT4A32f04jlwNR3OIWMztPA6erPLT
	5TdCXfNSClgyML5jNQ6YEY+MaZwK6RE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763110890; a=rsa-sha256;
	cv=none;
	b=D3we/0LQWb3/rJ3e6Cm+I3z6FD27hmuKQxo2NTZ4+S0EMVeRpEfFdtxplnBhA8+Uhw1K3a
	uvNn+2bqwCzlxbIxKJKvvWab5tWh2gZWxlaXA/zmxBg3sq+7RF4O14Dp9NOpkiABMz28GF
	OKD6C1FZ/T/U1bFGzDPiNsfg7E401bo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=lDkSCWvG;
	spf=pass (imf30.hostedemail.com: domain of "prvs=406d4a272=graf@amazon.de" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=406d4a272=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1763110889; x=1794646889;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EaIGl6EhlQ4V9CUY31LrgRIkIsFC5ga8p6ILWDzFD84=;
  b=lDkSCWvGS2neFzSWK2iMvyOo1UmmBGhzifdfa5Fh0L5PruYFwSaWhfa3
   ldLilk2d+8089kA0Hfh8mjiTFMCOEkc88LREpRa915ZvLl+v3Ihc3LZEd
   GS+lAeft4bAom/cP/AjxIXPf8W4tuYlrebwNajgP3lWh+yRJXz6vearzG
   +j8B+btaF5kx2JwQCcJNRd8fJf/yu7g3gOevVyEGv8reUR1/apuM7aOw+
   UmSH+awJ4AJZBiuWszMOnSVHfyR/pHXG43gLPl+LSff09PCIl3ji0tOpZ
   1WvTy/zGIoTDgPc0Gsj99pgq/2DzbsgVom1H3clKMRPHQ6BLIZkxGHbDc
   Q==;
X-CSE-ConnectionGUID: Uq1Ipwx9RJW9zvAJniWZLA==
X-CSE-MsgGUID: M25iTk7PRVC43yz2Zp6MFQ==
X-IronPort-AV: E=Sophos;i="6.19,304,1754956800"; 
   d="scan'208";a="7112418"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 09:01:25 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:22919]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.35.95:2525] with esmtp (Farcaster)
 id 7b41653c-f962-4fb6-9b96-b9676b9afb43; Fri, 14 Nov 2025 09:01:25 +0000 (UTC)
X-Farcaster-Flow-ID: 7b41653c-f962-4fb6-9b96-b9676b9afb43
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 14 Nov 2025 09:01:25 +0000
Received: from [0.0.0.0] (172.19.99.218) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Fri, 14 Nov 2025
 09:01:23 +0000
Message-ID: <e6f3c999-7a17-4c6b-8de7-a380cccdde9f@amazon.com>
Date: Fri, 14 Nov 2025 10:01:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] liveupdate: kho: Enable KHO by default
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin
	<pasha.tatashin@soleen.com>
CC: <akpm@linux-foundation.org>, <pratyush@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kexec@lists.infradead.org>,
	<linux-mm@kvack.org>
References: <20251110180715.602807-1-pasha.tatashin@soleen.com>
 <aRbag7qR9OVNAQXN@kernel.org>
Content-Language: en-US
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <aRbag7qR9OVNAQXN@kernel.org>
X-Originating-IP: [172.19.99.218]
X-ClientProxiedBy: EX19D040UWB004.ant.amazon.com (10.13.138.91) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Stat-Signature: rtgw5uqiwgsa5e8qfnqg9kya6ru87pqw
X-Rspam-User: 
X-Rspamd-Queue-Id: C5B3D8001E
X-Rspamd-Server: rspam01
X-HE-Tag: 1763110889-568976
X-HE-Meta: U2FsdGVkX1+DSoDQuYHjqGjUOFa+1vXnVR/xQ3swiVkdxBRWNQHNHsfFnxC0733A9VWt1JLgD3ibitvE6jrwcjWcRRqRrXESJJj3RkIt4umcws9yYnamlIdObzWMFEW3a2rzNlSoc3S1fdGu0BEWZd6x3LlmuXJHayRl2pcaDJL1mUsSAoeIBnWx6mUxFJd/SfQReovZdGYB1gwHwSS+3gQuCkrWSnyXgh/GaqON72U5E5dbAvsBSqim83SAuRKsO8FHg8b/hsjERz5yVX6ZnTjpCl2i44uLYhf+pX9pz9DrucY1f+ZvB17hp+7jr71cRL8/bJVIkCR/HzulYkqB2gcQxuV8IqeypayI8ta9sWtApiTgZhjt8s13+Bugn8Y203Snd508LaO+LTes8DZjzpxwEeLGcqg1rMciCFm1we6bIITODNyPK64IE+k0U1VGtnRe1nFgwMNeoXXiz/5KSVJhjv59BSIapca5kmed1ceHvAMu2grZFQwOWv65y5VaD8cwiK16uHUaSK4vID23c4L1NWLzf2fkxfsonj5+Vxphcs4EK0q3yrjMLV4hdnyxd5FL9yupB7zamDWOdp0HAFpKnrwpJ7uwtqnPQnDSyLnZQNN7nrY5FmYXQgA3zdgxOSIi/Rd4L6ACpZ6c+KTYeMb8Yyfjkp7EnhFKcr2zczTrR4wU8tSIO2CMH2p1uEnBOzgqldKOtEj8mW5GXrUpJTtPxeRnXQgWqwx81Irftt6pfU4wIJrujJZQJKdzUjPtsWcrtjsKWd87K1hfS+FAImKhGe0bdqm/YJgo3IYJZCbgHayghbYwKP6xqhdbH8EpX++A09XYWnrtpJkJoz4ahzQqj1UPyZ7XdkvK8lX1Nkb6ASFBGxA2J5E0v/yVZk6sEK8pRMfn5Rxpqh178XBHrBZtIw+Arzl2jq9Eh5sE521N8nbYMeIvFM/FzI+yt5+OPMWBLJINv1Vocs9kjL5
 R/L/AK76
 BMtJYo4cpV9SmzDcORbI+8dIpcTOgUBK9vkwyw7vIva9WwlfbNkxlGqxJg0yyKM8l7MwuSGpdsG4yYWrNdhHCkYHKIhzYYQCvW6bQZJkOw++Igdc0GYWvmX+DC8kNrChwcLC9XSMiweD6j0yGKUIBdU+opwFlaOCvdqrLqA4eThOpxoKri1CRckeCdCxpkd8k76Pl8TwuzGFMTol5gD1d+gR6IeI25uoMYwnhKqQLfisiATafzKDLd0ZIudkSvEDEyM2+CaQaGPNYEOIYzUaMu6E0RMHxnwFbSQKhmtI9Xf3RpUKRfntA1rH5Gnd2PancgZFDpbx0Lm6mc1tj68yaJAf9IYIxN48iKri7vNC5XpgorMQipRcQBhTa7oUmdpnOtQorrgFGd2auZz3Xjx2K/xq0NyUhrS49l91aMkCBt4kL3eycVaznK/X7y6SUnvuLrvkcrIKekAHySm8jkf19RndyOyOnLYEKIAoyIrBGgknY2d5t4NvrNdu40Mly+QKyD4NkB9xUq51aDYmio5jeVWkqz0mIyu4X/yHPGtEBZSLHRQKjSd8ivCYpz/+aoQ8LxnkLdtPFftAi1vJdDQxatr3hvZCi/20cjoYFFdulKQ61uqlTGlyZFCtFSK8P/zzgIvTauue7+anFJfq0gdPVzEArOYp0ODWsA5FaPdF7Lt7ciJRVHl9ciGLEqoZspFYTb32KrqRN5VCsMfp/ALNoiGn4E6dEFvxPqnZmDD9v+kkQtAbDzcIME/VFTwt6AlbjhSlode0rSiNpacTbbdbb6J5nSiQuY+sGMgGXEENymqo8Ohd/ed96/Aw5kNGJ7s/zkLMQvdOS1t0vqx1KoFOOyK7Okw1h/DNtOatW1I7l9oa+fm0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ck9uIDE0LjExLjI1IDA4OjMwLCBNaWtlIFJhcG9wb3J0IHdyb3RlOgo+IE9uIE1vbiwgTm92IDEw
LCAyMDI1IGF0IDAxOjA3OjE1UE0gLTA1MDAsIFBhc2hhIFRhdGFzaGluIHdyb3RlOgo+PiBVcGNv
bWluZyBMVU8gcmVxdWlyZXMgS0hPIGZvciBpdHMgb3BlcmF0aW9ucywgdGhlIHJlcXVpcmVtZW50
IHRvIHBsYWNlCj4+IGJvdGggS0hPPW9uIGFuZCBsaXZldXBkYXRlPW9uIGJlY29tZXMgcmVkdW5k
YW50LiBTZXQgS0hPIHRvIGJlIGVuYWJsZWQKPj4gYnkgZGVmYXVsdC4KPiBJIHRob3VnaCBtb3Jl
IGFib3V0IHRoaXMgYW5kIGl0IHNlZW1zIHRvbyBtdWNoIG9mIGEgY2hhbmdlLiBraG89MSBlbmFi
bGVzCj4gc2NyYXRjaCBhcmVhcyBhbmQgdGhhdCBzaWduaWZpY2FudGx5IGNoYW5nZXMgaG93IGZy
ZWUgcGFnZXMgYXJlIGRpc3RyaWJ1dGVkCj4gaW4gdGhlIGZyZWUgbGlzdHMuCj4KPiBMZXQncyBn
byB3aXRoIGEgS2NvbmZpZyBvcHRpb24gd2UgZGlzY3Vzc2VkIG9mLWxpc3Q6Cj4gKHRoaXMgaXMg
b24gdG9wIG9mIHRoZSBjdXJyZW50IG1tb3RtL21tLW5vbm1tLXVuc3RhYmxlKQo+Cj4gIEZyb20g
ODIzMjk5ZDgwYWE0ZjdjMTZlZjZjZmQ3OThhMTllMWRmZTFhOTFhYiBNb24gU2VwIDE3IDAwOjAw
OjAwIDIwMDEKPiBGcm9tOiBQYXNoYSBUYXRhc2hpbiA8cGFzaGEudGF0YXNoaW5Ac29sZWVuLmNv
bT4KPiBEYXRlOiBGcmksIDE0IE5vdiAyMDI1IDA5OjI3OjQ3ICswMjAwCj4gU3ViamVjdDogW1BB
VENIXSBraG86IEFsbG93IEtITyB0byBiZSBlbmFibGVkIGJ5IGRlZmF1bHQKPgo+IFVwY29taW5n
IExVTyByZXF1aXJlcyBLSE8gZm9yIGl0cyBvcGVyYXRpb25zLCB0aGUgcmVxdWlyZW1lbnQgdG8g
cGxhY2UKPiBib3RoIEtITz1vbiBhbmQgbGl2ZXVwZGF0ZT1vbiBiZWNvbWVzIHJlZHVudGFudC4g
TGV0J3MgYWxsb3cgS0hPIHRvIGJlCj4gZW5hYmxlZCBieSBkZWZhdWx0LCBhbmQgQ09ORklHX0xJ
VkVVUERBVEUgY2FuIHNlbGVjdCB0aGlzIENPTkZJRy4KCgpMb29rcyBtdWNoIGJldHRlciwgeWVz
IDopLiBZb3UgY2FuIGFsc28gaW1wbHkgdGhpcyBvcHRpb24gYXV0b21hdGljYWxseSAKd2hlbiBM
VU89eS4KClJldmlld2VkLWJ5OiBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPgoKCkFs
ZXgKCgo+Cj4gU2lnbmVkLW9mZi1ieTogUGFzaGEgVGF0YXNoaW4gPHBhc2hhLnRhdGFzaGluQHNv
bGVlbi5jb20+Cj4gU2lnbmVkLW9mZi1ieTogTWlrZSBSYXBvcG9ydCAoTWljcm9zb2Z0KSA8cnBw
dEBrZXJuZWwub3JnPgo+IC0tLQo+ICAga2VybmVsL2xpdmV1cGRhdGUvS2NvbmZpZyAgICAgICAg
ICB8IDggKysrKysrKysKPiAgIGtlcm5lbC9saXZldXBkYXRlL2tleGVjX2hhbmRvdmVyLmMgfCAy
ICstCj4gICAyIGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+
Cj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9saXZldXBkYXRlL0tjb25maWcgYi9rZXJuZWwvbGl2ZXVw
ZGF0ZS9LY29uZmlnCj4gaW5kZXggZDczNDRkMzQ3ZjY5Li4yNWM5YTRkNzc4MWYgMTAwNjQ0Cj4g
LS0tIGEva2VybmVsL2xpdmV1cGRhdGUvS2NvbmZpZwo+ICsrKyBiL2tlcm5lbC9saXZldXBkYXRl
L0tjb25maWcKPiBAQCAtNjMsNCArNjMsMTIgQEAgY29uZmlnIEtFWEVDX0hBTkRPVkVSX0RFQlVH
RlMKPiAgICAgICAgICAgIEFsc28sIGVuYWJsZXMgaW5zcGVjdGluZyB0aGUgS0hPIGZkdCB0cmVl
cyB3aXRoIHRoZSBkZWJ1Z2ZzIGJpbmFyeQo+ICAgICAgICAgICAgYmxvYnMuCj4KPiArY29uZmln
IEtFWEVDX0hBTkRPVkVSX0VOQUJMRV9ERUZBVUxUCj4gKyAgICAgICBib29sICJFbmFibGUga2V4
ZWMgaGFuZG92ZXIgYnkgZGVmYXVsdCIKPiArICAgICAgIGRlcGVuZHMgb24gS0VYRUNfSEFORE9W
RVIKPiArICAgICAgIGhlbHAKPiArICAgICAgICAgRW5hYmxlIHRoZSBrZXhlYyBoYW5kb3ZlciBi
eSBkZWZhdWx0LiBJdCBpcyBlcXVpdmFsZW50IG9mIHBhc3NpbmcKPiArICAgICAgICAga2hvPW9u
IHZpYSBrZXJuZWwgcGFyYW1ldGVyLCBhbmQgY2FuIGJlIG92ZXJ3cml0dGVuIHRvIG9mZiB2aWEK
PiArICAgICAgICAga2hvPW9mZi4KPiArCj4gICBlbmRtZW51Cj4gZGlmZiAtLWdpdCBhL2tlcm5l
bC9saXZldXBkYXRlL2tleGVjX2hhbmRvdmVyLmMgYi9rZXJuZWwvbGl2ZXVwZGF0ZS9rZXhlY19o
YW5kb3Zlci5jCj4gaW5kZXggNTY4Y2Q5ZmU5YWNhLi4yM2EzZGYyOTdiYjMgMTAwNjQ0Cj4gLS0t
IGEva2VybmVsL2xpdmV1cGRhdGUva2V4ZWNfaGFuZG92ZXIuYwo+ICsrKyBiL2tlcm5lbC9saXZl
dXBkYXRlL2tleGVjX2hhbmRvdmVyLmMKPiBAQCAtNTEsNyArNTEsNyBAQCB1bmlvbiBraG9fcGFn
ZV9pbmZvIHsKPgo+ICAgc3RhdGljX2Fzc2VydChzaXplb2YodW5pb24ga2hvX3BhZ2VfaW5mbykg
PT0gc2l6ZW9mKCgoc3RydWN0IHBhZ2UgKikwKS0+cHJpdmF0ZSkpOwo+Cj4gLXN0YXRpYyBib29s
IGtob19lbmFibGUgX19yb19hZnRlcl9pbml0ID0gdHJ1ZTsKPiArc3RhdGljIGJvb2wga2hvX2Vu
YWJsZSBfX3JvX2FmdGVyX2luaXQgPSBJU19FTkFCTEVEKENPTkZJR19LRVhFQ19IQU5ET1ZFUl9F
TkFCTEVfREVGQVVMVCk7Cj4KPiAgIGJvb2wga2hvX2lzX2VuYWJsZWQodm9pZCkKPiAgIHsKPiAt
LQo+IDIuNTAuMQo+Cj4KPgo+IC0tCj4gU2luY2VyZWx5IHlvdXJzLAo+IE1pa2UuCgoKCkFtYXpv
biBXZWIgU2VydmljZXMgRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApUYW1hcmEtRGFu
ei1TdHIuIDEzCjEwMjQzIEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hs
YWVnZXIsIENocmlzdG9mIEhlbGxtaXMKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxv
dHRlbmJ1cmcgdW50ZXIgSFJCIDI1Nzc2NCBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDM2NSA1
MzggNTk3Cg==


