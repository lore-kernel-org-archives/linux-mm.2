Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 966141093168
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:15:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A62F6B0005; Thu, 19 Mar 2026 23:15:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0573D6B0421; Thu, 19 Mar 2026 23:15:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAEE66B042E; Thu, 19 Mar 2026 23:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D8E966B0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:15:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A44A48C548
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:15:58 +0000 (UTC)
X-FDA: 84564977196.23.1C07F3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E44A840009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:15:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g/KLyr1V";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773976557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kIOlgTmWs0wQQuAz+SnoRJvMn933HepZE9pUlt+OByE=;
	b=YOsgSXv8gemfBVidR/Wq+y2283PP0Zp43sa3sVSHVt81y0Q8FNHPrdRefmuV9Yc+wmQBzZ
	IoWdywCgsXdcWbjXBRqUXd0P14O7XKDZTZbT7UFDYPMtcLLY3VsUmEPVBveaCchXJTZJbN
	APrVfdDDo1JSkXFLK+jD9VUIyyADhME=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g/KLyr1V";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773976557; a=rsa-sha256;
	cv=none;
	b=wTMsbPXKtStbLlZeqNifvrcyBg7j0hb6pLAcyshJnHCUT7GZbv20R8b5vWWhfC3JJqPvJX
	wZVliD5/qFXUkQEnvVH1GqXFa5ItMBCKeXyoqeXHz4HJkQODRMIdy/zCbuFA6qLuUbP6DZ
	7EkzkyI6sS7oOgFUFguQZnzZmQ5WZGE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BB1443EAC;
	Fri, 20 Mar 2026 03:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD83AC19424;
	Fri, 20 Mar 2026 03:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773976555;
	bh=c5SOlNAOAR6OFkxJkGh3j24Vwi+ZKbz8x5WFx0lPK0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/KLyr1VFAFLErYWLwwlICfRuQ791uyq7AxLA9drqoktor4arUOIvZ+0dFn6IAk6X
	 x0PMfMpb0QCmpIc+tSY4hVXZnvU3J04/cvXBCLAa/FmPc+m1N5LyYErOaBjflkSWqT
	 GZs16IZX8F4qr4tOaopbAZp5SfOBjb+ojG/j/POLjMqxukcedrP0zQ5/1C79+z3XQP
	 e+SpOvu1j1kRpPPy4bna75Jgj+oP8MtqyE1aFcwogUTBVhoqr5N46HIr44NvvekmIy
	 mPaIh+zqNA0GW1CDFujEy0oD+Hqwu0pE6Bn9pwl1hpao1ubT6NAS5nquklapjXl91/
	 dui3NyLhk8f/w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 15 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: avoid use of half-online-committed context
Date: Thu, 19 Mar 2026 20:15:53 -0700
Message-ID: <20260320031553.2479-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319194849.64b0911e2a7a6d8b1c22005a@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E44A840009
X-Stat-Signature: 4qobyj5p3bw7zgd75cjawh93yxw6ob4p
X-Rspam-User: 
X-HE-Tag: 1773976556-111451
X-HE-Meta: U2FsdGVkX1+arLVo7JcHHdGDrPBuGvwIeE1pP/HpcKGUYuBpe1M0UChQYALqYNpus33F+yq3t8ryC2nbwLj6SKzJSN0DW00CAo6YaE8NSMFcRC31XSO5OHmRBCJbmttOUmDODekIm5OjWGK8kujD5XNpYSXvWbZ3daGgLwkLznRiTBRfHn9FMPhdBixwpDIfiho7sc/epLVPTuEVR39Ff+bFhEXhzR6HVzWxPeGsIOA6Y/N4rlYMmytbgAMWurFy5bufMI0Hl1GZbGshMVlfzD9ABD6UaxKm2dMHGCLpo/MpkfWcISMT3RGTP3H0uZBgq3CrKiFCCJijXo2DseDdSIm6zCP+0plM3FVrd8UpAS2BrrlHq5ND33bzUWVSREFuobX/57DtWwXy0SGAZ4wnUxpdTic9EnbupRWIegJqNLI2yL15vyE9xf3hUKK4ECdpwC74qnTjKYG1DYbxi9UpcqIs9fo6KALvpavMdAfmGk6d/AvMI+RUE0rR4R6ntvFqU1BpltbOkEqyQ4qcpmbkR8TR/eAzOpoZK8qSPokhzyTpYVthrdmFAbHpAOHLhy7NoSh0tYWcHVw0DdY9eC7Ob9rulNH8YMOTCVFgE6DC8F/RLYZA21j/qnZqtYn7gyGz39Cukw/llXqb5znP6oMxOAQBoGuEAcc0AGX68tslMsDXLEIz1HC0hCZGOyUsEOvgkXQCFQvuTRbitVDvhlR8kRHXEf0CZawocSh+HjuYqp7tsLC51PX3+DMiVpUu2MZTew9m4Cxdn3BQu+NjvPNlwp4O9vuGHYcPKNBXfWPuGCKib/cGQjgYryzaqIubafGldJlIF0hEfutdbzEeXXBkRlGr/t6/EyD3KcfFpCP0xACyK2v+KKGKx70dYHZ0HiwjsoCcQC79+k4mP5OCKvSQW7Fnfj4a6gII6sztDp+dnIkJ0bq35jwY8RAuOQmlpwsmIakKTZ+F/KiLcnatOZw
 0U97PgJL
 Dt5blCHmn7bCqo7hYqi4YtwBriivdXKk938Cw96d0blejfRocA2Gr+XAZClOS3x6zN5mZbAQ5k7Qcy6h8xNUvaKIGV1vt3YC1Cg79Bw1+lWzNQ6ITuSqMijgv1TrZr8U0MXJjfUcEGnwwmiICGYKusGzecBviEnwy+JJw6UKVmAcluWcx6XU5CBl7ZWF8EJkEq4QmIIiD9ZThniEo0hN8UTM/cZ0bcCxBZjsMHHWLm9zZuTsaKBPyylbAe0usBxkeSe2kz6IKu7w60cxaBQo6yDKRLlW958Es9+cVLPJgsjBzmHE8mWcElHTP9oxTEPZ10pd+K6C/nraHRK7Hus7ieR4AcNfpnfpSsOR6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 19:48:49 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 19 Mar 2026 07:52:17 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > One major usage of damon_call() is online DAMON parameters update.  It
