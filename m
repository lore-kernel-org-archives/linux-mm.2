Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1303CD8CAC
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 07:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 281C86B0005; Tue,  9 Jun 2026 03:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20BC66B008C; Tue,  9 Jun 2026 03:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D38D6B0092; Tue,  9 Jun 2026 03:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC69E6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:42:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 935618DDBB
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:42:11 +0000 (UTC)
X-FDA: 84859580862.03.7934F3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id F3EA41C000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:42:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RIRQR/GA";
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780990930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/fLS4kGFzIziHid0UTMKzvuVWRHQkXx0n4JPVpgqLTY=;
	b=tko5AU3Gl3EcBGUbdvHnRmJJAfEQepUk039q4jIGTBwh1XmnaeV0LZ5Y8zx3KlnItHIkyV
	q3a0EgCO1IiO8g+Kg1o/k4ltUXIwj4YhUPZm+5ONBbslS16uBIAbIylPPvAFJyL83+rXwN
	Dmal65WKIMAZTuqcp43xRzAe8HRkBSE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RIRQR/GA";
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780990930;
	b=UbMoLHuI1dKZzw54xGbrcyrQnPGF9VvevrwfLQ8w5LFRpK74CbKEGOcs0n7wuII/T2tH2Q
	NzFElYTVm7oFLQ9R/yNuSRK+qKaleyBtlwhYYNxUwdhbQ9KiHJ1FbzyayJv4xrqJZwFvVv
	2FWk/Q/8vr4FSkIcKcqWQ3LHKktOZQg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76524601DC;
	Tue,  9 Jun 2026 07:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4431F00893;
	Tue,  9 Jun 2026 07:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780990929;
	bh=/fLS4kGFzIziHid0UTMKzvuVWRHQkXx0n4JPVpgqLTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RIRQR/GAbofpH1QBueIh1OaTOA2SiQZBYiBJ4sw/z2ARoJtRrjfMSJo+seg140UtD
	 B1MBnFooj/G5RLf7AAh7P4li+Cv9uP7IzMoR3RYeIKN/vCkTxCnWddH+8JTvt7nFNN
	 TlNqyfe8AmJd5l55fZTKFNCAuiU8xv3zX4n0qZA+h4Dl+W3DVtnmhPFGYuqY66fNNO
	 3gKc9WVnjWrMvsSNoPXFXMEFBaLfrirLBZ/sEMu7fZ4E81lk8REgJAPZteGbmR15wy
	 X+WJG1fhLdbUgfH3NuBeN3seVnans3dTGyb41I0io7ytOYUeTFO6DjkWmgHko5L8Vu
	 7jDAW2J06CODg==
Date: Tue, 9 Jun 2026 08:41:59 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, kernel-team@meta.com, longman@redhat.com, 
	chenridong@huaweicloud.com, akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, rientjes@google.com, 
	chrisl@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, jackmanb@google.com, ziy@nvidia.com
Subject: Re: [PATCH] mm: constify oom_control, scan_control, and
 alloc_context nodemask
