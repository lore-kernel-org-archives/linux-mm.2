Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E3ABD59F7A
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 09:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9380E6B0005; Sat, 13 Dec 2025 04:17:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2056B0007; Sat, 13 Dec 2025 04:17:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 789526B0008; Sat, 13 Dec 2025 04:17:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 610156B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 04:17:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F156E1A05C0
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 09:17:10 +0000 (UTC)
X-FDA: 84213893820.30.C680199
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3E69CC000B
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 09:17:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J7h7MjRF;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765617429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hR/d/jT7ZfIrXCb/i4BqcI91+I+cuWrlfFH0Gn2jm0=;
	b=vXPnjoQ9YWcmYsDhOoCrYQdWbTyapAlDvb8+dEoAdvuoSN1oE21pf+bNp0dYOjxapxsHkI
	X8GW5e6ZXYOebFwGI7Yj9Z0GS0ZfEfYq2e8wa8ZxVgTHs4W0V/DDz3ytRGINM6VQhK5Y1r
	mgESp+ezKi6+OUYXM/B3fmfSSHSGD2I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765617429; a=rsa-sha256;
	cv=none;
	b=s0Ha6TXbzg6yAUHsmO5r03Mq9vGp8VyLSNnkuEko/wwij6Ckx6+4GHdL3rBuuwbNbnlCkd
	QhGQl4gOQDshtlkZpA6UNsaUzBzulnNO5X7mkvGtWfGsLwA4bKP3tCTn0pK3Vl172DE6Rf
	6N60Oig869c7dPDbjWm6XJWUKFD5DGU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J7h7MjRF;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A2ED437B9;
	Sat, 13 Dec 2025 09:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7281C4CEF7;
	Sat, 13 Dec 2025 09:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765617427;
	bh=Viy5jp1GAhDvFDYvmsnNdApwzWh0FMjTdIf4v0RpktM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7h7MjRFKYVruehELr+ndqOzpbhSfDReeR6uOlevUnVJXJEbeMkxT6u7MMGlEKKey
	 8qnNkV85GTyODrvaRRzf/u3mJyr18f01gQD3k6LAHjVQl/rHQvrro5ufY/2/KI8Syp
	 paoohcfhAGQAh9ZWR6eyPU+QI3ZSG50I3hvRbb3c9bhYjVc+pPiwcg9fEMmx9DYcxD
	 M8T98Tq02h/Cw4o4CnrnH8K5V1H0E6m5lmBVidIJYzluM0K+31UCtEGK616OtyGcDc
	 AOR8fIcjNVU2E4O8fzSen+Z4YSjMy7gfHhjNEemIJ6jFxJLuP22298xoUntj/rodxd
	 CWN/M+Vx5a14Q==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: JaeJoon Jung <rgbi3307@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 07/37] mm/damon/core: apply access reports to high level snapshot
Date: Sat, 13 Dec 2025 01:17:03 -0800
Message-ID: <20251213091704.53985-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251213055334.51806-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ctj6injkqspmr7mateg8s3e37i796tq8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3E69CC000B
X-Rspam-User: 
X-HE-Tag: 1765617429-457348
X-HE-Meta: U2FsdGVkX1+AyiwnTN5ROwarbQPAWGj8gmegHa12opdSLgYEgGBWfQ4OsBYb3zqT3VzFtoOD1SqPcMPs5PQTMtTc/5A/Cl2Jca2O4rVR6/z72Cv02gPEa34Unvu6l34Rf9p5R1BESm1+8rYoi5d1/51ifS2uCh6MGWK4HwfRnZSPxYoRwSsQ1jMOx7XQvWHRPjJowKBGnLILVMHFsi1QxOSQsa5YQxvWrLUr7a+mIZjpvxd5xjVGutAgrMXW0VUentXhf0w3hOJoH7eJ7JIaHe9hsjBG1I7y+/kCpaWXSUaIlJ1INoAfB00x78KNGXl75Lnq6vfYJe1NVHVN5I2bWZ7Zj/JjWV9/x1Jp7RIggAP5F3vdEjoctJs6Yvz9ggumTRKZXbd1p0fR3Xl2e3W5VO+iDu/xZLZZuqXlWIiNV1oHxTD89tQF72jekvse0CE0VR3W/wf3sSqEytZG+e8egStU78M1TNjkYrzxmMa2NKfiCwz8ex1Fez0gN+v6GK3dzeRXblINsD9oOBLiRg3QHJNit/H9YGvv7hg9EfvMfBC+EX2h2QNzVQoKttViboPWg3Hq0m8h9V1H4ghTS6G4NpDbJPLiGVkOlMUV9SzPoqzcsgTvZ5ZHA0yv2XweUb1vFKEu7/lmxUOzhzbw2o93gO53RzLVQKevCfYPSZw4/N2dUZB3X9ebFt0irm8X5PGNi9uY2kTeD/X4XvcXFYwubBVpxcmlKUyI5dpRq3f/wFjiOz6yXntXLjBUF+FfL1BjixHtJEcNRAWCE7C18uwhfhqy2JsE8RnVX6WN2Tht0jgv9OvvUWEw4rFZUpK+C8PtUwuoX209jRGj9Mco3GBYrsbRf4iYMfS1rKzkPmamAgagGbrrJW1wNGCzKkG3hmQIXCnPehsu9EsgfhM9OzKvdNAlEVODAfd4xiXX8LTKCyEfJToaDnAzmoiJ6ZuyJuTkR5ezFX0el6CsEfCLNq4
 4cdmRFP/
 yFd7GZUprUX8TSIHtZ/j/a2PnVEFXRt+APS82NOANkSgLuGs2dYg+McWk8ieqTfrNnDLS6UfFOi7nqzKvLxkLI+xsvaNQiHQXKC5WjnBltfCcfQUUyTDPcrBqFlu5UopFrhD+ADR2oBYbpbKToC319lJxGbtsTKjBtUbTfb8VSwFat4ZqrAry3gZwlJ1WK/xXIER869D6Pss6b+AE8opBsin5uhIfEUvgq6bxWe6aXxujLmK03dOU/s2vT3Ldh8jlBFQu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Dec 2025 21:53:34 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Sat, 13 Dec 2025 13:09:37 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> 
