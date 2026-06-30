Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 289A4C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15F636B00FC; Tue, 30 Jun 2026 05:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1372B6B00FE; Tue, 30 Jun 2026 05:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0751B6B0100; Tue, 30 Jun 2026 05:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D84E16B00FC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:14:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76A711C3305
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:14:27 +0000 (UTC)
X-FDA: 84936018174.12.612EBC1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id A04D31C000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:14:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XjRXYR50;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782810865;
	b=kykxK7o9wq2/H3EUVemowPTA53P6AhKonrlNJwIvjYFHBfJIBPXs1dM/CXI/4bCQ6cy8E0
	WEMVswLfPt3ml4IuYro0J9Dnlvz1dfCT9Rt4/NajDl61heVAvCNFCtvHsWsyokE8zKPDlN
	Ce9EESp57qLPMoqF/AFqQXs6Gvb0lvM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782810865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfjTiG0jHFf9ywEZeS6UslnAQPABLC5dbG0q1WV0izI=;
	b=UU6LDSuVD92DrVChfuxp3DAO+yrTI62eOX64/co/0HzzD9NlXAlwBEtT2griBeBAMSr52u
	KVzIQTpyP3XSE0pb8sNRlpbd3aljgDvA0FSQUJwjaAHsp5aY/gAVU2Lvgx7r6uxwdgP7Qj
	yoD2crg3kh7Vkm/RXTACZ0EWn1suFJ4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XjRXYR50;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B1DF2C1C;
	Tue, 30 Jun 2026 02:14:20 -0700 (PDT)
Received: from [10.57.81.132] (unknown [10.57.81.132])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16E913FAFB;
	Tue, 30 Jun 2026 02:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782810864; bh=gWU2+q57VLQEQbWXLkaWbWHCxJakIwq33zdaa5p1Eu8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XjRXYR504D+Vxscp6Uvahb1H/yAoW0+cH56gS/Gc1aRNw2VZXb9jFW5zgD3p2d2gO
	 3E/MVCbHlFCImB7zkUo3wn4AUZVbYzG1ySzXEwb8GqLYQwL+DiAWM4MRJgJUnn/nTl
	 k7YNttTCKDuukMPf3Ch7PvgZk+8uZgczy5xupOUA=
Message-ID: <0ac4e410-c73a-4fe7-a248-4c0ff735e73f@arm.com>
Date: Tue, 30 Jun 2026 11:14:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v8 02/24] set_memory: Introduce set_memory_pkey() stub
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-hardening@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
 <20260526-kpkeys-v8-2-eaaacdacc67c@arm.com>
 <e026ab6b-aee2-48e7-9bb5-1735d7a23859@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <e026ab6b-aee2-48e7-9bb5-1735d7a23859@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u7sizqy8uhmb4raa8gc1qabnbroujg9t
