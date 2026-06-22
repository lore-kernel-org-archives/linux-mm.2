Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FE3ACDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 08:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4B46B008C; Mon, 22 Jun 2026 04:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BC716B0092; Mon, 22 Jun 2026 04:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EED016B0093; Mon, 22 Jun 2026 04:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE6036B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:25:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B334405BD
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:25:15 +0000 (UTC)
X-FDA: 84906863790.28.386605F
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6CC8310000A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:25:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=smail.nju.edu.cn header.s=iohv2404 header.b=gtHoClqp;
	spf=pass (imf14.hostedemail.com: domain of peiyang_he@smail.nju.edu.cn designates 18.132.163.193 as permitted sender) smtp.mailfrom=peiyang_he@smail.nju.edu.cn;
	dmarc=pass (policy=reject) header.from=smail.nju.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782116713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aFSO6AHP6WYDaFwfcRLcXH+hUoEb893SICpnQ5kYTyQ=;
	b=07Q83FibFziNr1qAkCKmvKRM2a0Hz4bIrmUkUHUHrMQ7gHk1Yv1XDSkhF4TvdpNmcsqny5
	yCDtB6ROUGyZhGNnzHNGSJ5NyhaTajn1/EUSD6QRTOAEbPQ1ykX2AFsUYR8ochUJPSra1A
	1NxmJHEWn0mLwWFfaOxfaZHjm6rvlus=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782116713;
	b=AKmVMVpFeXJt5+GhSEMVMN8BzeM7U1r2HgSG42OoujDxIyo9EIounz2v0OTTgaME1e+ujK
	egY0vfaRRa81CHtGQRql0r1yqFFDN8pCBapT7IfgszduL7XZVbHbrx71Ok/sUx7SMwyuSR
	W5MXVbkSE+pQxfpnRe7Ne6oVfXVp6tQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=smail.nju.edu.cn header.s=iohv2404 header.b=gtHoClqp;
	spf=pass (imf14.hostedemail.com: domain of peiyang_he@smail.nju.edu.cn designates 18.132.163.193 as permitted sender) smtp.mailfrom=peiyang_he@smail.nju.edu.cn;
	dmarc=pass (policy=reject) header.from=smail.nju.edu.cn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1782116673;
	bh=aFSO6AHP6WYDaFwfcRLcXH+hUoEb893SICpnQ5kYTyQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=gtHoClqpYIcEkd/a59j4lc/MN9ja5Mw+K8KAgmq7ph6eWBvepTiXyVd92Wec8Klqu
	 exKz5/4dNdW0uYte7Uf5WRBne/1uebAK7VyikgrXKX8GKe8VTCzCMLBIc6f4DIC0N3
	 5X52rdp0IfgIcfI4Tv9+lQeUEBrxTK+Yi8uwnkDQ=
X-QQ-mid: zesmtpsz5t1782116664t87087744
X-QQ-Originating-IP: aohLYNy9A2EbmAsTJnCfZLbDfB7g8+Zs+Hv+rcxIqUU=
Received: from [127.0.0.1] ( [202.119.42.245])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 22 Jun 2026 16:24:20 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 16359244240173991143
Message-ID: <F5EBCFC495955241+61489c47-c792-43de-a8f8-4b1030f4ab6a@smail.nju.edu.cn>
Date: Mon, 22 Jun 2026 16:24:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, harry@kernel.org,
 muchun.song@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn>
 <20260622073703.79258-1-qi.zheng@linux.dev>
