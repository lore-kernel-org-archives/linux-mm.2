Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C113CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 15:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9DD18E0017; Wed, 10 Sep 2025 11:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4E3D8E0006; Wed, 10 Sep 2025 11:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D0D8E0017; Wed, 10 Sep 2025 11:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7DA9B8E0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:16:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33BB8160957
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:16:30 +0000 (UTC)
X-FDA: 83873692140.11.715BBF1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 23F0320014
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:16:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757517388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nmKEgDDDv5jHwALQIQWP1dQM1C3WliCJzN4vuebfqtc=;
	b=Dbxus97IhK91qihJcpxR5+fl55iE1DAzCycKO0ux9JmI8GNI14KMfQchxI7iaWv9eu5YhB
	oY5kkX5fhg/Khos681YY1AQG45KTT7R1dQgS+3aagYr7ojIVYHEBP0YYj1oiNN9Hto+DNN
	7emnV9qnx/0+Hw0aN9Sa9JlRnKn0MgQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757517388; a=rsa-sha256;
	cv=none;
	b=uSnVLQAca6xcQZ4k+SdU9Mv9i1BMrBJ6Q/wtgOBYggiAB1SlBuQ4Czitucl5x9AA8zvT+F
	jIadOKx7yC1Gx/6MlKMB5DpVwQbP/DCjKse6mio/kr167V1dXaiOji+3M6jsrEy6TlVF2w
	zMzxFX5HZ/lww/4oa4e2gWyAIf7x3Fw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD96716F2;
	Wed, 10 Sep 2025 08:16:18 -0700 (PDT)
Received: from [10.57.67.148] (unknown [10.57.67.148])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 99AFA3F694;
	Wed, 10 Sep 2025 08:16:20 -0700 (PDT)
Message-ID: <9de08024-adfc-421b-8799-62653468cf63@arm.com>
Date: Wed, 10 Sep 2025 17:16:18 +0200
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
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <29383ee2-d6d6-4435-9052-d75a263a5c45@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 23F0320014
X-Stat-Signature: sg1yftd3tc559sfde4t3h9g5dom3qyk1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757517387-970089
X-HE-Meta: U2FsdGVkX1+9+KxcGd39YF+++gopnqsb5Pxmd7RaL2B5wbnuG/3SZXMaWdRJBywrzaZK0ki9+VNT0u5NCV85iQmRvzQBDouKNDz/GxBobVt2B8e0ktwytImuoC6g/ddqMoMVnqoMVGSUSMbO/x3wZQoO72eMvp40gkMvQZ5a6RbHABLyaViHcyouPZ78NN8sdQZxzGQrWoxMeaK74I48NXYjlOrRRSR44y1Pv0IB6tGvEQT+ieKWyxx97PI1wipFvI1zxtSQXOlZutihUls+0ap+dTMI9fUkwOPcaLepWLgMrVgGMlmpHbT3YmBHw+n7UsYuf80uEFEPn3LuixWkZS/3JXuk84C0E5vJIDXlX910MLQ7d9TkqslG7dpfNagS+kyzZDPR2n9aOGUO1wWfVBUTuQsCPA+FAi0jS1j7YaRbCRw/vIf1znVlXuM4hiBcni7HO5kUoUJurYKo0D5TudfKqiVJMMLO6i2lexpKUros5XcPE15Ko046JcxCWcfcFiJxA/m/eyvDzXsA8F1EOCOQJ8twZKjtB7wtK4UDKWTubFcKlpJAvHshhTgGQ91WoxfKQecOvLRnJdnsjT4tvby5utK0eKCyLsQE1ILkBv+G/eNqS+do/fnAS8lV95033nMH1jFjhY2lWJC5VHWodhwsEjuxGe9JWYVoXnj2RmZe+cizB9pgVitYaPxQhEFKGKN/dsvsbNRO5Vr8oSB5kv0l3vxFe0W7ObCVjZY50N2f+FV4iTDB7s8ZPml6QSVFUpVbuWt+itAvz7caDRIkRYc3I5gicndGO4Ap46uaAJcpQgNjkyOkPnKpjIxwaRW48qfR3nbGgE8wzo0PYrjSMcJz3IHQmLyyOzYTwMm5KeMMmjpl2mlbOAzIVl24m6jGoJb3Qopy7k8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Mark Rutland

