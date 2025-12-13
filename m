Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB17D59F6C
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 05:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B454D6B0005; Sat, 13 Dec 2025 00:53:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF65B6B0007; Sat, 13 Dec 2025 00:53:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0AD26B0008; Sat, 13 Dec 2025 00:53:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7F36B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 00:53:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 046A05917B
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 05:53:40 +0000 (UTC)
X-FDA: 84213381042.27.5738422
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5AA261C0007
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 05:53:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=So410YQ6;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765605219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSJV9aJqSvYHMMuhw4qg92a34nPkAO6Mx9DdJoEqBsg=;
	b=HPR6BzSHNm2nX9aESjyuzf8ifUvfIvvO7j3qVnGW6czXyHWzbGJh2V9/WfKCNy9kuUMTu8
	f6KhPHWVGrPtZVD0swqAY4riSSjemsLNOwwY3kZtR+iHIyX/9tCuczKlB0MlkD9pl7Pihq
	X42WQWy3F7IynY8XI/ZmprqDhdQgPUA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=So410YQ6;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765605219; a=rsa-sha256;
	cv=none;
	b=cf3f3SJG0IJ3zbJdb4f8IG+rv2/kXjtsVNLxWaedVEsPbAOPPSiXTgnhSV1/b/WgIfdhHS
	1t1lBac9fUgyQAsihdbpU2lbCATzS1s1uj4gWfjfpAdOPW+DtBofd/5c54+XtdPsJDIBUT
	YA85HgUN6sthE2wB43IY5oAOa+2XJZ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8ED3E600AA;
	Sat, 13 Dec 2025 05:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A307C4CEF7;
	Sat, 13 Dec 2025 05:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765605218;
	bh=Wccp+wZXScgD8eLeujdXQFZ/mmoEHYeNoY4rN4AzM+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=So410YQ6KPo6pKsazNewNsZwmkjx1uv56FwCs5LKCdpaAhqfwNKHd2w/UkMnSPDj5
	 umohLOb8ZXoe1fecaDJkCrJT+Bvjlae+fr5JDcKos/Nk/zekY0DGBg1x1T6/52qUGv
	 HUzJDPCtlKvvDVxU7OvOcA0ekgZBJklfeHbrwFajcEL84rPyLwM/4H3lVHHuASGn+r
	 tHY+3KJZh4xRXDoRpkMjZghg3LCPlcGen/JUapCj9FRd+kz/jl0HZb7I5TKSPOYs2k
	 A3PbECVA+IJLqgrL/ZMeRjKGJf5yE4zb8FBKihMdmBhRcvGizjvEDdh4jCpN7sJdds
	 wMl3mTo235Mdw==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 07/37] mm/damon/core: apply access reports to high level snapshot
Date: Fri, 12 Dec 2025 21:53:34 -0800
Message-ID: <20251213055334.51806-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC5izV51xSXFBBijVOCaffwimbmEe6YPk2AVJWXAK59t+w@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AA261C0007
X-Stat-Signature: 16hfwcsubqjjmguufq35aknre5si4uea
X-HE-Tag: 1765605219-510491
X-HE-Meta: U2FsdGVkX181Va7ToyPE0+pEkWRSQrlnXZfLFApUCKyZE6IKIzPiEwpLEthfY4cujkOUlCZR9YMp8DDm9MF1pzUzeOzRAMUlPbM/b44pw01hIO1AIug8ADF509rBtwH9KQtorQqOkbfqmmmXikSel9ljypTPV5O4M4PwM4zeXA1SVRvrLm2Wn4McRzESdHS9dC1KmxPljpmTpoZ3Fsww3tlEgmtfpY0dkK1LJFjXpg0PEbGwPTvfSvgfo+vvYjfl8a6rYVJdmc100u9LpDABfoY/NMWykfNTKIlO+wa8DrMeWIAZTk6vwFU3u8PcrXxsfCXuN3vsrvU2E9U9ENl9QxMUGcWEe1qMNWJ97x0Z1bViIocQozc4V+AnfsYBI6FKu49A/+8rzdnXCa3rY3/UPaX8HO7cu7QUFc5Dtitk9bQlTKp0y0F3DoXZAmQUDXk/INbX+0FvH5AiwPURzrWyYUk8F0Bk5+yxsZZwLqIm68Wf9h4ZFExtDzM8XS+dsSb+cOcghUF9Jc/3dOzqUDQ9DZCI3+mS3Z8JcnkvuDDnIpiS3RnkTTSjmMteWi2Wj8ppoCzu3m0eabo0pTIYCYrzuBL2rPS1XVNnEeDwiZEKyJEh64O8GCpfrbbhCmTTJCgneNme3afWsQ3yXEf674g/+HKoupPd4MHRqxrBpNAb8Eh6McpxhwEIM6Zv1Tlf9u81tpwFoPK1NviCdBMesh7d3ksVPihyZuUGFBWZ6NgkJD0S6kFcBto5N4TPOkuiv26Z+fyjq+fDmIuruK0bs0J5y1gPk3FQ+UcN26Gs2SFDOTbxGhRBpUobMIpfhR7RsEyMiwa+yzs2YMoHxD0S6o1t4sQxlvbFkVtk4pylZhS2klXp9czFqqTGvH9C71kR/T1kn50ltHoRXCsKAtb1PXIvVc/zK/xAQ3GguOKe50v3XO5Bdsyf7qz3BJKHqSsHdUFjqBpO1Jme25mk1PK5CB+
 hwDbtINk
 ViZfoIXZh8Xtm4KsKFJEe818MU5cJWhi0WoNcmyfJxATPy7NBBMUkuQSqpcCweteomi8IGi5mHlaTwatPM8dzGiqXjvPgO01U8q7MxeHfB0t7ITdrP9xpuWAropF/cEASDZNEoHyJsFCetvVz+ctpySHFmQRWKe90QPgniq8J3wVgjwrU7uHQm2OquuIi06gYRSRl6KKSxHqvOZIKSoZhI2Koaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 13 Dec 2025 13:09:37 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Sat, 13 Dec 2025 at 12:21, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Sat, 13 Dec 2025 10:10:38 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > On Sat, 13 Dec 2025 at 08:11, SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > On Fri, 12 Dec 2025 22:20:04 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > > >
> > > > > On Mon, 8 Dec 2025 at 15:35, SeongJae Park <sj@kernel.org> wrote:
> > > > > >
> > > > > > Now any DAMON API callers can report their observed access information.
> > > > > > The DAMON core layer is just ignoring those, though.  Update the core to
> > > > > > use the reported information at building the high level access pattern
> > > > > > snapshot.
> > > > >
> > > > > It seems inefficient to repeatedly access the damon_access_reports[1000] array
> > > > > using a for loop in the kdamond_check_reported_accesses() function.
> > > > > It is inefficient to for loop through the entire
> > > > > damon_access_reports[1000] array.
> > > > > When CONFIG_HZ and jiffies are increased as follows and
> > > > > damond sample_interval is 5000us (5ms), the time flow diagram is as follows.
> > > > >
> > > > > CONFIG_HZ 1000, jiffies == 1ms
> > > > > damond sample_interval == 5000us (5ms)
> > > > >
> > > > > reports_len(==): [0 ... 5]
> > > > >                                                      [*]
> > > > >         0    1    2    3    4    5     6    7    8    9        997    998     999
> > > > >         [====|====|====|====|====]-----|----|----|----|  ....  |------|-------|
> > > > > jiffies++    1    2    3    4    5     0    0    0    0        0      0       0
> > > > > damond_fn(sample interval)      -5[0<]
> > > > >
> > > > > reports_len(==): [997 ... 2]
> > > > >                                   [*]
> > > > >         0      1      2    3    4    5     6    7    8    9        997   998   999
> > > > >         [======|======]----|----|----|-----|----|----|----|  ....  [=====|=====]
> > > > > jiffies++   1001      1002 3    4    5     6    7    8    9        997   998   999
> > > > > damond_fn(sample interval)
> > > > >                             -5[997<]
> > > >
> > > > Please use fixed-length fonts for something like above, from next time.  I
> > > > fixed the diagram with my best effort, as above.  But I still fail at
> > > > understanding your point.  More clarification about what the diagram means
> > > > would be nice.
> > >
> > > Thank you for readjusting the font to fit.  The first diagram above is when
> > > reports_len is processed normally starting from 0 to reports_len.
> > > The second diagram shows the process where reports_len increases to its
> > > maximum values of 997, 998, 999, and then returns to 0.
> >
> > Thank you for adding this clarification.
> >
> > > The biggest problem here is that the latter part of the array is not processed.
> >
> > I don't get what "processed" is meaning, and what is the latter part of the
> > array that not processed, and why it is a problem.  Could you please clarify?
> 
> I'll just organize the code related to this issue as below.
> This applies when kdamond_check_reported_accesses() is executed
> when damon_access_reports_len becomes DAMON_ACCESS_REPORTS_CAP.
> 
> void damon_report_access(struct damon_access_report *report)
> {
>         ...
>         if (damon_access_reports_len == DAMON_ACCESS_REPORTS_CAP)
>                 damon_access_reports_len = 0;
>         ...
> }
> 
> static void kdamond_check_reported_accesses(struct damon_ctx *ctx)
> {
>         for (i = 0; i < damon_access_reports_len; i++) {
>                 ...
>         }
> }

