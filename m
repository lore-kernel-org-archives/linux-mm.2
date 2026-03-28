Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA2B710F3DEC
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 17:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 175426B008C; Sat, 28 Mar 2026 13:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14CA56B0095; Sat, 28 Mar 2026 13:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 089C86B0099; Sat, 28 Mar 2026 13:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EBC4B6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:03:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1B1954EC0
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:03:25 +0000 (UTC)
X-FDA: 84596092770.12.7DC592F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 148B540016
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:03:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YLKbqTlU;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YLKbqTlU;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774717404; a=rsa-sha256;
	cv=none;
	b=hV0IIPAzhv9hEn0A+NxsvyjQFu0o7sDkhLtcRvMy6C6FoEuTXxl1abzxQaaPgs2hfVOqLQ
	/OZQhaIQzqKlJPFk8iX1NrzY+jMbz4gKpdOtfFxEziEaD1duuvn5YM8UHwmNWvP/WjZ5eT
	IvUmEyi19M9nEmGPagEVvL3VSEDbLEM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774717404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2fYiWJHvryL//zD9zpITBlB+rls7YIL9e2CVU6nEuy8=;
	b=H5L+d2H4CzmG9qznusZjb9foFhM3zHjdNcsUdIB8KGhyCTB655PsFIwW4ksNoXAdrnbKrC
	/OyICcTEOXP0sf6VCAHPw+oJfajJehTfBcmeLIjE/56AXGsbVAxQEf22u/tTbDgdo4o510
	sYsZ7JiWJnTcyL4gqadgIWuGxr0gv1U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5382D60018;
	Sat, 28 Mar 2026 17:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BBDC4CEF7;
	Sat, 28 Mar 2026 17:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774717402;
	bh=Xib3LmBk+cvkQ71h/XBToCzox4WC/I5GEE+W0GLBvag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLKbqTlUiEIfPSLrLbDmry7Ju7Qr4sAg0DG1Tvb5SxxdYt9lh3pqVwUKCaWeGvWNq
	 mS88ZoRJgGz1LICYjIJ1N2gpwU5syglw76yA+qErf8zngGv5NLKjCAxcBO3PdU0Xi1
	 l/cG+nADFoA9BNGm4ZXfSvaP8YdSAV9SIvSZ51/fJO7yyQq6ryAmqhgt6eWLrcqa2v
	 vLvci7U50uALn1JP+JwYfzv1zOzFp0JRPxgUSXuyUszPgNFn8a17g4v5YlA+ujRP9g
	 xglV3RkBI+ns5CixXMLbMbnBHm6Gn2fpi2OlSYI/+jDDtjD0E+7pRpe4nIp8lJsAtT
	 WqGF/OKsucx6w==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 5 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH] mm/damon/core: use time_in_range() for damos quota window start
