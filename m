Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70F65CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 23:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444346B0088; Mon, 22 Jun 2026 19:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F5426B008A; Mon, 22 Jun 2026 19:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C986B008C; Mon, 22 Jun 2026 19:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEDBF6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:33:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D9BA1402F7
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:33:15 +0000 (UTC)
X-FDA: 84909151950.25.6C02FC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id B1A5B1C0003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:33:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+C0XNag;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782171193;
	b=DO3KHlk/Fst14yMXG+PckTp6sUGYVY51k/InWBwG/OR5IScpsimlNPIgd7e0HyccHZRm43
	IEGe57K+N5HLNx/ZIEoWz67JS4YBpkcUOkISpFRYAjeLtX5RxptiDIFx7wnfjrFDQXUwAl
	1aVnmcxWdZ7IuI9iMRPH7SLN6v2JbsQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782171193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KSxmiKCRroWaE39Q1RgwF5nRth0kmcKDQtRVrbtvJc0=;
	b=DA9Cm8USAZQGjhr7C+NqDsi7TbAikglcyt/G13ijXMv3RHBCBos3wsAHlRw/xj/lpQt+3T
	jzsVrddQISXvmocHr0CKNda/AlNkHUmvMJYoZ396+edx3/NySuQOqDWIEmS+N4JhvsEA+F
	kGOTy3PD/GiFJJ6Hr5ErrHRXSl7gTW4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+C0XNag;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ACCFA42B17;
	Mon, 22 Jun 2026 23:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044F51F000E9;
	Mon, 22 Jun 2026 23:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782171192;
	bh=KSxmiKCRroWaE39Q1RgwF5nRth0kmcKDQtRVrbtvJc0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G+C0XNagfgVZ+Vc7H+7OHKuHzM2MFIU5NvY6WD/kPPlJ8frGYefleUblXGcZz13gR
	 0pmWoA6J8S69eMiLwttf5iXkdUKx+uukGioNpQpH0/QFdoczELAUz2oNXVcer5BGYd
	 TwuuwBTFLGa8EX15Z6IDIHRwsUJMmMLm5Cxiam7OOo8h2Y1TWPt1kb0i51Zwc0GEHX
	 /bDlklNSi7VG0XKj0RJ0RuNf2C+Ob47NoMZ78qy5irBhFdhYErtnUHmYLDPvUs8ODB
	 v4Qw2lR4aB6UOMhVt5xSev+zhv+0hOnAmnxiVDfxmgXzi+6QOrVmDEBMOHFJNkMRYR
	 II9DmGjHConpQ==
Date: Mon, 22 Jun 2026 23:33:10 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v4 1/5] mm/zswap: Extend shrink_memcg() writeback
 capability
