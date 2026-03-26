Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0197109E54B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 06:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5A186B0005; Thu, 26 Mar 2026 02:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0A716B0088; Thu, 26 Mar 2026 02:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8FA6B0089; Thu, 26 Mar 2026 02:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9D9A6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:16:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C03D13C0C1
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:16:01 +0000 (UTC)
X-FDA: 84587203722.07.6FBD343
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 68A042000B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:15:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="V0G/376b";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774505759; a=rsa-sha256;
	cv=none;
	b=ssyEudAKJMKSu7ci2BYESLfbyZXXm+Fn5M3GWCNvHSvrYC8edLxDJPhtBSqDxIIMnUT7bp
	nsWJ0yBRwXigOWU6jl3zMYuygDfrZcTH2cb0i92qxLn7QkO6OReXPDkCkwP9cczT4WPxaU
	zgqARZBbdBHSrcHbUBpynbgcA0JfJdc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="V0G/376b";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774505759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p21EOSSnCFy71Fyv5uK3rPcnOtTcDDpnl2bD5vJEsTA=;
	b=OgMxPS0T1L3tdCKlaChREJv58ztbxB4LoMfSGuw4oU1R6R+3yqmtqtsdVUbaD/xxdplbm/
	nxZ/7uIV2AjRso7P0ri3L0iWrAm4hXxF0t68/wtSlu2lMctNPdMKZsMjKtZZwsl/3TaGfc
	eh2xgNjfBomnPTTjtKqsf6T6iyXlNuk=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-829781b2b01so374597b3a.2
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774505758; x=1775110558; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p21EOSSnCFy71Fyv5uK3rPcnOtTcDDpnl2bD5vJEsTA=;
        b=V0G/376bxxw2D9fAMkto55Cj7bpODd1VY/yqXwRcSxScyp4+pHAC93c6PVAUcUQqni
         tx4VvRcFkxj1P6inNUqvkXeYSPyS0IQYhth8iuuo28Ss+RohnhZJtF8uV1hPZxt0vPz2
         2JlXPP9hKmwvSOwSSRuAoB+Q0IverDlIQ1IRdoWi1+l+aiTo/1SCUEds4sH3fRMKMEHb
         /cjkAiAobbVOu4/JbjCt7Ysows/8ccr5guFjDq4fnqjrafQY6A/eJgfj3s/fcZuroDfF
         aqWDc4vym8FH80qCxMG0cXyY5AYzFciMGvkYA7BLMtyfQwyJBatIraKzsbh4pNngOr4C
         oH1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774505758; x=1775110558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p21EOSSnCFy71Fyv5uK3rPcnOtTcDDpnl2bD5vJEsTA=;
        b=DhJj8hMyUtrKmxEu8AGRrcgCYNAaSAyZHVwLReLtnyYJgH788bOLYR4BtGXgm18Mde
         OfUvb3gJ0T17xjRi7lLWxy4h8GDPfVLfsDSQuiFj/3dUaG0j1ei4DUMe0XWGV6aJFBtH
         kuBHyo85+oe3Ghl1nG8t9vv0UzeltOxAt0vXNd/GVvUVu/lKPziBj9y5VxZjh6yO8XJZ
         1tmczar5D2hexp8XQP051bs/OLAcCKjgLJMlpQh/TE//AqUT594qhsO+FIpL+BYNlEll
         Q0fDF7pGbG7V5zG28GMTDOjSTS4AhNxmSx5KKhWUxKJbTy5FHIiwXlKaNSDAjGttPl02
         PCzw==
X-Forwarded-Encrypted: i=1; AJvYcCViRTiuz1Cu5lvFDvD3MymWc+VVl1g2dHTkd0umSJAV6bkKLjiKSYmrE3qdhtmcMzpU7Mjzy1oYYQ==@kvack.org
X-Gm-Message-State: AOJu0YyKnoTlBfzg7Nj6Fm5/f5Bbt/YJQZlI5hShXwuDRNJuU2JmYpV8
	w/5/Ms7tusmIZO4A/2G6JGs2ddl8F0DbVyArka7HxODvxpDoYJbH14Dl
