Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5536ACCA490
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 02:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00ACA6B0088; Fri, 16 Oct 2026 22:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23AF6B008A; Fri, 16 Oct 2026 22:38:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEA136B008C; Fri, 16 Oct 2026 22:38:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3396B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:38:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 15CB5801E2
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 02:38:46 +0000 (UTC)
X-FDA: 85330560252.11.83820BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3FEA140005
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 02:38:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="a/GEhrIG";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792204724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCYy/omc/k0UmUcHxQJgnXUXd6XKF1gPbq7tP/hUJKU=;
	b=ewoUgLeEj2hpmP4m5dLGqbp4zA9eiPxwb7MinoLYygEsoVo5WLCyWuHZ4ysLH13on6yDEH
	SPeN0fmH35D/f3C8AEjHaCITvmyo03o7t67PhvloGHqfhZb08YvxRx4hVBT4DsL7Eo6lFU
	ANj7Viy3wY3U8NptM/auTI4sQkx7MPc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792204724;
	b=I8NC7Yix+BIavcZx3f5JQxK6aFWHB4zdfkG2erZHqzPxgiDMs97DMJdi3eF9UDAzCu8rC4
	tFooaFU//Ep3pjeBhfImbrH8Rj98yRzQOdcHq0/ipwdGYg+pn6BslB8tNUvlmPmme3G0OT
	DY5FmwXSydD5g4qI6X1829ieQK4wzdI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="a/GEhrIG";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F73B40A99;
	Sat, 17 Oct 2026 02:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5811F000C4;
	Sat, 17 Oct 2026 02:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792204722;
	bh=yCYy/omc/k0UmUcHxQJgnXUXd6XKF1gPbq7tP/hUJKU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=a/GEhrIG16ujWZEtMe2TRhF0aWm3OKHO9R7aOAjmg04ODrE/hQ76QqCThdvXH6hXK
	 l/WGCgfAhJI5+IZdEbJyG5IaaM1wkSiMeimGr9DAJRMTtlrFn2s1dLm4/Q3yImYE0f
	 U9CL2Pw5tTCsyQd7pRk0sX0fw750Mndukm5hD3zY=
Date: Fri, 16 Oct 2026 19:38:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Roman
 Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/shrinker: make per-memcg shrinker units
 cheaper
Message-Id: <20261016193842.5af1f5a6cffafd7a24aeb521@linux-foundation.org>
In-Reply-To: <79c1246f-8c9e-4e2a-adbf-e730732b33b1@virtuozzo.com>
References: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
	<20261014135046.7b13252ce99d918ffcdb1f49@linux-foundation.org>
	<84c9e97b-67c0-4c9b-bb7d-81811af8a16b@virtuozzo.com>
	<20261015175836.efc93cf9de01306402da61f9@linux-foundation.org>
	<79c1246f-8c9e-4e2a-adbf-e730732b33b1@virtuozzo.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3FEA140005
