Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B123E8FDAC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 18:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AF416B0005; Fri, 26 Dec 2025 13:31:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75E1D6B0089; Fri, 26 Dec 2025 13:31:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E556B008A; Fri, 26 Dec 2025 13:31:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 532936B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 13:31:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E2B9D12ABE
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:31:30 +0000 (UTC)
X-FDA: 84262465140.08.D392936
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2FB1140006
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:31:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f07vnWZy;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766773889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FpKraR1HqSO0862MyP9tVKNS5zT3lo1Toy0Wqe7ZQkE=;
	b=YAfws0XN8+r8UWHfrj6ToYoofdTHYb6bUI8OS99j0c8Lmc1u6lxL+Pz6FVq+SeDhtAj4wY
	JUDShvtbDRWeKdEdt9yVKfywERyEvBdEoc/TvRpF4n60a7iSMrHgrzpqArBsp95ULOCco6
	XhuriwAIHMmd+9MGHJfWzaTHLuIclXY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f07vnWZy;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766773889; a=rsa-sha256;
	cv=none;
	b=CYhdVeQ0RrljPOz2bJyFZL1T4xICiDIuBXfCwnM+eNCnJDQ7kQXLfqxm2t70VZFMrcjHc3
	oVIV3STMOQNrU91vU3GRF8Gb0oGoSgiTPJeluxjdElviCgocNc8RkcqITOmDgLzXCm6pLq
	Nb8C6V8W26lB2fE+LwTR5g6O1P83UAU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4831C417A8;
	Fri, 26 Dec 2025 18:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E62AC4CEF7;
	Fri, 26 Dec 2025 18:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766773888;
	bh=NOaIavykneT1/nXk1srM06FQDWvwc4luIp73kXT/Jgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f07vnWZybr1Fd80YLpaHtrAf1fjWWQkFsESDk0xJ6RrAvnQwxS0dEeWh5PmE6mBsF
	 agOrcTxF9ggXw8TSoAqT3na9YQkiokul0nzWs9YC5N/b9UV8xuDqW8T+cZLa30b7+d
	 ME1Z9SjgELSGWPpoK4vvb6BsRLX53K8nu8GNDFUt4VhMFl5u6rkBDPonhMQym8OCAZ
	 cJQOwGSIJrDwU/1qrAeMfJIJzeQwChakaNMKHpG+8sXPh1rPeCgAFB6WFP3mrTdAgX
	 VBEObCQx8RUVtpKDyQ1S2gfGUmoE7U7wHwEHrmiacyEDk31Jl9sT9RBGV2GRK3Ys7x
	 FF3cNrgaYULdA==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	rgbi3307@nate.com
