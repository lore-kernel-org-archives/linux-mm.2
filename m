Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E17EFB7EF
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 04:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9AF6B0089; Mon, 23 Feb 2026 23:27:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D1B6B008A; Mon, 23 Feb 2026 23:27:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42ED76B008C; Mon, 23 Feb 2026 23:27:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2CBDC6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:27:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B12A1C1C40
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:27:38 +0000 (UTC)
X-FDA: 84478066596.29.133B5D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0A7EF100003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:27:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JO+TCFPW;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771907257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/WlqwD5WKIJ1smOGzPXcyUKpW0wyUvuh74vuCBUfuQ=;
	b=X40USPYJO0CmuNj1DjyHwfmr+/o7Z6Wb+1P1nxoyWmLOMqFjBaQpsmYeC/8eK35aWCmmF6
	XbXLUjJgaOCSL1E2e8pZXkil4+ZIoGltGBG3gZLUQtu4ptUqu/X5MIAlk3mtFcYEg490A2
	Xi/4BNkS1M7DIfVjTClYNOA0dAGYoAg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JO+TCFPW;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771907257; a=rsa-sha256;
	cv=none;
	b=3q6QYy6KGSFYbL5acg1dRbuQlXy+fQ0AtRVw9AOLmD5CrwwD3GvKq6FCRsxYaMZmDSK0iJ
	pOtP/PmH83kcy7jy/CgOdh/n6BvSFIebv9n9GRI8977uGuAjp/y2YsL9mHGJZ6qOq5pbPS
	ixF8jvaq3N+2n5hJz7MZkOTX8MvT7l8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 58D0B60137;
	Tue, 24 Feb 2026 04:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6A6C116D0;
	Tue, 24 Feb 2026 04:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771907256;
	bh=DKH9P+2oEkKzIDD+rEyDOYCwldBWz2XgQi305D52RZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JO+TCFPWhl6YiJlSRDSrDIV9dFZrhjh0X+a4Kva+2ros/0Qx+6Tu/Ww70xy+ShN/H
	 hS/9ev1JC3qdqnQ6z1mU6OhtHLVQb66tL/VG8nSu6MpGsz1KCxyjHOO1ZNzDnv4RiL
	 uGb2MoVAsc65FouuJOSaLQwqmAmaMISrqHPiWJVkxjal2kEGLcJvvu3MHN8lUZGZgh
	 b8irlvIuqQ5Y/xcbsxpZtTeFmwTomp6Ye70yEiJcxN+yo+VDMnM6wJNqGbQ6x6AzZg
	 KyvjulmX2IKQuULm4LcdgKUqD8ZTkKwM87ns39WPHGRRqwfM3oCFCx6yGw5xgUw9YT
	 Bxaf2qCRUCuAQ==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH v3 3/4] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Mon, 23 Feb 2026 20:27:33 -0800
