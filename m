Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D3DC606A333
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 07:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LHuP4vQ0
Received: by kanga.kvack.org (Postfix)
	id A14CF6B00EF; Sun, 22 Nov 2026 02:54:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C72E6B05B0; Sun, 22 Nov 2026 02:54:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5796B05B1; Sun, 22 Nov 2026 02:54:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 529C06B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:54:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0293716062D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:53:59 +0000 (UTC)
X-FDA: 85461991440.21.616A0B7
Received: from mta0.migadu.com (out-102.mta0.migadu.com [91.218.175.102])
	by imf05.hostedemail.com (Postfix) with ESMTP id CD39E100005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:53:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LHuP4vQ0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.102 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795334038;
	b=8UQGW9HRfOL77rkGCa+Jr+ZcnbkU+Zi5DwVYuotoEGc7n8FCpRSBwOqI1C+W1zCidiIdUt
	6UEyckSGA0iKv2k/OjWRJbih/LHVyrZMHSbbaCTtdcxjfp1Y4PoU7g94EIT3Iig/kTo/dh
	8dTfRXFWtMiOqnhhStwfqQp+8unVi7M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795334038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOcmoHBzKwzqRhuvzie4cVIDXlVg/sxRWH6argNn2FA=;
	b=oLj2PCWfBq8HGqB2hTNbf7QEU6pHILVEayi6GEEwpsdc3Q7ylbUe3zM/H1quooB+isxZmY
	IXR+Uxb9UoeQrjyTEClfl3w7yo1y5DlRu4WY7fHjfhXHjIXGeybL51aIlIh/t8iNKXR2QB
	KlJppaqlae/TkJixvIw5lbAq/akYg2A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LHuP4vQ0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.102 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=zkTOqn+rNjlOfmFIyhoF6rAk683YaTwi6c+aGGYoa60=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795334036; v=1; x=1795938836;
 b=LHuP4vQ0LbfH0TkiIc7OPnMdIxBu3k1zCmUWVwzAtOnjVmf0a7rwmnpud7efP4ws1s4i4kHF
 1hxO0Ln+Tqt7z1JUMNar2v1E2mG9HikoNFNE88J416rT3vWkwiJ2+7S1dIDKNCSy/sr0MuM4ANQ
 MzPpOjU+kVGOeQw/LXMgJJJo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 862c2fb0d81c39f5;
	Sun, 22 Nov 2026 07:53:56 +0000
