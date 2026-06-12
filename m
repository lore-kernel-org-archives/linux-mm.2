Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE59CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 11:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3E456B008C; Fri, 12 Jun 2026 07:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF0206B0092; Fri, 12 Jun 2026 07:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE126B0093; Fri, 12 Jun 2026 07:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5146B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:32:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 35D9F406B5
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:32:03 +0000 (UTC)
X-FDA: 84871046526.24.E235A25
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0B1ECC0003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:32:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YnTxt42v;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf28.hostedemail.com: domain of ptesarik@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ptesarik@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781263921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bUqRGLNUM4V63GjZAblduHBjaNOc+aWkkWYnK1OoipA=;
	b=L30LIrbqkRYHITi9wyEERX1IMwm6ktwMjZKU1a/WJ+n2XG8u+j5zhTyoctnOWOGOTxHoP0
	r2qQjqNzNmrEabXMrSKjZ+Og7Kru+T+BKF8JWwz3k2nw5xQMuKJSzKyME0at7QkDJ8rQgq
	/sQOQyLx7lfjZTv8odqfXM9VQeOtlT4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YnTxt42v;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf28.hostedemail.com: domain of ptesarik@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ptesarik@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781263921;
	b=i5ByZDES72WCZkLH/msK8Gytkpb3tOCsaaMvhXflMruJ0qky/x/yLwh+Xrr86hvKpRfUWS
	wv83mDNXzVndsDPgzh1exmk6fQpzNRsRprTY9WTRK5PajVTeqyd+a85lE+xemjUgOVnRrR
	oF72IycXW9cbzRvqJJryUKYY15LPLuk=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490a78fbd7bso1001925e9.2
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781263919; x=1781868719; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bUqRGLNUM4V63GjZAblduHBjaNOc+aWkkWYnK1OoipA=;
        b=YnTxt42vQa7ViSuCcaRlILBglSsVasWEgUGtXb50HyVMPv4KFwm1RrFOVFLxTnZu72
         NXJWmxX/ra064lto3ES68wXExCpx/Wt+CRg5jNh+u2JH+qE+MfelclKGSG8dl5PbQKnq
         vKRLp/+VUo+0LsLglnf3PPUI6umvBDI7HzCfgsDVBOcELknJJ/OnypsT1K+vq9VhVsHt
         Aj+ms/lPvubs9U1VBfV64xXxpnrweBDM0YvBNPJH9q4rF5ChacndQxD4sQ/VNE4E4VLb
         udbyDZebKR+PIeMAKN8USErStbgQDue40NxuJhp9gLNV01Vm73YY18xHhwqek8/TWZ2X
         VYtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781263919; x=1781868719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bUqRGLNUM4V63GjZAblduHBjaNOc+aWkkWYnK1OoipA=;
        b=ew3/UC3/XxI2074BvSqFxjf1cKjuX1JUOeQX45PqDRX9XSI1YF+AEir0k+QDy4+7OX
         bRvOicmnQgEKSCCIGRd4GD6mIOJPxxTddxLEaWfu2kWUOkSRy+0asRIRnQSLNl0BJCoK
         oOBxhEk8WYB39wm3XanaOexGuzpN1w5MUOXtMUYGsyYmPnd/4ts+dv4OuMsh/HD3jRzZ
         P6Ly1Yz9KUH+rVMxEoJOAd6eF1Tr5G6wOepUFIuHSS6uCgg6CU8rHT7NYUQvoDh1XeNN
         T2HBIx4TWnf4+3B3A8jrHcJq+oQFd1PKYlmxHAa+UjZjVa/8xujUYWa3r8Iv0sV9hp0w
         zZAw==
X-Forwarded-Encrypted: i=1; AFNElJ/RGFfq8mldjaRO85q1Cz4gowF80CuCLzxViuJRk0UoqU9mKMyWDSXdcm8SO+Mr6EX0FhMtKC5B6A==@kvack.org
X-Gm-Message-State: AOJu0YxJ0+hrGodD6wKjD2CxdVKfDqJKegqUYx+eEWVzCg3HX5+mLZ7j
	ngl0jr+eXWgMZzqzs9SLGsQI06SCMBIeuNg2MNRppUenVeRQhLujRN/AAykFa5+YkSU=
