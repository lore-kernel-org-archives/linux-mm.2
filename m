Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C043FE8FDBE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 23:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C4116B0005; Fri, 26 Dec 2025 18:53:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A5BF6B0089; Fri, 26 Dec 2025 18:53:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7446B008A; Fri, 26 Dec 2025 18:53:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9FE6B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:53:36 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3805BA977
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 23:53:35 +0000 (UTC)
X-FDA: 84263276790.18.5F7531B
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id DFD4440005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 23:53:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A8GykLRa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766793213; a=rsa-sha256;
	cv=none;
	b=fKe8dfRY6ra4gm4BnsUxH/CVkFG7ur9LUDLFIdG5m60XqgHu5GgUapUH/kuc5efXNhTeQ5
	2vbThdiyWm9rDh9XbCnzrlUj/po76+oaltP8u9/YZsuP4tGlFRVL46mCuX8Mooml2ZmIzq
	L97aHpTx5u4Bn5o9KrOhB7ttIE6iQAY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A8GykLRa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766793213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5JTcSmilid40WVSQLI0qecHKHI64cGOCVGN86fIcYR8=;
	b=B8e+M5G66dYZT20l/cyndhMN5VPXabyV+dx2N/IloIZ1r+YuYyG9dm3shCNI689fQFg+9w
	AgLiNZYDcyPQYcs8ch/HBsfzd83GYdBWIrAQ81N3k32MzPUjRZUWhJzBYwQwxkSsiQEWzw
	sU6CYdZ2eGQWMnxmMD2qa3Q0t38101A=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-64472ea7d18so4943838d50.2
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 15:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766793213; x=1767398013; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5JTcSmilid40WVSQLI0qecHKHI64cGOCVGN86fIcYR8=;
        b=A8GykLRatc+smN2TAKVm3Xm/kRUJZ2meWQNTZ82dwwt1UsZDt1Rc9KcfLVWBoUdqg5
         aLtzXDeBsiH4La7VckfFMQGEKZYpnd9au4N+7TiVjlZc9dAdJgNfw7x1sLWD9D5kWKkY
         v8LwNMPO6EiOqZvH3O4Gfv+jjYB39/JqeMm3+Gl2/HlN2KLHpXOWw93C6Kd3ptPVhCQL
         O6VSqjNil+uLG4EFOmNapgrYMCuiwkUf+xUSvsVIa6kgwDQv+bJhYBTXhyCvUGDgAHS0
         WPhgzYfVkONjpnShjmJg6XzJfxaqVAphqo9sETEfMIcb4/HfwUp2+/58x7sLCcipKsvJ
         0X2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766793213; x=1767398013;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5JTcSmilid40WVSQLI0qecHKHI64cGOCVGN86fIcYR8=;
        b=u686E/m8Atg4nyu15vDOxWUeDXtK9LQxH48rvGUAsZbDWeTXPlHX+sIEbb/7wXzLpi
         dUF0fHNZF347EsoJKS0W1n+e8ModS60ttqx3KDSLmjj5OuTIAOyOBVZPCBRfz8sCqBBE
         IsMY3pmwcMjmMPvMVHkbmoJ80Lu85yHpd8tI020E9sgNJhUVw+w6AYxtYlJya9a61Mu9
         2XQSrvBnijFT8FgvpOCtYymi6B0krCo06uqp2oemYai5LrYhuNXMz91KZQFAoaQvIDT7
         VtAYkGFEUB569c5IvM66y8nuXr3Z0pXZaxocSIthF4f5nk1EL0asg58042EOs7PxL1vj
         t2Aw==
X-Forwarded-Encrypted: i=1; AJvYcCVWwyA5Yavxxae6fOfH1OvvocoVK7kEM9qh4ZMGuw6tmNv/iwVKyQdrvkGXM009+NKLQies3yFp8w==@kvack.org
X-Gm-Message-State: AOJu0YxgmtmDvs8cdeZ8L3UFPvcMgb8GQbosZn44HcJo+U4fZPIFO/Sw
	z0GfTyJ+LvxVEpp5uSUnrX4vOCTZKeHJEI+eH8d8xBrTqjLQRtZ0trFPO/AurAhgHcK2W2Lm3De
	bDwgKwCf9Agt+I+tfb6J+vHSSPkvbJUEz2TVgDXE=
