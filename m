Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50443606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 03:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=v4LNimE/
Received: by kanga.kvack.org (Postfix)
	id E839F6B05B2; Wed, 25 Nov 2026 22:11:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E341C6B05B3; Wed, 25 Nov 2026 22:11:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4A336B05B4; Wed, 25 Nov 2026 22:11:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE9D6B05B2
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:11:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 942FF80280
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 03:11:29 +0000 (UTC)
X-FDA: 85475794698.25.7D74C56
Received: from mta1.migadu.com (out-221.mta1.migadu.com [95.215.58.221])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2FB9B40007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 03:11:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="v4LNimE/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.221 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795662687;
	b=kvBiYJx0z61jQHDBUIUkfEBLPnnvCZFjfU3eNYxQ2zlsLbrPUGkqqb/gN5H4Eg1xjEGf3Z
	NfcmtsePXynTM8ALth7L+m2NuEAD3Dncj4Yf5WOI1EuMZwzFUEiqlhJD1D39zgFZ1JFTDe
	v7qJON3Q8Z7OmgH3oE1t2fGfgFRS+to=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795662687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYSs5d5Lp36V/22Iomfy0//nynBZd0fYykzrM/pot3A=;
	b=ghRtzxoedoLhIiYQGQlG3Hy4QxFP4BSY95qqhJsLGFMNFe3TOjaRZl3dLmF0CeRSrhJU9S
	haoUBpNePbH6EH3Eo/goHpZt56Kwhl/WpxpQBEXDFb4obfnKEfrknSzAt9tqwiygQrZGas
	UaQrQeD9xKM1T93ibu1MqKtCHELsYT0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="v4LNimE/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.221 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vvqUdZiid5uV0/NNKfcYRq6aGGte+Ajub0kcJ88W1xw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795662684; v=1; x=1796267484;
 b=v4LNimE/gC1YH2gkJSPSsR1U5WkvOLP+v30bRf7crUd8FH1aTK9tP82zmAxUbhbOCOFfvj24
 5YC0nbgSj0t9VOLVGdrL204D2lqRQooqnbMMKSrBrHTraKgDztTpeGwr705aKwG9VKpi9tMNas7
 Ed/aQnfk8eKQdTvJZTByNDt0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c118c9884fa7c50c;
	Thu, 26 Nov 2026 03:11:24 +0000
X-Mizu-Trace-ID: c118c9884fa7c50c
X-Migadu-Flow: FLOW_OUT
Message-ID: <82a7b4da-a67a-4e53-bdad-8c0551585cec@linux.dev>
Date: Thu, 26 Nov 2026 11:11:10 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/18] mm/mglru: make generation page counters atomic
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
 <20261124-mglru-fg-v6-4-8ffea39934a6@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261124-mglru-fg-v6-4-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2FB9B40007
