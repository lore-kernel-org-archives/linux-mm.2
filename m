Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F7E1CF31B0
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 12:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AEB66B00B0; Wed, 19 Nov 2025 07:24:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85EF36B00B4; Wed, 19 Nov 2025 07:24:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74DFB6B00B5; Wed, 19 Nov 2025 07:24:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5FDF56B00B0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:24:47 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 119D51A0472
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:24:47 +0000 (UTC)
X-FDA: 84127275414.25.C44F571
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 224A140003
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:24:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OBSgFKD3;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763555085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2dwmow3TuepoCNwXY3P6hcFzEoPrM376KiDIO88jNoM=;
	b=KBRZ+EE4jRLSw+OOwNIm22X/+QneE8RijZBaIuXjNoYdtiwtZF3TxQlux+7Daf9LuFgk4O
	BUZ6P/1SMDPN8WvGipMbe66TVYLKMSixfad3v74LUQh2PDxW0SV+50dGBRmA8OFrPfvt3c
	5bHRqYv/eq3BWaujZhcMp9ggicR2w00=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OBSgFKD3;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763555085; a=rsa-sha256;
	cv=none;
	b=frKZt16plid001KyLXTV6ta3YMr1w1tHG/0JZzwbOiUv7HpAdasqzMTETkxpX+EsXbz+t0
	r9lj6Rixg4sxWFVEjai6BLb2Qml7ainB0jbu80MNF+H96kCnAZV4K9Bi0feQmsGgRycqKb
	vvGmA4ujttMc02BxkecMsbnOgbSzQJE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EAD8432FE;
	Wed, 19 Nov 2025 12:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EBCC116D0;
	Wed, 19 Nov 2025 12:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763555083;
	bh=iBiJTRsmPeT8yT7z7CbiOkAhObefLKlCnyqgtKvMuCk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OBSgFKD3+2NvaYtuKw/QdLvJ4kd1qTjKiTeRyHWtELBx2sa2VxIWisexyF7jgJgeD
	 8/7qcHogwMEYULif7/zT0Blo6SdqmJfDDkjOtqvhR34sRQy8h5rR4W7ewalVmRGYey
	 Jc1bz1eKKmip3Nhp5EEVKNnH4+TcAvXMYIX4DJVlFe1cnT7kWo4T2BMafaaKj6W0QE
	 tksi9TyyDvEnpbaBkBecgBzphpzgjI0aD0eMgPZ+3ODv+MpVNh0XNg8xSfrSSBC/HP
	 tX3pn90oDkV+9B6k4FD+XGPRfz+Fs8u7hySZerofnUkosVm2LUZ1/W1me0CAQMB7jS
	 lCDTRg/6ptIBg==
Message-ID: <7160b6ec-4da5-4273-be91-1339bd00d009@kernel.org>
Date: Wed, 19 Nov 2025 13:24:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] mm: make PT_RECLAIM depend on
 MMU_GATHER_RCU_TABLE_FREE && 64BIT
To: Qi Zheng <qi.zheng@linux.dev>, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, peterz@infradead.org, dev.jain@arm.com,
 akpm@linux-foundation.org, ioworker0@gmail.com
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
 <479b0409-335f-4450-8eb2-5270a5847f5e@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <479b0409-335f-4450-8eb2-5270a5847f5e@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 224A140003