X-Gm-Gg: AY/fxX6NPxUIUlSPdJoLKxcaXarK0y+wqOHSthgGAd3VjqJIP1qXxeL20P+1Co0OtcI
	tOFqTqCQx96FuxKrJhSejYcQ8P1bqRf6aOjL6O+iVkyze1bamV7PizvuPxyeabKvEuA39C0NMrR
	XHWD0TQ/t7io77gbHBmkzGgkGkaF/iD9/0ZHzD/VkW2rMd7Nfk9PYRni9xCmj0Eqo152WXefZ1M
	puZ3efGvpuAdIAp2vIZ2gjI0bJsmy3+/ObZQEt6J+T4kZNpdAPtznSTt1ZWrNQFxV3JywwDzvfG
	SKUavE4=
X-Google-Smtp-Source: AGHT+IEAZAGqF9F6MxR1VLl7olkR5UmCPFUFao00Law/8wX3U6qC8XMgr6p+96BB+k6/+ca/7seKX62CnzUkAcpJmvg=
X-Received: by 2002:a53:adc3:0:b0:641:f5bc:6983 with SMTP id
 956f58d0204a3-6466a8c568amr15091028d50.79.1766793212876; Fri, 26 Dec 2025
 15:53:32 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC6PQKAK5WojmVFqBw0V-TZ+11CM_2uq4z8TxsyEu3gLVQ@mail.gmail.com>
 <20251226184111.254674-1-sj@kernel.org>
