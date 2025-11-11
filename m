Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4304ACCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 12:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF398E0003; Tue, 11 Nov 2025 07:16:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AFED8E0002; Tue, 11 Nov 2025 07:16:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0928E0003; Tue, 11 Nov 2025 07:16:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F37DF8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:16:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83485C0565
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:16:12 +0000 (UTC)
X-FDA: 84098223384.26.ADBE0FA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 910154000D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:16:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762863370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iIeHXQSY2T5hj/W75ZttXiirEAAL/14DBvTtO4y3ecc=;
	b=ISlUzt6ccQ13adYe/LExsjniYUAH4HxVV9Fns1R+OZ4YjA/oi7o4E1y7SP0jx2Wx36ZAuX
	imeJ4oD8MFCc/c9cdjseCp2kWpN7ntIOhy1jDzo+OOs61OVp9ZFh9i4+ykdsPZJcQlibIV
	l9PBOhJaikW6kSsMZFb/aAQyGdyNuPo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762863370; a=rsa-sha256;
	cv=none;
	b=3u+sDlH/gE/cyXu44llckhjs9mnAJZJwWZgaYAld1cXvhy9zlsE7StpeHRx/hPgMm3Kg3r
	cxVaqBKV4mSoJi3U6GP/8m+3HggHB6bSdeKB2INCKb9i6HXY2+/B9Sz899rX/0h2vxQ0G9
	6q2x3mhZbonxDFEQyvqFwJorOGPLg7A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4FDA2F;
	Tue, 11 Nov 2025 04:16:01 -0800 (PST)
Received: from [10.1.31.216] (XHFQ2J9959.cambridge.arm.com [10.1.31.216])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 976253F63F;
	Tue, 11 Nov 2025 04:16:04 -0800 (PST)
Message-ID: <b7581d35-29a1-44d4-bf81-395949bd4da1@arm.com>
Date: Tue, 11 Nov 2025 12:16:03 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/12] mm: introduce generic lazy_mmu helpers
Content-Language: en-GB
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
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
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-7-kevin.brodsky@arm.com>
 <71418b31-aedb-4600-9558-842515dd6c44@arm.com>
 <c764489e-0626-4a50-87b5-39e15d9db733@gmail.com>
 <645178fd-df4e-42fe-b55e-97d9506499be@arm.com>
 <413b2c49-f124-4cda-8fea-a6cc165f6326-agordeev@linux.ibm.com>
 <e428b1d5-65a8-49bc-92dc-ec4a4d933dec@arm.com>
 <92eca53f-eb5d-4bd0-ad6c-56c65fdcea86-agordeev@linux.ibm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <92eca53f-eb5d-4bd0-ad6c-56c65fdcea86-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 910154000D
X-Stat-Signature: oozd6f65bt6tfsomxmaez974qheoxkmr
X-HE-Tag: 1762863370-551508
X-HE-Meta: U2FsdGVkX192F2m2mMdsHVO8EexmXxlWf/RfqLYgdZjGQT2M8PxQ4D2XCd+xYL117OpzlSYBgajx1dXJNXuR9vUMB085HqvU0Jl/CxjgBXvx+/L+wpwKhUjKe8dqFpe1rN3fI72G3rmHw/ZWsnTSX1Z7G75ftkv1yYtoZTTuzABTqOp+jFYhpU/EMnkawa7fjLI5N5fL7yVm9PJWhBNq4WTurAPzlmU4vyNz/qYmW8VUCDq1AHjIqY6ZxdOVh9nXtqFtyDpYsyq6na7RwG7D8f3+TxM9jrUQDYRJUyPJUDOtLuBNJAjziI6PH/sniQaTkU5eF2z6qHTGqKBjQQtQPz2MsJkeHzQgmLxT1qAAA+9fdrm+LhhyyXC+qQMBPHA/KyhmylDBpsUors1jQ3dAAIJ3nN1/18J5e+sPiNkDtMNv+pRaL3CGNV/U1HS+qwUiBiu6alADzzZgcVsKzkoI0SpP26myr5vF4YaucWy6rYOKNH+JKbYsPpVWgwqes8aW2sqvezVyrcfT8yp0xd8POwpX0YZOpBjsijIb/TVz3GHXh260MpLc4u3iRu55lKpeQg3QDixS2IthFXYDhPcZV+x+k9R75OuHpCcY4d1ihshuDYJ9y01J6FrLMke8oUN3ApGDpEUY25t72usiTzJAuAj0T6ksZP4ONsD8nbcATI4uZIXB4peW3UtgODTnwD1W+UVWXzbWDWPbNytkJMpIL2ZyEUROb60xxDqPT/keEdOAqbWCuh6s38dQHYI6nVYjbuwEDhIcVHD405iy7PpXT4tQxoMhHz3/JUB8nt0Pcbrrx3aNmQ4Nkz51YRE7mkejgTr3ZtuA5Wi3Vq7EQLYQwGcsmYH28brwLdxm+nwOVWBunNTOoWRSU38h39njWy1NfSmZQ0o+62xuAaVz8wrk4+ocTWS+veAkPqeHxQIApxN1KWCYieAAtv5MJxBASUed3dGm4xPLaYRVjXwXnSQ
 GecCw01/
 pyUaQK9u7LJCLlxryo7cC8TZX0/ziygBbOTM6CgHBFaUqjvhDdAQ14GCZZOq7PS/vIparnm/S4o8AbLarwykbuOUUjm6UVyQo1owyaCh5JwcBhHtBsDhseYv4rIRZWx+U9N9Bl30cNBwPurQj7UHlKh61gusIwUl+kJpnCEfkpAYSqYIYBaTXeQwQpmVKbWJuBsQi/6m21HXicDmoLtAvNgRJyBob0IaVpml4HYM8yNDcGOH09BdFK6tMafl5oXosfdk7f4XwKDD/tEH5kP8hxSS4A7IvWNE0T6+EDqj3PK3sHlE1Z+ZMz3QmMIlRN/c5NxGq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/11/2025 08:01, Alexander Gordeev wrote:
> On Mon, Nov 10, 2025 at 09:19:40AM +0000, Ryan Roberts wrote:
>> On 10/11/2025 08:11, Alexander Gordeev wrote:
>>> On Fri, Nov 07, 2025 at 03:22:54PM +0000, Ryan Roberts wrote:
>>>
>>> Hi Ryan,
>>>
>>>> On 07/11/2025 14:34, David Hildenbrand (Red Hat) wrote:
>>>>>>>   #ifndef pte_batch_hint
>>>>>>> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
>>>>>>> index 5d2a876035d6..c49b029d3593 100644
>>>>>>> --- a/mm/kasan/shadow.c
>>>>>>> +++ b/mm/kasan/shadow.c
>>>>>>> @@ -305,7 +305,7 @@ static int kasan_populate_vmalloc_pte(pte_t *ptep,
>>>>>>> unsigned long addr,
>>>>>>>       pte_t pte;
>>>>>>>       int index;
>>>>>>>   -    arch_leave_lazy_mmu_mode();
>>>>>>> +    lazy_mmu_mode_pause();
>>>>>>
>>>>>> I wonder if there really are use cases that *require* pause/resume? I think
>>>>>> these kasan cases could be correctly implemented using a new nest level instead?
>>>>>> Are there cases where the effects really need to be immediate or do the effects
>>>>>> just need to be visible when you get to where the resume is?
>>>>>>
>>>>>> If the latter, that could just be turned into a nested disable (e.g. a flush).
>>>>>> In this case, there is only 1 PTE write so no benefit, but I wonder if other
>>>>>> cases may have more PTE writes that could then still be batched. It would be
>>>>>> nice to simplify the API by removing pause/resume if we can?
>>>>>
>>>>> It has clear semantics, clearer than some nest-disable IMHO.
>>>>>
>>>>> Maybe you can elaborate how you would change ("simplify") the API in that
>>>>> regard? What would the API look like?
>>>>
>>>> By simplify, I just meant can we remove lazy_mmu_mode_pause() and
>>>> lazy_mmu_mode_resume() ?
>>>>
>>>>
>>>> We currently have:
>>>>
>>>> apply_to_page_range
>>>>   lazy_mmu_mode_enable()
>>>>     kasan_populate_vmalloc_pte()
>>>>       lazy_mmu_mode_pause()
>>>>       <code>
>>>>       lazy_mmu_mode_resume()
>>>>   lazy_mmu_mode_disable()
>>>>
>>>> Where <code> is setting ptes. But if <code> doesn't need the effects to be
>>>> visible until lazy_mmu_mode_resume(), then you could replace the block with:
>>>>
>>>> apply_to_page_range
>>>>   lazy_mmu_mode_enable()
>>>>     kasan_populate_vmalloc_pte()
>>>>       lazy_mmu_mode_enable()
>>>>       <code>
>>>>       lazy_mmu_mode_disable()
>>>>   lazy_mmu_mode_disable()
>>>>
>>>> However, looking at this more closely, I'm not really clear on why we need *any*
>>>> special attention to lazy mmu inside of kasan_populate_vmalloc_pte() and
>>>> kasan_depopulate_vmalloc_pte().
>>>>
>>>> I *think* that the original concern was that we were doing ptep_get(ptep) inside
>>>> of a lazy_mmu block? So we need to flush so that the getter returns the most
>>>> recent value? But given we have never written to that particular ptep while in
>>>> the lazy mmu block, there is surely no hazard in the first place?
>>>
>>> There is, please see:
>>> https://lore.kernel.org/linux-mm/cover.1755528662.git.agordeev@linux.ibm.com/
>>
>> I've stared at this for a while, but I'm afraid I still don't see the problem.
>> This all looks safe to me. Could you explain exactly what this issue is?
>>
>> If I've understood correctly, kasan_populate_vmalloc() is called during virtual
>> range allocation by vmalloc. This is not in a nested lazy mmu block (but it
>> wouldn't matter if it was once we have Kevin's nested changes to ensure flush
>> when exiting the nested scope). kasan_populate_vmalloc() calls
>> apply_to_page_range(), which will walk the set of ptes, calling
>> kasan_populate_vmalloc_pte() for each one. kasan_populate_vmalloc_pte() does a
>> ptep_get() then, if none, calls set_pte_at().
>>
>> That's not a hazard since you're calling get before the set and you only visit
>> each pte once for the apply_to_page_range() lazy mmu block.
> 
> I have to admit I do not remember every detail and would have to recreate
> the issue - which is specific to s390 lazy_mmu implementation I think.
> Both kasan_populate_vmalloc_pte() and kasan_depopulate_vmalloc_pte() do:
> 
> apply_to_page_range()
> {
>     arch_enter_lazy_mmu_mode();
> 
>     kasan_de|populate_vmalloc_pte()
>     {
>         arch_leave_lazy_mmu_mode();             <--- remove?
> 
>         spin_lock(&init_mm.page_table_lock);
>         <PTE update>
>         spin_unlock(&init_mm.page_table_lock);	<--- PTE store should be done
> 
>         arch_enter_lazy_mmu_mode();             <--- remove?
>     }
> 
>     arch_leave_lazy_mmu_mode();
> }
> 
> Upon return from spin_unlock() both kasan callbacks expect the PTE contains
> an updated value to be stored to pgtable. That is true unless we remove
> arch_leave|enter_lazy_mmu_mode() brackets. If we do the value is continued
> to be cached and only stored when the outer arch_leave_lazy_mmu_mode() is
> called. That results in a race between concurrent PTE updaters.

OK, I've been staring at the code and KASAN docs and believe I understand the
problem now. Thanks for your patience!

The core of the problem is that the shadow memory which is being allocated here
is 1/8th the size of the virtual range it covers, and so a single page of shadow
memory can be shared by multiple vmalloc areas. The implication here is that
multiple concurrent vmalloc() calls can allocate adjacent areas and both will
race to allocate the same shadow page. That's why we have the spin lock and the
check for pte_none(); the winner is the one that sees pte_none() == true and
will perform the mapping.

And so yes, this does indeed create a read hazzard; there are 2 racing threads,
both reading and writing the pte.

One alternative solution would be to grab the spin lock around the whole
apply_to_page_range(), but for the populate call, that would imply holding the
lock during __memset(). And for depopulate, it would imply holding it during
__free_page(). Neither of these are desirable.

So I agree pause/resume are required here. Sorry for the noise!

Thanks,
Ryan


> 
>>>> apply_to_existing_page_range() will only call kasan_depopulate_vmalloc_pte()
>>>> once per pte, right? So given we read the ptep before writing it, there should
>>>> be no hazard? If so we can remove pause/resume.
>>>
>>> Unfortunately, we rather not, please see:
>>> https://lore.kernel.org/linux-mm/d407a381-099b-4ec6-a20e-aeff4f3d750f@arm.com/
>>
>> Sorry but I don't see anything relavent to my point in this mail. Perhaps there
>> is some s390-specific detail that I'm failing to understand?
> 
> Sorry, with this message I meant the branch where it was discussed,
> I will try to C&P some excerpts and summarize it here.
> 
> * lazy_mmu_mode_enable()
> 
> This helper is parameter-free, assuming the MMU unit does not need any
> configuration other than turning it on/off. That is currently true, but
> (as I noted in my other mail) I am going to introduce a friend enable
> function that accepts parameters, creates an arch-specific state and
> uses it while the lazy mmu mode is active:
> 
> static inline void arch_enter_lazy_mmu_mode_pte(struct mm_struct *mm,
> 						unsigned long addr,
> 						unsigned long end,
> 						pte_t *ptep)
> {
> 	...
> }
> 
> * lazy_mmu_mode_resume() -> arch_enter_lazy_mmu_mode()
> 
> Conversely, this needs to be -> arch_resume_lazy_mmu_mode(). And it can not
> be arch_enter_lazy_mmu_mode(), since a lazy_mmu_mode_resume() caller does
> not know the parameters passed to the original lazy_mmu_mode_enable(...)-
> friend.
> 
>>
>> Thanks,
>> Ryan
> 
> Thanks!
> 
>>>
>>> The problem is kasan code invokes apply_to_page_range(), which enters lazy_mmu
>>> mode unconditionally. I would claim that is rather an obstacle for the kasan
>>> code, not a benefit. But it needs to be tackled.
>>>> Should apply_to_page_range() had an option not to enter the lazy_mmu mode
>>> (e.g. an extra "bool skip_lazy" parameter) - the pause/resume could have
>>> been avoided.
>>>
>>>> Thanks,
>>>> Ryan
>>>
>>> Thanks!


