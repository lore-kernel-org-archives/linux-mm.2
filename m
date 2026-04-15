Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA3DFA0C36
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E16C6B0092; Wed, 15 Apr 2026 02:30:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592076B0093; Wed, 15 Apr 2026 02:30:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7E46B0095; Wed, 15 Apr 2026 02:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3AA126B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:30:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D00CCB8A64
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:30:57 +0000 (UTC)
X-FDA: 84659817354.26.08A9975
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf24.hostedemail.com (Postfix) with ESMTP id E455E180007
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:30:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=VE7mAYeP;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=sGHXEiBr;
	spf=pass (imf24.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776234656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VdAKD36E8rLdN/EhiUpV79Bm4JP9i6LgdGtBCZLwAhI=;
	b=dGvoSh4UoZLgSJAuoiWE1ML92JVcxtMR03toiGBOzFAp7yxOTygDyrLDFB5J3YI6HDczJf
	PMcZJytkjWzue7/uQ5/ZNVEH4aidNKkT6wC3T+d+UD40VCDmtObjRTSldXCbJ6MuMCTGzs
	xB+k4uavtznchHqyf49qoD35O669nmo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=VE7mAYeP;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=sGHXEiBr;
	spf=pass (imf24.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776234656; a=rsa-sha256;
	cv=none;
	b=NXtEMvzrvyA9vw9SquAdSjoPeVrZ1Uok1lgZC9lNR2qsUiRx8VEBZSXwnS6hhFAr4XYYZ6
	n5SBYz8Bm2ZrdioapbuFnYQ7Ut1ydoRjKJaQW22MK7O7FG93eZ9/nsdDCcL6VbpovWSf6Y
	+qI+g0DIJkgRIQc/mIr9INs2lX2HfNw=
Date: Wed, 15 Apr 2026 08:30:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1776234653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VdAKD36E8rLdN/EhiUpV79Bm4JP9i6LgdGtBCZLwAhI=;
	b=VE7mAYePSJuw8rYF2IEg8Uj5hjEni6px0w3pSuYBi6Zr4//Fs4BFaYhs6s3LLD0zT16FQZ
	+p/SbZIr3b4N3YaRnHlraP39iqn35JLtKphSUWJ6UUmZc/1vJbISKv73yu8bqwBbYRQqt2
	xzA8CzYm5G8MzbwIcTYdCFzt4oPe86BCZDLDCmEGueK109llRwV8U2KYJg24CG4SssKbrG
	ofkl2ebupTRXI7ey9j1UjryAlI1hKsNHDB93aSopTB1+h6fSATl1MDrQcP3YuvPV1mD+5U
	Ux5DD2DWvt4/bFtCDZjEIRNX61X/bfoy68PYrxABvZqiw4fFtZQKJiV/Q3Yoiw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1776234653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VdAKD36E8rLdN/EhiUpV79Bm4JP9i6LgdGtBCZLwAhI=;
	b=sGHXEiBrPEae0nW+Z4/Iz9is3KfRzvNPPszk5NeI4llau3YrME7LKceUTvCHIrpg1GtRK2
	3dTRgU45mNFgUBCA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, Dave Chinner <dgc@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Sandeep Dhavale <dhavale@google.com>,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
Message-ID: <20260415063051.H3zA99Qh@linutronix.de>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-9-hch@lst.de>
 <adl1iqhldFvJwSw-@dread>
 <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
 <ad2RKNo2FGhpzJQp@dread>
 <a7a74185-df02-4906-a0ec-f87e2394aa5f@linux.alibaba.com>
 <20260415055552.GD26893@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260415055552.GD26893@lst.de>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E455E180007
X-Stat-Signature: wbfwt78c54cy9pqkjrfb7a1bugtrepp1
X-Rspam-User: 
X-HE-Tag: 1776234655-211526
X-HE-Meta: U2FsdGVkX183BZfxjdBZ9db1mQXFtY2pq8raACC58LIBXSQIGM8dY9QHZvIELe/+qUIQ8riQ26MtvVdV3OEX4TZFrxE+v4F1F0cTI7L62pW85OfEpBKr5A3o18EAextdmlCHv4ure57gpYXj4f7aiRz4T3iT3+it/BTRUqwPqeIdBuNR/DgWfBU2UugEOdu+Cpkh8nW7PvNyRsxRDqYWpkX9FYZcjWJEnREPHmD9YlJC7HkYkMR2Aeawannwk+k/r314PON9ohTBJ+LTvvG/HJKfX5gfOQwTeiHSCpZLJ9hQSD8eOJCnJMMuPAiGAsDEbOB/UJDq0xjS4h+E10ARoYnjy+u2OgF6VCueRVIrIvULsZlIjkNqG8CB9fWuk32KA6dWU3Q1esrNyUhuJB3mG+yHT+BHwuxqWRQZfW6+2qsgqFqeeYJkc7zR0plPbElIMG1RVtz+viRw8TroqSRT3TSj22yHOMKRDdYxOLyso024xasrUuLg1Fx1tg/M9dKInko/qw4O1U09XhtatpUZ7XO5tTN85GQOGb8mXNygKT+k8I6R0+l5GBIg3gcmZY7MWkmr6mkNGQQcBuunReWkcLbGQE0DPqbof9KcR9mULce+xwYutU5eO8UKxLZv4qhZLt029aAC3Dw3d9MtQ+waX5OSOyiymuoAZ3czEk6Q/H3RGdrPVyhbmgBI+8GvnVEjAAPLm+5suq+/iOTX1M3jqnqXUFi4ZfDHoTh6nkfA4EBEawfpcexzR5suWV24u+U+tdJMBqSmr9DOzbrGw4yDbgMhDrI0VVR7zMf3v4tFa51zYuGqmUfCBsz50bOU7xKZVWpnur4ty2litkikp4vsDfYEfnqO4ox28QR0VvU87oBIqaF/IAlvCsiF5PN8A3axFLGYBUjdlHlveHIoSvW4tfQz5UmgB7Moj3nVbscLen0ryNY5RZRM6WG/DdIWUyTp/3+1P7gbDsAMFckjHta
 fOPipICG
 FKwGxZh5W00OWerYVO8yljHYzvmR2TX3diUQYUjg55xip8WjqpGDKonSRFchxKnr11nC+8lOcT7PrBfNa1z8ByndimZbgll95pkVjy+6DNedY6vSMt9++DK7/vGFOaoyEnxFs3fPhOGpXxSrqsj1H/1SwgkqRArSBlHSiwlIjjPjpJMlrIHQOqNwjYx2YjDM+yO8O/VqElKchKFo6/4L+UaPkXuXLBr9vYECEIJunhM4vPqvn2fTiXS73Dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-15 07:55:52 [+0200], Christoph Hellwig wrote:
> On Tue, Apr 14, 2026 at 10:23:13AM +0800, Gao Xiang wrote:
> > All softirq IO completion already works like this although
> > softirq tasks are not strictly called "RT tasks" (i.e. a non-RT
> > task issues the IO, and the softirq IO completion will interrupt
> > all ongoing tasks).
> >
> > Basically what we want is to get a non-atomic context instead of
> > using the current softirq context for read post-processing and
> > switch to the task context immediately as you said, because:
> >
> >  - Our post-processing needs to work in task contexts since
> >    advanced features like compression deduplication need it;
> >
> >  - Even regardless of our specific requirement needing task
> >    contexts, using a dedicated task context for read
> >    post-processing is much better than run in the original
> >    softirq context:
> >
> >    - Algorithmic work could take extra time (especially slow
> >      LZMA algorithm could take milliseconds on low devices
> >      (however, we need a common workflow for all algorithms,
> >      including fast algorithms like lz4) and verify work for
> >      example); and long processing time will interfere with
> >      other remaining softirq tasks like sound-playback
> >      / network softirqs;
> >
> >    - If it is then deferred to softirqd, it just makes this
> >      latency issue _worse_.
> 
> Yes, and the same applies to a lot of other things.  A very similar
> algorithmic issue is the checksum validation, be that T10-PI or
> file system native checksums.  We don't want to run them from
> soft/hardirq context obviously, but we really need them to preempt
> other work on the cpu, and avoid scheduling latency.  The case
> that started this is a bit different - folio invalidation mostly
> needs user context to take sleeping locks, but those are usually
> uncontented.  Again, getting this work done ASAP as readers
> are synchronously waiting is important.

Not sure why I ended up here but looking at the patch I don't see how is
different to the kworker solution that is removed. Unless you fiddle
with the thread priority in userland.
The get_cpu() + spin_lock usage breaks on PREEMPT_RT.
The NOHZ_FULL camp might not be happy about putting load on isolated
CPUs. I remember there was some effort to avoid those CPUs.

Sebastian

