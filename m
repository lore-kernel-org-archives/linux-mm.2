Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ECDFFD5F87
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 08:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A68106B0089; Wed,  8 Apr 2026 04:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19406B008A; Wed,  8 Apr 2026 04:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92EDD6B008C; Wed,  8 Apr 2026 04:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 801B66B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 04:08:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 418ED5BC19
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:08:16 +0000 (UTC)
X-FDA: 84634660992.10.7AE1DE4
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 227FD18000C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:08:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775635694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IWAffm22ZtgplRmNqL1SQY14/1VwydnHFAm5hkYyre8=;
	b=iM7u9B415RME9XNlBzJKdAQ9blk3Hzj8ZUO/hGJexT3/SGeSjEd9skjaWZXUdoRM0EI8D0
	AOMPLVmsMUgky0YBwxAhiPUVJIDI/b8eu72IE3pDKuMJ1aZe9DmQ28ila/7KJsssdcgQxA
	kZgtB6FIXjgH62CZbXb+peQ/1PD4FxA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775635694; a=rsa-sha256;
	cv=none;
	b=pNftHuTPZyRs5bZ9mJQGAxJJKOm6fWIZi3x94aUCH+olNUpWXp2me6gx7rHL6XQgjYG8IZ
	aF2DNuxSH45Hj3Un9KASfZvDDtgYR0z4tvGA7q5N6rsA4NLt0je6rIFSrleQNGGeG4ffUg
	lyP4EjfJH+O7+QsOjFlyrx6f6fWIF5o=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4frFzT2T7YzYQtgX
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:07:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 271E440539
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:08:07 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP3 (Coremail) with SMTP id _Ch0CgBXN1TlDNZpLdsmDw--.60482S2;
	Wed, 08 Apr 2026 16:08:06 +0800 (CST)
Message-ID: <997d5991-6935-49ac-8aa7-569767c4693b@huaweicloud.com>
Date: Wed, 8 Apr 2026 16:08:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/14] mm/mglru: restructure the reclaim loop
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
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
 <20260407-mglru-reclaim-v4-4-98cf3dc69519@tencent.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20260407-mglru-reclaim-v4-4-98cf3dc69519@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgBXN1TlDNZpLdsmDw--.60482S2
X-Coremail-Antispam: 1UD129KBjvJXoW3JFy7KF43JryfKw1kZry8uFg_yoWxKr15pF
	ZxGa17Ars7JrW3trs3ta18urW5A3ykGry5JrWfAw1fC3ZIqFyxXr12k34FvFy7ur97Zr1S
	qwsFkF18CayqqFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 227FD18000C
X-Stat-Signature: cw3swryf41thw4tfds1txid8rwm9dych
X-Rspamd-Server: rspam06
X-HE-Tag: 1775635691-912457
X-HE-Meta: U2FsdGVkX19EaMiiUhb/EqtALODcmlImOxNK5C65UucQJ/C2PeGB6XLqZPrZKbmlDyyVX/14Pz+5WF6lJG06+pg2r28Ziz9jBn58YYHVX8phKMiVm3QH2LUzPgYtANtwwxx3z2GpxTkRCeByJc7ShnGuStNOncPn/E0CcjQ/EEId6/U6KTji2NVJ/59ngV3LfB3zd6ctK2TQwf0B4a5fcpneBGmSZkRYrkMt2jGCmr4HFg+BlTGDKkwNIXUC7qpYPqseLS3JD/teFtsHsS/rxSY2SZ+IGhlFGGWxBbNDXda9kHXYox8mQCutFl1kaH+JikULj7UgGlzx1Ip8TyoO8jSHBqDdHU/Z5hk/KgJ7BPI+TFnLoX3VuOsxOVMxmdePHSDkDKyXfvXyztmTyc5URwO1073ORj4b7tdcojVMKsBZVhvwX6oy+s5RnkF1ugynW6ZU1kGn4xQfr/Ap82zBi6FJJucf0cpJrB/ETIIGGhJJsN8aftB0gl2ynMfy1rMD0UHEV90zV4TgF1SftlUB2fOesjI/i0SnVeKW6KIgaEvgcK80KaXsxa0n4H8/yor1Zlw7sfE2OyWi3+X73ICPHqVmwddzUltmCv6+VMPWFAZu8QCszRyzyO2zEf1fHWy923PRUhhJBbmDB4jyef8m/EDh4zY9+t7B+dYN52OMF+vxmdKB0aqfIqN9BWZBGUNECVcxWAa5CIDLe7tkUuxQ/9rVcJuxU67GE4GBsC9zgMpmQQl/wZUarNGy2Vn6Ymbjsqic6QtZ040GoMfBO3Y+nAUmvoQJXd+guQJtpnCqz0Z/JPUaw150mxRY/L05DT0EM/U2e2Yte4MsOjldOt0X8hyoxHqr43xNag9eqHlO35MKTZUkRFizy4kAWc84JOUCXz+tBz4op8LlQk6ezr8GOheyjRNRj1sTVzSHy3mhXF7sg/7z0RHkWhtIrbDhT96Qa8PAtr/KApxZMprunec
 h8Okk0D2
 uJdCGtPgUkOH1QFVM55jUUj4HkJzmsJZakwUGbqxThtsoKOyV2i9ldqwAvX9Ae5wQyKRUaDIUG84Md4tJaMuXw3DFM562iFyNIDiS17GPuimgPK6yANtib5+I3xXYIBwWmm6UuQoAyDYS2QFLTevmsSVRvN2qS8Pipip9xaMg36luebUpRZlPOeUJltne3WJkjcgC0q2njVqr1mylhv45vQK82B2kIJqtvHWIKhDrB8a+lFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/7 19:57, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The current loop will calculate the scan number on each iteration. The