Message-ID: <ajnB8IZrFZwbIr9P@google.com>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <20260618044857.69439-2-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618044857.69439-2-jiahao.kernel@gmail.com>
X-Stat-Signature: grkzcgks1dj1x6wfjkau134nssqbcfpw
X-Rspam-User: 
X-Rspamd-Queue-Id: B1A5B1C0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782171193-677733
X-HE-Meta: U2FsdGVkX1/YbpTziTd2/z1v1JvqvochKDP4iEx/zcxg84Q2lW7SiAIPWO3a0seBDSVosFbagsYT4GnAqPp3EzCfAgDF4S5kLmyUcnDJUHp7ul8HQoRMErvNtKCo9/lGhFXUwFtXVU0jCTQFVkEWz9xYnERLl2zFCn0w+YAn+d/oofAFNXO1jBJ1a2zX3MUBmmcGTvskyBxiryojj837pUFUOQQ7uMy31/p/TPhoN0McqYATtkXrS4d/o50i0UIchP4339tD5/zktF17d1E4BIv+gm62QnOUut7DoJ6ZtkMw2m5c2KZ9eDNlqoHgt0d3BPZbd/Kj7Vnt+C6wz+GWuUD33Q6vF3PbLllq9Lvmay2v9pML/epfm7glOiNI3idDhuFW0N7kDqgGAO9tCmRSLTP7fjky4I9lRRlNvEl2LASIwqq5AVYRE9Trxd25KFGl8HSh9R9i3ZiRyj8OB68zWlPuckcW9ChI5Zj2LOvgJ64T7fzaawqpAScDGiI39gPkTyiW4EuU30Ds8+XYafLdvWnL+xdCpVuAci8nqVOXV3pUvzkYkl1vMv5EzLDBlSlS6EdgrfZAQva0qE1NAP/LR+dmDd/U+sJwloCxOagVwuZLPpQzz8XlEZEP/DRMKKrJaxQ1uM/QPERF+GBNkqycAM6gqYLfXGN5L8+v7qHs/yLRmT/RK8fEOu0KwBkzUdJ4m1Jwt8/E0rkS3CDwFj1P9EbP31vEMExviCmpZ3I7nHpHhSfHZyqEMB53KBQ5ZJxqW3Of0QPKqqY7SVdAFeG/KZHI/8Kz22nTqz+9RBrbsCfA0YksowW6VMyS/1BkxQGa5pIVym6mwsj9hMAq3dMz5zpPIvoKl90WkmvYNbjI2hNljTt2AhSt5K9q2MolMQxqcranw0sujU2P21vSR3tIwMrQHkuApzglwcfAJMuH4qsJmYIOb2I8HTXeYNx6iyv0iOvxEzUgc0DmseJalK+
 HoKeayL5
 N7xdpdrwhqjqypkGMo2mq722ETJG17XyhacQZ2FJVeBsDP/wKFPumcw2AMYcWJNMfMVYjWBkICYLV3tOcyc8gF/9BCCMgeVfl5kSnmrhi7DphtI4QhLZkfvKXAZ1kR3Lr85uss+7Ikm1gphPJlAmwWF4XlZ36YIJbR+u9NLYWcglmnP9C2DIY4Id8apgtWR3i/mwLBt1VHOYOq45uk1PQ2cSOH1a94mZ8EqRbLOGaIAuGolAo4My1ZKWlTC985u8XdUeq3RCSLsTqy3rVL5FNg+4UoyEpKunNq0nxZVv0hqLuylz0oel0LMEZYbNaxGnsJkBG4niq84TxL62tapeg7xzaApvqEFgEMO4mHDD1LPLUG3PR5l0uTRZPqSfpTYtfexij+W8A4q5lPbKqp7TivYsHWUFFByEhn3rB2R4yP7hhxQGT9hpxVbGU9nMqx71EpvsKcfUMQZSOMYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 12:48:53PM +0800, Hao Jia wrote:
> From: Hao Jia <jiahao1@lixiang.com>
> 
> Currently, shrink_memcg() writes back at most one entry per-node
> during its traversal. This makes shrink_worker() inefficient, as
> it must repeatedly re-enter shrink_memcg() to make any substantial
> progress.
> 
> To address this, extend shrink_memcg() and rewrite its LRU iteration
> logic to support batch writeback. Introduce the nr_to_writeback
> parameter to support a writeback budget based on compressed size.
> This enables batch writeback in the shrink_worker() path, while
> maintaining a low writeback budget in the zswap_store() path.
> 
> Additionally, to prepare for future proactive writeback, update
> the return value semantics of shrink_memcg(): a positive value now
> represents the actual number of compressed bytes written back, 0
> indicates that candidates existed but no writeback succeeded, and
> a negative value represents an error code.
> 
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
> ---
>  mm/zswap.c | 116 ++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 97 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 761cd699e0a3..d7d031dee4cd 100644
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
> @@ -1135,8 +1141,13 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
>  	 * Once the lru lock is dropped, the entry might get freed. The
>  	 * swpentry is copied to the stack, and entry isn't deref'd again
>  	 * until the entry is verified to still be alive in the tree.
> +	 *
> +	 * entry->length is also copied while the lock is held, because
> +	 * zswap_writeback_entry() frees the entry on success and we still
> +	 * need its compressed size to account for writeback.

