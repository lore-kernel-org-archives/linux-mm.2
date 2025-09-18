Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD22FCAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12CC7280033; Thu, 18 Sep 2025 09:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DD9F8E0093; Thu, 18 Sep 2025 09:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01AA2280033; Thu, 18 Sep 2025 09:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E68CA8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:11:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE0041A01B4
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:11:18 +0000 (UTC)
X-FDA: 83902407036.16.3FAF136
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id EB697A000D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:11:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758201077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DyvhVj8MyvPGIpi2WKd0Wnd6mVC3QRyMqTf61T/MPoc=;
	b=IF0lEeQ8sYqc5zwsdT0t6NpTuhXW3/AYho/IqPaSUcwEr9GEzTF9Jg4vhkOVNfYGKhbZPm
	3fuizPmH0IkBxTIQBS45Fol4jTJsXFEWBTjSeRGiY7qD3FO7ZcHFLuPhJ0j2gJBUpVbsTK
	ULL6oQm+SD6uR31BbtfF6lhGHwFd7VE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758201077; a=rsa-sha256;
	cv=none;
	b=FR7BI5iIKsldkBihtI8ij07igweqYbc3gBrWn5cKpuRTJN+Hqhn7vrvgxlaT9pnaDZjYg+
	xmLX0CcN5BBNG4irVRALjhceXhX8nGyxl2M0JFbXzpNpRf37S58VuA48IA2svhPg3uw8mG
	jgKYg8+fUTMqLBuQBvnYBDawVI8CFRY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA4531A25;
	Thu, 18 Sep 2025 06:11:07 -0700 (PDT)
Received: from [10.1.33.171] (XHFQ2J9959.cambridge.arm.com [10.1.33.171])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6ACD93F66E;
	Thu, 18 Sep 2025 06:11:12 -0700 (PDT)
Message-ID: <4bb35dc4-4c28-4e0e-a06f-70782264cc5c@arm.com>
Date: Thu, 18 Sep 2025 14:11:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
Content-Language: en-GB
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
 <46dcddec-88a9-4b22-920c-8a3edeb2f027@arm.com>
 <87o6r833li.fsf@DESKTOP-5N7EMDA>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <87o6r833li.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EB697A000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: t35183yzzrt6jn45z7sjc4og6h4scb1w
