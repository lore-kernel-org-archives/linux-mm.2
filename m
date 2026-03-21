Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46B6B1094499
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 20:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A90916B0135; Sat, 21 Mar 2026 16:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40EA6B0137; Sat, 21 Mar 2026 16:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97DDF6B0138; Sat, 21 Mar 2026 16:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 85B766B0135
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 16:29:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19147160641
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:29:09 +0000 (UTC)
X-FDA: 84571209618.09.DF46155
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 624E91C000E
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:29:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FouJrfed;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774124947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TWFI5mwFGcswLKcSrOaiTtLDNB8APrYOD8VmqEnHp68=;
	b=4Z4F3Dv2/FqpJingI/XKT3ZoU3yKpO132WfgxpVkjT36kZ/ZfFmXE+wwGz7cSTLQT26xGr
	qfE5VZKdVu3lcPrzfMey9HrhghIKCVG3CB6AeBjDGeupgjEpXo/FX3MJo0qHuAbu1P6m6o
	EiyWkUs7Rnj98EQGBuaGSkJyhrJvgfw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FouJrfed;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774124947; a=rsa-sha256;
	cv=none;
	b=TrLqKNPs3GupgiYzLfuXEUVrfVK9RoI/Bt6G7WvZ6uIXqmX8UdnH5OWbJBKLQCbK8agRRV
	bxKiZUSYtrEWoLO5406rig3HULaQwruxKt6Hi0hjzYOdB+/co4Ynr1xSOPR67jJUS6EB4e
	vH8GtNloMg9Wo/IKfoq2lPiXRXgNqcY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8357B40D59;
	Sat, 21 Mar 2026 20:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3EBC19421;
	Sat, 21 Mar 2026 20:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774124946;
	bh=pRwILIX3KtOIImm5AyQGnriwJEWKQev29KIeh07Ao6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FouJrfed1pwy9nvl1DRzj+ufp45PuWXfDkQimBm/hshPMIm6fgqjbMAriM1WZYe2w
	 JupM2Q2mN6abupwc4p49LDMV3qLvwefIB1ZBXu5GxaBru2PJ11nkzJDFRJgFG1eCDg
	 gvUfze+1Z6X8gmZcvLunMctuI5O/Jvdu6Xzl/bpvxbaPAcq81y+qZxf74L+k8nD5+S
	 fkym5RbEaEmKy7FHH7Z3Nkye8a3pOQv1MpJRrO8+frEajwM3YenGa/vkf4j7COEhyU
	 TBeMHhJdCFedNv37of8mLrGUejCU6y87iC9JmunxKpCjxduK7ScjTjQvtzieKoZeIN
	 E+iW3Os9BEGiQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko) [PATCH 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Sat, 21 Mar 2026 13:28:57 -0700
Message-ID: <20260321202858.98091-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321201205.95756-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 624E91C000E
X-Rspamd-Server: rspam07
X-Stat-Signature: tygo58xhicwg3fq4h3k78iuy33dwr6mr
X-Rspam-User: 
X-HE-Tag: 1774124947-388604
X-HE-Meta: U2FsdGVkX1+ijf2mTwdBtZNpuVULil8PWsbn65k3BAoULXBkTEASaxwgoXgN1ZJhcdNLs2TkUgw8RjD3nsYL6/czIBaKe8zPPixsSUBH9JC3glDTxGEluzZsPKZx+IORVCeKPYgKO2SkOPxlHm7ELv0hPCxIUFfiWPIdoH2nQ54aA7D/ZwJNycblRcLwAkpKEH/U7iKlp71I5TX/HoEw3n0RLayL7F88nSH17mmRS46Oj9qagQlzMHnoIfPsHmjpyz1g1K9RWUBHl1VEikR4gRdOaBeGp9cjiADL+FBRY94vsVcQvQY3YoFN1DC18zK23ZgsDInzcmNZfxK/vc0IDRgLjaDxK9Tcbmdhxw/QO3h9VfjTqn5bvJ0svAaERmli0cLt/pfbOGTXQtgW5rpNffLqBQcthC79SoBZN/rKLtXmJWUMfjnE3pMNLqJmx8t/7qxnC24zpfdSUzqEMU3PBGPiMOeU4/l8qTGr/VETWoJBvlMm9o1Q+KJSF9S1/ILL56k67iV/0dZrjPOhsm4LQ+3uIcdRzrRtc5QvHey8cK8/uNHYr0JFB0SAdA1s8arZfGEEIrsIwZIh687Ra67l0IECgx8bBj15VZyTZpsm2mvQBgFNrMSaR9BAZ2vkdr4IypLt6LaohbBWR8dZ6abUjBjgrILz93c0sotBHsOm8+UFxpC2qFnOGDwqt6TcprLsK7GTaj9lRNwEQdMFfRQvqiGBqwlOEhjtPtnjVC4fd/NZr/V2fEgelM7uwk+BspOehufbVIvRRPSD9EZWPhzOFsel93Jb0w4Y/sVPckBaXavhVO49b5wUfhcccN6JILak2Poj/vu4ItDz5Lo364bHGGcCJDEAsO75Xzr9m0fYdiEjIkE9aqOr71b0TMdHKteQUWJ0MM4v8Rq9vpUnSCbvsCkZl8UaOk8B/hBFSvCCnWKGmMAEmh6XOYzbwJZMvaVzr02M+6sbpuRpeOA5EGS
 Bm6en6eM
 y5fitNhGQGUXTxbMrD/xSsZez2stl+7RmBFsnYrwItajYpET23CxNF2Qmz+kactWZC56iIYT+tvcUg2x8T9NwTH5sgsf46S/x8MKYz38fmmF0O/NF+IVXZQAhASBF1t1VHYQYixQ9sahufPAO6MSYjsXqNgclvQ7RdURma37YW4DUgRWgkllAMEwifYRu5ews+2kFBjYTJVt4fb6YvPLkYM0K5KvEbu8Tac4DJgYugJf9kcqBmZP3AjoPjkZx/ENfG1ZDK2hzLphmY7Zys9Zi3Azf6hJ3yh0bzdgBQNgVHaeNfA6z0myaXMTx+ScOoUF8a/z3fH+Q1k8E17E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: I think this needs a few changes.  That can be a fixup (picked by
Andrew) or respin for v2.

On Sat, 21 Mar 2026 13:12:04 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260321181343.93971-2-sj@kernel.org
> # start of sashiko.dev inline review
> commit b56d17c42c1dc6d883f3a75d785a05ba53b5c35b
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: introduce damon_ctx->paused
> 
> This commit introduces a paused parameter to the DAMON context API.
> It allows users to pause and resume kdamond execution while preserving
> self-trained data. The main loop is updated to perform limited work
> and sleep when the context is paused.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index db6c67e52d2b..ce010009ca13 100644
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
> > +			if (kdamond_need_stop(ctx))
> > +				goto done;
> > +			kdamond_usleep(ctx->attrs.sample_interval);
> 
> This isn't a bug, but polling with kdamond_usleep() using the sample
> interval could cause many wakeups per second even while the context is
> paused. Would it be more efficient to use a waitqueue here to consume
> near-zero CPU until the thread is explicitly woken?

sample internval is 5ms by default and recommended auto-tuning setup makes it
hundreds of milliseconds.  So I don't think such change is required.

> 
> > +			/* allow caller unset pause via damon_call() */
> > +			kdamond_call(ctx, false);
> 
> If a parameter update fails during kdamond_call() and sets
> ctx->maybe_corrupted to true, the loop will continue to run or exit the
> pause loop and proceed to kdamond_apply_schemes() with corrupted
> structures.
> 
> Is it possible to bypass the corruption safeguard here? Should we check
> ctx->maybe_corrupted inside this loop to safely terminate the thread?

Good finding.  I will add that in the next spin.

> 
> > +			damos_walk_cancel(ctx);
> 
> If kdamond_call() processes a request that unpauses the context, this
> will immediately cancel any pending or concurrent damos_walk() requests
> before the loop condition is re-evaluated.
> 
> Could this cause spurious cancellations of walk requests when unpausing
> the context?

As I replied in the previous patch, that can happen and fine.  Users can do the
walk again in the case.  But, now I agree it may better to reduce such spurious
failures if it can be done in a simple way.  And seems it can be.  Just doing
this before the sleep.

> 
> > +		}
> >  		if (!list_empty(&ctx->schemes))
> >  			kdamond_apply_schemes(ctx);
> >  		else
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260321181343.93971-2-sj@kernel.org

So, I think below attaching fixup is needed.  Unless Andrew picks it up
together, I will post v2 tomorrow.


Thanks,
SJ
=== >8 ===
From 9b07cde80e61bb4cc7a559a62465dd0ee6e2b945 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Sat, 21 Mar 2026 13:22:52 -0700
Subject: [PATCH] mm/damon/core: fixup: care corruption and cancel damos_walk()
 immediately

As Sashiko suggested and I agreed.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ce010009ca136..0ab2cfa848e69 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3005,12 +3005,12 @@ static int kdamond_fn(void *data)
 		if (ctx->maybe_corrupted)
 			break;
 		while (ctx->pause) {
-			if (kdamond_need_stop(ctx))
-				goto done;
+			damos_walk_cancel(ctx);
 			kdamond_usleep(ctx->attrs.sample_interval);
 			/* allow caller unset pause via damon_call() */
 			kdamond_call(ctx, false);
-			damos_walk_cancel(ctx);
+			if (kdamond_need_stop(ctx) || ctx->maybe_corrupted)
+				goto done;
 		}
 		if (!list_empty(&ctx->schemes))
 			kdamond_apply_schemes(ctx);
-- 
2.47.3



