Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F23CFCE8D7A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 02:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 572A28E001F; Fri, 14 Nov 2025 21:30:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522638E0005; Fri, 14 Nov 2025 21:30:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EA7A8E001F; Fri, 14 Nov 2025 21:30:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF7B8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:30:38 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B118813B5ED
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:30:37 +0000 (UTC)
X-FDA: 84111262914.05.F014302
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0BC914000E
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:30:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bKvI9iwP;
	spf=pass (imf12.hostedemail.com: domain of "SRS0=tNS5=5X=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=tNS5=5X=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763173836;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZwTQBF5988wknKRYLWHjs/juHVUWqEf6qIxH4Qsors=;
	b=yUnfcZaRtKshnvc95p8anXtvgFIN9eesRpDW/BfBHAtcvSbHx0M58hQGNBRPlGZtsa4QGG
	hlSXfe7mKxOxvvy/yDdEqK8Aq0LJNhkW/brXkyYHK37MJpNpYQ8YGhsO2C6QfbwAhsrljb
	WTbu/s3Vd8i8g1ZM+pjKnKuWBDH54Uk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bKvI9iwP;
	spf=pass (imf12.hostedemail.com: domain of "SRS0=tNS5=5X=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=tNS5=5X=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763173836; a=rsa-sha256;
	cv=none;
	b=p6llaGYtjb7BnDHb19/aRxNcPR9uXpADy7QwVKuOmayd0djhENQ8RZRPisLDkzklNq/obi
	2DqpiQvMbk/Xr88KYD81z0yfEvEWynxh+gVeZhcI2pgty5/pGdNVlWrKYLZJW0O3jnQyLJ
	8q4bUyq78q6XrB335vYjV8fKbrv4bNQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 25C726011F;
	Sat, 15 Nov 2025 02:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE408C4CEF1;
	Sat, 15 Nov 2025 02:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763173834;
	bh=mO1ZdVZnWjsvWJthzELzsTV32Ev+RejyUQceGtcadCA=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=bKvI9iwPxt7jGyJN+/x9h4ABAVqnNOF8evCkTmxLgPaWLBC6Ai3FhrHhZEqRb/5XD
	 QA2Jig8hSw0xPK6ir9azDHHkQ0jC4lmwGDZ53debIQxLdruXb0T5lPwISi80LoxuC/
	 bbp1DdK3JauP007kkx1bbZycMyMytGcLMKamg/GulHKHyfrz1F2xg7qAp60T4GNG8x
	 HvpXkxoKkv0RInCGzmjCQlVI/R5oG9XopzTEevjYqHGKbUQKcRXpxajPPDlWnkUbDu
	 i5cyl95DWHBmB9eKL9g3qXut0V58Gvfz97MDTZVIuDRPU6PZcgK6pyn5KonKeWab9e
	 Ss/NL0GhoEv5Q==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 4DC2BCE09CC; Fri, 14 Nov 2025 18:30:34 -0800 (PST)
Date: Fri, 14 Nov 2025 18:30:34 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: Valentin Schneider <vschneid@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-mm@kvack.org, rcu@vger.kernel.org,
	the arch/x86 maintainers <x86@kernel.org>,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>, Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: Re: [PATCH v7 00/31] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
Message-ID: <ecc0201e-2fde-4344-9254-89bf29e5054f@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20251114150133.1056710-1-vschneid@redhat.com>
 <c4768cf3-f131-44e6-9b25-ebeb633f32ee@app.fastmail.com>
 <beb46a02-b902-438b-8b6d-b5f0d7ad0ae6@app.fastmail.com>
 <89398bdf-4dad-4976-8eb9-1e86032c8794@paulmck-laptop>
 <1a911310-4ca5-45a4-b9bf-5f37c6ab238e@app.fastmail.com>
 <b3472cb3-86fa-4687-bfce-3b9a1bf4ff36@paulmck-laptop>
 <4f1a7b15-cfdc-478e-8e43-98750608866c@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f1a7b15-cfdc-478e-8e43-98750608866c@app.fastmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0BC914000E
X-Stat-Signature: kdd9otit8e746g5c93ta4by5ymj546ni
X-Rspam-User: 
X-HE-Tag: 1763173835-783420
X-HE-Meta: U2FsdGVkX1/RfwWsXqKH3WaLQf8UX0kFxP5h+YRmwZpDcvgtnQmR1/No/IV9uEhhz4UOb+JdFmERnTnmkYktYq2Mz9POqC3MiKqIJNM1uTZDT/xflyyQPs3Mu/tVdmIU6Acqsg5a9InWia/NnDVazfEpHfub8QAv/1x6LBKYGOBIBJoSVv1ZwnR7ChJtRlo85YBR2F0IXzw6y0+U36PDVp9h+iYhiK9h1E27Vny/a5Heei9/qLDJk6uO5RTeBbM6Dk/mirkkM46yrQsuRGmKBO5x6SxFiB5m1Bs6A/5CjxP6Zhkmc/pFnd5k9pQOJmQGVUoiMsuVm2Cyt1wG5DjqC0udjk6rH7M7MGcH4R2Ar35yC8oV3+H+PtQeCBQurvU1HF+PPZkKxpqBj/rRLWx8mht/Kfg9RI35cn5S89oXW5ZK6TUlIQp/SQn7zhSpoDq80LUvMVb/XTtSfdD25Bzh11WxqY9qvkLzX9xmcf+2PVS1NFyLaiW7JgR5ytZls81lCgflvwMsiG7of1f66QFetOcEaL0j9uNJowEx7Rzk1NdDGGq58RwzE3ffiwV+up5UgWMYsTSMCcG7i+doifNLl/zRduDH2rE3vVwaf7RKp8CsjTZCXJjasHVjCkaK1i9uS5lJQYIu9f+75w6it/kiacbROcK3HsHkYMkf02j+In5Lsvjlczd07TVDbJ9VeoGofZ5gw11k8ree3Oic2rJ2gl+0LWEu6WXyyMl9+N0IfBouMzeKvBTgVB8qt1/4jF5NvFxhy7zf239SM37+IoMjy4Sgd99scyPM2oNrPv3Bfnlfa2Q3BDlrScbNh+khhyfwaidsBYsi3wgf354oX/hi1Th3lDa+E62N8qdXqwu/sHBHNvjSuuq0FPvW7Byf481dFBhZfdEkYuCJTsCPgMO2rj9A19F6rzr2zGqb7khFiy1DTd2Hj8/qxt9T6IZyhROsr+4X5zn71b2GRuD04Kf
 MXpHv9ab
 kkH4MorHkqZWnTZHhiNN+I/Tb6CTSVJaHt5Refs552TxbrHyMYf7v5ENKnl+mHquTX/0ABcNQzaPNUMybo5BlBRlpbV63mbRNYNKchCACDJayg6Oo2S8GEZ4NdWLCD75na+auCjqoPsKDFSqzqp7zN+Bp0aFyG1HH4aRiNRzJbw9wEZ1Q8zSxeILYUcH4zz/NIqBRbeCbhdR7t6MVKCCLJcIABQd6emR/DfKJr5NVXkM4KM5kX7cI5pxm4GKC3+5CFFo76imTzXJcDBoYlBQKuQMdU03Q3C9vJv+xfXCSpHSiXILgDyttVpkeped2aUjGBIFzOz6GmrnXJOz5rwDV5Cr2rjQ0zh9LgJxym0v4hqYEMSNANmRJt303h8I0XFq0VbZYE0vVPy27erf8a0Yk1FiNP/1X5PwI4SkC74YvATw8JX9Z9RgG9S+KdoG8rSE8WHOlth/HmcEy/M+SM+kBEZdOf1nvdXeb/bXzp9TOV1ojpXJYhXjnxKb5rSUCoSN3FM/n0yBFhHDOd1x7vah9cOscnIVBtQksWDUutYfGcqevFYoY4jl9bhL/WgCTpS/BGn3x5MHqhDR5+Bca8saI++8e3HdMoK0XjcrrqkiVim6mKxsYXJgrIQBAXoAvOu6qGFwQvsiNnTyPbxFsHk9Yv2RY7b65VxpEvo4lsRrSYuP/89KBCguPeBKTtxgcztN9FpjSULlMCBBAM7GS4wBWdL0EuiGe4ZcoksdDCIDrJe6kiHG2rEE+fb0vaS/MMUGyTe3XFQJsAKsY/38=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 04:29:31PM -0800, Andy Lutomirski wrote:
> 
> 
> On Fri, Nov 14, 2025, at 12:03 PM, Paul E. McKenney wrote:
> > On Fri, Nov 14, 2025 at 10:45:08AM -0800, Andy Lutomirski wrote:
> >> 
> >> 
> >> On Fri, Nov 14, 2025, at 10:14 AM, Paul E. McKenney wrote:
> >> > On Fri, Nov 14, 2025 at 09:22:35AM -0800, Andy Lutomirski wrote:
> >> >> 
> >> 
> >> >> > Oh, any another primitive would be possible: one CPU could plausibly 
> >> >> > execute another CPU's interrupts or soft-irqs or whatever by taking a 
> >> >> > special lock that would effectively pin the remote CPU in user mode -- 
> >> >> > you'd set a flag in the target cpu_flags saying "pin in USER mode" and 
> >> >> > the transition on that CPU to kernel mode would then spin on entry to 
> >> >> > kernel mode and wait for the lock to be released.  This could plausibly 
> >> >> > get a lot of the on_each_cpu callers to switch over in one fell swoop: 
> >> >> > anything that needs to synchronize to the remote CPU but does not need 
> >> >> > to poke its actual architectural state could be executed locally while 
> >> >> > the remote CPU is pinned.
> >> >
> >> > It would be necessary to arrange for the remote CPU to remain pinned
> >> > while the local CPU executed on its behalf.  Does the above approach
> >> > make that happen without re-introducing our current context-tracking
> >> > overhead and complexity?
> >> 
> >> Using the pseudo-implementation farther down, I think this would be like:
> >> 
> >> if (my_state->status == INDETERMINATE) {
> >>    // we were lazy and we never promised to do work atomically.
> >>    atomic_set(&my_state->status, KERNEL);
> >>    this_entry_work = 0;
> >>    /* we are definitely not pinned in this path */
> >> } else {
> >>    // we were not lazy and we promised we would do work atomically
> >>    atomic exchange the entire state to { .work = 0, .status = KERNEL }
> >>    this_entry_work = (whatever we just read);
> >>    if (this_entry_work & PINNED) {
> >>      u32 this_cpu_pin_count = this_cpu_ptr(pin_count);
> >>      while (atomic_read(&this_cpu_pin_count)) {
> >>        cpu_relax();
> >>      }
> >>    }
> >>  }
> >> 
> >> and we'd have something like:
> >> 
> >> bool try_pin_remote_cpu(int cpu)
> >> {
> >>     u32 *remote_pin_count = ...;
> >>     struct fancy_cpu_state *remote_state = ...;
> >>     atomic_inc(remote_pin_count);  // optimistic
> >> 
> >>     // Hmm, we do not want that read to get reordered with the inc, so we probably
> >>     // need a full barrier or seq_cst.  How does Linux spell that?  C++ has atomic::load
> >>     // with seq_cst and maybe the optimizer can do the right thing.  Maybe it's:
> >>     smp_mb__after_atomic();
> >> 
> >>     if (atomic_read(&remote_state->status) == USER) {
> >>       // Okay, it's genuinely pinned.
> >>       return true;
> >> 
> >>       // egads, if this is some arch with very weak ordering,
> >>       // do we need to be concerned that we just took a lock but we
> >>       // just did a relaxed read and therefore a subsequent access
> >>       // that thinks it's locked might appear to precede the load and therefore
> >>       // somehow get surprisingly seen out of order by the target cpu?
> >>       // maybe we wanted atomic_read_acquire above instead?
> >>     } else {
> >>       // We might not have successfully pinned it
> >>       atomic_dec(remote_pin_count);
> >>     }
> >> }
> >> 
> >> void unpin_remote_cpu(int cpu)
> >> {
> >>     atomic_dec(remote_pin_count();
> >> }
> >> 
> >> and we'd use it like:
> >> 
> >> if (try_pin_remote_cpu(cpu)) {
> >>   // do something useful
> >> } else {
> >>   send IPI;
> >> }
> >> 
> >> but we'd really accumulate the set of CPUs that need the IPIs and do them all at once.
> >> 
> >> I ran the theorem prover that lives inside my head on this code using the assumption that the machine is a well-behaved x86 system and it said "yeah, looks like it might be correct".  I trust an actual formalized system or someone like you who is genuinely very good at this stuff much more than I trust my initial impression :)
> >
> > Let's start with requirements, non-traditional though that might be. ;-)
> 
> That's ridiculous! :-)

;-) ;-) ;-)

