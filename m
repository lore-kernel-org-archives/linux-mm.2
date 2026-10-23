Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD58C606A326
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 07:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ar2xEn3l
Received: by kanga.kvack.org (Postfix)
	id C8A1F6B0B02; Fri, 23 Oct 2026 03:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3B5E6B0B04; Fri, 23 Oct 2026 03:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B518B6B0B05; Fri, 23 Oct 2026 03:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CCF76B0B02
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:02:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC538A033B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:02:43 +0000 (UTC)
X-FDA: 85352998206.10.6778EA7
Received: from mta1.migadu.com (out-104.mta1.migadu.com [95.215.58.104])
	by imf24.hostedemail.com (Postfix) with ESMTP id A72EC180006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:02:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ar2xEn3l;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.104 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792738962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gz199l+B7NQiah1DuE0LCgGXB76bPZwiz6wv18yDHZI=;
	b=3t7YJVbJ4pv/Jo0a9pfQMAmdeQnDUmOLdHHTsTX5WOB6/JKc5KDNNq0CnT4fAJz0mBPHEB
	OGLN7aRVQFClA/eVMjPuseaBN1BMHGO7TtVf/jaJ5/972dyPrmiQe4912mI7a/d3yFIkjh
	lc6ChJFFq4qCwiNnIIWjMtuArNftzio=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ar2xEn3l;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.104 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792738962;
	b=XS1Qh393AKZI04mzcfKOJTNybtlXfyYGen7arVAz1pOlvZEAnxkHpyiXCwRJe6Mte2lS6o
	HZ9gkGdpiwD47dndLstIKQr5rYzT0ZyAjYStXpaAm3zAGHrGrFgXfWbRxQ2ItyAWLgmF/U
	XbutL1twykHxPCPPT7+Z2EmWI/V0lMY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=M25OzSHfR3m6+z30EB2GMimOpioSAFbUCrk7t17JYJM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792738960; v=1; x=1793343760;
 b=Ar2xEn3lv5QonRbbAFuS9nptAsz7ZupxzCBdmisigV0RK7y3goBbPt/QW8uUfjekjKcKCKtC
 qSrsh6HBrpQwmUPEUloCVxULMT3Ab21DTadYjI6ipIdBTn/b0Osu7wvM4nDPRuu6DK54v8M+N9V
 bXmzpn1M9g1klDH1Nc8aXB30=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 602095b45816c23c;
	Fri, 23 Oct 2026 07:02:40 +0000
X-Mizu-Trace-ID: 602095b45816c23c
X-Migadu-Flow: FLOW_OUT
Message-ID: <6e6986a0-b5b4-4ca2-b230-63088f30704f@linux.dev>
Date: Fri, 23 Oct 2026 15:02:35 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] mm: hugetlb: avoid recursive CMA allocation during
 migration
To: Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, david@kernel.org, osalvador@suse.de,
 akpm@linux-foundation.org, azpijr@gmail.com
References: <cover.1792651104.git.zhengqi.arch@bytedance.com>
 <35120f1e65b135ebc7885a85bb39baab90882820.1792651104.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <35120f1e65b135ebc7885a85bb39baab90882820.1792651104.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A72EC180006
