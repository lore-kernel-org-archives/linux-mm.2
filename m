Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FF7BC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 01:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F03636B008C; Wed, 19 Aug 2026 21:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB47C6B0092; Wed, 19 Aug 2026 21:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA34C6B0095; Wed, 19 Aug 2026 21:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5F086B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 21:43:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1F75B160657
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 01:43:57 +0000 (UTC)
X-FDA: 85119951714.10.128BD10
Received: from mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5C744160002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 01:43:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IiMx0KSC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787190235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z0gfvL+c1E289Cjs6J+bVr5+GIG0zCd0d9q8W8ZEZEs=;
	b=nt9ssZIULkMWe52DI3OpqGiZIOgk3o0Y3DVMToPdE1QofVumWgQzfDZYJcaK1JLvZGDyF1
	DFGYTosrHPRfFKlhBgipnnOrt0AXyqdxL4imlxZjK6DPDIBBmRlfA1n3800iEbgJp9Tr0y
	RVKrXKmANoAxqng5vS5JNwIe+STaoPE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IiMx0KSC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787190235;
	b=Kjux3JU9R9zsUfXcpiiumJsLJgsnV2kosWBkYntsB3g80FvXYQ3ucOACQ66LFrstYI87h5
	SL1RczIE1cecCAuhoSyxrU+JZJ1JcL3RpgfGvteqbgTVtMq9ap6qWkXcph62Qr3l74cZGl
	LNbGUMOqa6NRUJ85fj7C9d0kOpmHQ+o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lnVkbcv9nvMDIFwAzscsLZ6HrGmPYwlymVm5IRzpej0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787190230; v=1; x=1787795030;
 b=IiMx0KSCDqvdel//K7zTsZ0ApKBwCkEp0zLQqxNiFjUe6/5BLHxuB/vZRhdLZ6fRJYTWFgm2
 N9zZeVZom5k2a1UaJFk4wuddGYPpCOsixXKs2V5qccFuKtAbaNR6dI8kxYkNESDOBZmgY6tmc9P
 NcdqgombiNBRHbno800FQBjc=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 271e1b95aa3d4182;
	Thu, 20 Aug 2026 01:43:50 +0000
X-Mizu-Trace-ID: 271e1b95aa3d4182
X-Migadu-Flow: FLOW_OUT
Message-ID: <a13c3895-cc53-4f91-aac8-2bfef765eca5@linux.dev>
Date: Thu, 20 Aug 2026 09:43:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm/mglru: introduce helpers for manipulating gen and
 refs flags
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
 <20260818-mglru-flags-cleanup-v1-2-8dbbdac0d28c@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-2-8dbbdac0d28c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: yrpqgwjr4kwa4j6jrj9ipkzqsowrsyud
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5C744160002
X-HE-Tag: 1787190233-327859
X-HE-Meta: U2FsdGVkX19Ij4cmDvf5zIdT3h9naXxlE/GfHoc0rIk7+ZtdzIZe7b7fuf8PPhDfvUWKTszgCEsmE8MJ8UTPOErxEuRifWQPndMgnbsUz6FHFn/4r75ev9GvzuTiZ9YtMDrnV7Olf6d18GdHVWCGEjEknBPvnrXxRfpg0gf2IguCpbJTziQ7WzPY1ssJKUxLRZ0W0by/l5XKRQAKml/SqsZRHxWaFkeeFKL8f7TMSLmJXqKtBj0Gt0tgqTqIRjgrzPg+7TvOG1+XMHWV0taIxQ8mQOGAC9RSETudv8/i7nJnwpGaBccWg/N1edGZHbOLGkJEwCDZArxDFtoiOIv121/MIKjvxJI0HjmjtGAHPnQvU6esoB3b9hp0vFtP8ypi3SMlGlSC9w+qkWEln3pLcSbKgo2pBJXFau+1zpBjPG9MQLOnloVRWmVl8efhlbgtvH1Zvcn3H5GSxi7Sd9/LbQDJ1z9i0GUnmmGvIdaSsjEdFy/G97BV9UxT3coClrwoQt7/VrVKaVni6+SkrfYDRplG86tYPS1AAuDCE58cM+WSSIDMEkEAmCDe2F731z9mAq0po6I2t9nwPHBMQYiRnHS4V6JE9ryD0ugaRDtB+bnbp11Vpcx/FPhJ4ufClRybvZYLvRuMofqFCNWRtyMYNYrr2+Ys9o+UF9hInA7a74U3U987VFvM3USa0Rv04Dg2H8ySig9if8mj2DPkz4IYBj5aFRB79gWDqSdofrxjdiw+RRHxcH20tbNB4qlZNRI4VUwlrd0GAchVGa5pPjsbWBTgYx2BpPK3YlJyMjmA4Yy8a2LG/xUvSxVKaB4qGZN5PjRhjRE1JJ1A5LcowkalYKlBgzwJURlqdqS+w6kUD0YPQqbEqwSw9abL8Kz/jvfAl63DRRCBpS4k+num9uIbldFqQ19+xHAM80QRcOKmSVZcLIJP6yu/CYGsQB4dbFwWPOBJHiqm88FBIEpwSMD
 dLCFnJO/
 SUwUXFF+sGZPw4UAm9wykZP7XPf8SR62jySUOjRjBVllCQelyNy/UFpzw7g4UgkwSGbTqkiUUd90oA8iC0iL/GPpHgnkkH7Emr6vl+UvkcOcPUiTyzEb0iNFO6AYa/solzFoBXw72lvf6PzGyJbC3JwhuLa8gt+gOo9hqvrLTdARvJAqBsZDVOdm16QFsiipmPztJN4NsnbpMWmrBwHEkmTcdnuTIA6iyDAVJJSEGeLrN6ZqlxseTcUfgKHT5KXajg4CHE/baiUnf0hs0HUNvROA+sn3ehaxfVKrzpWCkQTEi7KE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/18/2026 1:38 PM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Instead of doing bit ops on folio->flags.f, introduce helpers for
