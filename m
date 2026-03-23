Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70472FC72C5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 07:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94B8B6B0005; Mon, 23 Mar 2026 03:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FC186B0088; Mon, 23 Mar 2026 03:27:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C4276B0089; Mon, 23 Mar 2026 03:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 667066B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:27:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CCE013BF61
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:27:31 +0000 (UTC)
X-FDA: 84576497502.08.052F444
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id 39C7C100004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:27:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hSbp2fBm;
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774250849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ti0opXmGZu97z0kNAXreOapOmgM8GmXul1oRrCViSA8=;
	b=SyH2IJxrQTC8lcQK/5+hTfOI8V/A8OGHaZq9yQQ3Il/erzeVRjjIV93JGxeEB6MBzSSj5p
	rA435iGKzs21z+bIJyCYIVOYJuYESvPTHtT1ZIj9XUpYCDw4JmGL1KFbZdn7L43sbBu4/I
	Hm+ll6Fovai5wh6rYXOlrsIV8As1Y3Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774250849; a=rsa-sha256;
	cv=none;
	b=Q0TpEddtnVykcHRTJaK1sLy6haVnMVBOw863eu6LWrJYvKyHuNzyR3ktfr1YyeAOtv0j4R
	IHZwUxQqtkDfOM0yBqganckcu4i1KmuBcEDvJTH+4UIIKvZjltgP+cH2D8Oc6kO3N+pn7g
	DmjK8/mhQRGldMeHalHMuTGidRttWVM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hSbp2fBm;
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35a09e0dd63so3352157a91.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 00:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774250848; x=1774855648; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ti0opXmGZu97z0kNAXreOapOmgM8GmXul1oRrCViSA8=;
        b=hSbp2fBm4IljeIrPF0HDVwiGHpNPj1y4ax8kXknpZWordaumSJ+P1TjAICPSRw6eTm
         TdFbkxoH343VxeUYUpm8pBq94GLa9uApvmAQd92YJYwN2FTcFaJYvoeFqvorc09K1og1
         52gC8oXkt6Wcy+auab3TcD1AX1UMAoE2O7Q02926hpEsyxcVnZWw5G/gkkg2wCTWluHV
         VoH6+lfGdV1klkXMrKlzaV9aUCY+vTmAozfq7GLJDGiSvAtGD4orSgBaDMzaoeFPZd9T
         Km6KdrWYhhrQ5bEVVha166R//FUIsnNGHlkLnUxuwodPisCMtXqi01aaYmvyLnTunAKY
         +1ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774250848; x=1774855648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ti0opXmGZu97z0kNAXreOapOmgM8GmXul1oRrCViSA8=;
        b=I+iT+tlY4B+d2izOhoLk3tMvnhmXbA0d+AGfTxCeMIEj+ar51hlagYSaDmQ+c9mKwY
         9ARJtabRKpjvz0wvIkCMj3Fnz7pWtLc+/gvUzn20FexYKRQB7nFpupxMbTCj53UdbSGr
         UkI6EugxQNSKIfMWKF0P8lpIohOUyGOYZy2nqRe4oXwtejtxqwDzUatflguewci+RHoX
         qXOS3WWM8+HwLZSmG00Fnlsb0DW8DN4mMxCvSbd7HmqnkM36BNPFQ02h6riW4wgHs+qG
         cZ2mkDBfvyg/wLtG0uxl3rSld8E9k1kT0a/VjbX5izZYHA4odZdfZDetzr2RHq68D0gw
         ZRbA==
X-Forwarded-Encrypted: i=1; AJvYcCVrU9ASkFhM7OLCJgdUzcbO/huVLwmomyVyKpgaggzuLP07xYyrUzN6PaHV5n+Hx2DbxfzjWHMOvg==@kvack.org
X-Gm-Message-State: AOJu0Yxyga86ZwVZNXuc5s2D8NdEVs1quyX1kBcQrrpR8hGBCIqGKgzQ
	/haV7KwOdkZ24yTwTY9BTCg8cIxRMcglC+fvkqrZil7ib92MAaGaT0wzRXSWAA==
