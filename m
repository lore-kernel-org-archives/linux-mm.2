Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD35BF45A1C
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 05:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12496B0088; Tue, 14 Apr 2026 01:29:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9C036B008A; Tue, 14 Apr 2026 01:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8B2B6B0092; Tue, 14 Apr 2026 01:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C396E6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 01:29:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E54A160439
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:29:08 +0000 (UTC)
X-FDA: 84656032776.28.8A4A1F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 914611C0003
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:29:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TPLzKPR3;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776144546; a=rsa-sha256;
	cv=none;
	b=QbOdXuUwZGPB/UenU0C1D3zj+6FsJJ91Y+ogjiUS7bNCepCW5W3fY0VmifrpzsbnYOj+GI
	e0pAMETkbtagOt+ZIx1K8n59O/ddu0XhBmDE/vmKjOxhGVGd4aMwpUnr8t2aj1096rGyPY
	PFLVmB8AIoMkuXCJNVxs37sUmlUyBcY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776144546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hn/Sg6v8Kl2xA+HZ3mHAijYI0QvVXvQ+lXetR8Dzs4M=;
	b=JVdqm0IJrAgF2uINhzBtsEtqfR+EzMaQ9TG1upUXuPaGOuRjQta5xt/b5BtyyT9EHDcbEa
	/i5cfTo/yO//Jfe/P8evGPVYhGdmfwFGznxGCSH1WM/+/CGWj9qvnWpips/X7eT4aoG+CF
	b3DxtFaBUBn014D/kRXfRwQ+w9n97Cg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TPLzKPR3;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E0FB42D84
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C477C19425;
	Tue, 14 Apr 2026 05:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776144545;
	bh=fYQyd2tPH0/IQiAZSr2cOX1SyNm+C7ey9+gqAGkZppQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPLzKPR3YXny9DBobkzoOscb/OyNgAsL+SXhLBLOxtrAdxfxMzXxgQVZ1u0WrimyR
	 xUDVCTWus0gUZNKPmo+RKGbRt1KyRRjiy95Sk3U+MkS4bj14YnzowDMTZ1s/0Nna7U
	 NskjCK0CfWxoo50yhfdbUEMswBUNGHezsXTlt2X3vHQl8b4PjcpLvquhuCed+8S+tO
	 t+q+GzMP6jMpgUvikS0rY2OhiJoL5kB0QWKzTcVDw1bJfcOUkV9lmoNmk5EYxI8Fye
	 pr/m4VFG2y/KH56S8FCy2V6r+BbEtyPFx/cvJcE7ctlFyVJzkQkW30v3UzZWL09QlS
	 bxiJVVnGxFVpg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH 1/2] mm/damon/reclaim: add autotune_monitoring_intervals parameter
Date: Mon, 13 Apr 2026 22:28:55 -0700
Message-ID: <20260414052855.90123-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414045253.88529-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 914611C0003
X-Stat-Signature: kmj114ih8ndpp3ygxyzafxhp1ht4yp1e
X-HE-Tag: 1776144546-672659
X-HE-Meta: U2FsdGVkX1+48tTRZP0iBSqNXSUEzbYUqdfdRaTJkgBijz3RgIIiAIWaYMclmtwn95SHvqa2lArrgU8jhhedrNWhqLiBs+vEIy2aIqQ2NsT+06JDsYcZrSXZQFgD6VoenDXmgGcrCV3qKST1HGfm8AnzEQ1bL1zX0/shJtfy4Kdr7qgwGF8TqcCzj9c+oABNKLSWtTNUVvfeu7pxhvs2GMc4Fa16QuQu6WAWWJJ2XyGlpHzqV3QRaKWyDLmln7Z0WzlPjkdVdHu85jAuKbDakRO6X3FdQwY/kwpiVbv/fjf34E+vdiMQ2KQiMO15KzkTCCla10pNGNsRU/yccMfTh2jP1XvPVy9LIAyT9Hsep2TgTodaV22xbRbnudMwi/yH1YZ1apW2Dz0ITa42soh/Ft9k1vtxNSxsJjVPydNQPJvoOW6jkkO1dwWDD3SxCnfBekyZH/CXH/oyjsjZ3tncskTKuXlksgF9VEyLdcM0AXrkLPnFfl9Q8mQowRONxgoZdNYTPnCg5x8HjjFjgnO7pDp7FF/CfZcor0ubgvSCM3Al+MQKDXSFBHtkZOVY/RYeH36EGFWy9RfeWRTWaDRdbDPtf/sU4EFfi3SQud/KP2/cxoYxTRJPnjzuypLkNkkYnQi4awSt4GsepyiWloHNXoN1ooSfw7DE3JtnCwVX3rkxNa3t56kl7urCc4SMIRvdgssoNCube1Z7ugnUh2YLJmrJCDUCdtCTnMnYWS+fbGRLowwPIweFG1iT5Kwo7ezAuJyDV0asraMf121rFBRyrrZNu9imHZra7/fGYePu/FTv1qezeVHYklDi9+3rjCMaVHfx8cRcpz6Z7jPw0UuTS9ndyTuckgrzi9YxTWX4n4rmbKZUjgAt3lnyiEXuKJw39LOiGn/FMlD0o4AJibCosTaqZz0S/D1jaerhZo8EfNy5GN45PfcSpKsz5x5Otkq8nyprIKWcOmSBHjlSBb1
 xY2676qU
 WU6I4DAJTbQ50JkLJ9oNgQa6z+QColk/gOxxx/WcrCI6JOn+mQ/6FDhpchQkTXohcPUOXOOIkD6GYpkXhRPbRmiSqk4bJaM92iXdSIPZq3QrlNf09Z+kUwX/3q/fnGkMKRD+6xudMj+UAym2zl+FZjXmZvOuNG6RMNM3P6jB0xt7sA5ZYOTEOtNW4hQuwNjUsK3LnuwFF2fcMcN8/ubDMMAAzaDWcAfvVT3W1gwhPD+TfY1Zz3l6HN63B1gFy+xJ3b1qobdELwAN5Nf6k3znAaI2uRc8P0FCc6fFZ6twNymEN3/s1Qg/be+XyeEcp9Lm8cP4kP5sfTvOBrI5T0UlAYDUlfXEOqo8rDqYemzwAoKB2aKBzmW4bD8byTjHtq5k5Ow610I1tG1PMlzcxeKXNXCJ9f3A7cFXDs41MdEYtxuq7va4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: Sashiko found not clearly documented behaviors.  I will make those