On 09/09/2025 16:28, David Hildenbrand wrote:
>>>>>>> Can't we just use an "enum lazy_mmu_state" and call it a day?
>>>>>>
>>>>>> I could envision something completely different for this type on
>>>>>> s390,
>>>>>> e.g. a pointer to a per-cpu structure. So I would really ask to
>>>>>> stick
>>>>>> with the current approach.
>>
>> This is indeed the motivation - let every arch do whatever it sees fit.
>> lazy_mmu_state_t is basically an opaque type as far as generic code is
>> concerned, which also means that this API change is the first and last
>> one we need (famous last words, I know).
>
> It makes the API more complicated, though. :)

Somewhat, but in the regular case where enter() is called followed by
leave() there is really no complexity for the caller, just an extra
local variable.

There are complications where we want to exit lazy_mmu temporarily, as
in mm/kasan/shadow.c [1k], but this is in fact unavoidable. Chatting
with Mark Rutland, I realised that to truly support nested sections,
this must be handled in a special way in any case. To be clear, I am
referring to this situation:

__kasan_populate_vmalloc:
    apply_to_page_range:
        arch_enter_lazy_mmu_mode() {1}

        kasan_populate_vmalloc_pte:
            arch_leave_lazy_mmu_mode() {2}
            arch_enter_lazy_mmu_mode() {3}

        arch_leave_lazy_mmu_mode() {4}

With the approach this series takes, call {2} is made safe by passing a
special parameter (say LAZY_MMU_FLUSH) that forces lazy_mmu to be fully
exited - and call {3} will then re-enter lazy_mmu. This works regardless
of whether __kasan_populate_vmalloc() has been called with lazy_mmu
already enabled (i.e. calls {1} and {4} can be nested).

On the other hand, with a pagefault_disabled-like approach, there is no
way to instruct call {3} to fully exit lazy_mmu regardless of the
nesting level.

It would be possible to make both approaches work by introducing a new
API, along the lines of:
- int arch_disable_save_lazy_mmu_mode() (the return value indicates the
nesting level)
- void arch_restore_lazy_mmu_mode(int state) (re-enter lazy_mmu at the
given nesting level)

This is arguably more self-documenting than passing LAZY_MMU_FLUSH in
call {2}. This API is however no simpler when using a
pagefault_disabled-like approach (and less consistent than when always
saving state on the stack).

[1k]
https://lore.kernel.org/all/0d2efb7ddddbff6b288fbffeeb10166e90771718.1755528662.git.agordeev@linux.ibm.com/

>
>>
>> I mentioned in the cover letter that the pkeys-based page table
>> protection series [1] would have an immediate use for lazy_mmu_state_t.
>> In that proposal, any helper writing to pgtables needs to modify the
>> pkey register and then restore it. To reduce the overhead, lazy_mmu is
>> used to set the pkey register only once in enter(), and then restore it
>> in leave() [2]. This currently relies on storing the original pkey
>> register value in thread_struct, which is suboptimal and most
>
> Can you elaborate why this is suboptimal? See below regarding the size
> of task_struct.

Suboptimal in the sense that we're allocating fixed space for each task
that we are almost never using.

>
>> importantly doesn't work if lazy_mmu sections nest.
>
> Can you elaborate why it would be problematic with nesting (if we
> would have a count
> and can handle the transition from 0->1 and 1->0)?

It doesn't work in that specific patch I linked - but yes it can be made
to work if we have both an extra task_struct member to store the level
of nesting *and* an extra thread_struct member to store the saved pkey
register value (both of which are only used while in lazy_mmu).


