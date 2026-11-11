Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E30F0606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PsB3Awzt
Received: by kanga.kvack.org (Postfix)
	id 13C716B00EF; Wed, 11 Nov 2026 04:19:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113D36B05B6; Wed, 11 Nov 2026 04:19:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 031F36B00EF; Wed, 11 Nov 2026 04:19:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0B2C6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:19:45 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B911140236
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:19:44 +0000 (UTC)
X-FDA: 85422290688.27.2742954
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A8FAD20009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:19:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PsB3Awzt;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794388782;
	b=nbN1ov7QicqCXindQ47p38zc1LJBSHSJLCXVc9b/w/kCwqqA4mVXDBWVn3ee1l4km6o+RD
	jbtZX6YkCp1HHY0mlrfo/o/gr/MkkWf/bo+9wNL2vru3yellU6a+JUU2TaTCx83RwO0cny
	/SPLcuQcL9OjUgz52AaDI1h5fLDRrpI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PsB3Awzt;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794388782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ifuEriw8WcC3rzQiq9PJJHtE9VRbVuBPyCsDSpTXl5k=;
	b=haLc4UjJ4cyYDq+MM/Z+04tx30IdisTIt4oVZoRePx1jhIcVt786M7kz992txOvjJcsHtM
	kOmye5O0wN87LahvYtp2DkDZVr80Fna+CKz17vdTzlocVeDSqZ/CaLpK9T1EEO4B9fUxmk
	ImsPAfNv9h6AnMeooWxJW10B5uYOF10=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 952CF4171D;
	Wed, 11 Nov 2026 09:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E561F00A05;
	Wed, 11 Nov 2026 09:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794388781;
	bh=ifuEriw8WcC3rzQiq9PJJHtE9VRbVuBPyCsDSpTXl5k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PsB3AwztcP3VgumQNohb4pgYlAaEvVCN2BjqH7/MXYu8/PP+ddhhYSkmEZhIjeCyp
	 BXetWxvHYfh7F9g9NtIKM3x169O6ZiUKpbt3su6PrUTFs4qdQKEKhyGnJLO5oJeuVu
	 c3T6hCmARrFWQosK3w5Vet7O8II94DsQMy5NMy4svGE6hfAJmsRliqycRrH0kQx4Gy
	 CHu9ziS4tg84ny6mmB5bYHNd2Oct1Sy3CAxxIx2ctWmNQAwYVR/Dyis81HiPR0aGZ/
	 F21kaUAM+QTc0wXLAptx8mdyN/5hLw5tNEE0fmij+h9Xj7R8rNFsIokDj+O2GYWqxg
	 efDwn2Xci+aAg==
