Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B8BD59F5F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 01:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4314D6B0005; Fri, 12 Dec 2025 20:10:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E10B6B0007; Fri, 12 Dec 2025 20:10:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F68B6B0008; Fri, 12 Dec 2025 20:10:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2E76B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 20:10:53 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9971D89885
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 01:10:52 +0000 (UTC)
X-FDA: 84212668344.11.89F13B8
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id C44B940006
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 01:10:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zr6rKyBj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765588250; a=rsa-sha256;
	cv=none;
	b=PC4JYzO2s242rKx+akzFI83q0ydCxnQHIW/H7kI2ZlzsjUDLWATtrOzrEJ6OiMz5U94ydS
	UXzNlZfZqlYDWzmx9NmsdoQ6+7FD/E4Q40P66YchSRFVWHgaaHnzZzop5nROUxm2iILD7M
	4J8w75D8c+wp1+58agVSwgDohcldiaA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zr6rKyBj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765588250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H69U5CDYHq4197VbTLKqjL8FPFMWb4JhR7VTb4JaM7g=;
	b=F8CpmGD2UXPgnBC5BvFlp52FV6DPwZ43J5lbk9l+rxGYPMhMsAKyZAAFozE3Mg/sgXmQHy
	Re9M34mM9Gta1a2kM2Poyg3QVlI0PjoRpcvlnNMATdvlvwTnOlPhdOR3mUNhvx5DoyW93d
	Uzufu3Yjq/hqxb0SJ1REvdvfv5fo+T0=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-78ab039ddb4so18498177b3.3
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 17:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765588250; x=1766193050; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H69U5CDYHq4197VbTLKqjL8FPFMWb4JhR7VTb4JaM7g=;
        b=Zr6rKyBjJTKJn7ewk7XFQm+MN0C+FHBQKn2GO91YkBfx4l/TzJ/Y4aIUtngXa1psFc
         /oHveNPxvD8+YYoxTGGAmmGT8723B3uNnvclGWypdJkYtO7cTsvEmRjDpLHBDct79/wG
         bRdXXAJ7R//SZn7JpJxGLfvEEqPmLRFiLPPdQlMtZ7ozEQJP28hnGw8gaOdhYwkO44QM
         SHrrLYO4zdmBFFQFmw2MLrTGai+UkZVr2EFXivm57FCeRDyKPkgTB4D1fVdVnBhczYGO
         z6Kh0+lsEXoFayaPnnS8zynAmwDyHIDE9UGZ/tZxW3IJ0ts7cPdS48YArXsCAa8D4tQ5
         IGiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765588250; x=1766193050;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H69U5CDYHq4197VbTLKqjL8FPFMWb4JhR7VTb4JaM7g=;
        b=l9++o4BrIUtQ9lyGbjh32aTlYKsvTgzOS8B6IdbXXsvadx1c0ZSXaQDG7OXfv75uuE
         oNNr1HqnngfBird91t3JPhPaRfF1D6EdU7F1osZVUDkda+KY4k5ptfKzico38D5EJ/60
         s0pQXpjfAsc+srfbaltmAaW6+eg+tQujYfMSHpo5qahm7psTvzMxkpz9Ip+cR4Gl5dkQ
         eWG47uRYY0eaBPUBdE4JImaitrbHLqlo8v6jKVYtys7C3te7Bq6osVbhM7vx7eqpHF1h
         VKaBMD+GO+YbIbhOxaA/v40kwJ1OlpuJhZJ2UfdmbjFM/qHMDvXP1B/TnQ2UC7X+WXiT
         HsnA==
X-Forwarded-Encrypted: i=1; AJvYcCWNZGL6B4/LxIOEuOALU+fsh+lMqQXIJr+pTfLgyXHwbN5Q22nxH3Bwl23VGa1cXQm7X70mgsXfmA==@kvack.org
X-Gm-Message-State: AOJu0YyNc5CGcFol63vvQJrmU2A8QnXNEbGwdZlBcT7J0Uz5TDPlZ3HD
	ua+n1jsykNFA8X0+erRolNQyRUrA4lpvlxToFAFfKBtdlELxOssAM6Ts9d+9eUP5Z0hy8LWvICN
	iTm/5Pij/r4m7HmPbNJALGrF48McH7dE=
X-Gm-Gg: AY/fxX4rip8Nq2xmFo6ZIkhsQB92Gtkrm92qlHWk+PFucuQnjYHKgHO1ETcDLDG3Q2L
	4Hxb/I3LplnLwpINGowcMgiPYtl1ghZ32e3ODGscD6OyuUqC9mbNsdnoW+2bmvY1uPtXvqkDMTW
	uJQm09N75jNVjt9qTH4fJ/XgrwosCe1g2Um0j7jBf74L+INo3umFdf5fgSXaxMIBiX2N05etxb6
	SGBAa9QKPWm57GOVoWPF9oy/pXLrg/8nJwcOtDqisdkMlS4FTTBxiLKAT/N+NKmOk22tLLU
