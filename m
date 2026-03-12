Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A0C71125867
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 13:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600A46B0089; Thu, 12 Mar 2026 09:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1036B008A; Thu, 12 Mar 2026 09:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0B76B008C; Thu, 12 Mar 2026 09:40:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE0D6B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:40:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC2668A6BE
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:40:27 +0000 (UTC)
X-FDA: 84537520494.03.F267BFD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C8D041C0019
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:40:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U9s93MWZ;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773322825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DCar/iJnA8frP5c0RzMTlGjBCoiPgfz37uIFkRiWsN4=;
	b=2eagTbK9VAKB6+ys2jhC2CjGdKwRnZN2hmBrUJFYrLYWARXJG7vYjhhboh5cWLRiN8IxdA
	WsxRAStSxfroJSWDZvVahFo40re4ey2CHJJ+D7Tp2XxMlrdpA4KAOO+us68kYIZKCJw9XP
	VKU1FExd39TxjgKdEZPV744s/A08XaM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773322825; a=rsa-sha256;
	cv=none;
	b=seceGOw7+lrH3ekMWKX/1C9sCfRis3xH8hHNcWwDgQx91ig5lCO+58BXr+2k/kSgBYhSce
	m0rpWnw995c5v+Nw5i5oKA7SpfUBeG5EQgYJKd5TvxfBQj7z2N4epYjrHaPnOB95QqFCHA
	HXp9zYMXZgjekEOA4O1wIPhkQCM3hzs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U9s93MWZ;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FEA460131;
	Thu, 12 Mar 2026 13:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B60C19424;
	Thu, 12 Mar 2026 13:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773322824;
	bh=bJ/FJZ5A5ABznD3gU1iqfOJTIvGzpAFjUy3xCqCvego=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U9s93MWZmg2ZJqu5UyKbC/QKGTnuHMlQIllu9gvx5i8Ds1oVAvP1sUye2GcPkEHmf
	 sdv4AdCYhTAttzvKMQOTckfuOsc7NCtUmd2vPli1EZ8kAXxpDyDHQ3wv8vgxBsoHlw
	 2FGJ6Q/ue+w5wmLeXlSsj23uVV+VtxyYulHyIHWCgj+5hO+YDjQ/sgvTCSyUhYSQab
	 Zxs8BpJ/D8alLYqcmtFp8XW74D/gM3A4ItededFvePFk4JOtQsEZSd3OZnIgPlQQTS
	 fhQGXPa+zKGkx7FxrFphRZX5/8AdU9qqBTx3WQgLoN65wqPdpXHvDnDeOQtJ26DGyR
	 KA/EuXdToFQBg==
Message-ID: <3a42463b-9ddd-4d64-b64c-6c2e6e4fc75d@kernel.org>
Date: Thu, 12 Mar 2026 14:40:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
Content-Language: en-US
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>, linux-mm@kvack.org,
 akpm@linux-foundation.org, mhocko@suse.com
Cc: apopple@nvidia.com, axelrasmussen@google.com, byungchul@sk.com,
 cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com,
 gourry@gourry.net, jasowang@redhat.com, hannes@cmpxchg.org,
 joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, ying.huang@linux.alibaba.com,
 yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260307045520.247998-1-jp.kobryn@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C8D041C0019
