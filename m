Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 401F8E784BE
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 03:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BD1C6B0088; Wed, 24 Dec 2025 22:10:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36B7F6B0089; Wed, 24 Dec 2025 22:10:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26CCF6B008A; Wed, 24 Dec 2025 22:10:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 136516B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 22:10:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE6F91A0557
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 03:10:43 +0000 (UTC)
X-FDA: 84256515966.25.29FCE1D
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1BE1E1A0015
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 03:10:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IqkH4iUO;
	spf=pass (imf19.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766632242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQpZi4UJdiEoSRKQp+EJ/hQpHOcHhJkN7UpOORPmbrk=;
	b=NTQdA9Gaa318PXISrnyx1eNddL3F1Gf6ZtIIDRCBAPsH65IL5dNVqtKa0LL7mdIuQbmdW6
	Mox9RuZvEURSvwHzX16YORrWw8Ke8ca7B9JJI8927k3JsvXmTSHtaGuGhI1kwlfCoEwGgu
	0NYSxONO7Q6vXxQBrgZFPVfPchmo2mg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IqkH4iUO;
	spf=pass (imf19.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766632242; a=rsa-sha256;
	cv=none;
	b=syQYYTaIaIChl6MCcekQsnaUH0GJGWlYfJKv9mVg/6jIDzwXtRXyQn0FBcuMu/MKBCH22o
	NBIIIxLX97MX5G8n7qEasZgfBqmeTFfoHMs+o/0J4DJjYMZ+7m5TIMLbbrUvvdJLl4W4Qa
	VzYMrQcBUKV74UW7K2CrFF+mtJEx43I=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-644798bb299so5273607d50.3
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 19:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766632241; x=1767237041; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aQpZi4UJdiEoSRKQp+EJ/hQpHOcHhJkN7UpOORPmbrk=;
        b=IqkH4iUOaDVwYC4QUCzJP5Fgk5UKGxKYz2KwuWJWQkqhxTJzfNWRut1vtySJgfnA7F
         H+ORhrfwbzCD3HjsUck7SksBcVh2oD24R99PCtVYGSg9gEqBFWbuITfid4QqVLPLClMj
         OhS9gBCVpvSEI9eMBDuBiI9/kedPr/FAFvFGKZiLUOBYP82fzwkXjO0DiBDlTQbzEvB3
         BI3BmlRWbZ+5WWEcSkMZ/yb1Apju8x/UXamgh/uJDSB4+Lbs+MPVqdRDd2iI98UnvnrT
         3bWLErbtpWUjrVDofM0vm9ojDye6M/iZGP7IsO7pn931SlwJBwFJZIAXQm3HrcwK5xhr
         kB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766632241; x=1767237041;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aQpZi4UJdiEoSRKQp+EJ/hQpHOcHhJkN7UpOORPmbrk=;
        b=eX5qPV8EtqAnCSSZtMNghUpCczHt61kCAXjHSRgFWSW7C3AJagOfX68FAuSf2pNURL
         3rPWv1WLNvVC2X/5t5V9ryOdus4K9HrImN8g33vTKe3usLUcHl+o+cEe9BnSSdIZqonG
         Ea3y6w17qjtAK9thlx9oXiDVNXnbAuIKY6H/bP4h0gB07OX5GbLm1J+j2Pg58deQJ0og
         9mOnrlmuufLR4HiizC377jxM4C3SpS0shX+8yVTDmX4EWyczIedvrWetZYS4xyStjoY5
         B7LVoV18rXSytfHAxm5qn207WrVgFar/b7k4qw6myPT7SgRuUgf+bYJIj7sSfWW3Fxi+
         6DDQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3Hca6gLD9kFXLRkSSadvUByqxSlHVpQ3mIVxZC5m4QLnabz2hXPVH2LTlCFJahKUfgsuo+BwWaw==@kvack.org
X-Gm-Message-State: AOJu0YzwDCOZ0GEnd4hd3X/DvqZrsxlbz6Hpzb/h/b6GpHh9PT7dd48i
	kl1dTj242dHNigAnIs/2Js0R3MgFn4QE/DZAPXcqS8XthAy/J4EW8Guz1t/4tT+/McKpXdwy1WW
	82MHM/ngrbEAu85sEAlnis3iQKP0MpUM=
X-Gm-Gg: AY/fxX6/uLVvKfVjNhSfUmwQQAHOxcdSaGFA5kJQPppL1nLBuUr1bKQdsuULfwZlcG8
	3qYlC4KJbF2caLYS9aWP4x74ImbEIBqRK4eamd5nluRxJUTQW2zq0l3gNf9HHlcMM5lRFRmXZX9
	FRj1AqHn7rDjpvvjBnZKSoRzEPDKoMNsg9GoVGGgJigIEaj66BQCsjYuhf0dqj15n1TcdEpIS0O
	WsJKazgqO+YFSsE8GIhn9gE0JUnRO3ynad4oe8KMRV/604h0HI4iyJogi8s9xllvDBZHVkcfY8g
	Wbr1I8Q=
X-Google-Smtp-Source: AGHT+IFI/4jYIrbnYLxGxYERk0hWCg/zYIwlO8H0PSAGU8doebIcVkjcpRIgVRxR9/d9/XaOOElXqzjwwAEBVgnfZT0=
X-Received: by 2002:a05:690e:588:b0:63f:a399:3972 with SMTP id
 956f58d0204a3-6466a8afb75mr13151737d50.56.1766632241049; Wed, 24 Dec 2025
 19:10:41 -0800 (PST)
MIME-Version: 1.0
References: <20251224124355.31667-1-rgbi3307@gmail.com> <20251225010722.14746-1-sj@kernel.org>
In-Reply-To: <20251225010722.14746-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Thu, 25 Dec 2025 12:10:30 +0900
X-Gm-Features: AQt7F2pSRmmDbIKVYa6sVJn212ElrKJ-ezt0GwJxsUDhXwpEW3IpcJ0OLS-hIGM
Message-ID: <CAHOvCC4dYGqY2pMQktBbO-NWKGE2XXeA1e+6BrP2QtsjM2Dodg@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/core: modified control->repeat loop at the kdamond_call()
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, rgbi3307@nate.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Stat-Signature: amcn6x51yuxbgfad7d9zgm3c4ghwbwwy
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BE1E1A0015
X-HE-Tag: 1766632241-261285
X-HE-Meta: U2FsdGVkX190MwR0558y4rfJe2Ii9N5Lma/f484wIAuWvxKZADjFCW74mbtWddVNE7eIVia1lLEuacFQjxo4jrSIABAYq2L2s7d9rt4H6tBh+tpfoOmCSZgNGdlsMffaWB5kK5hlqZLfKMoCspREuYmEYunfk7I5Tbo6TN6c7czz3QGn7oftazznE9xhd+3Tb10HYSXJ9WXnMjW+MbTXqwhD1hcF9mLy7SN1ePehK0sMv2nJh4OW5ezBX8e1MVFeO3/reXKmrij1sEvAAtVpT4zN+gl5HJCGx+c5JM4GEgAtC/LHAd8JH60vBga4AbVa6Yb7A3eL4D+p6QSlu4o61Lnhm26+GUM0V4gZ2SiC8mZ7vxu4iZ08Do13WwyrKsFKKyq2xOtkxNBGgbB/gW+06/x42cgYi/jV91wAwAlVrw6pZnpvAMk7c6VrtCPqEJeHUmaTi/1HRf+dfb+cL5lyXNXZgr9n/oPEXacg5Tq8GoA0WiW8Eg8ByxcoVnFMCWjFQwsh6yVWld+sP0CUhdHxknpADHSQOeUN11INB93FC+eA3Zhvlty32lssIG//XQIbv/PhOS3Hw3N2K4j2K+0STiK/X6qYaFioe+pEtTKUW3uZoIb+uV/winwDl9fgckudB0ohtOmvKkfvmcjNwZyZG2m/PfKay8hLrCfM//+Mx/FkHTDDF0IFJmkLYXwklzKRAVQkyHWyYQHNSf9QKUbXQ5dMI84/FimRssReLTTPxo1jH5nEakjTVXNyknCAfo8OVY3Gb4WBKbEtLdiojdTw6sBYMD073W25Onii2AHDsfdCX/E20vH2eyiS2TMXC6YNyq2pQlMWMsCM7cJx57zyAzvt1MOOh/jqwGpmDjpaTkniGG7jglENBcDVS1QMKdEA0VakvTUsj1b+HeD1kgnSSZkAs9apO/suE7qooE5ILkTSo+eYD7M1S3TmeCcyN28iOzQ0LKeChKK1HHrJpzi
 dKjVPrfy
 5R9Vnznw7GaMVylZ9sCq++xrjKX2onN2z8DXeXWX5F7iFAs4T2z4YTaxM4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Dec 2025 at 10:07, SeongJae Park <sj@kernel.org> wrote:
>
> On Wed, 24 Dec 2025 21:43:54 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > The kdamond_call() function is executed repeatedly in the kdamond_fn()
> > kernel thread.  The kdamond_call() function is implemented as a while loop.
> > Therefore, it is important to improve the list processing logic here to
> > ensure faster execution of control->fn().
>
> That depends on how critical the performance is, and how much complexity the
> optimization introduces.  I have no idea about if the performance of
> kdamond_call() is really important.  If you have a realistic use case that
> shows it, sharing it would be nice.

This is because kdamond_call() is called repeatedly in kdamond_fn().

>
> > For ease of explanation,
> > the data structure names will be abbreviated as follows:
> >
> > damon_call_control.list: C.list
> > ctx->call_controls: CTX.head
> > repeat_controls: R.head
> >
> > the execution flow of the while loop of the kdamond_call() function,
> >
> > Before modification:
> > Old while loop:
> >
> >         CTX.head <-----> C.list <-----> C.list <----> C.list
> >         ^                   |                           |
> >         |               if (C.repeat)            if (!C.repeat)
> >    restore: only one        |                           |
> >    list_add_tail()        list_del()                  list_del()
> >         |                   |                           |
> >         +                   |                       complete()
> >         R.head <------ list_add()
> >
> > To process C.repeat above, we use an additional list, repeat_controls.
>
> Your above abbreviation didn't explain what C.repeat is.  Maybe you mean
> 'damon_call_control.repeat'?

Yes, that's right.

>
> > The process of adding C.list to repeat_controls and then restoring it back
> > to CTX.head is complex and inefficient.
>
> I agree.
>
> > Furthermore, there's the problem
> > of restoring only a single C.list to CTX.head.
>
> I had to take some time on understanding what this mean.  And it seems you are
> working on an old version of the tree, and therefore saying about an issue that
> already fixed by commit 592e5c5f8ec6 ("mm/damon/core: fix memory leak of repeat
> mode damon_call_control objects").
>
> Please use mm-new as a baseline of DAMON patches, unless there are special
> reasons.  If there are special reasons, please explicitly specify.

This patch is based on v6.19-rc2.
I will continue to refer to mm-new and damon-new.

>
> >
> > Below, repeat_controls is removed and the existing CTX.head is modified to
> > loop once(1st rotation).  This simplifies list processing and creates a
> > more efficient structure.
> >
> > Modified while loop:
> > Not used repeat_controls:
> >
> >         CTX.head <-----> C.list <-----> C.list <----> C.list <-------+
> >                             |                           |            |
> >                         if (C.repeat)            if (!C.repeat)      |
> >                             |                           |            |
> >                           list_del()                  list_del()     |
> >                             |                           |            |
> >                             |                       complete()       |
> >                             |                                        |
> >                           first --------> list_add_tail() -----------+
> >
> >         if (C.list == first) break;
> >
> > Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
> > ---
> >  mm/damon/core.c | 37 +++++++++++++++++++------------------
> >  1 file changed, 19 insertions(+), 18 deletions(-)
> >
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 824aa8f22db3..babad37719b6 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2554,42 +2554,43 @@ static void kdamond_usleep(unsigned long usecs)
> >   */
> >  static void kdamond_call(struct damon_ctx *ctx, bool cancel)
> >  {
> > -     struct damon_call_control *control;
> > -     LIST_HEAD(repeat_controls);
> > -     int ret = 0;
> > +     struct damon_call_control *control, *first = NULL;
> > +     unsigned int idx = 0;
> >
> >       while (true) {
> >               mutex_lock(&ctx->call_controls_lock);
> >               control = list_first_entry_or_null(&ctx->call_controls,
> >                               struct damon_call_control, list);
> >               mutex_unlock(&ctx->call_controls_lock);
> > -             if (!control)
> > +
> > +             /* check control empty or 1st rotation */
> > +             if (!control || control == first)
> >                       break;
> > -             if (cancel) {
> > +
> > +             if (++idx == 1)
> > +                     first = control;
> > +
> > +             if (cancel)
> >                       control->canceled = true;
> > -             } else {
> > -                     ret = control->fn(control->data);
> > -                     control->return_code = ret;
> > -             }
> > +             else
> > +                     control->return_code = control->fn(control->data);
> > +
> >               mutex_lock(&ctx->call_controls_lock);
> >               list_del(&control->list);
> >               mutex_unlock(&ctx->call_controls_lock);
> > +
> >               if (!control->repeat) {
> > +                     /* run control->fn() one time */
> >                       complete(&control->completion);
> >               } else if (control->canceled && control->dealloc_on_cancel) {
> >                       kfree(control);
> > -                     continue;
> >               } else {
> > -                     list_add(&control->list, &repeat_controls);
> > +                     /* to repeat next time */
> > +                     mutex_lock(&ctx->call_controls_lock);
> > +                     list_add_tail(&control->list, &ctx->call_controls);
> > +                     mutex_unlock(&ctx->call_controls_lock);
> >               }
> >       }
>
> Let's suppose there are two damon_call_control objects on the
> ctx->call_controls.  The first one has ->repeat unset, while the second one
> has.  Then, it seems the 'break' condition will never met and therefore this
> loop will never finished.  Am I missing something?

You misjudged.
If (!C.repeat), it will be removed with list_del() and disappear.
If (C.repeat) loops through the loop once, and when it returns to the
first, it breaks.

>
> > -     control = list_first_entry_or_null(&repeat_controls,
> > -                     struct damon_call_control, list);
> > -     if (!control || cancel)
> > -             return;
> > -     mutex_lock(&ctx->call_controls_lock);
> > -     list_add_tail(&control->list, &ctx->call_controls);
> > -     mutex_unlock(&ctx->call_controls_lock);
>
> As I mentioned above, apparently you are using an old version of the tree that
> not having commit 592e5c5f8ec6 ("mm/damon/core: fix memory leak of repeat mode
> damon_call_control objects") that modified this part.  Please use mm-new as a
> baseline, or specify reasons why you cannot do so.

I'll look into what you said.
I'll also continue to look at the mm-new version.

Thanks,
JaeJoon

>
> >  }
> >
> >  /* Returns negative error code if it's not activated but should return */
> > --
> > 2.43.0
>
>
> Thanks,
> SJ