> > An "RCU idle" CPU is either in deep idle or executing in nohz_full
> > userspace.
> >
> > 1.	If the RCU grace-period kthread sees an RCU-idle CPU, then:
> >
> > 	a.	Everything that this CPU did before entering RCU-idle
> > 		state must be visible to sufficiently later code executed
> > 		by the grace-period kthread, and:
> >
> > 	b.	Everything that the CPU will do after exiting RCU-idle
> > 		state must *not* have been visible to the grace-period
> > 		kthread sufficiently prior to having sampled this
> > 		CPU's state.
> >
> > 2.	If the RCU grace-period kthread sees an RCU-nonidle CPU, then
> > 	it depends on whether this is the same nonidle sojourn as was
> > 	initially seen.  (If the kthread initially saw the CPU in an
> > 	RCU-idle state, it would not have bothered resampling.)
> >
> > 	a.	If this is the same nonidle sojourn, then there are no
> > 		ordering requirements.	RCU must continue to wait on
> > 		this CPU.
> >
> > 	b.	Otherwise, everything that this CPU did before entering
> > 		its last RCU-idle state must be visible to sufficiently
> > 		later code executed by the grace-period kthread.
> > 		Similar to (1a) above.
> >
> > 3.	If a given CPU quickly switches into and out of RCU-idle
> > 	state, and it is always in RCU-nonidle state whenever the RCU
> > 	grace-period kthread looks, RCU must still realize that this
> > 	CPU has passed through at least one quiescent state.
> >
> > 	This is why we have a counter for RCU rather than just a
> > 	simple state.

