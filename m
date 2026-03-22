Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4830CD58CA3
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 20:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47C2C6B0005; Sun, 22 Mar 2026 16:51:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42D6D6B0088; Sun, 22 Mar 2026 16:51:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3437D6B0089; Sun, 22 Mar 2026 16:51:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2444A6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:51:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABBD716088D
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 20:51:42 +0000 (UTC)
X-FDA: 84574895244.24.12358E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id EFBA8180006
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 20:51:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bw63tztB;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774212701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7FORrgqCWX2VgOnpglD2ly2yaAL99qWdZaK05nZUIQk=;
	b=D4YKO+wkpgA+oiT29lA4qPkFBGSA8EtXphoCW7NTs/2Bd2ASJiOBzJFgH/3OmTT393GW1w
	BVsd9v4BfmunCqfkJDPKLOEFKfk4zuXGMixyH3ffu/YfL1ptk/IE9c8Njq+2vGiZwE/k3E
	G1mizsXdUr4BDLdXVnbh/cthhEJ63kk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bw63tztB;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774212701; a=rsa-sha256;
	cv=none;
	b=3xQJ1PzFs3XxoyvKUmjDaqjdxWCeRyMOSE26QuY/GwpSE/IbzlmJjD1nEOaVb5mWELPO2F
	JXe2o8DuXq2bpKxnUcoONsoWH94L5nswEibEQ9Y2E8FC0jTgCeFlnIqRRNnq2/QlMIEOOu
	xrEeOmKaV/mwDP66WxbX0OUY8c5phHQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5600360008;
	Sun, 22 Mar 2026 20:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93881C19424;
	Sun, 22 Mar 2026 20:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774212699;
	bh=v+JZu3qXNVA/S1bG8WB9r8Oz6NwO0tcGbFSffeOQTzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bw63tztB5mqokQeZ2TQ6TDgQ4i0zunDVLTtd5npDG9dOE6JkAm8NmvH5a3DbIAQtj
	 SzA5CdTcLOxvx+90tqeYn6Kfhak7EOQB7EUPapY2FUo3mtHsnWMsOQrg9xp1Rln9Xf
	 s4NI7tvE8ho66tmEeWrR9Y9/jq2gWDAxyhp+bVH9mROWrdOmUqTRWfZeeM+/yXCN8f
	 ic55MSQlH6BTWwh+UsyYxREouYUYT+6oZEAxURvIWoRxBDZID8R3sv4ezMpAoe4A6i
	 CF/Rp3FLokntfAAFAAr5BHFPN5BCJwOFdBKigTQ6vyb72QNjgu6jq4gEQHRZbnUjbQ
	 3qfs6ZkevBUrQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v4 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Sun, 22 Mar 2026 13:51:24 -0700