>
>> With this series, we
>> could instead store the pkey register value in lazy_mmu_state_t
>> (enlarging it to 64 bits or more).
>
> Yes.
>
>>
>> I also considered going further and making lazy_mmu_state_t a pointer as
>> Alexander suggested - more complex to manage, but also a lot more
>> flexible.
>>
>>>>> Would that integrate well with LAZY_MMU_DEFAULT etc?
>>>>
>>>> Hmm... I though the idea is to use LAZY_MMU_* by architectures that
>>>> want to use it - at least that is how I read the description above.
>>>>
>>>> It is only kasan_populate|depopulate_vmalloc_pte() in generic code
>>>> that do not follow this pattern, and it looks as a problem to me.
>>
>> This discussion also made me realise that this is problematic, as the
>> LAZY_MMU_{DEFAULT,NESTED} macros were meant only for architectures'
>> convenience, not for generic code (where lazy_mmu_state_t should ideally
>> be an opaque type as mentioned above). It almost feels like the kasan
>> case deserves a different API, because this is not how enter() and
>> leave() are meant to be used. This would mean quite a bit of churn
>> though, so maybe just introduce another arch-defined value to pass to
>> leave() for such a situation - for instance,
>> arch_leave_lazy_mmu_mode(LAZY_MMU_FLUSH)?
>
> The discussion made me realize that it's a bit hack right now :)
>
> If LAZY_MMU_DEFAULT etc. are not for common code, then please
> maintain them for the individual archs as well, just like you do with the
> opaque type.

I see your point - having them defined in <linux/mm_types.h> could be
misleading. I just wanted to avoid all 4 architectures defining the same
macros. Maybe call them __LAZY_MMU_* to suggest they're not supposed to
be used in generic code?

>
>>
>>>
>>> Yes, that's why I am asking.
>>>
>>> What kind of information (pointer to a per-cpu structure) would you
>>> want to return, and would handling it similar to how
>>> pagefault_disable()/pagefault_enable() e.g., using a variable in
>>> "current" to track the nesting level avoid having s390x to do that?
>>
>> The pagefault_disabled approach works fine for simple use-cases, but it
>> doesn't scale well. The space allocated in task_struct/thread_struct to
>> track that state is wasted (unused) most of the time.
>
> I'm not sure that's a concern. Fitting an int into existing holes
> should work
> and even another 64bit (8byte )...
>
> I just checked with pahole using the Fedora config on current
> mm-unstable.
>
>
> /* size: 9792, cachelines: 153, members: 276 */
> /* sum members: 9619, holes: 20, sum holes: 125 */
> /* sum bitfield members: 85 bits, bit holes: 2, sum bit holes: 43 bits */
> /* padding: 32 */
> /* member types with holes: 4, total: 6, bit holes: 2, total: 2 */
> /* paddings: 6, sum paddings: 49 */
> /* forced alignments: 12, forced holes: 2, sum forced holes: 60 */
>
> Due to some "arch_task_struct_size" we might actually allocate more
> space.
>
>
> Staring at my live system:
>
> $ sudo slabinfo
> Name                   Objects Objsize           Space Slabs/Part/Cpu 
> O/S O %Fr %Ef Flg
> ...
> task_struct               1491   12376           24.8M     
> 721/25/37    2 3   3  74
>
>
> I am not sure if even an additional 8byte would move the needle here.
>
>
> Worse, it does not
>> truly enable states to be nested: it allows the outermost section to
>> store some state, but nested sections cannot allocate extra space. This
>> is really what the stack is for.
>
> If it's really just 8 bytes I don't really see the problem. So likely
> there is
> more to it? 

I suppose 8 extra bytes per task is acceptable, but some architectures
may want to add more state there.

The one case that is truly problematic (though not required at this
point) is where each (nested) section needs to store its own state. With
this series it works just fine as there is a lazy_mmu_state_t for each
section, however if we use task_struct/thread_struct there can be only
one member shared by all nested sections.

- Kevin

