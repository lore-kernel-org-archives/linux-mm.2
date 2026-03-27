Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAC6E10AB838
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 01:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580756B009E; Thu, 26 Mar 2026 21:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5314A6B009F; Thu, 26 Mar 2026 21:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446DB6B00A0; Thu, 26 Mar 2026 21:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 345D86B009E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:22:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C245C1B9628
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:22:21 +0000 (UTC)
X-FDA: 84590092482.03.D325D5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0B2BD140002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:22:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=imXgyYWA;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774574540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GF0kT8/W1qCd4rF54n5VqHjIF59NYhAWsR+NLmCDrlo=;
	b=Yi3L5Hz00iHKI9wQ+YoSqdFSPeRo7Q6n1OhiGkYa9astSefwY2R9g0EKIAcG4NRbKwsDJ1
	oV/TVSHRek9dlSesKK3FwnOfn+bkEf/aKrGbnU7kM7WQVq+GThxBZvRvgahw8BT141vx/H
	GwcTVjWTDomR18IH53KCUzPfYiJeQVw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=imXgyYWA;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774574540; a=rsa-sha256;
	cv=none;
	b=wy8tacDClqcsf01czfcYKKX+4iB06nZjS1l1c8RjFuizVT9w+WqivuvYGWYqFwV1c4QK4p
	hVc/vys+XGhEQvftlJJVAVsnxEMjN7j7AdzxXg52R8eZN4SPVXhZ30iQimFW+r8OmLO4Bo
	bPzpbzjVBGl6owF6ullmpdyQQjV/C8k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 10C9440DD5;
	Fri, 27 Mar 2026 01:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26E8C116C6;
	Fri, 27 Mar 2026 01:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774574538;
	bh=ptJUWvPNGK94YQ89lMNnnFafMWg0AR2vxZSfEMXpOEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imXgyYWAGdQqTNjfLLfY4Sl3qrRvkUWanFtm6ASO9QlyWBBVezX0L4R24t6kFmFGf
	 dbsByDHFA6Vn6zEHEce4qDI62K8Y+KFHA/I5RmgfRf7b9go/yD2tx9cJsrTADYMW5Q
	 R/5BFPqFfV+qxERxs/K/qqtzgH9KOlJcpQhJ9xaTP5SWf1Z49bM45U4ANY7WEunKZq
	 7JJ/1jLFIR/a8YWRRicXhTVKFyyf2wj8N3/+0IpXTox8iBQDOc43+1SAGzbrvXlgX6
	 MxwvubmeQl7eAK6ygDUO6fWO0E/g/I6yTXLCMQQYYBD9ZZQsuFddeeApf5QXo4yYXU
	 c4Rg73WDrzmmw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH] mm/damon/sysfs: dealloc repeat_call_control if damon_call() fails
