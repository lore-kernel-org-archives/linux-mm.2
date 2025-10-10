Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F050CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 07:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3048E000B; Fri, 10 Oct 2025 03:45:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53108E0002; Fri, 10 Oct 2025 03:45:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91AC78E000B; Fri, 10 Oct 2025 03:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C2D38E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 03:45:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4EC1BB6D43
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 07:45:11 +0000 (UTC)
X-FDA: 83981418822.27.B20DCF0
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	by imf29.hostedemail.com (Postfix) with ESMTP id 17E25120002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 07:45:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=NA6Ww11o;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf29.hostedemail.com: domain of "prvs=371de6772=acsjakub@amazon.de" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=371de6772=acsjakub@amazon.de"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760082309; a=rsa-sha256;
	cv=none;
	b=8PazSses+7fv4AMmo/sugIx19QhfPH/wvMrL4I3OecS0evyWIgm/wHfGU4Do+9O87H5G/C
	2N8wBkmJfLpIGxnKbDHhxSOpEf+HBUxVgDOhd6uUe/mOTSrsqc1/wjpMOaCH5ctNmT90Pu
	b6ZYn5f4Cn2+1BRAKi3/7Sl+LmHKB4k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=NA6Ww11o;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf29.hostedemail.com: domain of "prvs=371de6772=acsjakub@amazon.de" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=371de6772=acsjakub@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760082309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0oz5e0o8tACYdNARzq7pIphjfhSwpUbI/5pz+rfEhc=;
	b=UzYY7Xfh6F6Jryb+mqAKfo6do9T1XyIz0Ia0D0Zfxcm/KPTAAFGsn9k/PUS78Cdfcoedoq
	DEaSQNxqZaCgC1wLcAkooTbcTqU7FgdGpSUTi8LdhXvxilhwX28nMp8WQ4EVWxyFSGE4qu
	bSGEy18s+fvHn9/4iNPs3YLkXIIkpDs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1760082309; x=1791618309;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=l0oz5e0o8tACYdNARzq7pIphjfhSwpUbI/5pz+rfEhc=;
  b=NA6Ww11oJS6EeCvdGc63p6m1SXz4qsVZZdJN3S6SMeRQq0/aroscuM9Q
   zRlqTsFXteBJTrP5SQpOw3PIVyfAuwJfc5o/vtzsMGtay+epYBRN46CGh
   EA2IttYZb6cj+Po+E6utvf2TFvDdf1wBtGqng9yjNFxF8xOVjhzwZXIit
   t2M1I8qFS9PNpNeM/56XQACe2OUonMMraDrtglEhauG/JpMms/d34vCSj
   jdUx+0/mHssH/kE+POwCb0xDNO/fHB9AhpnV3CThudKzaBMXDdJySKM2l
   UG3KemnG61NEPWhbDR4L+NnucPmSC9ILhYSj2I6QLnL9t+UMKTdki7DKg
   A==;
X-CSE-ConnectionGUID: 1f6E/2q+TmO2qwnCdW7GDQ==
X-CSE-MsgGUID: 4tIHy7hpSKKp2C7U4pgYZg==
X-IronPort-AV: E=Sophos;i="6.18,281,1751241600"; 
   d="scan'208";a="4653589"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 07:45:04 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:50702]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.171:2525] with esmtp (Farcaster)
 id adeac70d-a4e1-4e41-a68c-ef2545172203; Fri, 10 Oct 2025 07:45:04 +0000 (UTC)
X-Farcaster-Flow-ID: adeac70d-a4e1-4e41-a68c-ef2545172203
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 10 Oct 2025 07:45:02 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 10 Oct 2025
 07:45:01 +0000
Date: Fri, 10 Oct 2025 07:44:58 +0000
From: Jakub Acs <acsjakub@amazon.de>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, kernel test robot
	<lkp@intel.com>, <llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>,
	Linux Memory Management List <linux-mm@kvack.org>, Miguel Ojeda
	<ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>
