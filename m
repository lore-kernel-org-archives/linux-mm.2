Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1283CF3198
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 11:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360B06B00A3; Wed, 19 Nov 2025 06:02:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 337D46B00A4; Wed, 19 Nov 2025 06:02:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 274266B00A9; Wed, 19 Nov 2025 06:02:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 169F16B00A3
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 06:02:15 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D846A4E383
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:02:14 +0000 (UTC)
X-FDA: 84127067388.04.87EC5CC
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id CB673100003
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:02:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mP/P3lxt";
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763550133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pWCjd1KJePPhJ2kBW/1JQctwuUbeN7emyFaJsPF+13s=;
	b=LJnBgKm2csMTju/uDedbFsPx+Ggd3UukEDxsw2vGnrhRv07ycK/kqVByylPwArjhKfOnhW
	JQ/e9SavvpcyZN1C4lczVfGfDYohjMCebJp3NGXGrlsnmgVFKeox9ju/7sARC8rAH/AzO6
	wwKT3dd1wU5nwJt86ZCqPaL5gK4P9W0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763550133; a=rsa-sha256;
	cv=none;
	b=EqoGTCVSeKlUFaQ46hGp4fB85d6nyiBjNetZT0yhocM1uizEOqLGWPlOhoX5kpsDeMdZ4l
	Rho/ioQHZssfD+J5318pqUsN+EhfdbI6YEixMDZxJJbdXNVs9PiIeRm7tbebIiajBz619A
	bFerwLysoZQfT3B8VX1nVeDNgMoulnQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mP/P3lxt";
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <956c7ca1-bce8-4eed-8a86-bc8adfc708b8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763550129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pWCjd1KJePPhJ2kBW/1JQctwuUbeN7emyFaJsPF+13s=;
	b=mP/P3lxthQRt4RBNI75YZfNBnXZAmkVQUWXJ/rGkrYoFs+cdyTatJFvEAkxHy17h5PcVU7
	Lk+c5TNjUFkOX+52zWjraznru5UeZZ0zArHNg+EAlhJsCa8P85HvXHgzZV0dRjfvL/z3qw
	3uyQEOwjBq6far+PazqEXVEHQS/Z8sg=
