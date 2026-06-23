Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 608B1CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 12:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BE9C6B0088; Tue, 23 Jun 2026 08:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272196B008A; Tue, 23 Jun 2026 08:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1875C6B008C; Tue, 23 Jun 2026 08:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E37C36B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:43:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67EDEA04B5
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:43:40 +0000 (UTC)
X-FDA: 84911143800.19.14EA9EC
Received: from mail-m82152.xmail.ntesmail.com (mail-m82152.xmail.ntesmail.com [156.224.82.152])
	by imf06.hostedemail.com (Postfix) with ESMTP id E733F180010
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:43:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf06.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.152 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782218618;
	b=Fy2j7K6uX7RMrh8p0gfgEbQtv/M2YuKDGV3RyxG/NsNT9p99huRIPNlh6hD4f0M+UOICr8
	Sk/tpeaXDbbgESjzBzwXnTFUE1viN6Zub1OrdzJSy2LE2kKGwq9/SVmgMcsFtJKm/M+q7M
	88TXiWpwPmCWnHJR2Z1sDozFj1dwsBk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782218618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jz7oJ47z0/xmp/6MiqV0lejcYbJp+60j1lQP1nOkpP8=;
	b=cxMKyuvXrZLVABQx+NedyZjmKQMTHKnx8cGB+qvC8yHItSB6YAX46zDtumTAnf2BB3snlA
	QDrNZqNkmPy89u5QhGaY6L96cFoBtzbGI0IeWhacyPk02TG+t87wgUTYUaqz36mNyHvQZ8
	gEnzxpQX+DJIU+Gs2cefaXjVqTeiMEc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf06.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.152 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1bca25288;
	Tue, 23 Jun 2026 20:43:30 +0800 (GMT+08:00)
Message-ID: <eb759401-341b-4660-be70-f1525ca9bff8@easystack.cn>
Date: Tue, 23 Jun 2026 20:43:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260525081652.2210206-1-zhen.ni@easystack.cn>
 <20260525125819.1857f215bc56b26a0727bedc@linux-foundation.org>
 <5ef656db-c6b6-4a2c-b6be-628e5214952f@easystack.cn>
 <7b2125bb-c2d6-4678-9ae3-6f4e93034391@kernel.org>
 <444a6fd9-26dd-4d33-b836-987ef220b5f2@easystack.cn>
 <ef2db739-fa41-4203-91e5-61c0625ecbf4@kernel.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <ef2db739-fa41-4203-91e5-61c0625ecbf4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ef481d59b0229kunm463626fe2ab2
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZSU1IVkNPHRhKGk0fGU9OSlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Stat-Signature: onf5ezeat9un7octkfw8fyqbhw5tqsck
X-Rspamd-Queue-Id: E733F180010
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782218616-773549
X-HE-Meta: U2FsdGVkX1/aVNxmEzA1/U56WalN3TujYzRz6j+DDc89fAXU2sOWYygTJKo+uKqEhMuVsoSzR52jGLDWw4CXi5kE4qEkXLXoCM+D93tZFwDMe+JsT2SEaf11z9mDgd+9XQW3ndOSpH2/ysSKd6Sym+BfdW1waBHzsvYavCIjyrDK6Vi9zINjNdnXPhcB4tkNWSrYaV6n+tqAohGe8f92QQM2YhdqhP3uz3UkD+L/USrAawEoxr0YtKrEAIDWz7SdYexUjNw9cpP8dNKeaQGq864FHKMugD1plQ1PrgPPzYpkZSgKgG3Yqghm7Dqz6lu/9Jd1GkXdHYpvCuOav7+v3IgsTuRhZYR1HCtiPjuaoMjgbg4r12bgUUZ/CVNZOnkxvaRpzcPz/+DkMohr9MO2XEPRkESMcLoMxZDVwb/2yrYb/okZryJdWW4ysyLzvLQczOMHgpEVad5DNbuEq0Q8ExnJZ/VID+TQWOIC/1MjChWPB2pJ5ZeyXT9+6/TSP158vg20/mYXO5Cnknk08+1Z9YnVGUwhglEXnHrEZ5wplH3/nPuY7tDQ13Qud7A6Mg0cG8CZ5m1tXOO48ZrYCtEZ6LL4dZJGFIQ6onnwODojfUMVn+8YCSfHTAiugp+W5PPPZhG8JiwfSxfi4r4weAFQ3kAZt64BAkMB4eEH6n14ViupLkkoUPL2yiJiXrxzIhYAN0I4wftmGvywLXUXsn1Sjhl3wmFUaaMy2CaJkHwapMLSlfoRaOS54sa+jEnEKt5d3eFrjwqcinf+MZptwgO38K3faeVqk81O7xfWSdjFOR4msN6fJXzf4OkjfEWPqpkO3PIbQs0H0STP+BS28tGBncL6RMoGdIySBh5kS/f6mfWNLPALSZozGuY88ScKs5SMIMEC8gFcvSp9giEKMzxnHYAIE9HgzChrWVyTlgKPX6X8rRFy/96r/JP0xU2GJaQjV+MD9bTUUb3CPgvUsI7
 N2ODN9T5
 zcY363JZ0jM6lm2fAV0aPzYzrcUqZrCGZj4ErasrADUy8tIH5mMGvQgZT5vLDktF9a6bLJHAFyG1j6wJkLevp7FRJQZ8E9pFTbMMQwxRwYYTOXtk/JQAokAT0eo4YI/hz3Bu18Ok9HW122qWMJ9TieICadqmxhF2LYnA+54GwoiHKWAh8Il5NqucxmlwRsZT5cpAQTkJFdtSBPDwAzK8NunGh3tnmeZaJPjwrwWJDrhTY667weFX8PPC30cyn/BfdVx3te3VUSNvNgFr44IvU7LRIPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/23 14:52, Vlastimil Babka (SUSE) 写道:
> On 6/18/26 10:15, zhen.ni wrote:
>>
>>
>> 在 2026/6/18 15:27, Vlastimil Babka (SUSE) 写道:
>>> On 6/17/26 10:52, zhen.ni wrote:
>>>> 在 2026/5/26 03:58, Andrew Morton 写道:
>>>>> On Mon, 25 May 2026 16:16:48 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
>>>>>
>>>>>> This patch series introduces per-file-descriptor filtering capabilities to the
>>>>>> page_owner feature.
>>>>>
>>>>> Thanks again.  AI review has found a bunch of new things to get worried
>>>>> about:
>>>>> 	https://sashiko.dev/#/patchset/20260525081652.2210206-1-zhen.ni@easystack.cn
>>>>>
>>>>>
>>>> Hi,
>>>>
>>>> Can this lead to an out-of-bounds memory read?
>>>>
>>>> The NUMA filter in page_owner (mm/page_owner.c:790-798) bypasses
>>>> PF_POISONED_CHECK() to avoid triggering VM_BUG_ON during concurrent page
>>>> allocation/free:
>>>>
>>>>        int page_nid = memdesc_nid(page->flags);
>>>>
>>>> When NODE_NOT_IN_PAGE_FLAGS is defined, memdesc_nid() performs unchecked
>>>> array access:
>>>>
>>>>        int memdesc_nid(memdesc_flags_t mdf)
>>>>        {
>>>>            return section_to_node_table[memdesc_section(mdf)];
>>>>        }
>>>>
>>>> If page->flags is poisoned, memdesc_section() can return a garbage
>>>> section_nr that causes out-of-bounds access.
>>>>
>>>> ## Lockless Access Safety Principle
>>>>
>>>> The page_owner iterator runs without locks, meaning pages can be
>>>> allocated or freed concurrently. The fundamental design principle should be:
>>>>
>>>> "It's acceptable to skip a small number of abnormal pages, but panics
>>>> must be prevented."
>>>>
>>>> In lockless iteration, TOCTOU is unavoidable - even with reference
>>>> counting or RCU, page->flags can still be modified concurrently during
>>>> access. Zone locks prevent this but are prohibitively expensive.
>>>>
>>>> ## Proposed Solution: Add nid to struct page_owner
>>>>
>>>> Record nid at allocation time when page state is stable, eliminating the
>>>> need to extract it from page->flags during iteration:
>>>>
>>>> ### 1. Modify struct page_owner
>>>>
>>>>        struct page_owner {
>>>>            unsigned short order;
>>>>            short last_migrate_reason;
>>>>            ...
>>>>            pid_t tgid;
>>>>            pid_t free_pid;
>>>>            pid_t free_tgid;
>>>>            int nid;  // NEW
>>>>        };
>>>>
>>>> ### 2. Record nid during allocation
>>>>
>>>>        static inline void __update_page_owner_handle(struct page *page, ...)
>>>>        {
>>>>            int nid = page_to_nid(page);  // Safe in allocation context
>>>>
>>>>            for_each_page_ext(page, 1 << order, page_ext, iter) {
>>>>                page_owner = get_page_owner(page_ext);
>>>>                page_owner->nid = nid;
>>>>                // ... other fields ...
>>>>            }
>>>>        }
>>>>
>>>> ### 3. Use saved nid in NUMA filter
>>>>
>>>>        if (state->nid_filter_enabled) {
>>>>            int page_nid = page_owner->nid;  // Direct read, safe
>>>>
>>>>            if (!node_isset(page_nid, state->nid_filter)) {
>>>>                spin_unlock_irqrestore(&state->lock, flags);
>>>>                goto ext_put_continue;
>>>>            }
>>>>        }
>>>>
>>>> ### 4. Update nid on page migration
>>>>
>>>>        // In split_page_owner() when page migrates
>>>>        page_owner->nid = page_to_nid(&newfolio->page);
>>>>
>>>
>>> This (presumably LLM) suggestion is a, let's say "lazy" solution to the
>>> problem, leading to more memory usage. I'd be surprised if it's not possible
>>> to read the nid in a way that avoids the hazards. If page_to_nid() can
>>> trigger a VM_BUG_ON(), then I'd add a version without that VM_BUG_ON(),
>>> handling the poisoned state gracefully - if it's poisoned, return e.g.
>>> NUMA_NO_NODE and skip the page, or something.
>>>
>>>> The remaining two issues can also be improved. If there are no
>>>> additional comments, I will proceed with sending v10.
>>>>
>>>>
>>>> Thanks,
>>>> Zhen
>>>
>>>
>>>
>>
>> Thank you for the review.
>>
>> I'd like to clarify that the "nid" member approach was my own design
>> after careful consideration of alternatives, not a suggestion from
>> automated tools.:)
> 
> Alright, good :)
> 
>> In fact, LLMs suggested approaches like "check then access" which I had
>> already implemented and rejected in earlier versions due to TOCTOU
>> issues. The key insight is that page_owner serves as a buffering layer
>> for struct page,  eliminating lockless access inconsistency entirely.
> 
> Sure, but is the elimination necessary if it has a memory cost?
> 
>> Think about it this way:
>> Even with extensive checks, page_owner->handle cannot guarantee the page
>> won't be freed when printed. The time window between checking
>> page->flags and accessing page->flags is unavoidable in lockless
>> iteration.
> 
> Of course, but that's an argument saying that page owner as a whole can't be
> a perfect snapshot anyway. Then it follows that "nid" snapshot doesn't need
> to be perfect either.
> 
>> By recording nid at allocation time (when page->flags is stable),
>> page_owner becomes a "consistent snapshot" that can be safely accessed
>> without locks. This is the same principle that makes page_owner work as
>> a debug feature in the first place - it accepts a small inconsistency
>> window in exchange for lockless access.
> 
> And that means we can accept some more small inconsistency for nid, without
> occupying more memory.
> 
>> Alternative approaches (adding poison checks, bounds checking) cannot
>> fully eliminate TOCTOU in lockless code - they just reduce the
>> probability. The buffering approach is the way to provide both
>> safety and lockless performance.
> 
> Please explain how the following "page_to_nid_robust()" (or similar name)
> code cannot eliminate the out of bounds accesses completely. The section/nid
> in page flags is possibly the most stable part of the whole struct page, it
> doesn't change as page is allocated, freed, or how it's used. The only
> problem is the poison.
> 
> memdesc_flags_t flags = READ_ONCE(page->flags);
> 
> // our flags variable is no longer subject to TOCTOU
> 
> if (flags.f == PAGE_POISON_PATTERN)
> 	return NUMA_NO_NODE;
> 
> return memdesc_nid(flags);
> 
> -
>> Thanks,
>> Zhen
> 
> 
>
Hi,


I agree that saving page->flags to a local variable can prevent TOCTOU. 
Both the nid member and page_to_nid_robust approaches are functionally 
equivalent, but the memory cost of the nid member is real.

Here's how I'm handling this logic:

     if (state->nid_filter_enabled) {
         int nid;
         memdesc_flags_t page_flags = READ_ONCE(page->flags);

         if (page_flags.f == PAGE_POISON_PATTERN) {
             spin_unlock_irqrestore(&state->lock, flags);
             goto ext_put_continue;
         }
         nid = memdesc_nid(page_flags);
         if (!node_isset(nid, state->nid_filter)) {
             spin_unlock_irqrestore(&state->lock, flags);
             goto ext_put_continue;
         }
     }

This might not be suited to be a separate public function - here we
just need to check if the page is poisoned to prevent crashes. If it
were a public function, it might need to check if the page exists
before getting nid.

If you have further suggestions, please let me know.

Thanks,
Zhen

