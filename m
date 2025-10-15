Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E92BCCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624AC8E0046; Wed, 15 Oct 2025 11:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FC238E0005; Wed, 15 Oct 2025 11:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 511F08E0046; Wed, 15 Oct 2025 11:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1348E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:28:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B26B61401D8
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:28:39 +0000 (UTC)
X-FDA: 84000730758.17.CDC74AB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id A6D7CA0006
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:28:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760542118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qqwvJoG2PskL4jkkGn6JRjHpEZXwohVU4wS0CrtVuk8=;
	b=Z9lf4VZ0fcBeI9VfsjVAmfiw14wLYPh7LQWdjA/QbgomGGHyX7xPqRn8Ge5+SF02tN8+Xm
	4sENWSwW1VHlZQaYmgIZGRo6Ky/frsCQdbPpFGA1KHvDZ0rUsdnyKFscTZItOLBXFena+4
	TjpUlkuq+xj7EqSkSgj5MuV461MEvk8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760542118; a=rsa-sha256;
	cv=none;
	b=t3N1yppyEvMgHzC1mzUUtEv6ng65bvpDeDHqdesE7Bf8D6JssnAv6ir/c2n+SZW8y+ZnKh
	6P7wZIfPaviCfd3h92nzwAnL2A2VBeP8YYnU2UuFvHldSqjSAfvB/T0K+AV02Kuui535PA
	LvNCUcqEuCUsxyEQsT9koVBwp7DhV3g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0BB01655;
	Wed, 15 Oct 2025 08:28:28 -0700 (PDT)
Received: from [10.1.38.178] (XHFQ2J9959.cambridge.arm.com [10.1.38.178])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1F7653F738;
	Wed, 15 Oct 2025 08:28:32 -0700 (PDT)
Message-ID: <9afcdd88-f8f9-4d2f-94d7-7c41b0a25ddf@arm.com>
Date: Wed, 15 Oct 2025 16:28:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -v2 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
Content-Language: en-GB
To: Huang Ying <ying.huang@linux.alibaba.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Yang Shi <yang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Anshuman Khandual
 <anshuman.khandual@arm.com>, Yicong Yang <yangyicong@hisilicon.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Yin Fengwei <fengwei_yin@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
 <20251013092038.6963-3-ying.huang@linux.alibaba.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251013092038.6963-3-ying.huang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: gkzae7da9da6gdci46o4mskf64yrjncr
X-Rspam-User: 
X-Rspamd-Queue-Id: A6D7CA0006
X-HE-Tag: 1760542117-342822
X-HE-Meta: U2FsdGVkX1+M1tGH4PTJ6DG0/+FboB+Tj/wVZY2iFpiFakuZ6shCRIlKp2x0RwPUbQ6j4729a9fgifc+rWEoMaqgdhWhy0hSbJZvsyl2Ti38GI/xftM8uY6pOUKzZ39P/FB6kXb38Hfr5g55H3gNXp1dzQGhD58OvromUmL+5vKkWS5jBhApPaI9jSK1CeoyTdvqn1eNww0BmMvC3AlFfUDAm2DGxnPcbzjvJqPX408b2CCft4EYOiW3nb7sDBsD7jCwzzoCQurIpFtFcd4bqvY2UmPenA7Bu4EQqlTVvCWCLWoS2W5NPU0aAxVX5H2P9ZPZg7Xg1E9JTHyLrc4UfghkzZbyOiImL7pYUsOLx8yaZboD0ICKFHDZ9i+dZ4YX+nAFAxY7za86o+tyJMztRRwGCEBE/buiMhrl5ulo/g89vqX1/sROCj9iZoya3vTAmjOcpALOpRhL/LIsTCW3YcXFVvDf18fR6uZ8Lgzm7haX3mWTEJpkujrXtrASOEqfKAC8PbgZBJ4Pi25qFuzMwYw8G4RkB9RD88jMLtxEsPbcwrb1CDqARjICJW3t6Hd0ys07Iff0ZfcDbT2OBAOuxkGMnpe4b2EZ5KwWHeBm5ea7r4wkCZSQ1YqB/SsDx63JHuwBhyntOrPJG6c99OGjgdW4fr6lLaJwlcmH6uHHBaAAeqvDRBJfTtqzzcXBuEHIKXugHEw0bfYr9PaM7eb1KQSH0UtAYQwno8JRXTwxyEnieRA0Ab5luYiPSMn1X1qLfm/mr8NGbGf20fb1jrPlW5LsJr0h91+zqVnynTZJFKteovle4X5C4gErOX+AP3fPpbsKGSOeliVHq9hNJtLllZ6A8APVLote
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13/10/2025 10:20, Huang Ying wrote:
> A multi-thread customer workload with large memory footprint uses
> fork()/exec() to run some external programs every tens seconds.  When
> running the workload on an arm64 server machine, it's observed that
> quite some CPU cycles are spent in the TLB flushing functions.  While
> running the workload on the x86_64 server machine, it's not.  This
> causes the performance on arm64 to be much worse than that on x86_64.
> 
> During the workload running, after fork()/exec() write-protects all
> pages in the parent process, memory writing in the parent process
> will cause a write protection fault.  Then the page fault handler
> will make the PTE/PDE writable if the page can be reused, which is
> almost always true in the workload.  On arm64, to avoid the write
> protection fault on other CPUs, the page fault handler flushes the TLB
> globally with TLBI broadcast after changing the PTE/PDE.  However, this
> isn't always necessary.  Firstly, it's safe to leave some stall