In-Reply-To: <20251226184111.254674-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Sat, 27 Dec 2025 08:53:21 +0900
X-Gm-Features: AQt7F2qKCfyxqagV7UlDOzpbncHuGGXw7tVVuiMUC6LDgDSt7Cv44S0l7SIN9po
Message-ID: <CAHOvCC7HqeGY1uxy7FxLKTFHAJPcWWbKJRjZ06W9bC4oAejOsw@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/sysfs: preventing duplicated list_add_tail() at
 the damon_call()
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, rgbi3307@nate.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DFD4440005
X-Stat-Signature: ifn53yquezkoyunde3j4osi3o811hh1g
X-Rspam-User: 
X-HE-Tag: 1766793213-120292
X-HE-Meta: U2FsdGVkX18lCYSvH+FpvT1YnY4uK4gYKEK7HyLAJTgglE19F7kdOY3JxcL29ZiBkY+ds/LZsLO+LCDFpnHhhwVEKafDIb6NwzpNAb3GBLlZlPMWCnm6F1YzowWXW1sLZzUewNG1BYY//szBuGwvYCdL2W5u+2qTIwqUrhzkYrKXjaPOJHXAf4Y9pd7SBsPbBdtXdXnAFU1AFygrlqh5FiqFO2tPdG1zMAAJr7wOctc3+Xhgpoh0+hnkZxt63e3fXUOxGPD5qsuFHcQpoqncDVJNQ72DV0uSxSvSyiHqygr15JELrpyQQYBFtFRrdxnLwlr4MP3pLK9lgcVlVDo3hCLaYeyLfRxpVSuFHXq4EmEW0odHur4WrcZogcTGelcOTiZjVMyKrwCA8Pit8wPwl0xwilsyKWtgI9d8PYeVuZ21VjU9UYo3wyBOy10YUM5yt+mdSct8hnUfwEzwloN/LGt20YHpDs7m/Mv0g66rJ1kpQyYd68qhubWaQCokr6/ERmdfWy5Kjp35or0n+AJpMDWajJK5+2Q0sJKfh4vxrFah9R6kQoKZfdZstEBZscf8uLLa7Yvvoz2rU9GiA0isTSrvBGPUyOUiSP2g/zhDBnyZ0Sg/NFggZVcqgveNd0sGnZtGJFBb1Un7qRWMSAWtuL8Pf6M/a2FJdpfjTnvGLKfBW7eVYkz95NJVxjeXNGh0ryb4STFzuYch6a+F1Ub8f7LHD2l8WRbXlwb4uYbkPupxP+PTdp8IdOzSXND3g3VJPx3YM2Ji/6f2m78FCfNOoR5dfTEG6oUKxbsDF1NTrGdjVqwj0GRdJy4vE1YFDkxCaXf9lKV4vF6he6nuQ78byrh8q2NCqUnl6bHJNbpIcGoghmDbXFpQmnzlH0cMQs28Af+XqHO7dy3ywQa5uIPhxT8aRUs1hMHXm0GI6TeVh6zmdDkn2jyms73Lz42brMti9D6PSDuSAWeoy92NBR2
 y5FKKg2j
 jqMuWYzvcv4U39VIzuoOwfiGXj9OltQwsYCbI+dgdVJeNcEsqu+EH+LRMYvW0sWMckap/nkIgd8jXeo5/czEXT8rMu/6E1eXcy9UbBVJRzRUodl/Lu3pxTE2BEarvNMOUix36hJ0NRM/s+oweAtj9xiYDKUgd2axkYMwRtWFQtmtg69WL6Zwm9BKuxzeaPxXhbUqGZumrpFiibiIPm9YKOlv0yLdeW1LfsaF94DdqvzYSn7wD5tpw/pLCKVFp2828ElbUskTeNvgoc9420U0EZ58UOIQsLpb0NbBTIzXqtXAp4VJ+u2M6CnpbyTrPtSVkOM8E/uh3lNjTEJcEqlFlunbVBLNVJeWJUxbfMyNKvnMjP9yCUNCg1toz3VzwRe8CFqVsqZDOWaK+CmxlcBvLEDwWkuMdTiFdeACYccwZB8OaDcOxOZ2EhUcMLVxGJaWah672
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 27 Dec 2025 at 03:41, SeongJae Park <sj@kernel.org> wrote:
>
> On Fri, 26 Dec 2025 10:48:31 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Fri, 26 Dec 2025 at 04:50, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Thu, 25 Dec 2025 11:35:33 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > >
> > > > On Thu, 25 Dec 2025 at 09:32, SeongJae Park <sj@kernel.org> wrote:
> > > > >
> > > > > Hello JaeJoon,
> > > > >
> > > > > On Wed, 24 Dec 2025 18:43:58 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> [...]
> > > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > > index babad37719b6..2ead0bb3c462 100644
> > > > --- a/mm/damon/core.c
> > > > +++ b/mm/damon/core.c
> > > > @@ -1462,6 +1462,9 @@ bool damon_is_running(struct damon_ctx *ctx)
> > > >   */
> > > >  int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
> > > >  {
> > > > +       if (!damon_is_running(ctx))
> > > > +               return -EINVAL;
> > > > +
> > > >         if (!control->repeat)
> > > >                 init_completion(&control->completion);
> > > >         control->canceled = false;
> > > > @@ -1470,8 +1473,6 @@ int damon_call(struct damon_ctx *ctx, struct
> > > > damon_call_control *control)
> > > >         mutex_lock(&ctx->call_controls_lock);
> > > >         list_add_tail(&control->list, &ctx->call_controls);
> > > >         mutex_unlock(&ctx->call_controls_lock);
> > > > -       if (!damon_is_running(ctx))
> > > > -               return -EINVAL;
> > > >         if (control->repeat)
> > > >                 return 0;
> > > >         wait_for_completion(&control->completion);
> > >
> > > Let's assume DAMON is terminated between the damon_is_running() and
> > > list_add_tail().  In the case, the control->fn() will never be called back.  If
> > > control->repeat is false, this function will even inifnitely wait.
> >
> > As you said, there are cases where kdamond is terminated(stopped) in
> > damon_is_running() and list_add_tail().  It may be a very rare case, but
> > I missed this case.
> >
> > >
> > > I think we should keep the damon_is_running() as is, but further check if it
> > > was terminated without handling the control object, and remove it from the list
> > > in the case.  Like below.
> [...]
> > However, the damon_call_handle_inactive_ctx() function is to post-process
> > the duplicate addition of control->list.  Rather, it is more efficient to
> > prevent duplicate additions in advance, as follows:
> > I have tested the following and it works fine.
> >
> > @@ -1467,11 +1496,14 @@ int damon_call(struct damon_ctx *ctx, struct
> > damon_call_control *control)
> >         control->canceled = false;
> >         INIT_LIST_HEAD(&control->list);
> >
> > -       mutex_lock(&ctx->call_controls_lock);
> > -       list_add_tail(&control->list, &ctx->call_controls);
> > -       mutex_unlock(&ctx->call_controls_lock);
> > -       if (!damon_is_running(ctx))
> > +       if (damon_is_running(ctx)) {
> > +               mutex_lock(&ctx->call_controls_lock);
> > +               list_add_tail(&control->list, &ctx->call_controls);
> > +               mutex_unlock(&ctx->call_controls_lock);
> > +       } else {
> > +               /* return damon_call_handle_inactive_ctx(ctx, control); */
> >                 return -EINVAL;
> > +       }
> >         if (control->repeat)
> >                 return 0;
> >         wait_for_completion(&control->completion);
>
> I think this is not differnt from your previous suggestion, and thus it has the
> same issue.  What if DAMON is terminated between damon_is_running() and
> list_add_tail() call?  Please let me know if I'm missing something.

I think it is good idea to insert a barrier() between damon_is_running()
and list_add_tail() to prevent context-switching.  What do you think this?

Thanks,
JaeJoon

>
> >
> > > If you don't mind, I'll post the above diff as a patch, adding a 'Reported-by:'
> > > tag for you.
> >
> > 'Reported-by:' is OK.  However, please check the above again.
>
> Thank you!
>
>
> Thanks,
> SJ
>
> [...]

