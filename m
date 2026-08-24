Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0B41C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2CEA6B00AB; Mon, 24 Aug 2026 12:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7036B00AC; Mon, 24 Aug 2026 12:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F266B00AD; Mon, 24 Aug 2026 12:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 525596B00AB
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:13:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8997A0117
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:13:56 +0000 (UTC)
X-FDA: 85136659272.28.655F4C9
Received: from mta0.migadu.com (out-139.mta0.migadu.com [91.218.175.139])
	by imf11.hostedemail.com (Postfix) with ESMTP id 95E4A40006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:13:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=abSqDNyw;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.139 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787588035;
	b=dyqau03EMkitKUnNQ6rxDNjQ/SxGxe570hEc5D5qAjwAV5jbUsYEZ7Ir7pvtnY8AeL4oMi
	AugH7vopBb2WXKGHvIzRtEweBI5A6OGashEkcKW0k7EabLYWfOveYjt/z4dX/2wiPwiqYY
	h9Eu0JAyE8j/2cnwj9BDDq7d8tQLGnQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=abSqDNyw;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.139 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787588035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BhOsuJoY3L6u8GNV+PC5ciDjqr92M19XB2V8DCcAL4U=;
	b=bTme2RfJxgPNogCc0hj3UTsRNLCCkOXHUxmbV042wKGWuaiQfen9fHoPRtMXuX9VGgTWWb
	tW5KQfAcbJkKxhL/aB/Frd697osF+awWYs3LyrhFzSzwj3jdcrRQA7V+QhpL7ae++GA3G9
	m5lr35eN62C8RyhffR/GYaah/Ev1x0U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=moWMKDFo1ejO1Y+SvTSn1ZBtiqsMttxF5PTsWQBALgw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787588033; v=1; x=1788192833;
 b=abSqDNyw/yKFT4k9pLTjpemjs+ZnH5r8henQ2NmyzQknZ14BHwMXRUfqVQMmcLNGLFEE7/uY
 pTcnnG5iAw+jRUjqYzg+K/ucUb7aDuxNY9j27CPnV6GrV9Dy10m2Kd1Os6trGrY3qiTzqCcDjon
 N2wOgPrDYlkyv60NIzhbaSdg=
X-Envelope-To: linux-mm@kvack.org
Received: from [192.168.50.204] (146.199.86.12)
	by smtp.migadu.com with ESMTPS id eea20e0d7aa22208;
	Mon, 24 Aug 2026 16:13:52 +0000
X-Mizu-Trace-ID: eea20e0d7aa22208
X-Migadu-Flow: FLOW_OUT
Message-ID: <f81160ac-0c7c-43f2-985f-43ab54a52358@linux.dev>
Date: Mon, 24 Aug 2026 17:13:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 16/57] mm/collapse: freeze the sources behind
 migration entries
To: Johannes Weiner <hannes@cmpxchg.org>,
 Kiryl Shutsemau <kirill@shutemov.name>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, nico.pache@linux.dev,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, liam@infradead.org, mhocko@suse.com, rppt@kernel.org,
 ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com,
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, jannh@google.com, willy@infradead.org,
 pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260816224609.308019-17-kirill@shutemov.name>
 <20260824131224.73344-1-lance.yang@linux.dev> <aoxQnuEacGpzp2I7@thinkstation>
 <20260824154921.GA863036@cmpxchg.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260824154921.GA863036@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 95E4A40006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 1y3kqk8dtb9tu4wixuk7q34zgadgxhqf
