Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E82F0F4613C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39B8E6B008A; Mon, 23 Mar 2026 11:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D046B008C; Mon, 23 Mar 2026 11:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262696B0092; Mon, 23 Mar 2026 11:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 157626B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:12:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ACF7F8CEF3
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:12:42 +0000 (UTC)
X-FDA: 84577669764.04.3340061
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C36D7100002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:12:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BkR3HS+A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774278760; a=rsa-sha256;
	cv=none;
	b=yY2yaNys73cQeYUwd3zNPMLSRzmVUYQqaXtW9b49U5EEt6mbQWyVc65BjWFQ5QBt0hRud2
	EzmOp3HwAUjpkk+URQvv60U5Xkj+sVFn+v8wMNLHW+L3XSWYtqkYZ1x+bM1r37BgbAVUua
	eFceag9v43tknQ56W4BqaEvTQRDHNmI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BkR3HS+A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774278760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LpVpbh00EMkThamoRttDtYXhalfrwcmmdadJ3W2nJ3M=;
	b=MNfztRCV/FEekHZldYzX4tgnJ2skV8293OYPR+Uy1Pg7e92E3p0mMn9GW+4jUf1Nwblhj6
	8dacjXsrnmRq4rc2qwbyzeiRA2xG9v2ZGlkK5vssNp1cdjqtr+oXbbTP8hU0qzSzQ0fGY+
	UQNS1xRQFKh6mvA7XOPsGGgWLWSeDLc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C94760132;
	Mon, 23 Mar 2026 15:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA42EC2BCB1;
	Mon, 23 Mar 2026 15:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774278759;
	bh=tTzRD/5QdlyRLK1EtxLTVvBj/l5amHALku8Zl9jmQbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkR3HS+AVrNHpExi/W9v183XJhT6bwxOhbYxlPexeP61pYQIj6VSeywhv73F9cm2V
	 lyilDUDeffB7xJ7CBKo26VAbv+TT3HIKx7SlbLEV8ywMEFLxJws3SOgVP+Ymw+i7q5
	 xY6YuIbxYN4XH0ON2bJ1imCg3HoFGUJfcKHaW7dqX7gmDkc4gxYEGmuIJ6Ap8HGVcA
	 OBRpnbvPeM40ILQX+Yz0MLeaybV1lks9n0TKJaswlZUKewVbFgrf1QIyk6PJXbfUqj
	 McRZmsS6mm3OM0i7Brv5HBwzt06KFiun6Au3tYRMp9i3wkvNF2urQWRn35UsxTQZU/
	 AjRgNGadSFEoQ==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC v4] mm/damon: add synchronous commit for commit_inputs
Date: Mon, 23 Mar 2026 08:12:36 -0700
Message-ID: <20260323151237.81224-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323072724.15942-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w9dsuagdnfahozwzgi3nfe8prdtafxie
X-Rspamd-Queue-Id: C36D7100002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774278760-269178
X-HE-Meta: U2FsdGVkX1//5M95KIf35cmFu9P4jiXEwRZ2dZ1078wFZBo/24Zs7IMlqlz1vFK+2PtdB5/xWTqJh7hN6CG4W5fi4crCtJGPwujhm2FeTx76XhbRp+68bAaKoXsZYzFxTnGha8J0i6OQVEtlTZQJqN1wIvQCvxLZeZnUXpqrOPfkxAM3xyr0Aaj2VykAUOOdKtO6IVvvI8p0MzrbAD7/wS8SDbW2DgHiSVavQ0d+YLzcYuyXNnjgsyxHTwITyLfP4/PRXeULho7ArFWSFmBrcnU9hFrgNC0uzxr61bR52JmudZ0C9oibsoUTbS0oReo7mZMyUYE1MGvPV6RKyKiyeWVY+7TZZ4tR25A7kd1iDyLvph2vdD6tJQcWVXp3Pqk/6vbR1M7xmqhLb9eYOXdp6Rmn0k581yYE8c8J5jiUIpxNrzIwYAMysNAG9gVdAFBA+Z1pwNpbA0Au512dnSuagN7DQyyEonIkZPpKoMNcZCc82+vyWXeL0ZnFjRytIZCDCgg/WH9B6F/RtMdBhcpV4TOaK9la9nmUxaRYQqI5h2E1jAtSuc20rFXdKuV4sp1k4Hc4XqtdYzQnY0tY6REGqL8EU+b9m5vyt8uWhySZHY1oVaaZ6iqvNWMI6Xza9XmBs8sVwmhe67APx5UfUbAiHv7K8S6O39QD4HD3BqlngnFdEotQeczNRcLSDcAx4ZdTzHYGGoDXADeoHCkxrP61azZInH7urizu+h1qFxeyITTu7A0F/atsErnDW0Q0jsaXeHj+GrTtASEGWEk79XBLS0XYYXqv5ZxZnLkLjMv4mhdBI0HgWHjFtx4pqoSswoxbQy+wg5KpCDVEpz+0sDuriLxqe0HK2D8eH4HNBM38XB1B1HSKPc0dnwBljEQcvURCJb9uVDQpjQbixSWQMjN8HkVr2dfUClJdEneThDbmiXnet/KjosGTSb/f5j2MoCCGIur0Is12jO0oUgRBtEF
 MmutTOnn
 GvZ6FquJJFOQ9nNisLzrY17JPhzz7DNqChe2jdS6ZWIWXokoGqG+spSk/W/Alg4nsuYvj5mMgkAk6mPag70Qlft4phin6tZMAyg8ju81TPC/NjY8vJPVZVZyQMuXrlpEzwyJXrAdUlJf94V1FVaetuPX34Kk4MVhEV7yHmeNs8Ah49uSjFpaNUP47uwEd+KIyqG0VMoJkL1N3k8mrNeNDnwwjFjHE+Pgxn0QrHNPySZqQ/axucrAwnxUa+3kBSZJWZuF4QbXjmNvqlT30PXU2JDPi7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 15:27:24 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> Thank you for reviewing this patch. I'd like to address the review from
