Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0C92CD6E51
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 01:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 042426B0005; Fri, 29 May 2026 21:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2EC46B0088; Fri, 29 May 2026 21:37:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E44506B008A; Fri, 29 May 2026 21:37:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2C4D6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 21:37:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B6D41C0DE0
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:37:22 +0000 (UTC)
X-FDA: 84822373524.16.A2A9548
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D45044000E
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:37:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AzsUAUVP;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780105040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nO0cIl82wPxeZvS2+pe+To1HD6LqNrV1MR7nS3Y58H4=;
	b=x2AJa/h/xzHNJoa6Ya14FsHw3nPcugGt8OZiM/lxiGnBEnOsqAVGOHu85st5Luea2pVBzC
	v50mjZRM2+Plw+NQXXxayz0OYGFAyU8xboePR4IB4p4EZqCAjVw0V9TLtyjUwZeB8gKnWV
	h+TInqjvwGhUOMkSC/xRDmC/WwWy31k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AzsUAUVP;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780105040; a=rsa-sha256;
	cv=none;
	b=T7Lf63hh8AR4gw9Ed4w9t7R62IbNou/koa9rffpNMHCafkFWt9tcGeYNIRYBy9yIUCBV2e
	1vO5yeXk0E+7FCib+4FVp83WtAKCzlwKSX0/37/cEGjVt6hpD6YtOtGbFzCSvgTkQ64ylL
	EBWkBZO5UYun5wb8VUHW2j/fMvzuCkA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5629260103;
	Sat, 30 May 2026 01:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706F51F00893;
	Sat, 30 May 2026 01:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780105040;
	bh=nO0cIl82wPxeZvS2+pe+To1HD6LqNrV1MR7nS3Y58H4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AzsUAUVPsLR7I7C/g6G1sNgiaNwjyBjcx4VXK1rGDUE+KeFuH+qr9lt+QZoIftpGe
	 zDlTKF+/SrGarcqWMVsCqpPMdjfOtpS/HBQzr/LeAZ+yODO9O9apiCfsUGDxXn3kDK
	 ZhfgnoGOrdiQWy8mww3522kArTFMwMd9iEQDknvI4pLn6/XB2EfHmcMQjGqEwr5nFu
	 pC16ARFKIg63BifO/IJoQ4ABoEAT00o38Aj8xoh5rW/VJzSBHSlHteIjOd1DH1Fzl7
	 +pzohQWzrkPteaoygGwIFlpjTkFL5cRl9TUOWgSKOSY2feSmHw1/Dm9PC4vuWjVofQ
	 jnyVNGdWki0Ow==
Date: Sat, 30 May 2026 01:37:18 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Message-ID: <aho-Z6wshceTAYd9@google.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526114601.67041-3-jiahao.kernel@gmail.com>
X-Stat-Signature: 5x1kd8ezw4sp67gbdnhci38mw6dxwqnx
X-Rspamd-Queue-Id: D45044000E
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780105040-714170
X-HE-Meta: U2FsdGVkX1/5noOMnYZZbBt5wZi6pEXIrdvUlUDrKWRn+c8KuLZ8WC/MDFZiUslBgfpAIJeYrzicyhofKHNgA55er1HDzJmjniq1rrVvi4NzuBihzKKfu/dNfAKsLuagWjBEZ0GRDfppz3NZ+PROrp9QPZYxHt+1fMu/CxbtVsMdZmeuTjHUOZzfbF6cq2wRFVo97DoxbajglizK+V/GDUSDSLb9UXo/+29wDJB43mosB4/eMJ9J1S9mhJMrDYFfCtswBxoMK22aGFhGKn/CHlSpXh0TolMtqsk45LkjlNT7/1ns33kScEzOR2VULIVMb62hq6kB/NpK3FppEN2x6V7He1mmANhJEtxZUbbwO1F6L3yaXUzS3Tjuphpjt6rK7e1CgjD+Ygmzv+8jaDnkrbjM73WBhg4tigUiNdnVEuweXptVH7N6bEk0eOnNJL8wYg2KrGOabCrHg8A+S7obLfY/bGfSUb2Pi+/yqjmt67I7nxCZVXvD9FcjHYvVKJsBFYmAnWjPIRx239GZZSAUxwitoi54e1YhZpn94XzG7YfUriwIvTphKZGaxf/Hw8F2ND1NTU7UGqJE4gldq0BmYuiYbyTJtOsyC2KlUZMmjXTqfuLX3dI23uQEWpB5YM7rT+Y4fNOgo0i52UX1yb6LAtLB47f9jovpDrek7y55GgEh3cW+4Iqc4cvlKOMlZ5vzOAU8p8TdpUPc/ZfYnpetVXWuq4tyo9Z5eOYcQNe1z0r+OC+Rgw5u7/oldPMaN8WPMzJGx0LFYbWzjAsEXlBX3u25C798Soppz6xZxufmCEuR3nu4KsjdhsvwtOmQqTBZ4rStSlCM5N4aO8dan+/WvJyGMDuaVF2aXBiA4/2DkEU3I8lU4SSJZTxxRU+8WF5o+idVoA6uM5qVknoYIi6A2C3TaXerLvrxHp9nBOsvXleD87HeU1UlEti4EYWg53H1TPOH3HwZj+AxfmRZZNE
 plzKu0tl
 ZtaEiwsNeiwr84iZcuFEJ8fYf4U6oFIWwFqIArO3gqdx/e+xqusYuuQKOeKqTgTobuoPrwDnzDI2fjSSQguuB7qfxXT265zG/q4ZIy6g2qqAu/gaN/O/Sqdewe1M+xr7LTLxG3e5upyJBw5mGmYcUx7w7GeQ8U66ZAsZFka6atW5MQBmK3C4HYDH5eFPY7AhlO9NlfqNTv8EJUAaupqQS+aaoqhfd38z+Yy8v2GkIoPSwwwJDdkYX6a0CfXCrdvIbVza+Eekg2caC4y5b+wWmckRkbHarUFpv1SflTFL0vNum6swBPmXpb00xoeUvjgYpfB3evydkWBjcGucxXpq8cGKBo7NeEikxf0r3e9s/RFoRA7WITy1gqM5W1xoSMY6u0QJfJuRPkFd+clzEf42WI6nHiPoJcEZgM3iz9lxUlGrqYk4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 07:45:59PM +0800, Hao Jia wrote:
> From: Hao Jia <jiahao1@lixiang.com>
> 
> Zswap currently writes back pages to backing swap reactively, triggered
> either by the shrinker or when the pool reaches its size limit. There is
> no mechanism to control the amount of writeback for a specific memory
> cgroup. However, users may want to proactively write back zswap pages,
> e.g., to free up memory for other applications or to prepare for
> memory-intensive workloads.
> 
> Introduce a "zswap_writeback_only" key to the memory.reclaim cgroup
> interface. When specified, this key bypasses standard memory reclaim
> and exclusively performs proactive zswap writeback up to the requested
> budget. If omitted, the default reclaim behavior remains unchanged.
> 
> Example usage:
>   # Write back 100MB of pages from zswap to the backing swap
>   echo "100M zswap_writeback_only" > memory.reclaim
> 
> Note that the actual amount written back may be less than requested due
> to the zswap second-chance algorithm: referenced entries are rotated on
> the LRU on the first encounter and only written back on a second pass.
> If fewer bytes are written back than requested, -EAGAIN is returned,
> matching the existing memory.reclaim semantics.
> 
> Internally, extend user_proactive_reclaim() to parse the new
> "zswap_writeback_only" token and invoke the dedicated handler. Add
> zswap_proactive_writeback() to walk the target memcg subtree via the
> per-memcg writeback cursor, draining per-node zswap LRUs through
> list_lru_walk_one() with the shrink_memcg_cb() callback.
> 
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst |  18 +++-
>  Documentation/admin-guide/mm/zswap.rst  |  11 +-
>  include/linux/zswap.h                   |   7 ++
>  mm/vmscan.c                             |  14 +++
>  mm/zswap.c                              | 138 ++++++++++++++++++++++++
>  5 files changed, 185 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 6efd0095ed99..6564abf0dec5 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1425,9 +1425,10 @@ PAGE_SIZE multiple when read back.
>  
>  The following nested keys are defined.
>  
> -	  ==========            ================================
> +	  ====================  ==================================================
>  	  swappiness            Swappiness value to reclaim with
> -	  ==========            ================================
> +	  zswap_writeback_only  Only perform proactive zswap writeback
> +	  ====================  ==================================================
>  
>  	Specifying a swappiness value instructs the kernel to perform
>  	the reclaim with that swappiness value. Note that this has the
> @@ -1437,6 +1438,19 @@ The following nested keys are defined.
>  	The valid range for swappiness is [0-200, max], setting
>  	swappiness=max exclusively reclaims anonymous memory.
>  
> +	The zswap_writeback_only key skips ordinary memory reclaim and
> +	writes back pages from zswap to the backing swap device until
> +	the requested amount has been written or no further candidates
> +	are found. This is useful to proactively offload cold pages from
> +	the zswap pool to the swap device. It is only available if
> +	zswap writeback is enabled. zswap_writeback_only cannot be combined
> +	with swappiness; specifying both returns -EINVAL.
> +
> +	Example::
> +
> +	  # Write back up to 100MB of pages from zswap to the backing swap
> +	  echo "100M zswap_writeback_only" > memory.reclaim


