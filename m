Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF9F1CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 16:20:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29FC48E0007; Thu, 11 Sep 2025 12:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 277CD8E0001; Thu, 11 Sep 2025 12:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B47E8E0007; Thu, 11 Sep 2025 12:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9BA8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:20:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0179C0456
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:20:03 +0000 (UTC)
X-FDA: 83877481086.25.F5C59F3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id E190C4000A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:20:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757607602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6qqjTYTrD/QqdRv64e17c4F7ZvmzcQ8jL1KviIELsb0=;
	b=YugYkT6KaihqvY1C99F/gUUsEOxJ+nN6Ip4Tm5XgLDXkSEdtanC0koBBgWHvrk89WKa6lf
	NQdonMBh9CH/8OzFbQwJ5ZXJ1GCx61ReITIWbz/JuTvtRclKwpgBZNeFba6e+FeD2nKGeO
	6GnsAIV9LAmQMGHVocs/UNoaIZmVUzc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757607602; a=rsa-sha256;
	cv=none;
	b=WEGQdmLCh5Y9waaz59MITXkDaFpjFBQzldo7+8IR/tB5DKITe7QzxH6HowIRY3B5YM/wDP
	Yd2cHkG4wn2Lve2HhlHlTtY/u99sGL2ptyEmvjmYIVyLUp5mVWFP4rdpeQS8hugKLJkmC0
	yfiAC1hZOfDjXbRQiXZ5zD/VW9j21w8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DC0B153B;
	Thu, 11 Sep 2025 09:19:52 -0700 (PDT)