Subject: Re: [akpm-mm:mm-new 36/102] error[E0425]: cannot find value
 `VM_READ` in crate `bindings`
Message-ID: <20251010074458.GA91144@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
References: <202510100127.yuqhg8uo-lkp@intel.com>
 <20251009110555.29a67af19f5cc4d40e66713c@linux-foundation.org>
 <CANiq72kKSz=UK+O4tnV0Kmw_HmJhJJ+KNZnUBWtOWqanrG+7Vg@mail.gmail.com>
 <20251010060618.GA80465@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
 <CANiq72kndiqwEm-OZLd6JumAaBy7KrzYf_rDjwhtw5Uh4vdTCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CANiq72kndiqwEm-OZLd6JumAaBy7KrzYf_rDjwhtw5Uh4vdTCg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D042UWA002.ant.amazon.com (10.13.139.17) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Transfer-Encoding: base64
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 17E25120002
X-Stat-Signature: qhipgcgskw17nm58yuaj9jqu9ss9w4yg
X-HE-Tag: 1760082308-650541
X-HE-Meta: U2FsdGVkX19SHNFtH3kuSd9iOa0ezKcrpKZUeGNDt8UKivdM4425PUodvEvZ8tJvybF05FY3afDmgFsXJstzjnaY2GHHol2ATlYIsXHN0CYGWRPyVtQIcz/EhuUFLQI97T5F2qCr5gUAnBbAlTMIon4Z5Kerx0Ia4HUddYMYe4HhINmcaK8kFClnUMCMDmS8di9ow4u/Ugtxd2HrfGQ2OUWW6bakhajYvLHqjqI/f8ShA76rflSu5E+8+rABZ36XB98dXXqakxFIVEGJRJMLpLTA7v0s+ajBofzA2nWIqFaNnqNMACgnpwSvGsAJipaLqHewr+sRIeyAiGQwOfYdXDHYpNfrV6Ir8ZkM76dg2pJsCvDaW9yO7GmvgQOwqn9KqOSxXK1t2+zK2jKFFpZ5LfjCkO9FrsNSxRCSp/s+mYiwIM5ObirpUhW3bM5cWG/uOpun6F/BVRcOyyHFGn5akInSgKnDJET8O9goOVh47xeIRNTKTdlV3mGK0EYC4E6RSH8kERN5/yn9X4sR3DwDk+lTeJpxTQRc2vLk9zXYeD2hwTlGya0NHAO/bEZpTiNrFXQ78HzeDF9GGUBhNfG8jgfUg1SEo7jPLfgvXVr4ZtRpi8ZKu5p85tFAKPPXTNKaed8XlNlsBq/JLPekg1SssPLomZjh+XbtPDvuk1u7HWzkk/3TrpkFYGCTkpSX+RSagFopqL3ZnJvAA2YjVjWaUC5Rewel36T/12uKccj1d4s+UNoZQJCZac32OxJ81Dpq+zvHT/4gxX+a+tD9NZc2syINICi3NzjTODePyUhBCZIZuAwV5nG+/aXyJqFcSMVSs4RPtpfbtmf7wvLzdgA2cs11zNW/Y8aEgU8CgNBxSUGjb4UScDxpvbsQjZxH0F88Q+LaAjCXkb+cqn2bzLbFSBNwFAwag4DI1MZ+UZS/QKk1INXWq9G/h3hTICf9uN3wTqeYe4HE94CfLvudSyv
 nUVY0y7P
 dbBfasqQAQEBrXYFHdFKVKV4rFDEbFxaTrk9+EQ6u0jwxjxPH7F4m/iUeBv21lDaFKeFiLLdldOU44AYywRjW6wsQvOgJxOs9O2ecDLj+BVZjl6nJ2zaj9tV2tWJ37/13Avn0wiPQSqnpoAxWaQjHFJJXk/RNHHNQ5+npnVckV7qwcV+itdMZ+rQ21nwcVXVTRJVmX12N1Fol9lC/fBroDhosPvZKPokB82xeDSByFM8EHFb48B/RV5NyXGRwwb4mR4No9bsCV5apCQzEZaF+9BNxj9oJVvwN55y5BszYyxgF6AnM71exlZLHPkNDKiJltKDGAVQ5hbIr36kTqwgpu9J0sDdRDBEGGL7QMDCRVPZv2Ocon6FfPD18kn2vyfOnwtcCcJ7mMi0MwjVIxHDQ8hMhhAWhdy0KneFQMfpJthqqidw7q1/1Tq1N0ZkW56/vyY+KYVFZIdZy/dOtYs+jkQwq4PtI9SHNLr+cidqiJR1la95IPm4vhdIiLkt/s2knIInIVRwTLUiRg4qEEKM8Bg65t6mFv7aiPy3rGc1bsJJzWAm9ABYbRH1SHHXX4CPFQXIz3svaTwPIO4f1Ajoi023x/Rc78djm8rOItsLeT9t0tpOfH9FwRj0m6UB1X7rTyqhmrt4Xu34U8xZwh2AqtTtti76KJ3KIIuoy9Fr6hm9ebUxC4xmY1QQeXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gRnJpLCBPY3QgMTAsIDIwMjUgYXQgMDg6NTk6MDZBTSArMDIwMCwgTWlndWVsIE9qZWRhIHdy
