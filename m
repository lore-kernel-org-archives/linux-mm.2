Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA2D1C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 02:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA99F6B008A; Wed, 19 Aug 2026 22:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A820E6B0098; Wed, 19 Aug 2026 22:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998806B009B; Wed, 19 Aug 2026 22:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7BF6B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 22:13:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D78C88066C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:13:46 +0000 (UTC)
X-FDA: 85120026852.05.21CFE46
Received: from mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9D61F40003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:13:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gHsuPHM5;
	spf=pass (imf04.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.210 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787192025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v7FhN6v/cM0fbcl1AqwRFLOq32gltqBXeQ4sVd+sPkc=;
	b=HC0PJs4tT7ErTWLjNtylLmR/e4deFVBAVne8UQkAVCQzZ15dO1+ft/ZkkV/jkDA/W+Ezuy
	KhmnWSS867MJ1HFJdDgeH3MhdaYESRlmjxPmKHUbVedfPPs4Q+BpI43ZUqrBRXSk3wVkZ3
	J4Q4NK66yS90SUwtF4e4kCavIGKC/So=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gHsuPHM5;
	spf=pass (imf04.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.210 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787192025;
	b=AFpzPSJMMGYV2YDS9h3uHpPa1kvILIg12c41Jk0P1sYObGwSrSszJ+4Q3bBsfamOrKKVTZ
	8OedRvBtcsAbPUyyi7KHlN7ciq7q7gOo5eLK/ozc114m/qTSAj9wTgDq5T/TakYh6IbMS8
	g4K7MtwWln0TffEqCL+7mXpviJ54WOk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LuPpbLrg2mFJpP3Oijmcwi0b1Io6UxYacsdMENBArMg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787192023; v=1; x=1787796823;
 b=gHsuPHM5nvdrpU/vprdktAFACgo7HCZcA7Udg/MLscAwICWKd+F0SlvdkMZkIMYxNzhuIWMc
 xp6equPEWegDLJzu1vRY9RiDh1cuP/cEcI415vTQ6PopY4MWSU3CEJDW+LdavB4UNsoCasQ8Ytu
 pHC1RaVphn+YmE5NBtfNwe74=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id e44608bd8b5d53f7;
	Thu, 20 Aug 2026 02:13:42 +0000
X-Mizu-Trace-ID: e44608bd8b5d53f7
X-Migadu-Flow: FLOW_OUT
Message-ID: <e25532ec-04c8-4d88-974d-17478da87a3b@linux.dev>
Date: Thu, 20 Aug 2026 10:13:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] mm/mglru: move max_seq read into walk_update_folio
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-4-8dbbdac0d28c@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-4-8dbbdac0d28c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9D61F40003
X-Stat-Signature: i141uwaczu8iqafdrek7p7dijggjx3fm
X-Rspam-User: 
X-HE-Tag: 1787192024-276328
X-HE-Meta: U2FsdGVkX18zZXnHZKJ4ehAC7IwizmaTM5zf5BloOz+Z8ZWZM+jY3/5jm9gvsWQzo++1ViwLxN+FNtsaDIel4yiZEyCJp3XxyGtHS5WfQ0sUB3diOaEjNkAv/+hAUgD5tleezCyP3ARujT5wqAnJ/aZrOGMc2vdEAx4jyK56XZBqIFZT4LC109JugRnmIFnwtUIwVzmTSxLeAlrQl2I4LyjktIp/7DQEQASVGB/28suKmgroib1ls+YYHsDLhedQgvg27E7IrGkvCQKzLvbw4IeTzHwhIFBzSqN6Wz/R1YViI4K8xuwNTyUyBpELJ0eB2+BUps3ypHerSnQ46coSZXjMlEEmb1QdTdqD49MoW0sPNMRmzqVc5M09oU9M+0CV64aKYF+EaJD1JvvXbSXom4OIZMkzRMluothigYjtPv5wBsH7VZ38TzJN+9AkskweMCxVz+WtBV4tOIsOVyPQ0ZnoD9QBqUW6vJ4lsyA2ic0T8ZL8tbhUh1dR6EkhJXZmzIbLAd1yLicUVbE+AxLtw09ywhL79UEnh0DObes6MZe/ZwJSIZ6OAbjWMqnfl1T8I9mNUNST0t5lWW+tACIZI5l+TNq1ZE4VZ9aPvMO3t0WlT8QaTbjITS8dhLLVIEZ8umG7JJzA2SutuZKx9Gr6DYS9UFl4yOwM7wifo5Fjlhozfexc3sbGhRaBKeR+V2o/6XbT8/7IjgLptfP7m38pZGxnVrMuYAjnaVfuKEEC4IAfO9Fz93OgjS2k3c+PNIzthpb6rNTtLxowwrb2si6FMuO3EBjaLE8ga7nNbLV4am0YAWXzSeuET9hxx98o+CqYBKqF8+tP6eySKg4l7S7krlCRQC18O1/i90lWRlen+Bdt9JnnO18rK3NYwdRfhF759VCHnMk4CVXLiDmqQsBmat86PKlwQ4w5G++YvVy1fzRDDUZMdQtHsCqmJtqYzE7xQu88I/brW8LFEKdT4d+
 lM4nj+1d
 Tc+K8tIJGGH+spDIk0zDfnhqs3iQEIUSpLe4a3ZAZfrAEx9ZgJ9/8DzS6cKRIvW+YO/V0kcHfd4effDv3GCRLWd0/ZdRvmwfel3z0aX5yKdOssAtX5E/ghkzymU9WukB79wD1ZY+HhGQKoXbuklDLA4TfezTMo8aXhqL+vJKPep1/bqeZ0eJoxTjt83XQOc0GowIYtB2M4Du8Y8VX6DiKAIg8aCEFyCkwguDzkX8teFnbqxSwh69gBLw4csnbg+J/lQyeC33+tgjjkw8EgYOWqG63RiUrNnYAdWETkQT1j0pg85Z/nBBlfk2MUSi0wK8RnSmR5SWBiNh3yQLgXJ58omQFZVVyx+YowYe21s4/YQ8NYhpzixv1vXgzOwqDFZENIiyR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/18/2026 1:38 PM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> walk_pte_range(), walk_pmd_range_locked(), and lru_gen_look_around()
> each read lrugen->max_seq to compute the target generation used by
> walk_update_folio(), then pass it as a parameter. Move the read into
> walk_update_folio() itself so the callers no longer need to compute
> or pass the value.
> 
> The max_seq read now happens once per folio update rather than once
> per walk range, so folios always get promoted to the current youngest
> generation.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> ---
>   mm/vmscan.c | 29 ++++++++++++-----------------
>   1 file changed, 12 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 080132997d87..a819be6b7ae9 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3517,13 +3517,15 @@ static bool suitable_to_scan(int total, int young)
>   }
>   
>   static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
> -		struct folio *folio, int new_gen, bool dirty)
> +			      struct lruvec *lruvec, struct folio *folio, bool dirty)
>   {
> -	int old_gen;
> +	int new_gen, old_gen;
>   
>   	if (!folio)
>   		return;
>   
> +	new_gen = lru_gen_from_seq(READ_ONCE(lruvec->lrugen.max_seq));
> +
>   	if (dirty && !folio_test_dirty(folio) &&
>   	    !(folio_test_anon(folio) && folio_test_swapbacked(folio) &&
>   	      !folio_test_swapcache(folio)))
> @@ -3554,8 +3556,6 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>   	struct lru_gen_mm_walk *walk = args->private;
>   	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
>   	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
> -	DEFINE_MAX_SEQ(walk->lruvec);
> -	int gen = lru_gen_from_seq(max_seq);
>   	unsigned int nr;
>   	pmd_t pmdval;
>   
> @@ -3606,7 +3606,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>   			continue;
>   
>   		if (last != folio) {
> -			walk_update_folio(walk, args->vma, last, gen, dirty);
> +			walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
>   
>   			last = folio;
>   			dirty = false;
> @@ -3619,7 +3619,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>   		walk->mm_stats[MM_LEAF_YOUNG] += nr;
>   	}
>   
> -	walk_update_folio(walk, args->vma, last, gen, dirty);
> +	walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
>   	last = NULL;
>   
>   	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
> @@ -3642,8 +3642,6 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
>   	struct lru_gen_mm_walk *walk = args->private;
>   	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
>   	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
> -	DEFINE_MAX_SEQ(walk->lruvec);
> -	int gen = lru_gen_from_seq(max_seq);
>   
>   	VM_WARN_ON_ONCE(pud_leaf(*pud));
>   
> @@ -3697,7 +3695,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
>   			goto next;
>   
>   		if (last != folio) {
> -			walk_update_folio(walk, vma, last, gen, dirty);
> +			walk_update_folio(walk, vma, walk->lruvec, last, dirty);
>   
>   			last = folio;
>   			dirty = false;
> @@ -3711,7 +3709,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
>   		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
>   	} while (i <= MIN_LRU_BATCH);
>   
> -	walk_update_folio(walk, vma, last, gen, dirty);
> +	walk_update_folio(walk, vma, walk->lruvec, last, dirty);
>   
>   	lazy_mmu_mode_disable();
>   	spin_unlock(ptl);
> @@ -4275,8 +4273,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>   	struct pglist_data *pgdat = folio_pgdat(folio);
>   	struct lruvec *lruvec;
>   	struct lru_gen_mm_state *mm_state;
> -	unsigned long max_seq;
> -	int gen;
>   
>   	lockdep_assert_held(pvmw->ptl);
>   	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
> @@ -4313,8 +4309,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>   
>   	memcg = get_mem_cgroup_from_folio(folio);
>   	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
> -	gen = lru_gen_from_seq(max_seq);
>   	mm_state = get_mm_state(lruvec);
>   
>   	lazy_mmu_mode_enable();
> @@ -4346,7 +4340,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>   			continue;
>   
>   		if (last != folio) {
> -			walk_update_folio(walk, vma, last, gen, dirty);
> +			walk_update_folio(walk, vma, lruvec, last, dirty);
>   
>   			last = folio;
>   			dirty = false;
> @@ -4358,13 +4352,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>   		young += nr;
>   	}
>   
> -	walk_update_folio(walk, vma, last, gen, dirty);
> +	walk_update_folio(walk, vma, lruvec, last, dirty);
>   
>   	lazy_mmu_mode_disable();
>   
>   	/* feedback from rmap walkers to page table walkers */
>   	if (mm_state && suitable_to_scan(i, young))
> -		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
> +		update_bloom_filter(mm_state, READ_ONCE(lruvec->lrugen.max_seq),
> +				    pvmw->pmd);
>   
>   	mem_cgroup_put(memcg);
>   
> 

LGTM.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>

-- 
Best regards
Ridong


