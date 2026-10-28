Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 567E6606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PJawk3Ru
Received: by kanga.kvack.org (Postfix)
	id 519A06B05B3; Wed, 28 Oct 2026 06:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0CF6B05B4; Wed, 28 Oct 2026 06:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0466B05B5; Wed, 28 Oct 2026 06:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 166616B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:20:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A3D2140BB2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:20:10 +0000 (UTC)
X-FDA: 85371639780.10.7EE1EE5
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8299820008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:20:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PJawk3Ru;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793182808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGZCyoP3FE5bGQl/UeXjVk9zpz6msuuXm/vv60rRm4I=;
	b=qYIuAoie3rUlCN3keVlIzbwtKWrN6zkcVOBP+dL8rU4yn9GOsDkh/mk2UsJ9JCCvMS47VI
	OkE5WZZwu7f7jtZRxEnZqSTBXTWWDZBCFwGPgZvDzdEUiERZYQK70VoV9M8bNOyym+oKoz
	pZWLwqbysxFf0Sqf7i03SgOLEkQ2dIY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PJawk3Ru;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793182808;
	b=gDlJovXC+VoM7bus9LmAut+zvWm/arblfvKnKDrbJSKyl+1kmntWo8GXxqumpWlgLnNsuk
	akwXX3LcE5q66ytfgEAhG22eWz0V4vEKLgksJ4V2i8JNLEQMPPnsE9IaagSLExIOlzl6Zz
	GhQ1FoBP/Zz+0PiuoI7AtqHjeVzk4Gs=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cd5d2dafeccso465737a12.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793182807; x=1793787607; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dGZCyoP3FE5bGQl/UeXjVk9zpz6msuuXm/vv60rRm4I=;
        b=PJawk3RuZscHjoGfA4VppSCQ7anU9A38FZv0Vm0vVNSxXYcfxu/g/EHofskTUblul+
         nUqj0HIo0XqK85eWkV6jPIBkO984DrlXFxNtnVpJWPeaMxZcsBqOttttA6Hq5wW0BRIB
         /MWjhURqEZ7XfhrsJChINGEMD7xV0QBQ5RZJ4sLnO/uoB56ffdoBjJyubr8/I1wm0KMT
         tFOrRO5W1PiBVjkchyhTSNOoDYC3HuH3nVs4jaVmpFievg6AcnanKCD3d7MJCQle+sUm
         q/PR8l2K40rtqKoRqANoS+q2fKmFElmVPr6wvbM9EuLsfXfXtlV2Gi0C91VnAQ4g32qd
         C8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793182807; x=1793787607;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dGZCyoP3FE5bGQl/UeXjVk9zpz6msuuXm/vv60rRm4I=;
        b=sQ0rSSDBeew3T4F3kDA97B90Yju9Z9IvOn8GuEO5wbhebsSwjipsboOqM/6rweIzkA
         TVCDjUIyTU16YT2sVN9KKxwjC/2GWQ1VN6xnWf52H6eVVUxtBlo5tFe6y0xNOIs0JA5C
         /KIWzNOIM12Q64tAGsDZutxWShdWlNb+sgBEYvxPBTZYvdFWpthhH6e3cAfDVJxn6lFI
         +xIszjASP+JHVOfKWM94/5gO9ARwJa72CrNa67SgO8F7i5dx3r5o2NEW7fzJ24+kBcMo
         sk4lgfrQQwzVqF3pUqnc91TVSVE4ejysobH6UjocHLkZXG132nWBFn1HSaAIkgAiCD4F
         5jpg==
X-Forwarded-Encrypted: i=1; AKwUvBzgJ6IaNVLCLE31iERyeBes0NvT/DxvrpGf0u4ycTHtccHAqynFpF6vUCVQ6xnNlIFMB2QTHjhMaQ==@kvack.org
X-Gm-Message-State: AFq9FYK9lB9SU2qLgkne/6+c9cSmWTAonogw2KuFHvyTxLQj17KfqXRy
	TB//rBGscW7jWaNlcOejPb7YMFqMLS4CScLivyEeOyr+cTyaJigvxiFn7m0uKZMBAuk=
X-Gm-Gg: AYBFou2XlRTIxVKBEd+rK7KFAIBBR5oCxTiR3s8DFhHKFcbAV4LiXwjZKBqNeSsUHhS
	wcnEjTcS4MMg+JGHxPEM9zgIxPWdShQTPGg+R7BvRcvQKYED7ez8w7pOpem48s4puYADGKHsK72
	0QTVSJE0bF2UZnf/XTyQr5Nagtm+DYX829t3NVkMh73WnMjP6zlknPXpyQkfhhKUncioiUu17aJ
	VsNYRJNnZ7xR1Xe4SS/mjPiKlyOqJv+Z/MsFg8wrjAojlza/504mV+uncS5gRU9L8/N00CTG6WT
	MuasczdWWtdZ9Kz4VsjJGPU8doNelVO/3sJsHUPBVNqB8CYok3DbQWlS+IKTAAAruz2PTfgftgW
	rOy6APQkx7kdsS5Mgf7mUYKIWv5unmPVpICH9fveqcrtyobRR3OKOQ3T/uIHx+HF5E99vQpB2g9
	uI52tAWvb75tPxK4jy+HcUYDXD2vZnmLbz0+bE2G+PNIPEAV7l80bfonmD49tTVvBzHsWWIyq1w
	3gCoIUUAsla2Mcx9DPbq32Smqa31SY68i2DDQUbeViSsW6MsbGWKuWsrbqOUmFCwCVOdjmxPk0S
	XdZPmpN8YbXXxRFlATW/s8aO0K3fdLVXEkFS2RgIBA9zcFOh7ABZff1dRFwQBtPOgP9Db1sSRYw
	=
