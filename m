Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10D07CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 08:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB918E0013; Tue, 16 Sep 2025 04:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C2C8E0001; Tue, 16 Sep 2025 04:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3138E0013; Tue, 16 Sep 2025 04:24:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D3CD08E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 04:24:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6517C11B072
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:24:53 +0000 (UTC)
X-FDA: 83894427666.22.48DDCFC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2950A1C0009
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:24:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758011091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PWZBDigLOa2cx6/5Tu47dZ4P+Y0RlDmXPQo5pmrJZ4k=;
	b=U3z6D3jIbyIaYmHAFKS9E1OsgyxL6Qe27249PtWsKHROAz1fTBdElpVbXQATCBa6TX9Ccq
	njWmax518XvzDoyw5VDXZZSly+5W0V7utfBP/iweGVXl0Hs6oUM8AjMKI0CeoAHGwWYjDE
	OSApRKWp6C+NtYFFUhcJS3lu+aMJFqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758011091; a=rsa-sha256;
	cv=none;
	b=J84Y26PJlRxEe0NfcTxBHl/m8vFw0rboNiirgKe0pudO5Nwd1PaGS3K9CgoocnKYJ2XvDr
	MVuHfKXSTLaPo7xp/jDvw7nH0wvKIYZDO/bbfZp/ddLAgEiAJ5Bb+SBEaD2XaMjQu8KR4h
	hVDNHeJ5lPRBJkJfaFge4RkKz58zNb0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD4F912FC;
	Tue, 16 Sep 2025 01:24:41 -0700 (PDT)
Received: from [10.57.94.248] (unknown [10.57.94.248])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB8983F673;
	Tue, 16 Sep 2025 01:24:46 -0700 (PDT)
Message-ID: <46dcddec-88a9-4b22-920c-8a3edeb2f027@arm.com>
Date: Tue, 16 Sep 2025 09:24:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] arm64, tlbflush: don't TLBI broadcast if page
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
References: <20250915032946.33203-1-ying.huang@linux.alibaba.com>
 <20250915032946.33203-3-ying.huang@linux.alibaba.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20250915032946.33203-3-ying.huang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: abzu5nsatzm339nd1477o71ueytc45eu
X-Rspamd-Queue-Id: 2950A1C0009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758011090-327760
X-HE-Meta: U2FsdGVkX1+ZdkVM29gFbn3PcPE7zNPABgZwxNGyPNrY/RqvhLbjZOd+WH0+UzQMVdKbgacw7rtIADpk53o/eoEs+Glwo1tHS6FnB5zUZcKbQVznDcrs+JkAW9oW1QDhW261P90cXPEAuPd8ecg5BJGbHT4/p1xOCD345bnnYBxHi5NDZXHqT845gZiNv2l5nbLq2uTf0jWzKHkluYUOOhEs1vVP9hORrBW9e9y8IXoRzTB7oGZUQeCaYp+dEiDTAfro/K9RcJ9DwrQFT4PU1CqhLqi42MeTgQKPSAgq3VZwZxgRR8bUWZ/IiA6RpqHtJZmFFp72d0nNzwN3zYY2EZZaBZ1uy3lqGRDiENVizmJ+9CF69LYj6A/ELqsPrCRHyk3kRSpJmAsZ64mX72Sd0j3eSB+UbXlJuq92CMkupCc8oTvZYk6dzX2aNkyV3bX628EfhmkMbLrkR+o7/yK1F7cE3ebrAg82FapaPBHEH0x2fMNS6ZyzljIp/UBqMNgmR7vLAr2zsjQT7uINURww1/5oIlSyynTbDT+XKrM1CMDQfGDsXke8zZoOlB5httR/+9p3q1TbZKHWlkBjMWi3ThgbTjD8HQLew8E25vIWmZJVIMjzyXK/BIi/diNT+3a/yKwvui7rC+5SUh67p2BF3SDxPrkf9r771ME39xM93+RN25beCMQZG49aUzpVQ/EQR+npAlcFXcRyideS+XTLDYZE1TAAmpAwMBXndtRwhALGWIdWhVHxXL7YPZj78jL6AElCDhgEuw4n0RRg3F7g91uZmRotjX87/fiNJc/CqTL79QO8al9dhs11MBUanaM5icivOxlm81c/6X5Mvr0RcqUT4veHxCyk0NM6649Ife8ZRFlIrxNFxiVIvZcPDpqYtmKZzUxEbOljrK4bpIJnvMsvosrCdZRc83ng2UyBm3hQIa5ZsF0WeMbw0jBjxMmEipD1QB6cbkCvmYN3Yrf
 q/YumNWU
 7TpmiWWzasEh/RmeVJz5WnYzsBuU2vdZcWro/fh5XyvALWpo3ceXrUH/v7raVtZpUPnUNLQBJrcinvjmJp2+S0BNFAjRHs/SDnU8w07nHEG17R7jUJoCs6PyHGZBWOy90TZtx5B6Gd/9UVmTw3A/5MJPfrhu0CzdCBvsQ/DZkfiY9w+QfPoATuIetUX76aSECoE06EnNQF5HYipBXbcCXy/sFKzgDPAOv06UnUTI6Lk5RDkPzT+17iYCoMQX6jmoKEkp7FnspAaKxbGfhhMDQd9ihmzZl2mvgWniqqkQONivKbpljkVFvFOvdEtCiyGH/XjNaYZUUSblKHRjak/tZWocx9rq6Z6YxHBpZbIyzT54x2IAczYprBirRxh2WB3D7ic7a9Be8qy02GA0BB4yNnjDjtK9ylia6K25bu8eoSYu8QfjlP6OESRKfpkVtfirmAyDDyTL+1wTxflK95ry2TfCD5Gj6lNfqWuOZowwTlVUBcjBUqYgllaXYxlw0+hG7boRvGcMjFJHPkeCthQjPJFulCKeog+NIZQeZUpeOQ9+wfHLDiuxyWKMnWu6QZjFaYDl8dhcGf+DEBiayM2PIWgV18nYGEGxX7DWxPIuSHULyKkr44/vpB7tumWYaRxLcikgNXEK0PR+23ClDxcjUztyq5uulpdoIaeJfbKXlDVNliqSrwxYKpfr894q482JT7elO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/09/2025 04:29, Huang Ying wrote:
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
> To test the patchset, make the usemem.c from
> vm-scalability (https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git).
> support calling fork()/exec() periodically.  To mimic the behavior of
> the customer workload, run usemem with 4 threads, access 100GB memory,
> and call fork()/exec() every 40 seconds.  Test results show that with
> the patchset the score of usemem improves ~40.6%.  The cycles% of TLB
> flush functions reduces from ~50.5% to ~0.3% in perf profile.

