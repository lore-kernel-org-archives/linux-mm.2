Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99F2606A321
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 07:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jVcRHdR6
Received: by kanga.kvack.org (Postfix)
	id 09FE66B0B0A; Fri, 23 Oct 2026 03:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0511C6B0B0C; Fri, 23 Oct 2026 03:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5CEC6B0B0D; Fri, 23 Oct 2026 03:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B76E46B0B0A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:21:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A95E4035C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:21:26 +0000 (UTC)
X-FDA: 85353045372.24.AACAD35
Received: from mta1.migadu.com (out-213.mta1.migadu.com [95.215.58.213])
	by imf27.hostedemail.com (Postfix) with ESMTP id 301AA40005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:21:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jVcRHdR6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.213 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792740084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jS7Nx9Hg72tCF5iYSwDNRegJlI9Y+Crzbgkhm2yDvjg=;
	b=7QWSWaeewppdqK8vDZVunWUeMyok0Xn/oL7lDOQAj3eoK2X6FHlUVwJiMMsT2YYtT53Vew
	0Bb5RJytQBSlLUxATtSNiGQsfA+xg10N6RRxTJS67LvMiv+vMX15FJKVQPPOKVbTqKNr9I
	OutiJpAXt4td9H7ThrRAn/1TyK6284g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jVcRHdR6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.213 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792740084;
	b=FJAM5/hETwY+3N998+oln7Xbd0+8NJghAe5kH/3WHDtoCrfBfzkq19rQ+zZu/4iI4erShD
	tPyt0o/zFYL6er1xTfLxmnyBUWrPPsb9R1PTVzueLoOz0IFpse04JvORXuZhA5uXSdn6YW
	NE9zG40LpojQlkVhU3hCfml9aZRpL2I=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TDAEQuMA1li4CsA0Bz8PTsar+qPlc8LSFD7g31MoXcw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792740082; v=1; x=1793344882;
 b=jVcRHdR67p+JaGaKQkppRS5YtYVhdsU3gan/w3yN66JLJfgSO9cD+OFY5kt0cbYRub1/dImT
 TguXFFh74TLfjfGUSoUJq/aP4CbBgCPhYmXL69hT5uoSGorqPDW9QjdY+dR7gD5rm21A63nfEUM
 9oVuBWNjP8sRH3dm7qy9QlH4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0a1a4bd446dd5578;
	Fri, 23 Oct 2026 07:21:22 +0000
X-Mizu-Trace-ID: 0a1a4bd446dd5578
X-Migadu-Flow: FLOW_OUT
Message-ID: <256915fd-d26e-4809-a126-e33140e52c39@linux.dev>
Date: Fri, 23 Oct 2026 15:21:16 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] mm: hugetlb: avoid recursive CMA allocation during
 migration
To: Muchun Song <muchun.song@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, david@kernel.org, osalvador@suse.de,
 akpm@linux-foundation.org, azpijr@gmail.com
References: <cover.1792651104.git.zhengqi.arch@bytedance.com>
 <35120f1e65b135ebc7885a85bb39baab90882820.1792651104.git.zhengqi.arch@bytedance.com>
 <6e6986a0-b5b4-4ca2-b230-63088f30704f@linux.dev>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <6e6986a0-b5b4-4ca2-b230-63088f30704f@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 301AA40005