nit: You keep using the word "stall" here and in the code. I think you mean "stale"?

> read-only TLB entries as long as they will be flushed finally.
> Secondly, it's quite possible that the original read-only PTE/PDEs
> aren't cached in remote TLB at all if the memory footprint is large.
> In fact, on x86_64, the page fault handler doesn't flush the remote
> TLB in this situation, which benefits the performance a lot.
> 
> To improve the performance on arm64, make the write protection fault
> handler flush the TLB locally instead of globally via TLBI broadcast
> after making the PTE/PDE writable.  If there are stall read-only TLB
> entries in the remote CPUs, the page fault handler on these CPUs will
> regard the page fault as spurious and flush the stall TLB entries.
> 
> To test the patchset, make the usemem.c from vm-scalability
> (https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git).
> support calling fork()/exec() periodically (merged).  To mimic the
> behavior of the customer workload, run usemem with 4 threads, access
> 100GB memory, and call fork()/exec() every 40 seconds.  Test results
> show that with the patchset the score of usemem improves ~40.6%.  The
> cycles% of TLB flush functions reduces from ~50.5% to ~0.3% in perf
> profile.
> 
> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Yang Shi <yang@os.amperecomputing.com>
> Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Yicong Yang <yangyicong@hisilicon.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
> Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>  arch/arm64/include/asm/pgtable.h  | 14 +++++---
>  arch/arm64/include/asm/tlbflush.h | 56 +++++++++++++++++++++++++++++++
>  arch/arm64/mm/contpte.c           |  3 +-
>  arch/arm64/mm/fault.c             |  2 +-
>  4 files changed, 67 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index aa89c2e67ebc..35bae2e4bcfe 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -130,12 +130,16 @@ static inline void arch_leave_lazy_mmu_mode(void)
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  
>  /*
> - * Outside of a few very special situations (e.g. hibernation), we always
> - * use broadcast TLB invalidation instructions, therefore a spurious page
> - * fault on one CPU which has been handled concurrently by another CPU
> - * does not need to perform additional invalidation.
> + * We use local TLB invalidation instruction when reusing page in
> + * write protection fault handler to avoid TLBI broadcast in the hot
> + * path.  This will cause spurious page faults if stall read-only TLB
> + * entries exist.
>   */
> -#define flush_tlb_fix_spurious_fault(vma, address, ptep) do { } while (0)
> +#define flush_tlb_fix_spurious_fault(vma, address, ptep)	\
> +	local_flush_tlb_page_nonotify(vma, address)
> +
> +#define flush_tlb_fix_spurious_fault_pmd(vma, address, pmdp)	\
> +	local_flush_tlb_page_nonotify(vma, address)
>  
>  /*
>   * ZERO_PAGE is a global shared page that is always zero: used
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index 18a5dc0c9a54..651b31fd18bb 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -249,6 +249,18 @@ static inline unsigned long get_trans_granule(void)
>   *		cannot be easily determined, the value TLBI_TTL_UNKNOWN will
>   *		perform a non-hinted invalidation.
>   *
> + *	local_flush_tlb_page(vma, addr)
> + *		Local variant of flush_tlb_page().  Stale TLB entries may
> + *		remain in remote CPUs.
> + *
> + *	local_flush_tlb_page_nonotify(vma, addr)
> + *		Same as local_flush_tlb_page() except MMU notifier will not be
> + *		called.
> + *
> + *	local_flush_tlb_contpte_range(vma, start, end)
> + *		Invalidate the virtual-address range '[start, end)' mapped with
> + *		contpte on local CPU for the user address space corresponding
> + *		to 'vma->mm'.  Stale TLB entries may remain in remote CPUs.
>   *
>   *	Finally, take a look at asm/tlb.h to see how tlb_flush() is implemented
>   *	on top of these routines, since that is our interface to the mmu_gather
> @@ -282,6 +294,33 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
>  	mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
>  }
>  
> +static inline void __local_flush_tlb_page_nonotify_nosync(
> +	struct mm_struct *mm, unsigned long uaddr)
> +{
> +	unsigned long addr;
> +
> +	dsb(nshst);
> +	addr = __TLBI_VADDR(uaddr, ASID(mm));
> +	__tlbi(vale1, addr);
> +	__tlbi_user(vale1, addr);
> +}
> +
> +static inline void local_flush_tlb_page_nonotify(
> +	struct vm_area_struct *vma, unsigned long uaddr)
> +{
> +	__local_flush_tlb_page_nonotify_nosync(vma->vm_mm, uaddr);
> +	dsb(nsh);
> +}
> +
> +static inline void local_flush_tlb_page(struct vm_area_struct *vma,
> +					unsigned long uaddr)
> +{
> +	__local_flush_tlb_page_nonotify_nosync(vma->vm_mm, uaddr);
> +	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, uaddr & PAGE_MASK,
> +						(uaddr & PAGE_MASK) + PAGE_SIZE);
> +	dsb(nsh);
> +}
> +
>  static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
>  					   unsigned long uaddr)
>  {
> @@ -472,6 +511,23 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
>  	dsb(ish);
>  }
>  
> +static inline void local_flush_tlb_contpte_range(struct vm_area_struct *vma,
> +						 unsigned long start, unsigned long end)

This would be clearer as an API if it was like this:

static inline void local_flush_tlb_contpte(struct vm_area_struct *vma,
					unsigned long uaddr)

i.e. the user doesn't set the range - it's implicitly CONT_PTE_SIZE starting at
round_down(uaddr, PAGE_SIZE).

Thanks,
Ryan

> +{
> +	unsigned long asid, pages;
> +
> +	start = round_down(start, PAGE_SIZE);
> +	end = round_up(end, PAGE_SIZE);
> +	pages = (end - start) >> PAGE_SHIFT;
> +
> +	dsb(nshst);
> +	asid = ASID(vma->vm_mm);
> +	__flush_tlb_range_op(vale1, start, pages, PAGE_SIZE, asid,
> +			     3, true, lpa2_is_enabled());
> +	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, start, end);
> +	dsb(nsh);
> +}
> +
>  static inline void flush_tlb_range(struct vm_area_struct *vma,
>  				   unsigned long start, unsigned long end)
>  {
> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> index c0557945939c..0f9bbb7224dc 100644
> --- a/arch/arm64/mm/contpte.c
> +++ b/arch/arm64/mm/contpte.c
> @@ -622,8 +622,7 @@ int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
>  			__ptep_set_access_flags(vma, addr, ptep, entry, 0);
>  
>  		if (dirty)
> -			__flush_tlb_range(vma, start_addr, addr,
> -							PAGE_SIZE, true, 3);
> +			local_flush_tlb_contpte_range(vma, start_addr, addr);
>  	} else {
>  		__contpte_try_unfold(vma->vm_mm, addr, ptep, orig_pte);
>  		__ptep_set_access_flags(vma, addr, ptep, entry, dirty);
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index d816ff44faff..22f54f5afe3f 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -235,7 +235,7 @@ int __ptep_set_access_flags(struct vm_area_struct *vma,
>  
>  	/* Invalidate a stale read-only entry */
>  	if (dirty)
> -		flush_tlb_page(vma, address);
> +		local_flush_tlb_page(vma, address);
>  	return 1;
>  }
>  