Ok, so I understand that when damon_access_reports_len is reset, the reports
that stored at the end part of the array is simply ignored.  And your suggested
change can fix it.

> 
> >
> > >
> > > >
> > > > >
> > > > > It seems that only the section corresponding to the sample interval ([==|==])
> > > > > can be cycled as follows.  And, how about enjoying damon_access_reports[1000]
> > > > > as damon_access_reports[500]?  Even if it reduce the 1000ms to 500ms
> > > > > array space, it seems that it can sufficiently report and process within
> > > > > the sample interval of 5ms.
> > > >
> > > > Are you assuming the the reports can be made only once per 1 millisecond?  That
> > > > is not true.  The design assumes any kernel API caller could make the report,
> > > > so more than one report can be made within one millisecond.  Am I
> > > > missingsomething?
> > >
> > > jiffies 1ms is just to simply unfold the passage of time when
> > > CONFIG_HZ is set to 1000.
> > > This is a simplification to help it understand the flow of time.
> >
> > So I understand you are saying that only one report can be made per jiffy.  But
> > that doesn't answer my question because I'm saying that design allows any
> > report at any time.  Any number of reports can be made within one jiffy time
> > interval.
> 
> The input events are what you pointed out, but when reporting,
> it is processed in jiffies time with time_before/after().
> So we have to take everyone into consideration.

I don't get your point yet.  Can you please elaborate?

> 
> >
> > >
> > > >
> > > > >
> > > > >  static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
> > > > >  {
> > > > > -       int i;
> > > > > +       int i = damon_access_reports_len;
> > > > > +       unsigned int nr = 0;
> > > > >         struct damon_access_report *report;
> > > > >         struct damon_target *t;
> > > > >
> > > > > @@ -2904,16 +2905,18 @@ static unsigned int
> > > > > kdamond_check_reported_accesses(struct damon_ctx *ctx)
> > > > >                 return 0;
> > > > >
> > > > >         mutex_lock(&damon_access_reports_lock);
> > > > > -       for (i = 0; i < damon_access_reports_len; i++) {
> > > > > -               report = &damon_access_reports[i];
> > > > > -               if (time_before(report->report_jiffies,
> > > > > -                                       jiffies -
> > > > > -                                       usecs_to_jiffies(
> > > > > -                                               ctx->attrs.sample_interval)))
> > > > > -                       continue;
> > > > > +       report = &damon_access_reports[i];
> > > > > +       while (time_after(report->report_jiffies,
> > > > > +               jiffies - usecs_to_jiffies(ctx->attrs.sample_interval))) {
> > > > >                 damon_for_each_target(t, ctx)
> > > > >                         kdamond_apply_access_report(report, t, ctx);
> > > > > +               if (++nr >= DAMON_ACCESS_REPORTS_CAP)
> > > > > +                       break;
> > > > > +
> > > > > +               i = (i == 0) ? (DAMON_ACCESS_REPORTS_CAP - 1) : (i - 1);
> > > > > +               report = &damon_access_reports[i];
> > > > >         }
> > > > > +
> > > > >         mutex_unlock(&damon_access_reports_lock);
> > > > >         /* For nr_accesses_bp, absence of access should also be reported. */
> > > > >         return kdamond_apply_zero_access_report(ctx);
> > > > > }
> > > >
> > > > So I still don't get your points before the above code diff, but I understand
> > > > this code diff.
> > > >
> > > > I agree this is more efficient.  I will consider doing something like this in
> > > > the next spin.
> > >
> > > What I tried above is to process the current array [1000] as
> > > efficiently as possible.
> > > But, if I think again, It would be better to store it in a linked-list
> > > and process it
> > > in FIFO mode whenever requested in damon_report_page_fault(),
> > > damon_report_access(report)
> > > instead of storing it in an array.  I'm also analyzing the source code
> > > starting this week,
> > > so I'll organize it a bit more and get back to you with my opinion.
> >
> > I personally don't feel linked list is specially better than the current
> > ring-buffer like implementation at the moment.  But I would be happy to learn
> > new ideas.  Please feel free to revisit when you get a chance.
> 
> I agree that the ring-buffer you mentioned is good.
> However, if this is not well controlled, it is less efficient than FIFO,
> so I am analyzing your source code a bit more.

We consider not only efficiency but also simplicity.  Please keep that in mind.


Thanks,
SJ

[...]