Received: from [10.57.70.14] (unknown [10.57.70.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9403F3F694;
	Thu, 11 Sep 2025 09:19:53 -0700 (PDT)
Message-ID: <4b4971fd-0445-4d86-8f3a-6ba3d68d15b7@arm.com>
Date: Thu, 11 Sep 2025 18:19:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
To: David Hildenbrand <david@redhat.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
 Mark Rutland <Mark.Rutland@arm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-3-kevin.brodsky@arm.com>
 <d23ea683-cca4-4973-88b1-4f6fd9b22314@redhat.com>
 <ca2054ad-b163-4e61-8ec4-6f2e36461628-agordeev@linux.ibm.com>
 <e7acb889-1fe9-4db3-acf4-39f4960e8ccd@redhat.com>
 <2fecfae7-1140-4a23-a352-9fd339fcbae5-agordeev@linux.ibm.com>
 <e521b1f4-3f2b-48cd-9568-b9a4cf4c4830@redhat.com>
 <47ee1df7-1602-4200-af94-475f84ca8d80@arm.com>
 <29383ee2-d6d6-4435-9052-d75a263a5c45@redhat.com>
 <9de08024-adfc-421b-8799-62653468cf63@arm.com>
 <ef343405-c394-4763-a79f-21381f217b6c@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <ef343405-c394-4763-a79f-21381f217b6c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E190C4000A
X-Stat-Signature: 7f8mbkuzyuetg9jtd78mfs14ru6k4r49
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757607601-186232
X-HE-Meta: U2FsdGVkX18wi/9Xy+pPPHx+aEhoihEZBYPB4bp0sjYKjW8zNd2Amrr+R30ncLvYBxxggmspOHTGWHzldflPea23cYr9exVU4TEhw5RhEIrPMLXJh9vx/WfAVJUS6/hVYI86CFOMcKKuMRROxKbH+dqXawR2zIedLxksUw4ZHGJl/zE9rEeSNOBOjfA6mtlutoteK4HIIRiaYLzICA3BJeyylTeJbpUHyeCiElEXNop8KKc/oi5Psc9kD+OuUwqKpWXZRtGd+SQA0CObCE6a8PNbGtXzekPOWky3HGBtIOl+/bPrByTH7UXRRxDjFVHcAn3CmglphnjDPJ73Y9VZRB0am7AtMNtX8YlY1bOi9FioEfTTjLK3d9Y9bWDxpChPPQDh1G4yUl5QZyIEk/H7sgjJMiLgutYbXvF2ZzaMmiq1Za0Y1FwHhG4Z/ifsaJP0EJRu2de0ECnTMEn6k5WNfOFtdcw0a2opAxvee3wXOUZOEVFZWOXq5Gv+wrVgEN15yI927zAxePzB+opmFaOXRKK0Q9QCs9h7pTNWRcRCdWmbtxvlBV7JbEIrc3aLaVkIwXpWdPE/ms38csaoqNeogJvjJJuvKk2zveljyN+GEvg2RlwhauB4XpeVPOHkA682I0rCpt4Yoj7agK8fotTNtS6aA+EQoAVnhlPSL0MySBurahfA76TCTHv+319nnMjjEI7pTS1ZVTRoSjGILrHEmXyeim69RN4cqMpcM68+JkhzdCc/OM0fCiaV6YMZ0lKtaq7/GPEmSh00ubthIJiccKl//vTLLbsLm7fLpLZObekFqfq++X1OHY7ezvy88g+DobH9hiFZlasHNt0YrBi9DqpIKdZss0PrtJ6gFtZ1OPnDa19pMWxQmceEEkrIoCcqKpCjos0+w12ujFv+CmPIZMCYytP6FDI+bGspIQi4ISBKZfhLVbKjbrxeCdqpA9+n4/Ga6AxKhqFaY+RKPsS
 9FcdkWXL
 KdZNibnA0t7v/c2lDMJxJot+Pg54bfVpQoGBgjqQxUFh06G6tgHroyAjFrLzIAhSmC0WaD9XwEu2Q7XJSF4bOzi1WOPLiV34IUzyTctrI3PPes8KIxJekhThdAahboFB5blkyNijefN3vYoI4KUf1YAwk5VBTk2zbYTsFL6ne9bgB3SBEedTWPNBcvKFKZAeOvgZAKoKfbQqx+o5owa7O5f/Zbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/09/2025 17:37, David Hildenbrand wrote:
>>
>> Somewhat, but in the regular case where enter() is called followed by
>> leave() there is really no complexity for the caller, just an extra
>> local variable.
>>
>> There are complications where we want to exit lazy_mmu temporarily, as
>> in mm/kasan/shadow.c [1k], but this is in fact unavoidable. Chatting
>> with Mark Rutland, I realised that to truly support nested sections,
>> this must be handled in a special way in any case. To be clear, I am
>> referring to this situation:
>>
>> __kasan_populate_vmalloc:
>>      apply_to_page_range:
>>          arch_enter_lazy_mmu_mode() {1}
>>
>>          kasan_populate_vmalloc_pte:
>>              arch_leave_lazy_mmu_mode() {2}
>>              arch_enter_lazy_mmu_mode() {3}
>>
>>          arch_leave_lazy_mmu_mode() {4}
>>
>> With the approach this series takes, call {2} is made safe by passing a
>> special parameter (say LAZY_MMU_FLUSH) that forces lazy_mmu to be fully
>> exited - and call {3} will then re-enter lazy_mmu. This works regardless
>> of whether __kasan_populate_vmalloc() has been called with lazy_mmu
>> already enabled (i.e. calls {1} and {4} can be nested).
>>
>> On the other hand, with a pagefault_disabled-like approach, there is no
>> way to instruct call {3} to fully exit lazy_mmu regardless of the
>> nesting level.
>
> Sure there is, with a better API. See below. :) 

I meant while keeping the existing shape of the API but yes fair enough!

>
>>
>> It would be possible to make both approaches work by introducing a new
>> API, along the lines of:
>> - int arch_disable_save_lazy_mmu_mode() (the return value indicates the
>> nesting level)
>> - void arch_restore_lazy_mmu_mode(int state) (re-enter lazy_mmu at the
>> given nesting level)
>
> Yes, I think we really need a proper API.
>
>>
>> This is arguably more self-documenting than passing LAZY_MMU_FLUSH in
>> call {2}. This API is however no simpler when using a
>> pagefault_disabled-like approach (and less consistent than when always
>> saving state on the stack).
>
> Yes, a proper API is warranted. In particular, thinking about the
> following:
>
> arch_enter_lazy_mmu_mode() {1}
>     arch_enter_lazy_mmu_mode() {2}
>
>     kasan_populate_vmalloc_pte:
>         arch_leave_lazy_mmu_mode() {3}
>         arch_enter_lazy_mmu_mode() {4}
>
>     arch_leave_lazy_mmu_mode() {5}
> arch_leave_lazy_mmu_mode() {6}
>
>
> Imagine if we have the following API instead:
>
> lazy_mmu_enable() {1}
>     lazy_mmu_enable() {2}
>
>     kasan_populate_vmalloc_pte:
>         lazy_mmu_pause() {3}
>         lazy_mmu_continue() {4}
>
>     lazy_mmu_disable() {5}
> lazy_mmu_disable() {6}
>
>
> I think it is crucial that after lazy_mmu_save/lazy_mmu_restore, no
> more nesting must happen.

That makes sense to me - lazy_mmu should only be paused in very specific
situations and I don't see a justification for supporting nesting while
paused.

>
> Assume we store in the task_struct
>
> uint8_t lazy_mmu_enabled_count;
> bool lazy_mmu_paused;

I didn't think of that approach! I can't immediately see any problem
with it, assuming we're fine with storing arch-specific context in
thread_struct (which seems to be the case as things stand).

>
> We can do things like
>
> a) Sanity check that while we are paused that we get no more
> enable/disable requests
> b) Sanity check that while we are paused that we get no more pause
> requests.

