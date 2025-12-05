Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D9BD2F7EE
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 12:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADAC26B014C; Fri,  5 Dec 2025 07:50:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2DA6B0150; Fri,  5 Dec 2025 07:50:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF0E6B0152; Fri,  5 Dec 2025 07:50:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8C3186B014C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:50:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E17F89A33
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:50:53 +0000 (UTC)
X-FDA: 84185401986.23.4F651F0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7B057A0006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:50:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764939051; a=rsa-sha256;
	cv=none;
	b=N6Gcwp+zR3LIP1Kg9i6M7ifNKykKX+Gta+ic6r0BZtZcruFrzsM3xJ7Lvh6v9eyljpw/++
	XHzkeMYuUGz0p6n4eT5FRb9Nb/S64mnqD+1MslkevDDk3LTQyvMnEKvVuDGzZuLpQbclOE
	qnoJmSIFpE+OWbvq/npdXQ05EIPsT+0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764939051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j4UjFMdcuPchwkA3lmeDso5ij/iOMhTFMDd348T6uyc=;
	b=LeWcI+W5v86rdrIwiY57MLW7KfNH6J63pLsNizZcXZ7ommb0ivjMVs3/LFWvkiqvXdaUdN
	jAS5csRrqVOxcDh5dXWJkLpIlUtjVTWAJAOK3ZCTWLyMDX7G4O/gdNDmlUQ7KiA53JKYub
	aSrqUCHYUvze5kOLbU9Fd0epbqgNcNI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02DB31063;
	Fri,  5 Dec 2025 04:50:43 -0800 (PST)
Received: from [10.44.160.68] (e126510-lin.lund.arm.com [10.44.160.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02CD63F86F;
	Fri,  5 Dec 2025 04:50:42 -0800 (PST)
Message-ID: <093f814e-ce49-43c9-951b-b0d0ef583cea@arm.com>
Date: Fri, 5 Dec 2025 13:50:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] mm: enable lazy_mmu sections to nest
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-9-kevin.brodsky@arm.com>
 <2dfd54d7-fe2a-4921-85ff-a581392a777a@arm.com>
 <93d04ef8-0364-4013-8839-ba599d930cb2@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <93d04ef8-0364-4013-8839-ba599d930cb2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7B057A0006
X-Stat-Signature: hzsnw4capqhtddkdhbux3exzzy8kfiqs
X-Rspam-User: 
X-HE-Tag: 1764939051-497722
X-HE-Meta: U2FsdGVkX187zhNuXfxqwW1MQL82KddGBd5ukZI8rwgMHf4dCUcXHyGU5DwHgxgq621RH/M50VQh8/bs3ac/K5YgQR9fidDnOQHoLBfg1DgoBpDOzaHkpc/38rl+bWxMWk+NVrtwi9iCAVHL7GuouMYiAS8ecIMEz2w/LlXAB/qrOx+7JqUf89+vDK2IFN0bWUCgahf05X/Jaaad0AZXdaOHTiiuXakCv7pus3a1nreqO2qegchsJXFOtyAwbO+PIhkV1rRstcwjBnD+YiE3wkUbZQA0IZq65YDSugL6UG83L/lZcC+a5s1G2zz97IwlxtW0oVo/oBSTx5BTFsyImGdnDIgAL+Lodwr3uKnxFDKJ/sR2OsG/q0/ZtDyDC0IS6mPmvWcbfq1L94zW5jvXbNdAAi6h1JhUrX+XBeryksJnqZA7/xUcBV0QmWqX5tc5dYfW0f2Qtog1L58wXUWSSzaSCxO+XjMnnsw6yIeE8/Osx9Y5fgSFE3WtXPU2SgOsei2J3fG0B7Y9tuoB2VDlqjPlMPs9nNGHgb008WbopKnGO3D+HqlosER8WjLUxDbolV4gmewohTRMHku7XyM5MXzZkj77z4w1hoq4ADjwqkct87Fu6RDehQ40HiQhE7kSHnECFDLeeo8vcDISHVQ8zh8RnW/0MFX5O7ysUVYGzLiGGqoOZZ/PLOgjVm28tNY0ARhghwJB5tBTuHhGsFDuwhGUlCiGFf16C2bOioPeptiLuSyRrAJFMHPDSnDgmlOq37eQikBlW0QifeEx7EdAPuJWp1IWyVwcPQZCTY15JOkay2bRjWxOODr0ULQ5a4Qj43tTCYFm6/qipgJ8gRHOQm6JBSgpEKjg83F85lBQcHxwCKdNT0V+d1qGcxz3RGKjX+mdYXiBZuHAk5xyAieeAA8YRdHDfO+tUbrK4qPa+DM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/12/2025 12:52, David Hildenbrand (Red Hat) wrote:
> Some comments from my side:
>
>
>>>   static inline void arch_enter_lazy_mmu_mode(void)
>>>   {
>>> -    /*
>>> -     * lazy_mmu_mode is not supposed to permit nesting. But in
>>> practice this
>>> -     * does happen with CONFIG_DEBUG_PAGEALLOC, where a page
>>> allocation
>>> -     * inside a lazy_mmu_mode section (such as zap_pte_range())
>>> will change
>>> -     * permissions on the linear map with apply_to_page_range(), which
>>> -     * re-enters lazy_mmu_mode. So we tolerate nesting in our
>>> -     * implementation. The first call to arch_leave_lazy_mmu_mode()
>>> will
>>> -     * flush and clear the flag such that the remainder of the work
>>> in the
>>> -     * outer nest behaves as if outside of lazy mmu mode. This is
>>> safe and
>>> -     * keeps tracking simple.
>>> -     */
>>> -
>>>       set_thread_flag(TIF_LAZY_MMU);>  }
>>
>> Should not platform specific changes be deferred to subsequent
>> patches until
>> nesting is completely enabled in generic first ? Although no problem
>> as such
>> but would be bit cleaner.
>
> This could indeed be done in a separate patch. But I also don't see a
> problem with updating the doc in this patch.

I think it is consistent to remove that comment in this patch, since
nesting is fully supported from this patch onwards. Subsequent patches
are cleanups/optimisations that aren't functionally required.

Patch 7 takes the same approach: add handling in the generic layer,
remove anything now superfluous from arm64.

>
>>
>>>   diff --git a/include/linux/mm_types_task.h
>>> b/include/linux/mm_types_task.h
>>> index a82aa80c0ba4..11bf319d78ec 100644
>>> --- a/include/linux/mm_types_task.h
>>> +++ b/include/linux/mm_types_task.h
>>> @@ -88,4 +88,9 @@ struct tlbflush_unmap_batch {
>>>   #endif
>>>   };
>>>   +struct lazy_mmu_state {
>>> +    u8 enable_count;
>>> +    u8 pause_count;
>>> +};
>>> +
>>
>> Should not this be wrapped with CONFIG_ARCH_HAS_LAZY_MMU_MODE as the
>> task_struct
>> element 'lazy_mmu_state' is only available with the feature.
>
> No strong opinion; the compiler will ignore it either way. And less
> ifdef is good, right? :)
>
> ... and there is nothing magical in there that would result in other
> dependencies. 

