Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D175FCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 10:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326178E0007; Mon, 10 Nov 2025 05:48:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6C98E0002; Mon, 10 Nov 2025 05:48:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ECD08E0007; Mon, 10 Nov 2025 05:48:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07B998E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:48:05 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5DDD160CA9
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:48:04 +0000 (UTC)
X-FDA: 84094372488.14.B46B668
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id EEA14120010
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:48:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762771683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sjXywmJ+WA0ld4wtuKRvw4DwT8rmylaCBEi/H93g6VA=;
	b=3mg+EYDUbua4dScZ0lIIabOLF0Elr99mIG3QNU7UmQN5AAq8I4qsXt4Oi8W8jHj5n1485t
	T9FatTIsXeiZfGCYBfBnxr5qKChUr3FOEILaktfP3+6asvFnXsS98XKslSScWH/YjvlaUO
	RNJiDSiNvAXxQzQ9il2QVmtYb24+4j0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762771683; a=rsa-sha256;
	cv=none;
	b=CzrU5dVj5WKsk4r1L+sj9SeSN2WeZ4KsmDjJ+aANKkhI9YWOF2NM2D73KILHjrYv7I+0iJ
	iVVQASqc4NdDCOTuxn95bYgJbSwY5T2ipUHhO70HsOYgQ0wC/7kQFazJaT9y7ALgkoM2T8
	U3C0MUtmrUTYpT5ZY7EdQ9GV4vsm08A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CA95497;
	Mon, 10 Nov 2025 02:47:54 -0800 (PST)
Received: from [10.57.39.147] (unknown [10.57.39.147])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 183443F66E;
	Mon, 10 Nov 2025 02:47:53 -0800 (PST)
Message-ID: <cc9dc398-b9c5-4bb8-94ad-7e7f3ddd5b4f@arm.com>
Date: Mon, 10 Nov 2025 11:47:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/12] mm: enable lazy_mmu sections to nest
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
 <20251029100909.3381140-8-kevin.brodsky@arm.com>
 <999feffa-5d1d-42e3-bd3a-d949f2a9de9d@arm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <999feffa-5d1d-42e3-bd3a-d949f2a9de9d@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dry64mzxhi7d6m5bm88pqqrps1nrp67b
X-Rspam-User: 
X-Rspamd-Queue-Id: EEA14120010
X-Rspamd-Server: rspam10
X-HE-Tag: 1762771682-762891
X-HE-Meta: U2FsdGVkX1/drEV8d2pC/jApX6LjaXXVuzMXKxxqfUSBNH5AsP3Ny4u1jgAXyDTfLpkRu0QhPUQJMxYnmTvKWL/oas2jrINpwvNrnLCpu3PDZTlYkvMaknzQFK99qjpUt/a1K5EyHTX/stLNLqdhMrdX/4VVVXI9drLK6Ndkpf+9bSiNrL4R1tvLXjKeBguhU0T+J+hpyF9kn8HxpUS/dAoRHdX9nTE6mXunLJtLvS/d4nzVTYrk+MMrS9nUrudkZ0+95RolFGnmBEKjQ11fxW8TKJr74LImbAki2pCEsl0XbS1+/BECR/ytCAIHRDXANpMJ2ellvgxn4CZOHVCPiUtkfzM4R9sugShftDoegFz8BJQ4JjU1YycE/L35AWXxPWdHWOW70MO4+5DmpNHDibZw22G1WeEP4Dr4eEnoxdO8Ixb+L6gjM4YXN79viIFB0ZCl6LjLQHBMmRAj2TuB2VQ/eW/CwjViTdFxvMVOsrzeSFi6WRxZxhGP9SUX6EGdMEbK7ZVeEk1SdeicXj2F/O3zC6H88EpBMfuO+N8QPUmo8XjONNSm9YCgelhjo8zq/OPlYM3dafgn92VnpWhR/dsOwGhadHmRXrYoLF68Z/tK5efoBiSwwPgn21CcIepvA46QNY9VZouZywbmRNMP21yNYTEYKwNFSAyHxfh6hoqDZXiC4sSMMmHI6SFcMo/XLRDPe2p6k1gTVuuUBwBjeCT4lYXV/sRY367ZciDfDIEFJJlvSt6dYaUjOXRfkTmaDsx1G8wPnJPGr1UT3pLeM2jhuacdpDXSR0YoGlFkzVBAjD0NK404ztn68l7qv6tXW1rob7Ay9SQ1kTfzbBL7YQX1AaAcXjx43VfwhsIABPRZYkzbqzSe+7No3nGtEeBpcnSDnosBZW3XRcxLvz+C4VS2knITsYcHeCncIgntORo9dS3XIeap52pxmZgyphzvUwYO3h37oM6DsfI25v7
 a+KODYM/
 Hfm4p7eaaYjW3xVd2B+tshDKPe4PnBjUWrp/3j2e2vfq5HwdsqV3XdUQbQliNHZvmLV8arHjeFzJHY93CkCJYlQ6rOOWhoCBzhoCKP0nFxQ2HxvlllxnvX9l59p0IOprd/I4/AWM1txVlcdqPcf29Gg8MprGvYfZ/oj4A8sK296rcPPDVQZTGUg1x8Lk8+GV6v9riNgOd7lAcumZeVQ2ZkESQVhD64tjTHwEY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/11/2025 14:59, Ryan Roberts wrote:
> On 29/10/2025 10:09, Kevin Brodsky wrote:
>> [...]
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index b5fdf32c437f..e6064e00b22d 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -228,27 +228,86 @@ static inline int pmd_dirty(pmd_t pmd)
>>   * of the lazy mode. So the implementation must assume preemption may be enabled
>>   * and cpu migration is possible; it must take steps to be robust against this.
>>   * (In practice, for user PTE updates, the appropriate page table lock(s) are
>> - * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
>> - * and the mode cannot be used in interrupt context.
>> + * held, but for kernel PTE updates, no lock is held). The mode cannot be used
>> + * in interrupt context.
> "The mode cannot be used in interrupt context"; except it is for arm64. KFENCE
> and/or DEBUG_PAGEALLOC will request the arch to change linear map permissions,
> which will enter lazy mmu (now using the new generic API). This can happen in
> softirq context.

Are you happy with the wording update in patch 12?

>> + *
>> + * The lazy MMU mode is enabled for a given block of code using:
>> + *
>> + *   lazy_mmu_mode_enable();
>> + *   <code>
>> + *   lazy_mmu_mode_disable();
>> + *
>> + * Nesting is permitted: <code> may itself use an enable()/disable() pair.
>> + * A nested call to enable() has no functional effect; however disable() causes
>> + * any batched architectural state to be flushed regardless of nesting. After a
>> + * call to disable(), the caller can therefore rely on all previous page table
>> + * modifications to have taken effect, but the lazy MMU mode may still be
>> + * enabled.
>> + *
>> + * In certain cases, it may be desirable to temporarily pause the lazy MMU mode.
>> + * This can be done using:
>> + *
>> + *   lazy_mmu_mode_pause();
>> + *   <code>
>> + *   lazy_mmu_mode_resume();
>> + *
>> + * This sequence must only be used if the lazy MMU mode is already enabled.
>> + * pause() ensures that the mode is exited regardless of the nesting level;
>> + * resume() re-enters the mode at the same nesting level. <code> must not modify
>> + * the lazy MMU state (i.e. it must not call any of the lazy_mmu_mode_*
>> + * helpers).
>> + *
>> + * in_lazy_mmu_mode() can be used to check whether the lazy MMU mode is
>> + * currently enabled.
>>   */
> Nice documentation!

Thanks!