These are good points - and this is only possible with such global
state. (Similarly we can check that the counter never underflows.)

>
> [...]
>
>>>
>>> If LAZY_MMU_DEFAULT etc. are not for common code, then please
>>> maintain them for the individual archs as well, just like you do
>>> with the
>>> opaque type.
>>
>> I see your point - having them defined in <linux/mm_types.h> could be
>> misleading. I just wanted to avoid all 4 architectures defining the same
>> macros. Maybe call them __LAZY_MMU_* to suggest they're not supposed to
>> be used in generic code?
>
> Maybe look into avoiding them completely :) Let's agree on the API
> first and then figure out how to pass the information we need to pass.
>
> [...]
>
>>> Worse, it does not
>>>> truly enable states to be nested: it allows the outermost section to
>>>> store some state, but nested sections cannot allocate extra space.
>>>> This
>>>> is really what the stack is for.
>>>
>>> If it's really just 8 bytes I don't really see the problem. So likely
>>> there is
>>> more to it?
>>
>> I suppose 8 extra bytes per task is acceptable, but some architectures
>> may want to add more state there.
>
> Just for reference: we currently perform an order-2 allocation,
> effectively leaving ~4KiB "unused".
>
> If there are any real such case on the horizon where we need to store
> significantly more (in which case storing it on the stack might
> probably also bad), please let me know.
>
>>
>> The one case that is truly problematic (though not required at this
>> point) is where each (nested) section needs to store its own state. With
>> this series it works just fine as there is a lazy_mmu_state_t for each
>> section, however if we use task_struct/thread_struct there can be only
>> one member shared by all nested sections.
>
> Do we have a use case for that on the horizon? If so, I fully agree,
> we have to store information per level. How/what information we have
> to store would be another question.

Not that I'm aware of, and all things considered it may not be so
likely: once lazy_mmu is enabled, entering nested sections isn't really
supposed to change any state.


Overall what you're proposing seems sensible to me, the additional
fields in task_struct don't take much space and we can keep the API
unchanged in most cases. It is also good to have the option to check
that the API is used correctly. I'll reply to the cover letter to let
anyone who didn't follow this thread chip in, before I go ahead and try
out that new approach.

- Kevin