Subject: Re: [PATCH] mm/damon/core: modified control->repeat loop at the kdamond_call()
Date: Fri, 26 Dec 2025 10:31:17 -0800
Message-ID: <20251226183122.254549-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC4f2xPK_LwFoisdqr_wX-RbdW9KUq48+82CMC=5ViF=ag@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2FB1140006
X-Stat-Signature: xztbwk66wihstwpprape8hbg6dcnn1qw
X-Rspam-User: 
X-HE-Tag: 1766773889-371981
X-HE-Meta: U2FsdGVkX1/hitWsTONfyrjLcDRI0DX+HZklIt8ouplQ85P/kgtHGGObIN0TpmpIozlje3Cu+kDa61uPsvHmK36yCwX8jkNs4ehyToO7xec+ZL+Cbgcidy1LT1RFDt3izF0PKyAPo7LGhsaZiejV+RuB3SJ/SqfcgXRLx7nYhHZ9Kh3pQoBZWbDy932FFlyTl5FNwMZ3X4fTwXgHfeZaRZuuhB+jKyXtYAKU/h3hrvzQCL3UBpcxQwBwUg5XCteIdETjVYL+lSb0PrVXPTE2Jx7GMeHsr9v6jy+FuNTnNaD2wpj+Pby9lSD/BKBkz7h5MVB2rvAO3T5hwveXBc7RC1Oe2LxroVZz0u+sCWkAR5/FfVQkxXT8mzae0Y4IkX/vUXdqtkA1SXPg4D6sWF5+hBMZvRN7xUda70a2o17gRdisxKqTWhg6YGQT0kQ0GB7bbrTfwcbUuM+M8gutLLqs3XhYtZaBdkagEU+F5zvMnhENBgITeIrinfAfPqBSFtGRuKobhmIfSz9g1/tKOtPd+Hf3rLa6a3vPv3+bSekgHYFlPsvJxStJ3IaxcqMr6s4Ur3NOBmV3XxQZVlkFBvnGVvMXnZ8agiPDpw/xng1kVz4FQI08+kGRxrgarzlhqQUdjiX4W3Bn6hsWVEbMRlaPwrKe/fw1cogMDt3locTcPvNe6ZaCVM3XemQG9IwyhoXMRUgWRxmepch0FNQpK1TA0qHDmcgsNr6UbQ8rI86Taa59+i1Aion3YMkgPMBsyUil3DAY5EvwNR8y5bBbcq1hSYrmftyAwEMhnc1LQhqQY9LHHP4UVmU8xlj4h5VpqFnIVc3WmtCCLoOmhrUCT4uZEP+iMoLYxHJHa3KKl77ntBIfpVnoSKC/p93qj8JAPfGvkgyEB25G0UvZFJ5cSWClgTb54WmNNXL17XeYkHgBtF3KNQGtlEdCS0j+1L20KvbLaz/7XJb1yn8LsFxwkdE
 URg02ccv
 VKq2encX21qfbZOz/sGO2XvsmRU9Z09qSkpHUkTAuuP0Vajah0I/CYQKEX/ZJrVwcTnQvhowEb3kU8cRi+BTUdJgn6/VXYh94/8f/ApaYqkAp9Jo90uSJKX6a5HVG3bg96A0WV4QdHWSPXc68Jgqd05U8PSXFlCOFuJdrHbyXPcLCZmY0bq27C8tFpYO8z05kc+4q/sMO3r3+Z60t6Ul14ENIWIX0B1iIos7bOhp9w2xNt7TBT8a669L06jnPINtPKmx6NxfW5X9HgwCYdRL/jLBm6UEd8tf9symAiX/kewvBJyk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Dec 2025 11:19:28 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Fri, 26 Dec 2025 at 05:01, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Thu, 25 Dec 2025 12:10:30 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > On Thu, 25 Dec 2025 at 10:07, SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > On Wed, 24 Dec 2025 21:43:54 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > > >
> > > > > The kdamond_call() function is executed repeatedly in the kdamond_fn()
> > > > > kernel thread.  The kdamond_call() function is implemented as a while loop.
> > > > > Therefore, it is important to improve the list processing logic here to
> > > > > ensure faster execution of control->fn().
> > > >
> > > > That depends on how critical the performance is, and how much complexity the
> > > > optimization introduces.  I have no idea about if the performance of
> > > > kdamond_call() is really important.  If you have a realistic use case that
> > > > shows it, sharing it would be nice.
> > >
> > > This is because kdamond_call() is called repeatedly in kdamond_fn().
> >
> > Yes, it is repeatedly called.  But, my question is, does it impose overhead
> > that great enough to make a negative impact to the real world.
> 
> I agree that the overhead is not that much since there are only a few lists
> added to ctx->call_controls(CTX.head).
[...]
> > > > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > > > index 824aa8f22db3..babad37719b6 100644
> > > > > --- a/mm/damon/core.c
> > > > > +++ b/mm/damon/core.c
> > > > > @@ -2554,42 +2554,43 @@ static void kdamond_usleep(unsigned long usecs)
> > > > >   */
> > > > >  static void kdamond_call(struct damon_ctx *ctx, bool cancel)
> > > > >  {
> > > > > -     struct damon_call_control *control;
> > > > > -     LIST_HEAD(repeat_controls);
> > > > > -     int ret = 0;
> > > > > +     struct damon_call_control *control, *first = NULL;
> > > > > +     unsigned int idx = 0;
> > > > >
> > > > >       while (true) {
> > > > >               mutex_lock(&ctx->call_controls_lock);
> > > > >               control = list_first_entry_or_null(&ctx->call_controls,
> > > > >                               struct damon_call_control, list);
> > > > >               mutex_unlock(&ctx->call_controls_lock);
> > > > > -             if (!control)
> > > > > +
> > > > > +             /* check control empty or 1st rotation */
> > > > > +             if (!control || control == first)
> > > > >                       break;
> > > > > -             if (cancel) {
> > > > > +
> > > > > +             if (++idx == 1)
> > > > > +                     first = control;
> > > > > +
> > > > > +             if (cancel)
> > > > >                       control->canceled = true;
> > > > > -             } else {
> > > > > -                     ret = control->fn(control->data);
> > > > > -                     control->return_code = ret;
> > > > > -             }
> > > > > +             else
> > > > > +                     control->return_code = control->fn(control->data);
> > > > > +
> > > > >               mutex_lock(&ctx->call_controls_lock);
> > > > >               list_del(&control->list);
> > > > >               mutex_unlock(&ctx->call_controls_lock);
> > > > > +
> > > > >               if (!control->repeat) {
> > > > > +                     /* run control->fn() one time */
> > > > >                       complete(&control->completion);
> > > > >               } else if (control->canceled && control->dealloc_on_cancel) {
> > > > >                       kfree(control);
> > > > > -                     continue;
> > > > >               } else {
> > > > > -                     list_add(&control->list, &repeat_controls);
> > > > > +                     /* to repeat next time */
> > > > > +                     mutex_lock(&ctx->call_controls_lock);
> > > > > +                     list_add_tail(&control->list, &ctx->call_controls);
> > > > > +                     mutex_unlock(&ctx->call_controls_lock);
> > > > >               }
> > > > >       }
> > > >
> > > > Let's suppose there are two damon_call_control objects on the
> > > > ctx->call_controls.  The first one has ->repeat unset, while the second one
> > > > has.  Then, it seems the 'break' condition will never met and therefore this
> > > > loop will never finished.  Am I missing something?
> > >
> > > You misjudged.
> > > If (!C.repeat), it will be removed with list_del() and disappear.
> > > If (C.repeat) loops through the loop once, and when it returns to the
> > > first, it breaks.
> >
> > Maybe my explanation was not enough.  Let me explain a bit in more detail.
> >
> > In the scenario I mentioned, at the first iteration of the loop, 'first' will
> > be the first control object, which has ->repeat unset.  The object will be
> > removed from the list.  In the second iteration of the loop, it handles the
> > second object, which has ->repeat set.  The object is added to the list again.
> > In the third iteration, the loop runs for the second object again.  Because it
> > is not same to 'first', the 'break' statement is not reached.  The loop
> > continues forever.
> >
> > Am I missing something?
> 
> Thank you for your detailed review.
> There may be cases where C->repeat=false is the first control.
> This can also be solved simply as follows:
> 
> @@ -2567,9 +2599,6 @@ static void kdamond_call(struct damon_ctx *ctx,
> bool cancel)
>                 if (!control || control == first)
>                         break;
> 
> -               if (++idx == 1)
> -                       first = control;
> -
>                 if (cancel)
>                         control->canceled = true;
>                 else
> @@ -2589,6 +2618,8 @@ static void kdamond_call(struct damon_ctx *ctx,
> bool cancel)
>                         mutex_lock(&ctx->call_controls_lock);
>                         list_add_tail(&control->list, &ctx->call_controls);
>                         mutex_unlock(&ctx->call_controls_lock);
> +                       if (++idx == 1)
> +                               first = control;
>                 }
>         }
>  }

Yes, that should fix the issue.

And it seems 'idx' is being used for only this?  If I'm not wrong, I think it
may be easier to read if you do something like 'first = first ? first :
control' and drop 'idx'.


Thanks,
SJ

[...]

