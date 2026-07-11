Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C5E5C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 09:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB196B0088; Sat, 11 Jul 2026 05:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC546B0093; Sat, 11 Jul 2026 05:18:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1A66B0095; Sat, 11 Jul 2026 05:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 04CA96B0088
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:18:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 720F912069E
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:18:02 +0000 (UTC)
X-FDA: 84975944004.21.10C0B8D
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf29.hostedemail.com (Postfix) with ESMTP id 40C48120005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:18:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d+Asd+6Q;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783761480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkBQdQqW9l/vkDYfka0IKWJdPmtoY2v3nYkEf3NdSrc=;
	b=S0x2i2hIZyDZJoyj9va4kT9+RV12mcKBHYRxFjpQ917CexB+WxNZi8gKruhxCMwLAFAs66
	rZT59RTK2URVcicqQij27uNgzIbl923KF2BnvsJCUcC6zTumGw4Ff9+HLoj01GeGg1dXjc
	Dt7LU4kNvK4a7X8awci43tTawAEdxSI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=d+Asd+6Q;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783761480;
	b=c+LIFA8Cz8tXKazdeVUF/FgrU7at9Xr3yJFVTnrJAUP5uIW5+9c7J4mx2Vaa4I83cs3F/C
	96xhquiVGXFS6k17p7OpCHOkDBG5Xws07+DIJijnPBaQNjSBgm/u3WxY0mj3GCNAY5dXZl
	iYV+9PdFdQjo6Rv0fhvvcqPQqEdV1qM=
Message-ID: <a8698739-6987-4f4c-aa68-ff0fb98a0c29@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783761478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KkBQdQqW9l/vkDYfka0IKWJdPmtoY2v3nYkEf3NdSrc=;
	b=d+Asd+6Q4RHoaNC1k4UuSAQh6JkxcKjIkj6+0umPOhRLz62ERK8kdLcfL2hQO/TP7oatHc
	IE69EkW/tg/GGFYQpoceI9SUAQ858KEUzl1Y6OsFIUv9KKuDJ5K36IgX9IvUGdqwfMKqvX
	B4mlE2stVO0JCse0GTDPHYFAUgNOLjM=
Date: Sat, 11 Jul 2026 17:17:35 +0800
MIME-Version: 1.0
Subject: Re: [PATCH -next] memcg: move mem_cgroup_swappiness to memcontrol.h
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260710111224.2355668-1-ridong.chen@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260710111224.2355668-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: g99ksr8cgpmu1pdy434bbb6zu5ppu45q
X-Rspamd-Queue-Id: 40C48120005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783761480-884427
X-HE-Meta: U2FsdGVkX1/Ckjg2PuI5xMt3PbqPQgv6BluisDfBzarNMXM0C8+hczWaH+S9h3tYz8D5n8qsNNONQEAIxYmSz/EDpYDv5ZncMI1mw8+yCSVPcyJ4pveqSCvz9Oy4Mufbq16P4DXqMdESgIaqZLlBs1j5+vLFO+TUSYuyDIhRoIk9g9UdDA21Kar/IIxssOmE3Yj/DqrgEgcsnODm++esdu9QWnfNHicuf8ihnVBjLzBNqvOnjO6MUbetrO1uAtq5pcXE1nztIIjgeqtQbnzClzNLK63Vzkd8gqJNCQZT9vv+9CGWpmIgAM92k6jBx/9Ln3SYIWrtZOeNkrmnlIJhp8verJq8SrRgEH9dNTQ1H7VbunqqN0OErC16bDEkF6/StVMjhnYZP9W9zdHTMxQNjQ8AAocL4NQkwG230QTg1DEovxXWlRQEDD/EaCgRvKvGbf42+aLLnHPlWFDtmNReHl3YIidnaqxZ2Ez6wgKkqv4/w8PhXW9CFBdc3ycsgPLnjsvzljBcNQZT0K67kiMFc3oP7rJpqy1WO0UQmyuc+OPekINyds79HcEY2DBmyPMcE0oh0ZX6iEZ1I+nq8mztVyKqmXInhM/C4ANd8H63QBI/YmdWIHLjXBGdfpcoo5geIhQ41WoNwzUB6rjKaBK9XLSAlH5WFlsXnUSF5bqZh5M1iUKGJcBaAsXfWwOrvl/seL2hYLpXJnYja5W9Dt6P1OlF2O78rQB2xHzpkyWxfzfNGuwGsMQLqvpbnJ7yuZdd2uFc7MvfRwaBevTs4VZmCkC+q0l+B2wCTn625kIJaLZjoY2SSDHBv/XQII+e6XFXGAtSoHiLJS1ELG4a/oTMe7he/FRyq4fEeZi2FMZ0uMSZTSsFg22Vggt9NbjHDX0ouf5tKFQUv0jMUFOxd+MLA1mqk+E7Hu91aDE/I5Y9JXoZBDybZcyyHt3phQVkKQP7m0WeH4/7NI2Ojnn3gS/
 14rJg1b6
 86RCjcTlKU/kOx14L0/xJ6ugrjDBueigGfEO53m5jfDcXTuJpCbpIkm6V9PGnMVTWQhRgKNakqrN97HnBmX0PIDj76wvPQL3/OufY7YeEvzIQohY6HxchCHDRWXir/fgM2w1JQLGpR8A20UPuV+48dnzNjq2K35Tbw4t8vtTh4vH2a/eTpyrvHAYK4zGI66uP5pnucVxqYNdDFYRW+O0dZkTFzel3sA2Q7mlJhQhaoHoSpesJSChADTD+ATtqWwqB1aEZSYzoApT+/6kQsTPgwghZx4IgsX2NWhtB7Qx0gO7Ay8U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/10/2026 7:12 PM, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The per-memcg swappiness knob is v1-only; v2 always uses global
