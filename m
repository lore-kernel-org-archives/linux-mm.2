Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF99606A33B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 07:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=o6bjUeAs
Received: by kanga.kvack.org (Postfix)
	id 74C246B05B3; Thu, 26 Nov 2026 02:58:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FDA66B05B4; Thu, 26 Nov 2026 02:58:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 612C16B05B5; Thu, 26 Nov 2026 02:58:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1C46B05B3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:58:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A1BF140242
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:58:08 +0000 (UTC)
X-FDA: 85476517056.06.DE01536
Received: from mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id E8371160010
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:58:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o6bjUeAs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.47 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795679885;
	b=ERTb9neyqx46qWvlJtHzXw/4u4cnzyz8G96jqIOHJXBmbR1v/uks4rV2nWiaLASMSuxW9k
	gY7d6M2iMiQtacKt8cjakJ+eyRHbhw8hlDOhiiv/7goQVcBI8GQfKhgJYA6Er9JhbwxkZ1
	cz9tHfun92Nho2sIZqPTt9EwXwaslEA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795679885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LvwFbBDWNBefR0kvXHQjNB1xk2tLuKkLL0ZTvCS0RKo=;
	b=JvGM/53lmIzUsWGP7sQeecnK04UX6CEpvItlcGQPunrZQsv/XJxGxev16hBmDj1xETsE/6
	xPDUaYj6s/i4ipn4U7cB6HvajA35MCctAAx2Re7nT6MYhtz7UvYNpVDERrcE6MhIIozgQo
	0KZl1OqfVpcQlbzXBsieKv4JlsXtNro=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o6bjUeAs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.47 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FjE3HtgmKFq8WFEo5xKnHSon1s4J/tMgqoWdmhdBcjc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795679882; v=1; x=1796284682;
 b=o6bjUeAscT1Lwh6QHVgwf2bJ1f75R+7XJvrz13QiJ08OF1Wvc9srPIbjDCJWT656QujjEIKP
 C45RqbYJStESB/bkq3kguAp8+hhqQh35vGPP3sYNU5Hnvdp3VEuqWvW1n0n4ZDr7tBB1bRGoaUZ
 /eWlpySvzH0QeYAOBQCoxV/w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c5246ef4abf9f853;
	Thu, 26 Nov 2026 07:58:01 +0000
X-Mizu-Trace-ID: c5246ef4abf9f853
X-Migadu-Flow: FLOW_OUT
Message-ID: <b771065b-392d-4bf6-ab63-682179f6ed1f@linux.dev>
Date: Thu, 26 Nov 2026 15:57:41 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/18] mm/memcg: add folio-based lruvec live helper
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>,
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang
 <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org,
 Tianyi Chen <hi@tychen.cc>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-5-8ffea39934a6@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261124-mglru-fg-v6-5-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E8371160010
