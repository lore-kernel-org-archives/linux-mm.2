Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3FC3D59F5C
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 03:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894AF6B0005; Fri, 12 Dec 2025 22:21:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845726B0007; Fri, 12 Dec 2025 22:21:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731C46B0008; Fri, 12 Dec 2025 22:21:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6015D6B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 22:21:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03CB2B96BD
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 03:21:33 +0000 (UTC)
X-FDA: 84212997708.12.6A23E1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6967380005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 03:21:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aeN+3Fex;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765596092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=56rb9YJZpLUWwDjJijfc7AuJl+s0F4GN9ASHRoA1yfk=;
	b=0N7hImGjAMFTRCnLhDw99ekp/iBXrdolTGZrVpewmNjdCUX4NngcXhkampde+KjamxHnTg
	buoCtYzg51hylg+QeJ5eEug5HlcQn4pyigSPcsE+fG7X/gFagywayCYOWbfnTzkRu3Nuri
	nmZw3B5eEXm+4s7nKhDytSrz4s8Ir7o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aeN+3Fex;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765596092; a=rsa-sha256;
	cv=none;
	b=SYj9NjGYlx6NtRiuhs52Hvy/Dssj00Q65F/ZCpBqyT7HAhoqYtMO7m7rkmSfB4RlyWz44O
	6/OCbiiSQERIE0hxT3DpEbULbj/VfGgzW4m0Gct49jdLrV9QubqEU4+8rZycZ1EAuLU8xA
	uAUCGBxFiyq7UL7iWgC+VLBi51jxoq0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 96E8E601AA;
	Sat, 13 Dec 2025 03:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EB1C113D0;
	Sat, 13 Dec 2025 03:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765596091;
	bh=kT7u+4G4tMNU0hzWWYdQK1IaQytQ2ZSZvqDLHNbzUT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aeN+3FexFboZmXsDmmxLJJloFnjNMI6naFV3jgHQ1CjrdiU7L9L6rRoFZL5/Ol0eR
	 Y3L87T6YGDnpRN0ZT61u9udq9P52/6sLk6fd8qzzDIr2rWnDxcfrq/FljOTeLLHBZZ
	 IWKTw5EX4gWH0BXC9/dem2rIAvUgHoeAf8Y0Zf/eU6lmESJQ7AKPhzDWeLlQO11EGQ
	 0E3hBLCIhScL+TiMs7aokWaAvSWKzWRa5gUdJedohhLyDYfAbyDgHJSkrhGG5mriYb
	 jmx2KNy/KJh/ExOeDfBMgiTFTRHBDp1ikpr7nKOJ/sH4cnn/B5MqUreSJNCudO9SxI
	 t+WZFKcPclRCw==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 07/37] mm/damon/core: apply access reports to high level snapshot
