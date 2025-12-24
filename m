Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B0B2E7545C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 14:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BADC6B00B6; Wed, 24 Dec 2025 09:07:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 669576B00BB; Wed, 24 Dec 2025 09:07:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56AF06B00BC; Wed, 24 Dec 2025 09:07:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 484E76B00B6
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:07:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DEA3113A23B
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 14:07:41 +0000 (UTC)
X-FDA: 84254542722.29.0CD5862
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3D14640006
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 14:07:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766585260; a=rsa-sha256;
	cv=none;
	b=Ujg/RqRIZXKPgFG8sMF0G2M48e9+rxGJJMRckbQuDkBQyLvyIlYsyOZhg3uXjUFT8Ok0OE
	CIICLcV2IxmfOQLhSkCE4MEPF4fYp0Lp9d99uZJ4oRTf94SfCXP2jqFu0h+IR3pe0xaBHu
	9UyY6j7uYnf0mPFxqzz/8FdRCXHGAOU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766585260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CNP12ttvfiKuLGbd+vZzogiX6plKziyzDRQUiTQGcx4=;
	b=mkrmCYRAm6yhIgZRKlTc0BzVdVchZ1Y2zY4+EUn5hMWE1LSKGJIiC/DkFUlFFugMulxNuq
	mJ5QaPG/K/d6TquxXdpF1idhtJPxg7AzBAeUDR2Odploiq0x06M6ykNjHwkx2l5QNiKj3H
	nHQv+2N+AxhCxUHAhGT7YHwHkCSuQT0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0AA54339;
	Wed, 24 Dec 2025 06:07:32 -0800 (PST)
Received: from [10.57.93.190] (unknown [10.57.93.190])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 290423F5A1;
	Wed, 24 Dec 2025 06:07:36 -0800 (PST)
Message-ID: <c5df1f9f-952a-4e83-9ae0-bd0a83dedd36@arm.com>
Date: Wed, 24 Dec 2025 14:07:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] arm64: mm: support batch clearing of the young
 flag for large folios
Content-Language: en-GB
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
 <3b427d9010a6d52f2b91342760f12be097d21cf6.1766455378.git.baolin.wang@linux.alibaba.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <3b427d9010a6d52f2b91342760f12be097d21cf6.1766455378.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D14640006
X-Rspamd-Server: rspam04
X-Stat-Signature: 4gji43cehptw7a381taon1bfpaib46hj
X-HE-Tag: 1766585260-193737
X-HE-Meta: U2FsdGVkX18Gk7dO4TDM7MIJXUxY+sjhmLoCDaxhbsZgXkIQyw1DONexPWlataGJ1GuVyorp9QEH8mMHZhxaW1Tk7WIdbzIEQCA1FphZ19bGRiSFUXJilWYySS49YxmtBCxaFLbPSi0reROHfA/Dl5HXVIJtRTA/i3Lg2EeWwnNq8lwRStvPGz+rmC6oy78i7aXeAEzgILX3bFGc2qCzj33VJrYzbqqDWNbR8s0rrtXPKqbcfLH/71c3etkdiGWWUt1K26E6Zyu5LPP4pqrJZ5euOM0qHlD4xyGL5AXEEO+ejF3GZWiQYzWsEWgP179x7OlRPUvLj4tF8UjwuCd7E40Z9J2wEK1gyTQOLaPCa0V7mYNp9ieFvWCHsFJKlG+vuwfoUXCvxzUKt7RE8vftBCzoEB0S4v76Jkp0zxm1A/+HmieO/OKsLW8n9kjkSFFbJYYNBE7j+Pd1avDnsjcBS6bK2uUUC3LX6Ta4yhk0qemG7Vy6EFyhMjrXg4kKnydNH/imjq+s7dXzBJqx1fonImCvXBkY1etOIVq6fcRKoZYZCPwh/SMfe6p4NxGqkG5Bpq7ZySzzmNIYRSW7a0EwK3nF9KT5rkzzSkq//hcV1RoGlvz5/4SHxx71YcVJqY8p9bFu3UodyIIPIRGMvL5529qTHBEjAuSNzIvzMcwJziYSER09uULOH6Vf6Xm7KqI92M92rBBdwMOa92OedrkQN2cJi63iWUSTbY+yxgJKfOcLHXbc+goym21K2u6TZpzaLv8n2uBdzCqgQ70jeTkgnJOM4htoaudSdWdgpJbyfALh3zx0GC/cHuhmY33axxV69pM1ouEXHcNwd4jSfhZifQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/12/2025 05:48, Baolin Wang wrote:
> Currently, contpte_ptep_test_and_clear_young() and contpte_ptep_clear_flush_young()
> only clear the young flag and flush TLBs for PTEs within the contiguous range.
> To support batch PTE operations for other sized large folios in the following
> patches, adding a new parameter to specify the number of PTEs that map consecutive
> pages of the same large folio in a single VMA and a single page table.
> 
> While we are at it, rename the functions to maintain consistency with other
> contpte_*() functions.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 12 ++++++------
>  arch/arm64/mm/contpte.c          | 33 ++++++++++++++++++--------------
>  2 files changed, 25 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 445e18e92221..d5fbe72e820a 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1648,10 +1648,10 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
>  extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>  				unsigned long addr, pte_t *ptep,
>  				unsigned int nr, int full);
> -extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
> -				unsigned long addr, pte_t *ptep);
> -extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
> -				unsigned long addr, pte_t *ptep);
> +int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
> +				unsigned long addr, pte_t *ptep, unsigned int nr);
> +int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
> +				unsigned long addr, pte_t *ptep, unsigned int nr);
>  extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>  				pte_t *ptep, unsigned int nr);
>  extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
> @@ -1823,7 +1823,7 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
>  	if (likely(!pte_valid_cont(orig_pte)))
>  		return __ptep_test_and_clear_young(vma, addr, ptep);
>  
> -	return contpte_ptep_test_and_clear_young(vma, addr, ptep);
> +	return contpte_test_and_clear_young_ptes(vma, addr, ptep, CONT_PTES);

