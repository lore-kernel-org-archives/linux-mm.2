Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E319D64076
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 06:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91A296B0005; Wed, 17 Dec 2025 01:23:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C80F6B0089; Wed, 17 Dec 2025 01:23:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1156B008A; Wed, 17 Dec 2025 01:23:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5D56B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 01:23:37 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C990E13BD14
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:23:36 +0000 (UTC)
X-FDA: 84227971632.06.4B36722
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id A41C280006
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:23:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765952615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QJcGh/KleJuHsA1FtzekUTSI/9XQy5iwRCGyk6mN9x4=;
	b=RuMEpAfZZZI449wxhiJQB8lpY9h8rkIdV/SHmhn+oJFOw1CjuSAZZ8WNtXNmEkXu0I94UK
	96JtGQAAajkm/hi7+VQqrGM68gulxDT7o7wqxI7xc214oXh9kSKySH6TvzOB1sTs1C0xue
	sokzEWwarIyFXZhr7ap9LrXPevZ4Lzg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765952615; a=rsa-sha256;
	cv=none;
	b=06dFbNMqaHmRYzqw4PaFwLouHv4Kz0QXJmRGjb1ZMp0kYHuGUA81kJCwVbFvO9kLCUnrg+
	LjhkA0OToudvtKzAdRs7SreCYdAFU8JPoo14AcVFLSmVrL2WYw3B1bCq8yydsMsNy+YVQs
	deheOhveh+NSfLdOchjHcv9WbghKaLg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3AD60FEC;
	Tue, 16 Dec 2025 22:23:26 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3EC193F762;
	Tue, 16 Dec 2025 22:23:28 -0800 (PST)
Message-ID: <17380b96-3a9e-46f9-b22b-0e770f7f1b4f@arm.com>
Date: Wed, 17 Dec 2025 11:53:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: rmap: support batched checks of the references
 for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <545dba5e899634bc6c8ca782417d16fef3bd049f.1765439381.git.baolin.wang@linux.alibaba.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <545dba5e899634bc6c8ca782417d16fef3bd049f.1765439381.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A41C280006
X-Stat-Signature: 6y1dtm685xzbm5keg8ik6hbbxp9ihu6u
X-Rspam-User: 
X-HE-Tag: 1765952614-524760
X-HE-Meta: U2FsdGVkX1/LXVOApBHhwb0QGGmo2+mBYWsZosrVeeiriUvp18f2+BJvnKgAGFqUUgulHv8P3npaTss80EaU6w0XxN/u6G4OHPxzonH2bTzRSOIwfEHQSH2HxUzmfNMIGdPkXDk8K5306ptBQapdXaUdn0DTjPQ7lYaUpiISMumUuWAyS/fog5dxKpxLJyBILx35qU7OJUKs5DA03O81dNQcnvYEgW9qd22LWcgy3iJ/VEGOQBAs1n1MGaT33zierKQh7z8lgdBXFFuiRDHZtAwPNK0cqCPGX0Wkny4G8MkblYy+IEJxTzeXHKnYf3W/Vb2x1CEpInf2rkqeBMsVDm9O05gbWa4xS+S19Ea7755t+5GJ54j6f2k93fDwrwEjYUIEcsuk3Djafqj+HOj98d3WA6ryXD5WcjHtUnDe5FxQxSPkixV9MXQG7BCD3WF7IoWIiUdRLoAvi3N5GDFJMVYso9pUZMKPaMPUj8JsygG+H9SCihEccpjk3KKEx4a8W5+WQtuY4Oj9qEvAwCfHH/xyFgD7hDosnQ6EvDmprcNVsd1AUVnMIo3BpaYpkhOOAC28rgcstbHR5F7mAj7OyKqwXdaTBFWg3/v94fe7bz/1CR+6HZX8k2YDo1120j+5ff5QrDsJTX/xhcsdpvSWg8pjvlKFfQTDQftZS+YsSlGs72bfJ6tZY3ZKtKIAhoyDJ6ngIiwMFVpUbXTqmJy4xcKwZSXs6pfptstpk7wG2uGVD5A8jPmYe70etzHdOq4AjJX7wKX4Nh98svNWcxij6Qe1f83oH2XAP6voww6XtiszsEqiAHh5zg3qpDGWYAbMRsWTq3nETrpY+hz6yoadPPc97REIWTDAHNWCc42EWdEdQ2qISYfLLqR7ajIhTs+/oZql3iEdcYkx4nOwv2oSyB+T7FakxNGrT3o7c8bGSXLCm3XCvrd9WT2V3mdmv2AOUok6y0p6Cku3h2PbB4N
 9xO1KMpy
 ZpT7Z7gX4tfT7lztf7WfBPyyBMq7lRplp6LppIm6Fe74xCyOVevoqeXuyHihXoKcTnupU539JCc/faOTlBpTOIng8LjheNTRqI/dINpNFz1cOKUyxazv3GtAV6Znbjmp1DU4E5ocGBVLM5dlTIwXZ7IK3He3XzINTCbqjkW6H7MN3zFimNCXPLPMMcO9gBo1YYG/AaaGA+weZRY4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/12/25 1:46 pm, Baolin Wang wrote:
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

Do we have an existing bug here, in that mmu_notifier_clear_flush_young() should
have been called for CONT_PTES length if the folio was contpte mapped?

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
> index b13b6f42be3c..c7d0fd228cb7 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -947,6 +947,25 @@ static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
>  }
>  #endif
>  
> +#ifndef clear_flush_young_ptes
> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
> +					 unsigned long addr, pte_t *ptep,
> +					 unsigned int nr)
> +{
> +	int young = 0;
> +
> +	for (;;) {
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
> +		}
>  	}
>  
>  	if (referenced)