X-Received: by 2002:a17:90a:fd92:b0:3a0:d265:3647 with SMTP id 98e67ed59e1d1-3ae57e357e5mr882344a91.8.1793182807428;
        Wed, 28 Oct 2026 03:20:07 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a9a5e73sm2400905a91.10.2026.10.28.03.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 03:20:06 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:19:59 +0800
From: Kairui Song <ryncsn@gmail.com>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/vmscan: remove redundant !mem_cgroup_online()
 checks
Message-ID: <auHLzLazLr4iA_Pn@KASONG-MC4>
References: <20261028010611.3929937-1-tjmercier@google.com>
 <20261028010611.3929937-2-tjmercier@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028010611.3929937-2-tjmercier@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8299820008
X-Stat-Signature: s94dty8ywse77iajbsq3kpc19n3xcm64
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793182809-512471
X-HE-Meta: U2FsdGVkX18ZYpVEDyonejLyQ2Y2cFO5jn61iuGb710YSBgv6R5MEigH79AJolqlLulpjYp4CWQ9dKUz+eVeB1HhasfNY3EJYcdKn6oMg/2IoTs2/dv2Vb7Ehh/+WJQYlpUmeUb8Eqp/PqmZ+ESy9WI5LHrOq45VZh44RJyJN8C1P39XD5jfKRc/WGBIMhEUcskXYnKbj9vNY2AHqV512MDPhOvNZKmzAB5+40lVh9LDlIBIPMGaFmebFs/pqTbcJ95Gb9DS3abdWdRABzNV5H6SBWM8/n9QVAAPT27YehhRYLAiM2ORaPR4VbI6gi27lyeahRGBfyVu1A1hiZ4bEaN1CmH0gy9HdC9L1bc/+McGCn268IpzCWEnzvIn5u2uQpo9GbezT9A220gUIbfDw9QKetvTmdeq74uzsixi2TmEhykeF6fT3RPHZsnIMiFA0B5ax1WPV4UnA6T8U6EFJIS/CqqV5o9JqHWwbwn21ZaJ/gRVfShzBtgHOlVhY6rUMDXM4sA77CseSXKkJc5On27KJvJoLLcBsZsHcOjqxBjL6oPe3pvC7mNOxyAReD2UESvxvUkrdc5bs5Cwu1ztAmlKPzHVGpEgGBLIFqoGlmaj4aW3c0QL0G2dN4CP7m+lmy0e3WWIGIelZU0LAUGgj8EXpWZ2AeEqwCroh5b+uVn7dWLcGruLrK5NpGsbMSQgMcAPUyJ31Qhemb3VRoW4kaCDBm6FDssAVNtnO1So99X8kma5m90coD20t9rBwO7X7BhE64r3TQOzat6R+zQDj+RzoZqZCHILD4qZ8vidiYgtOpCifkN3AhfqFf6B044EMZkS5pR33t0TQLxV/pyy0eokCWl0wT0s31DqlrA/+BhJXVZzu6/TOBOSE2XxJV/5rcQxTcJp7LdR52hDbyKhWPWBm9epBaKlOWuWt9Kl6z5GzWi4xNoM2jFL5E4xzrk8zncds6Ul4PLp0l4GiCh
 uczhxpkD
 igCr1uKyIMewfOwHyboqXiVGOFjOfVsCw7G48UXltgJJLC0glNx0RIUzoCEPA5qA0vs8J/31wqK6StX6GKHT6AXsibNEQ5pfMVGyHePmX8DA1cVDq6XhMwbkBziL1sxNQ3VTCqbt62CjGuchYvx/FY7cdEriew1zE41czZZDCpl9hVDMlWfD+Z5ncE9X9zIqrWr4p0FC+UPpMy+zwne7IeLbvd2JT+Fs8Jy5kTWQkXs+/M0qYKw8h4TasvgAgjNRUwwBas5ojVlPm49nZ19YhhEDF63ssxWeL6IH1rqxphcjt2XlrLgSysYAAMuJup9K34LgoquqCc/uHML9SV4ddpEQ77tpEZ8jzw1vyRAeBPfOedj3wrVLch/m1pa8GG+qkQouQQVm08oayozlSW/UsUJODsqg+4dwZ5omG/rN/lsRUV73BuhKWgg39hPZwMD2bis7jn0ov9DfPLtCrTcQu8H6qvs9GJR1ulAMkDI2mqkA8hHDOdpaxI/q1vRWGUAF7IsoaOCEHZqtna/LnoxvkA+E0ySexXGXu25JQjNbHupuuFxSxd2rQn8daRk46WgcX6NrY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 06:06:05PM +0800, T.J. Mercier wrote:
> Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> dying memory cgroup for LRU folios") and commit 0e0ac326c511 ("memcg:
> move LRU size accounting on reparenting instead of copying it"),
> mem_cgroup_css_offline() reparents all LRU folios to the parent memcg
> and zeroes the child's lrugen->nr_pages and lru_zone_size before the
> memcg is offlined. Nothing can repopulate the offlined memcg's lruvec
> afterwards. A folio that is off the LRU during reparenting looks up its
> lruvec through its objcg, which now points to the parent so it is put
> back on the parent's LRU.
> 
> As a result, lruvec_lru_size() and lruvec_evictable_size() are always 0
> when !mem_cgroup_online(memcg) is true, making the offlined memcg special
> cases in get_scan_count(), lruvec_is_sizable(), and shrink_one() dead
> code. Remove them.
> 
> With the get_nr_to_scan() special case removed, an offlined memcg that
> still has stale effective protection now has
> apply_proportional_protection() applied like get_scan_count() does, so
> the MGLRU and traditional LRU behavior is now the same.
> 
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> ---
>  include/linux/mmzone.h |  8 ++++----
>  mm/vmscan.c            | 28 +++++-----------------------
>  2 files changed, 9 insertions(+), 27 deletions(-)

Nice!

> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 3b96d6c7123b..7f078ff0dd76 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -638,10 +638,10 @@ struct lru_gen_mm_walk {
>   * The events that trigger the above operations are:
>   * 1. The first attempt to reclaim a memcg below low, which triggers
>   *    MEMCG_LRU_TAIL;
> - * 2. The first attempt to reclaim a memcg offlined or below reclaimable size
> - *    threshold, which triggers MEMCG_LRU_TAIL;
> - * 3. The second attempt to reclaim a memcg offlined or below reclaimable size
> - *    threshold, which triggers MEMCG_LRU_YOUNG;
> + * 2. The first attempt to reclaim a memcg below reclaimable size threshold,
> + *    which triggers MEMCG_LRU_TAIL;
> + * 3. The second attempt to reclaim a memcg below reclaimable size threshold,
> + *    which triggers MEMCG_LRU_YOUNG;
>   * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
>   * 5. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
>   * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9959ca158ce8..636152d8c94d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2754,13 +2754,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>  		scan = apply_proportional_protection(memcg, sc, lruvec_size);
>  		scan >>= sc->priority;
>  
> -		/*
> -		 * If the cgroup's already been deleted, make sure to
> -		 * scrape out the remaining cache.
> -		 */
> -		if (!scan && !mem_cgroup_online(memcg))
> -			scan = min(lruvec_size, SWAP_CLUSTER_MAX);
> -
>  		switch (scan_balance) {
>  		case SCAN_EQUAL:
>  			/* Scan lists relative to size */
> @@ -2769,14 +2762,8 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>  			/*
>  			 * Scan types proportional to swappiness and
>  			 * their relative recent reclaim efficiency.
> -			 * Make sure we don't miss the last page on
> -			 * the offlined memory cgroups because of a
> -			 * round-off error.
>  			 */
> -			scan = mem_cgroup_online(memcg) ?
> -			       div64_u64(scan * fraction[file], denominator) :
> -			       DIV64_U64_ROUND_UP(scan * fraction[file],
> -						  denominator);
> +			scan = div64_u64(scan * fraction[file], denominator);
>  			break;
>  		case SCAN_FILE:
>  		case SCAN_ANON:
> @@ -4355,12 +4342,11 @@ static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
>  {
>  	unsigned long total;
>  	int swappiness = get_swappiness(lruvec, sc);
> -	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>  
>  	total = lruvec_evictable_size(lruvec, swappiness);
>  
>  	/* whether the size is big enough to be helpful */
> -	return mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
> +	return total >> sc->priority;
>  }
>  
>  static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_control *sc,
> @@ -5199,10 +5185,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
>  
>  	evictable = lruvec_evictable_size(lruvec, swappiness);
>  
> -	/* try to scrape all its memory if this memcg was deleted */
> -	if (!mem_cgroup_online(memcg))
> -		return evictable;
> -
>  	nr_to_scan = apply_proportional_protection(memcg, sc, evictable);
>  	nr_to_scan >>= sc->priority;
>  
> @@ -5325,13 +5307,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>  
>  	flush_reclaim_state(sc);
>  
> -	if (need_rotate && mem_cgroup_online(memcg))
> +	if (need_rotate)
>  		return MEMCG_LRU_YOUNG;
>  
> -	if (!need_rotate && lruvec_is_sizable(lruvec, sc))
> +	if (lruvec_is_sizable(lruvec, sc))
>  		return 0;
>  
> -	/* one retry if offlined or too small */
> +	/* one retry if too small */
>  	return READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_TAIL ?
>  	       MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
>  }

This part looks much cleaner, thanks!

Reviewed-by: Kairui Song <kasong@tencent.com>

