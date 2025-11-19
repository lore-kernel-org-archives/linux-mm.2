Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34DB8CF31B5
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 12:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D7E6B000A; Wed, 19 Nov 2025 07:13:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4786B0062; Wed, 19 Nov 2025 07:13:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3816B007B; Wed, 19 Nov 2025 07:13:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 572E76B0062
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:13:33 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F3F931A0475
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:13:32 +0000 (UTC)
X-FDA: 84127247064.03.3F5C6BA
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf16.hostedemail.com (Postfix) with ESMTP id D9E42180010
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:13:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=STg5O2V+;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763554411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ChntVSAJEdx52GDp22Byw4gNrU45MwhrzYBvf/r7fVA=;
	b=l677TcOelH8+WKpQmoY6XUzxhokBtCB+r3xjNIkvARKPZAASJqB7uymbn+fj9pXlLmx0ys
	tdchNfeIWiXY+djkVByWBUaR3goNSg++DiojJnYPE2nvRTVWzz3E5qk1jc+21yrBx/z2Bj
	nTkqWFi+EbEupQpk7AeeSiLr6dZkGk0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763554411; a=rsa-sha256;
	cv=none;
	b=txROm3KJVR72XGcq0SjiXKZt1pDHBK1+y6PDuQoRfpYiEGk4gpAhDIXb3vKq2mXkx1pBih
	e9ybFivmQYgFUHyEG5LB3TC1UblNODNCs+w+ls61QBuMjeVBakqL7IoHCRVU+Sl4UVhX8k
	RQfvKlkL9cp9vNzdUPoE99998M8si2U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=STg5O2V+;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <479b0409-335f-4450-8eb2-5270a5847f5e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763554408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ChntVSAJEdx52GDp22Byw4gNrU45MwhrzYBvf/r7fVA=;
	b=STg5O2V+Sl9LLOnwZQaczXlTHP+1ZdEUgInCww0UaRgkRmy/DKZhE6CSS5saVN1blO5tpU
	Dsv08XPCA2xSNec4xWm6Qi56GDukuP6Qlk4spz1T14QeoraE5F9Wwf1VM2PgaND/qU0KYn
	1ac+eFY7mf5P/I8Fh10S5tR+u8NSHG0=
Date: Wed, 19 Nov 2025 20:13:10 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 7/7] mm: make PT_RECLAIM depend on
 MMU_GATHER_RCU_TABLE_FREE && 64BIT
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
 dev.jain@arm.com, akpm@linux-foundation.org, ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
 <0a4d1e6f0bf299cafd1fc624f965bd1ca542cea8.1763117269.git.zhengqi.arch@bytedance.com>
 <355d3bf3-c6bc-403e-9f19-89259d868611@kernel.org>
 <195baf7c-1f4e-46a4-a4aa-e68e7d00c0f9@linux.dev>
 <9386032c-9840-49da-83f9-74b112f3e752@kernel.org>
 <956c7ca1-bce8-4eed-8a86-bc8adfc708b8@linux.dev>
 <6a22ff95-28c1-4c1d-a1a8-6a391bcc8c86@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <6a22ff95-28c1-4c1d-a1a8-6a391bcc8c86@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D9E42180010
