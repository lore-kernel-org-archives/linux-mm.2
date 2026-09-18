Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 780B0C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 18:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AC9F6B0098; Fri, 18 Sep 2026 14:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E226B00AA; Fri, 18 Sep 2026 14:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626826B00AB; Fri, 18 Sep 2026 14:14:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1E06B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:14:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B41A9807A3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:14:16 +0000 (UTC)
X-FDA: 85227682512.02.BEACBC9
Received: from mta0.migadu.com (out-108.mta0.migadu.com [91.218.175.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id 20FA9120004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:14:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lyPhmtDX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.108 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789755255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=boW6IDDNzO9pEnZVQAmnXDxUH+UPgmW6l22NMMYR6+M=;
	b=mQEOvEt/MzCB26B45TzHsO9qi6E3DaM689hspxrT2Te5g6kkS4/PECKktuoDeeIUNGboyf
	W/Lp52oyixKfyR7NioBaSMBD9LbYSBUMZoWXqHJYzWn7n62X5pB9v50yVANkE9vHXjEGxA
	i01LxuzSybL+tbtbEyY9pv31t/H7wh4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789755255;
	b=y55sNxgb1KodVCb7aC3Rrr9irPy4kOgDZiugPD6XIGtGPYJvlibwsOau3hkcPZbLCtiJBQ
	nA8XVpDicmp1st8auUu1I7u4ez37taknVytNVj3pEMcpF5gli3ujKk3d8SkVFW3UBoP19k
	7RI36BYDbjcSEFpeTUij/Pbkbze3Fq0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lyPhmtDX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.108 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FqlRlZbpY0aC0R6VarAfbvRXZpO3mHZ5xrmMHvOClk0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789755249; v=1; x=1790360049;
 b=lyPhmtDXHCj/isT64daxeJUXm+dxFtgqafQb8prfx+GRY6jEmgO2xyIF5X2QFgtMzhN6ggAc
 +BbuT5ZosduM3OLC2FfyNvBbPzzELOyIJooEYtChJPz07w886CpBkYRMrwXz7HCujRHmpt+b+6+
 Dze6BDBK6PHvSvvRA6GT00FM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 49d6f23acb7f0677;
	Fri, 18 Sep 2026 18:14:08 +0000
X-Mizu-Trace-ID: 49d6f23acb7f0677
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 11:14:03 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: bingfangguo@tencent.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Bingfang Guo <bfguo@icloud.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] memcg: manipulate memcg private ID references by ID
Message-ID: <aq1_Qhid7-62pHcW@linux.dev>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-3-5bbf3220d88f@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-3-5bbf3220d88f@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 20FA9120004
X-Stat-Signature: m4nkf4p5mwuj5k9a7wdkibz5q8h833rz
X-HE-Tag: 1789755251-705543
X-HE-Meta: U2FsdGVkX18BCYSbtdUsk+i3ien5ixWwT8SX1hIixHsPdsyYQhvkLXjOlLEy+fr4eI70m/yFzu4KVyBqM+HtCDY5s8PKrlwrl70sXaYOJxHDo/n2Qo6hgHkPmH7QMpQQHlSDLpWiqy85WRKcsI2wij3pYpGLQ6E5VGg5nxxAgCMLmhx59WofGPrZit3SrGSwfJfw2pqQCpD34jyOskWpAmD7ljDCAFVBgqpuJNTAmDzpBzuJ/Kae/TTNe8EYnMvXeix8TzPPnm6ksH94//XK4WPOV4wd7znSz96dYkJGFfvPjAkLdlJTsgnXhgsaTRPvq5H0OA/jhz9JsyVKwK3llh3koQorfQbo72M+orx8/mc/2xu5ZlIfWqFOND7Z+yjydL0wRN9JQk77gWSvMfffvj2ubkh350gw44qqF0r2qxdcGG+suCq40F8gnPkmjzIkRm6m7lT+njJ7SrGJG6HCOgwzrIYEO8wsxeoc2OvQGjrKMIuIcc3TSO33NLY2jhEkot6gJyLzlyEEZk4k+wotTvwvd5N+E04s7lFOOXBa4u5beeZeykRE5QO5S9pQfviPAxotmTs5ocIyU/jNkTu89riwME24bDZoaS850dyelovgLnLUN/z75PxBJdwHtIXxaV3ptFhlnwKiwlQb72yaQ9ldeUdzQlcLgPNzjYgNIKetQgU95z0mOny+wLobxvd3clR2Tl9mRJyEVIihiQGwjQFZedwDjSwfsLoCUlFHyuNEW0GsjDH5xoGqSUeldKXdMxFbUqMPshzRx9qqK8il4sVkxG+S20UyCYVL1WeVCBGt10AZaAdgiXwZHsQR6WUZ8s7ZqnVNp8G5VaPtQVQVGQXDyEAIDlN5ebdpNbqLtDJLsyIWRqWU0w1ipbdIKfrF7WXiU7HZSTPzSOVa2MaNqsWmVeNmospJ4aOLTmLo95/WxjLVuOWxkY6MJEuIKevKdFowxymwM6ZDNXutTK5
 awr9h0e4
 8pg1ekZwZBuk9c6OVAPA4P8IbqE9qp8mlVHxdKTfhvLG2qiVNysjPnPh2VvtNppj9SbXDZNnFP8jWfSQGTpDUn8yfwoRFo7rSNNkDI5hgx5NPUZM8haqVFfcalkrdEMvu6ph5sR/DZdA8+812xwti78gPbE0SaOHnv5UTwihq0ib257e155KNBpzdDfo+tsZXl9m9YlX8brsWSkrXTjrvoMmrOAeJbsimXfMPXX/YUoWMYGAH07NjHxaBh6841CiRPwN1IJwT171LSPJcba4o6x37F8TtRJtzsJ5fh82i13JYCkE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 05:18:42PM +0800, Bingfang Guo via B4 Relay wrote:
> From: Bingfang Guo <bingfangguo@tencent.com>
> 
> This is a preparatory work for moving memcgid from memcg to objcg.
> 
> Swap entries retain a private ID rather than a memcg pointer. Once
> private ID references are moved to objcgs, the ID can also outlive the
> memcg to which it was originally assigned.  So it's better to make the
> get and put functions accept the ID itself instead of the memcg.
> 
> Rename mem_cgroup_private_id_get_online() to
> mem_cgroup_private_id_get(), and make it return the ID only.  If the
> memcg is already dying, the dying memcg will still be used for charging
> and stats accounting in v2 swap charging path. But they are hierarchical
> and will be reparented after offlining so it doesn't matter.
> 
> Make mem_cgroup_private_id_put() take the ID and resolve the reference
> holder internally. Convert swap uncharge and charge rollback to release
> the reference using that ID.  This introduces an extra xarray lookup for
> now, which will be removed in the final patch.
> 
> Separate the online-state reference release into
> mem_cgroup_private_id_kill(). The offline path already has the memcg
> pointer and can call the underlying put helper directly.
> 
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> ---
>  mm/memcontrol-v1.c |  7 +++----
>  mm/memcontrol-v1.h |  3 +--
>  mm/memcontrol.c    | 32 +++++++++++++++++++++++---------
>  3 files changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index ed015fdd95123..b7f2868885071 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -268,7 +268,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
>   */
>  void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
>  {
> -	struct mem_cgroup *memcg, *swap_memcg;
> +	struct mem_cgroup *memcg;
>  	struct obj_cgroup *objcg;
>  	unsigned int nr_entries;
>  	unsigned short private_id;
> @@ -298,9 +298,8 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
>  	 * if the ID refers to the root memcg.
>  	 */
>  	nr_entries = folio_nr_pages(folio);
> -	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
> -	private_id = mem_cgroup_private_id(swap_memcg);
> -	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
> +	private_id = mem_cgroup_private_id_get(memcg, nr_entries);
> +	mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
>  
>  	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, private_id);
>  
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index 23be2512702dc..281425273ea97 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -27,8 +27,7 @@ static inline bool mem_cgroup_private_id_is_root(unsigned short id)
>  	return id == mem_cgroup_private_id(root_mem_cgroup);
>  }
>  
> -struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
> -						    unsigned int n);
> +unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n);
>  
>  void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>  				       struct mem_cgroup *parent, int idx);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bfe53e4392f09..ed44b3e7ac938 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4082,7 +4082,7 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
>  	}
>  }
>  
> -static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> +static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
>  {
>  	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
>  		mem_cgroup_private_id_remove(memcg);
> @@ -4092,7 +4092,22 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
>  	}
>  }
>  
> -struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
> +static inline void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	rcu_read_lock();

Use lockdep_assert_in_rcu_read_lock() here instead of taking rcu as both callers
already taking rcu read lock.