X-Rspamd-Queue-Id: A04D31C000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782810865-918578
X-HE-Meta: U2FsdGVkX1/T7kkjCnyfn9b0gZ50+I6FCzOfBuOgLu9FBvfkB6nRQ35jmcusGujUoykfMcYTvFMP/RF9I1UG/YCzhSh9BprA1R1ejUZypCHAhAiBnsLJLKOLRil88DiH4B2bnB4LwBgbGtbXUPJQQJZSirOR98ZZPLnITZeNykDnKf4pSCVUDif6Uf/Rq2rWVEY+GFMnbfdQahsWFogz/hvVOActLoqpPShN0G2BK5/TWGJDVgD2Ls1/EvI9QrOrM/C8IioYN90l17cpOmGGhMhzQR9vVdNS2W8MA/ghJZQvLZnE+8PXO84WRIQRS/lRDdtMHiqC999nfdg5teMmcIXmF3a0+S0JTRbU0RtC4UD1Cn7LWAh+qh0EXa6Zo9MkjslcT/8w/17y4ntFvvC3np/eL5wkJe/VLyC7AByCNyoIzals500ONo+TOxPPtw+CVnCaWjYgi6upLYBltBKElV6YvNzVgp022FFIQC5CVEXV2k2SV/0xmOOSYWPpFKJ/jl6+FGcMbSGRVHel0a3ve/HXwQP8WKaO7FPZPmk/HKdbtW78fUQPhhe4hw4qmVeSSswsb3BcyMfY3kH6OtObRz7smD6iqrDfMfHTzzsTIfXziMQyQqCb4JvIfJkxzRnoVIuZmBO9pEynHcuLy8adSOIArG04iQtfUZ2a47EOgjK+W+3u1BuBcHFgqB6sqZNhVLD+yDMJPs+mpm5fbmCqoOAXut8XQ93Y9WanwqUTDzEaATmEQEvAhd35JhpbFhfB52wrQlBnpK2aFb24Z9aV2UMhRjZGHvTjO83jayz0k+XIVZNrCcMn39aZ0IW8WnMv/w+urUBYDefhIWI4wgnmMndbOTsMiZDcJ+6ggtxv7iQhdbG8U0Ru2LZxQ5eo/QpquFtQ5mcUBguxb/Mop/DB0bzI2K757P8ZrOlRCwPoAG2FkNjwQpcUw3EHa92YAv5oHjny1lV0KGLJ+uMHR9H
 FeR2T3Ub
 TTRFYqc0qTJaBl3NSoYR9ZP8Zilu5f/5c6kvIG2P8wCabf29mtE8tUgIT16nkeKUKeF36X9bNAv2fcFYAwg35adqdN2iixv2allqnaip5dVhLHaf5bF4Skc3iN1b+4Qz5UQZrWwEVWw+bQE2LD8J95V6nUQFUlZFLs/7SqRc3RlMuzmIRX3KKq97nGzeB00pBA3grNoHh/WdA8zYGuK6DIXirekaTYd+Ydv1/UHwBywXij77SksmlzQebR/q4kL4eFYs5IV45y7bPVpWwVMGgEbzy15ypWmIp8CkE9vednGOSJrW/mOkKtlv/lXBSRoehe6IJPZVXKO8MCzN+mccOEGzC8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16/06/2026 17:41, David Hildenbrand (Arm) wrote:
> On 5/26/26 13:15, Kevin Brodsky wrote:
>> Introduce a new function, set_memory_pkey(), which sets the
>> protection key (pkey) of pages in the specified linear mapping
>> range. Architectures implementing kernel pkeys (kpkeys) must
>> provide a suitable implementation; an empty stub is added as
>> fallback.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  include/linux/set_memory.h | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
>> index 3030d9245f5a..7b3a8bfde3c6 100644
>> --- a/include/linux/set_memory.h
>> +++ b/include/linux/set_memory.h
>> @@ -84,4 +84,11 @@ static inline int set_memory_decrypted(unsigned long addr, int numpages)
>>  }
>>  #endif /* CONFIG_ARCH_HAS_MEM_ENCRYPT */
>>  
>> +#ifndef CONFIG_ARCH_HAS_KPKEYS
>> +static inline int set_memory_pkey(unsigned long addr, int numpages, int pkey)
>> +{
>> +	return 0;
>> +}
>> +#endif
>> +
>>  #endif /* _LINUX_SET_MEMORY_H_ */
>>
> This patch looks rather odd, given that this is just a stub that won't be used
> before patch #20.
>
> And there, it's only used from arm64 code? So why do we need the common-code stub?

It is primarily used in patch 12, the generic kpkeys page table
allocator, so we do need a stub.

The ordering might be a little confusing indeed, but I tried to follow
the following order: 1. kpkeys/generic, 2. kpkeys/arm64, 3.
kpkeys_hardened_pgtables/generic, 4. kpkeys_hardened_pgtables/arm64.
Happy to reorder if you have other preferences.

- Kevin

