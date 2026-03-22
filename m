Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 997A2FC72C4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 17:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C85716B0005; Sun, 22 Mar 2026 13:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C360A6B0088; Sun, 22 Mar 2026 13:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4C2E6B0089; Sun, 22 Mar 2026 13:40:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A398F6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 13:40:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B0F98C695
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:40:28 +0000 (UTC)
X-FDA: 84574413336.18.3A0B2C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4C151140005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:40:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dQ4Cel6C;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774201226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XhkfnwbWKvHTVeFG8ExD24fInDUSQT7tjPCGLmJl8wY=;
	b=QOAQc70uqU6mMNQsGQF9oJJO8D+kMajs1mhpvLvVi5qEhszty8eRrSc3meHaxkzP8Jqx0/
	c7ocoibWW9QyrMoGEJUQpfH79gUN0t2qYl7ZjMd/D+UpEY2xkpHnefie83pXopSvcV5EGm
	ps8rJZwna0uSPcMhnxofnJ+ihBDXTHA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774201226; a=rsa-sha256;
	cv=none;
	b=wwRgfYUiKfE0mmKoSdNIHbt8lilJGtrOzYrJ3W1KdhBC9+m/irIMqjlHbU6mEdPWOiMq73
	+WQfjx3v1IF6QPpj53g7V9f5kCFOvcwez9/lcnw4si/xGhqxm2MnsCLz/VSordd3VNgcgT
	K6F9yeOuG5E+RTiLEKezzJVCX3JRk3o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dQ4Cel6C;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 426D5440A1;
	Sun, 22 Mar 2026 17:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7A8C19424;
	Sun, 22 Mar 2026 17:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774201225;
	bh=t1kmCjtJgBoqc5PGMnOUBWW1n3gt6R1pJatljm8Xo5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQ4Cel6CZjAb6jCoyMoJdsoWtXwH1HECSI5Fldc6qTvmsclGT0FN1w4Xya6STcLF9
	 vGRco51ydJMZq8iri3WweLfPiKdGfZSE2ZJmr9uWAONMMAM2Wj3aZfUxtd8HqYzbRX
	 6D2dm0Xi8QsRIqgoqNPDiDRpK+MZeELGNV7uKTZ9VR2tPnLmtIlVxuTPzjXKvn1wRE
	 SV8GwCYIpQTrLAu4qdWyQz6uCORu3eRLAI1iqAdXgntxc4D9qLeqqTRi8l4P/tQPik
	 9jCvOAmll1Zzqheby51ACgIBrJg8wBErQ6fuheIywnPDfscMYtXiY4WO5XkpuTfeL5
	 kPciwjYOdThlg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v4 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Sun, 22 Mar 2026 10:40:16 -0700
Message-ID: <20260322174018.83729-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322170700.83123-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C151140005
X-Stat-Signature: s9p1y99ni6b9ocx117yqpztp4w8zc7bk
X-HE-Tag: 1774201226-878671
X-HE-Meta: U2FsdGVkX1/xk+eqMupqoI7MwC+EOhWtiV/vICmzWLsd2+JxAxf020ZZ774EkAiWvbCYTJMApyRXuUi2hmnw+6Uqa3wQlK3UEB924jUtHh4shbr4+/g2rpOf7hFBRR6uTu4C3ujro3S4s6WAC7LlRvCLipc03XizkPBowV+8DC3Ur710is+qWoRI+graafjN9DMrW3MlegwhhSo7RXahQRUf3/mofBiOk19i3D2ooVicevyOyu9n3KiwYCw5KnmPorZE9OR9DPsWcB9du24eokktIaLJsqLLq0G9FtkIrX9p6UULTZQtwOQKcfhNqSJikDq3IB6Xx6uRHJcWqQWb3WWAGaqdljWe8jl8S+YLxuyqvfnnPw4FrE9z5EA6oTXEWKmNB+dNivXme2EhWT4BsxEH3v5QvFAlvFXc7VRYhmHByN9VSfob/xEexnKHj/V308rm9ZG7qyNasXUb6BBygIqATXOBwLsDJ4BoQ9tkHBNUu4k8rSdfJSvbtn5rdtee9Y0F2xEOy3e8vc8fOnn/wltl5Gmf9ZaEqa3Ycl6xlTnN+Rwe/U0wGGzC5qQoc2aArmf7rytIT8XpeJ0vuoUvYHYu/2oWygMWjZFZXpc2K384ct+NTNBrAB/vBLzesUrl4cIs36KTbD5j7ewXFQDB+616wBEbaTLNc1PYESbjzGNgFldA3TFVUDP6n1k4yNhwEO+2N6p2vlClW96Ve9HAMz0hm+VOsBAEhiJQ2qp6KamXvIiuZaISRMxE3z+skG5hNvhcjZdeIa7gxn8c1HacFlqUw/wghUB8ir2OqLp6EMg8LRUi9XsHRn1u7tMpLNAKUaW5+Bp6Vc+NxZKKOCaXFNeg1HeGMl+MKDAJ5hqZ9X3lDRcf2gIruyd/tRXtrcMzkHnQjgAEJ5e9LSZW0s/+5scOQXiak+J+N+Pd4ahY8SXokTv7mQdcw76tjMt3VG9oCqp1Yssufxtve3AVF5R
 WvsmWl2Q
 7xpNG79YzbnKWCazzYAJc0BTX5alx96J9e/zBTUMA1PO0YDN2Q2J6Ntn6Kdq+RJfjrX8ODuOQGASAVRhtt5RpuDtcgocNeI9Bj3O/HirGTKhFjQ954AQjJjaYfpIrNDmAUiStXr1y0Y4DOuuv9XfJ6uTBMG1f0EJDiAhMEjyp8LY7AGhimx/SBWj5wVGlxu/+lAEBPqomuS5oWEvr/AIVI6zKjSk0MAx09RNN2qDj4TxQJiEAp/YLvsrG2AeU223j+7ZIyJedNQiYDDVSAXzDiJyhor/dv9gB55yHTRs6BsvUbnXgFtDU0uzjvKPdSxtZ97fs5SRltj3D7U0yLEqsARKSdFEXGNMnYlIA5dZkrnP4P8Tid96h6G4oaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 10:06:59 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260322155728.81434-2-sj@kernel.org