X-Gm-Gg: Acq92OEKpBYeZ0QXQbP8Tp1ZiFX83YY3HuSDTbKsVCz7/90Es1ONYPqW/dcLHnQznyT
	p/7IGnMiOHacPn4iAg3NlKTBtCmb7DXpZTN8AUzhj36KjiKtEN3k1sXYdEvCAZW8sT5wT9wgcva
	26UfEKEzpxw7AjiVeE7ipmD/5uiTKgHIisNMdMJIukVxoTmaQnIabwrJcLhyYV+b6BICyurfEE8
	lyjTCiLTg24tuZ9eyVH1RugmO89qYw7OMLcjQcSGquMgLaDogkiHvaI6MfTO3qs+acY3NZ66eEI
	SYKsjmE+kauaqupfn4fWWtgpZ87mT4JdUKsLYPEAoYtmVCTGVODFk69Bs8vAchhMG/4VriEAOmb
	3kxq77QI3x6gc9pFtjR+apWRT3ylnWe0wKno1CDJcpJ4Gzyrj4ucD7ASPUuTm1NiBGnZiZmziOU
	XnlXg8MJtwpUp0PvJRDxeKIzwoI8ouNDTYYAnT1c4vq0YMemfIkQVgE1H3VD95FRkQ7VvXpWSw+
	S0jhtSdOdER3L7U
X-Received: by 2002:a05:600c:4745:b0:488:7e7b:dbc2 with SMTP id 5b1f17b1804b1-490ec4fd3e4mr15690515e9.3.1781263919318;
        Fri, 12 Jun 2026 04:31:59 -0700 (PDT)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f20e77asm5427094f8f.0.2026.06.12.04.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 04:31:58 -0700 (PDT)
Date: Fri, 12 Jun 2026 13:31:55 +0200
From: Petr Tesarik <ptesarik@suse.com>
To: "Brendan Jackman" <brendan.jackman@linux.dev>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, <linux-mm@kvack.org>, "Brendan Jackman"
 <jackmanb@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan"
 <ziy@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] mm: reduce NODE_RECLAIM_xxx and change to enum
Message-ID: <20260612133155.71958e80@mordecai>
In-Reply-To: <DJ6ZMH9VU0BE.6Q8EHJIL65DW@linux.dev>
References: <20260612085052.59291-1-ptesarik@suse.com>
	<DJ6ZMH9VU0BE.6Q8EHJIL65DW@linux.dev>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: gb4ps1ci7qk4bb888qdcuzemd7d95u7r
X-Rspamd-Queue-Id: 0B1ECC0003
X-HE-Tag: 1781263920-681803
X-HE-Meta: U2FsdGVkX1/Jif5WecHkB7GhQJ1Fzc008UW4zDqT0+6QnP8Akem17fqEkIfk8wEr8NtiS0gnOGBsfE0hfXHVtBRZK4qs8Kej/RQHHWsbpxZ7x0jPTuxQ30L8uhHLUAvlEbbQMvUapM9SKorxz+UyqHbHrdFfRPY5VRpwrtEpqr7k+4V03qgAEZj65W89Oe3OjTu8PVEcQLdIi3o+RAGFejol7tmOXqHZCWtz8pMRBwRdD+M3rx4Kqf8p3njQRIsNWg/WP/LoIzcurj9VaDhiTLJWj9Lo+B3L/LeZIj8vptZoDBX7VzuNJWwfczpuT8IbHJ45nXyq5hHiGoK1aTPtATd/VsVtqJa6RsumT25xS7mx2ooZi6Hh/O7pdtgJdmdlNXYPIBYh/bxZxCFUc74gcgLqVlAgl+EnndtR2Ixt6x6rByXjdtHRSrPNWzjFg63qejEaXQBxhQM0dICJP8HAZay2tFo9SxpKdP0n+kNr7MzLODxb/LMUP8FbZsORbq7IKB/ZuZGM2Ja9sKGAPi9nfhEuaXiMYJQQ/3JEBoihQvGUg7gDfZ/ymbvTUK4RB9FOhPqZpEmqa+tSUmKt08xQU5Ir4jObPD7VF/wavVAFbQ4RfI/HkCcv+77469arB912bSb6S4xEaiX3gdiKEuZ23ErG9ATaA+UH8NcZODcMFZDHP/9t0uuIZ9H6QEhJxMq6jDB533Ma0dR2+hjcUtv1p+wX6oCESYZAe0dw3r8wF/PUw7h1gvm23Ki2tcC4MxtuHnH4e0768vr2yrP6R2ewHUwYL5hdua+n+dzBTIWCjFKOvx07SJkDYsAoQOaZa6xxDCPaHIOi+Fl2Hrwr/+e5755B61nhvXtET8NnGa1pUVbfhiFwMvmhtXGqnu/JWWsBNCY0HKZRpOk/W7sEDmNBb3G95/2qax9XdFxkqgI0PIliCuLavROgjgJlQsLcmLVfAHfg39JmjqZeRsS6IBN
 uTr63CRL
 J9Nld3g7Z+Mb4OVqh0jW56RESZLaFUDiC7eWznB1ckrHoLYXPtEKI12V5PRhq8W5Pha0aGt1kePCNrBHpq/K+69wmoA/jheOzOQaZAfecUKvfJXuGkKnScYztk+JXP7kAtkQeYVbMvgSbxYNkXOObTfpM1oHXvHpG+AWnwBI134d/dQz72/AgTkTaNpqYoJORLx7IOayW1W5Iey+pPuI9grkfuVTvVzLte35wx/U0MrLUIbPVaWGz9V6YkcsRO3U2Kz9vj2Fp7ELZwaVbb3GeG0YtdjleLHgMuJDhfBCGQG3zUkKFApglRVTNd790MH38fzGLD9ojWHk3SPL0y4fVdXLIUTGCTwsqB2qH6JQEgiY1i7BTiqwnC6DVUQLzZoR0yUAthYQ4Hm3vaLk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026 10:10:20 +0000