X-HE-Tag: 1758201076-348255
X-HE-Meta: U2FsdGVkX1/U/koenNFAOhmEuE891kymVHUr9jjdWN2+TAWRZmKncxvaSfgAXIarT16MCaEG9TUL+isVPZncg/IuOduSuJbg4AAdfijK5dY4jzzIewZ2Yzi1T7zpZK8AIAlUl/2KwETGKmpccpwfcefxp66Hzvc8aXXKPOVcioqVy4KsRpeoHJv0UPKQJBHc+zrB+P3VMVHEOr3OJ9uHCxkmVaXDDV087L4RrMTiFtJA7pLMz5WcxCqCnd+0UfyMASIIoLggrrd0hL3QWXv6T6mB8Lc0cyzoYF/GdI1lJHLWy08sEBvXvSXDciZJBKw4rpurEzUbGGCG4cxzA5I8dCpLcOINJD/Eg7sipdh6OZHtNzd8WipV6acFxqw/9T7pTBDl0HWE6zeHNp/nztN9OSSVZhZ5NsJuoX6V0wnuzjSj9X4W6mO/lgnpd0CqvrPvZm5jJboqsMStYLaN2BGKQ9Al/Lf8os4gNGjGjE+WTILvzpmSC/NIPeLTUKgSyz6BkC4bo64XYj/4BDZFhWJWW7ny3Mh4TSodcSw7U7W+CbhcGeUNq8akNhrjBHLQ6XYkKlYCQJBo65GCsxWT1jKKE8Zjo1EjXF6JJAKr4W/gFlYdeSagb+iv5riZpDloLiRGPfg4nsj7yNt43mWXarZMMESIpjiFKyzOQPjWiBQL29IfOsTAV8OlzjMACTQamKgcQTOJe1D2SLgThFTypNP7RySapviRt937n6GsWF+0fhEC42zfVXeke9A9hJMDqyr7CKXIxyhX7ynKGLRkTmfkF3hDzmm5VA0QmZYpIz1mIr9r3D679g4LKLvLgCTRtxkJ5P3bTgRd6CQU41gz0SofargkMdujwhqEUA85dwFt3b1Sob18iM0ZtVXiT1q3CQ/heyVLWz5TpT+J4mGGNe+SgkfqaiU8b3zDLHzhwZX1d2yosvhaGWKE5+76TFjRqCE5sWHgd6WEihxhU+cFNDr
 soNXCrqR
 jEKIQ037+FxN8I05vDGm0sINS/SnVRurE51YyF7KSYNd/S8xyGX22W3Ed0+ZOlJaRFeRQpYkYHFrd1t5KzqTs28zBRacN9lYmYnfss0DvXuKE+nmENvtafpcMZUvNxd3M7TZRScqY22q2rTtTGGDh3EwNMMm97hvTP8CmBr8WRepO9clnRz6ple9eg7hy1/IYdaCjFeT6BYhZLfbUJMuQGcwRLl65bRkszOjfaQLrTSAZU3xNG26GNrgfpKnDzD0BzTu/wYIWWqyfjiRGX5vuJEBRHt5WULeVt1G4pmtS/yC0WZiH74TwFztSl4pE/ly7t73NDkP/ygrJ6mq5T+zUWRHC3w2KT9JDFGx9gYRiyPAyOOMkjoKNs/k4rxeqwCOpYpsGM+GKNJ/pbZlNrnDSXYZDllDgrARUKBK/LQaJrrjOnoXsY9v55SMNlT+hWLMFdyrKl/GUrVVxGq4z9IuUB3cxSVymhdaK5mpg7OafFTJt9nbV7BUOtvlhJS8Kzgwgbb9vydb1i195pU1ziVKdlEN0RStFXrOAKvWE/Ut3IXDJaPZkYGC5EE9jve1SOMZa3/ttlXfjVUUTl0DnKSQiSUJygxuySigjunTp7peWkL/gUjjQS7mAcQcwdVB9kgnn2PKaPbMoO7n5D7HQRb8smct11AP4z+ZS4f6sYXh/FZzoRIXLk+UdpVqwf2edf/SOpLvi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/09/2025 03:18, Huang, Ying wrote:
> Hi, Ryan,
> 
> Thanks for reivew!
> 
> Ryan Roberts <ryan.roberts@arm.com> writes:
> 
>> On 15/09/2025 04:29, Huang Ying wrote:
>>> A multi-thread customer workload with large memory footprint uses
>>> fork()/exec() to run some external programs every tens seconds.  When
>>> running the workload on an arm64 server machine, it's observed that
>>> quite some CPU cycles are spent in the TLB flushing functions.  While
>>> running the workload on the x86_64 server machine, it's not.  This
>>> causes the performance on arm64 to be much worse than that on x86_64.
>>>
>>> During the workload running, after fork()/exec() write-protects all
>>> pages in the parent process, memory writing in the parent process
>>> will cause a write protection fault.  Then the page fault handler
>>> will make the PTE/PDE writable if the page can be reused, which is
>>> almost always true in the workload.  On arm64, to avoid the write
>>> protection fault on other CPUs, the page fault handler flushes the TLB
>>> globally with TLBI broadcast after changing the PTE/PDE.  However, this
>>> isn't always necessary.  Firstly, it's safe to leave some stall
>>> read-only TLB entries as long as they will be flushed finally.
>>> Secondly, it's quite possible that the original read-only PTE/PDEs
>>> aren't cached in remote TLB at all if the memory footprint is large.
>>> In fact, on x86_64, the page fault handler doesn't flush the remote
>>> TLB in this situation, which benefits the performance a lot.
>>>
>>> To improve the performance on arm64, make the write protection fault
>>> handler flush the TLB locally instead of globally via TLBI broadcast
>>> after making the PTE/PDE writable.  If there are stall read-only TLB
>>> entries in the remote CPUs, the page fault handler on these CPUs will
>>> regard the page fault as spurious and flush the stall TLB entries.
>>>
>>> To test the patchset, make the usemem.c from
>>> vm-scalability (https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git).
>>> support calling fork()/exec() periodically.  To mimic the behavior of
>>> the customer workload, run usemem with 4 threads, access 100GB memory,
>>> and call fork()/exec() every 40 seconds.  Test results show that with
>>> the patchset the score of usemem improves ~40.6%.  The cycles% of TLB
>>> flush functions reduces from ~50.5% to ~0.3% in perf profile.
>>
>> Overall, this looks like a simple and useful performance optimization - thanks!
>> I'm running this through our performance regression suite to see if it spots any
>> workloads where the change slows things down and will report once we have the
>> results.
> 
> Thanks!
> 
>>> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Will Deacon <will@kernel.org>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Yang Shi <yang@os.amperecomputing.com>
>>> Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
>>> Cc: Dev Jain <dev.jain@arm.com>
>>> Cc: Barry Song <baohua@kernel.org>
>>> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
>>> Cc: Yicong Yang <yangyicong@hisilicon.com>
>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
>>> Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Cc: linux-mm@kvack.org
>>> ---
>>>  arch/arm64/include/asm/pgtable.h  | 14 ++++++++-----
>>>  arch/arm64/include/asm/tlbflush.h | 33 +++++++++++++++++++++++++++++++
>>>  arch/arm64/mm/fault.c             |  2 +-
>>>  3 files changed, 43 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>> index abd2dee416b3..a9ed8c9d2c33 100644
>>> --- a/arch/arm64/include/asm/pgtable.h
>>> +++ b/arch/arm64/include/asm/pgtable.h
>>> @@ -130,12 +130,16 @@ static inline void arch_leave_lazy_mmu_mode(void)
>>>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>>  
>>>  /*
>>> - * Outside of a few very special situations (e.g. hibernation), we always
>>> - * use broadcast TLB invalidation instructions, therefore a spurious page
>>> - * fault on one CPU which has been handled concurrently by another CPU
>>> - * does not need to perform additional invalidation.
>>> + * We use local TLB invalidation instruction when reusing page in
>>> + * write protection fault handler to avoid TLBI broadcast in the hot
>>> + * path.  This will cause spurious page faults if stall read-only TLB
>>> + * entries exist.
>>>   */
>>> -#define flush_tlb_fix_spurious_fault(vma, address, ptep) do { } while (0)
>>> +#define flush_tlb_fix_spurious_fault(vma, address, ptep)	\
>>> +	local_flush_tlb_page_nonotify(vma, address)
>>> +
>>> +#define flush_tlb_fix_spurious_fault_pmd(vma, address, pmdp)	\
>>> +	local_flush_tlb_page_nonotify(vma, address)
>>
>> It's not really clear to me how important doing local tlb flushes for pmds is
>> for the performance improvement? I'm guessing most of the win comes from the pte
>> level? I suspect you have only added spurious pmd fault handling because the
>> arm64 implementation of __ptep_set_access_flags() actually handles both pte and
>> pmd levels?
>>
>> Given the core kernel didn't previously have support for pmd spurious faults, I
>> wonder if it would be simpler to drop the first patch and rejig
>> __ptep_set_access_flags() so that it has a pgsize parameter and can
>> differentiate based on that? I'm on the fence...
>>
>> If you do end up taking this approach, there is a style I introduced for
>> hugetlb, where the function is suffixed with _anysz and it takes a pgsize param:
>>
>> int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
>> 				  unsigned long address, pte_t *ptep,
>> 				  pte_t entry, int dirty, unsigned long pgsize);
> 
> From the performance point of view, local TLB flushes don't improve
> performance much.  At least in a test similar to the one above, we don't
> find observable improvement.
> 
> From the design point of view, I personally prefer to use similar logic
> between PMD and PTE unless it hurts performance.  IMHO, less different
> logic means less mental overhead.  Do you agree?

Yeah fair enough, that's a reasonable argument.

