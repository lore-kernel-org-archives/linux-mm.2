Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A14D2606A333
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 00:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aGuAXDAP
Received: by kanga.kvack.org (Postfix)
	id A6B2B6B071D; Thu, 19 Nov 2026 19:49:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1CBB6B0722; Thu, 19 Nov 2026 19:49:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959576B0723; Thu, 19 Nov 2026 19:49:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 731166B071D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:49:45 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF03B40C67
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:49:44 +0000 (UTC)
X-FDA: 85453664688.22.30E2F19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6428E20003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:49:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aGuAXDAP;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795135783;
	b=DcMk0Oe5po5EhnjQIaedXvhzY7cqlFieWkR70Pd6sdGo7V4ZREoQLSabdwF0hM+M+IWwlC
	2YNppdsq8pZ7KVoxn/QaCIvTNLmYJII+kYEFrJrt7FHOr5KLH7xqpS4jfstErExugj4DkF
	LYziYFQ4tMkmd/+aSA6+BolcJ7Acngs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795135783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkS1ralUzvuQKKu8b7gkCgxda4Hz1Nq+3pjzMQUco7M=;
	b=PWizUxGAV/FRDRamO1rJNBHP+Eg/K8nJR95ursnSN9fjOeBs7vNtu1R6ZZK5jHVQq9Awi5
	dMUDR4XdcXkMYGkJjgCY0wr2RPbyoqQ6iwCcGuhDzMv++yuRjLVFlEObiLICPdEP0+Ehd9
	tgjPIGNJBDdm5G+p9hZ3HAwO4zLIQZw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aGuAXDAP;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5768843B06;
	Fri, 20 Nov 2026 00:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0085E1F000C4;
	Fri, 20 Nov 2026 00:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795135782;
	bh=xkS1ralUzvuQKKu8b7gkCgxda4Hz1Nq+3pjzMQUco7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aGuAXDAPUStqYD3A3YZkgo8Xe+lSt4wKwYW/DoY5jQoiLKq7jxiFcW8Td0wS3NJKo
	 KlmlaawvS8x4FEZPRxDdfubLGqbYs6JuMyL9x6KZAdpufm8muhmxICpxPatvB1MH38
	 r7o1H8ONwOx2c25JYrs6RvdvYjZZiSqZi2hVQRqoaXgyKPi5Ozdi6BeVtYIxIYcaPA
	 4xrZIOGC90t6yGHHiz5LEc6NDi4IWBep4rHc26G2gJPHgVSZtZEhEAXMXhkKzGxEk0
	 SbXR33DJqWt1TVFyy9Cr5UJ55rhBDE7NAqHidr+syqqkvgKQlOK/bKHzjBD43cF52F
	 np5huzxb3BYcg==
