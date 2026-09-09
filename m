Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8EF9C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B604E6B008A; Wed,  9 Sep 2026 08:26:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37E06B0093; Wed,  9 Sep 2026 08:26:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27016B0095; Wed,  9 Sep 2026 08:26:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD996B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:26:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D191E401BE
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:26:01 +0000 (UTC)
X-FDA: 85194145722.15.F0CA9B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id EC85CC0003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:25:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BScMIUn9;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788956760;
	b=0maHBYhJmGRKcWpN11UJlDU/1S2SQdKofyAD+LpKxluq2ThOemzWiDN6QKCpzTCQL2TrTH
	ZAUNZIKeVviGBZxQ590Fgf93MSmpLgt3Tvj/9p+EMLfqPtPsoGzrfoby3WN5MeBWMTgi2F
	NsLeDykgB1LK1fmpYsAGahkAafc3PXo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BScMIUn9;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788956760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdOqLRxV95bI5IZka8zmrojbtJaO7I6k0UmQwWBwPus=;
	b=iKA0taP3rICt9f/f4fmoOsof2yxCYT+MYpH8hxfczmelIK74e4DZU1G6RuvhFbqY8//irR
	nTGjLDhoLp0LGq1pYKPE4+YK5WhlW8RZf1cgXrTNnDjTmTKi4Y1CwJASgeYDIDEggmgn7u
	uzlkP0F1oXSpjuKEJOAUgbxKsv6J2Vk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A64C411D7;
	Wed,  9 Sep 2026 12:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE611F00A3A;
	Wed,  9 Sep 2026 12:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788956758;
	bh=SdOqLRxV95bI5IZka8zmrojbtJaO7I6k0UmQwWBwPus=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BScMIUn9axRAmLIfx9jWVcCKGgcpMi1cOTaSdHR+Suxkd6THPECJO6DFz8yTc7Nq3
	 ITO/9uwEYpMJ/Dk8XClTJlm9vsumhjpAJ27fvSsk5IyREmVO1D6nH5MOUkD69HvorG
	 vjPBuGSeN6lJe8P/yg1/4u2betNHORGKYPQIG53D4yPrskhFJlXeE0h/t/1FOLEc0R
	 VM/+eMecxqP+dFfrH3c1s9zEpKe5TJBvwdizBsp7ktyuzFq894L5rzLb94+vd14sdB
	 z5TCe+NAgwE9CObpXIkHF4Axv0PmpsINQ18yH9eewWWG2MW6EJZodFCS5riuJ1PcPr
	 DrxLF4YVezt5Q==
Message-ID: <296bf543-23e0-417a-a729-c222392a1777@kernel.org>
Date: Wed, 9 Sep 2026 14:25:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/26] mm/fbatch: lru bit set, no extra ref, while
 folio on per-cpu fbatch
Content-Language: en-US
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Binbin Wu <binbin.wu@linux.intel.com>, Christian Brauner
 <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>,
 JP Kobryn <jp.kobryn@linux.dev>, Jan Kara <jack@suse.cz>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Kairui Song <ryncsn@gmail.com>, Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Yang Shi <yang@os.amperecomputing.com>,
 Yu Zhao <yuzhao@google.com>, Zach O'Keefe <zokeefe@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
 <61e15506-940f-3532-5fc9-4086f7612c10@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <61e15506-940f-3532-5fc9-4086f7612c10@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC85CC0003