> 
>>>  
>>>  /*
>>>   * ZERO_PAGE is a global shared page that is always zero: used
>>> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
>>> index 18a5dc0c9a54..607b67d8f61b 100644
>>> --- a/arch/arm64/include/asm/tlbflush.h
>>> +++ b/arch/arm64/include/asm/tlbflush.h
>>> @@ -282,6 +282,39 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
>>>  	mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
>>>  }
>>>  
>>> +static inline void __local_flush_tlb_page_nonotify_nosync(
>>> +	struct mm_struct *mm, unsigned long uaddr)
>>> +{
>>> +	unsigned long addr;
>>> +
>>> +	dsb(nshst);
>>> +	addr = __TLBI_VADDR(uaddr, ASID(mm));
>>> +	__tlbi(vale1, addr);
>>> +	__tlbi_user(vale1, addr);
>>> +}
>>> +
>>> +static inline void local_flush_tlb_page_nonotify(
>>> +	struct vm_area_struct *vma, unsigned long uaddr)
>>> +{
>>> +	__local_flush_tlb_page_nonotify_nosync(vma->vm_mm, uaddr);
>>> +	dsb(nsh);
>>> +}
>>> +
>>> +static inline void __local_flush_tlb_page_nosync(
>>> +	struct mm_struct *mm, unsigned long uaddr)
>>> +{
>>> +	__local_flush_tlb_page_nonotify_nosync(mm, uaddr);
>>> +	mmu_notifier_arch_invalidate_secondary_tlbs(mm, uaddr & PAGE_MASK,
>>> +						(uaddr & PAGE_MASK) + PAGE_SIZE);
>>> +}
>>> +
>>> +static inline void local_flush_tlb_page(struct vm_area_struct *vma,
>>> +					unsigned long uaddr)
>>> +{
>>> +	__local_flush_tlb_page_nosync(vma->vm_mm, uaddr);
>>> +	dsb(nsh);
>>> +}
>>> +
>>
>> You're introducing more variants than you're actually using here. I think you
>> just need local_flush_tlb_page() and local_flush_tlb_page_nonotify(); you could
>> keep __local_flush_tlb_page_nonotify_nosync() and drop
>> __local_flush_tlb_page_nosync() since it's not really adding much?
> 
> Sure.
> 
>> But I'm also wondering if we should tidy up this API in general; we have local
>> vs broadcast, sync vs nosync, notify vs nonotify. And page is really just a
>> special case of a range. So perhaps it is better to rework the range API to take
>> some flags and we can tidy up all of this. I know Will also posted an RFC to
>> convert a lot of this to c functions, which should also be included. Not a
>> blocker for this change, I don't think, but there should definitely be some
>> follow up work to tidy it up. (I'm happy to take it on).
> 
> This sounds goo to me.  Thanks for working on this!

OK I'll put it on my todo list to have a go at this as follow up.

> 
>>>  static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
>>>  					   unsigned long uaddr)
>>>  {
>>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>>> index d816ff44faff..22f54f5afe3f 100644
>>> --- a/arch/arm64/mm/fault.c
>>> +++ b/arch/arm64/mm/fault.c
>>> @@ -235,7 +235,7 @@ int __ptep_set_access_flags(struct vm_area_struct *vma,
>>>  
>>>  	/* Invalidate a stale read-only entry */
>>>  	if (dirty)
>>> -		flush_tlb_page(vma, address);
>>> +		local_flush_tlb_page(vma, address);
>>
>> Given this is called for both pmds and ptes, it's a bit of an abuse to flush a
>> *page*. Yes it is architecturally safe, but it's not exactly self-documenting.
>> If we pass in the pgsize (as per above) it could be optimized given we know the
>> level and we only want to invalidate the last level. e.g. the local equivalent to:
>>
>> __flush_tlb_range(vma, address, address + PMD_SIZE, PMD_SIZE, true, 2);
>>
>> or
>>
>> __flush_tlb_range(vma, address, address + PAGE_SIZE, PAGE_SIZE, true, 3);
>>
>> Again though, perhaps that is part of some follow up tidying work?
> 
> This sounds good to me too.  And, Yes, I think this can be a follow up
> tidying work.

I'll include this in my follow up.

> 
>> contpte_ptep_set_access_flags() currently does a (broadcast) __flush_tlb_range()
>> on the (pte_write(orig_pte) == pte_write(entry)) path. I think that should be
>> changed to a local range invalidation to be consistent with this change.
> 
> Yes.  This should be changed too.  However, it means we need a local
> variant of __flush_tlb_range() and flush_tlb_mm().  Is it OK to
> introduce them first and tidy up later?

I think do it as Catalin suggested for now. I'll then refactor as part of the
tidy up.

Thanks,
Ryan

> 
>>>  	return 1;
>>>  }
>>>  
> 
> ---
> Best Regards,
> Huang, Ying


