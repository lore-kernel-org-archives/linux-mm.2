Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 975CBE8FDBA
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 23:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD62A6B0005; Fri, 26 Dec 2025 18:42:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84426B0089; Fri, 26 Dec 2025 18:42:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A904F6B008A; Fri, 26 Dec 2025 18:42:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 965696B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:42:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23D55138C16
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 23:42:26 +0000 (UTC)
X-FDA: 84263248692.27.A141569
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 539A380006
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 23:42:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HEU5uGji;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766792544; a=rsa-sha256;
	cv=none;
	b=uEGorEa1OCR2suh8/ep8iWm5SvufxqhNzZ/RmxcXEKvZ3el82edzuP5dRxu6+k5U9pD3xD
	e0D2VeHochQBUrziAi/wKGYUP3qZX2yioJ/EPWg0QBqbTYTCqPj3nzuc3C8uprfUzagPes
	cHscyoiaMrXibpxOHWTrZuGKrgx+lE4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HEU5uGji;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766792544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fAZppyva63DEjptZqcQdtviylUco9oD9YcVtJdE6l+o=;
	b=56zqglQGf4Nne2r8aGViOeOZvFvxsUkbZt+Ke2hwVYASJDrHW06Ngvp4qHd+BUoCQvRUff
	WzZhWh1H2y+e+uqZqR2qE7CdSO0VsoXJ7J3+SlmNumNyOz1OFSfplwv+hilZMiRINKsVP9
	OXCrDkubDclx8liR72NVegKCzvgAQlw=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-641e9422473so6174209d50.2
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 15:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766792543; x=1767397343; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fAZppyva63DEjptZqcQdtviylUco9oD9YcVtJdE6l+o=;
        b=HEU5uGjiJT7ZT3vYXio2def3BtlbKVNLy7+5ru/Ypj4zv5UQzDolHy4o2gqMFvVSb3
         rwIoDLb2gd0NDC2dtINQ3bUjGcALQ0DNcT7aWHwx5Jyln8FL8mDRJJ/m+tK0pn90GIS3
         jaot35sVP0MiRNuYKUCUfINFjAnRkQ70LCspOmpLBt2YzJDkIG2ZOBBLZfvI5lBUODhY
         y5Bd9A/y1ooDKiBIQasVFIeLcpq31scHd/rbYQUu0S8aBrXOmIxkyimTekOZS4XKZ6np
         47dzh/3Fj8QRKF3pFHyoWXTxqoMN7c7mbEAf4SJJ6ZJKckPYojcMtYiuSKQFGU+1Hn9+
         R3SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766792543; x=1767397343;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fAZppyva63DEjptZqcQdtviylUco9oD9YcVtJdE6l+o=;
        b=FfQDM0ng1CXB79oP/RESsm7f3AlVNIzsVgqVzIEGZwvVQYb3kD3DDK5HHtaiZuu+Ob
         KsfaurQzyLgKqFdR5W7QQ1pkEI8hCjfELDDGZui6/CQC4f5yP9xiSr0ASDdCCxuu1BSS
         yGGpnAmdKgKNPXHqAlz7lQhvYa0IPcgRtM4BVGNs47kFEvVsrS4DqLlUCmyrQmlAq+v7
         bWPRZJQ4EYyQRNunHaG3ZlHimqIkIJCLdEX8Nb3g5ynMUkhmkYN13qXrm/XNnB9U1zz+
         4gGpt6zL1QS7x6wU22Z864QZRDuDaLTtG2wD1ltwTW9/3FIlhdWbKsfwREJZ0dCl99tx
         qiIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyqafA/Pm8/2SvsL54j7a0+4Ji1aayDVQ0jJ59djcfigR8+/pMBReQj2heYlb6FqC3ZOUY6ocybQ==@kvack.org
X-Gm-Message-State: AOJu0Yxpmjnq+32s/mq66Kt/QoC1j4t1LEhZy8p9V+c1KEqK1epqXQbC
	tOAvlBbjr0BSXs3xIBi1J7n+8UmYjxssps+XfsopeVBQYxU4pf8EXIDQbdTVzAM5RILnxDG13zm
	qFCEm6gQ/JWmcS7pwLGg089ZhZ30ALrA=
