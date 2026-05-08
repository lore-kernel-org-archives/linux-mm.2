Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0507ECD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 09:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 428BC6B012D; Fri,  8 May 2026 05:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9A36B012E; Fri,  8 May 2026 05:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EF166B012F; Fri,  8 May 2026 05:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5F46B012D
	for <linux-mm@kvack.org>; Fri,  8 May 2026 05:30:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C5B771C15C5
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:30:21 +0000 (UTC)
X-FDA: 84743731842.08.D77D391
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id D69182000D
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:30:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pGosNmLK;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778232620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s8DdICLhnj/DfQCudkc982W5x6Y5k2ODjetxBBj7jzQ=;
	b=UerY7MuzdekKnBiM6ODD/xZK4CxwN1lpRmio6YXuCtOQiNC/Ffn7FjopEseUjGDUG8X+O2
	SEbi4DPpiMwpn1aetVbV2MNXvC9odh627BVJZSLDs0DKRSIQoo8DZUcVH69E2aTfWFXL+X
	PJ0FoBoSsL1xJbgGPbzGRBLuePb3Xho=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pGosNmLK;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778232620; a=rsa-sha256;
	cv=none;
	b=cr4fL79gFJY+xGj0sope1NsJN6dmlaErgSmnxZ91ei+qj+nLl6WKwiseDTjq0H4bnDAKZk
	pFaXiR6ivNxCGukF1t6Dyg9Lt277fzHzsE+gmvfthrz175W+ncS9DykPf4Oxm4EYqRQQg7
	Oz2IKuo8F8uPyB9tsa+BgKgETj0OLe8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BF1E1BCA;
	Fri,  8 May 2026 02:30:13 -0700 (PDT)
