Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64F0BCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 02:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1B71280004; Wed, 17 Sep 2025 22:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC368E006B; Wed, 17 Sep 2025 22:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BAFD280004; Wed, 17 Sep 2025 22:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7545A8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:18:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ECCB211ACD1
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:18:58 +0000 (UTC)
X-FDA: 83900763156.10.BC23E04
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf01.hostedemail.com (Postfix) with ESMTP id 712E64000D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:18:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rDrVJvy1;
	spf=pass (imf01.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758161937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxbRB5XWir6VmFp5xOaBmn7eG9P2Fj+zCnltu72Ma9U=;
	b=Ut8lFZY3fP0Ilr0rEZJPtAxis42mstIiTnKcY6ZTdozkgeKYUUkBBw1reWUcYzvp3EBcM9
	PqBu/ehRPvNnqJgNgCw7CjRtKjsQ713FDTMuWjoG7vrW3kEJ4oOGsxU/+l4ZqaYmQWYmGS
	sEWjaFwawhy3phE0LJ6x2J2ZnREL8PA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758161937; a=rsa-sha256;
	cv=none;
	b=D6Qaodh43Ph9VTM4KgFGjYppWkOxugdFbsy7fEqlxbcZpJXqJU9Ob1qVeG7mZchdSOD316
	wUzmMzstd4wDFUx2gACKpsFWNABRWBF6W9NURsXpjkQ9eoT1tLT2wdFuzRJp+XHtHfJVU1
	GbfCkQIIjYRtQDGmzVkdQirBcjNDdc4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rDrVJvy1;
	spf=pass (imf01.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758161932; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=gxbRB5XWir6VmFp5xOaBmn7eG9P2Fj+zCnltu72Ma9U=;
	b=rDrVJvy1/CZsUwZOKum15BxmnTYm+W2eNz65U/wKUtS/Aihc8ZloAg/5RpDB2WDyO6VbHKAXAaS2ko/E/yq8rIT+n5mV6mGcZ4UkvMESnYBgcCmxTG6nrHo7svAQ31i9F2us6rkQsRFBe7Fck7Lu2CjNFRJAw/Pd+2l5sGXqBHI=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WoE51RN_1758161930 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Sep 2025 10:18:51 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,  Will Deacon
 <will@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  David
 Hildenbrand <david@redhat.com>,  Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,  Zi Yan
 <ziy@nvidia.com>,  Baolin Wang <baolin.wang@linux.alibaba.com>,  Yang Shi
 <yang@os.amperecomputing.com>,  "Christoph Lameter (Ampere)"
 <cl@gentwo.org>,  Dev Jain <dev.jain@arm.com>,  Barry Song
 <baohua@kernel.org>,  Anshuman Khandual <anshuman.khandual@arm.com>,
  Yicong Yang <yangyicong@hisilicon.com>,  Kefeng Wang
 <wangkefeng.wang@huawei.com>,  Kevin Brodsky <kevin.brodsky@arm.com>,  Yin
 Fengwei <fengwei_yin@linux.alibaba.com>,
  linux-arm-kernel@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
In-Reply-To: <46dcddec-88a9-4b22-920c-8a3edeb2f027@arm.com> (Ryan Roberts's
	message of "Tue, 16 Sep 2025 09:24:45 +0100")
References: <20250915032946.33203-1-ying.huang@linux.alibaba.com>
	<20250915032946.33203-3-ying.huang@linux.alibaba.com>
	<46dcddec-88a9-4b22-920c-8a3edeb2f027@arm.com>
Date: Thu, 18 Sep 2025 10:18:49 +0800
Message-ID: <87o6r833li.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 712E64000D
X-Stat-Signature: ther7dft1gmhir9mmroasiwairc8sjue
X-Rspam-User: 
X-HE-Tag: 1758161936-120753
X-HE-Meta: U2FsdGVkX1+gR7Uy/jURSdllTYsTEZtyn57xT2+hJA2Iw4icjW2HPuThA4mItAtfTs0LstKCqaBcogFPZMbmh3IU0ub5UjpQxFtZH28qVQT08cd/KoWqj5rmomaOitEiY/0qUN+uAje5spNSbGuhERrXGcQBKpPcbhKG2XGUvnYHTELDpyTdKc9pc71k+ZP7y3ErFhyMa34SpEL8AlP04Rkvn68KFmo/HMdqmq8wpWiOWb+SThTfXEoAHQP2fLypPCgGyxfhhuHWPbnbUT5ijzbhnrZj0fVxfbgd8bPDzGXaO0x1SVD7OIjX+igZGm7R6MsXEAahhgV8c3g+FeGq419+ozwG03DMzOGzJA7k79z+eN4Di21qyO4QkDFsSy6EZb8p13Q/Xxsgk90gr+t9kOvOtduM/l5B8YZbboIeGUlYOXSzh8IHU1VAdNqq2ImLsiozyH69Gduxd0tgFB5QQ39I67Lu6SYNA8Q1Qbz3o5UR+s516vs6VsaBIEdcRlGnSmO1ATaMB+QsX5VUpNIYHK3fO/VBpawMb8zGfM8T897rln6iwbSvZz2wI6Xf7dLUJw90gbIZw3wG28H0ctJQham5QV0ol0jhlJz7s9RX7Lgn7RqknO+qP991g6rxpyyD7px58SQ/Quhqi5GsGB+gdt2f0sbe4zPGTly1b0a8+gm7R4av1bRhkt7NNTqKz3B0YaPqZYHAhsHU+Yn8vonLAdOXintPoeWl4ONnAmWpyWKSzAx3UZR7ZjCP2kRuAQ/3tGCcQkaPSE41dpVNMTizQcSglJMeJxfVy1ftYq+I9ULVeOiLasjEV6fky73fJes1KGj7bLCmG3D5+GC2m6cpDeIboWMXSqJng8ABzNx+K9MsKW1Wzk80P4s3hjMH9krEkc0dHMX0zywRxG0r0yAZKJkaRKO2hoZeCYEkazzeKPtGVecSKK5JqLs4THUjHHhXDZTB8+JfjZ43SWKT3fv
 JnOfLloZ
 ke1uCLE00hy0DlBU0jt55iYySn5wetz886XTAykoXAFI61h3e1duoeD5H44HguIa0XbUzHU+TVfgAkJueyWTU+4f+4ACgnCfb8VzD0WfIqrLX59J2/cpW0+s3MnllNd+xRMKEpy84o4sFCRVQjc6mtQ69J9uiGlIhrj26tlSQFdILIgR5gLQuMOnX3Gz6n32t5FPXCUFMohHQOwh/I2vBSvg/quXyasu8XrFKiS+aElJTgONYs9PxwiFKuP5fsawd59Q9QwjZusW1Cnc+NpJf60mh9r8gknGmGLbxtrEwsNWGr98vDc3rdtcKUlr+1CrS/FwdPPmkoQjJo7OuogImLeUDlJ9b64DQPut1mKUKYL+clC6Vzl9qV+8IlLhVBtB6k7H9G57hxY4nNxg5Xi8cMXgZRzALPAGxanuJP0P5tqsy/8RQZfahr+fPgj4UxKk12bX88s325G730wUUNk1OVMwOOCvPWl8TBnvwIDthggDBsqfGhR/zVsRLK0KOMEEzXGmq0Ix3vV8+u2j+Cn6RGcGZmj9IqjsGWBdxUtQcKS1rCOqLg1j1/EnpwlI7yN3ZjSyF7Bk/WFrT8dGjsM/BWGndbFnQHN7+gqVDayvKv74AKoiSlKUQGaAa3IAiT0ms6g53rFe3y7G5f1iIFQxDU3Bqy/HDvxicZAIp1lRVVL99JUYLLqw2Z+Wn0xK/jcsRmczXgPMWl/skDU7xwYIE6St++cExJ0hUCzmNhyhrGs61aIQH1ifLbpNqxLvMLDTVBk8sJr7ZddLWMq9FzLVN+cBVfViC1Ao0UxGS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Ryan,

Thanks for reivew!

Ryan Roberts <ryan.roberts@arm.com> writes:

> On 15/09/2025 04:29, Huang Ying wrote:
>> A multi-thread customer workload with large memory footprint uses
>> fork()/exec() to run some external programs every tens seconds.  When
>> running the workload on an arm64 server machine, it's observed that
>> quite some CPU cycles are spent in the TLB flushing functions.  While
>> running the workload on the x86_64 server machine, it's not.  This
>> causes the performance on arm64 to be much worse than that on x86_64.
>> 
>> During the workload running, after fork()/exec() write-protects all
>> pages in the parent process, memory writing in the parent process
>> will cause a write protection fault.  Then the page fault handler
>> will make the PTE/PDE writable if the page can be reused, which is
>> almost always true in the workload.  On arm64, to avoid the write
>> protection fault on other CPUs, the page fault handler flushes the TLB
>> globally with TLBI broadcast after changing the PTE/PDE.  However, this
>> isn't always necessary.  Firstly, it's safe to leave some stall
>> read-only TLB entries as long as they will be flushed finally.
>> Secondly, it's quite possible that the original read-only PTE/PDEs
>> aren't cached in remote TLB at all if the memory footprint is large.
>> In fact, on x86_64, the page fault handler doesn't flush the remote
>> TLB in this situation, which benefits the performance a lot.
>> 
>> To improve the performance on arm64, make the write protection fault
>> handler flush the TLB locally instead of globally via TLBI broadcast
>> after making the PTE/PDE writable.  If there are stall read-only TLB
>> entries in the remote CPUs, the page fault handler on these CPUs will
>> regard the page fault as spurious and flush the stall TLB entries.
>> 
>> To test the patchset, make the usemem.c from
>> vm-scalability (https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git).
>> support calling fork()/exec() periodically.  To mimic the behavior of
>> the customer workload, run usemem with 4 threads, access 100GB memory,
>> and call fork()/exec() every 40 seconds.  Test results show that with
>> the patchset the score of usemem improves ~40.6%.  The cycles% of TLB
>> flush functions reduces from ~50.5% to ~0.3% in perf profile.
>
> Overall, this looks like a simple and useful performance optimization - thanks!
> I'm running this through our performance regression suite to see if it spots any
> workloads where the change slows things down and will report once we have the
> results.

Thanks!

>> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Yang Shi <yang@os.amperecomputing.com>
>> Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
>> Cc: Yicong Yang <yangyicong@hisilicon.com>
>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
>> Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> ---
>>  arch/arm64/include/asm/pgtable.h  | 14 ++++++++-----
>>  arch/arm64/include/asm/tlbflush.h | 33 +++++++++++++++++++++++++++++++
>>  arch/arm64/mm/fault.c             |  2 +-
>>  3 files changed, 43 insertions(+), 6 deletions(-)
>> 
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index abd2dee416b3..a9ed8c9d2c33 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -130,12 +130,16 @@ static inline void arch_leave_lazy_mmu_mode(void)
>>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>  
>>  /*
>> - * Outside of a few very special situations (e.g. hibernation), we always
>> - * use broadcast TLB invalidation instructions, therefore a spurious page
>> - * fault on one CPU which has been handled concurrently by another CPU
>> - * does not need to perform additional invalidation.
>> + * We use local TLB invalidation instruction when reusing page in
>> + * write protection fault handler to avoid TLBI broadcast in the hot
>> + * path.  This will cause spurious page faults if stall read-only TLB
>> + * entries exist.
>>   */
>> -#define flush_tlb_fix_spurious_fault(vma, address, ptep) do { } while (0)
>> +#define flush_tlb_fix_spurious_fault(vma, address, ptep)	\
>> +	local_flush_tlb_page_nonotify(vma, address)
>> +
>> +#define flush_tlb_fix_spurious_fault_pmd(vma, address, pmdp)	\
>> +	local_flush_tlb_page_nonotify(vma, address)
>
> It's not really clear to me how important doing local tlb flushes for pmds is
> for the performance improvement? I'm guessing most of the win comes from the pte
> level? I suspect you have only added spurious pmd fault handling because the
> arm64 implementation of __ptep_set_access_flags() actually handles both pte and
> pmd levels?
>
> Given the core kernel didn't previously have support for pmd spurious faults, I
> wonder if it would be simpler to drop the first patch and rejig
> __ptep_set_access_flags() so that it has a pgsize parameter and can
> differentiate based on that? I'm on the fence...
>
> If you do end up taking this approach, there is a style I introduced for
> hugetlb, where the function is suffixed with _anysz and it takes a pgsize param:
>
> int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
> 				  unsigned long address, pte_t *ptep,
> 				  pte_t entry, int dirty, unsigned long pgsize);

From the performance point of view, local TLB flushes don't improve
performance much.  At least in a test similar to the one above, we don't
find observable improvement.

From the design point of view, I personally prefer to use similar logic
between PMD and PTE unless it hurts performance.  IMHO, less different
logic means less mental overhead.  Do you agree?

>>  
>>  /*
>>   * ZERO_PAGE is a global shared page that is always zero: used
>> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
>> index 18a5dc0c9a54..607b67d8f61b 100644
>> --- a/arch/arm64/include/asm/tlbflush.h
>> +++ b/arch/arm64/include/asm/tlbflush.h
>> @@ -282,6 +282,39 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
>>  	mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
>>  }
>>  
>> +static inline void __local_flush_tlb_page_nonotify_nosync(
>> +	struct mm_struct *mm, unsigned long uaddr)
>> +{
>> +	unsigned long addr;
>> +
>> +	dsb(nshst);
>> +	addr = __TLBI_VADDR(uaddr, ASID(mm));
>> +	__tlbi(vale1, addr);
>> +	__tlbi_user(vale1, addr);
>> +}
>> +
>> +static inline void local_flush_tlb_page_nonotify(
>> +	struct vm_area_struct *vma, unsigned long uaddr)
>> +{
>> +	__local_flush_tlb_page_nonotify_nosync(vma->vm_mm, uaddr);
>> +	dsb(nsh);
>> +}
>> +
>> +static inline void __local_flush_tlb_page_nosync(
>> +	struct mm_struct *mm, unsigned long uaddr)
>> +{
>> +	__local_flush_tlb_page_nonotify_nosync(mm, uaddr);
>> +	mmu_notifier_arch_invalidate_secondary_tlbs(mm, uaddr & PAGE_MASK,
>> +						(uaddr & PAGE_MASK) + PAGE_SIZE);
>> +}
>> +
>> +static inline void local_flush_tlb_page(struct vm_area_struct *vma,
>> +					unsigned long uaddr)
>> +{
>> +	__local_flush_tlb_page_nosync(vma->vm_mm, uaddr);
>> +	dsb(nsh);
>> +}
>> +
>
> You're introducing more variants than you're actually using here. I think you
> just need local_flush_tlb_page() and local_flush_tlb_page_nonotify(); you could
> keep __local_flush_tlb_page_nonotify_nosync() and drop
> __local_flush_tlb_page_nosync() since it's not really adding much?

Sure.

> But I'm also wondering if we should tidy up this API in general; we have local
> vs broadcast, sync vs nosync, notify vs nonotify. And page is really just a
> special case of a range. So perhaps it is better to rework the range API to take
> some flags and we can tidy up all of this. I know Will also posted an RFC to
> convert a lot of this to c functions, which should also be included. Not a
> blocker for this change, I don't think, but there should definitely be some
> follow up work to tidy it up. (I'm happy to take it on).

This sounds goo to me.  Thanks for working on this!

>>  static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
>>  					   unsigned long uaddr)
>>  {
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index d816ff44faff..22f54f5afe3f 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -235,7 +235,7 @@ int __ptep_set_access_flags(struct vm_area_struct *vma,
>>  
>>  	/* Invalidate a stale read-only entry */
>>  	if (dirty)
>> -		flush_tlb_page(vma, address);
>> +		local_flush_tlb_page(vma, address);
>
> Given this is called for both pmds and ptes, it's a bit of an abuse to flush a
> *page*. Yes it is architecturally safe, but it's not exactly self-documenting.
> If we pass in the pgsize (as per above) it could be optimized given we know the
> level and we only want to invalidate the last level. e.g. the local equivalent to:
>
> __flush_tlb_range(vma, address, address + PMD_SIZE, PMD_SIZE, true, 2);
>
> or
>
> __flush_tlb_range(vma, address, address + PAGE_SIZE, PAGE_SIZE, true, 3);
>
> Again though, perhaps that is part of some follow up tidying work?

This sounds good to me too.  And, Yes, I think this can be a follow up
tidying work.

> contpte_ptep_set_access_flags() currently does a (broadcast) __flush_tlb_range()
> on the (pte_write(orig_pte) == pte_write(entry)) path. I think that should be
> changed to a local range invalidation to be consistent with this change.

Yes.  This should be changed too.  However, it means we need a local
variant of __flush_tlb_range() and flush_tlb_mm().  Is it OK to
introduce them first and tidy up later?

>>  	return 1;
>>  }
>>  

---
Best Regards,
Huang, Ying

