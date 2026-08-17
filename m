Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AAB3C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0066B00EC; Mon, 17 Aug 2026 12:04:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6F56B00ED; Mon, 17 Aug 2026 12:04:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8084A6B00EE; Mon, 17 Aug 2026 12:04:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF926B00EC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:04:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB7D81C1BDA
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:04:27 +0000 (UTC)
X-FDA: 85111233774.01.33925CF
Received: from mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
	by imf04.hostedemail.com (Postfix) with ESMTP id C0EF840012
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:04:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q6GDh+eB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786982666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6bvKWwul4MAxt/vg5vHzP9YNSKR5ox5YJG9+JAY1sAI=;
	b=Uq3AVeTmRTLN/xOejg+FblbuT6fK8KmifbCTPb1WQ3Steq7vnYECsNG8lHdsCSANYr7VlV
	AJwjwJvvuDE3sBFMvdJdkadKJdLljKYzWMYxBddKKHx0jEI/u3Qmfu1wVswdm1+HKtR1hg
	SjhznuwXRV62Mwsp6WOi3thenk1y0wU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q6GDh+eB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786982666;
	b=X2Fw+9KNXArnaNPjgitWcelR1btvS5DOii/BFBVGrIgLoHaUr3IZWK9nnsk0wa2986irgc
	0D3HYzHtWGmVe+DGZLRsRhrEnYcRzlxfsrJCDPHzbYVWnEdsCB8T/I/bLI5xSmbin4SnxE
	wx4j7AravX8T30K2Usb+GFLjcjmsXQE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SjbR/PgkZJDP5BslDAQ5jDOl6LqPclZDfgrCJIHFSoo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786982664; v=1; x=1787587464;
 b=q6GDh+eBCm+kWE8Uz+mzm0jcNG/ij3QPcfwPu9KuLFB7eDnHb2Ebs1CauCm2IpS1vEeeaseL
 OE48io6WE6RAtPfCRZI4sd3sA+CXcQDkEFH1I6qZGyvmK8PuJB+9bXuIjmvpuJNOmv7Q7UBburd
 bzs6+SyBOxk4kTDzUuDE3W6s=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:2a::)
	by smtp.migadu.com with ESMTPS id 68c5ea4acd3a7bb7;
	Mon, 17 Aug 2026 16:04:24 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 09:04:18 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, nphamcs@gmail.com, yosry@kernel.org, 
	chengming.zhou@linux.dev, yunzhao@cloudflare.com
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in
 obj_cgroup_may_zswap()