Date: Sat, 28 Mar 2026 10:03:21 -0700
Message-ID: <20260328170321.48340-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328170008.48144-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 148B540016
X-Stat-Signature: b4q5173ct78imy4zy75dn6yc79t8gj99
X-Rspam-User: 
X-HE-Tag: 1774717403-961389
X-HE-Meta: U2FsdGVkX1/MgVwYj/9SJxl0+HPU7J9ZHz36mFhjWUCr8Q2c9gjrn1pByux5xR5cSeGVwZSb9csjp0g5a9+ZvSxKWABWfhnNRx3dLtb0RnWPGOG3P4bFERQvuevw5ErqcXNcHuY+ti+c9OOohlVKstDlcrSrRQZf74le7CuoBj7GHGwYC3aDw6aEgXVwl+xthyMTd9GIQ/AZGmX5f6kc/VK+YdeJYWKdAQ5oaQZKd8r2b3/pVISzOuOaQsJVn9VKWRDKSXcVN7QPCyNaU/SVhxL3qlBGrkpNhtif+U9XiglmG42uFUFT/ibu3zBEyRk9R0z7Zw+Xxx9O9Oj30r+we4ZKYj1Z0k/m0OhM6QleQhZnCdpL/+stYjKEXNUXJscyN8rUIbcf3P48lbP3oITRWlxZXWzuBMizb61Reoct9ljDL9RJ0r1vaNUYRlUoWRSc7m6UUyx/j/P+JXUOon8C7VbWKoPulHaSm7ISOsU4SMt0IAC1XweZSidI6aem1JOYbfRGHATTxgTkLl6rLMu4aFAmBmz3EeGU1ZEbSMBQKYbgM4eh7kjBxqFRmMdTvpnuVH5C5XgsCXQWr0bbr046k8iDC7bjs7Ji0VcyblDBZ7iPuF2yswbXp7RiC4mcMr7r1ttRzd+tfDecndH9htR7r4E6rTqasgLQFlJ21B8/sDJteIAFmYiqpqR6MHjqTyNNDZ9yVS7gA49aStX4pLq0UF16+qbqFccA29+MrEu58d/IWfNTjoM62eS9Ny2lhJ7izIHWYZui2EJs/ZmOnLlqK94/m16+jpskzAlQbQMUNolmqvcvzhc/HZBWKGdvbIsoi98dJta7+iIITGoGGcP3/8cKu6ub1Wt9i0qkZbbpxApCvhGRL0uPnH/PnY9Vdg9CKd4Q0z8IiGpzaHin3RV0zYFGApPi6yW+BbFK37nPx0kzw8GKiNMLcKwBQMI94aP22NsqoOdRtxRzbBQBqhK
 k/0QzSfm
 d7oB5qWy548eU75gvEBhPqBVik1ABEfT4HLq9HXAOdhtBUnPKgHXX58lSaHFU8Niczzk5XVmxYwTt6CL9AIWzEN+aR/g4dGEVrvwyG4K6Ho6xCeO+XK6zrLRW5kiKjJFGpPGylrJYpetauBEoo64RpWVyBFbxixP4KmcaiQfFzGx2zivKd4TKDdrcJhUZvEd8yfIvGEb/OLNROR3lDlFGZ2wVk+nmvhEPH6WXDFX4OfjZ+v6Hhqp9DjpeLbRcGQxqLDR4RH4Cb+kf9cuRq5Mgno30cTJDNdKFVkrVPa2I8UUkA0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 28 Mar 2026 10:00:08 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260328163930.47096-1-sj@kernel.org
> # start of sashiko.dev inline review
> commit 2ee07f5a4fcf25b39aeac61c6b88fe3fdfd0c9b6
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: use time_in_range() for damos quota window start
> 
> This commit attempts to fix a stall in DAMOS quota charge windows when
> a scheme is deactivated for more than LONG_MAX jiffies. It replaces
> time_after_eq() with !time_in_range() to properly handle the extended
> time wrap-around.
> 
> Link: https://lore.kernel.org/20260324040722.57944-1-sj@kernel.org
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index db6c67e52d2b..8e47183473d3 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2452,7 +2452,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
> >  	}
> >  
> >  	/* New charge window starts */
> > -	if (time_after_eq(jiffies, quota->charged_from +
> > +	if (!time_in_range(jiffies, quota->charged_from, quota->charged_from +
> >  				msecs_to_jiffies(quota->reset_interval))) {
> 
> Does this introduce an off-by-one regression that extends every quota charge
> window by 1 jiffy?
> 
> time_in_range(a, b, c) evaluates the inclusive interval [b, c], which means
> it returns true when jiffies exactly equals the end of the interval. The
> original code used time_after_eq(), which correctly triggered the new
> charge window exactly on that jiffy.
> 
> By replacing it with !time_in_range(), the reset evaluates to false on that
> exact jiffy and is delayed until the next jiffy. For small reset_interval
> configurations or low CONFIG_HZ values, this 1-jiffy delay might alter the
> effective quota replenishment rate.

The effect should be negligible, but good finding.

> 
> Would using !time_in_range_open() preserve the exact original timing
> semantics while still fixing the wrap-around stall issue?

Good suggestion, I will do so in the next revision.


Thanks,
SJ

[...]

