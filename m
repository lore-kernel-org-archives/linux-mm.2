Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59E75C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 16:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159D46B0088; Tue, 25 Aug 2026 12:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131C16B008C; Tue, 25 Aug 2026 12:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 046C76B0092; Tue, 25 Aug 2026 12:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFE9D6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:57:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36A60A0115
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:57:06 +0000 (UTC)
X-FDA: 85140396852.15.F9E08C1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3475080002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:57:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=arvQFXMr;
	spf=pass (imf30.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787677024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iaZWKHAckqeA7K7xB+lhxHxtbFfTIKiixJPwaw0cQfE=;
	b=FX5KjT/YGPFtceoTHEeFCKss2SSZS1qcL6R6UWpTAFgBWXAzuXwHiqlJJgqy+Aab83HABL
	UqOQbmlMdIWcrWUw2k/3asVEPWOsvCP8XX2NmgDPYW+qNlyf0ZgNJ4p6K14wzlXPQyXIl/
	tr5NWQ/L2WnAIXVAFnn3nCtaPcX8zCI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787677024;
	b=o//klr75DJJFCnzEUadSmF6QbNxfApGpaYZxifH905eFy4zWMGNWJfUrb3PZJRDemc2Vqm
	Ey9eiD7cgRsnHqXLZKSovgh9ai6pQ4SoY1jE+Lfnny2HZoVS5vvHWYS8L4/l/V61D8T6eH
	gLtFBNFb4YklNid/vRm2jNsz5If78sw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=arvQFXMr;
	spf=pass (imf30.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787677023; x=1819213023;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GUHBtX8i/XXdFP4nTGCmtXDoyJYGQXwhXsT4+TfHfKY=;
  b=arvQFXMrVvzxS5/hV6+9kE5XhzX06SwLJZVBXGomrEh8KbSwx3fSI6KM
   NJZ46HJNYAsVVSGVDqsM+cHKxL7ZOH5SRIcpaqe5FZ20QwFc0ehaXDvKf
   ZlWFe7veGHmlrC0xx72fwtMwhQ3mlviMV6gWYsAOMGeeMkTWuT5l5PdLh
   SdwH1U1jPrVQduWp8hB1OzJ3nLozZau0wSBT185j0XRNXoWFTEsE9G/3O
   yaMuGVBOpaeZAJn5i9h9HxhMCx1VJNINRuH1SuCtjpMpJRtVLe9jFb4O0
   vMiRm+nOYBOaW7rc65VQAue2u0i1bvArfwO+EIKGf7oSJKFXH5YgN7BGG
   Q==;
X-CSE-ConnectionGUID: QcsGPKPJRmWDRYrCHQf9UQ==
X-CSE-MsgGUID: vt3sX+lARUSj6svgLG7x9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="88206685"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="88206685"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 09:57:01 -0700
X-CSE-ConnectionGUID: yAPm+p4JStOXHfag/PiOnQ==
X-CSE-MsgGUID: gpPNc10qQBSRPWPPMyM1YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="270819353"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.109.12]) ([10.125.109.12])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 09:57:00 -0700
Message-ID: <687afc72-5b6a-4138-8d33-fe5b6b7aef00@intel.com>
Date: Tue, 25 Aug 2026 09:57:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] x86/mm: add set_direct_map_ro_noflush()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org
Cc: ljs@kernel.org, usama.arif@linux.dev, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, rppt@kernel.org, ryan.roberts@arm.com, ziy@nvidia.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lance Yang <lance.yang@linux.dev>
References: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
 <20260730090647.2401252-4-xueyuan.chen21@gmail.com>
 <2931f8a6-3780-4d6a-b19d-61cbbdad1a3a@intel.com>
 <1e04196a-7079-4a8d-a1b7-844e60d08728@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <1e04196a-7079-4a8d-a1b7-844e60d08728@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3475080002