> # start of sashiko.dev inline review
> commit 2a3be2c8b6c327ef72163cd54e6121ef72b9c932
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: introduce damon_ctx->paused
> 
> DAMON supports only start and stop of the execution. When it is
> stopped, its internal data that it self-trained goes away. It will be
> useful if the execution can be paused and resumed with the previous
> self-trained data.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index db6c67e52d2b..0ab2cfa848e6 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -3003,6 +3004,14 @@ static int kdamond_fn(void *data)
> >  		kdamond_call(ctx, false);
> >  		if (ctx->maybe_corrupted)
> >  			break;
> > +		while (ctx->pause) {
> > +			damos_walk_cancel(ctx);
> 
> Is it safe to repeatedly call damos_walk_cancel() here?
> 
> In damos_walk(), the walk_control_lock is dropped after setting
> ctx->walk_control to check damon_is_running(), which opens a race window.
> 
> Concurrently, kdamond_fn() calls damos_walk_cancel(), which reads
> ctx->walk_control, drops the lock, and completes the old request.
> 
> If a new caller invokes damos_walk() and successfully registers a new
> walk_control, could damos_walk_cancel() resume, reacquire the lock,
> and unconditionally set ctx->walk_control = NULL, dropping the new
> request?
> 
> This might leave the new caller permanently deadlocked in
> wait_for_completion().

Nice catch.  Orthogonal to this patch, though.

The deadlock could happen in below sequence.

CPU0                          │CPU1
──────────────────────────────┼────────────────────────
damos_walk()                  │
 │register request            │
 │wait completion             │damos_walk_cancel()
 │                            │ │complete the request
 ▼wakeup,return               │ │
damos_walk()                  │ │
 │register new request        │ │
 │                            │ │remove the new request
 │wait completion             │ ▼return
 ▼  nobody completes it.      │

Nonetheless, kdamond_fn() is calling damos_walk() already in several places
including this loop.  This issue hence exists regardless of this patch.  I will
work on fixing this as a separate hotfix.  Below fix may work.

'''
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2321,7 +2321,9 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
        control->canceled = true;
        complete(&control->completion);
        mutex_lock(&ctx->walk_control_lock);
-       ctx->walk_control = NULL;
+       /* A new damos_walk() caller could added a new request meanwhile */
+       if (ctx->walk_control == control)
+               ctx->walk_control = NULL;
        mutex_unlock(&ctx->walk_control_lock);
 }
'''


> 
> > +			kdamond_usleep(ctx->attrs.sample_interval);
> 
> Could this result in a busy loop if sample_interval is 0?
> 
> The DAMON API allows attrs.sample_interval to be 0 (for example, when
> tuning is disabled via goal.aggrs == 0).
> 
> If sample_interval is 0, this invokes usleep_range_idle(0, 1), which
> sleeps for at most 1 microsecond using an hrtimer.
> 
> Since the normally expensive monitoring operations are bypassed while
> paused, would this cause the thread to loop almost instantly and create
> an interrupt storm?

This is an intended behavior for users who really impatient.  So this should be
fine.


Thanks,
SJ

[...]

