Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09376C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 00:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F4A6B00BB; Mon, 29 Jun 2026 20:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8106B00BC; Mon, 29 Jun 2026 20:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0DED6B00BD; Mon, 29 Jun 2026 20:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DECE6B00BB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:21:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 187768D0EB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:21:25 +0000 (UTC)
X-FDA: 84934674930.14.B1245BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 60433C0005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:21:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZYRxfn9j;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782778883;
	b=OUK0efthaafVfwR/Cy+Edt9v1qVE67h03TfUy/3k0HnjJSTo6gmNTYU/ErysFDnLu6Es3M
	c6I6yqux5x01QDbZ2xOTlFQSJBqGIXFYkhi8/35zdJj3DllN4EdljA9KgO0fuM5WcYycLE
	CPiD1lqwnA99EOKfOro/5c7DJvtAevc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782778883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1/03gzz0ds6TJ32gK+FBdEfAwHCvhh8gu24bRY2Uww=;
	b=ZNGyJw3ZueHCHI42y83GLPtvhSg7r0GrsHmq4GGAocGw6tWL+BF/wKXPvDXP0t5PA5D7Bd
	5Jk8/IMq1hh7kDgu03e2lWQjhBxF9mM3hgxyr/Pbkin28cdgGtg6Aqow1kONifgnwnnqUZ
	O5D7RqKi4hmQ7f8IcQDqi4uboDFaZoY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZYRxfn9j;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9375543451;
	Tue, 30 Jun 2026 00:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83901F000E9;
	Tue, 30 Jun 2026 00:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782778882;
	bh=h1/03gzz0ds6TJ32gK+FBdEfAwHCvhh8gu24bRY2Uww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZYRxfn9jVr+A5PLaXrQF9dGV/f3hx+W7pEF9cfhnxwTqN1zqjfwYFHLeWdnR0tbRo
	 iUT8bKmz5Nr+vxL/dvb7aSuUiEsSAMokytDA+DSSNqpJMEhOCylC5unlyYFdELEI9q
	 FKXRlMfi3EajzpE8QpInWzV6BiM0w+cIVuFp5FsIci4P8+4E6ZUeRMYc3DB8uDu7Fn
	 8Np6LRlexJW08bCuLavHNtIm54x/S1acgbTAh05wg1HsLXU3W2pNIT8MPGBDdvlsqq
	 j83wjtCeA0F1RrYNFQUNCPwwhbpw27sHoPb9sfRQKiYYQSPxTzwWUiprGe+gsdl2Fj
	 zvF2KaIwwWXlQ==
Date: Tue, 30 Jun 2026 00:21:20 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v5 2/6] mm/zswap: Support batch writeback in
 shrink_memcg()
Message-ID: <akMK9z_GOarOZWHz@google.com>
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
 <20260629112032.20423-3-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629112032.20423-3-jiahao.kernel@gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 60433C0005
X-Rspam-User: 
X-Stat-Signature: 185ox767m3cifbg8x4nypo69bhr1ukok
X-HE-Tag: 1782778883-736450
X-HE-Meta: U2FsdGVkX1+SpeJvyis9oZ9p0EabzZFqi3W6v/WOJ6wsc3hmpf1w5/Cq12Y424SdCnKRvKCj8wcMYpEXCIbp2S7fM8TsrrhX8ffnqM1VBB5Sk4+wZg2ufM139Hz4KRh5BrHABWTxCINtOhbbhwrdSRN4FB8/tZdhjsagZ1UV0qlXofpCuVKsgzQHre81dPty/ANKJErEVuyu2T4QWagKWUDAlsq6iUks6GWn3jJwTDqrARnuDFfpUNuLVj9hJ/NFp4gqkMnPWL2Q01ZYsRj7wGqZYrkOgKaVhQvPnDuYlIc/kwYVuWWx3KRP1VDHLBZuluz+4Lnvlz09NQEIPwLBhJUi9ikBGytFBSWR3Cu7koS1RV/hqPAw8SQeX6YPFxPsMe+e/rdG3LhALj7M1MQAwKc+2YFc14fNHlu3odfUwjwk6RyJxfuIOv6HbbVSkthhVpv6dXgzKFJjVH1IBsScNEvbirQKwKtkwG5S0MDI9ugMd85/ACygWOHyAODnyLEQ6dMN4ZskATKbE2ejpWiQVy4Qa30yBOBheprTC7p+8Yj8tz/5RKacIazVoUT0STFLdjC84egesBitfFSfnFseB4cjFvML1Pf1UaIhzhFL39TcyppfzO3fY+pmww4vJOZWHve/a6UYrMLSDoz5OQFX6M+tPEp9Jft7vUhtWTC65w1QouPGIWu45PJJvA0BM7gNgNT3dnU/9RI+5iatQNdzmquqGQzjmeLSkT9u17FL4VmILulAPLYq3YZxnRWmtYUM20kr2sNc80Cho+eSI+6RFxJrOUW+6TQzgI6NkNQlWvH+XzUR8ilBiKmDrLZo9HUjRajgMGwe2rq95TCvwng+hr9M5x2oniNTx+qN6+axHjkl09DFXEA+OowE83mzVLFqIaFWma6XzkfAOwhQ9aLDh8ckda+7cPtcgqISmo2lD8c6qW4PoDDWv7/MfNAsUoaNBS//f3b1NJXt6o+e9yF
 0IKlx2/W
 rE4NJmQyircHsLWGvBPwk4mw+ZvGuow3JiBgAdkCnkW5l59oPdW52HAsQ0NrNSxsFd1Y1iCiYVJKl5yBKvrLINFhT6z32vw9TuDD2QhFIH4BLPd12lLfJosULSUBIjaBrQUP7cM0a+HE8a4Rpg9K3v2pPz+Ft6d+eFLkyWBaqUO/1oWF72ihERCBpSE3kfzPhgdVqBS6/hRuntNsWWVv8aV6jOFBboki3d4EUEeopsYavVmnX0cEQj1+Qdfd05E257P8Rlvfnei2jzSFzfgTkkuE5ovKRFIlBzL5+waioP8oXObVe6svW4aPYyUwoZuw9XDJBMVJy6KA/0AMANV5xS5KBYERePAawjuFTioZzHrSt8ew2MW4AWSkY44keAD9mzgCGEElajKCy90Hl1JOorb+IIq9AsavwW0SNup4OWc2E0sbwGN1bhblzn0tekUFmI7J5KwiU2QHxaLY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 07:20:28PM +0800, Hao Jia wrote:
> From: Hao Jia <jiahao1@lixiang.com>
> 
> Currently, shrink_memcg() writes back at most one entry per-node during
> its traversal. This makes shrink_worker() inefficient, as it must
> repeatedly re-enter shrink_memcg() to make any substantial progress.
> 
> To address this, extend shrink_memcg() and rewrite its LRU iteration logic
> to support batch writeback. Introduce the nr_to_scan parameter to bound how
> many pages are scanned per call. This enables batch writeback in the
> shrink_worker() path, while maintaining a low scan budget in the
> zswap_store() path.
> 
> Additionally, to prepare for future proactive writeback, update the return
> value semantics of shrink_memcg(): a positive value now represents the
> actual number of compressed bytes written back, 0 indicates that candidates
> existed but no writeback succeeded, and a negative value represents an
> error code.
> 
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
> ---
>  mm/zswap.c | 89 ++++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 69 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 0f8f04f22888..e2c2a3f1e061 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -160,6 +160,11 @@ struct zswap_pool {
>  	char tfm_name[CRYPTO_MAX_ALG_NAME];
>  };
>  
> +struct zswap_shrink_walk_arg {
> +	unsigned long bytes_written;
> +	bool encountered_page_in_swapcache;
> +};
> +
>  /* Global LRU lists shared by all zswap pools. */
>  static struct list_lru zswap_list_lru;
>  
> @@ -1089,8 +1094,9 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
>  				       void *arg)
>  {
>  	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
> -	bool *encountered_page_in_swapcache = (bool *)arg;
> +	struct zswap_shrink_walk_arg *walk_arg = arg;
>  	swp_entry_t swpentry;
> +	unsigned int length;
>  	enum lru_status ret = LRU_REMOVED_RETRY;
>  	int writeback_result;
>  
> @@ -1133,10 +1139,11 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
>  
>  	/*
>  	 * Once the lru lock is dropped, the entry might get freed. The
> -	 * swpentry is copied to the stack, and entry isn't deref'd again
> -	 * until the entry is verified to still be alive in the tree.
> +	 * needed fields are copied to the stack, and entry isn't deref'd
> +	 * again until it is verified to still be alive in the tree.
>  	 */
>  	swpentry = entry->swpentry;
> +	length = entry->length;
>  
>  	/*
>  	 * It's safe to drop the lock here because we return either
> @@ -1155,12 +1162,13 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
>  		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
>  		 * shrinker context).
>  		 */
> -		if (writeback_result == -EEXIST && encountered_page_in_swapcache) {
> +		if (writeback_result == -EEXIST) {
>  			ret = LRU_STOP;
> -			*encountered_page_in_swapcache = true;
> +			walk_arg->encountered_page_in_swapcache = true;
>  		}
>  	} else {
>  		zswap_written_back_pages++;
> +		walk_arg->bytes_written += length;
>  	}
>  
>  	return ret;
> @@ -1169,8 +1177,11 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
>  static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
>  		struct shrink_control *sc)
>  {
> +	struct zswap_shrink_walk_arg walk_arg = {
> +		.bytes_written = 0,
> +		.encountered_page_in_swapcache = false,
> +	};
>  	unsigned long shrink_ret;
> -	bool encountered_page_in_swapcache = false;
>  
>  	if (!zswap_shrinker_enabled ||
>  			!mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
> @@ -1179,9 +1190,9 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
>  	}
>  
>  	shrink_ret = list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_memcg_cb,
> -		&encountered_page_in_swapcache);
> +		&walk_arg);
>  
> -	if (encountered_page_in_swapcache)
> +	if (walk_arg.encountered_page_in_swapcache)
>  		return SHRINK_STOP;
>  
>  	return shrink_ret ? shrink_ret : SHRINK_STOP;
> @@ -1275,9 +1286,31 @@ static struct shrinker *zswap_alloc_shrinker(void)
>  	return shrinker;
>  }
>  
> -static int shrink_memcg(struct mem_cgroup *memcg)
> +#define NR_ZSWAP_WB_BATCH	64UL
> +
> +/*
> + * Scan up to @nr_to_scan pages across the per-node zswap LRUs of @memcg
> + * and write back the reclaimable ones.
> + *
> + * Since the second-chance algorithm rotates referenced entries to the
> + * LRU tail, the per-node scan is capped at the current LRU length so
> + * each entry is scanned at most once per call. It is up to the caller
> + * to handle retries, deciding whether to scan another memcg to complete
> + * the full iteration, or to rescan the current memcg to drain its zswap
> + * entries.
> + *
> + * Return: The number of compressed bytes written back (>= 0), or -ENOENT
> + * if @memcg has writeback disabled, is a zombie cgroup, or has empty
> + * zswap LRUs.
> + */
> +static long shrink_memcg(struct mem_cgroup *memcg, unsigned long nr_to_scan)
>  {
> -	int nid, shrunk = 0, scanned = 0;
> +	struct zswap_shrink_walk_arg walk_arg = {
> +		.bytes_written = 0,
> +		.encountered_page_in_swapcache = false,
> +	};
> +	unsigned long nr_remaining = nr_to_scan;
> +	int nid;
>  
>  	if (!mem_cgroup_zswap_writeback_enabled(memcg))
>  		return -ENOENT;
> @@ -1290,24 +1323,40 @@ static int shrink_memcg(struct mem_cgroup *memcg)
>  		return -ENOENT;
>  
>  	for_each_node_state(nid, N_NORMAL_MEMORY) {
> -		unsigned long nr_to_walk = 1;
> +		unsigned long nr_to_walk;
>  
> -		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
> -					    &shrink_memcg_cb, NULL, &nr_to_walk);
> -		scanned += 1 - nr_to_walk;
> +		/*
> +		 * Cap the scan at per-node LRU length so each entry is scanned
> +		 * at most once per call.
> +		 */
> +		nr_to_walk = min(nr_remaining,
> +				 list_lru_count_one(&zswap_list_lru, nid, memcg));
> +		if (!nr_to_walk)
> +			continue;
> +
> +		nr_remaining -= nr_to_walk;
> +		list_lru_walk_one(&zswap_list_lru, nid, memcg, &shrink_memcg_cb,
> +				  &walk_arg, &nr_to_walk);
> +		/* Return the unused share of the budget to the pool. */
> +		nr_remaining += nr_to_walk;
> +
> +		if (!nr_remaining)
> +			break;
>  	}
>  
> -	if (!scanned)
> +	/* Nothing was scanned: every LRU under @memcg was empty. */
> +	if (nr_remaining == nr_to_scan)
>  		return -ENOENT;
>  
> -	return shrunk ? 0 : -EAGAIN;
> +	return walk_arg.bytes_written;
>  }
>  
>  static void shrink_worker(struct work_struct *w)
>  {
>  	struct mem_cgroup *memcg;
> -	int ret, failures = 0, attempts = 0;
> +	int failures = 0, attempts = 0;
>  	unsigned long thr;
> +	long ret;
>  
>  	/* Reclaim down to the accept threshold */
>  	thr = zswap_accept_thr_pages();
> @@ -1373,7 +1422,7 @@ static void shrink_worker(struct work_struct *w)
>  			goto resched;
>  		}
>  
> -		ret = shrink_memcg(memcg);
> +		ret = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
>  		/* drop the extra reference */
>  		mem_cgroup_put(memcg);
>  
> @@ -1394,7 +1443,7 @@ static void shrink_worker(struct work_struct *w)
>  		}
>  		++attempts;
>  
> -		if (ret && ++failures == MAX_RECLAIM_RETRIES)
> +		if (ret <= 0 && ++failures == MAX_RECLAIM_RETRIES)
>  			break;
>  resched:
>  		cond_resched();
> @@ -1504,7 +1553,7 @@ bool zswap_store(struct folio *folio)
>  	objcg = get_obj_cgroup_from_folio(folio);
>  	if (objcg && !obj_cgroup_may_zswap(objcg)) {
>  		memcg = get_mem_cgroup_from_objcg(objcg);
> -		if (shrink_memcg(memcg)) {
> +		if (shrink_memcg(memcg, num_node_state(N_NORMAL_MEMORY)) <= 0) {

Why not just 1? 

I guess the current behavior will try each node. But this doesn't really
match it, as we may reclaim everything from the first node. Right?

I think it's probably fine to just do 1 here, fairness is not the main
concern in this code path, we're really just trying to free up some
space to free up some space for the incoming page. I doubt these limits
are actually being used extensively anyway, so we can revisit this later
if needed.

>  			mem_cgroup_put(memcg);
>  			goto put_objcg;
>  		}
> -- 
> 2.34.1
> 

