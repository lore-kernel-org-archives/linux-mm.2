Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06305CAC585
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 05:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 621408E0009; Tue,  9 Sep 2025 01:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1CC8E0001; Tue,  9 Sep 2025 01:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7D68E0009; Tue,  9 Sep 2025 01:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7F58E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:58:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02474119BA0
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:58:07 +0000 (UTC)
X-FDA: 83868656256.18.14DAEF8
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 240FC4000B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:58:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FG+97Zq3;
	spf=pass (imf04.hostedemail.com: domain of flyinrm@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=flyinrm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757397486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DggTN4E5dBZUCumd1C+59dNXXLSXOXcd98w2I28eygo=;
	b=GPClM9nqmZ6fQexXf7oKP8TxEDNeE07YbexgKs/nygzANnQ39Z6x+HPsm4sAc7ffJqkM1p
	DTiopI0OqIk0n5M+9wbiOhJvPc7YRgma6tG7/dCRPaxn3iMVQ9t76GR5sVTJ5hLaz+83/H
	8ulH04ohPheywwjXy3YS4NVh2n5zl0o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757397486; a=rsa-sha256;
	cv=none;
	b=09SqzEjSjhWMaY/1nwdOm0AdkhrG39VV4+ECAr/XaEOACmV4DoubpTB5ij0NHzqBYq8ihX
	ohHaqZRlrfyEcMbvNYr4U9vOg/jqcLty/DQ9/pVklC9EG6+vcuL/trRdB+weWdOovGOqEm
	5Sk+BNuoNr79G7CqRUGbC5+GCGEcG/g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FG+97Zq3;
	spf=pass (imf04.hostedemail.com: domain of flyinrm@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=flyinrm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-77247e25a69so464906b3a.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 22:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757397485; x=1758002285; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DggTN4E5dBZUCumd1C+59dNXXLSXOXcd98w2I28eygo=;
        b=FG+97Zq3Byvh3DexlekmIjfMuiy1KMqDTRk3Ra64Ob0hXCam/GjA/M4ZSuQGWZhwiC
         V6F/ztoQkIor9zPuk4jXCKFJ2EFLzq2FIoeZdvKP9wYA6Z4HnJjmyFwMMGoiTd9pCMje
         gVXc+2JvyeJQnLbVqsXYFY4KLf0Mk5388wTXZ05ah/dwCu5jx0ci40ncKvsKuJWRRMkq
         QMye9ZFUH1GYUq6qPy5xa0+h9Nb1D/azzsRgJDEnK85BDxvaGlOs0GFFaCY6YzJUKJSu
         0G0e2yKzCxzSrUcWlz/bGOZcrrmIOI7umW22m+VO+2OHEa1bDNCGKQssUTcNClF90J/d
         kqlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757397485; x=1758002285;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DggTN4E5dBZUCumd1C+59dNXXLSXOXcd98w2I28eygo=;
        b=W8E9s2cjrP37dfnyfc+SOJK2eQMuBInxIt8pUw06ynTRoubutueXTHhJFdVH+TBILe
         vwguPPlQiLeElUrvl/UdcpbHReiqKD5FfdHFT9+OSembA7IglSQkkeMToNlsPRac9R/g
         XGxwWlvZ8/Bw/h2GiI70Cw5OxgSR/2RZD5XbFE/xrBMsgr/H1tq3WEZzEtw2lBWIIbCh
         hh8VCf4A0yXZXz6v6nx0/aDHP15WlY0JNpaJjnufVV0uSNzKbDAna1Jw8fCmjj6c3+fA
         Yz/vW51FQNSoFzjhJvgHtKshqJ4WlHmGkFfSDxCCQM2cXXt0cY39qTGdQDsypkv6pys2
         /5KA==
X-Forwarded-Encrypted: i=1; AJvYcCX7gieSQPegGjHx5FRVCpuFI7AiQQ/J41/UnCg73g4SsM6incCZVadrM8VNe0+jD0GHFI7RUkOOKA==@kvack.org
X-Gm-Message-State: AOJu0YxXpcHRE6VRxqv2/1m4OW3KRGJPUjUZF8iFGNELMBRkQFM1Hy2J
	mMek0jDR9QABi1xJdyN/jfNtTxiOZqP+znLQXTwgk2QSjxMUX2uxTD07
X-Gm-Gg: ASbGncs/ZWa5XIhXKopoW0gVFCtmz4Y9io0zzhPTjVp/g92oDea720UC3x3B6/gpznr
	qVm0lx3lNUG7fBc3YDd78+eWJm50FGQRf3CbnMIefXO/JJy/u2wuXUcogAdbh4oqoFVabsKxL0S
	TBdvMQCpdZlXgqwU2//gUlKi178ucWlRAd1/LQjq/tAZcGrn/yPBta8G4+pAR/5NEzDXi/uGLwf
	xO8LoWHcey9LbMm7KLPW8cI10RjleKSCqZgYuLf4LU7YLDv3pBzcojI7Z/TgHSSF26ksI/MJlr+
	FAQm91wbtZQM7ogVdhLH46d78BQsTt0fRSMngNx1+QTSwVM6NLL/JcYijh2wx5jtZHqyEwNFVTa
	wWx1XdXLzNz1lfj6N10mquSP1yrPkZQ==
X-Google-Smtp-Source: AGHT+IEQaF8VkteRDiHl9DxWqny/r7YFyWqrpkAO6xB9vMqaCt5n2cMBeffBByxPadsRktPirb1Ygw==
X-Received: by 2002:a05:6a00:c8c:b0:771:f3c2:bbfc with SMTP id d2e1a72fcca58-7742de8eb0fmr7007745b3a.7.1757397484776;
        Mon, 08 Sep 2025 22:58:04 -0700 (PDT)
Received: from pcw-MS-7D22 ([115.145.175.37])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-774660e76ebsm855505b3a.11.2025.09.08.22.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 22:58:04 -0700 (PDT)
Date: Tue, 9 Sep 2025 14:57:59 +0900
From: Chanwon Park <flyinrm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: re-enable kswapd when memory pressure subsides or
 demotion is toggled
Message-ID: <aL/B57jl7y5K1tJ/@pcw-MS-7D22>
References: <aL6qGi69jWXfPc4D@pcw-MS-7D22>
 <20250908170650.8ede03581f38392a34d0d1f7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908170650.8ede03581f38392a34d0d1f7@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 240FC4000B
X-Stat-Signature: 11sx6nn78ky6ijurg438rfe81hsowbdx
X-Rspam-User: 
X-HE-Tag: 1757397485-364264
X-HE-Meta: U2FsdGVkX1/oGraDzcM8BU+87gwaXyXt9nrradp5xsf+QoquXwUjdQOz46N80Z1d2HKTAoP3ZIGhnyIa8ruJUbhnrq2tEDyoJYvWp4TdNBJ/b/WsMrXxsBhSjVD9Dorvx64cnMk+4SJRe+nIepdD1l5ZgiDLuTPLIUMH56c7vSpRtl/2SuoBNNyhfBC0hDcccZN6+UfdIzs7omlAiGkhCCGMB1u73HuZ5TGeklpUch3Ogqhgfvo2YktOKqqHTo/WEvcNSAiTQJMxQGylvQ+Z0vWTQn7JiwbpARcFUiMPNO8HVnLVXVJy61KdUGLmv5s35fQSjd4Wl34fBV8k7QK52Hohd/gMFPujgxQc4eQWJJoZTmwrrTtvT1bIguvLZnxh1tsc4Wnc7A+e472l6B64Tn4U54tzUjVls+YEClY2D1QiJLiodtTnkDZ361N7sjwNOMCcvpcvoIFu1Wt3TvAJ3fN6a7lDsEO8fEWLTo/7PqU4C0Tk4U8hgtFpqiYIQaynOM3crsl5X5WvMINLVgzRLWty2LzPZnrBnK4o6kadRglRGSh57lJjUST9P9vQ8KU5xU8pYd0QBSir3Cxp9yG7WIG4tLeymkC0HAcNlyfVivqVs9OzpnNIy82L+VF+D/lmlUBRidpH/m5VTw2lyExOCWbgQsOzxQ658E4FE6gv4rutStmrOPyNWLvihILOCrd7BZBNhljWtg1kR5xtRRmrvEb7eNgRcsYn1jjqzfbmOKlwkKu43UY4zD78crKIX3VxwEUubcR+Grw0VRTZcQkA5ZONeBqIymGxaxaKjDQZcuPwOHx3NDiPQKqaqG1fH1nOPL+mgZZCokGbMahF0B7WFVbx4HBgFoUa9YzU+7S/3L5ztiURzsDLBCNUX8PtObGanogXCXwjzpb/+hSQMtrYG8ITJngHZPYUhTkwTWWpNIM5XmlHk0g7ch7iSZUHh81wwTmCEDqmQERtHtoao4k
 Ry3QKv/I
 6uTw/+LL7n8Yt+BtsViZtBJJPKfr3dsA/OthxLmQ2oMFThCMpgQtp9NASc3MCN+FVExGo0uIcWsMVV7JySHH+XRCKmbHzsbHK6VfuFDOddmx7i2hCtkgssIVQ6wel7+0LoDhAFcBkZo1NYHgzlbM7ZEnZ1clRORd46xk7QPbXzOjoqPt5Gif46gveLKAhJ0f0I8h6rh+XtPKS3DiYdbl1V6VS4Mhi2P1nvfK5QMdX7oPrSDUmaxyLoMQW02Yg3tNG9bdsuBM0kDdIcyD/m8Q0WgHXX4ttkTgGKpXL4blfXMwag1JqxRbOXznzjWWyORbj3SiHEhMr9BTwvvNy6Mvn4CKWG5xXzsBjdTJIoPiQLf+p0CZau6wuXHZtIKtP/qFDf5TkEOkI3xz35c3tI1OuVCA9OxLNvD0Xg9F7R+RykGu1VENB4tU7g2ZK/SmZbvxHJ2td5WZIL78Vh86lbB/XuKm77vq/LVYWGOTdlzmCmD87dC70IApeB994enzyZDHlKSOOttZArQ3rUGszPL0+jCPT5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 05:06:50PM -0700, Andrew Morton wrote:
> On Mon, 8 Sep 2025 19:04:10 +0900 Chanwon Park <flyinrm@gmail.com> wrote:
> 
> > If kswapd fails to reclaim pages from a node MAX_RECLAIM_RETRIES in a
> > row, kswapd on that node gets disabled. That is, the system won't wakeup
> > kswapd for that node until page reclamation is observed at least once.
> > That reclamation is mostly done by direct reclaim, which in turn enables
> > kswapd back.
> > 
> > However, on systems with CXL memory nodes, workloads with high anon page
> > usage can disable kswapd indefinitely, without triggering direct
> > reclaim. This can be reproduced with following steps:
> > 
> >    numa node 0   (32GB memory, 48 CPUs)
> >    numa node 2~5 (512GB CXL memory, 128GB each)
> >    (numa node 1 is disabled)
> >    swap space 8GB
> > 
> >    1) Set /sys/kernel/mm/demotion_enabled to 0.
> >    2) Set /proc/sys/kernel/numa_balancing to 0.
> >    3) Run a process that allocates and random accesses 500GB of anon
> >       pages.
> >    4) Let the process exit normally.
> 
> hm, OK, I guess this is longstanding misbehavior?
> 

