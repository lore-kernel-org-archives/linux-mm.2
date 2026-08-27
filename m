Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9FDEC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EA566B0088; Thu, 27 Aug 2026 12:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69BA06B008A; Thu, 27 Aug 2026 12:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562A56B008C; Thu, 27 Aug 2026 12:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 281CA6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:19:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A03CD140109
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:19:24 +0000 (UTC)
X-FDA: 85147559448.26.87302E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E07EB2000B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:19:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=COSR07O1;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQK9VCo/irKfPIXKEc3cGBdHJHvWvT42ZgRi4sLaCGA=;
	b=QyYYQJcWOXumwjpW56c/Lzt4jjXGkZe4znewku6IPZgEDvS+519pJeb9e4vqlws0EeVzxX
	/afNSnIFTh68oA3nhiXdKIML0quF//g480InE/+iJaHYdFXb0Qma7PN+e6gRXSmwtSL+5g
	P1tTabuJNu2t2c/0IQD+iiXw29rW1U0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847562;
	b=jL6MDTAuY+XkboiFkfJr4dz69BctQLBAqfAvF8S6ANgjZcNOflm6TuSzyMJIh50BY5lPD+
	lthiVHogK5C2aqaOx/DSF9kPSVsHeOWdyMYKvtYwRt4zAF85TCXPP/IxibqrL1tJSe1ICe
	yXtv+NbylrGZbRMerK+2ZvJ+oNbCu4s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=COSR07O1;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B2C8600D3;
	Thu, 27 Aug 2026 16:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C251F000E9;
	Thu, 27 Aug 2026 16:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787847561;
	bh=oQK9VCo/irKfPIXKEc3cGBdHJHvWvT42ZgRi4sLaCGA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=COSR07O1y9vXawm8HIwW9LxygFma/VKVqoPNcX145+K96FfaBJInTFBOjhATg/CN2
	 Nnjs63s5nnC1BdacteJ+YgvU0mjd28gfSShjoncowGKxW+T9m+i1cBpNsR6G6WzgeC
	 3IHZ+allCqPbZfG5YNxccc5PKxmLNfIAIUmqXu1ooE2P6GUXc2DItVJln8nL9bBTjH
	 mOKMyCB1fU/szqNcRxBTNRwx2D770iE3Xxx2bE5Gi7au9IE/sujSsBI8tG8SI3xfJJ
	 mh2fmjGxb+4zqGMe1C7ya/Vgz/o/hNb1aRrgA50HG7wFXK5Zl+C4rhzReORrBo01hS
	 4KykD3YYV9H6Q==
Message-ID: <e156c931-69b4-48d6-84bf-c06df134c9da@kernel.org>
Date: Thu, 27 Aug 2026 18:19:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/18] mm/huge_memory: split the routine for splitting
 anon and file folio
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-4-9b43f5163238@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260821-swap-thp-cleanup-v3-4-9b43f5163238@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E07EB2000B
X-Stat-Signature: ib8xpjsw84g16ag5igkfix94q61wa9gi
X-HE-Tag: 1787847562-632477
X-HE-Meta: U2FsdGVkX1+eZTtDNlMHxW7nPwasH8GjYUDW1bKMX6ya/CfDhLC58yN6I2dOXFf9lCf9M3SpqmHFUxr34x4XVjYLI3nrURVXKFDNUjtoErCiS+sMRKY5mFkyLwJDxFk88hJ4FCXqmPHxBAnJVUzXx5PLM2TeYxzf4wsdK/JBmi752JanUije/ywUmgfVrdE0a5piKVreDWsL5FkAqo4OY5koStdNj9mPCWZVnEzGds0npQJa/Q2M7zgZeL7U9q1Y+donO+p5g2LaiPcQgCmUItTEXiklIlbyfdhHsMBJimc8cRkFBPvtwj9xdI/vfEg8SbqPI49Okqe1nrZi0kbrhuQyPzQtT5L4k0dvsTzm2dw9PgFOd8a+41OZW3oCOlSjEDPQn5lRYEeCgw8debcPqC4SLDXj4zMApXa43C2HMXk/yCxIPKpoda/FSE9CECKzNOCpZw3n9102qvDhF9JSxxuWoJbOIGJLWUuZtgGv8g9j4C5c9Dh2PDkq7ZSioraFQb6ItU6hSyKUdRKUGklqhU7NThx37v9g18boTBVZFoluHOjsec5oKh84tdHcVzfFON7/GTrNRLGlpm323GHV1H5zEzVRAG+RIIxoIL4IecbUCD4X6/dyYwgmn4Bg+pMbtvSpA59tphvK7P8qz9dp81Rt1aTGBuF4utwIGGL7RKt/99cRNUSaZPvnqcjdHEkb01lwRRxAYKK/aHQp8u6G0PJsliGkI1koPpIuU9oclSRi6sjVHqEOVW2iOylqPTCGw0aEBgzVC+5Z/m9cg/MGIqguhEdYfl1CJi7s4G6TOVEgyGJf78Lp9ggJPHl0saePF/QDKrGqofydxUAoqr2o730U807FPisJbkV8+w9doGEBqzqF5gL7LtREU3egKcuCwxA7sF+0U63TLzFA99LR6n7zUy+f+UrbJcBVdObZnTWifBoTw2m+qvUtrBtHRfOy3ZUeWiPfS5mlbX3bPQz
 0KzBy1aL
 y7/Y4m1V9FicnQup+YGEfvQD/sBO3uRCWh2Qk/thOzRm+Ng/l2nIkqiV44Tynr57RikqhslKK9VJrPN1XQageUBDSGC4XdzuscuRATyvkamNqIs5Tzry/qcCr6al0Jx6eg2BXHB33WnuIp5n0gwWGk1JHsiu2OCyChNNMsdK2DJAd7cia9pAcA1l8IXznfymHdWPDeKuWsvDfY4jsXLEXMiFQr04zCr5nftbvzn4ldHggkHIgeXRUfdIPHRuGRygI2I82u2myWj6sZuqub0RCEL9VNUwwuEflXkLzdk/SouoBs4HXKse0zOeJRBhJ5EPi8cJcRM3rqcV+GQA6f41QnanWHR1J5b7JssIETqCHf2mI1AaX5vED0zShB8A41f69PUZqFO9O2w//bFW41dRD5vDzgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> No functional change intended. Before adding more logic, split
