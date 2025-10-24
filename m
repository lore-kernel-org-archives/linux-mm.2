Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37D27CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 12:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BEEE8E0086; Fri, 24 Oct 2025 08:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F538E0042; Fri, 24 Oct 2025 08:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65F5E8E0086; Fri, 24 Oct 2025 08:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51BA68E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:16:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E18318853D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:16:47 +0000 (UTC)
X-FDA: 84032906454.30.FEEE50B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 251A3A000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:16:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761308205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uP/rxN2bRwMLh2GALLbrzV+vL7uIUOOM5XeCDOOe+d0=;
	b=PxcviZ8ZNdNjAXSTnzKoO1m1YAYbUexGd6KcM2TQW+VIEoRlxAbELGo1zhxKhdni9QMMg+
	AaAkOTY+bW3gFqLH0lU6+UhoJ9htMGGAaKdcEmjODFv9Tgb4ilIf6jv9BCBRYajXN+kA91
	t6YWuxaWMC+hOtzvvKbaaWe1xO2Ud+Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761308205; a=rsa-sha256;
	cv=none;
	b=0i93o6vgzei5uYf6SKwJAYvm7abKvGiJSaagWQX2MZq4+TeswB1HlqBegVnoPKPDClPd9R
	O0evXxPVrX9qg2agwK1PGx5UG8Mi1pR5wQK7PuvetdIyxTKkw4j4Lqs9KUBVs3wdaRTvrq
	IgN0m1Pi4haSW8Zw5Zow35g1tmINF68=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73CC91515;
	Fri, 24 Oct 2025 05:16:36 -0700 (PDT)
Received: from [10.44.160.74] (e126510-lin.lund.arm.com [10.44.160.74])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E88963F66E;
	Fri, 24 Oct 2025 05:16:36 -0700 (PDT)
Message-ID: <7a4e136b-66a5-4244-ab07-f0bcc3a26a83@arm.com>
Date: Fri, 24 Oct 2025 14:16:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/13] mm: enable lazy_mmu sections to nest
To: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-8-kevin.brodsky@arm.com>
 <2073294c-8003-451a-93e0-9aab81de4d22@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <2073294c-8003-451a-93e0-9aab81de4d22@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 251A3A000A
X-Stat-Signature: k653mksca3yjufzj64sm9bkcpau4m8px
X-Rspam-User: 
X-HE-Tag: 1761308204-897758
X-HE-Meta: U2FsdGVkX1+cotwPvjpnw6S0PERQnR557JO2shnvR2TQagBTO5+J8VifJfbhaTR3dZTOVQ5uhOAnrPzFOyCm7pzI+l7qMyS6Ks2TfJ3eKrziTn7Ja8cE7CmJ4GzlB3vXOh8N9Xb+liKLDuYfsvqXCIud0MVnVzkxxXYYcnFqTBM7idmwYDcWnu9bHucPAq4llDTc8ev/FpeedPHX0nCBWs9ulYKIYHOQUBntR7jtEiszpclGDwgjYEa8oYe97Z6MvLIo6lHbjTgsaJe9rcqnnIiCMojo+PMxk+sYaDWy8dPgKeLpog1Pxl+a50qApQhTuarc3zqUqBj8sVUkEeK6slHHK/t/pkGDmME66ztfRBVyJ7XPNsLQMwMKe627pnbul5Nasto9iqADBVwTWUnV0mwMBuvTHs5kDT2lvmSg/XdJrhOcv8swHCXKKwBSGpEGO69gFeeObglyyfxGWTwkupoUhKGVuXMsbvm+JSYdxbLE7z32S9d/G6UNPmy3lNo1OAj5bM1XdMBzBd/Xt6LY2jaDwbO6pn/lFQb/yatJY5Nx9oKidP3DhcaemH/bRNWvtDrlTTiOiuYiusg947aU0a16yOBQukYIZz9bxzU4EeUpagDDYc2PM41NNyH7yloCDVP+mjLz6QEhlLt9xrANIT/oqsEnZ4/YFWDSKZrBfTkOA20iHS/3uxJ8vw9VjEdomAgcNDjv0rYlO1WiGRi6DyifYI6b1CySPDA9/wZu83Oc/0TsH1oxn/bmMbX/F3xvAiSQosxjeptq+29ZHq2C3iG8O0Ku2xip1TruB7kY3GXvDl/k8eGAv9C5AnToSTb8/uX4GtulfhwT151BJmeT/nxswpUCGmLcY32Sun58EDdSZDCgQzW+0GHzBxxBdTD99GdGzciQANlniJCQn6nMf6UMdwLp1BUsDt4SPS4bohe9c1DZArWVIVSyI0hRUW89fYVlky8T/RUIKwdPROS
 keZUiaVs
 NGiTlB1qVczRdOJnpMlapeMBnIyDHAsNgU9rzEuuVg38APNf1tYDE3+VkxeD5CPFaTIqCdlDVVM+97Cs+O8qh/cZcvMl/sO434WwlxWfGqFEn8Di0mOCTUS6c6X8oR5iVxJozrvzEQB4YekBt7JwNAxtlw0yRT2mE9n4To6ieWhgFUIrU4np/sloZECAAZ7MT+XyNbym8jPPwrPTIbcjGxNunGWbVDgtoevoQ25bQ1DF8iPKEXjbXR5zX8ZMJojxZgIXA6oxlapAtnW4Z4G7fo4B8bNYbxFMUIksHhxXDk/11J0Xk4bZiOM6TWFhSj/Z03uuqycshdxFRuayenVMArA74IL9ZNhw06Jp7B2HyGj4LHN8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/10/2025 22:00, David Hildenbrand wrote:
> [...]
>
>
>>
>> In summary (count/enabled represent the values *after* the call):
>>
>> lazy_mmu_mode_enable()        -> arch_enter()        count=1 enabled=1
>>      lazy_mmu_mode_enable()    -> ø            count=2 enabled=1
>>     lazy_mmu_mode_pause()    -> arch_leave()     count=2 enabled=0
>
> The arch_leave..() is expected to do a flush itself, correct?

Correct, that's unchanged.

>
>>     lazy_mmu_mode_resume()    -> arch_enter()     count=2 enabled=1
>>      lazy_mmu_mode_disable()    -> arch_flush()     count=1 enabled=1
>> lazy_mmu_mode_disable()        -> arch_leave()     count=0 enabled=0
>>
>> Note: in_lazy_mmu_mode() is added to <linux/sched.h> to allow arch
>> headers included by <linux/pgtable.h> to use it.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>> Alexander Gordeev suggested that a future optimisation may need
>> lazy_mmu_mode_{pause,resume}() to call distinct arch callbacks [1]. For
>> now arch_{leave,enter}() are called directly, but introducing new arch
>> callbacks should be straightforward.
>>
>> [1]
>> https://lore.kernel.org/all/5a0818bb-75d4-47df-925c-0102f7d598f4-agordeev@linux.ibm.com/
>> ---
>
> [...]
>
>>   +struct lazy_mmu_state {
>> +    u8 count;
>
> I would have called this "enabled_count" or "nesting_level".

Might as well be explicit and say nesting_level, yes :)

>
>> +    bool enabled;
>
> "enabled" is a bit confusing when we have lazy_mmu_mode_enable().

Agreed, hadn't realised that.

> I'd have called this "active".

Sounds good, that also matches batch->active on powerpc/sparc.

