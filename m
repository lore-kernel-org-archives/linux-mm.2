Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1810A606A328
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UUslPJzJ
Received: by kanga.kvack.org (Postfix)
	id 337066B05B1; Fri,  6 Nov 2026 02:43:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0786B05B2; Fri,  6 Nov 2026 02:43:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21DC26B05B3; Fri,  6 Nov 2026 02:43:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F35776B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:43:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 62C89120BC1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:43:48 +0000 (UTC)
X-FDA: 85403904936.09.964E7EC
Received: from mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0EDAB140006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:43:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UUslPJzJ;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793951026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQ493reg1DFWSPby69XzCWASVouZmLq1W+aADtj60OE=;
	b=v9fLHy/Tw1lz03px5KPlYGjOIMu3C8aJEDli0GzhXzCYWy9pg55qRuDgZJUHB9T+Rat7nr
	wj0a2qbeg/VUF+37ulyvEw/tPZ+jPxbpbgqIq9QMEl8S72qah/hSCm1zTVc1Kas9sHNvfD
	3n8D9fR2NNMO4gvzLBWU9tfJezLaBuY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793951026;
	b=3JLLJ2yCpyO7NP2vVzXJaqpTZQQHInIbNeuu2xoLkOXAckvGwiDzrUzw9qJatPOZQiiX5A
	FqIIcZOZvg5j6wT4OsQeYeqqV1mcV4UfzgxAk3kpfg1lp3eRPVAYe4Fxbz7F5FLuhTNJTT
	3smo9BIX1MQ3vaSXrhC+bstZIwZX18U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UUslPJzJ;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=o9Tmykt3lhCIaXXKkm5ZZA+SVo0MxKGt6zqyZUr8nlc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793951024; v=1; x=1794555824;
 b=UUslPJzJsosbxl4LiZgDzuNLV1FVGk2DOY0WYsTMTq36yXOBkwDrQPaDUJDvAU+iwqhKds3j
 FCFvH3005Nvt6h9U51/e+Xb7AkapHPYzZ0wWlkwJHuF11Er6SOJ/RBIztOf7P6C9TCcanA8YMrn
 jLG9y/fYc64cHri8M0MpjY8o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 047cd03742201f6e;
	Fri, 06 Nov 2026 07:43:44 +0000
X-Mizu-Trace-ID: 047cd03742201f6e
X-Migadu-Flow: FLOW_OUT
Message-ID: <3bccbb5c-bc3f-425a-b8cd-42342ca71f42@linux.dev>
Date: Fri, 6 Nov 2026 15:43:41 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: hugetlb: fix cpuset violations in gigantic
 surplus allocations
