Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63FC8C61DBD
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 01:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A6E6B0088; Wed, 26 Aug 2026 21:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4AFE6B008A; Wed, 26 Aug 2026 21:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A156A6B008C; Wed, 26 Aug 2026 21:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 688B06B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:37:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D0AD11A028F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:37:29 +0000 (UTC)
X-FDA: 85145337018.02.35D1A93
Received: from mta0.migadu.com (out-8.mta0.migadu.com [91.218.175.8])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1D26A40003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:37:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=utTf4NcU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.8 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787794648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GlDvim1+dClTWqdDoHDqk8VSGXbD9cR+OAlw3D+B3/U=;
	b=B/hmjbPwAvRZ2M599d0cHQ1dbbyOlOVMYyqF17gGib9u59WgGZCi/vIPylmhOVgyAAHJ+w
	dbEEWS2fSb1Yr0iz7VxBxJ2gAF23/C0O1hPb9h8go1B/gT320NN/7+XEhOq1FI+uWlj307
	pd8npP0DKmwI5ONjFHVsVp4uYiytgb4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=utTf4NcU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.8 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787794648;
	b=Tnr6XE5HeM1ymRX18Wvmodlza4LdHBNwoTjiPXF8rLXlrAWtnWgBSdU8fT+7+GQoWpcQXc
	/NbVbgS5z8Q/nUVQbPWF9sEl5GAnrGfj+hKDXk/25KZLN4hhM7R7/khH7oa2WmN+X0aPKh
	t64vwcuj9gN1SZwrIKhuLEImRtaLryg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=htyAKBUKag4BkmqelGoVlxjJ7s9eT/i2PDyfgKhi+pQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787794641; v=1; x=1788399441;
 b=utTf4NcU4n4TAvT83CXkJlQuWI5F9l6oAwfGYXPaHINyrIH/Dv9j91QVa6tPrjNMJsgSzrVM
 oA7331wY/Z/ZOOCr+e+LdDsf9BveJqQUKuokTVX3RQHi/SyJWXio1XQ0pHcLLcIea8PI53GlPw0
 c6utCRWxj5NUf4p8C7tf2zmM=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 00f404dab48392af;
	Thu, 27 Aug 2026 01:37:21 +0000
X-Mizu-Trace-ID: 00f404dab48392af
X-Migadu-Flow: FLOW_OUT
Message-ID: <49c19d73-beca-473f-96b9-23ff8ee9d445@linux.dev>
Date: Thu, 27 Aug 2026 09:37:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, David Hildenbrand
 <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Yu Zhao <yuzhao@google.com>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
References: <20260826133054.88529-1-ridong.chen@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260826133054.88529-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1ec8dpi6m7jxiytuzs9bt6ewfdks9p8z
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1D26A40003
X-Rspam-User: 
X-HE-Tag: 1787794645-900612
X-HE-Meta: U2FsdGVkX1+h5VyFE5M7NBincQXcLQLhVC9W2i8YaOtc5hUE5kH3Blgm7Jj/nViON2NrV99WqhjvqG/gpIaHYe7hgJ/ha6GaOU1gv3+nnxD07blkg0L8tRdEpyhOeLgVx6621SmjGDARYBATGkxVXaOaa6wbgDM/2Tzx087rGf/UKxL+6G0AbehlY50ABuxtX4qaZauPkD6EO4h9yTbe/QxyJuA4DZGgmLAAZYgzAw9kx+hO/Rjz3inQp+R/bYc/kyQXbOohOhgvj5TuoDYaEXTi7Inqi6looUimgQQdH4/dq6xgFU7h69NyEYoR3vXrfMdWEO/m/W9AgHFWdNElTVxTPbPox5ngXwYlDCxdsr5xz13j4+bfPoxv66kEpvM27J5u7rhTmYeJpGwikIyvNddndh0ZY5T2+sM3hTNxCRUaSPLuJBjt+cK15idcUNDw4OpfzPQ2GPcT3MoeIehUJwP3YVI77btyPzvq3WGB+sfH93FIBetHtP8+k4qdnLF+UJboDymhvvCCgeMdz3jcqzbOVe3hh0qsJDyOVVDkibx195u8VTX8C8hzTXm9Dqis6hfBJ4RybvcTBRm1yz8mVO1cEiANOR+NiD8TQiKpOSlkvqWVsWp4QyTekDNzg/9KQe4ErJM73MoPt71wHeMtdabkZtuO+Ih0+t0f42R4nWiSxk58/PYMn2zHOWMDYxix4ZTrtz0st4VyRm40FWV2QhO66cIhBNtHweSdcFZLy6+XF41mSD6cakE/o5vUTgOxZGtlRXy21d2jRzU3LGaW3+91UwJqgx4PojFIUYUDS2HyRXCpvlRe5eZ5Rllmqc1Hf2FwXa5se8lIPoBYlMRzHXPeZ6cQ7cxsvmte3Skir0fDtCA3VRqens340iE51eqXi2do2kKJfhy3NPCeMAFPR8vTXkcq5tHh9k6v7J8PCPwD1j+mfPFK816YdevP2/j4drk+VssccHzfIRSdjk1
 4ek4s/ep
 wQFWcU00fmMcnXND8VX9cAx5gdnMrsHD4g5DWKb3W8BxuHWOf0U4IQyiBq2d9IWMKBGkDRiV7TeaxGdPQ8IRDB1yshJROwhRGjQKwoB1Gmdh0UtG9fwRLE7OP+s5t+cutBkzDin2pFiUb06+Mq9Imk2hEpE4OtGzWQFKj69pigzfiRcLML7tx1xUJhjKYuAV8g5Awn8yRql5oTFqt6a5uH/gMS4fwLVL0W8sWzBMeMhCeaGJWTTOi8Pm5ToKkh7rxuhREwKqHyJ+9H2Q4AEklfjY2v9rtKXkD7TrEtNL9m9EEbBAWrpg6duRD9jq+SoPrAO3tdWhsvYs7KTY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/26/2026 9:30 PM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> memory.min/low is silently bypassed for MGLRU during global proactive