Date: Thu, 26 Mar 2026 18:22:16 -0700
Message-ID: <20260327012217.66272-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327011747.66127-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wr3yo1rnaskupcz18ogi9sry853mnwfe
X-Rspamd-Queue-Id: 0B2BD140002
X-Rspamd-Server: rspam09
X-HE-Tag: 1774574539-258257
X-HE-Meta: U2FsdGVkX184E4zNOuU5O4+w4hter9p0qG465DGHnNedgJq7z4yQJAmc/x/3UkF1GiQR9iAggBrWkN/dVPbakAgYRSOFOzscnwh6NmU8JL286Qi8GL+j1tADjIQtgIGxcTa4ueqwc50sPt9hOYD1YIreAGJsykA2Au7n7wbpX2Zw/HBXHIrG72kc5To8oEZIO7N3m1TyC+9vgyoDZnv7KlCAXtvmPQvt2KcFwSQAVTNds9irNHg1nXzJLb4ETnvBtJft/sPJn6FuNUfuJAhYUl7TfIzbUrxDYZwCS/vElYsS2JIek0DlKEEOH2wQxFf7dkelMHp0gJde98P4YZb154sKKCs98Dj/pvCv5Y1fzOQtsjy7/dsi2DZ9vPFhn/u42MRGGjTduSs7zce1rgPihIGVS81Orw2crFF+gi8+N7hRncG1mNfFoh5sS9XKVpYe2F9PkADMsP8QckJzAdL/tUlYOYEdvU553pkWVmPjEsH/Ogv+Ho853+ybHW2uTBjqCLYmZpqWlFknh1G6LlkThhszOp3AagQr95nfyeA+XNjPwdZl8DeJ6I5HdiYJdFtZg9pdafG840yDZxq4ZVBFrMIJ1gHujy1RcGYiBIObYRtyy7J4A0VCQBwWMR5EX7yrkR6gHdJJFRNNdQi5bJO4HS3WpomKi3pPsiujZqXvn2VbOng5wiL1oFfUyK1c64kbor15u76b7XNcvlGviAQp+cqpjOR+gZryzAMcn+cvK+V463G9TBo6JmlM9yjBV6njZYbKl6R/ro1Kykj2PE3SxAOoivIKoNUpzDWDu5n0d43T4THMfUBSrb3o9GJMZc9MnZKcBxDNz5pJhbXzQeQyIYUv5SUs26g4nWxBAN6PY81A2HG74Fk943MUzaVbEe9I3ajyeR3lSGxanYMLI5mjZW+TZ2lLkzOXAx1Jl1CxAEUkwkbPQJri0ZGlggcqS1Ax5bu+pRsLILalaP1f72w
 QG2vwDEU
 RUMhmCAje0uzxqh9fGQgtJKW471p/F/UujNjCJEVnkmC3FQ5XKGfwbiHlpWCu7qJrpoX9XlMYIkxQqN96ijlgl5/AKcxFFnv2Hy5vS1KCLTC/fPy/inZAVbjMt2Ba7DO9LJ9IbM3Ge+OfgAn5ELDrDMGmUb+hLJ4uduG+nCtSVjAXpQMMDZ8AYAuuSQ4nyyIe3vHcUxzrJSEIwX6+5Y0u+BFvwuHueyKJ86vf8oubti6ehSSi2KBBD0Vgwc/QSqo9krfLc4l4woKoqb28Fx6287OwPV2jKiinqwJpVTNiAXikoGAF5r7R3lGZ3MM1ycqTF5HSqg4kdt/DD58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: nice finding but orthogonal to this patch.

On Thu, 26 Mar 2026 18:17:47 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260327003224.55752-1-sj@kernel.org
> # start of sashiko.dev inline review
> commit aba7f94d0accfda5ab9b573157f691de9e9acf00
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/sysfs: dealloc repeat_call_control if damon_call() fails
> 
> This commit attempts to fix a memory leak where repeat_call_control is
> not deallocated if damon_call() fails because the kdamond stopped before
> the invocation. It adds a check to free repeat_call_control when
> damon_call() returns an error.
> 
> Link: https://lore.kernel.org/20260320020630.962-1-sj@kernel.org
> 
> > diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> > index 6a44a2f3d8fc..eefa959aa30a 100644
> > --- a/mm/damon/sysfs.c
> > +++ b/mm/damon/sysfs.c
> > @@ -1670,7 +1670,8 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
> >  	repeat_call_control->data = kdamond;
> >  	repeat_call_control->repeat = true;
> >  	repeat_call_control->dealloc_on_cancel = true;
> > -	damon_call(ctx, repeat_call_control);
> > +	if (damon_call(ctx, repeat_call_control))
> > +		kfree(repeat_call_control);
> 
> Does this fully resolve the leak of repeat_call_control?
> 
> If a sysfs writer thread calls damon_call() during kdamond shutdown,
> after the worker thread in kdamond_fn() flushes pending controls but
> before it sets ctx->kdamond = NULL:
> 
> kdamond_fn()
>    kdamond_call(ctx, true);
>    ...
>    // Before ctx->kdamond = NULL
> 
> Would damon_call() add the new request to ctx->call_controls and return 0
> since ctx->kdamond is not yet NULL and repeat is true?
> 
> If so, does this leave repeat_call_control in the queue and leaked since
> the worker is already exiting and this check is bypassed?
> 
> Could this same window also cause a deadlock for synchronous commands like
> DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS?
> 
> If a synchronous command with repeat = false is added to the queue during
> this same window, would the caller hang indefinitely on
> wait_for_completion() since the worker thread will never process the queue
> again?

Nice catch, but orthogonal to this patch.

I'm working on fixing the race with a separate patch:
https://lore.kernel.org/20260327004952.58266-1-sj@kernel.org

The patch would fix the two issues at once.

Nonetheless, the seaprate patch was motivated for only the deadlock issue.
Finding of the leak possibility is a good call.


Thanks,
SJ

[...]

