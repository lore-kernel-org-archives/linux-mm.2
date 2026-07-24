Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 469C0C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 09:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38C216B0088; Fri, 24 Jul 2026 05:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33BD46B008A; Fri, 24 Jul 2026 05:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2037A6B008C; Fri, 24 Jul 2026 05:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF81C6B0088
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 05:58:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58012C0335
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:58:38 +0000 (UTC)
X-FDA: 85023220716.22.F19F761
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id A9A6FC0009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:58:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=obJNvxuD;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784887116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L541VKiqXeegrdDBGEbQltr0E3niQlPmGsrvV1AIcQA=;
	b=InoTxi3Z+nYRg+1ziAsaWdLjunpsrHErvswFqgUX/OPr3+ccYd5gdHHBslYHrTZbblLqZc
	GJcfHTFAyLidHFeFS6zaJw6f+FmZTeVewnG9QyO0yvkFHcNrQv/9Qt9biAL2GJa70ty88a
	/NDwPbnqsfanM42Z5HdYhY0yrxRBrOc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=obJNvxuD;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784887116;
	b=L2W12aoGpHGNveG5rLbLhDzS8+ofeXX4X3W2uDr+amglBYwSikePm1U/UjQkBiJENYEom1
	Bq/oydTffiRhBGLByhQyTpOgH9X4cKCYjPRvxkXblymzQQFDLac3/jcyEUKuyTK0dj7k1+
	TNg8+IpgGuXKK98E5xlFrQ0ZnsWdEYM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=L541VKiqXeegrdDBGEbQltr0E3niQlPmGsrvV1AIcQA=; b=obJNvxuDYRmXOhnzrCkICh5HBw
	BXHtwOW/lFdNmrivFjCW3TMe27FdHA/ZFw40SMfexgW0SzeNpNXg9Vns/alM6TRrqkI9GEuwGqrog
	GXQJYl0SW8+E3+u/ls9rsMqVhetAUsFrqJfH6sVY4EZkDcaCkxVjvqD5Ib7AHiB6x+eUVahrcHS/T
	UumxVay4PbaY2CqkBaW4Qcnox1s5wV03aLZm4tHtLzn5Dtfi7AEH4466GdG0H85HUndhHUbPLjRm1
	0uugn6XPyPxOhkpEFFXms+rmHdGNSuuqNC/p2DiUMU+3xWvPBYGPtCVbSnQEFzkOMJRuLdlpd7hHz
	M0Z1hSBg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wnCfl-004TYP-07;
	Fri, 24 Jul 2026 09:58:29 +0000
Date: Fri, 24 Jul 2026 02:58:24 -0700
From: Breno Leitao <leitao@debian.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, puranjay@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during
 the scan
Message-ID: <amM1xUOhcpGpqIpe@gmail.com>
References: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
 <20260720153917.2e428e489cd0873ac6d4e6da@linux-foundation.org>
 <5b83b0a0-708a-458a-bdbd-41c6d4610349@paulmck-laptop>
 <amCT9QEgJRsLIb_y@gmail.com>
 <ffa5d8d2-1157-4a30-995c-ddae3566e3a4@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffa5d8d2-1157-4a30-995c-ddae3566e3a4@paulmck-laptop>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A9A6FC0009
