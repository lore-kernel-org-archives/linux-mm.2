Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A33FE74905
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 01:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842D76B0005; Tue, 23 Dec 2025 20:49:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0B46B0088; Tue, 23 Dec 2025 20:49:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2216B008A; Tue, 23 Dec 2025 20:49:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D47A6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:49:52 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2C5A1405B9
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 01:49:51 +0000 (UTC)
X-FDA: 84252683382.02.5C7DE3D
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4DDD0C0003
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 01:49:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766540990; a=rsa-sha256;
	cv=none;
	b=IxJfTbeo9Y9zLP1RrQ5zyNHOJ79R1HQlxFjrWGu9o3TEZfvHsxmEh1wBPSJaYYc9yH56WN
	1QYLagexrbUG0/XcA0I9kYh+2DX+0E5JCdROQQsBsSO9eq0GI1c6jLJEIOGLBJBjyvGS1g
	IJwiFalu5ndLnj2r2pJBCCZQG7G3tUw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766540990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IY8dR8BytG1sE7vqanLY6g9Ysw0KAWaQ+zGFClVbaKQ=;
	b=1sgpkx2yqksMuBt8LAluoxTFKVrt416S5LG4uxbIO4RMz8qFQnmntSZZ6thHHCTOfrir1w
	gvvf4+z0q7CVnd8LQt+QPgaa0ssOBgrwiZwQXftcX2c5olfJiyMm8l1svJ5hr9hf/sYoG9
	+3qgQaOqDHx3AJ8oc9eu0LT1PVyOFXI=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dbZYY6R72zKHLtp
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:49:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0697840573
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:49:41 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgBXBvezRktprrYSBQ--.50131S2;
	Wed, 24 Dec 2025 09:49:40 +0800 (CST)
Message-ID: <646ee1fa-edd1-4588-9720-c3c1df8ebce5@huaweicloud.com>
Date: Wed, 24 Dec 2025 09:49:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
To: Bing Jiao <bingjiao@google.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 gourry@gourry.net, longman@redhat.com, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, tj@kernel.org, mkoutny@suse.com, david@kernel.org,
 zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 cgroups@vger.kernel.org
References: <20251221233635.3761887-1-bingjiao@google.com>
 <20251223212032.665731-1-bingjiao@google.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251223212032.665731-1-bingjiao@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBXBvezRktprrYSBQ--.50131S2
X-Coremail-Antispam: 1UD129KBjvJXoW3uF45Ar47WrWxAFWxGFWkCrg_yoWDuF1rpF
	s3Ga4rC3yrArW3Gr4Svayq9a4Fvw1kXFW5A34agrn7ArnIqF1UXr1Dtw1fXFy3CFy5ur17
	JFnxAr18u3yjya7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
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
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4DDD0C0003
X-Stat-Signature: asqxx5azep5nws8sc38x7wxqgy7s1x8g
X-HE-Tag: 1766540985-3977
X-HE-Meta: U2FsdGVkX19JMAfxLATu2N0aTCsuSwTuoDNy2lYAkt5Hhb9Z2LZqhj4GoLhwUvcJ+1HHFFYwaB2EPTrLprXS/gRIOnv7ugog4d5lB+JaI/qrfNvNbe3anNlv+nL+YNjXI9jT1OLlBfXIdSVqk1M8hpMBJ62yZT8Fp6GE3eLuuZ9pMWrUckimhNaN8TRTBFjzLs/s8FUEYZoRgRlrWBxIIEru3vIzZ1nLdwSIPfiXNRPprMCQMnCkzpSG3Ei9kN6D0SYEy0glpEYBNO6de1ge2EoErQT2vS/osKJqYlo0OrvdAmumOBxOwtL0yMZ02kk5wvULLvLvLg/USVVzUNQkvjfFFkK5iZKK2kPDpJeWjA/BSQZzECPJL1Vw0upuWByec4ifT46h3SCmCMF93+4qS1lmQ5AK+fItlQItNS5pHmQeCH2xozx2XppAscnZ25QqpqT5BKzWiCirPa8mIWbW94lHDis09xhULVNvlbbTpQf2VC5NDY9If+xsEVo4xTiGq5pHYNAWQevu4vV1V2Bkvp6MZbJ2OjvMxG40QswMLlJtn1wgaPilCL+eIYxLVmhkbTYoyDKk2cPKuFpqKM2C8H7PVJPOANufBMGdFtAfXOS5mMVUDiXvMEvK5BtEQiBLddoA2qRjpL53TFkUO8AdIwKvGDU5v9qIo3ks/OQRKxJ+EwChwslQmcUWX9xBEsOACfUggjh141mdhISvORi9MSW/82sHpTKu8FLuM+FHp/+bgW8ovF4uFUi6NhtWTv6ZWfpUUoPjSvhrS131xvh4/bbjVAfhwEHNPbdaQM9LdzIC+iHmaHputhqyuVh77YuhZMHMa6+Gng8qGbwZniNrI4ZiAwtu0NzUBznRq0Zud7+nXl1fFbACXus36uzJTVCLA5uKcblKRBAXDMdDGVwbk/Y0u/8beLi0Qkz4Y95PkiQUBLgBNIiEk9+/FYaDV67Fxc8KuyAC+/+ruFUMpEw
 JcDqSMjD
 Yi3V+pcEsDNkGby+8sNPkDWcTn9tIO6BxZotQrC3YtsXlLXyR7ueJzo5n+GK9iaoWB+7pOXi5tSFbCLCV+56ovMXAuI3JLU/pdYg2qv73+QivN3W54U/kZgpP14z+nvGzZA+8I3mjVKwvxyOKVYE0U02FqzvGCNlx3HX8/T49vnsFvT88NyrPhBZfWFStEXJG4nxTa97oCKlUyQ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/24 5:19, Bing Jiao wrote:
> Fix two bugs in demote_folio_list() and can_demote() due to incorrect
> demotion target checks in reclaim/demotion.
> 
> Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> introduces the cpuset.mems_effective check and applies it to
> can_demote(). However:
> 
>   1. It does not apply this check in demote_folio_list(), which leads
>      to situations where pages are demoted to nodes that are
>      explicitly excluded from the task's cpuset.mems.
> 
>   2. It checks only the nodes in the immediate next demotion hierarchy
>      and does not check all allowed demotion targets in can_demote().
>      This can cause pages to never be demoted if the nodes in the next
>      demotion hierarchy are not set in mems_effective.
> 
> These bugs break resource isolation provided by cpuset.mems.
> This is visible from userspace because pages can either fail to be
> demoted entirely or are demoted to nodes that are not allowed
> in multi-tier memory systems.
> 
> To address these bugs, update cpuset_node_allowed() and
> mem_cgroup_node_allowed() to return effective_mems, allowing directly
> logic-and operation against demotion targets. Also update can_demote()
> and demote_folio_list() accordingly.
> 
> Reproduct Bug 1:
>   Assume a system with 4 nodes, where nodes 0-1 are top-tier and
>   nodes 2-3 are far-tier memory. All nodes have equal capacity.
> 
>   Test script:
>     echo 1 > /sys/kernel/mm/numa/demotion_enabled
>     mkdir /sys/fs/cgroup/test
>     echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
>     echo "0-2" > /sys/fs/cgroup/test/cpuset.mems
>     echo $$ > /sys/fs/cgroup/test/cgroup.procs
>     swapoff -a
>     # Expectation: Should respect node 0-2 limit.
>     # Observation: Node 3 shows significant allocation (MemFree drops)
>     stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1
> 
> Reproduct Bug 2:
>   Assume a system with 6 nodes, where nodes 0-2 are top-tier,
>   node 3 is a far-tier node, and nodes 4-5 are the farthest-tier nodes.
>   All nodes have equal capacity.
> 
>   Test script:
>     echo 1 > /sys/kernel/mm/numa/demotion_enabled
>     mkdir /sys/fs/cgroup/test
>     echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
>     echo "0-2,4-5" > /sys/fs/cgroup/test/cpuset.mems
>     echo $$ > /sys/fs/cgroup/test/cgroup.procs
>     swapoff -a
>     # Expectation: Pages are demoted to Nodes 4-5
>     # Observation: No pages are demoted before oom.
>     stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1,2
> 
> Fixes: 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Bing Jiao <bingjiao@google.com>
> ---
>  include/linux/cpuset.h     |  6 +++---
>  include/linux/memcontrol.h |  6 +++---
>  kernel/cgroup/cpuset.c     | 16 ++++++++--------
>  mm/memcontrol.c            |  6 ++++--
>  mm/vmscan.c                | 35 +++++++++++++++++++++++------------
>  5 files changed, 41 insertions(+), 28 deletions(-)
> 
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index a98d3330385c..eb358c3aa9c0 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -174,7 +174,7 @@ static inline void set_mems_allowed(nodemask_t nodemask)
>  	task_unlock(current);
>  }
> 
> -extern bool cpuset_node_allowed(struct cgroup *cgroup, int nid);
> +extern nodemask_t cpuset_node_get_allowed(struct cgroup *cgroup);
>  #else /* !CONFIG_CPUSETS */
> 
>  static inline bool cpusets_enabled(void) { return false; }
> @@ -301,9 +301,9 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
>  	return false;
>  }
> 
> -static inline bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
> +static inline nodemask_t cpuset_node_get_allowed(struct cgroup *cgroup)
>  {
> -	return true;
> +	return node_possible_map;
>  }
>  #endif /* !CONFIG_CPUSETS */
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index fd400082313a..f9463d853bba 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1740,7 +1740,7 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
>  	rcu_read_unlock();
>  }
> 
> -bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
> +nodemask_t mem_cgroup_node_get_allowed(struct mem_cgroup *memcg);
> 
>  void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
> 
> @@ -1811,9 +1811,9 @@ static inline ino_t page_cgroup_ino(struct page *page)
>  	return 0;
>  }
> 
> -static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
> +static inline nodemask_t mem_cgroup_node_get_allowed(struct mem_cgroup *memcg)
>  {
> -	return true;
> +	return node_possible_map;
>  }
> 
>  static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 6e6eb09b8db6..abb9afb64205 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4416,23 +4416,23 @@ bool cpuset_current_node_allowed(int node, gfp_t gfp_mask)
>  	return allowed;
>  }
> 
> -bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
> +nodemask_t cpuset_node_get_allowed(struct cgroup *cgroup)
>  {

Could we define it as:

void cpuset_node_get_allowed(struct cgroup *cgroup, nodemask_t *node)

to align with the naming style of node_get_allowed_targets?

> +	nodemask_t nodes = node_possible_map;
>  	struct cgroup_subsys_state *css;
>  	struct cpuset *cs;
> -	bool allowed;
> 
>  	/*
>  	 * In v1, mem_cgroup and cpuset are unlikely in the same hierarchy
>  	 * and mems_allowed is likely to be empty even if we could get to it,
> -	 * so return true to avoid taking a global lock on the empty check.
> +	 * so return directly to avoid taking a global lock on the empty check.
>  	 */
> -	if (!cpuset_v2())
> -		return true;
> +	if (!cgroup || !cpuset_v2())
> +		return nodes;
> 
>  	css = cgroup_get_e_css(cgroup, &cpuset_cgrp_subsys);
>  	if (!css)
> -		return true;
> +		return nodes;
> 
>  	/*
>  	 * Normally, accessing effective_mems would require the cpuset_mutex
> @@ -4447,9 +4447,9 @@ bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
>  	 * cannot make strong isolation guarantees, so this is acceptable.
>  	 */
>  	cs = container_of(css, struct cpuset, css);
> -	allowed = node_isset(nid, cs->effective_mems);
> +	nodes_copy(nodes, cs->effective_mems);
>  	css_put(css);
> -	return allowed;
> +	return nodes;
>  }
> 
>  /**
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 75fc22a33b28..c2f4ac50d5c2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5597,9 +5597,11 @@ subsys_initcall(mem_cgroup_swap_init);
> 
>  #endif /* CONFIG_SWAP */
> 
> -bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
> +nodemask_t mem_cgroup_node_get_allowed(struct mem_cgroup *memcg)

