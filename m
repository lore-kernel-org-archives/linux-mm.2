Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA85FE7AD78
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 02:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59556B0088; Thu, 25 Dec 2025 21:19:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E069B6B0089; Thu, 25 Dec 2025 21:19:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09476B008A; Thu, 25 Dec 2025 21:19:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCE026B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 21:19:42 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3F28159FFA
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 02:19:42 +0000 (UTC)
X-FDA: 84260016204.20.42C691E
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 70C5E140002
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 02:19:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j0SCatQX;
	spf=pass (imf09.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766715580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7MwV7wnomdpUA3QvJZeGbNIM+Niz71u03D9NfQ2Qt4=;
	b=lf7xfAdSzy4bH0orZR+cAVIWWWx/CAxo5tIoki0WLbIGEWKYcpIScUWYE84ypT/WysgsQb
	Pre2UgMmNpRtX+41MFSJv6d9Rj2YCV5KZiLjvGu1Af3HYNy59tC3SH9NjE6hIpEEQjvwVt
	+peH7snYiAbY3x+NgjgQR1sI/BsxVfY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j0SCatQX;
	spf=pass (imf09.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766715580; a=rsa-sha256;
	cv=none;
	b=23ag4w5tiJ1eIHM1z+Yn10TDpvnKMkmxYYnJeU/MrUVA3v17BdO6u9JpRWnufu0wFTj9Qr
	3pQMBWQINN6GHjEvVWlEku4VoMXMoptHlSCeGHs5I40ERvkvVCCH+yYvy2IKrY4MiBTbhM
	mHYXob82jl11ZisBvNkIzeUlOtcvm3I=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-78fc0f33998so41461487b3.0
        for <linux-mm@kvack.org>; Thu, 25 Dec 2025 18:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766715579; x=1767320379; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=t7MwV7wnomdpUA3QvJZeGbNIM+Niz71u03D9NfQ2Qt4=;
        b=j0SCatQXPhOy20WoejcubhADXRMGyeGmQrlinKDIFLLwNd/dwdsI0Qp4aMgyvUgkE+
         dpVW2GNRMQ167J2BMS7XVlCqo8lF2n7K7Y4QQY+1Qi10NN3QtpBe+6w8dQNLJh8AkiIs
         yqz0rFJFLzJCM+CALaCo7KCoFGz784e3xsgHZIvtJ3LPF9PJfrh1SgzOccwr3xh44G3n
         IHGUt2cBdWri4mSebi7GBaQ2uhGM4SZdsaMuFsD5TLY8EPyDvG83ImpL2+TlIDQxEAB8
         Bgih76Y27ygUcSFxlT+3u+LDIJD4wy1LYWrZmH3X6fPqPnCT9fLOxS96FJzis3lTs8U5
         HY6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766715579; x=1767320379;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t7MwV7wnomdpUA3QvJZeGbNIM+Niz71u03D9NfQ2Qt4=;
        b=WFq9xj/Wj5oh2gFjHSAZwrnMziblDtgbYdrY0CRLdj81RkZdB5JzbjRe/476j6cr4/
         PcesM5FF4hRIqez9eVgd8ClnyZGLLKlvzCW9adlCK6xMOLNMpRZLRQZsvrasE1Y81fYG
         0Mif1ZLRJ6QXkE8kdbb0S7P8C32MT1X3GDvyb+mhVVus6+x9ea8UY6ocVyjdoduurawC
         kuHv+aCj7Z5n+BX4jMCaEOv1TvK8zzgoLNBZI1UvsWQVpk8Pae4NZQDuIIbL0pF6hg8T
         Unws8GKHb/ClVPr1fTdlN0ASpswiKVwEkwHRneNwrRdg61VS+l/AhODFxvhmssdxlgRV
         yHzg==
X-Forwarded-Encrypted: i=1; AJvYcCXartWefGqqzTQ6Ejg6cXghU20LvOoKHaF5hdd1sLtIPbXC4+mS5hXpAxm2tQ7Qk4AWvWXZPgCHPg==@kvack.org
X-Gm-Message-State: AOJu0Yw27TvoKJ7uMiuRjEl2snIFos0j1TcvLspQjt5t+MiLh412fcpg
	lcJ3+0YaiVuHq+zNe4jzcYbnHjM4pnp3EE0i57TeH59GluNkH/iHgG8t5TnLlhw9dqlapTDGStC
	MAXrUIQxW4klPkKZH6GeEhjBUARDmcoM=
X-Gm-Gg: AY/fxX63OLlE8Pjz/vuZ4tt3d2MVmNILmmNtAAIsqXZ1kfj+WJHvzvi5QqeOBAk7FY3
	PMrJgPpFjrvFHx39FZQvfnBInPAAitWLZ4bsxmjPMR8G11cItG2b6WTUOm15p45IhfsjRZTIcd7
	EKIMmuh8I9aLpejxaM72xU9S9B5tggvA9qkqfj0E0toPHXg22QOjir/dhgWXul0d4EJ6+Z7QhzL
	40xP4f47XbAilkSqDkdnqty0jUglNyo29WcjMGmuhy5RI5ulOWGAuoTFHHMDa92zYTlImKi
X-Google-Smtp-Source: AGHT+IH2ZFQ8GgZ8BOanNglgLtEm635duvNuVsF9Wfc8H6UNreiOxRUqdz6IgbwI87pzbFD1cL2acGM0/OKe7xcIPlc=
X-Received: by 2002:a05:690c:7409:b0:78f:ac82:51e7 with SMTP id
 00721157ae682-78fb403c2d2mr349347387b3.40.1766715579436; Thu, 25 Dec 2025
 18:19:39 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC4dYGqY2pMQktBbO-NWKGE2XXeA1e+6BrP2QtsjM2Dodg@mail.gmail.com>
 <20251225200051.1069-1-sj@kernel.org>
In-Reply-To: <20251225200051.1069-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Fri, 26 Dec 2025 11:19:28 +0900
X-Gm-Features: AQt7F2pXT0e-4_oBLK6sV7pkwmAOSOx89g1eFse8oF9DsLlLzTCpYPnqVGTG6DM
Message-ID: <CAHOvCC4f2xPK_LwFoisdqr_wX-RbdW9KUq48+82CMC=5ViF=ag@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/core: modified control->repeat loop at the kdamond_call()
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, rgbi3307@nate.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 70C5E140002
X-Stat-Signature: ydj8yon5kdpamoydiqo7cibkzqpjp56m
X-Rspam-User: 
X-HE-Tag: 1766715580-15105
X-HE-Meta: U2FsdGVkX1+3gGqeU4PSyLYPGpJjSz2fscDAgt5+vCl1UI90lsi0h8o+ENbEAh1S7WMMDsR55hpjwQryRUBeuh+ORwQjeViG3aklII7tGVPnTKat7f6aqGUpFm3jhpmUkR1+er6R7Fyqg6ikVBk7FPtP0A1BECXkhx33637TGd1R/5H3nkvbuATNRsAYNGeT3xR0zqD/VXRvyz794o+6AOK74iOP2GRgMsmrAJ53vLuo1kQXQrGbpZ+kIhR0EbDkx4s0GpJgmevnqwQq3pzsAkfUVztWebfAlJpZHg3SBXfbiVpBu24AFrCG9oS0e3qR0ft59sTXdW0oVxtHtuIW36+9l8662wytrjWn2I37CLNDGd2kaKCKy1yy4ZfQ+I+wgxdN8Vf+yBXzaKd42GFCdu5jWlRKVmtXeaIAqNb+oH+9o6ahAAVDxVfOt8wCMYZomLlCD2+gwVsYua/HhbuLoIEEgYA/hTj6OwvAIyAJwf7gilQKxckcQbbXZgV/Eyu6J/ipmVDqzwIke1ONXYKLTzI6X4FYYii9jTSlbqSyxizNltRQj80m4h2881OwfBZtodLGx4riPKkpu3/KgKNYDhfMtXmbx+8pSPSVT7oN3FuJyCgBCITBpYxtCraYe5K4YcA+JrG+QiJIvnXHJYNWGhelMGHa6rbR483aQwrOrjWIHh04KQzHq/5E/5sHxoAkmS0g+81wq2invHTrwnyfSCfkeFzjkDvOirnbIVmvmhD6vqq5RJ06mtpqbcCyRWwfPFWe00qbzy4oR+SkB3cxH0Y2T5TmLt89s1sr4IOU0ZyUwPuiK8TNDm+ZawkG86ykA4ybLY8ui/d3MjD0XvcPJvFQswisFPUeLO5WLsKxrVGvLzu9UAbdk4SpI7E/2AgopPjZqh7uT6+huEPJfvxMR4/BS+CO+sJORCSqoWV3FpaWZALNLcqi/C6Qp6lz3ETO2grd29ZqeaOVQgJd2Ov
 6txbaP4/
 gDlj1u8zPHdrmUGBMBPy/wlmzP5he7TDlcrqYcgBSsvIIuatwul94DCRmjuPdR3TB8QgdvuZMwZFWBavX70/Y0mJcx1I4fshwB8zEkbuDO0DB0x/B9cDEUbnQESlnI7Xket+T5czgQ//X2ac+6Cop4+LHI3Wndx6Gk4gNMwaC0L+aCVSvMPZcru/6+i0WtSYQGB1DebgkR56m0yP5Olw+3FYJz8I2yroZ4L8o9HLOa+oltf3nlsFTjWQAcw9o1IXc8yzg9Z5ufgL4YJ0Uuna48UUaaL+4Zgm/+2mWshsV5X5206fvY5M8u8RLIcj8ZcDhRpu1DTdPriTnjpIBkrNmVocEg9FdQ6L2Hm3KlSPSy8I0ySxNmOyM7+tbSVFvwCUrQkDsn88vZfIQBxmrocjaPZ0HtzyBdLa1FlO2mS6u+REE0b3gqXXtxOUfuHYjMYacL0DJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Dec 2025 at 05:01, SeongJae Park <sj@kernel.org> wrote:
>
> On Thu, 25 Dec 2025 12:10:30 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Thu, 25 Dec 2025 at 10:07, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Wed, 24 Dec 2025 21:43:54 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > >
> > > > The kdamond_call() function is executed repeatedly in the kdamond_fn()
> > > > kernel thread.  The kdamond_call() function is implemented as a while loop.
> > > > Therefore, it is important to improve the list processing logic here to
> > > > ensure faster execution of control->fn().
> > >
> > > That depends on how critical the performance is, and how much complexity the
> > > optimization introduces.  I have no idea about if the performance of
> > > kdamond_call() is really important.  If you have a realistic use case that
> > > shows it, sharing it would be nice.
> >
> > This is because kdamond_call() is called repeatedly in kdamond_fn().
>
> Yes, it is repeatedly called.  But, my question is, does it impose overhead
> that great enough to make a negative impact to the real world.

I agree that the overhead is not that much since there are only a few lists
added to ctx->call_controls(CTX.head).

>
> >
> > >
> > > > For ease of explanation,
> > > > the data structure names will be abbreviated as follows:
> > > >
> > > > damon_call_control.list: C.list
> > > > ctx->call_controls: CTX.head
> > > > repeat_controls: R.head
> > > >
> > > > the execution flow of the while loop of the kdamond_call() function,
> > > >
> > > > Before modification:
> > > > Old while loop:
> > > >
> > > >         CTX.head <-----> C.list <-----> C.list <----> C.list
> > > >         ^                   |                           |
> > > >         |               if (C.repeat)            if (!C.repeat)
> > > >    restore: only one        |                           |
> > > >    list_add_tail()        list_del()                  list_del()
> > > >         |                   |                           |
> > > >         +                   |                       complete()
> > > >         R.head <------ list_add()
> > > >
> > > > To process C.repeat above, we use an additional list, repeat_controls.
> > >
> > > Your above abbreviation didn't explain what C.repeat is.  Maybe you mean
> > > 'damon_call_control.repeat'?
> >
> > Yes, that's right.
>
> Thank you for confirming.
>
> >
> > >
> > > > The process of adding C.list to repeat_controls and then restoring it back
> > > > to CTX.head is complex and inefficient.
> > >
> > > I agree.
> > >
> > > > Furthermore, there's the problem
> > > > of restoring only a single C.list to CTX.head.
> > >
> > > I had to take some time on understanding what this mean.  And it seems you are
> > > working on an old version of the tree, and therefore saying about an issue that
> > > already fixed by commit 592e5c5f8ec6 ("mm/damon/core: fix memory leak of repeat
> > > mode damon_call_control objects").
> > >
> > > Please use mm-new as a baseline of DAMON patches, unless there are special
> > > reasons.  If there are special reasons, please explicitly specify.
> >
> > This patch is based on v6.19-rc2.
> > I will continue to refer to mm-new and damon-new.
> >
> > >
> > > >
> > > > Below, repeat_controls is removed and the existing CTX.head is modified to
> > > > loop once(1st rotation).  This simplifies list processing and creates a
> > > > more efficient structure.
> > > >
> > > > Modified while loop:
> > > > Not used repeat_controls:
> > > >
> > > >         CTX.head <-----> C.list <-----> C.list <----> C.list <-------+
> > > >                             |                           |            |
> > > >                         if (C.repeat)            if (!C.repeat)      |
> > > >                             |                           |            |
> > > >                           list_del()                  list_del()     |
> > > >                             |                           |            |
> > > >                             |                       complete()       |
> > > >                             |                                        |
> > > >                           first --------> list_add_tail() -----------+
> > > >
> > > >         if (C.list == first) break;
> > > >
> > > > Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
> > > > ---
> > > >  mm/damon/core.c | 37 +++++++++++++++++++------------------
> > > >  1 file changed, 19 insertions(+), 18 deletions(-)
> > > >
> > > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > > index 824aa8f22db3..babad37719b6 100644
> > > > --- a/mm/damon/core.c
> > > > +++ b/mm/damon/core.c
> > > > @@ -2554,42 +2554,43 @@ static void kdamond_usleep(unsigned long usecs)
> > > >   */
> > > >  static void kdamond_call(struct damon_ctx *ctx, bool cancel)
> > > >  {
> > > > -     struct damon_call_control *control;
> > > > -     LIST_HEAD(repeat_controls);
> > > > -     int ret = 0;
> > > > +     struct damon_call_control *control, *first = NULL;
> > > > +     unsigned int idx = 0;
> > > >
> > > >       while (true) {
> > > >               mutex_lock(&ctx->call_controls_lock);
> > > >               control = list_first_entry_or_null(&ctx->call_controls,
> > > >                               struct damon_call_control, list);
> > > >               mutex_unlock(&ctx->call_controls_lock);
> > > > -             if (!control)
> > > > +
> > > > +             /* check control empty or 1st rotation */
> > > > +             if (!control || control == first)
> > > >                       break;
> > > > -             if (cancel) {
> > > > +
> > > > +             if (++idx == 1)
> > > > +                     first = control;
> > > > +
> > > > +             if (cancel)
> > > >                       control->canceled = true;
> > > > -             } else {
> > > > -                     ret = control->fn(control->data);
> > > > -                     control->return_code = ret;
> > > > -             }
> > > > +             else
> > > > +                     control->return_code = control->fn(control->data);
> > > > +
> > > >               mutex_lock(&ctx->call_controls_lock);
> > > >               list_del(&control->list);
> > > >               mutex_unlock(&ctx->call_controls_lock);
> > > > +
> > > >               if (!control->repeat) {
> > > > +                     /* run control->fn() one time */
> > > >                       complete(&control->completion);
> > > >               } else if (control->canceled && control->dealloc_on_cancel) {
> > > >                       kfree(control);
> > > > -                     continue;
> > > >               } else {
> > > > -                     list_add(&control->list, &repeat_controls);
> > > > +                     /* to repeat next time */
> > > > +                     mutex_lock(&ctx->call_controls_lock);
> > > > +                     list_add_tail(&control->list, &ctx->call_controls);
> > > > +                     mutex_unlock(&ctx->call_controls_lock);
> > > >               }
> > > >       }
> > >
> > > Let's suppose there are two damon_call_control objects on the
> > > ctx->call_controls.  The first one has ->repeat unset, while the second one
> > > has.  Then, it seems the 'break' condition will never met and therefore this
> > > loop will never finished.  Am I missing something?
> >
> > You misjudged.
> > If (!C.repeat), it will be removed with list_del() and disappear.
> > If (C.repeat) loops through the loop once, and when it returns to the
> > first, it breaks.
>
> Maybe my explanation was not enough.  Let me explain a bit in more detail.
>
> In the scenario I mentioned, at the first iteration of the loop, 'first' will
> be the first control object, which has ->repeat unset.  The object will be
> removed from the list.  In the second iteration of the loop, it handles the
> second object, which has ->repeat set.  The object is added to the list again.
> In the third iteration, the loop runs for the second object again.  Because it
> is not same to 'first', the 'break' statement is not reached.  The loop
> continues forever.
>
> Am I missing something?

Thank you for your detailed review.
There may be cases where C->repeat=false is the first control.
This can also be solved simply as follows:

@@ -2567,9 +2599,6 @@ static void kdamond_call(struct damon_ctx *ctx,
bool cancel)
                if (!control || control == first)
                        break;

-               if (++idx == 1)
-                       first = control;
-
                if (cancel)
                        control->canceled = true;
                else
@@ -2589,6 +2618,8 @@ static void kdamond_call(struct damon_ctx *ctx,
bool cancel)
                        mutex_lock(&ctx->call_controls_lock);
                        list_add_tail(&control->list, &ctx->call_controls);
                        mutex_unlock(&ctx->call_controls_lock);
+                       if (++idx == 1)
+                               first = control;
                }
        }
 }

Thanks,
JaeJoon

>
>
> Thanks,
> SJ
>
> [...]