"Brendan Jackman" <brendan.jackman@linux.dev> wrote:

> On Fri Jun 12, 2026 at 8:50 AM UTC, Petr Tesarik wrote:
> > Change node_reclaim() to return an enum indicating whether any
> > pages have been reclaimed, because that's all the information
> > needed by the only caller, get_page_from_freelist().
> >
> > This leads to the following translation of the old macro
> > identifiers to the new enum values:
> >
> > - NODE_RECLAIM_NOSCAN  -> NODE_RECLAIM_NONE
> > - NODE_RECLAIM_FULL    -> NODE_RECLAIM_NONE
> > - NODE_RECLAIM_SOME    -> NODE_RECLAIM_SUCCESS
> > - NODE_RECLAIM_SUCCESS -> NODE_RECLAIM_SUCCESS
> >
> > Originally, I was looking for occurences of NODE_RECLAIM_SOME
> > and NODE_RECLAIM_SUCCESS, but I couldn't find any. That's because
> > they are typecast from the result of a relational operator. This
> > seemed a bit fragile, so I dug a bit deeper and came up with this
> > proposed cleanup.
> >
> > Signed-off-by: Petr Tesarik <ptesarik@suse.com>
> >
> > --
> >
> > Changes from v1:
> > - use an enum instead of a bool
> > ---
> >  mm/internal.h   | 17 +++++++++--------
> >  mm/page_alloc.c | 19 ++++---------------
> >  mm/vmscan.c     | 18 +++++++++---------
> >  3 files changed, 22 insertions(+), 32 deletions(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 181e79f1d6a20..89b0ea28051c1 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -1373,23 +1373,24 @@ static inline void mminit_verify_zonelist(void)
> >  }
> >  #endif /* CONFIG_DEBUG_MEMORY_INIT */
> >  
> > -#define NODE_RECLAIM_NOSCAN	-2
> > -#define NODE_RECLAIM_FULL	-1
> > -#define NODE_RECLAIM_SOME	0
> > -#define NODE_RECLAIM_SUCCESS	1
> > +enum node_reclaim {
> > +	NODE_RECLAIM_NONE,
> > +	NODE_RECLAIM_SUCCESS,
> > +};
> >  
> >  #ifdef CONFIG_NUMA
> >  extern int node_reclaim_mode;
> >  
> > -extern int node_reclaim(struct pglist_data *, gfp_t, unsigned int);
> > +extern enum node_reclaim node_reclaim(struct pglist_data *pgdat,
> > +				      gfp_t gfp_mask, unsigned int order);
> >  extern int find_next_best_node(int node, nodemask_t *used_node_mask);
> >  #else
> >  #define node_reclaim_mode 0
> >  
> > -static inline int node_reclaim(struct pglist_data *pgdat, gfp_t mask,
> > -				unsigned int order)
> > +static inline enum node_reclaim node_reclaim(struct pglist_data *pgdat,
> > +					     gfp_t mask, unsigned int order)
> >  {
> > -	return NODE_RECLAIM_NOSCAN;
> > +	return NODE_RECLAIM_NONE;
> >  }
> >  static inline int find_next_best_node(int node, nodemask_t *used_node_mask)
> >  {
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index f7db8f049bd23..83a1caac5ac9c 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -3899,8 +3899,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
> >  		if (!zone_watermark_fast(zone, order, mark,
> >  				       ac->highest_zoneidx, alloc_flags,
> >  				       gfp_mask)) {
> > -			int ret;
> > -
> >  			if (cond_accept_memory(zone, order, alloc_flags))
> >  				goto try_this_zone;
> >  
> > @@ -3921,22 +3919,13 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
> >  			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
> >  				continue;
> >  
> > -			ret = node_reclaim(zone->zone_pgdat, gfp_mask, order);
> > -			switch (ret) {
> > -			case NODE_RECLAIM_NOSCAN:
> > -				/* did not scan */
> > -				continue;
> > -			case NODE_RECLAIM_FULL:
> > -				/* scanned but unreclaimable */
> > +			if (node_reclaim(zone->zone_pgdat, gfp_mask, order) == NODE_RECLAIM_NONE)
> >  				continue;
> > -			default:
> > -				/* did we reclaim enough */
> > -				if (zone_watermark_ok(zone, order, mark,
> > -					ac->highest_zoneidx, alloc_flags))
> > -					goto try_this_zone;
> >  
> > +			/* did we reclaim enough */
> > +			if (!zone_watermark_ok(zone, order, mark,
> > +					       ac->highest_zoneidx, alloc_flags))
> >  				continue;
> > -			}
> >  		}
> >  
> >  try_this_zone:
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 3f3ff25e561ac..d5bd55620ee9a 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -7786,9 +7786,9 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
> >  	return sc->nr_reclaimed;
> >  }
> >  
> > -int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
> > +enum node_reclaim node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
> >  {
> > -	int ret;
> > +	unsigned long nr_reclaimed;
> >  	/* Minimum pages needed in order to stay on node */
> >  	const unsigned long nr_pages = 1 << order;
> >  	struct scan_control sc = {
> > @@ -7815,13 +7815,13 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
> >  	if (node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages &&
> >  	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=
> >  	    pgdat->min_slab_pages)
> > -		return NODE_RECLAIM_FULL;
> > +		return NODE_RECLAIM_NONE;
> >  
> >  	/*
> >  	 * Do not scan if the allocation should not be delayed.
> >  	 */
> >  	if (!gfpflags_allow_blocking(gfp_mask) || (current->flags & PF_MEMALLOC))
> > -		return NODE_RECLAIM_NOSCAN;
> > +		return NODE_RECLAIM_NONE;
> >  
> >  	/*
> >  	 * Only run node reclaim on the local node or on nodes that do not
> > @@ -7830,20 +7830,20 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
> >  	 * as wide as possible.
> >  	 */
> >  	if (node_state(pgdat->node_id, N_CPU) && pgdat->node_id != numa_node_id())
> > -		return NODE_RECLAIM_NOSCAN;
> > +		return NODE_RECLAIM_NONE;
> >  
> >  	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
> > -		return NODE_RECLAIM_NOSCAN;
> > +		return NODE_RECLAIM_NONE;
> >  
> > -	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >= nr_pages;
> > +	nr_reclaimed = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc);
> >  	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
> >  
> > -	if (ret)
> > +	if (nr_reclaimed >= nr_pages)
> >  		count_vm_event(PGSCAN_ZONE_RECLAIM_SUCCESS);
> >  	else
> >  		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
> >  
> > -	return ret;
> > +	return NODE_RECLAIM_SUCCESS;  
> 
> Should that be returning NODE_RECLAIM_NONE when !ret?

No. That's the thing. Before my patch, the return value here was either
NODE_RECLAIM_SUCCESS (when at least nr_pages were reclaimed), or
NODE_RECLAIM_SOME (if less than nr_pages were reclaimed), but the caller
makes no distinction, handling both cases in the default label of a
switch statement.

Petr T