Message-ID: <20260322205125.88701-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322174018.83729-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EFBA8180006
X-Stat-Signature: qanpd95beqki7oxe3mzos599fxqrbrgb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774212700-440850
X-HE-Meta: U2FsdGVkX19lcGVWxUYeO0tJDVU6L9i3ujxTY+HGNw4RvdgVXvi24/nFJn9PcGq/Ew8zgWX4Ybxk8i7ndXPFip8hwxdSJIqC2NgNgMU2++X3n1Jk2lZA7yHrOUjsco4dsmVFXE9E9qr6IaOsFXzMU6eq6VpXVQo68dR0g++V71MCjGbXOM4ZVONd7uiQkGoXqbvWfJZoZLYEWYgUSIoWD11qP+qIyBFNVpj+2eDFq1avsaLy5pvL8Oka1q4lctozI2gbMPIo+bIIoHfiig6DmLbnbsg7woefIi/Ocy6bjeGp/QjQ6rMdE8h+/FDtXe3u8X5+wJ4TqHYEoXaTVhK4tuW3CjrikJsnzZPySSGQEjNla1ukXkwKbu6sDyY9cx9OMyqh9iJd2W6IhlwgyyvY6daFP6z2ahnRNCW/lCbaqCqR+am3BhkKBA/BvA6z8K0r2Jr55gwse91I0U3nst7c7XrrEgLh1n+PjEUs4ygPW5LJTwl0xiPyWRaNVtbH1yx5uqVAlskEcWE1UVZOenntvFoX6D/cm/0mwuc4UpmyZiKfTR49OvyzFqEK+lP/0cfwPF7GYKggGsFWVTAuiozTxXRnwEFOqWHrmippyEZ3Xm1pMHZe62YPJ2n89cvSKPzKYV+pMNeglIHZpnFP+Io8fgowbLE9nQERUdwk+fiSN3kHVwoGEAt1b+ssfbU2dZ2Ka4aAZk6mKSxMWQ/buDoyGB1HtVW8fjsPSJ0QJUQbZKFys8WdddlXjU6nzkTAAYLCkInNgu99yHwfxczhWjOsXilFBfvz0dP0aOWyeKDLafV/kjLG1sx2CQv+HhAYw3PXw326WA16DG0Vi1Mnr7C3qmTraGOc1qs+VDnBcIgdF9kdHyRmPl2epxVwx/cFdEiDOuGd797WHlL09ytpk9poK1nXB4wKTYNUlkg9/Tg8PqAz6MpmTAGqt4yKQ88VzBrMeNMlgRDgUN2ajeosI2h
 ZAtpMq4W
 8JSQrlt0g5hxjh/fKKvbRU1fYD5i1wtB9kMYa8Uuxv/z+wKzW9vrB6OotlGQ1LS5g/tNjKNnEs86hZ/OCAOMx6zaWd6pgLPqpnuRECSrTqNcMDdXmwkJF6KgO0qlhljVhc5XIcwN+G+HjD/G8CzNu4raCP0741JTEiAzy7q9XdRaqXg7woOwbhetACeEH16uEuUB+a+DFybKR4vwXHPnp2WEUD22Ea9OzMFixI5wV61bJs77jn3jKyBkqEOfHN8LwqiYCUXkNzobMnF2KbwMrpGg5AFGlq9RUUlAeMzh3pL6x0KFci2rHkbYGk+Nv1vOz8dp08bQSySAzcKHWzaHnIxEzLD7vnNLtt4cpra39NyvxQgYvrnoDfJFJXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 10:40:16 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Sun, 22 Mar 2026 10:06:59 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > Forwarding Sashiko review for doing discussions via mails.
