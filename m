Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 981BAC624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3C36B0098; Mon, 31 Aug 2026 10:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8646D6B009B; Mon, 31 Aug 2026 10:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753CA6B009D; Mon, 31 Aug 2026 10:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E9906B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:19:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD11580160
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:19:16 +0000 (UTC)
X-FDA: 85161771912.29.2B7CD81
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf05.hostedemail.com (Postfix) with ESMTP id 22ED2100003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:19:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=IJgNMTIM;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=YDLpBnsD;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf05.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788185955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fY9FkrWPyWj0ZgYccDxYtQRH8Ojx2I+KpYWeK1aZjSs=;
	b=QgkICqkihvqz4BHO5MDvRZOLoCefUIbpbPWvm6QH7hAiX20yh23WTaKv+sJx3Cm2zyx7a/
	JX/dmlaQczvooy6anIIHVq726junUn+Js2gA/ArNiti9eUsT3CaFLDdkTMc2+OdXAQs9oz
	0/ZTeNWuscpbbs58q5sC4Txvm1fazAk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=IJgNMTIM;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=YDLpBnsD;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf05.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788185955;
	b=3ka5tBqHeuJLFBvRKUGJri5eufpo8sVTMxxzehfrYG5fRVhu6axjYP56ZDh8wNymuIBDd1
	3bDnDtE1gET4DslbH9ff5Jow4upJKzOfLzJEWsXkJsVkT54oR0FT39wGxoYXoiU0XEJDVG
	kMKrTBS/wxxUm2JBj6FZBmcDssVMmPc=
Date: Mon, 31 Aug 2026 16:19:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788185951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fY9FkrWPyWj0ZgYccDxYtQRH8Ojx2I+KpYWeK1aZjSs=;
	b=IJgNMTIMa9qcuZqyQE+GWQmT7cQgtDV9HIZlDG+9zc4n8ry57LubvX9cN0NcV9TybkqM3z
	USaydmSmVjyyUm+3MS8IpLX+GPDIICU330OOMpKw/BwMUblf8gAPONtX90GufQu2LUT58s
	1tI2FVuP32tPuYLetmGEy18q/P01FFG6REUmB2uuqv1I73zUrGjcPnKSbrHqfIEyzjOCt3
	Aybhz5fr1Aw/+BnUPkvJngpbfn/GRZfa8uBO6vXA6muOIGleAe8PIfqaSRm+WZq7ui281O
	0b5u8OCx3UvWSblltmM5vardsl8wETIXZPeFqLeW5JOcO/07Dn4k1Kae9t2Tkw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788185951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fY9FkrWPyWj0ZgYccDxYtQRH8Ojx2I+KpYWeK1aZjSs=;
	b=YDLpBnsDa5JKA0InFyvu7EzOe/ogs1h3Xq99G44tWTp3Fqgj4tW3yhLruINH7w66+25ZI0
	U7piwSBCg7GzteBA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	David Stevens <stevensd@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260831141909.WrGjMogw@linutronix.de>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de>
 <20260828135947.GU776954@noisy.programming.kicks-ass.net>
 <CAOiLmNHrbXeTY7zoNodmaZUoMWf+NgvGvZ_LjfWD-1sKAoiLeQ@mail.gmail.com>
 <20260829084901.GA776954@noisy.programming.kicks-ass.net>
 <apLxcg3Lgy0-nXA4@casper.infradead.org>
 <20260831073619.Ssq-wt7s@linutronix.de>
 <0849e5ca-6dec-4cf9-83ac-89ab08364044@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0849e5ca-6dec-4cf9-83ac-89ab08364044@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 22ED2100003