Yes, unless there's any application forced to allocate pages on node 0
running, kswapd stays disabled until reboot.

> > 
> > Since kswapd_failures resets may be missed by ++ operation, it is
> > changed from int to atomic_t.
> 
> Possibly this should have been a separate (earlier) patch.  But I
> assume the need for this conversion was inroduced by this patch, so
> it's debatable.
> 

May be I should've done that, but I wasn't sure if it was the right
thing to do... It seemed that atomic_t was not needed before, and
changing the type alone meant it just adds overhead without any gain
(for that patch). But I also think splitting them is a logical thing to
do. Should I split and reupload the patch (with changes you made)?

> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -1411,7 +1411,7 @@ typedef struct pglist_data {
> >  	int kswapd_order;
> >  	enum zone_type kswapd_highest_zoneidx;
> >  
> > -	int kswapd_failures;		/* Number of 'reclaimed == 0' runs */
> > +	atomic_t kswapd_failures;	/* Number of 'reclaimed == 0' runs */
> 
> This caused a number of 80-column horrors!  I had a fiddle, what do you
> think?
> 

The changes you made look good to me! Sorry for the noise.

Sorry, my previous reply missed the mailing lists.
Resending with proper Cc.

--
Best regards,
Chanwon Park

> --- a/mm/page_alloc.c~mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix
> +++ a/mm/page_alloc.c
> @@ -2860,29 +2860,29 @@ static void free_frozen_page_commit(stru
>  		 */
>  		return;
>  	}
> +
>  	high = nr_pcp_high(pcp, zone, batch, free_high);
> -	if (pcp->count >= high) {
> -		free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
> -				   pcp, pindex);
> -		if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
> -		    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
> -				      ZONE_MOVABLE, 0)) {
> -			struct pglist_data *pgdat = zone->zone_pgdat;
> -			clear_bit(ZONE_BELOW_HIGH, &zone->flags);
> +	if (pcp->count < high)
> +		return;
>  
> -			/*
> -			 * Assume that memory pressure on this node is gone
> -			 * and may be in a reclaimable state. If a memory
> -			 * fallback node exists, direct reclaim may not have
> -			 * been triggered, leaving 'hopeless node' stay in
> -			 * that state for a while. Let kswapd work again by
> -			 * resetting kswapd_failures.
> -			 */
> -			if (atomic_read(&pgdat->kswapd_failures)
> -			    >= MAX_RECLAIM_RETRIES &&
> -			    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
> -				atomic_set(&pgdat->kswapd_failures, 0);
> -		}
> +	free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
> +			   pcp, pindex);
> +	if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
> +	    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
> +			      ZONE_MOVABLE, 0)) {
> +		struct pglist_data *pgdat = zone->zone_pgdat;
> +		clear_bit(ZONE_BELOW_HIGH, &zone->flags);
> +
> +		/*
> +		 * Assume that memory pressure on this node is gone and may be
> +		 * in a reclaimable state. If a memory fallback node exists,
> +		 * direct reclaim may not have been triggered, causing a
> +		 * 'hopeless node' to stay in that state for a while.  Let
> +		 * kswapd work again by resetting kswapd_failures.
> +		 */
> +		if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES &&
> +		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
> +			atomic_set(&pgdat->kswapd_failures, 0);
>  	}
>  }
>  
> --- a/mm/show_mem.c~mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix
> +++ a/mm/show_mem.c
> @@ -278,8 +278,8 @@ static void show_free_areas(unsigned int
>  #endif
>  			K(node_page_state(pgdat, NR_PAGETABLE)),
>  			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
> -			str_yes_no(atomic_read(&pgdat->kswapd_failures)
> -				   >= MAX_RECLAIM_RETRIES),
> +			str_yes_no(atomic_read(&pgdat->kswapd_failures) >=
> +				   MAX_RECLAIM_RETRIES),
>  			K(node_page_state(pgdat, NR_BALLOON_PAGES)));
>  	}
>  
> _
> 

