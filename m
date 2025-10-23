Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB9B6CCD1BF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 10:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE6B98E0002; Thu, 23 Oct 2025 06:54:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D968F8E0008; Thu, 23 Oct 2025 06:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3FF8E0002; Thu, 23 Oct 2025 06:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7F868E0003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:54:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E961140AA0
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:54:45 +0000 (UTC)
X-FDA: 84029070930.14.21E4FB6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9103F140005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:54:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761216883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8iWglKbjLiBlAchDZDLWS4BlIu2BiQFtL8QdLRBPGf4=;
	b=29MnfWE/NPGgN7cVt05wJ9SEmnNLhxsqC4xDxPbje20W9H8zLuqeCIh5UCFOBYiywy2vb2
	6XHFiFmA2GlzJadVoSVzIwqOoZBykpEmF6zzRXeU5nvEJnWDFsUYefclJCJJRnDII47hy5
	yc1BTB6jRUjf/ULeQY17GDDHIqiRV5k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761216883; a=rsa-sha256;
	cv=none;
	b=L8fWvnqXwmuzEf6c11T/FNB021Vo9AyaRV6ZzeRa4a74RNWlzcwUHitE0D+1G4diJ2ZdIB
	igjk3eGy3atlDjqaLsrCVpMelu10F5F3cVa+RE6LW9JFMver8U9uqUsLKn+U54Exy3stdQ
	LPScWv5LO1Uojh/BXPTn2bUPTELWIA0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA4891516;
	Thu, 23 Oct 2025 03:54:34 -0700 (PDT)
Received: from [10.1.31.176] (XHFQ2J9959.cambridge.arm.com [10.1.31.176])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C02393F63F;
	Thu, 23 Oct 2025 03:54:39 -0700 (PDT)
Message-ID: <fb633059-9b5b-49ea-848a-7537bb13559d@arm.com>
Date: Thu, 23 Oct 2025 11:54:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -v3 2/2] arm64, tlbflush: don't TLBI broadcast if page
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
 <anshuman.khandual@arm.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Yin Fengwei <fengwei_yin@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251023013524.100517-1-ying.huang@linux.alibaba.com>
 <20251023013524.100517-3-ying.huang@linux.alibaba.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251023013524.100517-3-ying.huang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: tyiueeer57jhdktusmhmnpau8i6mrut7