> number of folios to scan is based on the LRU length, with some unclear
> behaviors, eg, the scan number is only shifted by reclaim priority when
> aging is not needed or when at the default priority, and it couples
> the number calculation with aging and rotation.
> 
> Adjust, simplify it, and decouple aging and rotation. Just calculate the
> scan number for once at the beginning of the reclaim, always respect the
> reclaim priority, and make the aging and rotation more explicit.
> 
> This slightly changes how aging and offline memcg reclaim works:
> Previously, aging was always skipped at DEF_PRIORITY even when
> eviction was impossible. Now, aging is always triggered when it
> is necessary to make progress. The old behavior may waste a reclaim
> iteration only to escalate priority, potentially causing over-reclaim
> of slab and breaking reclaim balance in multi-cgroup setups.
> 
> Similar for offline memcg. Previously, offline memcg wouldn't be
> aged unless it didn't have any evictable folios. Now, we might age
> it if it has only 3 generations and the reclaim priority is less
> than DEF_PRIORITY, which should be fine. On one hand, offline memcg
> might still hold long-term folios, and in fact, a long-existing offline
> memcg must be pinned by some long-term folios like shmem. These folios
> might be used by other memcg, so aging them as ordinary memcg seems
> correct. Besides, aging enables further reclaim of an offlined memcg,
> which will certainly happen if we keep shrinking it. And offline
> memcg might soon be no longer an issue with reparenting.
> 
> And while at it, make it clear that unevictable memcg will get rotated
> so following reclaim will more likely to skip them, as a optimization.
> 
> Overall, the memcg LRU rotation, as described in mmzone.h,
> remains the same.
> 
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 69 +++++++++++++++++++++++++++++++------------------------------
>  1 file changed, 35 insertions(+), 34 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 963362523782..462ca0fa2ba3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4913,49 +4913,36 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
> +	nr_to_scan >>= sc->priority;
>  
> -	/* try to get away with not aging at the default priority */
> -	if (!need_aging || sc->priority == DEF_PRIORITY)
> -		return nr_to_scan >> sc->priority;
> -
> -	/* stop scanning this lruvec as it's low on cold folios */
> -	return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -1 : 0;
> +	return nr_to_scan;
>  }
>  
>  static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
> @@ -4985,31 +4972,46 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
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
> +
> +	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
> +	if (!nr_to_scan)
> +		need_rotate = true;
>  

Will it be simpler if we return directly here?

	if (!nr_to_scan)
		return ture;

I wonder if moving the aging check under `while (nr_to_scan > 0)` can change
behavior when the scan budget gets shifted down to 0.

In the old code, once `should_run_aging()` became true, reclaim could still go
through `try_to_inc_max_seq()` instead of being gated by the priority-shifted
scan budget. With this change, a small lruvec can skip the loop entirely, so a
lruvec that needs aging to make reclaim progress would neither scan nor age in
that reclaim round.

Does this have any observable impact on reclaim progress or reclaim balance,
e.g. by deferring aging until a later retry / higher priority and pushing more
pressure onto other memcgs?

> -	while (true) {
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
> @@ -5035,8 +5037,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
>  	}
>  
> -	/* whether this lruvec should be rotated */
> -	return nr_to_scan < 0;
> +	return need_rotate;
>  }
>  
>  static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
> 

-- 
Best regards,
Ridong


