Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83D53D5B86E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 21:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48476B0089; Mon, 15 Dec 2025 16:14:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5916B008A; Mon, 15 Dec 2025 16:14:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6046B008C; Mon, 15 Dec 2025 16:14:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9AC5A6B0089
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:14:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 620AC8A548
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:14:05 +0000 (UTC)
X-FDA: 84222958050.11.5139DE8
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2A6A64000F
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:14:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Sv9mdRHr;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765833243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sprp7N31vRBp7VCcAwUpV7y0XcoygDpCbBqecnhH9uE=;
	b=iARC2THsyTuN7/Shsn/mm8qMjMdr5PHPtIsHaeq8tbzGrQBanzyaUd1Xc5YaewJ8TVBnO7
	NKcNV5Lw/ku27NYV8eOaqA5rpbdh0BbkiAKNI75izPC3bG7uEBoft8es5udmMApMkMmgWH
	o2kRCjR7EGciGIKdF0bA9mu8kqHUDBI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Sv9mdRHr;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765833243; a=rsa-sha256;
	cv=none;
	b=csvTBApZk2jxkMrLIln94JwiVkMup2iX9WtBeCYwzlvTJLrbMzHrIMwJqOsWc1alzaTAuR
	0L608rFuoQed8bH9Ft1FT70vz7MJpjAcRFQSr2SQpTUWvwTK2GoB8uXgZnPTzHgPBGoCjp
	hOxJEq+u4lGmehLx6gs3ZRfugNwJMx0=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8b25dd7ab33so244135285a.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 13:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1765833242; x=1766438042; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sprp7N31vRBp7VCcAwUpV7y0XcoygDpCbBqecnhH9uE=;
        b=Sv9mdRHrG69UEspuh554V6yZ/9nuW8JuMkRSu+5RVkvUj66J6RABn3o5/JKCJYJQHy
         1cK3YtDs3CBCOWu2zGECqzdDLVd+X2n3bsRawQCONvGTCQy6bgK1lQTC48ANPFwLG/AF
         hPz0iNCVJooFFD8+ZEF/1nt3KpV5nY0yXX062z6F0oI693Tp6iQDnvaeLAwrT4cTR323
         SmiZeH6KHps3AZJaOqB/kq5J1/R2NQ4wWa9ounwfWO5LZkQtJSru1hwd5UfL9drSBNFo
         p2yWFP4Gau0zpjb3Ua58HrouQX8lLB1lws1noS3853zT/tU6FsigojMa4GnfaqZpVTWu
         uh1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765833242; x=1766438042;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sprp7N31vRBp7VCcAwUpV7y0XcoygDpCbBqecnhH9uE=;
        b=G6Oo8t2mz9/gR4qSA5IQCHgTInQqg1roNb5VJHJkZAaRK5dHmFstmL29MBghOXK9LY
         Z70QUhwi71w77JYOe3bSU1lNch3H3bEST5X79E4f3Bpsy3yihdM4Q3udUpfeQHmVq4/y
         ZuWSui9ekesl3oYnQmvDdkA32wUESxUndnqB6or+ndzM+YL1yfe1B5En3k8Dfakiwe/w
         4jRND8ryufzuslhn9xEGvzsd6kXeJ31omoqrqK+zRreD+xm5wNKkNvqSWJHXZODOWIqJ
         GkGB4CYFieuIE7Dccl+/nNpWef5jJJy73m/8n24O48mWF/yqQ7u6INmmLQ37WwCw+HNG
         SulQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlYmG9UqmyAquqDlQvdKGOOC/yu1QpttscSn+2+VzFhZabiMv6nuD5sGX/XmIIMHMabzEg354rxQ==@kvack.org
X-Gm-Message-State: AOJu0Yzbo+aI/sj1U7l61w3oFHUep87HY0mNObqF29+8jDhorlvrvqAb
	TEOhFUOaS2h6gR8hM0gbWOk5bIjtdEqt0Fif4ckKeGb0KUYwMu6U3aG/pLkhhsvLDxk=
