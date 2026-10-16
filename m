Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81DC3CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 01:04:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C3726B0095; Thu, 15 Oct 2026 21:04:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4747B6B0096; Thu, 15 Oct 2026 21:04:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389DE6B0098; Thu, 15 Oct 2026 21:04:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1551C6B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:04:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B0C2A8025C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:58:39 +0000 (UTC)
X-FDA: 85326679158.14.A9966AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E0079C0007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:58:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qOQ0xc88;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792112318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RR9cRtj6rZdpMcx+AFWBtWQ0JWEoIVZNsQZgVJ+kILs=;
	b=maENIc+g7SSYiIWCrTfPoFKwAFUP7s+DP3rWfNJ3/kgt0wBZN5qFNdFHH1tZIY+4Zs9JEI
	UmURDdl+jgeMfZl3IxBBms4kg5Rj248Y/QJV9ffI6O12UlUY6/O0Rl3jx1c8v7vWGnJgI2
	fOmX/7AZ2IHn5CDVEhGaOTzLrUb99Ww=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qOQ0xc88;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792112318;
	b=ckZoe3gYyk6g6aysMECqJW5c82H15hMFajKKJeQ5gxGjzMI05SQZTc+tZj8J30B+Qqq1K/
	Il0sdNenB/5eTeA4ZGysVf81m0IjpRPii+PjyKZe3u+/xjB4y+ljGmWC0EIeaFL04SQ0xK
	56s0P5Gm14LYCcgrrX9P/3PZYhIx6xM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1245D43A69;
	Fri, 16 Oct 2026 00:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AD91F000C5;
	Fri, 16 Oct 2026 00:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792112317;
	bh=RR9cRtj6rZdpMcx+AFWBtWQ0JWEoIVZNsQZgVJ+kILs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=qOQ0xc88WAvVTVuFgMaEAQ4Cjt9md/ms0MfJDRpYnr5r73g3RpNIyk0jyBKWZgL9i
	 xUCUMTH7D3y5m3khh+N4yesBHRGDrpHJhGHeyhhNVo74YmuoJVz1zZKkAv3+ysBmyB
	 xrdT7eIaEE1jvD9MYvuwPWdOnH4xpDBnWBWDOhYw=
Date: Thu, 15 Oct 2026 17:58:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Roman
 Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/shrinker: make per-memcg shrinker units
 cheaper
Message-Id: <20261015175836.efc93cf9de01306402da61f9@linux-foundation.org>
In-Reply-To: <84c9e97b-67c0-4c9b-bb7d-81811af8a16b@virtuozzo.com>
References: <20261014-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v2-0-51af2aedbe6c@virtuozzo.com>
	<20261014135046.7b13252ce99d918ffcdb1f49@linux-foundation.org>
	<84c9e97b-67c0-4c9b-bb7d-81811af8a16b@virtuozzo.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E0079C0007
