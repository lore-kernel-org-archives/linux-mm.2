Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53661D1D486
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 19:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88ED6B009E; Thu,  8 Jan 2026 14:01:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53776B009F; Thu,  8 Jan 2026 14:01:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52EE6B00A0; Thu,  8 Jan 2026 14:01:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EFFF6B009E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:01:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33F9616027B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 19:01:20 +0000 (UTC)
X-FDA: 84309714720.11.43632C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 46EDC40007
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 19:01:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CnAkSC6a;
	spf=pass (imf12.hostedemail.com: domain of "SRS0=1jwM=7N=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=1jwM=7N=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767898878; a=rsa-sha256;
	cv=none;
	b=s0Y9Ho586hn3Ds0+/GWrcM0ICXy2cXzYffqWUBLLAGdwpjOxbgn6uGdKImWVQEejxTj343
	6NggklRpYRllbLBM155pRPEHspOpqTh8MtlzCPRIlRAKUK0C6S9GHNw+kzNfCik7dZeNPs
	MWOvsW90GGgXWbT+qEYYf6bwF69hvBE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CnAkSC6a;
	spf=pass (imf12.hostedemail.com: domain of "SRS0=1jwM=7N=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=1jwM=7N=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767898878;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PS2mUkfa56RM0HipNYeKA3Vd6mJdT10YIk4QUnjNGV4=;
	b=R/RzL1qxFgmNztT55HFqJ2QujYwpYmWaUvPdqIf7+1F9ZsRD9BJB1cTtlvvMD07uqPy2dr
	pA06ERBELqBgRIeztwkR8IaHASYbSAb8ynUxaSVwwv7cveanMr3L9bJJmcQ78RQ2tK/xOA
	BJmeLgY/ERb1gLIaaBRv/NBDRdUHrow=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A81360133;
	Thu,  8 Jan 2026 19:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4B1C116C6;
	Thu,  8 Jan 2026 19:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767898877;
	bh=85lqoq+CQJ2HM2BHYhQM6KPWo3GQyLWoKEtp5vriauY=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=CnAkSC6aCYPXrZfTNFoYj/UrHem2yIZRvLMEuBErPVex8IVONGzWUYHqfK20BUS1n
	 uJcTwvY/iTb0C7SvSMi99I4unqgPDoRDt5U1AktB+91vOfCRQMH3vN1+Gj+rqn67xs
	 Hzy5TmEqccfXdqjswjDJpbbD6OnvjpNt0KKB4RV0LvAsWBy8dU6YvAC0zZh4OHbBvN
	 x9Lnt5OoppRhno5FMHaF+Rw/Vpsd2DtG59Np0gFbK7FEIv7fpaWoWbeUThmXWU4zwW
	 uQCq8dlVWc9JDBrwWW9ZsTsOEbTb0lFG732B//kc1A+lk1R4NfY1NguDBr5x7n386a
	 YhxfZwLlBinLg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 7F7BDCE0CB8; Thu,  8 Jan 2026 11:01:16 -0800 (PST)
Date: Thu, 8 Jan 2026 11:01:16 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Joel Fernandes <joel@joelfernandes.org>,
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
Message-ID: <4f6fe051-b686-4ec4-8aff-4237b3007f33@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
 <20251218014531.3793471-4-mathieu.desnoyers@efficios.com>
 <aUO9KRaP0FXpm_l9@tardis-2.local>
 <fcbc99d0-b7c7-45f7-9cf8-f5d3bfad966e@efficios.com>
 <aUSfu4V9mrD7BQGl@tardis-2.local>
 <6c96dbb5-bffc-423f-bb6a-3072abb5f711@efficios.com>
 <aV_cms1mCPYq6jah@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aV_cms1mCPYq6jah@localhost.localdomain>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 46EDC40007
X-Stat-Signature: ijp1ib6i946q76gabumu3xi1jjusic7z
X-Rspam-User: 
X-HE-Tag: 1767898878-486053
X-HE-Meta: U2FsdGVkX1/o9U1ZZJt2BimLV4H8o5u0xMY4n16buaQFnINizOzPC3+WyHXGWTRoQJxS/PaFl3Hlg7Oek57OxJBsIIadn7XN4bNV+Vk2+W6GsrgIV6asJloX9GABokFwlm5u8JUxuKBPwq1183wr8xrb1EZtgHa4EA+nIZEVBBBQB4jKTsM70KbKj27yOHzPzTpVjpiaQjNWF+pOeCJPAFfoqGke4IiRqVi0LqdiEodHLF1o13bxFCuMr5y+3ylN0LFzidbqjdMnZVsAsPxT2KlFQbuCwVuLLEqsgwImV6ccD9eEChMB76wAmNd8ikJolmIW7yc6Azug8EqsysFPOh8SXDsWU6MGK+UILrs4vxaXi3Ojph7OtCiddmFfoANBAQ3Q5JlJ2loajG1k3lpxOP0+ySXC10SKm8XkJY1h9d2/C65DKNku9iMPEffFzBlxa++Ovwms14Ml3r2N/2c2soHqkvQ/p9ZZSdWLaLzBmGOLRcMatH74gMJVs0fNfeMe6L+2UFuyAr46aSF+UGWqd87dwvsQhnKQTQgMTJJJ9MxwFGK6xgYILMLHwQw6Z+32dekSM67bh2YX3NAtYDu9twR5tgGIhuW/eVejISqDT/MpTtg+3eDc3eDc2BBwf64/T7pKTaylf2Rnf/hBF9tuEC/AJBgzAFAcDNj5k/Z7NpN+OiIZrtLJyZ9xy1pfVmhMeBvnD3vBkRD6oyqg8A8bXsJ77SLjIxIw0yT6fFRAGQtaeJAgqzUKUgpVHI0cYhSXXHaeg+K2lhoZrdG4Bnaf1nocFp+SwlEQBF9rON6v6DBinYe6d72vM08kiHE1cu1/sdGBOw7jC5JI5fK0z0qyqt19nDjZKO7B03nRwA/awkMVJ82F4pjnTx+qR8jZi/iXgD51rYfLyzdkNJ3qeIw7BJJMOUGEEliHZFA+WEF+3f/cCQQpP+Z8pPBx7882axtmmdDeo6pSAj6VCLnh/kv
 hx5tS63S
 CTyBRNQ/OW2jK6lZMlHjFC+/5hM/++pddEYt0JyZVB2/Tj278SMCkuoBFWnnfuQJ42pYyVYNs6KEqrH7riJHHturlLz/+pXeH7X22JAWg/spHsL+LUsnX/HnzwBHjgnu4tV6xj08RjtA7psmIcqPVoHihN7BXns1LJxSXa2r2fEQ5XSRom2bT6UtBRKzLXEYZrBA6H6514h54bBWlkHWrdhdEF1KB3y5IsnZwdn5dtBWJNcTozuI8HzJY14KRY76OMpcxTvQYe3MT9ASafMT47zNgHmQRpNbNFOR29iGfHvNc+n2U+R7TIosixn3M994NlEp6ZBKGCjW3b/aT7MZdAKL5e2YCV2giDBIaKa2hQlCJdEzTRjLrlMzNj999QaEn+I8xOO6m37oL3F9hRArpAy9500rKFKv0TkwHoBDglo4wQ+YQXnb4ri2aKySSddytY8ctd5vfHykjvdBwf9dNiN7GV1qYjmlOxqzBnffHW6KlxTvILz4uxnK1eBm4gTxzjd3TYglFgMnzoMJf09MqghxJ8sT2B5byyTTUoEZBUXA71yCi6DZCprOlAmdo9tFgSIDmczkAI3LjLNnXSXuB4sdCOyFbjniZAxSU/eH/mADJZGWjx/SGInU19oiE6GbCPwnF4eI0gc35cQYXU1uf/uXQigmpKJgEj0SLL2zAgTPjvmzDjuJ9jM6QA4vKp4JzRHafE3BMxuD20atpMtPMa34/G/dowHkwcxBMvQWbaRGbGko=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 05:34:34PM +0100, Frederic Weisbecker wrote:
> Le Fri, Dec 19, 2025 at 09:22:19AM -0500, Mathieu Desnoyers a écrit :
> > On 2025-12-18 19:43, Boqun Feng wrote:
> > > On Thu, Dec 18, 2025 at 12:35:18PM -0500, Mathieu Desnoyers wrote:
> > > [...]
> > > > > Could you utilize this[1] to see a
> > > > > comparison of the reader-side performance against RCU/SRCU?
> > > > 
> > > > Good point ! Let's see.
> > > > 
> > > > On a AMD 2x EPYC 9654 96-Core Processor with 192 cores,
> > > > hyperthreading disabled,
> > > > CONFIG_PREEMPT=y,
> > > > CONFIG_PREEMPT_RCU=y,
> > > > CONFIG_PREEMPT_HAZPTR=y.
> > > > 
> > > > scale_type                 ns
> > > > -----------------------
> > > > hazptr-smp-mb             13.1   <- this implementation
> > > > hazptr-barrier            11.5   <- replace smp_mb() on acquire with barrier(), requires IPIs on synchronize.
> > > > hazptr-smp-mb-hlist       12.7   <- replace per-task hp context and per-cpu overflow lists by hlist.
> > > > rcu                       17.0
> > > 
> > > Hmm.. now looking back, how is it possible that hazptr is faster than
> > > RCU on the reader-side? Because a grace period was happening and
> > > triggered rcu_read_unlock_special()? This is actualy more interesting.
> > So I could be entirely misreading the code, but, we have:
> > 
> > rcu_flavor_sched_clock_irq():
> > [...]
> >         /* If GP is oldish, ask for help from rcu_read_unlock_special(). */
> >         if (rcu_preempt_depth() > 0 &&
> >             __this_cpu_read(rcu_data.core_needs_qs) &&
> >             __this_cpu_read(rcu_data.cpu_no_qs.b.norm) &&
> >             !t->rcu_read_unlock_special.b.need_qs &&
> >             time_after(jiffies, rcu_state.gp_start + HZ))
> >                 t->rcu_read_unlock_special.b.need_qs = true;
> > 
> > which means we set need_qs = true as a result from observing
> > cpu_no_qs.b.norm == true.
> > 
> > This is sufficient to trigger calls (plural) to rcu_read_unlock_special()
> > from __rcu_read_unlock.
> > 
> > But then if we look at rcu_preempt_deferred_qs_irqrestore()
> > which we would expect to clear the rcu_read_unlock_special.b.need_qs
> > state, we have this:
> > 
> >         special = t->rcu_read_unlock_special;
> >         if (!special.s && !rdp->cpu_no_qs.b.exp) {
> >                 local_irq_restore(flags);
> >                 return;
> >         }
> >         t->rcu_read_unlock_special.s = 0;
> > 
> > which skips over clearing the state unless there is an expedited
> > grace period required.
> > 
> > So unless I'm missing something, we should _also_ clear that state
> > when it's invoked after rcu_flavor_sched_clock_irq, so the next
> > __rcu_read_unlock won't all call into rcu_read_unlock_special().
> > 
> > I'm adding a big warning about sleep deprivation and possibly
> > misunderstanding the whole thing. What am I missing ?
> 
> As far as I can tell, this skips clearing the state if the state is
> already cleared. Or am I even more sleep deprived than you? :o)

Get some sleep!  A good night's sleep is one of the best debugging aids
available, even in this brave new world of LLMs.  ;-)

							Thanx, Paul