X-Gm-Gg: AY/fxX7RduMI4eokbCNYeAbOaSlFQAt+flS1WMbghw9v844RWcN9uECMqgzSZUxin7S
	fYssOJEKwqPwQv/wzIm3oS9f54RmsR0/YZsdM5UEokpozEYcZLQxJToHGm1LllhK8WYKaIPZAyu
	K96NiTQ8u0h6EqxRdff1hkBskEkMCXnRvvHA0T5bXl88hPcl3e1bWacT589V9Z0HnKfbDAEjnmW
	3qAxoU9UO4eq4WXnG/8IFHjyabn55UCiR4a69UXm0+NLhdqLjFIDTbrgOXtlEGB9QrumFBbQPlC
	+M+zJ7sU2nFAOV9SW9I88Fcv0RLNM65M5vL+9yX7sPTXP9FCB55Of4kYyw0sPsbesT6gzkRV1h/
	MWdoOH+kdLNRHpW9qhWHtNW2xKJMWDS2p3PZ93dpwqwJ66s1bsJAvpHvkCV2udfeEVmHHUchj8M
	d4sM2+QuZLJQ==
X-Google-Smtp-Source: AGHT+IHZwGOmPvX/ipW2v8YF+vbttYdToKCmV+QF3O0fIsJWdhQfh5G0IVQ6AYKNvskI6a+jEMbH0g==
X-Received: by 2002:a05:620a:2a01:b0:8b2:1568:82e8 with SMTP id af79cd13be357-8bb39fb6365mr1568864485a.35.1765833241963;
        Mon, 15 Dec 2025 13:14:01 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8be303e7e51sm37195385a.7.2025.12.15.13.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 13:14:01 -0800 (PST)
Date: Mon, 15 Dec 2025 16:13:57 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	lujialin4@huawei.com, zhongjinji@honor.com
Subject: Re: [PATCH -next 3/5] mm/mglru: extend shrink_one for both lrugen
 and non-lrugen