> > On Sat, 13 Dec 2025 at 12:21, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Sat, 13 Dec 2025 10:10:38 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > >
> > > > On Sat, 13 Dec 2025 at 08:11, SeongJae Park <sj@kernel.org> wrote:
> > > > >
> > > > > On Fri, 12 Dec 2025 22:20:04 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > > > >
> > > > > > On Mon, 8 Dec 2025 at 15:35, SeongJae Park <sj@kernel.org> wrote:
> > > > > > >
> > > > > > > Now any DAMON API callers can report their observed access information.
> > > > > > > The DAMON core layer is just ignoring those, though.  Update the core to
> > > > > > > use the reported information at building the high level access pattern
> > > > > > > snapshot.
> > > > > >
> > > > > > It seems inefficient to repeatedly access the damon_access_reports[1000] array
> > > > > > using a for loop in the kdamond_check_reported_accesses() function.
> > > > > > It is inefficient to for loop through the entire
> > > > > > damon_access_reports[1000] array.
> > > > > > When CONFIG_HZ and jiffies are increased as follows and
> > > > > > damond sample_interval is 5000us (5ms), the time flow diagram is as follows.
> > > > > >
> > > > > > CONFIG_HZ 1000, jiffies == 1ms
> > > > > > damond sample_interval == 5000us (5ms)
> > > > > >
> > > > > > reports_len(==): [0 ... 5]
> > > > > >                                                      [*]
> > > > > >         0    1    2    3    4    5     6    7    8    9        997    998     999
> > > > > >         [====|====|====|====|====]-----|----|----|----|  ....  |------|-------|
> > > > > > jiffies++    1    2    3    4    5     0    0    0    0        0      0       0
> > > > > > damond_fn(sample interval)      -5[0<]
> > > > > >
> > > > > > reports_len(==): [997 ... 2]
> > > > > >                                   [*]
> > > > > >         0      1      2    3    4    5     6    7    8    9        997   998   999
> > > > > >         [======|======]----|----|----|-----|----|----|----|  ....  [=====|=====]
> > > > > > jiffies++   1001      1002 3    4    5     6    7    8    9        997   998   999
> > > > > > damond_fn(sample interval)
> > > > > >                             -5[997<]
> > > > >
> > > > > Please use fixed-length fonts for something like above, from next time.  I
> > > > > fixed the diagram with my best effort, as above.  But I still fail at
> > > > > understanding your point.  More clarification about what the diagram means
> > > > > would be nice.
> > > >
> > > > Thank you for readjusting the font to fit.  The first diagram above is when
> > > > reports_len is processed normally starting from 0 to reports_len.
> > > > The second diagram shows the process where reports_len increases to its
> > > > maximum values of 997, 998, 999, and then returns to 0.
> > >
> > > Thank you for adding this clarification.
> > >
> > > > The biggest problem here is that the latter part of the array is not processed.
> > >
> > > I don't get what "processed" is meaning, and what is the latter part of the
> > > array that not processed, and why it is a problem.  Could you please clarify?
> > 
> > I'll just organize the code related to this issue as below.
> > This applies when kdamond_check_reported_accesses() is executed
> > when damon_access_reports_len becomes DAMON_ACCESS_REPORTS_CAP.
> > 
> > void damon_report_access(struct damon_access_report *report)
> > {
> >         ...
> >         if (damon_access_reports_len == DAMON_ACCESS_REPORTS_CAP)
> >                 damon_access_reports_len = 0;
> >         ...
> > }
> > 
> > static void kdamond_check_reported_accesses(struct damon_ctx *ctx)
> > {
> >         for (i = 0; i < damon_access_reports_len; i++) {
> >                 ...
> >         }
> > }
> 
> Ok, so I understand that when damon_access_reports_len is reset, the reports
> that stored at the end part of the array is simply ignored.  And your suggested
> change can fix it.

