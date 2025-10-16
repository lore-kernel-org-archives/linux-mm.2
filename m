Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAA1DCCD193
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 01:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3538E004C; Wed, 15 Oct 2025 21:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273638E0008; Wed, 15 Oct 2025 21:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13BD88E004C; Wed, 15 Oct 2025 21:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 000F88E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:35:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BC8D138EEC
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:35:19 +0000 (UTC)
X-FDA: 84002259558.01.C8FEBBC
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf20.hostedemail.com (Postfix) with ESMTP id A77641C0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:35:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OZIfaWuA;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760578518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23ZCF8KBb3dclACfCrat83b8Fd2iW62x98ewCs5uUOg=;
	b=U63hV6+KH+uKOH8xrvEN33mn+U8mzdhIuHEU1oJhKDsZrtNfn0aBtAANFhxcq7doBiTEIZ
	uqtDjGvdh9ZI78Ul8ohuZ3jPMkXCfVheqh8Yoj1GtTJIR0JYr+tKwAkxP1LaEMSz9/BE2Z
	7VETVKVqCrp8SYZhnVRztin+VkYFbRQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760578518; a=rsa-sha256;
	cv=none;
	b=rrMWYjdXNN0P2kJF4c0MReGEBY1zr+lnXJ5glPrtyFKPoT2SgUbHAmTp/oLe3IaRFWfvhB
	98ZvHBxnPBBakMl7NUlyO2Rdt/CYiM4nqApL/uOk+tWcf89rxpFAjoI6GB7Od8CFlE3rsl
	BSpfaw/OpiqJ7B1PFfo/Pp5UEKFKP4o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OZIfaWuA;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760578513; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=23ZCF8KBb3dclACfCrat83b8Fd2iW62x98ewCs5uUOg=;
	b=OZIfaWuAv0nEawCK0Ty0XG+y1dXFgf+NlYu+559UdHLzklGB99yJIQj/rE1AM3M7W/848Nw+g39Xrts9yZ/ziX5U78dLwQwy5E+NConKz8+Ilbc2GfMjhQLszyUh30e92UXg9EfPggcPzSRBQDIyCRVGjwEWb2wd2SB4IPmynC0=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqIOhL1_1760578511 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Oct 2025 09:35:12 +0800
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
Subject: Re: [PATCH -v2 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
In-Reply-To: <9afcdd88-f8f9-4d2f-94d7-7c41b0a25ddf@arm.com> (Ryan Roberts's
	message of "Wed, 15 Oct 2025 16:28:31 +0100")
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
	<20251013092038.6963-3-ying.huang@linux.alibaba.com>
	<9afcdd88-f8f9-4d2f-94d7-7c41b0a25ddf@arm.com>
Date: Thu, 16 Oct 2025 09:35:11 +0800
Message-ID: <877bwvmxww.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Queue-Id: A77641C0003
X-Rspamd-Server: rspam02
X-Stat-Signature: 7rxb6zg3cwhbcgzj71jbf9ezpmbiz9jk
X-HE-Tag: 1760578516-879556
X-HE-Meta: U2FsdGVkX18e09g+lAkHen3a386AD5/nJhAC5RpFRp6Oa+Fg/eOw7pH7SCOYUmrNsglHmWRWMXsnRE5J6/eTpgSSDsuTu0tJOxdt/sOsYyVffxECvdZKTxs5B3IkjCuw4S2dIf06eyIREDlYfpnPn7TJz6Zo+hCw8iXd656u8IwiA1sc5lVLiewPSsQFeMYDJlKnfRxr8VGKIeIi2NzPmSd1/lKKfC4czsIIcRKB38AsOwnvKdR6LPH3ztvCy5/Jialb5eEUMMn43UPdLT9dyIiJyj0W11cOxEzRi5ynmz9A2WArLCGV6gS53Q0MSXhYPyt+hJQM9tcC+21OnZgUlZZzHz0HgFNz7/otVFLmMOOisdsBYsb4f8h2YzTH1SA6w5uPCAgJfuNB9eup5xRK5bTQ7zN4uLKJLq7F2inx+0kDWCdmKFeFao1L6Zqxfym4y7tDe4+xWl1X0e16NoK/3WbT03oyQ7Ktbg2KfPt1TxKDgxdL2f+ptcbog/vSCOdgVHGY2Dkan6MBVzKeYovLfwwzc2S9w7c0pJYihY2SMEPjwtbuZRXBOmwtWbTw6GXMaR8ivf1i6s7wA89zxR8a/7OH/s3IPQ3UOv8c09MyZvq92900d6t4W++OoV/fDdv2ANH9tFVUyqE/oUeS9NpRX8Xco+sX3jcCttdQWV9bCNCOT1AITzPHuldCWl/tFHBLrrMcHjCi7SC5zm3xzS9belfqvD4AuUdYKXdpegCDqo+63UYoa3ceQqRkDsk1v3PhLLr4w2z+jfeTic0JodHKnNUniDqvQzxMZrtqubm2Z3nKT1taIKtcBkpgn08Spi7/y/PaG4M8Fqlbs/n9pbTTqUWGFFTrXnrMEhFyBuUeiFG+YZAPxyASNoHT1ZTHx+KEd7PigdFC+YMVpy1bw6TeYs+BsrJpWyDLjVcYPZN//VnKKfRMhPx3XOQ5sbcBj1491OmiIJYM89qRCzBgGc+
 TtR0u+2l
 PuH47FzyCtXKypPfwsq2TBxmKAecJq18MebCc89C/MZO1au2TRiJvXbbyqpXCunDSUfgyhylfYAt6WxdVWM4JxL43tD9eSHH+y9YdqreQMGdeQlilKjRK0Aq0Yd8a7nx5bM2k/Q1RnO6mbkzpfJCSaHZ+HZETRpN5oyvUMlKBWMIk7uqQwfKhKCl0uLbHp5RdBwn72vZsjh6cT1F64HtYGc5twRl8VZigDfq4qCjFJGBW8rrdfz1xkt+F+P3Kq8dh4jR9y1ZpQ9nmsQHipS0uR6DSiwaANOq7KC1ZRrgzlu3Zczx4zhq1f8vVKMWTzlCCe/0rhQVEw90skwsX/rx/pcQ9zs1TdN4Zpy5pr/KPWn3qJulPGk6KuismxSLes3x6osnUKcExrBP4ctlPCqkoW6yAlR8wCpE1sGSDvwcJWN7FIg60xD88OfSxnMh+fqzMQ6KzPEvn35rYUOYGGBFJrHcoXX4eLWAV8SvQhohZXxg3qkdaIWCtFEh7k1BmNjSGCk+lJ+FnuzIvuXU01nwJmm5B3G30sPcYkyQKvW3tUDV7QL8jtwkEAaRGzvOdMovm2e2K1558SYLL3MjTvAr2tiHoIgHO69mx8kKM8DOvx05xFYNCaVSqZxWYGvXoEAVPGROcWuOsR1u7xg4mE8BfMsKjTwpxcaNcdJiiOxbAl/N6muj26k52DG6y/1Si5WFhixdwTJtQ4DT5tIRY9iTmISNTwE/v1VS6YrBBly+i4MV/bq4Kuldd1UyiDgEEKEYA8Tbk7FVwEBfBWkbpdqBlwLlGw0pEfFk2zTTw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Ryan,

Thanks for comments!

Ryan Roberts <ryan.roberts@arm.com> writes:

> On 13/10/2025 10:20, Huang Ying wrote:
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
>
> nit: You keep using the word "stall" here and in the code. I think you mean "stale"?

OOPS, my poor English :-(
Yes, it should be "stale".  Thanks for pointing this out, will fix it in
the future versions.

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
>> To test the patchset, make the usemem.c from vm-scalability
>> (https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git).
>> support calling fork()/exec() periodically (merged).  To mimic the
>> behavior of the customer workload, run usemem with 4 threads, access
>> 100GB memory, and call fork()/exec() every 40 seconds.  Test results
>> show that with the patchset the score of usemem improves ~40.6%.  The
>> cycles% of TLB flush functions reduces from ~50.5% to ~0.3% in perf
>> profile.
>> 
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
>>  arch/arm64/include/asm/pgtable.h  | 14 +++++---
>>  arch/arm64/include/asm/tlbflush.h | 56 +++++++++++++++++++++++++++++++
>>  arch/arm64/mm/contpte.c           |  3 +-
>>  arch/arm64/mm/fault.c             |  2 +-
>>  4 files changed, 67 insertions(+), 8 deletions(-)
>> 
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index aa89c2e67ebc..35bae2e4bcfe 100644
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
>>  
>>  /*
>>   * ZERO_PAGE is a global shared page that is always zero: used
>> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
>> index 18a5dc0c9a54..651b31fd18bb 100644
>> --- a/arch/arm64/include/asm/tlbflush.h
>> +++ b/arch/arm64/include/asm/tlbflush.h
>> @@ -249,6 +249,18 @@ static inline unsigned long get_trans_granule(void)
>>   *		cannot be easily determined, the value TLBI_TTL_UNKNOWN will
>>   *		perform a non-hinted invalidation.
>>   *
>> + *	local_flush_tlb_page(vma, addr)
>> + *		Local variant of flush_tlb_page().  Stale TLB entries may
>> + *		remain in remote CPUs.
>> + *
>> + *	local_flush_tlb_page_nonotify(vma, addr)
>> + *		Same as local_flush_tlb_page() except MMU notifier will not be
>> + *		called.
>> + *
>> + *	local_flush_tlb_contpte_range(vma, start, end)
>> + *		Invalidate the virtual-address range '[start, end)' mapped with
>> + *		contpte on local CPU for the user address space corresponding
>> + *		to 'vma->mm'.  Stale TLB entries may remain in remote CPUs.
>>   *
>>   *	Finally, take a look at asm/tlb.h to see how tlb_flush() is implemented
>>   *	on top of these routines, since that is our interface to the mmu_gather
>> @@ -282,6 +294,33 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
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
>> +static inline void local_flush_tlb_page(struct vm_area_struct *vma,
>> +					unsigned long uaddr)
>> +{
>> +	__local_flush_tlb_page_nonotify_nosync(vma->vm_mm, uaddr);
>> +	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, uaddr & PAGE_MASK,
>> +						(uaddr & PAGE_MASK) + PAGE_SIZE);
>> +	dsb(nsh);
>> +}
>> +
>>  static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
>>  					   unsigned long uaddr)
>>  {
>> @@ -472,6 +511,23 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
>>  	dsb(ish);
>>  }
>>  
>> +static inline void local_flush_tlb_contpte_range(struct vm_area_struct *vma,
>> +						 unsigned long start, unsigned long end)
>
> This would be clearer as an API if it was like this:
>
> static inline void local_flush_tlb_contpte(struct vm_area_struct *vma,
> 					unsigned long uaddr)
>
> i.e. the user doesn't set the range - it's implicitly CONT_PTE_SIZE starting at
> round_down(uaddr, PAGE_SIZE).

Sure.  Will do this.

> Thanks,
> Ryan
>
>> +{
>> +	unsigned long asid, pages;
>> +
>> +	start = round_down(start, PAGE_SIZE);
>> +	end = round_up(end, PAGE_SIZE);
>> +	pages = (end - start) >> PAGE_SHIFT;
>> +
>> +	dsb(nshst);
>> +	asid = ASID(vma->vm_mm);
>> +	__flush_tlb_range_op(vale1, start, pages, PAGE_SIZE, asid,
>> +			     3, true, lpa2_is_enabled());
>> +	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, start, end);
>> +	dsb(nsh);
>> +}
>> +
>>  static inline void flush_tlb_range(struct vm_area_struct *vma,
>>  				   unsigned long start, unsigned long end)
>>  {
>> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
>> index c0557945939c..0f9bbb7224dc 100644
>> --- a/arch/arm64/mm/contpte.c
>> +++ b/arch/arm64/mm/contpte.c
>> @@ -622,8 +622,7 @@ int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
>>  			__ptep_set_access_flags(vma, addr, ptep, entry, 0);
>>  
>>  		if (dirty)
>> -			__flush_tlb_range(vma, start_addr, addr,
>> -							PAGE_SIZE, true, 3);
>> +			local_flush_tlb_contpte_range(vma, start_addr, addr);
>>  	} else {
>>  		__contpte_try_unfold(vma->vm_mm, addr, ptep, orig_pte);
>>  		__ptep_set_access_flags(vma, addr, ptep, entry, dirty);
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
>>  	return 1;
>>  }
>>  

---
Best Regards,
Huang, Ying

