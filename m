Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A62A3F532CE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 04:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2C706B0089; Tue, 24 Mar 2026 00:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03E46B008A; Tue, 24 Mar 2026 00:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41436B008C; Tue, 24 Mar 2026 00:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D847D6B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:07:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B3348E3C7
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:07:26 +0000 (UTC)
X-FDA: 84579622092.17.7239FE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C11F41C000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:07:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uMx6PC1c;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774325244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u5kiKnJAI3N+FWcPm8ldrXj8PlGO00vfxums085D6CI=;
	b=dXVR1cHgdk0/id2OmMcdZlCw5gBQs1MTWWtA5AkcVBoWB6xgDL+cTrXygSdOp+iJQhmW53
	rFAYVbCSOwwuFywbuO6UNz+dNXSKkhRMDx8+VinqtdP+uNQpI7NlZj8dEQqHlGxyz85Dfo
	/o410FlNa+ozHvnC9ElJDr9ySCNkAAU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uMx6PC1c;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774325244; a=rsa-sha256;
	cv=none;
	b=s5jCUHcxpBYA03RX5LX6pgqzr3sPwZRMuWZqabK0016A3pOwdmxztnoIHiiZoizkHoc2Fl
	ueNLXyEaksMyjO6i3DCFLW8NIDR7S6XWEaypoPo3u0kT7pcxPI3+Z2H7dzPyGaz18hnxtt
	eh/NspgKFYzzmvo40WCv8IZGvuPlDCA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4020416CF;
	Tue, 24 Mar 2026 04:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF7EC19424;
	Tue, 24 Mar 2026 04:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774325243;
	bh=WixgUXX1lfvmvG11uU5T6ehB/p6uAs83QpYTsLmE6Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMx6PC1cHdZUo0j0Azh+oLPsTp7fGo0ySi6hOj50uqRG9LHhT79zchZf+Qg2IKRM0
	 Gi4v/h6SLV4t4Rz+bijrU9mUJMIl/PIx6ayOpGs/NGoj/0T7tNdQniCB13S0kSOCpZ
	 A+fY8o39wzb7yGFVwCnBU9BA1IXhreMxlzuoIAYa3fc+vw1vLv+3wS5p0Iv2staq9S
	 jHL/2lYFuWQ3TmJLUxJe5d6IQ5B7ZQ3Qqq8kpNhEXLT6iptq2zwbb3muwIZCz6E+TJ
	 OoB6IA7u36WFRUhZ3ZjpHG8MhSin5Iw06vDon7Yky24gS3mOgWkx0CBG/aDbWSXZYH
	 /tfwlphlxr0Hg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v5 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Mon, 23 Mar 2026 21:07:21 -0700
