Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0FFA10A62D2
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 13:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F7686B0005; Thu, 26 Mar 2026 09:51:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A8956B0088; Thu, 26 Mar 2026 09:51:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE3F6B0089; Thu, 26 Mar 2026 09:51:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 270506B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:51:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC00EE109E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:51:55 +0000 (UTC)
X-FDA: 84588352590.08.767FEA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3C618100015
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:51:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=paK2t53d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774533114; a=rsa-sha256;
	cv=none;
	b=RIm3UZKbRRF8stILLYUnSHgLbaHpATMd1T4C311LaJiMznk6Ivgvw7i4MXvoIOqmaL2wHA
	Cq5G2CpzHPbWtjOhCaDjAZSWTJipijt0EnAdt5O/E7OGF8q6E1z33/+tdWNsYZ5lxRe/PR
	p9vVMrvn7cgBJRTKyJgQlzJFgwpSNEo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=paK2t53d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774533114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GKLqa3TJ4/ULXsSe7w4gbyFnqTfI6ApKJ1shEd7M3pU=;
	b=eXS6UXhoCh0EKxK6a2+LZTl53T18+brl9Yx1pBiVjvv+oUvBwZVWslCR9j/dQOfqB+isRQ
	ZbFhku7v7nt087ZefHvZc1u7CA2WhMIm2KKyhOMCWCdnKI6tDDkurOPDMTmmPWC4/WMkKz
	Zkz55HHfFTnwvG2jmDeKPtU2KqUL4zc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B456960053;
	Thu, 26 Mar 2026 13:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5048DC116C6;
	Thu, 26 Mar 2026 13:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774533113;
	bh=1KHahd11zjguvDsCZzGR0L8yXI0OCjg5sN+45sTqLVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=paK2t53dHROwCP0aPc3ZYmUcs/U0tmfJ5YGPVFG42cdFYBIuHVx0mT3yOll/7NTCl
	 MjG5HF3q1q1tIv5RyKQYUOwQvf4xZ9e2dg2B4ZO2pAshgEj9uTJlgN1JT4R+dBuP5u
	 Sj6ldaiRhaVHOEXK/Ki9TdNQD489wTOsUaTR91xmqwbzgFzsQwNldWXWbk9Kh7WrOx
	 /Rm+qvVUEaZZkTUkjfJA9urR4N6g/HEtaMeeqOd84UxM24b7MKV1dSQi75iCZHCogw
	 pvYXuRUOuC0b9iYEHXfR9+c9BPMqLx3HswttmWgOMHliLkXZJ9w8sI32ZWNXQYCBwY
	 VV9TGQOP5pygQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH 2/2] mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock
Date: Thu, 26 Mar 2026 06:51:46 -0700
Message-ID: <20260326135146.90670-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326134330.90521-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j47t6gjmtk4ogtoqa4repmsazxtsxqgd
X-Rspamd-Queue-Id: 3C618100015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774533114-329998
X-HE-Meta: U2FsdGVkX18Yl6RJf5oVkyxJDomuoOsfmRL6iGHLkAwQQLnhvLJRkBdxhzS/CL+jZdQ9KE5xi7iXFrBmAm0VhwOlJjruHzrJP8bEPhaVaajOMtSdQKrK2wll6u2m73fQLE5dar++R1QezwUXt/W5XUIB+yA3zGdneqfctLNk2amGa/FtF99Caru6gHAyfvF3dXiJDYJ9y0XDAJHtncamqN1buFcOkVxyRT2RFQ7/rbH/rr1hZEBpRcHJPZm27Kj0SHihADqRR72g8C3V/rCoE+xbmmp08WRJzekgwEx8nCwmlV3GZjtdeH0zJy683w3vVyA7HbEJAZy+rVP3OalJHAf3H7lBSKuU2YCE5uajLitBZsbFCakN75SZZjEK6TVIDhGoVUT9wkTNGeHN2lY0ySxZdyXFj1YxgHtOLYiwS8gvFgbRXJV85JPDjabGrhJuWm25BGi7dPoFH9Gmc48NAm4Ovv4OcTnb4zQ5vZ7v7BJ4kTFeBUU34/unvSUtZWLnzMAdIzGLcU0msy3JIDw5+sD+/9+L0qDrBzoUEinPnZAFtnrRdS8+uDtGn6+cvvFfCpd9jAUbFWDQ4t4DZ36qJex8Dl5juk5qr07Nin0Kiz5FNLX0l1iriCeljgfPQv6Mp9NKFYME/a83Qlv/z5bB+zrKMah5bE6uqQxgn5U6SheHeRTWA9465sb89xm6fHEuqFrhL33733UNhO4nvnIWNoUm+AbDH3UMjFdm31qGR68BoGLJjIKG1SKxKt3vflar421uJGSYCugLxOuKIHEOMf+p4lx/fJ4Vp18uYx2g1hPfqtNM7Vg/S6UuiSTLN0mFRz0vLh3X7mz+8HTIy6uD3LWtAN2Htkq3JjnevgyQOl3fWUy8PXfWoDd2Pq8JRGuvi91Jn/dfSbpp7r5GUAzwBKWD0WJdyNJBYKyGU6HkPDb9vYFLZq2Tk5+btaCcQC/+QRXYKuXXWVxel2bC9eW
 hQGBGQ8u
 N3AXcMdP20n4zcWEOpvBC/6X0QfJpg2PMF8c+XviMr5senQaHVd3JYsKwTLquQH3IgwXolv553kGW3pn8/ePM9R2kNtulEIDb2ceWMA6bDHOQQKbc7fOfOY59QiKO9Hm2pqK9Ok8yqpyX80MvnRGE+uTm1GHOI51dD5wO/bo17QHMQbKR2JlXvPN4QIYbBxmnNO4mmidYxR9MFejhd4NlRYwoOOjxLzLLcbuzpkem7Z1n4YDmu0O/iuiEvEFKNCSngouQRDpezm5F1+ALdiRB3bDQKXJcF9I1jsq6kR34bRu4vqINycSbDsdtvn/OvEHa/TO17Tds9hdo4gs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 06:43:29 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260326062347.88569-3-sj@kernel.org