>>  #ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>>  static inline void lazy_mmu_mode_enable(void)
>>  {
>> -	arch_enter_lazy_mmu_mode();
>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>> +
>> +	VM_WARN_ON_ONCE(state->nesting_level == U8_MAX);
>> +	/* enable() must not be called while paused */
>> +	VM_WARN_ON(state->nesting_level > 0 && !state->active);
>> +
>> +	if (state->nesting_level++ == 0) {
> Hmm... for the arm64 case of calling this in an interrupt, Is it safe?
>
> If a task is calling this function and gets interrupted here, nesting_level==1
> but active==false. The interrupt then calls this function and increments from 1
> to 2 but arch_enter_lazy_mmu_mode() hasn't been called.
>
> More dangerously (I think), when the interrupt handler calls
> lazy_mmu_mode_disable(), it will end up calling arch_flush_lazy_mmu_mode() which
> could be an issue because as far as the arch is concerned, it's not in lazy mode.
>
> The current arm64 implementation works because setting and clearing the thread
> flags is atomic.
>
> Perhaps you need to disable preemption around the if block?

As you found out this is addressed in patch 12, but indeed I hadn't
realised that this patch leaves the generic API in an unsafe situation
w.r.t. interrupts. We at least need to have in_interrupt() checks in the
generic layer by the time we get to this patch.

>> +		state->active = true;
>> +		arch_enter_lazy_mmu_mode();
>> +	}
>>  }
>>  
>>  static inline void lazy_mmu_mode_disable(void)
>>  {
>> -	arch_leave_lazy_mmu_mode();
>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>> +
>> +	VM_WARN_ON_ONCE(state->nesting_level == 0);
>> +	VM_WARN_ON(!state->active);
>> +
>> +	if (--state->nesting_level == 0) {
>> +		state->active = false;
>> +		arch_leave_lazy_mmu_mode();
>> +	} else {
>> +		/* Exiting a nested section */
>> +		arch_flush_lazy_mmu_mode();
>> +	}
>>  }
>>  
>>  static inline void lazy_mmu_mode_pause(void)
>>  {
>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>> +
>> +	VM_WARN_ON(state->nesting_level == 0 || !state->active);
> nit: do you need the first condition? I think when nesting_level==0, we expect
> to be !active?

I suppose this should never happen indeed - I was just being extra
defensive.

Either way David suggested allowing pause()/resume() to be called
outside of any section so the next version will bail out on
nesting_level == 0.

>> +
>> +	state->active = false;
>>  	arch_leave_lazy_mmu_mode();
>>  }
>>  
>>  static inline void lazy_mmu_mode_resume(void)
>>  {
>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>> +
>> +	VM_WARN_ON(state->nesting_level == 0 || state->active);
> Similar argument?
>
>> +
>> +	state->active = true;
>>  	arch_enter_lazy_mmu_mode();
>>  }
>>  #else
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index cbb7340c5866..11566d973f42 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1441,6 +1441,10 @@ struct task_struct {
>>  
>>  	struct page_frag		task_frag;
>>  
>> +#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>> +	struct lazy_mmu_state		lazy_mmu_state;
>> +#endif
>> +
>>  #ifdef CONFIG_TASK_DELAY_ACCT
>>  	struct task_delay_info		*delays;
>>  #endif
>> @@ -1724,6 +1728,18 @@ static inline char task_state_to_char(struct task_struct *tsk)
>>  	return task_index_to_char(task_state_index(tsk));
>>  }
>>  
>> +#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>> +static inline bool in_lazy_mmu_mode(void)
>> +{
>> +	return current->lazy_mmu_state.active;
>> +}
>> +#else
>> +static inline bool in_lazy_mmu_mode(void)
>> +{
>> +	return false;
> Just pointing out that this isn't really a correct implementation:
>
> lazy_mmu_mode_enable()
> ASSERT(in_lazy_mmu_mode()) << triggers for arches without lazy mmu
> lazy_mmu_mode_disable()
>
> Although it probably doesn't matter in practice?

I'd say that the expectation is invalid - lazy MMU mode can only be
enabled if the architecture supports it. In fact as you pointed out
above the API may be called in interrupt context but it will have no
effect, so this sequence would always fail in interrupt context.

Worth nothing that in_lazy_mmu_mode() is only ever called from arch code
where lazy MMU is implemented. I added the fallback as a matter of
principle, but it isn't actually required.

- Kevin

