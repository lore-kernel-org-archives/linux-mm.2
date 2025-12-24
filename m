Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87661E75458
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EBE76B0005; Wed, 24 Dec 2025 08:24:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199946B0088; Wed, 24 Dec 2025 08:24:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07B886B008A; Wed, 24 Dec 2025 08:24:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED08E6B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:24:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A0B6B7141
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:24:47 +0000 (UTC)
X-FDA: 84254434614.07.3516F2E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 23F10140013
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:24:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766582685; a=rsa-sha256;
	cv=none;
	b=XtoQ49fTZmFUdHw9fRjabo6g6PaFbJX3i84sYNEtjQm608EueQJ4fSoNpFa6hgdMEIi+yD
	Ide69gNVKgQBSluw4SEpWgN8vFZ1E1lOwP0baDI3lS+Dh599up2uhto1nAqQWr0SBOaIf/
	ZiIoWA8GM1adyvgcQGgLdyhX4PCNFCk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766582685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1zYKtm0NA2ZP4ktq0x+0ajoxRw0Z/JYH22EVb2Qabus=;
	b=E+d3GyPDOujP4fkYsCOIOgWBSnXFEfvFy7SOBCEjW9OWi3OdEfLTxzgpvF/qk2ZnrbL++q
	HJo+JxZ234st6NXSJm6yk+QXmzJdy6OgTlaXcvG3DWPlFOSnkKihzR1lgL76i1a5hB2hME
	XdKeSPOxfaPjcKcZDo3CGB2Oy4LCUts=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94491339;
	Wed, 24 Dec 2025 05:24:36 -0800 (PST)
Received: from [10.57.93.190] (unknown [10.57.93.190])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02CC03F694;
	Wed, 24 Dec 2025 05:24:40 -0800 (PST)
Message-ID: <ec49f0fe-9df8-4762-b315-240cbb1ed3ce@arm.com>
Date: Wed, 24 Dec 2025 13:24:39 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/5] mm: rmap: support batched checks of the references
 for large folios
Content-Language: en-GB
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
 <e9ff5fa689740f3b6f3ed1c1ec0e3244f20c1f06.1766455378.git.baolin.wang@linux.alibaba.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <e9ff5fa689740f3b6f3ed1c1ec0e3244f20c1f06.1766455378.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 23F10140013
X-Stat-Signature: fgnhc3x3euq46b5my88cefmgqixx9wgc
X-HE-Tag: 1766582684-303923
X-HE-Meta: U2FsdGVkX18gIxY7rJAa4Qi63oTRY1msrzL1l2HpFp+Ou/XcEE81qBMQCyp71mzegwaa1PCE2E/1RGhPny+Fz51Qto3MDnHd1yHcRdzhGaV/EMuOGl49Rao8xtBXJE4z+8z+iBzAcjspWw4/KHOb4KEO2SaBdAGICcWzH9GUgY0wF3PcbOeHNTzFM/nekw5kBYYT64/gOH99BJsQfVguBiuzhGTxUQ67R/EURXiCsdIUHewmvtDf5ZCH6bqECIhKszxVHesePHk4SoFbFuIO6cojshTiY+FX/ayo9NDIxkVjBw3zJeh6riFJ/E9Y2N4z6HG1riPOGuHgQHXALpfiNcAazY1K3mAwsRYBSqIvTy0mDSlds4X8tyufAJmVcXEnDO9MIOh2sPli1f6mAdQh7lU0tTsAPd0S822wFcTSQQgEBWJfAU4KtbDcM8pXqpyaCagNBeQMH7vhykSj9l5cxFtixo2nRO0paERAovtP8dOGmHgo3ml2r6Enz7bgoQp3RoiGiqG6qNUdt1VAfs2MnARDnD8SC8t874KC1YVCOsCwOhElH/r+jyowPQrZBvkNQaRRlVj18z+el+D3G3UD3dtoE+ZX7fiEWOHuD9MCX6kCQ/9fTv6CS9A63WL2VVyRjWOMPke+jr+fbaWb+tb+ySDuyNneLLNCB53qN98+ZS81G0SwAsvqeHLrxumpBellYBzo96668o/5iT5wxwc+Ie5kxtyrVNwmNM0xqUjCVJUS1/Fp3i9MaTnsYr2UE3Cca+1oAZ2MJe442iMomiklO3Q6+IiUHrE8iAIAFop6gPmg7f4dSv4BPiSnjqCfqXSoND0OPELn63ZSKQypYLKJGPpVt3aUiHDuBMNwxvFeUpGQi0mm/M7Npr5wEa4AWBIr959IzE+RtvrY2iIFFwe0cIC3ks6BBW2MO2+PozIIJhK/amUpvr9IzA9XLCLqGYoJndK4xN5i3R+M2VvtAhF
 7W/UTZ9v
 suT2dVI+MkOeKb6M4NUrG3zNyDekpDaa4GPUx5qvHfty1K8Jx3owaF+1enBb9EsUhmQSKy9b8LIDP9fDzreYl3HH/MUfvJphX5diYo4CBCCtpdnECx39Y2EOY9/YAfeUgCD2M1or+gRnqGybhrTfhofw6k5EqNSfuX6bKF8LsB3hwCXxd9zfpV8mTUARgj/QMy0T/pj4AbUsmxAiPh3CJ+/ccSJDqXuYewc78K5+1UgJ+UpKUngOgdcGwtvSRnLdaqD9z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/12/2025 05:48, Baolin Wang wrote:
> Currently, folio_referenced_one() always checks the young flag for each PTE
> sequentially, which is inefficient for large folios. This inefficiency is
> especially noticeable when reclaiming clean file-backed large folios, where
> folio_referenced() is observed as a significant performance hotspot.
> 
> Moreover, on Arm64 architecture, which supports contiguous PTEs, there is already
> an optimization to clear the young flags for PTEs within a contiguous range.
> However, this is not sufficient. We can extend this to perform batched operations
> for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).
> 
> Introduce a new API: clear_flush_young_ptes() to facilitate batched checking
> of the young flags and flushing TLB entries, thereby improving performance
> during large folio reclamation. And it will be overridden by the architecture
> that implements a more efficient batch operation in the following patches.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

With the 2 niggles below addressed:

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  include/linux/mmu_notifier.h |  9 +++++----
>  include/linux/pgtable.h      | 35 +++++++++++++++++++++++++++++++++++
>  mm/rmap.c                    | 29 +++++++++++++++++++++++++++--
>  3 files changed, 67 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index d1094c2d5fb6..dbbdcef4abf1 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
>  	range->owner = owner;
>  }
>  
> -#define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
> +#define ptep_clear_flush_young_notify(__vma, __address, __ptep, __nr)	\

I think I previously suggested that this should be renamed to
clear_flush_young_ptes_notify() given that it is now a batch operation. Were
others against that or did you forget?