Message-ID: <aifDlU96HSRy72Rb@lucifer>
References: <20260609002919.3967782-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609002919.3967782-1-gourry@gourry.net>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F3EA41C000A
X-Stat-Signature: o1pnrc18tw77c8jzopeg8m6wc35pjhut
X-Rspam-User: 
X-HE-Tag: 1780990929-30787
X-HE-Meta: U2FsdGVkX18VtIoro49rcaQr5Chd0044p125CcXdFWf1yTbqVBZkFUligT1pzqYnQPdetn1Hj94/Uk4T8ISTXspDfwb1ezz6Exko5F/K3VrpIsNjmwAjTUY5JfOgcSOxLh4zZb4olfXaylzB2oGTVKRxZlrY/PSIADBjyrjCavAsPwC5TRq18Hn5N+lwT5nA7vXqqAyj8twVisR0zJaCCw6ToVpFUHCAhwRRJKAp9TuvZByMp6pfzN6Jz5TnUaGsWpEMBK0eB6etyPpUPYmtgpBkjfUi+Usgeh3h1tKbZVSu1Sgo0B1P3QQMdSaMAdQw8HDek263B+czBNE3OcnIOCEExpssHOXsRxRBo8u1Q75XxlVEJhSDoYHGdwelW1/fXhh7r12vuXTmkzf+AIettPXhz3/8TUnLzfe9Em0CS+bjbN78VH6toirL3dMnok+GX+zqJnJaXxNu0GMp5hTolt3F9CpcBgd95tMWTVCUmtyAYus1GRUJ/DuZ3bsvooAuEjkeC9eTggNv8SibDxmHVFpzmqc2GMybr08n9OuidQslQF32bezCmyk6Q2CpMbhpiXPQCYYC81yFx5ZzQQTrRNgFuouf/E6uKebyLvoGL0WOa8lEdxC+AnHioOKBMvzBtol2qZN2+4sft8sWIHBIAPYMhvdx1qMW/lqc3Z7p1brFUQguiptDzKJop08cuWS0Tnews3aASVhflbE0zXSBPLaxKpBK/RQ1oJsu1kKm40ngsiTDJmkZ8MvOMNNhem6RthzgJVrdnbsgg1SbOU+s9KB50eM0SgsNfRuT2KSc16/ui8/WAeFRou4d5507WckveS8DKC7nABKY6+mLsOTFxryG7ir5pzW50uNMMshvNDGaGL9Xf7wzDfVEsOoXxUDCY38S7Iiy+dMLjYvP/Z8aoD6UdkaFsCxz6Eielq9okYcecjpOmAk3O3WRNtDlRKwd7aj1c6cX6JZP4RWSDHG
 +wlHC5iV
 1aoT4OSu2en+5uEfnSDKX5J/h84UHLmKr3hWnnrzVer2HZMHvYuK8axqzVpcyTDcFfVPtAK9rbuN7vYLbqD94SZKdARz+hqZ4txitny15PSTpDNayAtp5UKy7CyRz3BtYJ6+rU6OxN855aUiAaWtbqGCYWUiS6Jy52yZKfWZTkueGNUe3TlcGd8Cf080jtSCScEkVsqrJ6Gr8WJWV9/boJBxdlwM/sHwSQRJvgUiOaWlOLQy+fVebYNhLpi2zBZPyo4/SZANEHy01BDS/ejHQwr1t84qC7iTyKbAL69kLnYb/1dTxG/6J3b0wT/gDmM2Qs0uGHPQmg2J2E2nXe/uqg81952Xhf1G/JLYVxGLt9j9abzRACOo9xg7tF6Yc2lK9jZWZBAHJgW3uzD0exdhVA4cZ7E8xkQs7qnul
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 08:29:19PM -0400, Gregory Price wrote:
> The nodemasks in these structures may come from a variety of sources,
> including tasks and cpusets - and should never be modified by any code
> when being passed around inside another context.
>
> Signed-off-by: Gregory Price <gourry@gourry.net>

Thanks for doing this, it's nice to gradually up our const correctness game
(as much as C can ever be const correct :)

