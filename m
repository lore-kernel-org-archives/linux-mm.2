Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D9FCCFA1A
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 07:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41EC18E0007; Sat,  8 Nov 2025 02:20:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0008E0003; Sat,  8 Nov 2025 02:20:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E58D8E0007; Sat,  8 Nov 2025 02:20:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1965C8E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:20:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8AFFE1A06CB
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 07:20:31 +0000 (UTC)
X-FDA: 84086591862.15.C0EA3B7
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F0CD40003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 07:20:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Bb8ftdHI;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762586430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5hRbEmCZAr8rZpKUXLSHNatmnQ6+I1kl4hbNoJwVz4=;
	b=s9O94pDeg1+5LLSmo0qYsRKmzccCrZLOhzNfLUZ/2Q2mSgl104rnTOBDc2dR3iA3ZS52Yr
	JJg5UOfgq/OZz3XkB+g/ElPdY0IkXJQABwiA8fKutITPHq3tD0tzbicyk07kiSxlCsKEKh
	rSjeSrMLx7xWDgaI/AJNO3E5BhJ4uqk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762586430; a=rsa-sha256;
	cv=none;
	b=eYJhSbC+wIpK2vojrvOtzlTiSnCepCnmLq3DYZA8JNko/oR5v6/Oy5CXqZgOCmLMqMHKia
	gMdqALkrFqeikxgxmiAKz0TrxRCQlvPymhgZ7DAmSgoXF2QuARNEAMVWT2uXDppe8oakry
	mi/ny5QXquI3nrqCApi+KK9ytJAMFPc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Bb8ftdHI;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762586424; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=w5hRbEmCZAr8rZpKUXLSHNatmnQ6+I1kl4hbNoJwVz4=;
	b=Bb8ftdHIj55L105b9x2Elp40YNoGVWwFtvsnzfebs5yUaP+Aa+nz//gWXWdD98UoEqHrHOT2EnzKrw81cd/mQiCX8fbyQ+X1ghcl8koHiyQvBnJUz4iJNbB/JVGCC0coxYvdDPHU4SSmr75ate5YZG6yrZXxK0e2BCzlCgKq2iU=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wrv9onH_1762586422 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 08 Nov 2025 15:20:23 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,  Will Deacon
 <will@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Ryan
 Roberts <ryan.roberts@arm.com>,  Barry Song <baohua@kernel.org>,  Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,
  Zi Yan <ziy@nvidia.com>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Yang Shi <yang@os.amperecomputing.com>,  "Christoph Lameter (Ampere)"
 <cl@gentwo.org>,  Dev Jain <dev.jain@arm.com>,  Anshuman Khandual
 <anshuman.khandual@arm.com>,  Kefeng Wang <wangkefeng.wang@huawei.com>,
  Kevin Brodsky <kevin.brodsky@arm.com>,  Yin Fengwei
 <fengwei_yin@linux.alibaba.com>,  linux-arm-kernel@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH -v4 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
