Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60817E66886
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 02:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988D86B0088; Sun, 21 Dec 2025 21:51:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960696B0089; Sun, 21 Dec 2025 21:51:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88CC96B008A; Sun, 21 Dec 2025 21:51:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 795CC6B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 21:51:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2EDDC60B99
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:51:59 +0000 (UTC)
X-FDA: 84245582358.15.1182053
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id 19FB9A0002
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:51:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766371917; a=rsa-sha256;
	cv=none;
	b=x//QB6n9qAba0bkRx53Ty2Z5aDo6ecQWbyqHoNvfeBU/psEFp3GOjrUyyXziZssqq1OUYK
	9rFIa3LxGDrHxOLfFyLtgT4kIz+YdLApaPWxRB3Di41p+eWOxVzBQ5hz6Qd0fsoODU5bD0
	3z8KR7SUp5EJ+sI4AzPVI6z3eTfrodI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766371917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R2yFV8TNA4Lta09h01kc3HUrffjQFox+Q1ynSDFg4rk=;
	b=LU3+zFHogUdTOX48NQRYCJYh4Ru1pvH8fgiU64i3HbbBSx+fO666KFqcqtSUsMnlTFTZXz
	Y9xdj5deQ7uBGJ6fDybcnjd9xeCVepXXpT8sJJYhm6I+nfWU3/NP3b62UA5MgDBWdBBvJd
	DjmNd2ENjzzD+OBi9YVi9lZOU0oGFDg=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dZN2G30ZtzKHMM2
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:51:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8558A40574
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:51:50 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgDHKPlFskhp_yArBA--.65468S2;
	Mon, 22 Dec 2025 10:51:50 +0800 (CST)
Message-ID: <d5df710a-e0e1-4254-b58f-60ddc5adcbd5@huaweicloud.com>
Date: Mon, 22 Dec 2025 10:51:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/vmscan: check all allowed targets in
 can_demote()
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
 <20251221233635.3761887-3-bingjiao@google.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251221233635.3761887-3-bingjiao@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgDHKPlFskhp_yArBA--.65468S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Xr4rGrWkKFy7ury8JF1fJFb_yoWxCrWfpF
	s3G3W7Aa1rAFW7GrsIyayq9a4Svw4kJF45Ar18Wr1kAr9IqF1UZF1DXwn7JFy5AFyfurW7
	tFsxAr48u3yqyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	bAw3UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 19FB9A0002
