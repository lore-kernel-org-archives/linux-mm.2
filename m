Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00360606A32D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 03:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MyX5D/kW
Received: by kanga.kvack.org (Postfix)
	id A34B66B05B1; Tue,  3 Nov 2026 22:39:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0D756B05B2; Tue,  3 Nov 2026 22:39:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94C6A6B05B3; Tue,  3 Nov 2026 22:39:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6530F6B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:39:26 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49293140350
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:39:25 +0000 (UTC)
X-FDA: 85396031490.25.3A19DBB
Received: from mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
	by imf09.hostedemail.com (Postfix) with ESMTP id 987EB140005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:39:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="MyX5D/kW";
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.197 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793763563;
	b=iIZzzU7EtUCIqYlMjT6Zlvng1Cg2sxG3uWFk4zCUUJ1O/tJpi239F54T8TenUDxUUeHL/V
	mku4Jz3/qK+0Gc6/qclfY68q5ERidb7sdtHg8yLz3px3KF0L+aG+KzTWJrJluOWmSiLi3T
	BWQtQZ35qd2xA16YprySk2p4rvqgpWE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="MyX5D/kW";
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.197 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793763563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01Aq7gKPieZxE3SBl3+t+xrp06XwQVnR3Mk/k1CLSlA=;
	b=bKKuskNO4wEyjVDo12ZdGYWgRfLGIyyYqPj1oITnwBi1i6PADu/O18ZZvqBlN1dFJk+OVa
	gUtAv+LfcJGambs0xXW/XYHzu81B1OKvQh3zHVeOy6mXSwFDXWpBcgn9bEgiFufqrkNlaF
	eDVFcIC+qfwFMkrcy+IzT0fryLDy0eI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jqUVmAlPtX6mbUXql1pA60JQ91sSKa7gr/G4bWwt47g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793763560; v=1; x=1794368360;
 b=MyX5D/kW0AqUhD0Q/cHG9pm+8XXS6sMt8TkP9NdXO+CvGqNUlgJ5vZG+HoJjJ2wWjwDffLr7
 DxgIUfSAce18eh/8+TmNdFDLxQiXaezPFaxWuGFeKYQdwfT6OVarApE/YPz4hY+7pSjYE3HWoVt
 4GdOeOTHtiXRWfj219rxGcEI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5171a04d1f5983c4;
	Wed, 04 Nov 2026 03:39:20 +0000
X-Mizu-Trace-ID: 5171a04d1f5983c4
X-Migadu-Flow: FLOW_OUT
Message-ID: <c8e43f76-3f99-44e5-9c33-d45660d9b5f7@linux.dev>
Date: Wed, 4 Nov 2026 11:39:15 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm: hugetlb: respect cpuset restrictions for surplus
 allocations
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, muchun.song@linux.dev,
 osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
 Lance Yang <lance.yang@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
 <d1e41a65970ced879715a73ce2607de7ad102fb2.1793692578.git.zhengqi.arch@bytedance.com>
 <b1c86bc9-24e8-4c87-b2a7-2eefbdd96c12@gmail.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <b1c86bc9-24e8-4c87-b2a7-2eefbdd96c12@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gfttx36w14o54co8mozd4qi1snuaxd1m
X-Rspamd-Queue-Id: 987EB140005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793763561-139581
X-HE-Meta: U2FsdGVkX18Kd8zuyN2sjRcQkDpBUIHkrbMvymBvmqFO0S4LLB5z8aLeqcqNywX+g/svD3Lu9lL+ItX4JvljwWftzR5UExjUUPW/VvraGiW6rU7SJ/Ixl6F/oimfpqN1Q3lElE6IHVFBAw4Te0Mg46wQ2LX2sDln43ZqJ9haIxnobXvxVW0ooZtNRrkfUSh5eHrM/TIK3syAK39gUYKTDDCQ8Hh6LIfpQoUX4sMiVVy+Zm//eRFnJ5mLVZnVJf9KNeJeHWLRHxv2L3GXl7qCsubQ0kEKINShNeofqgcCuYjYvDPeDbZHSaLSOSYufn7DYpnlJAAJlmNjWdqLwYsc4AFVYzH9lmBbgFH7vac9LH76WVDAG7OxUKw0JvOA6+yNDRAx5QGz14/kHQT31K5NVILYyRQ47J8yH4uD37jFy2xLSuxtCscknmCI2cY0oZDxYW8J7+KpLJi/1bG7+P/mPWBwXFNPKH4/nDGMhS05ueieGmBjq0yo6Fw7q0lWp8B/DEU/y1DgRi2VppN07eDlKLkVTkCPo66cfvjdumZG1I2AJetvqg6WgMAHDiskElvc/Z8DMxRhs907IJ6HqXH0xGyWBHQjaqGlnJvho3vcgdV5T8ycFXWE5HAYC55a4PVfb0NQlmCI5UENqW1iTlJFIyFKcTDC9mIq5+Zcu05jK0/jKIkGdPzluPb5aWV/dy7LOugMLCFT0OaB4bKxFV+ndbKvjX/KvZ7EM29/XpHql7VkxMYmMJI7Ge7sCIyHHXnoM94L3YyjxuJRRRljDKzpj7Jc69WkpS2U7/2EVhOj7x76QFXpex88HV4UwKZBmQhGuSAqNVMZ7NWBFnaFYOCpPxgo5Jsf5MPJDZmSAL4zNr5r79E68OeLgpbPYBBmPkH6PIeZGClCWPBcfpbcCJ6O9GweA2Z3q7+CNm/NLQrQcij/Qpl+0Xbn8dPkEgjByu9HvS5FWLwImjE9QivyUEq
 9jQu0Ill
 MV1oBzAfJl8NSNc9VqtJb59sz4cpdHHkVETw6iR3KlMhEYHbqzHYCXxPFhB2aBsx9M8sCBw4CTpbStMCKA2JzxoYWRz7Fn93wlCLltiOEeEThTraanNfm+hT278FEVyV5428A2E7tzl6sLWAmS7Oh3pfjObKY1ydc/ti7BL0mEvdphKCsrYT738HWMucN2tVNVSZR9JM2jgrJLW29+rTJjFYkZNCB6sT9CrwwQxKfqA+MLKBqS1lcjNGOBcfQh37ceJeQWtAtYMT3Ixw/yTnDRGlQ2ctm7NpTpJHl3XRr6ZfZIKOmoke66Qn0jWNxmL5673+5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/3/26 8:21 PM, Jose A. Perez de Azpillaga wrote:
> On 11/3/26 9:01 AM, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Gigantic surplus allocations can escape the faulting task's cpuset.
>> CMA and the contiguous allocator trust the supplied nodemask without
>> checking the current cpuset.
>>
>> For example, a shared HugeTLB VMA has MPOL_BIND={0,1}, and T is a
>> non-leader thread. With surplus allocation enabled and no eligible free
>> HugeTLB folio, the following sequence can occur:
>>
>>    CPU0 (cgroup v1 migration)       CPU1 (thread T)
>>    -------------------------       ---------------
>>    cpuset_attach_task(..., T)
>>      T->mems_allowed = {0}
>>      /* Non-leader: skip
>>         mpol_rebind_mm(). */
>>                                    /* Fault; VMA policy is still {0,1}. */
>>                                    policy_nodemask()
>>                                      /* {0,1} intersects {0}. */
>>                                      nodemask = {0,1}
>>                                    hugetlb_cma_alloc_frozen_folio()
>>                                      /* node0 fails; node1 succeeds. */
>>
>> The 1 GiB folio is allocated on node1 despite T being restricted to node0.
>>
>> Intersect the interpreted policy with the current cpuset before surplus
>> allocation, preserving MPOL_BIND and MPOL_PREFERRED_MANY fallback rules.
>> Apply the restriction at the policy-aware entry point to preserve
>> per-node pool management semantics.
>>
>> If the cpuset changes during allocation, rebuild the mask and revalidate
>> any allocated folio against the current constraints. Keep it if it is
>> still eligible: freeing an HVO-optimized folio can defer returning its
>> range to CMA, so discarding a usable folio can cause a needless allocation
>> failure. Only release the folio and allocate again if it is no longer
>> eligible.
>>
>> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
>> Cc: stable@vger.kernel.org
>> Reported-by: Lance Yang <lance.yang@linux.dev>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   mm/hugetlb.c | 38 +++++++++++++++++++++++++++++++-------
>>   1 file changed, 31 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index ce9c8e57b8e5c..6fd6e58ace869 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -2181,22 +2181,46 @@ struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
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
>> +
>> +	if (folio) {
>> +		if (unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
>> +			goto retry;
>> +
>> +		if (node_isset(folio_nid(folio), alloc_nodemask))
>> +			return folio;
>> +
>> +		/* Balance free_huge_folio()'s decrement before caller accounting */
>> +		lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
>> +		free_huge_folio(folio);
>> +		folio = NULL;
>> +	}
> 
> the page allocator only retries when the allocation fails, why does this
> need to drop a folio that raced with a cpuset change? retrying only on
> !folio would make this whole block go away, with the check at the end as:

You're right. I overthought the cpuset race and added unnecessary
revalidation of successful allocations.

> 
>          if (!folio &&
>              unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
>                  goto retry;

I'll follow your suggestion and retry only failed allocations, and
update the commit message accordingly.

Thanks,
Qi

> 
>>   
>>   	if (mpoli->mode == MPOL_PREFERRED_MANY) {
>>   		gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
>>   
>> +		nodes_and(alloc_nodemask, alloc_nodemask, *mpoli->nodemask);
>>   		folio = alloc_surplus_hugetlb_folio(h, gfp, mpoli->nid,
>> -						    nodemask);
>> +						    &alloc_nodemask);
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
>> +	if (unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
>> +		goto retry;
>>   
>>   	return folio;
>>   }
> 
> 


