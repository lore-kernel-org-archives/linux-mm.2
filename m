Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E078606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 18:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EckPO1La
Received: by kanga.kvack.org (Postfix)
	id 32FF26B05B0; Sun, 25 Oct 2026 14:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0D46B05B1; Sun, 25 Oct 2026 14:48:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5C96B05B2; Sun, 25 Oct 2026 14:48:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD38C6B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 14:48:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41EF61C1CEE
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:48:55 +0000 (UTC)
X-FDA: 85362035430.06.3042289
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 88C9E100006
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:48:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EckPO1La;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792954133;
	b=IvIGvg++F457SvPG8jzQJ7f1RkEhK9TDADOnYBlANpdj7eq84yzpR2jgwUG581RJZ8AyVe
	v/iovEDTLQtdDsnSMkTjHCpXA+5TRmZ8FzkrvfzlJ8qNVXkKh9K/7GNt0+lheslsyK8Wt/
	IIRCXWrv0qhZ3t0eFstTCC1WXpp2PRg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EckPO1La;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792954133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pznFzyD5BxdTzOagRh9mbfazQSSMPDVThvsWbVF1d2o=;
	b=Ipr2LV6deqfg86eunpLGxhKAk84L2GCpJWe7PjMVYUsctIiRXZY8Ab8GQ2sE10uY1l1ozd
	Yyuka0nizeD0oGtgTSFWHoGNdCua/WsPmOOzIJCJaK2guMg2snymZDm2ec1wg8ffcLDldB
	m8DcZWATBMmwaCvVR5ce91sX8gslfmE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87E464076F;
	Sun, 25 Oct 2026 18:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440141F01825;
	Sun, 25 Oct 2026 18:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792954132;
	bh=pznFzyD5BxdTzOagRh9mbfazQSSMPDVThvsWbVF1d2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EckPO1LaGYCz5T1lsTmZB4ujCWnoneGjVwZa4Fzod0L6bvuhXJfas33aw9cVtrB5Y
	 HDzedltEPbA3IhM3selq/hdYJt+dJ+mWyKfTya3s6u4xcbBHPoZUuO47Op5IRkRYKu
	 kX58KeQNFraZQTfKmfTgSF2twEAdzTL1WCWoMJgs/flJjDcN+lAyPt8duadT8Zkz6/
	 Nb8ePXKPhdnZ+GJ9qZ01vyAMgiotG8PGKIskZ3U8uGn9WsO3I1H/a7Dv30JRp7uwbH
	 tIIrnVXxu858Jte3vz4qDIB/NkYan8V5lOM/IZqcf1jXeWe6/umWffMz/FjiAnNs/z
	 kGPSjjEujF6uw==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 6.12.y] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Sun, 25 Oct 2026 11:48:43 -0700
Message-ID: <20261025184845.190103-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-184343@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: na5zom6jr9qmnfcpdziqox5t8rfes8gn
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 88C9E100006
X-Rspam-User: 
X-HE-Tag: 1792954133-185030
X-HE-Meta: U2FsdGVkX18nWj6IYD8dGRAyAdOlPP/jW19W7TKdA9j7sZNeHTZyBjqiIauC61HLfYah4UFX5Wu1674Ps5mPfIuB5Cbh/mlgXMMSImZFOJQWG9yDB3uTbBoTF5WSQ5vsXQWRJVqVg6IquycsJghq6i2gOG5YnTxf5r4OhngW5hbLmkkmKeQhkzv/iI8I9KxnRXgg/1lXacz/cUewsrwGvCMXl2ka8TdfmkRpPD9Sc4VVc0SZIqszXi+h5RbF86teV+ck3PXUD5X+qlWJTscb3AMpUK9ZYKcYqwlgtlRhbe21TQy9Db6hePIn43dehsr75aoOfJ/ZYNVt3fro63/NgRV6LhnSyTa+JIpgWQWr9Et5L/rWgYFmQRir+bjR36EptE0zhNXfJ1e85VG5/psX4kVT3gOxrqXb2guqJXvy/RnCssh1sCLBCqd9qHZYgGbxU+v+iDYNub15lrTdHS5luxDFyASipQFAALpVSBlErzAnl50N8YdgGQ2rpZH5Tm6YspVCZilP4gz3TwaHM5IOQfg6aZEGR8ZhOt/LHuSYZ/wTZsMExhDCjjXfeNsYI88P/2Lx86mNG20jzG8JJaok7kmHGnK137CjblnuiXKPItv/744OwIygO1kZ3M2lIB3YGR4HghQ0ibzo4kzs1An7/kBov+v6rUNjMN+tB+IeDCpxyG36F1p2LTV3ArDYoNmHcdmhOo6B/99d/cwRNzlnIObEr7VZhtaej//JL2uILQyRrehr32SkN/pZ3zMGHZNBNibswY2vqajW05Od7maQOa+f61QFFLxb1dSDha3IdxPbPLwiGR/bq6a7UFHIPhSUysFGn/MCfEHWfQNafqgXDmzBiHJ0dFMAKcMdIQNtI10VFm7WrBOSfvxbb72bX94O8ei07aTOeSel34xV8RYzrjTMvay3KVGRDditZBphmnKp5CJIdl4DZURN/5uVQGN2Y6zcuXloP80AtQLjRaB
 G7zaK0UA
 my5IpPscm+fLtW77WHYm4+DSnymhX7CwWWIGi0dkJmuekNsMANW9L6LK0nshMxkaCWhoTH4Vzyh5YBKJwH1KkDsWuF6CiL6krohdWzZYgfMpy9k/WWfocpjZcsFJCixJoXkRfnZHszJlVoFcoFX07QRKWff1SaUccChglpMq8H+tSuyQBqeMw5NcIgZMipy+4FOCpI+vWKtzPlgb76Xhkb+W8clrWHI6RthtqIPsPmIjew3Rzqo2tO2104kg2uzhnTRpIZbpvAusZe8HN2q8E2II4aBkFYBxwLNUfHByEXOh9ZuZaWgusgcYoHYJgRD9/m7csLl/WYcfteKV/5KFfwVAh9wi3fxjFawNudJxo8U5AOCFy+61GTKHabQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 25 Oct 2026 18:33:53 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] mm/damon/sysfs: ctx memory leak in damon_sysfs_turn_damon_on()