X-Stat-Signature: xe1kmfeqzpusq1j6xhiepxkfiic5asy6
X-Rspam-User: 
X-HE-Tag: 1773322825-445776
X-HE-Meta: U2FsdGVkX18PqhUbd8op7YWg8A/lAjmrmAzYh7jgqKhoeBznGRoXsNIiiAwukSlvrxmVU3SYjWx4ZpJathb3+gxfs77gqYCpK5FP+vMOTcIuBL31Xq1j1To98dv9rLQThWpqKZlA+mrcCdlHEh3SUAAZ5D/E8qiqwyuVdnTPss9OtwbaQ7NBT4gBgC7t3zlKUjzpHBdParF312LNVm22zPWqaMTokd0CBqkse15MbEheSFTmG6U+NmkJoRc0sDjMCkry5I/pliQaGvA1LvF/AfBpAy1/3A+Y/tOOGl1XRQcdbkzBtHModuHSSTm6Pzx6YME3VdwzWd6C+6gfI46zA8FAfO6Jx3NZvzVqDSmxEhk11jiG6MPg6o1wSZNlsuUaH46BFsMLqnBqDJBkJfmSGCKrWYxHS5YvZ20gtlY3GRJTPcniPDdWoVOVqZOXoQfkNOOmer37gqwjDZHYU9ioiTV8jvbwNhB610/thNsJF91bmcEGlucG5qMbLhJ7ej9dksdTZ/MMeWj/TTVHeMz8mzUhqc+0UGUdQRLuMplH0eLaRuz6anJeJDxAasPI502S/8rwFMdcdX15oCHVzBW4STR+gqkqyUP67fRKE6Mcjm5NGuiOSkueYBBs6n5uOHl+plnpYsUbdoRO9pwtlF97gNeawg4jS9Brcqry8gV3W3BZ8/aLpN1d6eZtNNid8V4G6mdndnKnYCifjAZCna91n/2Uqs9G1xDAMf3STmFb4GNj/sq1ToyXimSMXKrsJIs8GxhBTY8klmRCTyqiIBRaTf5C/plW9i+EdYPUMunnVeOVOQKGtHj+tnIFTwSQkGW7PgshVWXwDdYnZmK4g7+GQV8JQBXOFceO8aZ9G6Yc4pLWQ7A45S5543VnlKd9avTkrF0gHIybIziH+Xgds3GpJz0zMA6hVI3VJUFL+yNXh6/I474+9jsanZ90YgNkhtBvUNETWdOZt3OmbjtXDO5
 NLyEpFkf
 4ue2jbKxOqB1+wd6EKuzDzeXXWTUNyFJtsH+414BvzNvLDrAT122QZbdloiQcsH5Z3UpSS5S0ogZe78lEf3D32RbOcKpp6K7990n+mI3BiP6gbWsf+jmMj7rvPP+nqcteKM5ojld3N/TUGsnnMIzEkizAS9YyLTRn5ZMFzj/c/TEHlaG1NkkTPV6dA7fCcrpftHCPMfde5tCRclpmVWoxuQYreja5HpSxKeyA2AApTu3Y9GtnuRPIFjiUU+qj/zEWA53NooPR5oJJZPUp85cJm8ZUjcy5e4qSjJY3aIPp+SOf4wVA1wc4b5oWEGT0N6S289lw56vSxDejVCbNRH18SVfaeNTcK1b9RWImKQCc2m8HHtW6f9FrEhKQIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/7/26 05:55, JP Kobryn (Meta) wrote:
> When investigating pressure on a NUMA node, there is no straightforward way
> to determine which policies are driving allocations to it.
> 
> Add per-policy page allocation counters as new node stat items. These
> counters track allocations to nodes and also whether the allocations were
> intentional or fallbacks.
> 
> The new stats follow the existing numa hit/miss/foreign style and have the
> following meanings:
> 
>   hit
>     - for BIND and PREFERRED_MANY, allocation succeeded on node in nodemask
>     - for other policies, allocation succeeded on intended node
>     - counted on the node of the allocation
>   miss
>     - allocation intended for other node, but happened on this one
>     - counted on other node
>   foreign
>     - allocation intended on this node, but happened on other node
>     - counted on this node
> 
> Counters are exposed per-memcg, per-node in memory.numa_stat and globally
> in /proc/vmstat.
> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>

I think I've been on of the folks on previous versions arguing against the
many counters, and one of the arguments was it they can't tell the full
story anyway (compared to e.g. tracing), but I don't think adding even more
counters is the right solution. Seems like a number of other people
responding to the thread are providing similar feedback.

