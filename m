Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 971111075269
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 01:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EABC76B0088; Tue, 24 Mar 2026 21:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5CB66B0089; Tue, 24 Mar 2026 21:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D63286B008A; Tue, 24 Mar 2026 21:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0D776B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:17:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 40D431A0636
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:17:04 +0000 (UTC)
X-FDA: 84582821568.02.92C4F3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 92CE340005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:17:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HDebcREA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774401422; a=rsa-sha256;
	cv=none;
	b=Y7wAh9On3AYpTckSMD79/G60u1z0zDZKbu4lLZMQL1fpX8mtNSmrgtUfCJr2qODl3oEAfm
	+ohm7dxCkHg9aKPqFT901nzqTATaTrPl8v6R5eI2EK/Ihnc0LjOzTbUMZb5MkR0lKQTIg8
	wW8lvlZzSNu8PEdRbrMgk7Pf2w02UqQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HDebcREA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774401422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=03B0rml+cB29N+qWQ2mM+0XMhuqXGxDqpi6OBTff/X8=;
	b=CPM1ysEfUlMRS0kGJPFBmbiJmkljoNfD+ncyJNz7HTqh/7igkTAL6F+7msrfcOuzS8LP5g
	TvPEt+U5+ZcU7Fhat0GFGO/ur+X6YU6vvleHHCPE4pPzMs0elOVxPMaKqJej0roM08RNbF
	3aDBiQfP3NK4+7tQQkEsRo04BxZi9W4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F0CC9600AC;
	Wed, 25 Mar 2026 01:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD2CC19424;
	Wed, 25 Mar 2026 01:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774401421;
	bh=nbpn1HlNS+cTXXOL5D8pJ35n5ChNxTXKV92YCz9TAoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDebcREAm/zGVG4vNA/rTt/xIPC1Jn6idgfjKVKuop5NLhgbCt/C+Vu+dz2smYnGM
	 nCJnd4KBuiHOsNY2ugsIlopjvgIEdwcYdPzi4RYgF5tx82MO+TF6VzKORgv8INEYn3
	 eUkWkIAm1X9845uVt/Yay+0AKqdT9ClNfMXuQxIKpumvRa+QU/Hr1wc/O4J+HD34De
	 sWarPv8f6bXsBY/BWzAi1mTWH0uY5XcZe8nw/KK3uAQp3rcCAsQO6Set1cI7z05M73
	 Y+Tdb8PqNDLYsjllOr5GnL1DZTQk7eO6n8xifCDk8xMqjx+7qXQ+lfvqA+ibyAmwpd
	 7Lgg9nETqZvrw==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: (sashiko review) [PATCH] mm/damon/core: eliminate hot-path integer division in damon_max_nr_accesses()
