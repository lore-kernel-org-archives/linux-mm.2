Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FDE5FD9E34
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 06:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54D726B0005; Fri, 27 Feb 2026 01:19:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FB2A6B008A; Fri, 27 Feb 2026 01:19:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EF7F6B008C; Fri, 27 Feb 2026 01:19:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 285826B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:19:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFF2D1C528
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:19:18 +0000 (UTC)
X-FDA: 84489234396.23.FBBFD70
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 03A101C000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:19:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772173157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fy8I4DfvDIaiPhoKT5gdF9vbgVJgKjiNms1TxDu+mH4=;
	b=CvKHzf/iI/NCru+5aUwFlVaYudMEEcyBVKNFahpl9fSoAIQeT1GfBn27fAMqW2DuMfIeZE
	HDeBjs1xLslXkrpFOLxUYbj0M62jzQ0li8fKSAaNoO1oUhaUP35KGlt+y5NDfPmyZw9+NO
	GsJQY49EdJ4PryZPWkQNm91LKbWK57o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772173157; a=rsa-sha256;
	cv=none;
	b=tETiAjCmY7BLklcQ4PGmdmDqNmo8hJ1oW62/Vqq154SUAf2boYWGYXxSo1WDRuO22UK3Dq
	p4zc9k6yiBQw6I7SoGhSaYh1+zmPiZO+dfw7QQyM0spnl3ql5xu1o3AQDUY7kvwNs77G2b
	cwL7Cs5w1HA9M5Xb3ovZ7+k9UrpAO3A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9450214BF;
	Thu, 26 Feb 2026 22:19:09 -0800 (PST)
