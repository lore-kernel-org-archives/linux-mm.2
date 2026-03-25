Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC99A109C02F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CC5B6B0099; Wed, 25 Mar 2026 10:57:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4026B009B; Wed, 25 Mar 2026 10:57:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E17B6B009D; Wed, 25 Mar 2026 10:57:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 020196B0099
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:57:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5066140996
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:57:52 +0000 (UTC)
X-FDA: 84584889984.04.0503170
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0D42910000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:57:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hEOslwJi;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jo6d5vnD/b2Oupj3N4fRtQBbwRt1fICWyQgHTAqlgtY=;
	b=I8sLBVF9bWTgyOdTnoOizxvHUKLy3P2lVRey7LXEpRIPPkCAncaQx6X7Fa/3dDXNOt4tKG
	lTclAcbwZBz58m0uKP2slyR6T/PBy8zBAQodRvhMe0keYmYB8ffko40ryDle8Nly/Jo89U
	oj7UWuuRBgd1z6DH8+eDFfrcM7q/two=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hEOslwJi;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774450670; a=rsa-sha256;
	cv=none;
	b=8Upribfoabi3h/eyHMyrXzvxqodXXX4dsqAqvMf16nlUn6kKl8Mbkzk1F3UYNKhA7zEeub
	OHhPEGMK9XXZMArRBuDtN3vmtGQYzxuTy3vGP77mo426L2Ey7NBdL/LWGzAO1gK9XfcddX
	h2YzI7SUnqMY+gK+ZsM58Mp2pQ0YC7c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 63362600C4;
	Wed, 25 Mar 2026 14:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BEEC4CEF7;
	Wed, 25 Mar 2026 14:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450669;
	bh=4GSx9AFpoG65jD6G5Qw9iA42wbY1V+x5tjlC4TYn/Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEOslwJi/G72R/9cw2jvefeEooIwtA/tWDtu94soIPyrp6E4GtJSyOMD5vo434/sl
	 GAuipYBrAJNnlziQrYKt56w1kyGFaVSEbp266M5ujvSGmBqoMp9cqN17EAWB0T9T74
	 zuyNP82UYB7syRO78z1WbrF65un0PRV7mdXC5ICsZWOXtFKafTzBIclqx3B3oU47s9
	 aNw+3EXcSeag0D+xIRs+Kl2vFl063Lo7uMntSbwq5SZwDQRtGFYyDcSAc8Djv33VA6
	 jsABWtSQB9+C09XVxTfIACinDKoDhdKNxYDnHnTI7/Rm00CUkwh0HC7tC7buunMfQ7
	 1DnR9TdoKXJsw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Josh Law <objecting@objecting.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: (sashiko review) [PATCH] mm/damon/core: eliminate hot-path integer division in damon_max_nr_accesses()
Date: Wed, 25 Mar 2026 07:57:47 -0700
Message-ID: <20260325145747.88132-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325011653.85502-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0D42910000B
X-Stat-Signature: ijukbi5jes7u4jk19h8qwzcf78xxu3ha
X-Rspam-User: 
X-HE-Tag: 1774450669-236359
X-HE-Meta: U2FsdGVkX18/jvaJFZGDlaIRRydEyE5GBIoS+xbAwgDVrrExOUnbIOlfcY7jGI4tE7eKScQoKQi3hJjAGMdFaOYLKmVyYhBUUDzcuG318CG7XSCgZ1gjDP1/lYPE1AO6Fy9r8JivcGk3eRBUEIm5nkJOoi2CfQGLL7we+5D0kBjA9/fK3JdEtilK2aIlYVTfhLRV184Bzn9r54KXCwC0ELOiE9JgFDdOJykdwGyoKlXcLB7fKHmGBjL/lvZ1fmYVdBv4PSYXqAUvR9Oxz/ekprbgqtgg5+OSV+GfOfg4TFNRGclJ17lH7HgRHm2qZhC6B6XC8+z95LOKR70Hx+EEY2Zy6eTIdUhJDGK9BRumPx5vQzj61pRxeZHAQASxSCI6ZsyBaatDEGlXaLVioEYCEA4cBUsL5FMaafxIci5ynM/HE+XWcoR/zgMCwZxUw6FFk2vM1xARMx5AbYaGQjgwDm3ie6VURUxFJWLV47D4JLf289PlMkrrzA+dtwSkLrk+gcKJvt5rCMRikoexwAaz9VHR31b+oZ3S7l2jZVjnjvkjg5GHVTMau1qQFY3dRe3Z3+7norw7wybsC1Kn83BO7qt72IALDq+SJ7fC3Fn/K8vON/AjFhnRLLS9haUJ9dPw8nW1O/K6Sv3OtqYzXZI0bHtaLWwOQZhKc7pX4H34ZIem95hy9bfMmf5pQDT1UoDi+D7Fp+3eJt3h5H5DtQIm4EZOrA5/rLaIV3Ro7Kd1+3vfDMM/vQMsZixKAdeija81eMU7WTuru8SZt0rkq9T1pxrBG2NabFNgSG+Wr62p1j8SjWcC6wt+AhJLw/Rjl7hqMCGibhmT2af40HC1XSl0cwyeaoUvqh247bWuiXasy5/ecQpq1uG9hvQ3bPVYOohesWCosdjT9NMikaG/ItgXBCkrA3ONg8pwWmsc8PF3GkAmgMvL4LpfgDiAum0aXTTce4vNhnfZys927YF/COd
 0q9T4a9v
 +TdHDN6tGBPyAy/a+mQoDcBR/RcgxbI1GrOZc+rtHB9mNM4Lo0Z29HIU/LDONTqh4HPOvkelgzfYEXFCLUIXGPB0yQ4ajszfNwvlFz3Kk/1jter/SFVsM0aMbX1MQqOEO8t1AG50NlJuKi90BbsQj7BGwzcIV6lvBkGr08rvtCx/GxmjbnlJhMEj1QknJ46KbS13wRuRKf3/oBV4JRPDbpR1Qj7CoE/nbOXgxyqwCglVQ954dNACf8T+6HQnQ4BiemHI3wVwUkQYKtOEb7UxJT65i5igvmCkGHRXaGiVD/aK8zHCgg2Vk1SGRhrm/nxvyuVV3wJaSpp9tvACsSOnEfNVDzWugXNMbo0icGUqo6vSzOzdFswysYSRvxF5G6Jg7eTmthSufw+q7xqo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 18:16:52 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260324154005.83651-1-objecting@objecting.org