Hmm that's unnecessary, just update "The swpentry is copied to the
stack.." above to "Copy neded fields to the stack.." or something.

>  	 */
>  	swpentry = entry->swpentry;
> +	length = entry->length;
>  
>  	/*
>  	 * It's safe to drop the lock here because we return either
> @@ -1155,12 +1166,13 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
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
> @@ -1169,8 +1181,11 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
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
> @@ -1179,9 +1194,9 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
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
> @@ -1275,10 +1290,32 @@ static struct shrinker *zswap_alloc_shrinker(void)
>  	return shrinker;
>  }
>  
> -static int shrink_memcg(struct mem_cgroup *memcg)
> -{
> -	int nid, shrunk = 0, scanned = 0;
> +/*
> + * The maximum acceptable scan cost factor for writing back
> + * PAGE_SIZE bytes of compressed data.
> + */
> +#define ZSWAP_WB_SCAN_FACTOR	16UL
> +#define NR_ZSWAP_WB_BATCH	64UL
>  
> +/*
> + * Iterate over the per-node zswap LRUs of @memcg in batches, writing back
> + * up to @nr_to_writeback * PAGE_SIZE bytes of compressed data.
> + *
> + * Return: The number of bytes written back, or -ENOENT if @memcg has
> + * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
> + */
> +static long shrink_memcg(struct mem_cgroup *memcg,
> +			 unsigned long nr_to_writeback)


Is nr_to_writeback supposed to be the number of pages we want to
writeback (regardless of their compressed size), or the compressed bytes
we want to writeback divided by PAGE_SIZE?

The way it's being used below seems like it's the latter, but the batch
size should be in terms of scanned pages (i.e. uncompressed pages). So
this is confusing.

The zswap_store() path expects to reclaim one uncompressed page, but
this will reclaim PAGE_SIZE worth of compressed memory when passing 1
IIUC (actually maybe more, see below).