Received: from [10.164.18.47] (unknown [10.164.18.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 446B43F7BD;
	Thu, 26 Feb 2026 22:19:12 -0800 (PST)
Message-ID: <7f59b3ea-9346-46eb-b6c1-ae27b718f7e6@arm.com>
Date: Fri, 27 Feb 2026 11:49:09 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 10/16] arm64/mm: Route all pgtable writes via
 ptdesc_set()
To: Ryan Roberts <ryan.roberts@arm.com>, Usama Arif <usama.arif@linux.dev>
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
 <917f3bc3-1f17-4712-836d-ac75fdef3d16@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <917f3bc3-1f17-4712-836d-ac75fdef3d16@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 03A101C000F
X-Stat-Signature: dbobodqo9tm9mtekykeskmzjbczoozp6
X-Rspam-User: 
X-HE-Tag: 1772173156-132925
X-HE-Meta: U2FsdGVkX1800O/WYo0JnxfCynxeT/fp8zWm0DS9b+v/L31Awrhapu2g49JfCJhTM4FrnYvVhXhbvDPNxcicXSiDdrFbABP8mZ/yVmHAEFp8cH4naJYcfCJPnv+dCM3Uw8jJ9G+qOz7Nv+sK+xsB1vnVQoDIgwwl9cwn9vcnZlbtQyvjWhciGOLtRLTP9Ntmao8REV+CRU/9F5n+/b85KwDQIHCEDJHsk9ASJR/g/YL1gFJWon9PlTXE/OAPuB6e1JEBdaWxV56Ak9Xepngg8zuN1ZNllEWSF9yBSinpPkwS6HetJm6hGHDok4QtvDMvBR4641c8nXUrrpntXn9v5RvRKmVr3pqo0vjjtkmfGr+ssUbovDQzDZUFtubTkj7XTiTkWmnwyt+FxKj9s54zzzmQocXajqGEb/GQnBaVuA+zUrrNGVGNAxmL7Q+MUI1BsyrI1h9lXp22UVwtiISNy5XKHFWLhNOv4s7U3taggSKxMbJ6Rq3+BzXNNTZ6EmToKj4WMEhqnCK+IYC7InmFdLNfMbsUcqTqjXxOhRJzhIl0JPKFM8AxSUZC0oFHlzw/UEeYVrKdQC8h3a153mypoyLcqwett7jTVXJzKjkMeW3aptbcUPDdyq4WzU+FZKAWnJG9mcWf9Du8ZeItUCaViH8Len2/hT0Mto0e8Q8sLak53rfH2qsFhfGMdc/kuvTmcH5MtRqOeT7mmkZscHvdp9MbxkbAKu0dpTqj7fVOFdZ85Jc+bS5OUblGlinSlyDbzPi2IrP+0vmJq8Lk4VawxzON59GY5JKgEY3AEWUohYlYz4LO+AWku0D7FEhSq4Ze3pM51qUQhMp1oGZLTk4G6qM7EXbJYC8sLmvJu88PS+D73Jp1OhPDOg/g5Dpn1F9U2vraRJ+taJVOwBTqylkuwmmml7RM3HTnHkhwj21N2HEs82BTKUQdEzpaqP9N/PjLZMDKKtsYVEYiAZR+eTw
 MrwG/2AP
 XPvYgfoHFiqPMRnANYAB603S2oixxaftx1hUbyeyWqtqgwq+k4WtQK41OE/uT/MUNwJZaw7/Kl/oOHwGlEbuVupjPsmuBc7SS/EGRVr+KhgY+lNEkwa+wBGev+hgFrBGuHeEwLm5RjGcT8Wcz2qlmZ32Cp6QPJ8Psyrb5jU9ZQrraCFbf7+JBekTCYrVZexexBj1PTuN01qbvS0ELn+2Ql9C9SZmmWD3lOX0uE1Kh+wMkjMV5ADFKGg1MIhMeIDoJhFd/d9Yp21uyeHnjMZwTWbOYpviww2WIgJ9yo8x7PxYShx/cSv5C7vx5huDPYZSWtxvUXBK77poLqwc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/02/26 6:49 PM, Ryan Roberts wrote:
> On 26/02/2026 12:54, Anshuman Khandual wrote:
>>
>>
>> On 26/02/26 6:07 PM, Usama Arif wrote:
>>> On Tue, 24 Feb 2026 10:41:47 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>>
>>>> Currently ptdesc_set() is defined as WRITE_ONCE() but this will change for
>>>> D128 pgtable builds, for which WRITE_ONCE() is not sufficient for single
>>>> copy atomicity.
>>>>
>>>> In future this infrastructure can be used for D128 to maintain single copy
>>>> atomicity semantics with inline asm blocks.
>>>>
>>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>>> Cc: Will Deacon <will@kernel.org>
>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>>> ---
>>>>  arch/arm64/include/asm/pgtable.h | 11 ++++++-----
>>>>  arch/arm64/mm/mmu.c              |  4 ++--
>>>>  mm/debug_vm_pgtable.c            |  4 ++--
>>>>  3 files changed, 10 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>>> index 804ef49aea88..42124d2f323d 100644
>>>> --- a/arch/arm64/include/asm/pgtable.h
>>>> +++ b/arch/arm64/include/asm/pgtable.h
>>>> @@ -85,6 +85,7 @@ static inline void arch_leave_lazy_mmu_mode(void)
>>>>  }
>>>>  
>>>>  #define ptdesc_get(x)		READ_ONCE(x)
>>>> +#define ptdesc_set(x, val)	WRITE_ONCE(x, val)
>>>>  
>>>>  #define pmdp_get pmdp_get
>>>>  static inline pmd_t pmdp_get(pmd_t *pmdp)
>>>> @@ -389,7 +390,7 @@ static inline pte_t pte_clear_uffd_wp(pte_t pte)
>>>>  
>>>>  static inline void __set_pte_nosync(pte_t *ptep, pte_t pte)
>>>>  {
>>>> -	WRITE_ONCE(*ptep, pte);
>>>> +	ptdesc_set(*ptep, pte);
>>>>  }
>>>>  
>>>>  static inline void __set_pte_complete(pte_t pte)
>>>> @@ -856,7 +857,7 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
>>>>  	}
>>>>  #endif /* __PAGETABLE_PMD_FOLDED */
>>>>  
>>>> -	WRITE_ONCE(*pmdp, pmd);
>>>> +	ptdesc_set(*pmdp, pmd);
>>>>  
>>>>  	if (pmd_valid(pmd))
>>>>  		queue_pte_barriers();
>>>> @@ -917,7 +918,7 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
>>>>  		return;
>>>>  	}
>>>>  
>>>> -	WRITE_ONCE(*pudp, pud);
>>>> +	ptdesc_set(*pudp, pud);
>>>>  
>>>>  	if (pud_valid(pud))
>>>>  		queue_pte_barriers();
>>>> @@ -999,7 +1000,7 @@ static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
>>>>  		return;
>>>>  	}
>>>>  
>>>> -	WRITE_ONCE(*p4dp, p4d);
>>>> +	ptdesc_set(*p4dp, p4d);
>>>>  	queue_pte_barriers();
>>>>  }
>>>>  
>>>> @@ -1120,7 +1121,7 @@ static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
>>>>  		return;
>>>>  	}
>>>>  
>>>> -	WRITE_ONCE(*pgdp, pgd);
>>>> +	ptdesc_set(*pgdp, pgd);
>>>>  	queue_pte_barriers();
>>>>  }
>>>>  
>>>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>>>> index bcf32d1a92de..ffd307c546f5 100644
>>>> --- a/arch/arm64/mm/mmu.c
>>>> +++ b/arch/arm64/mm/mmu.c
>>>> @@ -83,7 +83,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
>>>>  	 * writable in the kernel mapping.
>>>>  	 */
>>>>  	if (rodata_is_rw) {
>>>> -		WRITE_ONCE(*pgdp, pgd);
>>>> +		ptdesc_set(*pgdp, pgd);
>>>>  		dsb(ishst);
>>>>  		isb();
>>>>  		return;
>>>> @@ -91,7 +91,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
>>>>  
>>>>  	spin_lock(&swapper_pgdir_lock);
>>>>  	fixmap_pgdp = pgd_set_fixmap(__pa_symbol(pgdp));
>>>> -	WRITE_ONCE(*fixmap_pgdp, pgd);
>>>> +	ptdesc_set(*fixmap_pgdp, pgd);
>>>>  	/*
>>>>  	 * We need dsb(ishst) here to ensure the page-table-walker sees
>>>>  	 * our new entry before set_p?d() returns. The fixmap's
>>>> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
>>>> index 83cf07269f13..faf6a19a89a1 100644
>>>> --- a/mm/debug_vm_pgtable.c
>>>> +++ b/mm/debug_vm_pgtable.c
>>>> @@ -445,7 +445,7 @@ static void __init pmd_huge_tests(struct pgtable_debug_args *args)
>>>>  	 * X86 defined pmd_set_huge() verifies that the given
>>>>  	 * PMD is not a populated non-leaf entry.
>>>>  	 */
>>>> -	WRITE_ONCE(*args->pmdp, __pmd(0));
>>>> +	ptdesc_set(*args->pmdp, __pmd(0));
>>>
>>> The ptdesc_set() and ptdesc_get() macros are defined in
>>> arch/arm64/include/asm/pgtable.h and are arm64-specific. This change is
>>> in mm/debug_vm_pgtable.c which is generic code compiled for all
>>> architectures. Other architectures do not define ptdesc_set(), so this
>>> will would cause a build failure on other architectures..
>>
>> Agreed. Probably will add a local fallback for ptdesc_set() which
>> defaults to WRITE_ONCE() for platforms not overriding. OR does it
>> require making ptdesc_get/set() much more generic construct ?
>>
>> Probably missed this problem while building on some other platforms
>> as DEBUG_VM_PGTABLE might not have been enabled in their defconfig.
> 
> I don't think there is any need for WRITE_ONCE() in this file? (and I feel like
> this has come up before in some other context). Could you just change it to a
> plain C assignment? Or even better, pmd_clear()?

Agreed and just sent a patch in this regard.

https://lore.kernel.org/all/20260227061204.2215395-1-anshuman.khandual@arm.com/

> 
>>
>>>
>>>>  	WARN_ON(!pmd_set_huge(args->pmdp, __pfn_to_phys(args->fixed_pmd_pfn), args->page_prot));
>>>>  	WARN_ON(!pmd_clear_huge(args->pmdp));
>>>>  	pmd = pmdp_get(args->pmdp);
>>>> @@ -465,7 +465,7 @@ static void __init pud_huge_tests(struct pgtable_debug_args *args)
>>>>  	 * X86 defined pud_set_huge() verifies that the given
>>>>  	 * PUD is not a populated non-leaf entry.
>>>>  	 */
>>>> -	WRITE_ONCE(*args->pudp, __pud(0));
>>>> +	ptdesc_set(*args->pudp, __pud(0));
>>>>  	WARN_ON(!pud_set_huge(args->pudp, __pfn_to_phys(args->fixed_pud_pfn), args->page_prot));
>>>>  	WARN_ON(!pud_clear_huge(args->pudp));
>>>>  	pud = pudp_get(args->pudp);
>>>> -- 
>>>> 2.43.0
>>>>
>>>>
>>>
>>
> 
> 


