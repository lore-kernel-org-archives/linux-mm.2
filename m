Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C337FCD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 351A86B008C; Fri, 29 May 2026 04:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DAFF6B0092; Fri, 29 May 2026 04:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CAF96B0095; Fri, 29 May 2026 04:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 074D66B008C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:49:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B7B6C353D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:49:46 +0000 (UTC)
X-FDA: 84819834372.13.AFCBAF2
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf24.hostedemail.com (Postfix) with ESMTP id E9966180004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:49:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=PezPME7C;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=hXpBCHC4;
	spf=pass (imf24.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780044585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RIQTzMrAiz60EQXjnvZkMfXRLxi3s6ETa0YnTZQN3V0=;
	b=1kLGwq3sf+31AR0XnvJe8TKXkYihJ8pZahPh+IpW88IcscbvuNQbFmDjG/hOYXq8o7Ex9w
	DlJpZs3L0zt78dMuxx78xnJf0guPHf3a9pC7lINSjebeQfW90WrheMjmePcaxQ+PJsfJIJ
	hLpF3FpezulANINPH11wW0yYm3yvXYs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780044585; a=rsa-sha256;
	cv=none;
	b=KVxPUEvuUVzZGGpLTUw6Favbe720fxYbYnBCbd3+xj5j+dFUbHMlhgW06j0waGhEnuddql
	cPdkaWc4/EKMvJMWZpe4ZgZ5WvAYfuu28Fz4Lg32OSQrz8HPX9iopX23EHOM6KWCdCn7dx
	cmBpOrP/q4wor0G4dq4xhRlqx4GEwck=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=PezPME7C;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=hXpBCHC4;
	spf=pass (imf24.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Fri, 29 May 2026 10:49:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1780044582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RIQTzMrAiz60EQXjnvZkMfXRLxi3s6ETa0YnTZQN3V0=;
	b=PezPME7Ck4DYD3pliNLx80vlw7cBwz4loyN4hp4vr99ld5QeCjXUaYDk4HPjJWNIaQnq4f
	0LxxtzVOUWhqIHIH7twCdRAVZ4CLMCdeIYdJe5JdlFewz1xVNoOu78DAFqsfcYlkoIcDT9
	O/XNOzNEuARiVjFPEv7yXpTcaMjFZqQ2LZYMPvDbih3OvYfdJi/vdTvDq7xh8iGIbQTDzW
	yDWvl0x9xn7yNXjZ9k9dcBmv54e/1zv0kJh5cvQZSczWuVAf4haoNjwrQ1mjH9Y00UK3oQ
	6HjviRT4QUJQa+RVtekFJTWsggcUGZeLOBhi2MTnepnzenOqovMnOrV4JCrYfQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1780044582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RIQTzMrAiz60EQXjnvZkMfXRLxi3s6ETa0YnTZQN3V0=;
	b=hXpBCHC4cVaCxy8mohdL9CuJryevkV2GGrSOm/4C3/y0Ka2S2b4kEgKL/boonjNbSwUhFS
	2C4ZWQ/P7coXDPBg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <20260529084939.bWkYVTj4@linutronix.de>
References: <ea6fc01f-5cb7-4a04-9f92-bbd2791fea51@columbia.edu>
 <ahPdDtu3vXfNpb__@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ahPdDtu3vXfNpb__@infradead.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: 1utwhryszfp34mt7tf6axdio5ikmy3ji
X-Rspamd-Queue-Id: E9966180004
X-Rspam-User: 
X-HE-Tag: 1780044584-590167
X-HE-Meta: U2FsdGVkX1+7I8I2KSou953aumLBQF0Uim8CGTyYHMZH3ZS5LTf7BjdtJMETzflig7UG5BYJZjDYWr2P0Jj1xX7btkx8gTqiZXQAElXvhLPWZTQcVb/695x1ahrTYAT2CwL9ZPOrpXQlpZcXQ/dNK+K4mxFRYwAQ301fUTq0LBDLhJiZCoqkHIB8I627Shj3hvhCBEVskCOqc5BX2ibX3D0EBijV80ityzw3HVBf9tkPMPjK4Q7RjpCEg/h12CclzqPdpR+sLDOFxv9hyGjxyHH70b7UCAV9Vnz2ShDhpjBscXTH9C85Wzu+TBsYvc9n3GyY6eC05/CeZp/AvL7nWY21OeczX9IcAeH2f1qxRIIiFN84UwUEh+A1jgvaetAohaOXYv+yoly0HWlHChvZ5DO6MgJOVkA1he+voDdwgh8B+ujGG1DQRN6HOuH0eq4yV1+Xk5fZEaieyf8Szr2846MPvvM1e6EQI9X79/o4Yq5aJasLqPUzYSgV89+WB7jfYbXGoBxt3LgSznXPZYfBEEA0yqBjY/rWftpgTcT26XZrTTwynmWiLRNfJaGcBvz0cRNkxqwtL3DPESeusG+sR5VJDu27IHFBgpeTTkCunrjnob21+hZPO5eOZB7hD8jGS85NrDTn6UIuOSkQfmJQzuAjjqja84Hiz7yLmmn3DlftQXwR3fRCbDCxBPWyAPutpYm8kLLYjtoCa8i2p7mEi/UPTnv6WkLg+yy4JdytoCQgQP7pCLeY5ftoop8fMRM69+lNl7566rUpcQAD19Z4lKJlfx5l9x7WvLDkbMUVo40sJZKyiFW7PmB0aVyeV+GKXdNZfrnRKnSol6HjJrTiWyJkReMpnjNF1M2FfP7AxlWZ7xE/+rZV3dXhtk74uTpUNtrHqWTODns0XGV0VC1UCsG+ZnukTjyw81IN6iNUCzvi/3u8mf3kI68WqIykit2OivNQv896CMAr8EH/VuJ
 bwqMv+om
 8C7HGv7wQ0W8J/me64WeS+APJZNYWavHxJeRx6/sVd2zHJehsCjL+QaFPE4sIeQ1O1qiEijVL1L0CygiWvXmzXd/ZZU3uPcg2/EZJUZ3PrcxYqjKMftbLNdA93Bw0MrKCCeC6+bIkBsGnNh3lcaBnu82Cv55WA0GdxFKCyXDRpLuwUf0kddQT6JFDYdusTFo8wGTQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-24 22:24:30 [-0700], Christoph Hellwig wrote:
> > > +	local_lock_irqsave(&bio_complete_batch.lock, flags);
> > 
> > Q: "Is it safe to use local_lock_irqsave() here when called from an atomic
> > context?
> > On CONFIG_PREEMPT_RT kernels, local_lock_t maps to a per-CPU spinlock_t,
> > which is a sleepable rt_mutex. Since __bio_complete_in_task() is specifically
> > called when bio_in_atomic() is true (which includes hardware interrupts or
> > execution under a raw_spinlock_t), attempting to acquire a sleepable lock
> > here would trigger an "Invalid wait context" lockdep warning.
> > Would a lockless list (llist) be more appropriate here to avoid sleeping
> > in atomic contexts?"
> > 
> > A: This seems legit, but I'm not super familiar with PREEMPT_RT. I don't want
> > to switch to raw_spinlock_t, as it seems like that would add unnecessary
> > overhead on non-PREEMPT_RT kernels. I think switching to use local_irq_save()
> > (as is done for the per-CPU bio allocation cache) should work.
> 
> Adding the PREEMPT_RT maintainers for this as it is above my pay grade.

The local_lock_irqsave() seems to come from __bio_complete_in_task()
which sounds like preemptible context in general. So yes, using so is
safe.
It should be even save with interrupt handlers and so on since they are
threaded in general.
There is this new bio_in_atomic() this looks a bit odd to detect softirq
context as calimed in the comment. Anyway, on PREEMPT_RT
rcu_preempt_depth() will work as intended. The preemptible() shouldn't
get false because softirq handling is not recorded in preempt-counter,
interrupts are forced-threaded so you should never be in hardirq
context and things like spin_lock_irq() don't disable interrupts. So
unless you do local_irq_save(), preempt_disable() you should remain
preemptible (even in softirq). This might or might not do what you want.

> > Q: "Does creating this workqueue with WQ_MEM_RECLAIM break the local_lock_irq()
> > protection in bio_complete_work_fn()?
> > When a workqueue has WQ_MEM_RECLAIM, it spawns a global rescuer thread that
> > can execute per-CPU work items during worker pool congestion. This rescuer
> > thread executes unbound, meaning it could run on CPU B while processing
> > CPU A's work item.
> > Since local_lock operates strictly on the currently executing CPU, the
> > rescuer thread on CPU B would acquire CPU B's lock, while popping elements
> > from CPU A's list (derived via container_of()).
> > If an interrupt on CPU A concurrently calls __bio_complete_in_task(),
> > it will acquire CPU A's lock and modify the same list without mutual
> > exclusion, potentially causing list corruption."
> > 
> > A: The rescuer should run on the same CPU, not unbound, so this is not an
> > issue.
> 
> This is another area where the PREEMPT_RT/scheduler folks might be able
> to help.

Not sure what the question is. WQ_MEM_RECLAIM is one thing WQ_UNBOUND/
WQ_PERCPU another.

bio_complete_wq is WQ_MEM_RECLAIM | WQ_PERCPU. So it will run on the
requested CPU. The container_of() and local_local() looks like it will
access the same thing but having a WARN_ON() if they don't would be a
blessing. Or just use this_cpu in the worker FN to avoid all this.

The need_resched() check in bio_complete_work_fn() is bit odd. So if
need_resched() is true then you want to leave (and you care !PREEMPT
kernels). On PREEMPT_LAZY you could just continue as there would be
preemption sooner or later.
The bio_list_empty() check below is futile. If it is empty then you
leave doing nothing (so you could just leave without the check).
If there is an item, then the enqueue "thread" should have invoked
mod_delayed_work_on(, 1) claiming the work. That means the
mod_delayed_work_on(, 0) in this function should do nothing because the
work is already claimed (so you could just leave skipping the extra
work).

Sebastian