Date: Tue, 24 Mar 2026 18:16:52 -0700
Message-ID: <20260325011653.85502-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324154005.83651-1-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bp7ps3x8u757zu1ytb919od38yod9q3p
X-Rspamd-Queue-Id: 92CE340005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774401422-908215
X-HE-Meta: U2FsdGVkX189ba77/7JUXafY+LBgOOzIgBBqjmoVwsFpkNpZmusOMSYjCD26eRJJUvxv9X0TRAohJaQT/q4ULfZ26jD9B297ERbSwmqbE5qT6zlpF3HDTyRkk3grqXKo+hgR5UI6gMZi4FYVnuQDSuO1RGlU/rbHnKglf1VIu7mMAstJ1IoAFNmptyuM9/lVvojbJMPazWoFG4AbKEs+QL9Q/WbF9/Kn4KDSNeGbCi6rbJIl8YtEYXPEsZMOfKaYd4ZTeRM1eMPjOnxESfT20qdWAnKIVa+tT8bevi5lZ1N5zDK7S/8amav5h/le8rHP2fqa8TitHKrSUXJ5YYIKz04PQv1oX4+XRONmgXdrC3sQL/aisncrY1O7y4b4XjUBolWfywP3jxXOElx2UdRsdB+/gv+NUAKsa3Sufssp4f1ite3B2tkedAoYRAOnrOF5D1n/e3or6Z3e1AijBFjnp9XXybV7OfMwBBPQnPZ1izDpl7WManDtEOywSwV27kTQ5RaRtGPido0mi4z0D5IOWlNbuApqlwHqly3sWMSytPpBMrovyChhN1kQtN4mKFX6IFCIBBkeFR4XjUlYUPNdoK6+reOuIdYwBaID0iL0+Mf0z+WMHxDch9nqjUJKmnzPjiJi6piLyvMTbBIcpayBOpG6vViyc0IqIyl8Po8gXuBwjE/cgQWHcoHSuk6AEfK0k/ni3QLu+zDkSEZloMAMO7sksQo90xURt06Wa+s6xCeiwsv6yhzrT+CDawqzv0qg+BNKnd/OCKKvpJa8lJlExu4FyMIpLUtwTq8qcB77NRtV0P6fFPjIg9IwsNXDozkVIZxIyZ3FphcVxdgZL4nr0aIptEYpimNSxZfIalDmZ6DPY6Xj7+51MwYenqe3ydHe3pCI9p6LgynOOn3naf6hmhqjUAEqXhVmWFu0sZDiXt0afI+6NdEL5nybILA8U7uh5214Kyv2on2AxLUS2ZJ
 zdfPpWUm
 037A9mm+6JwOcJtp41wv1SDHAhLAGEudlpbKTbt+2rOlHA3ANk54foZ6++vl09I13oKnhtYM3f4rgUQmb3C35LrAKDoOUuWol4mlMfWTCaQfiqDxBxCSAcbzks1BBjtPADx1EU2QxGQxj/1hX+KX4D6X/4KmOyXXAfy1himG2/xq8pE6ciEOP4jy44g+FHM8yb69BWeI6JBPaYVTm2apikMnojkSCredoIAt2bsJ6g5LmzCo+d0WCc9QEqrs2S8gZDrio5NjvE5BADVP4b8hy/wT1aIi4aTSUT4L80nV+XVcs9iFHp05F+3zxyXsuvXx3OlyVqnJwF1mcb2NiRvK664wNKc6FG6JIyLrSUbcotuD0ZgpGCc8Hs82+6ZwnjB0Bp9aEkMqHiTKOKes=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260324154005.83651-1-objecting@objecting.org
# start of sashiko.dev inline review
commit ff5e227a18cd69435749b0aae0dc2c762c4f0a47
Author: Josh Law <objecting@objecting.org>

mm/damon/core: eliminate hot-path integer division in damon_max_nr_accesses()
    
Hardware integer division is slow. The function damon_max_nr_accesses(),
which is called very frequently, performs an integer division.
However, the struct damon_attrs already caches this exact ratio in the
internal field aggr_samples. We can eliminate the hardware division in
the hot path by simply returning aggr_samples.

> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index d9a3babbafc1..04c8a052fcfb 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -978,8 +978,7 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
>  static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
>  {
>  	/* {aggr,sample}_interval are unsigned long, hence could overflow */
> -	return min(attrs->aggr_interval / attrs->sample_interval,
> -			(unsigned long)UINT_MAX);
> +	return min_t(unsigned long, attrs->aggr_samples, UINT_MAX);
>  }

If an administrator dynamically updates aggr_interval via sysfs and commits
the inputs, will attrs->aggr_samples be correctly recalculated?

If aggr_samples becomes stale, kdamond_fn() will compute the real aggregation
loop count and allow r->nr_accesses to increment up to the new bounds (for
example, 80 loops). Meanwhile, damon_max_nr_accesses() will return the
stale aggr_samples cache (for example, 20).

When evaluating schemes, damon_hot_score() normalizes r->nr_accesses against
this stale maximum, producing a freq_subscore that severely exceeds
DAMON_MAX_SUBSCORE. This causes the calculated hotness to exceed
DAMOS_MAX_SCORE.

For DAMOS_PAGEOUT actions used by damon_reclaim, damon_cold_score() returns
DAMOS_MAX_SCORE - hotness, yielding a highly negative score.

Could this negative score cause an out-of-bounds write on the
kernel heap when used as an array index?

mm/damon/core.c:damos_walk() {
    ...
    c->regions_score_histogram[score] += damon_sz_region(r);
    ...
}

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index db6c67e52d2b..afb058f7da5c 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -587,6 +587,7 @@ struct damon_ctx *damon_new_ctx(void)
>  	ctx->attrs.sample_interval = 5 * 1000;
>  	ctx->attrs.aggr_interval = 100 * 1000;
>  	ctx->attrs.ops_update_interval = 60 * 1000 * 1000;
> +	ctx->attrs.aggr_samples = 20;

Since this value is cached here, but not updated when intervals change, does
it remain permanently stale during dynamic updates?


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260324154005.83651-1-objecting@objecting.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260324154005.83651-1-objecting@objecting.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