X-Mizu-Trace-ID: 862c2fb0d81c39f5
X-Migadu-Flow: FLOW_OUT
Message-ID: <42207e26-ba7f-4df5-8c80-71fa1b84d26e@linux.dev>
Date: Sun, 22 Nov 2026 15:53:44 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/17] mm/memcg: add folio-based lruvec live helper
To: kasong@tencent.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>,
 Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org, Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>,
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>,
 Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh
 <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 damon@lists.linux.dev, linux-doc@vger.kernel.org
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-4-9eee2fe97a2d@tencent.com>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261119-mglru-fg-v5-4-9eee2fe97a2d@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q3i1ia4ojw14j86o345c7cdbsy1esjsh
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CD39E100005
X-HE-Tag: 1795334037-10175
X-HE-Meta: U2FsdGVkX1+yb5//OP2eYlfu4Hp3u6XIX/F/2TM88V/ETZWAwxesUXkNyAcIZ2hHfxmLo6MQUkVDXaTl943W9FyAfiuAh+vRvyE+JnVJ+pjTcWJfgL/wV+OyAxTBSkUH3SXxKman7Gg5GntO0rrKNb6DpB3D0+Dpdsjqo9u/UH1XjCNmhgQ2xCJyi72noW7COgg+MHsMTL2HhATdb43frFgdCXOiioc+839nZaYnu8YGv8GlCC4p1NBy1HuDrtIHhR6NNhE9/Leh0GqNCwxx+iXm7wnV4w0nA2Oq5L7ZPBstVX2qj8rF21GmtRNbJG2BR7u4eOfuwkdIVQ4O14DE01luvHTM4Jqzm6Q2CstLKwQlirhX1RsJP3JqeHp4NEm/IcDoD5pYtBpSfzA68NNmiukANw5laIxKEbSIDx94utVjtzjNdlndd25zoFV+Gez4h56mrJNfk8qRI2J5bhahHqKjAqIAEkGm5gu99HWXY5V5PjpbSrfBZeTdRDVl/A6VecYqV61yA3WXyOFVluiOXFN2SXjwPLT5Sr8d4FWJ/WwSi6SXNsqYK4Xw7A04wmSsRmoKhmPocVih4ySmHYp42avWgXJh5hzpr0sMWLLU+47Anyf/8M9RujfhRTI9nv3nZ3+KCOyb4KhCTl2q/STIV2a/xxP4HhFyRoQ+gIKVZlz6eo0IStpoOUcXW3GfzeZrEYVOp512rF5GzHWhuxADKCWZ2aX0ZvuIpwJhXBERXCEnaJG0qqVtD8u7Mw5wKsSE7jJ1XlaSCzhxd//MKHAfBOjPxn9kz5/ba/ZVbdgKb0rnf1cMPjKVQ5FiGGQI6HeUJn3NE2RA87MUgqRP5wvS42OlkjYNmCy+cYBX2le0d60HGcS6rqHBvaDyRnYuz73ktXjsd8GBGHdMibGugOvR1FwmxNqSzyqq6sWLPJRGT1FE2ozv7NuAtzXvCd7IvKNFmI+SlH2BmO20CYWu6HZ
 e2L3QFbY
 cM8Z/DzqL7lAW0kZ2fs/vyIjLy9wHj02LeIbqMf9ZhCIQQvEt2ED93JwfHpQJYu3/xMX70ZbKBrJAgp1e3y8uOxin3BjhKp/QgxRSmAHEWLFjHdyJJ2cOjYkkfFF/6Y/N1NDuOJhnFa7EUAU73YgURv/TM7bS4p+U/un1cfUmRxkQpxFWUPTBb9KQJBn9rXNMbSispl21zvLMm43lEZBrpqBJPSow8GWUW/4MKtmtjGInvhR575fiqTdHOwZ1KEib2AzeW1t9Yaj7i6MvJK5rCzWgQhdTOkRgd6/fLUc1BWa6C1VNVObxYK5+N/+mpkT/UQVHRHewufNw3GKxjqL0dqHdtIVUMtggGioHapATc1/nwVfDqRGOvCOttxsRzVfzodN7EZdq7zq2aEbkQ7Bo2HZEUCFiNSOohSSDxnZFIe/0VyUvVB4oWbQ8PCDcuVaLggpuysqWSIcfk0996Ql36f0AASQKD2ilaTJgUZsQrobzaHukXE9YD57nyDHFBItA6oBdhEWyktmUmR5FeHhqmgy7LDL3LcAZTbPPKsF5Q9Lv+g6OknFT+MJABGsgT4zd0uuIM6OXpmrY3y1tqeeGVou6fn/6tdIdAyfl0LIG/uGHyuCdNq5zhitqvFnrgnsmJwKrjqwLqZhXsxw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/19 05:03, Kairui Song via B4 Relay wrote:
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
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Some nits bellow:

> ---
>   include/linux/memcontrol.h | 71 ++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 56 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 980358bc6f49..441a5d57e723 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -571,6 +571,11 @@ static inline bool mem_cgroup_disabled(void)
>   	return !cgroup_subsys_enabled(memory_cgrp_subsys);
>   }
>   
> +static inline bool memcg_is_dying(struct mem_cgroup *memcg)

Let's make it const for @memcg along the way.

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

Cound @lruvec be const as well?

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
> +static inline struct lruvec *folio_lruvec_live_get(struct folio *folio)

const folio?

> +{
> +#ifdef CONFIG_MEMCG
> +	rcu_read_lock();
> +	return __lruvec_get_live(folio_lruvec(folio));
> +#else
> +	return folio_lruvec(folio);
> +#endif
> +}
> +
> +static inline void folio_lruvec_live_put(struct lruvec *lruvec)

Ditto.

Thanks,
Muchun

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


