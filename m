Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB7ABE8FDA7
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 18:41:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1089E6B0005; Fri, 26 Dec 2025 13:41:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B52F6B0089; Fri, 26 Dec 2025 13:41:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24616B008A; Fri, 26 Dec 2025 13:41:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DE8F46B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 13:41:21 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 644F812CFB
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:41:21 +0000 (UTC)
X-FDA: 84262489962.22.A3DDCF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D235AC0009
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:41:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qUiWm749;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766774479; a=rsa-sha256;
	cv=none;
	b=pmbauQK/9BSqSDJnbWrHnmv5jaGdsoUOwYEQXXhnQ5b5RkkMoBjqY6SZiOYcc0XUe66Kuj
	mBUWAUUcnr2qf/AqAe/KuX5nxzXXTzkbdjwWNVTSVhLrkmhC/Yq7ncFFrReFMQL7yYrffR
	u19ahvWM4oq891Dy4AiHdTzyKTMnS3w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qUiWm749;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766774479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kufkVggCItsGJHP1AE0yn84AKp16zM+JHO96dRvTPa4=;
	b=gGIThJWZPJ8kfE+1bUY2TS1XdH1xN53nwg9zJ4ootgifsmmu/TIuWTYVFap6bVeGWsjTph
	HtnfCENfsJz2hu0kPS0BCpmxSjFGMFdwQmKY5P4pxAB9RcchwYPmRHyNpzQ8XFji2Njkbd
	v/r9BbnNn9vKplO1PU68ZbbmqfK1Tnc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 180BF6000A;
	Fri, 26 Dec 2025 18:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E943C4CEF7;
	Fri, 26 Dec 2025 18:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766774478;
	bh=mEp6J4yadIUdsHFqxS1/gcxPf7v5MNQ8+PlP8jNRAUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUiWm7497uoFIXzelm48+mbsYVw9oIQlO3ejG39jnW1uy6FFEP4gle7ZApnB0K/Rt
	 kek3fMRUveNxzBRP+z8/3FPYgo3s4oLZ070PItPv3/kuwa7iOGFKLplh6vlVvUx368
	 gvOJo4ZkZzKoob5LkVeOrqBiExXuI3XqK1CT3KelDZ97Yjv6D21qHqvtZwXxu/n8MN
	 E2UXshFHT3KCrEF4b5e9vvODgtodLlHrwzFabVAgK8FO8CWk83ER5bTbaxcKPhsJI/
	 gyuNOi7GsMvJ5hnMaxus7BbPDjQXTrVe7zR88titGy31wEfo9nCBcmeuAFgawbyGY1
	 Qz02b1O8YlZmA==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	rgbi3307@nate.com
Subject: Re: [PATCH] mm/damon/sysfs: preventing duplicated list_add_tail() at the damon_call()
Date: Fri, 26 Dec 2025 10:41:09 -0800
Message-ID: <20251226184111.254674-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC6PQKAK5WojmVFqBw0V-TZ+11CM_2uq4z8TxsyEu3gLVQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D235AC0009
X-Rspamd-Server: rspam03
X-Stat-Signature: jiouxo4gyfqyyx31qs3ta46qqw4o3prm
X-Rspam-User: 
X-HE-Tag: 1766774479-569925
X-HE-Meta: U2FsdGVkX1/QrYW4Gt4VL4UWByrFD8Smpw5Bidv/wYlRDVmoR9jHiTJhDtnRZrPHi93EWe7U7nFy0vHxfkQrzmxRkA2m7imYiPXnS2XuU1mjiycfkNrMrAd+UqVkdq5tIPQ7/Xfzk/lsxr8IiDrGYO4atp70Q8n3Wa1kCMp/RYIiBuGSbi9+eeuzmeAMWJO2YJ0g2R9GivEF/fwUxFvW8GvlWLO0LXmeliK1B+fV2OGdKAnYdFFoeR5BoSHRZjQ+fgaNWmr8IDtrBCtWnXB5jzsi3ZfxFS1HLNMv+/oIa51+LTqaBf6Vs4HWuKFTPWKlU3mRkmLfuVaXAGiw+iM63iUN5/LKyl9EBO8ughy9Ohy/cryPQxJGDBG0AtPGicaPBB3Hp/7BaqXYdKI61o0ZkMO/1uhuFNGRRX5wdAjzHLRWEzoCBAZK+9Ark7WRL6DPC8fKY0SAYOkL4PQGLRe8Uh8e/5U3pjJmqBx6ek9k1XaWjagCR9KR4S3Co8V/E8mzD500EilUDuKYf7kJq2tgBzq+FfZuVgEh7sXPvbOuQ2R1qAaSx5FxJOJFe9lLuNOg3VUCdUev1pOA41WzDqW5lmUvPiEaPCh3Xr0fnDb+5hHD4y6VU65SfUiIyTH41wQp/YITP6Xdeh4IjYSPqwzi8upd2xqmWMqdj/+JlywTW+oYkMBwJDV3cwvobdLdulsQ/NXyHSCdrdyXADYueD92rKWhB3kAnZEpIc8/Q1/l9+xN/goSTyMXO83N6PCFZxUuyuWNmQ3+8SnKGU8zy9sxENVDVud/s2q6S/iiGCeWD+yvYd+Q/pmc+jCtoQOLL/kHQIycmW8+Wl2zIyloKfHXkTpq8B7hh+wtoQgiyMeeQzjzA+NrG5EjPqzLqUbcacwvERfRF608jpCiDCHpTjxq6zIdtMqcN/JZRsBpYVXsLa4KTJbhcBEwPg7yHjW8ooCfoe/atsff+GbQ8Mld0IL
 lCnGTyyb
 XFjPTqDf9EAEOJ0fWLXiLCwiMBWmCuU19vKz4o+GM553HetRhALJ89OaqYSx8tVPQNjkIAvuMDu72lPedlbuxvQmuyFAUaJbG+nd8QeI1tTkTAgN8mAVvmDpoS9OqbNsPS3UpJef/A5xVz1/Fl5QI8YdOBHKxVfQzBNUi2Yn7ZcdTGYY/G8EMZcM0q2Kbms+c8FhwcDuOU+4eNj4Pu3Id5CWmknmcBTgAbKPBz43jw+x0Rt0zXUIRs8r+ePT4dFMplXJvHEC+JiflmwaHiwnsq876+nju47QwduD9WQtBfCKosYM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Dec 2025 10:48:31 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Fri, 26 Dec 2025 at 04:50, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Thu, 25 Dec 2025 11:35:33 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > On Thu, 25 Dec 2025 at 09:32, SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > Hello JaeJoon,
