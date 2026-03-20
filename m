Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A1561098796
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 15:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7A76B0098; Fri, 20 Mar 2026 11:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78B16B0099; Fri, 20 Mar 2026 11:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB50A6B00CB; Fri, 20 Mar 2026 11:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A4E8B6B0098
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:12:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26376C1522
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:12:03 +0000 (UTC)
X-FDA: 84566781726.02.770BACC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 93B7440016
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:12:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z4P7XvUv;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774019521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zSL1gr0YXyAsWIFkP0ihhTye1LIBKyjs/Pd7rWpn/lQ=;
	b=B+Xd2t1N/eXI+04F86gYDrwJoEjtgTJlwXl1gdm6NWvNz+/e+kNc5Y5IY/u9oDeFSVN/P0
	t03rzojJw8+r959aqDCoNkfY4Sfke9mAfdrryMNHhicMkDh+2gULHdOIBqXpJ8eMJIEHVJ
	3lPTQFReb36IX7MS6YFrn3GIy5PQ2TY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774019521; a=rsa-sha256;
	cv=none;
	b=Pa0afHHz26U2jphaYQzTfIBauZWnAvP9un0C5MF6IS64nCL3bxwXq2aa88NmC5xsMHLTlL
	xS6lVVe6wa4nDCr0um9i1Fxy3v7wMXFxr7W8x1baNc9MrtFdg2B8RCOpOPzNqeqjTRy6KJ
	4pkKTh5/LDfN1nxel95nA9eYdgUdXz0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z4P7XvUv;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5CC26012A;
	Fri, 20 Mar 2026 15:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76155C4CEF7;
	Fri, 20 Mar 2026 15:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774019520;
	bh=p2F28LNpMDUeRHCnHa5wYw3eMG12pSgtr/9O++IOtu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4P7XvUv6r0ihfu5+hQzvdKhtfjBHi0cTKN5U+N5iDM9Uy4yI8pi9Bc537HBI/qB2
	 ykmDv7gZiiTaTtJHb26v4XEagCabdkBmiuo3+ECx9Fwlpw2r8wAEhO2mXp/XBSaobQ
	 dqZbIGoKocOI1kc0C51CP+E48xJ8ogBpPjvpAfHzdWHW7+MEYooPESdommOwiA1la+
	 yF4QinKPehif9qf9y8X8DVMOfCTSV6m/o9xwuXTQWPq//1mYmgki7wL/5tY49Fxt9E
	 TRXqn68NvKO2fgkg9J8FjlpWq3ziUgtufnEuNOIfnt66l5FVR0aAhEhiaMUlK3R4do
	 q4oVZdZPxueJw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Fri, 20 Mar 2026 08:11:51 -0700
Message-ID: <20260320151152.99020-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319052157.99433-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 93B7440016
X-Stat-Signature: c8ezffift31riy5y3zfzhx78i4g54kw3
X-HE-Tag: 1774019521-393692
X-HE-Meta: U2FsdGVkX19J2R+N3EBfifQ9i2SC85xH8IDLX2iKLqyX0irRKxy8LQDcwRFcsiCVY9N/UdkyX+oa5QixZDsylk1icj6foJ0K+tatmd7ajne+XUWL3Vi2b0vhKSK/pk3ZZVz3ilGxoMl6lNjX0V9XAJNIqgrMgaOB/gqBNIoapspeuLlGlBeoXkFD45AXPqrvJhoTtvSH9EMOF1SKly3ZZBZCl+xiJIBnwJ7QzDWXB12jI+7JDipIEe/ZLXu7ydsNoLECMetWrFja5tfcsawuc1s6l1ieCJYUV1ptZzUTRA6U9vLuaUTJ+R93BzzlrQX8X/W2QORbz8FcTov6Nb+l95zFlQ4yH1LxylQpBm07/Z91WCqba6u2q5LFhSsy8cqYGw9FdEyGIaS4D3q8uugQkfTwgYt3EA42PlHe/2gdKrCcjAEiM/jFNejOiVyMMCMVxT2oz66LBJjE9SID26RTd9wd7kXU7uOaW2vCuuD7nKvzc/RuiqllKCggnkDba/VXoQ31mPQVQpJVTiz9XRmoN8Pj756/kv5I468dTIa0iiU1SdpiAPmv9Gdhx3tAIe/I3/X/ftAyhRtbf+KkI0DZBQ1bu6OZg7d3zgMEcRXf0rWqBUBQdvOnNCMwHgQfinC1UTLmS7au9G/dKll4SdmTsOrW/rIEs8t/w7rqyEJbZo88RAIEdyMeHh++T6v5qewWKjo+8F8qyuCKPA/iOQyITi0IO7sE63xJUrBFciDnr9GT5FA0iYW6mDuQ0AyqkS0SEuLzP53FDgzjOOLH6t2Ig1Gknts7L4N2NTR9X7h6tQhYptmDCkQgP6c6pvy201Xmp59wFqWFg8JA2lS0ufBbJXFNPGpangRRqGGSJwxY03gYTSGdrBUh5dK616A7u/zxePqtWNiGhaiGPFYpWuqd+NWxILpMbTQ2xbgmc8UahGYdCGL6svukmmDPifHSpqaTipng6jxo4KmbTVzabmd
 uf67t/4A
 nwXt0RWbPASSEk9sVztEgUEZsxVn+VZda6x8vsalX2x2+vEAdMppQQdi1k5y90zbp8VUGLb3Tp5QrKCR2L6PqpKTVKm2+IA1KuIYuadkiIb7rmoKMrNF1NkRhomT2wR8ZUX88s1z/W+d9cjgQI+uyTXoFvXsp1OacU28exjNvFYetegBcUVPVcm9BEVuyEWVP3E8w9kQ/ks2TX5HoZtkl7hZhu/Yaud8V3AHydT78crkjwigS4a13ieN10Hz0aNZvh9WGFpllbtcsQITl9SDi+aM926YBdFJge2hwqCoFEIe4R3TCu568fBw3Ak0TlvkIL8rZTWsSi0GzgoE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 18 Mar 2026 22:21:44 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON supports only start and stop of the execution.  When it is
