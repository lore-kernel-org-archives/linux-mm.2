Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D58CBE7314E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 09:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 029866B0088; Mon,  2 Feb 2026 04:30:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F194E6B0089; Mon,  2 Feb 2026 04:30:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB246B008A; Mon,  2 Feb 2026 04:30:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE3AF6B0088
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:30:12 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6497813C025
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:30:12 +0000 (UTC)
X-FDA: 84398995464.08.DBDBBE7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf13.hostedemail.com (Postfix) with ESMTP id B686D20009
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:30:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SHyeIox9;
	spf=pass (imf13.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770024610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a47tOyzOYXg7hjTEWYS+Q9Gs3aPc6OTzuqo3JGwuYTc=;
	b=fVU7dpuLscs7505rEjqXI1nyeYIVGvGDeffqHOtMaFvYG+KKZ9hgHHohOnJ8q5KhjQ2SFn
	xtDsaQ/YU9vcpfafPfY90c4Q709WJQRwopaXi2+jT5cQXiVPhM7uPWUyjJ3wOMwxvFPIGY
	bXlTqW2xQXuXH1NoUnrC4XGuPmE9OKQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SHyeIox9;
	spf=pass (imf13.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770024610; a=rsa-sha256;
	cv=none;
	b=10hGk72cu+orLeC8L5xQNdkQKFEGS/jXSQOqbAQzXEYQaotn+aOasrcoGIACQLhsCHUT+Z
	rJ8CVtMjfnpPuPQtPeoYoGSyCmJ9nIbYLR4NXnVs5naqXv8MyPPRibFL9s7l7n2FiS6rsq
	Ur07/MO4zfIDti0Deqs+XPaMBAttGM4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770024610; x=1801560610;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=a47tOyzOYXg7hjTEWYS+Q9Gs3aPc6OTzuqo3JGwuYTc=;
  b=SHyeIox9Z8EmFGwmTj8GeNR5ykWneKZXn36+6sdofdJ9dtLJmrSjHiZI
   P3wQzJyIpizJ0zVdGwxkUHG3UaiTSnspFtBrRFQAK5JKZ2IpKGSGXuZgM
   Hg9KrAJeFLV5vbwVugRcUBQgGBOkPy5qLfFJi+Xeb2zrklzGX+h/TUlWV
   ihH9z3gG/VqK73sd1+uijU+NZJn5U6zQ2tcJEgXqQ8mFhCmN1ohZhQgD/
   wI0iWGt4BpFofPleNdJb0hJciyF/XGN32cv8ec+oKxfe2vIvvEwXpcVYD
   pc+2ZU+Hd436LU/FZKqnCn5ALewG4/rBeXaU2+jG6f0VqgLXBRQ/O8MRR
   Q==;
X-CSE-ConnectionGUID: N+kdCrirR9CyH3axziSxaQ==
X-CSE-MsgGUID: eCrt7f9yQO6m+9wJJBPwVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11689"; a="81492754"
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="81492754"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 01:30:09 -0800
X-CSE-ConnectionGUID: T4VfLHqsQ1Cvz8JZMUzNng==
X-CSE-MsgGUID: XX/xY5LOTheTTVox4SAc1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="240159385"
Received: from abityuts-desk.ger.corp.intel.com (HELO [10.245.244.193]) ([10.245.244.193])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 01:30:05 -0800
Message-ID: <f48e3d818c6e20d6ea7a7fbd6b1741f25df17a78.camel@linux.intel.com>
Subject: Re: [PATCH] mm/hmm: Fix a hmm_range_fault() livelock / starvation
 problem
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Alistair Popple <apopple@nvidia.com>, Matthew Brost
	 <matthew.brost@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>, Andrew Morton	
 <akpm@linux-foundation.org>, intel-xe@lists.freedesktop.org, Ralph Campbell
	 <rcampbell@nvidia.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe	
 <jgg@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky	
 <leon@kernel.org>, linux-mm@kvack.org, stable@vger.kernel.org, 
	dri-devel@lists.freedesktop.org
Date: Mon, 02 Feb 2026 10:30:02 +0100
In-Reply-To: <lbqqmohxpeynsrunbdyvod2fm4tinzq5coueh2mq6weubste5x@y4f5weqvwszg>
References: <20260130144529.79909-1-thomas.hellstrom@linux.intel.com>
	 <20260130100013.fb1ce1cd5bd7a440087c7b37@linux-foundation.org>
	 <57fd7f99-fa21-41eb-b484-56778ded457a@nvidia.com>
	 <2d96c9318f2a5fc594dc6b4772b6ce7017a45ad9.camel@linux.intel.com>
	 <aX5RQBxYB029/dkt@lstrano-desk.jf.intel.com>
	 <0025ee21-2a6c-4c6e-a49a-2df525d3faa1@nvidia.com>
	 <aX+oUorOWPt1xbgw@lstrano-desk.jf.intel.com>
	 <81b9ffa6-7624-4ab0-89b7-5502bc6c711a@nvidia.com>
	 <aX/AgHAZ7Tl4iOua@lstrano-desk.jf.intel.com>
	 <lbqqmohxpeynsrunbdyvod2fm4tinzq5coueh2mq6weubste5x@y4f5weqvwszg>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: b3pbzsk61d6ttwksncx3oxqo7rhzk7do
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B686D20009
X-HE-Tag: 1770024609-97762
X-HE-Meta: U2FsdGVkX1+lpOR2ZEEwN6O8uIvuLJJeMpNi29nDOBAG65ODiVp5rg7lphQqj1CrCUzFIWVBgk+Y5md5nXXGxE4FvdVN3DxMRywo2qxhI0lfdVo9jxCVOkFrPTYo1yj5+OrQaqSZL0kE1CKeLjkItnmpDUyDBF2A5RpLXEAsWY7NFJNcJRLYBaMTypltBSnVE/Q9e00K4l125rMHFM2Azz0oJnUhnWwDF2c8qwfjYuso653qyuFvsOdXDYhgP5p9ZUgK0tMqKI5La7xv8KH/X1WJViPMeEsqUvc1a1NPuVtij19xXZtOYMJ6x+NMr6NsArlw8r2Hu7GuXoBVA164issI2tkbt+jLjeBFlfU644b3ErF22kmchqKsW/BWFPzLi9znvB/4PkjwRtAwVdGJR2PnKNS2Wd6bKRNx6QFPecgVNjbR2Lq2mty7tzQUuThaHpKNhs7XbelJcrAiX/wdNa3D/AA5SObvTaX/FbhgePUAPVGsTTs/Z84EJThyiUNe9BNYfB0LaVtDromx59H4iHkgQCymVQTTJA34yf6lKiQ/pmcWOgeKV+9TDR9R+4km+3H7zomOsZshXZ7WXhxAgkCCn5ldb52mvsc2qYaGh4TwG9s7fm4yPd7fepqXPlcjhKyw+TkKp/vpq3+bJcSeyvPfwdwRHWYUGw0ve83oEDUFlqRcdsKb5PoaOD7iNGtaJVXxsQlWrtOpv9n5gYf0KiVq+jJ4VLeQ2Nx4NggMfDQ5SCT2yQ2JX4vacM/ypcwh21H0tlY/CQrV0xcNPU/wd8xoqdt2v9xlU46GNCQwk7fs1v2vCY4dnXpy6lnsoG6KtA3Zij1AxRno2oB9fkb2ObXIxruszPivZTHTAMGm4JWn5gyHlvPdzA76W8PNKCsonlkorEt04P8cayV8EA2A2gY0eryjMN/NnfaBx0ZaHYsdutl281PMV48RneB3a5Ta3u5ZyTh4j1WcMdWjf/K
 q3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGksCgpPbiBNb24sIDIwMjYtMDItMDIgYXQgMTE6MTAgKzExMDAsIEFsaXN0YWlyIFBvcHBsZSB3
cm90ZToKPiBPbiAyMDI2LTAyLTAyIGF0IDA4OjA3ICsxMTAwLCBNYXR0aGV3IEJyb3N0IDxtYXR0
aGV3LmJyb3N0QGludGVsLmNvbT4KPiB3cm90ZS4uLgo+ID4gT24gU3VuLCBGZWIgMDEsIDIwMjYg
YXQgMTI6NDg6MzNQTSAtMDgwMCwgSm9obiBIdWJiYXJkIHdyb3RlOgo+ID4gPiBPbiAyLzEvMjYg
MTE6MjQgQU0sIE1hdHRoZXcgQnJvc3Qgd3JvdGU6Cj4gPiA+ID4gT24gU2F0LCBKYW4gMzEsIDIw
MjYgYXQgMDE6NDI6MjBQTSAtMDgwMCwgSm9obiBIdWJiYXJkIHdyb3RlOgo+ID4gPiA+ID4gT24g
MS8zMS8yNiAxMTowMCBBTSwgTWF0dGhldyBCcm9zdCB3cm90ZToKPiA+ID4gPiA+ID4gT24gU2F0
LCBKYW4gMzEsIDIwMjYgYXQgMDE6NTc6MjFQTSArMDEwMCwgVGhvbWFzIEhlbGxzdHLDtm0KPiA+
ID4gPiA+ID4gd3JvdGU6Cj4gPiA+ID4gPiA+ID4gT24gRnJpLCAyMDI2LTAxLTMwIGF0IDE5OjAx
IC0wODAwLCBKb2huIEh1YmJhcmQgd3JvdGU6Cj4gPiA+ID4gPiA+ID4gPiBPbiAxLzMwLzI2IDEw
OjAwIEFNLCBBbmRyZXcgTW9ydG9uIHdyb3RlOgo+ID4gPiA+ID4gPiA+ID4gPiBPbiBGcmksIDMw
IEphbiAyMDI2IDE1OjQ1OjI5ICswMTAwIFRob21hcyBIZWxsc3Ryw7ZtCj4gPiA+ID4gPiA+ID4g
PiA+IHdyb3RlOgo+ID4gPiA+ID4gPiA+ID4gLi4uCj4gPiA+ID4gPiA+IEnigJltIG5vdCBjb252
aW5jZWQgdGhlIGZvbGlvIHJlZmNvdW50IGhhcyBhbnkgYmVhcmluZyBpZiB3ZQo+ID4gPiA+ID4g
PiBjYW4gdGFrZSBhCj4gPiA+ID4gPiA+IHNsZWVwaW5nIGxvY2sgaW4gZG9fc3dhcF9wYWdlLCBi
dXQgcGVyaGFwcyBJ4oCZbSBtaXNzaW5nCj4gPiA+ID4gPiA+IHNvbWV0aGluZy4KPiAKPiBJIHRo
aW5rIHRoZSBwb2ludCBvZiB0aGUgdHJ5bG9jayB2cy4gbG9jayBpcyB0aGF0IGlmIHlvdSBjYW4n
dAo+IGltbWVkaWF0ZWx5Cj4gbG9jayB0aGUgcGFnZSB0aGVuIGl0J3MgYW4gaW5kaWNhdGlvbiB0
aGUgcGFnZSBpcyB1bmRlcmdvaW5nIGEKPiBtaWdyYXRpb24uCj4gSW4gb3RoZXIgd29yZHMgdGhl
cmUncyBubyBwb2ludCB3YWl0aW5nIGZvciB0aGUgbG9jayBhbmQgdGhlbiB0cnlpbmcKPiB0byBj
YWxsCj4gbWlncmF0ZV90b19yYW0oKSBhcyB0aGUgcGFnZSB3aWxsIGhhdmUgYWxyZWFkeSBtb3Zl
ZCBieSB0aGUgdGltZSB5b3UKPiBhY3F1aXJlCj4gdGhlIGxvY2suIE9mIGNvdXJzZSB0aGF0IGp1
c3QgbWVhbnMgeW91IHNwaW4gZmF1bHRpbmcgdW50aWwgdGhlIHBhZ2UKPiBmaW5hbGx5Cj4gbWln
cmF0ZXMuCj4gCj4gSWYgSSdtIHVuZGVyc3RhbmRpbmcgdGhlIHByb2JsZW0gaXQgc291bmRzIGxp
a2Ugd2UganVzdCB3YW50IHRvIHNsZWVwCj4gdW50aWwgdGhlCj4gbWlncmF0aW9uIGlzIGNvbXBs
ZXRlLCBpZS4gc2FtZSBhcyB0aGUgbWlncmF0aW9uIGVudHJ5IHBhdGguIFdlIGRvbid0Cj4gaGF2
ZSBhCj4gZGV2aWNlX3ByaXZhdGVfZW50cnlfd2FpdCgpIGZ1bmN0aW9uLCBidXQgSSBkb24ndCB0
aGluayB3ZSBuZWVkIG9uZSwKPiBzZWUgYmVsb3cuCj4gCj4gPiA+ID4gZGlmZiAtLWdpdCBhL21t
L21lbW9yeS5jIGIvbW0vbWVtb3J5LmMKPiA+ID4gPiBpbmRleCBkYTM2MGE2ZWI4YTQuLjFlN2Nj
YzRhMWE2YyAxMDA2NDQKPiA+ID4gPiAtLS0gYS9tbS9tZW1vcnkuYwo+ID4gPiA+ICsrKyBiL21t
L21lbW9yeS5jCj4gPiA+ID4gQEAgLTQ2NTIsNiArNDY1Miw4IEBAIHZtX2ZhdWx0X3QgZG9fc3dh
cF9wYWdlKHN0cnVjdCB2bV9mYXVsdAo+ID4gPiA+ICp2bWYpCj4gPiA+ID4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZtZi0+cGFnZSA9IHNvZnRsZWFm
X3RvX3BhZ2UoZW50cnkpOwo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCByZXQgPQo+ID4gPiA+IHJlbW92ZV9kZXZpY2VfZXhjbHVzaXZlX2Vu
dHJ5KHZtZik7Cj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfSBlbHNl
IGlmIChzb2Z0bGVhZl9pc19kZXZpY2VfcHJpdmF0ZShlbnRyeSkpCj4gPiA+ID4gewo+ID4gPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgZGV2
X3BhZ2VtYXAgKnBnbWFwOwo+ID4gPiA+ICsKPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHZtZi0+ZmxhZ3MgJiBGQVVMVF9GTEFHX1ZN
QV9MT0NLKQo+ID4gPiA+IHsKPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qCj4gPiA+ID4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICog
bWlncmF0ZV90b19yYW0gaXMgbm90IHlldAo+ID4gPiA+IHJlYWR5IHRvIG9wZXJhdGUKPiA+ID4g
PiBAQCAtNDY3MCwyMSArNDY3MiwxNSBAQCB2bV9mYXVsdF90IGRvX3N3YXBfcGFnZShzdHJ1Y3Qg
dm1fZmF1bHQKPiA+ID4gPiAqdm1mKQo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdm1mLQo+ID4gPiA+ID5vcmlnX3B0ZSkpKQo+
ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgZ290byB1bmxvY2s7Cj4gPiA+ID4gCj4gPiA+ID4gLcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qCj4gPiA+ID4gLcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBHZXQgYSBwYWdlIHJlZmVyZW5j
ZSB3aGlsZSB3ZSBrbm93Cj4gPiA+ID4gdGhlIHBhZ2UgY2FuJ3QgYmUKPiA+ID4gPiAtwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIGZyZWVkLgo+ID4gPiA+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICovCj4gPiA+
ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmICh0cnls
b2NrX3BhZ2Uodm1mLT5wYWdlKSkgewo+ID4gPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGRldl9wYWdlbWFwICpw
Z21hcDsKPiA+ID4gPiAtCj4gPiA+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnZXRfcGFnZSh2bWYtPnBhZ2UpOwo+IAo+IEF0
IHRoaXMgcG9pbnQgd2U6Cj4gMS4gS25vdyB0aGUgcGFnZSBuZWVkcyB0byBtaWdyYXRlCj4gMi4g
SGF2ZSB0aGUgcGFnZSBsb2NrZWQKPiAzLiBIYXZlIGEgcmVmZXJlbmNlIG9uIHRoZSBwYWdlCj4g
NC4gSGF2ZSB0aGUgUFRMIGxvY2tlZAo+IAo+IE9yIGluIG90aGVyIHdvcmRzIHdlIGhhdmUgZXZl
cnl0aGluZyB3ZSBuZWVkIHRvIGluc3RhbGwgYSBtaWdyYXRpb24KPiBlbnRyeSwKPiBzbyB3aHkg
bm90IGp1c3QgZG8gdGhhdD8gVGhpcyB0aHJlYWQgd291bGQgdGhlbiBwcm9jZWVkIGludG8KPiBt
aWdyYXRlX3RvX3JhbSgpCj4gaGF2aW5nIGFscmVhZHkgZG9uZSBtaWdyYXRlX3ZtYV9jb2xsZWN0
X3BtZCgpIGZvciB0aGUgZmF1bHRpbmcgcGFnZQo+IGFuZCBhbnkKPiBvdGhlciB0aHJlYWRzIHdv
dWxkIGp1c3Qgc2xlZXAgaW4gdGhlIHdhaXQgb24gbWlncmF0aW9uIGVudHJ5IHBhdGgKPiB1bnRp
bCB0aGUKPiBtaWdyYXRpb24gaXMgY29tcGxldGUsIGF2b2lkaW5nIHRoZSBsaXZlbG9jayBwcm9i
bGVtIHRoZSB0cnlsb2NrIHdhcwo+IGludHJvZHVjZWQKPiBmb3IgaW4gMWFmYWViODI5M2M5YS4K
PiAKPiDCoC0gQWxpc3RhaXIKPiAKPiA+ID4gCgpUaGVyZSB3aWxsIGFsd2F5cyBiZSBhIHNtYWxs
IHRpbWUgYmV0d2VlbiB3aGVuIHRoZSBwYWdlIGlzIGxvY2tlZCBhbmQKd2hlbiB3ZSBjYW4gaW5z
dGFsbCBhIG1pZ3JhdGlvbiBlbnRyeS4gSWYgdGhlIHBhZ2Ugb25seSBoYXMgYSBzaW5nbGUKbWFw
Y291bnQsIHRoZW4gdGhlIFBUTCBsb2NrIGlzIGhlbGQgZHVyaW5nIHRoaXMgdGltZSBzbyB0aGUg
aXNzdWUgZG9lcwpub3Qgb2NjdXIuIEJ1dCBmb3IgbXVsdGlwbGUgbWFwLWNvdW50cyB3ZSBuZWVk
IHRvIHJlbGVhc2UgdGhlIFBUTCBsb2NrCmluIG1pZ3JhdGlvbiB0byBydW4gdHJ5X3RvX21pZ3Jh
dGUoKSwgYW5kIGJlZm9yZSB0aGF0LCB0aGUgbWlncmF0ZSBjb2RlCmlzIHJ1bm5pbmcgbHJ1X2Fk
ZF9kcmFpbl9hbGwoKSBhbmQgZ2V0cyBzdHVjay4KCkhvd2V2ZXIgaXQgbG9va3MgbGlrZSBNYXR0
IEJyb3N0LCBpbnNwaXJlZCBieSB0aGUgYWJvdmUsIHRyaWVkIHRvCmNoYW5nZSB0aGUgb3JkZXIg
b2YgdHJ5X3RvX21pZ3JhdGUoKSB2cyBscnVfYWRkX2RyYWluX2FsbCgpIHdoaWNoIHdvdWxkCmNh
dXNlIHRoZSBmYXVsdCBoYW5kbGVyIHRvIGV2ZW50dWFsbHkgYmxvY2sgb24gYSBtaWdyYXRpb24g
ZW50cnkuIFRoYXQKc2VlbXMgdG8gc29sdmUgdGhlIGlzc3VlIHdlJ3JlIHNlZWluZyBoZXJlLgoK
U3RpbGwsIEkgdGhpbmsgdGhlIHNwaW5uaW5nIG9uIHRoZSB0cnlsb2NrIGhlcmUgaXMgc3RpbGwg
c29tZXRoaW5nIHdlJ2QKd2FudCB0byBnZXQgcmlkIG9mZiwgYmVjYXVzZSBJTU8gd2Ugc2hvdWxk
bid0IG5lZWQgdG8gYWRhcHQgb3RoZXJ3aXNlCmNvcnJlY3QgYnV0IHNsaWdodGx5IHN1Ym9wdGlt
YWwgY29kZSB0byBhIGJhZGx5IGJlaGF2aW5nIHBhdGggaW4gdGhlCmZhdWx0IGhhbmRsZXIuIElu
IGVzc2VuY2Ugd2UncmUgbmV2ZXIgYWxsb3dlZCB0byBsb2NrIGEgZGV2aWNlLXByaXZhdGUKZm9s
aW8gYW5kIHRoZW4gY2FsbCBzb21ldGhpbmcgdGhhdCBuZWVkcyB0byBleGVjdXRlIG9uIGFsbCBw
cm9jZXNzb3JzCmJlZm9yZSB1bmxvY2tpbmcuCgpUaGFua3MsClRob21hcwo=