> # start of sashiko.dev inline review
> commit b886bf00a72b1462f29533c91c431cd2ba3fa3a6
> Author: SeongJae Park <sj@kernel.org>
> mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock
> 
> This commit introduces a call_controls_obsolete flag to protect damon_call()
> from racing with the kdamond termination sequence. This replaces the previous
> after-registration damon_is_running() check.
> 
> Link: https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index db6c67e52d2b8..a2b553e2c5a81 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> [ ... ]
> > @@ -1629,10 +1600,12 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
> >  	INIT_LIST_HEAD(&control->list);
> >  
> >  	mutex_lock(&ctx->call_controls_lock);
> > +	if (ctx->call_controls_obsolete) {
> > +		mutex_unlock(&ctx->call_controls_lock);
> > +		return -ECANCELED;
> > +	}
> >  	list_add_tail(&control->list, &ctx->call_controls);
> >  	mutex_unlock(&ctx->call_controls_lock);
> > -	if (!damon_is_running(ctx))
> > -		return damon_call_handle_inactive_ctx(ctx, control);
> 
> Does this removal cause an indefinite wait if damon_call() is invoked on an
> unstarted context?
> 
> For a newly allocated damon_ctx, call_controls_obsolete is zero-initialized
> to false. Without the damon_is_running() check, if a caller invokes
> damon_call() before damon_start(), it appears the request will be queued and
> block on wait_for_completion() indefinitely since no kdamond thread is
> running to handle or cancel it.

Yes.  But it is clearly wrong usage of this function.  I will add a comment
clarifying this, e.g., "this function shouldn't be called for unstarted DAMON
context.  In the case, it could be indefinitely sleep."

> 
> >  	if (control->repeat)
> >  		return 0;
> >  	wait_for_completion(&control->completion);
> [ ... ]
> > @@ -3062,6 +3038,9 @@ static int kdamond_fn(void *data)
> >  	damon_destroy_targets(ctx);
> >  
> >  	kfree(ctx->regions_score_histogram);
> > +	mutex_lock(&ctx->call_controls_lock);
> > +	ctx->call_controls_obsolete = true;
> > +	mutex_unlock(&ctx->call_controls_lock);
> >  	kdamond_call(ctx, true);
> >  	damos_walk_cancel(ctx);
> 
> Can this sequence also cause a spurious -ECANCELED failure when a context is
> restarted?
> 
> When restarting a context, kdamond_fn() signals kdamond_started before
> calling kdamond_init_ctx():
> 
>         complete(&ctx->kdamond_started);
>         kdamond_init_ctx(ctx);
> 
> If damon_start() unblocks and immediately invokes damon_call(), couldn't it
> observe the stale call_controls_obsolete == true from the previous run and
> return -ECANCELED, since kdamond_init_ctx() has not yet reset the flag?

Good catch, I will do the call_controls_obsolete unset before the complete()
call.

> 
> Also, is damos_walk() vulnerable to the same termination race being fixed
> here for damon_call()?
> 
> In kdamond_fn(), damos_walk_cancel() processes cancellations before
> ctx->kdamond is set to NULL. If damos_walk() is called during this window,
> it checks damon_is_running() (which still returns true), sets the walk
> control, and blocks on wait_for_completion().
> 
> Since cancellations are already processed, will it wait indefinitely?

Yes.  I'm working on it for another patch.


Thanks,
SJ

[...]