X-Stat-Signature: wg96adoqdze14x691mn8udymyaaboe3d
X-Rspam-User: 
X-HE-Tag: 1792204724-136269
X-HE-Meta: U2FsdGVkX19bSDAGojzXLWmkootOWM+rv3KyxrkW4myRCRcu3fYtxSRELtMcDquOLm9F2NodjYuooGmxbBG3hvOpOyw0jSfK2rX1B6pMDpLZIHjpFH3PJujcH+9wWhEfCOKtOK+oYDXL9uBr5wSEYTVr9pAYf2uFC48RTLS5Uf9jGEMTT/Y5AFx+VEUvo7ZZYlc1zuFpklTSIUQwz/a2zlD/SYEjE9l33eDqE5Ra3ukrS32QsRj1ExR/JWAp8NXdCqBnUeeI3VGkdLzRn0AIWl91IKZx3qlZfNsSVVZjZFMA7/GmNQHzGEu/swgUqlPMZVTUslOw30FI3epd8oNP+TwfQTAlobaydSj6J70nuQHsYkJt1xpjtU0IN2fjUQuzjiEJO3WZrLJYFS6RsyVLbkJSv1VfSC2cF2w6qwHqGAr50smF/Mm/OCZEwbGhA+Rsf0saV/neFyhBbmLpSH36xhGpPxyVXWLE2+Rf+YQ89lDhaUi63DzlRleY+/PzHclihdPtL3McaPpMIhPqTknP+QZUj1Ik6GaRw3moX4sIZWzjFJXqA1kU9RgzCChDt06LFasz+3FEwmbe7pHBQ0oMFARO/Ph0pc8G2TOUSTBBRtNpupCaDJkVYu1Wvj3RnlQ+SarbjQfk7iMhCqU6DcMg1VaMhqGWiY17tOPwHsl/9n7on6N+zv2dgonUcSv0ccVX86kvh5Y8fu33O2MkZCZqSINhrtvN43XEUPzuZKG/0eX75YDPb1MTlcM3SpOiDmLmUUxxXoBh22nUVREHUsnwBJzIlL5KJT2ywdkrwPYepbeq+Tpgx32T9D3e6KigeSD3SaN2fLcY56/vROrc0BwMsdMwYqEqFJQYqHkg9jJkwyR1aAC5T8OgPSOrXPcPZlJFBrGVMVhLEBRULJkgb98eZx0l8N2Sngd2EuCeMPuwwmTgjw/PI7YkF4xk85xMtOmnD+kD6ltgGxJeD+c/yJL
 c4UAnTyM
 0K1kS/eZk09QcDNgrqKgDrITkt7/N9gtldhid7Xhv9xRq6yvihjLoza+9IShGsiQIB2B7wNN+WBxAK5VkhOhc/98ILBSRmX9dUwj1EYg2nPZVZrrMLH7VCUop2Fx30o/VEJoFDJcxxImjR/+Bjdy3Y84OiMJTaWUye3IPD19LDuyBEGA1x7yS/Gzf2CSW/rvsn9KCLsdHBXjeYhMN9NVLDsTolFbtD/g+T1hJ6vb6uuYyxQHibU4YwVAkfqf0KbkcFenOnqsjhWA1nX4J9JIgTnOPEr1E9m6BovzH9CplrRPsCEGfAO20sjVA+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Oct 2026 14:27:32 +0200 Konstantin Khorenko <khorenko@virtuozzo.com> wrote:

> On 10/16/26 02:58, Andrew Morton wrote:
> > On Thu, 15 Oct 2026 13:42:41 +0200 Konstantin Khorenko <khorenko@virtuozzo.com> wrote:
> ...
> >> If you prefer the cache, I'm happy to redo patch 1 that way.
> >> Patch 2 does not care about the unit size.
> > 
> > OK, thanks.  Yes, using a kmem_cache is a simple no-brainer.  Let's get
> > that done first and then let's look at additional optimizations on top
> > as a separate activity.
> 
> OK, no problem. I'll redo patch 1 with a dedicated kmem_cache and send
> it separately.

Great.

> 
> > But a tweak which reduces 145GB of bloat to half of that is lipsticking
> > the pig, and what a pig it is.
> > 
> > Why the heck is memcg allocating so many of these things?  What sort of
> > rip-out/rethink/start-over can we do to reduce this by 99.x%?
> 
> That is what patch 2 does:
>   [PATCH v2 2/2] mm/shrinker: allocate the per-memcg shrinker units on demand
> 
> Today every memcg allocates, on every node, a unit for every 63 shrinker
> ids up to shrinker_nr_max, whether or not it ever has an object on those
> shrinkers. Patch 2 allocates a unit only when the memcg gets a list on that
> shrinker's list_lru, so a memcg pays for the shrinkers it uses, not for
> every superblock on the host.
> 
> In the synthetic test from the cover letter (8000 tmpfs mounts,
> shrinker_nr_max 8064, 2000 empty memcgs, 4 nodes):
> 
>                      units               slab per memcg
>   base               1011518 x 1024 B    548 KB
>   + patch 1          1023787 x  512 B    289 KB
>   + patches 1-2          136 x  512 B     42 KB

OK.

> Size: it would replace patch 2 with two patches. The first turns the
> array into an xarray, with the units still allocated up front, and
> removes struct shrinker_info and the expand path. The second allocates
> the units on demand, without the lock and the expand handling patch 2
> needs now. Together I expect about the size of patch 2 today, around
> 170 changed lines, mostly in mm/shrinker.c, with fewer lines in total
> than now.

That sounds like a good plan.

> Which way would you prefer: patch 2 as it is, or the xarray version in
> its place? Or something else?

The xarray approach sounds more complex?  If so I'd say only do that if
it's justified for some reason.