Agreed, #ifdef'ing types should only be done if necessary.

>
>> Besides, is a depth
>> of 256 really expected here ? 4 bits for each element would not be
>> sufficient for
>> a depth of 16 ?
>
>
> We could indeed use something like
>
> struct lazy_mmu_state {
>     u8 enable_count : 4;
>     u8 pause_count : 4;
> };
>
> but then, the individual operations on enable_count/pause_count need
> more instructions.

Indeed.

>
> Further, as discussed, this 1 additional byte barely matters given the
> existing size of the task struct.

In fact it would almost certainly make no difference (depending on
randomized_struct) since almost all members in task_struct have an
alignment of at least 2.

>
> [...]
>
>>> +/**
>>> + * lazy_mmu_mode_pause() - Resume the lazy MMU mode.
>>> + *
>>> + * Resumes the lazy MMU mode; if it was active at the point where
>>> the matching
>>> + * call to lazy_mmu_mode_pause() was made, re-enables it and calls
>>> + * arch_enter_lazy_mmu_mode().
>>> + *
>>> + * Must match a call to lazy_mmu_mode_pause().
>>> + *
>>> + * Has no effect if called:
>>> + * - While paused (inside another pause()/resume() pair)
>>> + * - In interrupt context
>>> + */
>>>   static inline void lazy_mmu_mode_resume(void)
>>>   {
>>> +    struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>> +
>>>       if (in_interrupt())
>>>           return;
>>>   -    arch_enter_lazy_mmu_mode();
>>> +    VM_WARN_ON_ONCE(state->pause_count == 0);
>>> +
>>> +    if (--state->pause_count == 0 && state->enable_count > 0)
>>> +        arch_enter_lazy_mmu_mode();
>>>   }
>>
>> Should not state->pause/enable_count tests and increment/decrement be
>> handled
>> inside include/linux/sched via helpers like in_lazy_mmu_mode() ? This
>> is will
>> ensure cleaner abstraction with respect to task_struct.
>
> I don't think this is required given that this code here implements
> CONFIG_ARCH_HAS_LAZY_MMU_MODE support.

Agreed, in fact I'd rather not expose helpers that should only be used
in the lazy_mmu implementation itself.

- Kevin

