Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35B77109C028
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C0CB6B00A5; Wed, 25 Mar 2026 11:01:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94A746B00A7; Wed, 25 Mar 2026 11:01:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839A46B00A8; Wed, 25 Mar 2026 11:01:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1116B00A5
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:01:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB4B58C857
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:01:13 +0000 (UTC)
X-FDA: 84584898426.13.CC2A7B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3AF38C0029
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:01:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fQ6c99w/";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLfzS/Pij0qLCeb2wjXaUjPYf1U26b39dS6MWcHSfaU=;
	b=Bml8RboSAXAD0foVYHz5gdD3RUPKdcbJ47FtwJXXRF1dyyaSBD60rY3ew9b5fijtCjDFvg
	wdgHCQPu1gKzhMaEaRdWUCA/fa2IlPryL6Y4M1lfWxpLJ39COTqJohMU4sAfQvik0xjpQl
	T7XzUb68vepe1FWi94XUXqf+UW7GM5Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774450871; a=rsa-sha256;
	cv=none;
	b=rq4h1B41s+j7kDF91xwYcfwWIf4wauwcQmGoY+hh6ELhjHYREAhrwzJ6nBZbGtcIARoI0w
	DMHLMknJOgKxYyBSGswTM9bVf8+DVEkCxcUqXIirrnhKUYsq+FD+AWbaL74+xXI4osYLPD
	+65xb9HfHk9rFeh1NgzAeJgwr4mI8ZU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fQ6c99w/";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 78B1E60103;
	Wed, 25 Mar 2026 15:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E057FC4CEF7;
	Wed, 25 Mar 2026 15:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450870;
	bh=qVRF9sk1Jd0nZq4F7HqfXkke05aS+QAgoJZ+38yMEVo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fQ6c99w/XgLo2BKV8yRY1ozwD37yWcqUOQeYTXfAO3ZrgPhLDkzCzD/8FjPm1qlnW
	 AoLx3T/NedKCCagIUrPPaTBC4SRlgZ6ZU1+Htd2WmqYjZs9EjUXgG35+GTMH6nMBfN
	 nA8T0mS0f63WCHEfF9f2oll36MM2qlAlsKFmVvxEUdR6dbIhOk4naAtOTMSWtxrYsI
	 ltRG9yvLfwZTG2/HQW03+fN/Y6j+JT8ZEWVMqtDI+2/Do1xgkfGR4pxkBQtigDMlaY
	 KPAIbLo7IegjxHY/7oRPryoQPlhvkF0j57qUGQ9KCjMHtX9bXVonEGx8YwK5P/HdXa
	 6zRk8g5utnl0A==
Message-ID: <0030565c-ec0d-47f6-94a9-b16e76800875@kernel.org>
Date: Wed, 25 Mar 2026 16:01:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] vmalloc: Optimize vfree
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-3-usama.anjum@arm.com>
 <e5d4e527-5e81-4713-a145-c87100973bea@kernel.org>
 <80dc24d6-944c-46d8-a692-24a9be408a59@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <80dc24d6-944c-46d8-a692-24a9be408a59@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: dnozc9xp1k1rwhxtqsozfopjmbc8d6ib
X-Rspamd-Queue-Id: 3AF38C0029
X-Rspam-User: 
X-HE-Tag: 1774450871-110706
X-HE-Meta: U2FsdGVkX1+Cr6jYIce/ne+U/2esaCHE0cWJlc5qpxIDLig0BAdwVgyM3NNi7egMr4OieNgNsUpaswE5mjIolNQgNUJwZSWDymR8VY/fngd/795VM2XaFJLo3bPmTYmr1ZhSdsmX1eE3+5WF8CYiS31vEHpt4aqIQMHTUC7bxwk5VQ0dr+QQICtTfIKXVrA7OdLqfqqyestW50qtwW+DSpoKoSmoUo+odv6nUAGiMKKxigXPiGVzz+IH11jWkMrnDhsXVAg1D8G1LAjzcjoR86+ZNd+gQ3p9S8FIOvX7bJSOyAb4kboc9n5/9W+f9DFBuyLY2DE8XeLujMJKMbilQx1DHTMLK50ocILP9ugBm5FpY7uJzoah2lseastRETwPNu3FdZAr3SylfJSPlX6PNxa+D9RqZZWQYqLWH/WV/pa7yopCIILIOKbb4RsqitirIuFENLAWeC4w6dHkqx7379eUKf0fsknAdJ5IQgMtJCPb4nKKbQ9l+7nnylI+FBjG1W8XE3oLyvVrAMAhr+6jEBTbO59ebp72Nqw5ACdYMcvUCaNPlHMHtd0eWGq3ZlGuZV4XqcPDUN+nKHBpqExClkm7rSsQL1gMElAM3JtvtxIDSmEX6oCr7bPngjW7PUzK/wzvsw75hxhohqAzTGoWzvjYhFFoKsoKjWJjnxe+PwKmf2fgG2EZ84xsAkVRsJeyB+r4pK460sl3LHyGC/iTTieH2tnTDw7m9QV+5CaIO7ptt+6gW6CT4X/rFDgbK4F0u33ORyGzepuDtA6LypT1rndhlAnaeRwLV1Cwcb4FfehDBTpzdkqbVXlSMz2NSCfSTMIgBR4eatjq8FXnSyM7bg+Zck2OgqhRzrBl5IVDndC14XAJUBlXpef2zW+/UxMhrxFcvvqe3Y712cEL+DzP9uUYca2mXTHdNgQJ4oPR2BQiviXPu0fzek1FpdLVBWZOhCCQh42b03Ocp1/P+Qj
 dhX+QYKO
 4HlN2o1urwQP4/36cYru3mw3HQgsBOUZGD/vtZFhTwfrLxqOS6jqdd5j/tov8TNVlNb2S56oihbEHRpo4pnKuhWqki/bIuvj9TPymqCwe/nA1Y7S5BdGUXyk1bf29jcnC1vsP4f4sLGEK0z45Dtb78ZpFB4H/tHvRBa3Ci0USF1MzcpDQ7S05A43YC/8h57Z1pFqkKHV/8dZyDIeYVQRsIWzBNrjoV9UPNxizPRIX6VEMRWTWYgvusTVXz1M8k8GEX+Y69id/f+yvQMgziYpsIxKWBujEFE1iDx4XwqwiVKMiLmDpLEV12nY6wano639oB3PaCKAkMhymWyHqKJ6By+UG7GLvOKBsq/G2hffitR9WyBKZ5sW+omLBtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 15:26, Muhammad Usama Anjum wrote:
> On 25/03/2026 10:05 am, David Hildenbrand (Arm) wrote:
>> On 3/24/26 14:35, Muhammad Usama Anjum wrote:
>>> From: Ryan Roberts <ryan.roberts@arm.com>
>>>
>>> Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
>>> must immediately split_page() to order-0 so that it remains compatible
>>> with users that want to access the underlying struct page.
>>> Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
>>> allocator") recently made it much more likely for vmalloc to allocate
>>> high order pages which are subsequently split to order-0.
>>>
>>> Unfortunately this had the side effect of causing performance
>>> regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
>>> benchmarks). See Closes: tag. This happens because the high order pages
>>> must be gotten from the buddy but then because they are split to
>>> order-0, when they are freed they are freed to the order-0 pcp.
>>> Previously allocation was for order-0 pages so they were recycled from
>>> the pcp.
>>>
>>> It would be preferable if when vmalloc allocates an (e.g.) order-3 page
>>> that it also frees that order-3 page to the order-3 pcp, then the
>>> regression could be removed.
>>>
>>> So let's do exactly that; use the new __free_contig_range() API to
>>> batch-free contiguous ranges of pfns. This not only removes the
>>> regression, but significantly improves performance of vfree beyond the
>>> baseline.
>>>
>>> A selection of test_vmalloc benchmarks running on arm64 server class
>>> system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
>>> large order pages from buddy allocator") was added in v6.19-rc1 where we
>>> see regressions. Then with this change performance is much better. (>0
>>> is faster, <0 is slower, (R)/(I) = statistically significant
>>> Regression/Improvement):
>>>
>>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>>> | Benchmark       | Result Class                                             |   mm-new          |  this series       |
>>> +=================+==========================================================+===================+====================+
>>> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
>>> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
>>> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
>>> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
>>> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
>>> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
>>> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
>>> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
>>> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
>>> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
>>> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
>>> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
>>> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
>>> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
>>> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
>>> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
>>> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
>>> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
>>> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
>>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>>>
>>> Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
>>> Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
>>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> ---
>>> Changes since v2:
>>> - Remove BUG_ON in favour of simple implementation as this has never
>>>   been seen to output any bug in the past as well
>>> - Move the free loop to separate function, free_pages_bulk()
>>> - Update stats, lruvec_stat in separate loop
>>>
>>> Changes since v1:
>>> - Rebase on mm-new
>>> - Rerun benchmarks
>>>
>>> Made-with: Cursor
>>> ---
>>>  include/linux/gfp.h |  2 ++
>>>  mm/page_alloc.c     | 23 +++++++++++++++++++++++
>>>  mm/vmalloc.c        | 16 +++++-----------
>>>  3 files changed, 30 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>>> index 7c1f9da7c8e56..71f9097ab99a0 100644
>>> --- a/include/linux/gfp.h
>>> +++ b/include/linux/gfp.h
>>> @@ -239,6 +239,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>>  				struct page **page_array);
>>>  #define __alloc_pages_bulk(...)			alloc_hooks(alloc_pages_bulk_noprof(__VA_ARGS__))
>>>  
>>> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages);
>>> +
>>>  unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
>>>  				unsigned long nr_pages,
>>>  				struct page **page_array);
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index eedce9a30eb7e..250cc07e547b8 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -5175,6 +5175,29 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>>  }
>>>  EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
>>>  
>>
>> Can we add some kerneldoc describing call context etc?
> Yes, I'll add short kerneldoc here.
>>
>>> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
>>> +{
>>> +	unsigned long start_pfn = 0, pfn;
>>> +	unsigned long i, nr_contig = 0;
>>> +
>>> +	for (i = 0; i < nr_pages; i++) {
>>> +		pfn = page_to_pfn(page_array[i]);
>>> +		if (!nr_contig) {
>>> +			start_pfn = pfn;
>>> +			nr_contig = 1;
>>> +		} else if (start_pfn + nr_contig != pfn) {
>>> +			__free_contig_range(start_pfn, nr_contig);
>>> +			start_pfn = pfn;
>>> +			nr_contig = 1;
>>> +			cond_resched();
>>> +		} else {
>>> +			nr_contig++;
>>> +		}
>>> +	}
>>
>> Could we use num_pages_contiguous() here?
>>
>> while (nr_pages) {
>> 	unsigned long nr_contig_pages = num_pages_contiguous(page_array, nr_pages);
>>
>> 	__free_contig_range(pfn_to_page(*page_array), nr_contig_pages);
>> 	
>> 	nr_pages -= nr_contig;
>> 	page_array += nr_contig;
>> 	cond_resched();
>> }
>>
>> Something like that?
> __free_contig_range() is already checking for the sections. If
> num_pages_contiguous() is called here, it'll cause the duplication
> of the section check.

No problem. For configs we care about it's optimized out entirely either
way.

-- 
Cheers,

David