Date: Fri, 12 Dec 2025 19:21:27 -0800
Message-ID: <20251213032128.50837-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC6TXo=7svC2Ka=+rf_YLTMnaF8QUV_nNvuef20XMZ=+pA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: 71384syidtaahwsmcad31xyhmwtjjyqq
X-Rspam-User: 
X-Rspamd-Queue-Id: 6967380005
X-HE-Tag: 1765596092-35746
X-HE-Meta: U2FsdGVkX1+9LHchEeE0GFdOZPWAHcv0p0MZnS/ilLnHJEDiHL08ZKXhsh1F6OTWX6loPeb2HGx/OlDsGYcMEQYC4pA4pXNWOxN8qAPpXZEx8U6FJ5CZvxUilG/YfrwnFucdgfuKccunlv1qywLF//qxZNcc3SqopOpBiQU96JT7quVUGRETDZ1m4vs1rwyo5wrofFg3raqJzTheH/3Zv4f17rpUrSkIERub3Sc80W7pZ7CP0vqWyy2xMNTJ7eM6JtO5+fWigUOQc+rkZnHjs8jIjl01AwJB2RcLATGKOnWQm6NeFUntAHdBNe5fEEhuBnVfv+oxy/ELt5KAjWcY6xyDPoC3AiDwVBRclYb5XsxtSXudrxYGAF5NIPcgaKM/N/W3NKE5P8ZK9+zINCiMttGNAQag6UV8Tea85NwRJvM77xcklzRSdlqPPJ11wS0Ja0N6RJhlyJc6JnPxPtlpTZTWvgGKeD3Oj9/INg5HyNjbQcUKkSZ7XLHyPkvRWyOwIzLbHFIqCQ2Pz9UlJ9g/wMIO4drXIMwagZs2D5zY+S8N+N81egwS8CQYYHNBi+ajeDNATpH0KeckwGeemGxQCtdoOmtMLUh+MlJJO5zMa4zLRb8gy+jVxdJtXuow5eVQBQViU0rkT5HzwCqbvJg4TdyVnxKFn3KR0yuVdJZrITRBBo118gfVPEQWz4oqY0OOYOfclJcsRLcc/A4MQO7pphwXehWXBgtSZspkCEXwWKEJOe5yEhhFEbz3chy1hnCO0/fRl3EEFZxFsflJwRZDFOQCOTRR9FVN2mTlQgXoo3/VWnvSPgrq/qseDms70tvW/SAUzwXC+O3QLZ5MyWw5Aj/py+mpqDOv2rygS69qWK+zoPfZx7LV735VKi4xGqj1HT0NcPGlvfZmFOQOsZoCqwhA8vUIf6RVHLaP7MGJnA5SEfpWEwuHujbfs7Ehgw+2ED2od+eGjdJfvz4H18w
 SbLixG74
 BQ+ZjvOKuyJ4Eh/Q2Uxox23CrTUK6Xj4kVPFdqvQox2+6V6SE4BJL02HIX1iDj1LWu+2oDXHq4noF+K2V+1AnTWyv4rt0zFsm6C8uAqOaMZyj8xaTtUOBMKHyKT9+/SFQRXAGXXULyNWwjaSABW17FFdRwR/f2dnPPJpfBvyBA2y87aOeEjRtH+KQ696Fp8nAzTwOnqL6Q9wF+3ynb4qLc60CLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 13 Dec 2025 10:10:38 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Sat, 13 Dec 2025 at 08:11, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Fri, 12 Dec 2025 22:20:04 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > On Mon, 8 Dec 2025 at 15:35, SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > Now any DAMON API callers can report their observed access information.
> > > > The DAMON core layer is just ignoring those, though.  Update the core to
> > > > use the reported information at building the high level access pattern
> > > > snapshot.
> > >
> > > It seems inefficient to repeatedly access the damon_access_reports[1000] array
> > > using a for loop in the kdamond_check_reported_accesses() function.
> > > It is inefficient to for loop through the entire
> > > damon_access_reports[1000] array.
> > > When CONFIG_HZ and jiffies are increased as follows and
> > > damond sample_interval is 5000us (5ms), the time flow diagram is as follows.
> > >
> > > CONFIG_HZ 1000, jiffies == 1ms
> > > damond sample_interval == 5000us (5ms)
> > >
> > > reports_len(==): [0 ... 5]
> > >                                                      [*]
> > >         0    1    2    3    4    5     6    7    8    9        997    998     999
> > >         [====|====|====|====|====]-----|----|----|----|  ....  |------|-------|
> > > jiffies++    1    2    3    4    5     0    0    0    0        0      0       0
> > > damond_fn(sample interval)      -5[0<]
> > >
> > > reports_len(==): [997 ... 2]
> > >                                   [*]
> > >         0      1      2    3    4    5     6    7    8    9        997   998   999
> > >         [======|======]----|----|----|-----|----|----|----|  ....  [=====|=====]
> > > jiffies++   1001      1002 3    4    5     6    7    8    9        997   998   999
> > > damond_fn(sample interval)
> > >                             -5[997<]
> >
> > Please use fixed-length fonts for something like above, from next time.  I
> > fixed the diagram with my best effort, as above.  But I still fail at
> > understanding your point.  More clarification about what the diagram means
> > would be nice.
> 
> Thank you for readjusting the font to fit.  The first diagram above is when
> reports_len is processed normally starting from 0 to reports_len.
> The second diagram shows the process where reports_len increases to its
> maximum values of 997, 998, 999, and then returns to 0.

