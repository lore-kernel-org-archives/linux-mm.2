Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D648E99074
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B4A6B0005; Fri, 10 Apr 2026 06:08:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C276B0089; Fri, 10 Apr 2026 06:08:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73AFB6B008A; Fri, 10 Apr 2026 06:08:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 642BF6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:08:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0DC08E3033
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:08:23 +0000 (UTC)
X-FDA: 84642221286.26.9FB839D
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1E905180008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:08:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HbBwhoGg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775815701; a=rsa-sha256;
	cv=none;
	b=7Maw2hFS+l1CjkI7oeCVkTG72WDqjQ9kAqTl6lIVeYBbRb0TQXC7j+B6aWOdQHlF8PWRn1
	XJzVskIfsb3YDDskrGP5DKHRR4FSEQmmMEztlYAu9RX8L1RRNbbgYUv7opGKMmt7BCGz66
	LgYvAsdolFIyw88RMAcqIksf9QJeBWI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HbBwhoGg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775815701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ex06fw8ZW4mGohg3CG9/QbBROQUogUR/vRM+h93FYi0=;
	b=6WsnJguJ0GdgtNe0jY4AHky3uYR1fgH4F5t2CJKkmxsDdmV2+Gc5KequV4oeN2N9Tf0Fwl
	/YZu8JKLTqp8FCdg7HZciZzceLUVqvRgdOj7iED9jk3nqOQscHEYE6MkDfaq869nEf7fsk
	SFVgDlorII7cZqNAomm7IdjC7u/Gbd8=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-827270d50d4so1760010b3a.3
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775815700; x=1776420500; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ex06fw8ZW4mGohg3CG9/QbBROQUogUR/vRM+h93FYi0=;
        b=HbBwhoGggv1lUvB7Dl6L0UyYM8ZGM5Ppo139TVhSJnqbEuqjjF3jMAuXZBI4bNsCrY
         XE411HDbYSj9LKp1cS2A86Dd3SatAGsulcz+guWuDu0SmzS/jXikzpVuSC87fpEa1Q0d
         wOv6A4XxWdutIy46YVx3o3/1VizXy5F7O6+U0diXKBio1d6jELikBPbz8t3hkL+waahn
         DJteGKLv6HmEQNw5dG3dr15ZGScPpWPFkrMasfW2wyRWZIv25BPHo4CFFkkGF0OeJCXn
         8qNUemlDAyJL17JkGIsRBWcCCjIK4VoT8FfmOsx/Tc1NC7ZetZoCgE2H4IsRztP3Bku6
         Z7Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775815700; x=1776420500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ex06fw8ZW4mGohg3CG9/QbBROQUogUR/vRM+h93FYi0=;
        b=s3+V2X3hhcCSqHo5wZttdvd9Uwc2SOK4T4xChvMGO81tUUUpfhEIp6JfbN3rIFUajA
         pctUBoXA1Mq7eVOLnwNWRFOADVkurcYXqSlMINrIi6+76ZFw86NAtBzwGRlY0PJoFnNy
         MQGuyoVOmqaVhqICgKw9tmv3n1OAa261RH77s3xnP9iX11wfU1z5S7N2Mf6+HY2F8cYN
         U3UEmUtNc8w5TOfcbypU3rXqxUGS79grI1en4dYbXbGIPPIRCuDdZ8CrdJmxanGurwGu
         wYVmvBWilUxkJuxZUxuffhHvSyJo5WKX0F1Bn3DbyUqTOxb8/b7gdgZ2kJIj+4U2Wpdr
         o1Rw==
X-Forwarded-Encrypted: i=1; AJvYcCWQBSBz6Uolu1XFIb9dz3GTvwV26rqMbrae7alEgLb2+dOdX+NSRYCMsSNuRp35+DcFZVPEJs26/Q==@kvack.org
X-Gm-Message-State: AOJu0YyEm+EbqcSCr6tiS+ac007B5TgvlRicxSNTth2DvubS/MlPSAZ7
	HUuS2BqXAlUcjNPpsAEQKd8pE7RF3NyOQOfCRa5NuUKgiw5vbk+dwBFU
X-Gm-Gg: AeBDievK9SF540znrDwEsSmlgoLyqfeCkhzAP5Lm982gSi1/YZq0HHYq/ErytKMHbEL
	mte30CH5Q3VoJbH/INxTBkiI71w1IJMgfETiMkj1az9HvqxKA+9nnlrnkmuseBC9Fl/Lg6MJ7t/
	SOPozL4JGYxj79SmS3H2jU/9E9SIsPZyr5wueUGLwwHqxG3g/BFAGtv55kfH1jAE3J2UzDp62DU
	oZpqMCLxrls6wuJIDqJxoyXutPWma2fhXlU3kTb4ZwtZiz4eeZwqILKFHgnSzu6hAWAj4RksBGK
	6eWkfBI3/gVlWJr8Y66gLsyo5rAgpBmM34F9TKcf9P1RaOM99hs6KCCDDBIFfXzLho3d3S29kGV
	c/sfRqnFvyPKDiF7d5Tygt9QcJGDwP8l2Jy8IwsBVft7tlZXPDznoUZtcEmQkpaBJ5rBAVqtgDY
	0Q5Iuz9HYkuok22dT0iWYSac+EkcMQcBa89CEvCA==
