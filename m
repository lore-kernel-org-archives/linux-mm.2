Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C58C61DE1
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 08:40:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5C86B008A; Sun, 30 Aug 2026 04:40:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2568C6B008C; Sun, 30 Aug 2026 04:40:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E5D6B0092; Sun, 30 Aug 2026 04:40:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D080F6B008A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:40:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CDDBC40280
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:40:02 +0000 (UTC)
X-FDA: 85157288244.07.2848256
Received: from mta1.migadu.com (out-38.mta1.migadu.com [95.215.58.38])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6A17840006
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:40:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oUOiAOUQ;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.38 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788079201;
	b=ILf/T8pMUG6F0RNehtjuo5k1m8kn6pVyePs7Bkp1JFIOCmSZEVFVPhCbNaozAXeTnaRXdZ
	DQlN61nqHxo7Y1X79UzNmwTnHo9y9kVM/wjsnTfE8zN50VU/tlWkzEb5h0HSbJwDwrEjyw
	sqnl+BDzDIIYuow8ptl5TRyqrBsEGoE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788079201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IeYytJO+FmZM8wLVpVvmk+jnMNt2BttzqZQlu/HsRFA=;
	b=KSidXSvoqbidNezsYTnvWbDlnrdXULZmeO2mfJa2AWsVcKIhpTT3fIxcqCS/upAmcUNA/v
	LwqX1ipsyDFAoupLt/xrDEDf7I/+rPW92bIVP+3MFgBe+EnWmtbNl6ogJ62MgjMLqks6f8
	JvmRgdkDT9OJJvkZ1J5hdsB73+rfN04=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oUOiAOUQ;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.38 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=poyqFmqVhqESctsgwAG+EcOJLqeE1cvWI7I6QYVl1/o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788079198; v=1; x=1788683998;
 b=oUOiAOUQ37shsktjFTc2wZkDkzs46iAU4zqXDawTXx4E43h+HJ8VpLc8wVcIYbDxalVNwstA
 Q6F1RPho89CwcCHyztk++5m6Qv7jlFxWi0wh8Q/bs0be2RuDJ/sPlOC2liO/9LfElpLQNCn0ncG
 n7URoqYKG5sjo430lYfqhISc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3983c7bbd036915e;
	Sun, 30 Aug 2026 08:39:48 +0000
X-Mizu-Trace-ID: 3983c7bbd036915e
X-Migadu-Flow: FLOW_OUT
Message-ID: <ad8acdc0-7618-4caf-88ca-4780e39ff324@linux.dev>
Date: Sun, 30 Aug 2026 16:39:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
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
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6A17840006
X-Stat-Signature: 5odm6sf47damgc39dpobhmedhgu4iq9p
X-HE-Tag: 1788079200-473507
X-HE-Meta: U2FsdGVkX195Gri8j5Is95dF6y8h2KHKjWBGvaP/V9QQy1U8vkuT5N/4GPdwBcvKYWLV/p8oyBoL2lYcMb2/7YbQnKQr8WpfZXBF8jr1cMfBYzzErS9Afom46I+96aOuECOh88hopNi94gr1NmHfvbEaEA6YXIeVFTfbnN4P/efbNb3iEVt1iGZsv/WAfcS7cK/wEKyqWhJtuDOJsBaEL9G4YE62eu/gB2Svn6/v8ZYocCmvnRb5eQHoqYxq07Gs1PCv/uqAvvoeTy/3JarjmjpDsYlIq0H0xU//9Dd1pzPW1+MhSiE/CqIeqI0unuugjqXaLCSNH8v4Szx4QbBZmHZFb6LUSv/HUZidUbl3Q06GA8a7wUkLMwJH0ynyQTZ9OiWBbJN6tW2EWuzlnslfWUcYIKGJIuo2cEjqEYSVeHxLrCYNgBv2DvDY435Qg8zDOxw0oAqO4ZbQzu2tOKCirJpbsooaBmiKEXrD8zvgnq0R6OPzrnLATiyHVtXK3S4kdrBMVMJiscnjAppnKTYEH0zXvZK7NrnsrnFGUXIAdSDBYdcrudfzVPq7YG+h1pgkeykWet6kUoZ1/V/EaLgJ3mCB/fykcyDDD7beGtnODCyWl78ClBvp6XRaQM+HtaxKkvCbIgb9G3K4i5DiKg7E47N1jd2+zHrduUD7mT1VSohRr6UYsDfoY1QvjwcjINfbwSSak0xu/EpYVxDIm7Wh6dEjxppEPFknR3owOkfyKI5MgpucXVrqXuTks3Nu7X/yYTLBCvBTWWEDeg9yR6cb2bSva9Nzpnxtk+HSLT4K+dD68FhzoaHoQdRapOtm6uNALCGZaZayxHyl1SwNzhOndfoMA1IdXV8s1vuwDKe4AhaTz/f2L+Tcw36w1jUmLU4C9buyGwqen2uJX2eITL8SvLdRueTOb57hrdQDpFG9cU4W9A/vF6LEo5fK43zLOTuhPI/hHv3cC3FE9DgOKma
 mbnu0mUA
 AuzrzVYVsZ4GbUpZPMvWrJeTLy8bef10o/edFhaNN496Rt9g0JVLA1VqLptzYxki78uybxXVMQ0Hw41Qm0TDz94+yVAvK9lJuXxzEeEtF4Gb1V+r/qlFYhXaE5MT7EuKs3fwUqRBFIXi5xWSPJLL+I5HOLfaFyxjFLwxyHe1OYqiePoQoxS1lvtxtzmNW4AdT3UtwYn3jy8YbyAEQCD6VJOT807zCH54OsdA1pAZRT7qx7T/hmGWYy/2ifsMwRdvPL/ZkYCcnCeZCJDKSt7w3lq0Oa/TQONDmfYMIA2TYWX+Y1Pk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/26/2026 1:53 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Instead of doing bit ops on folio->flags.f, introduce helpers for
