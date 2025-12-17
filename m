Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6CCDD65C7B
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 16:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 585466B008A; Wed, 17 Dec 2025 11:39:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566CA6B008C; Wed, 17 Dec 2025 11:39:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0C66B0092; Wed, 17 Dec 2025 11:39:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 362CA6B008A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:39:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E86C6140BA2
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:39:16 +0000 (UTC)
X-FDA: 84229523112.25.CD0D144
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1661140009
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:39:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765989555; a=rsa-sha256;
	cv=none;
	b=4eSTfb5gWec9xpjRDAlFT0PKgyraFEyiDUO7oXZoH7nbmXXk+ubRKpJuBvZvfTllRNIjcL
	/WrlX+D4rESUHO53YY1TBX2GzMHOHqv87SRzyRBODyVOmbaEt5fbxTEJ6r0Fm574/PPAfJ
	9ZidmenmMtAmxcjSlek/hqqw0SAmLJs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765989555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLhiL3rYbCCFa3QZaUhJJq+N9OeVWuWlDRvrpMhOcyM=;
	b=jCuYX+FYkZtoveAm3zeoZ3DHjfNnLqQvxSBsiWq8yWaQF40nf0nVNus5fUDnmnu/4N/0Jl
	eTpCNg8wznmIQNAUpw9CO8HvLLn3wJTbecCapsMLTcnNmew0hWEAeQk2mnT0qt0LlHMj88
	Zb72fH1PZo2LNkGj5MrilRlCgLC7Bws=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3542EFEC;
	Wed, 17 Dec 2025 08:39:07 -0800 (PST)
Received: from [10.57.91.77] (unknown [10.57.91.77])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1360F3F5CA;
	Wed, 17 Dec 2025 08:39:10 -0800 (PST)
Message-ID: <cb4d7243-d8c6-4706-a254-6f5afc148910@arm.com>
Date: Wed, 17 Dec 2025 16:39:09 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: rmap: support batched checks of the references
 for large folios
Content-Language: en-GB
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <545dba5e899634bc6c8ca782417d16fef3bd049f.1765439381.git.baolin.wang@linux.alibaba.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <545dba5e899634bc6c8ca782417d16fef3bd049f.1765439381.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1661140009
X-Stat-Signature: c4d3etfuu1yibjhoimcyk5uz5gq9pec3
X-Rspam-User: 
X-HE-Tag: 1765989554-481361
X-HE-Meta: U2FsdGVkX1+ejvMGn6b9OiH/ktYLq+4mY8uSwhwJeGzjoT0QlqTU5nhdiZmbY0eJVkc5Qym23JiDqY4BfvRBinBhwikJ0q8Jc7JvHtt2Tf5rC0zdmGyh6X2GTaa7NZTols5Onzguy9OsUWxm7+vgL7ABY3JbshWrJfRRCx7l47qmFb10venAgoaNTrKbHMJ5TOfMYbz0KlD/md76hRcsG4Y1ajEYlObX2zLspdyE/fEKZWoRN/Vf4LUz9vSD4GtmMdlysxOsgWxqx+yhCsqFLMphKpn8yIpj86vzG1RIGv2MYCL4DCu8Fg0/5y1FRtjxPNIzJy7D/z+I77pGXbxOZSgPH0LrvNJbWZ1ToGzjanHT0/BYWhttdMJCa8FWU8b7vJQg8YQsjJ4naB6al6+h/hjQ+XFaAH4JuQp3EFqyPrR+Thv3K2HjI83qNYy6VDZUsziL2/gzsmsiPX6IDnMaMhJE3Aj2zZwk89anAjbpcTFXMa4OCDMkfKfKIWz3JfG13aRxcWplbl/IGiwCEmrOYzqVybtICm80KAm6n6vPJwyWjBRY1psZLZabWpZbISOwVONHeRKDfSdDkXg91HT2g695k6lG3SZl80w5Pu6ij+Tf/oTZkUfsF/gb/blkmxT4LkmzdMiz5s3iYWC3d4/HfwalMMGqXddds+QMFWQjxTMEPw6lrUFACrar50vNHOO86nXZXCxH6A35jYp6aOv/W4M+e/5tZBVpc/ASiuVzX1SbjrRO35Maoq/rGaoOk1bvY9o+uKMbLz5vvIb62Q199BL21DtJp1ub+SlS1cvAIvov1R4dS5a6miyAaelWaz0BRrEqtHm+BD7HwQ63YYDQAzAjekkFF7X58mbdHA3Zi7u8sDwl+7ma8WXCdyGL4vQSM2Eqx5zfyxC3vW4qzeeYSHnhdiBZgJ49eguz1HtOBEfrfYVaLJKq7UvRFjFI9xIk+zzdDm1HY4VjbBkYARj
 BMj2lC54
 sQJ7kubYaiPquWBR6Ww5Q5gUXD9tam4BdM+beq4z53EFlLziS2sRZPkSJxYawWhyhPG6AtQAgcbURv+EglFt25zuDfmSvP6bl+hzB4RhN7cpwh/tzZc3ANYr7uRCRdTDgmG8NN64bgNpIsZ9Xe4ou1VLuH5O76Wkw6e2q3nuQWZ2kzDFYTzCz1w5+PiLi1tVE3iUXB/3WwfwdYtA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/12/2025 08:16, Baolin Wang wrote:
> Currently, folio_referenced_one() always checks the young flag for each PTE
> sequentially, which is inefficient for large folios. This inefficiency is
> especially noticeable when reclaiming clean file-backed large folios, where
> folio_referenced() is observed as a significant performance hotspot.
> 
> Moreover, on Arm architecture, which supports contiguous PTEs, there is already
> an optimization to clear the young flags for PTEs within a contiguous range.
> However, this is not sufficient. We can extend this to perform batched operations
> for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).
> 
> Introduce a new API: clear_flush_young_ptes() to facilitate batched checking
> of the young flags and flushing TLB entries, thereby improving performance
> during large folio reclamation.
> 
> Performance testing:
> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
> 33% performance improvement on my Arm64 32-core server (and 10%+ improvement
> on my X86 machine). Meanwhile, the hotspot folio_check_references() dropped
> from approximately 35% to around 5%.
> 
> W/o patchset:
> real	0m1.518s
> user	0m0.000s
> sys	0m1.518s
> 
> W/ patchset:
> real	0m1.018s
> user	0m0.000s
> sys	0m1.018s
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 11 +++++++++++
>  include/linux/mmu_notifier.h     |  9 +++++----
>  include/linux/pgtable.h          | 19 +++++++++++++++++++
>  mm/rmap.c                        | 22 ++++++++++++++++++++--
>  4 files changed, 55 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index e03034683156..a865bd8c46a3 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1869,6 +1869,17 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>  	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
>  }
>  
> +#define clear_flush_young_ptes clear_flush_young_ptes
> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
> +					unsigned long addr, pte_t *ptep,
> +					unsigned int nr)
> +{
> +	if (likely(nr == 1))
> +		return __ptep_clear_flush_young(vma, addr, ptep);

Bug: This is broken if core-mm tries to call this for nr=1 on a pte that is part
of a contpte mapping.

The similar fastpaths are here to prevent regressing the common small folio case.

I guess here the best approach is (note no leading underscores):

	if (likely(nr == 1))
		return ptep_clear_flush_young(vma, addr, ptep);

> +
> +	return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
> +}
> +
>  #define wrprotect_ptes wrprotect_ptes
>  static __always_inline void wrprotect_ptes(struct mm_struct *mm,
>  				unsigned long addr, pte_t *ptep, unsigned int nr)
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index d1094c2d5fb6..be594b274729 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
>  	range->owner = owner;
>  }
>  
> -#define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
> +#define ptep_clear_flush_young_notify(__vma, __address, __ptep, __nr)	\

Shouldn't we rename this macro to clear_flush_young_ptes_notify()?

And potentially:

#define ptep_clear_flush_young_notify(__vma, __address, __ptep) \
	clear_flush_young_ptes_notify(__vma, __address, __ptep, 1)

if there are other non-batched users remaining.

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
> +						nr * PAGE_SIZE);	\
>  	__young;							\
>  })
>  > @@ -650,7 +651,7 @@ static inline void
mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
>  
>  #define mmu_notifier_range_update_to_read_only(r) false
>  
> -#define ptep_clear_flush_young_notify ptep_clear_flush_young
> +#define ptep_clear_flush_young_notify clear_flush_young_ptes
>  #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
>  #define ptep_clear_young_notify ptep_test_and_clear_young
>  #define pmdp_clear_young_notify pmdp_test_and_clear_young
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index b13b6f42be3c..c7d0fd228cb7 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -947,6 +947,25 @@ static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>  }
>  #endif
>  
> +#ifndef clear_flush_young_ptes

Let's have some function documentation here please.

> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
> +					 unsigned long addr, pte_t *ptep,
> +					 unsigned int nr)
> +{
> +	int young = 0;
> +
> +	for (;;) {

I know Lorenzo is pretty allergic to this style of looping :)

He's right of course, we should probably just do this the ideomatic way and not
worry about it looking a bit different to the others.

> +		young |= ptep_clear_flush_young(vma, addr, ptep);
> +		if (--nr == 0)
> +			break;
> +		ptep++;
> +		addr += PAGE_SIZE;
> +	}
> +
> +	return young;
> +}
> +#endif
> +
>  /*
>   * On some architectures hardware does not set page access bit when accessing
>   * memory page, it is responsibility of software setting this bit. It brings
> diff --git a/mm/rmap.c b/mm/rmap.c
> index d6799afe1114..ec232165c47d 100644
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
> @@ -874,9 +876,21 @@ static bool folio_referenced_one(struct folio *folio,
>  			if (lru_gen_look_around(&pvmw))
>  				referenced++;
>  		} else if (pvmw.pte) {
> +			if (folio_test_large(folio)) {
> +				unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
> +				unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
> +				pte_t pteval = ptep_get(pvmw.pte);
> +
> +				nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
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

The -1 part is because the walker will increment by 1 I'm guessing?

>  		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>  			if (pmdp_clear_flush_young_notify(vma, address,
>  						pvmw.pmd))
> @@ -886,7 +900,11 @@ static bool folio_referenced_one(struct folio *folio,
>  			WARN_ON_ONCE(1);
>  		}
>  
> -		pra->mapcount--;
> +		pra->mapcount -= nr;
> +		if (ptes == pvmw.nr_pages) {
> +			page_vma_mapped_walk_done(&pvmw);
> +			break;

What's this needed for? I'm suspicious because there wasn't an equivalent here
before.

Thanks,
Ryan

> +		}
>  	}
>  
>  	if (referenced)


