Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F203F606A332
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=t++7t+Nj
Received: by kanga.kvack.org (Postfix)
	id 1BDD26B05B3; Fri,  6 Nov 2026 04:15:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 146D86B05B4; Fri,  6 Nov 2026 04:15:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0251E6B05B5; Fri,  6 Nov 2026 04:15:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2CC06B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:15:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21D1440D71
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:15:22 +0000 (UTC)
X-FDA: 85404135684.17.1C8AEA4
Received: from mta0.migadu.com (out-79.mta0.migadu.com [91.218.175.79])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0DDBB16000C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:15:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t++7t+Nj;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.79 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793956520;
	b=0to2TBIdga7dr82epKbzgW4ZzoCNEV5Uo/1t56FMcZYe9BenONqTKEt5KQ/UjmJ8FXeaiR
	lx/ui4WVd1ItC6bno0pewjhpxSzXQXooA9f8G3kwN/+JVo8LkRyQiOWnnMSVBsUXj1Gv8y
	0W20xzTDUizDCWjhrVAVDXMGkfegzek=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t++7t+Nj;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.79 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793956520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ctycaF2KOXwWuXEDXSNAYypG2JZO9cxBfbE3KtRR508=;
	b=Un1Oh+GyZXKfZDzN9Mv05TCfog2mwIICCzBPs+NH7F1rnyO3IjpHMA0Vm1w1QKQoKUg7jI
	BExF+E/VEfdXbQ/dldVuc8fYMiqrBzTlnfwiQFN8paN01EN5LuP7e4Ejbf8mM6TnVspFmX
	TW+wJbNCUI4ojFAdDq0kdvLjcCqDmk4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Oe28MT9PKJAMfqKhdWMUFjyxqbMd1HIlftDdBYgWRmE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793956518; v=1; x=1794561318;
 b=t++7t+NjOpL8roCsTGtIavPsidMJcvLd4y9Lsr6MalyVXoYgggPgY7SL35WvUYAKdzgR28Pt
 gSS5YFPEivkVFhFnM7eBIUB5pU5zaCHS3k97wF6ZNOJ3n4bAEyFjI9+NflglhOcWXhsS0P5KCY+
 UDPQVgQRMMQA+Hr7l0J2lw5I=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id dcf04c63a15f31f4;
	Fri, 06 Nov 2026 09:15:16 +0000
X-Mizu-Trace-ID: dcf04c63a15f31f4
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: baolin.wang@linux.alibaba.com
Cc: baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	qi.zheng@linux.dev,
	pfalcato@suse.de,
	ayushr@modal.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio sizes
Date: Fri,  6 Nov 2026 17:15:10 +0800
Message-ID: <20261106091510.67980-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <453e2c18-4e79-4db2-b565-1af881925f08@linux.alibaba.com>
References: <453e2c18-4e79-4db2-b565-1af881925f08@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e6bp7dk4cbq6qfikrci9a1uxue1snny4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0DDBB16000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793956519-779549
X-HE-Meta: U2FsdGVkX18UrPn0jK+5BgKVlclIDN/70ahZS6W6dKgIMpeCBVjq/kP3FYGZuT5v2lfSaafrZQA5TzWXBRnF/GreBVt0A7SBjOJ9ms5a9A0h/tIfui9Q1jTNxKhjH7EScBkL92PS2EkoigdxvHrtOXGKVJCwrEDZlq/vYd3VcCMulKrfZk35XjuaVaJRobun1sI/45cbiBvsq9M4+UvHiYTUF6K7uypPo77kbajdSv2dKEt4i+o3xgej8cv+8HghFqMxJ5ljsMDWX0F7D9bR92LTySAt740TcDgZ+geTuWoc9KMQK6SJ+tYv3yvgdJb8JhFUURBp5mivw2m0zNCcA90/UoMribQ4xUKk2N/U0xp+A7u/5BLl5XI3kRCZsxY5dJWBTqxq0uzxSh1Jmfq2velGxve0YhhXdeF4Bj1Yao63pdE9SdIDthTo5JaPbCg7WLOL73+TYL7T8QqMo0j23fp+oEiOiEBK4S1BgbX05+gxxmbd775fg1BN91wPrvcJOrhKej97oSoo+lz+92GAAovNHmnAiQjUppduYfr9yeBcKmwyVk8+K/1g8qRA9i+oGZvDOZK1DrV0fSHJ/YRX22PT32xlUbv8Nv7jIELX5e5+QGwFxxW5hStrrjf9VqPhoc45QAm1FZaSKE+fOUEmb7OAVXxLBNcRxDHbNhASW8L5uo0IWXPx6Fx0ifFVpzcDKGk57ipUBIfSzFQgiMAhsYSq1uIJEG3QsOnsJgoalZOPiYGSLHovs6TUSQAI6lP1hishWHhM/tOw5tx8WZAWXUoWee2Q+Ty9JEWDgTM1JkJmxTdKIVxIZm6QZiJix/h/D7zGWm+0/Yo+0BnS7o4IoXkUDS7MMuFIABTKl9Sx8NMWnfExFn8QvwtQtVW6x/GHmTHQlFK4Fx/f7oysORn/EjeeXF2hrCcYDMlZhlwVWILOct4v3kv55p9/DxJT0ynR0zGQDzaO0LAO0a2af5U
 3wat/yIl
 P/1qlMH5ojK95rbi3NhXAD/E5bs5UqHEX5o2rCWkSX0vvcdIdVngiif8D4YzC5JEosQ747QZsuzyZfec4IHdSFinUo3lyPXUbfPvTJmNlXISNF6O0zy4ugSLg2VOrNTsFj1mWNwbPHgddlWPvw7t5zEXo4PzJKJDD5iA76ceJ96ok1NBu4YYe6KFh5raucw4mFGkyliCuT9fPUl7uAWLTxvA/Odao8hZ6oK7tcHsQrYE0lAL1WNhD0DLWg1PAJZvO+Tw05jCRnTJx/3MqgssXa0yite7UvrEPzqasLBYwx5cKFB8e5WEUasGnkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Fri, Nov 06, 2026 at 04:54:44PM +0800, Baolin Wang wrote:
>
>
>On 11/6/26 2:24 PM, Barry Song wrote:
>> On Thu, Nov 5, 2026 at 5:00 PM Baolin Wang
>> <baolin.wang@linux.alibaba.com> wrote:
>>>
>>> CC Barry, who added the TTU_SYNC in shrink_folio_list().
>>>
>>> On 11/5/26 1:48 PM, Lance Yang wrote:
>>>>
>>>>
>>>> On 2026/11/5 12:54, Lance Yang wrote:
>>>>>
>>>>> On Thu, Nov 05, 2026 at 10:56:28AM +0800, Baolin Wang wrote:
>>>>>> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing
>>>>>> mapped
>>>>>> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can
>>>>>> also race
>>>>>> with concurrent page table reclamation via zap_empty_pte_table().
>>>>>
>>>>> Good catch!
>>>>>
>>>>>> page_vma_mapped_walk() is used by many functions including
>>>>>> try_to_unmap(),
>>>>>> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(),
>>>>>> remove_migration_ptes(),
>>>>>> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for
>>>>>> try_to_unmap()
>>>>>> and try_to_migrate(), the other callers do not perform post-walk
>>>>>> accounting
>>>>>> checks, so the race has no observable impact on them.
>>>>>>
>>>>>> For migration, the race can cause unnecessary retries. For reclaim via
>>>>>> try_to_unmap(), the race can cause failure to reclaim a folio that is in
>>>>>> fact already unmapped (as shown below), which may lead to unexpected OOM
>>>>>> or increased refaults.
>>>>>>
>>>>>> CPU 0 (reclaim)                      CPU 1 (MADV_DONTNEED)
>>>>>> --------------------------------    --------------------------------
>>>>>> folio_lock(F)
>>>>>> try_to_unmap(F, TTU_SYNC)
>>>>>>                                      zap_pte_range(full PMD range)
>>>>>>                                        spin_lock(ptl)
>>>>>>                                        clear PTEs
>>>>>>                                        zap_empty_pte_table()
>>>>>>                                          spin_trylock(pml)
>>>>>>                                          pmd_clear()
>>>>>>                                          spin_unlock(pml)
>>>>>>
>>>>>>    page_vma_mapped_walk()
>>>>>>      observe !pmd_present(pmde)
>>>>>>      nr_pages < HPAGE_PMD_NR
>>>>>>      skip synchronization
>>>>>>      return false
>>>>>>
>>>>>> try_to_unmap() returns
>>>>>> folio_mapped(F) == true
>>>>>> nr_unmap_fail += folio_nr_pages(F)
>>>>>>                                      tlb_flush_mmu_tlbonly()
>>>>>>                                      tlb_flush_rmaps()
>>>>>>                                        remove F's rmaps
>>>>>>                                      spin_unlock(ptl)
>>>>>>
>>>>>> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
>>>>>> folios")
>>>>>> has already moved the PMD clear operation (via zap_empty_pte_table()) to
>>>>>> after tlb_flush_rmaps(). Similarly, page_vma_mapped_walk() also needs to
>>>>>> use sync_with_folio_pmd_zap() to synchronize and avoid memory ordering
>>>>>> issues on weakly ordered CPUs.
>>>>>>
>>>>>> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in
>>>>>> madvise(MADV_DONTNEED)")
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>> ---
>>>>>> mm/page_vma_mapped.c | 5 +----
>>>>>> 1 file changed, 1 insertion(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>>> index e6b6170c2f4f..8797467b6f0c 100644
>>>>>> --- a/mm/page_vma_mapped.c
>>>>>> +++ b/mm/page_vma_mapped.c
>>>>>> @@ -293,10 +293,7 @@ bool page_vma_mapped_walk(struct
>>>>>> page_vma_mapped_walk *pvmw)
>>>>>>              spin_unlock(pvmw->ptl);
>>>>>>              pvmw->ptl = NULL;
>>>>>>          } else if (!pmd_present(pmde)) {
>>>>>> -            if ((pvmw->flags & PVMW_SYNC) &&
>>>>>> -                thp_vma_suitable_order(vma, pvmw->address,
>>>>>> -                           PMD_ORDER) &&
>>>>>> -                (pvmw->nr_pages >= HPAGE_PMD_NR))
>>>>>> +            if (pvmw->flags & PVMW_SYNC)
>>>>>
>>>>> Right. Whether the folio can be PMD-mapped doesn't tell us whether its
>>>>> PTE table can be reclaimed, so those extra checks can skip
>>>>> synchronization
>>>>> that the caller explicitly asked for ;)
>>>>
>>>> Ouch ... one thing I missed ... what about order-0 reclaim?
>>>>
>>>> shrink_folio_list() only sets TTU_SYNC for large folio, so can't we still
>>>> hit the same race there?
>>>
>>> Thanks Lance. But this matches the purpose of the TTU_SYNC flag, which
>>> is used to avoid racy checks with PVMW_SYNC. If no TTU_SYNC flag is set,
>>> it means the caller can tolerate some racy checks.
>>>
>>> For this case, I think we should set TTU_SYNC unconditionally in
>>> shrink_folio_list(). Barry, what do you think?
>> 
>> Baolin, thanks for reaching out to me. I added that flag
>> mainly for large folios.
>> 
>> I observed cases where PTEs for large folios are partially
>> cleared during certain transition states, for example, when
>> PTEs are cleared before being modified:
>> 
>> pte = ptep_get_and_clear();
>> pte modification;
>> set_pte_at();
>> 
>> In such cases, page_vma_mapped_walk() skips the empty
>> entries and starts from the next valid one.
>> 
>> This may result in partially unmapping PTEs for large folios
>> and trigger unexpected folio splits. At the time, I was
>> particularly concerned about unnecessary folio splitting,
>> so my focus was mainly on large folios.
>
>Thanks for the information.
>
>> However, I also noticed that a similar race can occur with
>> small folios. In that case, the folio may simply remain
>> unreclaimed by the reclamation path.
>> 
>> However, my main concern at the time was avoiding
>> unnecessary folio splits.
>> 
>> Your new race also seems to amplify the same situation.
>> However, I don't think this problem necessarily depends on
>> the commit you mentioned. It has been around for a long time.
>
>Agree.
>
>> If the concern is reclaim failure, I agree that there is no
>> fundamental difference between large folios and small folios.
>
>OK. And I did a quick measurement to reclaim anon and file folios via 
>the memory.reclaim interface.
>
> From test results, reclaiming 1G small anonymous folios (using zram as 
>swap) shows no significant performance change. However, reclaiming 1G 
>mapped clean small file folios does show an observable regression if the 
>TTU_SYNC flag is set.
>
>Without TTU_SYNC for small folios:
>time echo 1G > /sys/fs/cgroup/test/memory.reclaim
>real	0m0.178s
>user	0m0.000s
>sys	0m0.178s
>
>With TTU_SYNC for small folios:
>real	0m0.315s
>user	0m0.000s
>sys	0m0.314s

Nice numbers, cool!

>So for the current patch, I'd prefer to keep things as is: only sync 
>when TTU_SYNC is set. Without setting the TTU_SYNC flag, keep the 
>original logic, meaning the caller can tolerate some racy checks.
>
>Any other thoughts?

One thing I want to pin down first, for the order-0 folios, was that run
with TTU_SYNC going through the pmd lock, or did it already go the
smp_rmb() way?

My guess is the first one, right?

If so, please keep the fix as is and only sync when the caller asks for
it (at least, order-0 folios should not go the pmd lock way) :D

Cheers, Lance