Overall, this looks like a simple and useful performance optimization - thanks!
I'm running this through our performance regression suite to see if it spots any
workloads where the change slows things down and will report once we have the
results.

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
>  arch/arm64/include/asm/pgtable.h  | 14 ++++++++-----
>  arch/arm64/include/asm/tlbflush.h | 33 +++++++++++++++++++++++++++++++
>  arch/arm64/mm/fault.c             |  2 +-
>  3 files changed, 43 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index abd2dee416b3..a9ed8c9d2c33 100644
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

It's not really clear to me how important doing local tlb flushes for pmds is
for the performance improvement? I'm guessing most of the win comes from the pte
level? I suspect you have only added spurious pmd fault handling because the
arm64 implementation of __ptep_set_access_flags() actually handles both pte and
pmd levels?

Given the core kernel didn't previously have support for pmd spurious faults, I
wonder if it would be simpler to drop the first patch and rejig
__ptep_set_access_flags() so that it has a pgsize parameter and can
differentiate based on that? I'm on the fence...

If you do end up taking this approach, there is a style I introduced for
hugetlb, where the function is suffixed with _anysz and it takes a pgsize param:

int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
				  unsigned long address, pte_t *ptep,
				  pte_t entry, int dirty, unsigned long pgsize);

>  
>  /*
>   * ZERO_PAGE is a global shared page that is always zero: used
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index 18a5dc0c9a54..607b67d8f61b 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -282,6 +282,39 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
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
> +static inline void __local_flush_tlb_page_nosync(
> +	struct mm_struct *mm, unsigned long uaddr)
> +{
> +	__local_flush_tlb_page_nonotify_nosync(mm, uaddr);
> +	mmu_notifier_arch_invalidate_secondary_tlbs(mm, uaddr & PAGE_MASK,
> +						(uaddr & PAGE_MASK) + PAGE_SIZE);
> +}
> +
> +static inline void local_flush_tlb_page(struct vm_area_struct *vma,
> +					unsigned long uaddr)
> +{
> +	__local_flush_tlb_page_nosync(vma->vm_mm, uaddr);
> +	dsb(nsh);
> +}
> +

You're introducing more variants than you're actually using here. I think you
just need local_flush_tlb_page() and local_flush_tlb_page_nonotify(); you could
keep __local_flush_tlb_page_nonotify_nosync() and drop
__local_flush_tlb_page_nosync() since it's not really adding much?

But I'm also wondering if we should tidy up this API in general; we have local
vs broadcast, sync vs nosync, notify vs nonotify. And page is really just a
special case of a range. So perhaps it is better to rework the range API to take
some flags and we can tidy up all of this. I know Will also posted an RFC to
convert a lot of this to c functions, which should also be included. Not a
blocker for this change, I don't think, but there should definitely be some
follow up work to tidy it up. (I'm happy to take it on).

>  static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
>  					   unsigned long uaddr)
>  {
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

Given this is called for both pmds and ptes, it's a bit of an abuse to flush a
*page*. Yes it is architecturally safe, but it's not exactly self-documenting.
If we pass in the pgsize (as per above) it could be optimized given we know the
level and we only want to invalidate the last level. e.g. the local equivalent to:

__flush_tlb_range(vma, address, address + PMD_SIZE, PMD_SIZE, true, 2);

or

__flush_tlb_range(vma, address, address + PAGE_SIZE, PAGE_SIZE, true, 3);

Again though, perhaps that is part of some follow up tidying work?


contpte_ptep_set_access_flags() currently does a (broadcast) __flush_tlb_range()
on the (pte_write(orig_pte) == pte_write(entry)) path. I think that should be
changed to a local range invalidation to be consistent with this change.

Thanks,
Ryan

>  	return 1;
>  }
>  


