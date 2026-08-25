Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0315BC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187346B0092; Mon, 24 Aug 2026 22:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA2F6B0096; Mon, 24 Aug 2026 22:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1B5F6B009B; Mon, 24 Aug 2026 22:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEE4D6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:44:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57478160300
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:44:47 +0000 (UTC)
X-FDA: 85138249014.25.0FA70B9
Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1DBFF1C0002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:44:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LJFOfwau;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787625885;
	b=B+SUv4TcK683X6kx0Yn17gqFTUZR0C4Pdmr9bskBia1/zS6MLdUG6cevrg8MnMSI4J8SSP
	cAEA/LkAw+uHMUlPJBB5b/7VkHVf7cb3oABgr6Nm+Vi5jnwVPARLn2R9/xD0E9XVeDZSHv
	yHkbh+KDduFp0vB71ur8KJ+tdiJcMbk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LJFOfwau;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787625885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrqHgFPHcX5EnySKHobDXnVgfrh+qqroggg87dHJc5o=;
	b=QUczvn7H6gGb9MQkZNDifyMBg1kaAn/62t91B07AmtQNWc4XAusaOcJ1bvUmwueFaEkM+h
	qowT1+0JubfZQFTpOPBMo0w4/Flcmf0rlB1PRRvq+hbd7Oc+MWKMLnMrEyNrA+O5u9PWXP
	IzUBtKwLJ0OVpEpGQzV14lS9DrKfB+g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QGaCBBZqoDLwrT1fV2aQjhVthAgbGXSKI1ufVgpgOao=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787625883; v=1; x=1788230683;
 b=LJFOfwau3//i2kp3whENs9ZtI0YKJrTfDxuNh0uIF3xHks1G0RF7IvjeBmck5DlQNCoIQ0Hy
 uTr0IvOkXrIOQyLu3+t0QAlnjFtToQlRI/a7u4wH/eL99Kvw1EZelaxlJjKvz+76l9Q2HyvEuyh
 Cj34eFN4LHNe56MCyvquMs0Y=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 72a80e7a41d0f84b;
	Tue, 25 Aug 2026 02:44:43 +0000
X-Mizu-Trace-ID: 72a80e7a41d0f84b
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: usama.arif@linux.dev,
	hannes@cmpxchg.org,
	kirill@shutemov.name
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [RFC PATCH 16/57] mm/collapse: freeze the sources behind migration entries
Date: Tue, 25 Aug 2026 10:44:34 +0800
Message-Id: <20260825024434.39662-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <f81160ac-0c7c-43f2-985f-43ab54a52358@linux.dev>
References: <f81160ac-0c7c-43f2-985f-43ab54a52358@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1DBFF1C0002
X-Stat-Signature: scpjd9bxffqggiehdbzcyqfa5yhez9sk
X-HE-Tag: 1787625884-320762
X-HE-Meta: U2FsdGVkX18AagBgeLPOoV2LWm7l47Y+4W3WCzL2e8je/qXaEm/ibe6qGbZeNC9B0DLWLpN1PN1HwR5TKNwhcksWbXcii0fSJdCVfJUKM4emLjkmLucL6YTJCxdZ5bkh2+TzqFUkPQ23zSLV3hWeiUbXJOl4etDuYcuHo3vn12/VtRztJEU6rSISdXsZVTJuSb/emxSpexygeRTNtuoKHZhZaGtTUwGtRXUIYHrsMMkjf5osf1rZ99l1yaPJAzYrxTFa8JqctexvkuYO9Z2zOjMeX6GWsb9J0VwQP0irbADj2qykBjjbF32NQFftNL571Y1YEiEeot5e47pBdj16f/uPVh0i3Eq4jPSiTAGDO4yeWedviw17m97fHPnrxNhlMJnfkc8BL1xNqyVgvFz83Q8eqekeoIlFGoKAn7UuyzWWxVS9ODwLFZMqmhtuFURExQ6+6/qKXh0ORu1q0g9SoRb5OhBMQGoC3C6Qg2Gc8gy4JAJYPj9aTzHM9INH584SxdJewba7bsrwzgA6deZAGKHt/R9x/xIrgOxgICrkKc0SIIcRn4GsLGxxfKyADH6enIWG2MbNPTshLqXUVZGhVZJ50JFqU6VB80VmnDL0XTR9v2u16qUMzcsl0V3nSyAoX0PR1BACti6WDr4FG6zNf1+0TRq7MjgKhwda7BG0GmOP8OipNZwNMNjTooRFwJJFLmXyyqrXBgWHX8a66rzsaE8ddtN0FCSOi8vydkOcFpbWOh/9vhK+Y4ILY6R26ANEp87/abnmOBHELpefNvinvvHAegPy7lFnKMdL5YXTTBEToY7Fls1FjIpnA3/tWwT2cL4VdIjCr6ohrplazXF5G59Zad6J1EBWEelc7hohEhHWW3fLhSue+TPulCQOPCCUs98qyDLtxqYbzMhM4wJD14TqgQUJv7Cd/chemanlqbgLpQbdQ4ZnhkfzYoHK9gpPXBAPvOEuawUPkPJCPmB
 iWpCz7xN
 X+ahqZFCWIxGSZhYOy6OwVBncNYzJhnuUFigzfLFFi2Au8t8bdV6LCEFS6je23eTLLgeRzkm/ikr/ibW08i5hCkcRVLCBIRbhQlStX+CKLntme2HtRWWsJeVZxhl+4HYqqvkYyLwyyADm+RxnnHKIzxfd/+HYMPt57Wn74jPElC2nWD6RO1456hitpCoIkbd+TJV3cYzR35Q6yf7n2cZDDbvA1N5HUUGQt7rc71yUQ3bAlr3gktZ/O6UJPjuvLIBzd8lAgkjXophY3TTfmy8kEoyVfMl2etEYsLKs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Aug 24, 2026 at 05:13:52PM +0100, Usama Arif wrote:
>
>
>On 24/08/2026 16:49, Johannes Weiner wrote:
>> On Mon, Aug 24, 2026 at 03:13:10PM +0100, Kiryl Shutsemau wrote:
>>> On Mon, Aug 24, 2026 at 09:12:24PM +0800, Lance Yang wrote:
>>>>
>>>> On Sun, Aug 16, 2026 at 11:45:28PM +0100, Kiryl Shutsemau wrote:
>>>>> +		if (!folio_ref_freeze(folio,
>>>>> +				      folio_expected_ref_count(folio) + 1)) {
>>>>> +			result = SCAN_PAGE_COUNT;
>>>>> +			goto unfreeze;
>>>>> +		}
>>>>> +		nr_frozen = nr_saved;
>>>>
>>>> Just one thing I was wondering about ... can deferred_split_isolate()
>>>> remove a source folio from deferred_split_lru while its refcount is
>>>> frozen by collapse_freeze_candidate()?
>>>>
>>>> Assume an earlier span belongs to an anonymous large folio on the
>>>> deferred split queue, then a later span fails folio_trylock().
>>>> collapse_freeze_candidate() continues after freezing each source folio
>>>> and calls collapse_unfreeze_candidate() on a later failure:
>>>>
>>>> static noinline enum scan_result collapse_freeze_candidate(struct mm_struct *mm,
>>>> 		struct collapse_candidate *cand, pte_t *pte)
>>>> {
>>>> ...
>>>> 	for (i = 0, addr = cand->addr; i < nr_pages;) {
>>>> ...
>>>> 		if (!folio_trylock(folio)) {
>>>> 			folio_put(folio);
>>>> 			result = SCAN_PAGE_LOCK;
>>>> 			goto unfreeze;
>>>> 		}
>>>> ...
>>>> 		nr_saved = i + nr;
>>>>
>>>> 		if (!folio_ref_freeze(folio,
>>>> 				      folio_expected_ref_count(folio) + 1)) {
>>>> 			result = SCAN_PAGE_COUNT;
>>>> 			goto unfreeze;
>>>> 		}
>>>> 		nr_frozen = nr_saved;
>>>>
>>>> 		i += nr;
>>>> 		addr += nr * PAGE_SIZE;
>>>> 	}
>>>>
>>>> ...
>>>> unfreeze:
>>>> 	collapse_unfreeze_candidate(mm, cand, pte, nr_saved, nr_frozen);
>>>> 	return result;
>>>> }
>>>>
>>>> folio_ref_freeze() takes the source folio's refcount to zero:
>>>>
>>>> static inline int folio_ref_freeze(struct folio *folio, int count)
>>>> {
>>>> 	return page_ref_freeze(&folio->page, count);
>>>> }
>>>>
>>>> static inline int page_ref_freeze(struct page *page, int count)
>>>> {
>>>> 	int ret = likely(atomic_cmpxchg(&page->_refcount, count, 0) == count);
>>>>
>>>> ...
>>>> 	return ret;
>>>> }
>>>>
>>>> While collapse_freeze_candidate() still holds the source folio lock,
>>>> deferred_split_scan() can call deferred_split_isolate():
>>>>
>>>> static unsigned long deferred_split_scan(struct shrinker *shrink,
>>>> 		struct shrink_control *sc)
>>>> {
>>>> 	LIST_HEAD(dispose);
>>>> 	struct folio *folio, *next;
>>>> 	int split = 0;
>>>> 	unsigned long isolated;
>>>>
>>>> 	isolated = list_lru_shrink_walk_irq(&deferred_split_lru, sc,
>>>> 					    deferred_split_isolate, &dispose);
>>>> }
>>>>
>>>> static enum lru_status deferred_split_isolate(struct list_head *item,
>>>> 					      struct list_lru_one *lru,
>>>> 					      void *cb_arg)
>>>> {
>>>> 	struct folio *folio = container_of(item, struct folio, _deferred_list);
>>>> 	struct list_head *freeable = cb_arg;
>>>>
>>>> 	if (folio_try_get(folio)) {
>>>> 		list_lru_isolate_move(lru, item, freeable);
>>>> 		return LRU_REMOVED;
>>>> 	}
>>>>
>>>> 	/*
>>>> 	 * We lost race with folio_put(). Read folio state before the
>>>> 	 * isolate: folio_unqueue_deferred_split() checks list_empty()
>>>> 	 * locklessly, so once removed the folio can be freed any time.
>>>> 	 */
>>>> 	if (folio_test_partially_mapped(folio)) {
>>>> 		folio_clear_partially_mapped(folio);
>>>> 		mod_mthp_stat(folio_order(folio),
>>>> 			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>>>> 	}
>>>> 	list_lru_isolate(lru, item);
>>>> 	return LRU_REMOVED;
>>>> }
>>>>
>>>> And folio_try_get() fails because the source folio has a frozen refcount.
>>>> deferred_split_isolate() treats the failure as a race with folio_put(),
>>>> clears PG_partially_mapped and its MTHP_STAT_NR_ANON_PARTIALLY_MAPPED
>>>> accounting when set, then removes the folio from deferred_split_lru ...
>>>
>>> Hm. So, the premise in deferred_split_isolate() is false:
>>> !folio_try_get() doesn't mean lost race with folio_put().
>> 
>> I suppose you mean, not exclusively. But it can also mean that. And
>> then the question is, who cleans up the partially_mapped state.
>> 
>>> I think deferred_split_isolate() should do something like:
>>>
>>>       if (!folio_try_get(folio))
>>>               return LRU_SKIP;
>>>
>>>       list_lru_isolate_move(lru, item, freeable);
>>>       return LRU_REMOVED;
>>>
>>> Johannes, do I miss something?
>> 
>> Ah. The idea being: leave the item on the LRU when there is a race
>> with the refcount going zero; and then it's up to that other side to
>> deal with/clean up the partially_mapped state as appropriate. Thus:
>> 
>> folio_put()
>>   __folio_put()
>>     folio_unqueue_deferred_split()
>>       if __list_lru_del():
>>         // clear partially_mapped state & stats
>> 
>> will always succeed, even if it races with the shrinker. And you are
>> also guaranteed on the collapse side that the state won't vanish from
>> underneath you.
>> 
>> I think that should work. Usama?
>
>
>Kiryl's suggestion makes sense. I think there is a bug here. If we dont
>get the reference, whoever owns the reference should decide how partially_mapped
>is treated for that folio:
>
>- If its the last folio_put(), it will clear partially_mapped and cleanup
>after itself.
>- If its folio_ref_freeze(), clearing partially_mapped is wrong (which we
>are currently doing in deferred_split_isolate)

Yeah, returning LRU_SKIP looks right. I have this locally:

---8<---
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e771244f42f3..a269775129c4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3939,11 +3939,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n

 	VM_WARN_ON_ONCE(!mapping && end);
 	/*
-	 * If this folio can be on the deferred split queue, lock out
-	 * the shrinker before freezing the ref. If the shrinker sees
-	 * a 0-ref folio, it assumes it beat folio_put() to the list
-	 * lock and must clean up the LRU state - the same dequeue we
-	 * will do below as part of the split.
+	 * If this folio can be on the deferred split queue, hold the list_lru
+	 * lock across the refcount freeze and dequeue.
 	 */
 	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
 	if (dequeue_deferred) {
@@ -4592,22 +4589,10 @@ static enum lru_status deferred_split_isolate(struct list_head *item,
 	struct folio *folio = container_of(item, struct folio, _deferred_list);
 	struct list_head *freeable = cb_arg;

-	if (folio_try_get(folio)) {
-		list_lru_isolate_move(lru, item, freeable);
-		return LRU_REMOVED;
-	}
+	if (!folio_try_get(folio))
+		return LRU_SKIP;

-	/*
-	 * We lost race with folio_put(). Read folio state before the
-	 * isolate: folio_unqueue_deferred_split() checks list_empty()
-	 * locklessly, so once removed the folio can be freed any time.
-	 */
-	if (folio_test_partially_mapped(folio)) {
-		folio_clear_partially_mapped(folio);
-		mod_mthp_stat(folio_order(folio),
-			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-	}
-	list_lru_isolate(lru, item);
+	list_lru_isolate_move(lru, item, freeable);
 	return LRU_REMOVED;
 }
---

One detail, though ...

deferred_split_isolate()'s assumption predates patch 16. Patch 16 lets
collapse_freeze_candidate() leave refcount at zero and later unfreeze it
on rollback.

Existing split code takes a list_lru lock for deferred_split_lru before
folio_ref_freeze() and holds it through dequeue. The shrinker cannot see
that temporary zero.

collapse_freeze_candidate() does not take that lock and can roll back
later.

Say a candidate has two source folios. After the first one is frozen,
deferred_split_isolate() can see refcount 0, dequeue it, clear
PG_partially_mapped and decrement its accounting. If freezing the second
one fails, collapse rolls the first one back:

static void collapse_unfreeze_candidate(struct mm_struct *mm,
					struct collapse_candidate *cand,
					pte_t *pte, unsigned int nr_saved,
					unsigned int nr_frozen)
{
	unsigned long addr = cand->addr;
	unsigned int i = 0;

	while (i < nr_saved) {
		pte_t saved = cand->saved_ptes[i];
		struct folio *folio;
		unsigned int nr, k;

...
		folio = pte_folio(saved);
		nr = collapse_saved_span_len(cand, i, nr_saved);

		for (k = 0; k < nr; k++) {
			set_pte_at(mm, addr + k * PAGE_SIZE, pte + i + k,
				   cand->saved_ptes[i + k]);
		}
		if (i < nr_frozen) {
			folio_ref_unfreeze(folio,
					   folio_expected_ref_count(folio) + 1);
		}
		folio_unlock(folio);
		folio_put(folio);

		i += nr;
		addr += nr * PAGE_SIZE;
	}
}

PTEs and the folio's refcount are restored, but its deferred split queue
entry, PG_partially_mapped flag, and accounting are already gone. So yeah,
patch 16 has a real state-loss bug when collapse rolls back a partially
mapped folio.

LRU_SKIP looks right. A failed folio_try_get() only says refcount is zero.
It cannot tell a final folio_put() from a temporary freeze. A final put
still reaches:

void __folio_put(struct folio *folio)
{
...
	folio_unqueue_deferred_split(folio);
...
}

folio_unqueue_deferred_split() takes the same list_lru lock and clears
PG_partially_mapped + its accounting if the entry is still queued.

Cheers, Lance