>  ({									\
>  	int __young;							\
>  	struct vm_area_struct *___vma = __vma;				\
>  	unsigned long ___address = __address;				\
> -	__young = ptep_clear_flush_young(___vma, ___address, __ptep);	\
> +	unsigned int ___nr = __nr;					\
> +	__young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);	\
>  	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
>  						  ___address,		\
>  						  ___address +		\
> -							PAGE_SIZE);	\
> +						  ___nr * PAGE_SIZE);	\
>  	__young;							\
>  })
>  
> @@ -650,7 +651,7 @@ static inline void mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
>  
>  #define mmu_notifier_range_update_to_read_only(r) false
>  
> -#define ptep_clear_flush_young_notify ptep_clear_flush_young
> +#define ptep_clear_flush_young_notify clear_flush_young_ptes
>  #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
>  #define ptep_clear_young_notify ptep_test_and_clear_young
>  #define pmdp_clear_young_notify pmdp_test_and_clear_young
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 2f0dd3a4ace1..fcf7a7820061 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1087,6 +1087,41 @@ static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>  }
>  #endif
>  
> +#ifndef clear_flush_young_ptes
> +/**
> + * clear_flush_young_ptes - Clear the access bit and perform a TLB flush for PTEs
> + *			    that map consecutive pages of the same folio.
> + * @vma: The virtual memory area the pages are mapped into.
> + * @addr: Address the first page is mapped at.
> + * @ptep: Page table pointer for the first entry.
> + * @nr: Number of entries to clear access bit.
> + *
> + * May be overridden by the architecture; otherwise, implemented as a simple
> + * loop over ptep_clear_flush_young().
> + *
> + * Note that PTE bits in the PTE range besides the PFN can differ. For example,
> + * some PTEs might be write-protected.
> + *
> + * Context: The caller holds the page table lock.  The PTEs map consecutive
> + * pages that belong to the same folio.  The PTEs are all in the same PMD.
> + */
> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
> +					 unsigned long addr, pte_t *ptep,
> +					 unsigned int nr)
> +{
> +	int young;
> +
> +	young = ptep_clear_flush_young(vma, addr, ptep);
> +	while (--nr) {
> +		ptep++;
> +		addr += PAGE_SIZE;
> +		young |= ptep_clear_flush_young(vma, addr, ptep);
> +	}

I think it's better to avoid the two ptep_clear_flush_young() calls if we can.
Personally I think we should just go for the simple:

	for (i = 0; i < nr; ++i, ++ptep, addr += PAGE_SIZE)
		young |= ptep_clear_flush_young(vma, addr, ptep);

> +
> +	return young;
> +}
> +#endif
> +
>  /*
>   * On some architectures hardware does not set page access bit when accessing
>   * memory page, it is responsibility of software setting this bit. It brings
> diff --git a/mm/rmap.c b/mm/rmap.c
> index d6799afe1114..a0fc05f5966f 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -827,9 +827,11 @@ static bool folio_referenced_one(struct folio *folio,
>  	struct folio_referenced_arg *pra = arg;
>  	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>  	int ptes = 0, referenced = 0;
> +	unsigned int nr;
>  
>  	while (page_vma_mapped_walk(&pvmw)) {
>  		address = pvmw.address;
> +		nr = 1;
>  
>  		if (vma->vm_flags & VM_LOCKED) {
>  			ptes++;
> @@ -874,9 +876,24 @@ static bool folio_referenced_one(struct folio *folio,
>  			if (lru_gen_look_around(&pvmw))
>  				referenced++;
>  		} else if (pvmw.pte) {
> +			if (folio_test_large(folio)) {
> +				unsigned long end_addr =
> +					pmd_addr_end(address, vma->vm_end);
> +				unsigned int max_nr =
> +					(end_addr - address) >> PAGE_SHIFT;
> +				pte_t pteval = ptep_get(pvmw.pte);
> +
> +				nr = folio_pte_batch(folio, pvmw.pte,
> +						     pteval, max_nr);
> +			}
> +
> +			ptes += nr;
>  			if (ptep_clear_flush_young_notify(vma, address,
> -						pvmw.pte))
> +						pvmw.pte, nr))
>  				referenced++;
> +			/* Skip the batched PTEs */
> +			pvmw.pte += nr - 1;
> +			pvmw.address += (nr - 1) * PAGE_SIZE;
>  		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>  			if (pmdp_clear_flush_young_notify(vma, address,
>  						pvmw.pmd))
> @@ -886,7 +903,15 @@ static bool folio_referenced_one(struct folio *folio,
>  			WARN_ON_ONCE(1);
>  		}
>  
> -		pra->mapcount--;
> +		pra->mapcount -= nr;
> +		/*
> +		 * If we are sure that we batched the entire folio,
> +		 * we can just optimize and stop right here.
> +		 */
> +		if (ptes == pvmw.nr_pages) {
> +			page_vma_mapped_walk_done(&pvmw);
> +			break;
> +		}
>  	}
>  
>  	if (referenced)


