Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A979E66886
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 02:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C291F6B0088; Sun, 21 Dec 2025 21:38:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6BF6B0089; Sun, 21 Dec 2025 21:38:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABAC76B008A; Sun, 21 Dec 2025 21:38:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97C5D6B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 21:38:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F05260D2C
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:38:38 +0000 (UTC)
X-FDA: 84245548716.20.16B908F
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf26.hostedemail.com (Postfix) with ESMTP id 82FA0140012
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:38:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766371116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t3raz3t45aN/hMLgh3K6EXT+aYHj6ZgGzst0rmbnogU=;
	b=tv2EvuHQsdy5ey+nudR+g+lAs8qjrceGPrxpQv3hGp6nK96MheMSmQ7SSnjr7nzsneLh5r
	1X+moMpNYyJ/oMg2svtYuIHT1joGhDxnnQFUidN6JGadm/nBHI3pAbztvxFoc+D8UMUGJe
	IfEu88x9ICDGjTE1VvWFfBW0COolJDM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766371116; a=rsa-sha256;
	cv=none;
	b=q3b/Zo/HWmWPRA4XepHSTa/vE+MGNE/RxjoRIAJJhAicpy0MT0F4jZ/l7883ZBdOKF5V98
	6S25CRmf+EppUuAbqv8CvMnBlyxhbRHXA11xFMQvU/hmyFKm9sc+1vug9/UizPDmXTgZ0V
	sopmPqExslyPytZmbdSan40a7WZz/60=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dZMkr5187zKHMKl
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:38:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C8C2940562
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:38:28 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgAHtvYjr0hpMQkqBA--.13440S2;
	Mon, 22 Dec 2025 10:38:28 +0800 (CST)
Message-ID: <6a7f78fe-0d46-4901-b4f0-977472e29859@huaweicloud.com>
Date: Mon, 22 Dec 2025 10:38:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/vmscan: respect mems_effective in
 demote_folio_list()
To: Bing Jiao <bingjiao@google.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 akpm@linux-foundation.org, gourry@gourry.net, longman@redhat.com,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, tj@kernel.org,
 mkoutny@suse.com, david@kernel.org, zhengqi.arch@bytedance.com,
 lorenzo.stoakes@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, cgroups@vger.kernel.org
References: <20251220061022.2726028-1-bingjiao@google.com>
 <20251221233635.3761887-1-bingjiao@google.com>
 <20251221233635.3761887-2-bingjiao@google.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251221233635.3761887-2-bingjiao@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAHtvYjr0hpMQkqBA--.13440S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Xr4rGF45trykuF1fGFW8tFb_yoW3XFW8pF
	4kG3WFkr4rAF17W39aya4q9a4Svw1kXa15AryxWr97AF9IqF1UZF1DGwnxJFWUAF95ur12
	qFnxAw48W3yDtaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: nfzwzfr8gjwhcniim3kujpxsa3m1x693
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 82FA0140012
X-HE-Tag: 1766371113-538946
X-HE-Meta: U2FsdGVkX19EHKkTk4jgWsZx2gf2rL1VbIFnY9v4E9kjb+PqQQWEiD7fsYl6I+kSX7MEwsS25iPeGjiG8Pb20vHOKv7IBKtkcUnAULE92CHkCXx41RL6vqe9H7DmBAk2y2SS/wI56Gay6nloPSIomwPrHfMt2dsZdVFqOjQGMuAtUFex7YUI5K/9vKZRmZU/YNiBLpaOhi0O8L9BIt4K3Npea5gN2TJs5PP/Tdll3C7mBVR5VIFYv236IA+QPClBZ4ZkAvpmmOvOaxal3liAtBtKGUld9YwCFBNWCa+qGS95gTINz+wRLFk+Gzqw20VZq3IRZ1Q5nEqZID69DIzW0Vvzst8yN1UUL6hAL6rYLPTsPZktpps+9b22W46wOg4O2kB96Xp8W1nLc3UvRKXfVPfeaRlx1Alu0ykxLTtC95qtygLMIPBk7EgoqIeGAqMajEEQweQa4CEapDqLJUfJl3LFI7ARWmOFeHYrKRuohvfjTJ8orSZLB4FPWShD2Mmf9b1tvLMg+nGFuFdLMG4YT0WQLLLa8JfjGeBk+CR/QEYBwW6XA5s5IHKgdybmzFjbPlHVbR90Y+3/CY2rF1zQKGPHKHV5SHt+GP0Mo6WNoirSY/QezckLS4rnDS17/D2MYdVk2xnJQP28ACeJp+dCm8HPMKdhQHKyIRGYGXnYSsK7+p9BKEOfL7XfazygG+oO2wjmAnh08sC3t7ERsQAxLx5NdvSA4nqqPyHqTbTalGHZj4MgKVzRIA7TZHPwGO8InN9UMXJ3gt3cxMc00wAJLvCwx2CRtsUBJ+k9lI4krxgm4Qk4dhP4If2kVfXzLj3E4HxQLZEDcAPL1u1yoVvpQF78QUnAdyXFbTGkT0leF+t5YiZbr9B1WAr8wd7puJwBIVHZ44MVFUjXmz/iS7duxaCJXHl/Re5gJbvkivGfQ+Jd3o0sJEkREJcMhjpf8yAFdKslidAobL7EXP0GDN0
 IL3tfbKc
 AyKhwS3+hWBrd10Kwj20x5OgEsWuYAvHLsXd8WjDQFb5iGqZC7ziaJHi6ckOYtiABX0fssqgWtZeRcZbUqF+gKxcY6Pj8tXUz7MX8W/+FGrvuJJSYdxdrHAAUkTrFYPRubvuwIb6aPI7KlQGOWqWFeuTfoaOOPPWsvQJt0SoUh63DdI9b0kkgEh3UIC3zI4C0iOcyR5ft+fxPblXmhZEFe2HeKylSVbcLp3dM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/22 7:36, Bing Jiao wrote:
> Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> introduces the cpuset.mems_effective check and applies it to
> can_demote(). However, it does not apply this check in
> demote_folio_list().
> 
> This omission leads to situations where pages are demoted to nodes
> that are explicitly excluded from the task's cpuset.mems.
> The impact is two-fold:
> 
>   1. Resource Isolation: This bug breaks resource isolation provided
>      by cpuset.mems. It allows pages to be demoted to nodes that are
>      dedicated to other tasks or are intended for hot-unplugging.
> 
>   2. Performance Issue: In multi-tier systems, users use cpuset.mems
>      to bind tasks to different performed-far tiers (e.g., avoiding
>      the slowest tiers for latency-sensitive data). This bug can
>      cause unexpected latency spikes if pages are demoted to the
>      farthest nodes.
> 
> To address the bug, implement a new function
> mem_cgroup_filter_mems_allowed() to filter out nodes that are not
> set in mems_effective, and update demote_folio_list() to utilize
> this filtering logic. This ensures that demotions target respect
> task's memory placement constraints.
> 
> Fixes: 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> Signed-off-by: Bing Jiao <bingjiao@google.com>
> ---
>  include/linux/cpuset.h     |  6 ++++++
>  include/linux/memcontrol.h |  7 +++++++
>  kernel/cgroup/cpuset.c     | 18 ++++++++++++++++++
>  mm/memcontrol.c            |  6 ++++++
>  mm/vmscan.c                | 13 ++++++++++---
>  5 files changed, 47 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index a98d3330385c..0e94548e2d24 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -175,6 +175,7 @@ static inline void set_mems_allowed(nodemask_t nodemask)
>  }
>  
>  extern bool cpuset_node_allowed(struct cgroup *cgroup, int nid);
> +extern void cpuset_node_filter_allowed(struct cgroup *cgroup, nodemask_t *mask);
>  #else /* !CONFIG_CPUSETS */
>  
>  static inline bool cpusets_enabled(void) { return false; }
> @@ -305,6 +306,11 @@ static inline bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
>  {
>  	return true;
>  }
> +
> +static inline void cpuset_node_filter_allowed(struct cgroup *cgroup,
> +					      nodemask_t *mask)
> +{
> +}
>  #endif /* !CONFIG_CPUSETS */
>  
>  #endif /* _LINUX_CPUSET_H */
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index fd400082313a..7cfd71c57caa 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1742,6 +1742,8 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
>  
>  bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
>  
> +void mem_cgroup_filter_mems_allowed(struct mem_cgroup *memcg, nodemask_t *mask);
> +
>  void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
>  
>  static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> @@ -1816,6 +1818,11 @@ static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
>  	return true;
>  }
>  
> +static inline bool mem_cgroup_filter_mems_allowed(struct mem_cgroup *memcg,
> +						  nodemask_t *mask)
> +{
> +}
> +
>  static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
>  {
>  }
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 6e6eb09b8db6..2925bd6bca91 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4452,6 +4452,24 @@ bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
>  	return allowed;
>  }
>  
> +void cpuset_node_filter_allowed(struct cgroup *cgroup, nodemask_t *mask)
> +{
> +	struct cgroup_subsys_state *css;
> +	struct cpuset *cs;
> +
> +	if (!cpuset_v2())
> +		return;
> +
> +	css = cgroup_get_e_css(cgroup, &cpuset_cgrp_subsys);
> +	if (!css)
> +		return;
> +
> +	/* Follows the same assumption in cpuset_node_allowed() */
> +	cs = container_of(css, struct cpuset, css);
> +	nodes_and(*mask, *mask, cs->effective_mems);
> +	css_put(css);
> +}
> +