> adjusting a folio's refs and generation info, making the code easier
> to debug and understand.
> 
> No functional change is intended: some combined atomic operations are
> split into two, which only creates harmless transient states. There is
> no measurable performance impact, and some paths even look slightly
> better in the generated assembly.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mm_inline.h | 76 ++++++++++++++++++++++++++++++++++++++++++-----
>   include/linux/mmzone.h    |  1 +
>   mm/folio.c                | 19 +++++++-----
>   mm/vmscan.c               | 61 ++++++++++++++++++++-----------------
>   4 files changed, 114 insertions(+), 43 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 621c8653d8f7..edfaf2661812 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -142,10 +142,42 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
>   	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
>   }
>   
> -static inline int folio_lru_refs(const struct folio *folio)
> +/**
> + * lru_gen_from_flags - Return the LRU generation number from folio flags.
> + * @flags: folio flags
> + *
> + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
> + * -1 if the flags indicate the folio is off the list (e.g., isolated).
> + */
> +static inline int lru_gen_from_flags(unsigned long flags)
> +{
> +	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> +
> +	BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
> +	gen -= 1;
> +	VM_WARN_ON_ONCE(gen != -1 && gen >= MAX_NR_GENS);
> +	return gen;
> +}
> +
> +/**
> + * lru_gen_set_flags - Set the LRU generation number to specified folio flags.
> + * @flags: pointer to the folio flags
> + * @gen: generation number, between 0 and (MAX_NR_GENS - 1), inclusive.
> + */
> +static inline void lru_gen_set_flags(unsigned long *flags, int gen)
>   {
> -	unsigned long flags = READ_ONCE(folio->flags.f);
> +	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS || gen < 0);
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
> @@ -155,11 +187,40 @@ static inline int folio_lru_refs(const struct folio *folio)
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
> @@ -270,7 +331,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
>   	gen = lru_gen_from_seq(seq);
>   	flags = (gen + 1UL) << LRU_GEN_PGOFF;
>   	/* see the comment on MIN_NR_GENS about PG_active */
> -	set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), flags);
> +	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
>   
>   	lru_gen_update_size(lruvec, folio, -1, gen);
>   	/* for folio_rotate_reclaimable() */
> @@ -295,7 +356,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>   
>   	/* for folio_migrate_flags() */
>   	flags = !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_active) : 0;
> -	flags = set_mask_bits(&folio->flags.f, LRU_GEN_MASK, flags);
> +	flags = set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flags);
>   	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>   
>   	lru_gen_update_size(lruvec, folio, gen, -1);
> @@ -339,7 +400,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>   
>   static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
>   {
> -
>   }
>   #endif /* CONFIG_LRU_GEN */
>   
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 94f9c3ff5416..c9ecf370cd9f 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -497,6 +497,7 @@ enum lruvec_flags {
>   
>   #define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
>   #define LRU_REFS_MASK		((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
> +#define LRU_REFS_MAX		BIT(LRU_REFS_WIDTH)
>   
>   /*
>    * For folios accessed multiple times through file descriptors,
> diff --git a/mm/folio.c b/mm/folio.c
> index c02dcea9c03c..a932059057ac 100644
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

Do we still need this branch now?

If folio_lru_refs(folio) == 0, that means refs = lru_refs_from_flags(old_flags) 
== 0, correct?

If so, the do-while loop below already handles this case, making this early 
return redundant.

Or am I missing something here?

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
> index 73a81b4a3e16..9ee9f8dc6805 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -843,19 +843,22 @@ static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
>   	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
>   		/* Activate file-backed executable folios after first usage. */
>   		if (is_exec_file_folio(folio, vma_flags)) {
> -			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
> +			folio_set_workingset(folio);
> +			folio_set_lru_refs(folio, 0);
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
> +		folio_set_workingset(folio);
> +		folio_set_lru_refs(folio, 0);
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
> @@ -4716,7 +4721,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
>   
>   	/* see the comment on LRU_REFS_FLAGS */
>   	if (!folio_test_referenced(folio))
> -		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
> +		folio_set_lru_refs(folio, 0);
>   
>   	success = lru_gen_del_folio(lruvec, folio, true);
>   	VM_WARN_ON_ONCE_FOLIO(!success, folio);
> @@ -4932,8 +4937,10 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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


