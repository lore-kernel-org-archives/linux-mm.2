Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 856CFC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77F516B03FB; Thu, 13 Aug 2026 04:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72FB46B03FD; Thu, 13 Aug 2026 04:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 645F16B03FE; Thu, 13 Aug 2026 04:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2AB576B03FB
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:25:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95209A056B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:25:51 +0000 (UTC)
X-FDA: 85095562902.22.36CD153
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id B7AB240003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:25:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=D5I5Fsdw;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786609549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d7EWP/UZyzHoakqvLZkpxTo9WbVTelGn+MRpEEiULPo=;
	b=5uoTKSrzhpUwO3Wub0n76GlH8Ixp6AeKQWNf2wBsjHygsUt4cPCnFsuyT83klzVy64HkYQ
	3l/4EhWJdRHXMlDBRCVwWjeoK/a2LR825/3b3E7MqbZV4ASpllkySrg9+SWjYVGKhnZ86p
	h3LfaDM4nb2or9+JXxEhjan2h3PbTW8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=D5I5Fsdw;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786609549;
	b=AOAhdDBYGfUq2SWVFVPFbTxQ3UgbY3iEDr+k7evdg7n5E4baJkibDpvGFvWCBg3cA6JmID
	v2hX6vsBaO2I7sZ2P71NWdlXgzsfMNS9K6Kbc+kSk9Zyz+hgdwSkklm4C8yZ10rACSiyie
	TkwxVvfcvrQxGg3V4KQfTZys4cu2AkY=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49954b88fffso4761785e9.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609548; x=1787214348; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d7EWP/UZyzHoakqvLZkpxTo9WbVTelGn+MRpEEiULPo=;
        b=D5I5Fsdwp+WMZBpLgrUV6IiBwCjnl6YJ3cI2xvjg2EuuVMbjV08jaUnQQrPJHNe0eO
         0Jpftb+MEtTEWkdxnYrqxVrwq7LRFnEXwwxDs2FNEbroXfMIBquciLVGSZU/7vGu08P8
         FqFiSdyXLQ4RS7/Uw0rNfeSBSSG2PDOfuj21+AMOR7BFkSFLXB5YIB9ZonvyMoJOSonG
         wApmo8zPzJj0LKdnYEJc1iwY/uWzt4L63TTnBZ0z8JpA6+nyqmMFGHTqEP33h7DUJXst
         EoCPWoM8CvvsT5Y0XGXoUbvfYDq1gQBWNzgK7P22rTWtXHHLvW0mDrY8JE+sVL0oy0QL
         tndA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609548; x=1787214348;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d7EWP/UZyzHoakqvLZkpxTo9WbVTelGn+MRpEEiULPo=;
        b=cizuzr3+Mwofn7jGjz20kHQnlxjNCfn6xdgl3lGWN9Y2gzUVDCjs9BQlb5M21sRzKs
         spctarm53l9Lp26BO0sBz5WR6wx/7DeMWVUKtRP9mqY+7Gm3XXqVKY+sMHoqi1NWk4eR
         lDe0uUwour5QpquCojjulXbo98WA9zHO0z948Wz/7YyM8YDgNeirFhJZ0q2Ey6rOfVSr
         fUTzz+f9nmIRUuVqdDC2ZbB3UwIVE6+POijW1N9ycd7cuivu8suGjJzlMs9iq1gOC1N2
         U78w5/LHkjmDAB/8RCc0sn43cfCI+hYk4IgUXYQR5m4++QRi8u6zsp5frJe98R7Ifvgq
         y0bg==
X-Forwarded-Encrypted: i=1; AHgh+Rp5bKZyKw2Y6kaJxvJn409s0ZH800PM994t9QAPZ9uoQ+G5JHylUp1Mr232b6H/A7SUcGrfAQ0Aew==@kvack.org
X-Gm-Message-State: AOJu0Yx3J7jroMu4UaJqkYVcEswq/Eg2gfdnKNaDnxUBK91Vcz6fmObY
	x2m2U9Cm1GhXEfNo/8t6IrAkO47UllRn/EC9BzPnWA8K4r34QwW7VicFjDR/tTe1zjM=
