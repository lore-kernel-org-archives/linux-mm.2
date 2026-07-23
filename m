Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 872E4C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 19:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7D76B0088; Thu, 23 Jul 2026 15:41:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF906B008A; Thu, 23 Jul 2026 15:41:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50FD66B008C; Thu, 23 Jul 2026 15:41:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0036B0088
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:41:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9261EC014A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 19:41:57 +0000 (UTC)
X-FDA: 85021061874.30.B495477
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 065B91C000B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 19:41:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fud2iX/u";
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784835715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K2dpb7jWuPRitxlaV2YlTpHdd3fdOnLFqMv+siPkyhY=;
	b=aeU02mO4t5sQQS2oYHDDLLL2Dk6xUHqBltPrkyOaNhPs8yjMgbCHiOe93yvIh25sxtk1sB
	s73F6vo3+eFivY2Cjlz5bL3/1Gm2hqnk/jO8FdR+duAvMZXwSdOTYzO0Wrchb/lekbazIF
	6umfKQSw8lloVlA3yt8UQe8SAI/qF+I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784835715;
	b=2GBa5QIXYSUaw6rnXDvaDFmaMWcV4rnIPnMY/Bpm5EqJ1CL/7hj3Pi/iy6ZlpnlFrc3edl
	SXCJNO4OR4tUJJi1yUZa0HXXZSYgtveYcA8F2ohhS0m+h/3Nq7/aGFJqY5EYp9mdgxABWs
	EtuE81j4pB73QpFjdNucDvqhvB39rOk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fud2iX/u";
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 23 Jul 2026 12:41:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784835710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K2dpb7jWuPRitxlaV2YlTpHdd3fdOnLFqMv+siPkyhY=;
	b=fud2iX/uEPMDQW21ivxz6dX4hnscjMV6U/qz9xRug/rczHrbkmHEdPhtZNHjKahxBOSmXK
	q6lsUaz58aBOe16dDPNNciOejdH+KFujrmiHgJmCvK/fMEmgWdzErisoR9SK2x1+QhagH4
	ZrV9HmFTGzsQG6XJqEolEeFO0NEFScY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, chrisl@kernel.org, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, hannes@cmpxchg.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, rientjes@google.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 1/2] mm/vmstat, mm/memcontrol: add _monotonic vmstat
 readers
Message-ID: <amJuV2zHAPYge56_@linux.dev>
References: <20260720164207.450685-1-usama.arif@linux.dev>
 <20260720164207.450685-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720164207.450685-2-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 065B91C000B
