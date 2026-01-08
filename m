Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0CC3D1D480
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 16:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107C96B0005; Thu,  8 Jan 2026 11:34:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DFE26B0088; Thu,  8 Jan 2026 11:34:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8E86B0089; Thu,  8 Jan 2026 11:34:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF2E06B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:34:39 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6EF6F139D49
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:34:39 +0000 (UTC)
X-FDA: 84309345078.13.BCFD43E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D5C36C0014
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:34:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qop4onjQ;
	spf=pass (imf10.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767890077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZX2yIYCz8CIxvkZgLksF5i3PjrgARc/4+au0dY2IsYI=;
	b=E2WKnm4eyAfaoYqbT6w9fnESU0WkYbFEJhCuVIfgjdloqizM99LaDjVK+W5QPhrq5ouY1P
	W888YozgkKbC3nM+OlQo60Nd5n5Lv07yo/ZTnIdW4BEGaYwr23GlA2gijMucRK35e89AMm
	rZmTdyi+X/Y6vHYXrb6IUGvGA4zTT1M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qop4onjQ;
	spf=pass (imf10.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767890077; a=rsa-sha256;
	cv=none;
	b=J10uI08mbgAy0XBEBFVzUqnJiF9kr6g2WLi8Cyh8pPHz5bKdQm5pdOuTBi/U9FS9w4Y02K
	ypTZSmpFH4TV4sAPn8Wk54Wt5JsPlkP0JIBzDqXBfPAdJvfsrU2TvVP3SBmHUbBfH14lIl
	YFxhB6plc1c2bdBmw93ECt5CcX7h0nA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A9B460130;
	Thu,  8 Jan 2026 16:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4EDC116C6;
	Thu,  8 Jan 2026 16:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767890076;
	bh=HB/X+fffuA0TvjLxceiX3y3jO+hrwXvc4XJ3pZcxDUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qop4onjQDUz1kTx/uz4y6thrIiH7R4NA/jCKCIITrsaen+w4MAI+VWGV8DRkozJzw
	 uGl/xQKos29DqLGAtxe6EiwpCEDigO+ynC8AutDn5gybIRkHATVQOksvH+xHTeyQp3
	 9TjKySCTHakWMET5kiYzKMb7jai+h2VsHo9JgSUJfioprUpYdR8NBQRIlFOB3s6I4l
	 xr0KGNwNUZlGeyfpxp62zkRNQmfQRC94A6nhj6G4CidAN2lS76nO86rWtg91v8nf4W
	 q4eNHWwMI82ZmpaLwnIirCp/1tXEq3vT5zuoULdJP4azhIiEkB+4qk5KzUuuEDWiJY
	 5yFHyOg/CK/2A==
Date: Thu, 8 Jan 2026 17:34:34 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	John Stultz <jstultz@google.com>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>, Ingo Molnar <mingo@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com,
	Mateusz Guzik <mjguzik@gmail.com>,
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,
	rcu@vger.kernel.org, linux-mm@kvack.org, lkmm@lists.linux.dev
Subject: Re: [RFC PATCH v4 3/4] hazptr: Implement Hazard Pointers
Message-ID: <aV_cms1mCPYq6jah@localhost.localdomain>
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
 <20251218014531.3793471-4-mathieu.desnoyers@efficios.com>
 <aUO9KRaP0FXpm_l9@tardis-2.local>
 <fcbc99d0-b7c7-45f7-9cf8-f5d3bfad966e@efficios.com>
 <aUSfu4V9mrD7BQGl@tardis-2.local>
 <6c96dbb5-bffc-423f-bb6a-3072abb5f711@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6c96dbb5-bffc-423f-bb6a-3072abb5f711@efficios.com>
X-Rspam-User: 
X-Stat-Signature: ucd8qfrs38mp3w35wyai83zwhszodqck
X-Rspamd-Queue-Id: D5C36C0014
X-Rspamd-Server: rspam04
X-HE-Tag: 1767890077-235660
X-HE-Meta: U2FsdGVkX18ZT0kqapzxaI+Z0iBOZC1+wuEd9pBUdrbbWvmkCXS/D2mo+Lls8E3jGFN6gjnsYZI4akU2St2DmPgThPiCuCHWEe97CzGB8aT1I5hBEucREgtTpXBYxTmgEkoblXSX2SJVs3sD/DiDNvibHjeAft6xvmuhITyHKmOenIaVmDTy1/vWAutcqasHxb9vGEV7Lc/3Oiyrqi5/OryVKJ4nP4YTQNhj7aQ1aOvM5UP5HrfuU2GTADqXR1LDo/aLChEGKLP/vcRFPe91lR2Y+7TesXAJVW3V9FMaDLAqto6vmIBYxxUCk+5lRug9T8YhH1L3xI/qxKwOXIiiRMF5TdWBW+21yQdOIQ1b0R1d9WBVe+pA9GwhA/BfPXksz84siptB8YaH50ofcSYKuO3ChBcY8eV64DQOfownVRapoCp1WrRBDZSTc8xNbcKgWfcZljtS303jXG0Wz9a9wOuDGhYCAahea0L92N/FbNk+/VXSkudJTJkmkCvGIGNY5xbvYVtAx3MnjhQJQCHgS3/mdh6VRXPHOmSIhUXNC6FBEoK6UfZHEQr2xW76QyOse9a45oPXFvXu1T6uQ3DjLKsU8QqTeNQP7hKZpQWes3k+gb75e1UHvTrvTORBwlgx9xPS/onXcE7j5mivU0LESpAjuQv0XHIofCM3hLCgibYZ9UKWwM4Ts6j+scSvtBO88O08DjffuVVvwGGI9gfdV1O/uBSnjfeJAfjYWvelcYBZ4mhB7r8fYQjVe0cgh0IUup5mNMh+revCEWPVCFHKqPdW0Wp5U7eDNViIRtdWhowIwcj5hXz/ebspgZSID1IY1zCNmxJUAgcMcF5Ec1vP1mKl+yFLoi+9/9QbHkqFfuS011vv4GyX/YssaMgcRtHTKoqDFwCcPaEtexWWIU87kqfBq2cUu67ebJdwYrzgALV5yW6idRg3Ea9APiKh+RS2GMQUOAiq3wSrZaRdryQ
 lllwbZ8O
 FwkehBRnktTtWeE0TK5uGsrIn/tVqxAh2AFv3PGO5tDS08EhO3RjFNtJSed7vtBV9mFMV61pGjtl/y349hA8sJ384wQwSjxRAbietEV86TYUyVPpm4N4fIdinN7IbTLFT3LmnDq4cJUKqPEChjKFufB8acBeFZ0KNNV3x1oaAZM7irzQK7HlMapR7VZN8YKJ7rIzUvJP6+3xhu5bC6W9xgouf/8F9nOQvBZgLmuOz8DtwmIQut62QMvnOlYM1TQDQ2aaM4oB4U8dtudClRgSYQObwYZpnvbBOO5y15P1bFJsXu35P2jqam0HwhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Fri, Dec 19, 2025 at 09:22:19AM -0500, Mathieu Desnoyers a écrit :
> On 2025-12-18 19:43, Boqun Feng wrote:
> > On Thu, Dec 18, 2025 at 12:35:18PM -0500, Mathieu Desnoyers wrote:
> > [...]
> > > > Could you utilize this[1] to see a
> > > > comparison of the reader-side performance against RCU/SRCU?
> > > 
> > > Good point ! Let's see.
> > > 
> > > On a AMD 2x EPYC 9654 96-Core Processor with 192 cores,
> > > hyperthreading disabled,
> > > CONFIG_PREEMPT=y,
> > > CONFIG_PREEMPT_RCU=y,
> > > CONFIG_PREEMPT_HAZPTR=y.
> > > 
> > > scale_type                 ns
> > > -----------------------
> > > hazptr-smp-mb             13.1   <- this implementation
> > > hazptr-barrier            11.5   <- replace smp_mb() on acquire with barrier(), requires IPIs on synchronize.
> > > hazptr-smp-mb-hlist       12.7   <- replace per-task hp context and per-cpu overflow lists by hlist.
> > > rcu                       17.0
> > 
> > Hmm.. now looking back, how is it possible that hazptr is faster than
> > RCU on the reader-side? Because a grace period was happening and
> > triggered rcu_read_unlock_special()? This is actualy more interesting.
> So I could be entirely misreading the code, but, we have:
> 
> rcu_flavor_sched_clock_irq():
> [...]
>         /* If GP is oldish, ask for help from rcu_read_unlock_special(). */
>         if (rcu_preempt_depth() > 0 &&
>             __this_cpu_read(rcu_data.core_needs_qs) &&
>             __this_cpu_read(rcu_data.cpu_no_qs.b.norm) &&
>             !t->rcu_read_unlock_special.b.need_qs &&
>             time_after(jiffies, rcu_state.gp_start + HZ))
>                 t->rcu_read_unlock_special.b.need_qs = true;
> 
> which means we set need_qs = true as a result from observing
> cpu_no_qs.b.norm == true.
> 
> This is sufficient to trigger calls (plural) to rcu_read_unlock_special()
> from __rcu_read_unlock.
> 
> But then if we look at rcu_preempt_deferred_qs_irqrestore()
> which we would expect to clear the rcu_read_unlock_special.b.need_qs
> state, we have this:
> 
>         special = t->rcu_read_unlock_special;
>         if (!special.s && !rdp->cpu_no_qs.b.exp) {
>                 local_irq_restore(flags);
>                 return;
>         }
>         t->rcu_read_unlock_special.s = 0;
> 
> which skips over clearing the state unless there is an expedited
> grace period required.
> 
> So unless I'm missing something, we should _also_ clear that state
> when it's invoked after rcu_flavor_sched_clock_irq, so the next
> __rcu_read_unlock won't all call into rcu_read_unlock_special().
> 
> I'm adding a big warning about sleep deprivation and possibly
> misunderstanding the whole thing. What am I missing ?

As far as I can tell, this skips clearing the state if the state is
already cleared. Or am I even more sleep deprived than you? :o)

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