X-Stat-Signature: 8ig56pwdn5kefiuzr55knd3wboxkxdkp
X-HE-Tag: 1787677022-749883
X-HE-Meta: U2FsdGVkX1+mmEdUeYrSX0IInH1NtxTpZTQVZCLNCYHPsB/lo59DuQ0wW0QkscDh3y8g6z9F3SPsuLj+j5Buf9QoleqgJYkNqmFx897hN6PwirlMVGxJoPYqKTmFUQxwWX1mrleAXofcJDUfVdvh3cj4p6XQ/7HBCr2GPmaYJZMtO1gMrjNI3ZUgkH5n/3IyyMRY3tODtvEjhiYDPOvZVLUQ5RP1Xk+fls3SckiDh4bij29qjhupdGWxseFHoHkjs3e/FoeW5d9rs9dsb6NilWy4kJHvE4cmKcK+IAavTKCxAeVYEhEMMq648rW3osMj38gHuqyqjG2rwc5fjDC5VZqUi2sRabpjh7grfRQHiIP7cVf0qZryG+x40oFit3GUKmhikQLqAIq2U69u9XugC8/MzIVXGbYALl/1bMEtCpbGw3S6zSOG93RnphGpnJ60gqNcSImsWpYjy9eGhdMN0g5JFXMYEcLyTRze/tqtF4uN4bDkkfqDdr1hZmEO2lR4Jjw4EpSfoos2OlrSHJ7bnRmHDYVrRcXbdAbwLZqHoE7WyaljT2Ur0SKMDPrZp0Upm6IeKIAZU6EZZoYJs/maYL5FNdYbyb+4Au+Z3okgY0wcwUC2n/QKdbBMIkT7PkzSo0Y042vwPU1B2biOMF/AldrfghIKezz4Xw0yasgkv13tUXoSJVCkIAtSZRvZrU8I6v/V5d5mFrSzX89G7SvLLbWz55SSiWMgmu21a1EfROlIvO+f+mvw1ciJCoyb8utMuFNks9gg95r7gCFjvJFGPy11PjaKEbSXHfkEwO3BJu76B6IPZm4XHN3JVYVw5UyCj7lI9pCtUnRlyEz4mSyNG4RuLB5IrYMq8POAGfgN0qRVrU33YmwUFvtJq7ne+wsaBa63kb386V/ozEewzpaY8QdhvJfQnioLTcT3psWpT1Ad5K1hwFSo5flj4nDC8iV6QFCMLqbcPCju7BYgL0+
 9vH7q494
 BcEV7rQ1lrbZspxNWNyxxazyKL+0SGcm476SdRFLzrw35Sglkr52K9jL9NnK7VVHXzy77aM4bXt35tA9DxLYzsEcrStTRjIOzo9jihDSLqQAiM0diXnhaQFSz08J80hassbnxf4pQPM5ZPsAVA6fbTYgHWaWFtEGst3ybP6Vvq989+GsWZTf/+gB3L4s1yKU+44nidYRpgn1ho/4CGK3FhVT6og8DpRx0RHIib1uPj5s7ypzC38Njom770SGc00PMLbXH+VnpmPGf8H7kriIYJO1PUwd9b6s0COciXXRr5KthShp7xPdpc89xYOIKRtNJAUQHj9xK+qdcO3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 09:43, David Hildenbrand (Arm) wrote:
>> int set_direct_map_invalid_noflush(struct page *page)
>> int set_direct_map_default_noflush(struct page *page)
>> int set_direct_map_valid_noflush(struct page *page, unsigned nr, ...
>> int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages)
>>
>> Which one of these things is not like the other, despite being named
>> just like them?
>>
> That's called out in the cover letter:
> 
> "
> This series adds set_direct_map_ro_noflush() so mm code can make a
> direct-map range read-only, then uses it for the persistent huge zero
> folio. The helper is direct-map specific, takes an address-based range as
> discussed for set_direct_map* helpers[2], and leaves TLB invalidation to
> the caller.
> "

My concern is not so much what the function is doing or whether or how
the specific function is documented. It's more about whether the new
function is consistent across all functions with a similar purpose and
name. Also, if it is _not_ consistent there needs to be reasoning behind
the inconsistency. I think that is missing here.

In this case, look at the call site:

	addr = (unsigned long)folio_address(huge_zero_folio);
	set_direct_map_ro_noflush((void *)addr, HPAGE_PMD_NR);

It *has* a folio. But it does a folio_address() and two casts to massage
it into the type for set_direct_map_ro_noflush().

If set_direct_map_ro_noflush() just took a 'struct page *', there would
be one folio=>page conversion, no casting, and complete consistency with
the other set_direct_map*() functions.

I'd also be OK with set_direct_map_ro_noflush() taking a folio, with the
implication being that it might eventually make sense to convert the
other set_direct_map*() functions to folios. But page vs. folio
confusion is much less likely to cause bugs than a void* versus another
pointer.

IOW, what I think I want is:

int set_direct_map_ro_noflush(struct page *page, unsigned long nr_pages)

Or _maybe_:

int set_direct_map_ro_noflush(struct folio *folio)