X-Gm-Gg: AR+sD12v8GcF6/B05/h8eLefBpLPXx63u9w10DlfWiyw9k81MMNMP3h6zhQZ+I30JeP
	HZo9b6YJo1ZXmn74jJ7+KA3HDQJbmu3k576O63dQw3fv+fCT23g3YJtGm8csrjKNoEDfIML5PzJ
	mapmwRIa3YVLEWl7Z15cU13LnXN7nu/XqLHnPbD9ErzyhOgbkXhlXdkr2Gm2c1Mb9UvWnIL0CQZ
	sBdnz2Umqi4NIel4Nh77WbSD0B8VJdeJspvwrhbOSDx3xdxN6TL9SlOZpO2k1a07pJTPz2UQklj
	1+cOg1A6ib4Kj07s/Azdc25P4JxkgYG5j5uZfCE8J8y3WHzIui63dw0kSZo+Nqvs/InLai/Z3iC
	nvW5KBi1STvOfjUrn9sr3HuoJTmkWSXVKTfllcmE6s9RIWeIsgR4FWnYqsCCemGdUx+keb3YVwQ
	x/XfgmhGMMKKasy9axAGhcdeCwZPmSwD+hC3bPtje8rCOqjoxxljW2idhpmpou3xhtRvvQeww=
X-Received: by 2002:a05:600c:e489:20b0:499:8467:3f2d with SMTP id 5b1f17b1804b1-49984673f49mr6182385e9.19.1786609548419;
        Thu, 13 Aug 2026 01:25:48 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499820f5d26sm32668385e9.1.2026.08.13.01.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:25:48 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:25:47 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] memcg: remove the soft limit rbtree
Message-ID: <an1_i8BeRtUA01xs@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-6-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-6-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B7AB240003
X-Stat-Signature: 4t4g93off7yabwgjuqs59yzrj4dxerk9
X-Rspam-User: 
X-HE-Tag: 1786609549-694585
X-HE-Meta: U2FsdGVkX1/PtdGF7nOq8imWIbZvJqHOhXu5RzqkZn68QnbIzXbfl2B7pnhsZKr17tbTJeImKTgD6EiF4i+M6ACUinbxlyygyG2YRpuZA6l5cxOuURjhRn6d4NHPlpI+PF7skhrETVgDt1u7LlwPPqQaISYqX5NsJgAlBv95JpaawxoNeJR9WDRl9S0kDj/nNQdUgaJVUSgVTGalQtAnJs03JIwQiMIFoSRV0NprFNjSWqJJhy2ddEG79TcrDbBQKVmIV4sHQnEKerVxt6AWO6PScmR9TdPCfwejA+/8D5uSVLiLwL9oNb8MayyLkc4YH7miq4QbWT5M9K/DrqFr2N3H/PuJ1luMHY3ao3p2xlzDkk+AgkQfWgx2UjiJNIv4k2FHd/Gw816BVIsiioFK3ehhge+o1tDQgsTNpI3yOFhE/J7CX85gxdPKDD+0muwTjMj/NWDHY1D/MD5Ddto8OBs1CCkxkGcCHita++zv6dVQiW5uti7W3vrEci+kqTQIBo4JhWjt/Mv8AX/USRy2DdFXAJKbGg2JjYs4z5yf3ftR6xISZopJs49ypnCc3ijfTXSXnZa6SHLPRUbXx1JJ8rtRPn/zWkYazltUPqqorkMxIkKcBAnOlbXuNHhymRuBYKLBb2PZGruyZl7uqJGhy9ZsBd63Em5ankSZyDV5GVlJtqP1Bg/p7ScDMACcZccpdxizqDqJYWROEcj146bzO1IH/l98By//ckafbuKzJK9MrrNKtYQvfguRxCB5o3CjlOXucEXh53kxL3DhWskjXdTv/6W+4E+NwbfbPhVpCoztN4gr0WewGb5usOO4CW3vELHDFi+hpBTHclGFliWtoBWjwSWvm9dnd//aAM+HrgbSwoJVbxu0YQLTvccOhXZ/ASnIKvwO1QrtvRhbeOhqQyePsoOt6im74XUpEFLMoLs7NsT5GvSAuP/Ie+YOlsRMrGA5nTsLqwLhTSSS/96
 KCYZdzOH
 oUShqZ0IOf5hBSniT232P5n/lxjzclk0b42RnFmHDFxkmTkej4624kOJwaYCNAj91/k/Qk8lYBHNXih6rQR01RhMTzaUDVNV4rAAsqytZHyScTJuOWg/HEs1Yh4v8t6qvcJrHRmz9lmPp2QSmoervV05kM+h2GO9XfmseKMK2kzVzl2Dkq5gm0lUHoYmrEDb3uIyKZ/jnrQDEpN17vovVIXhGy73yFlLC3WDBgh9vF3uIggng5dsqn8RBmelZlfhIjj2qLPOd1zPWIuuLUoxKA8mYD38eYdDMWcbWzUzYtpNc8c5o5eZpy7YAtqN9jsszgxTWxn7DMUTFiO0nMPa5VhH3wbn3Ff+Rspmjd0KBv7ofLTS0NWhKKT486TGnOQQzXpUhJzuMg2VSXIo9Tc0hP4j+JW3YDqBoOglj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-08-26 13:31:59, Shakeel Butt wrote:
> With soft limit reclaim gone, the per-node rbtree of cgroups in excess
> has no readers left. Remove the tree, the helpers maintaining it, and
> the subsys_initcall that existed only to allocate it. memcg1_check_events()
> no longer needs to feed it, which also drops the last caller of
> lru_gen_soft_reclaim().
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/memcontrol-v1.c | 176 +--------------------------------------------
>  mm/memcontrol-v1.h |   2 -
>  mm/memcontrol.c    |   1 -
>  3 files changed, 2 insertions(+), 177 deletions(-)
> 
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index b38b8d0f7f51..475f998b7643 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -17,23 +17,6 @@
>  #include "swap_table.h"
>  #include "memcontrol-v1.h"
>  
> -/*
> - * Cgroups above their limits are maintained in a RB-Tree, independent of
> - * their hierarchy representation
> - */
> -
> -struct mem_cgroup_tree_per_node {
> -	struct rb_root rb_root;
> -	struct rb_node *rb_rightmost;
> -	spinlock_t lock;
> -};
> -
> -struct mem_cgroup_tree {
> -	struct mem_cgroup_tree_per_node *rb_tree_per_node[MAX_NUMNODES];
> -};
> -
> -static struct mem_cgroup_tree soft_limit_tree __read_mostly;
> -
>  /* for OOM */
>  struct mem_cgroup_eventfd_list {
>  	struct list_head list;
> @@ -99,133 +82,6 @@ static struct lockdep_map memcg_oom_lock_dep_map = {
>  
>  DEFINE_SPINLOCK(memcg_oom_lock);
>  
> -static void __mem_cgroup_insert_exceeded(struct mem_cgroup_per_node *mz,
> -					 struct mem_cgroup_tree_per_node *mctz,
> -					 unsigned long new_usage_in_excess)
> -{
> -	struct rb_node **p = &mctz->rb_root.rb_node;
> -	struct rb_node *parent = NULL;
> -	struct mem_cgroup_per_node *mz_node;
> -	bool rightmost = true;
> -
> -	if (mz->on_tree)
> -		return;
> -
> -	mz->usage_in_excess = new_usage_in_excess;
> -	if (!mz->usage_in_excess)
> -		return;
> -	while (*p) {
> -		parent = *p;
> -		mz_node = rb_entry(parent, struct mem_cgroup_per_node,
> -					tree_node);
> -		if (mz->usage_in_excess < mz_node->usage_in_excess) {
> -			p = &(*p)->rb_left;
> -			rightmost = false;
> -		} else {
> -			p = &(*p)->rb_right;
> -		}
> -	}
> -
> -	if (rightmost)
> -		mctz->rb_rightmost = &mz->tree_node;
> -
> -	rb_link_node(&mz->tree_node, parent, p);
> -	rb_insert_color(&mz->tree_node, &mctz->rb_root);
> -	mz->on_tree = true;
> -}
> -
> -static void __mem_cgroup_remove_exceeded(struct mem_cgroup_per_node *mz,
> -					 struct mem_cgroup_tree_per_node *mctz)
> -{
> -	if (!mz->on_tree)
> -		return;
> -
> -	if (&mz->tree_node == mctz->rb_rightmost)
> -		mctz->rb_rightmost = rb_prev(&mz->tree_node);
> -
> -	rb_erase(&mz->tree_node, &mctz->rb_root);
> -	mz->on_tree = false;
> -}
> -
> -static void mem_cgroup_remove_exceeded(struct mem_cgroup_per_node *mz,
> -				       struct mem_cgroup_tree_per_node *mctz)
> -{
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&mctz->lock, flags);
> -	__mem_cgroup_remove_exceeded(mz, mctz);
> -	spin_unlock_irqrestore(&mctz->lock, flags);
> -}
> -
> -static unsigned long soft_limit_excess(struct mem_cgroup *memcg)
> -{
> -	unsigned long nr_pages = page_counter_read(&memcg->memory);
> -	unsigned long soft_limit = READ_ONCE(memcg->soft_limit);
> -	unsigned long excess = 0;
> -
> -	if (nr_pages > soft_limit)
> -		excess = nr_pages - soft_limit;
> -
> -	return excess;
> -}
> -
> -static void memcg1_update_tree(struct mem_cgroup *memcg, int nid)
> -{
> -	unsigned long excess;
> -	struct mem_cgroup_per_node *mz;
> -	struct mem_cgroup_tree_per_node *mctz;
> -
> -	if (lru_gen_enabled()) {
> -		if (soft_limit_excess(memcg))
> -			lru_gen_soft_reclaim(memcg, nid);
> -		return;
> -	}
> -
> -	mctz = soft_limit_tree.rb_tree_per_node[nid];
> -	if (!mctz)
> -		return;
> -	/*
> -	 * Necessary to update all ancestors when hierarchy is used.
> -	 * because their event counter is not touched.
> -	 */
> -	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
> -		mz = memcg->nodeinfo[nid];
> -		excess = soft_limit_excess(memcg);
> -		/*
> -		 * We have to update the tree if mz is on RB-tree or
> -		 * mem is over its softlimit.
> -		 */
> -		if (excess || mz->on_tree) {
> -			unsigned long flags;
> -
> -			spin_lock_irqsave(&mctz->lock, flags);
> -			/* if on-tree, remove it */
> -			if (mz->on_tree)
> -				__mem_cgroup_remove_exceeded(mz, mctz);
> -			/*
> -			 * Insert again. mz->usage_in_excess will be updated.
> -			 * If excess is 0, no tree ops.
> -			 */
> -			__mem_cgroup_insert_exceeded(mz, mctz, excess);
> -			spin_unlock_irqrestore(&mctz->lock, flags);
> -		}
> -	}
> -}
> -
> -void memcg1_remove_from_trees(struct mem_cgroup *memcg)
> -{
> -	struct mem_cgroup_tree_per_node *mctz;
> -	struct mem_cgroup_per_node *mz;
> -	int nid;
> -
> -	for_each_node(nid) {
> -		mz = memcg->nodeinfo[nid];
> -		mctz = soft_limit_tree.rb_tree_per_node[nid];
> -		if (mctz)
> -			mem_cgroup_remove_exceeded(mz, mctz);
> -	}
> -}
> -
>  static u64 mem_cgroup_move_charge_read(struct cgroup_subsys_state *css,
>  				struct cftype *cft)
>  {
> @@ -336,7 +192,7 @@ static void mem_cgroup_threshold(struct mem_cgroup *memcg)
>  	}
>  }
>  
> -/* Cgroup1: threshold notifications & softlimit tree updates */
> +/* Cgroup1: threshold notifications */
>  
>  /*
>   * Per memcg event counter is incremented at every pagein/pageout. With THP,
> @@ -405,17 +261,8 @@ static void memcg1_check_events(struct mem_cgroup *memcg, int nid)
>  	if (IS_ENABLED(CONFIG_PREEMPT_RT))
>  		return;
>  
> -	/* threshold event is triggered in finer grain than soft limit */
> -	if (unlikely(memcg1_event_ratelimit(memcg,
> -						MEM_CGROUP_TARGET_THRESH))) {
> -		bool do_softlimit;
> -
> -		do_softlimit = memcg1_event_ratelimit(memcg,
> -						MEM_CGROUP_TARGET_SOFTLIMIT);
> +	if (unlikely(memcg1_event_ratelimit(memcg, MEM_CGROUP_TARGET_THRESH)))
>  		mem_cgroup_threshold(memcg);
> -		if (unlikely(do_softlimit))
> -			memcg1_update_tree(memcg, nid);
> -	}
>  }
>  
>  void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
> @@ -2391,22 +2238,3 @@ void memcg1_free_events(struct mem_cgroup *memcg)
>  {
>  	free_percpu(memcg->events_percpu);
>  }
> -
> -static int __init memcg1_init(void)
> -{
> -	int node;
> -
> -	for_each_node(node) {
> -		struct mem_cgroup_tree_per_node *rtpn;
> -
> -		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
> -
> -		rtpn->rb_root = RB_ROOT;
> -		rtpn->rb_rightmost = NULL;
> -		spin_lock_init(&rtpn->lock);
> -		soft_limit_tree.rb_tree_per_node[node] = rtpn;
> -	}
> -
> -	return 0;
> -}
> -subsys_initcall(memcg1_init);
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index 1e394269c613..fd611e66859a 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -41,7 +41,6 @@ bool memcg1_alloc_events(struct mem_cgroup *memcg);
>  void memcg1_free_events(struct mem_cgroup *memcg);
>  
>  void memcg1_memcg_init(struct mem_cgroup *memcg);
> -void memcg1_remove_from_trees(struct mem_cgroup *memcg);
>  
>  static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
>  {
> @@ -98,7 +97,6 @@ static inline bool memcg1_alloc_events(struct mem_cgroup *memcg) { return true;
>  static inline void memcg1_free_events(struct mem_cgroup *memcg) {}
>  
>  static inline void memcg1_memcg_init(struct mem_cgroup *memcg) {}
> -static inline void memcg1_remove_from_trees(struct mem_cgroup *memcg) {}
>  static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
>  static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1d3339520809..b68f1f16ae54 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4394,7 +4394,6 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  
>  	vmpressure_cleanup(&memcg->vmpressure);
>  	cancel_work_sync(&memcg->high_work);
> -	memcg1_remove_from_trees(memcg);
>  	free_shrinker_info(memcg);
>  	mem_cgroup_free(memcg);
>  }
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

