Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14BD4CDB46B
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 04:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC26E6B0005; Sat, 20 Jun 2026 00:19:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D71706B008A; Sat, 20 Jun 2026 00:19:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62556B008C; Sat, 20 Jun 2026 00:19:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D8896B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 00:19:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1720A90571
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 04:19:42 +0000 (UTC)
X-FDA: 84898987404.12.1B82DA5
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id E1A0D100007
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 04:19:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rs3TyiHU;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781929180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCMktU8ssVVWOY8171eAKFdomK30x6Xys+dZdEKy3kk=;
	b=ZXO4b9L8xhdzKgdTt2CnEkijSTwjOxEvua4ifgPMEA4W5dPZufAZiH29CSkw4T9MSHUIKA
	7OQclLFDtu+6/688O+seCD6TmnfFhT+reSQbPGgrOhMynt00YPPBssWHfK6LFmaBaZ15wN
	+a0/0fgwGDZnCh4o2tvCJ2WVOIxcYXs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rs3TyiHU;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781929180;
	b=J8+zXS0eN/BNdwhzr54JNE74zsiovQWT9wwRhy42W8VVMu66XZAaRWvrp4xevS1eX+0EaI
	5+TlUqwpRgvcnpXe7j+aX+eVzGBnVSXpJ83nG9bYpgMP39kMJ2bEddk6tvDz2aB9/mD9w0
	uSVEOV9Hx4krNQxsGzrldKn7HlzqWQ0=
Date: Fri, 19 Jun 2026 21:19:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781929177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RCMktU8ssVVWOY8171eAKFdomK30x6Xys+dZdEKy3kk=;
	b=rs3TyiHUwzmV+mSY3Juav6ERZqjnkQ7s0twtXpeo6AkiJxJd5Cen4QyBUq+Q2T297v26H4
	wjM5JVyUUiTUr5p1cM97gbQe4rHPsa1mKNls0hZMYs3totBHk06jGHc7Jy0TPwbZXX6fva
	rwRuHK9XIaWdreDOS2WQD2czLzr8RpY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	linux-mm@kvack.org, bsegall@google.com, dietmar.eggemann@arm.com, hannes@cmpxchg.org, 
	juri.lelli@redhat.com, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, 
	mgorman@suse.de, mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org, 
	surenb@google.com, vincent.guittot@linaro.org, vschneid@redhat.com, 
	riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH 1/1] sched/psi: skip irqtime accounting when no new irq
 time has elapsed
Message-ID: <ajYUs0NwohosCjK5@linux.dev>
References: <20260617175219.2494857-1-usama.arif@linux.dev>
 <20260617175219.2494857-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617175219.2494857-2-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E1A0D100007
X-Stat-Signature: 9ofmin5kqco77tye3h3wu136d1kh4tcg
X-HE-Tag: 1781929179-899899
X-HE-Meta: U2FsdGVkX19so//89iiHK99FRQHFILSqeMm80EJe013Iad+risNScZUZcws9lKgWJkcdCwptSEmVGTTXZig5Uks28yEgf9tjA4WHGNeIlXr6OP2UHuiRPQHI4ieRG0pQAQr2nfKTsUtN3OWEW3wQr198Gy8qJpw9ASaBr1UHP70+7NqLRhp13wxIEmRmtnuD0zd71AQDgCgIJ26GisPsyF80p383eILLSYQJM/mONWcpBUjiz4d3UU6GfZG3698V/tobJI0QLwUYazDiOTbCiz3dbG5obQoRG8s0X6A85WkBWkxEKB9dZWYa6oTgWFFzxGywdacPORV/NMXdYkIjFsClK82billz0eRCECLTEsR3h87hqHfaWIikqkr2Qr92Arcwv42TBszaEQAv5YhW7IeiQWrt7q4cYvzflTIjkhCxYXl/ZFPmNygNfMd2bO3at3R6hnDcUzdZRLt55yDhk7Y4ZcgCFGKT8chuHautmP2ZLNonMcMhRs5RVuEbsjw4RJLoLDZDkB29SZWyUDw7aG40mYKTW+XjXh/x3IstJua7myTU30eVEeE8q1IK+6n/DQa1XBhkgGeyUzbunZX7vv4W3XirmBBGezYbxRX19gtGkry/zKBQjeYRbcg64vIkRUBtSJrE+AgSCCuslxNXfSL3jlZcgWDL87+H+JmNdYkgU0jGPT5L2SATCAPqxfVt4ic800QJR5Bt76cbBYe5yG5Ch6dkD8fD4bRGklfKeBtFJzibPZyi8VbmTAFXyRqmMqbqnAOXCb+blQmGmaf5C43DsCsuy5RzwZMIEQB4ZVCw2n4NZU5c3RDebvBpN1Vd1mK+paJDrKCRtxsIRx9J3vqXSgcKsQLPAAXwfe+ncZL01q2QznW/NjVgtLQc4lyNKJivmIitSyguFvz9npnPiyiVrBaNEDqvs2+LaHWAgni2tNAH3y4112gVXflRjIILKDW8XIbZXpxnRRPNneV
 4stf4hGa
 Czln0erjeWld/nqDea03DMMK9hKcv4k4OHRWLXUrVkt5psGScWP4ru+zKno3g53XEDxZYK/GkevztuDJ7Gx/3qVzgBOTshM+maW78mrBAy3UOHJjdTVXExvRNdIFqe0TbwcAF1bhCrUCkRRit/SGDo2+UhNYVWotmXz0Dl6vz64Ny+dQnbrbq6bW/byDVHDpH6AwNVOmPsE1LjikGu0omg+DN9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 10:50:06AM -0700, Usama Arif wrote:
> psi_account_irqtime() reads irq_time_read() into a per-rq cumulative
> counter and only bails out when the delta vs. the previously accounted
> amount is negative.  A delta of exactly zero is treated as "do the
> work": psi_write_begin() is taken, cpu_clock(cpu) is read (which on
> x86 ends up in native_sched_clock() / rdtsc) and the cgroup ancestor
> chain is walked to add zero to every group's PSI_IRQ_FULL bucket.
> 
> The zero-delta case is common in practice -- it fires every time a
> context switch crosses a PSI group boundary on a CPU that hasn't
> serviced an interrupt between the two switches.
> 
> Measured on a 176-thread AMD EPYC 9D64 server running a compute
> intensive production workload, instrumented with bpftrace over a 30s
> window (irq_time_read() read directly from the per-CPU cpu_irqtime so
> that delta == 0 and delta < 0 could be separated):
> 
>   @total              17,229,311    (100.0%)
>   @ret_curr_swapper    7,864,195    ( 45.6%)  curr->pid == 0
>   @ret_samegrp           323,299    (  1.9%)  same cgroup as prev
>   @reached_delta       9,041,817    ( 52.5%)
>     @delta_positive    6,358,192    ( 36.9%)  real work
>     @delta_zero        2,683,625    ( 15.6%)  work wasted (this patch)
>     @delta_negative          (0)    (  0.0%)  monotonic clock
> 
> So 15.6 % of all psi_account_irqtime() calls - and 29.7 % of the
> calls that get past the early returns - hit the delta == 0 case;
> delta < 0 did not occur once in the 30 s window.  Under the current
> code each of those ~89 k calls per second performs the full seqcount
> write + cpu_clock() read + cgroup-chain walk just to add 0 to every
> group's PSI_IRQ_FULL counter.
> 
> Extend the early-return to also cover delta == 0.  rq->psi_irq_time
> does not need updating in that case (it would store the same value
> back) and no PSI bucket would change.  The existing behaviour for
> delta > 0 is untouched.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