X-Stat-Signature: cj9qhw7ir9wrg8r5s9oxwxmt8g5id6oy
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795679884-338844
X-HE-Meta: U2FsdGVkX18M2PEajeCuSMBnlu/uAQlN5z9YTtNzUZAWOw8Zs82Uum4PMh4taXpjszwi0/Qvr3F1bElMOqB8ZaGZFz2KCMIdsxG0J9KkSjfj2U/AQ9HDbBGOgzharddCSGRte2OaeyceRDosTdy1vDzzA2u52+iYw0a/0LR3aDj3SHtkFoitSkMnhw8qL8eBFkNHU6EuyQFhBb8GL6Y1iG9Nx7SbxmlKMNjIxGlWpwPJfmsMpMTvp/XmTw5TAWphDrxDfP0Md/0UJQ9c4Ex356uiwcXkFspE4QMceoic5+fFJuTx74elcLvQZnEG5nXxKgksRZpEORokunHuDEdiGts4UZgIuLLv7K17Hg+KHR+m2T3lfq4J5le25E8t7j9+qx3JV+ihEDMAU1FWzGplyZLylmqXkRBQcktIldrdUdr1ogdnm1xTUHYVq8tzpozHysFNru2FRoMU98G4M9Ss8xe5YRU1f1PTRU7QqDRO9MDPfTVa5NptdYCarbRjB1DEt5XloNJ9wOdu9MD9gZbmIEovztnVMw/MaazqIxo0KlDlkhfwGZ0HxFa1ZcD2dmwMUvLBRulHWAp7rb9+g2jUgUasyzg3JESWiaw30/ZOmtqwju+KObSnRKH0aw0I26wCoT0DqHfrLWKBo8icxvHCvIenqMw9GXqO9s9PIdhHY1i7lpEMJoHihIsISzyDUgi8nqx9wWzS8EpBfGrt8Cc+OLr6Awu8Oh7WyluZJrN2uaaeWGJsLgU+ochCxzOlTtrONVZINHXBT4rcUw/LzZa7nt/7WfBmHZ6ggkOUHscz5988TClb9Z/xD4KsZqXiKq0GzIYsIStbHw4OU6b6GiuG0lvy3A3er0koc9Eu1j0RR3zswzJkRjZtTdXsNILU9UM+3AHBb3Mr7uonNMJC9oRZTfLvdH1tgxa42H4KKd4kqhQqXk0IO8SQuB2jKIpwOlyPhsYcPFOmlZTKAVmz4fQ
 Zv7MXJwk
 Zf/smwcuFXSFRsNkwhsg7/I1nQv3XB7jS5zuQzc8DFqh+KPT8UrE2+HoREM2duL0PPfAaX7gGKSaBYPpxIt9AVJAX9WCeyqEhV/OmreCe55PIas7DBy1NEQDX6kFPU3kvNlFYHKA3ocgY9lhKB0LnOGOksKHFk+yT/Z+7GziovnkbTRVFVjdGeYF+kmiInZSIiKXXHYKq6YQdlc0+IYKE2mfcLMSlG9ixujJiW2mdgihytXruaqYDSvQZ32CAQkez7toGBQ6/pittrQ2Pg47r+OiymDZsoCIkXITG/qpniZwcwMNtk09y0fFEYHvrLXm55h0kKfDgpka/7CXST20QvyStJ5Bc3hBIt7ZgUIOYLy9q8FjCuiPtEuf55SoEsDjNFC//Knib+FYWwZOjNGCVKasrRG6McHmxfudv3H/IXDAqcj80n3FJMgcyMsZNzby5H4CrJuKgGLqNoGrWYTiP1aBZGlxEmO5c/PwCyC2v9WmLMAqT9Sv0d1bOIohggKGi04Eagh+6/rOKZsZYt7hHvW5uv3ufAb/xmVMkZD4cxFzN6gMCuzwslyXNo5p/tUmpsKlyDPTawmvL16V6aC+3R9A11GVZo58t+QPgccjIbPpPIVlJvhKbbWUGm+mWiAmLgj8b7IfVNAZ1po397vPB3KSuUoUY0T23bYfZqef84s8CnNp5nqYdx5ZZeVH0sDorfN/E+Sl/EIedVIAmkFGJXvRGpvJZ4tO7Bh8o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/24/2026 2:52 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Add a helper that resolves a live lruvec for a folio under RCU
