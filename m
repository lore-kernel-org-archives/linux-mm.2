Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFDBDCD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 01:53:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 075AA6B0005; Mon,  8 Jun 2026 21:53:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F419E6B0088; Mon,  8 Jun 2026 21:53:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0A026B008A; Mon,  8 Jun 2026 21:53:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CCB526B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:53:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CDE91203D0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 01:53:18 +0000 (UTC)
X-FDA: 84858701676.16.E0E4A45
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 083D2180003
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 01:53:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nr0e3yEp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780969996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lMwoIGwmHL5jq6k7DRmMIiOP7MlJzA+Jmp+TngHbG40=;
	b=xyTSujXsgCnoQ4lAzrh27Vkmtttwo1jitBeGesN0gQmBUMeWQcaEWiQRbyM/Llt+StB6iI
	ewUtlxwBYt/HWU4eAvoxRlilGNyOfwRD+i4oB5TlG26LJ/Depo8mHQXaQ750Qs9bt3x7Xg
	Jdn5oqHVBnYesyAeCN2LNaE80DXKm9I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nr0e3yEp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780969996;
	b=a2vRC+zuFlp4iVfwpNv34U1yqGC77Llcma8dw+6DBpM+aT1b2t1Z0yCzxRW1NPYGj70Fnf
	v4774qGW2fv3GGHt1zGHtbk7aCVjuQ8pBg2PguZDa/7AQ7VdAv1iIhwgXCciSS8Nl+xcMr
	OF+dX2aop89jlBsZVoZ489hhEJ7SUJA=
Message-ID: <de647abc-b016-4425-9c82-96ea00bfaca5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780969993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lMwoIGwmHL5jq6k7DRmMIiOP7MlJzA+Jmp+TngHbG40=;
	b=nr0e3yEplrSOJ9/zRyoUG5133F42jJgtk8LiVp8IlkZ8OU+hq9sC5Lnu8Aqbdk7lMAoj97
	Ci+0TjQ2xmwhb7jN5i5uuvwGbdGjGbgEgrn7KxgV4wcAF9cKT1J5GXlzQCqBBOZuGcCbVx
	ByIF1fkzg2gLezDl2KCiJi2fBqSf3WM=
Date: Tue, 9 Jun 2026 09:52:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable v19 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Content-Language: en-US
To: david@kernel.org
Cc: npache@redhat.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
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
References: <2553caae-9e0e-42a7-8b61-d1216f1e81fa@kernel.org>
 <20260608162612.27122-1-lance.yang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260608162612.27122-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 083D2180003