memcg folks need to chime in about the interface here. An alternative
would be a separate interface (e.g. memory.zswap.do_writeback or
memory.zswap.writeback.reclaim or sth).

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 73e64a635690..7bcbf788f634 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1679,6 +1679,144 @@ int zswap_load(struct folio *folio)
>  	return 0;
>  }
>  
> +/*
> + * Maximum LRU scan limit:
> + * number of entries to scan per page of remaining budget.
> + */
> +#define ZSWAP_PROACTIVE_WB_SCAN_RATIO	16UL
> +/*
> + * Batch size for proactive writeback:
> + * - As the per-memcg writeback target in the outer memcg loop.
> + * - As the per-walk budget passed to list_lru_walk_one().
> + */
> +#define ZSWAP_PROACTIVE_WB_BATCH	128UL
> +
> +/*
> + * Walk the per-node LRUs of @memcg to write back up to @nr_to_write pages.
> + * Returns the number of pages written back, or -ENOENT if @memcg is a
> + * zombie or has writeback disabled.
> + */
> +static long zswap_proactive_shrink_memcg(struct mem_cgroup *memcg,
> +					 unsigned long nr_to_write)
> +{
> +	unsigned long nr_written = 0;
> +	int nid;
> +
> +	if (!mem_cgroup_zswap_writeback_enabled(memcg))
> +		return -ENOENT;
> +
> +	if (!mem_cgroup_online(memcg))
> +		return -ENOENT;
> +
> +	for_each_node_state(nid, N_NORMAL_MEMORY) {
> +		bool encountered_page_in_swapcache = false;
> +		unsigned long nr_to_scan, nr_scanned = 0;
> +
> +		/*
> +		 * Cap by LRU length: bounds rewalks when referenced
> +		 * entries keep rotating to the tail.
> +		 */
> +		nr_to_scan = list_lru_count_one(&zswap_list_lru, nid, memcg);
> +		if (!nr_to_scan)
> +			continue;
> +
> +		/*
> +		 * Cap by SCAN_RATIO * remaining budget: bounds scan cost
> +		 * to the remaining writeback budget.
> +		 */
> +		nr_to_scan = min(nr_to_scan,
> +				 (nr_to_write - nr_written) * ZSWAP_PROACTIVE_WB_SCAN_RATIO);
> +
> +		while (nr_scanned < nr_to_scan) {
> +			unsigned long nr_to_walk = min(ZSWAP_PROACTIVE_WB_BATCH,
> +						       nr_to_scan - nr_scanned);
> +
> +			if (signal_pending(current))
> +				return nr_written;
> +
> +			/*
> +			 * Account for the committed budget rather than the walker's
> +			 * actual delta. If the list is emptied concurrently, the
> +			 * walker visits nothing and nr_scanned would never advance.
> +			 */
> +			nr_scanned += nr_to_walk;
> +
> +			nr_written += list_lru_walk_one(&zswap_list_lru, nid, memcg,
> +							&shrink_memcg_cb,
> +							&encountered_page_in_swapcache,
> +							&nr_to_walk);
> +
> +			if (nr_written >= nr_to_write)
> +				return nr_written;
> +			if (encountered_page_in_swapcache)
> +				break;
> +
> +			cond_resched();
> +		}
> +	}
> +
> +	return nr_written;
> +}
> +
> +int zswap_proactive_writeback(struct mem_cgroup *memcg,
> +			      unsigned long nr_to_writeback)
> +{
> +	struct mem_cgroup *iter_memcg;
> +	unsigned long nr_written = 0;
> +	int failures = 0, attempts = 0;
> +
> +	if (!memcg)
> +		return -EINVAL;
> +	if (!nr_to_writeback)
> +		return 0;
> +
> +	/*
> +	 * Writeback will be aborted with -EAGAIN if we encounter
> +	 * the following MAX_RECLAIM_RETRIES times:
> +	 * - No writeback-candidate memcgs found in a subtree walk.
> +	 * - A writeback-candidate memcg wrote back zero pages.
> +	 */
> +	while (nr_written < nr_to_writeback) {
> +		unsigned long batch_size;
> +		long shrunk;
> +
> +		if (signal_pending(current))
> +			return -EINTR;
> +
> +		iter_memcg = zswap_mem_cgroup_iter(memcg);
> +
> +		if (!iter_memcg) {
> +			/*
> +			 * Continue without incrementing failures if we found
> +			 * candidate memcgs in the last subtree walk.
> +			 */
> +			if (!attempts && ++failures == MAX_RECLAIM_RETRIES)
> +				return -EAGAIN;
> +			attempts = 0;
> +			continue;
> +		}
> +
> +		batch_size = min(nr_to_writeback - nr_written,
> +				 ZSWAP_PROACTIVE_WB_BATCH);
> +		shrunk = zswap_proactive_shrink_memcg(iter_memcg, batch_size);
> +		mem_cgroup_put(iter_memcg);
> +
> +		/* Writeback-disabled or offline: skip without counting. */
> +		if (shrunk == -ENOENT)
> +			continue;
> +
> +		++attempts;
> +		if (shrunk > 0)
> +			nr_written += shrunk;
> +		else if (++failures == MAX_RECLAIM_RETRIES)
> +			return -EAGAIN;
> +
> +		cond_resched();
> +	}
> +
> +	return 0;
> +}
> +

There is a lot of copy+paste from shrink_worker() and shrink_memcg()
here. We really should be able to reuse shrink_memcg().

Is the main difference that we are scanning in batches here? I think we
can have shrink_memcg() do that too. If anything, it might make the
shrinker more efficient. Over-reclaim is ofc a concern, and especially
in the zswap_store() path as the overhead can be noticeable. Maybe we
can parameterize the batch size based on the code path.

Nhat, what do you think?

