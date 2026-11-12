Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8394606B59B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JNB2g3Zm
Received: by kanga.kvack.org (Postfix)
	id C21BC6B05C6; Thu, 12 Nov 2026 06:29:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAAE46B05DE; Thu, 12 Nov 2026 06:29:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99ED6B05DF; Thu, 12 Nov 2026 06:29:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FD576B05C6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:29:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 07A171A0582
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:29:10 +0000 (UTC)
X-FDA: 85426245660.08.E4CE22F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id DB37740004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:29:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JNB2g3Zm;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794482948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=omP2ka6eqdRebpd9f2r0exDtmLmc6R/khoAMBzVyA3w=;
	b=fSvzxSCSwkelgx4eg6KecJrVcMbtMIxBTdCy+u3m/DhvKc8xf4Y6ypw5fYO8D+FJ1VvBWX
	rs0SOLW3XIUqNBra/ObvTSsXDvNq2XS0LBIEoAAcofvbncBIkqk/R65yz0WV/ggnuJjZBz
	2QXtw5sUdIsiMMv2smkDtPGcJpg4EUI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JNB2g3Zm;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794482948;
	b=CQkvg3e34nqZQMLBhDL8PRs4la/uS8bahBOYCI+OmjkluY4m+BZfXu6cEbA/oYIdH0BCu/
	3tzrNrfKHNey2LYj0wWVnE21zTzvwR7iihAjaQD4ARPKtFJ01Z25X8CGoY/YcdG9eZIngn
	6G52pwf+45XfxofeODLbje6rGh8/i5U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82305153B;
	Thu, 12 Nov 2026 03:29:02 -0800 (PST)
Received: from [10.57.59.183] (unknown [10.57.59.183])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 45FFC3FA7A;
	Thu, 12 Nov 2026 03:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794482945; bh=GM+wYOwDu4RHFLVq/TBNKwG/MbfYaJS+I1C0GInFgZc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JNB2g3ZmQqRZ5i+qpkSU6aSNW2KEfP/6eEdrA4U5pGDP5V+3MgICDJlffO51AcsQL
	 Ay60k6osyIJCBlnzKeZP6Hn4/sWuap8Rl800g52mwF2zB1ROVV+8nEYPmBSdFcc9Oi
	 53FaBbGBQsbN16dxZvALt9asmN5jzazd454fKKwI=
Message-ID: <65433c02-7b1c-449b-bf92-417bdedbbe54@arm.com>
Date: Thu, 12 Nov 2026 12:28:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v10 13/22] mm: kpkeys: Protect early kernel page
 tables
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org, x86@kernel.org,
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-13-aa6c4d9603bc@arm.com>
 <sashiko-outbox-207327@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-207327@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j5xu5a91duhemgq44f1ttx1dw4mgh9qd
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DB37740004
X-HE-Tag: 1794482946-565833
X-HE-Meta: U2FsdGVkX19/yGUH6eOF+jMlMMWX+RhxKv7x8302aB3xsqzJF08X+GhofkPzSjudvcfbR4RF/lmB6mZQutdhDiL6Ji04HTRjXs5wtX/jH7N9STEGo707PPNp6j3ZQXmmhwxE5u87LuzihBm0VOp7foD2HRAmWDHXG6PXprVXDXE1CMDiToCmM1ReplJFKw6Sk2puT8r7TdJHoWNM24aKYFaDgm/65L62Q9Mi2mHdLfKYMH0MTEFVe+jOVfSJdIoRAUk1XTy1gv3f5Ig9B/B4bNm6uxIg4+mH1I2UuWy32PYgrIZracz1D8IJ+KGyTluCA9LQuD3kRcSiSwpBEqIkhv5/T7QLliqlLp1w7hlRgGN9NlzEHKJbKdcUhcmhiRr/k/Nh6P2yh+c9cH6cy7BZRHxw9LCJN35KzJ+Zd/kHXK535/bGqpLnCAM1PSZMjCEGj+Y7EywXvsCWpArWISoPz2jy0atIZJPbOGn5vuEOvgT7oEWw689nfy1A4Hd81X5Pkt3T0gGq5YOhwfy5nXoRyTqJOAO3PlcZ04kR4N5A/xt8FEq/SgM/ub9EzrkhGwX56FkQteg8Gq0fFYnbPhGau8XIyd/usw5qQryxD8SgQ7yw6iXgHRlrGvToWytqG8NwNYJs0nWdbjHiUCpj38edWhEILmKEZY+nOsaRsSW+1+0R+5Jc2DDJCzozOj0F2SnmyEWlrb3+54F2bisUJANNtbOrv+gxYw8D/3vISwefrpBgeAp3ZHt+oolYCin1ngmB5FOF1h5h9pd37J/cSuMGPG1Zb3lx4Y9FKAG0KPjJCiPC2dd/JpqCThiSd+TUo79DhSOGbHaOzaGWIrB76dKRB4ibGwUx6wdTR3TJB9o7C4XkEep30udfy9vPC3gNKO3fDodnH7Yc7xjj8OkkRnEyH15w5qQ+m/CLTutM6FIlMk4sgCzHF5ZRNSj4DGyKFNbA1690lZUQT9QTzB6jooU
 16XAV26o
 STLQyX9wGEtF4qKw8Gyvf2q9LmTeHfR0H3azMcsApIgP0J8luRqTCpBXMosU3R/l2rmpDH85sp4Bhy0cK2zS24vhVGmZygRcR8GILq3wen946BaSr6uNKGkRQco0zfeRg+7028IxskzPtxMQOGWsCOUFcaT0CMVmcZbTDmNB/lyTP3KdBkg7B8FqnJTep0md0mLdvR5r6XyoXr9aPb/M/hqLfZV8GtSRm2zMwsYOMAY0m5cdP2wGoJGbG760KNQGkhgHhaNz/jw85qXOQEqvIF8CXNuYxPyBBJiueyLQWSAO4y60fO6neddvLyClxstE5PXYm2m7UFelOdDeYrFsa2PZzE1cVm9LdaSIHC7YpFAZboAhrXdrfju8dNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/11/2026 17:02, sashiko-bot@kernel.org wrote:
>> +static int __init protect_p4d_table(pgd_t *pgd, unsigned long addr,
>> +				    unsigned long next, struct mm_walk *walk)
>> +{
>> +	pgd_t entry;
>> +
>> +	if (mm_p4d_folded(walk->mm))
>> +		return 0;
>> +
>> +	entry = pgdp_get(pgd);
>> +	if (!pgd_present(entry) || pgd_leaf(entry))
>> +		return 0;
>> +
>> +	protect_pgtable_page(p4d_offset(pgd, 0));
>> +
>> +	return 0;
>> +}
> [Severity: Medium]
> When CONFIG_KASAN_GENERIC or CONFIG_KASAN_SW_TAGS is enabled, does this walk
> and call set_direct_map_pkey() millions of times on the shared
> kasan_early_shadow_{p4d,pud,pmd,pte} tables?

Yes, KASAN support needs to be addressed, as mentioned in the cover letter.

> kasan_init() runs in setup_arch() before mm_core_init() calls
> kpkeys_hardened_pgtables_init(), populating unbacked shadow ranges in
> [PAGE_OFFSET, ULONG_MAX) with shared static tables where all 512 entries at
> each level point to the same next-level kasan_early_shadow_* page.  Unlike
> mm/ptdump.c, which detects those tables and sets walk->action =
> ACTION_CONTINUE, the callbacks here descend through every entry and invoke
> set_direct_map_pkey() (including a direct-map page table walk and broadcast
> TLB flush) for every 2 MiB PMD slot across the multi-terabyte shadow range,
> stalling boot.
>
> [ ... ]
>
>> +static void __init protect_early_kernel_pgtables(void)
>> +{
>> +	int ret;
>> +
>> +	mmap_write_lock(&init_mm);
>> +	/*
>> +	 * [PAGE_OFFSET, ULONG_MAX) covers all early kernel mappings on arm64
>> +	 * and x86 (at least).
>> +	 */
>> +	ret = walk_kernel_page_table_range(PAGE_OFFSET, ULONG_MAX,
>> +					   &protect_pgtable_ops, NULL, NULL);
>> +	mmap_write_unlock(&init_mm);
>> +	WARN_ON_ONCE(ret);
>> +}
> [Severity: Medium]
> On arm64 with CONFIG_ARM64_LPA2=y running on hardware where the top page
> table level is dynamically folded (vabits_actual < VA_BITS), does starting
> at PAGE_OFFSET walk and re-protect swapper_pg_dir 16 or 32 times?
>
> On arm64, PAGE_OFFSET is the compile-time _PAGE_OFFSET(VA_BITS) rather than
> _PAGE_OFFSET(vabits_actual).  When !pgtable_l5_enabled() on 4K pages (or
> !pgtable_l4_enabled() on 16K pages), pgd_none() is always false and
> pgd_to_folded_p4d() (or p4d_to_folded_pud()) wraps each top-level step in
> [PAGE_OFFSET, ULONG_MAX) back to the start of swapper_pg_dir:
>
> arch/arm64/include/asm/pgtable.h:pgd_to_folded_p4d() {
> 	return (p4d_t *)PTR_ALIGN_DOWN(pgdp, PAGE_SIZE) + p4d_index(addr);
> }
>
> As a result, walk_kernel_page_table_range() traverses the entire kernel page
> table hierarchy and flushes TLBs across all page table pages 16 times on 4K
> pages (or 32 times on 16K pages) during boot.

Right. Addresses don't really matter here, so for the next version I'm
planning to use the synthetic range [0, SZ) where SZ is PTRS_PER_PXX *
PXX_SIZE and PXX is the highest non-folded level (PGD if there is no
folding).

- Kevin