X-Received: by 2002:a05:6a00:2d85:b0:82c:9126:31e3 with SMTP id d2e1a72fcca58-82f0c31050amr3292091b3a.26.1775815699762;
        Fri, 10 Apr 2026 03:08:19 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4b7d10sm2462891b3a.28.2026.04.10.03.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 03:08:19 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org
Subject: Re: (sashiko review) [PATCH v4 2/2] mm/damon/reclaim: validate min_region_size to be power of 2
Date: Fri, 10 Apr 2026 18:08:22 +0800
Message-ID: <20260410100822.196999-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260410044259.95877-3-aethernet65535@gmail.com>
References: <20260410044259.95877-3-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: azz4oo1xk4ds8f7zye6nfpcfscsyx199
X-Rspamd-Queue-Id: 1E905180008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775815700-435047
X-HE-Meta: U2FsdGVkX19DdqgCrpN16rznJEZfgRjm7qOp7/8CFZOsO3I/uYgeGEB8UG4UWBhm0xB95QM9+qlRb2y5SecsHF8cmpv90TJ7u3aqUf+znNWKhH+2TxqU36Du8rCfiEZyh5OIrT6o8tYLI8fP8dE1XBP1d8QUEIFwLYDkrv5U/qiIze8LFic9j2/dIXVDnV2fjHCub7Kfy0I8YG4srYsHwbWgr7y2upGZiTdKAUGmqXlMx1xGLXhvbQ4JTggXqY6jGa6dPZPbsvDf/LqtKDT7iJ4zgwyQvWV8kRqhnkBroiCXzVVMqzXbd1fDnRyvljUS690f9/3X1fMe3yPrCceYTszOoPTlbfRQ2ub9e7jLThHZ4Adk7pIawzfbIc2hidTi28fJHV7IU3fDiTn+OjthUE2YzYS3VCH9d6giXRcJBzEqjqR4ASVAMnUmNbSUD0ZsC720Dq3k4J/daoKf6ycxFWhlAHhYsvsjK2rhMkcKO7w28tToppw9mfI8SIXOW9TmFn4kritfbZQ2jj3kIxv2QcDPkoquWgS1dP50Hhh7nrCv600z2tvqNz2NCDYy5PcZCgBUxZrxhG2jiKZ2Do1I8WRkdUOduq3SnwZmSMC6nNQyILzyuVysQJbPTYUUaoqftGasY8I7oIqRHol1SCSEnYJWPIvzO4Y7Vs77CbCjijuKH5kb91RKo9eJgr4aJMXZR4hE4aSXsO45XRfrBmW/5sadCuaAjwUAk6e36l70l7At3ddxP6+kQNMP/bBCSO2jOm/ObHi7Yo2MsT/fYYtfrICodiOjfZv3s+2PSeZBTf+hFeDAbRxiJ4wxZJL6GdrD/k0VDkqipOs9NTyLlRX0/flJkqa3tw7fhrsdeUBPiO9rw36d5gklytPcCs05bRN2Q32aWM3KJPrPMNxZewF9rLsQ7bR/v2ns3LiiuLSS0smPOz63f4uRLXTOYw3VfIRzU27siQ2eKus7LEEQWHF
 xMCA03xX
 TfNjfsfPFFl5sZ2jXqldIb2L/hx/gFvvGmBbcPFZ+55YxFSFxPcJvjHHMb5TvMwM+FZu82kvOQeyTnGlCO1vL50ogWputyFYiL9cmzu6Kr+oBbo4Y8yKgmMZ00k5guTr12d/gQoEz40ZnVPWzbVYfLIK7Cv5UQqet+HMtOw7gZybuLps5Xf4Bte46kHSfngfeKo03BVpEAflijMUXyFy6jLr/AcwAQVboDodpCWbtXItN4Qd9gLB5es3M4Q6vESZYnOa/Xpwsk06/uUOVdggLnqmPK7HzELUpEGK2v5cihOJuqN7HAHC1DX11hEmemQtyVh/ksSIYTStJip1uYW9SaS2KIUO+2gLnAwzpINOrY63k5XXtWNNFw9SnPmSbfWGxBz8pvys7DAoaJWrygJuF6BwcjlwbgflHFXckUETVeSoRTbWiZLU0BOtWSw+mwlCbcxQdc6drnTO40tofHXX2GttxuOzDMo7LHCy0V4RhoPsmIDlwlTYIHwmmi7hMILWXUdheqnxq/euaULVOSmmqG39aibp9jNK6JS0ILDe3oVulziU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko found some issues.