X-Stat-Signature: 8491gkkyr5ihkgf74zeuetuzartbnxry
X-Rspam-User: 
X-HE-Tag: 1763554410-800033
X-HE-Meta: U2FsdGVkX1/HS9zMYR+CDeGGrj7PIjZAzwLHpKtKwdW6ccJclV7KEe8ivUB024i4FKe/UWecA82/2XjwAW5Y+SYyOgi4y5skcvMEmxik6/s9i4Y+xyW7pp7RtsaDUqK04v/tA6Fc1rwJZGUL3VJx7/3zlUfcLN6Yzu+7yBQSNmQftSL5QlYxXKZUYjGEezLaodKBWoW37dRQcvegJ+hWoTlJ50lGmin4iNX5WQSGaZq9m2CbA0BBElVU72e40id675r5LpttKAxdSSIoxhq46LVOKeKCkgcdL+IHwjqFnm+msDFjnMqKL+jGIJgSXvg+fUcduzaT3ywYhlPvwvfdt6LLwT9ukXIZRYz/Ad1pLXJnNASS7Sp/pv+D5wzpgKt3+tKCRZAJKZmXpBmTLdNRA3FubuKSCx5a9I6uUmH8q+VSoFkYUB5wv0/npai3OC8UPLGUb1MTdbqCt0y1BtdfyQHblhsWsei1gZfUH4uVU0h/Efit16CtdwVmG08DrtfBKvBR1GwL86Zz/nkoVMb5W35qY5VwiffGnIZv8h4+tpdGCACt727zL4q8iJY9SHnJJky7t41XAvB2V1a30ALQJaLXDl+8LDoY20k41s4QbSlrDDlux66MJhkB1z/MPeBro8y/jk7qMEkiJgioiZOKYiBsoSDpsGbs0lCzkLvoPcNMyeuW3LyfD6NpPEJCxbJTs5gkS+gx00rO6UDFEaS5TpgnMomQevX/b6yTrN7AVDI2HwYvUYIlBG3Y8EBXvUiifmbIU8Bx2zPGeP9mG33ggQVB5siFiyRT3PnNl2Z9PH6yID3fuJvQaHxgBGBMZ2GmK6EkD1tKSftt1AAVpKaPULOQjtHbj1VVGZeYWZYUG2WKKOM7hKTkY8G5a2+m1BGctK4FfyKvujdCg0XuK0kJ3KzdvFq1NahvsXpelTtQZIfJKeJjXrcGC5NE73kBOXDxDe5t+Q+tNOZW3FtQIlA
 IJebJp3/
 4a8PYJbJSw+6YkktyYUhL3fyznowjOHEtt3F1akL5D4qGqM//reIaHgzq5A4XrH/ZzGLC2NKI7onLjAzuA8YYe78+hBf0uIEpEg2BO+Uuvj/1xxSPP5CEPbZ7NNKfSXkgS+Ej8lDnJFD54zKka5K63MieInFiFM9vVyMeivZdtIT7AyR9P4J4C0OQ6BkEqyuAsxJh71eLRqmXk28zOXM9fFBek76zpuvymaXC62m52y1mB5/PQg/NAv5WMnVblQS3KNPLawLFUrKZMZRND8+7Xum8hANAV0OtOHH7vqM5j5qk3Xx2CMGhNNeqhi0j0p5W4lKatlNdY88FPZo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/19/25 7:35 PM, David Hildenbrand (Red Hat) wrote:
> On 19.11.25 12:02, Qi Zheng wrote:
>> Hi David,
>>
>> On 11/19/25 6:19 PM, David Hildenbrand (Red Hat) wrote:
>>> On 18.11.25 13:02, Qi Zheng wrote:
>>>>
>>>>
>>>> On 11/18/25 12:57 AM, David Hildenbrand (Red Hat) wrote:
>>>>> On 14.11.25 12:11, Qi Zheng wrote:
>>>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>
>>>>> Subject: s/&&/&/
>>>>
>>>> will do.
>>>>
>>>>>
>>>>>>
>>>>>> Make PT_RECLAIM depend on MMU_GATHER_RCU_TABLE_FREE so that 
>>>>>> PT_RECLAIM
>>>>>> can
>>>>>> be enabled by default on all architectures that support
>>>>>> MMU_GATHER_RCU_TABLE_FREE.
>>>>>>
>>>>>> Considering that a large number of PTE page table pages (such as
>>>>>> 100GB+)
>>>>>> can only be caused on a 64-bit system, let PT_RECLAIM also depend on
>>>>>> 64BIT.
>>>>>>
>>>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>> ---
>>>>>>     arch/x86/Kconfig | 1 -
>>>>>>     mm/Kconfig       | 6 +-----
>>>>>>     2 files changed, 1 insertion(+), 6 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>>>>> index eac2e86056902..96bff81fd4787 100644
>>>>>> --- a/arch/x86/Kconfig
>>>>>> +++ b/arch/x86/Kconfig
>>>>>> @@ -330,7 +330,6 @@ config X86
>>>>>>         select FUNCTION_ALIGNMENT_4B
>>>>>>         imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>>>>>         select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>>>>>> -    select ARCH_SUPPORTS_PT_RECLAIM        if X86_64
>>>>>>         select ARCH_SUPPORTS_SCHED_SMT        if SMP
>>>>>>         select SCHED_SMT            if SMP
>>>>>>         select ARCH_SUPPORTS_SCHED_CLUSTER    if SMP
>>>>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>>>>> index a5a90b169435d..e795fbd69e50c 100644
>>>>>> --- a/mm/Kconfig
>>>>>> +++ b/mm/Kconfig
>>>>>> @@ -1440,14 +1440,10 @@ config ARCH_HAS_USER_SHADOW_STACK
>>>>>>           The architecture has hardware support for userspace shadow
>>>>>> call
>>>>>>               stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>>>>>> -config ARCH_SUPPORTS_PT_RECLAIM
>>>>>> -    def_bool n
>>>>>> -
>>>>>>     config PT_RECLAIM
>>>>>>         bool "reclaim empty user page table pages"
>>>>>>         default y
>>>>>> -    depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>>>>>> -    select MMU_GATHER_RCU_TABLE_FREE
>>>>>> +    depends on MMU_GATHER_RCU_TABLE_FREE && MMU && SMP && 64BIT
>>>>>
>>>>> Who would we have MMU_GATHER_RCU_TABLE_FREE without MMU? (can we drop
>>>>> the MMU part)
>>>>
>>>> OK.
>>>>
>>>>>
>>>>> Why do we care about SMP in the first place? (can we frop SMP)
>>>>
>>>> OK.
>>>>
>>>>>
>>>>> But I also wonder why we need "MMU_GATHER_RCU_TABLE_FREE && 64BIT":
>>>>>
>>>>> Would it be harmful on 32bit (sure, we might not reclaim as much, but
>>>>> still there is memory to be reclaimed?)?
>>>>
>>>> This is also fine on 32bit, but the benefits are not significant, So I
>>>> chose to enable it only on 64-bit.
>>>
>>> Right. Address space is smaller, but also memory is smaller. Not that I
>>> think we strictly *must* to support 32bit, I merely wonder why we
>>> wouldn't just enable it here.
>>>
>>> OTOH, if there is a good reason we cannot enable it, we can definitely
>>> just keep it 64bit only.
>>
>> The only difficulty is this:
>>
>>>
>>>>
>>>> I actually tried enabling MMU_GATHER_RCU_TABLE_FREE on all
>>>> architectures, and apart from sparc32 being a bit troublesome (because
>>>> it uses mm->page_table_lock for synchronization within
>>>> __pte_free_tlb()), the modifications were relatively simple.
>>
>> in sparc32:
>>
>> void pte_free(struct mm_struct *mm, pgtable_t ptep)
>> {
>>           struct page *page;
>>
>>           page = pfn_to_page(__nocache_pa((unsigned long)ptep) >>
>> PAGE_SHIFT);
>>           spin_lock(&mm->page_table_lock);
>>           if (page_ref_dec_return(page) == 1)
>>                   pagetable_dtor(page_ptdesc(page));
>>           spin_unlock(&mm->page_table_lock);
>>
>>           srmmu_free_nocache(ptep, SRMMU_PTE_TABLE_SIZE);
>> }
>>
>> #define __pte_free_tlb(tlb, pte, addr)  pte_free((tlb)->mm, pte)
>>
>> To enable MMU_GATHER_RCU_TABLE_FREE on sparc32, we need to implement
>> __tlb_remove_table(), and call the pte_free() above in 
>> __tlb_remove_table().
>>
>> However, the __tlb_remove_table() does not have an mm parameter:
>>
>> void __tlb_remove_table(void *_table)
>>
>> so we need to use another lock instead of mm->page_table_lock.
>>
>> I have already sent the v2 [1], and perhaps after that I can enable
>> PT_RECLAIM on all 32-bit architectures as well.
>>
> 
> I guess if we just make it depend on MMU_GATHER_RCU_TABLE_FREE that will 
> be fine.
> 
>> [1].
>> https://lore.kernel.org/all/ 
>> cover.1763537007.git.zhengqi.arch@bytedance.com/
>>
>>>>
>>>>>
>>>>> If all 64BIT support MMU_GATHER_RCU_TABLE_FREE (as you previously
>>>>> state), why can't we only check for 64BIT?
>>>>
>>>> OK, will do.
>>>
>>> This was also more of a question for discussion:
>>>
>>> Would it make sense to have
>>>
>>> config PT_RECLAIM
>>>       def_bool y
>>>       depends on MMU_GATHER_RCU_TABLE_FREE
>>
>> make sense.
>>
>>>
>>> (a) Would we want to make it configurable (why?)
>>
>> No, it was just out of caution before.
>>
>>> (b) Do we really care about SMP (why?)
>>
>> No. Simply because the following situation is impossible to occur:
>>
>> pte_offset_map
>> traversing the PTE page table
>>
>> <preemption or hardirq>
>>
>> call madvise(MADV_DONTNEED)
>>
>> so there's no need to free PTE page via RCU.
>>
>>> (c) Do we want to limit to 64bit (why?)
>>
>> No, just because the profit is greater at 64-BIT.
> 
> I was briefly wondering if on 32bit (but maybe also on 64bit with 
> configurable user page table levels?) we could have the scenario that we 
> only have two page table levels.
> 
> So reclaiming the PMD level (corresponding to the highest level) would 

reclaiming the PMD level? The PT_RECLAIM only reclaim PTE pages, not PMD
pages, am I misunderstanding something?

> be impossible. But for that to happen one would have to discard the 
> whole address range through MADV_DONTNEED (impossible I guess) :)
> 