Content-Language: en-US
From: Peiyang He <peiyang_he@smail.nju.edu.cn>
In-Reply-To: <20260622073703.79258-1-qi.zheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:smail.nju.edu.cn:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NbXhg4FPraGZvkJcoK2wx4EMCxM/ZY7G1k07T7EPXosyZJEgmTufylD2
	IOvRgHesiNTd/rQB1MT2/7aznJM4TzClCaDqtnl3U5m+Qa0AVLtumbg9TLGR8zVtA2NDhjf
	4KTpd3abWiAF6fG/Ij0uKZQ6T6K80xPkB0KeqRZTfepjgYa04YMsCXqxZR8eoDVN5pXmyyN
	wGOAmx44Sgd6PcpqIegSQutzTQxnVbAcVyYl2lNzTgq7INs6yh9zkxa1nhqL0qFmqwCK58T
	fdjoKfn0+i/2x6/tjkBLz+I+0fO6KWpoP18D8x0zMn1z1SqPdKeku54R5hdxOOWKZPMq58/
	oUMFm6pUmXQQKTNwPJPNTOAZSKcZ6eZhUm/5ZoVlHo/C09InXuGQjvCIlHmTUR0DOgDAtrD
	OCCEg2dzXDgKF8nml09OcU1fipB7P1GOeKzUrAadnz6P/SqpOQjmwBLhJJ2mTxu6AbBOW1x
	q8w/+06z8221pHToGkJgOLjUy5X2A/rZD/XM9Rqaha+GuW1+cdUPh/nUM6H86WzGDD0TmWL
	/Jbu3xYQKpsPflVYgGbFVZRsN/3Ft9pqvwMAocjbEBj8mpeDmpeo4U98CnL12fkAGGfaU6s
	SSTvehSBxsAGD0244pE+lZfAhjmsuBbzkP0WaSRZHHDe4m8gpxWTTicDQHs9fve5mlKF3s2
	L4ny71wYmfJjlCHJHYHCDnHTx9zvqrBjaIyhAbetyUk/SLlQuBmNclnFeZ6qIcmCbRnH39F
	evguyp5UNXzBzSlbCIiQYKPWaQ4tgQd/rER84z43FiXTZQMhdbN+lQNFwPr7rV11YRv/rFw
	Uww4mxm5HyFazUFUwKpy+m7dp5r5gS1Q2PGmHtDt9Gg40+6TsoeDw2l7IKFB0JjdukD8goH
	jD7Oway98NGg9StAAHErY2VLDSYfyqz6atmrtKPudMAeMFdiQh/LzL820jll2JJAtP8ebX8
	FeDSj/L+h9liXrFg8B9k0YEsWMtkzwoQh4az7cvu5LdlXdfKOnf7+tY10rtZpqdeVbSOCDI
	01ELGmrwDs+iK3iiZCr1KLv2SWrVlaUKhIKm7DHpJrDzqASSuzu6E6ve194cyg9GqM776li
	nv0MDd/7QTd
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: nhh5qderdgockc5xr9qaz797hhuaj3si
X-Rspamd-Queue-Id: 6CC8310000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782116710-306498
X-HE-Meta: U2FsdGVkX18dU1e+Xs+df40jVuY+1XnJc9LLoomcXboho7oLmHYjXc41eba/AN2mGx11wm/KYgrhEl5Q9tcYmFVSgtrJ8Lo33tCIZTT5R+qLRgSXg78zaPPFc8CUgYCRzVveiilWTm2B04615i6fgHb+m0vyvlDDNgw3im3YPsTHTYU+aX8ziTvwb1uIDbryoYhruJBLQb/vlex+apBJeS1a7qdlf/ANoWXd1+M4o5sMakeNVVDsvYJqyKVjFz9hHLvnPunFvrrOQKklZlwVBY58mKMkmepZ0xBrgJ6TW7iqtmMs+OaJLhTHOSIJCcrr+qbmFYYVC6xdlNRVLVcOw3JsbrOq4TR5aUHVR3Xuvse2Wg9F5ou+m/YNdBpnQBKsAjPdzWB8KwosHb2dnD/FCfsnfkd+SbpxfowAugapJQxKXrsJwS6ui6u1Upz/qiQ6OLbmdVrO3BCK2aVrQXmk2L31EpJtFxq5c8BGlFfnNBeAGyUIs9LZfKIS7/4UJOMl0CWX2JLeyA5CV+GKv/kZy1t64B2Cquyd4UGGrM/GYSTM5xfbMKNj8JoieX69BkDNQl3poMGK3IHIyFY8LZtyh2BoelpOYqmSK2kqDjL7OaKWBAkdbZ7RLvPOKz3VNwie6ZfLQkD2DFo1zhXnVwpBtupqMHQjsryD6OvArKToqunTNAEbOp55+/qqz2a6B6a4cpGXtilrH5c+YM1U/lfn197Zb0yOlfkhb50uDLADTze+FILWrqrq20+NKam5Yv3R0liPtWfcS42z4lbgELDqMMSZiKRkgWyA+iEAlTWIDj7zB1Q7EIdSxwWT+cUjV5BAfwNc31FKxlV55Fo1gxS4CiBWBa03hAkZ7zSjLvJzskKuPVHvp+TFQ1OoFj1qkAwBftdKl+uNricnBcfGEoHpR4ivRzG/R8hWjx/0dxnNdCzk6GAcGClrG3Xr7eYEpI+WR5snjOeOmHSfWrAunSM
 1w0WMFdM
 XKt52MaH/XdG6rluNwi8ePyi+tURytVPn6BQE3Vq2IxaiLeM3df+4Ro+fPZ5hGnzysgmsy3uU9Nof2zTiO86WtBukiLSjIgqBFwmJkajONtcNqFK48f5k3EignwACOGAEAoxLW4TQbPIJr3pvJDGjxA9cmwHvoJ+69Q5y+v40fmhy0laqE6FE76TRHxAXwol9BkcomrcXDXClMzD8dyNPJCjBbE2PMM42JgVllx2wamjvSMqim2EGeco2Hk3Uy7PT9qeUV3AOEclE2AfPyIIqvbVkZKlsS5Wf2Nqn0L/YubujOAavA6vNRXaktGqzSjcCG9amlBwseN/B4IZaoLqOo+N7Q2czKuHu0ejblcdG0CP07GKxafPr/ppcOCLrvK47612hM8ONFpIp10siLZKqSBJl4Q+wXByGLvuGksXnzy70nAJ4yMacg6QNCZB363y1XC5O34B8Gtbq8/CQBHtOxQc262HnOYy0MEfJqhpDnKexJN8hTagnLmDX/dnNuFQ9tqckVTuRpwW6w8s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Qi,