> adjusting folio's refs and gen info, make the code easier to debug and
> understand.
> 
> No functional change is intended: some combined atomic operations are
> split into two, which only creates harmless transient states.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mm_inline.h | 79 +++++++++++++++++++++++++++++++++++++++++------
>   include/linux/mmzone.h    |  2 ++
>   mm/folio.c                | 19 +++++++-----
>   mm/vmscan.c               | 61 ++++++++++++++++++++----------------
>   4 files changed, 117 insertions(+), 44 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 621c8653d8f7..93bf3fa221f8 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -142,10 +142,43 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
>   	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
>   }
>   
> -static inline int folio_lru_refs(const struct folio *folio)
> +/**
> + * lru_gen_from_flags - Return the LRU generation number from folio flags.
> + * @flags: folio flags
> + *
> + * Returns: A number between 0 and LRU_GEN_MAX, inclusive. Returns -1 if the
> + * flags indicate the folio is off the list (e.g., isolated).
> + */
> +static inline int lru_gen_from_flags(unsigned long flags)
> +{
> +	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> +
> +	BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
> +	gen -= 1;
> +	VM_WARN_ON_ONCE(gen != -1 && gen > LRU_GEN_MAX);

Perhaps we could define a macro such as GEN_OFF = -1 to make the code more 
self-explanatory, I found this warning a bit confusing at first glance.

LRU_GEN_MAX already bears some resemblance to MAX_NR_GENS, so introducing yet 
another macro may add some clutter.

Just my two cents.

> +	return gen;
> +}
> +
> +/**
> + * lru_gen_set_flags - Set the LRU generation number to specified folio flags.
> + * @flags: pointer to the folio flags
> + * @gen: generation number, between 0 and LRU_GEN_MAX, inclusive.
> + */
> +static inline void lru_gen_set_flags(unsigned long *flags, int gen)
>   {
> -	unsigned long flags = READ_ONCE(folio->flags.f);
> +	VM_WARN_ON_ONCE(gen > LRU_GEN_MAX || gen < 0);
> +	BUILD_BUG_ON((LRU_GEN_MAX + 1) != MAX_NR_GENS);
> +
> +	*flags &= ~LRU_GEN_MASK;
> +	*flags |= (gen + 1UL) << LRU_GEN_PGOFF;
> +}
>   
> +/**
> + * lru_refs_from_flags - Return LRU referenced / access count from folio flags.
> + * @flags: folio flags
> + */
> +static inline int lru_refs_from_flags(unsigned long flags)
> +{
>   	if (!(flags & BIT(PG_referenced)))
>   		return 0;
>   	/*
> @@ -155,18 +188,47 @@ static inline int folio_lru_refs(const struct folio *folio)
>   	return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
>   }
>   
> -static inline int folio_lru_gen(const struct folio *folio)
> +/**
> + * lru_refs_set_flags - Set the LRU referenced / access count to specified folio flags.
> + * @flags: pointer to the folio flags
> + * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, inclusive.
> + */
> +static inline void lru_refs_set_flags(unsigned long *flags, unsigned int refs)
> +{
> +	VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> +	BUILD_BUG_ON(LRU_REFS_MAX != (LRU_REFS_MASK >> LRU_REFS_PGOFF) + 1);
> +
> +	*flags &= ~LRU_REFS_FLAGS;
> +	if (!refs)
> +		return;
> +	*flags |= (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_PGOFF));
> +}
> +
> +static inline int folio_lru_refs(const struct folio *folio)
>   {
> -	unsigned long flags = READ_ONCE(folio->flags.f);
> +	return lru_refs_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
> +}
> +
> +static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
> +{
> +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> +
> +	do {
> +		new_flags = old_flags;
> +		lru_refs_set_flags(&new_flags, refs);
> +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> +}
>   
> -	return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> +static inline int folio_lru_gen(const struct folio *folio)
> +{
> +	return lru_gen_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
>   }
>   
>   static inline bool lru_gen_is_active(const struct lruvec *lruvec, int gen)
>   {
>   	unsigned long max_seq = lruvec->lrugen.max_seq;
>   
> -	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
> +	VM_WARN_ON_ONCE(gen > LRU_GEN_MAX);
>   
>   	/* see the comment on MIN_NR_GENS */
>   	return gen == lru_gen_from_seq(max_seq) || gen == lru_gen_from_seq(max_seq - 1);
> @@ -270,7 +332,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
>   	gen = lru_gen_from_seq(seq);
>   	flags = (gen + 1UL) << LRU_GEN_PGOFF;
>   	/* see the comment on MIN_NR_GENS about PG_active */
> -	set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), flags);
> +	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
>   
>   	lru_gen_update_size(lruvec, folio, -1, gen);
>   	/* for folio_rotate_reclaimable() */
> @@ -295,7 +357,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>   
>   	/* for folio_migrate_flags() */
>   	flags = !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_active) : 0;
> -	flags = set_mask_bits(&folio->flags.f, LRU_GEN_MASK, flags);
> +	flags = set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flags);
>   	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>   
>   	lru_gen_update_size(lruvec, folio, gen, -1);
> @@ -339,7 +401,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>   
>   static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
>   {
> -
>   }
>   #endif /* CONFIG_LRU_GEN */
>   
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 94f9c3ff5416..32d9354a754f 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -496,7 +496,9 @@ enum lruvec_flags {
>   #ifndef __GENERATING_BOUNDS_H
>   
>   #define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
> +#define LRU_GEN_MAX		(BIT(LRU_GEN_WIDTH - 1) - 1)
>   #define LRU_REFS_MASK		((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
> +#define LRU_REFS_MAX		BIT(LRU_REFS_WIDTH)
>   
>   /*
>    * For folios accessed multiple times through file descriptors,
> diff --git a/mm/folio.c b/mm/folio.c
> index 59c477120b9a..0adfe4f5ef72 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -353,26 +353,28 @@ static void __lru_cache_activate_folio(struct folio *folio)
>   
>   static void lru_gen_inc_refs(struct folio *folio)
>   {
> -	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
> +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> +	int refs;
>   
>   	if (folio_test_unevictable(folio))
>   		return;
>   
>   	/* see the comment on LRU_REFS_FLAGS */
> -	if (!folio_test_referenced(folio)) {
> -		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
> +	if (!folio_lru_refs(folio)) {
> +		folio_set_lru_refs(folio, 1);
>   		return;
>   	}
>   
>   	do {
> -		if ((old_flags & LRU_REFS_MASK) == LRU_REFS_MASK) {
> +		new_flags = old_flags;
> +		refs = lru_refs_from_flags(old_flags);
> +		if (refs == LRU_REFS_MAX) {
>   			if (!folio_test_workingset(folio))
>   				folio_set_workingset(folio);
>   			return;
>   		}
> -
> -		new_flags = old_flags + BIT(LRU_REFS_PGOFF);
> -	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
> +		lru_refs_set_flags(&new_flags, refs + 1);
> +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>   }
>   
>   static bool lru_gen_clear_refs(struct folio *folio)
> @@ -384,7 +386,8 @@ static bool lru_gen_clear_refs(struct folio *folio)
>   	if (gen < 0)
>   		return true;
>   
> -	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset), 0);
> +	folio_set_lru_refs(folio, 0);
> +	folio_clear_workingset(folio);
>   
>   	rcu_read_lock();
>   	seq = READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c1404a59523d..080132997d87 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -843,19 +843,22 @@ static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
>   	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
>   		/* Activate file-backed executable folios after first usage. */
>   		if (is_exec_file_folio(folio, vma_flags)) {
> -			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
> +			folio_set_lru_refs(folio, 0);
> +			folio_set_workingset(folio);
>   			return true;
>   		}
>   
> -		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
> +		folio_set_lru_refs(folio, 1);
>   		return false;
>   	}
>   
>   	/* Promote on second access */
> -	if (folio_lru_refs(folio) > 1)
> -		set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
> -	else
> +	if (folio_lru_refs(folio) > 1) {
> +		folio_set_lru_refs(folio, 0);
> +		folio_set_workingset(folio);
> +	} else {
>   		folio_mark_accessed(folio);
> +	}
>   	return true;
>   }
>   #else
> @@ -3266,11 +3269,10 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
>    ******************************************************************************/
>   
>   /* promote pages accessed through page tables */
> -static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma_flags)
> +static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t *vma_flags)
>   {
> -	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
> -
> -	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
> +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> +	int old_gen;
>   
>   	/*
>   	 * See the comment on LRU_REFS_FLAGS, and activate file-backed
> @@ -3279,20 +3281,24 @@ static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma
>   	 */
>   	if (!folio_test_referenced(folio) && !folio_test_workingset(folio) &&
>   	    !is_exec_file_folio(folio, vma_flags)) {
> -		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
> +		folio_set_lru_refs(folio, 1);
>   		return -1;
>   	}
>   
>   	do {
> +		old_gen = lru_gen_from_flags(old_flags);
> +		new_flags = old_flags;
> +
>   		/* lru_gen_del_folio() has isolated this page? */
> -		if (!(old_flags & LRU_GEN_MASK))
> -			return -1;
> +		if (old_gen < 0)
> +			break;
>   
> -		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
> -		new_flags |= ((gen + 1UL) << LRU_GEN_PGOFF) | BIT(PG_workingset);
> -	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
> +		lru_gen_set_flags(&new_flags, new_gen);
> +		lru_refs_set_flags(&new_flags, 0);
> +		new_flags |= BIT(PG_workingset);
> +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>   
> -	return ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> +	return old_gen;
>   }
>   
>   /* protect pages accessed multiple times through file descriptors */
> @@ -3301,21 +3307,20 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
>   	int type = folio_is_file_lru(folio);
>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>   	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
> -	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
> -
> -	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
> +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
>   
>   	do {
> -		new_gen = ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> +		new_gen = lru_gen_from_flags(old_flags);
> +
>   		/* folio_update_gen() has promoted this page? */
>   		if (new_gen >= 0 && new_gen != old_gen)
>   			return new_gen;
>   
> +		new_flags = old_flags;
>   		new_gen = (old_gen + 1) % MAX_NR_GENS;
> -
> -		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
> -		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
> -	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
> +		lru_gen_set_flags(&new_flags, new_gen);
> +		lru_refs_set_flags(&new_flags, 0);
> +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>   
>   	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
>   
> @@ -4711,7 +4716,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
>   
>   	/* see the comment on LRU_REFS_FLAGS */
>   	if (!folio_test_referenced(folio))
> -		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
> +		folio_set_lru_refs(folio, 0);
>   
>   	success = lru_gen_del_folio(lruvec, folio, true);
>   	VM_WARN_ON_ONCE_FOLIO(!success, folio);
> @@ -4927,8 +4932,10 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   		}
>   
>   		/* don't add rejected folios to the oldest generation */
> -		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
> -			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
> +		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
> +			folio_set_lru_refs(folio, 0);
> +			folio_set_active(folio);
> +		}
>   	}
>   
>   	move_folios_to_lru(&list);
> 

-- 
Best regards
Ridong