Message-ID: <20251215211357.GF905277@cmpxchg.org>
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
 <20251209012557.1949239-4-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209012557.1949239-4-chenridong@huaweicloud.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: ft9s1rwmji9mher5brrgw7cd7coymx5m
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A6A64000F
X-HE-Tag: 1765833243-954903
X-HE-Meta: U2FsdGVkX1+gOitVQXXObXW/JcZ/KnWWCigKAy6Q3GkaXVypR7YC0h9DFqBb/YyvK05xujuMF81BDyFUFb+VPz22dDpKQLqSWedSj9WQ2L8+J8Jq6bYC2CjGquUF1tnxHFESthKRKl2io/KBXIYWiSh7apZs+HVP0R0nB35xnUewXLCtXvIiX8P6pmlzpmsndajCRJoeL8JL6jPSuy2/2QnHXrJ4JswUEy6p26LWXQUpZbxiPSu9AyWKw6gc4H2sBw5kNxNdX3Es3qGcnk4EkhHCYPiNkndvGirZR8cPHm6ntbMn28QXWkD7KVy1akFJYHNTSCif7ayITDCuvIDYYQgjT3VMGBxDYNnbbpiPp/JCz2h39yKKu7fjQlVdCVhuL4Gg2DH2Z85dTp35xLR0EE0FayZ00rnCBNSBW3x5HWZdW4Cpixlkh9l2Ra8aQNn8GCBL8oiDJwXCPYJ5CoOC8PyoYq6vf5f35JVgbXaMNZY7HFsJLrkcpTPaCkiaY2mWcTy7f6DYVNxM1rqOFtCy5Uep+ueqPK5qq2oaRq4Y2pUGPrADvUDbLmeOt/qqSRAp19g0T5GozRr6i6+ELG989KWXHWc7rMRhGBgXMHUcN5UP+9xec4fLT4KUO8oUOn7ORbgFDp0/uovNYWgyNXjnP3njDyd7LwfrLuU8lh7FqxChWGND+TUj7PPclFdLzEnKmwr8+SNlp8tQpGE92rOJqkibqCeKI16d3p4wn/4WFHIPgTacAnoVxUwZwgRQVqmMMJM7R/mdqo9+6ExaLSuyVoHfVLZZdfRcS4LYQvHPcNhsBHltA8ot2c+t5pZDW7cVpEWdCary3lYyUlqhgHMx1EOukQr02N3GzTJ15HyR7x3T6499z2F6CSZVXasWyZBTwtPmAIfGkRNwXGtmtb/ZU2IChVQ6TTf7nXFM+NFXxRlNJOoMr5KrcTaO4rbF2Ei1LdFsV6ez2yEwGi8nKXk
 QyAwtrG9
 H0MSBf++KgdXbIfkUp73GztvbY+9/YkmA41i6ZNlk45qf6cYnAQcMd/bzuxeWVSqBpfaCQMhuUvSF5f3Nf999MBC9Yol9ebxbuzsPBQ0GIYFmmQP6Hx2DzLvlHeYR+wWp08vnSEgBYOfypFUzG9y2z4sP2PF/D5Qo28fHIlWq1poOKAnf+ALQS5cl78/I9BN/78VUR0xIXzBI3ptzTvIF/4Bu6oCtVXyEwzLL6SF5X/EbiG6J03HZ26Omi0MgXSuIz9bUln/+3Tno43c1TWcuVX7HVPCAzprRtflr9AVqkiw/Y3EllBSUADfhMbJj4h+/ZA1l8WE7tUwLl9nX4jK/2IF1nOxhyPFmObxiAunp6DOKC+TLMkv0sP5eqNozzcGuhORB2Wu13A1N1VQQX8qVZiZigK7ytEZS0IgDF2D65t7ismblChXvB372LemMGc4c09l7XnCs8f/RwbBVl4xERaJs2Lsr9oE11r57
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 01:25:55AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> Currently, flush_reclaim_state is placed differently between
> shrink_node_memcgs and shrink_many. shrink_many (only used for gen-LRU)
> calls it after each lruvec is shrunk, while shrink_node_memcgs calls it
> only after all lruvecs have been shrunk.
> 
> This patch moves flush_reclaim_state into shrink_node_memcgs and calls it
> after each lruvec. This unifies the behavior and is reasonable because:
> 
> 1. flush_reclaim_state adds current->reclaim_state->reclaimed to
>    sc->nr_reclaimed.
> 2. For non-MGLRU root reclaim, this can help stop the iteration earlier
>    when nr_to_reclaim is reached.
> 3. For non-root reclaim, the effect is negligible since flush_reclaim_state
>    does nothing in that case.
> 
> After moving flush_reclaim_state into shrink_node_memcgs, shrink_one can be
> extended to support both lrugen and non-lrugen paths. It will call
> try_to_shrink_lruvec for lrugen root reclaim and shrink_lruvec otherwise.
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> ---
>  mm/vmscan.c | 57 +++++++++++++++++++++--------------------------------
>  1 file changed, 23 insertions(+), 34 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 584f41eb4c14..795f5ebd9341 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4758,23 +4758,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  	return nr_to_scan < 0;
>  }
>  
> -static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
> -{
> -	unsigned long scanned = sc->nr_scanned;
> -	unsigned long reclaimed = sc->nr_reclaimed;
> -	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> -	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> -
> -	try_to_shrink_lruvec(lruvec, sc);
> -
> -	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
> -
> -	if (!sc->proactive)
> -		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
> -			   sc->nr_reclaimed - reclaimed);
> -
> -	flush_reclaim_state(sc);
> -}
> +static void shrink_one(struct lruvec *lruvec, struct scan_control *sc);
>  
>  static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
>  {
> @@ -5760,6 +5744,27 @@ static inline bool should_continue_reclaim(struct pglist_data *pgdat,
>  	return inactive_lru_pages > pages_for_compaction;
>  }
>  
> +static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
> +{
> +	unsigned long scanned = sc->nr_scanned;
> +	unsigned long reclaimed = sc->nr_reclaimed;
> +	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> +
> +	if (lru_gen_enabled() && root_reclaim(sc))
> +		try_to_shrink_lruvec(lruvec, sc);
> +	else
> +		shrink_lruvec(lruvec, sc);

Yikes. So we end up with:

shrink_node_memcgs()
  shrink_one()
    if lru_gen_enabled && root_reclaim(sc)
      try_to_shrink_lruvec(lruvec, sc)
    else
      shrink_lruvec()
        if lru_gen_enabled && !root_reclaim(sc)
          lru_gen_shrink_lruvec(lruvec, sc)
            try_to_shrink_lruvec()

I think it's doing too much at once. Can you get it into the following
shape:

shrink_node_memcgs()
  for each memcg:
    if lru_gen_enabled:
      lru_gen_shrink_lruvec()
    else
      shrink_lruvec()

and handle the differences in those two functions? Then look for
overlap one level down, and so forth.