> vm_swappiness and ignores the per-cgroup field.
> 
> Guard memcg->swappiness with CONFIG_MEMCG_V1, and move the helper
> to memcontrol.h where it belongs.
> 
> No functional change for v1; v2-only kernels drop the unused field.
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  include/linux/memcontrol.h | 25 +++++++++++++++++++++++--
>  include/linux/swap.h       | 19 -------------------
>  mm/memcontrol.c            |  3 +--
>  3 files changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e1f46a0016fc..f59614956f96 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -239,8 +239,6 @@ struct mem_cgroup {
>  	 */
>  	bool oom_group;
>  
> -	int swappiness;
> -
>  	/* memory.events and memory.events.local */
>  	struct cgroup_file events_file;
>  	struct cgroup_file events_local_file;
> @@ -318,6 +316,9 @@ struct mem_cgroup {
>  	/* List of events which userspace want to receive */
>  	struct list_head event_list;
>  	spinlock_t event_list_lock;
> +
> +	int swappiness;
> +
>  #endif /* CONFIG_MEMCG_V1 */
>  
>  	struct mem_cgroup_per_node *nodeinfo[];
> @@ -365,6 +366,9 @@ enum objext_flags {
>  
>  #define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
>  
> +/* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
> +extern int vm_swappiness;
> +
>  #ifdef CONFIG_MEMCG
>  /*
>   * After the initialization objcg->memcg is always pointing at
> @@ -1440,6 +1444,23 @@ static inline void mem_cgroup_flush_workqueue(void) { }
>  static inline int mem_cgroup_init(void) { return 0; }
>  #endif /* CONFIG_MEMCG */
>  
> +static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
> +{
> +#ifdef CONFIG_MEMCG_V1
> +	/* Cgroup2 doesn't have per-cgroup swappiness */
> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +		return READ_ONCE(vm_swappiness);
> +
> +	/* root ? */
> +	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
> +		return READ_ONCE(vm_swappiness);
> +
> +	return READ_ONCE(memcg->swappiness);
> +#else
> +	return READ_ONCE(vm_swappiness);
> +#endif
> +}
> +
>  /*
>   * Extended information for slab objects stored as an array in page->memcg_data
>   * if MEMCG_DATA_OBJEXTS is set.
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 3f31b6a56788..f27e73f29195 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -366,7 +366,6 @@ extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
>  						pg_data_t *pgdat,
>  						unsigned long *nr_scanned);
>  extern unsigned long shrink_all_memory(unsigned long nr_pages);
> -extern int vm_swappiness;
>  long remove_mapping(struct address_space *mapping, struct folio *folio);
>  
>  #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
> @@ -530,25 +529,7 @@ static inline int add_swap_extent(struct swap_info_struct *sis,
>  }
>  #endif /* CONFIG_SWAP */
>  #ifdef CONFIG_MEMCG
> -static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
> -{
> -	/* Cgroup2 doesn't have per-cgroup swappiness */
> -	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> -		return READ_ONCE(vm_swappiness);
> -
> -	/* root ? */
> -	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
> -		return READ_ONCE(vm_swappiness);
> -
> -	return READ_ONCE(memcg->swappiness);
> -}
> -
>  void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
> -#else
> -static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
> -{
> -	return READ_ONCE(vm_swappiness);
> -}
>  #endif
>  
>  #if defined(CONFIG_SWAP) && defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 938f190a98fe..2d659b76cd77 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4174,11 +4174,10 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>  #endif
>  	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
>  	if (parent) {
> -		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
> -
>  		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
>  		page_counter_init(&memcg->swap, &parent->swap, false);
>  #ifdef CONFIG_MEMCG_V1
> +		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
>  		memcg->memory.track_failcnt = !memcg_on_dfl;
>  		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
>  		page_counter_init(&memcg->kmem, &parent->kmem, false);

I have resent this patch [1], as I found another issue related to it.

[1]
https://lore.kernel.org/linux-mm/20260711091157.306070-1-ridong.chen@linux.dev/

-- 
Best regards,
Ridong


