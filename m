Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82950C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 17:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1388B6B007B; Fri, 24 Jul 2026 13:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9726B0088; Fri, 24 Jul 2026 13:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 001776B008A; Fri, 24 Jul 2026 13:29:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B49276B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:29:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 282C012021A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 17:29:29 +0000 (UTC)
X-FDA: 85024356858.08.8C44221
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 61DBE1C0009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 17:29:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QzbxZzeE;
	spf=pass (imf18.hostedemail.com: domain of "SRS0=cZYt=FS=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=cZYt=FS=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784914167;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzIG0ffdjdaknmN28KqXEB7nB5TnL1C89uh1+8cw5PY=;
	b=puZr35G+M0RZE54qFvIEySRqY4vNQafXheg6WKU95K1NvgTbUKFbLdArevvTtTh1SzrEX9
	ZXD+nsbEsk41nX/x4wR5n0+kM5dKgFEOu6cus/ihtV8/+ssugCRUF1TEkCTGaGqzmIYTpK
	euj5zcvbpElKJYlJm3mKA7Cz4+ocXU4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QzbxZzeE;
	spf=pass (imf18.hostedemail.com: domain of "SRS0=cZYt=FS=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=cZYt=FS=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784914167;
	b=19jcyEjK4iqr4e2W25xeD9LdUWh8xL7YiIJTAcjg0AOT/H8nuJa9DAlQ65rBRIUjWJLPBk
	y7xqpy8wIZxYZlR88FZelX98gUSAteDhpZS+CcmrBcwEGkO7srFgJpWs9AkVqscm4FOpoh
	wnkiqfiiGYoKO+ySN0Y5ggIxQHZPvLY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8ECED406DE;
	Fri, 24 Jul 2026 17:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B7A1F000E9;
	Fri, 24 Jul 2026 17:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784914166;
	bh=rzIG0ffdjdaknmN28KqXEB7nB5TnL1C89uh1+8cw5PY=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=QzbxZzeE8vpgOXP2ZHM161S+PygFvp3hBMEljNtXd3B1MacnT6d15F13lz8yW5qE2
	 pig/YSBxoTHdOL5j+mpuJydhtwuLy/EY7o7nqCNnugYQENXyXzrzKUK7mq8zMQOiYN
	 TOIbLeUnBnHrjjk2hOvvXF4ZbzGGjHpFYYbPseEuUHNJCxS5FwJRL23aIUKYrmRQ11
	 PD0Ciggb4DJmxy4yRyDq46Vik4qSiyNQW97cfxCT9ugOyJzSeDM7xaaJisu2ynkP4r
	 CPkBFhZJhSAc2IKM4F2qiwr0csrMGrDID/TjEY4MH7k5HYj9cM3oXrRvOlIL1+zbRl
	 PMOhVqpO49X3A==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 37477CE08DF; Fri, 24 Jul 2026 10:29:26 -0700 (PDT)
Date: Fri, 24 Jul 2026 10:29:26 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>, puranjay@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during
 the scan
Message-ID: <39c90e82-f785-4b47-9571-dd4b1339d685@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
 <20260720153917.2e428e489cd0873ac6d4e6da@linux-foundation.org>
 <5b83b0a0-708a-458a-bdbd-41c6d4610349@paulmck-laptop>
 <amCT9QEgJRsLIb_y@gmail.com>
 <ffa5d8d2-1157-4a30-995c-ddae3566e3a4@paulmck-laptop>
 <amM1xUOhcpGpqIpe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amM1xUOhcpGpqIpe@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 61DBE1C0009
X-Stat-Signature: knfdd43q1j3hq84a1iru3da83rc13q3c
X-HE-Tag: 1784914167-720455
X-HE-Meta: U2FsdGVkX196JMjAeju2jQl53w1/Ekr3nlzrpsMzePJoCCrnOC6y0524sl52WfDXNfRLCQkJ1278ehSAQYYs6H7iuGxar4xBBLAwLpthUYlkfaDlgel6/plhYh5mLxyYNQb9RjLMKWLf5zXRoJ+lCnBtglTr2D4MdGOpltXGQc9R/hkjThzBpOoK4LaA8RZNMimzOsDU9TnJz0/TAGyKcAHdIPq4/NLsly8diWb0dMsS+kV1OGyO8S2jpbY89CSDk2xmc/mgGhLdnMlwlVMg0but40p3fHmcoogMUwb3HvQ5jN2cKr0CmjAKF8FMB4tP/uPiPI6Fd7nliIv83rADzVt4M1p0cL+i3RNxgRrPxmDW2kfqpAT53QUhy/wzlq21oI0aY3JdxIs48WvS6nrOklQIrmrOU+WxhK0GcM6+6uJi+C97Zw2vHgsHX+4ApXTuCzoffeHASdqc4W15npSdBmTMD0NU2oO7lx7DMFr1aR3Fqdah2DDZTrMl3VRsPeOYe4tDlqcV8UlrsG8NbZYaooRCbtQ1TcbaUg21HDQ2mVUvKTJ66pJjBoZgJ4w9UZGcRb5tbQTfeF38fK9gdRfzA99qKJF8zJvLwWiR1NA4RN+L2Ei6Rc4+HJv+nVxJBPdBmF/2hGTdDgZ8oyw/ST7Yhtk+clxHVMF1nB+/ZF6nYdylYR9pAt3rGY7c7ApV03n8t/IHhxN8Y9rFLs2Bebi7vjYWCJoPwg/eRDUEDWuODm+oKvgO1arr/gnpfnUJbcBXpRMSrqVEv1wqcP5BsIMkBc8P/xbMtKZlo4gMYXHiFuvpa7O5r3/O98Z8FJ+g1FHSP52NQ+xwPw4arCM8d6/9upzsolXW+MXBSzrAIgwZg3t84ot3fViF9ERdhG+lcaXm3UrawEHmmZlhjyVea17aUuhA1AcQVMgBFRTEAunYGoK984rxjpM75A0P2xEEhq8oS4Bv34jXmjdMMbTvhOb
 KCQxI6D0
 i7xYjcD6BzZfW+f2QU1GD6cwNBrxK7emHSRH2NkrX0hJekRcdUF5Uih3qmV7Vuf/R33zZLYnmYHKAt/bevqIVdc3nYgCRi8xepyTf/VNFsaxgzBhUQHKPwBrE3Dhq9bxW53uyep4kWhotnsCCuTkE1FGlHXbwCGtgzYzJ23HCd2XbzLFMe0TbUIC8gNU5sOd5GjjCAQDA3QukyObRzDaQYjNlr3sb0WN4LvOhaZH0IGQpyjOJahQ5hO/ogUgnLtc2FxKrv/5PLG153woTg5jLE31k8bgo+uoYMch0vfS1b9yLSoW0lFzXT0TWLb4ml1qXaITOOgFPvNKO+CyhYcbhMpkDwTwByQKTUed9TSBcgAD1eB9CkDucZ+ex6wIoD0SB2rsd98+qdPcIAdctijtURWVuBIbHyAFgfsMFQXWLmNbvpcxdpOUR2L3Kxtx1x1sBgSg6T5L7gE6Y8ysbZSBMJUUAAz+ZnBOxgY4fjhQG+cPC7580d5Oe+XBXstak76D19m6YHSIidj54/C64sJ8+qmXfWaJsIhLJhBdzr1sBhUhYtQiSH8DSlPXCDN5zxOsy+Oi3HKBN52X1MiiZUitxt1DOfHFtzy2eN9bn2iaA1eAdpBNuHSBIl6hx9lftTFoVPl0GHfMNYtW99Jb+sD1X8GR2nLEDVN6xLF5skzYmpx5lPLAP3+SiRclqEHJ6YtBc1ILKDWZ48/jA4D+r4yBbVVyPnLZ1MPFCG8QQaYP8cCbIZbIfwyUO0rU4zJgRIpd3zWQx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 02:58:24AM -0700, Breno Leitao wrote:
> On Thu, Jul 23, 2026 at 08:56:58AM -0700, Paul E. McKenney wrote:
> > On Thu, Jul 23, 2026 at 06:26:11AM -0700, Breno Leitao wrote:
> > > Hello Paul,
> > > 
> > > On Mon, Jul 20, 2026 at 09:21:17PM -0700, Paul E. McKenney wrote:
> > > > On Mon, Jul 20, 2026 at 03:39:17PM -0700, Andrew Morton wrote:
> > > > > On Mon, 20 Jul 2026 06:23:45 -0700 Breno Leitao <leitao@debian.org> wrote:
> > > > > 
> > > > > > kmemleak_scan() can run for ages on large debug kernels. It was
> > > > > > causing some soft-lockups which I got fixed with commit
> > > > > > 3175fcfec8b16baeb ("mm/kmemleak: avoid soft lockup when scanning task
> > > > > > stacks") with our beloved cond_resched().
> > > > > > 
> > > > > > I've got the fix above deployed in the Meta fleet, and now I am seeing:
> > > > > > 
> > > > > >   INFO: rcu_tasks detected stalls on tasks:
> > > > > >     task:kmemleak state:R ... nvcsw: 274/274 holdout: 1 idle_cpu: -1/3
> > > > > >      scan_block
> > > > > >      scan_gray_list
> > > > > >      kmemleak_scan
> > > > > > 
> > > > > > and, worse, blocks the callers waiting on that grace period. Here a BPF
> > > > > > struct_ops map free, which waits via synchronize_rcu_mult(call_rcu,
> > > > > > call_rcu_tasks), is stuck long enough to also trip the hung task check:
> > > > > > 
> > > > > >   INFO: task kworker/...:bpf_map_free_deferred blocked for 122 seconds
> > > > > >      __wait_rcu_gp
> > > > > >      bpf_struct_ops_map_free
> > > > > > 
> > > > > > Then I've learned that cond_resched() is not an RCU-tasks quiescent
> > > > > > state, so, we need to use stronger primitives.
> > > > > > 
> > > > > > Use cond_resched_tasks_rcu_qs() at the scan reschedule points so the scan
> > > > > > reports an RCU-tasks quiescent state as it proceeds.
> > > > > > 
> > > > > > Inspired by commit b96285e10aad ("tracing: Have osnoise_main() add a
> > > > > > quiescent state for task rcu").
> > > > > 
> > > > > I'll add
> > > > > 
> > > > > Fixes: c4b28963fd79 ("mm/kmemleak: rely on rcu for task stack scanning")
> > > > > Cc: <stable@vger.kernel.org>
> > > > G
> > > > Thanks to all three of you!
> > > > 
> > > > This adds fewer than ten calls to cond_resched_tasks_rcu_qs(), but still
> > > > more than doubles the number of such calls outside of the RCU subsystem.
> > > > 
> > > > Which is most likely just fine, and in any case absolutely should not
> > > > get in the way of Breno's patch, which after all solves a real problem
> > > > in the here and now.
> > > > 
> > > > Nevertheless, on the off-chance that over the next few months or years
> > > > we start playing cond_resched_tasks_rcu_qs() whack-a-mole, I figured it
> > > > would be good to get a head start on writing up alternatives.  An initial
> > > > draft may be found here:
> > > > 
> > > > https://docs.google.com/document/d/1s3fn29SCTYVw9jak4iraNIVQR59Wk5C6_I-_eu-MfQA/edit?usp=sharing
> > > > 
> > > > TL;DR:  Should we get into a rousing game of whack-a-mole, alternatives
> > > > include continuing as we are, making the existing calls to cond_resched()
> > > > in turn call cond_resched_tasks_rcu_qs(), decoupling mutex-induced
> > > > hung-task warnings from synchronize_rcu_tasks(), and various
> > > > not-so-practical alternatives to RCU Tasks for trampoline synchronization.
> > > > 
> > > > Thoughts?  Especially thoughts on other schemes?
> > > 
> > > While debugging this issue, I was surprised to discover that cond_resched()
> > > doesn't provide RCU-tasks quiescent states. That led me to
> > > cond_resched_tasks_rcu_qs(), which is the stronger primitive needed for
> > > long-running kernel threads like kmemleak_scan(). Is this the common
> > > case for cond_resched()? I got the impression that kmemleak is the
> > > extreme side, but, I have no data on this.
> > 
> > And that discovery did in fact lead you correctly, and hence my
> > giving you a Reviewed-by.
> > 
> > > Worth noting that commit 7dadeaa6e851e7 ("sched: Further restrict the
> > > preemption modes") continues to narrow PREEMPT_NONE, so the future of
> > > cond_resched() itself may be uncertain, no?
> > 
> > Especially given that one of the explicitly stated goals of lazy
> > preemption was in fact to eliminate cond_resched().  ;-)
> > 
> > Getting back to your point about kmemleak possibly being extreme, as far
> > as I know, none of us have data on how many conversions of cond_resched()
> > to cond_resched_tasks_rcu_qs() will be required, or, for that matter,
> > how many additions of cond_resched_tasks_rcu_qs() above and beyond
> > current cond_resched() instances will be required.
> 
> I've searched for "rcu_tasks detected stalls on tasks" on Meta's
> fleet "dmesg depot" and I was suprised to see we have many of them, in
> which seems to be on hypervisor workloads (running VMs).

Good to know!  There have been experiments in the past with hinting
to the hypervisor that a given vCPU could really use some CPU time,
but the result has usually instead been a more targeted fix.

> > There were concerns raised off-list, so I figured that it was time
> > to lay out what we do know, hence the above gdoc.  I very much hope
> > that we don't need many more calls to cond_resched_tasks_rcu_qs(), and
> > thus that the time I spent writing that turns out to be wasted time.
> > But better safe than sorry!
> 
> The document was not a waste of time. it helped people like me to
> understand what the issue is, and what are the decisions we have ahead
> of us.
> 
> Back to what is the best decision/design, I honestly don't have an
> opinion, but I am happy to get more data about Meta production servers
> to help with the decision.

Looking forward to seeing what you come up with!

							Thanx, Paul