X-Rspam-User: 
X-Rspamd-Queue-Id: 9103F140005
X-HE-Tag: 1761216883-498030
X-HE-Meta: U2FsdGVkX19EhkC137BkhFyqYoEQd6XkNPfBpEQjHQdSsLMVjAYc1w2n+DEQF0g0LhxOIx28STAIzbGJ7yeEaKmF8scdDI0fbKqCiXNmmn+sE2PC55TqSuN69kLlTp4eUzHhp/X0pfkNliUcjl6j6w8G5Axn4xB8n4dFYbt93anxZeDIeMrlqu1iiAqFto6WxLWcJrchNEmTrb8XWiknL5WlN1jd3TANLoElaRMAjBK6lKLjw4IO2s7elDAyOzoQK5OC0KUPmIGqSYMx2eyZlwKElBAXYmlDIK6hd6v8rI9KujqOCDqGOphYa+01JwiWJevJKtqq22d0izYlprfT7xnO95fIY0RoOCvp+Oa398IK5fWu0bzPGT3hNASkSYBJfn/Sq4/7UwFSnW8Coow1kZwcSP1DMLWqa+9lTC9lsUAA+/gYBesRTn2WI2XImOKxjgqTsP384bHvQ2bIKojZnZ9qB5TH5P43wnKfKfClz+Ves8R4okrCtq1pUZjt4a7xsuHanmC+9x14PUQnMEMjHrq09SsPytyk95x+fylWFnAKu8lrzrWAYGEKzRGVymQCnAn8RGPVK0pvGLKQZJsSswaRJiKs5WbXXeM5gjZUa06dIBOVofp1YbieT4UPjvniCx0L6aT8OsOxCxLjBBOshYPUEU8npVUbvarHiqaZM1ZoqTYAX8mQmik4ACSwbRC8Viz8VEzRLqSBZK8fqtFH6qR5d6i59ziWgzth1StYDKZyoPsFfr+xKBP5EIY3vYhm0ICHESnQoIc77wIn1cRkr8hmZwwr/C7FXbA3uY0lGIUpjQbXJO90iUvLhekUTPBnW1ApHBAZLsoFrXhakKwlzJxIZmPel4y/ItrZ1Etj47yGFsToM7+rIuhD6hQ/G5P5Ccxx9Mzjen/khCZ4creuUBAq+ayoyeFsgp6m9fPbZxicbJblaGR5p/QnPQmNEt9fHoCJvfkd32zWlXq+nk1
 nRaSl9cY
 CkYNPc5mSpXXmUUshJAOlrvgysm5ILH8Od/VmxjNIU92F/kNolcb0yOOyC4Lw5MU9qFAdIoc5Cv2z2GcWK9rVHLlX1Nlz/R09ZMq0i7EVLm7s9uPrSpyazkxU6dauybZAMmehP4jswAhd2sVxgY11rUFYB7btp0fg6sa0U/Rc8u+iZqLlVOjK32EeKt9CVDCAebwJPwYWEPe33LKvoQXnDNE05BLt55uOGNWnTnKial52aq7AE2VlFqxKUrToSMZndIvIYk6bHxRv7DPNFQerUMbPYXkay9U6vICTjRbyYb2sbH3cycccvpM1WC1S/hZ6G1hUt8eVvntDBHvT6jLi9+NCSboLLjvP8fnx7ja89GjMJjT0bb+w8wK0h+GZl9QipdQz5W0lP0NWLf1ne6H/nH0O69/d2E0iCPMKV/zQUNXiK3tnNaAt0WL/8DmQ/38f8urFj58GHj08lZ+Oxx0e3Ch8IRRRJDI8iIYJA0FOE688ls+QLHGLkcLSwNJj/XnZKFAyDLC9xTdQKOiapGHhLlukW5FPS78zS6cRMVU7uC1G0th5s7k/ct4giIrA7kibssx1Si8+nFUQwGJT2KFnehIeOfvKSsuKN4zQ/lrPlvdzLw68fUb1NKb+jGCPO9sQMHje
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/10/2025 02:35, Huang Ying wrote:
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
> isn't always necessary.  Firstly, it's safe to leave some stale
> read-only TLB entries as long as they will be flushed finally.
> Secondly, it's quite possible that the original read-only PTE/PDEs
> aren't cached in remote TLB at all if the memory footprint is large.
> In fact, on x86_64, the page fault handler doesn't flush the remote
> TLB in this situation, which benefits the performance a lot.
> 
> To improve the performance on arm64, make the write protection fault
> handler flush the TLB locally instead of globally via TLBI broadcast
> after making the PTE/PDE writable.  If there are stale read-only TLB
> entries in the remote CPUs, the page fault handler on these CPUs will
> regard the page fault as spurious and flush the stale TLB entries.
> 
> To test the patchset, make the usemem.c from
> vm-scalability (https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git).
> support calling fork()/exec() periodically.  To mimic the behavior of
> the customer workload, run usemem with 4 threads, access 100GB memory,
> and call fork()/exec() every 40 seconds.  Test results show that with
> the patchset the score of usemem improves ~40.6%.  The cycles% of TLB
> flush functions reduces from ~50.5% to ~0.3% in perf profile.

LGTM:

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

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
> index aa89c2e67ebc..25b3c31edb6c 100644
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
> + * path.  This will cause spurious page faults if stale read-only TLB
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
> index 18a5dc0c9a54..5c8f88fa5e40 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -249,6 +249,19 @@ static inline unsigned long get_trans_granule(void)
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
> + *	local_flush_tlb_contpte(vma, addr)
> + *		Invalidate the virtual-address range
> + *		'[addr, addr+CONT_PTE_SIZE)' mapped with contpte on local CPU
> + *		for the user address space corresponding to 'vma->mm'.  Stale
> + *		TLB entries may remain in remote CPUs.
>   *
>   *	Finally, take a look at asm/tlb.h to see how tlb_flush() is implemented
>   *	on top of these routines, since that is our interface to the mmu_gather
> @@ -282,6 +295,33 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
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
> @@ -472,6 +512,22 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
>  	dsb(ish);
>  }
>  
> +static inline void local_flush_tlb_contpte(struct vm_area_struct *vma,
> +					   unsigned long addr)
> +{
> +	unsigned long asid;
> +
> +	addr = round_down(addr, CONT_PTE_SIZE);
> +
> +	dsb(nshst);
> +	asid = ASID(vma->vm_mm);
> +	__flush_tlb_range_op(vale1, addr, CONT_PTES, PAGE_SIZE, asid,
> +			     3, true, lpa2_is_enabled());
> +	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, addr,
> +						    addr + CONT_PTE_SIZE);
> +	dsb(nsh);
> +}
> +
>  static inline void flush_tlb_range(struct vm_area_struct *vma,
>  				   unsigned long start, unsigned long end)
>  {
> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> index c0557945939c..589bcf878938 100644
> --- a/arch/arm64/mm/contpte.c
> +++ b/arch/arm64/mm/contpte.c
> @@ -622,8 +622,7 @@ int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
>  			__ptep_set_access_flags(vma, addr, ptep, entry, 0);
>  
>  		if (dirty)
> -			__flush_tlb_range(vma, start_addr, addr,
> -							PAGE_SIZE, true, 3);
> +			local_flush_tlb_contpte(vma, start_addr);
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