Sigh...

4.	Entering and exiting either idle or nohz_full usermode execution
	at task level can race with interrupts and NMIs attempting to
	make this same transition.  (And you had much to do with the
	current code that mediates the NMI races!)

> ...
> 
> > I am not seeing how the third requirement above is met, though.  I have
> > not verified the sampling code that the RCU grace-period kthread is
> > supposed to use because I am not seeing it right off-hand.
> 
> This is ct_rcu_watching_cpu_acquire, right?  Lemme think.  Maybe there's even a way to do everything I'm suggesting without changing that interface.

Yes.

Also, the ordering can sometimes be implemnted at a distance, but it
really does have to be there.

> >> It wouldn't be outrageous to have real-time imply the full USER transition.
> >
> > We could have special code for RT, but this of course increases the
> > complexity.  Which might be justified by sufficient speedup.
> 
> I'm thinking that the code would be arranged so that going to user mode in the USER or the INTERMEDIATE state would be fully valid and would just have different performance characteristics.  So the only extra complexity here would be the actual logic to choose which state to go to. and...
> >
> > And yes, many distros enable NO_HZ_FULL by default.  I will refrain from
> > suggesting additional static branches.  ;-)
> 
> I'm not even suggesting a static branch.  I think the potential performance wins are big enough to justify a bona fide ordinary if statement or two :)  I'm also contemplating whether it could make sense to make this whole thing be unconditionally configured in if the performance in the case where no one uses it (i.e. everything is INTERMEDIATE instead of USER) is good enough.

Both sound like they would be nice to have...

> I will ponder.

...give or take feasibility, of course!  ;-)

							Thanx, Paul