LGTM, builds locally too, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  include/linux/cpuset.h | 4 ++--
>  include/linux/mm.h     | 4 ++--
>  include/linux/mmzone.h | 6 +++---
>  include/linux/oom.h    | 2 +-
>  include/linux/swap.h   | 2 +-
>  kernel/cgroup/cpuset.c | 2 +-
>  mm/internal.h          | 2 +-
>  mm/mmzone.c            | 5 +++--
>  mm/page_alloc.c        | 6 +++---
>  mm/show_mem.c          | 9 ++++++---
>  mm/vmscan.c            | 6 +++---
>  11 files changed, 26 insertions(+), 22 deletions(-)
>
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index 65d76a38974b..a80d38e752d2 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -83,7 +83,7 @@ extern bool cpuset_cpus_allowed_fallback(struct task_struct *p);
>  extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
>  #define cpuset_current_mems_allowed (current->mems_allowed)
>  void cpuset_init_current_mems_allowed(void);
> -int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
> +int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask);
>
>  extern bool cpuset_current_node_allowed(int node, gfp_t gfp_mask);
>
> @@ -224,7 +224,7 @@ static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
>  #define cpuset_current_mems_allowed (node_states[N_MEMORY])
>  static inline void cpuset_init_current_mems_allowed(void) {}
>
> -static inline int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
> +static inline int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
>  {
>  	return 1;
>  }
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..2101e5205fc0 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4042,7 +4042,7 @@ extern int __meminit early_pfn_to_nid(unsigned long pfn);
>  extern void mem_init(void);
>  extern void __init mmap_init(void);
>
> -extern void __show_mem(unsigned int flags, nodemask_t *nodemask, int max_zone_idx);
> +extern void __show_mem(unsigned int flags, const nodemask_t *nodemask, int max_zone_idx);
>  static inline void show_mem(void)
>  {
>  	__show_mem(0, NULL, MAX_NR_ZONES - 1);
> @@ -4052,7 +4052,7 @@ extern void si_meminfo(struct sysinfo * val);
>  extern void si_meminfo_node(struct sysinfo *val, int nid);
>
>  extern __printf(3, 4)
> -void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...);
> +void warn_alloc(gfp_t gfp_mask, const nodemask_t *nodemask, const char *fmt, ...);
>
>  extern void setup_per_cpu_pageset(void);
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index ca2712187147..919be0d9b4fa 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1815,7 +1815,7 @@ static inline int zonelist_node_idx(const struct zoneref *zoneref)
>
>  struct zoneref *__next_zones_zonelist(struct zoneref *z,
>  					enum zone_type highest_zoneidx,
> -					nodemask_t *nodes);
> +					const nodemask_t *nodes);
>
>  /**
>   * next_zones_zonelist - Returns the next zone at or below highest_zoneidx within the allowed nodemask using a cursor within a zonelist as a starting point
> @@ -1834,7 +1834,7 @@ struct zoneref *__next_zones_zonelist(struct zoneref *z,
>   */
>  static __always_inline struct zoneref *next_zones_zonelist(struct zoneref *z,
>  					enum zone_type highest_zoneidx,
> -					nodemask_t *nodes)
> +					const nodemask_t *nodes)
>  {
>  	if (likely(!nodes && zonelist_zone_idx(z) <= highest_zoneidx))
>  		return z;
> @@ -1860,7 +1860,7 @@ static __always_inline struct zoneref *next_zones_zonelist(struct zoneref *z,
>   */
>  static inline struct zoneref *first_zones_zonelist(struct zonelist *zonelist,
>  					enum zone_type highest_zoneidx,
> -					nodemask_t *nodes)
> +					const nodemask_t *nodes)
>  {
>  	return next_zones_zonelist(zonelist->_zonerefs,
>  							highest_zoneidx, nodes);
> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index 7b02bc1d0a7e..00da05d227e6 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -30,7 +30,7 @@ struct oom_control {
>  	struct zonelist *zonelist;
>
>  	/* Used to determine mempolicy */
> -	nodemask_t *nodemask;
> +	const nodemask_t *nodemask;
>
>  	/* Memory cgroup in which oom is invoked, or NULL for global oom */
>  	struct mem_cgroup *memcg;
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 8f0f68e245ba..bf76356d94fe 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -351,7 +351,7 @@ extern void swap_setup(void);
>  /* linux/mm/vmscan.c */
>  extern unsigned long zone_reclaimable_pages(struct zone *zone);
>  extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> -					gfp_t gfp_mask, nodemask_t *mask);
> +					gfp_t gfp_mask, const nodemask_t *mask);
>  unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx);
>
>  #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 5c33ab20cc20..536ce591c7ba 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4153,7 +4153,7 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
>   *
>   * Are any of the nodes in the nodemask allowed in current->mems_allowed?
>   */
> -int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
> +int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
>  {
>  	return nodes_intersects(*nodemask, current->mems_allowed);
>  }
> diff --git a/mm/internal.h b/mm/internal.h
> index 181e79f1d6a2..a2ef9512b5bc 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -668,7 +668,7 @@ void page_alloc_sysctl_init(void);
>   */
>  struct alloc_context {
>  	struct zonelist *zonelist;
> -	nodemask_t *nodemask;
> +	const nodemask_t *nodemask;
>  	struct zoneref *preferred_zoneref;
>  	int migratetype;
>
> diff --git a/mm/mmzone.c b/mm/mmzone.c
> index 0c8f181d9d50..59dc3f2076a6 100644
> --- a/mm/mmzone.c
> +++ b/mm/mmzone.c
> @@ -43,7 +43,8 @@ struct zone *next_zone(struct zone *zone)
>  	return zone;
>  }
>
> -static inline int zref_in_nodemask(struct zoneref *zref, nodemask_t *nodes)
> +static inline int zref_in_nodemask(struct zoneref *zref,
> +				   const nodemask_t *nodes)
>  {
>  #ifdef CONFIG_NUMA
>  	return node_isset(zonelist_node_idx(zref), *nodes);
> @@ -55,7 +56,7 @@ static inline int zref_in_nodemask(struct zoneref *zref, nodemask_t *nodes)
>  /* Returns the next zone at or below highest_zoneidx in a zonelist */
>  struct zoneref *__next_zones_zonelist(struct zoneref *z,
>  					enum zone_type highest_zoneidx,
> -					nodemask_t *nodes)
> +					const nodemask_t *nodes)
>  {
>  	/*
>  	 * Find the next suitable zone to use for the allocation.
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 81a9d4d1e6c0..586524bbde9c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3979,7 +3979,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  	return NULL;
>  }
>
> -static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
> +static void warn_alloc_show_mem(gfp_t gfp_mask, const nodemask_t *nodemask)
>  {
>  	unsigned int filter = SHOW_MEM_FILTER_NODES;
>
> @@ -3999,7 +3999,7 @@ static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
>  	mem_cgroup_show_protected_memory(NULL);
>  }
>
> -void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
> +void warn_alloc(gfp_t gfp_mask, const nodemask_t *nodemask, const char *fmt, ...)
>  {
>  	struct va_format vaf;
>  	va_list args;
> @@ -4687,7 +4687,7 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
>  	return false;
>  }
>
> -static void check_alloc_stall_warn(gfp_t gfp_mask, nodemask_t *nodemask,
> +static void check_alloc_stall_warn(gfp_t gfp_mask, const nodemask_t *nodemask,
>  				unsigned int order, unsigned long alloc_start_time)
>  {
>  	static DEFINE_SPINLOCK(alloc_stall_lock);
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index 43aca5a2ac99..1b721a8ade67 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -116,7 +116,8 @@ void si_meminfo_node(struct sysinfo *val, int nid)
>   * Determine whether the node should be displayed or not, depending on whether
>   * SHOW_MEM_FILTER_NODES was passed to show_free_areas().
>   */
> -static bool show_mem_node_skip(unsigned int flags, int nid, nodemask_t *nodemask)
> +static bool show_mem_node_skip(unsigned int flags, int nid,
> +			       const nodemask_t *nodemask)
>  {
>  	if (!(flags & SHOW_MEM_FILTER_NODES))
>  		return false;
> @@ -177,7 +178,8 @@ static bool node_has_managed_zones(pg_data_t *pgdat, int max_zone_idx)
>   * SHOW_MEM_FILTER_NODES: suppress nodes that are not allowed by current's
>   *   cpuset.
>   */
> -static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
> +static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
> +			    int max_zone_idx)
>  {
>  	unsigned long free_pcp = 0;
>  	int cpu, nid;
> @@ -402,7 +404,8 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>  	show_swap_cache_info();
>  }
>
> -void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
> +void __show_mem(unsigned int filter, const nodemask_t *nodemask,
> +		int max_zone_idx)
>  {
>  	unsigned long total = 0, reserved = 0, highmem = 0;
>  	struct zone *zone;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e8a90911bf88..47d3f3361fb9 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -79,7 +79,7 @@ struct scan_control {
>  	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
>  	 * are scanned.
>  	 */
> -	nodemask_t	*nodemask;
> +	const nodemask_t *nodemask;
>
>  	/*
>  	 * The memory cgroup that hit its limit and as a result is the
> @@ -6599,7 +6599,7 @@ static bool allow_direct_reclaim(pg_data_t *pgdat)
>   * happens, the page allocator should not consider triggering the OOM killer.
>   */
>  static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
> -					nodemask_t *nodemask)
> +				    const nodemask_t *nodemask)
>  {
>  	struct zoneref *z;
>  	struct zone *zone;
> @@ -6679,7 +6679,7 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
>  }
>
>  unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> -				gfp_t gfp_mask, nodemask_t *nodemask)
> +				gfp_t gfp_mask, const nodemask_t *nodemask)
>  {
>  	unsigned long nr_reclaimed;
>  	struct scan_control sc = {
> --
> 2.54.0
>

