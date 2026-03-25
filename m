Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE4FF1093176
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:20:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E25C6B0005; Wed, 25 Mar 2026 10:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193C56B0095; Wed, 25 Mar 2026 10:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3006B009E; Wed, 25 Mar 2026 10:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F35326B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:20:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C4EA71A0928
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:20:03 +0000 (UTC)
X-FDA: 84584794686.25.603C0A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C87C2140012
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:20:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VXnLPu+W;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774448402; a=rsa-sha256;
	cv=none;
	b=fGduiqoRGWCplegRKvsY+QooEgZjKy0oB9RfGuHN7MOB1lZlCRhu88gFMtRKDmBwwvW4zA
	JLOS9/UCBI1JKA+DHSTMdMB98KHDhQYw8CTqxqyyViuaPbCg7pSc7BaWNAEfBh8coUucAQ
	r3RYa1KXWlKiUkvDMt2z4l6L1RALxWU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774448402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NxIZr0TWAkATag8YPG0NGJNwOReE74Z4Ko+MGIbZZIM=;
	b=fZbGnWVx6vCcHU/lIhGPLb4zcd51g3ikAUKcjzzDkH4uZJEiDNj9HHtcLkfcK5LQ7YgtPr
	VD5OaUTPIJI5kgllakeMCQdpYM3zl7QJl7hn+eTUgtJS46vyd05xCagSepjsxF8j9KgmyD
	7GxojEhS6lYe1e7pDdPMIr2gyBN10MI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VXnLPu+W;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BF8CC40765;
	Wed, 25 Mar 2026 14:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CA8C4CEF7;
	Wed, 25 Mar 2026 14:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774448400;
	bh=q5VvioLDQTNcYBbO1nmeWlXQ6duaUHGdgXQqKoMkybE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXnLPu+Wm4eCAzSiDsSSlHCsRyCrKH1ygMQc7l+D0gDD7h9w1yusmvNHEwhEZxABV
	 OCXMvPeqfHEuCdZPgtBBsGhT2T2ZHRiqyWHsDG3qI4Or/jMKiqWjAsj5zsPXtkAADs
	 ffmkfJBdioOfVc3B+raHfbYhqa5Ttu3E0npkUWMSoazmzh+uHAlgrgQiUgTC036/oi
	 VLu4JCQvnSR6QHvs4oM4u6rWHSrM9uoDATi72/t13KQmHl+P8Ukuw8w8iZwoHHX471
	 fHcIUcabP5CqXv6Es9EVaAhNsAvvQlIusPe2kyJXFFv69YqnQupSXimj5ekjvLM2Tq
	 qdURwRi77wIYw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC v5] mm/damon: add synchronous commit for commit_inputs
