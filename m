Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39421E92733
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 15:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64C996B0088; Mon, 29 Dec 2025 10:14:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FA1B6B0089; Mon, 29 Dec 2025 10:14:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527886B008A; Mon, 29 Dec 2025 10:14:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 443B36B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 10:14:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6181F912F6
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 15:14:51 +0000 (UTC)
X-FDA: 84272855982.07.0E09527
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9E334180012
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 15:14:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SwCRwJlL;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767021289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7mE1OzZ0/nBD6aGtt9XWKOgg7vhGKV4i9O8OLs0uKko=;
	b=XQcrQN7WQKljc/IRn3e2xjMuYdfQRtpFtojCD/Pf3lGrhNxBxjPzLgGGW9qKEQZEH/FXlU
	bODKNBTWgj0pOVpPuwV9qe+OOrnGKwkxZycOmwq1aQv5RQ0VUYZ76+lOyWQcDfTBZOoYGg
	nsYrxElykKyxfbmEEPfFhh4u0StZQ30=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SwCRwJlL;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767021289; a=rsa-sha256;
	cv=none;
	b=UyvGEO+OR+0Awg0yG4MvF48uRy8+tjY2nAW6/gPXBu7x0IVSlmy+nK4S65M8uEtHv79p0O
	HkoDzg1vg4Z+R0onjU2v8p7HsOnDgDIK3Ms3xjjjt5QQ/LVx5nw8fi0GYrOK6nYAp2y733
	e1BO0GwAbjM5yDsIch2xKiJFwYKj+SY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 56DA1415B7;
	Mon, 29 Dec 2025 15:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C4CC4CEF7;
	Mon, 29 Dec 2025 15:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767021288;
	bh=Xs1tmf9C7xo6l4OgdflDuYGdhYDMGIBEbJwdPqxALW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwCRwJlL6HQFPm5wxDbBdS7qlRBSIirtH9eKhS4LOK8Hub+XN2GMIxyGQebL/85vD
	 SpFhWQ4ynQyPWv2XANaScssiu405qVIZCc8jjNEF91eDH4lMans2OtOAoPLyU+UYWM
	 98dO+2UmXkf64lkxb9FfWt18TV8ZCzXSUNdL5UgXd3GSPxxGv62vCvZzPQFFLaRXVJ
	 RxrWzkbKErnw0KFwwoumTCHXViTKA+TDEXDdAo2yBlKc3iovPWe5O2KYSWzL0w+hUr
	 kZuOhmniOhry9U7+l8AC2eNJ/I5HH1U/yfJtzesnoCoG93n17SobVQf0uxnoFiUMxc
	 aSsX7I0Vo9s1A==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	rgbi3307@nate.com
