Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC93C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 01:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5496B00A6; Tue, 30 Jun 2026 21:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6236B00A8; Tue, 30 Jun 2026 21:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6F046B00A9; Tue, 30 Jun 2026 21:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6272F6B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:47:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B85B7401AE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:47:58 +0000 (UTC)
X-FDA: 84938521836.15.AD7A65F
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8065740004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:47:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ACb/zxQc";
	spf=pass (imf04.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782870476;
	b=1fuH2pfznwsFRjUlG4Lh8kE3r7u2WfGrCplJYOw0HVonZQJuaKNzGnHnJbSzxlIC/A+7bC
	uHt/GMj5P+8TuF08r2wh4QVhQC2i1pHSZJGMm7V6XFcYHqfj3vpNTDX/nlUU23lspXnJT6
	TxU0oRrNmo5cOupGumWPycJro1EDfeo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782870476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysLxtr1n2K4bo9wRx4/EdIOpK0zk8mIVVHbKxk1Ez/4=;
	b=Aqs2w9LRKA5+1L5TwVtrwRwLIfQ8MLRshcdcWtHbAyafeesFQK5wcsO473QjqKZlv8XL86
	w63A7dUP5Eia+VQT3PG0979smP+mkKisWzYhAh707vRNZHnvBfwY4582Ep8+X7uM/xEnJr
	Vj3yf9gGgHPSw1l9SuJW7XB3QjrK9xM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ACb/zxQc";
	spf=pass (imf04.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <97e35cad-20f8-46cf-ae37-18fecb978e2f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782870474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ysLxtr1n2K4bo9wRx4/EdIOpK0zk8mIVVHbKxk1Ez/4=;
	b=ACb/zxQcg/Qyy9PQAB+n+SdUBjP5gkfNkc0qneHUbVvZLKbT35HJ0QyVpHyP3DOEy0Oljn
	J/BViD0FXAgiAlMq0EVr4v3VL9sVJgd77k+tAXQ6CRTziWSFwtvK4y3zo0c7UPKcL4xfvk
	GUIyk034z++L4bDAPTBIjp3p5uFQdFA=
Date: Wed, 1 Jul 2026 09:47:06 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 15/16] mm: replace __GFP_NO_CODETAG with
 ALLOC_NO_CODETAG
To: Brendan Jackman <brendan.jackman@linux.dev>,
 Brendan Jackman <jackmanb@google.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-15-57bef0eadbc2@google.com>
 <b4916118-3537-4e19-8bc8-1d103dd0d225@linux.dev>
 <DJMAWIOIOII3.24TMC6HTPXA7C@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <DJMAWIOIOII3.24TMC6HTPXA7C@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8065740004
X-Stat-Signature: ty1gwef5k4yom9g7s3ohzgz37b373jnd
X-HE-Tag: 1782870476-862837
X-HE-Meta: U2FsdGVkX1+aB5iRH40/bUHOnw4o49QBuZWtJBxMksP3mt9kh+lF29/qj2288D9OnleM9DHztC5JyZpzShOvBn6FjQnMLXXc2Ik19mP0CpdhatncBn7qtSNcKvB9U2o5l7InuU9SlUDD9ZZECg+7dthJ6pY3A6gyTk9R6Y4pENY052osINPRqeysAYjmEkFxQ1FMu7NpgFbyOLmcBfnEVFcKZ0AC87Ly6CAYJ+PoARUx/TFxqS7+YzXUNzXug0v9JM2YH8Rc1tReSdhaJYawvY0udlebHuxwju3IX43uhPjOfZKy2Xy8UOwmdd66lSJT+GFRyM5tPHnTQ5ZphNk7peAb6dfmUbDATyZIhDwc7YRNBOmD+aosIsGUfspwY/kJOzqgNizZMw6cilvpwQQYuMfvWzktV8ELHnTQT4PYCgPZ2FsQXRSFVStgycfwLF8VXl7etlpxYHA1NdKil++4r3BefghPzYde2+257Zd2BAQvg2tCLWT6vU4lAvI4OH7hDUDADqBcErJW1YzeADM388z3WVBWTa8KMYDq53i2UBMSuyqqhpbRFsgzksX0khRpz0YummUM+JvlmQ/vRvxk5NtKtkZQklb/Dr8afJrfjmqAYBX6/IJe+86E601oM2R/nW544QincH9ti//C99pdVHsiofqiDWyGN2r1aMW3+2X734keI8exbdYmGR7fm8ryUZNb3vH7l1Kxdhcv+f0/DH6U3Ux5CE1pISKS0mlEaf4ywJ8reGrwqnIZ8DkyOX/4zrP7CLwPd87xAGe1Yej0JkqJ7+am8t3yK1hCZnzuK2LRFrQjuBsg0e+XluPs7xKwgAMluF+rB6mpzRl7XSq5VSXeNrb061boZHgryvzTsxudPtwzVBinv6YEWNPicfKv4Pis+1uwRcyX3jt8lUx5dPt5wOk3Ft2ZrU0mKQcr3m4hvQWJ6a3W/WGKBABedNGFtegfUMz+Ed1GO+FmFOw
 5CMxsB/j
 h1bPBq+ohlxL8Emi1MF41uovC2WHKayFgLaswF7uTAyoFrBQfIZgJspHfqnKi0OQBojTV267x4fhQXWCgph6K3iI85WJZ3b58JEIb3+/Eb6WVG3ZpEP6COJ1Sq50KUxB6xL2viKNdeKWbT3HWUxyZ7z2hOHL6FVGWTgNLle9ZDzcXQtqVyP/t7zJdgbbLPPON4btx+9kKNrlx0S3RSNYMnXAB6hzpvTwxImLeL0y/biuHU2dPHBM+GFKBbtyavSmOU+fcYlZ92rBsg8KeR5Oz5TFtbunafiYzDTcqYPuYBWz75VQw7WI1rEcatZpKNb9lqoiEQC0vak8PzwsUdfxfdFRulaW94mkzw2A+CeCSzCla57GqPHru79W2X5Eo7TsaTCtLP5g4/9oFfPGxYGbkW0KReQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Brendan


On 2026/6/30 18:10, Brendan Jackman wrote:
> On Tue Jun 30, 2026 at 1:55 AM UTC, Hao Ge wrote:
>> Hi Brendan
>>
>>
>> On 2026/6/29 21:12, Brendan Jackman wrote:
>>> Now that alloc_pages has an entrypoint that allows passing alloc_flags,
>>> we can take advantage of this to start removing GFP flags that are only
>>> used for mm-internal stuff.
>>>
>>> This requires also plumbing the alloc_flags into some more of the
>>> allocator code, in particular __alloc_pages[_noprof]() gets an
>>> alloc_flags arg to go along with its callees, and we now need to pass
>>> those flags deeper into the allocator so they can reach the alloc_tag
>>> code.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>>> ---
>>>    mm/alloc_tag.c       | 22 ++++++----------------
>>>    mm/compaction.c      |  4 ++--
>>>    mm/internal.h        |  1 -
>>>    mm/page_alloc.c      | 42 ++++++++++++++++++++++++------------------
>>>    mm/page_alloc.h      | 17 +++++++++++++++--
>>>    mm/page_frag_cache.c |  4 ++--
>>>    6 files changed, 49 insertions(+), 41 deletions(-)
>>>
>>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>>> index d9be1cf5187d9..a32a94e759b94 100644
>>> --- a/mm/alloc_tag.c
>>> +++ b/mm/alloc_tag.c
>>> @@ -15,6 +15,8 @@
>>>    #include <linux/vmalloc.h>
>>>    #include <linux/kmemleak.h>
>>>    
>>> +#include "internal.h"
>>
>> Should we include page_alloc.h here, as we call __alloc_pages later in
>> this file?
> Yeah, there are a few build failures due to me not doing a broad enough
> build. From now on I will just wait for allmodconfig instead of trying
> to be clever with my build tests, sorry about this.


No worries at all. For the alloc_tag build error, it depends on whether

CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled.


> Also, this suggests that I have not actually re-tested the alloc_tag
> code since v3 so I must repeat the test described in my cover letter (I
> just manually enable the feature and check the kernel boots) for v4.
>

Thanks a lot for your work. I merged your patch locally via my 
automation bot,

and verified the basic functionality of alloc_tag.

The alloc_tag feature works well so far.


By the way, you may need to rebase your patchset on top of mm-new.

This patch has been merged into mm-new and will cause a minor conflict,

assuming the mm-new tree has not made further modifications to this patch:

https://lore.kernel.org/all/20260629-free-pfn-on-alloc-contig-range-error-path-v1-1-496ff9ca22db@nvidia.com/


Thanks

Best Regards

Hao


>>> +
>>>    #define ALLOCINFO_FILE_NAME		"allocinfo"
>>>    #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
>>>    #define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX NAME)
>>> @@ -783,19 +785,6 @@ struct pfn_pool {
>>>    
>>>    #define PFN_POOL_SIZE			((PAGE_SIZE - offsetof(struct pfn_pool, pfns)) / \
>>>    					 sizeof(unsigned long))
>>> -
>>> -/*
>>> - * Skip early PFN recording for a page allocation.  Reuses the
>>> - * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoid
>>> - * recursion when allocating pages for the early PFN tracking list
>>> - * itself.
>>> - *
>>> - * Codetags of the pages allocated with __GFP_NO_CODETAG should be
>>> - * cleared (via clear_page_tag_ref()) before freeing the pages to prevent
>>> - * alloc_tag_sub_check() from triggering a warning.
>>> - */
>>> -#define __GFP_NO_CODETAG		__GFP_NO_OBJ_EXT
>>> -
>>>    static struct pfn_pool *current_pfn_pool __initdata;
>>>    
>>>    static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
>>> @@ -806,7 +795,8 @@ static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
>>>    	do {
>>>    		pool = READ_ONCE(current_pfn_pool);
>>>    		if (!pool || atomic_read(&pool->count) >= PFN_POOL_SIZE) {
>>> -			struct page *new_page = alloc_page(__GFP_HIGH | __GFP_NO_CODETAG);
>>> +			struct page *new_page = __alloc_pages(__GFP_HIGH, 0, numa_mem_id(),
>>> +							      NULL, ALLOC_NO_CODETAG);
>>>    			struct pfn_pool *new;
>>>    
>>>    			if (!new_page) {
>>> @@ -837,7 +827,7 @@ typedef void alloc_tag_add_func(unsigned long pfn);
>>>    static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
>>>    	RCU_INITIALIZER(__alloc_tag_add_early_pfn);
>>>    
>>> -void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
>>> +void alloc_tag_add_early_pfn(unsigned long pfn, unsigned int alloc_flags)
>>
>> alloc_tag_add_early_pfn() has three occurrences across the codebase:
>>
>> 1. Definition in mm/alloc_tag.c:830:
>>
>> void alloc_tag_add_early_pfn(unsigned long pfn, unsigned int alloc_flags)
>>
>> 2. Declaration in include/linux/alloc_tag.h:166:
>>
>> void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
>>
>> 3. Static inline stub in include/linux/alloc_tag.h:170:
>>
>> static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t
>> gfp_flags) {}
>>
>> This patch updates the definition in alloc_tag.c to take unsigned int
>> alloc_flags,
>>
>> but the two declarations in alloc_tag.h are left with the old gfp_t
>> gfp_flags signature
>>
>> These should be updated to match.
> Yeah ditto, sorry about this and thanks for the review.