b3RlOgo+IE9uIEZyaSwgT2N0IDEwLCAyMDI1IGF0IDg6MDfigK9BTSBKYWt1YiBBY3MgPGFjc2ph
a3ViQGFtYXpvbi5kZT4gd3JvdGU6Cj4gPgo+ID4gRldJVyBBbGljZSBzdWdnZXN0ZWQgdGhlIGVu
dW0gdmVyc2lvbiBhbmQgd2UgZGlzY3Vzc2VkIGFkanVzdG1lbnQgdG8gdGhlCj4gPiBwYXRjaCBp
biB0aHJlYWQgWzFdLiBJIHdhcyBnb2luZyB0byBzZW5kIG5ldyB2ZXJzaW9uIG9mIHRoZSBwYXRj
aCBhcwo+ID4gc29vbiBhcyBJIGZpZ3VyZSBvdXQgaG93IHRvIHRlc3QgZm9yIHRoZSBpc3N1ZSBw
b2ludGVkIG91dCBieSBEZXJyaWNrIGluCj4gPiBbMl0uCj4gPgo+ID4gUGxlYXNlIGxldCBtZSBr
bm93IGlmIHRoYXQgaXMgZGVzaXJlZCBvciB3aGV0aGVyIHlvdSdyZSB0YWtpbmcgY2FyZSBvZgo+
ID4gaXQgaGVyZS4gQW5kL29yIGhvdyBlbHNlIEkgY2FuIGhlbHAuCj4gCj4gVGhlIGBlbnVtYCBh
cHByb2FjaCBpcyB3aGF0IHdlIHVzdWFsbHkgc3VnZ2VzdCBpZiBwb3NzaWJsZSwgYW5kIGluCj4g
dGhpcyBjYXNlIGl0IGFsc28gYXZvaWRzIGhhdmluZyB0byByZXBsaWNhdGUgY29uZGl0aW9uYWwg
Y29tcGlsYXRpb24KPiBvbiB0aGUgUnVzdCBzaWRlLCB3aGljaCBpcyBnb29kLgo+IAo+IEhvd2V2
ZXIsIHVzaW5nIGl0IGhlcmUgYXMtaXMgbWVhbnMgdGhlIHJlc3VsdGluZyB0eXBlIG9mCj4gYFZN
X01FUkdFQUJMRWAgaXMgYHVuc2lnbmVkIGludGAsIG5vdCBgdW5zaWduZWQgbG9uZ2AgLS0gYnV0
IHdhc24ndAo+IHRoYXQgYW4gaXNzdWU/IGkuZS4KPiAKPiAgICAgaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvYWxsLzIwMjUwOTMwMTMwMDIzLjYwMTA2LTEtYWNzamFrdWJAYW1hem9uLmRlLwo+IAoK
VGhpcyBpcyBhIHRyaWNreSBvbmUgLSBWTV9NRVJHRUFCTEUgYmVpbmcgYHVuc2lnbmVkIGludGAg
aXMgb25seSBhbiBpc3N1ZQppZiB0aGVyZSBhcmUgZmxhZ3MgdXNpbmcgYW55IG9mIHRoZSB1cHBl
ciAzMiBiaXRzLiBBbmQgaWYgdGhhdCBpcyB0aGUKY2FzZSwgQ09ORklHX0FSQ0hfVVNFU19ISUdI
X1ZNQV9GTEFHUyBoYXMgdG8gYmUgJ3knLCAtPiB0aHVzIHRoZSBlbnVtCndpbGwgYWxzbyBoYXZl
IEJJVCgzMyksIEJJVCgzNCksIGFuZCBzbyBvbi4gU28gZnJvbSB0aGF0IHBlcnNwZWN0aXZlCndl
J3JlIG9rIChjaGVja2VkIGJ5IHJ1bm5pbmcgYSByZXByb2R1Y2VyKS4KCj4gV2UgbWF5IGJlIGFi
bGUgdG8gdXNlIGEgZHVtbXkgbGFyZ2VyIGNvbnN0YW50IHRvIGZvcmNlIHRoZSBjb21waWxlciB0
bwo+IHBpY2sgYSBiaWdnZXIgdW5kZXJseWluZyB0eXBlLCBlLmcuIHNvbWV0aGluZyBsaWtlOgo+
IAo+ICAgICBfX1ZNX0ZMQUdTX0ZPUkNFX1VMICAgID0gQklUKDYzKSwKPiAKPiBCdXQgbm90ZSB0
aGF0IG9sZGVyIHZlcnNpb25zIG9mIEdDQyBhbmQgQ2xhbmcga2VlcCB0aGUgc21hbGxlciBgZW51
bWAKPiBjb25zdGFudHMgYXMgYGludGAgKGkuZS4gc21hbGwgYW5kIHNpZ25lZCksIGV2ZW4gaWYg
dGhleSB3aWxsIHBpY2sKPiBgdW5zaWduZWQgbG9uZ2AgZm9yIHRoZSBiaWdnZXIgb25lcy4gTmV3
ZXIgdmVyc2lvbnMgd2lsbCBwaWNrCj4gYHVuc2lnbmVkIGxvbmdgIGZvciBhbGwuCj4gCj4gVGhl
IGJlc3Qgd291bGQgYmUgdG8gdXNlIEMyMy1saWtlIGBlbnVtIDogdW5zaWduZWQgbG9uZyB7IC4u
LiB9YCwgYnV0Cj4gc2FkbHkgd2UgZG9uJ3QgaGF2ZSBhIHJlY2VudCBlbm91Z2ggR0NDIGFzIGEg
bWluaW11bSBpbiB0aGUga2VybmVsCj4gKEdDQyAxMykuCj4gCj4gSWYgdGhlcmUgYXJlIGV4dHJh
IGNvbXBsaWNhdGlvbnMgd2l0aCB0aGUgYGVudW1gIGFwcHJvYWNoIChpLmUuIHNlY29uZAo+IGxp
bmspLCB0aGVuIHBlcmhhcHMganVzdCByZXBsaWNhdGluZyBpdCBvbiB0aGUgUnVzdCBzaWRlIGlz
IHNpbXBsZXIuCj4gCgpUaGlzIG9mYyByZW1haW5zIHRydWUsIEknbSBub3QgeWV0IHN1cmUgaG93
IHRvIHRlc3QgdGhhdCBjb21wbGljYXRpb24uCgpUaGFua3MsCkpha3ViCgoKCkFtYXpvbiBXZWIg
U2VydmljZXMgRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApUYW1hcmEtRGFuei1TdHIu
IDEzCjEwMjQzIEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIK
RWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDI1Nzc2
NCBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDM2NSA1MzggNTk3Cg==