X-Google-Smtp-Source: AGHT+IFh0yCO4DCvhJF/e90OOfihjwNmvglPMYyupmK4fLMSTIYYCvDFBzxXiOXo0lY9wEjXztUxJ/qb/Fbqsvn99NM=
X-Received: by 2002:a05:690c:62c9:b0:784:883c:a88d with SMTP id
 00721157ae682-78e66e75022mr28160487b3.52.1765588249806; Fri, 12 Dec 2025
 17:10:49 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC4WQPo5HrCJ+958t1ab2NDzbg493XYarqACARTpYskVzQ@mail.gmail.com>
 <20251212231148.49843-1-sj@kernel.org>
In-Reply-To: <20251212231148.49843-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Sat, 13 Dec 2025 10:10:38 +0900
X-Gm-Features: AQt7F2ozNy49he0FHbezx-HKAtCT9iN5jmwm0-PfIpuyrs8ubUzntd6g14IB0t8
Message-ID: <CAHOvCC6TXo=7svC2Ka=+rf_YLTMnaF8QUV_nNvuef20XMZ=+pA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 07/37] mm/damon/core: apply access reports to high
 level snapshot
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C44B940006
X-Stat-Signature: fqcgqb4jyzomb57458nhq7j79e5a8miw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765588250-393355
X-HE-Meta: U2FsdGVkX1/SW4dY9bC4vXRKzjhv6nza69at0ZncXc6haWIukKsWgZmPl/MJphjUpwkpEB3rtWHpdZN8u5jj3Bm3ZtSeTv8yCWRZP5Vu8dagC3gZ29cmjDKf21qasgaBMWT5MSq0exhZZCkf547Evw1CUzSreMdJWLJfAvT4dTcv11nFG9pILou/MM9lsCjv9JM/OBebULbPYUhJlob0bw7JXNpRmLIdRwqzlBuhPLlSmf46ZcMKS0oaLEyQEN8pIwRr7ppzqj8YOSZAVjJwHRCP+gSQM3oU29JuoOPRUzJuHtUWljepRdM29AJJ4nGu9KsInDlo0xlwAz30s6XDaqobCssvMfiCng6SIqhJAHZaiUuHCkpMrO/dYrHy0LgK+FOcsZZ1hew57JcgpxDGI/UYv6FfujTkRjoY3o86wde8ZIfW/B8s1jPvQ1FBTYk1oZWwy7QkVwtwTbwQb0euKZS0RFZeSX8OaV3TDrJFaWpjIQWBQ2bKTGtKU+1eJ4mBFtEpkGQGj/bl84E6VqwRenoYmlITx1jx1b5UHQC8CsopNGInl3E4zqPaWH5Qg2LnZp6HPXi64DJJ4A/KTyJ8cpkocQAapxS9K2U66V4HDkViessoI+dmNjD4PRDngnNzZslX9QP7Kr/GwtUEuH20Dr4y+JxJVXdX0KMefVErelqnPh+p7Chy1R3wsKbMAqqjAxOUBv2jz00DDwYb5jkzyL0+IVTrS8kb6n1isqRnlYuw6hZruu01PYUmq9EaapCl04S/q8xTIlVuUFLsN5NHSdrMbQwzYXGE+pc97HbPIxsh0BPG35zndCmFIztwzxTmsb4jGO24YnPmKrcjoj7HjJu7iKB0RKGjKuoD5ICSSgnvGz3DenYfzkMgA4zeVKerXf05jgHdZMS/ZrKk1yWbiWa1XQ9TsBB4l9uddB5N2vohkOslDvW2ttlq3DZp36hvYXZxhDbYADC9SQr5dyj
 kMNffQFH
 tVpONf4F+gs+OXz+TEoqQoG0Rz30cbdWCmSikWnCWe4FzbWYNmSLnKv5iOzypGAcck90jP/EUWJ73IGEwTw47Si4D5kfT4oGzEv4pAsSeApkOyzHVkLka8Ls0fbk+dZ9eJZOwc3bDOs9o3vdFmALl/5whNluQzCtmQty/ZjmXTgB7smXq+le8lNFAgiu6xoG4wtEsFDz0riCeplhv5mGctd2VaDealwOBEb8EeTsHACAjzzVJ2fbd74vgydGxvG67uiVVGi+iWXvQLDweek7fGJmnq+bXCzE2dOQYJrqgT+Ho+k2rrSUAjoXKVCF4ZSKa5WGOcUNuOrg/A8IPuKVkl6wi4U+8cPxXCBtQXgFD+EhFM9c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 13 Dec 2025 at 08:11, SeongJae Park <sj@kernel.org> wrote:
>
> On Fri, 12 Dec 2025 22:20:04 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Mon, 8 Dec 2025 at 15:35, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > Now any DAMON API callers can report their observed access information.
> > > The DAMON core layer is just ignoring those, though.  Update the core to
> > > use the reported information at building the high level access pattern
> > > snapshot.
> >
> > It seems inefficient to repeatedly access the damon_access_reports[1000] array
> > using a for loop in the kdamond_check_reported_accesses() function.
> > It is inefficient to for loop through the entire
> > damon_access_reports[1000] array.
> > When CONFIG_HZ and jiffies are increased as follows and
> > damond sample_interval is 5000us (5ms), the time flow diagram is as follows.
> >
> > CONFIG_HZ 1000, jiffies == 1ms
> > damond sample_interval == 5000us (5ms)
> >
> > reports_len(==): [0 ... 5]
> >                                                      [*]
> >         0    1    2    3    4    5     6    7    8    9        997    998     999
> >         [====|====|====|====|====]-----|----|----|----|  ....  |------|-------|
> > jiffies++    1    2    3    4    5     0    0    0    0        0      0       0
> > damond_fn(sample interval)      -5[0<]
> >
> > reports_len(==): [997 ... 2]
> >                                   [*]
> >         0      1      2    3    4    5     6    7    8    9        997   998   999
> >         [======|======]----|----|----|-----|----|----|----|  ....  [=====|=====]
> > jiffies++   1001      1002 3    4    5     6    7    8    9        997   998   999
> > damond_fn(sample interval)
> >                             -5[997<]
>
> Please use fixed-length fonts for something like above, from next time.  I
> fixed the diagram with my best effort, as above.  But I still fail at
> understanding your point.  More clarification about what the diagram means
> would be nice.

Thank you for readjusting the font to fit.  The first diagram above is when
reports_len is processed normally starting from 0 to reports_len.
The second diagram shows the process where reports_len increases to its
maximum values of 997, 998, 999, and then returns to 0.
The biggest problem here is that the latter part of the array is not processed.

>
> >
> > It seems that only the section corresponding to the sample interval ([==|==])
> > can be cycled as follows.  And, how about enjoying damon_access_reports[1000]
> > as damon_access_reports[500]?  Even if it reduce the 1000ms to 500ms
> > array space, it seems that it can sufficiently report and process within
> > the sample interval of 5ms.
>
> Are you assuming the the reports can be made only once per 1 millisecond?  That
> is not true.  The design assumes any kernel API caller could make the report,
> so more than one report can be made within one millisecond.  Am I
> missingsomething?

jiffies 1ms is just to simply unfold the passage of time when
CONFIG_HZ is set to 1000.
This is a simplification to help it understand the flow of time.

>
> >
> >  static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
> >  {
> > -       int i;
> > +       int i = damon_access_reports_len;
> > +       unsigned int nr = 0;
> >         struct damon_access_report *report;
> >         struct damon_target *t;
> >
> > @@ -2904,16 +2905,18 @@ static unsigned int
> > kdamond_check_reported_accesses(struct damon_ctx *ctx)
> >                 return 0;
> >
> >         mutex_lock(&damon_access_reports_lock);
> > -       for (i = 0; i < damon_access_reports_len; i++) {
> > -               report = &damon_access_reports[i];
> > -               if (time_before(report->report_jiffies,
> > -                                       jiffies -
> > -                                       usecs_to_jiffies(
> > -                                               ctx->attrs.sample_interval)))
> > -                       continue;
> > +       report = &damon_access_reports[i];
> > +       while (time_after(report->report_jiffies,
> > +               jiffies - usecs_to_jiffies(ctx->attrs.sample_interval))) {
> >                 damon_for_each_target(t, ctx)
> >                         kdamond_apply_access_report(report, t, ctx);
> > +               if (++nr >= DAMON_ACCESS_REPORTS_CAP)
> > +                       break;
> > +
> > +               i = (i == 0) ? (DAMON_ACCESS_REPORTS_CAP - 1) : (i - 1);
> > +               report = &damon_access_reports[i];
> >         }
> > +
> >         mutex_unlock(&damon_access_reports_lock);
> >         /* For nr_accesses_bp, absence of access should also be reported. */
> >         return kdamond_apply_zero_access_report(ctx);
> > }
>
> So I still don't get your points before the above code diff, but I understand
> this code diff.
>
> I agree this is more efficient.  I will consider doing something like this in
> the next spin.

What I tried above is to process the current array [1000] as
efficiently as possible.
But, if I think again, It would be better to store it in a linked-list
and process it
in FIFO mode whenever requested in damon_report_page_fault(),
damon_report_access(report)
instead of storing it in an array.  I'm also analyzing the source code
starting this week,
so I'll organize it a bit more and get back to you with my opinion.

Thanks,
JaeJoon

>
>
> Thanks,
> SJ
>
> [...]

