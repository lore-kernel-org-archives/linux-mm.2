Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7540810F3DC1
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 00:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CB546B008C; Fri, 27 Mar 2026 20:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97CAC6B0095; Fri, 27 Mar 2026 20:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B94A6B0096; Fri, 27 Mar 2026 20:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8EB6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:51:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB0EB8EB40
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:51:52 +0000 (UTC)
X-FDA: 84593644464.19.7465EB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2E4C32000B
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:51:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EE+0i+EK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774659111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7lTSZIO19+Cb7u/hti84omZBkywuQHdf6aQfckdMbM=;
	b=cCP3h5nPQNX6OU8oY35QZ/lo1KFetYiANl6KbiX8A0dKhMp8wQ3pAziqGr95U86n3n3VZl
	c0pOpjRg/vK1oHAIg3zQwWtzzrNZHGd5OqS1nQSZSJS2Dz6ELdS8asmnQy/aAKX4sEExcY
	wEcdebyg+wwT0uqNaN9S1ZDi/QG9GB4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774659111; a=rsa-sha256;
	cv=none;
	b=y7p1L6NshWD8IxG8tke1RqSg/oBvENS3hi5QEDuPwNJGDGc67k005LChikJi4myfGLNbnv
	ZbjgVCmoMQ8RTngx1duUdB/DEI7X5THiNmeFdmoJnqenzBthIiFF/e0KyDVNtEN6EEFTo/
	myoM0Tjc8DGDhtHDdXLrpoSE6j2GIlQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EE+0i+EK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F58B43ACF;
	Sat, 28 Mar 2026 00:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5851C19423;
	Sat, 28 Mar 2026 00:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774659110;
	bh=pJYyQZiMQ0KPSvyjj3o15XFMXdymXNI8R8k9OQyW7BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EE+0i+EKbV8nAM1Rna0by0it8TnMuHnF+wWs/zCypZDeJe6H6EHXmg/TY7yhBB+J1
	 SF+3XRzpgS6g2Xp9MoYM7Qq9qKBJHYGdFL34L6idTK26zhkSNuwuPI8FWbLa2MlwtR
	 aMeQTLyXem6nTb4z+arXYuwTSx3QOEF8BxVP7++OEs+A8BXkM0JyDyhN+Pu3uvWc2D
	 16ewrDi2BIJIrN5fLwXvqzwpXRrOZ4Iudq/NuSjNKbd+Mf7GNBEKUkZYrc6CK1Fvli
	 IMohZ3miuTSyDTdnaj9mw7jaO2BUIaFcLMxQcexXoiKPnqc3Z2tQ8ZRt+L9+/pA5zO
	 pSCw5YRQqTOUQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH 1/2] mm/damon/core: fix damon_call() vs kdamond_fn() exit race
