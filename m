Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 036CDF483E1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9DB6B0005; Mon, 23 Mar 2026 14:38:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A20E6B008A; Mon, 23 Mar 2026 14:38:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8146B008C; Mon, 23 Mar 2026 14:38:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 497CA6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:38:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBF7BC39ED
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:38:14 +0000 (UTC)
X-FDA: 84578187708.25.F7977E7
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id C6A3F180009
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:38:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TPnhsG4Y;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774291092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9VpMu8BW02kfasuQLNMIW88lcfKKCHzNKLRC8iN9hLI=;
	b=IevR3A6Q0TXDur3IrJHcYlOPWeSaA9c+8vHXbsQ53LAjsTl8p3hfOsNCqcKTCM9GQIYcOO
	xofe95gWvVrrpILEsuYpN48gHVlT8aIXB78sFIdtW49EKJSzaG7gRx76NjqCxsaNYV5KbH
	MhF9CW8uGtDYCo8EK8eoYDh/+uWFBHY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TPnhsG4Y;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774291092; a=rsa-sha256;
	cv=none;
	b=ioxju6tbRp0YlbJr9156XULGs8fNCjHyWJRg4B7uTB2a+AklFrpMOfbc+L+GphwDK549B/
	1/H/FDwWQyaipHDUTA+KRJCOCEpXfQh6vhvUEcbxlXLkrFV2Pd3tgJXtteqz4trF8x78XO
	uOn9ujFDvsKKJwlNGUl0tKKLbweivxw=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35a094cc3e9so3095413a91.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774291091; x=1774895891; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9VpMu8BW02kfasuQLNMIW88lcfKKCHzNKLRC8iN9hLI=;
        b=TPnhsG4YB94H2iAK/NUug0w2kPausz1FVQwfsmFKgJwWKETbKcPCBVLAVkZlkJJuCR
         oqToHHq898DjP+jb6/mGa4nFe4x2lmkIp/CyDyFZPBvrcQzKrstw51Be6On0xtfdQ0Lu
         sfi7MqB7P3iLvWxuxaxGM6HTs0CRhHrMORgLXqeLUT+m9DJlyppfEtilmup/c+A4nObh
         qrj+j1Om99MOnqJ83l0x35Otv1knLYMcquXBaVWzzDxsb8PX5a8dz9C22SWqK9qfhcVE
         GnLSJVkRCJkhJ5bHHEkpL7cajr9imemdNvuI3L7wKoVgo9BSFC8jGxiUEXWCj60pKfd3
         Sysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774291091; x=1774895891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9VpMu8BW02kfasuQLNMIW88lcfKKCHzNKLRC8iN9hLI=;
        b=qNg3vUqJjwN391E3H72m7Cd1gjes025vM/2u9WtCmbuJNqYLoKoednsVUCH0gfKtvz
         L37opfR7uJZyxiGEeiT4S8KcQ7I/8MlsyLppiHlmGxuiOrZ8yvjKLMbU/oV0UJJ09et/
         7GjbzOXNmj7jm/4VNjVXNOXwlWY0K/IbJdgk0JPWTH8dOD44dIILUfyUt/j1FodGMJEQ
         zCnHU646nSmsLUDZCvF8AUhvyXJPNN4gPMqf7RNGzp62AiXifnbAEmF7yBPXiLc2cF5C
         fcwN50GefSFwWpBZK/7vh738pombe2slW8GYaASEfUrzRV/lKLmUHCCSwvVjO8MOGTW/
         RFFA==
X-Forwarded-Encrypted: i=1; AJvYcCUmfO7bvDBmiyxxe9sqy0hgQlcCC6cQUKlUFm0Dk7A1Xop7BwT+U6AsETntP00s4gMxN8iuhADEVw==@kvack.org
X-Gm-Message-State: AOJu0YxT+ksCHq/ZuH53faOUXxEnJiYCyCj/72EIXo44Ba02J6blsXdw
	BsLLKaDsneRV4gWsGhDPjle9xbSVb+IL0e6WO0OtJpis9NdYsFAPt39L
X-Gm-Gg: ATEYQzxW6/m3Ysnp3R7O0mq9Mz5m+JGqu3iP7vhdUvu5Yozo08/KkbdhL2cGGFaHhly
	m9ehmJKmCdY4EoevIQEMAT6ELKIFhwPholi/3gJJa4HX825vOoUD+5cbvXu+z+XYcqdLCr3dW+7
	zD4Cc0gRneWiLwJ1IN3tNHLse3Zm8kuxr5NBaR/qygwMW1mMF1gIHSWYv1o8CM0PSI3B4uJF0Cm
	P6YHWzbyN++UduvB6tfojL/p9ifJsEkKDM72Ngpq9MwqC7zEqAQTtHDUgGcw+HrpD3S8BbFyjJi
	FNgD+lp1W3fCD92fpvQxElbCp6D0xq+HPNEUuFaPrushezUkxAFgpQt6WMDSe0bOxr+p/zakZf/
	MKznBj8UmHPgsUAm5bCphrA4jUkYK0NK5SfNJhCyW9MQrMOdy0yAyBGzmVdyueZyeAeUaQzvPuD
	dW8VNu25drtcVaGyHHQ08Pihv15iEFqUdcD1oy1w==