> reclaim (writing to the root memory.reclaim) and global direct reclaim.
> It can be reproduced as follows:
> 
>    # echo 7 > /sys/kernel/mm/lru_gen/enabled
>    # cd /sys/fs/cgroup
>    # mkdir -p a/b
>    # echo 100M > a/memory.min
>    # echo +memory > a/cgroup.subtree_control
>    # echo 100M > a/b/memory.min
>    # echo $$ > a/b/cgroup.procs
>    # dd if=/dev/zero of=/tmp/testfile bs=1M count=200
>    # cat a/b/memory.current
>    222650368
>    # echo 500M > memory.reclaim
>    -bash: echo: write error: Resource temporarily unavailable
>    # cat a/b/memory.current
>    6070272
> 
> memory.min is 100M, yet reclaim drops a/b down to 6M, breaking the
> protection.  The traditional LRU path is not affected because
> shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
> visits during a top-down tree walk.
> 
> Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
> moved the protection computation into lru_gen_age_node(), which only
> runs for kswapd.  Non-kswapd global reclaim reaches shrink_one() through
> lru_gen_shrink_node() -> shrink_many() without any protection
> computation, so emin/elow remain stale or zero.
> 
> Introduce mem_cgroup_protection_path() which computes emin/elow along
> the root-to-target path only by iterating through the cgroup ancestors
> array top-down.  This avoids the full tree traversal that would be
> needed with mem_cgroup_calculate_protection(), limiting the cost to
> O(depth) per memcg - typically 3-5 levels.
> 

Hi all,

This is an RFC patch.

My initial attempt to address this issue involved traversing the entire memcg 
tree, similar to what kswapd does. However, Sashiko raised concerns that this 
could introduce performance regressions [1].

To address that, this patch instead walks the cgroup ancestors array in a 
top-down manner, as outlined above, and I'd like to gather feedback on this 
approach.

[1] https://lore.kernel.org/linux-mm/20260723130559.2343690-1-ridong.chen@linux.dev/

> Call it from shrink_one() for the non-kswapd path so that each memcg
> about to be shrunk has correct protection values.
> 
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>   include/linux/memcontrol.h |  7 +++++++
>   mm/memcontrol.c            | 42 ++++++++++++++++++++++++++++++++++++++
>   mm/vmscan.c                |  8 +++++++-
>   3 files changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7d1c0ce189a8..26be8277d64b 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -605,6 +605,8 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
>   
>   void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>   				     struct mem_cgroup *memcg);
> +void mem_cgroup_protection_path(struct mem_cgroup *root,
> +				struct mem_cgroup *memcg);
>   
>   static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
>   					  struct mem_cgroup *memcg)
> @@ -1133,6 +1135,11 @@ static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>   {
>   }
>   
> +static inline void mem_cgroup_protection_path(struct mem_cgroup *root,
> +					      struct mem_cgroup *memcg)
> +{
> +}
> +
>   static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
>   					  struct mem_cgroup *memcg)
>   {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1271d390b617..c739db33b917 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5198,6 +5198,48 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>   	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
>   }
>   
> +/**
> + * mem_cgroup_protection_path - compute protection along root->memcg path
> + * @root: the top ancestor of the sub-tree being checked (NULL for root_mem_cgroup)
> + * @memcg: the target memory cgroup
> + *
> + * Walk the ancestor path from @root down to @memcg and compute the effective
> + * protection at each level.  This is safe for isolated queries because it
> + * ensures parents are computed before children.
> + */
> +void mem_cgroup_protection_path(struct mem_cgroup *root,
> +				struct mem_cgroup *memcg)
> +{
> +	bool recursive_protection =
> +		cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT;
> +	struct cgroup *cg;
> +	int root_level, i;
> +
> +	if (mem_cgroup_disabled())
> +		return;
> +
> +	if (!root)
> +		root = root_mem_cgroup;
> +
> +	if (memcg == root)
> +		return;
> +
> +	root_level = root->css.cgroup->level;
> +	cg = memcg->css.cgroup;
> +
> +	rcu_read_lock();
> +	for (i = root_level + 1; i <= cg->level; i++) {
> +		struct mem_cgroup *cur;
> +
> +		cur = mem_cgroup_from_css(cgroup_css(cg->ancestors[i],
> +						    &memory_cgrp_subsys));
> +		if (cur)
> +			page_counter_calculate_protection(&root->memory,
> +					&cur->memory, recursive_protection);
> +	}
> +	rcu_read_unlock();
> +}
> +
>   static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
>   			gfp_t gfp)
>   {
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6dff207ad8c6..e572d2742c8c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5102,7 +5102,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>   	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>   
> -	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
> +	/*
> +	 * For kswapd, lru_gen_age_node() has already called
> +	 * mem_cgroup_calculate_protection()
> +	 */
> +	if (!current_is_kswapd())
> +		mem_cgroup_protection_path(NULL, memcg);
> +
>   	if (mem_cgroup_below_min(NULL, memcg))
>   		return MEMCG_LRU_YOUNG;
>   

-- 
Best regards
Ridong


