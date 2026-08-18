Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED5C0C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 02:24:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB55F6B0192; Mon, 17 Aug 2026 22:24:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C659D6B04F4; Mon, 17 Aug 2026 22:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54916B0884; Mon, 17 Aug 2026 22:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 814226B0192
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:24:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F51EA0A3B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:24:13 +0000 (UTC)
X-FDA: 85112795586.30.A24225E
Received: from mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
	by imf17.hostedemail.com (Postfix) with ESMTP id DEDCC40002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:24:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z9fbAdyG;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.197 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787019851;
	b=WeMGE9ncm3MENpaLp22fTdtqTxcbKskTvHKg/Ig+i3idxjYjutnd7LCitBn08kSPhtlxCj
	m3awhxLiehQ2dzGHMDJYZe5M2UAqTI8reZHI6+RIm+XOiycM7QLQAc/NNiOoIXi0jccoXc
	7WXMzYGEQdVZDk45QKfRx+ZwWVQ/PeU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z9fbAdyG;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.197 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787019851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ewiDZhCjydHAZsdyEVhHh+6erZ0a2pG9r7TmjbO6ys=;
	b=I1Es7cSNiXHD0quq4orzTSRZ/+iSvZKKz9rRma2TyfcTrLYS35t1BGiJCNeagaOjHy5rq2
	wvC6xlWfJrJckS+BWp8PJADtojnH0llm0tuqxmk4CI0Jwhhzv7WTWZRVXD48KXdJDd00dh
	lYnshh7lm95InWtAge7j6dYbQR8Jz6A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Kj2l2s2b8Q7rDIIPhTRWO4Dg9LJTGn1lCoLDlO7EmgE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787019849; v=1; x=1787624649;
 b=Z9fbAdyGWgXQT1KsRtu4yTyXeIgjWcfGxTCYxdbNl46jSVJgN3JtXrnMLwfeT5qLM/36/NMv
 i1GseHdEcQT4XizWiVtDxJ/30MXPaJkyIQeGiVTTmCrLRC9APZlByWY1LpJlIyP3eWNveerFDhU
 eIjfthqN2IE1Mq4jeA3bSex4=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id d2aa8026bf3fbfef;
	Tue, 18 Aug 2026 02:23:59 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 10:23:51 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>, Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 05/15] mm/mglru: move max_seq read into
 walk_update_folio
Message-ID: <aoPCNxyRVpQFulwS@MiWiFi-R3L-srv>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-5-4d8dad39dad6@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804-mglru-fg-v1-5-4d8dad39dad6@tencent.com>
X-Rspamd-Queue-Id: DEDCC40002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: h4dx97y5qhrtp1mmewtm7douigfs77oc
X-HE-Tag: 1787019850-391985
X-HE-Meta: U2FsdGVkX18lAM2CSDQQ2CbswfuqkJdjvarTQYmyagj/B7a2Vn+gbDRalb3SfMx3yOMlUGWlIm+jKLTYfaYjopJ5ABG4KgO9dR+dekVynSlf6WrIjv6dVkCNjidKo7KgYx7/VASlOUHgLPVl6mxvTes5eG+gUa9HSQIGT2+i6r8D21hVnxu3K5BSecI+AFHV7oDfCfrnER60alSM9N6NQ94hvdC2BY3gcw3sch+0DDYwurBeZi5N2I2lPv8z0+K5lfYYAIJFwJS7Rv/zQOHvrnhlpKpxhRGJG2Nf1kk3gpByXsBFghzTbPn+rEqKmqjz2GrL3XLGAGdQDsF6C5sXv4vd1lpz229x6E37zwEbJ0XSovMB8lOA7vuZx14W5i0l5A6AtV5pfxV1urXnoG1obPYVVNrOrKoYkv+XEpcBr3zoRndHqqx6ojdPFNsq0ErqvSmPasEU5XmaJSNZrtt2pxgRe/9u/jG3MEsYSqoYl7lURc+RTbLXNm2B/UmB+Z4vt7nCsfat8RG8RZ9wSAzcDYUEsapE1snuNvwUkFru3bwselmP+P2Hr82RvjIdjM6+b+cu0L3SscdjIRu46Za/qdefReObnwl9C5Yt4AH+j/IhXXEm3HXwu3aMvlkYampC0gb+1/xKR7boJkQbTDxlxbRphSWHilcoeUhdms/AyvZzd1pGqzn9qWZh4Edxpfh+UCATH1CscS0zrFecGDG5JB9NmGm93m9hfTgnz1lcbKlJyOqw3+2wU+fbSySNHaZxahHR75STKYUQfMRy+Dn3h9JvwVKBQ+c5KhchKzN8+6wZ7q+WlU4Y4bsiopg6ePVVJo9GULMt3hH0Et/gLFkh9wB52XGDbztAeDY3xsfneXv/T1cTFDPkD3ufVb+x0RDSY8xQeWKtnj6YQCZDJi81y1p0TFRbB2ArnTzE58NMr7TnEywhXLcJI/+1rtjg2o5T9d0g4nah4tjkicCnXUm
 c3IOgok0
 Db29JOIa+rGmvxrWC0qCjrstRkQZeY8uSYi/6Ff8FMYp0vGY8jhFc5NBAP+jk0aoiBCnuM449rqX1TsaCgHCEoHcaRGBGFY/hTUvj++YeoRH5GkemEGv0ULWowynvUKc0RcfN8f6/3FLuaTrhV8mCKUjLV7mUQlmY4UymluUqKUzuoents1rPNGrT/kfPcwMF1LXjAFJapphQcyq3hhzlmVzL6Kba+Bihan+9MoTVV43sb8z/bpQQTmUcov/5VtG7WbZHxLJiBZ391brY8+oq7IPGFoMTC5hh3nGGSVMO3cPKLB+MnEAQGGSbgDWiSm83N3wxtHEq3mT4La3hw/YMvOOg28HrsgA10G/TgJyXrOGR61aLxqmxd9CoZ7+bfo6jI/8tzeqyLYlwjjtaObzB7PkFildlb9rCFGhbTzmaAiQRdbpmi4yPFAE17KzfvLFnBN0VOXx6/GjDlAd+XWCWPGvfgSEZPbs6TwIJuaap2s6JBEJTpxST9mSEyiXAVFfBvvbCksBuSfHmh4kSvRQ7p+8uUYSwCYSy9BgfBEYDL4qAElGflyR2Dh6sHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/04/26 at 03:47am, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> walk_pte_range(), walk_pmd_range_locked(), and lru_gen_look_around()
