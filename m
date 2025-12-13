Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61BD6D59F6C
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 04:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D41B6B0005; Fri, 12 Dec 2025 23:09:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484EF6B0007; Fri, 12 Dec 2025 23:09:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 373C46B0008; Fri, 12 Dec 2025 23:09:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26F976B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 23:09:52 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B43C21A0436
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 04:09:51 +0000 (UTC)
X-FDA: 84213119382.21.D950504
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id E16F8140006
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 04:09:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CoG/kXT/";
	spf=pass (imf26.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765598989; a=rsa-sha256;
	cv=none;
	b=V7ot/oEsXCxQvdy3MOVA4c61VQ8ictsYird6YCYQbAAYfm805ffnyVHi9z3gVvVNpW63ys
	ZjX7OHsiE52rQwCBInu0s60xIOxeVBcqiSlcqGXAWVSMu+yxq5jtbhoJ1kxcoCmLzuq6Io
	SUDSxkvIQ4Ub6zNf85maI1xZeOrSBAc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CoG/kXT/";
	spf=pass (imf26.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765598989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/HAsPyxpOwek2zebDAB6m9a/MhhIhddpY3TGGSAO0A=;
	b=tyq61vzkuLKiEbnj3ezGN+irCk3a/Rhi8Ym9g/pm2idSRwe8vIK5T7Lq8zqBDhgyD7vpLB
	TfU7HQFUkyvBZ5X+XYOqOHPAnyxfxS3OMP3sHXZNP13dlyK2sOqi4obbxoXt4jg1ikdDFK
	N/6YOKExgqXSjx4jr1VmJ+Lk9FdYR2g=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-787df0d729dso15793687b3.3
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 20:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765598989; x=1766203789; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W/HAsPyxpOwek2zebDAB6m9a/MhhIhddpY3TGGSAO0A=;
        b=CoG/kXT/OvCffJ0f0XxoUfqf5W1pMpsUqQxe8VAfKmcHqeRvJbv3mo5AEGGXbQuCf2
         ATFDHriMwpmlBnBH1jm0aaIP2y9h5o/cV7pu2LqRDG6UhRDCk3euKXe2SGaFzMj7J4uU
         9dXCfHla8rQsTP2FGUqcR4CXn4KQDrri57aHC0J2gCZsz1YbmFv5ziS0OJQXBj4Or8PZ
         O/jtgtr7nyBHl6/FnkWUNrATwgxBRHubJ16CuDzpt08F4k8vGSi/OgOrxzfOlgyKrYe8
         UUUxQTMKWJ3techZgKzu5QronxBQv3KFK/i6FLsgO5IUiR6unDkMx2pNSzchj5FcY86j
         a5FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765598989; x=1766203789;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W/HAsPyxpOwek2zebDAB6m9a/MhhIhddpY3TGGSAO0A=;
        b=OFrFLBqNuvGKmKMLm65/7tUY6tY1FPSVdAVi1mAGvVuGsLfVkdnG+QKEd5Cer0pxV8
         nNeXRMzKh8SHVJ+NlsbW9qpiJPX0nqVGaOGU5Opg9GIsMA8AQ9B/FTvtJRyDgz8w1/sz
         EP/Zrw09SbiiFtx0c9/ZLntsLKudvf/zFkJbcaUXS8I4kCrUakC91jJTGhbNf6uWBBrw
         GmCJHg+CpUjNaKLw6a7R7yIJh40cZfPNKyp0QEGVFj4Wxd/CLOmjRGjukeYfhGt8vRv3
         H3K+6QtdlSm0bpeWH1lBLISMJH7WXpZ8GZa2YBygOYI3+yJkpgrYiJxDts869NAG709G
         R9nw==
X-Forwarded-Encrypted: i=1; AJvYcCXqATgTmT1d2ELI0HrDbsby/IgMxONx2Rv85Ek4a4aX6TA5j/vsfcH+xKWKws9O2YjikVNvkikqsA==@kvack.org
X-Gm-Message-State: AOJu0YyJZ9cr3bsfVhp3euMjqDvR5RNMIWC29/A6cI0PG7BzygjmQriC
	/V+/GZO8fySG/zXUHM+2R5iEREB42uZOibHnxLlCvnsxGbIb0u2PeAXBCjj1IT9RqwmjLEb1lFH
	YVP+QLHYT7MmqlVQo6TApLvzigmk0uys=
X-Gm-Gg: AY/fxX4YC/DPKSsYILxRBIHZQhBJgmaeWNjkDmbQ7i4lqaBB1wd6tZ1pr62lmaxvA32
	DSCmOVO1VGl/DJiIiUNAkKxgw8cuHMFXlowGFGGjfSo6Otb1gpD4nuRU82EBt02ikdobE4XBgfv
	uPpLnHsm5XV2QCcAJ5/8kzKJQctvpLs7w9QZwHKctSGgtlLfkAxi21U/xotCgNcGikjG94zmpd6
	xO4IjMOiw3Uv8VG4FpMX5dg3d3nbPoQdsdMUEao59DqMSnwSqZo+nC1eMoXXrx961ccy3J6cpEU
	0nXi3Do=
X-Google-Smtp-Source: AGHT+IE2Dkk6szXkQqiUNR6kSrSKxVH9bxB3s7bq/ieDF4UsmcTJCdBoslNFsgvt8an/r6v/t6O+dAihPlvBHvyePw4=
X-Received: by 2002:a05:690c:6306:b0:787:f5c5:c639 with SMTP id
 00721157ae682-78e66ce5a98mr36274727b3.3.1765598988879; Fri, 12 Dec 2025
 20:09:48 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC6TXo=7svC2Ka=+rf_YLTMnaF8QUV_nNvuef20XMZ=+pA@mail.gmail.com>
 <20251213032128.50837-1-sj@kernel.org>
In-Reply-To: <20251213032128.50837-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Sat, 13 Dec 2025 13:09:37 +0900
X-Gm-Features: AQt7F2rolIJNfJ6j7j90N3dzK-4Yx1gdSt7UneU1YzoG00xWzcI9BRDmandvwc8
Message-ID: <CAHOvCC5izV51xSXFBBijVOCaffwimbmEe6YPk2AVJWXAK59t+w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 07/37] mm/damon/core: apply access reports to high
 level snapshot
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: E16F8140006
X-Rspamd-Server: rspam04
X-Stat-Signature: cizt8hizir8qymmkpmnfy9xxen3ikjw7
X-HE-Tag: 1765598989-293378
X-HE-Meta: U2FsdGVkX1+mArgQHyUE/UccPLnVyBAD90yjSwSz1ZiLSyQcf73c/HUelPnaEm6yWwFOYRqeZAnIR1q8/rFh3nBJJXXUI+IzgDr9oBdXvp4zEANY1Ips48jWBJXJdLL1j92qpPeFbiWC/tcWMIgEyREarRU/KcEhzcWAoJ7ta5ozhsbrcYP04U2dF28NAA+wDOpI//nm/soBf7B1ponr4lrZ86CN1J0OPDUHvcwVzObpyGH3YWrydpPaVezGzNySDAxch6jYHfhJ4M2WOuZ4C3F55EECcJ0J48c+UCopRT0PyqYwXckRAo47o7V0jaEIogTJDKNnAiyUNZJhfXD6WmphHpZ7VxlAtSHE7yjm0veYQqA2Lcr7AyvYj1ID7oiA6dOduddet2zDHZs6ni+1ut/ahN3WXniZl844Gu6LnxUyqJilCFDTGRskLgwG3gQqPDPPzOSNwv4IBk0boqUZ29VjDtPxLJt+G6bTan+XDfdq66SmUFta4ZGR4BItQsUOgfQtS9Dicop1DsQ9BpsQLukfNRIlxoWapYnpKS7zivIBz1+8rIepzEumjPnvHt7c6iluqEnyMceLMy9spjNxjFoqEmnfpzfdN9BD3Yy76NrGqHxtuMyplQUSCzS+WuSEjTD0MvxqkOQqglzIm938KmZ5QabEWAV/jaMmGPGKE/cINQCQZJUOdKDXWpv32STAwdwwL52jln7lwUaiFb3qE5j3AhfAN4CQMdWnCppZPZ+0PM1PZt8OwtugXyKZPFcuyUbhCqSRasMQuok5mluMJ+q9Dx2YXGE6dcXAIa6moSsAztR4w9FZ03cEOp13G/FVTD9Z1TUG1Yrt0mRb/Op/LCS7lQYMIGnv6dKii++jmy80y8X3yvoM4+lBY69T7oHBtqq3Mvu84EkC5Df04orkvCBKIUi35+u8IJwzAS4vN8LQn/jV4UxDhE2whHe68DVtZfw+G28A13iKwmHOCmq
 fd++j5cD
 e4a2DoWGWvSltH0GlAdKaQS4RF8NZIG2N/CrikK21TBz0yPKkoACN+I0ecFYx7ilz637UI8zYgAyrLSdPViCDPgStcoKriX/R6+8vDs3uYRezK3rGWqW6eMbn/+ToVodguskuU3xvRlieem2hj/P3iGpr1Z0XVsZqwwRP5TFRHWN3uIV/xV2wQJkfY6GnT0NGnbYI+06J3xLxrUBEvFyQXK2uASOjia4m/QFHrdke2R2/bYT0AtEzeTYqD8yb2raGmDtE5hD7/K7mqrJ+mQW393UH310Ltc3SrbwAlHqzzFIdeqlAVgB3ISV266Kydy+to5JD9lGk/ct98h/jdajT7OjwD6ES4cGCYkDYDETf/yJuPes=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 13 Dec 2025 at 12:21, SeongJae Park <sj@kernel.org> wrote:
>
> On Sat, 13 Dec 2025 10:10:38 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Sat, 13 Dec 2025 at 08:11, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Fri, 12 Dec 2025 22:20:04 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > >
> > > > On Mon, 8 Dec 2025 at 15:35, SeongJae Park <sj@kernel.org> wrote:
> > > > >
> > > > > Now any DAMON API callers can report their observed access information.
> > > > > The DAMON core layer is just ignoring those, though.  Update the core to
> > > > > use the reported information at building the high level access pattern
> > > > > snapshot.
> > > >
> > > > It seems inefficient to repeatedly access the damon_access_reports[1000] array
> > > > using a for loop in the kdamond_check_reported_accesses() function.
> > > > It is inefficient to for loop through the entire
> > > > damon_access_reports[1000] array.
> > > > When CONFIG_HZ and jiffies are increased as follows and
> > > > damond sample_interval is 5000us (5ms), the time flow diagram is as follows.
> > > >
> > > > CONFIG_HZ 1000, jiffies == 1ms
> > > > damond sample_interval == 5000us (5ms)
> > > >
> > > > reports_len(==): [0 ... 5]
> > > >                                                      [*]
> > > >         0    1    2    3    4    5     6    7    8    9        997    998     999
> > > >         [====|====|====|====|====]-----|----|----|----|  ....  |------|-------|
> > > > jiffies++    1    2    3    4    5     0    0    0    0        0      0       0
> > > > damond_fn(sample interval)      -5[0<]
> > > >
> > > > reports_len(==): [997 ... 2]
> > > >                                   [*]
> > > >         0      1      2    3    4    5     6    7    8    9        997   998   999
> > > >         [======|======]----|----|----|-----|----|----|----|  ....  [=====|=====]
> > > > jiffies++   1001      1002 3    4    5     6    7    8    9        997   998   999
> > > > damond_fn(sample interval)
> > > >                             -5[997<]
> > >
> > > Please use fixed-length fonts for something like above, from next time.  I
> > > fixed the diagram with my best effort, as above.  But I still fail at
> > > understanding your point.  More clarification about what the diagram means
> > > would be nice.
> >
> > Thank you for readjusting the font to fit.  The first diagram above is when
> > reports_len is processed normally starting from 0 to reports_len.
> > The second diagram shows the process where reports_len increases to its
> > maximum values of 997, 998, 999, and then returns to 0.
>
> Thank you for adding this clarification.
>
> > The biggest problem here is that the latter part of the array is not processed.
>
> I don't get what "processed" is meaning, and what is the latter part of the
> array that not processed, and why it is a problem.  Could you please clarify?

I'll just organize the code related to this issue as below.
This applies when kdamond_check_reported_accesses() is executed
when damon_access_reports_len becomes DAMON_ACCESS_REPORTS_CAP.

void damon_report_access(struct damon_access_report *report)
{
        ...
        if (damon_access_reports_len == DAMON_ACCESS_REPORTS_CAP)
                damon_access_reports_len = 0;
        ...
}

static void kdamond_check_reported_accesses(struct damon_ctx *ctx)
{
        for (i = 0; i < damon_access_reports_len; i++) {
                ...
        }
}

>
> >
> > >
> > > >
> > > > It seems that only the section corresponding to the sample interval ([==|==])
> > > > can be cycled as follows.  And, how about enjoying damon_access_reports[1000]
> > > > as damon_access_reports[500]?  Even if it reduce the 1000ms to 500ms
> > > > array space, it seems that it can sufficiently report and process within
> > > > the sample interval of 5ms.
> > >
> > > Are you assuming the the reports can be made only once per 1 millisecond?  That
> > > is not true.  The design assumes any kernel API caller could make the report,
> > > so more than one report can be made within one millisecond.  Am I
> > > missingsomething?
> >
> > jiffies 1ms is just to simply unfold the passage of time when
> > CONFIG_HZ is set to 1000.
> > This is a simplification to help it understand the flow of time.
>
> So I understand you are saying that only one report can be made per jiffy.  But
> that doesn't answer my question because I'm saying that design allows any
> report at any time.  Any number of reports can be made within one jiffy time
> interval.

The input events are what you pointed out, but when reporting,
it is processed in jiffies time with time_before/after().
So we have to take everyone into consideration.

>
> >
> > >
> > > >
> > > >  static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
> > > >  {
> > > > -       int i;
> > > > +       int i = damon_access_reports_len;
> > > > +       unsigned int nr = 0;
> > > >         struct damon_access_report *report;
> > > >         struct damon_target *t;
> > > >
> > > > @@ -2904,16 +2905,18 @@ static unsigned int
> > > > kdamond_check_reported_accesses(struct damon_ctx *ctx)
> > > >                 return 0;
> > > >
> > > >         mutex_lock(&damon_access_reports_lock);
> > > > -       for (i = 0; i < damon_access_reports_len; i++) {
> > > > -               report = &damon_access_reports[i];
> > > > -               if (time_before(report->report_jiffies,
> > > > -                                       jiffies -
> > > > -                                       usecs_to_jiffies(
> > > > -                                               ctx->attrs.sample_interval)))
> > > > -                       continue;
> > > > +       report = &damon_access_reports[i];
> > > > +       while (time_after(report->report_jiffies,
> > > > +               jiffies - usecs_to_jiffies(ctx->attrs.sample_interval))) {
> > > >                 damon_for_each_target(t, ctx)
> > > >                         kdamond_apply_access_report(report, t, ctx);
> > > > +               if (++nr >= DAMON_ACCESS_REPORTS_CAP)
> > > > +                       break;
> > > > +
> > > > +               i = (i == 0) ? (DAMON_ACCESS_REPORTS_CAP - 1) : (i - 1);
> > > > +               report = &damon_access_reports[i];
> > > >         }
> > > > +
> > > >         mutex_unlock(&damon_access_reports_lock);
> > > >         /* For nr_accesses_bp, absence of access should also be reported. */
> > > >         return kdamond_apply_zero_access_report(ctx);
> > > > }
> > >
> > > So I still don't get your points before the above code diff, but I understand
> > > this code diff.
> > >
> > > I agree this is more efficient.  I will consider doing something like this in
> > > the next spin.
> >
> > What I tried above is to process the current array [1000] as
> > efficiently as possible.
> > But, if I think again, It would be better to store it in a linked-list
> > and process it
> > in FIFO mode whenever requested in damon_report_page_fault(),
> > damon_report_access(report)
> > instead of storing it in an array.  I'm also analyzing the source code
> > starting this week,
> > so I'll organize it a bit more and get back to you with my opinion.
>
> I personally don't feel linked list is specially better than the current
> ring-buffer like implementation at the moment.  But I would be happy to learn
> new ideas.  Please feel free to revisit when you get a chance.

I agree that the ring-buffer you mentioned is good.
However, if this is not well controlled, it is less efficient than FIFO,
so I am analyzing your source code a bit more.

Thanks,
JaeJoon

>
>
> Thanks,
> SJ
>
> [...]

