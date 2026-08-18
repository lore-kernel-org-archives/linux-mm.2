Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F31EBC5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 04:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2396B08BB; Tue, 18 Aug 2026 00:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62306B08C5; Tue, 18 Aug 2026 00:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A77856B08C6; Tue, 18 Aug 2026 00:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9376B08BB
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:56:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0240440946
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:56:21 +0000 (UTC)
X-FDA: 85113179004.26.DDF725B
Received: from mta0.migadu.com (out-9.mta0.migadu.com [91.218.175.9])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8CF1440003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:56:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="d/Bd3C1w";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.9 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787028979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e/r3PHy2PFYeGOeSWaxYAqBh2obXAS+oLRit1XGCVok=;
	b=B0mpL5HhWPGDKqYf8MbUQcPh80qCDCNT7XC7d36ugcCNwMpOw6l26RA1WCIUHd84WpOkjT
	bAZO2mv0DF1wl15Tsi2u+h4Za7ekjl3zFYQor6Ci6aCafy+cJP2wDZCPmOcvyRwT5QyEtF
	76+lw3dGnyygDsQMx8sXwDXGWyipNYo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="d/Bd3C1w";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.9 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787028979;
	b=exw5CnuDAWsKhDrBflk4exgG9pKV1usSUWSjBTkwIcwQHr6TXadjBrNh2f1sLv38AYV27H
	MUwCrVlzlbUdO5PXbd7zpOsyrtGn4BBZivMHkAbAxhRP9zSlpO3FCTjXrGj2L1KvLirO/t
	AnvwQN/eB/mpVusZ+JUAA0gp9r8U9fw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=J8dWFRtsWHShQk23X9lRpocJrpsf0FxLrR1k+V4msQE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787028973; v=1; x=1787633773;
 b=d/Bd3C1w3EC/HT+O5oM3N2Q/wJtyZYW36bZrM2Wf6nBG6N9f+el9K8luIYH+GlAzwH+Z2jS9
 RzAGTKW1+6rcrdgW+Wg+t7ptBI8FS9pnp/0EUlq2Ia7RpmR+KaufxKxQcV9lpJTe64XU+VIPXRt
 GUBnjg86rThV/KmocA1qcbt8=
X-Envelope-To: linux-mm@kvack.org
Received: from [192.168.110.173] (223.70.160.239)
	by smtp.migadu.com with ESMTPS id a1618604a50247ca;
	Tue, 18 Aug 2026 04:56:13 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <43f12802-de69-45a2-bb97-317a6cc2ee4b@linux.dev>
Date: Tue, 18 Aug 2026 12:56:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, tj@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, akpm@linux-foundation.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 8/8] cgroup: add memory_tiered_limits cgroup mount
 option
To: liuqiqi@kylinos.cn, linux-mm@kvack.org
References: <20260818023121.100613-1-liuqiqi@kylinos.cn>
 <20260818023121.100613-9-liuqiqi@kylinos.cn>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260818023121.100613-9-liuqiqi@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8CF1440003
