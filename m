Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7021D73099
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 04:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F161B6B0005; Fri,  3 Apr 2026 00:45:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC73E6B0089; Fri,  3 Apr 2026 00:45:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCCA6B008A; Fri,  3 Apr 2026 00:45:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD1C86B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:45:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 62C4C13AC36
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 04:45:04 +0000 (UTC)
X-FDA: 84616004928.19.93DA52C
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 827D440007
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 04:45:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D6CPPgj8;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775191502; a=rsa-sha256;
	cv=none;
	b=XeVRWDwovsMiII+rI/GYEdWzw7ixGwPBBH2q7a4CdmGkUlhADVKGe2Y4gSVbVWZd5Y7gVS
	hwRtbRvQvHcdYyDG9LsxGNhGIPilw+GOKhUgnYNI2+MnObrovI7BCYKhGq/qIQSjZxKQXY
	yMgI36Xccp5nT6iIuVQrdDIxmi7F4to=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775191502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFFOJlWNYenuIR7tW+KRBOvl8G+oT+ShQ5RGo8YTPJk=;
	b=RdrpnCz7WETd+HP+Mj07BPOtJLby0zF+bZ2bwmQgaYRfct0zx+npqqJnqPaye7/tjyaLmO
	bD5cjF3I0jEYHXTGYJPbCi0YOAboBC6d5HLgQvNUsJ/0zFZl4z5p8HpfSJRlYaGeJHc7cf
	HyVo8MOpjJ/j/7y5VVXS+RLzbx18RAg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D6CPPgj8;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82ce0a9b3f7so711432b3a.0
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 21:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775191501; x=1775796301; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qFFOJlWNYenuIR7tW+KRBOvl8G+oT+ShQ5RGo8YTPJk=;
        b=D6CPPgj85A8TNkFRnfZgXewel6sa2KOlRF0APkx3RD9SYpqJD3DHFylIKvb7Tjnh/P
         EsudfC0TT5citCgpgorFvBJw9s5Fmsew40TVFe0B3+dM8q4yssZeOMckZgYiH3yPR8vJ
         sTyj4ihetuIhaW8lN40zY6uWHM6tlL9Chjiw2yhRrKIT33LFr8Z20Vce637z8buldozR
         qVWr9zGV4WqIamjN04qua0fJXG+33xTpcOCxDAHt3lvoDXKW3bHqDGyrPgyz+jUkO+kb
         2ijB01StlEB2y7sGItopnspta4G0Zhg9lW/MFMxF0vp0RSBM6EA+gRDaDaNEzOLfkpe5
         tRWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775191501; x=1775796301;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qFFOJlWNYenuIR7tW+KRBOvl8G+oT+ShQ5RGo8YTPJk=;
        b=oBzKOEyZNDOXzSXfZkeynsHKy+lcOEnvZd03PVnTb6/G4azjc06/dEqpdjipgApAG/
         m5ZzcTvq3f2BRSX7m1qHHtMD4p06RANiiZrdZeykZRVfQ9dGRu7eOygxO5KR46tBy/kN
         GMXoYYdpdgNOs6S+Z1D2vJVwlUxjRUiepgqKhZ3Xy9cLArIK1ZFd/KS/7Z5nLmwuEiCj
         fybsCZoEBFiHDS3TkTUtQWJ+gRWoh2RaM9SLtL1kSDmseTqAbrd3AJpre7IUHTQEkL9j
         uUi6+/g/fqcAU/BDAG2ZUUJW9qJFFgycV5iSeGhOAWdY0/UzMr2qYD0PuH5p2PiwJh8S
         /9Og==
X-Gm-Message-State: AOJu0YwRF71THrsA97/kzqF/91zunKedKuHNFXcJsQ0N0x4dVbBu26tG
	bG+BfggUc4mjmGAKy6kBQq+XPJ0APLvbOZcy2n33pM0vIn1sd4iOFJSVD1dQuBMaxPs=
X-Gm-Gg: ATEYQzxGHx5C6/HeDu5gwHLRFarwCsWcFl/irmNikTqJTqc45mK6pRqzJePFdRT1EFk
	V1lMa1CYV9UH1TPFu0GVcuKgjLSHM1Vx7GbhwXpxpi/5efznm92b1FfRm+Zn1psGmiHEUxfohnh
	CBw62TgasXI+uoX6+NooUTqIif7ZNjOWbPV/lQ7eRcyQKUpHsLtU6a2e2VETZ5ZH1YB/pazI6I4
	I0IzkAybLzsASrCBlFOyZSP67YlLTUDCa3ZTczlWudIRmJ5O6G1oPr02MkN5eq6JhuslPvuBjwD
	zOF9ifWJGNQi6xQtAgkqK14rgAuaOq9m2PgY/Roka/FdM55HEHWc5HUd+L1uWq9Rr6EMAh6DkPA
	zXK8Xsb0tfqW7au5ORVV2Nqvp/45mBana+McnStwRHXleHYWZoae5dBc5fLSKJEj6hgOWWmQ3CS
	ZMfCyuq6vo1Y5fIwlmqPwDFL//ADIIiSykoOnt4DLra3nEY5xVGbL77oIjKCGWvMSz42KK
