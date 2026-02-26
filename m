Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7193DFCE07B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 13:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E2C6B0005; Thu, 26 Feb 2026 08:19:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC5F6B0089; Thu, 26 Feb 2026 08:19:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8ED6B0092; Thu, 26 Feb 2026 08:19:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7DDEB6B0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:19:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37EFA160196
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:19:20 +0000 (UTC)
X-FDA: 84486664080.01.4D1A3EC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6CAB912000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:19:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772111958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T5bv3fCx38/Oe77CtI1/SCNT7oSrtnnXMV+HW3yFRYU=;
	b=HdS44nXDZR/12xLTZ+u5M6YOYU3gPZbDHvzsc2cLVN2rw8pT4Oitc9P5T0bXyH9kjkOZkx
	wmUIwTk7SsWazDZv1NevfTJ5S6MYdVDnxyA8IfaaqT8qzLD/BQHk1CjiFTpV0vlJur7yl8
	PNpERmqM2A63ev4IeR1lktLaRWOqZTw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772111958; a=rsa-sha256;
	cv=none;
	b=dExqVChG96aLFjZTJNacg5vgaI+rqvyLs7wAA5HCzF84Z8P8vN0+8rnuGcVa3lIjqSaeai
	XleoCuAZevKWKOdG80J9jT3OyJGFG+wIC6Yer5TxBiRZv+0sfTUqfwUyBUdbTcsg/MwL9s
	4ucPbufUFAoWjNSAguh9FvGAEXCxEh4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4789E1516;
	Thu, 26 Feb 2026 05:19:11 -0800 (PST)
Received: from [10.57.82.70] (unknown [10.57.82.70])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 49E263F62B;
	Thu, 26 Feb 2026 05:19:15 -0800 (PST)
Message-ID: <917f3bc3-1f17-4712-836d-ac75fdef3d16@arm.com>
Date: Thu, 26 Feb 2026 13:19:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 10/16] arm64/mm: Route all pgtable writes via
 ptdesc_set()
Content-Language: en-GB
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 Usama Arif <usama.arif@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260226123747.801496-1-usama.arif@linux.dev>
 <0ee7ff56-ac0c-458e-9772-b3c026389e65@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <0ee7ff56-ac0c-458e-9772-b3c026389e65@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CAB912000B
X-Stat-Signature: 66k8s9x9rjtm8sp3rqqkumaobur6dota
X-HE-Tag: 1772111958-147675
X-HE-Meta: U2FsdGVkX18HN2/KJk4/NhfY5AODiJDHcjym5x2pSGrU1k5l+XOa5giaAo6ThMbYJBwP6iiqRI5AwzlaSZE+m57hFD1/gTbpO3o/eSver3LSI5fTm5whRvbjiTISuICo6qsqsRtueVvOL2BSrCQqlRrEf+FqZXxfWCCzX1Pdb1QzUqyLcldtGK/WakUxOpfCLQyEoTuOdM0Kr6qYQ5H90lPUKBT+Q3XtiFWgKROryZEeYf6+s/0vHRtAGnBJ/HyMYaj5w8F8nznan0OvQPPOBDuXuCeXSGxTbA1MPJ1bJJz/yiBvfrq2f1rn0pG8gNoGIC3o82crsAsSqx2hBfxwT/80Fq3E3eNlg4J3un40IiLqA0gzrUYr9T1vzw+zImmtO7eCf8L/BtR6u8aG8srZFlNKK2YCDxzPCiplIvfpoToi12pCVS/Tdr9WOL3HwJYLWASx/WjQA4aCeXxpIKQ8YdD6NN3Gu8y5T92zVxsFB+1JFZbxR/g/DWl4TF3ASfxhzxUBmlNme2A2omMY/5hv32/RE3Ftdr9qbz7Ni2x/HacA8mYzv71zDBveLfPZFvpF/AW3qSkOIZX1l5wgVAfVu8bd3fSBNyWuhkJw+uq+OdWFvkGxhhdjZetCRYyBwXBulN+HtRIvSczdVFTMnL8OYO2XtCZrCFPv2Aec1IAoR9e2p8/76mah6pEaTv7yIosQMRVX2+jHogAnrvIt/RASWslh+nhTjNwKvcXafn8/k6I2vBuxWntc4/CBAbu/8+MbaPoL/3a5DkXRkPlV+L2TSIuSUS2ZoNnzNy4NvnzrBP/Rb22bzm51k23lvuEBor2psBTTXlECpyqEp4ri38pSMBK8NgwNM7zgiK/gZSUWFvwHizhFk7JyRbBNGePn8ykMfmo2U71Si3kpGq8rmOX2IgY0mZs45yGn+CQ3qL8uCEER+oGxrC6jSHoLj7fPUtY+wQeXoQY2JPv3nxLqkIH
 wqgzu4kD
 XqoMs2QOX1rfgAjOsSALGQIX3bf8OHgGOsKZH8/DCCwH9eJqwELcPoLCznajPU8zd8ymRY2LTmc5pNYJnPNsj60v+L4Mm6MWK9pjsBT7bwdv5gYGr1S/kculK31kGocefstoE4qwcIMf5ywL+tmI3bEiAqybxsXiggVHH3ucmbTKXeybgYguZDXS1hYkXNal2jfYXHYwA/RKO+SuqkJ0X1n6B6dBt2I6ZaSppNuM4TjEMlEp5mRnMDQeLY+2wDq2beRrNemDlff6aSUUF5iAgac5uS72x9bNzyISshAqGyXxJt7i/PKJvNJeQa7MBPtZCWb4eidkbyW6nG2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/02/2026 12:54, Anshuman Khandual wrote:
> 
> 
> On 26/02/26 6:07 PM, Usama Arif wrote:
>> On Tue, 24 Feb 2026 10:41:47 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>
>>> Currently ptdesc_set() is defined as WRITE_ONCE() but this will change for
>>> D128 pgtable builds, for which WRITE_ONCE() is not sufficient for single
>>> copy atomicity.
>>>
>>> In future this infrastructure can be used for D128 to maintain single copy
>>> atomicity semantics with inline asm blocks.
>>>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Will Deacon <will@kernel.org>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>> ---
>>>  arch/arm64/include/asm/pgtable.h | 11 ++++++-----
>>>  arch/arm64/mm/mmu.c              |  4 ++--
>>>  mm/debug_vm_pgtable.c            |  4 ++--
>>>  3 files changed, 10 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>> index 804ef49aea88..42124d2f323d 100644
>>> --- a/arch/arm64/include/asm/pgtable.h
>>> +++ b/arch/arm64/include/asm/pgtable.h
>>> @@ -85,6 +85,7 @@ static inline void arch_leave_lazy_mmu_mode(void)
>>>  }
>>>  
>>>  #define ptdesc_get(x)		READ_ONCE(x)
>>> +#define ptdesc_set(x, val)	WRITE_ONCE(x, val)
>>>  
>>>  #define pmdp_get pmdp_get
>>>  static inline pmd_t pmdp_get(pmd_t *pmdp)
>>> @@ -389,7 +390,7 @@ static inline pte_t pte_clear_uffd_wp(pte_t pte)
>>>  
>>>  static inline void __set_pte_nosync(pte_t *ptep, pte_t pte)
>>>  {
>>> -	WRITE_ONCE(*ptep, pte);
>>> +	ptdesc_set(*ptep, pte);
>>>  }
>>>  
>>>  static inline void __set_pte_complete(pte_t pte)
>>> @@ -856,7 +857,7 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
>>>  	}
>>>  #endif /* __PAGETABLE_PMD_FOLDED */
>>>  
>>> -	WRITE_ONCE(*pmdp, pmd);
>>> +	ptdesc_set(*pmdp, pmd);
>>>  
>>>  	if (pmd_valid(pmd))
>>>  		queue_pte_barriers();
>>> @@ -917,7 +918,7 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
>>>  		return;
>>>  	}
>>>  
>>> -	WRITE_ONCE(*pudp, pud);
>>> +	ptdesc_set(*pudp, pud);
>>>  
>>>  	if (pud_valid(pud))
>>>  		queue_pte_barriers();
>>> @@ -999,7 +1000,7 @@ static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
>>>  		return;
>>>  	}
>>>  
>>> -	WRITE_ONCE(*p4dp, p4d);
>>> +	ptdesc_set(*p4dp, p4d);
>>>  	queue_pte_barriers();
>>>  }
>>>  
>>> @@ -1120,7 +1121,7 @@ static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
>>>  		return;
>>>  	}
>>>  
>>> -	WRITE_ONCE(*pgdp, pgd);
>>> +	ptdesc_set(*pgdp, pgd);
>>>  	queue_pte_barriers();
>>>  }
>>>  
>>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>>> index bcf32d1a92de..ffd307c546f5 100644
>>> --- a/arch/arm64/mm/mmu.c
>>> +++ b/arch/arm64/mm/mmu.c
>>> @@ -83,7 +83,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
>>>  	 * writable in the kernel mapping.
>>>  	 */
>>>  	if (rodata_is_rw) {
>>> -		WRITE_ONCE(*pgdp, pgd);
>>> +		ptdesc_set(*pgdp, pgd);
>>>  		dsb(ishst);
>>>  		isb();
>>>  		return;
>>> @@ -91,7 +91,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
>>>  
>>>  	spin_lock(&swapper_pgdir_lock);
>>>  	fixmap_pgdp = pgd_set_fixmap(__pa_symbol(pgdp));
>>> -	WRITE_ONCE(*fixmap_pgdp, pgd);
>>> +	ptdesc_set(*fixmap_pgdp, pgd);
>>>  	/*
>>>  	 * We need dsb(ishst) here to ensure the page-table-walker sees
>>>  	 * our new entry before set_p?d() returns. The fixmap's
>>> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
>>> index 83cf07269f13..faf6a19a89a1 100644
>>> --- a/mm/debug_vm_pgtable.c
>>> +++ b/mm/debug_vm_pgtable.c
>>> @@ -445,7 +445,7 @@ static void __init pmd_huge_tests(struct pgtable_debug_args *args)
>>>  	 * X86 defined pmd_set_huge() verifies that the given
>>>  	 * PMD is not a populated non-leaf entry.
>>>  	 */
>>> -	WRITE_ONCE(*args->pmdp, __pmd(0));
>>> +	ptdesc_set(*args->pmdp, __pmd(0));
>>
>> The ptdesc_set() and ptdesc_get() macros are defined in
>> arch/arm64/include/asm/pgtable.h and are arm64-specific. This change is
>> in mm/debug_vm_pgtable.c which is generic code compiled for all
>> architectures. Other architectures do not define ptdesc_set(), so this
>> will would cause a build failure on other architectures..
> 
> Agreed. Probably will add a local fallback for ptdesc_set() which
> defaults to WRITE_ONCE() for platforms not overriding. OR does it
> require making ptdesc_get/set() much more generic construct ?
> 
> Probably missed this problem while building on some other platforms
> as DEBUG_VM_PGTABLE might not have been enabled in their defconfig.

I don't think there is any need for WRITE_ONCE() in this file? (and I feel like
this has come up before in some other context). Could you just change it to a
plain C assignment? Or even better, pmd_clear()?

> 
>>
>>>  	WARN_ON(!pmd_set_huge(args->pmdp, __pfn_to_phys(args->fixed_pmd_pfn), args->page_prot));
>>>  	WARN_ON(!pmd_clear_huge(args->pmdp));
>>>  	pmd = pmdp_get(args->pmdp);
>>> @@ -465,7 +465,7 @@ static void __init pud_huge_tests(struct pgtable_debug_args *args)
>>>  	 * X86 defined pud_set_huge() verifies that the given
>>>  	 * PUD is not a populated non-leaf entry.
>>>  	 */
>>> -	WRITE_ONCE(*args->pudp, __pud(0));
>>> +	ptdesc_set(*args->pudp, __pud(0));
>>>  	WARN_ON(!pud_set_huge(args->pudp, __pfn_to_phys(args->fixed_pud_pfn), args->page_prot));
>>>  	WARN_ON(!pud_clear_huge(args->pudp));
>>>  	pud = pudp_get(args->pudp);
>>> -- 
>>> 2.43.0
>>>
>>>
>>
> 