> - [Low] mm/damon/sysfs: unknown member targe_value in damon_sysfs_valid_start_ctx()
> --
> 
> commit 1635d9f393d64d22688141e9540fde6f98f5d6bb
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: error damos_commit_quota_goal() for zero target_value
> 
> This patch rejects zero target_value in DAMOS quota goals during parameter
> commit in damos_commit_quota_goal() and damos_commit_quota_goals() to avoid
> division-by-zero errors. For this stable backport, it also adds a validation
> helper before damon_start() in damon_sysfs_turn_damon_on().
> 
> Link: https://lore.kernel.org/20260903010722.94244-1-sj@kernel.org
> Link: https://lore.kernel.org/20260903010722.94244-2-sj@kernel.org
> Link: https://lore.kernel.org/20260803134034.15217-1-sj@kernel.org [1]
> 
> > diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> > index 5aa23c6545cb8..7895b11555d06 100644
> > --- a/mm/damon/sysfs.c
> > +++ b/mm/damon/sysfs.c
> > @@ -1497,6 +1497,20 @@ static struct damon_ctx *damon_sysfs_build_ctx(
> >  	return ctx;
> >  }
> >  
> > +static bool damon_sysfs_valid_start_ctx(struct damon_ctx *ctx)
> > +{
> > +	struct damos *s;
> > +	struct damos_quota_goal *g;
> > +
> > +	damon_for_each_scheme(s, ctx) {
> > +		damos_for_each_quota_goal(g, &s->quota) {
> > +			if (!g->targe_value)
> > +				return false;
> > +		}
> > +	}
> > +	return true;
> > +}
> 
> [Severity: Low]
> Will mm/damon/sysfs.c fail to build in damon_sysfs_valid_start_ctx() due to
> referencing g->targe_value instead of g->target_value?

Nice catch.  My build test was somehow configured to disable DAMON_SYSFS.  I
will fix this in the next spin.

Also, my build test found an issue in macro expansion after fixing the config.
I will add below change for the two build issues.

'''
@@ -1503,8 +1503,8 @@ static bool damon_sysfs_valid_start_ctx(struct damon_ctx *ctx)
        struct damos_quota_goal *g;

        damon_for_each_scheme(s, ctx) {
-               damos_for_each_quota_goal(g, &s->quota) {
-                       if (!g->targe_value)
+               damos_for_each_quota_goal(g, (&s->quota)) {
+                       if (!g->target_value)
                                return false;
                }
        }
'''

> 
> In include/linux/damon.h, struct damos_quota_goal defines this field as:
> 
> struct damos_quota_goal {
> 	enum damos_quota_goal_metric metric;
> 	unsigned long target_value;
> 	unsigned long current_value;
> 
> > +
> >  static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
> >  {
> >  	struct damon_ctx *ctx;
> > @@ -1517,6 +1531,8 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
> >  	ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
> >  	if (IS_ERR(ctx))
> >  		return PTR_ERR(ctx);
> > +	if (!damon_sysfs_valid_start_ctx(ctx))
> > +		return -EINVAL;
> 
> [Severity: Medium]
> Does damon_sysfs_turn_damon_on() leak ctx and its associated allocations when
> damon_sysfs_valid_start_ctx(ctx) returns false?

Good catch.  I will destroy the ctx in the error case in the next version, like
below:

'''
@@ -1531,8 +1531,10 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
        ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
        if (IS_ERR(ctx))
                return PTR_ERR(ctx);
-       if (!damon_sysfs_valid_start_ctx(ctx))
+       if (!damon_sysfs_valid_start_ctx(ctx)) {
+               damon_destroy_ctx(ctx);
                return -EINVAL;
+       }
        err = damon_start(&ctx, 1, false);
        if (err) {
                damon_destroy_ctx(ctx);
'''

> 
> When userspace writes "on" to the kdamond state sysfs file with a scheme
> quota goal whose target_value is zero, damon_sysfs_build_ctx() allocates ctx
> along with its targets, regions, schemes, quota goals, filters, and any
> target struct pid references. Returning -EINVAL directly here skips
> damon_destroy_ctx(ctx) (and target pid cleanup via
> damon_sysfs_destroy_targets(ctx)), whereas the damon_start() error path right
> below destroys ctx before returning:
> 
> 	err = damon_start(&ctx, 1, false);
> 	if (err) {
> 		damon_destroy_ctx(ctx);
> 		return err;
> 	}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261025182326.178326-1-sj@kernel.org?part=1


Thanks,
SJ