Subject: Re: [PATCH] mm/damon/sysfs: preventing duplicated list_add_tail() at the damon_call()
Date: Mon, 29 Dec 2025 07:14:39 -0800
Message-ID: <20251229151440.78818-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC7KAmj8hb8GtTJ+P_GUGqjP1WO8uqnpFjMPQmKFrc1oZw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 19i8ohc48wzi7yien9ebogdjqr8ygtjb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9E334180012
X-HE-Tag: 1767021289-289836
X-HE-Meta: U2FsdGVkX1+9+Aisk7myp+E0FMmuQV/UjJQUPX2L7xI5yTqy6qReEs18Wp8uCnSakLKt+7qRKHl+hKp3f945UwY8xcl4LEdZLSDKUTDxALzWShMAHduv5zNOcZnj+VRNx3PdxJD1U0HArazNNCwz8LYw4V6aGS2FWwOtmmkzEXfML1h7sABO9ZcFUm4L4aAun7Cy4FbWmC0vxZPcAtV/NE9rXZUuSABj+OgzBEtNk9IStelMLQ7Ff0ZQxrSQC6JkNY8PKXZ4HhsJC5PiOL/YUBYDOqxE1iUca+ayMTY/hgtUF9g/a9VFuyR0pQ4M24kYvLOG/VZ8wPGDfSbE5bxG1FwaqRvz3gM0hhseOqbU7BFOrp02Y2+3pY393jDrT9xvqCKPynE0a8blyxD6O1IHwjAk8HPIDPPy3eZTP3DK0q9AdoTyacuqT5C1t8RQ1P9xeSxONSxInsImMhbbCkmk6WtZD8zoSBTf7PFCKbIh6GrJk/zj/4Ze0k1gTUajBT3+47iws4Rrpop8oFCyetX+QzN13PNnFsYgZz6mY+bAl7DoJRwtz0gj0RFYNVqouxij+BNaCNM+zbyITQoFAPm1ITdIYOJMXKDNVV9FIN0pQHxqoyuYKWCorhhmlXGPZbXGof8WTu1pyL2aLSBXhfpqsGz7MXL960QkoeBjkySHLsUgn53VkBEuV1h6zCdmmlhErMOSSJ1fBnInKLsjNBy3XTnfHmvh9uWRop3MvkPIu/UAQmx6U1BsL1UfyEJ7tXtTVF41QA4A/KguQTOK0Nb9DLJR9mbNGxZE0kS6zTSAYTjK0bB9FvnzXsEITZWwPTVxL/L3NOH33IZ9o1dvtZtsCB7AXrq4Ne+6yHzdRxr/rpy1eb94zFwb1r2r2nxyZLuTcgj8A7PYTxlz91Sf499nW8BGZwYHP7GlQsh4pRPoyVgiZA8PkdmQnOy6mi2DvaeGFA8kIBJzovluQaqcCqX
 7gvLwjVP
 MkHhMyiStXzAjT5HY1Yar7Pedv4nGi5hexI9vz1hMR9Z9IhONwORb+RuStYgONh0j/NCOY8RuGNPeTzwKBv6h9QYYt2llmDQLtvjnS+MiKcUvR2o2BB8GUvBuQFKQUljv8pNLYAsUvr+Rm7VwHlub0R4rgmXK/XSXBtkgOpcE1piD6yuml3vzQQJuekYUR/acfTKXJNHXKC0+ISxcU6jALEDJ7tGaikOO9WRMQ/75zFCNzhMjKDQoma3sWjVyM8RL1DCEnOvJ7kHAjD4L6kp4A7L5kxwWgdxTzu1wY+Ak4twZ0NI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Dec 2025 12:38:58 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Sun, 28 Dec 2025 at 02:42, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Sat, 27 Dec 2025 08:53:21 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > On Sat, 27 Dec 2025 at 03:41, SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > On Fri, 26 Dec 2025 10:48:31 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > > >
> > > > > On Fri, 26 Dec 2025 at 04:50, SeongJae Park <sj@kernel.org> wrote:
> > > > > >
> > > > > > On Thu, 25 Dec 2025 11:35:33 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > > > > >
> > > > > > > On Thu, 25 Dec 2025 at 09:32, SeongJae Park <sj@kernel.org> wrote:
> > > > > > > >
> > > > > > > > Hello JaeJoon,
> > > > > > > >
> > > > > > > > On Wed, 24 Dec 2025 18:43:58 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > > > [...]
> > > > > > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > > > > > index babad37719b6..2ead0bb3c462 100644
> > > > > > > --- a/mm/damon/core.c
> > > > > > > +++ b/mm/damon/core.c
> > > > > > > @@ -1462,6 +1462,9 @@ bool damon_is_running(struct damon_ctx *ctx)
> > > > > > >   */
> > > > > > >  int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
> > > > > > >  {
> > > > > > > +       if (!damon_is_running(ctx))
> > > > > > > +               return -EINVAL;
> > > > > > > +
> > > > > > >         if (!control->repeat)
> > > > > > >                 init_completion(&control->completion);
> > > > > > >         control->canceled = false;
> > > > > > > @@ -1470,8 +1473,6 @@ int damon_call(struct damon_ctx *ctx, struct
> > > > > > > damon_call_control *control)
> > > > > > >         mutex_lock(&ctx->call_controls_lock);
> > > > > > >         list_add_tail(&control->list, &ctx->call_controls);
> > > > > > >         mutex_unlock(&ctx->call_controls_lock);
> > > > > > > -       if (!damon_is_running(ctx))
> > > > > > > -               return -EINVAL;
> > > > > > >         if (control->repeat)
> > > > > > >                 return 0;
> > > > > > >         wait_for_completion(&control->completion);
> > > > > >
> > > > > > Let's assume DAMON is terminated between the damon_is_running() and
> > > > > > list_add_tail().  In the case, the control->fn() will never be called back.  If
> > > > > > control->repeat is false, this function will even inifnitely wait.
> > > > >
> > > > > As you said, there are cases where kdamond is terminated(stopped) in
> > > > > damon_is_running() and list_add_tail().  It may be a very rare case, but
> > > > > I missed this case.
> > > > >
> > > > > >
> > > > > > I think we should keep the damon_is_running() as is, but further check if it
> > > > > > was terminated without handling the control object, and remove it from the list
> > > > > > in the case.  Like below.
> > > > [...]
> > > > > However, the damon_call_handle_inactive_ctx() function is to post-process
> > > > > the duplicate addition of control->list.  Rather, it is more efficient to
> > > > > prevent duplicate additions in advance, as follows:
> > > > > I have tested the following and it works fine.
> > > > >
> > > > > @@ -1467,11 +1496,14 @@ int damon_call(struct damon_ctx *ctx, struct
> > > > > damon_call_control *control)
> > > > >         control->canceled = false;
> > > > >         INIT_LIST_HEAD(&control->list);
> > > > >
> > > > > -       mutex_lock(&ctx->call_controls_lock);
> > > > > -       list_add_tail(&control->list, &ctx->call_controls);
> > > > > -       mutex_unlock(&ctx->call_controls_lock);
> > > > > -       if (!damon_is_running(ctx))
> > > > > +       if (damon_is_running(ctx)) {
> > > > > +               mutex_lock(&ctx->call_controls_lock);
> > > > > +               list_add_tail(&control->list, &ctx->call_controls);
> > > > > +               mutex_unlock(&ctx->call_controls_lock);
> > > > > +       } else {
> > > > > +               /* return damon_call_handle_inactive_ctx(ctx, control); */
> > > > >                 return -EINVAL;
> > > > > +       }
> > > > >         if (control->repeat)
> > > > >                 return 0;
> > > > >         wait_for_completion(&control->completion);
> > > >
> > > > I think this is not differnt from your previous suggestion, and thus it has the
> > > > same issue.  What if DAMON is terminated between damon_is_running() and
> > > > list_add_tail() call?  Please let me know if I'm missing something.
> > >
> > > I think it is good idea to insert a barrier() between damon_is_running()
> > > and list_add_tail() to prevent context-switching.  What do you think this?
> >
> > I don't think barrier() works in the way.  Please correct me if I'm wrong.
> 
> Yes, there is no need to use memory barriers.  Since each kdamond runs
> its
> own damon_ctx, the concurrent access problem can be sufficiently
> solved with
> mutext_lock.  The problem discussed so far can be solved by applying
> mutex_lock to both ctx->kdamond and ctx->call_controls.
> Please refer to the modified code below:
> 
> @@ -1496,14 +1502,15 @@ int damon_call(struct damon_ctx *ctx, struct
> damon_call_control *control)
>         control->canceled = false;
>         INIT_LIST_HEAD(&control->list);
> 
> -       if (damon_is_running(ctx)) {
> -               mutex_lock(&ctx->call_controls_lock);
> +       mutex_lock(&ctx->call_controls_lock);
> +       if (ctx->kdamond) {
>                 list_add_tail(&control->list, &ctx->call_controls);
> -               mutex_unlock(&ctx->call_controls_lock);
>         } else {
> -               /* return damon_call_handle_inactive_ctx(ctx, control); */
> +               mutex_unlock(&ctx->call_controls_lock);
>                 return -EINVAL;
>         }
> +       mutex_unlock(&ctx->call_controls_lock);
> +
>         if (control->repeat)
>                 return 0;
>         wait_for_completion(&control->completion);

This diff assumes holding ctx->call_controls_lock will avoid the context be
terminated, right?  But there is no such guarantees.


Thanks,
SJ

[...]