> without taking the lruvec lock.  It takes a folio directly so the
> lruvec lookup happens inside the RCU read-side critical section,
> which a lruvec-based interface cannot guarantee.  The first user is
> the lockless folio_inc_lru_refs() path later in the series.
> 
> Factor the ancestor walk out of lruvec_live_lock_irq() into
> __lruvec_get_live(), so that both entry points share it, and spell
> out why the walk is enough while only the RCU read lock is held:
> reparenting of a memcg that starts dying waits for a grace period,
> so it cannot race with the caller until the lock is released.
> 
> Move memcg_is_dying() up in memcontrol.h, next to the other memcg state
> predicates, and use it for the walk rather than repeating the open coded
> css_is_dying() test a few definitions away from where it is explained.
> 
> No functional change for existing callers.
> 
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/memcontrol.h | 71 ++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 56 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 980358bc6f49..a03f9711522e 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -571,6 +571,11 @@ static inline bool mem_cgroup_disabled(void)
>   	return !cgroup_subsys_enabled(memory_cgrp_subsys);
>   }
>   
> +static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> +{
> +	return memcg ? css_is_dying(&memcg->css) : false;
> +}
> +
>   static inline void mem_cgroup_protection(const struct mem_cgroup *root,
>   					 const struct mem_cgroup *memcg,
>   					 unsigned long *min,
> @@ -1349,6 +1354,11 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
>   	return true;
>   }
>   
> +static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> +{
> +	return false;
> +}
> +
>   static inline
>   unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
>   		enum lru_list lru, int zone_idx)
> @@ -1510,28 +1520,41 @@ static inline void lruvec_lock_irq(struct lruvec *lruvec)
>   	spin_lock_irq(&lruvec->lru_lock);
>   }
>   
> -static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
> +/*
> + * Reparenting moves a dying memcg's LRU state to its parent at any time,
> + * so anything added to that LRU afterwards would be lost.  This helper
> + * walks up to the nearest live ancestor while the caller must hold the
> + * RCU read lock: reparenting of a memcg that starts dying waits for a
> + * grace period, so it cannot race with the caller until the lock is
> + * released.
> + */
> +static inline struct lruvec *__lruvec_get_live(struct lruvec *lruvec)
>   {
>   #ifdef CONFIG_MEMCG
>   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>   	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>   
> -	rcu_read_lock();
> -
>   	/*
>   	 * The memcg can be NULL when the memory controller is disabled.
>   	 * Otherwise, the caller keeps the memcg owning @lruvec alive.
>   	 */
> -	while (unlikely(memcg && css_is_dying(&memcg->css))) {
> +	while (unlikely(memcg_is_dying(memcg))) {
>   		memcg = parent_mem_cgroup(memcg);
>   		lruvec = mem_cgroup_lruvec(memcg, pgdat);
>   	}
> +#endif
> +	return lruvec;
> +}
>   
> +static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
> +{
> +#ifdef CONFIG_MEMCG
> +	rcu_read_lock();
> +	lruvec = __lruvec_get_live(lruvec);
>   	spin_lock_irq(&lruvec->lru_lock);
>   #else
>   	lruvec_lock_irq(lruvec);
>   #endif
> -
>   	return lruvec;
>   }
>   
> @@ -1561,6 +1584,34 @@ static inline bool folio_matches_lruvec(const struct folio *folio,
>   	       lruvec_memcg(lruvec) == folio_memcg(folio);
>   }
>   
> +/**
> + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
> + * @folio: the folio
> + *
> + * Same as folio_lruvec(), except that a folio whose memcg is dying is
> + * accounted to the nearest live ancestor, which is where reparenting
> + * would put it anyway.
> + *
> + * Return: the live lruvec, with rcu_read_lock() held.  Pair it with
> + * folio_lruvec_live_put().
> + */
> +static inline struct lruvec *folio_lruvec_live_get(const struct folio *folio)
> +{
> +#ifdef CONFIG_MEMCG
> +	rcu_read_lock();
> +	return __lruvec_get_live(folio_lruvec(folio));
> +#else
> +	return folio_lruvec(folio);
> +#endif
> +}
> +
> +static inline void folio_lruvec_live_put(const struct lruvec *lruvec)
> +{
> +#ifdef CONFIG_MEMCG
> +	rcu_read_unlock();
> +#endif
> +}
> +
>   /* Don't lock again iff page's lruvec locked */
>   static inline struct lruvec *folio_lruvec_relock_irq(const struct folio *folio,
>   		struct lruvec *locked_lruvec)
> @@ -1826,11 +1877,6 @@ void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg, nodemask_t *mask);
>   
>   void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
>   
> -static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> -{
> -	return memcg ? css_is_dying(&memcg->css) : false;
> -}
> -
>   #else
>   static inline bool mem_cgroup_kmem_disabled(void)
>   {
> @@ -1901,11 +1947,6 @@ static inline void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg,
>   static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
>   {
>   }
> -
> -static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> -{
> -	return false;
> -}
>   #endif /* CONFIG_MEMCG */
>   
>   #if defined(CONFIG_MEMCG) && defined(CONFIG_LRU_GEN)
> 

LGTM.
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