> __folio_freeze_and_split_unmapped() into an anon and a file variant so
> each path can evolve independently. The two paths shared little beyond
> the folio freeze call, the LRU locking, and the unfreeze skeleton, but
> differed in all other per-folio bookkeeping and routines.

Splitting that up makes sense.

> 
> While splitting, some cleanups become easy to apply, and helped drop a
> few now-redundant checks. Also introduce a folio iteration helper to
> avoid a common pitfall of iterating post-split sub-folios: a sub folio
> might get freed mid-iteration as pointed out by Zi [1].
> 
> Link: https://lore.kernel.org/linux-mm/DKJSFCLP967N.YBR4DNK1NM2N@nvidia.com/ [1]
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 119 +++++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 75 insertions(+), 44 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 7fb603ac500f..c3fd6757c14c 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3933,11 +3933,9 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
>  	return folio_nr_pages(folio);
>  }
>  
> -static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
> -					     struct page *split_at, struct xa_state *xas,
> -					     struct address_space *mapping, bool do_lru,
> -					     struct list_head *list, enum split_type split_type,
> -					     pgoff_t end, int *nr_shmem_dropped)
> +static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int new_order,
> +					      struct page *split_at, bool do_lru,
> +					      struct list_head *list, enum split_type split_type)

Switch to double tab indentation instead while at it. Same for the other function.

>  {
>  	struct folio *end_folio = folio_next(folio);
>  	struct swap_cluster_info *ci = NULL;
> @@ -3948,7 +3946,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  	bool dequeue_deferred;
>  	int ret = 0;
>  
> -	VM_WARN_ON_ONCE(!mapping && end);
>  	/*
>  	 * If this folio can be on the deferred split queue, lock out
>  	 * the shrinker before freezing the ref. If the shrinker sees
> @@ -3956,7 +3953,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  	 * lock and must clean up the LRU state - the same dequeue we
>  	 * will do below as part of the split.
>  	 */
> -	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
> +	dequeue_deferred = old_order > 1;
>  	if (dequeue_deferred) {
>  		struct mem_cgroup *memcg;
>  
> @@ -3986,24 +3983,72 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  		rcu_read_unlock();
>  	}
>  
> -	if (mapping) {
> +	if (folio_test_swapcache(folio))
> +		ci = swap_cluster_get_and_lock(folio);
> +
> +	if (do_lru)
> +		lruvec = folio_lruvec_lock(folio);
> +
> +	ret = __split_unmapped_folio(folio, new_order, split_at, NULL,
> +				     NULL, split_type);
> +
> +	/*
> +	 * Unfreeze the post-split folios and put them back to the right

Why call it "post-split" here when it's "after-split" in the other comment?

> +	 * place. Keep the head @folio frozen until the end: sub entries
> +	 * in swap cache must be updated first, so a concurrent
> +	 * swap_cache_get_folio() cannot return the head folio for a sub
> +	 * entry (folio_try_get() will fail on the head @folio until unfreeze).
> +	 */
> +	for (new_folio = folio_next(folio); new_folio != end_folio;
> +	     new_folio = next) {
> +		next = folio_next(new_folio);
> +		zone_device_private_split_cb(folio, new_folio);
> +		folio_ref_unfreeze(new_folio,
> +				   folio_cache_ref_count(new_folio) + 1);
> +		if (do_lru)
> +			lru_add_split_folio(folio, new_folio, lruvec, list);
> +		if (ci)
> +			__swap_cache_replace_folio(ci, folio, new_folio);
> +	}

This smells like duplicate code now. That should better be factored out?

[...]

> -	zone_device_private_split_cb(folio, NULL);
>  	/*
>  	 * Unfreeze @folio only after all page cache entries, which
>  	 * used to point to it, have been updated with new folios.
> @@ -4075,8 +4105,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  
>  	if (do_lru)
>  		lruvec_unlock(lruvec);
> -	if (ci)
> -		swap_cluster_unlock(ci);
>  
>  	return ret;
>  }
> @@ -4230,10 +4258,14 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  			ret = -EAGAIN;
>  			goto fail;
>  		}
> +		ret = __folio_freeze_split_unmapped_file(folio, new_order, split_at, &xas, mapping,
> +							 true, list, split_type, end,
> +							 &nr_shmem_dropped);
> +	} else {
> +		ret = __folio_freeze_split_unmapped_anon(folio, new_order, split_at, true,
> +							 list, split_type);
>  	}


I was briefly wondering whether shmem folios in the swapcache would now go
through __folio_freeze_split_unmapped_anon(). But folio_check_splittable()
rejects them.

I think we should consider changing all the "if (mapping)" checks there to
"is_anon" instead.

is_anon implies no mapping and !is_anon implies that we need a mapping.


This patch LGTM, but I think we should clean up __folio_split() further. Maybe
taht happens in the next patches in this series :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