X-Stat-Signature: t1798o5fq5ixo8e76orzrzrfz4t8ipyg
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792738961-53321
X-HE-Meta: U2FsdGVkX1+/OYkuwovCLfbI00pnTa3vdNdl7G/+n6m0mCi55+uAtodkZYbc4Xzw3XTdrImobtlP31CoDu27OT/8PODsjWLqYL+X3H78cEr5ZpFf3ea9DLWR1y5ubH9zQF5ge8D8NPzyuCgRh5+AnNzXJ/5MHxSikRXAG67vId/jc742JTqTfvh+M/+hAJDMcF3YoRpy0oMJQPT06RvO5OwhliLWGaGW7KzND5VLHv52v7Hii17t2WpvlN7tyc/4HFG41hONnA0DVyijlPrrgzQg9ax8UQpc3kqtLLxgygkxsFW8o1GTDNK02uDwjzN065b7mGcTDX+w5/0N23ujlBZMtNC/FkzI+0a6xF28ef6uZY5hgFiWG96DD3afyAK+O/0TYgh6fI2hcQ5+HxKXb45y5CKbs4zO2b3lbyh+Mp7Q9U48jE4KgiIl7SEq6VM8eYGZjmJu9AmboXbyef+GeIBFgwgufiA3gfC+xnp3/qW019CVWTZQIIykAXH4srmZff14wt2Yr+H+xxuJX/1NrqwDn2kQWvzYzalityNQQ5Qso0G/Wsa1c3/G7Ebuiuu1x1qDv6rLCs9H19xCjBWQBqp2ChMALSIzCOfhZ0x6mwUrJAH25oxn7l+ErhzbxvkW7JLJMgZsEuSwpqi4LYnllnRm/H61ruQUWMO6cIJYMWF8Rbh9VtRqCBeivIUOM9hHp5ujr2JSmDEsGGSCmtisU8ZxcEYu7nt89+e++nVeCLC4py8OwJqlij4HrNnDmfdS65NefC5VNBc3QbOkRdqjnljp+k5p0fOX+4TJ/aph1sAlmPTclVORATlvavfSrDKeKnUTXTQAcmvmfk/h/fYcaNnSLeV0FWzJGhwjm0bY5WGqnWOXiAg9zmJ3t4rf6qpmP3WazghswhzBeBYD9MQSgv/d1E3sakCs/Vx/NZHL89Rs8AqwqrnfXkdXF0Q81sHCQbkJOYTRi/Mbpjc7ZD4
 x37XrOVn
 rYFiasC/v6QjNu37EjDPNRm1xDpp7QmGkMG8NLVEF8OhTX7e0vC80B2SqUWbRYVXrsRJnfAcLsd8RUJ2ktd2oTl9R58Q7b0eFbVNFlkJ0nPOAW7dIofGqVAo43hIfoDKG9C/Hy1ysRQ7L3tyQ0KOiOJQpDRAxVJ+9BTg/sqBt5tltZe5BLubdb+aZHjEnh9ej8lOqQ/emDT6ozKziw5UYCwQJ6d+DkjlOF8b1QVvtNfHNOsLQubsMzO+0xDxIAKvCKDxbq4uJJKh3Rxo991+cxbzBupLpNJmkk5dMVEnVWiOWnms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/10/22 15:31, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> Contiguous allocation can migrate allocated HugeTLB folios or replace free