Message-ID: <aoMvtKr6o8a6KpDf@linux.dev>
References: <20260817131843.45121-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817131843.45121-1-husong@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: C0EF840012
X-Rspamd-Server: rspam07
X-Stat-Signature: udbqxwzzbiuxs71zueuhjayyib1fophr
X-HE-Tag: 1786982665-793882
X-HE-Meta: U2FsdGVkX1/3A8TkBOAfNu4XcfpVSRjtUgh6CLey4ph5Scqe7Wyea1qQo7s80K99QqU4U7RagRbBD74lDqT6nd7BDk2KUjSsOvXtgQrJvzdL2r6Rvd1Ma5cncficd8dtzQ4nfRt8eZ8Tc5eNwxjW2uBJG6XOl10w/DHGEYMDCwJpWD0aBRkwwSAmRlYrYVjUHgzXn8CLRZCrZ3HtZKeDTWdYH0VoifS87SATpJFdxVi4lPX3zoRoy2/O/RHB3rRoA7WhgnvzWMfESDGlLaIaLfdnxbcuV4jqsHz1OQZqRWHmI5cmYN6mHp+vw3QN1LSlCH36BsH+H+rxyk3GOZfTtqf0unE3Ell02w/Pd2oNnVA2upA1is6djnkY1lbbluvebjNZflJ7XaCFBBVTKVTDZEoNizrgZ8gdkQGGOlvr73xvVBJWguB5/VUFRmMrkBA+XMeoeOzSllONxjGcA5hi5BLLvPpB/WMmdITCyWV6x0UOIglIA0s3NC8qAm+DTbbvb0LxImcVV4OtqQOS28lEhk5ra1hr5sxFY5tUjb1AfKWd7sVfK25RYlAPAsI5Cjr8cXoz69TarfQNj2EkPRTNwbk9k67RUrle/510J00K5iSEoBxAaCPDprj7/8N+PfcSTVZlrihexCW6Q/jGLyyxQZhT+6UOX8wdSzsh9+7jHCvuO4vQC0MQbOZziIkDHfoThR5vr2Y5mtD3ooRiLmIu9X7Aw+mYkPN1BCPKPiQxBdjNRSq4bkj6/PlaFrIyTSVsVVW8Nc2bzzbBFzj3FwfpJMqvp50epAOZPpCLjsHDNGgt6krSzEojBdDy1jV5jv6C4ndfhrMMzM+MjVVFWlLRDtq4/2B+hrURiO+sTj6C0gHOy3yyydwL3X49Qz07T2+39xtZqc4DIsL1BkLFfT7jApwlSinLrRiq3r+EuwggPUE1aiFC+TuLd7XDJ8swDS0kNpPpct3MXy5F47yZpXt
 q7cxSCbh
 O+1n9ttne/B77+fMYxLeIFUzvY7SAIq9sWCoL/Tc1LArh0iVaEhX8P6jpwsXpzaKcdEwejbbPZoNOEbGogb1DN8LhCUl1GFMH1KEvzwHjPQL2oPlAGPq0t+aZczFcDNpvS0z+cGZkG9e/w9LneH11Bn7LJgird22yt/NxC1Sm9X9s14WiNPi64TsSxEvgxBbBfrYcnW533EMswYNGPpyzb1f5VFXSBzo9IxnLY38zH6t/77jZ0ja0hk0CMC1/QbyTKOClPnuGdulU3HzZGL13ai+6e7hGQbrrWEPT+zBhFWgLMkdESya9IUvu3R2fd07UC0VALt5F9n9/L/BgPMPV0g3VG+W4fPVnehdoSz6/gZghCic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 09:18:43PM +0800, Song Hu wrote:
> obj_cgroup_may_zswap() runs on every folio swapped out through
> zswap.  For each ancestor with a non-max zswap.max, it flushes the
> cgroup rstat hierarchy synchronously with force=true, which skips
> the ratelimit inside __mem_cgroup_flush_stats().  In a swap storm
> with zswap.max configured, a container takes the global rstat lock
> on every swapped-out folio.

Any reason you are limiting zswap through zswap.max?

> 
> zswap_shrinker_count() had the same pattern and switched to
> mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
> ("mm/zswap: use ratelimited stats flush in zswap_shrinker_count()"),
> where the same flush on the shrinker side showed up at 2.88% of
> kernel cycles under osq_lock on a 96-core machine.
> 
> Measured on a KVM guest with a swap storm under a cgroup with
> zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
> before the patch and 198,968 times after, while
> __mem_cgroup_flush_stats() was entered 281,017 times before and
> 80,445 times after.  The removed 200,572 flushes match the store
> attempt count almost exactly; the remainder comes from other stats
> readers in the swap path.

This is a known issue. Using ratelimited interface also comes with a drawback
that the kernel may react on stale information and the consequences might be
unneeded oom-kills.

There was orthogonal discussion on moving zswap limit enforcement away from
rstat. Yosry, any updates on that?

> 
> The stats can now be up to one flusher cycle stale, so zswap.max
> admission can overshoot for one cycle in a storm; the overshoot is
> corrected as soon as the next flush lands and later stores see it,
> the same tradeoff the shrinker side made.
> 
> Fixes: f4840ccfca25 ("zswap: memcg accounting")
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  mm/memcontrol.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17da1f43b7d3..7a8f689055c6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6000,8 +6000,7 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
>  			break;
>  		}
>  
> -		/* Force flush to get accurate stats for charging */
> -		__mem_cgroup_flush_stats(memcg, true);
> +		mem_cgroup_flush_stats_ratelimited(memcg);
>  		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
>  		if (pages < max)
>  			continue;
> -- 
> 2.43.0
> 