X-Received: by 2002:a05:6a00:17a5:b0:823:12cb:f5d1 with SMTP id d2e1a72fcca58-82d0da3de84mr1679971b3a.6.1775191500775;
        Thu, 02 Apr 2026 21:45:00 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c6b80dsm5821114b3a.42.2026.04.02.21.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 21:45:00 -0700 (PDT)
Date: Fri, 3 Apr 2026 12:44:52 +0800
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, kasong@tencent.com, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v3 04/14] mm/mglru: restructure the reclaim loop
Message-ID: <ac8xVN82LBLDZpIO@KASONG-MC4>
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
 <20260403-mglru-reclaim-v3-4-a285efd6ff91@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403-mglru-reclaim-v3-4-a285efd6ff91@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 827D440007
X-Stat-Signature: o7hx53rzdhgauzhes5nzcrajwymfhmnu
X-HE-Tag: 1775191502-845602
X-HE-Meta: U2FsdGVkX18VFcKrwh/rxq7Z5cV/YzebaVcH71ljE1bOCIiXLK25PxyisxAfXluWZGnyC/1TCCgZh3D4dpF14f0m2UNGL0qp9LFdvdOFz0zXXRHNC6HH/bjF0Pi+AUdndRYq6/JZ+7wy7vL++Fn+IJ5hHWKrnl5QRCOAfGYPvegkSbde5VcHBcZxVIW2XzrCfWYC2K3U5HhKtOvzN2ygVZlhb1ylBhtUsN8UW4AXnRfNM28xvQeRIeeLhe3HoDMjUzKINdk1togagEr7Lj/D3Q1zuou1pQzY9spRgaOQID/fNhBTN4lvkWagex5nRdRreUwlCmlamgRmpDzlpHPJHUssYr+27swhoB8KjS3msAg/n8ugOUmyDR3Op5wGIA7oCDP7wV8+8w3dXqclxwChuYCu1R87QEGEL9d/pvanLbgYSlKNA58vPz6Q8feeYb6dkpOmuzYFDQX/DwKBzSYXqMpnUqJA+VcOFJB4lWA/sMNVQUM9OYaV3uo9VmHITpE53w4zysIc7k4a3YT9HhGOcLdfMBmHlc2Hqq66XaQt8Vyqmov4xCng+ptHa5XAExlCqw2VS5dEzgbSDSX2jsYxGwFlzneWRMjleWigtou72pF2878eTB5RC7nV0ApBJZS00N1f05AbD0OmFb16qjy0zTNxF9TZtDVE+cZbuH4EoqR/o6IG+OU+GGbKpxQuprD4p5MLctrRYv3hXL+taqbRqtryRGbC/zCN0NKOHnGYdoL48n4ERNDW2MXr1YlDHgp4NlRrArTjpzsTuIwjkMbW8qc+gXWsvQM1KVjppcoyz+sdH13BhqE2SJ2xiLqO/pww/W5B455zmeR0LIhbJ/y5hp1oibWEx1iyOBE28hVsV1L5MSPrY1AFgfSI+WeG5KV6jNscsAjU9TmRD2CqY2FgBN2WEpR2Ng7b7Xy39Z9njQXF0f13jwxru/z4sMAlly3D6E0tiHDBIEgLl3cnnYR
 RQoa9j3U
 Jd136HfHESBxZt0oRbG+t/SXEKK+d1NrE9znNlYqolGiLjGfFvZE02Up3PGQb4JbVg+7TbbTYjB3ulzG2Q6ONdFR0h94sIH49o6GJO8vGp/VzTI8CAJkQrSrbPJr+XB2lw8A73lo9nzBfY4alxhDkKMk7qgXLnOcVaxE1I0CR+uk1ESg5ZEph+Tm9MOiH4RTJKJ3QK4dkxJt8MioeIR74/34OXMlBCBErITisOs74tOTiK67X2EEUNhbXF3TzOQlOY76gYWXZ5Rd7iQIb2604vvJHT3gkwHiKXHYsfPRH8mqqq3jkmXX6WVyXqOga4VMC0sC8ZC9TNBzW70jJPp9Y0uc5JdEmnAh3YhuKwiA+37e/P86JL57+p0opW4DR2C5OEPSdMMl+chNf6TogBR4o2H6EKm2UD3jAJH0IJhwkOa1CDpeHRV7B4sPe5jgo2uM9yQkPd9RC73SwCiTpceRHO6FfC67iW4DwWnS1yLtFpQBOcSCboKd61fJZbYEncYkcYFPoXw3YLK3zyGZ0QvxpqKkp0aQM0RodLC8KLD4nIh7STiepOJYMlbXUDsMGUu7ZAiHpC0QSoxdBbGs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko review:

https://sashiko.dev/#/patchset/20260403-mglru-reclaim-v3-0-a285efd6ff91%40tencent.com?part=4

> commit 89b3058e01113eb027062254e73446d398af330a
> Author: Kairui Song <kasong@tencent.com>
> mm/mglru: restructure the reclaim loop
> This commit restructures the MGLRU reclaim loop by calculating the scan
> number once at the beginning of reclaim and decoupling aging from rotation.
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 963362523782a..93ffb3d98fedf 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> [ ... ]
> > -static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
> > +static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
> > +			   struct mem_cgroup *memcg, int swappiness)
> >  {
> > -	bool need_aging;
> > -	unsigned long nr_to_scan;
> > -	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> > -	DEFINE_MAX_SEQ(lruvec);
> > -
> > -	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
> > -		return -1;
> > -
> > -	need_aging = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
> > +	unsigned long evictable, nr_to_scan;
> >  
> > +	evictable = lruvec_evictable_size(lruvec, swappiness);
> > +	nr_to_scan = evictable;
> [ ... ]
> >  	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
> >  
> > -	/* try to get away with not aging at the default priority */
> > -	if (!need_aging || sc->priority == DEF_PRIORITY)
> > -		return nr_to_scan >> sc->priority;
> > +	/*
> > +	 * Always respect scan priority, minimally target some folios
> > +	 * to keep reclaim moving forwards.
> > +	 */
> > +	nr_to_scan >>= sc->priority;
> > +	if (!nr_to_scan)
> > +		nr_to_scan = min(evictable, SWAP_CLUSTER_MAX);
> When falling back to a minimum scan size, does this bypass the memory.low
> protection applied earlier by apply_proportional_protection()?
> Since the fallback uses the original unprotected evictable value rather
> than the protected nr_to_scan calculated prior to the priority shift, it
> appears protected memcgs will evaluate to min(evictable, 32) = 32
> and be forcefully scanned, bypassing the protection.
> Could this also cause an inversion based on memcg size?
> For example, an unprotected memcg with 4,000 folios shifts to 0 at
> DEF_PRIORITY (4000 >> 12) and falls back to 32 folios, whereas a larger
> memcg with 4,096 folios shifts to 1 (4096 >> 12) and scans only 1 folio.

That's really trivial I think.

The low protection calculation already has a "max(scan, SWAP_CLUSTER_MAX)"
check. If it's concerning here then the
nr_to_scan = min(evictable, SWAP_CLUSTER_MAX) can be dropped. And actually
in previous version of this series there isn't such check and it was
concerned that always apply the priority shift could lead to inefficient
reclaim of small cgroup. Having the min check here seems safer and
make the reclaim loop a bit more like what it was.

In theory and in practise there isn't much difference since only very
tiny cgroups are slightly affected, and in most cases the reclaimer
already starts with requesting SWAP_CLUSTER_MAX folios to be reclaimed
(nr_to_reclaim).

Maybe some chore cleanup can be done for a perfect accurate reclaim
budget starting from the reclaim start point. Not sure if that
would be a practical thing to do though.

> > -	/* stop scanning this lruvec as it's low on cold folios */
> > -	return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -1 : 0;
> > +	return nr_to_scan;
> >  }
> [ ... ]
> > +static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
> >  {
> > +	bool need_rotate = false;
> >  	long nr_batch, nr_to_scan;
> > -	unsigned long scanned = 0;
> >  	int swappiness = get_swappiness(lruvec, sc);
> > +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> >  
> > -	while (true) {
> > +	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
> > +	while (nr_to_scan > 0) {
> >  		int delta;
> > +		DEFINE_MAX_SEQ(lruvec);
> >  
> > -		nr_to_scan = get_nr_to_scan(lruvec, sc, swappiness);
> > -		if (nr_to_scan <= 0)
> > +		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
> > +			need_rotate = true;
> >  			break;
> > +		}
> > +
> > +		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
> > +			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
> > +				need_rotate = true;
> > +			break;
> > +		}
> If an lruvec has zero evictable folios in its oldest generation,
> get_nr_to_scan() will return 0, and this loop will be completely bypassed.

No, get_nr_to_scan won't return zero if aging helps get this LRU
evictable. And if even aging won't help there is no point to
reclaim it.

> Because the memcg rotation check (mem_cgroup_below_min) and the MGLRU aging
> logic (should_run_aging) are now entirely inside this loop, will this leave
> an lruvec permanently stalled?

There won't be stall, in worst case empty memcgs filled all the
random bucket, it just requires a few more iteration to find a
reclaimable memcg.

But on second though, if get_nr_to_scan returns 0 in the first try,
try_to_shrink_lruvec should just return true to rotate unevictable
LRU to speed up following reclaim indeed. The old behavior is a bit
fuzzy about this since the rotation and not doing the best
choice either, roration is decided by if an aging success but
an unevictable LRU doesn't always trigger aging.

This part can be improved easily while at it, should be a
nice micro optimization, would do that if V3 is sent.

