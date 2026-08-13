Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1547EC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EC876B01FB; Thu, 13 Aug 2026 04:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C8A6B01FE; Thu, 13 Aug 2026 04:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2A86B0200; Thu, 13 Aug 2026 04:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E949E6B01FB
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:27:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7FDA2A0259
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:27:00 +0000 (UTC)
X-FDA: 85095565800.26.54AC28E
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id A41E0140004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:26:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WSi2JICs;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786609618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jb3x2xS6aF9vNzoM2pzTwYtYyaatYjz82383HVr+7k0=;
	b=aE4C63fA7hmtCeevfQrKJw3muAp+Ifm0hN3S9AAIEeaogUIH7oubk2X1uXkqUROtkNkleT
	+vO9/TfDHHXZYssQOfSlbbgpaVDJdhiUXyjhCAtSOfJnh8rwahaFhZ0dUAdpHH1hedagIQ
	oYtxMYuVCEwBGh5CQXJ4F0aUuu/zf1s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WSi2JICs;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786609618;
	b=A3Y1UbC1oRxdca9n2b2urs05Rlr4H4nKc3pBKah3cxEVZ6uE3sd7bv+mQdRo+IkKiD62ut
	rr6rxWqXPBP0gJSkUYLSHxip0SjHGogNXW+E4np1c6L3gR7tWEdiKW1Bz4AFZ5Bgltm+va
	bBtLkhk88aJ3AzGeSp70WWGiWAENRZI=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-472326ca506so1119884f8f.2
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609617; x=1787214417; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jb3x2xS6aF9vNzoM2pzTwYtYyaatYjz82383HVr+7k0=;
        b=WSi2JICsNTcW9PGNSZu5FKp6GppgUsJhfWwvRbCXp16QBLgZruORt5NRhDNC5SsqFI
         cvplgkB++MDJBxa/rSZVQr41OoYxZhBUpxykHKZ/vQJYUsfhQdYwV+O9bBb95W/HD86u
         LGfBaz20Zzesk+PH3Tom1d/+ENP2EX38czawkQmjbfUMPfMCFsXwZAH55OaPffiR3hyZ
         tI9blymG/BNtgfeN65o6EZEap4X91uhqJLB4JSz0Bxc4sdVoyaPYz8Y5oCbxsu5Ubeuw
         nXVWY/XgqIUyPMurxjT4/a/9aOa04L+wHa6HE01WDFhEI57z12Fp73CFp+X5mv88zR8v
         vq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609617; x=1787214417;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jb3x2xS6aF9vNzoM2pzTwYtYyaatYjz82383HVr+7k0=;
        b=GKzy+a1x0vXIf408enRuEaeUN4mkzos9tKtSpnuS9GXrG+NcRzoXpr5DJEuLt7nQN1
         7iRJDoxK9kCNodbeMxcqxgW9z+Q7jxZwPs+yfCH2SLoQ+okr6lw+ITTaxFMxI7lHRJTs
         4K3aSuBWoqEUH4TNbh6yRk8O2TYyUeTG9Q+ECzIUOtpYaUMGTDi4unTpbJVIXmaEw2nV
         oqOVCH7UiBg8Zv4jYTT++WqUNk8z7eyEmqBt/R+4y99gCjfo8pNp8o4iZ9bUzN2LGVVT
         TT8mZtSAaCc86fCJBhaz3o3CsDIkkjtgPS+NjNylbkT4xljp9FdULVvHrWljXRmQ/rfF
         Jwkg==
X-Forwarded-Encrypted: i=1; AHgh+RpEdbgpwBocSxbsYDSNMRdZnovdj7qF/QukxClIFLgDHD/1gL+HmrtXCbejLLhD6J6fKEZM1aTolQ==@kvack.org
X-Gm-Message-State: AOJu0YyPUhqVRe8UPapntD11OtV/QqLB7KC73prIAZnX894vKYj25dbA
	L8kZvvGpE7sgQxPOTHn9ebtYpE62sfcqXc9ktPJDiNBA7V6sT04Ahn3/jhg1AjZnaPI=
X-Gm-Gg: AR+sD126m9pm8qFK+kf7b+14Ta1/EBTSz3UxbwFqqC8nMeiLmm2Xcx70rBUNVT4/C8G
	c20GvBUzucRVhyBuw4U/A1f/HDjbcGYgJSpee0hArtjqZwmh3afg6ckrkgc7CjTWgD3FUG0b87t
	5wOyyAoZbW+YeNmZOhBVhu5F/5sRWO3QN33QPaKZ/47cUEYXjeAX/I1G+uK2jb4D7UM3Wxq7rkO
	zMzmuLQUGL0y+zQ86HB88GYi/uo57Uxdz4JuNz6xGJweeKKUBJ+GD3WnteXSd0QWMLp67QcNLTI
	mixyur+FizBei43bpBCdbfL6tD8T5H0d0OuVvzPIf1Sjigo7ZyM+jWCELIBf09hwIQQqC3hlGAi
	iiHD5ybBwPqufdht8STCQmIjY7ut4bNE3Ug5+2643y9dT2qtzzTuIq1dQxDo5ebq0mReMXYW8Kg
	XKe2j+A1/pXZFob84lOzU0znHXJxgUb3NG08yE6NKFC2uPpWmas1KWFOGqMiGyEXYdp1zm7C0=
