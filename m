Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8A17FCE075
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 12:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189BA6B008C; Thu, 26 Feb 2026 07:55:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 137DB6B0096; Thu, 26 Feb 2026 07:55:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064406B0098; Thu, 26 Feb 2026 07:55:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9B916B008C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:55:05 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2F01BD8D6
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:55:05 +0000 (UTC)
X-FDA: 84486602970.12.4C9A277
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0992E1C0006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:55:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772110504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9UpS5jL+Gpp+QY07dUZaiaPkT9jgd2LHzEpatl5ADyk=;
	b=du9NDcb0pQMzM8KN/DCeIqLBALjA+YnRDBLB2dj+wBDddOSCsdsMYgfLqDtqUpYR5i3c5n
	9zjaIZrLUIIiIIxyEc78v+HK7i4I/Q/LvG/NrSysOjpmjRUOu6tJkDL0mGLkQFQvcQp/Kj
	K/3wexx0SUnOUWJt9CKlvwg/wXuskdM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772110504; a=rsa-sha256;
	cv=none;
	b=jwMlXB3Mfa3QySDvQomSTEp/vIwlQtz7igwGILZm4bic0Wl5zWCuoZGAESl4ge6i//qyqi
	+9AlFQ9elRvhyeebWdXtVnPQbrZP6l251gcvhaiysubaSStpTPNYLm1YOimApZovjSXESX
	U/bmAARPX9fMUsSV60KciCSlnOdTQe4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3A3A339;
	Thu, 26 Feb 2026 04:54:56 -0800 (PST)
Received: from [10.163.173.11] (unknown [10.163.173.11])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 20EB03F73B;
	Thu, 26 Feb 2026 04:54:57 -0800 (PST)
