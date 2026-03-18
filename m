Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E09E1077617
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 028AE6B0315; Wed, 18 Mar 2026 16:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4ED6B0316; Wed, 18 Mar 2026 16:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D958C6B0317; Wed, 18 Mar 2026 16:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C31E46B0315
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:25:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 656BD1390D2
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:25:26 +0000 (UTC)
X-FDA: 84560313852.20.83026E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 89A3D140016
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:25:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Axa2bfrR;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773865524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bukDbMZbEtVa4Eav7k6MP5pU3zwKbPcddu/zzByWQys=;
	b=x3ebrorxgJJqgsTUHCkfJGAuAt0V/pUFf6wtML2OVvnMudx4klHNQ1NAkhwu2LlACXuOFH
	J6zltdtNGr8JeS8v4d2IEcIFaq+mH4sUcbJqptbgV9EjlpCTveowACgGEWq35sg6kxH9eH
	ljSwXI/HlBsgvBjdsQ+GkpdTfvw3uSc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Axa2bfrR;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773865524; a=rsa-sha256;
	cv=none;
	b=lyfr/h19ixK4a8qBYvNyXHpgCUfL7R0/rRwC3bPGZN5KZt0E7drTV7gFoXtQDmdr9/79gD
	rNxNTRh1F+w41lcz16ysIJtv0OTwnUiZ4S7FHmgNjEkOD/A0wAiGQCsmtdTbaitnSdv6MZ
	V4LUN8dN/sIv1hzcTe3lVjI3WooeWXo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FDA44424F;
	Wed, 18 Mar 2026 20:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E86C19421;
	Wed, 18 Mar 2026 20:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773865523;
	bh=mdvbQ1tn7ST4LxwKLY9jxhU4Fn365EEeLx0lD1neL3I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Axa2bfrR+vFXIn2OLHz5yzvI8zsrqvlpYIiRcZlfngiCW0CtrIuol0gm+Ro2gmT9J
	 DVO68Xz4neacd/yVCLpdAbNtDgcivQVKdbFYpUHSQl3eQVEKFmsLDspTnpwHV1O5ed
	 3Jr/JyxK84pWs+MGBEcsRLxX2+cUWRImJwlnMvReLphGJ9IZjGn32CxvK8bgAjpGpn
	 gzgxm7zA1H7gJqKv5o7NcFHPo8FzdTtfGRtMhq96YDP6Eazd560lR38exv1Nu9InLq
	 SSrSGOIKV7Ori6NRExhZ3KfGIOHpOoM2tqJ5NOXOomU64HIqI2N+rfqD2IBntmXeN3
	 zTWX0+Uare4yQ==
Message-ID: <61d86249-cd89-4e99-99d8-ab7c72e95f34@kernel.org>
Date: Wed, 18 Mar 2026 21:25:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] mm: switch deferred split shrinker to list_lru
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed
 <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-8-hannes@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260312205321.638053-8-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 89A3D140016
X-Stat-Signature: 6dg4ckcppiqm9usk14axrwcyaehuat6s
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773865524-427643
X-HE-Meta: U2FsdGVkX1/vJ70hDwoxH63GmW0pnfgzjHFoZiiyd5EB1QAhT1rH0ntKNx4z9WHEfFVorrGBDqlHVPDO8v6/cI0ahlIVRPILB6bGBZwfRKNhH2eAYrvBenvx2cIIjlBDO5/Jfnm9jS5FOp7lxr1gQp4uYyOFMdvfiD/BHqP6HuXSiSXbjI6rSRulQGfFoObi9rvSuv24xKHlJIOtLU7YxPp8GL1Aj54gWBB8rFHEyzxJk6XqXFA5eYfTBoQjD1FNZm4e1QAxVzm7SyoIbECIOAB8JqK1+nXE8e4d5VbbKA4UiZqhft6MxK0AkGXIB13EPR8eyWa/P08yEeBn2p85D53GqG2ZW6WP/RPMrRIBW3bqK0pALYUyDlVu1CwYWdW6EuMoDKBBweicv93Q8o8sQXWtgUsO48QwfRIyKFtxjhHSoPYa9lsFwMO7vH8yQDilr3VZdTFMX7vm+vfXtXO8iG8+pC4T+wopZBX7G0P7New3u4anMaX9TPw7OBgczFBoKR6wsTaVB4bnGek2w43laHaPLwPyBaOrRMfBn53Q1DWgPL5UbGPPFcfs5SDz7is5heQOD9e3HUIMsVXv9I3a4M8Ch/XmNxzYQc/Gr/Ah1RnPbNV1Bl9HEY3xy1H8WYxReq7HHNrACjlMtTSq0dcs9Lm36z129AWrlTGl3zLB7/+00zu29wL02OuK1sy8b3dQlRZ1nUn7hllQo+eOWIS01wKlpS7ANsRiyibXqTZwOybFS9WIuKga9X0wRHzQmjr6yIWi35xyeuN1l3VXn/aobqYK3DHwmQGDdPY8xSFEVuaCqGc/3nDLgMd7CzX6dFGVE4Wssn7g/fgna1CgFfpUkBZ+F6O1xVnD/dJTaJChheeBmfa6WHkmgqub9QeJ2R4Geyr/FDE9u+5Zm08YdaeQofNIyhLk0NOwIQL0v33GlJsKDw9oKOqFB+gyzlYCREV2HQy1r/EeITxGvFz7sCs
 sHgG7YvY
 MRDC78cbuM0oVvzLHSwhjRO2vGuHh4WxgR3G3ueacv3eQ6MMhj689evo+QNldtxRZ8CChikHg4qFUHYT9QXQImR3pBZJRSj2YvsZJHPrO9jVxMrygT4xkMFW7PE7wdmza7pQq/95YMdvRZGqwFjKsaXwHLztMQ0iUZ1YrQvE40Kec8qcEMjJzI/rZu3jHmrUEUEOzi4L7bxsfs13f7BFc0DHppj1LTuGqrvc8U1q2f2417GMWjrz4to3fWMWtTmbiIw8SiFKszFLAHBsZ9K05oqOAxBZhaNWQNt2Sd5xNuRrEKsyq6hWkIGzfyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 21:51, Johannes Weiner wrote:
> The deferred split queue handles cgroups in a suboptimal fashion. The
> queue is per-NUMA node or per-cgroup, not the intersection. That means
> on a cgrouped system, a node-restricted allocation entering reclaim
> can end up splitting large pages on other nodes:
> 
> 	alloc/unmap
> 	  deferred_split_folio()
> 	    list_add_tail(memcg->split_queue)
> 	    set_shrinker_bit(memcg, node, deferred_shrinker_id)
> 
> 	for_each_zone_zonelist_nodemask(restricted_nodes)
> 	  mem_cgroup_iter()
> 	    shrink_slab(node, memcg)
> 	      shrink_slab_memcg(node, memcg)
> 	        if test_shrinker_bit(memcg, node, deferred_shrinker_id)
> 	          deferred_split_scan()
> 	            walks memcg->split_queue
> 
> The shrinker bit adds an imperfect guard rail. As soon as the cgroup
> has a single large page on the node of interest, all large pages owned
> by that memcg, including those on other nodes, will be split.
> 
> list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
> streamlines a lot of the list operations and reclaim walks. It's used
> widely by other major shrinkers already. Convert the deferred split
> queue as well.
> 
> The list_lru per-memcg heads are instantiated on demand when the first
> object of interest is allocated for a cgroup, by calling
> memcg_list_lru_alloc_folio(). Add calls to where splittable pages are
> created: anon faults, swapin faults, khugepaged collapse.
> 
> These calls create all possible node heads for the cgroup at once, so
> the migration code (between nodes) doesn't need any special care.


[...]

> -
>  static inline bool is_transparent_hugepage(const struct folio *folio)
>  {
>  	if (!folio_test_large(folio))
> @@ -1293,6 +1189,14 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
>  		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
>  		return NULL;
>  	}
> +
> +	if (memcg_list_lru_alloc_folio(folio, &deferred_split_lru, gfp)) {
> +		folio_put(folio);
> +		count_vm_event(THP_FAULT_FALLBACK);
> +		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
> +		return NULL;
> +	}

So, in all anon alloc paths, we essentialy have

1) vma_alloc_folio / __folio_alloc (khugepaged being odd)
2) mem_cgroup_charge / mem_cgroup_swapin_charge_folio
3) memcg_list_lru_alloc_folio

I wonder if we could do better in most cases and have something like a

	vma_alloc_anon_folio()

That wraps the vma_alloc_folio() + memcg_list_lru_alloc_folio(), but
still leaves the charging to the caller?

The would at least combine 1) and 3) in a single API. (except for the
odd cases without a VMA).

I guess we would want to skip the memcg_list_lru_alloc_folio() for
order-0 folios, correct?

> +
>  	folio_throttle_swaprate(folio, gfp);
>  
>         /*
> @@ -3802,33 +3706,28 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  	struct folio *new_folio, *next;
>  	int old_order = folio_order(folio);
>  	int ret = 0;
> -	struct deferred_split *ds_queue;
> +	struct list_lru_one *l;
>  
>  	VM_WARN_ON_ONCE(!mapping && end);
>  	/* Prevent deferred_split_scan() touching ->_refcount */
> -	ds_queue = folio_split_queue_lock(folio);
> +	rcu_read_lock();

The RCU lock is for the folio_memcg(), right?

I recall I raised in the past that some get/put-like logic (that wraps
the rcu_read_lock() + folio_memcg()) might make this a lot easier to get.


memcg = folio_memcg_lookup(folio)

... do stuff

folio_memcg_putback(folio, memcg);

Or sth like that.


Alternativey, you could have some helpers that do the
list_lru_lock+unlock etc.

folio_memcg_list_lru_lock()
...
folio_memcg_list_ru_unlock(l);

Just some thoughts as inspiration :)

> +	l = list_lru_lock(&deferred_split_lru, folio_nid(folio), folio_memcg(folio));
>  	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
>  		struct swap_cluster_info *ci = NULL;
>  		struct lruvec *lruvec;
>  
>  		if (old_order > 1) {
> -			if (!list_empty(&folio->_deferred_list)) {
> -				ds_queue->split_queue_len--;
> -				/*
> -				 * Reinitialize page_deferred_list after removing the
> -				 * page from the split_queue, otherwise a subsequent
> -				 * split will see list corruption when checking the
> -				 * page_deferred_list.
> -				 */
> -				list_del_init(&folio->_deferred_list);
> -			}
> +			__list_lru_del(&deferred_split_lru, l,
> +				       &folio->_deferred_list, folio_nid(folio));
>  			if (folio_test_partially_mapped(folio)) {
>  				folio_clear_partially_mapped(folio);
>  				mod_mthp_stat(old_order,
>  					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>  			}
>  		}
> -		split_queue_unlock(ds_queue);
> +		list_lru_unlock(l);
> +		rcu_read_unlock();
> +
>  		if (mapping) {

[...]

Most changes here look mostly mechanically, quite nice. I'll probably
have to go over some bits once again with a fresh mind :)

-- 
Cheers,

David