In-Reply-To: <2b9fa85b-54ff-415c-9163-461e28b6d660@gmail.com> (David
	Hildenbrand's message of "Thu, 6 Nov 2025 10:47:10 +0100")
References: <20251104095516.7912-1-ying.huang@linux.alibaba.com>
	<20251104095516.7912-3-ying.huang@linux.alibaba.com>
	<2b9fa85b-54ff-415c-9163-461e28b6d660@gmail.com>
Date: Sat, 08 Nov 2025 15:20:21 +0800
Message-ID: <87qzu97zyi.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: y3b8ke59ciwmriycfw9d77n7h3c3pd9n
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F0CD40003
X-Rspamd-Server: rspam10
X-HE-Tag: 1762586428-928949
X-HE-Meta: U2FsdGVkX19qZZTSsrp5fVHz3FnJDNR7R3Tr1Zl+L2smJGwyA9zBCQyP1oersedBRL+7fP6ilvSMKWOgrltXMiTNUmRz1Vi4gwvYX4Mvb3jqIvRrgI5sHhKu+6op9T6jWcunpwUGqRTy8W8zhpjMBJRgtii6sYKvcFhlfAcRNHfn+clEdXFrM/OvW+bAhnaFvpE3UPe4BdMtRF4MpsQDOHxoWupJEfwPh9S8o7WaFN4HVM9mtFIRq6WP7DnqOcwJb2HuKJZ+vzUPmTAMjnMtUpQxPxsFBWWBrqxT147mhYcXRe0kQtf+bXXiX8yO4ulnHOPYZ65Jz+lYZ57IJKMuMHbNe4+4K2LSp/Ikzr/iMkdfQTNtJ37WSk25jz8Dg1UUxd2fyzgpBwmM/SSTmc9zOGvohtKOreZE4R3xnGwI5PdqkqSVZlwJ3+PbMzA19AWPauZ/c8dOfVP8pWM3a4jJ6It4mb+kfLLEFpjgpiy+682bV2U9Cts+g+/V5akgkYQ3M7mb+gGNtZ9Men9piPCg+ECkBJEiSYju53G7n7sGcP/ljBd9E458u7CDv+kWVCVVvpYNGgTtDQD1z6faChdL1mUr9RS8U8t9dija6csHftS8zpU/bRpO7AXI0xdgt/UVmdbceDznLeR8k272mgnksEv+ii8MDYQA0FmqPP6vSGDFfF20AkP4zB1OR7uRWbUA/tBaIlO2PmueJeJaVcHbtAecWhQo48yXnK6EQ876tFy1eq1WDkJilxVZR6sGeHvO/xUpYDO+jYMzI9M2duDcmdoIFt/y4C1Z7iinLd0x42kXmuSABLtEPGQBcneYDjgRZ32nZmESHzwMipixclWQwVcnTUjzMZLXFCu/Mf72FLSf5BfwoMrt/cU61zHEkJEhcDa8tS6UdXi+Um+JDuO9/St+Ibab4djOx/skOJdS3mXNGdMwfd3BK6OSH2KK5erU27ihSVnYwjw1YNzbTJy
 /jHSYXTh
 fKuajztWZ7gHj+fOtjhMlPYh6KePCIilLhPt/NBEJiyLWzFUTyDqoVrD+80ui4Q0tRSHfaYNonWven3nZ9VYJ7CEIQCAKFXQcWcRDlORJuL8xGR08lhb/tc0cZE2BF5dg719ZlStKX+IsZb2rYvHIFcZTynJikZ6pW6UkoHYwLwow4AQEH2V8lLq0szV71o8vUxdYx8N5XKssvoRmm+/oh1GVPPpM1B+0nPR8uIMloppxDf1YSm6lCPzhYBbD431z7Y2jbbJPKVYkiTo+xOIosxqRJigE3fJe6A1lyZRUQSroTBNdNMOtZOpSuYvz43qym1Y5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, David,

"David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com> writes:

> On 04.11.25 10:55, Huang Ying wrote:
>> A multi-thread customer workload with large memory footprint uses
>> fork()/exec() to run some external programs every tens seconds.  When
>> running the workload on an arm64 server machine, it's observed that
>> quite some CPU cycles are spent in the TLB flushing functions.  While
>> running the workload on the x86_64 server machine, it's not.  This
>> causes the performance on arm64 to be much worse than that on x86_64.
>> During the workload running, after fork()/exec() write-protects all
>> pages in the parent process, memory writing in the parent process
>> will cause a write protection fault.  Then the page fault handler
>> will make the PTE/PDE writable if the page can be reused, which is
>> almost always true in the workload.  On arm64, to avoid the write
>> protection fault on other CPUs, the page fault handler flushes the TLB
>> globally with TLBI broadcast after changing the PTE/PDE.  However, this
>> isn't always necessary.  Firstly, it's safe to leave some stale
>> read-only TLB entries as long as they will be flushed finally.
>> Secondly, it's quite possible that the original read-only PTE/PDEs
>> aren't cached in remote TLB at all if the memory footprint is large.
>> In fact, on x86_64, the page fault handler doesn't flush the remote
>> TLB in this situation, which benefits the performance a lot.
>> To improve the performance on arm64, make the write protection fault
>> handler flush the TLB locally instead of globally via TLBI broadcast
>> after making the PTE/PDE writable.  If there are stale read-only TLB
>> entries in the remote CPUs, the page fault handler on these CPUs will
>> regard the page fault as spurious and flush the stale TLB entries.
>> To test the patchset, make the usemem.c from
>> vm-scalability (https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git).
>> support calling fork()/exec() periodically.  To mimic the behavior of
>> the customer workload, run usemem with 4 threads, access 100GB memory,
>> and call fork()/exec() every 40 seconds.  Test results show that with
>> the patchset the score of usemem improves ~40.6%.  The cycles% of TLB
>> flush functions reduces from ~50.5% to ~0.3% in perf profile.
>> 
>
> All makes sense to me.
>
> Some smaller comments below.

Thanks!

> [...]
>
>> +
>> +static inline void local_flush_tlb_page_nonotify(
>> +	struct vm_area_struct *vma, unsigned long uaddr)
>
> NIT: "struct vm_area_struct *vma" fits onto the previous line.

Sure.

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
>>   static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
>>   					   unsigned long uaddr)
>>   {
>> @@ -472,6 +512,22 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
>>   	dsb(ish);
>>   }
>>   +static inline void local_flush_tlb_contpte(struct vm_area_struct
>> *vma,
>> +					   unsigned long addr)
>> +{
>> +	unsigned long asid;
>> +
>> +	addr = round_down(addr, CONT_PTE_SIZE);
>> +
>> +	dsb(nshst);
>> +	asid = ASID(vma->vm_mm);
>> +	__flush_tlb_range_op(vale1, addr, CONT_PTES, PAGE_SIZE, asid,
>> +			     3, true, lpa2_is_enabled());
>> +	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, addr,
>> +						    addr + CONT_PTE_SIZE);
>> +	dsb(nsh);
>> +}
>> +
>>   static inline void flush_tlb_range(struct vm_area_struct *vma,
>>   				   unsigned long start, unsigned long end)
>>   {
>> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
>> index c0557945939c..589bcf878938 100644
>> --- a/arch/arm64/mm/contpte.c
>> +++ b/arch/arm64/mm/contpte.c
>> @@ -622,8 +622,7 @@ int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
>>   			__ptep_set_access_flags(vma, addr, ptep, entry, 0);
>>     		if (dirty)
>> -			__flush_tlb_range(vma, start_addr, addr,
>> -							PAGE_SIZE, true, 3);
>> +			local_flush_tlb_contpte(vma, start_addr);
>
> In this case, we now flush a bigger range than we used to, no?
>
> Probably I am missing something (should this change be explained in
> more detail in the cover letter), but I'm wondering why this contpte
> handling wasn't required before on this level.

As Ryan explained in his replay email.  The flush range doesn't change
here.  We just replace global TLB flush with local TLB flush.

>>   	} else {
>>   		__contpte_try_unfold(vma->vm_mm, addr, ptep, orig_pte);
>>   		__ptep_set_access_flags(vma, addr, ptep, entry, dirty);
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index d816ff44faff..22f54f5afe3f 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -235,7 +235,7 @@ int __ptep_set_access_flags(struct vm_area_struct *vma,
>>     	/* Invalidate a stale read-only entry */
>
> I would expand this comment to also explain how remote TLBs are
> handled very briefly -> flush_tlb_fix_spurious_fault().

Sure.

>>   	if (dirty)
>> -		flush_tlb_page(vma, address);
>> +		local_flush_tlb_page(vma, address);
>>   	return 1;
>>   }
>>   

---
Best Regards,
Huang, Ying