X-Stat-Signature: awmyh1yh6z8kybw5n58xir4g57cnyzck
X-HE-Tag: 1788956759-980301
X-HE-Meta: U2FsdGVkX18sV93sr5TL2n2KGEMrr8+RuyHHaUOmNqCpfNAlNKcfwHHvIimDq+leRn5j5AnjZTBpjn+Lp3+es4SD6mD46Sko/6wgn+4cVDEHp9JKjlUD7vC9eFOj+1q6rFBWz/tVtFf21wlxK8kJFmQCE13srnd7Gt+C3MYjwVxRrqCu/fsN2aUuEdnTMa/cjZkYgZ/F3yu3/G6Tke4wpyD0aXC2lhlf5V2InB3TpZ+tWSrPIgCCljNNFB4lx0U7Svg4eUr12cnRcVoYiBcujOgKVIFLjZydjaRHKxRnaaofgGbkY07XHPMkTWM3/dVFdr3roW2aDZoff81r7H1uiC92sp3qEQgYodPbx5reYkZ9R2+FEXLR4qRyC+2O8GVJJyE5HYUgB9qb/H/w7i6RB4/v/8XjLvYcQvlrslUsZ6dTtICe4gkd+gXqznKunhRFs3p/nAqni0GVTXzlU80dkCgVEkEnerJNYqjbaaCirCYDBJO8XxqIONmvnSco3Ki0ViZIbhbIBp62LQOruWunE3fAocSsyB+0Rs9g0hHKlrt2LYSBKe5elhIHD48ITVg3QHeAXdN0xp9iqsSor3nP0PycnP6HYkiDIN6QxZYoRQnG8vHkyslW4iBS0EzZSnFuMTaYMzTgWvVCmky+ukoT9m7IyCm1BbjRWv/c4Jkr17RL5naZsNJON5JGFCoH5eAqJrNFqBsjQdd3aNQqdo+cUgdIoTm2Y4Mf0H4PlzU+Rwjb7iNfi9MvLnBBHKvrUZtPFXtV/N3ZzI+ON6SKNId5bxDpuUnKUGiDWuKuaOOxbo7w5Kte206U16qg5hn84kZljvnY9UHha9ydPRXM8IRG2dvfhUoBIUK8dheK+wIUo05xcOye2L3zcooZMKbpjqjNPGamgfFMFhHEqCzfdljX0rOPjQHecaNk/+wicfM5ZkRA//NlDBZrdeN2wAlei50rlNagDGqJJiasSSSVxSW
 6ksCNkho
 HsIKpjd8EgZAfWeyn5tRt3mRuOm8UpKVaQJAMiNyk7E9/d8GHhtz8kvySJ9fbpcH9Q5eTfiYJZSYtJWUtNRrrG9SFgAJkHv/UKjNb8WssosuS3PqzDmd06GEsOnwwp6VGKwXFYfjfiTpKd+NR/grtVc4VcwBJ8sjF/Chjy1ZLjhD0Xi4t66QVjSG9rY5YAqFgjK4aLcW0RuoJVNHFXtSPdTblSMR1LU8Q3VX00rSRY1qC4zkMQknBTvaYo++1e1N0F9gGvUg8Uwp8Ey3NfY0YWQxWA+Fu0y5BICvCLp1BRSTB+OY8nWhrA7pjcm1oha4XyCVR0xeFxJkBlTor3vz2b9LVvahAMonI/+Cvrelp6TVB+9M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 11:49, Hugh Dickins wrote:
> Treat folios on a per-cpu fbatch as if they were already on the lruvec:
> with PG_lru set, without holding an extra reference. This will enable
> the removal of most lru_add_drain() and lru_add_drain_all() calls soon.
> 
> Recognize such a folio by 0x02 set in the folio->lru.next pointer by
> folio_add_lru(). Then lruvec_del_folio() (aided by "lru_add_del_folio")

I admit I find the name lru_add_del_folio() quite confusing. What it does is
AFAIU try to delete from a folio_batch, which is not necessarily the lru_add
one?
I don't have an alternative proposal ready though, naming is hard.

