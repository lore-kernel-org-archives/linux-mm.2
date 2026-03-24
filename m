Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEACFF532E5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 06:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 395F26B00C3; Tue, 24 Mar 2026 02:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36DF96B00C5; Tue, 24 Mar 2026 02:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA2C6B00C6; Tue, 24 Mar 2026 02:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1869B6B00C3
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 02:41:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B81EC141601
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:41:44 +0000 (UTC)
X-FDA: 84580010928.07.1D912F2
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 362BA80003
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:41:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774334502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9rYqXGbvbqvjuvF6jpOFsvPDasDwCb+AY+ODDxbSRmU=;
	b=e0Q14EdaKtVkjY8tp+jqQ0yjocwSCJ1McwVM49dcey/UVakYgJz5wcAjdxPsRhoYFZvSCL
	+uq/Xf3yEL/JC6Bl6u3c+dOzaKlZ8d3qVb8u+G5Fflqs0iNQQcAXsswi6ScGlN1jXItOiT
	Aq4U1r9Xc6XpreHpvMzApsIrhpNaUv8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774334503; a=rsa-sha256;
	cv=none;
	b=niYPJWFPIKhGuiq1CYMgTiHGocFn+z78ppMRLPdPEF/FywLmvw3y9uly5Nt7BUpoFx3EGw
	fjmlQ9+t8h04rrN810EB0twLSSOL7mCw5ypddEO4/hgwquQFoAo4lLZTQiYddAuHJOlEVj
	fYBL2zqpBued3EgY9S2DGdkeUeiZlNU=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fg0n31cZ9zYQv4L
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:41:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 735A140579
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:41:35 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP3 (Coremail) with SMTP id _Ch0CgC3llMdMsJphGQUCA--.15460S2;
	Tue, 24 Mar 2026 14:41:35 +0800 (CST)
Message-ID: <9fbb618b-19d1-4d03-8488-7e4c52c859ff@huaweicloud.com>
Date: Tue, 24 Mar 2026 14:41:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] mm/mglru: restructure the reclaim loop
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>,
 Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-3-2c46f9eb0508@tencent.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20260318-mglru-reclaim-v1-3-2c46f9eb0508@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgC3llMdMsJphGQUCA--.15460S2
X-Coremail-Antispam: 1UD129KBjvJXoW3JFy7AFWDKFW3Zr1fJFWxtFb_yoWxZFW7pF
	ZxG3y7ArZ7JrWagws3tF4v9r45A3y8Gry5JrWfAw1SkFnIqFyIqr12kryFyFyUur95Zr1S
	qay2kr18CayjqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 362BA80003
X-Stat-Signature: qxrxgtw7g4tthfr6m476hq4ehw83zupd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774334499-812021
X-HE-Meta: U2FsdGVkX18+1hFjQXO068Awywh+KjcUFYOgkZ4XwybHcUZHMhJVVD+JpntsGFbF8WSnvY9XImNZZ7iH4a/N8jFXBlKanBAZXeIHbm0Z/1bCDgxc6BsRsejSi/sQjcg0t4Kiw0B4KYzZ3vmlEAk+W+gPbbYss6PbM2l2MbIZMp4tXR7CzVbIv2KVJWhJbATNL0ZbNk6aM+8hWHr3UdDuqQdmG56FQ5ydGK7ixBPLMJ9b1uiy9ImAfNdigK+wUK6FHhdbvrNEz0ee4OX3XBBJXBnPS4QJD32jDfb8/R/I0VOxXE9aid7HaU6EbxAEzfSqGcpvIRPMYDzFr3h9Z3DirV0MIyMz/FqGRa/7GMhxD5v37bs53fLnMEtldIVbvtvpmfXcznGPMO38H9WA6vFL0SiqvRwgIFuRTA90IosHiudcZShLIQwksgLb8dUB2vPTDlvUDSf36Qov8ppolhOGRs6te00OeUwcnU6lYiJlEEXSGBBtAhDoNS7D2/cxbs8O7BWKtWjLUw2LHlMECRbIJBY18Xwrr6bas3A2vDZRn3hJLy7GnCmgvtNlWbRA1CZUHjfJk3FjP1v2sppUEcqkc6AFpM8bYGET/aYbLJdzI7bwh49SZ5QU5GSQQGu7Mpja+cvENpIGM/dCFvA6/ZP6wg3L9+KNm6EN9UrfD7g+Su8KFUZNol7HGFJoiImiynZfpST1o8JAJrOk5BovAadUOjmjVIktKztqBsjvOHO9F1S/iJOy7vlj8bEMcI/U47ffC167J3PHCsqVQ8Wn3H217GVPEiXiCO4qpRg8x21PY29zLyOU0sN6Zjew6vMPOw64TkAfZzczMfG7oSqpZVEEBjopQLn1UGcD14PnsnMSYsP/NUf1lmbSVRZtv11zcInc3Ok4lSnBhRdRMkc5x8zjJxiN4S87q/M5HSe3b01eJFcqf9tJPhsjiU/mF33X5GdJANzuoknSaogQdciMAEC
 nvzQCerY
 lhtoXacsf6D9ZIikORzOENxWEx3wUlwz/eIDo5B3xwIOKXyC5YRyWNh+/k5uMT8JCSQyCqSAKg5Ps/qOtifdGlLW9854NuP19kIWy3uABZEBKw2mh2+Z04y0+EThM8PK1kxEwvj2WwEIRF5lnu0lrOSpfsIogVuykZJHDT+xak9NMtkrFmlbkRnatxl695Rwy92xB6K6RjBcljMMVRfhQcoilNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/18 3:08, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The current loop will calculate the scan number on each iteration. The