Thanks for confirming this bug and proposing the patch. The fix I previously proposed was indeed incorrect. I have applied your patch and tested it using the PoC script that previously triggered the warning; no warning is observed anymore.

Best,
Peiyang

On 2026/6/22 15:37, Qi Zheng wrote:
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
> This can trigger the following warning:
> 
> WARNING: mm/vmscan.c:5867 at lru_gen_exit_memcg+0x26f/0x300
> RIP: 0010:lru_gen_exit_memcg+0x26f/0x300 mm/vmscan.c:5867
> Call Trace:
>   <TASK>
>   mem_cgroup_free mm/memcontrol.c:3972 [inline]
>   mem_cgroup_css_free+0x76/0xb0 mm/memcontrol.c:4241
>   css_free_rwork_fn+0x125/0x1260 kernel/cgroup/cgroup.c:5575
>   process_one_work+0xa0d/0x1c30 kernel/workqueue.c:3314
>   process_scheduled_works kernel/workqueue.c:3397 [inline]
>   worker_thread+0x645/0xe80 kernel/workqueue.c:3478
>   kthread+0x367/0x480 kernel/kthread.c:436
>   ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>   </TASK>
> 
> To fix it, add lrugen->reparented to remember the new owner of a
> reparented lruvec, and make reset_batch_size() charge pending deltas to
> that owner.
> 
> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  include/linux/mmzone.h |  4 ++++
>  mm/vmscan.c            | 43 +++++++++++++++++++++++++++++++++++-------
>  2 files changed, 40 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index ca2712187147..0d572db2ef64 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -584,6 +584,10 @@ struct lru_gen_folio {
>  	u8 gen;
>  	/* the list segment this lru_gen_folio belongs to */
>  	u8 seg;
> +#ifdef CONFIG_MEMCG
> +	/* the lruvec this lruvec has been reparented to */
> +	struct lruvec *reparented;
> +#endif
>  	/* per-node lru_gen_folio list for global reclaim */
>  	struct hlist_nulls_node list;
>  };
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..64362cbed814 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3262,10 +3262,37 @@ static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
>  	walk->nr_pages[new_gen][type][zone] += delta;
>  }
>  
> +#ifdef CONFIG_MEMCG
> +static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
> +{
> +	struct lruvec *reparented;
> +
> +	for (;;) {
> +		lruvec_lock_irq(lruvec);
> +
> +		reparented = lruvec->lrugen.reparented;
> +		if (!reparented)
> +			break;
> +
> +		lruvec_unlock_irq(lruvec);
> +		lruvec = reparented;
> +	}
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
> @@ -3285,6 +3312,8 @@ static void reset_batch_size(struct lru_gen_mm_walk *walk)
>  			lru += LRU_ACTIVE;
>  		__update_lru_size(lruvec, lru, zone, delta);
>  	}
> +
> +	lruvec_unlock_irq(lruvec);
>  }
>  
>  static int should_skip_vma(unsigned long start, unsigned long end, struct mm_walk *args)
> @@ -3779,11 +3808,8 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
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
> @@ -4563,6 +4589,8 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
>  			mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
>  		}
>  	}
> +
> +	child_lruvec->lrugen.reparented = parent_lruvec;
>  }
>  
>  #endif /* CONFIG_MEMCG */
> @@ -4867,9 +4895,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	walk = current->reclaim_state->mm_walk;
>  	if (walk && walk->batched) {
>  		walk->lruvec = lruvec;
> -		lruvec_lock_irq(lruvec);
>  		reset_batch_size(walk);
> -		lruvec_unlock_irq(lruvec);
>  	}
>  
>  	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
> @@ -5784,6 +5810,9 @@ void lru_gen_init_lruvec(struct lruvec *lruvec)
>  
>  	lrugen->max_seq = MIN_NR_GENS + 1;
>  	lrugen->enabled = lru_gen_enabled();
> +#ifdef CONFIG_MEMCG
> +	lrugen->reparented = NULL;
> +#endif
>  
>  	for (i = 0; i <= MIN_NR_GENS + 1; i++)
>  		lrugen->timestamps[i] = jiffies;