> stopped, its internal data that it self-trained goes away.  It will be
> useful if the execution can be paused and resumed with the previous
> self-trained data.
> 
> Introduce per-context API parameter, 'paused', for the purpose.  The
> parameter can be set and unset while DAMON is running and paused, using
> the online parameters commit helper functions (damon_commit_ctx() and
> damon_call()).  Once 'paused' is set, the kdamond_fn() main loop does
> only limited works with sampling interval sleep during the works.  The
> limited works include the handling of the online parameters update, so
> that users can unset the 'pause' and resume the execution when they
> want.  It also keep checking DAMON stop conditions and handling of it,
> so that DAMON can be stopped while paused if needed.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/linux/damon.h | 2 ++
>  mm/damon/core.c       | 9 +++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 3a441fbca170d..421e51eff3bd2 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -811,6 +811,8 @@ struct damon_ctx {
>  	 * intervals tuning
>  	 */
>  	unsigned long next_intervals_tune_sis;
> +	/* pause kdamond main loop */
> +	bool pause;
>  	/* for waiting until the execution of the kdamond_fn is started */
>  	struct completion kdamond_started;
>  	/* for scheme quotas prioritization */
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 339325e1096bc..0b6cb63d64d0e 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1331,6 +1331,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
>  		if (err)
>  			return err;
>  	}
> +	dst->pause = src->pause;
>  	dst->ops = src->ops;
>  	dst->addr_unit = src->addr_unit;
>  	dst->min_region_sz = src->min_region_sz;
> @@ -2978,6 +2979,14 @@ static int kdamond_fn(void *data)
>  		 * kdamond_merge_regions() if possible, to reduce overhead
>  		 */
>  		kdamond_call(ctx, false);
> +		while (ctx->pause) {
> +			if (kdamond_need_stop(ctx))
> +				goto done;
> +			kdamond_usleep(ctx->attrs.sample_interval);
> +			/* allow caller unset pause via damon_call() */
> +			kdamond_call(ctx, false);
> +			damos_walk_cancel(ctx);

Sashiko comment
(https://sashiko.dev/#/patchset/20260319052157.99433-2-sj@kernel.org) and my
reply below.

: Can this cause spurious cancellations of DAMOS walk requests if the context
: is unpaused?
: 
: If kdamond_call() processes a commit that sets ctx->pause = false, and a new
: walk request is queued concurrently or immediately after, this unconditional
: call to damos_walk_cancel() will cancel the newly submitted request before
: the loop condition is evaluated again to exit the loop.
: 
: Would it be safer to verify if the context is still paused before cancelling,
: perhaps by checking if (ctx->pause) before calling damos_walk_cancel()?

Yes, it can cause unnecessary cancel of damos_walk() request.  But cancelling a
few more damos_walk() request is no big deal.  The caller and user can show it
is cancelled, and just ask it again.

So, not a problem.


Thanks,
SJ

[...]