And I now recall that this was an intended behavior for making this RFC very
simple and therefore can be implemented very quick.  The intention should
definitely be better documented.  I will do so by the next spin.

The purpose of this patchset is only for high level concept review and early
testing, not for being merged as-is.  Until I start believing the high level
concept is not making people very concerned, I want to keep this code as simple
as possible.  Only if it becomes clear the simplicity is making this too
inefficient to do even the early testing, I'd consider optimizing the
efficiency.

So, I will make the intention better documented, but keep the code as is for
now.

> 
> > 
> > >
> > > >
> > > > >
> > > > > >
> > > > > > It seems that only the section corresponding to the sample interval ([==|==])
> > > > > > can be cycled as follows.  And, how about enjoying damon_access_reports[1000]
> > > > > > as damon_access_reports[500]?  Even if it reduce the 1000ms to 500ms
> > > > > > array space, it seems that it can sufficiently report and process within
> > > > > > the sample interval of 5ms.
> > > > >
> > > > > Are you assuming the the reports can be made only once per 1 millisecond?  That
> > > > > is not true.  The design assumes any kernel API caller could make the report,
> > > > > so more than one report can be made within one millisecond.  Am I
> > > > > missingsomething?
> > > >
> > > > jiffies 1ms is just to simply unfold the passage of time when
> > > > CONFIG_HZ is set to 1000.
> > > > This is a simplification to help it understand the flow of time.
> > >
> > > So I understand you are saying that only one report can be made per jiffy.  But
> > > that doesn't answer my question because I'm saying that design allows any
> > > report at any time.  Any number of reports can be made within one jiffy time
> > > interval.
> > 
> > The input events are what you pointed out, but when reporting,
> > it is processed in jiffies time with time_before/after().
> > So we have to take everyone into consideration.
> 
> I don't get your point yet.  Can you please elaborate?

Any elaboration will still be helpful.

> 
> > 
> > >
> > > >
> > > > >
> > > > > >
> > > > > >  static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
> > > > > >  {
> > > > > > -       int i;
> > > > > > +       int i = damon_access_reports_len;
> > > > > > +       unsigned int nr = 0;
> > > > > >         struct damon_access_report *report;
> > > > > >         struct damon_target *t;
> > > > > >
> > > > > > @@ -2904,16 +2905,18 @@ static unsigned int
> > > > > > kdamond_check_reported_accesses(struct damon_ctx *ctx)
> > > > > >                 return 0;
> > > > > >
> > > > > >         mutex_lock(&damon_access_reports_lock);
> > > > > > -       for (i = 0; i < damon_access_reports_len; i++) {
> > > > > > -               report = &damon_access_reports[i];
> > > > > > -               if (time_before(report->report_jiffies,
> > > > > > -                                       jiffies -
> > > > > > -                                       usecs_to_jiffies(
> > > > > > -                                               ctx->attrs.sample_interval)))
> > > > > > -                       continue;
> > > > > > +       report = &damon_access_reports[i];
> > > > > > +       while (time_after(report->report_jiffies,
> > > > > > +               jiffies - usecs_to_jiffies(ctx->attrs.sample_interval))) {
> > > > > >                 damon_for_each_target(t, ctx)
> > > > > >                         kdamond_apply_access_report(report, t, ctx);
> > > > > > +               if (++nr >= DAMON_ACCESS_REPORTS_CAP)
> > > > > > +                       break;
> > > > > > +
> > > > > > +               i = (i == 0) ? (DAMON_ACCESS_REPORTS_CAP - 1) : (i - 1);
> > > > > > +               report = &damon_access_reports[i];
> > > > > >         }
> > > > > > +
> > > > > >         mutex_unlock(&damon_access_reports_lock);
> > > > > >         /* For nr_accesses_bp, absence of access should also be reported. */
> > > > > >         return kdamond_apply_zero_access_report(ctx);
> > > > > > }
> > > > >
> > > > > So I still don't get your points before the above code diff, but I understand
> > > > > this code diff.
> > > > >
> > > > > I agree this is more efficient.  I will consider doing something like this in
> > > > > the next spin.

As I mentioned above, I may not do that but make the documentation better.


Thanks,
SJ

[...]