Message-ID: <995164cd-34a6-4190-898a-79d25248b6f3@kernel.org>
Date: Wed, 11 Nov 2026 10:19:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/huge_memory: prevent losing PG_waiters in
 __split_folio_to_order()
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Brendan Jackman
 <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Ye Liu <ye.liu@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261109-fix-split_folio_to_order-race-v3-1-1cdc509e34be@nvidia.com>
 <5a7bb477-5392-404c-a748-4748cec2c84f@kernel.org>
 <940CBBBB-D564-4D4F-9C8A-A9A272F08064@nvidia.com>
 <a3557629-d86d-42f6-b181-bf8540dc1982@kernel.org>
 <1B3B1BC7-7623-4070-ABD7-13A5EE559297@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <1B3B1BC7-7623-4070-ABD7-13A5EE559297@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g18wgxmmhbjfjqsbrfhi6sf416e4176z
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A8FAD20009
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794388782-568583
X-HE-Meta: U2FsdGVkX1+Fnrqrnp6/ta644aA6/NfVR4qRh7STjCQhk/CtV98R0cjUfdV+TfPxJ17NLFRjYpQ9Kv1WTL6By9YnLgBQof8qlRFCH/Th30yG6LxWdIgsud2+MCyDmYF9RDVwmW3qsRTP+0dD/Gu/IjSv4FPiwAVFwfR1WG8qnHqKDhmWQcn5NpRwOZoA+HogAa6k+SOG0HdMMvnRZYDGJMy8tnrOO2ZPYysKlqFCTzIsvf7aVlgXzLPBiOedk1xInfmsNRAvo0jvDO5VSiUZMyPYt2o6x4hsSO9HzxAblpoE+0M5iF+fD31QACnhjFlYshoFfXVdLq64DlYrI1MNkE0jKmSxZuzn+7ToP8siv6/dlUqoLrCzk82cxbdonN1DY9Alf4RXOzqf30hnJtzyrCvPPrUF77f4+G85Agnm7LMqa8Y5TaK+7eCnhnS6q37rujjyEdESSMDTFyZgTJT7s17dHmCINbczC/oMxqTOEzQEVU9zoMDAE2v6V0j+PjPUGBUvtVAUxVat354EN+dEsvdUKX/ZXRgTIdKf8AavqonRnoMJ3SzYF71AVAgDzM1Ckxj8GPlhltQajGCtRsxzrChy1SG3ET4+9w8zGPKSWRCZAUkx4N1IoiyfMRRrOqGfcgxE2Wgd1f4BEgNvHBP1yr1NR4yR1FcOe4CjsUPvU84HYZZyldfKUsKYtRmVbwDxWK/DcvGfd8Zv5TtSLTCrApwb+Uqf5AHgJJdMN6uN4fT4QvqPsVttXXDeKhmbTuqCR4Z/0G+Y6uBUd4lqU64fNUemdW+ElCT2qxgzfb+qj2H4kKgDzFMu7iISB0s9EttYHo4E/wJzPer3mFvbRg2y/1ruqjF8eGWhN1zxSJEH8E8tpkNKSxv9sZ+ZWqWq/yNoU7NB0VvunxI2MvJCi8YiH4NOid5HCW0NnsG6SRNB238NbvaPVp79+KquBM6bZxSz+IV+9PCFWJin2xtsfWx
 WeRlMs/Z
 beYcsy85AmNAJHP1T98B5JojXM07J2x3Blxyherg2aoNDakoJutNLphLkA/a5fmxAX0qXM7Guf7UCjw2NmGzY52Wo93gon91bl0OcaUF0Xmb6yS+Slk3AFT+k6xeFkKFOPy2yygV+SVE2xFRyDQ5ZtlNQNmzsphrEDtD5jlYc2hrU0Yh8ZW2F5VCm9q1x1c9f67sa9DEyoYTneXa3zvxtdueJhGOkbIo0azNs5uIQSwogQJFB1e7PgKeXiSQ4s8kWh9JkPyQnApLbBO3hCp4rie6pI5ThWFsfWQ1XsECHvxx0W9c2uBhbjOZPoDyRVYYmOJ8KeT5b9SbRM5cPU3i94urQ92cbou7GBaFdFPOTU+qbsGl+rmpO5L9nK/pWqH54QnpWR3KFbhGUR4WuIwIZHqRuskwPxlvvNUGydN/QOXgAh6AX8sYTfQIZlDvCxNpIGNoQokg8M2zXD/L32mH4GXMGNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 18:03, Zi Yan wrote:
> On 10 Nov 2026, at 6:31, David Hildenbrand (Arm) wrote:
> 
>> On 11/9/26 22:05, Zi Yan wrote:
>>> On 9 Nov 2026, at 15:21, David Hildenbrand (Arm) wrote:
>>>
>>>> On 11/9/26 20:32, Zi Yan wrote:
>>>>> __split_folio_to_order() calls prep_compound_page() on each new head page
>>>>> to create a compound page after clear_compound_head(). prep_compound_page()
>>>>> uses non atomic __SetPageHead(). It is mostly OK, since the folio is locked
>>>>> and frozen and no one else is supposed to modify the folio's flags.
>>>>>
>>>>> However, code calling migration_entry_wait() can reach the folio by PFN,
>>>>> then access its flags. It is because softleaf_entry_wait_on_locked() used
>>>>> by migration_entry_wait() sets PG_waiters concurrently without taking a
>>>>> reference and the frozen refcount during split cannot block it. Meanwhile,
>>>>> __SetPageHead() does a plain read and write, so PG_waiters atomically set
>>>>> by softleaf_entry_wait_on_locked() will be lost if the set happens after
>>>>> __SetPageHead()'s read and before its write.
>>>>>
>>>>> One example code interleaving:
>>>>>
>>>>> CPU0: __split_folio_to_order(new_order>0)  CPU1: do_swap_page()
>>>>>
>>>>> 1. clear_compound_head(new_head)
>>>>>    new_head->compound_info = 0
>>>>>    (page_folio(new_head) == new_head now)
>>>>>
>>>>>                                            2. migration_entry_wait()
>>>>>                                              softleaf_to_folio(entry)
>>>>>                                              page_folio() -> new_head
>>>>>                                              (not the old head any more)
>>>>>
>>>>> 3. prep_compound_page(new_head, new_order)
>>>>>      __SetPageHead(new_head)
>>>>>        tmp = new_head->flags.f  <-- load; PG_waiters == 0 in tmp
>>>>>
>>>>>                                            4. folio_set_waiters(new_head)
>>>>>                                              set_bit(PG_waiters, &flags.f)
>>>>>                                              enqueue on waitqueue, sleep
>>>>>
>>>>> 5.     new_head->flags.f = tmp | (1UL << PG_head)
>>>>>        <-- store; overwrites step 4, PG_waiters == 0 again
>>>>>
>>>>> Later, folio_unlock(new_folio) sees no PG_waiters, skips folio_wake_bit(),
>>>>> and CPU1 can remain blocked indefinitely.
>>>>>
>>>>> Fix it by setting PG_head along with other flags in new_folio->flags before
>>>>> smp_wmb() and clear_compound_head(). The remaining compound page metadata
>>>>> is set after clear_compound_head(). In that way, after
>>>>> clear_compound_head() makes new_folio visible, nothing overwrites the
>>>>> PG_waiters from softleaf_entry_wait_on_locked() by modifying
>>>>> new_folio->flags non-atomically.
>>>>>
>>>>> While at it, use data_race() to suppress the KCSAN issue reported by Ye
>>>>> Liu's patch (the second Closes) on reading ->flags during a folio split.
>>>>>
>>>>> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
>>>>> Reported-by: David Hildenbrand <david@kernel.org>
>>>>> Closes: https://lore.kernel.org/all/DMHE8BEEER1H.2BIY52NXATPIA@nvidia.com/
>>>>> Reported-by: Ye Liu <ye.liu@linux.dev>
>>>>> Closes: https://lore.kernel.org/all/20261029-data_race_huge_mem-v1-1-112e331291c1@linux.dev/
>>>>> Fixes: c010d47f107f6 ("mm: thp: split huge page to any lower order pages")
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>>> ---
>>>>> The issue was raised by David when reviewing Ye Liu's "mm/huge_memory: use
>>>>> READ_ONCE() when cloning folio flags during split" [1]. This patch also
>>>>> supersedes Ye Liu's patch.
>>>>>
>>>>> [1] https://lore.kernel.org/all/20261029-data_race_huge_mem-v1-1-112e331291c1@linux.dev/
>>>>> ---
>>>>> Changes in v3:
>>>>> - set PG_head before smp_wmb() like Kiryl suggested instead of
>>>>>   prep_compound_page_atomic().
>>>>> - used data_race() to suppress KCSAN reports while at it.
>>>>> - dropped Lorenzo's ack, since the patch is changed.
>>>>> - Link to v2: https://patch.msgid.link/20261106-fix-split_folio_to_order-race-v2-1-1b59c67b8af3@nvidia.com
>>>>>
>>>>> Changes in v2:
>>>>> - renamed __prep_compound_head_and_tail() to __prep_compound_page().
>>>>> - added comments to prep_compound_page() and __prep_compound_page().
>>>>> - Link to v1: https://patch.msgid.link/20261029-fix-split_folio_to_order-race-v1-1-a483c7451b0d@nvidia.com
>>>>> ---
>>>>>  mm/huge_memory.c | 32 ++++++++++++++++++++++++++++----
>>>>>  mm/internal.h    |  2 ++
>>>>>  mm/page_alloc.c  | 17 +++++++++++++++--
>>>>>  3 files changed, 45 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>> index bd44d58e86845..99b48d7c988db 100644
>>>>> --- a/mm/huge_memory.c
>>>>> +++ b/mm/huge_memory.c
>>>>> @@ -3714,6 +3714,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>>>>  		 * Don't pass it around before clear_compound_head().
>>>>>  		 */
>>>>>  		struct folio *new_folio = (struct folio *)new_head;
>>>>> +		memdesc_flags_t new_flags;
>>>>>
>>>>>  		VM_BUG_ON_PAGE(atomic_read(&new_folio->_mapcount) != -1, new_head);
>>>>>
>>>>> @@ -3730,8 +3731,16 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>>>>  		 * unreferenced sub-pages of an anonymous THP: we can simply drop
>>>>>  		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
>>>>>  		 */
>>>>> -		new_folio->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
>>>>> -		new_folio->flags.f |= (folio->flags.f &
>>>>> +		/*
>>>>> +		 * ->flags are stable since the folio is locked and frozen.
>>>>> +		 * data_race() is used because reference-less writers,
>>>>> +		 * 1. PG_waiters from softleaf_entry_wait_on_locked() and
>>>>
>>>> Hm? I thought that case would be handled by your patch? How can they still write
>>>> to the page?
>>>
>>> This is V3 of the patch. Instead of using prep_compound_page_atomic(),
>>> PG_head is written before clear_compound_page(), after which new_head
>>> is visible to the reference-less writers.
>>
>> I'm confused, how is it then valid to have PG_waiters set concurrently while we
>> read new_folio->flags.f? Because that's what your comment states.
>>
>>>
>>>>
>>>>> +		 * 2. PG_hwpoison from memory_failure(),
>>>>> +		 * can still write to it.
>>>>
>>>> We lose PG_hwpoison left and right when racing with non-atomic updates. It needs
>>>> a fundamental fix. Is this really something we should take care of in this series?
>>>
>>> IMHO, memory_failure()’s reference-less access violates the frozen
>>> page contract and should be fixed.
>>
>> Exactly.
>>
>>> But I do not think it needs to go
>>> along with this patch. We discussed HWPoison flag race with
>>> Michael S. Tsirkin and Miaohe before [1]:
>>>
>>> 1. Miaohe proposed to reset HWPoison in memory_failure() as a best effort,
>>> 2. mst used RCU for all non-atomic flag accesses,
>>> 3. you also proposed to move HWPoison out of ->flags.
>>>
>>> So memory_failure() needs a separate and proper fix series after
>>> we decide the right solution.
>>>
>>
>> Vlasta raised the idea to set hwpoison only after we actually managed to
>> isolate/grab the page. Which might be the proper fix.
> 
> I was bouncing the same idea with LLM yesterday, but it does not solve
> all cases:
> 
> 1. normal page: taking a ref just prevents it from going to be a free page,
>    but atomically set PG_hwpoison can still be lost when another one uses
>    a plain write, __folio_set/clear_*().

Hm if I pin and isolate a page, I'd expect my atomic flag updates to be
RMW-race-free. Who is doing plain writes to flags on pages they don't "own"?
I'd expect there would be more breakage than hwpoison in that case.

> 2. free page: isolating works if the free page on its free list, but it
>    could be on pcplist and we then need to drain all pcplists. That could
>    hurt performance.

Sure, but it's for an event that's already disruptive enough and should not
be happening a lot.

> 3. we cannot take a ref on slab page and other frozen pages, then we will
>    need a case by case handling for them.

It's also not possible to evacuate such pages (e.g. slab) so it's just bad
luck if those got corrupted.

> Anyway, this probably belongs a separate discussion on hwpoison.
> 
> Best Regards,
> Yan, Zi