Forwarding sashiko review in a reply format with my inline
comments below, for details of my view and doing discussions
via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260410044259.95877-3-aethernet65535@gmail.com
> # start of sashiko.dev inline review
> commit 7a816b41f4b321b6a513227bef0e50f3bc1e86f1
> Author: Liew Rui Yan <aethernet65535@gmail.com>
> 
> mm/damon/reclaim: validate min_region_size to be power of 2
> 
> This commit adds an early validation in damon_reclaim_apply_parameters() to
> check if min_region_sz is a power of 2. It attempts to prevent kdamond from
> terminating unexpectedly by catching invalid values before they reach
> damon_commit_ctx().
> 
> > diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> > index 86da147786583..2747eef5919d1 100644
> > --- a/mm/damon/reclaim.c
> > +++ b/mm/damon/reclaim.c
> > @@ -204,6 +204,11 @@ static int damon_reclaim_apply_parameters(void)
> >  	param_ctx->addr_unit = addr_unit;
> >  	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
> 
> Is it possible for a concurrent sysfs write to change addr_unit between these
> two reads, allowing an invalid value to bypass the new validation?
> 
> The global variable addr_unit is read twice without READ_ONCE(), once to set
> param_ctx->addr_unit, and again to calculate param_ctx->min_region_sz.
> 
> If addr_unit is changed from a non-power-of-2 to a power-of-2 between the two
> reads, the validation below might succeed using the new value, while the
> invalid addr_unit is committed to the active context.

I believe this is possible, because the current call to
damon_reclaim_apply_parameters() is asynchronous and does not hold the
'kernel_param_lock' during execution, so this situation should be
possible.

However, I'm still unsure whether your suggested changes should be
included in this patch.

> 
> > +	if (!is_power_of_2(param_ctx->min_region_sz)) {
> > +		err = -EINVAL;
> > +		goto out;
> > +	}
> > +
> 
> Does this early check mask a structural issue in the core API?
> 
> Looking at damon_commit_ctx() in mm/damon/core.c:
> 
> int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
> {
>         ...
>         dst->maybe_corrupted = true;
>         if (!is_power_of_2(src->min_region_sz))
>                 return -EINVAL;
>         ...
> 
> If a different caller passes an invalid min_region_sz, it will still trigger
> this same trap.
> 
> Could the root cause be addressed by moving the maybe_corrupted flag update
> below the validation checks inside damon_commit_ctx()?
> 
> Are there other ways damon_commit_ctx() could leave the context corrupted?
> 
> If a user dynamically enables features that require memory allocation,
> damon_commit_ctx() calls damon_commit_schemes() which attempts to allocate
> memory via damos_commit_quota_goals().
> 
> If this allocation fails with -ENOMEM, it returns an error but leaves
> dst->maybe_corrupted = true on the active context, permanently terminating
> kdamond.
> 

I discussed this in my previous reply. But I realized there might have
been some misundertanding in my previous explanation. What I wanted to
say is that there might indeed be some issues with 'maybe_corrupted' in
damon_commit_ctx() that need adjustment, but that's not within the scope
of this patch.

> Can a concurrent sysfs write cause a divide-by-zero panic in this same
> function?
> 
> Looking further down in damon_reclaim_apply_parameters():
> 
>         if (quota_mem_pressure_us) {
>                 goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US,
>                                 quota_mem_pressure_us);
> 
> The global module parameter quota_mem_pressure_us is read twice without
> READ_ONCE().
> 
> If a concurrent write changes its value to 0 immediately after the if
> condition passes, a quota goal with a target_value of 0 is added.
> 
> When DAMON evaluates the quota score in damos_quota_score(), it uses the
> macro mult_frac(goal->current_value, 10000, goal->target_value). Dividing
> by a goal->target_value of 0 will cause a kernel panic.

I tried to reproduce this issue, but without success. 

However, based on the code, I believe the problem exists because I
didn't find any checks preventing 'goal->target_value=0'. Please let me
know if I've missed anything.

> 
> A similar sequence exists for quota_autotune_feedback.
> 
> >  	if (!damon_reclaim_mon_attrs.aggr_interval) {
> >  		err = -EINVAL;
> >  		goto out;
> >  	}
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260410044259.95877-3-aethernet65535@gmail.com

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260410044259.95877-3-aethernet65535@gmail.com
#
# [1] https://github.com/sjp38/hackermail

Best regards,
Rui Yan

