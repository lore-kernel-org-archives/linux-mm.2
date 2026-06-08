Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E62CCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F414E6B0093; Mon,  8 Jun 2026 10:56:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18A06B0096; Mon,  8 Jun 2026 10:56:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E996B0098; Mon,  8 Jun 2026 10:56:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D35D36B0093
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:56:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C8081C05A3
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:56:55 +0000 (UTC)
X-FDA: 84857047590.21.20EBD59
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id D9BD52000E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:56:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=apqaJtWf;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780930613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/kesTRV9t2c22OAzBqgCOd/YcVEK8MsHdf9rZxo8/1A=;
	b=wGA/Ptjc8uajw4i9aRfOrhNLF4XM6hfi1cEVk9h4FFnO/nnjNSPj/LSfXJKUxXm2zsXDYc
	p8jELCIG2KCaxZJZckf+EzieGofV6Z9mzCedhntocRAlj3Utxi2FaQA9MbOIezQLb44hns
	lyyI8kIRXcL2+gsF16ZVnKTXFw9EGAU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780930613;
	b=RHhZ0OAdBPsHC5PUsNeEwdDXoLS7hlROLT4asPwwPysVKhMjmCVVXXCF477u6h/VAq8wfu
	oFkiPlk4OSh2sLHwlVUS3yc6+68cIEs+rqNDG3fLNG8cxoouwzyMtwoUV2qsNPvXulRe12
	rHKW+TrR+pXQ7f4TrV1k/dZOTW88oGg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=apqaJtWf;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A752601D8;
	Mon,  8 Jun 2026 14:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AE21F00893;
	Mon,  8 Jun 2026 14:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780930613;
	bh=/kesTRV9t2c22OAzBqgCOd/YcVEK8MsHdf9rZxo8/1A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=apqaJtWfBTqTN+KmE10cgxfUIvzUJ4bFVOwiSnmdSo2kmJJI0K3hd5QiXb+aSWZRT
	 7eB+2YDtliulbsFu8wuQqer2oOUIo9iRRRBBDgm2XUmFaqU2orT8Gerbp8IHQTJn26
	 oqDwpFAQPuUHswzAIvrEZyw5icryOY9KUixQ6hDQLrhVOTyECMIsFsRCPxO576Riy+
	 +Z4DrCo3ELWqzPu6taEr8+LAkcQYQVeLAwDuS/SKwwv5M9S0Q4V4+6JNqhaYxW8Lrw
	 KZCk0sf2fm2xzFkZ8t10fR/NLh8p+UWzvD7M7d42hKkcVtmbLHqEQdZS4O+N6lqZde
	 22AlX1OWxY2YA==
Message-ID: <2553caae-9e0e-42a7-8b61-d1216f1e81fa@kernel.org>
Date: Mon, 8 Jun 2026 16:56:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v19 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: Lance Yang <lance.yang@linux.dev>, npache@redhat.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260605161422.213817-12-npache@redhat.com>
 <20260606102800.26940-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260606102800.26940-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D9BD52000E
X-Rspam-User: 
X-Stat-Signature: 4fqnn4wntxg44mwn4pbayjuna9468in8
X-Rspamd-Server: rspam08
X-HE-Tag: 1780930613-633352
X-HE-Meta: U2FsdGVkX186VQBYbc/SynPSThbSjGCbrm7V9CWDhYTN2RtVuFMlagcp//xcLGb/wKsDIFYHNbLw/EX5ctfhkTUicX9j4Os8Qq/hJdVUjraea7EqJ/zcGfyOIzTUS0ZRcbtcdf7TMO/qbUbqPZub6EjerkHIe89ahVcz7mQ9OHf+i1CC7ww/qO7R0+levPBBnPxbzQEQ5Crt2yCLuGaNy+5/beabe82mxUFCiUlOeHIZ/tqpufpnlnL8QJenyJHW7Zpu5jBFuC5nkFvqdNuSA9ilizd63PdpI1ghkwpFLl3iMYsnRJysUujs9xmlNG0fi1R9SF3YYvA616Mb0GRyjiGQ6DR+qVkRV5+qn65OixVdVQqead6EGQ7tx6PLj5ZS0usf9/+IV5lM/Ur566uEu0rmyaxuZnRGzx7wG4ot+3TEIcDlwG7N+cl/MPdcBsS3SDv/3SYt+NxSn3NI3vYNwoK6iwoN6endNLb+o6zWcMMsQzGqAzFctgCfmO3S1yMOzcX1WHbALQiV33YjrmRy7fbvJxaYZ3UtVnuH6LzrRxl9hm4jwxzjOJHPMuJ5GjZefTxbMd0Nh4oMucb+N5meqkswVGALxQJs8RcX3m7zCygDCIa2LFEWs8DRIXg+82vmf0fwQJbsklwfooXUasrULBewI97uJCjp+jrdT4FlrN7J+gd+AMfnuHjxkTjJ2OpLKi9dOTcE7MOBIWYJnUBtdgv0VrJjhhiXupGACToK9hPR6rdWtG/q8JozypgpsOvPtzEXs2uSDjKIEL1lt4jirQ8pfujeNrFuQFxA+9tRJHZYHuM1Kg0bca4O/6iALez49B6vkdtTbpHy+fd1uiUad3vOxJyJYwXGr5ct8YvTQh/1Frv9x8ycWdgJD9MBjn6uZdunaOrovag3OnXXRi2TKdvNXYM+UoyMvB+R24kt5uHtAN9VVFr5AwkpnrcFAkoN+Go/8qxt0JD9p7f2USm
 RG+0kDH3
 04fwt6p4t7REIj5O8g+9jPE5GR106WUwLQkHNVVE7JxnackovHjXn9WXjN3rC8jSjz602F5PdnmwLrtwyGEKuPhgJ6LM0HsVu6dOyGNuG1Y8C8oLszEacQsk+6skV3EJ8AKaGUtL+fVzsr/cM+L/Cp/3FBCXUpHNFs/ZAhKmWx3rH2bU5E0NFV5GPCwwVUd/MxUhR0KrItFCJRA0skzRboQJwwytgIkPY6X4R/k9OfO46SUxjg9PN/GAoOGSlz3rq7kAWAMxfshWB8+LOtbdoEWvMXPFHtC6y17iNRT8yHLsVXx6UnJDeAnc4mFEi6Ov9nkKGA3jyLH2dRdLMYht67klttyvC0Mu7a1rKOLYMH2SXSLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/6/26 12:28, Lance Yang wrote:
> 
> On Fri, Jun 05, 2026 at 10:14:18AM -0600, Nico Pache wrote:
>> Enable khugepaged to collapse to mTHP orders. This patch implements the
>> main scanning logic using a bitmap to track occupied pages and the
>> algorithm to find optimal collapse sizes.
>>
>> Previous to this patch, PMD collapse had 3 main phases, a light weight
>> scanning phase (mmap_read_lock) that determines a potential PMD
>> collapse, an alloc phase (mmap unlocked), then finally heavier collapse
>> phase (mmap_write_lock).
>>
>> To enabled mTHP collapse we make the following changes:
>>
>> During PMD scan phase, track occupied pages in a bitmap. When mTHP
>> orders are enabled, we remove the restriction of max_ptes_none during the
>> scan phase to avoid missing potential mTHP collapse candidates. Once we
>> have scanned the full PMD range and updated the bitmap to track occupied
>> pages, we use the bitmap to find the optimal mTHP size.
>>
>> Implement mthp_collapse() to walk forward through the bitmap and
>> determine the best eligible order for each naturally-aligned region. The
>> algorithm starts at the beginning of the PMD range and, for each offset,
>> tries the highest order that fits the alignment. If the number of
>> occupied PTEs in that region satisfies the max_ptes_none threshold for
>> that order, a collapse is attempted. On failure, the order is
>> decremented and the same offset is retried at the next smaller size. Once
>> the smallest enabled order is exhausted (or a collapse succeeds), the
>> offset advances past the region just processed, and the next attempt
>> starts at the highest order permitted by the new offset's natural
>> alignment.
>>
>> The algorithm works as follows:
>>    1) set offset=0 and order=HPAGE_PMD_ORDER
>>    2) if the order is not enabled, go to step (5)
>>    3) count occupied PTEs in the (offset, order) range using
>>       bitmap_weight_from()
>>    4) if the count satisfies the max_ptes_none threshold, attempt
>>       collapse; on success, advance to step (6)
>>    5) if a smaller enabled order exists, decrement order and retry
>>       from step (2) at the same offset
>>    6) advance offset past the current region and compute the next
>>       order from the new offset's natural alignment via __ffs(offset),
>>       capped at HPAGE_PMD_ORDER
>>    7) repeat from step (2) until the full PMD range is covered
>>
>> mTHP collapses reject regions containing swapped out or shared pages.
>> This is because adding new entries can lead to new none pages, and these
>> may lead to constant promotion into a higher order mTHP. A similar
>> issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
>> introducing at least 2x the number of pages, and on a future scan will
>> satisfy the promotion condition once again. This issue is prevented via
>> the collapse_max_ptes_none() function which imposes the max_ptes_none
>> restrictions above.
>>
>> We currently only support mTHP collapse for max_ptes_none values of 0
>> and HPAGE_PMD_NR - 1. resulting in the following behavior:
>>
>>    - max_ptes_none=0: Never introduce new empty pages during collapse
>>    - max_ptes_none=HPAGE_PMD_NR-1: Always try collapse to the highest
>>      available mTHP order
>>
>> Any other max_ptes_none value will emit a warning and default mTHP
>> collapse to max_ptes_none=0. There should be no behavior change for PMD
>> collapse.
>>
>> Once we determine what mTHP sizes fits best in that PMD range a collapse
>> is attempted. A minimum collapse order of 2 is used as this is the lowest
>> order supported by anon memory as defined by THP_ORDERS_ALL_ANON.
>>
>> Currently madv_collapse is not supported and will only attempt PMD
>> collapse.
>>
>> We can also remove the check for is_khugepaged inside the PMD scan as
>> the collapse_max_ptes_none() function handles this logic now.
>>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
>> mm/khugepaged.c | 146 +++++++++++++++++++++++++++++++++++++++++++++---
>> 1 file changed, 138 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index ec886a031952..430047316f43 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -99,6 +99,8 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>>
>> static struct kmem_cache *mm_slot_cache __ro_after_init;
>>
>> +#define KHUGEPAGED_MIN_MTHP_ORDER	2
>> +
>> struct collapse_control {
>> 	bool is_khugepaged;
>>
>> @@ -110,6 +112,9 @@ struct collapse_control {
>>
>> 	/* nodemask for allocation fallback */
>> 	nodemask_t alloc_nmask;
>> +
>> +	/* Each bit represents a single occupied (!none/zero) page. */
>> +	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
>> };
>>
>> /**
>> @@ -1440,20 +1445,130 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>> 	return result;
>> }
>>
>> +/* Return the highest naturally aligned order that fits at @offset within a PMD. */
>> +static unsigned int max_order_from_offset(unsigned int offset)
>> +{
>> +	if (offset == 0)
>> +		return HPAGE_PMD_ORDER;
>> +
>> +	return min_t(unsigned int, __ffs(offset), HPAGE_PMD_ORDER);
>> +}
>> +
>> +/*
>> + * mthp_collapse() consumes the bitmap that is generated during
>> + * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
>> + *
>> + * Each bit in cc->mthp_present_ptes represents a single occupied (!none/zero)
>> + * page. We start at the PMD order and check if it is eligible for collapse;
>> + * if not, we check the left and right halves of the PTE page table we are
>> + * examining at a lower order.
>> + *
>> + * For each of these, we determine how many PTE entries are occupied in the
>> + * range of PTE entries we propose to collapse, then we compare this to a
>> + * threshold number of PTE entries which would need to be occupied for a
>> + * collapse to be permitted at that order (accounting for max_ptes_none).
>> + *
>> + * If a collapse is permitted, we attempt to collapse the PTE range into a
>> + * mTHP.
>> + */
>> +static enum scan_result mthp_collapse(struct mm_struct *mm,
>> +		unsigned long address, int referenced, int unmapped,
>> +		struct collapse_control *cc, unsigned long enabled_orders)
>> +{
>> +	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
>> +	enum scan_result last_result = SCAN_FAIL;
>> +	int collapsed = 0;
>> +	bool alloc_failed = false;
>> +	unsigned long collapse_address;
>> +	unsigned int offset = 0;
>> +	unsigned int order = HPAGE_PMD_ORDER;
>> +
>> +	while (offset < HPAGE_PMD_NR) {
>> +		nr_ptes = 1UL << order;
>> +
>> +		if (!test_bit(order, &enabled_orders))
>> +			goto next_order;
>> +
>> +		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
>> +		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
>> +						      offset + nr_ptes);
>> +
>> +		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
> 
> Looks broken for swap PTEs in PMD collapse ...
> 
> collapse_scan_pmd() allows them up to max_ptes_swap and record them in
> unmapped, but they don't get a bit in mthp_present_ptes. And then
> mthp_collapse() does the check above:

Right. I assumed this is implicitly handled by the optimization in collapse_scan_pmd:

	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;

But we perform the check a second time.

> 
> nr_occupied_ptes >= nr_ptes - max_ptes_none
> 
> So max_ptes_none=0 + 511 present PTEs + one allowed swap PTE won't even
> call collapse_huge_page() for PMD order.
> 
> Shouldn't we account for them in the PMD-order check? Something like:
> 
> if (is_pmd_order(order))
> 	nr_occupied_ptes += unmapped;
As an alternative, we could either 1) skip the check there for
pmd order (as the check was already done); or 2) introduce+maintain
a bitmap that tracks non-present PTEs.

@@ -1475,7 +1477,9 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
                nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
                                                      offset + nr_ptes);
 
-               if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
+               /* Check was already done in the caller. */
+               if (is_pmd_order(order) ||
+                   nr_occupied_ptes >= nr_ptes - max_ptes_none) {
                        enum scan_result ret;
 
                        collapse_address = address + offset * PAGE_SIZE;

2) would probably be cleanest long-term.

-- 
Cheers,

David