To: sashiko-reviews@lists.linux.dev, muchun.song@linux.dev,
 osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org,
 azpijr@gmail.com, lance.yang@linux.dev, Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-mm@kvack.org
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
 <046fd77e49ee8bb35e3bcc4104b9275d2e72ea5e.1793850539.git.zhengqi.arch@bytedance.com>
 <sashiko-outbox-198588@kernel.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <sashiko-outbox-198588@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0EDAB140006
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: onz7coqxcf7re99j7kn94kjkapeyx1uj
X-Rspam-User: 
X-HE-Tag: 1793951025-144505
X-HE-Meta: U2FsdGVkX1+aau/STiUfgQGteSh4GErl/5gEIgNAnbxixhjuZtGF3r7zHW4t3PiqOcL1iW1iZivk3nK9lpC9uG2SXFzSAAU2GuN2/E6c9wLjGJPxwe6vhanu2KoVA3YotDSK65ow+TePeewoVsNY+1DnscGEOStNPMJgKVKCqV2ANDPhlqR++bpZZS4JvNcCFbDkzfcvsTekNy3jxmseAJlVSWVQ0VPcv9IEI4NUpX8LaWEIQBc7WLnPz99ABYTuMmJGVvEZHkdCUdPTvbRg0px3ZG5uEehYM1E12SjhIksJiDauEdLEeV3a4E5qJ4NJOvrjY3ltbP3ropc+5JLmvQvovpezVxUupRY8X0pI6eu8KlQirDvWzeT/7nQXbguGNB7akp9vhqHyr6buUKdrz4o8zOzB3gwG7g8omWqAh3+w2RUhfSDqU464qt7Tqec8tN+xm7W+pgggApWTGO5mAtlw9uDOSI+L7EMNKsNhDFLfQss1IGFqrrYLc/UYqVu3Gl/pnjfOR//ZvXzMlink3wdwyAdSCEWDjpSzHpuKRy7SmZ8VGsDAix6VSx6oSTA96NjAMfgVdP7eEZXdnO6lOu1KRQ9Og8CXIjwqPJJw3JMtEkkQREnhlG8hzCXdaIjW+LJBM6duPORzDzomY/V5S4O4WDoMwxtncL7dp2nx+nFyHcHzoumpQ4s+vE+MwCQ6ycxpOxz02W5gzNzUqsO4dvjJsduU6Kh81VhhTbEluDaOst2LhLOf0m7s/jYiuNcaNe1szOrPnJkXyLGHv7T5h8e+wP+eDq7Bjyd6wMvXxKUAsWD9/rfEyHJk29x0ZpOu4OdfGVETVEfrI+mlC2uuQFPGEDduNTNnOmOyEuNVUkRjS46FhvQsJmP9rQCeK+S6iwFVxG6m9CPy81i0cxoU6nFrkZMnyJtTfXe7+RfRgGweQJlt1zzG0IjxmuyHELd17qTnb/pxRzVNmUwBIwe
 f7lpW9gi
 wJ/xbJvgBDm8uA+YuMrgSlvCOuZhPLrNrzLuf2zONx5i5Ee3MfufCOeGrHVcvO6g1sOJOeQ3sn2Ix5sC4BhYf3Sh2My5b4nGXJpRyrjSbMQGCpO8GUxJa5vD3s7thtT4A6OwzI2Az3/rys4mS5btbLdJVRYqkm4igjD8ZcNNpB9f1U96oSMiihw6SJiFOfXh1tfZPxoglN/jLMJ2aWQ7SngOs+PTj9sEcNqyFcINOJCkmVLceHv0gvmthxhKMVF//llS5cHm3MPymdeKo5VjKWP2KcyGd2/heBHQ8v4xXf5yi9qk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/5/26 1:15 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] mm: hugetlb: empty nodemask passed in alloc_buddy_hugetlb_folio()