X-Stat-Signature: 5cqnk8kxwrd4qqm6euuus5sgtpqe7x9a
X-HE-Tag: 1784887116-2210
X-HE-Meta: U2FsdGVkX194ONS94ejsJcPpF0CC7BsgpxZlN2Fta6IDAOUIo5ndrnpJB955NJ9OaYireG/q8KUyeiryQj4/0kseVhHJDURSQMZVILKhgZ3eHZ4T0FJXf+M1Lo7hUM4S93Ul2k+J3iTpKdJQonHQ+J7C7/K1+vc17TMTi8Hg1fucBffW+3tIp5Y/xclhuPmnsV6VyuX+www8bEIfemkI0UUGwdg67by8a4GR/efJM0Z+VvcOEla9NlAxStyzM/RDFwIaZctz8HB58raTugoyLQ2/P56fqRckYZLdMoaxkquG/luF01VFpfebdZBWPZNhnJ1P0KR7mEUHdZ185gn77gFFPPJhNjheEiOutpLCPmoV5jA93opo+QedDUthIefyPJA3jf4Nvj9V64DolJpeEHUrQQ6+JYu07zm8agKWoA2iWFcZ5pJJ4v1F5yXGftVDL0km8ythR1yMiW5Ci+SGyZ7J+3XNPBL+pAbZVhOShVIcmKQmkjzg5xJBiPUj5famtMVgeO998z36yVG3felG4XprycQ03tRjPfqOw6jagqBuL3naiLVY8guWY3G3hcZpabaydP2km2vY4UZJGjyhDyRl2sU97Yr69IDEBdJea2x5jJjwPDWv1y9/IDhNJL//CE9uJD2Rg2uB9qFu/ue8RQSIs8QNyZlieeI4gN+ryzhTS+bpx4/g5Ircl2I4oEuQilKo+Og7Oxvod5s7Tq22RGG89Fz4NZ7DC/WbHwvb8BPCGH6XdP/tmcdhl24iK23ZDiFk1j2lVRuYeRTaUKXKiFG4+Nm+ZfDnMsC3Tv4zWgWWQrr8UbZQFHeB38+wmDp7Ulkj83Bd/R5vIP3P4YgZDmMRg/MPFsqlCHzVP0V4nfb6fVkN5EjHDxUHjXGSMRfnJgvbtIePbvG+cqW9L7DNhfuS0u0AoIkmL4JIP+no7anKezpzVwzyXnEksviSjIMS++M4SfpSQuUPIlwoqnW
 i4KZ7+g7
 fphk/50UwgKvHf6XQIbBRG2ULyMJ67ZJSR404JkWeP04R/Egptc6ys3Z0QyfGjLQwVtruC+aqMBYIUC8ok0Cy8GT1MxHaz946mwjw/1/ls6zRWEIJFRAqqHzhN941rEc5OOw+TabGuH/Ncs/WCrCuvbuMKKQprU1B2chM0X5hrCl2OFaD0nO40dcWZJa9qMIVNwypCsY+ZmhyJtodwlLtMH4oQ2NYqdzsZpYKnhvLTWIANPw/gYcOnMLV16V/wO/SXtB4il6+rcWrMHU2t4JeUVRAw3Oe4BDgvIGS3pxLeonYyPh86NBtwsHJGNqPp3mHXPXy6l/i2sxDCnk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 08:56:58AM -0700, Paul E. McKenney wrote:
> On Thu, Jul 23, 2026 at 06:26:11AM -0700, Breno Leitao wrote:
> > Hello Paul,
> > 
> > On Mon, Jul 20, 2026 at 09:21:17PM -0700, Paul E. McKenney wrote:
> > > On Mon, Jul 20, 2026 at 03:39:17PM -0700, Andrew Morton wrote:
> > > > On Mon, 20 Jul 2026 06:23:45 -0700 Breno Leitao <leitao@debian.org> wrote:
> > > > 
> > > > > kmemleak_scan() can run for ages on large debug kernels. It was
> > > > > causing some soft-lockups which I got fixed with commit
> > > > > 3175fcfec8b16baeb ("mm/kmemleak: avoid soft lockup when scanning task
> > > > > stacks") with our beloved cond_resched().
> > > > > 
> > > > > I've got the fix above deployed in the Meta fleet, and now I am seeing:
> > > > > 
> > > > >   INFO: rcu_tasks detected stalls on tasks:
> > > > >     task:kmemleak state:R ... nvcsw: 274/274 holdout: 1 idle_cpu: -1/3
> > > > >      scan_block
> > > > >      scan_gray_list
> > > > >      kmemleak_scan
> > > > > 
> > > > > and, worse, blocks the callers waiting on that grace period. Here a BPF
> > > > > struct_ops map free, which waits via synchronize_rcu_mult(call_rcu,
> > > > > call_rcu_tasks), is stuck long enough to also trip the hung task check:
> > > > > 
> > > > >   INFO: task kworker/...:bpf_map_free_deferred blocked for 122 seconds
> > > > >      __wait_rcu_gp
> > > > >      bpf_struct_ops_map_free
> > > > > 
> > > > > Then I've learned that cond_resched() is not an RCU-tasks quiescent
> > > > > state, so, we need to use stronger primitives.
> > > > > 
> > > > > Use cond_resched_tasks_rcu_qs() at the scan reschedule points so the scan
> > > > > reports an RCU-tasks quiescent state as it proceeds.
> > > > > 
> > > > > Inspired by commit b96285e10aad ("tracing: Have osnoise_main() add a
> > > > > quiescent state for task rcu").
> > > > 
> > > > I'll add
> > > > 
> > > > Fixes: c4b28963fd79 ("mm/kmemleak: rely on rcu for task stack scanning")
> > > > Cc: <stable@vger.kernel.org>
> > > G
> > > Thanks to all three of you!
> > > 
> > > This adds fewer than ten calls to cond_resched_tasks_rcu_qs(), but still
> > > more than doubles the number of such calls outside of the RCU subsystem.
> > > 
> > > Which is most likely just fine, and in any case absolutely should not
> > > get in the way of Breno's patch, which after all solves a real problem
> > > in the here and now.
> > > 
> > > Nevertheless, on the off-chance that over the next few months or years
> > > we start playing cond_resched_tasks_rcu_qs() whack-a-mole, I figured it
> > > would be good to get a head start on writing up alternatives.  An initial
> > > draft may be found here:
> > > 
> > > https://docs.google.com/document/d/1s3fn29SCTYVw9jak4iraNIVQR59Wk5C6_I-_eu-MfQA/edit?usp=sharing
> > > 
> > > TL;DR:  Should we get into a rousing game of whack-a-mole, alternatives
> > > include continuing as we are, making the existing calls to cond_resched()
> > > in turn call cond_resched_tasks_rcu_qs(), decoupling mutex-induced
> > > hung-task warnings from synchronize_rcu_tasks(), and various
> > > not-so-practical alternatives to RCU Tasks for trampoline synchronization.
> > > 
> > > Thoughts?  Especially thoughts on other schemes?
> > 
> > While debugging this issue, I was surprised to discover that cond_resched()
> > doesn't provide RCU-tasks quiescent states. That led me to
> > cond_resched_tasks_rcu_qs(), which is the stronger primitive needed for
> > long-running kernel threads like kmemleak_scan(). Is this the common
> > case for cond_resched()? I got the impression that kmemleak is the
> > extreme side, but, I have no data on this.
> 
> And that discovery did in fact lead you correctly, and hence my
> giving you a Reviewed-by.
> 
> > Worth noting that commit 7dadeaa6e851e7 ("sched: Further restrict the
> > preemption modes") continues to narrow PREEMPT_NONE, so the future of
> > cond_resched() itself may be uncertain, no?
> 
> Especially given that one of the explicitly stated goals of lazy
> preemption was in fact to eliminate cond_resched().  ;-)
> 
> Getting back to your point about kmemleak possibly being extreme, as far
> as I know, none of us have data on how many conversions of cond_resched()
> to cond_resched_tasks_rcu_qs() will be required, or, for that matter,
> how many additions of cond_resched_tasks_rcu_qs() above and beyond
> current cond_resched() instances will be required.

I've searched for "rcu_tasks detected stalls on tasks" on Meta's
fleet "dmesg depot" and I was suprised to see we have many of them, in
which seems to be on hypervisor workloads (running VMs).

> There were concerns raised off-list, so I figured that it was time
> to lay out what we do know, hence the above gdoc.  I very much hope
> that we don't need many more calls to cond_resched_tasks_rcu_qs(), and
> thus that the time I spent writing that turns out to be wasted time.
> But better safe than sorry!

The document was not a waste of time. it helped people like me to
understand what the issue is, and what are the decisions we have ahead
of us.

Back to what is the best decision/design, I honestly don't have an
opinion, but I am happy to get more data about Meta production servers
to help with the decision.