X-Stat-Signature: tgffrmommm1c1z67p7nu89aa7jwbpgab
X-Rspam-User: 
X-HE-Tag: 1788185954-817220
X-HE-Meta: U2FsdGVkX1/ZQMrMcYxxwNY5habDBtY6KvwNxds/HyFzQ/R1tAnNGegWofX8LvAZShdOG7tyB4F9As6+uFkaybK60Rb6gHmdRkKVfRkvBAd3Ud/sNyASFrz4igQQk17KMx3jUpmccGKIp0yOCKJhUqvw43OsH2sLl31u0JV4ZZ4Ky/7MLg5IF8tPWV9dZntZgiZQWOsrrJwce5nxCqpq6kDaOHUk5va1LYfqDnfObuuHsiNuPtUw9hGvWuU3qB6xEg+J1/jJhFvBuXclAGkREY14N1wkpnbNnXzu78IKMnDtZA7Zpd/5sJGDyWuzKKn2B9V2gqFTYO8DU4KKVVt6KlJJYNsU1rS655vwyJ6+w/518WAD+jatUbknb550SXs3rbLJRWzM6YIVPVEBdL7NhL7c6WuSRsALrSnuLkvuPMNon4+FPKsk6yfs4cMCm7v4wQZYMPuSO3jrWOBiKVNh2ZhS6t3S+qzw285WVgtBiWvqCNNXAlB/klH7Y3xGHufjZAdBF3ZKYlncbftKgJ7z6RaspmjZg4CqRrrpVbWvhcIXus8gQd5x7L4uJt1DMdh4xOmAviCTqza1ExbnvNPX9ao9VmsH/TQWnthF8bg61tZsxXfexmpcyj1DYcxFOlFgN7lQ9PUZdRZk39iDdP8H955AP5O8YvUDgpz7XK4VQHxvx9Fye9q1/aO8G/JyBqi+LoieHj0Gj+DF9asDiMjY80cOHtrjAfRw7AkzbIF/79u0Nmz4UMc1K25mhg6PWYUnKcbeYZDSclOr6I5E4jr/Oa/yS4A7WJlT39AVW3ZASrSXOwSZuwyQ2dIFVzkYXYiHvdzE+uwD68LX9cEWPy8doeSBibxv6+dYfmWgSc5zhHG+bBZDD/QoRR6aw7FM326ifotBV4icceSxrboWLIjyNBbUgu3qTVScPGH/FireKGxlbfxoGGqXrD3+3ISv17Zwd5vv/dp/APFg5Xxwe/U
 hmHHSkyb
 S+mDPyYZU7wb/ipbk8q8JnH6Vu+jB0DhbsvVV4+bU9+VeDRljymxT9v349CsGXj6R6cYxBzXebZSnIVUehhgSySedoJkEnjddIn2uis9sUWKZuQk0vseokc+QJZ8uvh6Qlz1QmNhVipLbyZVYE9uI+DvmpEZ6ZOlwQGMwO6Zz+8AQLQHiGP7UcAxJCH7N9f/pLtym30c7/teQECjz5tzt6QJLlAR9vjfNol3vnmenNl8QMLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-31 16:03:38 [+0200], Vlastimil Babka (SUSE) wrote:
> On 8/31/26 09:36, Sebastian Andrzej Siewior wrote:
> > On 2026-08-29 15:49:22 [+0100], Matthew Wilcox wrote:
> >> On Sat, Aug 29, 2026 at 10:49:01AM +0200, Peter Zijlstra wrote:
> >> > > On PREEMPT_RT, it is necessary to skip the call to
> >> > > alloc_pages_nolock_noprof() from under pi_lock, since with that
> >> > > configuration spin_trylock can end up needing to take pi_lock. But at
> >> > > least on !PREEMPT_RT, there is no risk of deadlock.
> >> > 
> >> > Yeah, which puts the lie to that horrific hack Alexei did. We should
> >> > probably teach lockdep about spin_trylock() not being safe and see the
> >> > house of cards crumble.
> 
> Is it already happening then?
> 
> https://lore.kernel.org/all/20260831053846.107974-1-ngocthang2710.1999@gmail.com/

here I would strip kfree_rcu_sheaf() from the kfree_rcu().

> >> Why is spin_trylock() unsafe on PREEMPT_RT?  It's not intuitive since
> >> one can mutex_trylock() in interrupt context or under spinlock.
> > 
> > no, you shouldn't do mutex_trylock() in IRQ. There was something, I
> > don't remember but that is the reason people use semaphores because it
> > is okay to do down_trylock() in IRQ. It might be unlock path. 
> 
> Is it what this comment (recently moved to can_spin_trylock()) explains?
> 
>         /*
>          * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
>          * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
>          * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
>          * mark the task as the owner of another rt_spin_lock which will
>          * confuse PI logic, so return immediately if called from hard IRQ or
>          * NMI.
>          *
>          * Note, irqs_disabled() case is ok. spin_trylock() can be called
>          * from raw_spin_lock_irqsave region.
>          */
>         if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))           
>                 return false;
> 
> Of course checking for being under raw_spinlock_t can't be added like this,
> hm.

Yes.

Sebastian