X-Stat-Signature: nt91rmd867i8k3mnq773379pjnxajgi6
X-Rspam-User: 
X-HE-Tag: 1784835713-135684
X-HE-Meta: U2FsdGVkX18JR3FcZFGXEBOBpWZD5mgoLJY4HYp5OZzdQw0AMWFdGcVmCaD70/WJZY2/yczkDvYz6HBw0nMwYcdpBR4qvfEnJwrTnHZ7lGGIEjSxFMU5s7wVWgoxxO5rq12sAqGJaQWkWLJ3TCzW5EI944uHGK0ud7+1QR0tz9oFu37Ed+LmbHwo9vu5cKBmbZGRs1b5yhxldjQOOHyUi5MZ7salektjKvv2E20l1hWXZevlgTwSVS4tupeeOBZ9XtNm8n/u7bG9lWC3OaMQAzk1CHETWKTJ9c5SMnR6rqVhoBDVDN+NzPdirF2cpra6/AOg7j0f7iBab7v2hu6OI5DoIShOtkYb+u71xhUnCEIZBGEguEcc3ocW0AhXg1U2FWmwdc7SUvAxIUsZ1Rcr7tAufDWxmbtn0CtBVx7dM+5V+f+RWUP5PO4hhmFj6txE5x4QkMVAPooctVD0tn6eVaf8HDvLvSbvjiBkUQgHCrMMjZBNZi/pL8LRQ8RYIjpDh1RfQoE2j85OCDVPcD7J+j2yeoW5rbm7r7hgMxD8FlbBtGTEE42OWUqmMY5KxyuQQBFQcrMrDkd1B/+P4L/N80vOJ3vDaQGE/RRGMiogvYsEDCk0nLVzDatFiJJU5iSnplsrG17+cV3zMaX9jTsNym8CIZCoaLb+1CGXiTfzWnXvR2ziBEVMI75u+RGHrrAuvfByoF+Y0ljcHQaHyKPvXjiOOd7yfujKNEvw4E1EugNwsdryGm6fqE0qDCsNmvfZGXPMBdgLWJwCAATsXwEW0c7+dxjenivIqSWt1arVN9cvsBajlgb0u00U4xkyCVybqPc8UOmmEWxh7nJMkKEbwWN6sI1vqxUkyzHuyLSawyZlN+wEtkpGEa9DYt0WVbbHMeSmDrpH54aixzqwS+N9ozo7AWziuSAAo+r5RjIzW4s2dC9Z7bHm20IvoAOtZ54TPHw/1F5h61EzNr37f/r
 gcaR53zw
 EnBNLH4IBTR0nR9tqmvdRPrNKejaTb8jtVTzLOMhrfe9BUR1yxu/sEygtj3UWBddBrPhIRD8qKIgsF3mt/gTgl8tZkYztatnGltjYF6lwNEMo8Bfe+oRiV7uhPff/5dU95Iy94/yW9c2zcQNRkPuOqBjG0k1NvKqa2eJfX/Z9ItfjVhpV4AzApY0nMNN0K2/J9oqDXCnih9fTuDh9Vs0SkOUQpbs1SVq063x2floip320R1LD639h/efPtaSP++BS0Ra7rlRK9kIGUYv2qfJNY7apkn5tSZNnCoCfw9nc+D/PLl/guV//o1Wzz6CXRLynX1Ah
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 09:41:22AM -0700, Usama Arif wrote:
> lruvec_page_state(), node_page_state(), and global_node_page_state()
> all clamp negative reads to zero on CONFIG_SMP so that a transient
> per-CPU delta skew presents as zero pages rather than
> as a garbage unsigned value. This is the right behaviour for
> non-monotonic page-count readers.
> 
> It is however incorrect for callers that snapshot a monotonically-
> incremented event counter and compute a delta from two samples.
> Once the underlying signed long wraps past LONG_MAX, the clamped read
> drops to zero while the previously-recorded snapshot still holds the
> pre-wrap value; the unsigned subtraction then underflows into a
> ~2^31 spurious delta for 32-bit architecture and corrupts the
> caller's accumulator.
> 
> Add non-clamping siblings that return the underlying state value
> cast to unsigned long:
> 
>   global_node_page_state_monotonic()
>   node_page_state_monotonic()
>   lruvec_page_state_monotonic()
> 
> With both samples read via the _monotonic variant, unsigned modular
> subtraction stays correct across a signed-long wraparound as long
> as the true growth between two samples fits in unsigned long
> (< 2^32 on 32-bit, < 2^64 on 64-bit); the 32-bit bound is the
> practically-reachable one that motivates this helper.
> 
> The variants are only safe for monotonically-incremented counters.
> Non-monotonic page-count readers must keep using the existing
> clamped helpers so transient negative reads still present as zero.
> 
> This is a prerequisite for the following patch which
> replaces the producer-side anon_cost/file_cost accumulators with a
> read-side accumulator in prepare_scan_control() that samples
> monotonic per-LRU vmstat counters (PGROTATE_*, PGRECLAIM_PAGEOUT_*,
> WORKINGSET_RESTORE_*) via lruvec_page_state_monotonic() and folds
> the unsigned modular delta into a per-lruvec cost_accum[].
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