Message-ID: <20260224042734.57666-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260223123232.12851-4-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A7EF100003
X-Rspamd-Server: rspam02
X-Stat-Signature: ocrpnqkwqo16oh1zh1tbkswhqo7sng7s
X-HE-Tag: 1771907256-383265
X-HE-Meta: U2FsdGVkX19+weQeGB1DZ9LwXuUVRQs45a9E4IV8pEow63E6Yz9k2nw1/EFiIwuilAqG4MbuMbfU4c1t9La5rharm8syD/NsaONqarTBD+BZYpV/WOXjWZAFCzUiJeD+EceJNthdjiOO71tfccWPiWRsKUdR0+dHPTawhK55y/NfJZJsL1g7o9Tyok7oJKRKByKzruiTLYHYqf2KOdPMjNfq0p2nkxn5twP1aw3biJUJYklB56KtavZBq9lfvLSdzU4oIIA9Cb/3p3rCzoX3FG/G3vwqp0ztRZ1N/l46Dsnxs1LxtLMZ2iqkioWJTiFnh5aEEZj1XjB6dKvruDOuBQz+MQOhod3+yRiFXTOmFa8KVfY6BUU9TNfD9IvmyWAQzrGkxAFW+zsdWwcY7kqgCxjLwbC/MWM5ellNb5YiabyRYZtK5x6AlsvfE3VvaesPoBtwGKa6lfVGSGPYWqRupXT526I9vYVeI8xwrSbbF0vGWBH0k+Mp0qmbsqCullzt0EhSoWH88ZpfCxgLjnEp5atZRTIrSb/UkBqAul56Hsvd0SQS745cC9HyGftY8NM8LPpMvB2sGOhbEpD3X4QawUddlmcqO8AwfFG/vaZmpcJ+EkcJE7izuuYPfM1hrpxWLwwd3z9cEnPsuOqd6xJImOQLxuZNWLQo44HwU+clakL2X1yNj5K3HqZ/j2Ds1oO7ZvakJbMgm3CvA1Qqi+dv9BmN0O4xeRSXUtTN/U5aXNKiCgL+r7o1x3F24wuX7y82yAGVzuq8W1aWOtd+sz8ne88YmoD7wbQBwR7yOnKkgXLQhXsgYSd1GgWDTZcFAGnobdJjqBx99Z0Vlxoa7DCBVuevw7hwZ2hGhJip4pMWc8CLmWCgOlfwOnlGuoUEhq1mIoauYgM4NJ3tLIGYBtNhKSRo4fhZBFIutVCrzl3UkPzR+i0Z3qqG9XXMLGKFMhVMp7qunWSLTvu79PxK9CL
 EF8ftU/N
 KONBRj8hsbYXSKjBpYYg+33KG2ydmTGd1pUHwv1LJZTCY3I4nW0yVzPaYYp2IB84+j1lrG48ilCtwndDuqXHl+siPpwOTUBp8OuFcXcodLNZlaA1cA16Pow8cglo8psMOWYDboi0jb96A6rXHWOOGMtTihPW6IWYvNMv7lMByIQoPckvMdVf3/4Q0Aia2hLDVEnGG7WkNoT9LR57pzFoyntDFWVgRpoTeu7UqDcohdqcto818SZSFiLb6sbS02AA+PtTo+Cq3DKZDErsI6A0U92NbRoSXRo1hbZ7n19n7x8EmPE/E1M+RBycYvsf282bqXFWHXS6iAyQDnVwHixpYOHk2pCG2+1idg51LliqAY6J2yB6IksWuVNtKYMCc8b61/ebd51mKNG0gBMNWhcvYBkxXU6EZMkbh55Mh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Feb 2026 12:32:31 +0000 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> Add new quota goal metrics for memory tiering that track scheme-eligible
> (hot) memory distribution across NUMA nodes:
> 
> - DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP: ratio of hot memory on a node
> - DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP: ratio of hot memory NOT on a node
> 
> These complementary metrics enable push-pull migration schemes that
> maintain a target hot memory distribution. For example, to keep 30%
> of hot memory on CXL node 1:
> 
> - PUSH scheme (DRAM→CXL): node_eligible_mem_bp, nid=1, target=3000
>   Activates when node 1 has less than 30% hot memory
> - PULL scheme (CXL→DRAM): node_ineligible_mem_bp, nid=1, target=7000
>   Activates when node 1 has more than 30% hot memory
> 
> Together with the TEMPORAL goal tuner, the schemes converge to
> equilibrium at the target distribution.
> 
> The metrics use detected eligible bytes per node, calculated by summing
> the size of regions that match the scheme's access pattern (size,
> nr_accesses, age) on each NUMA node.

Looks good in general!  I have some comments about trivials and the design
below, though.

