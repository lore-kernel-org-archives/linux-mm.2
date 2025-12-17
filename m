Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86C0CD64062
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 06:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77E76B0005; Wed, 17 Dec 2025 01:49:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB1A6B0089; Wed, 17 Dec 2025 01:49:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFE126B008A; Wed, 17 Dec 2025 01:49:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC6DB6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 01:49:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5484E13BBA1
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:49:30 +0000 (UTC)
X-FDA: 84228036900.10.C4533B8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9EB2AC0003
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:49:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765954168; a=rsa-sha256;
	cv=none;
	b=vfEJgIqphThkRmzqfkKrEXtX4N/Q5a23igRpXDaw68A3C7P/ti/wzM9+xH20HRUFF4FIGJ
	mlajHTOb5/Y6Krj7JhUj60UAQpivYAjBMpnfVduRFDN9OsfWzAELkhriwx2jVjZbZqErTM
	cqt/cuUYPZJ+F/jEXBgMPG31qzZBwjs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765954168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xeIWHjmEuQl+Vej6A1X7eAx1UNbQZGR+W5HLSQlo+TU=;
	b=TtEjtvFrtT36J+fOCZficQ6LS976SvwDQjQJX6DiYPqW68Eyv2XEd/L+GUb0NN/n7AgAjm
	KPoE/cdcx+/1F50SoZynxmIniHgbO3/6/63rqMyYc87MsC0RzHAfhZHE5jKWX8ewIDBAAH
	TmKypEWLc2zSS3vy+18IkimTQAK+6Fc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86561FEC;
	Tue, 16 Dec 2025 22:49:20 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 894563F762;
	Tue, 16 Dec 2025 22:49:22 -0800 (PST)
Message-ID: <52ed7e12-b32e-4a73-ba55-eed993b930b9@arm.com>
Date: Wed, 17 Dec 2025 12:19:19 +0530
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9EB2AC0003
X-Stat-Signature: 3jjcgj5qnxaezdtsgx6z5o9eugsgh3n7
X-Rspam-User: 
X-HE-Tag: 1765954168-885647
X-HE-Meta: U2FsdGVkX1+dSxD7xUaB5OyP/727FyI/6CBMDY9f56PfJcVRIYPcF+K2ZH1KtSiLMEiAuVIXRsGYBVbUNTdJf6pNkRq5kuU1kHg547euwMCzPhznCc12xlTH39Bueo5WBbkjntXWq2Tf9YKd0X2p5MNy0uQQ5gIf8nGvz9/jBGi4tslLzeRaM7Msqcdf1kcJ5m0ZbwVm0X7ngmEZQPPQVLTujmm8qEEu2GOBXeok78GjIagjGut6zf8W7Xyfe7aOQtI6E3gL485a8eYb/sJZLrO+oKmvN7/zml6xlTwCm3U+HcvYo5m7ObjhR9/RYRCpN4s4+ed8nxPawQXpsplweCeQVJG23zyBmbFXZzpMgpgyt9a+xyGc7uQ2bUMw8kxbNihlaXWCFuI96yPlzWTGGwwq5qXRBMQncOo+qbULL6CtDcFOTCOHLSZKSANnkf9cZrAWuleUVfKrAfrq0eUWjopMUMtU4Fd8v8vYmxj0CTFj39qLAHXYJeA3r3gP3d+OeFXvHXKiSzPyGt3DhuSAU3pBq0GH8TwLAaVrRXip6WXIr09PV5MpdErCKVdhZKVn3TlYh2K9hyJCAB1/WBRa3aW7NMJ3bk32zH48VtZIIDrLZm5zJmHRg5MOOSp9M/QNNYWq+YOkbVYdNCsYcOA1Ec9wpdXIitPjxEwLDe7D4X+Qu+x/u/ONMwcwt0Tad0TLYjbtWOSQVAxZsK2hCLMcP2bK2A/NMtnHwc4YoHR+asctZYjujEZB5isYo7ZNeu260OBnsMcRkLZljKoYsUG3iJcHJiOIPNJ3R63cBwQzlzwyeoHQJ8jEiY8RUpovmZuZI9k8vEZtlAAa//0IYoL3jzHoSjKAxid72KG5VSpOskGhznzZNAeMpgC6WMIttYo4
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

I may be hallucinating here but I am just trying to recall things - is this a bug in
folio_pte_batch_flags()? A folio may not be naturally aligned in virtual space and hence
we may cross the PTE table while batching across it, which can be fixed by taking into
account pmd_addr_end() while computing max_nr.

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

