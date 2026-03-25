Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBAD1FEA81A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 07:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18C646B0005; Wed, 25 Mar 2026 03:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13D5F6B0089; Wed, 25 Mar 2026 03:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 053596B008A; Wed, 25 Mar 2026 03:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6D336B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:17:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 972221A0758
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:17:15 +0000 (UTC)
X-FDA: 84583729230.10.C4CE757
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id B2860C0014
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:17:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="GHq+//Za";
	spf=pass (imf22.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774423033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3A07CuX0FMbAmsm6wPhYwAIxkhxeIbAc+QWngeTZUts=;
	b=8GehgeuDz7EpDIcQi0hsnmTUxZ2Zb7I9nptKXA4JRPGQh+5ayuB+Su5ct7/suQSigdeiQe
	PEMg2e2dgMLGArYKb+nGZB3D1JrqLS/q3wrfA5jRsBLopBHrEowWHd7HBPdc3ysfb1RPFH
	vsxprsP68leEQlUMkY2yLmUdpweZ/Vg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774423033; a=rsa-sha256;
	cv=none;
	b=aCFz2PhJvOM8C8K5ze6tjzDMfjeo1Wp3XIvYxcQAgEKbI2vnqkyA/BotxbgDX5zGZG4QI0
	WYdu2hq+GYhYvG3Ibe33B3O5JK94Gf/hVTwDecKOzYRaZsaIlw/XWz28TDPnxeLQe3GDMS
	ouIP6fbvnzJTy7TP7XyVyPivdKmFxzU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="GHq+//Za";
	spf=pass (imf22.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c742bc88d87so2180340a12.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 00:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774423032; x=1775027832; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3A07CuX0FMbAmsm6wPhYwAIxkhxeIbAc+QWngeTZUts=;
        b=GHq+//ZaQtfCMpvCKsnWOXrTZoVASaxP3CuqR5MuBUS/xbmrL7r26BqjVSGzdvv5g5
         DcyRv4QudK9RkAHPxAk6KScAmOotcNZVODQ0V5YbEAxuzBxtNbxRXPdH9VYn3OCAGRRL
         Sf6Xp7bbvfNH7cmL+wh4+mY7PEODcw5f64hLsQHOhxEMwh0/ZIk7HcOUcWFb9LItpDCS
         8/kmtC2mkqr9rSQX2zRipCtFSRpjD2c2XdULyqbrCB/3zyu68LfGCZuBkN4pxF8nARRr
         aWBfs4VKD1uac3q8vaTqA+WzFliBk6XehckNLJFkSyJTj/fr6WBtHEg5lr9L/P5j8xkY
         YXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774423032; x=1775027832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3A07CuX0FMbAmsm6wPhYwAIxkhxeIbAc+QWngeTZUts=;
        b=nC1Wv9Wy3ix6dgUNQ2XjqdxE6nfTgGVzmftq9MAq2+xD7CWBdmfJBTf1qTEdkGW4cS
         YfUoyjAzeRV2vrhl7YWLSDTCVJKO8LKer7TWg4glngHqACu/o/QaTbzgZmGwvdL/FDNh
         +5XzaNjo17YeyJV6xAvBN4VZr8EQxvoAKUsg51DrYH+4/gxZf9jeGjIb8Q8wWsGbNfON
         FdSkBXRFRVxiXonBS2ACVVz+Ytcnz64tVQ9uDz8pZbQHjTMyz6pEvOlJmwg8Svq24M2B
         xofGffI2P1lT76o2udV1O7q1WQWH36dQesfSEwJ99Wo04fkm7JsRs71npKAI/UKizPnz
         lWcQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0dGccIxMTas1BXl4WI6TzPobStAgBm8jGsWVZpHP4BRWFLBqWCyNVDp+btZ2rsydfZupENIydPg==@kvack.org
X-Gm-Message-State: AOJu0Yyx3vumxKN0aQNrvj+U2t5ptkrmPUIvPpj3rz53cpujrbtVcf1+
	b8I/CR9vmhgChM0yrDbrOVdwBBPqY7/7Qug9X6F/ukcmTH3lOYnFpCdX
X-Gm-Gg: ATEYQzzQKi0lZK1aOv4GxT2JlAhnkEYeY1r/TA8Z4AW0tFGh7THO+wIUuFtuo2lS4rR
	rOAWUN8hrvDMe8hN+UUZ/Z9enpGqwKr+B8Rsw4RQSMBOTXEjCyawdkZ1ZB5Ylk4aMBRKB/6URny
	qz/tVRgRjNKVQZXIxW6qd7OsqTuOOk3c3K/KPUS9lTsSGjhFknxIID0IKim10N3EFVeJQvw7KqD
	srIz8HBG89yOPmYFfI0xa5xggc4njijYuyrV4JbF2w7JBZ2XoJFdbLEQD4j2zhghupeqLXnrX1P
	SMNf0YIMYgMam/hn6s/0XykJCVbzQ7fi15jZbt3ZxkEhlwZpnFD7dNB5cJ4lo0adP/yMuIr6KdL
	cLhaxxVp+gDlNsleke2oQAquZXxXaUEurZOkXj5WcWIIBzm7P/x3ue1YmFJfuH93gM4bLIhj+rV
	7Av94MTVZwykN4+RG9wVOF6/6TH6K1Pox6V6jQYJ9Y1K5I3yD47m0=
X-Received: by 2002:a05:6a20:7352:b0:398:b16f:7058 with SMTP id adf61e73a8af0-39c4ad64abbmr2830633637.40.1774423032398;
        Wed, 25 Mar 2026 00:17:12 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b0409f409sm14369493b3a.31.2026.03.25.00.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 00:17:11 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC v5] mm/damon: add synchronous commit for commit_inputs
Date: Wed, 25 Mar 2026 15:17:09 +0800
Message-ID: <20260325071709.9699-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260325025317.86571-1-sj@kernel.org>
References: <20260325025317.86571-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: u7fkqh4zz74swtzsae1amnt46ey5yjog
X-Rspamd-Queue-Id: B2860C0014
X-Rspam-User: 
X-HE-Tag: 1774423033-391316
X-HE-Meta: U2FsdGVkX1+XfxaXVPVmckpiNSfmTj8EaQoz7PKqTdx/fp4uDtgNJaxjDnTd3Ht5r1eYufE0G+vB327XLrIWebUwwSyXxONvcHwQiHjkGJ2uCWQ2Ml1gFgWyl2z9HfkHlAIr/DbnwYvWUmyvuGvy7ekpsC3DrzaW2Ay1I0sW0JMEPguHPsiqmzZD71keDgSQWNBZtphTIGss5KGD+RVNI5pB+zh/hwcwpNMEyTXzuYjhpDttoSv4MO9NToaGROVPC8DLGyIVLrbEyqgbUeQ4/uI6i6c/GRj4E27O7MF4JH4kqzGraAigxl7pcSD/0Xow12c9/jGkoY4ZQoobW+pR+Y7TBU5jiEBd0dcN2pFlDGDh/IJPSAMkPymSn93sKT0AUxWp/iXX9F509XMk5ZeKcpP6RhUYpm9/Jv8gwMfnEXR9yozODZsbblwGwBdCELr2z1JmV3idJkRVqYjVj8DdwCVFbXErSVHFTcKL6KbAK47oMgrCJDhECmxgdgwuZxJc7etM9K2wEWbIkjKl5eTGAT0g2zz3QevUIggVx9tHeowob5ikrZqD68IYVwtXUGK6u1w0MAZ5j++jHMq0oextr8Iw+Y4lvFNDcjwXkjLtih16T1s2j34vsKwq7y25DFflU4hAgP+FPYAF/CZIKAK9hhzmLI4rYIfmQgiYMIQ3zMSEiT0/Ts5Sj5KK10xG+qiVwOwGmHHVSJpH4KpOpldpFURVvgcz9fNN54rsIr4yKqs6REvOovrTou9rER/9RQgqJTFNDSGEB+0mfKhk/0xa1oRKykhsmSNf3rDmVBbJkQuiCCcbw6ahOdVbaFwrjBm6m3djXCmZ862Wq68UP5SsjWUI4w3oG7c62TN5DSXmM0dli0phKgANn5t/NU3H2ZH76btnsqPJU/Pf0rwBDMq92ZGXf4KZvxCrwm2MkyC3z4k9lULrZhSwCo+coLkzix2Vu4u1h2OAZpcHD8zTBAB
 bwnRkivf
 6HIGLnnHovIhKzvbp5o9mNHeKNDWUJKqvsLxR0XshDSRWwNxvDiITCbVR+uel7qjrx6aCe24iHGmprl88ESgKmLNzE4pGpszxWoiH+iVPTxjDvgDWe9BAOcKolpmQnyS0499ypnl1Ve9iWt8LmE8i/3rvx1GLNsUvnH1oVr0i8nYnPnuTMJDS5q2+F9iez+S78dB4us9fUN1tqcCGcJ1nHtgyhJzQo2xAxa1jMbwKRx9yjIfVIIwL1stEjkdE+NvqNHfVTRlLlY6VKy1P70MU/nqmcQKfmKAf8Dy61SwgpjcHZ/7dneLwyHQ2noht9hQUHRxmeHDpsyKyqNwRzvJIUsZiXk6QxQxY8JHsV/nFyEEJWu2fVbNl3s/ObT88Ci/l+OmqHu5q8G9Y2r+WfHBKsWu8hD5z8Z43vpvwZzKJKek4RpDe+JQb+7GPzTpjWeVViIbHLjafBWPJgnaopENu8WJhn+NZm97snr2ifFxvi//kRHch24aAJVBGPgDeGyeUBOunMx4BHxsschWHUdcxUTQCrpVkvlg0+GkkMOTiPqr3qC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260325013939.18167-1-aethernet65535@gmail.com
> # start of sashiko.dev inline review
> commit 60ccea4154b0c58741fae2323454a5a9496b67fa
> Author: Liew Rui Yan <aethernet65535@gmail.com>
> 
> mm/damon: add synchronous commit for commit_inputs
> 
> Writing invalid parameters to sysfs followed by commit_inputs=Y previously
> failed silently. This patch uses damon_call() to synchronously commit
> parameters in the kdamond thread's safe context, returning validation errors
> immediately to userspace.
> 
> Link: https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com
> 
> > diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> > index 554559d72976..a2410f648b51 100644
> > --- a/mm/damon/lru_sort.c
> > +++ b/mm/damon/lru_sort.c

Thank you for forwarding the review from Sashiko.dev!

> > +static int damon_lru_sort_commit_inputs_store(const char *val,
> > +		const struct kernel_param *kp)
> > +{
> > +	bool commit_inputs_request;
> >  	int err;
> > +	struct damon_call_control control = {
> > +		.fn = damon_lru_sort_commit_inputs_fn,
> > +		.data = ctx,
> > +		.repeat = false,
> > +	};
> >  
> > -	if (!commit_inputs)
> > +	err = kstrtobool(val, &commit_inputs_request);
> > +	if (err)
> > +		return err;
> > +
> > +	if (!commit_inputs_request)
> >  		return 0;
> >  
> > -	err = damon_lru_sort_apply_parameters();
> > -	commit_inputs = false;
> > -	return err;
> > +	/*
> > +	 * Skip damon_call() during early boot or when kdamond is
> > +	 * not running to avoid NULL pointer dereference.
> > +	 */
> > +	if (!ctx)
> > +		return -EBUSY;
> > +
> > +	err = damon_call(ctx, &control);
> 
> Can this sequence lead to a system-wide deadlock on kernel_param_lock?
> 
> Because damon_lru_sort_commit_inputs_store() is a sysfs .set callback, it
> executes with the global kernel_param_lock held.
> 
> If kdamond_fn terminates (e.g., due to an invalid parameter like addr_unit=3
> causing a non-power-of-2 min_region_sz), it processes its exit sequence by
> calling kdamond_call(ctx, true) to flush pending requests. After flushing, it
> eventually sets ctx->kdamond = NULL at the very end of the thread.
> 
> If a user writes to commit_inputs exactly in the window after
> kdamond_call() finishes but before ctx->kdamond = NULL is set:
> 
> Thread 1 (kdamond_fn):
>     kdamond_call(ctx, true);
> 
> Thread 2 (sysfs write):
>     damon_call(ctx, &control);
>         if (damon_is_running(ctx))
>             wait_for_completion(&control.completion);
> 
> Thread 1 (kdamond_fn):
>     ctx->kdamond = NULL;
> 
> Thread 2 will sleep indefinitely in wait_for_completion(). Because Thread 2
> holds the global kernel_param_lock, this permanently freezes all module
> parameter sysfs interfaces system-wide.

I have verified this behavior with the following test case:

    # cd /sys/module/damon_lru_sort/parameters/
    # echo Y > enabled
    # ps aux | grep "[k]damond"
    root   70  0.0  0.0  0  0 ?  I  12:16  0:00 [kdamond.0]
    # echo 3 > addr_unit
    # echo Y > commit_inputs
    bash: echo: write error: Invalid argument
    # ps aux | grep "[k]damond"

    ... kdamond has exited unexpectedly

I will add a patch in v6 to validate 'addr_unit' in addr_unit_store() to
reject non-power-of-2 inputs immediately.

> > +	if (err) {
> > +		/*
> > +		 * If kdamond is not running, damon_call() returns -EINVAL.
> > +		 * Remap it to -EBUSY to better reflect that the operation
> > +		 * failed due to the current state of the system.
> > +		 */
> > +		if (err == -EINVAL && !damon_is_running(ctx))
> > +			return -EBUSY;
> > +
> > +		return err;
> > +	}
> > +
> > +	return control.return_code;
> >  }
> 
> > diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> > index 86da14778658..4cbd67e08d56 100644
> > --- a/mm/damon/reclaim.c
> > +++ b/mm/damon/reclaim.c
> 
> [ ... ]
> 
> > +	/*
> > +	 * Skip damon_call() during early boot or when kdamond is
> > +	 * not running to avoid NULL pointer dereference.
> > +	 */
> > +	if (!ctx)
> > +		return -EBUSY;
> > +
> > +	err = damon_call(ctx, &control);
> 
> Does this code share the same kernel_param_lock deadlock potential as
> damon_lru_sort_commit_inputs_store() described above?

As we discussed in the RFC-v4 thread [1], this is a false positive.
Since 'enabled=N' and 'commit_inputs=Y' are both serialized by the
global 'kernel_param_lock', and kthreads cannot be forcibly terminated
by userspace signals, the completion signal in damon_call() will always
be reached in a controlled manner.

[1] https://lore.kernel.org/20260323021648.6590-1-aethernet65535@gmail.com

Best regards,
Rui Yan