> HugeTLB folios while holding a CMA allocation mutex. Allocating a
> replacement through CMA would recurse into that allocation path once
> non-gigantic HugeTLB pages can use CMA.
>
> Pass allow_cma through the migration and fresh allocation helpers, and
> disable it for MR_CONTIG_RANGE and free folio replacement. Move the CMA
> attempt into the common allocation path, retaining the gigantic size
> restriction. Honor hugetlb_cma_only even when allow_cma is false.
>
> The existing gigantic migration restriction is unchanged.
>
> Assisted-by: LLM
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>   include/linux/hugetlb.h |  4 +--
>   mm/hugetlb.c            | 69 +++++++++++++++++++++--------------------
>   mm/mempolicy.c          |  2 +-
>   mm/migrate.c            |  3 +-
>   4 files changed, 40 insertions(+), 38 deletions(-)
>
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 5029c72418631..38612f7b3478f 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -736,7 +736,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>   				unsigned long addr, bool cow_from_owner);
>   struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
>   				nodemask_t *nmask, gfp_t gfp_mask,
> -				bool allow_alloc_fallback);
> +				bool allow_alloc_fallback, bool allow_cma);
>   struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
>   					  nodemask_t *nmask, gfp_t gfp_mask);
>   
> @@ -1172,7 +1172,7 @@ alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
>   static inline struct folio *
>   alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
>   			nodemask_t *nmask, gfp_t gfp_mask,
> -			bool allow_alloc_fallback)
> +			bool allow_alloc_fallback, bool allow_cma)
>   {
>   	return NULL;
>   }
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6b08074d11f52..c1a8d00be11ac 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1362,18 +1362,8 @@ static struct folio *dequeue_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
>   static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
>   		int nid, nodemask_t *nodemask)
>   {
> -	struct folio *folio;
> -
> -	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nodemask);
> -	if (folio)
> -		return folio;
> -
> -	if (hugetlb_cma_exclusive_alloc(order))
> -		return NULL;
> -
> -	folio = (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
> -							  nid, nodemask);
> -	return folio;
> +	return (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
> +							 nid, nodemask);
>   }
>   #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
>   static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask, int nid,
> @@ -1841,37 +1831,47 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
>   
>   static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
>   		gfp_t gfp_mask, int nid, nodemask_t *nmask,
> -		nodemask_t *node_alloc_noretry)
> +		nodemask_t *node_alloc_noretry, bool allow_cma)
>   {
> -	struct folio *folio;
> +	struct folio *folio = NULL;
>   	int order = huge_page_order(h);
>   
>   	if (nid == NUMA_NO_NODE)
>   		nid = numa_mem_id();
>   
> -	if (order_is_gigantic(order))
> -		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
> -	else
> -		folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
> -						 node_alloc_noretry);
> +	if (allow_cma && order_is_gigantic(order))
> +		folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nmask);
> +	if (!folio) {
> +		if (hugetlb_cma_exclusive_alloc(order))
> +			return NULL;
> +
> +		if (order_is_gigantic(order))
> +			folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
> +		else
> +			folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
> +							 node_alloc_noretry);
> +	}
> +
>   	if (folio)
>   		init_new_hugetlb_folio(folio);
> +
>   	return folio;
>   }
>   
>   /*
> - * Common helper to allocate a fresh hugetlb folio. All specific allocators
> - * should use this function to get new hugetlb folio
> + * Common helper to allocate a fresh hugetlb folio. All special allocators
> + * should use this function to get new hugetlb folio.
>    *
>    * Note that returned folio is 'frozen':  ref count of head page and all tail
>    * pages is zero, and the accounting must be done in the caller.
>    */
>   static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
> -		gfp_t gfp_mask, int nid, nodemask_t *nmask)
> +		gfp_t gfp_mask, int nid, nodemask_t *nmask, bool allow_cma)
>   {
>   	struct folio *folio;
>   
> -	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
> +	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL,
> +					       allow_cma);
>   	if (folio)
>   		hugetlb_vmemmap_optimize_folio(h, folio);
>   	return folio;
> @@ -1911,7 +1911,7 @@ static struct folio *alloc_pool_huge_folio(struct hstate *h,
>   		struct folio *folio;
>   
>   		folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, node,
> -					nodes_allowed, node_alloc_noretry);
> +					nodes_allowed, node_alloc_noretry, true);
>   		if (folio)
>   			return folio;
>   	}
> @@ -2103,7 +2103,7 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
>   		goto out_unlock;
>   	spin_unlock_irq(&hugetlb_lock);
>   
> -	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
> +	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, true);
>   	if (!folio)
>   		return NULL;
>   
> @@ -2139,14 +2139,14 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
>   }
>   
>   static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
> -				     int nid, nodemask_t *nmask)
> +				     int nid, nodemask_t *nmask, bool allow_cma)
>   {
>   	struct folio *folio;
>   
>   	if (hstate_is_gigantic(h))
>   		return NULL;
>   
> -	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
> +	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, allow_cma);
>   	if (!folio)
>   		return NULL;
>   
> @@ -2219,7 +2219,8 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
>   
>   /* folio migration callback function */
>   struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
> -		nodemask_t *nmask, gfp_t gfp_mask, bool allow_alloc_fallback)
> +		nodemask_t *nmask, gfp_t gfp_mask, bool allow_alloc_fallback,

alloc_hugetlb_folio_nodemask() now ends with two adjacent boolean
arguments.

Call sites such as "false, true" are difficult to understand without
looking up the prototype.

Could you please add a comment at the caller to document this?

Thanks,
Muchun