X-Rspam-User: 
X-Stat-Signature: hi8pa3wfc73wykzn11e3ikbx6y8zb6g6
X-HE-Tag: 1792112317-516185
X-HE-Meta: U2FsdGVkX1+mzIQlFsSyEfb62RgNfQagz6S6+1HHgcY5wqDZk/qKflar6UyzXUdbUanI+jXJaaCI5BaZkLN9gpm3hbLw822okYpRjsOmz5eAryShdfVBz7swkUrZqVThcUitiSP3cq0W6ikI1zkftcDVBNO4Am3r3izkjIxeJpbHicLNvEP1Q3II7j4fEo6woQLI0g/huy7NcL18P6yxJ5wbCQ6oPett62Egz+Mlwp/327jsVR8UeMC5OKgeIcwkup11UJKINTPz9N2DSPTtnzpvATZMoS+u00Jc+bUcxhR+R78a1TzaK4halZEa13COlef7WbibWC3/ebP72ga4DeiTT4tElURRFDQOEUFTfAWrOqsIV/bRfHyjal3FVDC+oILZWQ1uFLWIOLDbYHogpFDCmT/cDgtNNh8MnP2NyTv6KhrHmyNA1iUyzqFahVnIci3r5ts3KgHGFXMMKwLWWN01NYC3FxsRk6bpqR3F87hIPx8RI1BwZ6mv3ZwAhbXOhsuYryP7PwkzHzD/AEWwZNS6DE72nLKyWKguYnHB9hOEGfJ+orydJ9M16pf6TXLrzpziTjAthZkc/bf8NY7gMVkQKEvlw1pwpM5o0R/l9s0dpmXh0TDut+trBDvua4kFq3k6tCq5/ycQumeYq3Cibx4wMUXSIMvLHYbeed1bg4RV3j4HXIylnscMPdOw/+VwmEf6Es4BCp9suKQtI0AR1wYdaJfOkVUYet79W4xO/SyYpiAvj691nZ2wgB0VYeZBM93FbubFlkXqKfafbZVV5bXd1sDcK8Zoe4kJFEixXu0xhx7iX1copz1dtlnmoeKlWb1EvjNQd08bqoMx96OSr/32B+bQ77d0a9h/yWOBamz5oLxRTc4VExY8hivHYSIPLe3mRUvKy+i1Frt3Hfnq35Ed5HICz5YBTpHigqtaFZo4hR8D4BTVUoNZNZtA7etwK12bISTyBVu6ALe/++2
 1bNrVpaK
 yFw8Lzm+OuXTyn8NcPMDwSC4QfO+fbSkspDWqYcadhSeH5C6QmFGuO/ZErq5UhgpvZr9IFYW+ZSL+PeMj/JpMBROQq7+Z1jv98bT9CvOQVqVkCzfs2qZnR7bsRoNjee9IKyHgnSHAe3CA4M9tvLHYvkAvVjQY5DQnZ33i/MM8c6JblKGB4604ze3ab7sXrTyHRg7Zc8yY4KnBxiXgvtCji1tEAV27OgWa+0MiREC8Akh9bRJIVL5/RDIxk2i+CWV5EV03BvLp1m2qvhLZpTx7wT7kXcwn19YaKzF9auSfdq74J03M/XACfUO7Tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 13:42:41 +0200 Konstantin Khorenko <khorenko@virtuozzo.com> wrote:

> On 10/14/26 22:50, Andrew Morton wrote:
> > On Wed, 14 Oct 2026 16:54:36 +0200 Konstantin Khorenko <khorenko@virtuozzo.com> wrote:
> > 
> >> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
> >> per 64 memcg-aware shrinker ids up to shrinker_nr_max, whether or not it
> >> ever charges an object to those shrinkers. Every superblock registers
> >> such a shrinker, so the cost is
> >>
> >>   memory cgroups x NUMA nodes x shrinker_nr_max / 64 x 1 KiB
> >>
> >> because the unit is 520 bytes and comes from kmalloc-1k.
> > 
> > So we could almost halve this just by using a dedicated kmem_cache?
> 
> Yeap, a dedicated cache gets approximately the same cost per shrinker id.
> On a 48-CPU box SLUB puts 31 units in an order-2 slab, about 528 bytes each:
> 
>                                       ids/unit  bytes/unit  bytes/id
>     today, kmalloc-1k                    64        1024        16
>     patch 1, kmalloc-512                 63         512       ~8.1
>     dedicated cache                      64        ~528       ~8.3
>     dedicated cache, HWCACHE_ALIGN       64         576        9
> 
> So the two are ~equal on memory, and the choice is about the code.
> 
> I went with 63 ids per unit because the unit then simply fills the
> kmalloc slot it already comes from.
> 
> The price is an odd SHRINKER_UNIT_BITS and roundup() instead of round_up(),
> plus the static_assert.
> 
> If you prefer the cache, I'm happy to redo patch 1 that way.
> Patch 2 does not care about the unit size.

OK, thanks.  Yes, using a kmem_cache is a simple no-brainer.  Let's get
that done first and then let's look at additional optimizations on top
as a separate activity.

But a tweak which reduces 145GB of bloat to half of that is lipsticking
the pig, and what a pig it is.

Why the heck is memcg allocating so many of these things?  What sort of
rip-out/rethink/start-over can we do to reduce this by 99.x%?