X-Gm-Gg: ATEYQzxmT/VdBcpH3x8qHotOVxmiWO/fHtyqj+T7+37R60HSHr/8fT2I+N74uy5wgyR
	kI5/wSxq/sE1jOhGgdysmI5JagXpP2Rpjfuitg/Hd++CWctlnw7Pv7AfyEWMPnyo32Y90zxGqdh
	V0e4HKkmFM7iyQGxczIO/xbSHJWTf2wQ+DSHfMswQzQMCWBV8msS5UgS3/KQg3LagywN8DA97oX
	w1KSbWOofi3JOMcpCrxJBH7SZtZweqrEHQ9HvfRpsK9Mbhdkkc7fdhTVoERg/iwVlaUBaMMS9KY
	ptEVlW29gpgg65U6y37DEo3Q5zcRbzmdgxLLyDR2X8vzOhTdJCQR9GmdQOW7gqP+hUgkq9YRr7a
	QkWgwfEG5HlxNn6vf7R3xdZybonF7LTrV013arF8V1iE/raag+IySUoSMAc0SmCsdqoyV0rsG8d
	KuMiXNAnHTejpyKhoivQs9nD6S0sm2pKJUKMNozxN4sxJw63cwE7s=
X-Received: by 2002:a05:6a00:1408:b0:829:803e:6798 with SMTP id d2e1a72fcca58-82c6e11bbfamr6279168b3a.56.1774505758063;
        Wed, 25 Mar 2026 23:15:58 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82c7d3bedeesm1482240b3a.42.2026.03.25.23.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 23:15:57 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC v5] mm/damon: add synchronous commit for commit_inputs
Date: Thu, 26 Mar 2026 14:15:54 +0800
Message-ID: <20260326061554.20466-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260325141956.87144-1-sj@kernel.org>
References: <20260325141956.87144-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gcwd3u6mofj7jjd7uohswwm8hcxtnxrb
X-Rspamd-Queue-Id: 68A042000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774505759-233187
X-HE-Meta: U2FsdGVkX19pA7PMgVEY9NYG7ImaNM0Mkdqpyh4dr/IQc9vqqPt40fMeO74WzmVV3WgVK9rYqY7jb7TMGkBY5UmBwFBKoZKxr2h4tV5d3q8m56Oc4IAyF7YQAtR9fFqvzTG14T2lUoU1qZ+wSvk9dhDUsBIKbT6VwlACm9F4Wq4PL2LrZDHcsHhXT2vK98uWTwBMJquGxq3pmITvZQ7jsUa/kRduoTG19BVP4WxE/PcAt2qJN9DV6ufsaiAE81Nop19EbcGZ/sz3JFIjAaxY/skeWdtUBkLucLw62F8PwQt/xfrKu54BCm3jmD+4rgITvm/neb8epoZqiLWoqkLabGIdKkbCEoBjYFqfuz27jVMisflXE26b8NIb/JEf1KCpiYfxEOQvkSIkyeqf6YQMRzZj2PflHrMZ5SvdStAXii7MiOktTmO/46fYu4YO0ZA/8Es0013NmOmOjq3AR2fydHpOblyof/i9dAvPEZEh8eduvzOxhna2aAGruj/WRJ/3vGHYn1zVUdh0FqHIO4e7gUY/7GXQMNp8Txh4cn5sgeZDxrsDOaLpEjBgEfyHo0QrTfY064p/vRHg6hPxU3rTbPO93GQ/Ui3ivCimbgE4smk2h/F2iqoMuDwRQWCs2NHe9OM24sL4AM/H/8nS4RXJNe1qsfk50up4X21dZTIB/mC8gkxiEDpCBDtertCKYrPHR3cAfmQ0McWpjauvX1w/kvtd+jMp95PadU15+D0Sq9ljR7U0WbTqqMxOth9nyXq+lYASDcCWxlswSkTnUOdMfHToxdkFWKoWgAto7kTk8nTZ+KerQ0WFYk+UO+rEeOH9Hg1Fj6szSfRNwj9WM+juEh+vAEPUGoXjt5zSNsSu20cqytm8Dz4Lge9srENjj/pparAbTELp8dkBMjr1lVyYNJ/oW08U8RHWO1ax3JFtPMsqMWKdIYWSiY+ocfHmJbInHUnp6OIvnZaCDKdujVM
 09kKXGHT
 raNwdniFLnYOsGG4z0YQc9Luhcke2blcKrUDpVJwNW6u71ArfKpZT/61tjI+y5xbG+ba9xksJLifRHt4ioPmAm66TRRoNdBkzJ6esOAlS0i9eY+gUjYvYQlvXwjasR+9ZHmVy7WOoTczV8Tflg+U48sOoc58wUP8Svdg5ghM+ZmxiWAbvFQAkpi4tfGawHruOUbY29eOZx/wOuIYstH4sIl52siPJBulB4kQwl3pzcqfuSnYLqdAUO5KP2uoovqOmEF/p7hv7Tkwn1QcKsXLetHnM83wXerpD68u+2l86Th5+11weSIetbb9jom2nOkVQVV5kRoO8sCsX3GX5KAATCu+v6gwMDc/ksvPP7vW7j44W889ojgt3WqvREHfo3/5GSyt3YyMaBdxyRCCZkeH7yteUAUCua1EIOik/5vDSfDSQewdI7Cm5+PFCto5jzqb20+65aX++0bnhSBAw6XPahSS3rmpG+OpBLLiHa2HPo5wCodNDa6CdlgcJiUFkLwJj/dPo3YQTW36xNyxt6L+DVMWWYBCqp4EwlSeGepSke6t92IQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On Wed, 25 Mar 2026 07:19:56 -0700, SeongJae Park <sj@kernel.org> wrote:

> Hi Liew,
> 
> On Wed, 25 Mar 2026 15:17:09 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > Hi SeongJae,
> > 
> > > Forwarding Sashiko review for doing discussions via mails.
> > > 
> > > # review url: https://sashiko.dev/#/patchset/20260325013939.18167-1-aethernet65535@gmail.com
> > > # start of sashiko.dev inline review
> > > commit 60ccea4154b0c58741fae2323454a5a9496b67fa
> > > Author: Liew Rui Yan <aethernet65535@gmail.com>
> > > 
> > > mm/damon: add synchronous commit for commit_inputs
> > > 
> > > Writing invalid parameters to sysfs followed by commit_inputs=Y previously
> > > failed silently. This patch uses damon_call() to synchronously commit
> > > parameters in the kdamond thread's safe context, returning validation errors
> > > immediately to userspace.
> > > 
> > > Link: https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com
> > > 
> > > > diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> > > > index 554559d72976..a2410f648b51 100644
> > > > --- a/mm/damon/lru_sort.c
> > > > +++ b/mm/damon/lru_sort.c
> > 
> > Thank you for forwarding the review from Sashiko.dev!
> 
> Thank you for reviewing the review.
> 
> > 
> > > > +static int damon_lru_sort_commit_inputs_store(const char *val,
> > > > +		const struct kernel_param *kp)
> > > > +{
> > > > +	bool commit_inputs_request;
> > > >  	int err;
> > > > +	struct damon_call_control control = {
> > > > +		.fn = damon_lru_sort_commit_inputs_fn,
> > > > +		.data = ctx,
> > > > +		.repeat = false,
> > > > +	};
> > > >  
> > > > -	if (!commit_inputs)
> > > > +	err = kstrtobool(val, &commit_inputs_request);
> > > > +	if (err)
> > > > +		return err;
> > > > +
> > > > +	if (!commit_inputs_request)
> > > >  		return 0;
> > > >  
> > > > -	err = damon_lru_sort_apply_parameters();
> > > > -	commit_inputs = false;
> > > > -	return err;
> > > > +	/*
> > > > +	 * Skip damon_call() during early boot or when kdamond is
> > > > +	 * not running to avoid NULL pointer dereference.
> > > > +	 */
> > > > +	if (!ctx)
> > > > +		return -EBUSY;
> > > > +
> > > > +	err = damon_call(ctx, &control);
> > > 
> > > Can this sequence lead to a system-wide deadlock on kernel_param_lock?
> > > 
> > > Because damon_lru_sort_commit_inputs_store() is a sysfs .set callback, it
> > > executes with the global kernel_param_lock held.
> > > 
> > > If kdamond_fn terminates (e.g., due to an invalid parameter like addr_unit=3
> > > causing a non-power-of-2 min_region_sz), it processes its exit sequence by
> > > calling kdamond_call(ctx, true) to flush pending requests. After flushing, it
> > > eventually sets ctx->kdamond = NULL at the very end of the thread.
> > > 
> > > If a user writes to commit_inputs exactly in the window after
> > > kdamond_call() finishes but before ctx->kdamond = NULL is set:
> > > 
> > > Thread 1 (kdamond_fn):
> > >     kdamond_call(ctx, true);
> > > 
> > > Thread 2 (sysfs write):
> > >     damon_call(ctx, &control);
> > >         if (damon_is_running(ctx))
> > >             wait_for_completion(&control.completion);
> > > 
> > > Thread 1 (kdamond_fn):
> > >     ctx->kdamond = NULL;
> > > 
> > > Thread 2 will sleep indefinitely in wait_for_completion(). Because Thread 2
> > > holds the global kernel_param_lock, this permanently freezes all module
> > > parameter sysfs interfaces system-wide.
> > 
> > I have verified this behavior with the following test case:
> > 
> >     # cd /sys/module/damon_lru_sort/parameters/
> >     # echo Y > enabled
> >     # ps aux | grep "[k]damond"
> >     root   70  0.0  0.0  0  0 ?  I  12:16  0:00 [kdamond.0]
> 
> FYI, you can read kdamond_pid parameter.
> 
> >     # echo 3 > addr_unit
> >     # echo Y > commit_inputs
> >     bash: echo: write error: Invalid argument
> >     # ps aux | grep "[k]damond"
> > 
> >     ... kdamond has exited unexpectedly
> > 
> > I will add a patch in v6 to validate 'addr_unit' in addr_unit_store() to
> > reject non-power-of-2 inputs immediately.
> 
> That's because kdamond_fn() has recently changed to exit the loop if
> damon_commit_ctx() fails in the loop for any reason.  Refer to commit
> 26f775a054c3 ("mm/damon/core: avoid use of half-online-committed context") for
> more details.
> 
> Adding the validation in addr_unit_store() would work, but it could be a kind
> of whack-a-mole game.  I'd prefer doing the validation of all inputs in one
> place, just before the last damon_commit_ctx() call.  DAMON_SYSFS is doing so,
> by making a test context and try committing user input to the test context
> before doing that to the running context.  How about doing so here, too?

Thank you for the suggestion. I have now added the check
'!src->addr_unit || ! is_power_of_2(src->addr_unit)' to
damon_commit_ctx().

> > 
> > > > +	if (err) {
> > > > +		/*
> > > > +		 * If kdamond is not running, damon_call() returns -EINVAL.
> > > > +		 * Remap it to -EBUSY to better reflect that the operation
> > > > +		 * failed due to the current state of the system.
> > > > +		 */
> > > > +		if (err == -EINVAL && !damon_is_running(ctx))
> > > > +			return -EBUSY;
> > > > +
> > > > +		return err;
> > > > +	}
> > > > +
> > > > +	return control.return_code;
> > > >  }
> > > 
> > > > diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> > > > index 86da14778658..4cbd67e08d56 100644
> > > > --- a/mm/damon/reclaim.c
> > > > +++ b/mm/damon/reclaim.c
> > > 
> > > [ ... ]
> > > 
> > > > +	/*
> > > > +	 * Skip damon_call() during early boot or when kdamond is
> > > > +	 * not running to avoid NULL pointer dereference.
> > > > +	 */
> > > > +	if (!ctx)
> > > > +		return -EBUSY;
> > > > +
> > > > +	err = damon_call(ctx, &control);
> > > 
> > > Does this code share the same kernel_param_lock deadlock potential as
> > > damon_lru_sort_commit_inputs_store() described above?
> > 
> > As we discussed in the RFC-v4 thread [1], this is a false positive.
> > Since 'enabled=N' and 'commit_inputs=Y' are both serialized by the
> > global 'kernel_param_lock', and kthreads cannot be forcibly terminated
> > by userspace signals, the completion signal in damon_call() will always
> > be reached in a controlled manner.
> 
> TL; DR: I think the deadlock can happen.  But that's a separate issue.
> 
> Let's suppose the user writes 'Y' to commit_inputs, and damon_commit_ctx()
> fails due to an allocation failure.  The write to commit_inputs will complete,
> and kdmond_fn() will start its exit sequence.
> 
> The user can write 'Y' to commit_inputs again, when kdamond_fn() finished the
> last kdamond_call() with 'cancel=True', but before it unset the ->kdamond
> field.
> 
> Then, the deadlock that sashiko pointed out could happen.
> 
> The deadlock is due to the incomplete design of damon_call() cleanup.  And I
> think the same deadlock is already available with DAMON_SYSFS.  I will work on
> fixing this.

I really appreciate your dedication to DAMON.

> So the issue already exists.  But let's ensure the fix is merged before this
> patch, since this patch adds another exploitable path that can consequence in
> whole param_lock deadlock.

Should I wait for your fix to be merged into damon/next before I post
the next version?

Best regards,
Rui Yan