Date: Fri, 27 Mar 2026 17:51:48 -0700
Message-ID: <20260328005148.7435-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328004307.7244-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2E4C32000B
X-Stat-Signature: ikguy6hkfakb4gg7htem3sw7xqswgiz5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774659110-517340
X-HE-Meta: U2FsdGVkX1+dbP+ft2u65dKTLQaYDyEHMgeCTZ7UPhyrH30F56607v5tCrWp1EWmadA/wPPXBwRr6FmgM6kTk9AHAJYWQpkjBuTHFyzUyGl+wX1joMQFYbsDbezDUJp6pEV5TN4lH77sKrhBvB/ZiDz3pyJTkH4RrMIYnli7SUouKieLgi55mz/XJgcQY1WiTlknAWT/elx6aPQfnpyIhwq97yAh9bDtGy0Xa9ZtMVg+9MbOLKRdo6EoMAQXh5zVfrwGJPi7AHPwOYZ0gy33F8sTuAFV1jYVyNaAfjUwKPsqkALvZYwF/oAatza2Xd2V6gUczcDFj51J0blW/suIImmbEtX7oEHiQKOQXAa7A5F6Vi+dC8r1Zg45Uo1TOxJ6xT0m0UlBXOKwGWdRuVBFuvWoZOvpd9aROWeupE9PQLwJbjIRcR7GPPWqR1y6tg11PDtAb1X0HDHP6zM5Zr60wSoyHzx4FfTt94VDfa7wAB08VPTuvsHUD4SSCqkiUqCAgtGJlSI2rlNk5QrhHvdN50l2HEu1QGPVSdhMEwjjsJjSxD+vAO+3nCUmGH7SgSB5fwEIWJm9A1/vPfiRpRUBZ5S2ZzPe3CfdQg/vbEOwk6Xb1UoARi193FGj3EmktSpzo25Ee41J4xeOm7DStv6fE6mPMDr5tNUgWSJzc3CfUof4EBipGn3aVQzZzjZd3j4bjIeJeRDp8JXoj1eBEIfxTNkJAo69WxZ1vCBP4CHxxzUBAK7T2aTG6dQa9rSI6QmPRkwoVZMdRAATNmFUL1HjZtbns/BrIZHA7MbAJHWcz0+O0jKMP9w/YxcWEZYg1LRuipKLhLjNmRMlE+jwKaK6UY+ODLaFSXtKruuDsadY7YKD83nGrweNEqR+0PejTKwnYQDxdhOxrWCkAwhEinps91EGScXcjSsUatC64GDeDEXRNOStK6HfpcZXw00ny7C5iMfEr78IJYNZEspiTLt
 gfzj+mxH
 KoMjSmARZyjdDwiQLCbBrqq1ocldnsLjA9+9V9YLVo39FAlCnApb3imhqCGmIJIqptLWxUTvB7/dcG/UkWXLHwxUaPJquQv82Gcv8Oa+i/j7590EgdLRV62l/9ZNlp5iRVVTXUoqQSF5Z593vNtAYnP85qy2sUOkyVdDKY5xH5kVXiy7eNnbEzBjo/nkRsWrVGIqiaEr3we+O/MilYjPtROCekb1iXjsGsMDtp90reka6zbOqlFC/JTxLshGWo4ltewjsohvsC1crMREGfniYy7suplfl7lb0qzc4+E/RxPWe4tGkHKYLVTFlv3frwVMys8pklfLtLGO9ouE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 17:43:06 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260327233319.3528-2-sj@kernel.org
> # start of sashiko.dev inline review
> commit 9cf54c95f0c4bda07c5dbaf4019d0d731f6c58fd
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: fix damon_call() vs kdamond_fn() exit race
> 
> This commit introduces a new call_controls_obsolete flag to prevent
> damon_call() from adding requests to a terminating kdamond context.
> It removes the after-registration DAMON context termination check.
> 
> Link: https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index db6c67e52d2b..9bcda2765ac9 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -1629,10 +1604,12 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
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
> >  	if (control->repeat)
> >  		return 0;
> >  	wait_for_completion(&control->completion);
> 
> Can this code trigger a use-after-free on control?
> 
> This appears to be a pre-existing issue that remains unfixed. If
> kdamond_fn() is terminating, it executes kdamond_call(ctx, true). This
> function removes the request, sets it as canceled, and calls kfree(control)
> if control->dealloc_on_cancel is true.
> 
> Since ctx->call_controls_lock is dropped right before the control->repeat
> check:
> 
> CPU1 (kdamond_fn)
> kdamond_call(ctx, true)
>     list_del(&control->list);
>     kfree(control);
> 
> CPU2 (damon_call)
>     mutex_unlock(&ctx->call_controls_lock);
>     if (control->repeat)
> 
> Could kdamond_call() free control before damon_call() evaluates
> control->repeat?

No.  kdamond_call(ctx, true) is called only after call_controls_obsolete is
set, under the call_control_lock.  And damon_call() reads the
call_controls_obsolete just after acquiring the call_control_lock, and return
if it is set.

Hence CPU2 in this scenario cannot execute the mutex_unlock() part after CPU1
entered kdamond_call().

> 
> Furthermore, if memory poisoning causes the freed memory to evaluate
> control->repeat as false, would this proceed to call wait_for_completion()
> on the freed memory and cause wait queue corruption?

So this is also wrong.


Thanks,
SJ

[...]