As per your fixup patch, I agree that nr should be 1 here, not CONT_PTES.

>  }
>  
>  #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
> @@ -1835,7 +1835,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>  	if (likely(!pte_valid_cont(orig_pte)))
>  		return __ptep_clear_flush_young(vma, addr, ptep);
>  
> -	return contpte_ptep_clear_flush_young(vma, addr, ptep);
> +	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);

And same here.

>  }
>  
>  #define wrprotect_ptes wrprotect_ptes
> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> index e4ddeb46f25d..b929a455103f 100644
> --- a/arch/arm64/mm/contpte.c
> +++ b/arch/arm64/mm/contpte.c
> @@ -508,8 +508,9 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
>  }
>  EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
>  
> -int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
> -					unsigned long addr, pte_t *ptep)
> +int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
> +					unsigned long addr, pte_t *ptep,
> +					unsigned int nr)
>  {
>  	/*
>  	 * ptep_clear_flush_young() technically requires us to clear the access
> @@ -518,41 +519,45 @@ int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
>  	 * contig range when the range is covered by a single folio, we can get
>  	 * away with clearing young for the whole contig range here, so we avoid
>  	 * having to unfold.
> +	 *
> +	 * The 'nr' means consecutive (present) PTEs that map consecutive pages
> +	 * of the same large folio in a single VMA and a single page table.
>  	 */
>  
> +	unsigned long end = addr + nr * PAGE_SIZE;
>  	int young = 0;
> -	int i;
>  
> -	ptep = contpte_align_down(ptep);
> -	addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
> -
> -	for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
> +	ptep = contpte_align_addr_ptep(&addr, &end, ptep, nr);
> +	for (; addr != end; ptep++, addr += PAGE_SIZE)
>  		young |= __ptep_test_and_clear_young(vma, addr, ptep);
>  
>  	return young;
>  }
> -EXPORT_SYMBOL_GPL(contpte_ptep_test_and_clear_young);
> +EXPORT_SYMBOL_GPL(contpte_test_and_clear_young_ptes);
>  
> -int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
> -					unsigned long addr, pte_t *ptep)
> +int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
> +				unsigned long addr, pte_t *ptep,
> +				unsigned int nr)
>  {
>  	int young;
>  
> -	young = contpte_ptep_test_and_clear_young(vma, addr, ptep);
> +	young = contpte_test_and_clear_young_ptes(vma, addr, ptep, nr);
>  
>  	if (young) {
> +		unsigned long end = addr + nr * PAGE_SIZE;
> +
> +		contpte_align_addr_ptep(&addr, &end, ptep, nr);
>  		/*
>  		 * See comment in __ptep_clear_flush_young(); same rationale for
>  		 * eliding the trailing DSB applies here.
>  		 */
> -		addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
> -		__flush_tlb_range_nosync(vma->vm_mm, addr, addr + CONT_PTE_SIZE,
> +		__flush_tlb_range_nosync(vma->vm_mm, addr, end,
>  					 PAGE_SIZE, true, 3);

Hmm... The requirement is that we must flush the _page_ if clearing access for a
pte that does not have the contiguous bit set, or we must flush the _contpte
block_ if clearing access for a pte that does have the contiguous bit set.

With your changes, you may call for a large range that covers multiple contpte
blocks but only has a single pte in a single contpte block for which the access
bit was previously set. But that will cause flushing the TLB for the full range.
Could this cause a performance issue? Yes, no, maybe... I think it's unlikely
but I wouldn't rule it out in some edge case.

I wonder if it's better to track the sub-ranges where access was cleared and
only issue tlbi for those sub-ranges? Probably just keep it simple (the way you
have done it) until/unless we see an actual problem?

Thanks,
Ryan

>  	}
>  
>  	return young;
>  }
> -EXPORT_SYMBOL_GPL(contpte_ptep_clear_flush_young);
> +EXPORT_SYMBOL_GPL(contpte_clear_flush_young_ptes);
>  
>  void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>  					pte_t *ptep, unsigned int nr)


