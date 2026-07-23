Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7417C531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 15:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95C6A6B0095; Thu, 23 Jul 2026 11:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9335F6B0096; Thu, 23 Jul 2026 11:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849E96B009B; Thu, 23 Jul 2026 11:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 55ACA6B0095
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:57:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D92B6120495
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:57:01 +0000 (UTC)
X-FDA: 85020495042.17.7A44D97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1CDB51C000C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:56:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j/RqNP4F";
	spf=pass (imf18.hostedemail.com: domain of "SRS0=k6gO=FR=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=k6gO=FR=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784822220;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnLlhWiRynP6/ofod3foQ+AAh+0y6A4DSv+/njyBLhk=;
	b=H6L/Px/0+wR533Jw9UbZftoUP0RouETfs/PKC+ZThaM4D9qPyNqLXEc9A7SrrkzTczNUKR
	99X/ic+G7vu4fVNYxvkHBIQfZYjUlYID2rGec+fNBPbarmM0nez0WzBR++2osf6QiMsd95
	/gkvqyGLB6tYHpNaU8zbIkZfBGf4mfI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j/RqNP4F";
	spf=pass (imf18.hostedemail.com: domain of "SRS0=k6gO=FR=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=k6gO=FR=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784822220;
	b=I8t0iEVEy14RctbZDSIWU/xreiUC2lOem4Eq/8b5GMyigGBY/JyExIxBj//oJnvS7yN2f0
	iE2kt161CwqrVZmIrFS2iD5RC82hlEgc+mck4QfaJz1qVMkvvCKN1+n08fTxY6SPXLpnvG
	9DSqGhp3gFs8giabYSjbSVwUBFf0Mmc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10808408A4;
	Thu, 23 Jul 2026 15:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E771C1F000E9;
	Thu, 23 Jul 2026 15:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784822218;
	bh=hnLlhWiRynP6/ofod3foQ+AAh+0y6A4DSv+/njyBLhk=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=j/RqNP4FNb4Os1gXyhKtdKfwqPKeDbNELuRzvh9cpAYIRLQx8uOQLbNhmD9pZKMcy
	 vJHxgcX9VvyQ0Ix2KMvnDd7a0rJWynXgNAjgvdgzDtV9QzpXumbmDBCghjOj4JnEp5
	 AceACFVIAsARZeXulWzpbGJ0DQz/aSNHU/JaehDbcRnsGUZbUQ4JWrf1vsqIkn+uKj
	 NQ+EFQmFq7SPD/5Mrkc9RgV9meMuzI+QPAAwTH1zy8W9NJtQ5HWVWDE80LS96AcWau
	 aZW2TIyCB0+rWBoLJ4Y3CzHIT9z4VY78ZajWpZU4ChbKz4jTg/ZenZLlQq6tSUx1My
	 GWWGHnqdz8ghQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 9B657CE0AD8; Thu, 23 Jul 2026 08:56:58 -0700 (PDT)
Date: Thu, 23 Jul 2026 08:56:58 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>, puranjay@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during
 the scan
Message-ID: <ffa5d8d2-1157-4a30-995c-ddae3566e3a4@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
 <20260720153917.2e428e489cd0873ac6d4e6da@linux-foundation.org>
 <5b83b0a0-708a-458a-bdbd-41c6d4610349@paulmck-laptop>
 <amCT9QEgJRsLIb_y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amCT9QEgJRsLIb_y@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1CDB51C000C
X-Stat-Signature: 658echcgj4ncjy7fjeagut6e8xq5icse
X-HE-Tag: 1784822219-30065
X-HE-Meta: U2FsdGVkX18evHYY87H1vYWKQFBmK3iqd/6kzNAir4ZW2HaZPbU9LDq1Mtz57AXRj8Jj4vNzVwSav3dku2K6JO32j7JO1pcdFBp7y09BzggHOM997d45UhR7y4EJdZ0+VDITh9s8S+xD5M4CdRM+gzZcPfgDkxGwEpPCCD5fYNsVYqeFeCD+eUQbGzyw8i6CrbVFvVMwDn5Xb5lwStEs4vKqXHwNgcJXu7v9pY/5tfuF1JWeYizBPtONwehzLgfjOrLj/7X29oSfpQm96BqHsCyVkdL2t2F9bDqTgHEdoZAZeSJjfC9aNXGgjNc0LukGq+hNbR2m+G3FN+FMWN5hrGIpeorSmaJ5tns68JzeTLGD6TDSTe2AjgRT1lq3awnhJRpwYy6lS0fsd8ecwVRujSEu/1WROSqB/Y24t5PYrjJi6fzJ0kpkpgzMPcKr2remWSvTus2yG3ibeGaqlUE2NPNufykIevvj4qNZ4bH9OUABF2VTttwLMEfEzRW6xw2maELHnjn6VE9yfwoyyDS1oA6yGKxLL6ifCGbyBH0kRDDJysgMKjUBCEcFsQhzWQTfwuC1gMHr8+GDPuEoT0Jw6BzqrxYygWdrL4GQqt2vMXZtTMsAqC5JA7B4gTZKfj8RqTgWF14lDCmP2U7a7eV1Aqk7XmpsyzrZtVBawNDZSlNjcXvSznaq2TMbztgKKHDcm969Tobog80mAbAE1b6owVBm6mqcwE+gTuGoPorIbkqTnFrJ9diEaXnsFgKo0FE4DibRlJES+aWM109vIbDm5H7+Q7AtKttpv47Ed/58ELFSQV+UlRLttsMMnhmWteBk+aXtmKP04K8VmmePXwnw9A4buf1WTgMPMr9T5tn5N0VnOEMtoNsNX9ZcrQVsyp8xvDWNK7LRIZicbXXep5iVfPko2tDct7ArKGXs/R4O+VSa22Ft6sJihWTsSQk+CYqCrvdt5seotEIuKM8lGc+
 m8WWkM2a
 PmFRPYv1W5NvJJlS6UEBfQP/J5KHOMwy/QqHuleF37UA9W1Fabe82ofFCV7BkGorJX0EOH7lVnM7qPPLLvwRScqqJ+A15trbOKBDJXM4xqHDgmpTB2+eQPqVOkfFdYBXphGUDXpiYs+hdZWADLggu50bc1NGFwS+QWneVNFf6XbAL9pPwCuGxSEI+l6xID2NqmGf97gM6dp+nQOeHbu0VWba2elfgM9spRfy/YS2jYw2hDxfN0ZnnOPMUQ4HaXG81P56a24TrNyasFEt5KhJ7denYVwgViTkeKOJMZJECk7OINLDddeQjRKXwpsw0g5CMRo9Tble5o60xB2RmNDxTNguHIMjVz46svoMqGv8LbuIxWC3A98rvfuO9tawfX+c1ozyeBmnRLGWZ+izFfEb5tgPnmpV4qUTY45OLsn2XTEJQ+J9Jbv2mgGLhp9SozdhO2iNnVEmPaA9g/Kea9p++E5qxlSQIg3RRTOs+kP6cqC2+fFnHLMi5Slw8ugdSluRiGelfSOrRsp34+wFotL3487ENpKAJBwbZa5UyEpDLFOHc474anrQwc5d53dQHo6TXztsV+a3F374L8/xZW3dTbUBhv0mzk9FIFVGaBA3S95VnjZdxdbzeF4Dnpkh0IOCP7cxbtgHOa2sJ5c/lVigQTOuk+f7k7WkWWkeXxu2jX4gPNz7jL/ksxYAuWDCcQNKoDwdTsZf1zE/K1OFA9Bx0dvBUeELhAqVK/uww427Tg4fPAhvOEplJqeld8KEb23f+44xH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 06:26:11AM -0700, Breno Leitao wrote:
> Hello Paul,
> 
> On Mon, Jul 20, 2026 at 09:21:17PM -0700, Paul E. McKenney wrote:
> > On Mon, Jul 20, 2026 at 03:39:17PM -0700, Andrew Morton wrote:
> > > On Mon, 20 Jul 2026 06:23:45 -0700 Breno Leitao <leitao@debian.org> wrote:
> > > 
> > > > kmemleak_scan() can run for ages on large debug kernels. It was
> > > > causing some soft-lockups which I got fixed with commit
> > > > 3175fcfec8b16baeb ("mm/kmemleak: avoid soft lockup when scanning task
> > > > stacks") with our beloved cond_resched().
> > > > 
> > > > I've got the fix above deployed in the Meta fleet, and now I am seeing:
> > > > 
> > > >   INFO: rcu_tasks detected stalls on tasks:
> > > >     task:kmemleak state:R ... nvcsw: 274/274 holdout: 1 idle_cpu: -1/3
> > > >      scan_block
> > > >      scan_gray_list
> > > >      kmemleak_scan
> > > > 
> > > > and, worse, blocks the callers waiting on that grace period. Here a BPF
> > > > struct_ops map free, which waits via synchronize_rcu_mult(call_rcu,
> > > > call_rcu_tasks), is stuck long enough to also trip the hung task check:
> > > > 
> > > >   INFO: task kworker/...:bpf_map_free_deferred blocked for 122 seconds
> > > >      __wait_rcu_gp
> > > >      bpf_struct_ops_map_free
> > > > 
> > > > Then I've learned that cond_resched() is not an RCU-tasks quiescent
> > > > state, so, we need to use stronger primitives.
> > > > 
> > > > Use cond_resched_tasks_rcu_qs() at the scan reschedule points so the scan
> > > > reports an RCU-tasks quiescent state as it proceeds.
> > > > 
> > > > Inspired by commit b96285e10aad ("tracing: Have osnoise_main() add a
> > > > quiescent state for task rcu").
> > > 
> > > I'll add
> > > 
> > > Fixes: c4b28963fd79 ("mm/kmemleak: rely on rcu for task stack scanning")
> > > Cc: <stable@vger.kernel.org>
> > 
> > Thanks to all three of you!
> > 
> > This adds fewer than ten calls to cond_resched_tasks_rcu_qs(), but still
> > more than doubles the number of such calls outside of the RCU subsystem.
> > 
> > Which is most likely just fine, and in any case absolutely should not
> > get in the way of Breno's patch, which after all solves a real problem
> > in the here and now.
> > 
> > Nevertheless, on the off-chance that over the next few months or years
> > we start playing cond_resched_tasks_rcu_qs() whack-a-mole, I figured it
> > would be good to get a head start on writing up alternatives.  An initial
> > draft may be found here:
> > 
> > https://docs.google.com/document/d/1s3fn29SCTYVw9jak4iraNIVQR59Wk5C6_I-_eu-MfQA/edit?usp=sharing
> > 
> > TL;DR:  Should we get into a rousing game of whack-a-mole, alternatives
> > include continuing as we are, making the existing calls to cond_resched()
> > in turn call cond_resched_tasks_rcu_qs(), decoupling mutex-induced
> > hung-task warnings from synchronize_rcu_tasks(), and various
> > not-so-practical alternatives to RCU Tasks for trampoline synchronization.
> > 
> > Thoughts?  Especially thoughts on other schemes?
> 
> While debugging this issue, I was surprised to discover that cond_resched()
> doesn't provide RCU-tasks quiescent states. That led me to
> cond_resched_tasks_rcu_qs(), which is the stronger primitive needed for
> long-running kernel threads like kmemleak_scan(). Is this the common
> case for cond_resched()? I got the impression that kmemleak is the
> extreme side, but, I have no data on this.

And that discovery did in fact lead you correctly, and hence my
giving you a Reviewed-by.

> Worth noting that commit 7dadeaa6e851e7 ("sched: Further restrict the
> preemption modes") continues to narrow PREEMPT_NONE, so the future of
> cond_resched() itself may be uncertain, no?

Especially given that one of the explicitly stated goals of lazy
preemption was in fact to eliminate cond_resched().  ;-)

Getting back to your point about kmemleak possibly being extreme, as far
as I know, none of us have data on how many conversions of cond_resched()
to cond_resched_tasks_rcu_qs() will be required, or, for that matter,
how many additions of cond_resched_tasks_rcu_qs() above and beyond
current cond_resched() instances will be required.

There were concerns raised off-list, so I figured that it was time
to lay out what we do know, hence the above gdoc.  I very much hope
that we don't need many more calls to cond_resched_tasks_rcu_qs(), and
thus that the time I spent writing that turns out to be wasted time.
But better safe than sorry!

							Thanx, Paul

