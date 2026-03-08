Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADAA6EA8543
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 19:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCFEE6B0005; Sun,  8 Mar 2026 15:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7D856B0089; Sun,  8 Mar 2026 15:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B51F66B008A; Sun,  8 Mar 2026 15:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A39D76B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 15:24:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36468B9C0B
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 19:24:51 +0000 (UTC)
X-FDA: 84523873182.27.A618B60
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5D0D12000B
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 19:24:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nbczan9v;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772997889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLcu0fphvFRBibme+sjG1mlApoH3lh7i3XFkoIx+9Xc=;
	b=8oXIyBT2O4Jjw7G1gRI6cBdisVbWaxTHUNfZiFFsTcF2jGHAn02vjOeZ7sT/lsILbivGke
	t7Tribu4RXLWctZeyahcQP889P11rk4epevJl6BSymnZBlNJ9w/UVR4a4iIswKaMsYXamp
	eqjsF1I/94HOh6GD5kEoQoTT8GtWuY0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nbczan9v;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772997889; a=rsa-sha256;
	cv=none;
	b=Oy2LJqEftHQlf2l9s4Cmt+SWIe2QDSeThA9Yer5G0Vp3NX8hxYrlfwwnk6LHGO+3T7NkxC
	wKw3L1W1bqwG3jEqEGLbYD6v7pMe1zHiKLHapovHrtqr/5REnIZjkpnX3gMC00XRHDvp1m
	IDNQv40I911nmms0jzG0IKBIaetASz4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772997886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XLcu0fphvFRBibme+sjG1mlApoH3lh7i3XFkoIx+9Xc=;
	b=nbczan9v0PbngnzTGOea/ulR27TTsXOkhvO8YSZ8at9w5NpJUJPI7tUlzC6RAQy+9dU0BU
	Hwwy0+5P0Sv/0bFrhlpYM3ICalFTB9OpAGw+zKME8QfYkMiVAbGjzhn2WdjEDbXy9F994V
	CtmXRvFW122oProx0uOw3RLkbK7JKiQ=
From: Usama Arif <usama.arif@linux.dev>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	mhocko@suse.com,
	vbabka@suse.cz,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	david@kernel.org,
	eperezma@redhat.com,
	gourry@gourry.net,
	jasowang@redhat.com,
	hannes@cmpxchg.org,
	joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mst@redhat.com,
	rppt@kernel.org,
	muchun.song@linux.dev,
	zhengqi.arch@bytedance.com,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	surenb@google.com,
	virtualization@lists.linux.dev,
	weixugc@google.com,
	xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com,
	yuanchu@google.com,
	ziy@nvidia.com,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
Date: Sun,  8 Mar 2026 12:24:35 -0700
Message-ID: <20260308192438.1363382-1-usama.arif@linux.dev>
In-Reply-To: <20260307045520.247998-1-jp.kobryn@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5D0D12000B
X-Stat-Signature: diq3uy89t5yebrr635oczmbepu6jdu47
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772997889-925941
X-HE-Meta: U2FsdGVkX1/JJlwTP3CEEiD0kyJA5/klgaQuB5i3v1h+bADmmPpwSLqmUKhBe/I55RJpIDyk4VdD/CRc2ovqR+03VWWz1AGelWmafXp7797FT2fRZyvgjdkT7GOlNOFzgI5pIYL2264FjcXtLvrJlsQcMjfrqDB52bntOmIxrdMd6ymJf99plmbJWSuWQtchKMRDFsXms5SnzilPmKA1HsPc01ngYzmaKwk4b0HrsocZzsyQAte/iEPtCkmq2t3C9BXf/5hRZ3PwdN8IxMH+7/EFKZPXABAG21PWIQyK92fJQgvvESiaL+egnxC5gWUrEUBokj2n6vou6hEugXDyo5CloXk36MX9Qmxna3KxMpdKv7j3IlWmOAiO0UhXjvC848IzsCF2q13l/Ajpwg6CV9YG6nFzdJFHrypEG7t7Pnkt+7WQnD7TZ3GAoR5/XZTa7dhCjVsJ6QnfbKQbBG5B0nWPX7r4vdxxF0gefTJGVVU138Ns7hQCPvMiREXAl8Ks/taOQO9kaaQF3E7UQHAIxBpq4StJBrtAt4/DgDdV2ypbXiN6yCYUCPzWZLkQ0e1iMCBpfknzv7FVDWM573l7RsCiYILNdMRTujgjQlkv+CrDjMGHXOY0J3Ti2gZdvqAhTIcLhqUOLRtUF311/jDKvKUiJhbPfsmhBLrUtwpPmWTluLTOY0q+Pj//HaJVVi4KEDa8TUw037W5KOJH2x3xHUTPnWQX7dRWR1f2dad44ZaVze1LcUHFmBuHOnpsPWDNYsDnTddCzpyOFx9dJ8/g4jsLNVUtywmv6oweUpxY40QPh/b38KU2HEPEvyKyWUs6szoK2n9uTnxniLmDZWN1ZUMcRms5DrjjIebSdRpgT6+hIomyd/aAq1T1pya/nI0CaEdAkjeMeFDFeKiErXTM2upiPY0nR8dXD1LR0hyNS1V4fS0bQTc9LDNtXOJ3AcJNQh7XbsaLpsOsj6/Eqia
 /uVD+Qru
 71OC1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  6 Mar 2026 20:55:20 -0800 "JP Kobryn (Meta)" <jp.kobryn@linux.dev> wrote:

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

Hello JP!

The stats are exposed via /proc/vmstat and are guarded by CONFIG_NUMA, not
CONFIG_MEMCG. Early returning overhere would make it inaccuate. Does
it make sense to use mod_node_page_state if memcg is not available,
so that these global counters work regardless of cgroup configuration.

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