clearly documented in the commit message in the next revision.

Forwarding full sashiko review in a reply format with my inline comments below,
for sharing details of my view and doing followup discussions via mails if
needed.

> # review url: https://sashiko.dev/#/patchset/20260414045253.88529-2-sj@kernel.org
> # start of sashiko.dev inline review
> commit 7929f87e52de2f1dff34abf2ede4e58298280466
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/reclaim: add autotune_monitoring_intervals parameter
> 
> This commit adds a new module parameter, autotune_monitoring_intervals, to
> DAMON_RECLAIM. It enables the auto-tuning feature for sampling and
> aggregation intervals with suggested default values.
> 
> > diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> > index 86da147786583..bcba2f719898d 100644
> > --- a/mm/damon/reclaim.c
> > +++ b/mm/damon/reclaim.c
> 
> [ ... ]
> 
> > @@ -160,7 +174,7 @@ DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(damon_reclaim_stat,
> >  static struct damon_ctx *ctx;
> >  static struct damon_target *target;
> >  
> > -static struct damos *damon_reclaim_new_scheme(void)
> > +static struct damos *damon_reclaim_new_scheme(unsigned long aggr_interval)
> >  {
> >  	struct damos_access_pattern pattern = {
> >  		/* Find regions having PAGE_SIZE or larger size */
> > @@ -170,8 +184,7 @@ static struct damos *damon_reclaim_new_scheme(void)
> >  		.min_nr_accesses = 0,
> >  		.max_nr_accesses = 0,
> >  		/* for min_age or more micro-seconds */
> > -		.min_age_region = min_age /
> > -			damon_reclaim_mon_attrs.aggr_interval,
> > +		.min_age_region = min_age / aggr_interval,
> 
> How does time-based page reclaim behave when the aggregation interval changes
> dynamically?
> 
> The min_age_region value is calculated statically once at scheme creation. If
> autotune_monitoring_intervals is enabled, the DAMON core dynamically modifies
> ctx->attrs.aggr_interval at runtime.
> 
> While the core scales existing regions' age counters via
> damon_age_for_new_attrs() so absolute time is preserved in the new units,
> the scheme's min_age_region threshold remains static and is not updated.
> 
> If the auto-tuner increases aggr_interval, the age counter grows slower,
> but it still needs to reach the exact same static min_age_region value.
> Does this cause the effective absolute time required for a page to be
> reclaimed to become much longer than the user originally configured?

Yes, and this is the intended behavior.  Modern users are expected to be less
depend on the static age threshold and use the aim-oriented quota tuning using
quota_mem_pressure_us like parameter.

Nonetheless, I think this is better to be more clearly documented.  I will
clarify this in the commit message in the next revision.

> 
> >  		.max_age_region = UINT_MAX,
> >  	};
> 
> [ ... ]
> 
> > @@ -209,12 +223,21 @@ static int damon_reclaim_apply_parameters(void)
> >  		goto out;
> >  	}
> >  
> > -	err = damon_set_attrs(param_ctx, &damon_reclaim_mon_attrs);
> > +	attrs = damon_reclaim_mon_attrs;
> > +	if (autotune_monitoring_intervals) {
> > +		attrs.sample_interval = 5000;
> > +		attrs.aggr_interval = 100000;
> 
> Does this silently discard user-configured module parameters?
> 
> If an administrator explicitly tuned sample_interval or aggr_interval via
> module parameters or sysfs prior to enabling the autotune feature, it
> appears their configured values are overwritten here without warning.

Yes, and this is an intended behavior.

Nonetheless, I think this is better to be more clearly documented.  I will
clarify this in the commit message in the next revision.

> 
> > +		attrs.intervals_goal.access_bp = 40;
> > +		attrs.intervals_goal.aggrs = 3;
> > +		attrs.intervals_goal.min_sample_us = 5000;
> > +		attrs.intervals_goal.max_sample_us = 10 * 1000 * 1000;
> > +	}
> > +	err = damon_set_attrs(param_ctx, &attrs);
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260414045253.88529-2-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260414045253.88529-2-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