X-Gm-Gg: ATEYQzzgQGgsAeBTET8sYQ+hrTmvecCgJ9RA4Vwqo3/QaQGrAetaC66LubUdI4hsbiL
	AB/9m/vyoABA6DS36sgkVQ4PZcl5eHPYCKgQofRqxjlVzPX7IDNR+b5Msdt4O0utiviFCZb+3Jf
	ifwBtZMSvgaarNPsmewGAjLt3OWEpU7/+H6+Bht5tHcfmBfoqZlvZ35wOTSugmmmvahkuY7M4T1
	OXYZEh9hHQK2NM1chXaZG9RDBk4W/b7KiOozknXblxW9/Mwr4Ik0GNUNb9V/9/urM/Nqi0qiHN3
	twpQPmDEDW24GlDsLEs4tfbkAKGdyol0rqXWqlOvEztBYPOodKeytG5zVfPQ/dFLFLrmYPuScAy
	oGLz480CNCQJhiXKVMa5YmYMkTxLZvO46VuO3HSaA8XMmXtmc/VNWcgE/DkvcIycTcyrZyxzZcP
	1PNzukCDX/7UPRvIN/SqIeDjLUry8rzEGURtAAG1XKVsMJxg6DeN4=
X-Received: by 2002:a17:90b:3b41:b0:35b:92c1:8a39 with SMTP id 98e67ed59e1d1-35bd2c47760mr9223747a91.8.1774250847877;
        Mon, 23 Mar 2026 00:27:27 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bc60ec3aasm11041077a91.10.2026.03.23.00.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 00:27:27 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	aethernet65535@gmail.com
Subject: Re: [RFC v4] mm/damon: add synchronous commit for commit_inputs
Date: Mon, 23 Mar 2026 15:27:24 +0800
Message-ID: <20260323072724.15942-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323021648.6590-1-aethernet65535@gmail.com>
References: <20260323021648.6590-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 39C7C100004
X-Stat-Signature: nyn9rh5fc9t4e1sj6wiy3y7ensdco6aw
X-HE-Tag: 1774250849-267776
X-HE-Meta: U2FsdGVkX1/gPQFt2st+6Mc2Gx/VQbruN0WTeg6aWx99m8uuX0MunDoiT93FZJ2QmUl1wTQUqRXdpxUcc92SrlFcbVikVQCWSyLEJOHCg0UV/aQVqzphaNlrQQU7Cz6OCqTzTAFp9J1+j60sfn+OKi2rPCiSNpXbni/qXvNQZhTz7eLVRVePju/5zo9ktMmzFX7klGQeexe4WqyzoVKLm9e0wPxmiN0R5wGQgzWaLtGS08Yf0XVFFrq2R76tCe0GholKuXjEXocrCOBnpE5JcGMFWG6z1ea5qoEB8CAMwRBwG0gIc5PZQQC3MzuMftAYXlxGYMX7TLve3F0LTGIRvtvmpAj28SDgrSnrXiNwmexLzg5681SzNPZwk0O2XW6RTvmi2VnpiJIN4DPxmvM6v19N2zjC7muYbsTQvDXrBdaTm2viSmlJjPZ6DPXOH5927eXS3vJhGVXP5+YigiUwl/FHMIZh1sUxDKBSolPXEQEYq34a9pIgd2yreC2Op9GRGo5Bf6tsWQvr3L+2Wp4pAqdXs5xhT8/GYYwvNKUt/3yHnE9p65qSIFszfGQx3Q9q1UXCPhkrIE17m+PreGBrV7VQGhTstXUnxFJvg0seXwr1UI8WZHkgG78Vu+inApGeW7ap6gqthKEYY7ejEBDjLx302C95LVflOWB0Gih1unX8Xm2e2jOnl2k85CMWAQLXi4R6DO4+bOuq5+vFjHz/LJMcSl5I3qBae55A8TjyNW4NVHRkuhtreuvx77avbc/h0TGEBVrCp7Cq+PaQcwHLQNnHeeVlpscI+wTpzNbWSWr4mwe+pcdLXHsYuUMxf1rebqQQZr0iIZL6s3+l8dfNssGbg5DyTpZq81pAAoy8HaG+JtTEBN2k321k+6ziy83V9hJ92dng3WO7IjV2KO3PbiP3lYwdnBDD6D95fW60a5VxpTWRbRVX77rrIQQTn4sstzSHzotNHKN4OpC9utP
 FmXY8rOw
 WV7UJygBfWFsNND0OeWkGKP664f2IySUh+z7s2/r6jWehywDwxDz/zXcIs4lKc5esiK//tcLDkBkfzqQZ4BPEpunbMyjpXZSH0Rt0fNHuCWtuvSuvHyu1s1Zf02+hPIhRT/7upL2G8qIQbCU9X//IkvPNA+q9HlOBAZgKoR9vLy+iP0ZM5mAG8+WgO+KeY7aFi0h4IOtuV6iafOU6njGN6j9qpKZahJp3zFmGnvLdsLCRTwjx8tK2kCxNoxZ7G5BEA7vfZf/D26RGFDcG316Dhagx9H2JAKX9ONd/G+t0KaH78rcpGz1xQyH4VZgXMnyZRqWf8vtgeZ5qs7zsFIkCcWjitGNpdwJFDowLBYOmjTtfVo9f5/bzPysjbKLv/iD6c4eMsRW7KpzEweG98LMqg3NyPPBzeBtxyqPBTQ2k6gAf8C8ocbHYyiM226dO12nNGsoX7NyURsBnG4J4H+Ns2Wlsaof0f8JR9FzbCVlka71l1uB1ixdZ+8oo0xz1C9GPybpl5VUzRAFz1PtnQKFv9v1O5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