Date: Wed, 19 Nov 2025 19:02:01 +0800
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <9386032c-9840-49da-83f9-74b112f3e752@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CB673100003
X-Stat-Signature: b6am71g8tmz7dfd3ioycx8e96acjfpsu
X-Rspam-User: 
X-HE-Tag: 1763550132-882770
X-HE-Meta: U2FsdGVkX18/my2cg45KL1zVZc3quxVjcHxc9lvGGF9dvswYL213SBvCqulf1JFNEhAnTplOCo34R6ISaRWwnaT20YfujsLKw4iuuXjgXaucZTMUyGEBp6qsbncVLude0sIOmXHnO7wNl64H+JYZDG9RE0UuXTPMzlU/pP+pQoaWeelMNDd+uFK2UxV7ef+Zbw7LEEp4uSp0Op5eEGhdZodRo3eV8YrIG0N4NvVxbgyRhqsxmxiFsSD1KyPrz/kufdUpMdpPrKiKLLkOaU0STV6boJ2Gzic7BD36D8rg6XQFULi8lYTBLXJcmZuxm7e4rmKI4IGmCV3Hok6ZyE6NCMv36zXbiYbsDk5RetC+T3kMV/cI0FYsil57D9jNMVhaniBPrjI4G0rvL+ohFenISX1B+8gfKlh7cejszBHItBz5j/b9cvbH66uVbkPtG1lwfWi/eU9MoqFCrPz9VdgLaYnnf/n4fs/PTCIxL4nUBEatEJjqalsPPS27XvYP0b5Va7Zr5yID2YGCkL1gsou5jm+AltkNoYrb542g1psmmCDXD3n9WrTXlu1bPFv5Pazpe8YoyYDYH0yeQ8xt90RF90RV4xDFL/0pSnuG4E+3hF3MwJs227BDOrVVIZtND52dF9LmqPtH/k57ZpQGlAF+LoAq5zKm8CWW1c06HN3J2S4bRLE87CbUgrsFH4Xcm/HEmfmNeVypni+IUqHhw+NCeKtAdgKjn5If9udesyvzZUKUxCvnjMlgo1gSfrVpTYl1fZ51kfa4O66XhcMsIZIdKe4c365YQOZyEq6BC4UmzzpNs9O2yzjjHIqBU9p5QWa1dgL7PNmVeuwFBc5d0gwWrmoVrMudzv4y0pt/S55liWrnEOU/tE6OJb0wqat3tPqdcjHRbSPdi1ylEyPFvY4qdRrEMHmJWD1jA11Wav8PUVJbkiRnaqteV81EqBAo0i8Wh9EkYVnYuWcff1EdpSD
 kAhDPS8q
 95lMq0Sc6V3r9ucKPqNDt5iuSJgmrj+fgMP+4nMKTiSJQrnqClqVaJu0lq1NKiM7Ln+W0MrKdtYW+N2TW+aE+ZO3rZb21COj5Uw9uS4aAjxYPIi1+50hKcW0anOi2IRa/Yv2nXXtAUu7ue8zgUilCOyZS9YIv6wz0xMqUfilU9yVmcvbdY/gq0YIIXS1N44WaGWZU+SkWS9b6a6Cek9rJmHD7XLtzDKW89HvuXbLS2/gOFDnBO2NpVB+58JoSwCokR8EZbPaNvYjZ/+5UtQLQQFE0HmMr2qy5pusGjX8S1voo8VsVVPlkTq4EbhBYcdC27mJWpsoZ1TW2srg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On 11/19/25 6:19 PM, David Hildenbrand (Red Hat) wrote:
> On 18.11.25 13:02, Qi Zheng wrote:
>>
>>
>> On 11/18/25 12:57 AM, David Hildenbrand (Red Hat) wrote:
>>> On 14.11.25 12:11, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>
>>> Subject: s/&&/&/
>>
>> will do.
>>
>>>
>>>>
>>>> Make PT_RECLAIM depend on MMU_GATHER_RCU_TABLE_FREE so that PT_RECLAIM
>>>> can
>>>> be enabled by default on all architectures that support
>>>> MMU_GATHER_RCU_TABLE_FREE.
>>>>
>>>> Considering that a large number of PTE page table pages (such as 
>>>> 100GB+)
>>>> can only be caused on a 64-bit system, let PT_RECLAIM also depend on
>>>> 64BIT.
>>>>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>> ---
>>>>    arch/x86/Kconfig | 1 -
>>>>    mm/Kconfig       | 6 +-----
>>>>    2 files changed, 1 insertion(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>>> index eac2e86056902..96bff81fd4787 100644
>>>> --- a/arch/x86/Kconfig
>>>> +++ b/arch/x86/Kconfig
>>>> @@ -330,7 +330,6 @@ config X86
>>>>        select FUNCTION_ALIGNMENT_4B
>>>>        imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>>>>        select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>>>> -    select ARCH_SUPPORTS_PT_RECLAIM        if X86_64
>>>>        select ARCH_SUPPORTS_SCHED_SMT        if SMP
>>>>        select SCHED_SMT            if SMP
>>>>        select ARCH_SUPPORTS_SCHED_CLUSTER    if SMP
>>>> diff --git a/mm/Kconfig b/mm/Kconfig
>>>> index a5a90b169435d..e795fbd69e50c 100644
>>>> --- a/mm/Kconfig
>>>> +++ b/mm/Kconfig
>>>> @@ -1440,14 +1440,10 @@ config ARCH_HAS_USER_SHADOW_STACK
>>>>          The architecture has hardware support for userspace shadow 
>>>> call
>>>>              stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>>>> -config ARCH_SUPPORTS_PT_RECLAIM
>>>> -    def_bool n
>>>> -
>>>>    config PT_RECLAIM
>>>>        bool "reclaim empty user page table pages"
>>>>        default y
>>>> -    depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>>>> -    select MMU_GATHER_RCU_TABLE_FREE
>>>> +    depends on MMU_GATHER_RCU_TABLE_FREE && MMU && SMP && 64BIT
>>>
>>> Who would we have MMU_GATHER_RCU_TABLE_FREE without MMU? (can we drop
>>> the MMU part)
>>
>> OK.
>>
>>>
>>> Why do we care about SMP in the first place? (can we frop SMP)
>>
>> OK.
>>
>>>
>>> But I also wonder why we need "MMU_GATHER_RCU_TABLE_FREE && 64BIT":
>>>
>>> Would it be harmful on 32bit (sure, we might not reclaim as much, but
>>> still there is memory to be reclaimed?)?
>>
>> This is also fine on 32bit, but the benefits are not significant, So I
>> chose to enable it only on 64-bit.
> 
> Right. Address space is smaller, but also memory is smaller. Not that I 
> think we strictly *must* to support 32bit, I merely wonder why we 
> wouldn't just enable it here.
> 
> OTOH, if there is a good reason we cannot enable it, we can definitely 
> just keep it 64bit only.

The only difficulty is this:

> 
>>
>> I actually tried enabling MMU_GATHER_RCU_TABLE_FREE on all
>> architectures, and apart from sparc32 being a bit troublesome (because
>> it uses mm->page_table_lock for synchronization within
>> __pte_free_tlb()), the modifications were relatively simple.

in sparc32:

void pte_free(struct mm_struct *mm, pgtable_t ptep)
{
         struct page *page;

         page = pfn_to_page(__nocache_pa((unsigned long)ptep) >> 
PAGE_SHIFT);
         spin_lock(&mm->page_table_lock);
         if (page_ref_dec_return(page) == 1)
                 pagetable_dtor(page_ptdesc(page));
         spin_unlock(&mm->page_table_lock);

         srmmu_free_nocache(ptep, SRMMU_PTE_TABLE_SIZE);
}

#define __pte_free_tlb(tlb, pte, addr)  pte_free((tlb)->mm, pte)

To enable MMU_GATHER_RCU_TABLE_FREE on sparc32, we need to implement
__tlb_remove_table(), and call the pte_free() above in __tlb_remove_table().

However, the __tlb_remove_table() does not have an mm parameter:

void __tlb_remove_table(void *_table)

so we need to use another lock instead of mm->page_table_lock.

I have already sent the v2 [1], and perhaps after that I can enable
PT_RECLAIM on all 32-bit architectures as well.

[1]. 
https://lore.kernel.org/all/cover.1763537007.git.zhengqi.arch@bytedance.com/

>>
>>>
>>> If all 64BIT support MMU_GATHER_RCU_TABLE_FREE (as you previously
>>> state), why can't we only check for 64BIT?
>>
>> OK, will do.
> 
> This was also more of a question for discussion:
> 
> Would it make sense to have
> 
> config PT_RECLAIM
>      def_bool y
>      depends on MMU_GATHER_RCU_TABLE_FREE

make sense.

> 
> (a) Would we want to make it configurable (why?)

No, it was just out of caution before.

> (b) Do we really care about SMP (why?)

No. Simply because the following situation is impossible to occur:

pte_offset_map
traversing the PTE page table

<preemption or hardirq>

call madvise(MADV_DONTNEED)

so there's no need to free PTE page via RCU.

> (c) Do we want to limit to 64bit (why?)

No, just because the profit is greater at 64-BIT.

> (d) Do we really need the MMU check in addition to
>      MMU_GATHER_RCU_TABLE_FREE

No, I was worried about compilation issues before, but now it seems that
my worries were unnecessary.

Thanks,
Qi

> 
> 


