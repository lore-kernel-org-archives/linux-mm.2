Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4FC2CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 10:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36D418E000E; Mon, 10 Nov 2025 05:45:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DBE8E0002; Mon, 10 Nov 2025 05:45:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5AF8E000E; Mon, 10 Nov 2025 05:45:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05F918E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:45:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 930EF4CAC5
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:45:13 +0000 (UTC)
X-FDA: 84094365306.18.00AEFCA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id C1652120012
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:45:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762771512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KSjXvKwlFd2+q4RbPzcQXr22CHbUvlx0Q6gRToGfNoM=;
	b=4xhtKGiRBd3JirFqrGu3+1fpgz9Az3kbGXuv/1Hme/CERYuhOV4Z0Wa0JNr5NiomwGHLgf
	ZcWTyxG9+bGlGjkpQfI7pHZ1davBIhuPLzW/W7J3aMyTvc3Jxfb3YYl0b+FiYnauTIiIh9
	ILy91lrdQb7dIUaGH/cahcvL2jgMhqw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762771512; a=rsa-sha256;
	cv=none;
	b=5aKhJuF9tGaLJcnPXp3Fe8OUzEDOLTB4NbE5XLyxXUVqPstytJHLNgDSZ3pDQ61Z6ox3W2
	YHiD9quMYlEZEoRZ5Sii+xrvkgDSABQcOYUuieO5qR+TJqM2B1nTdHiXQa/eYWwMuZqFPS
	iAhgJuxpWVANwJvO3OTQWtn72A/IY/I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3DC26497;
	Mon, 10 Nov 2025 02:45:03 -0800 (PST)
Received: from [10.57.39.147] (unknown [10.57.39.147])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78B2F3F66E;
	Mon, 10 Nov 2025 02:45:03 -0800 (PST)
Message-ID: <b44825dd-aef9-4d3e-91fd-a44122264c23@arm.com>
Date: Mon, 10 Nov 2025 11:45:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/12] mm: introduce generic lazy_mmu helpers
To: Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-7-kevin.brodsky@arm.com>
 <71418b31-aedb-4600-9558-842515dd6c44@arm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <71418b31-aedb-4600-9558-842515dd6c44@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: C1652120012
X-Stat-Signature: oicsacdgp169eamxumpkjew9epeyzbxb
X-HE-Tag: 1762771511-529120
X-HE-Meta: U2FsdGVkX1+CJaRxMY+RQvd8LaSkfeIDaKmayJ/ZewfZOjChnKe/FI0yKbg3vSl4N+BiQlt7N5nqN7eq02WYmeGhpe2OFO3T/WcZUdJ/rWyFs4p2h5xj/zV8nGNU844Ed1W1bGUyqj1UhnQOUfX9c18H8Dh7t003OG2Q1CpeAZZ64Xs0c/ZWMUnGdC+/m7UWuFAs166WniXm4BoPYdtY+w4vBqIZKEKP9XLQ3LOxRGWc/yYtJkKCeQ+EA53e0Per/kX/fgxVfQsiox0A+O5RJlvcCohfopwBsmaDrHwipgtig3AJFCtH7KMII3hduVaHohdnyBss0DzOM/o/xd7ZDCx6ylIFaKCncKdJzvvoDWkHN2XWDp2qIign4JZb0Vbysf9lq0ZiPokG7p1noYLY1aGKRclFdQ/4orEZPFYuvHJRYF3+NaslMv0hFssHo+/xR9DW7zx3ER2wVtyGpVa+hDM4kCl5gQ4PXBTSj2ZJhRKsCUtC9R8JaqCd8Xn06DZzT2NdBUWWHMOXfbu/rCW54jfb8G29L31VLISUNVn6u/Hc72s49NDpAwvwOu7JnnqGK7ZNfuQ2mohXvhtyfUCWT3A/PHpA48YehmtUcmTb0okWbgtJQ3jasbyP0zEjrxOR0tMdW3QHD5dwzSY82h+rv6ZmTRvP0oTC0YdtLwql8QUiVxLuDhuneFnmminkMlMc14PoH4mR3KOYtqqUKwjsfS8WFbS7KlK05T6l8dE4SgWYit842cIBJv6Fu/wDfJadkKEW7J6Zxz+XULFdl7wUWTQ5xUkKSr02g+Y2QtGd+756nvqM/45ij6MJBGivb76qi96e4pSblnc3qSJeXWroXJS9lX+X2hZkIMCfnqiYtf6FnSIVWenslTZtHw2Ux/66xctoGFlkHDEM1CXwhzY2tlgeIeL7YkheBL84p48Xl+8HEwmarYe3ueO1ocuyIf9Q51OGbydBFkQh80c2jAE
 CKmwh/0O
 lMLyMpo+WtxFsy+RCuTH/1G40uho8ZLkZB/JXyGtaO4xIVSzqrjYa5BTHL2dxpEyeXDbJFknvX7yeYSMeKmKY+HLcOUGItwERD2SyacbF+m02FDTr+C9tRDw4ye16nmaYtuYXWHnbq3I9Gc4BpaDTJ1wecQxenbLpQwJlUazXjYs6eM03uhYQP+EUSFwW7rzxfwn9w1HAMWDl17+6NSEtDGT6TXJ74gHzjUnhXqPBmzJQn108T9NdgoSZhqXOxc4IkRPg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/11/2025 14:26, Ryan Roberts wrote:
> On 29/10/2025 10:09, Kevin Brodsky wrote:
>> [...]
>>
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index b8d37eb037fc..d9c8e94f140f 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -731,7 +731,7 @@ int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
>>  		return -EINVAL;
>>  
>>  	mutex_lock(&pgtable_split_lock);
>> -	arch_enter_lazy_mmu_mode();
>> +	lazy_mmu_mode_enable();
>>  
>>  	/*
>>  	 * The split_kernel_leaf_mapping_locked() may sleep, it is not a
> This is a bit unfortunate, IMHO. The rest of this comment explains that although
> you're not supposed to sleep inside lazy mmu mode, it's fine for arm64's
> implementation. But we are no longer calling arm64's implementation; we are
> calling a generic function, which does who knows what.
>
> I think it all still works, but we are no longer containing our assumptions in
> arm64 code. We are relying on implementation details of generic code.

I see your point. The change itself is still correct (and required
considering patch 8), but maybe the documentation of the generic
interface should be clarified to guarantee that the generic layer can
itself cope with sleeping - without any guarantee regarding the
behaviour of arch_*_lazy_mmu_mode.

>> [...]
>>
>> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
>> index e33df3da6980..14fd672bc9b2 100644
>> --- a/arch/x86/include/asm/pgtable.h
>> +++ b/arch/x86/include/asm/pgtable.h
>> @@ -117,7 +117,8 @@ extern pmdval_t early_pmd_flags;
>>  #define pte_val(x)	native_pte_val(x)
>>  #define __pte(x)	native_make_pte(x)
>>  
>> -#define arch_end_context_switch(prev)	do {} while(0)
>> +#define arch_end_context_switch(prev)	do {} while (0)
>> +#define arch_flush_lazy_mmu_mode()	do {} while (0)
> Andrew converted over the default version of this (which you have removed with
> this commit) to be static inline instead of the do/while guff. Perhaps you
> should try to preserve that improvement here?
>
> See Commit d02ac836e4d6 ("include/linux/pgtable.h: convert
> arch_enter_lazy_mmu_mode() and friends to static inlines")

Good point, I suppose I could also convert arch_end_context_switch()
while at it.

>>  #endif	/* CONFIG_PARAVIRT_XXL */
>>  
>>  static inline pmd_t pmd_set_flags(pmd_t pmd, pmdval_t set)
>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>> index fc35a0543f01..d16ba1d32169 100644
>> --- a/fs/proc/task_mmu.c
>> +++ b/fs/proc/task_mmu.c
>> @@ -2703,7 +2703,7 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned long start,
>>  		return 0;
>>  	}
>>  
>> -	arch_enter_lazy_mmu_mode();
>> +	lazy_mmu_mode_enable();
>>  
>>  	if ((p->arg.flags & PM_SCAN_WP_MATCHING) && !p->vec_out) {
>>  		/* Fast path for performing exclusive WP */
>> @@ -2773,7 +2773,7 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned long start,
>>  	if (flush_end)
>>  		flush_tlb_range(vma, start, addr);
>>  
>> -	arch_leave_lazy_mmu_mode();
>> +	lazy_mmu_mode_disable();
>>  	pte_unmap_unlock(start_pte, ptl);
>>  
>>  	cond_resched();
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index 9894366e768b..b5fdf32c437f 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -231,10 +231,31 @@ static inline int pmd_dirty(pmd_t pmd)
>>   * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
>>   * and the mode cannot be used in interrupt context.
>>   */
>> -#ifndef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>> -static inline void arch_enter_lazy_mmu_mode(void) {}
>> -static inline void arch_leave_lazy_mmu_mode(void) {}
>> -static inline void arch_flush_lazy_mmu_mode(void) {}
>> +#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>> +static inline void lazy_mmu_mode_enable(void)
>> +{
>> +	arch_enter_lazy_mmu_mode();
>> +}
>> +
>> +static inline void lazy_mmu_mode_disable(void)
>> +{
>> +	arch_leave_lazy_mmu_mode();
>> +}
>> +
>> +static inline void lazy_mmu_mode_pause(void)
>> +{
>> +	arch_leave_lazy_mmu_mode();
>> +}
>> +
>> +static inline void lazy_mmu_mode_resume(void)
>> +{
>> +	arch_enter_lazy_mmu_mode();
>> +}
> It would be good to add documentation blocks for each of these.

I considered it, but then realised that these functions are much better
explained together (see comment added above in patch 7). Maybe a short
description for each that refers to the big comment above? That wouldn't
work well for the generated kernel-doc though...

- Kevin 