The functions cpuset_node_filter_allowed and cpuset_node_allowed are similar. We should create a
helper function to obtain cs->effective_mems, which can then be used by both
cpuset_node_filter_allowed and cpuset_node_allowed.

For example:

nodemask_t *mask cpuset_get_mem_allowed(struct cgroup *cgroup)
{
}

bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
{
e_mask = cpuset_node_allowed(cgroup);
return allowed = node_isset(nid, mask);
}

void cpuset_node_filter_allowed(struct cgroup *cgroup, nodemask_t mask)
{
e_mask = cpuset_node_allowed(cgroup);
nodes_and(mask, *mask, e_mask);
}

Previously, I did not think we should distinguish between cgroup v1 and v2 here. This should be a
common function; at least based on its name, it should not be solely for v2.

>  /**
>   * cpuset_spread_node() - On which node to begin search for a page
>   * @rotor: round robin rotor
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 75fc22a33b28..f414653867de 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5602,6 +5602,12 @@ bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
>  	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
>  }
>  
> +void mem_cgroup_filter_mems_allowed(struct mem_cgroup *memcg, nodemask_t *mask)
> +{
> +	if (memcg)
> +		cpuset_node_filter_allowed(memcg->css.cgroup, mask);
> +}
> +
>  void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
>  {
>  	if (mem_cgroup_disabled() || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 453d654727c1..4d23c491e914 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1018,7 +1018,8 @@ static struct folio *alloc_demote_folio(struct folio *src,
>   * Folios which are not demoted are left on @demote_folios.
>   */
>  static unsigned int demote_folio_list(struct list_head *demote_folios,
> -				     struct pglist_data *pgdat)
> +				      struct pglist_data *pgdat,
> +				      struct mem_cgroup *memcg)
>  {
>  	int target_nid = next_demotion_node(pgdat->node_id);
>  	unsigned int nr_succeeded;
> @@ -1032,7 +1033,6 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
>  		 */
>  		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
>  			__GFP_NOMEMALLOC | GFP_NOWAIT,
> -		.nid = target_nid,
>  		.nmask = &allowed_mask,
>  		.reason = MR_DEMOTION,
>  	};
> @@ -1044,6 +1044,13 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
>  		return 0;
>  
>  	node_get_allowed_targets(pgdat, &allowed_mask);
> +	/* Filter the given nmask based on cpuset.mems.allowed */
> +	mem_cgroup_filter_mems_allowed(memcg, &allowed_mask);
> +	if (nodes_empty(allowed_mask))
> +		return 0;
> +	if (!node_isset(target_nid, allowed_mask))
> +		target_nid = node_random(&allowed_mask);
> +	mtc.nid = target_nid;
>  
>  	/* Demotion ignores all cpuset and mempolicy settings */
>  	migrate_pages(demote_folios, alloc_demote_folio, NULL,
> @@ -1565,7 +1572,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  	/* 'folio_list' is always empty here */
>  
>  	/* Migrate folios selected for demotion */
> -	nr_demoted = demote_folio_list(&demote_folios, pgdat);
> +	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
>  	nr_reclaimed += nr_demoted;
>  	stat->nr_demoted += nr_demoted;
>  	/* Folios that could not be demoted are still in @demote_folios */

-- 
Best regards,
Ridong