X-Stat-Signature: x9r6k9cz3pzokaf9q4iu9yc3hqjjut3f
X-HE-Tag: 1780969995-836039
X-HE-Meta: U2FsdGVkX19dJPFU2OYMTh72xjOzlzmAh8JL/+qe0WLs9WalK27W5C4RD4SAxn7wivKeOHOiPaLQ/hHhitJdQZxfHmbDH1q4vCvfauTtIzX5gdGvmnnibQpoTzehFLI+86FRVVqO6+5MS/gU1TyheAidray7nCgdGlJRkiHsDvobMYDPXEwkJqUNQTQfi1IsgZgNabGhA7PG3zkO2NWjTYhOTqqbAnLBGO4JD81Pr/04/aG7rKxFnGziemOLx13RgA14mt4KJ/zJ/dF7TDH1bIOLL0AjRoYHJub33hU1kkGfWBpds4+5eoK7m5zGHV2uqdpKjBGCRSXC0sdecyrNyY5wTks8nbPSokDOTavRltG00iWOZSMdQKBwVod4brfVP11KGtEo0q5uZAY2u/XWuYrwJBZnp2jMLVl4Sl94k/lhsktD6DFDgc8waPKNOKY2ZPOMYHnwdBAIDB2IApYsqn/8T6pA+Vhcr7X9lt4SJLWpblwBGvofBOjZD6FfBa0NvsipQ+B+rDb5cEQV5dU6adinWO2mD8cjDp7txTH86Qy4RCEdn86s0SwBvxFIEkKjmAYFclwS+VQkuRBVyxCL+ivz64nuHfliR1GcAeDjvbKvLwPBQAMXxd/TVNfX2mltoZ/aDmC2pSHEi6Tf8p64Jf5/AwGnxcvs0WORH1mVPoFGMhiOCCo5CKlvLUon6vtJ8H9Lw0ZbJxGZ2yEEBEeMK53zVRe7K6fzK0Leo+DIBvnvjBEG5HuesveeITHkkfQh1esTmhQfT2KYgEdAHoaMRHQxax7cPCVzsAnfZ0A4w4p/JxSukdonoxH3UfyNKBxhvSsA47Drr1PLJckUC1Bq+P2L7oiACDlbF8gDwnE05iDw6zo9x7rtCdaPTa00mLbs9R6kpnfwi4wvu/6RGFa2E6+zvdIRNr2vJH7Zl2Wi6lsKLfe6MHQj0h1iqsjsoZQvxqV6FdYIiIZ5enojQ2j
 k+XIRm23
 94Z5qbgMPxLbH2fMMzaYykVl3zVZYvtJHz6RFjCTUT/Hzu8bL6DIH5Y1/R0ERmiYI96SkctnKKnCpSHUnUhKpmUC7aQDWewoK6GrvEjgYiuwiPR82fQvFQboSynd1a/wpDSUhNX1rs+bXcVwyoPmVsjbj1qCOUCp3gEk/2pGqAciwuNDt41qwHyQLoe6OC6+/Tvz4BuBCfxnfY1ub2JFyjh5VnvuEm/Bh0xa4yX+4EEcAGD0DiHzqC3c7zb5dBpeLgNrAe/84gZwYZYFmFtXE2LemwkZ9sgcdYXbqfeCKtpN2ugOA0emIZwWBqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/9 00:26, Lance Yang wrote:
> 
> On Mon, Jun 08, 2026 at 04:56:37PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/6/26 12:28, Lance Yang wrote:
>>>
>>> On Fri, Jun 05, 2026 at 10:14:18AM -0600, Nico Pache wrote:
>>>> Enable khugepaged to collapse to mTHP orders. This patch implements the
>>>> main scanning logic using a bitmap to track occupied pages and the
>>>> algorithm to find optimal collapse sizes.
>>>>
>>>> Previous to this patch, PMD collapse had 3 main phases, a light weight
>>>> scanning phase (mmap_read_lock) that determines a potential PMD
>>>> collapse, an alloc phase (mmap unlocked), then finally heavier collapse
>>>> phase (mmap_write_lock).
>>>>
>>>> To enabled mTHP collapse we make the following changes:
>>>>
>>>> During PMD scan phase, track occupied pages in a bitmap. When mTHP
>>>> orders are enabled, we remove the restriction of max_ptes_none during the
>>>> scan phase to avoid missing potential mTHP collapse candidates. Once we
>>>> have scanned the full PMD range and updated the bitmap to track occupied
>>>> pages, we use the bitmap to find the optimal mTHP size.
>>>>
>>>> Implement mthp_collapse() to walk forward through the bitmap and
>>>> determine the best eligible order for each naturally-aligned region. The
>>>> algorithm starts at the beginning of the PMD range and, for each offset,
>>>> tries the highest order that fits the alignment. If the number of
>>>> occupied PTEs in that region satisfies the max_ptes_none threshold for
>>>> that order, a collapse is attempted. On failure, the order is
>>>> decremented and the same offset is retried at the next smaller size. Once
>>>> the smallest enabled order is exhausted (or a collapse succeeds), the
>>>> offset advances past the region just processed, and the next attempt
>>>> starts at the highest order permitted by the new offset's natural
>>>> alignment.
>>>>
>>>> The algorithm works as follows:
>>>>     1) set offset=0 and order=HPAGE_PMD_ORDER
>>>>     2) if the order is not enabled, go to step (5)
>>>>     3) count occupied PTEs in the (offset, order) range using
>>>>        bitmap_weight_from()
>>>>     4) if the count satisfies the max_ptes_none threshold, attempt
>>>>        collapse; on success, advance to step (6)
>>>>     5) if a smaller enabled order exists, decrement order and retry
>>>>        from step (2) at the same offset
>>>>     6) advance offset past the current region and compute the next
>>>>        order from the new offset's natural alignment via __ffs(offset),
>>>>        capped at HPAGE_PMD_ORDER
>>>>     7) repeat from step (2) until the full PMD range is covered
>>>>
>>>> mTHP collapses reject regions containing swapped out or shared pages.
>>>> This is because adding new entries can lead to new none pages, and these
>>>> may lead to constant promotion into a higher order mTHP. A similar
>>>> issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
>>>> introducing at least 2x the number of pages, and on a future scan will
>>>> satisfy the promotion condition once again. This issue is prevented via
>>>> the collapse_max_ptes_none() function which imposes the max_ptes_none
>>>> restrictions above.
>>>>
>>>> We currently only support mTHP collapse for max_ptes_none values of 0
>>>> and HPAGE_PMD_NR - 1. resulting in the following behavior:
>>>>
>>>>     - max_ptes_none=0: Never introduce new empty pages during collapse
>>>>     - max_ptes_none=HPAGE_PMD_NR-1: Always try collapse to the highest
>>>>       available mTHP order
>>>>
>>>> Any other max_ptes_none value will emit a warning and default mTHP
>>>> collapse to max_ptes_none=0. There should be no behavior change for PMD
>>>> collapse.
>>>>
>>>> Once we determine what mTHP sizes fits best in that PMD range a collapse
>>>> is attempted. A minimum collapse order of 2 is used as this is the lowest
>>>> order supported by anon memory as defined by THP_ORDERS_ALL_ANON.
>>>>
>>>> Currently madv_collapse is not supported and will only attempt PMD
>>>> collapse.
>>>>
>>>> We can also remove the check for is_khugepaged inside the PMD scan as
>>>> the collapse_max_ptes_none() function handles this logic now.
>>>>
>>>> Signed-off-by: Nico Pache <npache@redhat.com>
>>>> ---
>>>> mm/khugepaged.c | 146 +++++++++++++++++++++++++++++++++++++++++++++---
>>>> 1 file changed, 138 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index ec886a031952..430047316f43 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -99,6 +99,8 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>>>>
>>>> static struct kmem_cache *mm_slot_cache __ro_after_init;
>>>>
>>>> +#define KHUGEPAGED_MIN_MTHP_ORDER	2
>>>> +
>>>> struct collapse_control {
>>>> 	bool is_khugepaged;
>>>>
>>>> @@ -110,6 +112,9 @@ struct collapse_control {
>>>>
>>>> 	/* nodemask for allocation fallback */
>>>> 	nodemask_t alloc_nmask;
>>>> +
>>>> +	/* Each bit represents a single occupied (!none/zero) page. */
>>>> +	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
>>>> };
>>>>
>>>> /**
>>>> @@ -1440,20 +1445,130 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>>>> 	return result;
>>>> }
>>>>
>>>> +/* Return the highest naturally aligned order that fits at @offset within a PMD. */
>>>> +static unsigned int max_order_from_offset(unsigned int offset)
>>>> +{
>>>> +	if (offset == 0)
>>>> +		return HPAGE_PMD_ORDER;
>>>> +
>>>> +	return min_t(unsigned int, __ffs(offset), HPAGE_PMD_ORDER);
>>>> +}
>>>> +
>>>> +/*
>>>> + * mthp_collapse() consumes the bitmap that is generated during
>>>> + * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
>>>> + *
>>>> + * Each bit in cc->mthp_present_ptes represents a single occupied (!none/zero)
>>>> + * page. We start at the PMD order and check if it is eligible for collapse;
>>>> + * if not, we check the left and right halves of the PTE page table we are
>>>> + * examining at a lower order.
>>>> + *
>>>> + * For each of these, we determine how many PTE entries are occupied in the
>>>> + * range of PTE entries we propose to collapse, then we compare this to a
>>>> + * threshold number of PTE entries which would need to be occupied for a
>>>> + * collapse to be permitted at that order (accounting for max_ptes_none).
>>>> + *
>>>> + * If a collapse is permitted, we attempt to collapse the PTE range into a
>>>> + * mTHP.
>>>> + */
>>>> +static enum scan_result mthp_collapse(struct mm_struct *mm,
>>>> +		unsigned long address, int referenced, int unmapped,
>>>> +		struct collapse_control *cc, unsigned long enabled_orders)
>>>> +{
>>>> +	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
>>>> +	enum scan_result last_result = SCAN_FAIL;
>>>> +	int collapsed = 0;
>>>> +	bool alloc_failed = false;
>>>> +	unsigned long collapse_address;
>>>> +	unsigned int offset = 0;
>>>> +	unsigned int order = HPAGE_PMD_ORDER;
>>>> +
>>>> +	while (offset < HPAGE_PMD_NR) {
>>>> +		nr_ptes = 1UL << order;
>>>> +
>>>> +		if (!test_bit(order, &enabled_orders))
>>>> +			goto next_order;
>>>> +
>>>> +		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
>>>> +		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
>>>> +						      offset + nr_ptes);
>>>> +
>>>> +		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
>>>
>>> Looks broken for swap PTEs in PMD collapse ...
>>>
>>> collapse_scan_pmd() allows them up to max_ptes_swap and record them in
>>> unmapped, but they don't get a bit in mthp_present_ptes. And then
>>> mthp_collapse() does the check above:
>>
>> Right. I assumed this is implicitly handled by the optimization in collapse_scan_pmd:
>>
>> 	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
>> 		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
>>
>> But we perform the check a second time.
> 
> Note that once lower orders are enabled, the scan *relaxes* max_ptes_none
> only so it can cover the whole PMD and build the bitmap ...
> 
>>>
>>> nr_occupied_ptes >= nr_ptes - max_ptes_none
>>>
>>> So max_ptes_none=0 + 511 present PTEs + one allowed swap PTE won't even
>>> call collapse_huge_page() for PMD order.
>>>
>>> Shouldn't we account for them in the PMD-order check? Something like:
>>>
>>> if (is_pmd_order(order))
>>> 	nr_occupied_ptes += unmapped;
>> As an alternative, we could either 1) skip the check there for
>> pmd order (as the check was already done); or 2) introduce+maintain
> 
> Yeah, skipping the check would do the trick, since isolate will check
> max_ptes_none again later :)

In addition, that later check is rather late, we may have already
allocated the folio and swapped in pages before isolate rejects
the range :)

>> a bitmap that tracks non-present PTEs.
>>
>> @@ -1475,7 +1477,9 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>>                 nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
>>                                                       offset + nr_ptes);
>>
>> -               if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {

So I'd still slightly prefer keeping this check and accounting
unmapped for PMD order.

if (is_pmd_order(order))
	nr_occupied_ptes += unmapped;


>> +               /* Check was already done in the caller. */
> 
> This check is not quite redundant for PMD order, though. It avoids
> entering collapse_huge_page() for a range that already exceeds
> max_ptes_none for that order.
> 
>> +               if (is_pmd_order(order) ||
>> +                   nr_occupied_ptes >= nr_ptes - max_ptes_none) {
>>                         enum scan_result ret;
>>
>>                         collapse_address = address + offset * PAGE_SIZE;
>>
>> 2) would probably be cleanest long-term.
> 
> Yeah, Agreed.


