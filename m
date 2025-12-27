Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D3C0E92718
	for <linux-mm@archiver.kernel.org>; Sat, 27 Dec 2025 17:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8B46B0005; Sat, 27 Dec 2025 12:42:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C962C6B0089; Sat, 27 Dec 2025 12:42:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA2E36B008A; Sat, 27 Dec 2025 12:42:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A68316B0005
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 12:42:55 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F8588D9B6
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 17:42:55 +0000 (UTC)
X-FDA: 84265971510.07.861BC20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 81000140003
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 17:42:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fNAZcGe+;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766857373; a=rsa-sha256;
	cv=none;
	b=4lO2L4mooHjxLKyKtIwBJVk7d2v0sneliLIVU992KaXhTNDWeJKTlwtFoIYXq8hjbX8F9W
	xcHJxTz63kd75HgHgUxxQePVZfAk3uy8+vfLXcSVhIPtj+JjBheiy9tiIKGPCnZ9QzmEwa
	7pYLaghp2zmFix8eu0XUlSxN5W8c/UU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fNAZcGe+;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766857373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GwA/OY9+gnMOOngUeTGBLVUuGZRSjzmnwAUNe2yvJvI=;
	b=0+3K+eVDvzgiL67oOWDQQEjRgDsoC7UW8D6w2Pt/+6tZd6NisWhlNZxZjaH6wwirkDj3px
	fpcyNhvq0Rn+FIe7n/mMkehs+6PzzXt+HmClKGpB+WyxMP4jYMRtRZN+zkMuG+8cuEIxIe
	rziMsX0OXDMeCcf7JClpcLrJosQHHgI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 511D34194B;
	Sat, 27 Dec 2025 17:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2959C4CEF1;
	Sat, 27 Dec 2025 17:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766857372;
	bh=GmEfmocljw2ZGdCriw+M4GF2i0Suwp4h07YGW7Y4lLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNAZcGe+FTTNOF8fqTLXMlRWM+/qMu7FnWT6tHKUo8cwQOhdOv/wxE1fKUiwBwAvK
	 3ZbHlr452PJuUxj3NADBzVszHCFdCgAFOg5tKubWAe3lp82vv4bxy8GslVN1tncRWF
	 jZk98OexmUbRHXsbqzzLXuKqA9+tw5uQE+uUcboLTevKBTzaO+JZgBYPzEFdKZmBgQ
	 hyWySJ6aXIv405fURyvfepr8KrJOYq6+VwOh6Nd2DePYFMxGDxx+M5bmtsOBQUIt7P
	 fvqtM0RyhD5EtwurHSZb0S8wsimoZ+hlYDaCTaDsJ6+VDzJoR1aUC4wIRgG2GNA7v4
	 ZThPFYZHSjPgQ==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	rgbi3307@nate.com
Subject: Re: [PATCH] mm/damon/sysfs: preventing duplicated list_add_tail() at the damon_call()
Date: Sat, 27 Dec 2025 09:42:34 -0800
Message-ID: <20251227174239.273581-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC7HqeGY1uxy7FxLKTFHAJPcWWbKJRjZ06W9bC4oAejOsw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 81000140003
X-Rspamd-Server: rspam04
X-Stat-Signature: f4sr7woegw4m4x4whjrhsshxc37ak8hz
X-HE-Tag: 1766857373-837375
X-HE-Meta: U2FsdGVkX18td2RT+gGgSTLUnQs5iQAVifrHcn4tGwWP3inoXH9yPbRQvhSvIx3mAkOpL/nunguJZILYqZ8ilZTb9FjoCXaQSy9jImiiP51JNh6F9sI4+rs09Xaze+38lvJ86OnGqbBR8UFkJHQB+aR2zWwEz3AjU7ioZjDVyDMpdag+xI8MkGBOUzrlR1VYLV0VhY3ch1BdCGIryfv7CbwfJi7UhZJOiQkcYBMxGHAiff6cxCD/ONckKw/ByW41BhABfkd0qV3uJObRTGISLVwsSE+Ahfg9BGppQUD64xJhOqU89L8GuD4vpo35L8RPZ1PC7hfZKOvRwfb0KBOmsrIWcz5lxCPDKI5/8JZWkgAOt+8pk4rw/XqUYro4F/bJuJMf620sWhYmgLwSfbBVsz6P3mPsKl2T0tewBXUf4tsLnTsEDTJYZfggdAIy6y6lRQEjWQgyO+8UNsJ362/6Eafyu+sohp3pBLxI1AlMKnT1tRJHly2xNxzX8edA0xcc3TSfd401uX4Eil6C6mUo4Bq9FCT04UWP9TeuJnpX0MsyJsEyL/QfsiM/ZO30ZlPHwDrnfCJxhme9T9ZhBREs8zRX8jXkxV1Sp15rCE0vfNlHsp3wf5TgBlndCCDT/DpjQacyYYTp/Y/sKSTmXhVGC26ZHJyo54GRjygoCk18ZbxkfyVWckxEmcqoXZ/Cv7R5dqMFuk9DnCODNv7CFDDGtj8PTtBRs9iqkew8x1hsPpYvx7EH6t+V3FPrUJM2apGmbEQ5ESZBuSeOWlsEIdMKzKoEVyHzWw8EvcaIbMNNGIXG0NmXPIinT6bMcuzj4QRu2iyyl4onRZX6IRnfQELlkH+9YBdt0pixDDzb5tW4ZXO9Zj5MSmQsN6Nr4YZ5BCTRgAipXCpkdlO4hdU58gxMhTH1XpT0VAJpN0G+2wPPXxsHFpxcD8BLq/nA+/fketQVwYggZ/aVONJLs0IdyUb
 DkrwU0hb
 gK1KmvWpiJAuW/rqnNtEuD28jhIOfSxnEvkmLRoEFgDYgEKxgZlVRhWeWMelxRGQh2S02QOQbynHlZetmt1g2E4Ek9fymusOzjQ0KKPHjmL75CGI/kjPPNcZ8gDThazT+0313Y84M+Z98zbg0W40BrvgukV7usjzsoBnWOPr7bOGuX+rND0jh6z+9aOUOPwOBvLcWu4stWXSSak4f323vW6Es4M6mWnY1KCO75a9iPUSThFPe9Cx7OGyZFUm0jHBOh57WKe//h237OCbCNI2y8ikGPnIWCRZWaAwqfsSehwjZ9Jk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 27 Dec 2025 08:53:21 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Sat, 27 Dec 2025 at 03:41, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Fri, 26 Dec 2025 10:48:31 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > On Fri, 26 Dec 2025 at 04:50, SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > On Thu, 25 Dec 2025 11:35:33 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > > >
> > > > > On Thu, 25 Dec 2025 at 09:32, SeongJae Park <sj@kernel.org> wrote:
> > > > > >
> > > > > > Hello JaeJoon,
> > > > > >
> > > > > > On Wed, 24 Dec 2025 18:43:58 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > [...]
> > > > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > > > index babad37719b6..2ead0bb3c462 100644
> > > > > --- a/mm/damon/core.c
> > > > > +++ b/mm/damon/core.c
> > > > > @@ -1462,6 +1462,9 @@ bool damon_is_running(struct damon_ctx *ctx)
> > > > >   */
> > > > >  int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
> > > > >  {
> > > > > +       if (!damon_is_running(ctx))
> > > > > +               return -EINVAL;
> > > > > +
> > > > >         if (!control->repeat)
> > > > >                 init_completion(&control->completion);
> > > > >         control->canceled = false;
> > > > > @@ -1470,8 +1473,6 @@ int damon_call(struct damon_ctx *ctx, struct
> > > > > damon_call_control *control)
> > > > >         mutex_lock(&ctx->call_controls_lock);
> > > > >         list_add_tail(&control->list, &ctx->call_controls);
> > > > >         mutex_unlock(&ctx->call_controls_lock);
> > > > > -       if (!damon_is_running(ctx))
> > > > > -               return -EINVAL;
> > > > >         if (control->repeat)
> > > > >                 return 0;
> > > > >         wait_for_completion(&control->completion);
> > > >
> > > > Let's assume DAMON is terminated between the damon_is_running() and
> > > > list_add_tail().  In the case, the control->fn() will never be called back.  If
> > > > control->repeat is false, this function will even inifnitely wait.
> > >
> > > As you said, there are cases where kdamond is terminated(stopped) in
> > > damon_is_running() and list_add_tail().  It may be a very rare case, but
> > > I missed this case.
> > >
> > > >
> > > > I think we should keep the damon_is_running() as is, but further check if it
> > > > was terminated without handling the control object, and remove it from the list
> > > > in the case.  Like below.
> > [...]
> > > However, the damon_call_handle_inactive_ctx() function is to post-process
> > > the duplicate addition of control->list.  Rather, it is more efficient to
> > > prevent duplicate additions in advance, as follows:
> > > I have tested the following and it works fine.
> > >
> > > @@ -1467,11 +1496,14 @@ int damon_call(struct damon_ctx *ctx, struct
> > > damon_call_control *control)
> > >         control->canceled = false;
> > >         INIT_LIST_HEAD(&control->list);
> > >
> > > -       mutex_lock(&ctx->call_controls_lock);
> > > -       list_add_tail(&control->list, &ctx->call_controls);
> > > -       mutex_unlock(&ctx->call_controls_lock);
> > > -       if (!damon_is_running(ctx))
> > > +       if (damon_is_running(ctx)) {
> > > +               mutex_lock(&ctx->call_controls_lock);
> > > +               list_add_tail(&control->list, &ctx->call_controls);
> > > +               mutex_unlock(&ctx->call_controls_lock);
> > > +       } else {
> > > +               /* return damon_call_handle_inactive_ctx(ctx, control); */
> > >                 return -EINVAL;
> > > +       }
> > >         if (control->repeat)
> > >                 return 0;
> > >         wait_for_completion(&control->completion);
> >
> > I think this is not differnt from your previous suggestion, and thus it has the
> > same issue.  What if DAMON is terminated between damon_is_running() and
> > list_add_tail() call?  Please let me know if I'm missing something.
> 
> I think it is good idea to insert a barrier() between damon_is_running()
> and list_add_tail() to prevent context-switching.  What do you think this?

I don't think barrier() works in the way.  Please correct me if I'm wrong.


Thanks,
SJ

[...]