Received: from [10.57.35.71] (unknown [10.57.35.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74F673F7B4;
	Fri,  8 May 2026 02:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778232618; bh=s8DdICLhnj/DfQCudkc982W5x6Y5k2ODjetxBBj7jzQ=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=pGosNmLKXsFDpqHZ2v4awPO7R4BJLnRLDFG6QTRmbEy3znEuuSjWSCNr806Eg77XW
	 R4Pa91NJ76pjBXYmMgu74Gf4TW14vrW4noSoTnyMABnH9Ok6XcDP2lWnraI7HJAZZR
	 0y//lSeZUixyJS7TWw3LdVRkiS9PDk3gQcxwKXMg=
Message-ID: <f9790dd2-b398-465f-908b-bf1a446f9ff2@arm.com>
Date: Fri, 8 May 2026 11:30:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/xen: Fix lazy mmu handling across context switch
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
 linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, xen-devel@lists.xenproject.org,
 =?UTF-8?Q?Marek_Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
References: <20260508080514.454607-1-jgross@suse.com>
 <5cb54bd1-5981-4a46-9083-f7b527ca342f@suse.com>
 <775a5fd2-394d-4409-81d3-4dc6ef8209f0@arm.com>
Content-Language: en-GB
In-Reply-To: <775a5fd2-394d-4409-81d3-4dc6ef8209f0@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D69182000D
X-Stat-Signature: 9qrdptkppkzqkgdpozssiicrxkpgsbpw
X-HE-Tag: 1778232619-957211
X-HE-Meta: U2FsdGVkX18UsACAtbDgTwK2PL6UriQqqxYGv8tX+hBIyU3U7JI10ucF1Nw5CZP97ri8bLUU3ZJCZadpnRfFGXxmS2ZE9s1jNQGjy8bzqQGmhjmpmhCPDf2UO/AZ0u4ogiAaTlbRB3q8fnGy1SK1SUTmdsUcNh1gFx2v2ZssDtx0ugvwWyE1DiafalJYZ2WQ3iG7tPVIW4ilE3INZyBobcOMLuutOgk+lr2mSj/oi7080UVu0URcx9z8MKyU+AqbiNBIozjLzedzni498W61Y2gkt5XIgvXmiMJ0T3LaFwmpCuKmOAPtiaiMEcII9QCCkxzect2uarHzupNBgDveZZOFF25DmksllIoWWqr02Bvm/CY6L63FBTx7WDbrILjZl9FqT2tmr2D+ptYjJhfREOBBoRGS7xMFwlGCmVCy7h9Zj1JUtL/7xu6BmAJ/xREv3ML9HeduTZBUe1q2aBIiRK3eG4Ab/R4BhdUOQsUkIjzQWfaoiUH+Yl0nw5zlfyCHNW+BlJsW7EsieWZXlL88DkIo+fa8DDsQ6IJTqx8VTpiXzt7xeE+4KeQJEmcLiPazzp1VJcPh39+ZMmSg0+HvPy/nf1AeoFyjPS/V2wkpTvkCYfSEa2XDlrCaWkQKqT94l5iwoX7RBGi7A10x6lBQByGqVABsb4aCmMRG02Wxf5RCg8Mu940vRZio5bQHBq/FW0PP4iH4L20vTPoDqrq2+k1/r0utAg7W4PI427hLrQZE/ek9dZqjLpS+a2T776onAI/djVCPsSGdgJREtpxMK1J0tDQ6KkI0KJrVn5fpKyw1mnrTU10c1/pDODLBVsS54vxTt9D62Whp9E172mMcfYV5ljst1zgWGSPJeOCcKFGCbAyIPtJ+FzSC9TCqw38C/yXD8GBnsRhpcl+PNiAJ9j1/c0ucWWkHj6C9+A9p4GdZhcap95qO0mrMUGMCJnFTbsNjtES91Ek328MoYv1
 0g/4IpUS
 S2KCuPRR81jUqxPbR7JY1IinIg4xep/j3/bU2Z0CrUT2thfPQNXWYx4JGkan0GMZC0DWk8fE2EFS8tZGNuIPwUFraW5mPibnksPOr1WmdnoKYAXf85nRI/xupwx6FtVnDEsXiHykZFXA3+chGxweXuNA7SYyd6vczSGTTWiRnb4rhuTjUK58fcFsN2OQbEQsfrfuRu3y6ukhP3+8WELG5dbq4xTjZ+86Ch5dzZx+jIFM2yMABroWM7kVnXeoosSCxtJRmJPUz9gB5rBjVQ90EYRjdgchkUsNMXpvF1fLfNWGfX3FTqPQj+18SLEtz/MBNmeZVGfOCKqvYVNQqZ1ZCg7knUAZqwf/WuXuY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Marek (the wrong address was in Cc)

On 08/05/2026 11:08, Kevin Brodsky wrote:
> On 08/05/2026 10:33, Jürgen Groß wrote:
>> Please disregard this patch. It isn't fixing the real problem.
> That's what I would expect, see below.
>
>> On 08.05.26 10:05, Juergen Gross wrote:
>>> The recent rework of mmu lazy mode has resulted in problems when
>>> running as a Xen PV guest. Enabling lazy mmu mode for the new context
>>> during context switch is done from the arch_end_context_switch() hook,
>>> but when calling this hook current hasn't been changed yet, so the
>>> lazy mmu mode state of the wrong task is modified.
> Currently xen_end_context_switch() checks if next has lazy MMU mode
> enabled and if so calls arch_enter_lazy_mmu_mode(), i.e.
> enter_lazy(XEN_LAZY_MMU). This does *not* modify any task state, rather
> it writes to the xen_lazy_mode percpu variable.
>
> I've thought about this from various angles when reworking lazy MMU, and
> the conclusion I made is that arch_{start,end}_context_switch() have no
> reason to change any task state. On arm64, for instance, we do nothing
> at all on context switching, since everything lazy MMU-related is
> tracked in task_struct and therefore already switched.
>
> Xen is trickier because it tracks lazy MMU/CPU state in a percpu
> variable, so these hooks do need to do something about it. This is
> entirely Xen-internal though, and there's no reason to be calling
> generic functions like lazy_mmu_mode_pause() that modify task state.
>
> The idea behind commit 291b3abed657 ("x86/xen: use lazy_mmu_state when
> context-switching") is that TIF_LAZY_MMU_UPDATES now duplicates
> lazy_mmu_state in task_struct and we can therefore replace the former
> with the latter. More specifically, the assumption is that
> TIF_LAZY_MMU_UPDATES is set if and only if the task has been scheduled
> out and __task_lazy_mmu_mode_active(task) is true.
>
> Clearly there is something wrong with this assumption, but I still can't
> put my finger on it. For now I would suggest reverting this commit if
> that solves the issue Marek reported; the intention was not to introduce
> any functional change, but only a (minor) optimisation.
>
> - Kevin
>
>>> Additionally it is much cleaner to use lazy_mmu_mode_pause() and
>>> lazy_mmu_mode_resume() in the Xen context switch hooks, as it avoids
>>> conditionals in those hooks.
>>>
>>> In order not having to add another hook to be called after switching
>>> current, modify lazy_mmu_mode_resume() to use a new sub-function which
>>> takes a task pointer as parameter. This new sub-function can then be
>>> used in the xen_end_context_switch() hook.
>>>
>>> Fixes: 291b3abed657 ("x86/xen: use lazy_mmu_state when
>>> context-switching")
>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>> ---
>>>   arch/x86/xen/enlighten_pv.c |  7 ++-----
>>>   include/linux/pgtable.h     | 33 ++++++++++++++++++++++++---------
>>>   2 files changed, 26 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
>>> index ed2d7a3756ce..67bb6bf6d240 100644
>>> --- a/arch/x86/xen/enlighten_pv.c
>>> +++ b/arch/x86/xen/enlighten_pv.c
>>> @@ -424,9 +424,7 @@ static void xen_start_context_switch(struct
>>> task_struct *prev)
>>>   {
>>>       BUG_ON(preemptible());
>>>   -    if (this_cpu_read(xen_lazy_mode) == XEN_LAZY_MMU) {
>>> -        arch_leave_lazy_mmu_mode();
>>> -    }
>>> +    lazy_mmu_mode_pause();
>>>       enter_lazy(XEN_LAZY_CPU);
>>>   }
>>>   @@ -436,8 +434,7 @@ static void xen_end_context_switch(struct
>>> task_struct *next)
>>>         xen_mc_flush();
>>>       leave_lazy(XEN_LAZY_CPU);
>>> -    if (__task_lazy_mmu_mode_active(next))
>>> -        arch_enter_lazy_mmu_mode();
>>> +    lazy_mmu_mode_resume_task(next);
>>>   }
>>>     static unsigned long xen_store_tr(void)
>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>> index cdd68ed3ae1a..83a099bf2038 100644
>>> --- a/include/linux/pgtable.h
>>> +++ b/include/linux/pgtable.h
>>> @@ -326,6 +326,28 @@ static inline void lazy_mmu_mode_pause(void)
>>>           arch_leave_lazy_mmu_mode();
>>>   }
>>>   +/**
>>> + * lazy_mmu_mode_resume_task() - Resume the lazy MMU mode for a
>>> specific task.
>>> + *
>>> + * Like lazy_mmu_mode_resume() below, but with a task specified.
>>> + * Must be called only by lazy_mmu_mode_resume() or during context
>>> switch.
>>> + * Must never be called in interrupt context.
>>> + *
>>> + * Must match a call to lazy_mmu_mode_pause().
>>> + *
>>> + * Has no effect if called:
>>> + * - While paused (inside another pause()/resume() pair)
>>> + */
>>> +static inline void lazy_mmu_mode_resume_task(struct task_struct *task)
>>> +{
>>> +    struct lazy_mmu_state *state = &task->lazy_mmu_state;
>>> +
>>> +    VM_WARN_ON_ONCE(state->pause_count == 0);
>>> +
>>> +    if (--state->pause_count == 0 && state->enable_count > 0)
>>> +        arch_enter_lazy_mmu_mode();
>>> +}
>>> +
>>>   /**
>>>    * lazy_mmu_mode_resume() - Resume the lazy MMU mode.
>>>    *
>>> @@ -341,15 +363,8 @@ static inline void lazy_mmu_mode_pause(void)
>>>    */
>>>   static inline void lazy_mmu_mode_resume(void)
>>>   {
>>> -    struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>> -
>>> -    if (in_interrupt())
>>> -        return;
>>> -
>>> -    VM_WARN_ON_ONCE(state->pause_count == 0);
>>> -
>>> -    if (--state->pause_count == 0 && state->enable_count > 0)
>>> -        arch_enter_lazy_mmu_mode();
>>> +    if (!in_interrupt())
>>> +        lazy_mmu_mode_resume_task(current);
>>>   }
>>>   #else
>>>   static inline void lazy_mmu_mode_enable(void) {}