Message-ID: <0ee7ff56-ac0c-458e-9772-b3c026389e65@arm.com>
Date: Thu, 26 Feb 2026 18:24:51 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 10/16] arm64/mm: Route all pgtable writes via
 ptdesc_set()
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260226123747.801496-1-usama.arif@linux.dev>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260226123747.801496-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 94u8t6u4x7nnu57c5c5pno5wtq9zsuns
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0992E1C0006
X-HE-Tag: 1772110503-474716
X-HE-Meta: U2FsdGVkX19fae1XXXQx0NJZ2ULx5fltDJ1DpPFVGFm1c6iD0x/GZV769xKo8m9QFLmIgYuSRiaC8CQHJipJrF7MkQuiXOYQ5WAULT6OwZp4ug8nBKUKbg4GlEYdzjk2LVwunINTCGMHoyPqrY/Rgpmdu+PcO0mpEn8Rr2Adjjlldr8GZexmXHvdR5bO6imGeCWwDm6Clt8staz6xwJm3soFoqlt3huq4nPn6veKvF4ETN8mD8yz5s0EOpiHEMwJKstzLQhWQwtWTCFjAhbv+2hcuUzHiHX6EdDe2V4ZYOWd1XgN8HQZlcTBoTzrqxZ4W+lyG2I7TSXm08/yKVe0EHDPpCWQg4uBfJ7I+BXCGRofL3akSRO2nI5zWmWwWw9acWYiNsUG5lmFJrrliLR/kXSF5tHIhho9Xc1uVZSKrZE2gbwWTU0St1cPaBNeNvGgvlIcflXgf72FrTIJWXdrQ9m6AAl+l3AsB4iRUtDgAvhOcxflP+p+GkloGMNzzQmyN2r9cIyLt0ZG/7sqDlbCNyTU015eQ//6ryq0tw/XyinBe/EdcyqaAIQhtcTw1b0m3s8xcWzp0uha7cM/pTjbVYVBagm/3iotfVwOsKmHO3MReVb6IvUVpm+TV4Joa5FEDLgGcnEwc+W5qmtT2oAODoEXoM0b7suWSwgTyudI9ZMlM+Pr2dGSa39zRpwoD1MXYctmpUEHEXg4AN69PIbNzHVRSamy4NvpGg41MMq4Ipz5kzc8H2aT0MKufoO209m5lyRJB9ra1NMVhDPWMM5+9DcrsrYFvGWDfKpDgEVSrQf8b8+vYk8aLPFgQ8mr3l5GiFC77rE3pcBxOrh0+mavUKNWjTAKJbsuRCuIWBtRKpLJIOIFkdUoR3l9tL1O6e16X3HKTKsiFgY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/02/26 6:07 PM, Usama Arif wrote:
> On Tue, 24 Feb 2026 10:41:47 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:
> 
>> Currently ptdesc_set() is defined as WRITE_ONCE() but this will change for
>> D128 pgtable builds, for which WRITE_ONCE() is not sufficient for single
>> copy atomicity.
>>
>> In future this infrastructure can be used for D128 to maintain single copy
>> atomicity semantics with inline asm blocks.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/include/asm/pgtable.h | 11 ++++++-----
>>  arch/arm64/mm/mmu.c              |  4 ++--
>>  mm/debug_vm_pgtable.c            |  4 ++--
>>  3 files changed, 10 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 804ef49aea88..42124d2f323d 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -85,6 +85,7 @@ static inline void arch_leave_lazy_mmu_mode(void)
>>  }
>>  
>>  #define ptdesc_get(x)		READ_ONCE(x)
>> +#define ptdesc_set(x, val)	WRITE_ONCE(x, val)
>>  
>>  #define pmdp_get pmdp_get
>>  static inline pmd_t pmdp_get(pmd_t *pmdp)
>> @@ -389,7 +390,7 @@ static inline pte_t pte_clear_uffd_wp(pte_t pte)
>>  
>>  static inline void __set_pte_nosync(pte_t *ptep, pte_t pte)
>>  {
>> -	WRITE_ONCE(*ptep, pte);
>> +	ptdesc_set(*ptep, pte);
>>  }
>>  
>>  static inline void __set_pte_complete(pte_t pte)
>> @@ -856,7 +857,7 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
>>  	}
>>  #endif /* __PAGETABLE_PMD_FOLDED */
>>  
>> -	WRITE_ONCE(*pmdp, pmd);
>> +	ptdesc_set(*pmdp, pmd);
>>  
>>  	if (pmd_valid(pmd))
>>  		queue_pte_barriers();
>> @@ -917,7 +918,7 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
>>  		return;
>>  	}
>>  
>> -	WRITE_ONCE(*pudp, pud);
>> +	ptdesc_set(*pudp, pud);
>>  
>>  	if (pud_valid(pud))
>>  		queue_pte_barriers();
>> @@ -999,7 +1000,7 @@ static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
>>  		return;
>>  	}
>>  
>> -	WRITE_ONCE(*p4dp, p4d);
>> +	ptdesc_set(*p4dp, p4d);
>>  	queue_pte_barriers();
>>  }
>>  
>> @@ -1120,7 +1121,7 @@ static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
>>  		return;
>>  	}
>>  
>> -	WRITE_ONCE(*pgdp, pgd);
>> +	ptdesc_set(*pgdp, pgd);
>>  	queue_pte_barriers();
>>  }
>>  
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index bcf32d1a92de..ffd307c546f5 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -83,7 +83,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
>>  	 * writable in the kernel mapping.
>>  	 */
>>  	if (rodata_is_rw) {
>> -		WRITE_ONCE(*pgdp, pgd);
>> +		ptdesc_set(*pgdp, pgd);
>>  		dsb(ishst);
>>  		isb();
>>  		return;
>> @@ -91,7 +91,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
>>  
>>  	spin_lock(&swapper_pgdir_lock);
>>  	fixmap_pgdp = pgd_set_fixmap(__pa_symbol(pgdp));
>> -	WRITE_ONCE(*fixmap_pgdp, pgd);
>> +	ptdesc_set(*fixmap_pgdp, pgd);
>>  	/*
>>  	 * We need dsb(ishst) here to ensure the page-table-walker sees
>>  	 * our new entry before set_p?d() returns. The fixmap's
>> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
>> index 83cf07269f13..faf6a19a89a1 100644
>> --- a/mm/debug_vm_pgtable.c
>> +++ b/mm/debug_vm_pgtable.c
>> @@ -445,7 +445,7 @@ static void __init pmd_huge_tests(struct pgtable_debug_args *args)
>>  	 * X86 defined pmd_set_huge() verifies that the given
>>  	 * PMD is not a populated non-leaf entry.
>>  	 */
>> -	WRITE_ONCE(*args->pmdp, __pmd(0));
>> +	ptdesc_set(*args->pmdp, __pmd(0));
> 
> The ptdesc_set() and ptdesc_get() macros are defined in
> arch/arm64/include/asm/pgtable.h and are arm64-specific. This change is
> in mm/debug_vm_pgtable.c which is generic code compiled for all
> architectures. Other architectures do not define ptdesc_set(), so this
> will would cause a build failure on other architectures..

Agreed. Probably will add a local fallback for ptdesc_set() which
defaults to WRITE_ONCE() for platforms not overriding. OR does it
require making ptdesc_get/set() much more generic construct ?

Probably missed this problem while building on some other platforms
as DEBUG_VM_PGTABLE might not have been enabled in their defconfig.

> 
>>  	WARN_ON(!pmd_set_huge(args->pmdp, __pfn_to_phys(args->fixed_pmd_pfn), args->page_prot));
>>  	WARN_ON(!pmd_clear_huge(args->pmdp));
>>  	pmd = pmdp_get(args->pmdp);
>> @@ -465,7 +465,7 @@ static void __init pud_huge_tests(struct pgtable_debug_args *args)
>>  	 * X86 defined pud_set_huge() verifies that the given
>>  	 * PUD is not a populated non-leaf entry.
>>  	 */
>> -	WRITE_ONCE(*args->pudp, __pud(0));
>> +	ptdesc_set(*args->pudp, __pud(0));
>>  	WARN_ON(!pud_set_huge(args->pudp, __pfn_to_phys(args->fixed_pud_pfn), args->page_prot));
>>  	WARN_ON(!pud_clear_huge(args->pudp));
>>  	pud = pudp_get(args->pudp);
>> -- 
>> 2.43.0
>>
>>
> 