> number of folios to scan is based on the LRU length, with some unclear
> behaviors, eg, it only shifts the scan number by reclaim priority at the
> default priority, and it couples the number calculation with aging and
> rotation.
> 
> Adjust, simplify it, and decouple aging and rotation. Just calculate the
> scan number for once at the beginning of the reclaim, always respect the
> reclaim priority, and make the aging and rotation more explicit.
> 
> This slightly changes how offline memcg aging works: previously, offline
> memcg wouldn't be aged unless it didn't have any evictable folios. Now,
> we might age it if it has only 3 generations and the reclaim priority is
> less than DEF_PRIORITY, which should be fine. On one hand, offline memcg
> might still hold long-term folios, and in fact, a long-existing offline
> memcg must be pinned by some long-term folios like shmem. These folios
> might be used by other memcg, so aging them as ordinary memcg doesn't
> seem wrong. And besides, aging enables further reclaim of an offlined
> memcg, which will certainly happen if we keep shrinking it. And offline
> memcg might soon be no longer an issue once reparenting is all ready.
> 
> Overall, the memcg LRU rotation, as described in mmzone.h,
> remains the same.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 74 ++++++++++++++++++++++++++++++-------------------------------
>  1 file changed, 36 insertions(+), 38 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d48074f9bd87..ed5b5f8dd3c7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4926,49 +4926,35 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  }
>  
>  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
> -			     int swappiness, unsigned long *nr_to_scan)
> +			     struct scan_control *sc, int swappiness)
>  {
>  	DEFINE_MIN_SEQ(lruvec);
>  
> -	*nr_to_scan = 0;
>  	/* have to run aging, since eviction is not possible anymore */
>  	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
>  		return true;
>  
> -	*nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
> +	/* try to get away with not aging at the default priority */
> +	if (sc->priority == DEF_PRIORITY)
> +		return false;
> +
>  	/* better to run aging even though eviction is still possible */
>  	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
>  }
>  
> -/*
> - * For future optimizations:
> - * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
> - *    reclaim.
> - */
> -static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
> +static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
> +			   struct mem_cgroup *memcg, int swappiness)
>  {
> -	bool need_aging;
>  	unsigned long nr_to_scan;
> -	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> -	DEFINE_MAX_SEQ(lruvec);
> -
> -	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
> -		return -1;
> -
> -	need_aging = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
>  
> +	nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
>  	/* try to scrape all its memory if this memcg was deleted */
> -	if (nr_to_scan && !mem_cgroup_online(memcg))
> +	if (!mem_cgroup_online(memcg))
>  		return nr_to_scan;
>  
>  	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
> -
> -	/* try to get away with not aging at the default priority */
> -	if (!need_aging || sc->priority == DEF_PRIORITY)
> -		return nr_to_scan >> sc->priority;
> -
> -	/* stop scanning this lruvec as it's low on cold folios */
> -	return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -1 : 0;
> +	/* always respect scan priority */
> +	return nr_to_scan >> sc->priority;
>  }
>  
>  static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
> @@ -4998,31 +4984,43 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
>  	return true;
>  }
>  
> +/*
> + * For future optimizations:
> + * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
> + *    reclaim.
> + */
>  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  {
> +	bool need_rotate = false;
>  	long nr_batch, nr_to_scan;
> -	unsigned long scanned = 0;
>  	int swappiness = get_swappiness(lruvec, sc);
> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>  
> -	while (true) {
> +	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
> +	while (nr_to_scan > 0) {
>  		int delta;
> +		DEFINE_MAX_SEQ(lruvec);
>  
> -		nr_to_scan = get_nr_to_scan(lruvec, sc, swappiness);
> -		if (nr_to_scan <= 0)
> +		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
> +			need_rotate = true;
>  			break;
> +		}
> +
> +		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
> +			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
> +				need_rotate = true;
> +			break;
> +		}
>  
>  		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
>  		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
>  		if (!delta)
>  			break;
>  
> -		scanned += delta;
> -		if (scanned >= nr_to_scan)
> -			break;
> -
>  		if (should_abort_scan(lruvec, sc))
>  			break;
>  
> +		nr_to_scan -= delta;
>  		cond_resched();
>  	}
>  
> @@ -5034,12 +5032,12 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  		wakeup_flusher_threads(WB_REASON_VMSCAN);
>  
>  	/* whether this lruvec should be rotated */
> -	return nr_to_scan < 0;
> +	return need_rotate;
>  }
>  
>  static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>  {
> -	bool success;
> +	bool need_rotate;
>  	unsigned long scanned = sc->nr_scanned;
>  	unsigned long reclaimed = sc->nr_reclaimed;
>  	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> @@ -5057,7 +5055,7 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>  		memcg_memory_event(memcg, MEMCG_LOW);
>  	}
>  
> -	success = try_to_shrink_lruvec(lruvec, sc);
> +	need_rotate = try_to_shrink_lruvec(lruvec, sc);
>  
>  	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
>  
> @@ -5067,10 +5065,10 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>  
>  	flush_reclaim_state(sc);
>  
> -	if (success && mem_cgroup_online(memcg))
> +	if (need_rotate && mem_cgroup_online(memcg))
>  		return MEMCG_LRU_YOUNG;
>  
> -	if (!success && lruvec_is_sizable(lruvec, sc))
> +	if (!need_rotate && lruvec_is_sizable(lruvec, sc))
>  		return 0;
>  
>  	/* one retry if offlined or too small */
> 

Maybe this renaming could be combined with the renaming in path 1/7 to split the
patch, which would be much clearer. Other than that, the path looks good to me.

-- 
Best regards,
Ridong