> 
> Suggested-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> ---
>  include/linux/damon.h    |   6 ++
>  mm/damon/core.c          | 123 ++++++++++++++++++++++++++++++++++++++-
>  mm/damon/sysfs-schemes.c |  10 ++++
>  3 files changed, 137 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index ee2d0879c292..6df716533fbf 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -191,6 +191,8 @@ enum damos_action {
>   * @DAMOS_QUOTA_NODE_MEM_FREE_BP:	MemFree ratio of a node.
>   * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:	MemUsed ratio of a node for a cgroup.
>   * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:	MemFree ratio of a node for a cgroup.
> + * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:	Scheme-eligible memory ratio of a node.
> + * @DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP:	Scheme-ineligible memory ratio of a node.

Nit.  Let's wrap the line for 80 columns limit.

>   * @DAMOS_QUOTA_ACTIVE_MEM_BP:		Active to total LRU memory ratio.
>   * @DAMOS_QUOTA_INACTIVE_MEM_BP:	Inactive to total LRU memory ratio.
>   * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
> @@ -204,6 +206,8 @@ enum damos_quota_goal_metric {
>  	DAMOS_QUOTA_NODE_MEM_FREE_BP,
>  	DAMOS_QUOTA_NODE_MEMCG_USED_BP,
>  	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
> +	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
> +	DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP,
>  	DAMOS_QUOTA_ACTIVE_MEM_BP,
>  	DAMOS_QUOTA_INACTIVE_MEM_BP,
>  	NR_DAMOS_QUOTA_GOAL_METRICS,
> @@ -555,6 +559,7 @@ struct damos_migrate_dests {
>   * @ops_filters:	ops layer handling &struct damos_filter objects list.
>   * @last_applied:	Last @action applied ops-managing entity.
>   * @stat:		Statistics of this scheme.
> + * @eligible_bytes_per_node: Scheme-eligible bytes per NUMA node.
>   * @max_nr_snapshots:	Upper limit of nr_snapshots stat.
>   * @list:		List head for siblings.
>   *
> @@ -644,6 +649,7 @@ struct damos {
>  	struct list_head ops_filters;
>  	void *last_applied;
>  	struct damos_stat stat;
> +	unsigned long eligible_bytes_per_node[MAX_NUMNODES];

I understand this could make it time-efficient.  That is, without this, you
will need to iterate the regions for number of node_[in]eligible_mem_bp goals
per scheme.  By having this you need to iterate regions only once per scheme.
I'm bit worried about the increased size of 'struct damos', though.

Do you think the overhead is really significant?  If not, what about making it
simply iterates the regions per goal, and add optimization later if it turns
out really needs?

If this optimization is really needed right now, I'd like it to at least be
dynamically allocated, for only num_online_nodes() or num_possible_nodes() at
least.

>  	unsigned long max_nr_snapshots;
>  	struct list_head list;
>  };
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index b438355ab54a..3e1cb850f067 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2544,6 +2544,111 @@ static unsigned long damos_get_node_memcg_used_bp(
>  }
>  #endif
>  
> +#ifdef CONFIG_NUMA
> +/*
> + * damos_scheme_uses_eligible_metrics() - Check if scheme uses eligible metrics.
> + * @s: The scheme
> + *
> + * Returns true if any quota goal uses node_eligible_mem_bp or
> + * node_ineligible_mem_bp metrics, which require eligible bytes calculation.
> + */
> +static bool damos_scheme_uses_eligible_metrics(struct damos *s)
> +{
> +	struct damos_quota_goal *goal;
> +	struct damos_quota *quota = &s->quota;
> +
> +	damos_for_each_quota_goal(goal, quota) {
> +		if (goal->metric == DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP ||
> +		    goal->metric == DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +/*
> + * damos_calc_eligible_bytes_per_node() - Calculate eligible bytes per node.
> + * @c: The DAMON context
> + * @s: The scheme
> + *
> + * Calculates scheme-eligible bytes per NUMA node based on access pattern
> + * matching. A region is eligible if it matches the scheme's access pattern
> + * (size, nr_accesses, age).
> + */
> +static void damos_calc_eligible_bytes_per_node(struct damon_ctx *c,
> +		struct damos *s)
> +{
> +	struct damon_target *t;
> +	struct damon_region *r;
> +	phys_addr_t paddr;
> +	int nid;
> +
> +	memset(s->eligible_bytes_per_node, 0,
> +			sizeof(s->eligible_bytes_per_node));
> +
> +	damon_for_each_target(t, c) {
> +		damon_for_each_region(r, t) {
> +			if (!__damos_valid_target(r, s))
> +				continue;
> +			paddr = (phys_addr_t)r->ar.start * c->addr_unit;
> +			nid = pfn_to_nid(PHYS_PFN(paddr));
> +			if (nid >= 0 && nid < MAX_NUMNODES)
> +				s->eligible_bytes_per_node[nid] +=
> +					damon_sz_region(r) * c->addr_unit;
> +		}
> +	}

Seems the above code assumes entire region will belong in the same node.  But
the region might be laying over a nodes boundary.  In the case, miscalculations
could happen.

What about getting start/end addresses of the node, and checking the crossing
boundary case?

> +}
> +
> +static unsigned long damos_get_node_eligible_mem_bp(struct damos *s, int nid)
> +{
> +	unsigned long total_eligible = 0;
> +	unsigned long node_eligible;
> +	int n;
> +
> +	if (nid < 0 || nid >= MAX_NUMNODES)
> +		return 0;
> +
> +	for_each_online_node(n)
> +		total_eligible += s->eligible_bytes_per_node[n];
> +
> +	if (!total_eligible)
> +		return 0;
> +
> +	node_eligible = s->eligible_bytes_per_node[nid];
> +
> +	return mult_frac(node_eligible, 10000, total_eligible);
> +}
> +
> +static unsigned long damos_get_node_ineligible_mem_bp(struct damos *s, int nid)
> +{
> +	unsigned long eligible_bp = damos_get_node_eligible_mem_bp(s, nid);
> +
> +	if (eligible_bp == 0)
> +		return 10000;
> +
> +	return 10000 - eligible_bp;
> +}
> +#else
> +static bool damos_scheme_uses_eligible_metrics(struct damos *s)
> +{
> +	return false;
> +}
> +
> +static void damos_calc_eligible_bytes_per_node(struct damon_ctx *c,
> +		struct damos *s)
> +{
> +}
> +
> +static unsigned long damos_get_node_eligible_mem_bp(struct damos *s, int nid)
> +{
> +	return 0;
> +}
> +
> +static unsigned long damos_get_node_ineligible_mem_bp(struct damos *s, int nid)
> +{
> +	return 0;
> +}
> +#endif
> +
>  /*
>   * Returns LRU-active or inactive memory to total LRU memory size ratio.
>   */
> @@ -2562,7 +2667,8 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
>  	return mult_frac(inactive, 10000, total);
>  }
>  
> -static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
> +static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal,
> +		struct damos *s)
>  {
>  	u64 now_psi_total;
>  
> @@ -2584,6 +2690,14 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
>  	case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
>  		goal->current_value = damos_get_node_memcg_used_bp(goal);
>  		break;
> +	case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
> +		goal->current_value = damos_get_node_eligible_mem_bp(s,
> +				goal->nid);
> +		break;
> +	case DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP:
> +		goal->current_value = damos_get_node_ineligible_mem_bp(s,
> +				goal->nid);
> +		break;
>  	case DAMOS_QUOTA_ACTIVE_MEM_BP:
>  	case DAMOS_QUOTA_INACTIVE_MEM_BP:
>  		goal->current_value = damos_get_in_active_mem_bp(
> @@ -2597,11 +2711,12 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
>  /* Return the highest score since it makes schemes least aggressive */
>  static unsigned long damos_quota_score(struct damos_quota *quota)
>  {
> +	struct damos *s = container_of(quota, struct damos, quota);

I'd prefer passing 's' from the caller.

>  	struct damos_quota_goal *goal;
>  	unsigned long highest_score = 0;
>  
>  	damos_for_each_quota_goal(goal, quota) {
> -		damos_set_quota_goal_current_value(goal);
> +		damos_set_quota_goal_current_value(goal, s);
>  		highest_score = max(highest_score,
>  				mult_frac(goal->current_value, 10000,
>  					goal->target_value));
> @@ -2693,6 +2808,10 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
>  	if (!quota->ms && !quota->sz && list_empty(&quota->goals))
>  		return;
>  
> +	/* Calculate eligible bytes per node for quota goal metrics */
> +	if (damos_scheme_uses_eligible_metrics(s))
> +		damos_calc_eligible_bytes_per_node(c, s);
> +
>  	/* First charge window */
>  	if (!quota->total_charged_sz && !quota->charged_from) {
>  		quota->charged_from = jiffies;
> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index fe2e3b2db9e1..232b33f5cbfb 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c
> @@ -1079,6 +1079,14 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs_qgoal_metric_names[] = {
>  		.metric = DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
>  		.name = "node_memcg_free_bp",
>  	},
> +	{
> +		.metric = DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
> +		.name = "node_eligible_mem_bp",
> +	},
> +	{
> +		.metric = DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP,
> +		.name = "node_ineligible_mem_bp",
> +	},
>  	{
>  		.metric = DAMOS_QUOTA_ACTIVE_MEM_BP,
>  		.name = "active_mem_bp",
> @@ -2669,6 +2677,8 @@ static int damos_sysfs_add_quota_score(
>  			break;
>  		case DAMOS_QUOTA_NODE_MEM_USED_BP:
>  		case DAMOS_QUOTA_NODE_MEM_FREE_BP:
> +		case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
> +		case DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP:
>  			goal->nid = sysfs_goal->nid;
>  			break;
>  		case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
> -- 
> 2.43.0

So, the overall concept and definition of the new goal metrics sound good to
me.  But I'd prefer having less optimized but simpler code, and nodes boundary
crossing regions handling.


Thanks,
SJ

