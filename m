Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F040BD1F9CD
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 11:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15DB26B0007; Thu,  4 Dec 2025 06:52:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E906B0023; Thu,  4 Dec 2025 06:52:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F3D6B0024; Thu,  4 Dec 2025 06:52:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DEA536B0007
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:52:50 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDE2ABC3F4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:52:48 +0000 (UTC)
X-FDA: 84181626816.25.D9620BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 18FE780002
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:52:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ISfT7eeA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764849167; a=rsa-sha256;
	cv=none;
	b=Uyrwv7wX/FAJo3iumZwhgRA5XuwQp61T8uPuQo/48QCfppNU/TCP/SItNXH/Piyhfxi9Ky
	w78e3x7RXVQ07pY8j1+ZUHr0bVTD8kou1VjaayCwRA6ji2DZMWdSwYSGi+F9LQf/TY5fgv
	3ueuxovf9Gr59DEfqx9dI0+K8epEgQU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ISfT7eeA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764849167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/D90w5HbPCz2bt7xnv+mJ1PnVxBYxNP9wTE7H670eFI=;
	b=w3JVCy6+cW6+kDMqbFFsp5kEF3p5+Wm2RIP2PsMS3768zzxzcVXPP1hpefA6B7MEaBscnh
	YUw1aw43h1UQQ4mf9KV7yaoA5dgl2itlgcxO6HoOvsxe79Uz35yu7zu/A9MdXma+oPs6Ej
	BE735QHZfUKRA5r27pNaU7ma26EN2Dc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE65D404ED;
	Thu,  4 Dec 2025 11:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68460C4CEFB;
	Thu,  4 Dec 2025 11:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764849165;
	bh=u1Zp6G/Tnzzf/H5X3ENLn84JA+wr9i7r3UFkx+PY1cA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ISfT7eeAMaUkykWFftAF34p60f1XrKRSCDcOgF5EQ7sjgQQQ6kR+ZfcxZf3nREGvz
	 3ImEd584csKzW2sprI2y59/eBKWA2YlWw7s0K9vR4XEpOPMmlPP8wvttqFfXSE4zN6
	 oekU1nlMo+H/Bg6n4zYp/bTOGvrxv/gOpiDiNlxCA9Y4OE+4DDcmSt+S8/kIsT/ev5
	 Uux8ESGp7F4HLNoZUmXHGJYu5mcFtULBpaUzDu9+oyUtKeFcenBNNa96Vy0OfGm27t
	 Z0EcKxK9WF0aNa8nPuC5BwJT+8bBhjdQ74Oz3kptWtnS35Y+COG+101Ok84TWX356P
	 FasrAKF5f+8MA==
Message-ID: <93d04ef8-0364-4013-8839-ba599d930cb2@kernel.org>
Date: Thu, 4 Dec 2025 12:52:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] mm: enable lazy_mmu sections to nest
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <2dfd54d7-fe2a-4921-85ff-a581392a777a@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 18FE780002
X-Stat-Signature: ots3och4z3p3yf9ut6djbddzjwgz5zu7
X-Rspam-User: 
X-HE-Tag: 1764849166-185693
X-HE-Meta: U2FsdGVkX1+mHDnhZNzQLNYO/BCrDfdqzZ8zJM5uKi389mfEYLEJ1DyBZUFMP8loSGw4Hvo4p4KlWOYhFMbkLrT4eiUsSNmsqrlavdBDDYOromNfi6CcapXh7yr70R+F1bEOrxnXUOZrlGGZgyyXnnd0kvSxvCi4LcQlJgoPAi6Zn3rOinn+GEHsUva6w6rOoBm6S+itdzX8q/RHPfoZ5vOkYbk9YonxHC+zRe5vj9Bu4HHvt+Q12qorMdUfKFYsSDlSKu7r29pqFs9qLDjLLesDDhN0YIycNHpOGG+NWpA+d8ZkTnbaQXscgaEXSgopsPSPS8f2+PenryTalqN6kF3mxhr50++leVJANbnUXBJ2JWh2BAzj5iRV3gJNw1uDs3dxX7b9r4AAQDHnEBAieuwGMtB64hU0W8a0R8SpuHoEUaZjSYi2hwr3V1B312mD49QHaUYcXAYruVmYcqNbtwdKGfXk/TqF4KXcG5d2UKb5Q73mIabktmG4+ujeyh4ImHrkgxL1O491I1Wiq/Q03czKfJ2ogobdbZ98K/RgS+hA2UWQzteVTAMq01I3uhpZIg/2pvtzbE6wvvgTrhjyofmrMl+lv/h8d5E3u4SXLLrqfV73adPlV805cCxLK3/mblDPq1v/wcEFJKRBdssIXon6cqzjzBMVdgaMln3S1U3Yy5WL5otuCugtytvEbZcDXdLHT8XNHbUwTA4x4FlMnxNllLbPsHTL0h9a9gth7YF3sNRI7mqgRcUv8Jj2SudLRUO5rK5taMtRforo7hw2g/zGAf6+C59xklT+EFKiYizqbPlpQdtHO5Ig6SvZQt99VOfQNOYu2NRCSONDaMjJFiVGrDL0KgkuhfMLBptP4fUfQvVDYCN4/GKXmwpuotAUiYvWr0l61DvVjN5P8V6ri+GfAk6QlBCJWtfDM15wloRDKMnc//chcUHZFopg+8TMJa08Das/Vg/fNMbaVfu
 VtXnM8sJ
 4o/seRouKzgLZt5+w2dFGaq4X7JSYXjNTXUpZA5WNZb9Jj//nFGNABdLLEhhGx7f4S1JJlFkmn0iGVHgxTSLbEfj+S+XC2/YeCvz02a1dj4v6dOOnnLZIzFLjicWuEZn1+iwxy9V6ZY+Q5zF5SneW11Jj/RbCT4Hq86k+IxzqTlY3ZvgSrwxpH5E+TJvfvqqYEJM5IKxj9tPGVfCuhFU/sCmbfVUtUBdycld0RIDJn4QMFiTvkR+S8UtwZKcMHNUlYEhFiCbk1vz3+J+3tmW/BQpKOpxoRRevtptpjgMCjoc5pwBmgrGH+sQvHE8GEPCXTzGp3eYIK8CywwbY5oZ1Ev5e2LYUe0TT8Z6FpzR0h2+KzLPgroGz9j4/42oxGJYvJ7Zw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some comments from my side:


>>   static inline void arch_enter_lazy_mmu_mode(void)
>>   {
>> -	/*
>> -	 * lazy_mmu_mode is not supposed to permit nesting. But in practice this
>> -	 * does happen with CONFIG_DEBUG_PAGEALLOC, where a page allocation
>> -	 * inside a lazy_mmu_mode section (such as zap_pte_range()) will change
>> -	 * permissions on the linear map with apply_to_page_range(), which
>> -	 * re-enters lazy_mmu_mode. So we tolerate nesting in our
>> -	 * implementation. The first call to arch_leave_lazy_mmu_mode() will
>> -	 * flush and clear the flag such that the remainder of the work in the
>> -	 * outer nest behaves as if outside of lazy mmu mode. This is safe and
>> -	 * keeps tracking simple.
>> -	 */
>> -
>>   	set_thread_flag(TIF_LAZY_MMU);>  }
> 
> Should not platform specific changes be deferred to subsequent patches until
> nesting is completely enabled in generic first ? Although no problem as such
> but would be bit cleaner.

This could indeed be done in a separate patch. But I also don't see a 
problem with updating the doc in this patch.

> 
>>   
>> diff --git a/include/linux/mm_types_task.h b/include/linux/mm_types_task.h
>> index a82aa80c0ba4..11bf319d78ec 100644
>> --- a/include/linux/mm_types_task.h
>> +++ b/include/linux/mm_types_task.h
>> @@ -88,4 +88,9 @@ struct tlbflush_unmap_batch {
>>   #endif
>>   };
>>   
>> +struct lazy_mmu_state {
>> +	u8 enable_count;
>> +	u8 pause_count;
>> +};
>> +
> 
> Should not this be wrapped with CONFIG_ARCH_HAS_LAZY_MMU_MODE as the task_struct
> element 'lazy_mmu_state' is only available with the feature.

No strong opinion; the compiler will ignore it either way. And less 
ifdef is good, right? :)

... and there is nothing magical in there that would result in other 
dependencies.

> Besides, is a depth
> of 256 really expected here ? 4 bits for each element would not be sufficient for
> a depth of 16 ?


We could indeed use something like

struct lazy_mmu_state {
	u8 enable_count : 4;
	u8 pause_count : 4;
};

but then, the individual operations on enable_count/pause_count need 
more instructions.

Further, as discussed, this 1 additional byte barely matters given the 
existing size of the task struct.

No strong opinion.

> 
>>    */
>>   #ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>> +/**
>> + * lazy_mmu_mode_enable() - Enable the lazy MMU mode.
>> + *
>> + * Enters a new lazy MMU mode section; if the mode was not already enabled,
>> + * enables it and calls arch_enter_lazy_mmu_mode().
>> + *
>> + * Must be paired with a call to lazy_mmu_mode_disable().
>> + *
>> + * Has no effect if called:
>> + * - While paused - see lazy_mmu_mode_pause()
>> + * - In interrupt context
>> + */
>>   static inline void lazy_mmu_mode_enable(void)
>>   {
>> -	if (in_interrupt())
>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>> +
>> +	if (in_interrupt() || state->pause_count > 0)
>>   		return;
>>   
>> -	arch_enter_lazy_mmu_mode();
>> +	VM_WARN_ON_ONCE(state->enable_count == U8_MAX);
>> +
>> +	if (state->enable_count++ == 0)
>> +		arch_enter_lazy_mmu_mode();
> 
> When lazy_mmu_mode_enable() gets called for the first time with state->enable_count as 0,
> then arch_enter_lazy_mmu_mode() will not get called ? Bit confused.


state->enable_count++ returns the old value (0). Are you thinking of
++state->enable_count?

But maybe I misudnerstood your concern.

[...]

>> +/**
>> + * lazy_mmu_mode_pause() - Resume the lazy MMU mode.
>> + *
>> + * Resumes the lazy MMU mode; if it was active at the point where the matching
>> + * call to lazy_mmu_mode_pause() was made, re-enables it and calls
>> + * arch_enter_lazy_mmu_mode().
>> + *
>> + * Must match a call to lazy_mmu_mode_pause().
>> + *
>> + * Has no effect if called:
>> + * - While paused (inside another pause()/resume() pair)
>> + * - In interrupt context
>> + */
>>   static inline void lazy_mmu_mode_resume(void)
>>   {
>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>> +
>>   	if (in_interrupt())
>>   		return;
>>   
>> -	arch_enter_lazy_mmu_mode();
>> +	VM_WARN_ON_ONCE(state->pause_count == 0);
>> +
>> +	if (--state->pause_count == 0 && state->enable_count > 0)
>> +		arch_enter_lazy_mmu_mode();
>>   }
> 
> Should not state->pause/enable_count tests and increment/decrement be handled
> inside include/linux/sched via helpers like in_lazy_mmu_mode() ? This is will
> ensure cleaner abstraction with respect to task_struct.

I don't think this is required given that this code here implements
CONFIG_ARCH_HAS_LAZY_MMU_MODE support.

-- 
Cheers

David