From: SJ Park <sj@kernel.org>
To: Yifan Feng <evanfengff@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: fix damos_walk() hang with zero watermarks interval
Date: Thu, 19 Nov 2026 16:49:34 -0800
Message-ID: <20261120004935.86433-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120001300.11809-1-evanfengff@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: gsud9eb91o974nyxw5fnpofud993jbjm
X-Rspamd-Queue-Id: 6428E20003
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795135783-295556
X-HE-Meta: U2FsdGVkX1/LpjWmmSg/o2aaExz6W7La9NtEeITOx4KQmRBQGBMddFI77aG1eOs2POOMUSbGVqV0en9MkgdayhuV2qdg0AvaVjoTA7Sd/ZpIDS9OtRuqXzCTfkXj3e5qg8mM3GpY+uIZGJJnOfU5xMoWmlA6ki2s4EPdqEXsm1asmqnQyqFFfxrbjGGALN1Tk+Wi6j8ASw92fY837sRZGYP71HXzmM9T2K+6RXnnKfy6NONUDy4O6RfrzMGtluGbgyckZvpGUtGWA6S8YzRF+lTpDZGjijj8eilFlEcu0GjQUeOyzTlHNuS1xyeDHmHAUvCzmbqyd1UfEHYrukiNvLTFD/LENQzzqXx/v+aN2sXtneejakvg6xhBscZ/XLHGdC/mGk6ZPjNc/GdNqQbOj/8XHi1WfwWPbqYewKsKTr1BC/egOluyg04ZEsrneXfcefVBxpGQ7fc7ZFmpsVD2+5Q0j5OmkkZWEBb2WbReBKOf0asw4sY+ggtjmaFFG3nsr1zXhdLy4uBckoYiNzDZzJSH9hBP5ZilSTrBu9VHqyvA2tQs0EStKqtq1/mitBMa0jpaB0qKz/fWmjiYwxhUqGyyA1438GCKDvcqP7TolsFeXpfk5C5HFm8cYtdD7kV/mFRDDVBpsHK7+6qaV3Isj1pzti0CdoYwaEG9w/gHCLdsE3Jiw78uSCH+ypPTgqPZAzVZ8AdYnkbOtRj0r0b1802Y7HpQVzLM4Q8yVwUe28KiD8o6aPfn/ZCest3esOHacKTIBm83JRmrFzy0a4RZffcQXfX2VCtcNr06hF+IcmFgLEp7EgWKrOIVAB0Pr5p2EIg1kqh+SOmex815a6SSCwWED9xMRMA5fSjClFYd8bJ5X45plvdX3XrRW62YfpK/uUilClZiGePOyIP1r/2hFkfcCbRBOmhBtypXS4nc/+UID4GSsRp5UZbf/Ek3RdQznsE0gasGi7nONliG0/D
 pdo01OES
 Wkrn/jqrCpV8CHCyoo+2Moi7JwMiOBT8vTAeJyDFkMTf8TMfrAi/4uf5EQ1IewOHJOp8kvMdoXEzI0JCwupwFxnInHMP5Dya1oZWZNKPeRKqo1V5KuiOr/pS5r0Mk0QYrM6AVBzezLqR0dYhMxWr+Lfm8SGSvJTlaK6QZAx21zZ97JLxgEZuFygHpr2CeGdw/5EA8e4+gCDmhCPzhZCLzdqxL8CwcRgEKg6uCaK12BKNtriK6qybJVUj+SkNxUmpnNMNpZK0xpMB96awzBUAOErGICSkiWESp2EF+Nxl+R9DeIfH6F7hsYy6N5oVkJb7qjWS3ESLGRyx3KuRl/BAlVMziyxIlvBqAr2Twpz7+WRQdeQv4HwkTAuxxNUhnLiOj3Yie85Cq85xVDCO5uuaXvntKiNLhOrgzXugZcXb5UIydjGale3d4Z6FtpoezzIp0a12BbIYGqvrolC1cb2MywPEzmZRlT+FyR0yRYD9di8paQ4KruWkwZGhIP7ruxSuPfrQ2q3sDdnL4YoUYO57PZvqMJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 19 Nov 2026 16:13:00 -0800 Yifan Feng <evanfengff@gmail.com> wrote:

> On Wed, 18 Nov 2026 17:42:46 -0800 SJ Park <sj@kernel.org> wrote:
> 
> [...]
> > But, this could make has_schemes_to_apply has false positive.  How about
> > calling damos_Walk_cancel() when has_schemes_to_apply is false, like below?
> 
> Thanks for the review.  You are right about the false positive.
> 
> I tried your change.  It fixes the hang, but has_schemes_to_apply is also
> false whenever no scheme has reached its next_apply_sis yet, so it cancels
> the walks of activated schemes too.  In my test (one stat scheme, default
> intervals) 18 of 20 update_schemes_tried_regions writes got -ECANCELED,
> and two selftests fail: sysfs_update_schemes_tried_regions_wss_estimation.py
> and sysfs_update_schemes_tried_regions_hang.py.

You're right.  Thanks for further testing and sharing the results.

> 
> What do you think about cancelling only when no scheme is activated?
> 
> '''
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3492,9 +3492,13 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
>  	struct damon_target *t;
>  	struct damos *s;
>  	bool has_schemes_to_apply = false;
> +	bool has_activated_schemes = false;
>  	unsigned long max_region_sz;
>  
>  	damon_for_each_scheme(s, c) {
> +		if (s->wmarks.activated)
> +			has_activated_schemes = true;
> +
>  		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
>  			continue;
>  
> @@ -3506,8 +3510,12 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
>  		damos_adjust_quota(c, s);
>  	}
>  
> -	if (!has_schemes_to_apply)
> +	if (!has_schemes_to_apply) {
> +		/* The walk cannot be completed while no scheme is activated */
> +		if (!has_activated_schemes)
> +			damos_walk_cancel(c);
>  		return;
> +	}
>  
>  	max_region_sz = damon_region_sz_limit(c);
>  	mutex_lock(&c->walk_control_lock);
> '''

Looks good to me.

> 
> With this the hang is gone, 20 of 20 writes succeed while the scheme is
> activated, and kunit and selftests results are the same as on the base
> kernel.
> 
> I will send v2 with this if you are ok with it.

Yes, I'm ok with it.  Please wait ~1 day before posting the v2, so that others
can also add comments if they have.


Thanks,
SJ

[...]