Thank you for adding this clarification.

> The biggest problem here is that the latter part of the array is not processed.

I don't get what "processed" is meaning, and what is the latter part of the
array that not processed, and why it is a problem.  Could you please clarify?

> 
> >
> > >
> > > It seems that only the section corresponding to the sample interval ([==|==])
> > > can be cycled as follows.  And, how about enjoying damon_access_reports[1000]
> > > as damon_access_reports[500]?  Even if it reduce the 1000ms to 500ms
> > > array space, it seems that it can sufficiently report and process within
> > > the sample interval of 5ms.
> >
> > Are you assuming the the reports can be made only once per 1 millisecond?  That
> > is not true.  The design assumes any kernel API caller could make the report,
> > so more than one report can be made within one millisecond.  Am I
> > missingsomething?
> 
> jiffies 1ms is just to simply unfold the passage of time when
> CONFIG_HZ is set to 1000.
> This is a simplification to help it understand the flow of time.

So I understand you are saying that only one report can be made per jiffy.  But
that doesn't answer my question because I'm saying that design allows any
report at any time.  Any number of reports can be made within one jiffy time
interval.

> 
> >
> > >
> > >  static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
> > >  {
> > > -       int i;
> > > +       int i = damon_access_reports_len;
> > > +       unsigned int nr = 0;
> > >         struct damon_access_report *report;
> > >         struct damon_target *t;
> > >
> > > @@ -2904,16 +2905,18 @@ static unsigned int
> > > kdamond_check_reported_accesses(struct damon_ctx *ctx)
> > >                 return 0;
> > >
> > >         mutex_lock(&damon_access_reports_lock);
> > > -       for (i = 0; i < damon_access_reports_len; i++) {
> > > -               report = &damon_access_reports[i];
> > > -               if (time_before(report->report_jiffies,
> > > -                                       jiffies -
> > > -                                       usecs_to_jiffies(
> > > -                                               ctx->attrs.sample_interval)))
> > > -                       continue;
> > > +       report = &damon_access_reports[i];
> > > +       while (time_after(report->report_jiffies,
> > > +               jiffies - usecs_to_jiffies(ctx->attrs.sample_interval))) {
> > >                 damon_for_each_target(t, ctx)
> > >                         kdamond_apply_access_report(report, t, ctx);
> > > +               if (++nr >= DAMON_ACCESS_REPORTS_CAP)
> > > +                       break;
> > > +
> > > +               i = (i == 0) ? (DAMON_ACCESS_REPORTS_CAP - 1) : (i - 1);
> > > +               report = &damon_access_reports[i];
> > >         }
> > > +
> > >         mutex_unlock(&damon_access_reports_lock);
> > >         /* For nr_accesses_bp, absence of access should also be reported. */
> > >         return kdamond_apply_zero_access_report(ctx);
> > > }
> >
> > So I still don't get your points before the above code diff, but I understand
> > this code diff.
> >
> > I agree this is more efficient.  I will consider doing something like this in
> > the next spin.
> 
> What I tried above is to process the current array [1000] as
> efficiently as possible.
> But, if I think again, It would be better to store it in a linked-list
> and process it
> in FIFO mode whenever requested in damon_report_page_fault(),
> damon_report_access(report)
> instead of storing it in an array.  I'm also analyzing the source code
> starting this week,
> so I'll organize it a bit more and get back to you with my opinion.

I personally don't feel linked list is specially better than the current
ring-buffer like implementation at the moment.  But I would be happy to learn
new ideas.  Please feel free to revisit when you get a chance.


Thanks,
SJ

[...]