X-Stat-Signature: ambp7yjj7xcqqod1cr1zsob7cdxcb9cn
X-Rspam-User: 
X-HE-Tag: 1766371914-152138
X-HE-Meta: U2FsdGVkX1/hO53RhXsFqF8bvzfRurnvSbRHbRZJ+ifHZjyJBceYaA/mtl2GBviJ+JRRAsbQVHNh+oFFaAeTXQUX8EkI4+y4SSMv91NfxZ4siSNoaWZn5H3duYCCzLfo8kMFlbA9cc9l8CxDr9ymsl76zmpu/ey+rcd+St5zpKJmLE43Uqoog3ZqCfKzIpqfAbCU/NtFfksO+p5O5hxu2Dd08TPD3yBJ6wsfwz3l07z74ThtmJfOZlZhF9QTZ9Nu3Qk9pYn9a8+UluNMy4Jx+tRWvPOEN1JqCRP0kZozCAFfPG8p/8i7uGRWKZC15b8BMhJT2lZH4Q7RYA6hfSNLr3w3BTT4gmfOp9wtw/D26fdeh0VoYKX01gMGlF7QSE5FdGLUwcZq5Oi8H1IqXGmk3hq3EO1nMI51nGgBqoX4VNXZH0uphfpPHKHU3AYqFTr9PBI3gGT6KH4q1CGMifjcYS4JPQS+IcsSHqW+AXn5boyDauH9Xhe5e+nyfpXBnR0Ymo93zxLFEfm9vvPu6LQbW05QRJIdXQYtWwcn6JyYTCNvSeh5Jw6I1v1Nmp6LaMOXBWpXV5AjpmV1RfXqGti4FR5qZ6WNEv0IGl4Irm1v42WXXAEzfEbzbSL1D9nrd9waD4oOBQZ6Cz7/SM6uVTBAnUGT0LXXs0yEb3daWJl414oFCUbPjS+oJT5IxsmNNmaxiXHKdgSMN/XweQ/wTTiRxIpkfjEhOuV/knAa2GW+EADcwzgbOkIRibjf+lDJrSxNeZfh6WjqfZ5QZ4k/v+Ik/IVim7QwhbvF41EdDKr567UaaInXsFmw396usWWbVpo9syCG3LQNj+3b8bwr5h0T4Pd6QnTOIMw2fmGyCLNXc5WXXzbadI50gFEp/sBvlA4rfENB7mG7akAx/z4XN+4dsOoQ8JGLKHgbd5mjw8jtzx5qiF4jXZPcxLOIovXtJfc8D1533EDe0wIkDtkd8KH
 N2/BasOE
 lY4mzUggOtQhnHCU/rRrzneelY0WmRR9S6lVlCI4m0GUR8sbNrccB6W5C6LzALAkYmaiUROt1eOuoplkz8bpxnKqodQAzXfTpbPnsU79kG68j4yxJ5LeHZZmPs86Fc4C05XcpuL3MaLCcUgS2+BuCRpxFGzEw/1FSADsIxloI+CqkjsyqI5hXEMiuqovfabFDq0YSKhtGc99XEC8Q4XQ4An4CdAQYZ453srfd
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
> can_demote(). However, it checks only the nodes in the immediate next
> demotion hierarchy and does not check all allowed demotion targets.
> This can cause pages to never be demoted if the nodes in the next
> demotion hierarchy are not set in mems_effective.
> 
> To address the bug, use mem_cgroup_filter_mems_allowed() to filter
> out allowed targets obtained from node_get_allowed_targets(). Also
> remove some unused functions.
> 
> Fixes: 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> Signed-off-by: Bing Jiao <bingjiao@google.com>
> ---
>  include/linux/cpuset.h     |  6 ------
>  include/linux/memcontrol.h |  7 -------
>  kernel/cgroup/cpuset.c     | 28 ++++------------------------
>  mm/memcontrol.c            |  5 -----
>  mm/vmscan.c                | 14 ++++++++------
>  5 files changed, 12 insertions(+), 48 deletions(-)
> 
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index 0e94548e2d24..ed7c27276e71 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -174,7 +174,6 @@ static inline void set_mems_allowed(nodemask_t nodemask)
>  	task_unlock(current);
>  }
>  
> -extern bool cpuset_node_allowed(struct cgroup *cgroup, int nid);
>  extern void cpuset_node_filter_allowed(struct cgroup *cgroup, nodemask_t *mask);
>  #else /* !CONFIG_CPUSETS */
>  
> @@ -302,11 +301,6 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
>  	return false;
>  }
>  
> -static inline bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
> -{
> -	return true;
> -}
> -
>  static inline void cpuset_node_filter_allowed(struct cgroup *cgroup,
>  					      nodemask_t *mask)
>  {
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7cfd71c57caa..41aab33499b5 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1740,8 +1740,6 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
>  	rcu_read_unlock();
>  }
>  
> -bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
> -
>  void mem_cgroup_filter_mems_allowed(struct mem_cgroup *memcg, nodemask_t *mask);
>  
>  void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
> @@ -1813,11 +1811,6 @@ static inline ino_t page_cgroup_ino(struct page *page)
>  	return 0;
>  }
>  
> -static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
> -{
> -	return true;
> -}
> -
>  static inline bool mem_cgroup_filter_mems_allowed(struct mem_cgroup *memcg,
>  						  nodemask_t *mask)
>  {
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 2925bd6bca91..339779571508 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4416,11 +4416,10 @@ bool cpuset_current_node_allowed(int node, gfp_t gfp_mask)
>  	return allowed;
>  }
>  
> -bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
> +void cpuset_node_filter_allowed(struct cgroup *cgroup, nodemask_t *mask)
>  {
>  	struct cgroup_subsys_state *css;
>  	struct cpuset *cs;
> -	bool allowed;
>  
>  	/*
>  	 * In v1, mem_cgroup and cpuset are unlikely in the same hierarchy
> @@ -4428,15 +4427,15 @@ bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
>  	 * so return true to avoid taking a global lock on the empty check.
>  	 */
>  	if (!cpuset_v2())
> -		return true;
> +		return;
>  
>  	css = cgroup_get_e_css(cgroup, &cpuset_cgrp_subsys);
>  	if (!css)
> -		return true;
> +		return;
>  
>  	/*
>  	 * Normally, accessing effective_mems would require the cpuset_mutex
> -	 * or callback_lock - but node_isset is atomic and the reference
> +	 * or callback_lock - but it is acceptable and the reference
>  	 * taken via cgroup_get_e_css is sufficient to protect css.
>  	 *
>  	 * Since this interface is intended for use by migration paths, we
> @@ -4447,25 +4446,6 @@ bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
>  	 * cannot make strong isolation guarantees, so this is acceptable.
>  	 */
>  	cs = container_of(css, struct cpuset, css);
> -	allowed = node_isset(nid, cs->effective_mems);
> -	css_put(css);
> -	return allowed;
> -}
> -
> -void cpuset_node_filter_allowed(struct cgroup *cgroup, nodemask_t *mask)
> -{
> -	struct cgroup_subsys_state *css;
> -	struct cpuset *cs;
> -
> -	if (!cpuset_v2())
> -		return;
> -
> -	css = cgroup_get_e_css(cgroup, &cpuset_cgrp_subsys);
> -	if (!css)
> -		return;
> -
> -	/* Follows the same assumption in cpuset_node_allowed() */
> -	cs = container_of(css, struct cpuset, css);
>  	nodes_and(*mask, *mask, cs->effective_mems);
>  	css_put(css);
>  }

Oh, I see you merged these two functions here.

However, I think cpuset_get_mem_allowed would be more versatile in general use.

You can then check whether the returned nodemask intersects with your target mask. In the future,
there may be scenarios where users simply want to retrieve the effective masks directly.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f414653867de..ebf5df3c8ca1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5597,11 +5597,6 @@ subsys_initcall(mem_cgroup_swap_init);
>  
>  #endif /* CONFIG_SWAP */
>  
> -bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
> -{
> -	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
> -}
> -
>  void mem_cgroup_filter_mems_allowed(struct mem_cgroup *memcg, nodemask_t *mask)
>  {
>  	if (memcg)
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 4d23c491e914..fa4d51af7f44 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -344,19 +344,21 @@ static void flush_reclaim_state(struct scan_control *sc)
>  static bool can_demote(int nid, struct scan_control *sc,
>  		       struct mem_cgroup *memcg)
>  {
> -	int demotion_nid;
> +	struct pglist_data *pgdat = NODE_DATA(nid);
> +	nodemask_t allowed_mask;
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
>  		return false;
>  
> -	/* If demotion node isn't in the cgroup's mems_allowed, fall back */
> -	return mem_cgroup_node_allowed(memcg, demotion_nid);
> +	/* Filter the given nmask based on cpuset.mems.allowed */
> +	mem_cgroup_filter_mems_allowed(memcg, &allowed_mask);
> +	return !nodes_empty(allowed_mask);
>  }
>  
>  static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,

-- 
Best regards,
Ridong