Thank you for reviewing this patch. I'd like to address the review from
Sashiko.dev [1] and ask for your guidance on two concerns.

> > -static int damon_lru_sort_handle_commit_inputs(void)
> > +static int damon_lru_sort_commit_inputs_fn(void *arg)
> >  {
> > +	return damon_lru_sort_apply_parameters();
> > +}
> > +
> > +static int damon_lru_sort_commit_inputs_store(const char *val,
> > +		const struct kernel_param *kp)
> > +{
> > +	bool yes;
> >  	int err;
> > +	struct damon_call_control control = {
> > +		.fn = damon_lru_sort_commit_inputs_fn,
> > +		.data = ctx,
> > +		.repeat = false,
> > +	};
> >  
> > -	if (!commit_inputs)
> > +	err = kstrtobool(val, &yes);
> > +	if (err)
> > +		return err;
> > +
> > +	if (commit_inputs == yes)
> >  		return 0;
> >  
> > -	err = damon_lru_sort_apply_parameters();
> > +	if (!yes) {
> > +		commit_inputs = false;
> > +		return 0;
> > +	}
> > +
> > +	commit_inputs = yes;
> > +
> > +	/*
> > +	 * Skip damon_call() during early boot or when kdamond is idle
> > +	 * to avoid NULL pointer dereference or unexpected -EINVAL.
> > +	 */
> > +	if (!ctx || !damon_is_running(ctx))
> > +		return 0;
> If kdamond is not running, this returns 0 but leaves commit_inputs set to
> true. When kdamond later starts, will subsequent writes of 'Y' to
> commit_inputs hit the earlier check "if (commit_inputs == yes) return 0;" and
> silently ignore parameter updates until it is manually reset to 'N'?

My current thought:
When '!ctx || !damon_is_running(ctx)', we should return -EBUSY instead
of 0, and keep 'commit_inputs' unchanged. This way, userspace
immediately knows the operation cannot proceed, and there is no risk of
stale state.

But, this means that users can no longer write 'commit_inputs=Y' before
'enabled=Y'.

> > +
> > +	err = damon_call(ctx, &control);
> The module parameter set operations are protected by the global kernel
> param_lock. If the kdamond thread is currently deactivated by watermarks and
> sleeping for the watermark check interval, could this damon_call() block on
> wait_for_completion() and hold the global param_lock for an unbounded
> duration?
>
> Also, could there be a race condition here if the kdamond thread is stopping?
>
> If kdamond_fn() flushes pending calls and only afterward sets ctx->kdamond to
> NULL, could damon_call() insert its control into the list precisely in this
> window? This might cause it to perceive the thread as active and block on the
> completion forever, deadlocking the param_lock.

I admit I don't have an elegant solution yet. Here are my current
thought:

Add a timeout to wait_for_completion() (e.g.,
wait_for_completion_timeout()), using 'damos_watermarks.interval' as the
upper bound. This prevents indefinite blocking of 'param_lock', though
it still holds the global lock for up to several seconds.

[1] https://sashiko.dev/#/patchset/20260323021648.6590-1-aethernet65535%40gmail.com

Best regards,
Rui Yan

