Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BA32E92FE3
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 00:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CF9A6B0088; Mon, 29 Dec 2025 19:14:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67C1E6B0089; Mon, 29 Dec 2025 19:14:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5888D6B008A; Mon, 29 Dec 2025 19:14:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 43F836B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 19:14:52 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A12128D0B1
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 00:14:51 +0000 (UTC)
X-FDA: 84274216782.22.93E527D
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id C11081C0003
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 00:14:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eT4GB83F;
	spf=pass (imf20.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767053689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbsM/e9eqvn9ArPBzYyguMVBWmbdWJHQH9hQHEYPUeQ=;
	b=D2jUEj9sb11EROXJbj+iES2zO8hrncwQ0XWBPozQTUkZIMTuXIOqXM/GdazpcF24Uqan3B
	9lQEaBMqntdXIZh/InFhKfzV7Y4P6HZK2UOA5aNgbKsKMxwtmGNTn/4ZwKIWKRGJXfk3UN
	j3hS1WtFzv3Sd3plSCchbWuEAkApiwA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eT4GB83F;
	spf=pass (imf20.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767053689; a=rsa-sha256;
	cv=none;
	b=EqM799fUQXmngJ9wG00AyvpMfK/YVrZv6KwhvWy8QULM0JiDzGadYImzn5DnHiXOmX2bSq
	8PiHMBvehCEgM/3mH8Huddv5wTALKGeBPRuoBEHA3uaJpA0rdYM+MV1fuF/JZYm7rnjpZm
	8yGZKdZPf/kxNtWwGgvlqWdEelnjdVI=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-78e7ba9fc29so84335187b3.2
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767053689; x=1767658489; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HbsM/e9eqvn9ArPBzYyguMVBWmbdWJHQH9hQHEYPUeQ=;
        b=eT4GB83FR/7vIz/dgPn/qLt/njHybgzWo21UTHfGslX/iKJp3MzzBJGxuKLfwpGWge
         A/a2eelhN7ZdaRYU33BxdJvbz1coGmhT9uN4HSwo4v3gEBE2EQF9xzphovcuA4TMEPVr
         UhdP66M0hAwtW+7oiKud4/rmz+ihKnCVHuUyPHsCJVnnsNWQeq3f5uplgSdfzYCesyDc
         SGLarmMepRHEKWaRstan6vJJnay3gpDIKxS3Qn8AEJhrgDIQQPnv5RznHO8JJjXA9MXz
         wxXNwDkkbMCOYj9Rhk6y57GTvPYulsJ/3mT/sUMDrrsG6fpEvgX+XnBIxze5UVwIhwLR
         vPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767053689; x=1767658489;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HbsM/e9eqvn9ArPBzYyguMVBWmbdWJHQH9hQHEYPUeQ=;
        b=i9dNnlN/0ACYKN5wu0hIe5szTdchpEyO1Igo6/Zp/5EWVnOiFd5HrmkFZN3irfZyRW
         Vfr3gmBwnzsdq3wCLSrCwerCbzfNuxfyrD3MXph1lSI/Fgt6I7wNjdiqECgJ3POFXGZJ
         SGXzf4rVUROeYG0Y6ipSy1cg1y/dAEamLhIrM6ctFh72w2cMvScsSKwFesDk1BkxaVQX
         Seu30sO0eIMdh7s5N4tUg9icTxuitKpacj7y4YWhpb+/pJBkzQICb3B+ub2HodongoDN
         2HsQamyf11biOVntOYv/f2yF8SnDwia1uoiJsXJjq/IoO5KKqhB2bIX2kFXyOnjT+Xgx
         GXCw==
X-Forwarded-Encrypted: i=1; AJvYcCVmyNFBdJmlUaSBtQMeQkew4IAjCX2aM6rZhgS/SCWv2pYsx+yqMo9YFs/d6bAodhbQ01JUTsn5qA==@kvack.org
X-Gm-Message-State: AOJu0YzBJOF3KSKVmMcnN4mQhFxYjZ96YU++smZbbmtgCXGTR/YwkA/x
	PlkkP7OTuytYAEs0TUrjdf2abeVje2vqr/RhU9+pfaaguqBo7QRH04Sfnjx5htHiE0cBSZUJdnQ
	sRKv2E6CiQR3PXlU98kKzAs/DKn4bEMA=
X-Gm-Gg: AY/fxX5vzGgm3eIzFaK3pYEFtZkee39NuE3XcdqN/1Lk0UxcdclXTpynNIvioIOmczd
	aemIrPoJFOPIbKkfIqRWYi0rBeQUZvSPCbjmFv9FA91VI+ETBxr/dX8OKEp4DAErp98dyKDznvI
	qrEXX6PDWak4zkI96+Z4mLyHNpHiNdyU3UF2zfAMCK85gqfBhy1m96Y9bqzG1sj2f4hKhAp9RxI
	E+JrAoMlyVDo7DEv8Qy+9aqFEFbQrhTdVhjKVmlGBOjsVRMSmChn4VgjUIi0RZD3vpm+NVK
X-Google-Smtp-Source: AGHT+IGWDE5Zp4wjstAjn/bJPigaugwDh5nqHV4zC8agPZgz4iwoP/AoWWwMZiCLso7z9MaoOtDG74GvqD3NmLEfrlU=
X-Received: by 2002:a05:690c:6c87:b0:78c:10d6:1e8b with SMTP id
 00721157ae682-78fb3f28e07mr271445467b3.26.1767053688721; Mon, 29 Dec 2025
 16:14:48 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC4f2xPK_LwFoisdqr_wX-RbdW9KUq48+82CMC=5ViF=ag@mail.gmail.com>
 <20251226183122.254549-1-sj@kernel.org> <CAHOvCC6L7TAX5Pu4pLVvYBsGc7tVYexgqJmiZ7UEhu7N4_jubw@mail.gmail.com>
In-Reply-To: <CAHOvCC6L7TAX5Pu4pLVvYBsGc7tVYexgqJmiZ7UEhu7N4_jubw@mail.gmail.com>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Tue, 30 Dec 2025 09:14:37 +0900
X-Gm-Features: AQt7F2pifKyEAF_NYMZ2gSwBpLyyKdjYsBNwTOXlgNDEAHSZnzjBiki3Rp1xTEU
Message-ID: <CAHOvCC7ondk_Gjhetb7Wtsz60c1dRmt_h9MwT8uwh0vwaktDLw@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/core: modified control->repeat loop at the kdamond_call()
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, rgbi3307@nate.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C11081C0003
X-Stat-Signature: rt7r9gobn9cac4neo3eo9jgf9xnfj5gs
X-Rspam-User: 
X-HE-Tag: 1767053689-505062
X-HE-Meta: U2FsdGVkX1/J9041C+DhU04TQxj0hC5va9qqn2QqixSQxP6BMntjt5h4iDhZDx+V/EXlXe6GaCxI8rtW05mfqZwwps3gVRr3gXA8e/HarLOz31aaC4nOxrkV/8frSDuaTNe9RYxVasH80eTxnpqzD4gsxgIe/cyG0dOjqSYkHtjM+Tn2e0272GLR2vaUIfDh4Tai8pq0ZCsjuXkOu7BXLOdIvB3yBlPJ/43Wfnmc+/JqoChPofSuvuy5vbfbuar6OVS3eubCwlM4IhO+YZ+cN14pUh8H/iE2j24Nj21u0tI65SY7DHGU1Gi0S/XWOQRDeDOuXpiQYOEC/BQxpAXubbxsCKD9fHIfoS12rhDvwH1MGvgC/kkS3/d1vrVW/bG8ycF7T+GvTb8qU53OdO5KNymeFpAc/4JH14+KHR7rzdNruD8rmdABGrCPiAEd9RWeIAvszfujVa5netzDtXWAphCfOZtyHjmz+IHtrQSSiDbZCBeVWqARb8PB/vlQm4kcerLMf7unktdCEK7qyt4i1TJ1x9gXk8+q5JHhCx3x95MyNrrha6cB/LrsIfXevDAusfJ6OD6wc1I2nzawgu0r9xAWYW2wqJOJD442fxtzrMgh9lLaW8dolTsNX0xw5Nph+fROuRGUERDiN20fPyKOzd7qQxUUpmuHMMGtPqMRkBUXrRlSFl8KGxlT+NpjWuGmia6eQLnVL3nV1j+cFBTRHDXbYKQyDar5PcSOJYWKcwhHfHwoOnrDWa55+C2XOA/WZUuw0D8xoo4Rsn3RoPc+IrmL0Nw4tnEjyrKzrKyLxXcnG1Erv47HdslQA7NH4hQ+3A6SAWFVApwfDHAmcyxaTU3/K24xb3uJOzZ/2JuOEb7hBS1Pk6ihVGF9eZyqKqm7dCYpWRJcXD1gro71Fj0pwHAkuQF0rokS7ehrZMoDp2d7JA1NZksHLiD2ovHFLQdt0AmfXKLeDU55TWIviFI
 STUFLG2p
 HM/ElyKZPNGGcDkvzq4lx4o2lRUK4g+SJekaMDw8aYnOWU9BHhUCrWncqtAWMEbpgx774tjGRT/wrFFbSy+ix+0SfRjfp3OuSPBlUO2tgpIZCMRCXTqn6AKVP1Yyk/AjkxQBT9Lw3wb48N5pNHY+HjGRVZdJ8j9IMuRsuwR9qjYikgSLmQ6AbFLj4ygbNec2ov6bQn1GBlIcWtaTZgf47Th+1takT3EsPL/aLlm04Shech/K8rfE9g0d7U4AAbtmOWck5I7/WMYJFqb6ybU3T+sOiFm45bN6/V7fsHzBUuytWCtCg+w0MdoBqc8hWhn+0+yBRKUTj+0yb9DqlfinVXbolVeVhdUrqCBSCu2ecXDvdoDqzRJR4ItSZj2tLcxaW/efka9hYmACs1iqd/g713erNoAAOL1D50SX2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I will reflect the above in patch v2.
Would you like me to resend patch v2 ?

On Sat, 27 Dec 2025 at 08:42, JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> On Sat, 27 Dec 2025 at 03:31, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Fri, 26 Dec 2025 11:19:28 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > On Fri, 26 Dec 2025 at 05:01, SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > On Thu, 25 Dec 2025 12:10:30 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > > >
> > > > > On Thu, 25 Dec 2025 at 10:07, SeongJae Park <sj@kernel.org> wrote:
> > > > > >
> > > > > > On Wed, 24 Dec 2025 21:43:54 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > > > > >
> > > > > > > The kdamond_call() function is executed repeatedly in the kdamond_fn()
> > > > > > > kernel thread.  The kdamond_call() function is implemented as a while loop.
> > > > > > > Therefore, it is important to improve the list processing logic here to
> > > > > > > ensure faster execution of control->fn().
> > > > > >
> > > > > > That depends on how critical the performance is, and how much complexity the
> > > > > > optimization introduces.  I have no idea about if the performance of
> > > > > > kdamond_call() is really important.  If you have a realistic use case that
> > > > > > shows it, sharing it would be nice.
> > > > >
> > > > > This is because kdamond_call() is called repeatedly in kdamond_fn().
> > > >
> > > > Yes, it is repeatedly called.  But, my question is, does it impose overhead
> > > > that great enough to make a negative impact to the real world.
> > >
> > > I agree that the overhead is not that much since there are only a few lists
> > > added to ctx->call_controls(CTX.head).
> > [...]
> > > > > > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > > > > > index 824aa8f22db3..babad37719b6 100644
> > > > > > > --- a/mm/damon/core.c
> > > > > > > +++ b/mm/damon/core.c
> > > > > > > @@ -2554,42 +2554,43 @@ static void kdamond_usleep(unsigned long usecs)
> > > > > > >   */
> > > > > > >  static void kdamond_call(struct damon_ctx *ctx, bool cancel)
> > > > > > >  {
> > > > > > > -     struct damon_call_control *control;
> > > > > > > -     LIST_HEAD(repeat_controls);
> > > > > > > -     int ret = 0;
> > > > > > > +     struct damon_call_control *control, *first = NULL;
> > > > > > > +     unsigned int idx = 0;
> > > > > > >
> > > > > > >       while (true) {
> > > > > > >               mutex_lock(&ctx->call_controls_lock);
> > > > > > >               control = list_first_entry_or_null(&ctx->call_controls,
> > > > > > >                               struct damon_call_control, list);
> > > > > > >               mutex_unlock(&ctx->call_controls_lock);
> > > > > > > -             if (!control)
> > > > > > > +
> > > > > > > +             /* check control empty or 1st rotation */
> > > > > > > +             if (!control || control == first)
> > > > > > >                       break;
> > > > > > > -             if (cancel) {
> > > > > > > +
> > > > > > > +             if (++idx == 1)
> > > > > > > +                     first = control;
> > > > > > > +
> > > > > > > +             if (cancel)
> > > > > > >                       control->canceled = true;
> > > > > > > -             } else {
> > > > > > > -                     ret = control->fn(control->data);
> > > > > > > -                     control->return_code = ret;
> > > > > > > -             }
> > > > > > > +             else
> > > > > > > +                     control->return_code = control->fn(control->data);
> > > > > > > +
> > > > > > >               mutex_lock(&ctx->call_controls_lock);
> > > > > > >               list_del(&control->list);
> > > > > > >               mutex_unlock(&ctx->call_controls_lock);
> > > > > > > +
> > > > > > >               if (!control->repeat) {
> > > > > > > +                     /* run control->fn() one time */
> > > > > > >                       complete(&control->completion);
> > > > > > >               } else if (control->canceled && control->dealloc_on_cancel) {
> > > > > > >                       kfree(control);
> > > > > > > -                     continue;
> > > > > > >               } else {
> > > > > > > -                     list_add(&control->list, &repeat_controls);
> > > > > > > +                     /* to repeat next time */
> > > > > > > +                     mutex_lock(&ctx->call_controls_lock);
> > > > > > > +                     list_add_tail(&control->list, &ctx->call_controls);
> > > > > > > +                     mutex_unlock(&ctx->call_controls_lock);
> > > > > > >               }
> > > > > > >       }
> > > > > >
> > > > > > Let's suppose there are two damon_call_control objects on the
> > > > > > ctx->call_controls.  The first one has ->repeat unset, while the second one
> > > > > > has.  Then, it seems the 'break' condition will never met and therefore this
> > > > > > loop will never finished.  Am I missing something?
> > > > >
> > > > > You misjudged.
> > > > > If (!C.repeat), it will be removed with list_del() and disappear.
> > > > > If (C.repeat) loops through the loop once, and when it returns to the
> > > > > first, it breaks.
> > > >
> > > > Maybe my explanation was not enough.  Let me explain a bit in more detail.
> > > >
> > > > In the scenario I mentioned, at the first iteration of the loop, 'first' will
> > > > be the first control object, which has ->repeat unset.  The object will be
> > > > removed from the list.  In the second iteration of the loop, it handles the
> > > > second object, which has ->repeat set.  The object is added to the list again.
> > > > In the third iteration, the loop runs for the second object again.  Because it
> > > > is not same to 'first', the 'break' statement is not reached.  The loop
> > > > continues forever.
> > > >
> > > > Am I missing something?
> > >
> > > Thank you for your detailed review.
> > > There may be cases where C->repeat=false is the first control.
> > > This can also be solved simply as follows:
> > >
> > > @@ -2567,9 +2599,6 @@ static void kdamond_call(struct damon_ctx *ctx,
> > > bool cancel)
> > >                 if (!control || control == first)
> > >                         break;
> > >
> > > -               if (++idx == 1)
> > > -                       first = control;
> > > -
> > >                 if (cancel)
> > >                         control->canceled = true;
> > >                 else
> > > @@ -2589,6 +2618,8 @@ static void kdamond_call(struct damon_ctx *ctx,
> > > bool cancel)
> > >                         mutex_lock(&ctx->call_controls_lock);
> > >                         list_add_tail(&control->list, &ctx->call_controls);
> > >                         mutex_unlock(&ctx->call_controls_lock);
> > > +                       if (++idx == 1)
> > > +                               first = control;
> > >                 }
> > >         }
> > >  }
> >
> > Yes, that should fix the issue.
> >
> > And it seems 'idx' is being used for only this?  If I'm not wrong, I think it
> > may be easier to read if you do something like 'first = first ? first :
> > control' and drop 'idx'.
>
> It's better removing idx.
> Thanks.
> JaeJoon
>
> @@ -2587,7 +2587,6 @@ static void kdamond_usleep(unsigned long usecs)
>  static void kdamond_call(struct damon_ctx *ctx, bool cancel)
>  {
>         struct damon_call_control *control, *first = NULL;
> -       unsigned int idx = 0;
>
>         while (true) {
>                 mutex_lock(&ctx->call_controls_lock);
> @@ -2618,8 +2617,8 @@ static void kdamond_call(struct damon_ctx *ctx,
> bool cancel)
>                         mutex_lock(&ctx->call_controls_lock);
>                         list_add_tail(&control->list,
> &ctx->call_controls);
>                         mutex_unlock(&ctx->call_controls_lock);
> -                       if (++idx == 1)
> -                               first = control;
> +
> +                       first = (first) ? first : control;
>                 }
>         }
>  }
>
> >
> >
> > Thanks,
> > SJ
> >
> > [...]