X-Received: by 2002:a17:90b:3d48:b0:359:8d95:4a4f with SMTP id 98e67ed59e1d1-35bd2d3b8f9mr10302435a91.32.1774291091371;
        Mon, 23 Mar 2026 11:38:11 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c017477eesm23164a91.1.2026.03.23.11.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 11:38:11 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC v4] mm/damon: add synchronous commit for commit_inputs
Date: Tue, 24 Mar 2026 02:37:58 +0800
Message-ID: <20260323183758.42138-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323151237.81224-1-sj@kernel.org>
References: <20260323151237.81224-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C6A3F180009
X-Stat-Signature: b5mrcg4f8huhanyhwnahtj86jqt8wwpd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774291092-823738
X-HE-Meta: U2FsdGVkX1/KwvuKRCNtSDEC38wpOfDn3m67K2cKzQI4FsieqVjvjMlRgBqmfWLVFgs1VtcuDaAZgDCNms62lOT2i//sgkSXZu+qi9w11nBsdhn3cJtgCMf7HbZB1k+0p6tNdQmEnDaBR9ozQrXIXtifAWnm9Oz1zlv9vBOW6wKeZ+EAXf/ochwJ/Ucrv31hgkb7rW/AVrNDvHVJfCDR/quCwGjezkOojzB/uYdMyrsuFKXHgp1cE9tgFmioBEY9Nv0XeQrxP0EMhqlkUa+iyIKp0DEq9cZXiovbeKip0fTMGx6fxH6ljcuTZaXbLAddDST38pqjeQZ7wGipKBSUZVcvvBUdDuY6ylmzh43Qx63TfIzoXOvlK/NfsXmqdEr5TiXSE3Aai3edKBLrc5cASGFhJfDrtZgZb4/Ks/YCnMIxRNTJXyfvGQdS6NlXjvBt5QMnpisNZG+e5aovaIj0JFH0TJoym7vx0HDOAhr/TxNCHEnDndp76QI9Ib0IdWP3EF7d5K2kt3fe5vCV1QvL1fWiTjG9H0rquA906c/7tYi7XSMw7eICrZDJXoKl5+/Fzi8dSu6Tea26A60VCFObMH5xxM+xvCUeJcufM/7dA6NPrMEdTA5Y/osjbj63f1JzU4GG7qEcHL188uLuY/UzhoUxw995OiN4Lt6OrIjkc7UnmSfkm0i3xPQFuSL8MrTcLiUEjqfp6geg4udNVAkRaOx3LliJUjbA9HyfLySwqtpS2LiVunWfO1Ka78X98YlgeGqkNdHXxNrdasdqdwanU1U1BiV4n6NYLRociUHxgG0xlw6Dq7nwaIbYYV2IzcOHbUzqwfsvBK1IutNoeywvNpxXScR/oPOiQfVDMPWyrmm+opNx9Q4iQdfRl93UGwnQuytbPYTIVRr4C6gTgpEAvpGgPynaiSNQuKWXGo7SrEeHwS52yOJhAUQjohseYMyxzggLn2n8cKfdJgiKC6Y
 XzRnZT7P
 sFfJuoicqEppRk6AqYoBTIFkv1UgEe+RlQleM8rEY+d+PSWfPBuv+wXGAeufVWCqdYPqGUStnBn0lHHzN5pCM5yZcQdyplMcUYSmpkQn57+uL/yZtRdcVvvhKfxOMp4D+rj8cChxz3CKRkh7/XRTgT7B2c0+KzYJ6Rbbm3nMEQIbDAmb8E/w0O/JTP1YOxRWr2pzk4m2e4M3Ifp60texAwMiNUEA0+2bI7Wk+ohNsKcctY7G/PXjGkHqlSglJ/wL2MRRzbAFEC+quHv1vSkbb98Rwawm0fMGXHNOw/MJe58qAHidpwli+DX7AbCyVK67Wl3AQX1Cvv4XwpOoPlhCXe4jULlpWXYmiip0U+ACguqcTuV97t2QVz4KjsUEty045cGCdzDQAeowm83niVUubanyCiS/8/fB9YIjkmS8lvke+mc19KLZQmjOciQMk1r512NKC7JysuhUPzL+NdOHm+5Nu9t6En7vznrTM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Hi SeongJae,
