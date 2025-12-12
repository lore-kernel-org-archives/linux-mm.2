Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E897D59F52
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 23:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 775506B0006; Fri, 12 Dec 2025 18:11:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74CC96B0007; Fri, 12 Dec 2025 18:11:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A4D6B0008; Fri, 12 Dec 2025 18:11:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 557006B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:11:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BDC87B855C
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 23:11:54 +0000 (UTC)
X-FDA: 84212368548.02.1A39ED1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 036B210000D
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 23:11:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q4Or2xyS;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765581113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RxNakWe3sHRyKec/cOeTnRHVmGw9RtxH9wyk4eABYBI=;
	b=ly/oO6Kd4RLU+5VxPrET4d+C6Cc43wUSJWRncyTzf+yXfAQ6n+jJ9A4+23orK373Uc3FZw
	Eys7fbXF//r5KPgRUdBCPQsjjtv5HiiRchIGsx2kN6g6gNGypQAuTzEmjPwa7hRkTM3Q4N
	iyb6eIEz4sKToteZSl12Gr8NisGo8WA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q4Or2xyS;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765581113; a=rsa-sha256;
	cv=none;
	b=04Mwc7FvUtotB9WyfkrjSKaohLk7DHZrr9/ZlvOPx2Yqp9/cPZDb11fT6qo9NvTa3Ey9Dl
	OfFs4d0imfmD2OMyxzLRI93JkiI2jNEErYCEsegEMlXUIFJHm2ESZdBxH3ssLnK8skBy8S
	TI24aAVKenA204CPhQa2COhORtY6UaU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 14AEA40361;
	Fri, 12 Dec 2025 23:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F09C4CEF1;
	Fri, 12 Dec 2025 23:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765581111;
	bh=P3uU7ajhp4vqPPW35PSbg+rdWdrGLIQGgY65lb1tkc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4Or2xySrQs91xkZYelAnLmWEzQ0ifu8RgboOCiScqQ2E8FpRgF5huJa9ljamuu5Q
	 vDbk/hCr2S+yMhWL/1onf+bZoRA+AaIAqZDjcpvEzx4JQbLADKJx8UfZscGmdqv1XH
	 RyGrc8b4w9zRl/vDEXBHfp8V0hkvBQaxjRvP3OuBJMFfGJsjtKxx8sAI+zU5oLGNgv
	 zgK/hlW+8TGLHJ/pvv6Dl0UOHTiqFfVf6MFH86iDKmbPXF/EMvquCbEY+rsDumCUu4
	 R+6XabQ/RRf0UIPX6HhajYlGOGsG26HQrwVSby2MbGrXhMOp3v4f6kStYYG70VouC6
	 0xugyYaCkp5Ew==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 07/37] mm/damon/core: apply access reports to high level snapshot
Date: Fri, 12 Dec 2025 15:11:47 -0800
Message-ID: <20251212231148.49843-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC4WQPo5HrCJ+958t1ab2NDzbg493XYarqACARTpYskVzQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 036B210000D
X-Stat-Signature: iwgzej7z591497ynjw9ne59tzbwchw7e
X-HE-Tag: 1765581112-729196
X-HE-Meta: U2FsdGVkX1++eZNcIXjDupzr+mor/AFXRnHiiyoe3xASmM8TrnHPyU7HhDuOmw8Hbx/MDg+zZrLmzBthKrXQBS2Cc8O+qZR3Jle8FfPoigWQ40cB5o5Xr2jb9KA+sWe1GtrJnr5ekf688STnbdyLT6g7sRkrqbNW+t2via5LyQ/MQzIKzPStLl/RW3KMe7ZFwZ9RSxUTYiNeM/TNLnyEIgGQv5uWW2fvDBMh2Cqy8fYCWuneOiXn7XQ8InwZVn/tdUpOCcOZthS5NXs2eYuo5yirmW7ax/109Dxvz5/e/BZ2CEsRIgGgJ9gUMPU57J4twDLFrmujxLKAWJDHHu2uq9Ss1uOQpA2y1WWz2aYg1sbeqW6kykp32kmfkozRloKJKuNIsLRFKIqQBZpEMGtMHIddNIB1Zbt2VuGeVuhJvBUJBgMHuTFMspWLoPQPHjTrqHhMKbQYYyswOOGqx6nesLrzipwZrsrtjC8w81wncI3PjQG7R0vamiG17fUnqgfMC9mtP4XxFYrjjCnIvxb2QRpioDz68RtNKKmL5hkxuGIqx8NWUcD8kOto75O+K7Xln08w2BEHlEVLRIpfqE28m9bk21YIxGJsBn7aj/kGm8fJpmI+zPSHWKNDj2JT2YU7axqmSpIPJt93GWSbMLK19oDF3dlKRdK3/aMa2Lksc1R+bQYA83j2glFndsNLmctUowuKgcetx3O5QnT5CsSVmBtiyoq4mJYFoUJgmOzHVNTHj2dc5l2WKp9TFFx8VpeuSdnYQnbVABKc0vqegU0O2ouG6y4NilGxUTubZC0k+u1su7IuIv2adDYCQ05sSxLXqVAZi2bEzXPcVn8flFaC2XYrVDtoSCUyd87nbTr4yn72WArgRudcaTok5/lA2hTmeRryewXXC23wc+t2wh04Eo8AeqKAebHdkBGt2xM+mavMUeXP72d3cDt3YAzSj6xWqdYODU2xy39Pnyyd3cs
 hkV5iT+M
 xPfFd/fXNT6EAuYpcm0cSiBixueDlKZYBki0TXhgjoAQzmFiAhmwg6CvkZc3hGHlj5/cFejTXmPXhvGnDY1lq6tQSvK3mFesqajv2IsEmkhBFtcJGOXvfoKuAs9DMXisXR5mbVbjJFhyCJEStg6KA+1O4vmvc8B2iBTX9BLl7hrJguiyHI+uRS/lA5DfX0W5Si+Z5T50QUyHb2E1LXg3EjfT81Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Dec 2025 22:20:04 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Mon, 8 Dec 2025 at 15:35, SeongJae Park <sj@kernel.org> wrote:
> >
> > Now any DAMON API callers can report their observed access information.
> > The DAMON core layer is just ignoring those, though.  Update the core to
> > use the reported information at building the high level access pattern
> > snapshot.
> 
> It seems inefficient to repeatedly access the damon_access_reports[1000] array
> using a for loop in the kdamond_check_reported_accesses() function.
> It is inefficient to for loop through the entire
> damon_access_reports[1000] array.
> When CONFIG_HZ and jiffies are increased as follows and
> damond sample_interval is 5000us (5ms), the time flow diagram is as follows.
> 
> CONFIG_HZ 1000, jiffies == 1ms
> damond sample_interval == 5000us (5ms)
> 
> reports_len(==): [0 ... 5]
>                                                      [*]
>         0    1    2    3    4    5     6    7    8    9        997    998     999
>         [====|====|====|====|====]-----|----|----|----|  ....  |------|-------|
> jiffies++    1    2    3    4    5     0    0    0    0        0      0       0
> damond_fn(sample interval)      -5[0<]
> 
> reports_len(==): [997 ... 2]
>                                   [*]
>         0      1      2    3    4    5     6    7    8    9        997   998   999
>         [======|======]----|----|----|-----|----|----|----|  ....  [=====|=====]
> jiffies++   1001      1002 3    4    5     6    7    8    9        997   998   999
> damond_fn(sample interval)
>                             -5[997<]

Please use fixed-length fonts for something like above, from next time.  I
fixed the diagram with my best effort, as above.  But I still fail at
understanding your point.  More clarification about what the diagram means
would be nice.

> 
> It seems that only the section corresponding to the sample interval ([==|==])
> can be cycled as follows.  And, how about enjoying damon_access_reports[1000]
> as damon_access_reports[500]?  Even if it reduce the 1000ms to 500ms
> array space, it seems that it can sufficiently report and process within
> the sample interval of 5ms.

Are you assuming the the reports can be made only once per 1 millisecond?  That
is not true.  The design assumes any kernel API caller could make the report,
so more than one report can be made within one millisecond.  Am I
missingsomething?

> 
>  static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
>  {
> -       int i;
> +       int i = damon_access_reports_len;
> +       unsigned int nr = 0;
>         struct damon_access_report *report;
>         struct damon_target *t;
> 
> @@ -2904,16 +2905,18 @@ static unsigned int
> kdamond_check_reported_accesses(struct damon_ctx *ctx)
>                 return 0;
> 
>         mutex_lock(&damon_access_reports_lock);
> -       for (i = 0; i < damon_access_reports_len; i++) {
> -               report = &damon_access_reports[i];
> -               if (time_before(report->report_jiffies,
> -                                       jiffies -
> -                                       usecs_to_jiffies(
> -                                               ctx->attrs.sample_interval)))
> -                       continue;
> +       report = &damon_access_reports[i];
> +       while (time_after(report->report_jiffies,
> +               jiffies - usecs_to_jiffies(ctx->attrs.sample_interval))) {
>                 damon_for_each_target(t, ctx)
>                         kdamond_apply_access_report(report, t, ctx);
> +               if (++nr >= DAMON_ACCESS_REPORTS_CAP)
> +                       break;
> +
> +               i = (i == 0) ? (DAMON_ACCESS_REPORTS_CAP - 1) : (i - 1);
> +               report = &damon_access_reports[i];
>         }
> +
>         mutex_unlock(&damon_access_reports_lock);
>         /* For nr_accesses_bp, absence of access should also be reported. */
>         return kdamond_apply_zero_access_report(ctx);
> }

So I still don't get your points before the above code diff, but I understand
this code diff.

I agree this is more efficient.  I will consider doing something like this in
the next spin.


Thanks,
SJ

[...]