>
>> +};
>> +
>>   #endif /* _LINUX_MM_TYPES_TASK_H */
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index 194b2c3e7576..269225a733de 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -228,28 +228,89 @@ static inline int pmd_dirty(pmd_t pmd)
>>    * of the lazy mode. So the implementation must assume preemption
>> may be enabled
>>    * and cpu migration is possible; it must take steps to be robust
>> against this.
>>    * (In practice, for user PTE updates, the appropriate page table
>> lock(s) are
>> - * held, but for kernel PTE updates, no lock is held). Nesting is
>> not permitted
>> - * and the mode cannot be used in interrupt context.
>> + * held, but for kernel PTE updates, no lock is held). The mode
>> cannot be used
>> + * in interrupt context.
>> + *
>> + * The lazy MMU mode is enabled for a given block of code using:
>> + *
>> + *   lazy_mmu_mode_enable();
>> + *   <code>
>> + *   lazy_mmu_mode_disable();
>> + *
>> + * Nesting is permitted: <code> may itself use an enable()/disable()
>> pair.
>> + * A nested call to enable() has no functional effect; however
>> disable() causes
>> + * any batched architectural state to be flushed regardless of
>> nesting. After a
>> + * call to disable(), the caller can therefore rely on all previous
>> page table
>> + * modifications to have taken effect, but the lazy MMU mode may
>> still be
>> + * enabled.
>> + *
>> + * In certain cases, it may be desirable to temporarily pause the
>> lazy MMU mode.
>> + * This can be done using:
>> + *
>> + *   lazy_mmu_mode_pause();
>> + *   <code>
>> + *   lazy_mmu_mode_resume();
>> + *
>> + * This sequence must only be used if the lazy MMU mode is already
>> enabled.
>> + * pause() ensures that the mode is exited regardless of the nesting
>> level;
>> + * resume() re-enters the mode at the same nesting level. <code>
>> must not modify
>> + * the lazy MMU state (i.e. it must not call any of the lazy_mmu_mode_*
>> + * helpers).
>> + *
>> + * in_lazy_mmu_mode() can be used to check whether the lazy MMU mode is
>> + * currently enabled.
>>    */
>>   #ifdef CONFIG_ARCH_LAZY_MMU
>>   static inline void lazy_mmu_mode_enable(void)
>>   {
>> -    arch_enter_lazy_mmu_mode();
>> +    struct lazy_mmu_state *state = &current->lazy_mmu_state;
>> +
>> +    VM_BUG_ON(state->count == U8_MAX);
>
> No VM_BUG_ON() please.

I did wonder if this would be acceptable!

What should we do in case of underflow/overflow then? Saturate or just
let it wrap around? If an overflow occurs we're probably in some
infinite recursion and we'll crash anyway, but an underflow is likely
due to a double disable() and saturating would probably allow to recover.

>
>> +    /* enable() must not be called while paused */
>> +    VM_WARN_ON(state->count > 0 && !state->enabled);
>> +
>> +    if (state->count == 0) {
>> +        arch_enter_lazy_mmu_mode();
>> +        state->enabled = true;
>> +    }
>> +    ++state->count;
>
> Can do
>
> if (state->count++ == 0) {

My idea here was to have exactly the reverse order between enable() and
disable(), so that arch_enter() is called before lazy_mmu_state is
updated, and arch_leave() afterwards. arch_* probably shouldn't rely on
this (or care), but I liked the symmetry.

>
>>   }
>>     static inline void lazy_mmu_mode_disable(void)
>>   {
>> -    arch_leave_lazy_mmu_mode();
>> +    struct lazy_mmu_state *state = &current->lazy_mmu_state;
>> +
>> +    VM_BUG_ON(state->count == 0);
>
> Dito.
>
>> +    VM_WARN_ON(!state->enabled);
>> +
>> +    --state->count;
>> +    if (state->count == 0) {
>
> Can do
>
> if (--state->count == 0) {
>
>> +        state->enabled = false;
>> +        arch_leave_lazy_mmu_mode();
>> +    } else {
>> +        /* Exiting a nested section */
>> +        arch_flush_lazy_mmu_mode();
>> +    }
>>   }
>>     static inline void lazy_mmu_mode_pause(void)
>>   {
>> +    struct lazy_mmu_state *state = &current->lazy_mmu_state;
>> +
>> +    VM_WARN_ON(state->count == 0 || !state->enabled);
>> +
>> +    state->enabled = false;
>>       arch_leave_lazy_mmu_mode();
>>   }
>>     static inline void lazy_mmu_mode_resume(void)
>>   {
>> +    struct lazy_mmu_state *state = &current->lazy_mmu_state;
>> +
>> +    VM_WARN_ON(state->count == 0 || state->enabled);
>> +
>>       arch_enter_lazy_mmu_mode();
>> +    state->enabled = true;
>>   }
>>   #else
>>   static inline void lazy_mmu_mode_enable(void) {}
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index cbb7340c5866..2862d8bf2160 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1441,6 +1441,10 @@ struct task_struct {
>>         struct page_frag        task_frag;
>>   +#ifdef CONFIG_ARCH_LAZY_MMU
>> +    struct lazy_mmu_state        lazy_mmu_state;
>> +#endif
>> +
>>   #ifdef CONFIG_TASK_DELAY_ACCT
>>       struct task_delay_info        *delays;
>>   #endif
>> @@ -1724,6 +1728,18 @@ static inline char task_state_to_char(struct
>> task_struct *tsk)
>>       return task_index_to_char(task_state_index(tsk));
>>   }
>>   +#ifdef CONFIG_ARCH_LAZY_MMU
>> +static inline bool in_lazy_mmu_mode(void)
>
> So these functions will reveal the actual arch state, not whether
> _enabled() was called.
>
> As I can see in later patches, in interrupt context they are also
> return "not in lazy mmu mode". 

Yes - the idea is that a task is in lazy MMU mode if it enabled it and
is in process context. The mode is never enabled in interrupt context.
This has always been the intention, but it wasn't formalised until patch
12 (except on arm64).

- Kevin