> > is done by calling damon_commit_ctx() inside the damon_call() callback
> > function.  damon_commit_ctx() can fail for two reasons: 1) invalid
> > parameters and 2) internal memory allocation failures.  In case of
> > failures, the damon_ctx that attempted to be updated (commit
> > destination) can be partially updated (or, corrupted from a
> > perspective), and therefore shouldn't be used anymore.  The function
> > only ensures the damon_ctx object can safely deallocated using
> > damon_destroy_ctx().
> > 
> > The API callers are, however, calling damon_commit_ctx() only after
> > asserting the parameters are valid, to avoid damon_commit_ctx() fails
> > due to invalid input parameters.  But it can still theoretically fail if
> > the internal memory allocation fails.  In the case, DAMON may run with
> > the partially updated damon_ctx.  This can result in unexpected
> > behaviors including even NULL pointer dereference in case of
> > damos_commit_dests() failure [1].  Such allocation failure is arguably
> > too small to fail, so the real world impact would be rare.  But, given
> > the bad consequence, this needs to be fixed.
> > 
> > Avoid such partially-committed (maybe-corrupted) damon_ctx use by saving
> > the damon_commit_ctx() failure on the damon_ctx object.  For this,
> > introduce damon_ctx->maybe_corrupted field.  damon_commit_ctx() sets it
> > when it is failed.  kdamond_call() checks if the field is set after each
> > damon_call_control->fn() is executed.  If it is set, ignore remaining
> > callback requests and return.  All kdamond_call() callers including
> > kdamond_fn() also check the maybe_corrupted field right after
> > kdamond_call() invocations.  If the field is set, break the
> > kdamond_fn() main loop so that DAMON sill doesn't use the context that
> > might be corrupted.
> 
> I guess you saw the AI review?
> 	https://sashiko.dev/#/patchset/20260319145218.86197-1-sj%40kernel.org

Yes :)  Pasting it and my reply in line below.  TL; DR: We need a fixup that
attached below.

: > --- a/mm/damon/core.c
: > +++ b/mm/damon/core.c
: > @@ -1252,6 +1252,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
: >  {
: >       int err;
: >
: > +     dst->maybe_corrupted = true;
: >       if (!is_power_of_2(src->min_region_sz))
: >               return -EINVAL;
: 
: Could this prematurely mark the context as corrupted?
: 
: If the power-of-2 validation fails, the function returns -EINVAL without
: modifying dst at all. However, because maybe_corrupted is already set to
: true, wouldn't the kdamond thread assume its state is corrupted and
: unconditionally shut down?
: 
: Should the flag be set immediately prior to the first mutating operation
: like damon_commit_schemes() instead?

Good suggestion.  But marking it as corrupted here doesn't make something
really bad.  Meanwhile, ksensKeep being aware of what function here is really
making change to the struct will make it complicated to maintain in long term.
I'd prefer keeping the code as is for the simplicity.

: 
: [ ... ]
: 
: > @@ -2678,6 +2680,8 @@ static void kdamond_call(struct damon_ctx *ctx, bool cancel)
: >                       complete(&control->completion);
: >               else if (control->canceled && control->dealloc_on_cancel)
: >                       kfree(control);
: > +             if (ctx->maybe_corrupted)
: > +                     break;
: >       }
: 
: Does this early break cause a deadlock during cancellation?
: 
: When damon_commit_ctx() fails, it sets ctx->maybe_corrupted = true.
: This corruption triggers an exit from the main loop in kdamond_fn() to the
: done: label, which invokes kdamond_call(ctx, true) to cancel and complete
: all remaining pending callbacks.
: 
: However, inside kdamond_call(), this loop now unconditionally checks
: if (ctx->maybe_corrupted) break; at the end of each iteration. Because
: the flag is true, won't the loop process exactly one callback and then
: break, leaving the rest of the callbacks in ctx->call_controls unprocessed?
: 
: If the worker thread then exits, wouldn't any callers waiting on
: wait_for_completion(&control->completion) for those remaining callbacks
: hang indefinitely?
: 
: Would it make sense to bypass this break condition when cancel is true?

Good catch!  Andrew, could you please add below attaching fixup?


Thanks,
SJ

[...]
=== >8 ===
From cafd5152c6d42e4153c54569b44b249e27939ad6 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Thu, 19 Mar 2026 20:09:27 -0700
Subject: [PATCH] mm/damon/core: let kdamond_call() with cancel regardless of
 maybe_corrupted

Otherwise, damon_call() callers could indefinitely wait [1].

[1] https://sashiko.dev/#/patchset/20260319145218.86197-1-sj%40kernel.org

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 37454e8c9c510..3e1890d64d067 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2680,7 +2680,7 @@ static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 			complete(&control->completion);
 		else if (control->canceled && control->dealloc_on_cancel)
 			kfree(control);
-		if (ctx->maybe_corrupted)
+		if (!cancel && ctx->maybe_corrupted)
 			break;
 	}
 
-- 
2.47.3