> > 
> > # review url: https://sashiko.dev/#/patchset/20260322155728.81434-2-sj@kernel.org
> > # start of sashiko.dev inline review
> > commit 2a3be2c8b6c327ef72163cd54e6121ef72b9c932
> > Author: SeongJae Park <sj@kernel.org>
> > 
> > mm/damon/core: introduce damon_ctx->paused
> > 
> > DAMON supports only start and stop of the execution. When it is
> > stopped, its internal data that it self-trained goes away. It will be
> > useful if the execution can be paused and resumed with the previous
> > self-trained data.
> > 
> > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > index db6c67e52d2b..0ab2cfa848e6 100644
> > > --- a/mm/damon/core.c
> > > +++ b/mm/damon/core.c
> > 
> > [ ... ]
> > 
> > > @@ -3003,6 +3004,14 @@ static int kdamond_fn(void *data)
> > >  		kdamond_call(ctx, false);
> > >  		if (ctx->maybe_corrupted)
> > >  			break;
> > > +		while (ctx->pause) {
> > > +			damos_walk_cancel(ctx);
> > 
> > Is it safe to repeatedly call damos_walk_cancel() here?
> > 
> > In damos_walk(), the walk_control_lock is dropped after setting
> > ctx->walk_control to check damon_is_running(), which opens a race window.
> > 
> > Concurrently, kdamond_fn() calls damos_walk_cancel(), which reads
> > ctx->walk_control, drops the lock, and completes the old request.
> > 
> > If a new caller invokes damos_walk() and successfully registers a new
> > walk_control, could damos_walk_cancel() resume, reacquire the lock,
> > and unconditionally set ctx->walk_control = NULL, dropping the new
> > request?
> > 
> > This might leave the new caller permanently deadlocked in
> > wait_for_completion().
> 
> Nice catch.  Orthogonal to this patch, though.
> 
> The deadlock could happen in below sequence.
> 
> CPU0                          │CPU1
> ──────────────────────────────┼────────────────────────
> damos_walk()                  │
>  │register request            │
>  │wait completion             │damos_walk_cancel()
>  │                            │ │complete the request
>  ▼wakeup,return               │ │
> damos_walk()                  │ │
>  │register new request        │ │
>  │                            │ │remove the new request
>  │wait completion             │ ▼return
>  ▼  nobody completes it.      │
> 
> Nonetheless, kdamond_fn() is calling damos_walk() already in several places
> including this loop.  This issue hence exists regardless of this patch.  I will
> work on fixing this as a separate hotfix.  Below fix may work.

TL; DR: there is no deadlock in existing code.  I will work on more clean code
or documentation, though.

The scenario that I illustrated above cannot happen, because the second
damos_walk() cannot register its new request before the old request is unset.

The request is unset in three places.  damos_walk_complete(),
damos_walk_cancel(), and damos_walk().  damos_walk_complete() and
damos_walk_cancel() are called from same kdamond thread, so no race between
them exists.

damos_walk() unsets the request, only if !damon_is_running().  damos_walk()
seeing !damon_is_running() means the kdamond is stopped.  It again means there
can be no concurrent damos_walk_cancel() or damos_walk_complete() that works
for same context and started before the damon_is_running() call.

Unless the same context is restarted, hence, there is no chance to race.  Only
DAMON_SYSFS calls damos_walk() and it doesn't restart same context.
DAMON_RECLAIM and DAMON_LRU_SORT do restart same context, but they don't use
damos_walk().  So, there is no deadlock in the existing code (or, no such
deadlock is found so far).

Let's assume there could be damos_walk() call with parallel restart of a DAMON
context, though.  In the case, below deadlock is available.  Seems this is what
Sashiko was trying to say.

0. A DAMON context is stopped.
1-1. CPU0: calls damos_walk() for the stopped context.
1-2. CPU0: damos_walk(): register a new damos_walk() request to the stopped
                         context.
1-3. CPU0: damos_walk(): shows !damon_is_running().
2.   CPU1: Re-start the DAMON context.
3-1. CPU2: Execute kdamond_fn() -> damos_walk_cancel()
3-2. CPU2: damos_walk_cancel(): complete the walk request that registered on
                                step 1-2.
4-1. CPU0: damos_walk(): unset the request.
4-2: CPU0: calls damos_walk() again.
4-3: CPU0: damos_walk() 2: register a new damos_walk() request.
4-4: CPU0: damos_walk() 2: wait for the completion.
5-1. CPU2: damos_walk_cancel(): unset the walk request that registered on step
                                4-3.

Nobody can complete the request that registered on step 4-3.  CPU0 infinitely
wait.

In more graphiscal way, this can be illustrated as below:

CPU0                           │CPU1             │CPU2                                    
───────────────────────────────┼─────────────────┼────────────────────────────────────────
damos_walk()                   │                 │                                        
   │register reqeust           │                 │                                        
   │show !damon_is_running(ctx)│                 │                                        
   │                           │                 │                                        
   │                           │damon_start(ctx) │                                        
   │                           │                 │damos_walk_cancel()                     
   │                           │                 │    complete first damos_walk() request 
   │                           │                 │                                        
   │unset request              │                 │                                        
   ▼return                     │                 │                                        
                               │                 │                                        
damos_walk()                   │                 │                                        
   │register request           │                 │                                        
   │wait completion            │                 │     unset second request               
   ▼                           │                 │                                        

As I mentioned abovely, this cannot happen on existing code, since there is no
code that restarts a terminated DAMON context, and calls damos_walk().  In the
future, there might be such use cases or mistakenly made call sequence, though.

I will work on improving this.  But, as I mentioned before, it is not a blocker
for this patch.


Thanks,
SJ

[...]