> +{
> +	struct zswap_shrink_walk_arg walk_arg = {
> +		.bytes_written = 0,
> +		.encountered_page_in_swapcache = false,
> +	};
> +	u64 bytes_to_writeback = nr_to_writeback << PAGE_SHIFT;
> +	bool memcg_list_is_empty = true;
> +	int nid;
> +
> +	/* Memcg with zswap writeback disabled are not candidates. */

The comment is unnecessary here, it should be obvious.

>  	if (!mem_cgroup_zswap_writeback_enabled(memcg))
>  		return -ENOENT;
>  
> @@ -1290,24 +1327,65 @@ static int shrink_memcg(struct mem_cgroup *memcg)
>  		return -ENOENT;
>  
>  	for_each_node_state(nid, N_NORMAL_MEMORY) {
> -		unsigned long nr_to_walk = 1;
> +		unsigned long nr_to_scan, nr_scanned = 0;
> +		unsigned long remain;
> +		walk_arg.encountered_page_in_swapcache = false;
> +		/*
> +		 * Cap by LRU length: bounds rewalks when referenced
> +		 * entries keep rotating to the tail.
> +		 */
> +		nr_to_scan = list_lru_count_one(&zswap_list_lru, nid, memcg);
> +		if (!nr_to_scan)
> +			continue;

Hmm generally if we are running out of pages to scan then we should scan
the rotated entries, and reclaim them on the second pass, right? So this
should be working as intended. But I guess this doesn't work well when
iterating multiple memcgs, as we don't want to drain referenced entries
in one memcg before reclaiming already rotated entries on another.

So I think the assumption here is that the caller will retry if needed,
handling balancing scanning between multiple memcgs if needed. Maybe we
should document this in the function doc above? We should explain that
referenced entries will be rotated but not reclaimed as part of the same
call.

> +		memcg_list_is_empty = false;
> +
> +		/*
> +		 * Cap by SCAN_FACTOR * remain budget: bounds scan cost
> +		 * to the remaining writeback budget.
> +		 */
> +		remain = DIV_ROUND_UP(bytes_to_writeback - walk_arg.bytes_written, PAGE_SIZE);
> +		nr_to_scan = min(nr_to_scan,
> +				 remain * ZSWAP_WB_SCAN_FACTOR);

For the zswap_store() path bytes_to_writeback=PAGE_SIZE, so remain will
initially be 1. But then we multiply by this factor and now to scan 16
pages? Also, where did this factor and equation come from?

We'll also loop over nodes, so we may end up scanning 32 or more pages
depending on the number of nodes in the system.

If this is just a heuristic, we should really just start simple and add
heuristics later as needed. The caller should probably pass in the
number of pages to scan (i.e. uncompressed pages), and leave it to the
caller to decide when to retry if the actual memory savings are
realized.

>  
> -		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
> -					    &shrink_memcg_cb, NULL, &nr_to_walk);
> -		scanned += 1 - nr_to_walk;
> +		while (nr_scanned < nr_to_scan) {
> +			unsigned long nr_to_walk = min(NR_ZSWAP_WB_BATCH,
> +						       nr_to_scan - nr_scanned);
> +
> +			/*
> +			 * Account for the committed budget rather than the walker's
> +			 * actual delta. If the list is emptied concurrently, the
> +			 * walker visits nothing and nr_scanned would never advance.
> +			 */
> +			nr_scanned += nr_to_walk;
> +
> +			list_lru_walk_one(&zswap_list_lru, nid, memcg,
> +					  &shrink_memcg_cb,
> +					  &walk_arg,
> +					  &nr_to_walk);
> +
> +			if (walk_arg.bytes_written >= bytes_to_writeback)
> +				return walk_arg.bytes_written;
> +
> +			if (walk_arg.encountered_page_in_swapcache)
> +				break;
> +
> +			cond_resched();
> +		}

If the caller is expected to have a retry loop anyway, should we
simplify this and just scan each per-node LRU once?

We should also probably bail early if the number of scanned pages has
already been reached? Currently shrink_memcg() scans one page at a time,
so if it scans a bit more to balance between the nodes it's probably
fine.

But with batching, we could end up scanning hundres of extra pages just
to balance between all nodes. Is node imbalance a real issue?

>  	}
>  
> -	if (!scanned)
> +	/* Return -ENOENT if all zswap LRU lists are empty. */
> +	if (memcg_list_is_empty)
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
> @@ -1368,7 +1446,7 @@ static void shrink_worker(struct work_struct *w)
>  			goto resched;
>  		}
>  
> -		ret = shrink_memcg(memcg);
> +		ret = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
>  		/* drop the extra reference */
>  		mem_cgroup_put(memcg);
>  
> @@ -1382,7 +1460,7 @@ static void shrink_worker(struct work_struct *w)
>  			continue;
>  		++attempts;
>  
> -		if (ret && ++failures == MAX_RECLAIM_RETRIES)
> +		if (ret <= 0 && ++failures == MAX_RECLAIM_RETRIES)
>  			break;
>  resched:
>  		cond_resched();
> @@ -1492,7 +1570,7 @@ bool zswap_store(struct folio *folio)
>  	objcg = get_obj_cgroup_from_folio(folio);
>  	if (objcg && !obj_cgroup_may_zswap(objcg)) {
>  		memcg = get_mem_cgroup_from_objcg(objcg);
> -		if (shrink_memcg(memcg)) {
> +		if (shrink_memcg(memcg, 1) <= 0) {
>  			mem_cgroup_put(memcg);
>  			goto put_objcg;
>  		}
> -- 
> 2.34.1
> 