> each read lrugen->max_seq to compute the target generation for
> folio_update_gen(), then pass it as a parameter to
> walk_update_folio().  Move the read into walk_update_folio() itself
> so the callers no longer need to compute or pass the value.
> 
> This is a pure refactoring: no functional change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 29 ++++++++++++-----------------
>  1 file changed, 12 insertions(+), 17 deletions(-)

Nice clean up.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b02d2ec8ff4b..c2ea92c2b69e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3511,13 +3511,15 @@ static bool suitable_to_scan(int total, int young)
>  }
>  
>  static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
> -		struct folio *folio, int new_gen, bool dirty)
> +			      struct lruvec *lruvec, struct folio *folio, bool dirty)
>  {
> -	int old_gen;
> +	int new_gen, old_gen;
>  
>  	if (!folio)
>  		return;
>  
> +	new_gen = lru_gen_from_seq(READ_ONCE(lruvec->lrugen.max_seq));
> +
>  	if (dirty && !folio_test_dirty(folio) &&
>  	    !(folio_test_anon(folio) && folio_test_swapbacked(folio) &&
>  	      !folio_test_swapcache(folio)))
> @@ -3548,8 +3550,6 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>  	struct lru_gen_mm_walk *walk = args->private;
>  	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
>  	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
> -	DEFINE_MAX_SEQ(walk->lruvec);
> -	int gen = lru_gen_from_seq(max_seq);
>  	unsigned int nr;
>  	pmd_t pmdval;
>  
> @@ -3600,7 +3600,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>  			continue;
>  
>  		if (last != folio) {
> -			walk_update_folio(walk, args->vma, last, gen, dirty);
> +			walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
>  
>  			last = folio;
>  			dirty = false;
> @@ -3613,7 +3613,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>  		walk->mm_stats[MM_LEAF_YOUNG] += nr;
>  	}
>  
> -	walk_update_folio(walk, args->vma, last, gen, dirty);
> +	walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
>  	last = NULL;
>  
>  	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
> @@ -3636,8 +3636,6 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
>  	struct lru_gen_mm_walk *walk = args->private;
>  	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
>  	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
> -	DEFINE_MAX_SEQ(walk->lruvec);
> -	int gen = lru_gen_from_seq(max_seq);
>  
>  	VM_WARN_ON_ONCE(pud_leaf(*pud));
>  
> @@ -3691,7 +3689,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
>  			goto next;
>  
>  		if (last != folio) {
> -			walk_update_folio(walk, vma, last, gen, dirty);
> +			walk_update_folio(walk, vma, walk->lruvec, last, dirty);
>  
>  			last = folio;
>  			dirty = false;
> @@ -3705,7 +3703,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
>  		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
>  	} while (i <= MIN_LRU_BATCH);
>  
> -	walk_update_folio(walk, vma, last, gen, dirty);
> +	walk_update_folio(walk, vma, walk->lruvec, last, dirty);
>  
>  	lazy_mmu_mode_disable();
>  	spin_unlock(ptl);
> @@ -4270,8 +4268,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  	struct pglist_data *pgdat = folio_pgdat(folio);
>  	struct lruvec *lruvec;
>  	struct lru_gen_mm_state *mm_state;
> -	unsigned long max_seq;
> -	int gen;
>  
>  	lockdep_assert_held(pvmw->ptl);
>  	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
> @@ -4308,8 +4304,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  
>  	memcg = get_mem_cgroup_from_folio(folio);
>  	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
> -	gen = lru_gen_from_seq(max_seq);
>  	mm_state = get_mm_state(lruvec);
>  
>  	lazy_mmu_mode_enable();
> @@ -4341,7 +4335,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  			continue;
>  
>  		if (last != folio) {
> -			walk_update_folio(walk, vma, last, gen, dirty);
> +			walk_update_folio(walk, vma, lruvec, last, dirty);
>  
>  			last = folio;
>  			dirty = false;
> @@ -4353,13 +4347,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  		young += nr;
>  	}
>  
> -	walk_update_folio(walk, vma, last, gen, dirty);
> +	walk_update_folio(walk, vma, lruvec, last, dirty);
>  
>  	lazy_mmu_mode_disable();
>  
>  	/* feedback from rmap walkers to page table walkers */
>  	if (mm_state && suitable_to_scan(i, young))
> -		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
> +		update_bloom_filter(mm_state, READ_ONCE(lruvec->lrugen.max_seq),
> +				    pvmw->pmd);
>  
>  	mem_cgroup_put(memcg);
>  
> 
> -- 
> 2.55.0
> 
> 