X-Gm-Gg: AY/fxX60kNeS6JRfPLvHebpAOlCAjVgNX+NoZlmzJAqXb2Olv0LtdE0NqJrDh/5lzP4
	18NU9U69Nd24jCTDbpyu04uIlEkeRpUrSp54ivhGgV8Z24zBwqwtk2sGU69iR9BjiUsBsTyPBCM
	coL33OqgpXJRu8uPUsZNMS8Lt9k2UaVGMbKlrbyDwMLqs0pJvZCdtE8Jd03g1oFxstbGoUXdNB1
	3xBDy5UtF1TQFDKP9KTIPWTeGcHExhbf19xRkD5YvgcJ7DrqxOOzKgeCRBrfR4+16Ie7WzG
X-Google-Smtp-Source: AGHT+IHWXW3HAQ2IWb0fPDByyES6LykAonpabAqCQdmat1G1q6oNNSUa6z5qQifEQZr99TfRO77TdqFM0nr2FQzcz10=
X-Received: by 2002:a05:690c:c4ce:b0:78f:bc2b:83f5 with SMTP id
 00721157ae682-78fbc2b8fd3mr421701197b3.20.1766792543250; Fri, 26 Dec 2025
 15:42:23 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC4f2xPK_LwFoisdqr_wX-RbdW9KUq48+82CMC=5ViF=ag@mail.gmail.com>
 <20251226183122.254549-1-sj@kernel.org>
In-Reply-To: <20251226183122.254549-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Sat, 27 Dec 2025 08:42:12 +0900
X-Gm-Features: AQt7F2qXA2NW8S6__pIPvLxhHe9J8Tr2XiSGV87pAHvpagp774VRSyEShoAx2fo
Message-ID: <CAHOvCC6L7TAX5Pu4pLVvYBsGc7tVYexgqJmiZ7UEhu7N4_jubw@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/core: modified control->repeat loop at the kdamond_call()
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, rgbi3307@nate.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 539A380006
X-Rspamd-Server: rspam10
X-Stat-Signature: rqimfiaxzsemhxsswriu58uo8nsruzh7
X-HE-Tag: 1766792544-169815
X-HE-Meta: U2FsdGVkX1+TTbqw/yK6gYiK6ZoVfI9nsUgHZnjq/2fETTCKnAIHvE2hoAlKYP5Wi5hICAAECqpl7RLKBS1cO0aMEQI0Hn/P/EH1T/7lEwQartFQl6S5XvL5i7pERMcx6hgXwJtbc2kxEaCwBeSW0Dd9CxRr/yrVtgxhq97nrBtMmOvZEM6XdHyAioJeWW42X2JCfk0B5vqeu1hWYU6xW4ShhD4q11PuEfJBQKUHJ4oS/67vK/0a0+bzdVZayJDP4qm/uLPd3pB5DxMZVzV2ElM62eOquwu8mLvlzJhNjwSzhy419dv7j15xFxV1hhxUXEnzX69N1PpsiFyiv56whX6jEwXyqMq1cUg3SS618vQBqhuEQc7hwnXAl4c0fPiFE7iGk/mB9JGjXoyhXHcrYHnj1xnDZn3Z7Y73uBCVGFkPchCNCTiGG+TsYcKMrurI8jZnv9fNbSYcwbw6f9qjkeHc+T6pgz8OJHfc2sNyHm7xhtwQhanq4KT4n/J8AMvjm9lcVeKDzS5+5VY4dDaouPhrnSJ/ypwDzddKFTpXBpj4WihIjbodWjMRn1axbA9TdqCewlR/IrSIiRlpuFGEQlZodMNLsIe0H6HTPBiCQfxMI9oqhEaKpghsJN+SnFotU/pAFkYrlMuM1TtQeDNhqkwWgmNRD+vqxkk/LH0Vn2+kebtzf3Dpm2hr1zFYsCo60FmgaAy9X+jXNqANSjYrN6BVo4r8ujLK/zKvgyJOMbYveHBlcKVYkOMM/v3HAJymbqUlNM2LK/3ZyNSKUdnmmQKgcI+NGMxUD8meWYU/LZeExMlM+5PGVjVGgLxx+12eP7Wwrlg0r8Z8qeNSfDOvSyFnUPopNB8SOXcipW8SDfho9ZwuU/onhQz+zkrOeUfgDe/nhwJbuLsZCkSg/TJBCkhVFqqLDVQOuCf1EBig4ymyK/cEHgnlzoLJQlXm6dE5lzraiNZu0cYMl9KwL99
 +X0sl8JJ
 juX0ZqUTlCMxvwasKiS5RoetkUCrqVIy4YK/CX8vH/6IXFOP7Xt2fEU5VFNNOpf744KlE2RsHfkiFCrZkE3GhfKozsM6c8C5rz78sM29DoVrSgFRcRUe8ezji0oVOHTjHDUC2y8cGr2t5ceBaoOGg52X5Naq9sR5QuvgDI/R+AyYm0lixHTpwVO5fhCjFmok1G6Ilb0Te87yOdpFIn8RxKEKUNASglAYheGeKBn6l/Wdfo5LYaF5NPnzL6EGVai9gXoeGkiC+r+o6LLCUFiihl+bdCnxvSj2wY7Xu2j/v+BoFoAEB1+20MT+KuDV2ZY4MFtQ/vk78V72E53WRBPnisn5Rg8OObX2VSf8/yknIgnjmdCYl7f1bCdfZtxUqICECH0vD0ReapLNX6td1QkMX/U/6XwU9CMSw7OVY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 27 Dec 2025 at 03:31, SeongJae Park <sj@kernel.org> wrote:
>
> On Fri, 26 Dec 2025 11:19:28 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Fri, 26 Dec 2025 at 05:01, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Thu, 25 Dec 2025 12:10:30 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > >
> > > > On Thu, 25 Dec 2025 at 10:07, SeongJae Park <sj@kernel.org> wrote:
> > > > >
> > > > > On Wed, 24 Dec 2025 21:43:54 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > > > >
> > > > > > The kdamond_call() function is executed repeatedly in the kdamond_fn()
> > > > > > kernel thread.  The kdamond_call() function is implemented as a while loop.
> > > > > > Therefore, it is important to improve the list processing logic here to
> > > > > > ensure faster execution of control->fn().
> > > > >
> > > > > That depends on how critical the performance is, and how much complexity the
> > > > > optimization introduces.  I have no idea about if the performance of
> > > > > kdamond_call() is really important.  If you have a realistic use case that
> > > > > shows it, sharing it would be nice.
> > > >
> > > > This is because kdamond_call() is called repeatedly in kdamond_fn().
> > >
> > > Yes, it is repeatedly called.  But, my question is, does it impose overhead
> > > that great enough to make a negative impact to the real world.
> >
> > I agree that the overhead is not that much since there are only a few lists
> > added to ctx->call_controls(CTX.head).
> [...]
> > > > > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > > > > index 824aa8f22db3..babad37719b6 100644
> > > > > > --- a/mm/damon/core.c
> > > > > > +++ b/mm/damon/core.c
> > > > > > @@ -2554,42 +2554,43 @@ static void kdamond_usleep(unsigned long usecs)
> > > > > >   */
> > > > > >  static void kdamond_call(struct damon_ctx *ctx, bool cancel)
> > > > > >  {
> > > > > > -     struct damon_call_control *control;
> > > > > > -     LIST_HEAD(repeat_controls);
> > > > > > -     int ret = 0;
> > > > > > +     struct damon_call_control *control, *first = NULL;
> > > > > > +     unsigned int idx = 0;
> > > > > >
> > > > > >       while (true) {
> > > > > >               mutex_lock(&ctx->call_controls_lock);
> > > > > >               control = list_first_entry_or_null(&ctx->call_controls,
> > > > > >                               struct damon_call_control, list);
> > > > > >               mutex_unlock(&ctx->call_controls_lock);
> > > > > > -             if (!control)
> > > > > > +
> > > > > > +             /* check control empty or 1st rotation */
> > > > > > +             if (!control || control == first)
> > > > > >                       break;
> > > > > > -             if (cancel) {
> > > > > > +
> > > > > > +             if (++idx == 1)
> > > > > > +                     first = control;
> > > > > > +
> > > > > > +             if (cancel)
> > > > > >                       control->canceled = true;
> > > > > > -             } else {
> > > > > > -                     ret = control->fn(control->data);
> > > > > > -                     control->return_code = ret;
> > > > > > -             }
> > > > > > +             else
> > > > > > +                     control->return_code = control->fn(control->data);
> > > > > > +
> > > > > >               mutex_lock(&ctx->call_controls_lock);
> > > > > >               list_del(&control->list);
> > > > > >               mutex_unlock(&ctx->call_controls_lock);
> > > > > > +
> > > > > >               if (!control->repeat) {
> > > > > > +                     /* run control->fn() one time */
> > > > > >                       complete(&control->completion);
> > > > > >               } else if (control->canceled && control->dealloc_on_cancel) {
> > > > > >                       kfree(control);
> > > > > > -                     continue;
> > > > > >               } else {
> > > > > > -                     list_add(&control->list, &repeat_controls);
> > > > > > +                     /* to repeat next time */
> > > > > > +                     mutex_lock(&ctx->call_controls_lock);
> > > > > > +                     list_add_tail(&control->list, &ctx->call_controls);
> > > > > > +                     mutex_unlock(&ctx->call_controls_lock);
> > > > > >               }
> > > > > >       }
> > > > >
> > > > > Let's suppose there are two damon_call_control objects on the
> > > > > ctx->call_controls.  The first one has ->repeat unset, while the second one
> > > > > has.  Then, it seems the 'break' condition will never met and therefore this
> > > > > loop will never finished.  Am I missing something?
> > > >
> > > > You misjudged.
> > > > If (!C.repeat), it will be removed with list_del() and disappear.
> > > > If (C.repeat) loops through the loop once, and when it returns to the
> > > > first, it breaks.
> > >
> > > Maybe my explanation was not enough.  Let me explain a bit in more detail.
> > >
> > > In the scenario I mentioned, at the first iteration of the loop, 'first' will
> > > be the first control object, which has ->repeat unset.  The object will be
> > > removed from the list.  In the second iteration of the loop, it handles the
> > > second object, which has ->repeat set.  The object is added to the list again.
> > > In the third iteration, the loop runs for the second object again.  Because it
> > > is not same to 'first', the 'break' statement is not reached.  The loop
> > > continues forever.
> > >
> > > Am I missing something?
> >
> > Thank you for your detailed review.
> > There may be cases where C->repeat=false is the first control.
> > This can also be solved simply as follows:
> >
> > @@ -2567,9 +2599,6 @@ static void kdamond_call(struct damon_ctx *ctx,
> > bool cancel)
> >                 if (!control || control == first)
> >                         break;
> >
> > -               if (++idx == 1)
> > -                       first = control;
> > -
> >                 if (cancel)
> >                         control->canceled = true;
> >                 else
> > @@ -2589,6 +2618,8 @@ static void kdamond_call(struct damon_ctx *ctx,
> > bool cancel)
> >                         mutex_lock(&ctx->call_controls_lock);
> >                         list_add_tail(&control->list, &ctx->call_controls);
> >                         mutex_unlock(&ctx->call_controls_lock);
> > +                       if (++idx == 1)
> > +                               first = control;
> >                 }
> >         }
> >  }
>
> Yes, that should fix the issue.
>
> And it seems 'idx' is being used for only this?  If I'm not wrong, I think it
> may be easier to read if you do something like 'first = first ? first :
> control' and drop 'idx'.

It's better removing idx.
Thanks.
JaeJoon

@@ -2587,7 +2587,6 @@ static void kdamond_usleep(unsigned long usecs)
 static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 {
        struct damon_call_control *control, *first = NULL;
-       unsigned int idx = 0;

        while (true) {
                mutex_lock(&ctx->call_controls_lock);
@@ -2618,8 +2617,8 @@ static void kdamond_call(struct damon_ctx *ctx,
bool cancel)
                        mutex_lock(&ctx->call_controls_lock);
                        list_add_tail(&control->list,
&ctx->call_controls);
                        mutex_unlock(&ctx->call_controls_lock);
-                       if (++idx == 1)
-                               first = control;
+
+                       first = (first) ? first : control;
                }
        }
 }

>
>
> Thanks,
> SJ
>
> [...]