X-Received: by 2002:adf:f74d:0:b0:47f:cb30:8616 with SMTP id ffacd0b85a97d-4815a00e362mr140464f8f.27.1786609617172;
        Thu, 13 Aug 2026 01:26:57 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a56133csm4400191f8f.7.2026.08.13.01.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:26:56 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:26:55 +0200
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
Subject: Re: [PATCH 6/9] memcg: remove lru_gen_soft_reclaim()
Message-ID: <an1_z6V5l7CNaCSb@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-7-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-7-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A41E0140004
X-Stat-Signature: 8aeuph4nxc3yew5ww4a1xnh6uwbk1qcp
X-Rspam-User: 
X-HE-Tag: 1786609618-229958
X-HE-Meta: U2FsdGVkX19RPVCeGzA3cuTkufXsl2B/0PoomEsANHGTMdS07VjEP30HG9awIjIeMrA79wtoJsOBfzzp+bYT82Pk0Byxd4Rdnyc1SER/HtMc0o0Q/EJXvXJ8bSF0nzYMlqJLL2i5jhyVYuArsheVs+ye5wD6t1X2iHMQSgseMrNfbP8Nugvxs1hpQZEZvN0P5rRJi8nGZ63nH12nRJv3wUynB47lWe43Y0f98SwwvUm1UBbPxb2YIqGsQLaylc/EMTnQLteUgIc3Zq31pifoc+LOLS2M+ouVb0o+EF+mq6HyLSO1tdRfUQ8ZQP8oHzYEzhc15KgZp5VnHH90KEF4d5YNFmNOW4jPIWKMbd2LNgltnug/Ra30DRWt10QFiu2FKfAjNpe3BdOu0imtpHOOC2N9MBSS/PyhlyiRflcs3t5iw2VbED7KOvnMLujwHYs7g1soYA00Rfv3lT4QMjoGKriU1sn1WGB++2uH2NHppe5xj4iZ5jKD/BGQbq7qFmHs8Rwjl55u8tKtr4wkvQ4cI62VOgIy+AhndudcvqUQkgHYgkoFReDOpx9eqczE5A1+anGjxS/xaTKCk001wsMhBxUKfdVZrCJEacYtqs1+Ti7to3yU1sSvYWNxW+rMmEpSLihW1R1m0WfZa8T/dO95FeVERaGsLRX/zhpjZnbxAWYtO61n+YW89F6l5kETAuPomCQ2ceCG9hzXq5mmOnWySIwUarXoElPMj4zJBFo2WNQo/6az++tcojY28ThKj/4TbZiRI5ZEkWMzWepQldvzP1mBbnP6R20nFWo8SeeFn5w4XgQLYleOPZPzFxBEY/6YbAAjBd0SwywOmSQMvKHfNgaSO041Vj/cjsDGJRlkDGwRIYV2SQjdROweNkrfFO110/3ZPnX5w7Xi0NXImT97WdmBNBKtB0XCzOEP17V1BmhdVrEmljXxY2FP7xfI3u3O51UDPxWoWdHJHRCoRuO
 UVXKKRcF
 +vM+Njgs380mzqOgRz68ExJKNyfoCMVx0Dq37Oi5QXM0iDKZrQK4oUDN45f6kcOPnMZ5UHgLVay3cnwTYw0T2MVEj2ssYBlMb9VTkSy8F6iXqNCFeQqziT6amf63cXTfS+pxxTQ3Iqk4DNhlcF5SvR+d4FwD0er81T/Vqx0k9RM+5yKFYDcFTCp67axGakEzEt/CyD0b9xRJkS/Jy+235P2+1DDZYhSiwByHSjjiyXUe49M8e5ytRawA7+K4l9L96MWUdTvgxRYn8bd8TMhSfQUXHWL0/G8ugw4kZ+J4GE90fVa8rc1R+p0/DcNeX4Z3IE439p1/M1uaj+9/RRRBFMCQJFVB3/weaQUroL+C2GzxNEhG/vd9xrcakJ7bTk6nLZ82fFa8O+mrVWo6OIsbnE1jJBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-08-26 13:32:00, Shakeel Butt wrote:
> The soft limit rbtree was the only caller. Dropping it leaves
> MEMCG_LRU_HEAD unreachable, since nothing else ever rotates a memcg with
> that op, so remove the op too and update the memcg LRU comment.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

I am not deeply familiar with MGLRU to give my ack but from a quick look
this looks right.