> > 
> > Thank you for reviewing this patch. I'd like to address the review from
> > Sashiko.dev [1] and ask for your guidance on two concerns.
> > 
> > > > -static int damon_lru_sort_handle_commit_inputs(void)
> > > > +static int damon_lru_sort_commit_inputs_fn(void *arg)
> > > >  {
> > > > +	return damon_lru_sort_apply_parameters();
> > > > +}
> > > > +
> > > > +static int damon_lru_sort_commit_inputs_store(const char *val,
> > > > +		const struct kernel_param *kp)
> > > > +{
> > > > +	bool yes;
> > > >  	int err;
> > > > +	struct damon_call_control control = {
> > > > +		.fn = damon_lru_sort_commit_inputs_fn,
> > > > +		.data = ctx,
> > > > +		.repeat = false,
> > > > +	};
> > > >  
> > > > -	if (!commit_inputs)
> > > > +	err = kstrtobool(val, &yes);
> > > > +	if (err)
> > > > +		return err;
> > > > +
> > > > +	if (commit_inputs == yes)
> > > >  		return 0;
> > > >  
> > > > -	err = damon_lru_sort_apply_parameters();
> > > > +	if (!yes) {
> > > > +		commit_inputs = false;
> > > > +		return 0;
> > > > +	}
> > > > +
> > > > +	commit_inputs = yes;
> > > > +
> > > > +	/*
> > > > +	 * Skip damon_call() during early boot or when kdamond is idle
> > > > +	 * to avoid NULL pointer dereference or unexpected -EINVAL.
> > > > +	 */
> > > > +	if (!ctx || !damon_is_running(ctx))
> > > > +		return 0;
> > > If kdamond is not running, this returns 0 but leaves commit_inputs set to
> > > true. When kdamond later starts, will subsequent writes of 'Y' to
> > > commit_inputs hit the earlier check "if (commit_inputs == yes) return 0;" and
> > > silently ignore parameter updates until it is manually reset to 'N'?
> > 
> > My current thought:
> > When '!ctx || !damon_is_running(ctx)', we should return -EBUSY instead
> > of 0, and keep 'commit_inputs' unchanged. This way, userspace
> > immediately knows the operation cannot proceed, and there is no risk of
> > stale state.
> 
> Yes, I think we should unset commit_inputs in the case as you and sashiko also
> mentioned.  Maybe it is better to just keep its value always 'false', though.
> Please read my reply to the patch for more details about why I think so.
> 
> > 
> > But, this means that users can no longer write 'commit_inputs=Y' before
> > 'enabled=Y'.
> 
> Is this a problem?

No, that's not a problem for me, but I think it might change some user
behavior, although I don't think anyone relies on that behavior. If
you're okay with it, then that's great! :>

> > 
> > > > +
> > > > +	err = damon_call(ctx, &control);
> > > The module parameter set operations are protected by the global kernel
> > > param_lock. If the kdamond thread is currently deactivated by watermarks and
> > > sleeping for the watermark check interval, could this damon_call() block on
> > > wait_for_completion() and hold the global param_lock for an unbounded
> > > duration?
> 
> It is bounded to user-set 'wmarks_interval'.  So I guess that's not a real
> issue?

I also believe that this is true.

> > >
> > > Also, could there be a race condition here if the kdamond thread is stopping?
> > >
> > > If kdamond_fn() flushes pending calls and only afterward sets ctx->kdamond to
> > > NULL, could damon_call() insert its control into the list precisely in this
> > > window? This might cause it to perceive the thread as active and block on the
> > > completion forever, deadlocking the param_lock.
> 
> damon_call() handles such cases using damon_call_handle_inactive_ctx().  I hope
> that could work for this, too.  Liew, could you please double check?

I have read the implementation of this damon_call_handle_inactive_ctx().
It does seem to avoid that issue.

> > I admit I don't have an elegant solution yet. Here are my current
> > thought:
> > 
> > Add a timeout to wait_for_completion() (e.g.,
> > wait_for_completion_timeout()), using 'damos_watermarks.interval' as the
> > upper bound. This prevents indefinite blocking of 'param_lock', though
> > it still holds the global lock for up to several seconds.
> 
> Because it is already kind of timed out for user-set 'wmarks_interval', I don't
> think we need an additional timeout.  Please let me know if I'm missing
> something.

It makes perfect sense. I believe there shouldn't be any problems, since
both 'enabled' and 'commit_inputs' are protected by param_lock.

Best regards,
Rui Yan