> # start of sashiko.dev inline review
> commit ff5e227a18cd69435749b0aae0dc2c762c4f0a47
> Author: Josh Law <objecting@objecting.org>
> 
> mm/damon/core: eliminate hot-path integer division in damon_max_nr_accesses()
>     
> Hardware integer division is slow. The function damon_max_nr_accesses(),
> which is called very frequently, performs an integer division.
> However, the struct damon_attrs already caches this exact ratio in the
> internal field aggr_samples. We can eliminate the hardware division in
> the hot path by simply returning aggr_samples.
> 
> > diff --git a/include/linux/damon.h b/include/linux/damon.h
> > index d9a3babbafc1..04c8a052fcfb 100644
> > --- a/include/linux/damon.h
> > +++ b/include/linux/damon.h
> > @@ -978,8 +978,7 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
> >  static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
> >  {
> >  	/* {aggr,sample}_interval are unsigned long, hence could overflow */
> > -	return min(attrs->aggr_interval / attrs->sample_interval,
> > -			(unsigned long)UINT_MAX);
> > +	return min_t(unsigned long, attrs->aggr_samples, UINT_MAX);
> >  }
> 
> If an administrator dynamically updates aggr_interval via sysfs and commits
> the inputs, will attrs->aggr_samples be correctly recalculated?
> 
> If aggr_samples becomes stale, kdamond_fn() will compute the real aggregation
> loop count and allow r->nr_accesses to increment up to the new bounds (for
> example, 80 loops). Meanwhile, damon_max_nr_accesses() will return the
> stale aggr_samples cache (for example, 20).
> 
> When evaluating schemes, damon_hot_score() normalizes r->nr_accesses against
> this stale maximum, producing a freq_subscore that severely exceeds
> DAMON_MAX_SUBSCORE. This causes the calculated hotness to exceed
> DAMOS_MAX_SCORE.
> 
> For DAMOS_PAGEOUT actions used by damon_reclaim, damon_cold_score() returns
> DAMOS_MAX_SCORE - hotness, yielding a highly negative score.
> 
> Could this negative score cause an out-of-bounds write on the
> kernel heap when used as an array index?
> 
> mm/damon/core.c:damos_walk() {
>     ...
>     c->regions_score_histogram[score] += damon_sz_region(r);
>     ...
> }

I didn't take deep look here, but sounds like true.  I also had similar
concern.

But this takes too much time for the small optimization, so I suggested another
direction.  So I will not take more time on this sashiko comment.

> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index db6c67e52d2b..afb058f7da5c 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -587,6 +587,7 @@ struct damon_ctx *damon_new_ctx(void)
> >  	ctx->attrs.sample_interval = 5 * 1000;
> >  	ctx->attrs.aggr_interval = 100 * 1000;
> >  	ctx->attrs.ops_update_interval = 60 * 1000 * 1000;
> > +	ctx->attrs.aggr_samples = 20;
> 
> Since this value is cached here, but not updated when intervals change, does
> it remain permanently stale during dynamic updates?

Ditto.


Thanks,
SJ

[...]