void mem_cgroup_node_get_allowed(struct mem_cgroup *memcg, nodemask_t *node)

>  {
> -	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
> +	if (memcg)
> +		return cpuset_node_get_allowed(memcg->css.cgroup);
> +	return node_possible_map;
>  }
> 
>  void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a4b308a2f9ad..711a04baf258 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -345,18 +345,24 @@ static bool can_demote(int nid, struct scan_control *sc,
>  		       struct mem_cgroup *memcg)
>  {
>  	int demotion_nid;
> +	struct pglist_data *pgdat = NODE_DATA(nid);
> +	nodemask_t allowed_mask, allowed_mems;
> 
> -	if (!numa_demotion_enabled)
> +	if (!pgdat || !numa_demotion_enabled)
>  		return false;
>  	if (sc && sc->no_demotion)
>  		return false;
> 
> -	demotion_nid = next_demotion_node(nid);
> -	if (demotion_nid == NUMA_NO_NODE)
> +	node_get_allowed_targets(pgdat, &allowed_mask);
> +	if (nodes_empty(allowed_mask))
> +		return false;
> +
> +	allowed_mems = mem_cgroup_node_get_allowed(memcg);
> +	nodes_and(allowed_mask, allowed_mask, allowed_mems);
> +	if (nodes_empty(allowed_mask))
>  		return false;
> 
	node_get_allowed_targets(pgdat, &allowed_mask);
	mem_cgroup_node_get_allowed(memcg, allowed_mems);
	if (!nodes_intersects(allowed_mask, allowed_mems))
		return false;

	Would it look better?

> -	/* If demotion node isn't in the cgroup's mems_allowed, fall back */
> -	if (mem_cgroup_node_allowed(memcg, demotion_nid)) {
> +	for_each_node_mask(demotion_nid, allowed_mask) {
>  		int z;
>  		struct zone *zone;
>  		struct pglist_data *pgdat = NODE_DATA(demotion_nid);
> @@ -1029,11 +1035,12 @@ static struct folio *alloc_demote_folio(struct folio *src,
>   * Folios which are not demoted are left on @demote_folios.
>   */
>  static unsigned int demote_folio_list(struct list_head *demote_folios,
> -				     struct pglist_data *pgdat)
> +				      struct pglist_data *pgdat,
> +				      struct mem_cgroup *memcg)
>  {
>  	int target_nid = next_demotion_node(pgdat->node_id);
>  	unsigned int nr_succeeded;
> -	nodemask_t allowed_mask;
> +	nodemask_t allowed_mask, allowed_mems;
> 
>  	struct migration_target_control mtc = {
>  		/*
> @@ -1043,7 +1050,6 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
>  		 */
>  		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
>  			__GFP_NOMEMALLOC | GFP_NOWAIT,
> -		.nid = target_nid,
>  		.nmask = &allowed_mask,
>  		.reason = MR_DEMOTION,
>  	};
> @@ -1051,10 +1057,15 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
>  	if (list_empty(demote_folios))
>  		return 0;
> 
> -	if (target_nid == NUMA_NO_NODE)
> -		return 0;
> -
>  	node_get_allowed_targets(pgdat, &allowed_mask);
> +	allowed_mems = mem_cgroup_node_get_allowed(memcg);
> +	nodes_and(allowed_mask, allowed_mask, allowed_mems);
> +	if (nodes_empty(allowed_mask))
> +		return false;
> +
> +	if (target_nid == NUMA_NO_NODE || !node_isset(target_nid, allowed_mask))
> +		target_nid = node_random(&allowed_mask);
> +	mtc.nid = target_nid;
>
>  	/* Demotion ignores all cpuset and mempolicy settings */
>  	migrate_pages(demote_folios, alloc_demote_folio, NULL,
> @@ -1576,7 +1587,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  	/* 'folio_list' is always empty here */
> 
>  	/* Migrate folios selected for demotion */
> -	nr_demoted = demote_folio_list(&demote_folios, pgdat);
> +	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
>  	nr_reclaimed += nr_demoted;
>  	stat->nr_demoted += nr_demoted;
>  	/* Folios that could not be demoted are still in @demote_folios */
> --
> 2.52.0.358.g0dd7633a29-goog

-- 
Best regards,
Ridong