For example I'm still not sure how it would help me if I knew the
hits/misses were due to a preferred vs preferred_many policy, or interleave
vs weithed interleave?

> ---
> v2:
>   - Replaced single per-policy total counter (PGALLOC_MPOL_*) with
>     hit/miss/foreign triplet per policy
>   - Changed from global node stats to per-memcg per-node tracking
> 
> v1:
> https://lore.kernel.org/linux-mm/20260212045109.255391-2-inwardvessel@gmail.com/
> 
>  include/linux/mmzone.h | 20 ++++++++++
>  mm/memcontrol.c        | 60 ++++++++++++++++++++++++++++
>  mm/mempolicy.c         | 90 ++++++++++++++++++++++++++++++++++++++++--
>  mm/vmstat.c            | 20 ++++++++++
>  4 files changed, 187 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7bd0134c241c..c0517cbcb0e2 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -323,6 +323,26 @@ enum node_stat_item {
>  	PGSCAN_ANON,
>  	PGSCAN_FILE,
>  	PGREFILL,
> +#ifdef CONFIG_NUMA
> +	NUMA_MPOL_LOCAL_HIT,
> +	NUMA_MPOL_LOCAL_MISS,
> +	NUMA_MPOL_LOCAL_FOREIGN,
> +	NUMA_MPOL_PREFERRED_HIT,
> +	NUMA_MPOL_PREFERRED_MISS,
> +	NUMA_MPOL_PREFERRED_FOREIGN,
> +	NUMA_MPOL_PREFERRED_MANY_HIT,
> +	NUMA_MPOL_PREFERRED_MANY_MISS,
> +	NUMA_MPOL_PREFERRED_MANY_FOREIGN,
> +	NUMA_MPOL_BIND_HIT,
> +	NUMA_MPOL_BIND_MISS,
> +	NUMA_MPOL_BIND_FOREIGN,
> +	NUMA_MPOL_INTERLEAVE_HIT,
> +	NUMA_MPOL_INTERLEAVE_MISS,
> +	NUMA_MPOL_INTERLEAVE_FOREIGN,
> +	NUMA_MPOL_WEIGHTED_INTERLEAVE_HIT,
> +	NUMA_MPOL_WEIGHTED_INTERLEAVE_MISS,
> +	NUMA_MPOL_WEIGHTED_INTERLEAVE_FOREIGN,
> +#endif
>  #ifdef CONFIG_HUGETLB_PAGE
>  	NR_HUGETLB,
>  #endif
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 982231a078f2..4d29f723a2de 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -420,6 +420,26 @@ static const unsigned int memcg_node_stat_items[] = {
>  	PGSCAN_ANON,
>  	PGSCAN_FILE,
>  	PGREFILL,
> +#ifdef CONFIG_NUMA
> +	NUMA_MPOL_LOCAL_HIT,
> +	NUMA_MPOL_LOCAL_MISS,
> +	NUMA_MPOL_LOCAL_FOREIGN,
> +	NUMA_MPOL_PREFERRED_HIT,
> +	NUMA_MPOL_PREFERRED_MISS,
> +	NUMA_MPOL_PREFERRED_FOREIGN,
> +	NUMA_MPOL_PREFERRED_MANY_HIT,
> +	NUMA_MPOL_PREFERRED_MANY_MISS,
> +	NUMA_MPOL_PREFERRED_MANY_FOREIGN,
> +	NUMA_MPOL_BIND_HIT,
> +	NUMA_MPOL_BIND_MISS,
> +	NUMA_MPOL_BIND_FOREIGN,
> +	NUMA_MPOL_INTERLEAVE_HIT,
> +	NUMA_MPOL_INTERLEAVE_MISS,
> +	NUMA_MPOL_INTERLEAVE_FOREIGN,
> +	NUMA_MPOL_WEIGHTED_INTERLEAVE_HIT,
> +	NUMA_MPOL_WEIGHTED_INTERLEAVE_MISS,
> +	NUMA_MPOL_WEIGHTED_INTERLEAVE_FOREIGN,
> +#endif
>  #ifdef CONFIG_HUGETLB_PAGE
>  	NR_HUGETLB,
>  #endif
> @@ -1591,6 +1611,26 @@ static const struct memory_stat memory_stats[] = {
>  #ifdef CONFIG_NUMA_BALANCING
>  	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
>  #endif
> +#ifdef CONFIG_NUMA
> +	{ "numa_mpol_local_hit",		NUMA_MPOL_LOCAL_HIT		},
> +	{ "numa_mpol_local_miss",		NUMA_MPOL_LOCAL_MISS		},
> +	{ "numa_mpol_local_foreign",		NUMA_MPOL_LOCAL_FOREIGN		},
> +	{ "numa_mpol_preferred_hit",		NUMA_MPOL_PREFERRED_HIT		},
> +	{ "numa_mpol_preferred_miss",		NUMA_MPOL_PREFERRED_MISS	},
> +	{ "numa_mpol_preferred_foreign",	NUMA_MPOL_PREFERRED_FOREIGN	},
> +	{ "numa_mpol_preferred_many_hit",	NUMA_MPOL_PREFERRED_MANY_HIT	},
> +	{ "numa_mpol_preferred_many_miss",	NUMA_MPOL_PREFERRED_MANY_MISS	},
> +	{ "numa_mpol_preferred_many_foreign",	NUMA_MPOL_PREFERRED_MANY_FOREIGN },
> +	{ "numa_mpol_bind_hit",			NUMA_MPOL_BIND_HIT		},
> +	{ "numa_mpol_bind_miss",		NUMA_MPOL_BIND_MISS		},
> +	{ "numa_mpol_bind_foreign",		NUMA_MPOL_BIND_FOREIGN		},
> +	{ "numa_mpol_interleave_hit",		NUMA_MPOL_INTERLEAVE_HIT	},
> +	{ "numa_mpol_interleave_miss",		NUMA_MPOL_INTERLEAVE_MISS	},
> +	{ "numa_mpol_interleave_foreign",	NUMA_MPOL_INTERLEAVE_FOREIGN	},
> +	{ "numa_mpol_weighted_interleave_hit",	NUMA_MPOL_WEIGHTED_INTERLEAVE_HIT },
> +	{ "numa_mpol_weighted_interleave_miss",	NUMA_MPOL_WEIGHTED_INTERLEAVE_MISS },
> +	{ "numa_mpol_weighted_interleave_foreign", NUMA_MPOL_WEIGHTED_INTERLEAVE_FOREIGN },
> +#endif
>  };
>  
>  /* The actual unit of the state item, not the same as the output unit */
> @@ -1642,6 +1682,26 @@ static int memcg_page_state_output_unit(int item)
>  	case PGREFILL:
>  #ifdef CONFIG_NUMA_BALANCING
>  	case PGPROMOTE_SUCCESS:
> +#endif
> +#ifdef CONFIG_NUMA
> +	case NUMA_MPOL_LOCAL_HIT:
> +	case NUMA_MPOL_LOCAL_MISS:
> +	case NUMA_MPOL_LOCAL_FOREIGN:
> +	case NUMA_MPOL_PREFERRED_HIT:
> +	case NUMA_MPOL_PREFERRED_MISS:
> +	case NUMA_MPOL_PREFERRED_FOREIGN:
> +	case NUMA_MPOL_PREFERRED_MANY_HIT:
> +	case NUMA_MPOL_PREFERRED_MANY_MISS:
> +	case NUMA_MPOL_PREFERRED_MANY_FOREIGN:
> +	case NUMA_MPOL_BIND_HIT:
> +	case NUMA_MPOL_BIND_MISS:
> +	case NUMA_MPOL_BIND_FOREIGN:
> +	case NUMA_MPOL_INTERLEAVE_HIT:
> +	case NUMA_MPOL_INTERLEAVE_MISS:
> +	case NUMA_MPOL_INTERLEAVE_FOREIGN:
> +	case NUMA_MPOL_WEIGHTED_INTERLEAVE_HIT:
> +	case NUMA_MPOL_WEIGHTED_INTERLEAVE_MISS:
> +	case NUMA_MPOL_WEIGHTED_INTERLEAVE_FOREIGN:
>  #endif
>  		return 1;
>  	default:
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 0e5175f1c767..2417de75098d 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -117,6 +117,7 @@
>  #include <asm/tlb.h>
>  #include <linux/uaccess.h>
>  #include <linux/memory.h>
> +#include <linux/memcontrol.h>
>  
>  #include "internal.h"
>  
> @@ -2426,6 +2427,83 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
>  	return page;
>  }
>  
> +/*
> + * Count a mempolicy allocation. Stats are tracked per-node and per-cgroup.
> + * The following numa_{hit/miss/foreign} pattern is used:
> + *
> + *   hit
> + *     - for BIND and PREFERRED_MANY, allocation succeeded on node in nodemask
> + *     - for other policies, allocation succeeded on intended node
> + *     - counted on the node of the allocation
> + *   miss
> + *     - allocation intended for other node, but happened on this one
> + *     - counted on other node
> + *   foreign
> + *     - allocation intended on this node, but happened on other node
> + *     - counted on this node
> + */
> +static void mpol_count_numa_alloc(struct mempolicy *pol, int intended_nid,
> +				  struct page *page, unsigned int order)
> +{
> +	int actual_nid = page_to_nid(page);
> +	long nr_pages = 1L << order;
> +	enum node_stat_item hit_idx;
> +	struct mem_cgroup *memcg;
> +	struct lruvec *lruvec;
> +	bool is_hit;
> +
> +	if (!root_mem_cgroup || mem_cgroup_disabled())
> +		return;
> +
> +	/*
> +	 * Start with hit then use +1 or +2 later on to change to miss or
> +	 * foreign respectively if needed.
> +	 */
> +	switch (pol->mode) {
> +	case MPOL_PREFERRED:
> +		hit_idx = NUMA_MPOL_PREFERRED_HIT;
> +		break;
> +	case MPOL_PREFERRED_MANY:
> +		hit_idx = NUMA_MPOL_PREFERRED_MANY_HIT;
> +		break;
> +	case MPOL_BIND:
> +		hit_idx = NUMA_MPOL_BIND_HIT;
> +		break;
> +	case MPOL_INTERLEAVE:
> +		hit_idx = NUMA_MPOL_INTERLEAVE_HIT;
> +		break;
> +	case MPOL_WEIGHTED_INTERLEAVE:
> +		hit_idx = NUMA_MPOL_WEIGHTED_INTERLEAVE_HIT;
> +		break;
> +	default:
> +		hit_idx = NUMA_MPOL_LOCAL_HIT;
> +		break;
> +	}
> +
> +	if (pol->mode == MPOL_BIND || pol->mode == MPOL_PREFERRED_MANY)
> +		is_hit = node_isset(actual_nid, pol->nodes);
> +	else
> +		is_hit = (actual_nid == intended_nid);
> +
> +	rcu_read_lock();
> +	memcg = mem_cgroup_from_task(current);
> +
> +	if (is_hit) {
> +		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(actual_nid));
> +		mod_lruvec_state(lruvec, hit_idx, nr_pages);
> +	} else {
> +		/* account for miss on the fallback node */
> +		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(actual_nid));
> +		mod_lruvec_state(lruvec, hit_idx + 1, nr_pages);
> +
> +		/* account for foreign on the intended node */
> +		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(intended_nid));
> +		mod_lruvec_state(lruvec, hit_idx + 2, nr_pages);
> +	}
> +
> +	rcu_read_unlock();
> +}
> +
>  /**
>   * alloc_pages_mpol - Allocate pages according to NUMA mempolicy.
>   * @gfp: GFP flags.
> @@ -2444,8 +2522,10 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>  
>  	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
>  
> -	if (pol->mode == MPOL_PREFERRED_MANY)
> -		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
> +	if (pol->mode == MPOL_PREFERRED_MANY) {
> +		page = alloc_pages_preferred_many(gfp, order, nid, nodemask);
> +		goto out;
> +	}
>  
>  	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>  	    /* filter "hugepage" allocation, unless from alloc_pages() */
> @@ -2471,7 +2551,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>  				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
>  				nid, NULL);
>  			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
> -				return page;
> +				goto out;
>  			/*
>  			 * If hugepage allocations are configured to always
>  			 * synchronous compact or the vma has been madvised
> @@ -2494,6 +2574,10 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>  		}
>  	}
>  
> +out:
> +	if (page)
> +		mpol_count_numa_alloc(pol, nid, page, order);
> +
>  	return page;
>  }
>  
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index b33097ab9bc8..d9f745831624 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1291,6 +1291,26 @@ const char * const vmstat_text[] = {
>  	[I(PGSCAN_ANON)]			= "pgscan_anon",
>  	[I(PGSCAN_FILE)]			= "pgscan_file",
>  	[I(PGREFILL)]				= "pgrefill",
> +#ifdef CONFIG_NUMA
> +	[I(NUMA_MPOL_LOCAL_HIT)]		= "numa_mpol_local_hit",
> +	[I(NUMA_MPOL_LOCAL_MISS)]		= "numa_mpol_local_miss",
> +	[I(NUMA_MPOL_LOCAL_FOREIGN)]		= "numa_mpol_local_foreign",
> +	[I(NUMA_MPOL_PREFERRED_HIT)]		= "numa_mpol_preferred_hit",
> +	[I(NUMA_MPOL_PREFERRED_MISS)]		= "numa_mpol_preferred_miss",
> +	[I(NUMA_MPOL_PREFERRED_FOREIGN)]	= "numa_mpol_preferred_foreign",
> +	[I(NUMA_MPOL_PREFERRED_MANY_HIT)]	= "numa_mpol_preferred_many_hit",
> +	[I(NUMA_MPOL_PREFERRED_MANY_MISS)]	= "numa_mpol_preferred_many_miss",
> +	[I(NUMA_MPOL_PREFERRED_MANY_FOREIGN)]	= "numa_mpol_preferred_many_foreign",
> +	[I(NUMA_MPOL_BIND_HIT)]			= "numa_mpol_bind_hit",
> +	[I(NUMA_MPOL_BIND_MISS)]		= "numa_mpol_bind_miss",
> +	[I(NUMA_MPOL_BIND_FOREIGN)]		= "numa_mpol_bind_foreign",
> +	[I(NUMA_MPOL_INTERLEAVE_HIT)]		= "numa_mpol_interleave_hit",
> +	[I(NUMA_MPOL_INTERLEAVE_MISS)]		= "numa_mpol_interleave_miss",
> +	[I(NUMA_MPOL_INTERLEAVE_FOREIGN)]	= "numa_mpol_interleave_foreign",
> +	[I(NUMA_MPOL_WEIGHTED_INTERLEAVE_HIT)]	= "numa_mpol_weighted_interleave_hit",
> +	[I(NUMA_MPOL_WEIGHTED_INTERLEAVE_MISS)]	= "numa_mpol_weighted_interleave_miss",
> +	[I(NUMA_MPOL_WEIGHTED_INTERLEAVE_FOREIGN)] = "numa_mpol_weighted_interleave_foreign",
> +#endif
>  #ifdef CONFIG_HUGETLB_PAGE
>  	[I(NR_HUGETLB)]				= "nr_hugetlb",
>  #endif


