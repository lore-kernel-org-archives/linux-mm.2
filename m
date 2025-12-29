Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58545E8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 03:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89ED6B0088; Sun, 28 Dec 2025 22:39:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B246B0089; Sun, 28 Dec 2025 22:39:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9565B6B008A; Sun, 28 Dec 2025 22:39:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 863BC6B0088
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 22:39:12 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB71D1A0850
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:39:11 +0000 (UTC)
X-FDA: 84271102902.25.13CAC7B
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2BD291C0002
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:39:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cXcqBvTi;
	spf=pass (imf21.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766979550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ec38jWe/KrrUFJROzDPN7mPmD+4inQ2VXMt0xla13TE=;
	b=2zSz1WOEn+1kjM4uzt68VNydqyRgwCWu/ouhaYW68vkKdaK8FaS1Ge20GXCneMRVGSQ15o
	Bd/O6KmuJ8AxQ/WmHAUmbP+Djis41EgxHY77KT/gt4qvAHxc1NRBsOlwfyk3feHuMvbaQq
	uVLKFzJmkAkhyNDQjGl4M1v64cqTZF0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cXcqBvTi;
	spf=pass (imf21.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766979550; a=rsa-sha256;
	cv=none;
	b=Zedya5jbEsLzYWVroSeSA8CLBgBFZMKp6iVLiYCdGdgxG+nDFcwwak6QovYGvyG8q7yFsp
	pD6YdsKJsMDNF68+6CjgQzZo74XmagfunypnZWQVUXPCelVArqwVWOA8CSsrvc+JxKO/Ca
	eVq6lvrsV5c2dJMO6c3VCBR+JD3u0Pk=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-644798bb299so6785230d50.3
        for <linux-mm@kvack.org>; Sun, 28 Dec 2025 19:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766979549; x=1767584349; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ec38jWe/KrrUFJROzDPN7mPmD+4inQ2VXMt0xla13TE=;
        b=cXcqBvTivE4mmzQfzP0WTsJ1FalsL4yj9XEzTY2nDqdfYUUxIvOWYDlZUlxZ7tXjzO
         yFtN6Lk5Jd2W88rc/bt2TXc/IztN754CpRADjD4F3hqrVcBaj38+2M0KLca69BgHhXMk
         PRUSoteoyfHbhimweFEt/f6KVdh+bVqdLdKvIgpe2hIOS8rZ/5/cJc2SNiE41Vyi6413
         MvTq4nB6MIlm5cACo8p1fK6ukveNeJhfpzZglmHtkHV6+VqakPnR7IbCNeCM6SsI8f1A
         CCxF95y+/O8CKGQncNZvzfc/6Mr4KdKJwUJM9govXrr+i/r48ycqH3aGAi6sN5VINZgV
         Mq0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766979549; x=1767584349;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ec38jWe/KrrUFJROzDPN7mPmD+4inQ2VXMt0xla13TE=;
        b=TYjFEhKyPVjr9Ke3thWhX+VjClMMzmYXWbUIbh8tl8iuS1j2PiqGvLS0UwRH8+iyyF
         FAkTWowEGx3lfRvKEIJT1wJty4ZP1I/XIAs1M2cCl9ZtuCboODPIJ/JJZwMfvvwRqmeJ
         5aLdsRT1l2K6DTXiSJRJOr3L0uJ7UGYPXGg/stfbXOTw2HNUZLdM2VTMIQWijr+AUtxO
         bbs3ApvFpXYcAhNVA3OczH63i7/A8hoVevoLVjcfRqXQC4aPCxrwRZp2t3tIFxqagRo/
         LeM7YCWpWf0fu55VxI+ugsrlw964ry42uanWUMIw/xl3BvaW1X3OGE+vi6/Y9OrgkU+T
         P6Vw==
X-Forwarded-Encrypted: i=1; AJvYcCVT5ZT1EE34ipFj5THlhWCOpJeY9ev6dYhFlio8Y5c6CpQpUSUZPx5h5EZXCA1lID2+Ve5N7D4kQA==@kvack.org
X-Gm-Message-State: AOJu0Yxw9d0xF1gw1389mpDPp6M11BUuC8hlcFVIaxXJjcYKHIAlPHkw
	BJB/roI215dnCBAkrMIqNDRVISeqfQ/5A3YHUd/A4wGeMNArqgERyKAhhSC8k1+F8GYmxmHzASx
	RBwObgjymyHW8ucWWVvMb/bcf9HKYt88=
X-Gm-Gg: AY/fxX53PVk8Jh18qOaFK9YvLVgY5pHZDMEXTGw+9AAWVIOa+xykSaYTofxRzYcH+f9
	46emopt3WrCAbk+oy1qKJV1fzANw5Djus8PAaqYCsJGDuAnGrD/foM+oHHxBJYsZh5crHhTm/Cv
	9tQmWl56Vj14suXR+XoU5PZzJrvgDdHKAj0tifvhXdJyx4qtxiia70Vo/g7nhqjWvBQh4pGL0IP
	g9HjwMApH99tGkK463ZXgl54jOhwtjgIqqDulx5hzwsq18mT9GUaKZLmOXfcYSjO9wyeGzq
X-Google-Smtp-Source: AGHT+IGMny9fg2k7Qgju0UYglg0kRUQjni0y2DiDufbvlgIlQAJlK2OlV8/96K2ETe8W7aLi49b3kLRDvZ1JRDHcJ+c=
X-Received: by 2002:a53:b549:0:b0:645:6c99:bf17 with SMTP id
 956f58d0204a3-6466a8afe74mr19566506d50.52.1766979549111; Sun, 28 Dec 2025
 19:39:09 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC7HqeGY1uxy7FxLKTFHAJPcWWbKJRjZ06W9bC4oAejOsw@mail.gmail.com>
 <20251227174239.273581-1-sj@kernel.org>
In-Reply-To: <20251227174239.273581-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Mon, 29 Dec 2025 12:38:58 +0900
X-Gm-Features: AQt7F2osd3IZrYaArYmRyOWBHGQGj20PD3b4hoISM9vUO7_MR3MY1NQLMXu3mg0
Message-ID: <CAHOvCC7KAmj8hb8GtTJ+P_GUGqjP1WO8uqnpFjMPQmKFrc1oZw@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/sysfs: preventing duplicated list_add_tail() at
 the damon_call()
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, rgbi3307@nate.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: uxet4dk1pma7bnf94skmkyczp6zzizc7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2BD291C0002
X-HE-Tag: 1766979550-433080
X-HE-Meta: U2FsdGVkX18/01iT9eBtHeGCmLvvmaKwKTQiomRbDk6hHoolUdxSZ4xkHycL6/RHr/M3NEWBWOb4NoGbGwqu+gL/C3Yx9oZK679fu+0QhJ2hr0Keh74J04KA5TTGFmmYIQEvzIS72bY89oxu3jDpVujbMMdn4O8gnVBLFSUecIbUGZp7/XIMS/aW0ImxSw5izwo4kZPwD2glvuFgJ6HkiLaMWHLK6Pffj4TmH4hZDZXzIWNI9cAWwsTgTTd/lNO7kAXXoEd1d1+iVzAzx/2AjwODH4+AOGjwCm/pYCTTP96hilBUUHm5x5CkGzkH/phFIqUU3cLKbnSNfGoKrvASJFyPNftqH1/1FqWTE62qWn2VafIasWtBuAIzjgV28vkh11uYefgM/MTY2NN5gC+fGDRCTnYaUvQfpMejwJkIVLMJ9+UsWvJjXoxdQtvZXsQ/lbpxIO8TqCCeeS/1Sd9b8Yndg7rou8r87UplmNdRTET0B0Ua484GU0+3Gn81Gw/vGQptGm7IJEzON6k464PcgpS9jUZk3mv7krEHNU2FuHT5HH/l/6xfw8nwCDrqtcgcv+33HUUPXDetbymlw+svDcQrivatn7zjmrCcfMIxoJIHzrKnpY4GCa1ibT9Q3WQNAeFX+kT7E1GboOtNKRiuuWgfQ3Sa7AOQHwoSR18xFxLtv7aPcBRul51uDrIO8YfNTRN4XAEAvXY+pYk2AvSC3SjEIkuVAhpBirq8jKHQw5VVf06FjWaQnuCXpzBvReN2lyhlyvzPByTZB3pDRajnj9AKVTpOcgbgkHTlz1EJ8VIrHD5NfudZqpandMpvvrpHkI8LwSrhNE6+DdC75UXMZ2rIp+YnBkD2e19hVwW3qzRMZrq8NcXEmkB5esHRQgEfsji6O7/iUVeUIrxZYtA+H4fQu2dSJDDvuNSiYh6/RE0O4DefZKI2Gcvg/foiUPzC5gMkp2Et0Et1hcJTJDf
 CweDU1Vx
 a8LH0GcgE1URH/RGJD3v9GA0GN00h2v+051cxQnknJh1/5h42eGJH5qiqqGtTqP1gYONae5qapysEya8hxqXckOTcuItO/7bo7degxD1Bdxa0fzlP/DXlLN4+GD/4yH1XgKCJiB6gR1sJ94Gfx88/Uk2wMB1fuQ7376AI5ojOOq3vbVK/h9ZPwVt6uf5UPawXx8aWw4w2hu2HZ1c+Pgj/rDWwUNjB3BvPZuvQjYthB8RXdcpQy0eIoMPwrZ/EAE6gwqEM1xLJK8xdkIFSnq01sHCAJytsUEFSa900LfeJ5r4jpjP1KC1vHh8P66JZFe11ixqI6DWbRCt3PmwZlLrwbrkGlVUBbnz9BPIhQVo9BAzPM0zqrl8bbu3OkYLUPW0CPrva5dGv3Oh0ROzRyYNSopYDY0wSr3pEWWOUibru8MkbR0O/tdthKYYVGSWbPcXyDC+F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000026, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Dec 2025 at 02:42, SeongJae Park <sj@kernel.org> wrote:
>
> On Sat, 27 Dec 2025 08:53:21 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Sat, 27 Dec 2025 at 03:41, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Fri, 26 Dec 2025 10:48:31 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > >
> > > > On Fri, 26 Dec 2025 at 04:50, SeongJae Park <sj@kernel.org> wrote:
> > > > >
> > > > > On Thu, 25 Dec 2025 11:35:33 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > > > >
> > > > > > On Thu, 25 Dec 2025 at 09:32, SeongJae Park <sj@kernel.org> wrote:
> > > > > > >
> > > > > > > Hello JaeJoon,
> > > > > > >
> > > > > > > On Wed, 24 Dec 2025 18:43:58 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > > [...]
> > > > > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > > > > index babad37719b6..2ead0bb3c462 100644
> > > > > > --- a/mm/damon/core.c
> > > > > > +++ b/mm/damon/core.c
> > > > > > @@ -1462,6 +1462,9 @@ bool damon_is_running(struct damon_ctx *ctx)
> > > > > >   */
> > > > > >  int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
> > > > > >  {
> > > > > > +       if (!damon_is_running(ctx))
> > > > > > +               return -EINVAL;
> > > > > > +
> > > > > >         if (!control->repeat)
> > > > > >                 init_completion(&control->completion);
> > > > > >         control->canceled = false;
> > > > > > @@ -1470,8 +1473,6 @@ int damon_call(struct damon_ctx *ctx, struct
> > > > > > damon_call_control *control)
> > > > > >         mutex_lock(&ctx->call_controls_lock);
> > > > > >         list_add_tail(&control->list, &ctx->call_controls);
> > > > > >         mutex_unlock(&ctx->call_controls_lock);
> > > > > > -       if (!damon_is_running(ctx))
> > > > > > -               return -EINVAL;
> > > > > >         if (control->repeat)
> > > > > >                 return 0;
> > > > > >         wait_for_completion(&control->completion);
> > > > >
> > > > > Let's assume DAMON is terminated between the damon_is_running() and
> > > > > list_add_tail().  In the case, the control->fn() will never be called back.  If
> > > > > control->repeat is false, this function will even inifnitely wait.
> > > >
> > > > As you said, there are cases where kdamond is terminated(stopped) in
> > > > damon_is_running() and list_add_tail().  It may be a very rare case, but
> > > > I missed this case.
> > > >
> > > > >
> > > > > I think we should keep the damon_is_running() as is, but further check if it
> > > > > was terminated without handling the control object, and remove it from the list
> > > > > in the case.  Like below.
> > > [...]
> > > > However, the damon_call_handle_inactive_ctx() function is to post-process
> > > > the duplicate addition of control->list.  Rather, it is more efficient to
> > > > prevent duplicate additions in advance, as follows:
> > > > I have tested the following and it works fine.
> > > >
> > > > @@ -1467,11 +1496,14 @@ int damon_call(struct damon_ctx *ctx, struct
> > > > damon_call_control *control)
> > > >         control->canceled = false;
> > > >         INIT_LIST_HEAD(&control->list);
> > > >
> > > > -       mutex_lock(&ctx->call_controls_lock);
> > > > -       list_add_tail(&control->list, &ctx->call_controls);
> > > > -       mutex_unlock(&ctx->call_controls_lock);
> > > > -       if (!damon_is_running(ctx))
> > > > +       if (damon_is_running(ctx)) {
> > > > +               mutex_lock(&ctx->call_controls_lock);
> > > > +               list_add_tail(&control->list, &ctx->call_controls);
> > > > +               mutex_unlock(&ctx->call_controls_lock);
> > > > +       } else {
> > > > +               /* return damon_call_handle_inactive_ctx(ctx, control); */
> > > >                 return -EINVAL;
> > > > +       }
> > > >         if (control->repeat)
> > > >                 return 0;
> > > >         wait_for_completion(&control->completion);
> > >
> > > I think this is not differnt from your previous suggestion, and thus it has the
> > > same issue.  What if DAMON is terminated between damon_is_running() and
> > > list_add_tail() call?  Please let me know if I'm missing something.
> >
> > I think it is good idea to insert a barrier() between damon_is_running()
> > and list_add_tail() to prevent context-switching.  What do you think this?
>
> I don't think barrier() works in the way.  Please correct me if I'm wrong.

Yes, there is no need to use memory barriers.  Since each kdamond runs
its
own damon_ctx, the concurrent access problem can be sufficiently
solved with
mutext_lock.  The problem discussed so far can be solved by applying
mutex_lock to both ctx->kdamond and ctx->call_controls.
Please refer to the modified code below:

@@ -1496,14 +1502,15 @@ int damon_call(struct damon_ctx *ctx, struct
damon_call_control *control)
        control->canceled = false;
        INIT_LIST_HEAD(&control->list);

-       if (damon_is_running(ctx)) {
-               mutex_lock(&ctx->call_controls_lock);
+       mutex_lock(&ctx->call_controls_lock);
+       if (ctx->kdamond) {
                list_add_tail(&control->list, &ctx->call_controls);
-               mutex_unlock(&ctx->call_controls_lock);
        } else {
-               /* return damon_call_handle_inactive_ctx(ctx, control); */
+               mutex_unlock(&ctx->call_controls_lock);
                return -EINVAL;
        }
+       mutex_unlock(&ctx->call_controls_lock);
+
        if (control->repeat)
                return 0;
        wait_for_completion(&control->completion);

>
>
> Thanks,
> SJ
>
> [...]