> Sashiko.dev [1] and ask for your guidance on two concerns.
> 
> > > -static int damon_lru_sort_handle_commit_inputs(void)
> > > +static int damon_lru_sort_commit_inputs_fn(void *arg)
> > >  {
> > > +	return damon_lru_sort_apply_parameters();
> > > +}
> > > +
> > > +static int damon_lru_sort_commit_inputs_store(const char *val,
> > > +		const struct kernel_param *kp)
> > > +{
> > > +	bool yes;
> > >  	int err;
> > > +	struct damon_call_control control = {
> > > +		.fn = damon_lru_sort_commit_inputs_fn,
> > > +		.data = ctx,
> > > +		.repeat = false,
> > > +	};
> > >  
> > > -	if (!commit_inputs)
> > > +	err = kstrtobool(val, &yes);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	if (commit_inputs == yes)
> > >  		return 0;
> > >  
> > > -	err = damon_lru_sort_apply_parameters();
> > > +	if (!yes) {
> > > +		commit_inputs = false;
> > > +		return 0;
> > > +	}
> > > +
> > > +	commit_inputs = yes;
> > > +
> > > +	/*
> > > +	 * Skip damon_call() during early boot or when kdamond is idle
> > > +	 * to avoid NULL pointer dereference or unexpected -EINVAL.
> > > +	 */
> > > +	if (!ctx || !damon_is_running(ctx))
> > > +		return 0;
> > If kdamond is not running, this returns 0 but leaves commit_inputs set to
> > true. When kdamond later starts, will subsequent writes of 'Y' to
> > commit_inputs hit the earlier check "if (commit_inputs == yes) return 0;" and
> > silently ignore parameter updates until it is manually reset to 'N'?
> 
> My current thought:
> When '!ctx || !damon_is_running(ctx)', we should return -EBUSY instead
> of 0, and keep 'commit_inputs' unchanged. This way, userspace
> immediately knows the operation cannot proceed, and there is no risk of
> stale state.

Yes, I think we should unset commit_inputs in the case as you and sashiko also
mentioned.  Maybe it is better to just keep its value always 'false', though.
Please read my reply to the patch for more details about why I think so.

> 
> But, this means that users can no longer write 'commit_inputs=Y' before
> 'enabled=Y'.

Is this a problem?

> 
> > > +
> > > +	err = damon_call(ctx, &control);
> > The module parameter set operations are protected by the global kernel
> > param_lock. If the kdamond thread is currently deactivated by watermarks and
> > sleeping for the watermark check interval, could this damon_call() block on
> > wait_for_completion() and hold the global param_lock for an unbounded
> > duration?

It is bounded to user-set 'wmarks_interval'.  So I guess that's not a real
issue?

> >
> > Also, could there be a race condition here if the kdamond thread is stopping?
> >
> > If kdamond_fn() flushes pending calls and only afterward sets ctx->kdamond to
> > NULL, could damon_call() insert its control into the list precisely in this
> > window? This might cause it to perceive the thread as active and block on the
> > completion forever, deadlocking the param_lock.

damon_call() handles such cases using damon_call_handle_inactive_ctx().  I hope
that could work for this, too.  Liew, could you please double check?

> 
> I admit I don't have an elegant solution yet. Here are my current
> thought:
> 
> Add a timeout to wait_for_completion() (e.g.,
> wait_for_completion_timeout()), using 'damos_watermarks.interval' as the
> upper bound. This prevents indefinite blocking of 'param_lock', though
> it still holds the global lock for up to several seconds.

Because it is already kind of timed out for user-set 'wmarks_interval', I don't
think we need an additional timeout.  Please let me know if I'm missing
something.


Thanks,
SJ

[...]