X-Rspam-User: 
X-Stat-Signature: 3oxx9xjt3eueh3t5tupjecy1bqr95yy4
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792740083-71214
X-HE-Meta: U2FsdGVkX1/6s2+fGjkNQS4SN4AuEH9Wl+us8G9W0Fg3kk+Bs1q9uUUcI7MKpCN2pIQT3eQdEz6OGc+x5gNJ3zCppxqlK/Q5etXfLTyl2q8fHKkxIHqIwrcFImhXewUoFAFSuUxRo6lxZcq8GGByIifmaaDJykiWQvP67IE8UV0BTmx7LsEyJcqH1RTelgy5UALxnXgm0g5zGdnfrkHOXD2FdU7qD7PIHTY05t3/4BMi0SJpjZ4qpryf75A7CpaSKd60VPJVGmyN/Kru/fYFG4bQ2x+jssq3kvENTPBbk2QujlTqDHl815Qzc2Gnhe7OGbrexSEr0ESdiGIxLcvFPqHI0L20QbDIuCxpS8I3TsOmnLczl1NjLNwUURO+hofGuU8m9Koe+n4kYv7W5zmCtjMEPy74TFKTIJQPqWQipjuxJEc5bQzR58g+Jy7uUhzMS2kDmryXyV+t28dxtJKipB1KJxgsFIx+murbILQMCxqsctHpNOJ9E3eZ/m35BqY/bEiIr00mKWJGFVKhW6x6i+9kEAW1TX7pTy90pb1VgELydJQg23GKb8t8g6EzOpQ2SoqVgqrvl/YfnfqVrVPyv9fM4xwP14jeRGOL97ypmJAjqgZWvd4kYJrWwQ3229h7gzEjzjQVZako9Cp8DokcrXeK94S1LSSSRGFl3judTF/1LU8jytH6h8KREDswwK79mBCNWpV5IOcamdipDWA0bYgYT8wZhfypZP1JWCv+J8Rign57KVKDlC0MKRsjkxuDC51zvKxURT6STjTtWj5aDujnoznXy5EeB0b8kVfnTkYlCzE3H/ZxCQDjMXKbBd34+N9NFbYSLrDcKnW3JnDvKb38+PPLFZ917ScE2Vh0JokMzHtEf3Rq1IYg7b6AR+t5MNUB33/sycRs8/jhOGmwGbNfK2zVC6Plavq3V/UcTo1yszpDQlbUBe1yAr2uN8tMGQZyYmDXXZvWw1WSMe8
 XmKBeiZT
 F3zG7ZkPZ3/f+TuwC9I5xFyMS7nsWawnNf0znToNtDtMKJMp32Ohsh/Dl6dlOLXRfjbrmFdDpzkt/SUcLHp1TJyZC1RWhryu3+iBIBFmdVvQHLQ85dsPn8/hk9+kKzlwgJro9sagfuI/2zLHyYLRsCcLclsND3dwmJKr4eAaCTCKDDBmIGdTgWZuyJShIjnpjd4ZmyTJKXMX+3ntUmCuETgV52n4VLhE5AtTbCobF18byMAad94MBGemyzYm6p88iwJ5tZFKFfeC1NEglrmbnqThmpnLNpxXb3DhHrCXKIsKFPJcjXuC3hVas6up2oPxxoTuZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/23/26 3:02 PM, Muchun Song wrote:
> 
> 
> On 2026/10/22 15:31, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Contiguous allocation can migrate allocated HugeTLB folios or replace 
>> free
>> HugeTLB folios while holding a CMA allocation mutex. Allocating a
>> replacement through CMA would recurse into that allocation path once
>> non-gigantic HugeTLB pages can use CMA.
>>
>> Pass allow_cma through the migration and fresh allocation helpers, and
>> disable it for MR_CONTIG_RANGE and free folio replacement. Move the CMA
>> attempt into the common allocation path, retaining the gigantic size
>> restriction. Honor hugetlb_cma_only even when allow_cma is false.
>>
>> The existing gigantic migration restriction is unchanged.
>>
>> Assisted-by: LLM
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/linux/hugetlb.h |  4 +--
>>   mm/hugetlb.c            | 69 +++++++++++++++++++++--------------------
>>   mm/mempolicy.c          |  2 +-
>>   mm/migrate.c            |  3 +-
>>   4 files changed, 40 insertions(+), 38 deletions(-)
>>
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 5029c72418631..38612f7b3478f 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -736,7 +736,7 @@ struct folio *alloc_hugetlb_folio(struct 
>> vm_area_struct *vma,
>>                   unsigned long addr, bool cow_from_owner);
>>   struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int 
>> preferred_nid,
>>                   nodemask_t *nmask, gfp_t gfp_mask,
>> -                bool allow_alloc_fallback);
>> +                bool allow_alloc_fallback, bool allow_cma);
>>   struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int 
>> preferred_nid,
>>                         nodemask_t *nmask, gfp_t gfp_mask);
>> @@ -1172,7 +1172,7 @@ alloc_hugetlb_folio_reserve(struct hstate *h, 
>> int preferred_nid,
>>   static inline struct folio *
>>   alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
>>               nodemask_t *nmask, gfp_t gfp_mask,
>> -            bool allow_alloc_fallback)
>> +            bool allow_alloc_fallback, bool allow_cma)
>>   {
>>       return NULL;
>>   }
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 6b08074d11f52..c1a8d00be11ac 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1362,18 +1362,8 @@ static struct folio 
>> *dequeue_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
>>   static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t 
>> gfp_mask,
>>           int nid, nodemask_t *nodemask)
>>   {
>> -    struct folio *folio;
>> -
>> -    folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, 
>> nodemask);
>> -    if (folio)
>> -        return folio;
>> -
>> -    if (hugetlb_cma_exclusive_alloc(order))
>> -        return NULL;
>> -
>> -    folio = (struct folio *)alloc_contig_frozen_pages(1 << order, 
>> gfp_mask,
>> -                              nid, nodemask);
>> -    return folio;
>> +    return (struct folio *)alloc_contig_frozen_pages(1 << order, 
>> gfp_mask,
>> +                             nid, nodemask);
>>   }
>>   #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
>>   static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t 
>> gfp_mask, int nid,
>> @@ -1841,37 +1831,47 @@ static struct folio 
>> *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
>>   static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
>>           gfp_t gfp_mask, int nid, nodemask_t *nmask,
>> -        nodemask_t *node_alloc_noretry)
>> +        nodemask_t *node_alloc_noretry, bool allow_cma)
>>   {
>> -    struct folio *folio;
>> +    struct folio *folio = NULL;
>>       int order = huge_page_order(h);
>>       if (nid == NUMA_NO_NODE)
>>           nid = numa_mem_id();
>> -    if (order_is_gigantic(order))
>> -        folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, 
>> nmask);
>> -    else
>> -        folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
>> -                         node_alloc_noretry);
>> +    if (allow_cma && order_is_gigantic(order))
>> +        folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, 
>> nmask);
>> +    if (!folio) {
>> +        if (hugetlb_cma_exclusive_alloc(order))
>> +            return NULL;
>> +
>> +        if (order_is_gigantic(order))
>> +            folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, 
>> nmask);
>> +        else
>> +            folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, 
>> nmask,
>> +                             node_alloc_noretry);
>> +    }
>> +
>>       if (folio)
>>           init_new_hugetlb_folio(folio);
>> +
>>       return folio;
>>   }
>>   /*
>> - * Common helper to allocate a fresh hugetlb folio. All specific 
>> allocators
>> - * should use this function to get new hugetlb folio
>> + * Common helper to allocate a fresh hugetlb folio. All special 
>> allocators
>> + * should use this function to get new hugetlb folio.
>>    *
>>    * Note that returned folio is 'frozen':  ref count of head page and 
>> all tail
>>    * pages is zero, and the accounting must be done in the caller.
>>    */
>>   static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
>> -        gfp_t gfp_mask, int nid, nodemask_t *nmask)
>> +        gfp_t gfp_mask, int nid, nodemask_t *nmask, bool allow_cma)
>>   {
>>       struct folio *folio;
>> -    folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, 
>> NULL);
>> +    folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, 
>> NULL,
>> +                           allow_cma);
>>       if (folio)
>>           hugetlb_vmemmap_optimize_folio(h, folio);
>>       return folio;
>> @@ -1911,7 +1911,7 @@ static struct folio 
>> *alloc_pool_huge_folio(struct hstate *h,
>>           struct folio *folio;
>>           folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, node,
>> -                    nodes_allowed, node_alloc_noretry);
>> +                    nodes_allowed, node_alloc_noretry, true);
>>           if (folio)
>>               return folio;
>>       }
>> @@ -2103,7 +2103,7 @@ static struct folio 
>> *alloc_surplus_hugetlb_folio(struct hstate *h,
>>           goto out_unlock;
>>       spin_unlock_irq(&hugetlb_lock);
>> -    folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
>> +    folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, true);
>>       if (!folio)
>>           return NULL;
>> @@ -2139,14 +2139,14 @@ static struct folio 
>> *alloc_surplus_hugetlb_folio(struct hstate *h,
>>   }
>>   static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, 
>> gfp_t gfp_mask,
>> -                     int nid, nodemask_t *nmask)
>> +                     int nid, nodemask_t *nmask, bool allow_cma)
>>   {
>>       struct folio *folio;
>>       if (hstate_is_gigantic(h))
>>           return NULL;
>> -    folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
>> +    folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, 
>> allow_cma);
>>       if (!folio)
>>           return NULL;
>> @@ -2219,7 +2219,8 @@ struct folio *alloc_hugetlb_folio_reserve(struct 
>> hstate *h, int preferred_nid,
>>   /* folio migration callback function */
>>   struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int 
>> preferred_nid,
>> -        nodemask_t *nmask, gfp_t gfp_mask, bool allow_alloc_fallback)
>> +        nodemask_t *nmask, gfp_t gfp_mask, bool allow_alloc_fallback,
> 
> alloc_hugetlb_folio_nodemask() now ends with two adjacent boolean
> arguments.
> 
> Call sites such as "false, true" are difficult to understand without
> looking up the prototype.
> 
> Could you please add a comment at the caller to document this?

OK, will do.

> 
> Thanks,
> Muchun