X-HE-Tag: 1787588034-774481
X-HE-Meta: U2FsdGVkX18UBcz1bf5R78gAiqOvheqgggrW/96UtPEHw8WzVDXGDvt0tb+4Nxg+x3BrJTycIG7XrqeolMMhEHmaGiIaS4DUiEKrjo0QibLx2CIbjUfew9hc3IQO3milWvWAxCThD8zrPCgT28TBczfoowLVR01p+xhzdo/b/Vn7ywmJoxj3fmvK9FpzspVymXTPUzIhmCwkROZ7w+5mUd/XtvW6/Y5Jwcmnpcg+0Q3F7d+bDsOHltWQ8FBlkoEjbZOLKr/splbpo0JafhAnvzM51Y2PWcO5q9wzhoEVhtifHGHZKo4w/Oa1Arad34lqBMlzUZtBR27mnF1pkohTOpp8nZ44S5RlT+0HPEss3s+FmXmZIeMRgaFBHZj/wIPW3it2zBdDrcUrxxoD4HCo5zI4O9IpcSXk9zCtmpknYkjWz04wLKuHpxN49nOr7R+mqleI/BYJvjMYZN4mEn/WKEJab/qT7Fpf1ZmN6iClRA0YKRNHdpWySkjC/qkaNVYmJz2SxsS4rKncEozYhyy4tOFjWB/je+BOJEjz6EMF0JOgwi3r2rb/CVBrRu7gEwMhjMQQyITNBeb2abNzc0rQTZyh2dnq2HxGf75XJ/jzAvG5frjgNyQRAUUgTqs6oGj7C9ne4kXFx3dLEjstIGL2yiMqmyd6STRyYg9laTCYARW04oBlYPaRBVcnYbv4OiSsQ93jptwMFQYAuPy/rzcbxuum/sWtxeOl02+WZNon2KIqcVhtdbPJ+0+Wo4lxN4XnaO5FxvB3dh+KotZI4LSocaRB9jvxajERybkSMcFuToPy3ZaAie7YkD7LFfKzraLPeSGdDT6oH3wBrhIaNObVpZBiw1UeQCOH0hg6J7eHlzQFteBo1eXj29MVLMBG1nZaL4ea8w3ZPXYjdwE6D2PnbcCLZM4J/kaRx9nhxziduc4/N3nolq8u7uWr/VOWgwCCeD7HQufKcZQCRehCALD
 SwpwCLS2
 69PmIiqsTbzeX8wd2+qiOzVXzHXS4ioc6KEVYQc/FyuNMhX5hJLcaMeZ7ndWSaHhgfCA//ooXeUsc76TIoA7ZL/Oy2Wrx4goXdIoju74wlUCC9CpGIlqtSu71ftVPO+/+hRRO97+Sil4PfA38CeY1UJ3OZzmimlF6wnneml/HCmafurcGtYmgbPXVJHL/U8/NBxnxBav3I6uQ4IXpPaQR4iDAMAh4KZi47Ak66fA8z4okNBKmBfgb1Q4Qpaf0LdLuV9N9XHay3jlfBAi6zl7GQRzYLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/08/2026 16:49, Johannes Weiner wrote:
> On Mon, Aug 24, 2026 at 03:13:10PM +0100, Kiryl Shutsemau wrote:
>> On Mon, Aug 24, 2026 at 09:12:24PM +0800, Lance Yang wrote:
>>>
>>> On Sun, Aug 16, 2026 at 11:45:28PM +0100, Kiryl Shutsemau wrote:
>>>> +		if (!folio_ref_freeze(folio,
>>>> +				      folio_expected_ref_count(folio) + 1)) {
>>>> +			result = SCAN_PAGE_COUNT;
>>>> +			goto unfreeze;
>>>> +		}
>>>> +		nr_frozen = nr_saved;
>>>
>>> Just one thing I was wondering about ... can deferred_split_isolate()
>>> remove a source folio from deferred_split_lru while its refcount is
>>> frozen by collapse_freeze_candidate()?
>>>
>>> Assume an earlier span belongs to an anonymous large folio on the
>>> deferred split queue, then a later span fails folio_trylock().
>>> collapse_freeze_candidate() continues after freezing each source folio
>>> and calls collapse_unfreeze_candidate() on a later failure:
>>>
>>> static noinline enum scan_result collapse_freeze_candidate(struct mm_struct *mm,
>>> 		struct collapse_candidate *cand, pte_t *pte)
>>> {
>>> ...
>>> 	for (i = 0, addr = cand->addr; i < nr_pages;) {
>>> ...
>>> 		if (!folio_trylock(folio)) {
>>> 			folio_put(folio);
>>> 			result = SCAN_PAGE_LOCK;
>>> 			goto unfreeze;
>>> 		}
>>> ...
>>> 		nr_saved = i + nr;
>>>
>>> 		if (!folio_ref_freeze(folio,
>>> 				      folio_expected_ref_count(folio) + 1)) {
>>> 			result = SCAN_PAGE_COUNT;
>>> 			goto unfreeze;
>>> 		}
>>> 		nr_frozen = nr_saved;
>>>
>>> 		i += nr;
>>> 		addr += nr * PAGE_SIZE;
>>> 	}
>>>
>>> ...
>>> unfreeze:
>>> 	collapse_unfreeze_candidate(mm, cand, pte, nr_saved, nr_frozen);
>>> 	return result;
>>> }
>>>
>>> folio_ref_freeze() takes the source folio's refcount to zero:
>>>
>>> static inline int folio_ref_freeze(struct folio *folio, int count)
>>> {
>>> 	return page_ref_freeze(&folio->page, count);
>>> }
>>>
>>> static inline int page_ref_freeze(struct page *page, int count)
>>> {
>>> 	int ret = likely(atomic_cmpxchg(&page->_refcount, count, 0) == count);
>>>
>>> ...
>>> 	return ret;
>>> }
>>>
>>> While collapse_freeze_candidate() still holds the source folio lock,
>>> deferred_split_scan() can call deferred_split_isolate():
>>>
>>> static unsigned long deferred_split_scan(struct shrinker *shrink,
>>> 		struct shrink_control *sc)
>>> {
>>> 	LIST_HEAD(dispose);
>>> 	struct folio *folio, *next;
>>> 	int split = 0;
>>> 	unsigned long isolated;
>>>
>>> 	isolated = list_lru_shrink_walk_irq(&deferred_split_lru, sc,
>>> 					    deferred_split_isolate, &dispose);
>>> }
>>>
>>> static enum lru_status deferred_split_isolate(struct list_head *item,
>>> 					      struct list_lru_one *lru,
>>> 					      void *cb_arg)
>>> {
>>> 	struct folio *folio = container_of(item, struct folio, _deferred_list);
>>> 	struct list_head *freeable = cb_arg;
>>>
>>> 	if (folio_try_get(folio)) {
>>> 		list_lru_isolate_move(lru, item, freeable);
>>> 		return LRU_REMOVED;
>>> 	}
>>>
>>> 	/*
>>> 	 * We lost race with folio_put(). Read folio state before the
>>> 	 * isolate: folio_unqueue_deferred_split() checks list_empty()
>>> 	 * locklessly, so once removed the folio can be freed any time.
>>> 	 */
>>> 	if (folio_test_partially_mapped(folio)) {
>>> 		folio_clear_partially_mapped(folio);
>>> 		mod_mthp_stat(folio_order(folio),
>>> 			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>>> 	}
>>> 	list_lru_isolate(lru, item);
>>> 	return LRU_REMOVED;
>>> }
>>>
>>> And folio_try_get() fails because the source folio has a frozen refcount.
>>> deferred_split_isolate() treats the failure as a race with folio_put(),
>>> clears PG_partially_mapped and its MTHP_STAT_NR_ANON_PARTIALLY_MAPPED
>>> accounting when set, then removes the folio from deferred_split_lru ...
>>
>> Hm. So, the premise in deferred_split_isolate() is false:
>> !folio_try_get() doesn't mean lost race with folio_put().
> 
> I suppose you mean, not exclusively. But it can also mean that. And
> then the question is, who cleans up the partially_mapped state.
> 
>> I think deferred_split_isolate() should do something like:
>>
>>       if (!folio_try_get(folio))
>>               return LRU_SKIP;
>>
>>       list_lru_isolate_move(lru, item, freeable);
>>       return LRU_REMOVED;
>>
>> Johannes, do I miss something?
> 
> Ah. The idea being: leave the item on the LRU when there is a race
> with the refcount going zero; and then it's up to that other side to
> deal with/clean up the partially_mapped state as appropriate. Thus:
> 
> folio_put()
>   __folio_put()
>     folio_unqueue_deferred_split()
>       if __list_lru_del():
>         // clear partially_mapped state & stats
> 
> will always succeed, even if it races with the shrinker. And you are
> also guaranteed on the collapse side that the state won't vanish from
> underneath you.
> 
> I think that should work. Usama?


Kiryl's suggestion makes sense. I think there is a bug here. If we dont
get the reference, whoever owns the reference should decide how partially_mapped
is treated for that folio:

- If its the last folio_put(), it will clear partially_mapped and cleanup
after itself.
- If its folio_ref_freeze(), clearing partially_mapped is wrong (which we
are currently doing in deferred_split_isolate)


