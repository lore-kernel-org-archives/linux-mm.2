Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84354C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F68E6B00B1; Wed, 29 Jul 2026 09:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5CD6B00B2; Wed, 29 Jul 2026 09:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 403686B00B3; Wed, 29 Jul 2026 09:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BDA86B00B1
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:59:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDB0C140701
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:43:38 +0000 (UTC)
X-FDA: 85041931716.18.9C21503
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1ED17C0006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:43:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V7vVZltv;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785332617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MrJoFtIwMXQt5ZyhY9hjJl3wSQc2T86WBOIiIs0Tcs8=;
	b=RmcbGHXV3ixKvVQOZJjoDapb8Jyu3vLysd1ug2Z47Kj9nsyVugjaRHoQ/FzBxkoqZPuUn3
	jObj8BYKIN7daiOtP3OTHnFvrJts6NtGZyJ41iytEHgvSfsax7yYp4vh82qfHyEi0EoKcK
	h5XvkkLahteR+V/MQsu8FHfOxVKUYFE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785332617;
	b=g1Beyw5q2Z92Z31/zAefuePrmylBMIAtL4/Qd50MAczi1LWEp24bE7LoEBJGw7NpwKI9Ca
	8xtlDF1+vpGUfKHr8xa0x7XfEqd8FbVGz62NlvQ6a4v9O5nQK0v0ez2+JUCb1J0suUWyA2
	ECUli+mxc6JW48RINnAxyKhfVCeK92k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V7vVZltv;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <0bdb81db-5e2f-47c9-998d-bca450644ba6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785332615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MrJoFtIwMXQt5ZyhY9hjJl3wSQc2T86WBOIiIs0Tcs8=;
	b=V7vVZltvqUQ+BiUX2YqoMMSSG4KoaC7M9aQrEbYm3a4JS9L53+gchrT3Ch16aeCxtAiLuf
	IT2sWCB8w2Am/1xntQngKzMnnujix/XdnlHnxcISjHXe9XM8EWJ5pxmSKaC6YTFT10sQs+
	6TJm4X/62Nqt66o0FYIgP60TPBqmQL4=
Date: Wed, 29 Jul 2026 14:43:24 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Cc: alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 willy@infradead.org, linux-mm@kvack.org
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <20260707201735.4113107-3-joannelkoong@gmail.com>
 <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
 <77b3b74d-c1bb-461b-8076-8729cdcf91f5@linux.dev>
 <7d841b27-f60a-496f-81db-84158a0a8f8f@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <7d841b27-f60a-496f-81db-84158a0a8f8f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1ED17C0006
X-Stat-Signature: oouooq7oq1ahtu9uar8r4m36164b6sdc
X-Rspam-User: 
X-HE-Tag: 1785332616-303421
X-HE-Meta: U2FsdGVkX19MvWapqY1s0v5gpQW4EKbcHhg1M5b+uQyDkfUVkl+oB+IvqW8KOD/n87jyAm1+s5uRkVkXNaa+RisTqXCBv3XttSZ46XOkrT+1ahVzySVKhnviqj2uIxjdRl/MEwhMUuMKHyr6hk+zQXODYfgcFCoqaOTWRl1d0dvWMcBTHq42gjPnRf2jmBUeUEMa4wU+UrOLGu24IfxgJm5LTuj5xvfcgV+Ohfmn1xd8+mVWm/0U9lKGZknvanY8wjt6a9OQWF054Q9/62O5PUjU8URHqIJp4CclyUIlX1KTPU58xedxiF6W+Ig3w7vLdDgPn1mQiyttSAeAhLMN2goEFTDR+jTqqIriTRb0w509FR/mSEw+zwdHKiMd6sN3HRsab8JQ3D+mp/F4h70ui3PAAlmpCPQSqDFfveQO0z+a6pi2Bg72SKqzEDuPC6OwZPJaNH50cZsAy9N9rMzl3amI/3T8Z2pt3yu93MqnqYVE5PzkAbAV4L5sTWD6uUHHqlq3Fuy3ZtYYHLyscj29rek5vkRW6ftryR2GicyVlxeE19Jq9GnE9xQq+T7DhGVA/bNUdaby5qIhwatoFSIj5pFlm704LZAvoqn9jEpQ9pRwWFab8vycVbhGIMpotOOvHqKTizvdW4Kz62CG0r+vzvrBan+B/hjKkYgsNO6Dq30qoDcT8a6tN5xBTh0ASyKUemXj6U11XAUE/JvAfCeO0SV0+ohPYOxSzUXp+ml3kfY0uRZaOTcKtT34uX4CRc2s5GjleEcNKQcKiouskmKnGVBTZUiu9JzC4XLY4fEbcsd7p562tMuJCkIAK3X1uarBomKbHoUN1BeD8RDusVX6UI19jfSptyQ3EBioMhlRaF0PSwHqZr8WzDrA3P4GZwD9XHc07fE1Qb3Izk+CzfCicv7LEE/kUp60ZQWNgb8vtZ9qbwsRvhqIovmNxQNRotIfwt7Vgu8ltn3AxROEBNO
 4CDqeC53
 ojChBTZHC8RBhLTUweKveQ5GX62fecHwb6sf0Cy18RzgvcJW/LjhrxcHnQV8/4H4lBAOT7kWRsd2O3cS9OjhgZV9XTwEaciEVIc8kIFY6eJhugNBadXyzzzYH6rDQG02auOpOEnsRUKee49cEh9vldDUGJ1QFqYfdpRnA4RmcqPlIVVOV4y3LDYYq744VBbBAGBDaQK6n1k4rePQtVGHzzbFAGJpZjmUo+iWf0oWCSpFXUt3Td/VQQ1DiM0E4CuxOOfhe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/07/2026 13:36, David Hildenbrand (Arm) wrote:
> On 7/8/26 11:58, Usama Arif wrote:
>>
>>
>> On 08/07/2026 08:56, David Hildenbrand (Arm) wrote:
>>> On 7/7/26 22:17, Joanne Koong wrote:
>>>> Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
>>>> to the deferred split list at fault or collapse time. As a result, a
>>>> fully mapped mTHP folio that is mostly zero-filled doesn't get split by
>>>> the deferred split shrinker when the system is under memory pressure.
>>>>
>>>> Add anonymous mTHP folios to the deferred split list so that if there's
>>>> memory pressure, a zero-filled mTHP can be split with its zero pages
>>>> remapped to the shared zero page and then reclaimed.
>>>>
>>>> To minimize overhead on the common order-0 fault path, the
>>>> deferred_split_folio() call is guarded by an inline folio_test_large()
>>>> check.
>>>>
>>>> Suggested-by: Usama Arif <usama.arif@linux.dev>
>>>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>>>> ---
>>>>  mm/memory.c | 2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/mm/memory.c b/mm/memory.c
>>>> index 6637c5b13c9b..441d918e3dc0 100644
>>>> --- a/mm/memory.c
>>>> +++ b/mm/memory.c
>>>> @@ -5259,6 +5259,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
>>>>  	folio_add_lru_vma(folio, vma);
>>>>  	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
>>>>  	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
>>>> +	if (folio_test_large(folio))
>>>> +		deferred_split_folio(folio, false);
>>>>  }
>>>>  
>>>>  static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
>>>
>>> I had a session [1] at LSF/MM about having essentially all large anon folios
>>> part of the the deferred split queue.
>>>
>>> (1) I don't think this scales.
>>>
>>
>> What if we only add the mTHPs for which the policy is set to always.
> 
> That doesn't really help lock contention. And the lock contention is indeed a
> thing, as we now also want to enable the LRU cache for smaller large folios,
> which improves performance:
> 
> https://lore.kernel.org/r/20260709081536.82768-1-baohua@kernel.org
> 
>>
>> I think it doesn't scale if someone sets all orders to always, but if you only
>> set the 2M mTHP sysfs to always, it should be the same as what we have today
>> for PMD order?
> 
> I don't see a problem with large large folios, only with small large folios :)
> 
>>
>> The main motivation for this series is to try and bring the performance for
>> ARM on par with x86. One of the differences is TLB misses. I imagine the lower
>> churn in kernel by using larger page sizes will help as well. But we will
>> run into OOMs without the shrinker.
> 
> Can you elaborate how this change helps here? I assume you want to enable mTHP
> in production. Which sizes? large large ones? :)
> 

One of the differences in our production between x86 and ARM hosts which we think
should perform at a similar level (but currently aren't) is TLB misses.

On x86, we have 2M THP set to always.
On ARM, we have base page size of 64K. 2M mTHPs should help bridge the gap due to
TLB coalescing. We can't really set 2M mTHP to always as without the mTHP shrinker
we will end up with severe memory pressure and a significant increase in OOMs.

We don't plan to enable other mTHP sizes on ARM, only 2M.

The series by Barry is for folios above costly order, so won't impact this.

David, Joanne, Johannes: what do you think about only adding folios that are larger
than COSTLY_ORDER to deferred split list?