> ---
>  include/linux/mmzone.h | 30 +++++++++++-------------------
>  mm/vmscan.c            | 16 ++--------------
>  2 files changed, 13 insertions(+), 33 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 94f9c3ff5416..01fabd0ece0d 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -635,35 +635,32 @@ struct lru_gen_mm_walk {
>   * For each node, memcgs are divided into two generations: the old and the
>   * young. For each generation, memcgs are randomly sharded into multiple bins
>   * to improve scalability. For each bin, the hlist_nulls is virtually divided
> - * into three segments: the head, the tail and the default.
> + * into two segments: the tail and the default.
>   *
>   * An onlining memcg is added to the tail of a random bin in the old generation.
>   * The eviction starts at the head of a random bin in the old generation. The
>   * per-node memcg generation counter, whose reminder (mod MEMCG_NR_GENS) indexes
>   * the old generation, is incremented when all its bins become empty.
>   *
> - * There are four operations:
> - * 1. MEMCG_LRU_HEAD, which moves a memcg to the head of a random bin in its
> - *    current generation (old or young) and updates its "seg" to "head";
> - * 2. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin in its
> + * There are three operations:
> + * 1. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin in its
>   *    current generation (old or young) and updates its "seg" to "tail";
> - * 3. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin in the old
> + * 2. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin in the old
>   *    generation, updates its "gen" to "old" and resets its "seg" to "default";
> - * 4. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin in the
> + * 3. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin in the
>   *    young generation, updates its "gen" to "young" and resets its "seg" to
>   *    "default".
>   *
>   * The events that trigger the above operations are:
> - * 1. Exceeding the soft limit, which triggers MEMCG_LRU_HEAD;
> - * 2. The first attempt to reclaim a memcg below low, which triggers
> + * 1. The first attempt to reclaim a memcg below low, which triggers
>   *    MEMCG_LRU_TAIL;
> - * 3. The first attempt to reclaim a memcg offlined or below reclaimable size
> + * 2. The first attempt to reclaim a memcg offlined or below reclaimable size
>   *    threshold, which triggers MEMCG_LRU_TAIL;
> - * 4. The second attempt to reclaim a memcg offlined or below reclaimable size
> + * 3. The second attempt to reclaim a memcg offlined or below reclaimable size
>   *    threshold, which triggers MEMCG_LRU_YOUNG;
> - * 5. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
> - * 6. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
> - * 7. Offlining a memcg, which triggers MEMCG_LRU_OLD.
> + * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
> + * 5. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
> + * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
>   *
>   * Notes:
>   * 1. Memcg LRU only applies to global reclaim, and the round-robin incrementing
> @@ -696,7 +693,6 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg);
>  void lru_gen_online_memcg(struct mem_cgroup *memcg);
>  void lru_gen_offline_memcg(struct mem_cgroup *memcg);
>  void lru_gen_release_memcg(struct mem_cgroup *memcg);
> -void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
>  void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid);
>  bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid);
>  void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
> @@ -737,10 +733,6 @@ static inline void lru_gen_release_memcg(struct mem_cgroup *memcg)
>  {
>  }
>  
> -static inline void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
> -{
> -}
> -
>  static inline void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid)
>  {
>  }
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 790b50c78a2e..71244cf33d59 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4373,7 +4373,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  /* see the comment on MEMCG_NR_GENS */
>  enum {
>  	MEMCG_LRU_NOP,
> -	MEMCG_LRU_HEAD,
>  	MEMCG_LRU_TAIL,
>  	MEMCG_LRU_OLD,
>  	MEMCG_LRU_YOUNG,
> @@ -4395,9 +4394,7 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
>  	new = old = lruvec->lrugen.gen;
>  
>  	/* see the comment on MEMCG_NR_GENS */
> -	if (op == MEMCG_LRU_HEAD)
> -		seg = MEMCG_LRU_HEAD;
> -	else if (op == MEMCG_LRU_TAIL)
> +	if (op == MEMCG_LRU_TAIL)
>  		seg = MEMCG_LRU_TAIL;
>  	else if (op == MEMCG_LRU_OLD)
>  		new = get_memcg_gen(pgdat->memcg_lru.seq);
> @@ -4411,7 +4408,7 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
>  
>  	hlist_nulls_del_rcu(&lruvec->lrugen.list);
>  
> -	if (op == MEMCG_LRU_HEAD || op == MEMCG_LRU_OLD)
> +	if (op == MEMCG_LRU_OLD)
>  		hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
>  	else
>  		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
> @@ -4489,15 +4486,6 @@ void lru_gen_release_memcg(struct mem_cgroup *memcg)
>  	}
>  }
>  
> -void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
> -{
> -	struct lruvec *lruvec = get_lruvec(memcg, nid);
> -
> -	/* see the comment on MEMCG_NR_GENS */
> -	if (READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_HEAD)
> -		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
> -}
> -
>  bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid)
>  {
>  	struct lruvec *lruvec = get_lruvec(memcg, nid);
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

