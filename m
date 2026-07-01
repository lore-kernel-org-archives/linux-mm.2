Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB697C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52CF6B00B1; Wed,  1 Jul 2026 10:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A030B6B00B4; Wed,  1 Jul 2026 10:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2D86B00B5; Wed,  1 Jul 2026 10:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 64A296B00B1
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:57:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02FBCA03D2
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:57:45 +0000 (UTC)
X-FDA: 84940512132.11.CECEA77
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2B786C0010
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:57:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="u/xNL6ff";
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782917864;
	b=bgRowgB1EWM5c1FnYV9DKzvxMK6fz7z5r1PgMSuMRRZd6V245Lsd4COKnmqd5Ehj1i+hi/
	uv00Hji+Mk75V5JXn74opg1jkqa2UOhyETDNJQHSeOCA9KVLxU+sHpajFTRiVipPkk9IIL
	0NYjWYAcNj5sU/ucNw5SbJWtAvHqclU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782917864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZxZYzr7s/jUyGjUJHT8GX3O2MqALroysxUHX5OVR6I=;
	b=X6U/LKR2XMn7iBQv/RNUhtkSxIJiLQVjIQ2XYdx6/sEK2573sZThfoifh44X5j7aRP4is/
	bP53EXc5ywdpmTK05MKqtf2R9KgKfZQsQxjUN/Lg336Suq+uMG5AueBeUjgHZij1l5XRBJ
	zd0E+fFwq1afn/GU+kdrRJSKah9xFYc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="u/xNL6ff";
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782917861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IZxZYzr7s/jUyGjUJHT8GX3O2MqALroysxUHX5OVR6I=;
	b=u/xNL6ffTYYFG6/pQpvgb7+IDpimCtA2nrVpoyuJXSR+7kaiiIrfULdup+UpIRI/qtrg7V
	GgzR0/hCpJhwoWWcGngrI4zLqG283UAA2LBp8soStkA1DrGZXKPunOUidLsR+PQee3cP6B
	RhE8vD7Y1go18ShEHgOu6+YT2Wtt24c=
From: Usama Arif <usama.arif@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	david@kernel.org,
	kasong@tencent.com,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	harry@kernel.org,
	muchun.song@linux.dev,
	peiyang_he@smail.nju.edu.cn,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v4] mm: mglru: fix stale batch updates after memcg reparenting
Date: Wed,  1 Jul 2026 07:57:35 -0700
Message-ID: <20260701145736.3785016-1-usama.arif@linux.dev>
In-Reply-To: <20260701075251.56413-1-qi.zheng@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2B786C0010
X-Rspam-User: 
X-Stat-Signature: zmrrg3gdqdfa44z3yogwma91edpgcz9z
X-HE-Tag: 1782917863-60655
X-HE-Meta: U2FsdGVkX1+qISBixi0HL1sqEsffs17/7xpmcwzVvx0zsAgOzI7V9OLGpdmlHiu/Ez404bOS/ThchnUounFKOCwk5ZkU/XajEU5UJgUphqCtvMi4sZX3tjeJ9EhHujnNOlbajujIt7IqPWlIgR8nxdghTlzw55v2SweNeF/b8bTfMvnrtKcqDZh2YQmt0X80JfxjkUuowkaAEkAc/fnOhdeUMAz3sYFuZq5cEbMqLYQLhsg/0+ERySRTTzq1R0viLvPSyCm37qrwkKS5ypSU625oEl+BP/FLXk2n4f32YmB8PnEV7BR/vB/LkTmWzdb8XcollLRlT6DeOcbdX8ueDRpmjK4eMq/pKKosNAUlngs9um896v/gQa8s0pOAPMAa1clR2f1LLkrGpbTDBQJMM1a5eCF73Mg07p3dsh9iRztiapJ7oZlQ7tH6OlpYD+L6Jd7gQP3ZlOaweVVl6GvbfmWgUbFE/q/mHwOBnAm/YvN2JI5sYeTEPEqQ323S1ApKN/qK2LhQpi5pIUh99HLUbFneq2aGYLHE40eEhNhjeWQoOdwN8YPhadSEgk/8jVC/msxue4Jjt11UPyvfZoNPK/0az2g9cqLGJKdUVTdRvp9Wlq88K9znO378TNH4R8xlmTFW7/6tZBpR0GiJ6FtBmzloSTIbuKPtCv0KofUj2NkeH2VNhGlhsGqUWhjrjLRpGK8sqafNHD+ndWgV4/T7/gtq3aD6FCMS+ORdDxFFvU70PKH4Y3zxQRPVH2fC2s1jhRNwfwoOUKP50eGpqObGMkW99yQ3E13XuVNfT2bBgtZuFe9dADRkAdiGQs5hAdnY8XRGUoOmfRcUuN5Z3YnPrvI5FuWPWw3B/YlcBp7TnLYoO0WNybcBhOS5P+vea6lFYFP1Zu4XIjgvaEWp04h9aKF4s2V5g9v64dz4p4Q3osm+BJ/xh+JFqzbJbVGknby5m9korhBoxMIbv5m1Dhv
 NRplXp9w
 LWFMm5h/fkQdlZ0cmr+MfwoROUjYt87l3wFhtEh1xZZCERmlG8snWSekSFtosALezI83vth9JkuW1WAe5yPfgoqOdCiRVLVOEXX3IRlMKVoiykDFBaXK6CLytYtJ8k6Du6X16Q3jSSyE2GJLWnnULfbdra7Te8mNZqUW+K+EU5CRvdgY5aqcXQeIGCQ6m5FV+EQdII0oXcYqnNfEMcJiKyhfZg96UUvAurlUWyRwzgjHc37P728uvUwMfDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Jul 2026 15:52:51 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The mglru page table walker batches per-generation size deltas in
