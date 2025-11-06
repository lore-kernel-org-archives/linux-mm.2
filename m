Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885B6CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD1B88E0005; Thu,  6 Nov 2025 11:54:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8B68E0002; Thu,  6 Nov 2025 11:54:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6898E0005; Thu,  6 Nov 2025 11:54:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AED5F8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:54:57 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4ED67B6D54
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:54:57 +0000 (UTC)
X-FDA: 84080781834.03.ECDBAD6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 80B13C0011
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:54:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762448095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xv6mPGh8OTRRAPa/vnnTLwXHmpQDOc+h8v1HfQuws/k=;
	b=k2chZIjGXKedX7+cuLMrAA38MuBhs6qHWS0Kqn64ez/Y9lz9rHmFoL9PxPTX/Ob8d//GtB
	qM2Sx/K3eFeUtgt9AYhasvITmztsM+gGTFXrOZi5bOApmCWn0YMZJMgHEfiiiKlb1s6Q0e
	in7pv0skjTfM63teunFoVNwFNd71DLY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762448095; a=rsa-sha256;
	cv=none;
	b=XBWi4/7WZ7u5cZAm7XfNIbjR2AQcvAdaO5c/xepAgZxUSDDw0Kjq+vq49x1ncp1juqab0I
	5SvPYQ3+a8se+fmfIi5bJgjb/3OsS9M0IRn/WFdY/bo2Osdqpnba1FxmVmY8FXybNvBEzP
	SBLnCsuXilSKPAHC5yBzLl1FRskTPhs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7FEB1596;
	Thu,  6 Nov 2025 08:54:46 -0800 (PST)
Received: from [10.1.30.195] (XHFQ2J9959.cambridge.arm.com [10.1.30.195])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E7ED3F694;
	Thu,  6 Nov 2025 08:54:51 -0800 (PST)
Message-ID: <bd10dd8a-8cdc-404e-8259-4d65ca9a650d@arm.com>
Date: Thu, 6 Nov 2025 16:54:49 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -v4 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
Content-Language: en-GB
To: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>,
 Huang Ying <ying.huang@linux.alibaba.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Barry Song <baohua@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Yang Shi <yang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Yin Fengwei <fengwei_yin@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251104095516.7912-1-ying.huang@linux.alibaba.com>
 <20251104095516.7912-3-ying.huang@linux.alibaba.com>
 <2b9fa85b-54ff-415c-9163-461e28b6d660@gmail.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <2b9fa85b-54ff-415c-9163-461e28b6d660@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 80B13C0011
X-Stat-Signature: 5hycojw4bcumoy9ij47uf1xotssjumop
X-Rspam-User: 
X-HE-Tag: 1762448095-738723
X-HE-Meta: U2FsdGVkX1+CyvO61rct8q75wYWyCvsvmOwM9gIlicl0T2BOoPzSCKkfKAjKIOZGq0Dc3rFbKViP/W0kLz4crPvw+cE7V4+N4Jln30KOMwV65TUpFJV+WR67JJsfK2KFIlLD86b1CmURv7yOwjj63+C67+uIRLRAczzD+0upCVS3q9jAuFz4yH9ki8R1LuSTFm0IWxltUl5SkPmVuil9gob/jW3v2sO+wI+ou4JYec+nkSvc1Ql3Tplsn0U5hQRC0ItT3Q2CNBblfahAC7H0HFcEd3h+FhNTxmHazXFfdzihuIBHLVkZ5xLGLHC/HZT7dyYb49n80nvA6QCtTKJtfJ11O82mgjjf0IQc9dOnbBIiRDBwMsVK/G549JbVRBOtoMi7/WfV0d09psSx+V/fJGegSx/VeSkiiKWx5suqXEm9WQ4gMfiZh9DfB3/dU6nJ2NgXFq5Q/T2DwOpyX/W+Qs3NhWCW/HszhxPHlKe4ShfdOKD1QK3AyFh0NV029OBrGsJJfBNlHMFxTy2BkAR4zf8fIHhUymy0cpzQVfpuUKfxISRo0NPl7hwB81daAQge+bo5s9Sl1zGme7W4RnRLs/EPHUIbTKq/IZtUfZ10Q1ZyFH5+ly8K0ITKcbhiXTM1jt3Mi72sBXG7EX10h5mMIvoVur1oI9BwxN/R6zhQP/W6DNnZnvBYL9+DjH7X3FQ6+lS8vk1INXZmw2fhmM+TGs9GGyQ62irjTbMFtU8H7Y9wPlzZaGDvP/HGSqMHG2YtdvFl/M69hRAcT09JJKiQE8LyjnttyLlrtc0NtxMaEEhZV1DGGaFKtDoIuXfHbFuAXwqQOwWuBsDRQ5xAH4Wg9/ZkIOgdxYz+YFWH2ts9O223frCSGRVhmUKYhUyjeOc6aADXv8gHjP3ACU+lLHg/s465xKd6e8pHUUOxTpk2uOM+KUta5lzeFM4FoHfNtij6MrBDV6SNPRRBbgalEKc
 zqmhRZff
 HwxKOP11Jb4JlP+AXPWze+6pRPRB1eDabuYkwkakZpzKrwNUj2KTuKQlN1ZLDefKbJviOvn75QN+OoArbo6m14rvdJuWP2ecLdUT9bBPAdVpuKj48r3mvhBBQhxMr5eO9CuP7khlP+ZAge+gFq3Ty0MAjWIMJM4oXeYlPMY4OKv9GptQZbapd4sdn1q6r4R1kCa1X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/11/2025 09:47, David Hildenbrand (Red Hat) wrote:
> On 04.11.25 10:55, Huang Ying wrote:
>> A multi-thread customer workload with large memory footprint uses
>> fork()/exec() to run some external programs every tens seconds.  When
>> running the workload on an arm64 server machine, it's observed that
>> quite some CPU cycles are spent in the TLB flushing functions.  While
>> running the workload on the x86_64 server machine, it's not.  This
>> causes the performance on arm64 to be much worse than that on x86_64.
>>
>> During the workload running, after fork()/exec() write-protects all
>> pages in the parent process, memory writing in the parent process
>> will cause a write protection fault.  Then the page fault handler
>> will make the PTE/PDE writable if the page can be reused, which is
>> almost always true in the workload.  On arm64, to avoid the write
>> protection fault on other CPUs, the page fault handler flushes the TLB
>> globally with TLBI broadcast after changing the PTE/PDE.  However, this
>> isn't always necessary.  Firstly, it's safe to leave some stale
>> read-only TLB entries as long as they will be flushed finally.
>> Secondly, it's quite possible that the original read-only PTE/PDEs
>> aren't cached in remote TLB at all if the memory footprint is large.
>> In fact, on x86_64, the page fault handler doesn't flush the remote
>> TLB in this situation, which benefits the performance a lot.
>>
>> To improve the performance on arm64, make the write protection fault
>> handler flush the TLB locally instead of globally via TLBI broadcast
>> after making the PTE/PDE writable.  If there are stale read-only TLB
>> entries in the remote CPUs, the page fault handler on these CPUs will
>> regard the page fault as spurious and flush the stale TLB entries.
>>
>> To test the patchset, make the usemem.c from
>> vm-scalability (https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-
>> scalability.git).
>> support calling fork()/exec() periodically.  To mimic the behavior of
>> the customer workload, run usemem with 4 threads, access 100GB memory,
>> and call fork()/exec() every 40 seconds.  Test results show that with
>> the patchset the score of usemem improves ~40.6%.  The cycles% of TLB
>> flush functions reduces from ~50.5% to ~0.3% in perf profile.
>>
> 
> All makes sense to me.
> 
> Some smaller comments below.
> 
> [...]
> 
>> +
>> +static inline void local_flush_tlb_page_nonotify(
>> +    struct vm_area_struct *vma, unsigned long uaddr)
> 
> NIT: "struct vm_area_struct *vma" fits onto the previous line.
> 
>> +{
>> +    __local_flush_tlb_page_nonotify_nosync(vma->vm_mm, uaddr);
>> +    dsb(nsh);
>> +}
>> +
>> +static inline void local_flush_tlb_page(struct vm_area_struct *vma,
>> +                    unsigned long uaddr)
>> +{
>> +    __local_flush_tlb_page_nonotify_nosync(vma->vm_mm, uaddr);
>> +    mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, uaddr & PAGE_MASK,
>> +                        (uaddr & PAGE_MASK) + PAGE_SIZE);
>> +    dsb(nsh);
>> +}
>> +
>>   static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
>>                          unsigned long uaddr)
>>   {
>> @@ -472,6 +512,22 @@ static inline void __flush_tlb_range(struct
>> vm_area_struct *vma,
>>       dsb(ish);
>>   }
>>   +static inline void local_flush_tlb_contpte(struct vm_area_struct *vma,
>> +                       unsigned long addr)
>> +{
>> +    unsigned long asid;
>> +
>> +    addr = round_down(addr, CONT_PTE_SIZE);
>> +
>> +    dsb(nshst);
>> +    asid = ASID(vma->vm_mm);
>> +    __flush_tlb_range_op(vale1, addr, CONT_PTES, PAGE_SIZE, asid,
>> +                 3, true, lpa2_is_enabled());
>> +    mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, addr,
>> +                            addr + CONT_PTE_SIZE);
>> +    dsb(nsh);
>> +}
>> +
>>   static inline void flush_tlb_range(struct vm_area_struct *vma,
>>                      unsigned long start, unsigned long end)
>>   {
>> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
>> index c0557945939c..589bcf878938 100644
>> --- a/arch/arm64/mm/contpte.c
>> +++ b/arch/arm64/mm/contpte.c
>> @@ -622,8 +622,7 @@ int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
>>               __ptep_set_access_flags(vma, addr, ptep, entry, 0);
>>             if (dirty)
>> -            __flush_tlb_range(vma, start_addr, addr,
>> -                            PAGE_SIZE, true, 3);
>> +            local_flush_tlb_contpte(vma, start_addr);
> 
> In this case, we now flush a bigger range than we used to, no?

I don't believe so, no; we are still flushing the same contpte region (i.e. 64K
for 4K base page config).

> 
> Probably I am missing something (should this change be explained in more detail
> in the cover letter), but I'm wondering why this contpte handling wasn't
> required before on this level.

The previous __flush_tlb_range() API was flushing the same region. But that API
broadcasts. We decided not to just create a local version of that API because it
is more complex than it needs to be for this use case.

The whole (arm64-private) TLB flush interface is creeking and needs some
refactoring, which I'm planning to do as a follow up to this.

Thanks,
Ryan

> 
>>       } else {
>>           __contpte_try_unfold(vma->vm_mm, addr, ptep, orig_pte);
>>           __ptep_set_access_flags(vma, addr, ptep, entry, dirty);
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index d816ff44faff..22f54f5afe3f 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -235,7 +235,7 @@ int __ptep_set_access_flags(struct vm_area_struct *vma,
>>         /* Invalidate a stale read-only entry */
> 
> I would expand this comment to also explain how remote TLBs are handled very
> briefly -> flush_tlb_fix_spurious_fault().
> 
>>       if (dirty)
>> -        flush_tlb_page(vma, address);
>> +        local_flush_tlb_page(vma, address);
>>       return 1;
>>   }
>>   
> 