Date: Wed, 25 Mar 2026 07:19:56 -0700
Message-ID: <20260325141956.87144-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325071709.9699-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C87C2140012
X-Stat-Signature: s8hnik1y44w4umwysr8chkii95ofgkfs
X-HE-Tag: 1774448401-667806
X-HE-Meta: U2FsdGVkX1+nv6jI0nMehvK+1qoV0WciCixJKNEqttL0zKta+zZduY3jEyqCHkShvwwPc/Yyj89EWxKbHvDL91dKexH3yz3yCZSIyflqyKFoFOAXZfmEPD/3/B0fRCbWz6CuZv7p4saxeh5YeLfv4iSQnqAWLr8EbjpqRNAkL1RjF5zMHCm8KJbdiXudY65xOD42h/h8q5Uy2CPnUy5jiDbzxI2qwrkeqdshoHFT4Rol5twVBlDvWweGielkpE85gOQIbJSLveaW7zbL4VrNZ5X8VQiKxtdgr5Bg906WBBFkdDGfrhQNYgFQRhJW0HCuYExvvDLwhM3v0msuiAKL7QYksJjE3d1x+RoExVxVqM1HQygJ5Dddm0DH3RJG0uUCKh1N1KNSS4SgD6Frhd4lT7muPH06TQSTWcOF5g8rUCoVpYpq2qDgJd9qaWcroQGEeK528gGKtycv1X8t/tYfkv5gS6jU8Nmc8ilOJtt9XkSEyToGPhAw+ZOa7PHg/MQtkSg0gp/CGaONDXsoI6smKvtSO+JdxijCA+vh/AIYXrENET8I5uHZkeVexZEWM+dRLu+6PdbcZq8b8mVpk5XOS9n8v2ZhCkgQ8XGm9cKAo5LnjS1DgBUQvLx6nw+/tlR3Oq1UI1F0s4TPwQL2g0kbf/FYPrx03QIfXvQZN/T1dSPsTLAxdvck0CgtU4eTKI0Atj5vCp+5JtqtKm9BUT00qWMy7S0zBT9ekbT89hXbR+bGlClLW/M+gP9/uOmrAG82ZqP8IFxGGq7G1f8bqjoxXQ7fJEQXodnkBBXWStKMbSUcuz1zIzcSV7NfjSq/5zMTXiWTxHJXLsw3dD1q7FEHTvUrZVm0oCOyGXyj6Z0cM4rkE3l0e72jCSEKaatpQaQ118WWHGV0sPhNA3fsjwCFXQ6HJmE0CEqsQGzzD3U7LHsm/RZtw2ZZwYy/ucj9SVU8fezUnluuceQQlosAEcL
 gdUh4O3j
 tJOaQCOoIvfl079LxzGfNab/aRH8f6rzA8HzND4VvyLOhF4zbeJmnzcL/83ZIGuAS2kMKm5wqFme2Qx/IoObtUCpsum2+xnX9APcRoAJwkCV2Hqi1rCwS9JX3SoeHKZcPpQt5+DF+C9ej6bVY2lay/GsbSuFqeAzb1vqzDJ5w9WaYwdWdPeMaw45tMHdRExlkIK40edD+CxsU8EJIHD16ijOzO3V4f4C8O30NLmdY5MvleW6GOUBX7Div+Z8oSxzZANiyMLezEzvd5bqKmCX7qcMzUUwFbQnN9cLKOIhnV/I8brtIw6amXZGah9HMIgGMfR2EczGHC9ZN8VKoSLyIjziY6xKFKhgSMrwaPWjf2LqU2Ek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liew,

On Wed, 25 Mar 2026 15:17:09 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> > Forwarding Sashiko review for doing discussions via mails.
> > 
> > # review url: https://sashiko.dev/#/patchset/20260325013939.18167-1-aethernet65535@gmail.com
> > # start of sashiko.dev inline review
> > commit 60ccea4154b0c58741fae2323454a5a9496b67fa
> > Author: Liew Rui Yan <aethernet65535@gmail.com>
> > 
> > mm/damon: add synchronous commit for commit_inputs
> > 
> > Writing invalid parameters to sysfs followed by commit_inputs=Y previously
> > failed silently. This patch uses damon_call() to synchronously commit
> > parameters in the kdamond thread's safe context, returning validation errors
> > immediately to userspace.
> > 
> > Link: https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com
> > 
> > > diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> > > index 554559d72976..a2410f648b51 100644
> > > --- a/mm/damon/lru_sort.c
> > > +++ b/mm/damon/lru_sort.c
> 
> Thank you for forwarding the review from Sashiko.dev!

Thank you for reviewing the review.