Message-ID: <20260324040722.57944-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324012801.42930-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C11F41C000C
X-Stat-Signature: ifr71ysdjds77bith3qhjqa6tsfhzt8f
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774325244-680531
X-HE-Meta: U2FsdGVkX1/ai5ghznT9FfvSKBQS4dye+x1m58gMaAiwn4NbBBwPlW8pEO7UfI3wdu7l6HAHwPvNqV7ik7KSc3VjgCrEzWrH6KSoJckEkE7EN8KunsadvpASs6bXcQfH2pHbSirf/JR17Nc5djDQyiWVvxfJpowcSjLPMh6QIAqhqJUXn7OfSlcwzOMnQy3B7mSXRwHeQbieForn0g7Xasv120xxYms1Fhl5Xt7tHP8U3eIU6Z+OCKhHbUwlUT/+pYdSSoPZfr/qsUSORKmzyqOVjpt7aVIhCOGUXlgnWTlgZkIO4UIaOX5SV4yrDDp+/hIXAHnW+vlknNS+3Lq8OG4kisMAINQtNUIw9sEpx1+9xh1RUXJiISHFhgoz4zEfNESFjn3hkNXcvNJUyZOFBlw8tdj55W2q6yq7n5BLevZbT2Ceze6Pal2gKmFuLhFkcsibk8W+K5aVr5P8AyzK/ovUh8UfXBOJC+SQ52ZCJqwKUfocoVcQXJKXQc4APHp8/+r3S4yRwsJSzGmFwMaurVREJfg9rgF8ffGcUfD/pZLO4LWp9dTMbPs+Xuj0x4NKhTys1G+OCjyInme5DAOGAdHathZ6lOHooYJUH/oT3OZS6lxjjFJtyhs8JLviyEoowD7I6IykyJsuWpGaYWDcdWhPzZc5mFWeuQzgjokjIepdK/jy9t3Y2Zc6B7/gt3WNUXg/yk17mWNWyIXjw+3dUp6WVsESpViPfMK9lOlBWWcbxzwYgnD3QQ/eE4LoLeq3+K2woJMsJVKbSjHaxYz8SDhvckW0bmYEnXYGGIzonuccMcmBvymSAoBEaL1Sap+BMUBRbCE+g02f6zWbVZ+4KlJpaR7W0s5n8qiicwsftfVyTCdUfUzHkZogfRfx6ke9A8JTZZ6PUKEkyaQP24l9t1JhxirZrSudK6K2xKoejGdAmbDvrbubOqEmqM8F0nD0oCvcli/Y+vv8dX28OWq
 ijpbDUyw
 Wg33tyDQDx561+fVdHjmY/BdcRqsURYV515v44eIO6Hlrwe7njbfy2eGDv7bIRYLSX1ymw92A6dznuqojGxCgfxpNVnpkV8s0s1SHiWyHDYumHgnlOEOJSo58sNRYeXzkB/UbMM0JGR4tSEDqbviMibyw7ppsEXr2CHbfDR9tpPBgWpCy4q4s2r7aLMCvCJb05ktl4QDXQM3BWQWHqZLC5qhGr3Fe548c/a/Cvy8PNpaN0QA07ZDktvVcRVtzahzcuud1v2/jXT8OhFydFzNbx8rEVUfYe35i0XAPeT/vyev2ZWpGwC++p0Wsj1QyCRujq/o0m9GBeqh0wlo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 18:28:00 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260323231538.84452-2-sj@kernel.org
> # start of sashiko.dev inline review
> commit 011f7b451b6e4a657677ee09eada15a7980e8480
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: introduce damon_ctx->paused
> 
> This commit introduces a pause parameter to the DAMON context, allowing
> the kdamond main loop to be paused and resumed without losing its
> self-trained internal data.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index db6c67e52d2b..0ab2cfa848e6 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> [ ... ]
> > @@ -3003,6 +3004,14 @@ static int kdamond_fn(void *data)
> >  		kdamond_call(ctx, false);
> >  		if (ctx->maybe_corrupted)
> >  			break;
> > +		while (ctx->pause) {
> > +			damos_walk_cancel(ctx);
> > +			kdamond_usleep(ctx->attrs.sample_interval);
> > +			/* allow caller unset pause via damon_call() */
> > +			kdamond_call(ctx, false);
> > +			if (kdamond_need_stop(ctx) || ctx->maybe_corrupted)
> > +				goto done;
> > +		}
> 
> Since this loop is located after ops.prepare_access_checks(), kdamond_usleep(),
> and ops.check_accesses(), does this unconditionally perform a full monitoring
> cycle before honoring the paused state?
> 
> If a context is started with pause set to true, or if pause is enabled while
> waiting in kdamond_wait_activation(), it appears it will still execute one
> complete active sampling cycle. Could this cause unexpected disruption, such
> as clearing PTE accessed bits, when the context is explicitly configured to
> be paused?

Yes, DAMON would behave in the way.  And having one more sampling work doesn't
cause a real issue.

> 
> Additionally, when the context is paused, kdamond_fn remains in this sleep
> loop and skips calling damos_adjust_quota(), which means quota->charged_from
> is frozen.
> 
> If the pause lasts for more than LONG_MAX jiffies (e.g., about 24.8 days on
> a 32-bit system with HZ=1000), will system jiffies wrap past the half-range
> limit of the unsigned long type relative to the frozen timestamp?
> 
> If this wraparound occurs, time_after_eq(jiffies, quota->charged_from +
> interval) would evaluate to false when unpaused. Would this cause the quota
> window to not reset for another 24.8 days, accumulating charged_sz and
> blocking the scheme from being applied?

That's a wild corner case, but I agree it is better to avoid the problematic
case.  I'm still thinking about the good way for that.  Anyway, I will address
this in the next spin.



Thanks,
SJ

[...]