> > > >
> > > > On Wed, 24 Dec 2025 18:43:58 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
[...]
> > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > index babad37719b6..2ead0bb3c462 100644
> > > --- a/mm/damon/core.c
> > > +++ b/mm/damon/core.c
> > > @@ -1462,6 +1462,9 @@ bool damon_is_running(struct damon_ctx *ctx)
> > >   */
> > >  int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
> > >  {
> > > +       if (!damon_is_running(ctx))
> > > +               return -EINVAL;
> > > +
> > >         if (!control->repeat)
> > >                 init_completion(&control->completion);
> > >         control->canceled = false;
> > > @@ -1470,8 +1473,6 @@ int damon_call(struct damon_ctx *ctx, struct
> > > damon_call_control *control)
> > >         mutex_lock(&ctx->call_controls_lock);
> > >         list_add_tail(&control->list, &ctx->call_controls);
> > >         mutex_unlock(&ctx->call_controls_lock);
> > > -       if (!damon_is_running(ctx))
> > > -               return -EINVAL;
> > >         if (control->repeat)
> > >                 return 0;
> > >         wait_for_completion(&control->completion);
> >
> > Let's assume DAMON is terminated between the damon_is_running() and
> > list_add_tail().  In the case, the control->fn() will never be called back.  If
> > control->repeat is false, this function will even inifnitely wait.
> 
> As you said, there are cases where kdamond is terminated(stopped) in
> damon_is_running() and list_add_tail().  It may be a very rare case, but
> I missed this case.
> 
> >
> > I think we should keep the damon_is_running() as is, but further check if it
> > was terminated without handling the control object, and remove it from the list
> > in the case.  Like below.
[...]
> However, the damon_call_handle_inactive_ctx() function is to post-process
> the duplicate addition of control->list.  Rather, it is more efficient to
> prevent duplicate additions in advance, as follows:
> I have tested the following and it works fine.
> 
> @@ -1467,11 +1496,14 @@ int damon_call(struct damon_ctx *ctx, struct
> damon_call_control *control)
>         control->canceled = false;
>         INIT_LIST_HEAD(&control->list);
> 
> -       mutex_lock(&ctx->call_controls_lock);
> -       list_add_tail(&control->list, &ctx->call_controls);
> -       mutex_unlock(&ctx->call_controls_lock);
> -       if (!damon_is_running(ctx))
> +       if (damon_is_running(ctx)) {
> +               mutex_lock(&ctx->call_controls_lock);
> +               list_add_tail(&control->list, &ctx->call_controls);
> +               mutex_unlock(&ctx->call_controls_lock);
> +       } else {
> +               /* return damon_call_handle_inactive_ctx(ctx, control); */
>                 return -EINVAL;
> +       }
>         if (control->repeat)
>                 return 0;
>         wait_for_completion(&control->completion);

I think this is not differnt from your previous suggestion, and thus it has the
same issue.  What if DAMON is terminated between damon_is_running() and
list_add_tail() call?  Please let me know if I'm missing something.

> 
> > If you don't mind, I'll post the above diff as a patch, adding a 'Reported-by:'
> > tag for you.
> 
> 'Reported-by:' is OK.  However, please check the above again.

Thank you!


Thanks,
SJ

[...]

