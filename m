Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65BBCC79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 426876B0098; Wed,  9 Sep 2026 05:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6DE6B0099; Wed,  9 Sep 2026 05:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C8BB6B009D; Wed,  9 Sep 2026 05:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E420A6B0098
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:52:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 254CD80160
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:52:41 +0000 (UTC)
X-FDA: 85193759322.10.544D2FE
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 54318C0003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:52:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rHaNIVv3;
	spf=pass (imf10.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39uM4LNN7batCoHFZc/UGv4aRojKefGSgFxZUzAHFw8=;
	b=AGz1Uyu0tn+c/mBfu7hOkp2gV4VLLM4HpyTNXpdMt07L3NoAA32WHXMTzCL1SenfFQiRw+
	WX4xbncciDJKQkXf4y5FzyXspiTgW5dML2Xc66WCUssllPmPivkQnGfkKxbaBTmVxBK/M1
	9Keno509KiF7LObMs5wUecEHFJGUGU4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rHaNIVv3;
	spf=pass (imf10.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947559;
	b=AL8eqimXENmJk0Czukj7r7VrPrjXOzne5TJm8k92n++ktDbXkh3IKSV+IPmm/vewNPTecB
	EedZw77u+1ajN6KLZFRKq+brCaMl8U/6qUtf/rD3wQRGNJpHXIhMVsi/hEJEkHtZDZO+Bx
	aD8RHEc0X9jEky+DFdFZsj8GTLfdDCQ=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2dd020a2e44so3082025ad.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 02:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788947558; x=1789552358; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=39uM4LNN7batCoHFZc/UGv4aRojKefGSgFxZUzAHFw8=;
        b=rHaNIVv3Pu5t8YOZbpZtNxOsNWEmHABWhndi7WHa3VAEcPK7mKd/7dK3uYzwlAaIzX
         vPfCda4jSjEbBTm17jgDxfzLe+M/ERNgb3RPOHqlo7JrxVjney7vQcxR53kXrhKIdHRM
         DgA8UvWyZN9jOhOaHX2u9qnaObFGedvkbWeK6qiIpckKAlPKpe8tOXsqZQwU2m1nd7U3
         8oP9Jw46auB7IZbznckttFDwDe963EXfUQLi0ZCe0bQe91dg/FKX+VtQTrKCnCly2pYy
         2Nvmuh82/B/+R94S0T6ghNvh6DtGqrPaaiYsCV2lfQsQrlWixE5l/3F4DMuCiqGEBm8H
         G8tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788947558; x=1789552358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=39uM4LNN7batCoHFZc/UGv4aRojKefGSgFxZUzAHFw8=;
        b=XjOCFkyxW4zpF40uj+GIEOdq1b5q6vCH/bgiHu+Gy67gGQQm2u76414C6Q4H2PH1np
         kT9FY8LfldrpVK3JkYTmBIBE9nm3JkKMwOWqRT/XI44eFOs3Ej/RV1mQB4zstuf3rWWQ
         F9CqmGVoJHNsJ73WxmYQ+QkvqmFO8WfbTNL5cdz34WtJ621702CJSYjcg/JtYMwAhkuR
         H5dQ2h5DHJ7Y23g2MIlMggq1JAYNISCmKNfKTSJbP6ay+fAux7GIrSoQ6qZpwKfUGjVr
         tpK3LE6m9U+IL/fbRBLWbHMLQOVMArA5XRWSgtzeo8R2iuLUl5xym2GDsdOb9MROVBMV
         oksQ==
X-Forwarded-Encrypted: i=1; AKwUvBztpaON7kvvi+LCNgkW3oKcoRzNf19rE5SJlZvr5+LHHxuok6D26Rm2pHhF4dCJGNlk0XbtQEzzfg==@kvack.org
X-Gm-Message-State: AFuF++nPDe0iMSaZH/xwwe1wK+LQXBPxtW/j6nRnXZpJU5zgdLGgK75C
	qtZoPtIM1LDNCRXnO9ZHT3C+jBRQzBuyeL5HhhG0291ZDMbv2tJLj1xQ
X-Gm-Gg: AYBFou29oRC7ACcfcxSHnrbN3Ez6eJv8z/mGZh8kwUkmM+RC1HTj+loXt2GrNKreS95
	8D29nKx5FS7ne2kVMmVn/fQf+siCEFbTt0Aa5uzCWhFw58GE2MQ/kFi3KqV4pCoTBToPQ2hGH79
	rEul7/c4om9ScVGQLq6aEteLFd9MBx78lP3mgiIbqvi1p704aDUxCjRnfpjePkTIsCFgSrmIXD8
	HPVKqF8y7Mt+fkuNRgfYVhgp9elz03aU4S6dZzsfKP8Ljx+fPX0y53xoBbqO7dhzBvctyF0OrBn
	N7ddOEcAuJDgVOiaUlCLBwxmsIJo1zhjNRr6OkkXecRq3NjQmFyh/+oHUVJDMgo+piHU7/EudHi
	rn1imR0YzvbDDclsq1SumavFoFXoCQ8+64Rg/t67URv/7C/isDM1kn/U6Q/CDgLXxqSeE4BShpa
	1UfeJbCjZMM1pSHJHSZgsAMI1eQajA6L7Wo8lWhAyj1MUqM6DhZJtiEbGI7W2jxG1uiujODA==
X-Received: by 2002:a17:903:1a28:b0:2db:31d5:1448 with SMTP id d9443c01a7336-2db31d514ebmr362436915ad.22.1788947557277;
        Wed, 09 Sep 2026 02:52:37 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db14959954sm70023065ad.27.2026.09.09.02.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 02:52:36 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: john <love_goo@163.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>,
	akpm@linux-foundation.org,
	liuye@kylinos.cn,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	mgorman@techsingularity.net,
	yang@os.amperecomputing.com,
	zhangqiuhao@huawei.com,
	wangkefeng.wang@huawei.com,
	mawupeng1@huwei.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wupeng Ma <mawupeng1@huawei.com>
Subject: Re: [PATCH resend 1/2] mm: vmscan: charge isolate overshoot against scan quota
Date: Wed,  9 Sep 2026 17:52:22 +0800
Message-ID: <20260909095227.2522994-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901084706.3784449-2-love_goo@163.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 54318C0003
X-Stat-Signature: f1x599a95n6khs4eyd7eod8euq1gghng
X-Rspam-User: 
X-HE-Tag: 1788947559-97369
X-HE-Meta: U2FsdGVkX1+mpJTcu0UpmJYrohsR7GKWBJZrIKcNXh1rhxurR2QP4lZ5KYS/X40vEmcGhc8jF6RohbkV02WPKT0ODLcq3eEa09GHyIz+PaBKPakO3NkSnZqwJDPwFnihQHlW2SmueWFunACy7VMfYYvGsvZVUaApm0JryZ5/bdkabYDdGq0NTw2oo9FgU6kORyLOSuL+chF7sWTmRSCx5lU0URf0JOo4LQ9wxXDGuiAwmDkl40N5Wiu/BMo2jB6rbi3bMJDyjPN1oTU1u2W8bI9xW/8iqmEQ+JvzQBt+3O5tX18z77x5+NEkdDFnk4Jy2A5uRGrefqEZ17vLXPtbwfD4ASGmVKJrQCS8KxjeXgp6MB5giCO4uE7wEsOE1C4m3OFdmXPDJm22WGZe/pzAbimdXHYHsU5TkgbWpU5s3HPhOBk9Ed8McBju5FQeZIZf53vUfd4sdf+TgmD/BJ/0VlUXSCdw+Ppl7adZjAogRFIn1t99lkWCOjC4arbJq3neflfuIL6slM2PDoIfHpP4zqZc9RUY7keG/V0ZExq+Zdgk8vu6UxyvPowkz2ZSOp6ogPez8m8ItFcjZM01BQ3tYBULu46mVd7bvJ++ysxChLoqMOvoTqOJh2z43HB5pqRjiu/2f8eXJa0YEznrnP5U1Dv8DHwpWnUNEk8D2P1p8F0EkQuz6RFPFPJWbzmpaOMP2CaTf0qyoTZkDuHw0WyA19Fu1eo5XGYD6+Z0g7mjiM352PsbvK2IH3QsB2zyFD8Vy6YDhUlQsuBVZjzOxxFywAWf+HGw87c4g5vToa7VY0UEsvFnQJJOFhHosJ74EgVOtfhDij45w20Z3GrVBKM21nlbOANqpLGX1ucmtOV671WthFXyq4FL60j13q2UhqEzDw2+Xpm0xr9EBhX5SDsRVRmd/UwXfS/XRjDrd6nxDySROM6sTAtZ/d5yxm4Hm19KZrwnAiaGgy+70gb3/Io
 DdCpmUjV
 1RWEkRs0TFqY0SSDXf4420CgPBg+7jKs7daKPTefO6TeFgC5arkqmlJsRoSRvaGJWWsM765XsOmYOykJYd6YrQNzsut3KaIV3FmWOUCxvcIej/AIrPQa4ZEp+OqgTHv53ntny5H45EhKCqq6klVqHOlDizIiPs8M0ChEfkCnUSn50pWxbTHjyzieVef6IIzYwsqO+7HncGFNHgaIdnvFLDVUdOHU48uAX/5qlwF3vbpjUJ/HOSm8mRqRRocNg9azS2BDRHyBhpx2UJFsjaovvX5T3I/lBR+gElprD2e13iXg+QDhCvjgIngFeLPdPzwH5v+pCPT9sZCh4kI+NJ80lwjJKu/OEkBFI1mluxjWO9NwX//MA9kxarUO9J+HWkqMWm3oGfSCmpgpOQYgIHVW6HSitmRsQPR0oVcz7RQWEwsLt6BFrGaAb1PGkdUuxhyexLHiEG7/kUvc9GDPJvSZIdAAmghY1G1E5ZP3y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 16:47:05 +0800 john <love_goo@163.com> wrote:

> From: Wupeng Ma <mawupeng1@huawei.com>
> 
> shrink_lruvec() charges the per-LRU budget nr[lru] in SWAP_CLUSTER_MAX
> (32) chunks, but isolate_lru_folios() may scan far more per call: a
> large folio can jump scan by many pages at once (a PMD-sized folio
> counts 512), and a zone-ineligible LRU walks the whole list without
> feeding scan back.  The overshoot is never refunded, so shrink_lruvec()
> keeps charging only 32 per round and rescans the same folios.
> 
> Have isolate_lru_folios() record its scanned count in sc->nr_isolate_scanned
> and let shrink_lruvec() subtract the overshoot from the remaining quota so
> the next round skips already-scanned folios.  The field is reset to 0

I'm not sure this is true across shrink_lruvec() invocations.

isolate_lru_folios() splices folios_skipped back to the head of the LRU, 
while get_scan_count() provides a fresh nr[lru] each time shrink_lruvec() 
is entered. Thus, charging sc->nr_isolate_scanned against nr[lru] appears 
to prevent repeated 32-page scans within the same shrink_lruvec() 
invocation, but the same ineligible folios can still be encountered 
again by a subsequent invocation.

Is the intended fix specifically to avoid repeated scanning within one 
shrink_lruvec() invocation, or is there another mechanism that prevents 
these skipped folios from being rescanned by a subsequent shrink_lruvec() 
invocation?

Thanks,
KunWu

> before each shrink_list() call, as shrink_list() only reaches
> isolate_lru_folios() on some paths (active + skipped_deactivate,
> too_many_isolated stall bail out early); a stale value would otherwise
> be charged.  The budget floor stays nr_to_scan via max() so an empty
> LRU (sc->nr_isolate_scanned = 0) still advances and cannot deadlock.
> 
> Co-developed-by: Qiuhao Zhang <zhangqiuhao@huawei.com>
> Signed-off-by: Qiuhao Zhang <zhangqiuhao@huawei.com>
> Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
> ---
>  mm/vmscan.c | 32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f11491ee9ed5c..823af9e86efd3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -166,6 +166,9 @@ struct scan_control {
>  	/* Incremented by the number of inactive pages that were scanned */
>  	unsigned long nr_scanned;
>  
> +	/* Number of pages that were scanned from isolate_lru_folios() */
> +	unsigned long nr_isolate_scanned;
> +
>  	/* Number of pages freed so far during a call to shrink_zones() */
>  	unsigned long nr_reclaimed;
>  
> @@ -1670,7 +1673,6 @@ static __always_inline void update_lru_sizes(struct lruvec *lruvec,
>   * @nr_to_scan:	The number of eligible pages to look through on the list.
>   * @lruvec:	The LRU vector to pull pages from.
>   * @dst:	The temp list to put pages on to.
> - * @nr_scanned:	The number of pages that were scanned.
>   * @sc:		The scan_control struct for this reclaim session
>   * @lru:	LRU list id for isolating
>   *
> @@ -1678,8 +1680,7 @@ static __always_inline void update_lru_sizes(struct lruvec *lruvec,
>   */
>  static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
>  		struct lruvec *lruvec, struct list_head *dst,
> -		unsigned long *nr_scanned, struct scan_control *sc,
> -		enum lru_list lru)
> +		struct scan_control *sc, enum lru_list lru)
>  {
>  	struct list_head *src = &lruvec->lists[lru];
>  	unsigned long nr_taken = 0;
> @@ -1763,7 +1764,7 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
>  			skipped += nr_skipped[zid];
>  		}
>  	}
> -	*nr_scanned = total_scan;
> +	sc->nr_isolate_scanned = total_scan;
>  	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>  				    total_scan, skipped, nr_taken, lru);
>  	update_lru_sizes(lruvec, lru, nr_zone_taken);
> @@ -2011,8 +2012,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  
>  	lruvec_lock_irq(lruvec);
>  
> -	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &folio_list,
> -				     &nr_scanned, sc, lru);
> +	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &folio_list, sc, lru);
> +	nr_scanned = sc->nr_isolate_scanned;
>  
>  	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
>  	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
> @@ -2068,7 +2069,6 @@ static void shrink_active_list(unsigned long nr_to_scan,
>  			       enum lru_list lru)
>  {
>  	unsigned long nr_taken;
> -	unsigned long nr_scanned;
>  	vma_flags_t vma_flags;
>  	LIST_HEAD(l_hold);	/* The folios which were snipped off */
>  	LIST_HEAD(l_active);
> @@ -2082,12 +2082,11 @@ static void shrink_active_list(unsigned long nr_to_scan,
>  
>  	lruvec_lock_irq(lruvec);
>  
> -	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &l_hold,
> -				     &nr_scanned, sc, lru);
> +	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &l_hold, sc, lru);
>  
>  	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
>  
> -	mod_lruvec_state(lruvec, PGREFILL, nr_scanned);
> +	mod_lruvec_state(lruvec, PGREFILL, sc->nr_isolate_scanned);
>  
>  	lruvec_unlock_irq(lruvec);
>  
> @@ -6013,10 +6012,21 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  		for_each_evictable_lru(lru) {
>  			if (nr[lru]) {
>  				nr_to_scan = min(nr[lru], SWAP_CLUSTER_MAX);
> -				nr[lru] -= nr_to_scan;
>  
> +				sc->nr_isolate_scanned = 0;
>  				nr_reclaimed += shrink_list(lru, nr_to_scan,
>  							    lruvec, sc);
> +				/*
> +				 * isolate_lru_folios() may scan far more
> +				 * than nr_to_scan when the LRU holds
> +				 * ineligible folios (zone-skip) or large
> +				 * folios. Charge that overshoot against the
> +				 * remaining quota (clamped by min() so it
> +				 * cannot go negative) so the next iteration
> +				 * does not rescan the same skipped folios.
> +				 */
> +				nr[lru] -= min(nr[lru],
> +					       max(nr_to_scan, sc->nr_isolate_scanned));
>  			}
>  		}
>  
> -- 
> 2.53.0
> 
> 