X-Stat-Signature: qhp8x7gyod33p4os4h4iwyeckbiy3f74
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787028978-509234
X-HE-Meta: U2FsdGVkX1+izCo/NfXkMPR3fogSqBxYyzCPwDF1EqU5yzsTxPREBaDHxBwPnLxFwfpmzP/99Xe9H2QB5QjJFbY0VFl/+JOBrRqa6IDGTsikbhp1jroSLGVqJNwGvn0/zhg9EtmsVKzg97hJxQGf0HhWXzwRK2u3hznyqq5YhvynwUMi5TmWfZld1zfrrAz9Tci0TdRBqWR4uOV/HnQD69FAjjmN4rchkzSlEFTZg74J8sehaJLa61bIRH06rKL3d7nfF/G3af31Ovlu/2DQGhV+RuJLaN+Cswf8OsJHKEP/eZPrZaWhJ+atf6JdOGLIteHWUVg9W6+ru9NzG8RuddNNnDojiySv94YWOeK6apD4c4PX+mVrFIE1lxToCCTtWm6Y/Jcmv2vPIKYli8gt9bwysWl+Fwd9By5D0vrm9IZsHZTGiEghft3tnCYprZSEagLZn7o/huLzhGcfw+BIUVV1TE4hbGV4nzkaM8wpRYlLC6K8MBZg/sroxTLVGeY1kr/jFuhuImdz6DqY9h1keMiOrDfbvQofuDj/UE+tf/eK/m1pDAJwKPKbohHvppcEuuf2OJTGB3gngwqZNx8nQWpAPB1Faub9mTtAZGUXTOlpBhLO3W/moXkGkx8VVbNyJvU7/qgEWoSwipU6OuUeos4nFCJsJp02xzx3vt4b1TPcDHudM+bCvXqx6xBIKXEwkYd52fdQRSKVWWI5eSI/SUDx7X0Rsz+4mwH2ra2y3Pu2L0baoTi2DeVZZyNukDJtm3ohCu7hZDOSMEjPiU4ntOzeuahudbO0lB1vHyJ1/HnzyoWV4Y/QCXc8iYIaVgenAhI5JyR8FkdY0aZacZvrGjvqgZc/Y6WTv/mWm61H3IZ0bmSZ808ggdtj7zYZ0W/tBfGjoUaNjJuZffe45USoPSI7tekWbHmYzPzMrdDB0fMFjE0awwPID6XKIUPr4jtu/qu6DZRlhEblvRyHl99
 /oS+NBO6
 iO7VjqpOL+8WZm3FMuILxyWjxI+EyV2ZKcrFMLw87E0sjRLUUWxICF3E4dSJfpHBda75vq+GhKOmJNG+pkUSwMTglr/qmycTdJO30NbDXw+LoI8JrvYjyyH1LhqWRQIVkEzcxGwRp10Zepy4ffgW44hqi35AqcUeCxNVY2epF3Fnky2/E9SQcnIdfClY8EYRRM9SZdlpKM6aWHd/EOkcoaNUYXAFCIaX7oEkU4xt4TLkehzFH+6CQY39vwhpVMIvbLvagwlA++OWZreQPUg2YZDjiaFrGbDt9MmpvvqkbNfCOZz2ry0liKt++nlkkQcmrRT5V2tmirs4OMBkTP5Y9j1xfu37oxPUw3kJK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/18 10:31, liuqiqi@kylinos.cn 写道:
> From: Qiqi Liu <liuqiqi@kylinos.cn>
> 
> Introduce the memory_tiered_limits cgroup v2 mount option to enable
> tier-aware memory control. The option follows the same pattern as
> memory_recursiveprot and memory_hugetlb_accounting.
> 
> When enabled, per-tier accounting, charging, stock batching, auto-
> derivation, and the memory.tier control file are active. When disabled
> (default), all tier-specific code is gated at entry points: no counters
> are created, no charge/uncharge occurs, and memory.tier remains empty.
> This ensures no measurable overhead for systems that do not opt in.
> 
> Usage:
>   mount -t cgroup2 none /sys/fs/cgroup -o memory_tiered_limits
> 
> Because the cgroup2 mount is owned by the init system, early-boot
> cgroups are created before userspace can specify mount options. To
> cover these boot-time cgroups, mirror the cgroup_favordynmods approach
> and add a kernel command-line parameter,
> cgroup_memory_tiered_limits=<bool>.
> This sets CGRP_ROOT_MEMORY_TIERED_LIMITS on all cgroup2 mounts by
> default. The mount option remains available for runtime, per-mount
> control.
> 
> Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
> ---
>  include/linux/cgroup-defs.h |  5 +++++
>  include/linux/memcontrol.h  | 12 ++++++++++++
>  kernel/cgroup/cgroup.c      | 21 +++++++++++++++++++++
>  mm/memcontrol.c             | 22 ++++++++++++++++++----
>  4 files changed, 56 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
> index de2cd6238c2a..4324d68dbce9 100644
> --- a/include/linux/cgroup-defs.h
> +++ b/include/linux/cgroup-defs.h
> @@ -129,6 +129,11 @@ enum {
>  	 * Enable legacy local pids.events.
>  	 */
>  	CGRP_ROOT_PIDS_LOCAL_EVENTS = (1 << 20),
> +
> +	/*
> +	 * Enable tier-aware limits for the memory controller.
> +	 */
> +	CGRP_ROOT_MEMORY_TIERED_LIMITS = (1 << 21),
>  };
>  
>  /* cftype->flags */
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 8848bc5eeb24..094b9a839977 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -544,6 +544,18 @@ static inline bool mem_cgroup_disabled(void)
>  	return !cgroup_subsys_enabled(memory_cgrp_subsys);
>  }
>  
> +#ifdef CONFIG_NUMA
> +static inline bool mem_cgroup_tiered_limits(void)
> +{
> +	return cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_TIERED_LIMITS;
> +}
> +#else
> +static inline bool mem_cgroup_tiered_limits(void)
> +{
> +	return false;
> +}
> +#endif
> +
>  static inline void mem_cgroup_protection(struct mem_cgroup *root,
>  					 struct mem_cgroup *memcg,
>  					 unsigned long *min,
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 38f8d9df8fbc..da94bcda0859 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -231,6 +231,7 @@ static u32 have_release_callback __read_mostly;
>  static u32 have_canfork_callback __read_mostly;
>  
>  static bool have_favordynmods __ro_after_init = IS_ENABLED(CONFIG_CGROUP_FAVOR_DYNMODS);
> +static bool have_memory_tiered_limits __ro_after_init;
>  
>  /*
>   * Write protected by cgroup_mutex and write-lock of cgroup_threadgroup_rwsem,
> @@ -1985,6 +1986,7 @@ enum cgroup2_param {
>  	Opt_memory_recursiveprot,
>  	Opt_memory_hugetlb_accounting,
>  	Opt_pids_localevents,
> +	Opt_memory_tiered_limits,
>  	nr__cgroup2_params
>  };
>  
> @@ -1995,6 +1997,7 @@ static const struct fs_parameter_spec cgroup2_fs_parameters[] = {
>  	fsparam_flag("memory_recursiveprot",	Opt_memory_recursiveprot),
>  	fsparam_flag("memory_hugetlb_accounting", Opt_memory_hugetlb_accounting),
>  	fsparam_flag("pids_localevents",	Opt_pids_localevents),
> +	fsparam_flag("memory_tiered_limits",	Opt_memory_tiered_limits),
>  	{}
>  };
>  
> @@ -2027,6 +2030,9 @@ static int cgroup2_parse_param(struct fs_context *fc, struct fs_parameter *param
>  	case Opt_pids_localevents:
>  		ctx->flags |= CGRP_ROOT_PIDS_LOCAL_EVENTS;
>  		return 0;
> +	case Opt_memory_tiered_limits:
> +		ctx->flags |= CGRP_ROOT_MEMORY_TIERED_LIMITS;
> +		return 0;
>  	}
>  	return -EINVAL;
>  }
> @@ -2068,6 +2074,11 @@ static void apply_cgroup_root_flags(unsigned int root_flags)
>  			cgrp_dfl_root.flags |= CGRP_ROOT_PIDS_LOCAL_EVENTS;
>  		else
>  			cgrp_dfl_root.flags &= ~CGRP_ROOT_PIDS_LOCAL_EVENTS;
> +
> +		if (root_flags & CGRP_ROOT_MEMORY_TIERED_LIMITS)
> +			cgrp_dfl_root.flags |= CGRP_ROOT_MEMORY_TIERED_LIMITS;
> +		else
> +			cgrp_dfl_root.flags &= ~CGRP_ROOT_MEMORY_TIERED_LIMITS;
>  	}
>  }
>  
> @@ -2085,6 +2096,8 @@ static int cgroup_show_options(struct seq_file *seq, struct kernfs_root *kf_root
>  		seq_puts(seq, ",memory_hugetlb_accounting");
>  	if (cgrp_dfl_root.flags & CGRP_ROOT_PIDS_LOCAL_EVENTS)
>  		seq_puts(seq, ",pids_localevents");
> +	if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_TIERED_LIMITS)
> +		seq_puts(seq, ",memory_tiered_limits");
>  	return 0;
>  }
>  
> @@ -2363,6 +2376,8 @@ static int cgroup_init_fs_context(struct fs_context *fc)
>  
>  	if (have_favordynmods)
>  		ctx->flags |= CGRP_ROOT_FAVOR_DYNMODS;
> +	if (have_memory_tiered_limits)
> +		ctx->flags |= CGRP_ROOT_MEMORY_TIERED_LIMITS;
>  
>  	return 0;
>  }
> @@ -7214,6 +7229,12 @@ static int __init cgroup_favordynmods_setup(char *str)
>  }
>  __setup("cgroup_favordynmods=", cgroup_favordynmods_setup);
>  
> +static int __init cgroup_memory_tiered_limits_setup(char *str)
> +{
> +	return (kstrtobool(str, &have_memory_tiered_limits) == 0);
> +}
> +__setup("cgroup_memory_tiered_limits=", cgroup_memory_tiered_limits_setup);
> +
>  /**
>   * css_tryget_online_from_dir - get corresponding css from a cgroup dentry
>   * @dentry: directory dentry of interest
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f39a702d2301..891051f164ff 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2462,7 +2462,7 @@ static void memcg_charge_tier_id(struct mem_cgroup *memcg, int tier_id,
>  {
>  	struct memcg_tier_counter *tc;
>  
> -	if (tier_id < 0)
> +	if (!mem_cgroup_tiered_limits() || tier_id < 0)

The cover says remount "affects newly created cgroups only", but the
gate is the live global flag on both charge and uncharge.

(same in memcg_uncharge_tier_id() and refill_tier_stock()).

>  		return;
>  	rcu_read_lock();
>  	tc = memcg_tier_counter_find(memcg, tier_id);
> @@ -2476,7 +2476,7 @@ static void memcg_uncharge_tier_id(struct mem_cgroup *memcg, int tier_id,
>  {
>  	struct memcg_tier_counter *tc;
>  
> -	if (tier_id < 0)
> +	if (!mem_cgroup_tiered_limits() || tier_id < 0)
>  		return;
>  	rcu_read_lock();
>  	tc = memcg_tier_counter_find(memcg, tier_id);
> @@ -2581,6 +2581,9 @@ static void tier_update_derived_limits(struct mem_cgroup *memcg)
>  	unsigned long total;
>  	int i, nr_entries;
>  
> +	if (!mem_cgroup_tiered_limits())
> +		return;
> +
>  	spin_lock(&tier_cap_lock);
>  	total = tier_total_capacity;
>  	nr_entries = nr_tier_entries;
> @@ -3198,6 +3201,9 @@ static void refill_tier_stock(struct mem_cgroup *memcg, int tier_id,
>  	uint8_t pages;
>  	int i;
>  
> +	if (!mem_cgroup_tiered_limits())
> +		return;
> +
>  	/* Too big to cache: direct uncharge, leave the stock untouched. */
>  	if (nr_pages > MEMCG_CHARGE_BATCH) {
>  		rcu_read_lock();
> @@ -3252,7 +3258,7 @@ static int try_charge_memcg_tier(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	bool drained = false;
>  	nodemask_t nodes, *nmp = NULL;
>  
> -	if (tier_id < 0)
> +	if (!mem_cgroup_tiered_limits() || tier_id < 0)
>  		return 0;
>  
>  	rcu_read_lock();
> @@ -4736,7 +4742,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>  		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
>  		page_counter_init(&memcg->swap, &parent->swap, false);
>  
> -		{
> +		if (mem_cgroup_tiered_limits()) {
>  			int nid, tid;
>  
>  			for_each_online_node(nid) {
> @@ -5459,6 +5465,8 @@ static int memory_tier_show(struct seq_file *m, void *v)
>  	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
>  	struct memcg_tier_counter *tc;
>  
> +	if (!mem_cgroup_tiered_limits())
> +		return 0;
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(tc, &memcg->tier_counters, list) {
>  		seq_printf(m, "tier%d.current=%llu\n", tc->tier_id,
> @@ -5484,6 +5492,9 @@ static ssize_t memory_tier_write(struct kernfs_open_file *of,
>  	char knob[8], *p;
>  	int tier_id, err;
>  
> +	if (!mem_cgroup_tiered_limits())
> +		return -EOPNOTSUPP;
> +
>  	buf = strstrip(buf);
>  	if (sscanf(buf, "tier%d.%7[^=]", &tier_id, knob) != 2)
>  		return -EINVAL;
> @@ -6267,6 +6278,9 @@ static int __meminit memcg_tier_hotplug_cb(struct notifier_block *self,
>  	struct mem_cgroup *memcg;
>  	int tid;
>  
> +	if (!mem_cgroup_tiered_limits())
> +		return notifier_from_errno(0);
> +
>  	switch (action) {
>  	case NODE_ADDED_FIRST_MEMORY:
>  		tid = node_to_tier_id(nn->nid);