> walk->nr_pages while walking page tables without holding the lruvec lock.
> The reset_batch_size() later folds those deltas into walk->lruvec under
> the lruvec lock.
> 
> The page table walker can run concurrently with the memcg reparenting path
> as follows:
> 
> CPU0                           CPU1
> ====                           ====
> 
> walk_mm
> --> walk_page_range
>     --> update_batch_size
>         --> walk->nr_pages += delta
> 
>                               mem_cgroup_css_offline
>                               --> memcg_reparent_objcgs
>                                   --> lock lruvec
>                                       lru_gen_reparent_memcg
>                                       --> reparent child folios to parent
>                                       unlock lruvec
> 
>     lock lruvec
>     reset_batch_size
>     --> child lrugen->nr_pages += delta
> 
> This will trigger the following warning in lru_gen_exit_memcg():
> 
> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
> 				   sizeof(lruvec->lrugen.nr_pages)));
> 
> And the user-visible impact of underestimated nr_pages in MGLRU was
> premature OOMs because MGLRU does not try to reclaim memory when nr_pages
> reaches zero, but there are still more pages.
> 
> To fix it, make reset_batch_size() check CSS_DYING under RCU before
> flushing the pending batch. A non-dying memcg keeps the original lruvec
> stable against RCU-delayed offlining; a dying memcg redirects the deltas
> to the first non-dying ancestor.
> 
> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
> Changes in v4:
>  - re-implement lock_batch_lruvec() in a simpler way
>    (suggested by Johannes and Harry)
>  - collect Reviewed-by
>  - rebase onto the next-20260630
> 
> Changes in v3:
>  - re-implement lock_batch_lruvec() by checking CSS_DYING under the RCU lock
>    (suggested by Harry)
>  - update the commit message (suggested by Harry)
>  - temporarily drop the previous Reviewed-by tags
>    (since the sync method has changed)
>  - rebase onto the next-20260624
> 
> Changes in v2:
>  - update the commit message (pointed by Barry)
>  - collect Reviewed-by
> 
>  mm/vmscan.c | 41 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..ca1e2a870d51 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3262,10 +3262,40 @@ static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
>  	walk->nr_pages[new_gen][type][zone] += delta;
>  }
>  
> +#ifdef CONFIG_MEMCG
> +static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
> +{
> +	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> +
> +	rcu_read_lock();
> +
> +	/*
> +	 * The memcg can be NULL when the memory controller is disabled.
> +	 * Otherwise, the caller keeps the memcg owning @lruvec alive.
> +	 */
> +	while (unlikely(memcg && css_is_dying(&memcg->css))) {
> +		memcg = parent_mem_cgroup(memcg);
> +		lruvec = mem_cgroup_lruvec(memcg, pgdat);
> +	}
> +
> +	spin_lock_irq(&lruvec->lru_lock);

Do we need an rcu_read_unlock() here?

> +
> +	return lruvec;
> +}
> +#else
> +static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
> +{
> +	lruvec_lock_irq(lruvec);
> +
> +	return lruvec;
> +}
> +#endif
> +
>  static void reset_batch_size(struct lru_gen_mm_walk *walk)
>  {
>  	int gen, type, zone;
> -	struct lruvec *lruvec = walk->lruvec;
> +	struct lruvec *lruvec = lock_batch_lruvec(walk->lruvec);
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>  
>  	walk->batched = 0;
> @@ -3285,6 +3315,8 @@ static void reset_batch_size(struct lru_gen_mm_walk *walk)
>  			lru += LRU_ACTIVE;
>  		__update_lru_size(lruvec, lru, zone, delta);
>  	}
> +
> +	lruvec_unlock_irq(lruvec);
>  }
>  
>  static int should_skip_vma(unsigned long start, unsigned long end, struct mm_walk *args)
> @@ -3779,11 +3811,8 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
>  			mmap_read_unlock(mm);
>  		}
>  
> -		if (walk->batched) {
> -			lruvec_lock_irq(lruvec);
> +		if (walk->batched)
>  			reset_batch_size(walk);
> -			lruvec_unlock_irq(lruvec);
> -		}
>  
>  		cond_resched();
>  	} while (err == -EAGAIN);
> @@ -4867,9 +4896,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	walk = current->reclaim_state->mm_walk;
>  	if (walk && walk->batched) {
>  		walk->lruvec = lruvec;
> -		lruvec_lock_irq(lruvec);
>  		reset_batch_size(walk);
> -		lruvec_unlock_irq(lruvec);
>  	}
>  
>  	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
> -- 
> 2.54.0
> 
> 