X-Rspam-User:
X-Stat-Signature: x1ag5w93cpenmihzqccqya3cpx43tftu
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795662686-449874
X-HE-Meta: U2FsdGVkX1+p1X0WVAyrqMY02WmHu4Z7VJQnPi5af6qO9OeRl0PHfm74h3V0IbbUdlyIqal5t1p5Xa2QSk1fJZBgg6hio+ITemMF7SLm7CtA7eu6gUXhxWTc4ogZn83MVtLm6DxVEvLQN7G26xVg7StDEBArGxNMDyUbUcooa0E3i+aMggyEuseyIEcAHA2qFRHBp35bh/HLM1eDhzS6Ptl+5j5cSRUmiIRgzW9AdloTo/96iEB2y9coLmsAPqDZ60MJ7YSLJUMtyUnxAfj6QgEeanqe0W8Gb54VJrK/rvteiaUrESDJ6ghqfZtgi8XsH4YAHaB0D5vNSM3U94ArGLlerJBDoP1spYDXHyKCq4ngznTdqihJZPwNbiECh74MWRIwMHilWa+FUatrSc3EvgxWMaTPt6IGcBFcXz11lZZcrnH1cSwGF5H+daaZ8UEkxVsY7Fiv0JvSOcI87amY67dty8DsF64quSNlWrqIYuW8t+EJ3I7q30oIfuyoLxzYlAe5hrhXgLdlbPuxwNyuYq7hyouEzHhcFsUpglbDWCzC3jS0atEief+ScWy5NZpuvGxVFnC8hI1QT8a9UEqgfxPaw7OYG5AudQiyIxwIQA9zzJESB+A8DPrQIhdFfh1OX8Z3YeGp3jEqo4lOyZcdgUXtQxjXLvkHK0X5plp0cuIvS7lU+QMYW8v/SI+g43ye7OqX2MMTU8lOdhz2Al/BCZYH083p+DaUzr9DR1Fop1zsY5HMouJY2SfmfcX6PkPrU0c2/oOOsQmI5lGCD8ywx5GOszCStZwqOGCWms+wmxlsfLJ5dGt9fmBS6zxTDjmN4B9klKdeGMUv5vssqAaBDOM8NSPceHXE5KhzD8TTDH+v73i1lMOxDipwTW+HEDdlfsx7Za+Gx8KxXUlyhigSwONdpgJeB5c5do5xuogCoRelhqjAy1M5fEtFAnf5kx/IG79hJgQJ+71CiRBHQrf
 Jimm4EUQ
 PjfuaL7Sa48Cyg19Ij3JwkLJQWxE5d0E6mbHDKDX4erO8iUvp/+vkdytBXhUv9gb1J1HCKgI0tu8qI+muvi/Ni2/RVsaXdLWvfqIpXfHQNCkm/zOfko0VS2F8c99FXsKDqBgQ50JzTZEKi4xwnBIRe7QeWvP+8+JHXyr8Yy8yd5Cxm7t5/vMGJVM4lkGfZQilE1pJqKQXUvBvkajRNJqPHELyvlJXcHS1p/2PJjXr7gtelW/Z7GA2/4MHZZAGZV7xQWHjeZBT1YcsZM3hLjWKUlJEi3q8R1Nle95mi/RN7PGjjKRVxYswf55e76U0qkXXYysbcP3VS4JdMr1wY9qHsYpSYnERXwFNI5aKTU2ffeM13esG/yQppx6dL+WVRHD9W1/QiS3uclmUzAMRZJjfj1cAcsXFXjS57GvnQ3KEVl27u7rCR9iLu3mcXiBeSjjJz+T/1Qz4k2ooJIYZORRztx4ps1DXmuyEElv4+RdJhj1qIPTPibQvMBsSsYZUBTbXaG34loEyZLoce1DVTfi2GOi7bfMultTg0CrrIKyzw5wJqV2a5MOEYlaKeSm3xQDQCKpT1renceNlMcu7c1HY3lbM/tSu4ofmKCP2Zkhl+JrofIjbrSOhKiUYb9t9Do+qtvTeKgjNC9eXa8qMoVZUNEhOihxRT5m2VCrIYcWaeuyuEZCuT1OvCEo0IYH4C1L4QXji/dXt5EepuPXQvl+g6irRa1T83zYsDHjP3rfqKgyXrYxielZ2sGC7zw==
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
> No feature change, convert them to atomic so we can update them without
> holding the LRU lock. A temporary underflow is fine: readers clamp a
> negative value to zero, and the counters only need to be eventually
> consistent.
> 
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mm_inline.h |  6 ++----
>   include/linux/mmzone.h    |  2 +-
>   mm/vmscan.c               | 26 +++++++++++++-------------
>   mm/vmscan.h               |  2 +-
>   4 files changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 2edb9beef6d3..46beded51c7d 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -265,11 +265,9 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
>   	VM_WARN_ON_ONCE(old_gen == -1 && new_gen == -1);
>   
>   	if (old_gen >= 0)
> -		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
> -			   lrugen->nr_pages[old_gen][type][zone] - delta);
> +		atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][zone]);
>   	if (new_gen >= 0)
> -		WRITE_ONCE(lrugen->nr_pages[new_gen][type][zone],
> -			   lrugen->nr_pages[new_gen][type][zone] + delta);
> +		atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][zone]);
>   
>   	/* addition */
>   	if (old_gen < 0) {
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 6a2ad0cff795..4e85bb520f76 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -554,7 +554,7 @@ struct lru_gen_folio {
>   	/* the multi-gen LRU lists, lazily sorted on eviction */
>   	struct list_head folios[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
>   	/* the multi-gen LRU sizes, eventually consistent */
> -	long nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
> +	atomic_long_t nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
>   	/* the exponential moving average of refaulted */
>   	unsigned long avg_refaulted[ANON_AND_FILE][MAX_NR_TIERS];
>   	/* the exponential moving average of evicted+protected */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bc7579d47f9b..202e0f874b23 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3350,8 +3350,7 @@ static void reset_batch_size(struct lru_gen_mm_walk *walk)
>   			continue;
>   
>   		walk->nr_pages[gen][type][zone] = 0;
> -		WRITE_ONCE(lrugen->nr_pages[gen][type][zone],
> -			   lrugen->nr_pages[gen][type][zone] + delta);
> +		atomic_long_add(delta, &lrugen->nr_pages[gen][type][zone]);
>   
>   		if (lru_gen_is_active(lruvec, gen))
>   			lru += LRU_ACTIVE;
> @@ -3971,11 +3970,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>   				break;
>   		}
>   		flush_lru_batch(head, &batch_end, target_list);
> -
> -		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
> -			   lrugen->nr_pages[old_gen][type][zone] - delta);
> -		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
> -			   lrugen->nr_pages[target_gen][type][zone] + delta);
> +		atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][zone]);
> +		atomic_long_add(delta, &lrugen->nr_pages[target_gen][type][zone]);
>   		if (!remaining)
>   			return false;
>   	}
> @@ -4093,8 +4089,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
>   	for (type = 0; type < ANON_AND_FILE; type++) {
>   		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
>   			enum lru_list lru = type * LRU_INACTIVE_FILE;
> -			long delta = lrugen->nr_pages[prev][type][zone] -
> -				     lrugen->nr_pages[next][type][zone];
> +			long delta = atomic_long_read(&lrugen->nr_pages[prev][type][zone]) -
> +				     atomic_long_read(&lrugen->nr_pages[next][type][zone]);
>   
>   			if (!delta)
>   				continue;
> @@ -4625,8 +4621,13 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
>   	child_lrugen = &child_lruvec->lrugen;
>   	parent_lrugen = &parent_lruvec->lrugen;
>   
> +	/*
> +	 * The child is offline and the lockless updaters, which hold
> +	 * rcu_read_lock() over the update, avoid racing with reparenting,
> +	 * so the read/set/add operations below are safe.
> +	 */
>   	for (gen = 0; gen < MAX_NR_GENS; gen++) {
> -		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
> +		long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
>   		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
>   		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
>   
> @@ -4634,9 +4635,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
>   		list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
>   				      &parent_lrugen->folios[gen][type][zone]);
>   
> -		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
> -		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
> -			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
> +		atomic_long_set(&child_lrugen->nr_pages[gen][type][zone], 0);
> +		atomic_long_add(nr_pages, &parent_lrugen->nr_pages[gen][type][zone]);
>   
>   		if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
>   			__update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
> diff --git a/mm/vmscan.h b/mm/vmscan.h
> index c2cea36289f3..6551f0a6691a 100644
> --- a/mm/vmscan.h
> +++ b/mm/vmscan.h
> @@ -126,7 +126,7 @@ static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
>   	unsigned long size = 0;
>   
>   	for (int zone = 0; zone < max_zone; zone++)
> -		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> +		size += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]), 0L);
>   
>   	return size;
>   }
> 

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