> can pretend to unlink it, and folio_batch_move_lru()'s lru_add case can
> check whether one of the others has already moved it to lruvec.
> 
> (That bit is also used in a transient way by set_page_pfmemalloc(), to
> inform interested callers whether page_is_pfmemalloc(): but those callers
> are in networking, not putting folios on LRU; and accept that any use of
> the page->lru field already erases page_is_pfmemalloc() information.)
> 
> Let folio->lru.next point to the lru_add fbatch entry, but this is now
> just for debugging: it seemed to be important for folio_batch_move_lru()
> to distinguish fresh from stale entries, but then it turned out that it
> has to processs them identically.
> 
> Activate, deactivates and move_tail, holding no reference on the folio,
> might come to act on a stale folio when the fbatch is drained: but it's
> acquired by try_get and test_clear_lru, so safe even when suboptimal.
> 
> Reclaim is not an exact science, and there have been no complaints of
> missed actions since 5.11 commit fc574c23558c ("mm/swap.c: serialize
> memcg changes in pagevec_lru_move_fn") introduced the TestClearPageLRU
> protocol: so don't expect complaints of a few surprisingly taken actions.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Tricky, and I guess my questions below will betray I didn't grasp all the
nuances...

> ---
>  include/linux/mm_inline.h |  25 ++++++++
>  include/linux/mm_types.h  |   6 +-
>  mm/folio.c                | 119 +++++++++++++-------------------------
>  mm/huge_memory.c          |   6 +-
>  4 files changed, 74 insertions(+), 82 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 621c8653d8f7..8420b1276535 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -343,6 +343,29 @@ static inline void folio_migrate_refs(struct folio *new, const struct folio *old
>  }
>  #endif /* CONFIG_LRU_GEN */
>  
> +enum {
> +	LRU_NEXT_NEVER_TAIL = 0,	/* Used by a tail's compound_head */
> +	LRU_NEXT_BATCHED = 1,		/* Not used by any aligned pointer */
> +	NR_LRU_NEXT_FLAGS
> +};
> +
> +static __always_inline
> +bool lru_add_del_folio(struct folio *folio)
> +{
> +	unsigned long lru_next = READ_ONCE(folio->lru_next);
> +
> +	/* BUG_ON(folio_test_lru(folio) && folio_ref_count(folio)); */

Maybe do it as VM_WARN_ON_ONCE() and then it's acceptable for mainline and
gets excercised by bots?

> +	if (!(lru_next & BIT(LRU_NEXT_BATCHED)))
> +		return false;
> +
> +	WRITE_ONCE(folio->lru.next, LIST_POISON1);
> +	/* BUG_ON(folio->lru_next & BIT(LRU_NEXT_BATCHED)); */

Is this a test for unexpected LIST_POISON1 definitions (in which case
BUILD_BUG_ON would work?) or a test for a race that should not happen,
however with a very tiny detection window?

> +
> +	/* Ensure folio->lru_next visible when folio_set_lru() called later */
> +	smp_mb__before_atomic();
> +	return true;
> +}
> +
>  static __always_inline
>  void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
>  {
> @@ -384,6 +407,8 @@ void lruvec_del_folio(struct lruvec *lruvec, struct folio *folio)
>  
>  	if (lru_gen_del_folio(lruvec, folio, false))
>  		return;
> +	if (lru_add_del_folio(folio))
> +		return;
>  
>  	if (lru != LRU_UNEVICTABLE)
>  		list_del(&folio->lru);
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 6d815f6440c9..fe6220b97cf3 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -85,6 +85,8 @@ struct page {
>  	 * WARNING: bit 0 of the first word is used for PageTail(). That
>  	 * means the other users of this union MUST NOT use the bit to
>  	 * avoid collision and false-positive PageTail().
> +	 * Bit 1 of the first word is used by page_is_pfmemalloc().
> +	 * Bit 1 of the first word (lru_next) is also used by folio_add_lru().
>  	 */
>  	union {
>  		struct {	/* Page cache and anonymous pages */
> @@ -410,10 +412,8 @@ struct folio {
>  			union {
>  				struct list_head lru;
>  	/* private: avoid cluttering the output */
> -				/* For the Unevictable "LRU list" slot */
>  				struct {
> -					/* Avoid compound_info */
> -					void *__filler;
> +					unsigned long lru_next;
>  	/* public: */
>  					unsigned int mlock_count;
>  	/* private: */
> diff --git a/mm/folio.c b/mm/folio.c
> index b9dc4f5e10a6..e743cd539b9e 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -152,57 +152,34 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
>  	int i;
>  	struct lruvec *lruvec = NULL;
>  	unsigned long flags = 0;
> -	struct folio_batch free_fbatch;
> -	bool is_lru_add = (move_fn == lru_add);
> -
> -	/*
> -	 * If we're adding to the LRU, preemptively filter dead folios. Use
> -	 * this dedicated folio batch for temp storage and deferred cleanup.
> -	 */
> -	if (is_lru_add)
> -		folio_batch_init(&free_fbatch);
>  
>  	for (i = 0; i < folio_batch_count(fbatch); i++) {
>  		struct folio *folio = fbatch->folios[i];
>  
> -		/* block memcg migration while the folio moves between lru */
> -		if (!is_lru_add && !folio_test_clear_lru(folio))
> -			continue;
> -
> -		/*
> -		 * Filter dead folios by moving them from the add batch to the temp
> -		 * batch for freeing after this loop.
> -		 *
> -		 * We're bypassing normal cleanup. Clear flags that are not
> -		 * applicable to dead folios.
> -		 *
> -		 * Since the folio may be part of a huge page, unqueue from
> -		 * deferred split list to avoid a dangling list entry.
> -		 */
> -		if (is_lru_add && folio_ref_freeze(folio, 1)) {
> -			__folio_clear_active(folio);
> -			__folio_clear_unevictable(folio);
> -			folio_unqueue_deferred_split(folio);
> +		if (!folio_try_get(folio)) {
>  			fbatch->folios[i] = NULL;
> -			folio_batch_add(&free_fbatch, folio);
>  			continue;
>  		}
>  
> +		if (!folio_test_clear_lru(folio))
> +			continue;
> +
> +		/* Do not add to LRU if it has already been added */
> +		if (move_fn == lru_add && !lru_add_del_folio(folio))
> +			goto restore_lru;
> +
>  		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
>  		move_fn(lruvec, folio);
>  
> +		/* Do add to LRU if not already there (move_fn skipped) */
> +		if (lru_add_del_folio(folio))
> +			lruvec_add_folio(lruvec, folio);

AFAICS the previous code didn't do anything like this (and move_fn could
skip or not all the same?) , and I wonder if it's now (sorry) load-bearing,
or an optimization?

> +restore_lru:
>  		folio_set_lru(folio);
>  	}
>  
>  	if (lruvec)
>  		lruvec_unlock_irqrestore(lruvec, flags);
> -
> -	/* Cleanup filtered dead folios. */
> -	if (is_lru_add) {
> -		mem_cgroup_uncharge_folios(&free_fbatch);
> -		free_unref_folios(&free_fbatch);
> -	}
> -
>  	folios_put(fbatch);
>  }
>  
> @@ -211,8 +188,6 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
>  {
>  	unsigned long flags;
>  
> -	folio_get(folio);
> -
>  	if (disable_irq)
>  		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
>  	else
> @@ -273,7 +248,6 @@ static void lru_activate(struct lruvec *lruvec, struct folio *folio)
>  	if (folio_test_active(folio) || folio_test_unevictable(folio))
>  		return;
>  
> -
>  	lruvec_del_folio(lruvec, folio);
>  	folio_set_active(folio);
>  	lruvec_add_folio(lruvec, folio);
> @@ -289,37 +263,12 @@ void folio_activate(struct folio *folio)
>  	    !folio_test_lru(folio))
>  		return;
>  
> -	folio_batch_add_and_move(folio, lru_activate);
> -}
> -
> -static void __lru_cache_activate_folio(struct folio *folio)
> -{
> -	struct folio_batch *fbatch;
> -	int i;
> -
> -	local_lock(&cpu_fbatches.lock);
> -	fbatch = this_cpu_ptr(&cpu_fbatches.lru_add);
> -
>  	/*
> -	 * Search backwards on the optimistic assumption that the folio being
> -	 * activated has just been added to this batch. Note that only
> -	 * the local batch is examined as a !LRU folio could be in the
> -	 * process of being released, reclaimed, migrated or on a remote
> -	 * batch that is currently being drained. Furthermore, marking
> -	 * a remote batch's folio active potentially hits a race where
> -	 * a folio is marked active just after it is added to the inactive
> -	 * list causing accounting errors and BUG_ON checks to trigger.
> +	 * XXX: It is curiously difficult to recreate safely the old
> +	 * __lru_cache_activate_folio() optimization (folio_set_active()
> +	 * directly if it's on the local lru_add fbatch): revisit later.
>  	 */
> -	for (i = folio_batch_count(fbatch) - 1; i >= 0; i--) {
> -		struct folio *batch_folio = fbatch->folios[i];
> -
> -		if (batch_folio == folio) {
> -			folio_set_active(folio);
> -			break;
> -		}
> -	}
> -
> -	local_unlock(&cpu_fbatches.lock);
> +	folio_batch_add_and_move(folio, lru_activate);
>  }
>  
>  #ifdef CONFIG_LRU_GEN
> @@ -410,16 +359,7 @@ void folio_mark_accessed(struct folio *folio)
>  		 * unevictable page accessed has no effect.
>  		 */
>  	} else if (!folio_test_active(folio)) {
> -		/*
> -		 * If the folio is on the LRU, queue it for activation via
> -		 * cpu_fbatches.lru_activate. Otherwise, assume the folio is in a
> -		 * folio_batch, mark it active and it'll be moved to the active
> -		 * LRU on the next drain.
> -		 */
> -		if (folio_test_lru(folio))
> -			folio_activate(folio);
> -		else
> -			__lru_cache_activate_folio(folio);
> +		folio_activate(folio);
>  		folio_clear_referenced(folio);
>  		workingset_activation(folio);
>  	}
> @@ -439,6 +379,10 @@ EXPORT_SYMBOL(folio_mark_accessed);
>   */
>  void folio_add_lru(struct folio *folio)
>  {
> +	struct folio_batch *fbatch;
> +	unsigned long lru_next;
> +	bool full;
> +
>  	VM_BUG_ON_FOLIO(folio_test_active(folio) &&
>  			folio_test_unevictable(folio), folio);
>  	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
> @@ -458,7 +402,26 @@ void folio_add_lru(struct folio *folio)
>  			folio_mark_accessed(folio);
>  	}
>  
> -	folio_batch_add_and_move(folio, lru_add);
> +	local_lock(&cpu_fbatches.lock);
> +	fbatch = this_cpu_ptr(&cpu_fbatches.lru_add);
> +
> +	/* Storing this address is only for debugging */
> +	lru_next = (unsigned long)&fbatch->folios[fbatch->nr];
> +	/* This mask will do nothing on 64-bit */
> +	lru_next &= ~(BIT(NR_LRU_NEXT_FLAGS) - 1);
> +	lru_next |= BIT(LRU_NEXT_BATCHED);
> +	folio->lru_next = lru_next;
> +
> +	full = !folio_batch_add(fbatch, folio);
> +
> +	/* Ensure folio->lru_next visible to folio_test_clear_lru() callers */
> +	smp_mb__before_atomic();
> +	folio_set_lru(folio);
> +
> +	if (full || !folio_may_be_lru_cached(folio) || lru_cache_disabled())
> +		folio_batch_move_lru(fbatch, lru_add);
> +
> +	local_unlock(&cpu_fbatches.lock);
>  }
>  EXPORT_SYMBOL(folio_add_lru);
>  
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index afbb5974bd22..c7510d875433 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3995,8 +3995,12 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  		}
>  
>  		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
> -		if (do_lru)
> +		if (do_lru) {
>  			lruvec = folio_lruvec_lock(folio);
> +			/* Move from fbatch to lruvec before lru_add_split_folio()s */
> +			if (lru_add_del_folio(folio))
> +				lruvec_add_folio(lruvec, folio);

This is not mentioned in the changelog. Why is it necessary now?

> +		}
>  
>  		ret = __split_unmapped_folio(folio, new_order, split_at, xas,
>  					     mapping, split_type);