> - [Medium] mm: hugetlb: MPOL_BIND violation in alloc_buddy_hugetlb_folio() on cpuset race
> --
> 
> commit 6e27dfcfc4f6238bea6b6e8639c15188d8d94295
> Author: Qi Zheng <qi.zheng@linux.dev>
> 
> mm: hugetlb: fix cpuset violations in gigantic surplus allocations
> 
> This commit intersects the allocation nodemask in alloc_buddy_hugetlb_folio()
> with cpuset_current_mems_allowed so gigantic surplus hugepage allocations do
> not allocate from nodes outside the current task's cpuset. It also retries
> failed allocations if cpuset_current_mems_allowed changes during the attempt.
> 
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 6fba92b0f6749..09b64f7c11dd2 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -2181,22 +2181,33 @@ struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
>>   		gfp_t gfp_mask, struct mempolicy_interpreted *mpoli)
>>   {
>>   	struct folio *folio = NULL;
>> -	nodemask_t *nodemask = mpoli->nodemask;
>> +	nodemask_t alloc_nodemask;
>> +	unsigned int cpuset_mems_cookie;
>> +
>> +retry:
>> +	cpuset_mems_cookie = read_mems_allowed_begin();
>> +	alloc_nodemask = cpuset_current_mems_allowed;
>> +	if (mpoli->mode == MPOL_BIND && mpoli->nodemask &&
>> +	    nodes_intersects(*mpoli->nodemask, alloc_nodemask))
>> +		nodes_and(alloc_nodemask, alloc_nodemask, *mpoli->nodemask);
>>   
>>   	if (mpoli->mode == MPOL_PREFERRED_MANY) {
>>   		gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
>>   
>> +		nodes_and(alloc_nodemask, alloc_nodemask, *mpoli->nodemask);
>>   		folio = alloc_surplus_hugetlb_folio(h, gfp, mpoli->nid,
>> -						    nodemask);
>> +						    &alloc_nodemask);
> 
> [Severity: Medium]
> What happens here when an MPOL_PREFERRED_MANY policy's nodemask is disjoint
> from cpuset_current_mems_allowed (for example, after moving a task or
> non-leader thread to a cpuset on different NUMA nodes, since
> mpol_rebind_preferred() does not remap pol->nodes)?
> 
> Unlike the MPOL_BIND branch above, this path does not check whether the
> intersection is non-empty before calling alloc_surplus_hugetlb_folio() with
> &alloc_nodemask. When alloc_nodemask is empty:
> 
> 1. For gigantic hugepages, alloc_surplus_hugetlb_folio() performs a wasted
>     pass through CMA and alloc_contig_frozen_pages() with an empty nodemask.
> 
> 2. For non-gigantic hugepages, alloc_surplus_hugetlb_folio() ->
>     alloc_fresh_hugetlb_folio() -> only_alloc_fresh_hugetlb_folio() ->
>     alloc_buddy_frozen_folio() -> __alloc_frozen_pages_noprof() fails the fast
>     path and enters __alloc_pages_slowpath(). In check_retry_cpuset():
> 
>     mm/page_alloc.c:check_retry_cpuset() {
>     	if (cpusets_enabled() && ac->nodemask &&
>     			!cpuset_nodemask_valid_mems_allowed(ac->nodemask)) {
>     		ac->nodemask = NULL;
>     		return true;
>     	}
>     }
> 
>     Because cpuset_nodemask_valid_mems_allowed() returns false for an empty
>     nodemask, check_retry_cpuset() treats it as a raced MPOL_BIND nodemask,
>     resets ac->nodemask to NULL, and restarts __alloc_pages_slowpath() with
>     __GFP_DIRECT_RECLAIM masked off. That wakes kswapd across all nodes via
>     wake_all_kswapds() with ac->nodemask == NULL, attempts an allocation on
>     non-preferred fallback cpuset nodes at ALLOC_WMARK_MIN before the normal
>     fallback pass at ALLOC_WMARK_LOW with reclaim/compaction runs, and
>     increments HTLB_BUDDY_PGALLOC_FAIL in alloc_buddy_frozen_folio() if that
>     first pass fails.
> 
> Should the first-pass alloc_surplus_hugetlb_folio() call be guarded by
> if (nodes_and(alloc_nodemask, alloc_nodemask, *mpoli->nodemask)) so that an
> empty intersection skips straight to the cpuset fallback pass?

Right. We should skip the preferred-node attempt when no preferred nodes
are allowed by the current cpuset.

> 
>>   
>> -		/* Fallback to all nodes if page==NULL */
>> -		nodemask = NULL;
>> +		/* Fallback to all nodes allowed by the current cpuset */
>> +		alloc_nodemask = cpuset_current_mems_allowed;
>>   	}
>>   
>> -	if (!folio) {
>> +	if (!folio)
>>   		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, mpoli->nid,
>> -						    nodemask);
>> -	}
>> +						    &alloc_nodemask);
>> +
>> +	if (!folio && unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
>> +		goto retry;
> 
> [Severity: Medium]
> Can pre-intersecting alloc_nodemask with cpuset_current_mems_allowed cause
> non-gigantic surplus allocations to violate MPOL_BIND or use a stale nodemask
> when cpuset_current_mems_allowed changes concurrently?

Yes. We should preserve the original policy nodemask and check cpuset
constraints separately in the hugeTLB CMA and contiguous allocators.
This avoids losing policy information or restricting retries to a stale
cpuset snapshot.

The plan is to:

1. Add optional cpuset checks to the contiguous allocator.
2. Add node-selection checks to the HugeTLB CMA allocator and enable
    cpuset enforcement in both paths for HugeTLB surplus allocations.
3. Keep policy fallback at the policy-aware callers and retry failed
    allocations when cpuset changes.

I'd like to address cpuset handling more comprehensively across the
HugeTLB allocation paths, so I'll drop patch 4 from this series and
follow up with a separate patchset.

Thanks,
Qi

> 