> 
> > > +static int damon_lru_sort_commit_inputs_store(const char *val,
> > > +		const struct kernel_param *kp)
> > > +{
> > > +	bool commit_inputs_request;
> > >  	int err;
> > > +	struct damon_call_control control = {
> > > +		.fn = damon_lru_sort_commit_inputs_fn,
> > > +		.data = ctx,
> > > +		.repeat = false,
> > > +	};
> > >  
> > > -	if (!commit_inputs)
> > > +	err = kstrtobool(val, &commit_inputs_request);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	if (!commit_inputs_request)
> > >  		return 0;
> > >  
> > > -	err = damon_lru_sort_apply_parameters();
> > > -	commit_inputs = false;
> > > -	return err;
> > > +	/*
> > > +	 * Skip damon_call() during early boot or when kdamond is
> > > +	 * not running to avoid NULL pointer dereference.
> > > +	 */
> > > +	if (!ctx)
> > > +		return -EBUSY;
> > > +
> > > +	err = damon_call(ctx, &control);
> > 
> > Can this sequence lead to a system-wide deadlock on kernel_param_lock?
> > 
> > Because damon_lru_sort_commit_inputs_store() is a sysfs .set callback, it
> > executes with the global kernel_param_lock held.
> > 
> > If kdamond_fn terminates (e.g., due to an invalid parameter like addr_unit=3
> > causing a non-power-of-2 min_region_sz), it processes its exit sequence by
> > calling kdamond_call(ctx, true) to flush pending requests. After flushing, it
> > eventually sets ctx->kdamond = NULL at the very end of the thread.
> > 
> > If a user writes to commit_inputs exactly in the window after
> > kdamond_call() finishes but before ctx->kdamond = NULL is set:
> > 
> > Thread 1 (kdamond_fn):
> >     kdamond_call(ctx, true);
> > 
> > Thread 2 (sysfs write):
> >     damon_call(ctx, &control);
> >         if (damon_is_running(ctx))
> >             wait_for_completion(&control.completion);
> > 
> > Thread 1 (kdamond_fn):
> >     ctx->kdamond = NULL;
> > 
> > Thread 2 will sleep indefinitely in wait_for_completion(). Because Thread 2
> > holds the global kernel_param_lock, this permanently freezes all module
> > parameter sysfs interfaces system-wide.
> 
> I have verified this behavior with the following test case:
> 
>     # cd /sys/module/damon_lru_sort/parameters/
>     # echo Y > enabled
>     # ps aux | grep "[k]damond"
>     root   70  0.0  0.0  0  0 ?  I  12:16  0:00 [kdamond.0]

FYI, you can read kdamond_pid parameter.

>     # echo 3 > addr_unit
>     # echo Y > commit_inputs
>     bash: echo: write error: Invalid argument
>     # ps aux | grep "[k]damond"
> 
>     ... kdamond has exited unexpectedly
> 
> I will add a patch in v6 to validate 'addr_unit' in addr_unit_store() to
> reject non-power-of-2 inputs immediately.

That's because kdamond_fn() has recently changed to exit the loop if
damon_commit_ctx() fails in the loop for any reason.  Refer to commit
26f775a054c3 ("mm/damon/core: avoid use of half-online-committed context") for
more details.

Adding the validation in addr_unit_store() would work, but it could be a kind
of whack-a-mole game.  I'd prefer doing the validation of all inputs in one
place, just before the last damon_commit_ctx() call.  DAMON_SYSFS is doing so,
by making a test context and try committing user input to the test context
before doing that to the running context.  How about doing so here, too?

> 
> > > +	if (err) {
> > > +		/*
> > > +		 * If kdamond is not running, damon_call() returns -EINVAL.
> > > +		 * Remap it to -EBUSY to better reflect that the operation
> > > +		 * failed due to the current state of the system.
> > > +		 */
> > > +		if (err == -EINVAL && !damon_is_running(ctx))
> > > +			return -EBUSY;
> > > +
> > > +		return err;
> > > +	}
> > > +
> > > +	return control.return_code;
> > >  }
> > 
> > > diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> > > index 86da14778658..4cbd67e08d56 100644
> > > --- a/mm/damon/reclaim.c
> > > +++ b/mm/damon/reclaim.c
> > 
> > [ ... ]
> > 
> > > +	/*
> > > +	 * Skip damon_call() during early boot or when kdamond is
> > > +	 * not running to avoid NULL pointer dereference.
> > > +	 */
> > > +	if (!ctx)
> > > +		return -EBUSY;
> > > +
> > > +	err = damon_call(ctx, &control);
> > 
> > Does this code share the same kernel_param_lock deadlock potential as
> > damon_lru_sort_commit_inputs_store() described above?
> 
> As we discussed in the RFC-v4 thread [1], this is a false positive.
> Since 'enabled=N' and 'commit_inputs=Y' are both serialized by the
> global 'kernel_param_lock', and kthreads cannot be forcibly terminated
> by userspace signals, the completion signal in damon_call() will always
> be reached in a controlled manner.

TL; DR: I think the deadlock can happen.  But that's a separate issue.

Let's suppose the user writes 'Y' to commit_inputs, and damon_commit_ctx()
fails due to an allocation failure.  The write to commit_inputs will complete,
and kdmond_fn() will start its exit sequence.

The user can write 'Y' to commit_inputs again, when kdamond_fn() finished the
last kdamond_call() with 'cancel=True', but before it unset the ->kdamond
field.

Then, the deadlock that sashiko pointed out could happen.

The deadlock is due to the incomplete design of damon_call() cleanup.  And I
think the same deadlock is already available with DAMON_SYSFS.  I will work on
fixing this.

So the issue already exists.  But let's ensure the fix is merged before this
patch, since this patch adds another exploitable path that can consequence in
whole param_lock deadlock.

> 
> [1] https://lore.kernel.org/20260323021648.6590-1-aethernet65535@gmail.com


Thanks,
SJ

[...]