X-Stat-Signature: m7h7oat8anxqfqxxt1k7mdkxiora4891
X-Rspam-User: 
X-HE-Tag: 1763555084-19316
X-HE-Meta: U2FsdGVkX19LecPijM626StIYMffJHrxmlHdmKuWWITaOOjNYzXPxX49Rn8k6Aio3sGTqpE6gJlkKybEzcZqFx8+kMUfp+m3YdUY5wa6ugyKrI2rv20vcXTWj3lpBsLQVkQOqPLpbNYqDykDIt5APSYAuy8MPxehrETQCaZrBzslHMsB/pM/y/8UVqDRlbasq9xcDcGTMZwJ/vZI/oKagB0lRI8b6jFLql/jBIbXAv4jO0DgOKyIIzPgIzd1XV1plGxAL2QIqOrtvpqZgUqpSnnHwZDP0GzPdDJRLM8R7Btz4MpUHaXs1wN/KE3gHgPu3N/EP8WKoVGr6WU585OaRYint/j6KNTwBsTvG+S0ciHXGEdX91QyV8lG8XhXOd7O8WTz77+ecutPB0iBj3mAFUP1Rwlj+2BpTtkv8+6dLlERSon+2xBzM5hlqu9w6yL//e0vE/jGvTJAuumvDhRCbI3eXW2Q/mGept0n6xniz62iWpMg440T4cpvS4lTl80Ca/mnEVlPmzq8XTmIG+6LLJso1C3kKWeY4QPh1J63FrjwT4+OHJyYTpUAuwpDVyTc7A/RWBaDiiaFmQb/ofNjcDFMOtAMuqQE3j53/BUEdBRCip0w/mmQj6GV5L3paaxEsxxybHh7EB5Pepvcmm0/+dzPczxiYIKDQAjaDqqxRYxKa8Sx6Y6NJ1fpbK6pnxImaaE2UzMVLf436Rt3d4maAg60KMiV8xzILXsxq6KiMrUiCuSbR5U1pxho9dpK4/jZoRweFPImk1lo90J8+7S1hFxXlOBLWlaQp+4MaCXVD0iNokOVgQRZC2b0OO2Au7qbPhrtu8+bWsI8iHPwEmdaUxNeeu+S855grig4RuSBw6blqDqA0eoremXCYvBXCBO82RYOAthHVQpvOr9cq8zY74MYWtFhO7RUJexB5izuA40FHsvJziHX+eKxAdB+k4/e2H82/+x0xlM8YWRNjzl
 OzJevpJz
 UYhDl8RGz4dHctATtDZzHAOLeQaCiTeYkrMdTKVEWf2kMCMRGNU4bKuZiMSgw3ICHjhrURkkZw2ylSkdb4caVIoMDhZFJZP/OqNKykMQnWY2Uq8lzKv0E8GHynmPKmnvsMXeO8fVR3ruUiuBhjZKIqqx7hSw+d7w2jBxoZVkYWa1soM50fIaHk4/RdsYRg3zcJROSYSaaZHqS3Xlqm2x81QVIvo/ZRnZBXUuzXW9h4IdmFiu7y7HKrX/CIJEh51gB5XX5kckCjSK/H9550s6n0iSXe4fw9lbqxu29242lP/98vw82kORaw2yACNE+/LQdGECdU5cIfhvgHcG1xgB64nAUOib/WEvWqO/FZ4RgwVUn9i4tplxOyA2IiJS1uBiKMgNd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.11.25 13:13, Qi Zheng wrote:
> 
> 
> On 11/19/25 7:35 PM, David Hildenbrand (Red Hat) wrote:
>> On 19.11.25 12:02, Qi Zheng wrote:
>>> Hi David,
>>>
>>> On 11/19/25 6:19 PM, David Hildenbrand (Red Hat) wrote:
>>>> On 18.11.25 13:02, Qi Zheng wrote:
>>>>>
>>>>>
>>>>> On 11/18/25 12:57 AM, David Hildenbrand (Red Hat) wrote:
>>>>>> On 14.11.25 12:11, Qi Zheng wrote:
>>>>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>>
>>>>>> Subject: s/&&/&/
>>>>>
>>>>> will do.
>>>>>
>>>>>>
>>>>>>>
>>>>>>> Make PT_RECLAIM depend on MMU_GATHER_RCU_TABLE_FREE so that
>>>>>>> PT_RECLAIM
>>>>>>> can
>>>>>>> be enabled by default on all architectures that support
>>>>>>> MMU_GATHER_RCU_TABLE_FREE.
>>>>>>>
>>>>>>> Considering that a large number of PTE page table pages (such as
>>>>>>> 100GB+)
>>>>>>> can only be caused on a 64-bit system, let PT_RECLAIM also depend on
>>>>>>> 64BIT.
>>>>>>>
>>>>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>>> ---
>>>>>>>      arch/x86/Kconfig | 1 -
>>>>>>>      mm/Kconfig       | 6 +-----
>>>>>>>      2 files changed, 1 insertion(+), 6 deletions(-)
>>>>>>>
>>>>>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>>>>>> index eac2e86056902..96bff81fd4787 100644
>>>>>>> --- a/arch/x86/Kconfig
>>>>>>> +++ b/arch/x86/Kconfig
>>>>>>> @@ -330,7 +330,6 @@ config X86
>>>>>>>          select FUNCTION_ALIGNMENT_4B
>>>>>>>          imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>>>>>>          select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>>>>>>> -    select ARCH_SUPPORTS_PT_RECLAIM        if X86_64
>>>>>>>          select ARCH_SUPPORTS_SCHED_SMT        if SMP
>>>>>>>          select SCHED_SMT            if SMP
>>>>>>>          select ARCH_SUPPORTS_SCHED_CLUSTER    if SMP
>>>>>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>>>>>> index a5a90b169435d..e795fbd69e50c 100644
>>>>>>> --- a/mm/Kconfig
>>>>>>> +++ b/mm/Kconfig
>>>>>>> @@ -1440,14 +1440,10 @@ config ARCH_HAS_USER_SHADOW_STACK
>>>>>>>            The architecture has hardware support for userspace shadow
>>>>>>> call
>>>>>>>                stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>>>>>>> -config ARCH_SUPPORTS_PT_RECLAIM
>>>>>>> -    def_bool n
>>>>>>> -
>>>>>>>      config PT_RECLAIM
>>>>>>>          bool "reclaim empty user page table pages"
>>>>>>>          default y
>>>>>>> -    depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>>>>>>> -    select MMU_GATHER_RCU_TABLE_FREE
>>>>>>> +    depends on MMU_GATHER_RCU_TABLE_FREE && MMU && SMP && 64BIT
>>>>>>
>>>>>> Who would we have MMU_GATHER_RCU_TABLE_FREE without MMU? (can we drop
>>>>>> the MMU part)
>>>>>
>>>>> OK.
>>>>>
>>>>>>
>>>>>> Why do we care about SMP in the first place? (can we frop SMP)
>>>>>
>>>>> OK.
>>>>>
>>>>>>
>>>>>> But I also wonder why we need "MMU_GATHER_RCU_TABLE_FREE && 64BIT":
>>>>>>
>>>>>> Would it be harmful on 32bit (sure, we might not reclaim as much, but
>>>>>> still there is memory to be reclaimed?)?
>>>>>
>>>>> This is also fine on 32bit, but the benefits are not significant, So I
>>>>> chose to enable it only on 64-bit.
>>>>
>>>> Right. Address space is smaller, but also memory is smaller. Not that I
>>>> think we strictly *must* to support 32bit, I merely wonder why we
>>>> wouldn't just enable it here.
>>>>
>>>> OTOH, if there is a good reason we cannot enable it, we can definitely
>>>> just keep it 64bit only.
>>>
>>> The only difficulty is this:
>>>
>>>>
>>>>>
>>>>> I actually tried enabling MMU_GATHER_RCU_TABLE_FREE on all
>>>>> architectures, and apart from sparc32 being a bit troublesome (because
>>>>> it uses mm->page_table_lock for synchronization within
>>>>> __pte_free_tlb()), the modifications were relatively simple.
>>>
>>> in sparc32:
>>>
>>> void pte_free(struct mm_struct *mm, pgtable_t ptep)
>>> {
>>>            struct page *page;
>>>
>>>            page = pfn_to_page(__nocache_pa((unsigned long)ptep) >>
>>> PAGE_SHIFT);
>>>            spin_lock(&mm->page_table_lock);
>>>            if (page_ref_dec_return(page) == 1)
>>>                    pagetable_dtor(page_ptdesc(page));
>>>            spin_unlock(&mm->page_table_lock);
>>>
>>>            srmmu_free_nocache(ptep, SRMMU_PTE_TABLE_SIZE);
>>> }
>>>
>>> #define __pte_free_tlb(tlb, pte, addr)  pte_free((tlb)->mm, pte)
>>>
>>> To enable MMU_GATHER_RCU_TABLE_FREE on sparc32, we need to implement
>>> __tlb_remove_table(), and call the pte_free() above in
>>> __tlb_remove_table().
>>>
>>> However, the __tlb_remove_table() does not have an mm parameter:
>>>
>>> void __tlb_remove_table(void *_table)
>>>
>>> so we need to use another lock instead of mm->page_table_lock.
>>>
>>> I have already sent the v2 [1], and perhaps after that I can enable
>>> PT_RECLAIM on all 32-bit architectures as well.
>>>
>>
>> I guess if we just make it depend on MMU_GATHER_RCU_TABLE_FREE that will
>> be fine.
>>
>>> [1].
>>> https://lore.kernel.org/all/
>>> cover.1763537007.git.zhengqi.arch@bytedance.com/
>>>
>>>>>
>>>>>>
>>>>>> If all 64BIT support MMU_GATHER_RCU_TABLE_FREE (as you previously
>>>>>> state), why can't we only check for 64BIT?
>>>>>
>>>>> OK, will do.
>>>>
>>>> This was also more of a question for discussion:
>>>>
>>>> Would it make sense to have
>>>>
>>>> config PT_RECLAIM
>>>>        def_bool y
>>>>        depends on MMU_GATHER_RCU_TABLE_FREE
>>>
>>> make sense.
>>>
>>>>
>>>> (a) Would we want to make it configurable (why?)
>>>
>>> No, it was just out of caution before.
>>>
>>>> (b) Do we really care about SMP (why?)
>>>
>>> No. Simply because the following situation is impossible to occur:
>>>
>>> pte_offset_map
>>> traversing the PTE page table
>>>
>>> <preemption or hardirq>
>>>
>>> call madvise(MADV_DONTNEED)
>>>
>>> so there's no need to free PTE page via RCU.
>>>
>>>> (c) Do we want to limit to 64bit (why?)
>>>
>>> No, just because the profit is greater at 64-BIT.
>>
>> I was briefly wondering if on 32bit (but maybe also on 64bit with
>> configurable user page table levels?) we could have the scenario that we
>> only have two page table levels.
>>
>> So reclaiming the PMD level (corresponding to the highest level) would
> 
> reclaiming the PMD level? The PT_RECLAIM only reclaim PTE pages, not PMD
> pages, am I misunderstanding something?

Sorry, I looked too much into PMD table sharing the last days :D

You're right, it would work in any case even with only 2 levels of apge 
tables.

-- 
Cheers

David

