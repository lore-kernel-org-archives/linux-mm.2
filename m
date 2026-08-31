Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F2A9C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CC2E6B0088; Mon, 31 Aug 2026 03:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37DF26B008A; Mon, 31 Aug 2026 03:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26CB16B008C; Mon, 31 Aug 2026 03:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 03FAE6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:36:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8641640389
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:36:24 +0000 (UTC)
X-FDA: 85160756688.28.1CEAB98
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf05.hostedemail.com (Postfix) with ESMTP id EBD2B100003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:36:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=nq4JVzso;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=pk91fDTw;
	spf=pass (imf05.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788161783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0bbLn43OEfzJk6RijiG0hY9eLwY+qM7uVXluXMN+YSs=;
	b=1DnZgfDvjnuX/Rf7DyAxbPtRJdtR3RpGUnrjw0v+NWLDDsZLFMavFkwt53itw7cbqiUsmK
	zhYr8Utw72E68caQg70BGPHRW+uAqV0Z1TMLD7b6R6cd53RWwrJJG/fep5lRSWQHv5XIWK
	2XuW64CSnaTjSrF5a+N4fnLuWeIVWiI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788161783;
	b=jfbprmRx4IDI4lUEPsfOOYWwD7GDbiMxUBdhwL3e/d1Qvtt51RYkS97FRx0ELFpJOuge0S
	KHnSgpV/oP9VE/6WJ5I4Sxip8y5so1FYvJVRy9Icfsxc5lCaqOYDGdbGWhF2PmuXBXA24e
	SiPozuUgUX7VFoFqKdlMyFjVvVrPBt4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=nq4JVzso;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=pk91fDTw;
	spf=pass (imf05.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Mon, 31 Aug 2026 09:36:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788161781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0bbLn43OEfzJk6RijiG0hY9eLwY+qM7uVXluXMN+YSs=;
	b=nq4JVzso6agIIEJPtT+hA2jj6xB08NNe45cLx3b3da5REQJup3Vb5gX/bgy+epwACYFOwh
	4dmrOIEwuY26RvfhCQapR4BZRlTBYX8V9rIvVQdNqVZtO9KcX8cY2gPUAvu7eG1IUk4zWI
	iGQf6n/EHr3gsDVe8aj2pFL/0A65eG2jbRDrih1dS473/GiZE0uyEJDNlC2egaMTnbXRGM
	I0XJQ4EsLkyrO58e8EV7+vj7II5p+fmDJfFCHdFbMJyuZD3zYw5jR1Vz6jk6oExsjbzlZX
	KRTFOrv9cQRhCIMu5h9rUFqvjPoLMdr2d2IYVQJDRkrwgFk+D6SvmF+ajLcFWA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788161781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0bbLn43OEfzJk6RijiG0hY9eLwY+qM7uVXluXMN+YSs=;
	b=pk91fDTwvh9wOOk+diFwBjcIFfkAtuIAvaITJVIRjHrxu/tDM8ZpStQUYGvAopCfp7Lifw
	XzuXrIPEv7O0J2AA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
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
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260831073619.Ssq-wt7s@linutronix.de>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de>
 <20260828135947.GU776954@noisy.programming.kicks-ass.net>
 <CAOiLmNHrbXeTY7zoNodmaZUoMWf+NgvGvZ_LjfWD-1sKAoiLeQ@mail.gmail.com>
 <20260829084901.GA776954@noisy.programming.kicks-ass.net>
 <apLxcg3Lgy0-nXA4@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <apLxcg3Lgy0-nXA4@casper.infradead.org>
X-Stat-Signature: 4gth31ifenq5qo1uhkicbe95369msni9
X-Rspamd-Queue-Id: EBD2B100003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788161782-160474
X-HE-Meta: U2FsdGVkX1+0jhra48Scjc0QevP98BucljVm1uxyCpMbtpZ0uKDV1FLmp2lh3UwTZbkBGhhwSnJG8QYbKOzgRhy1fg7xeg4TJ3Rzadp+rnO7r/9shqOdhCsMZ2YWT+xEhQqilXI3eY+6MK0FEVy4GPaPiP04JX6RwOzdJfqhvE1RjAwogkW5HQC8BMvqDctetYMfTsuzUAs15MKe31Piw2dQXpfBxXpEITr4j1mDQH4F9SBT0Vl73i057R4ANtTlVAUVVvw4iHM5p5BILUND05xBtP/0hMOmgcsxXuICTkXFLjv1enWy1R2sErpeRoAKHDXBFRL7xfTVJjqOSW3npP8uC/tR4yw+0qjIfl1rd5RCAfjJ5PqfygSsv12iD8w93tDczokA8nMTCQM9BzTA4yeacAvDoHEAd2xNLsmw4ku9ClBB58EVfWAgso0Tno64zuSjww8AbkfW4qRU2Cdvt2UNsfKB3k0EZx9SjFFA0lt5sPqNmOFAHBFMWruyxRW6rRPc7zq+FftodEkVFfE0mPvH26AB+uzl2XJHu0LMXwhOEazwK73qSlff8gUdRNZ+y1qciPPSBEfNDm1oAgmB6/fsiyETE3TNS2oPnE3kWqi4peXP9Xgp0jwHkgVfif8gdM8IWlcYGxS7VqtAf9Rw39dMCSOPhDR+ln6eyLUatKy6MzorQ01pJGNZhlbsGSPgmGYS90Aoy72uvV6tmp+0aguPsW3cJG8hQ5iAevw/WlC74Z4UOPbr7UCCQXxuBjzs10xsPnFro0WfOrcUeieRAbaIDqi76CdqxD2t1vYoqKzn+NiO4tLg1pshaFhFY1X14bARFBJxNi78GoOoDiEZYXHnrJ2Lr/Gou2y0rlxuLOYoVrUn/bSpM9k21iyfZi4WtZkWU1ZqtVqQahuyRlTTean3qgOhHAVIvm4LhpEU1/62FVToUyyvtA7TweLGFdVHOShlc8BtYs2e49KtQlU
 OR5x00R/
 OrXf9yjqw7vdVFh0UfKqES4Dci9RUgnkHZbtz6Hhpb8RRPLjDHcbsyhIfV/AW6yfyBgdbx6oeKk+XlRktP/fjHCanwGP6l08iRNzf7bSjQLYteimdrDlzOeGgSagum1Ew9WTc3xgCKE+Qd4wDQIspug4FkbWeL6plm+qk3jJqJL0tJ0anVDx2yRVC8BZrZqzDv3Lx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-29 15:49:22 [+0100], Matthew Wilcox wrote:
> On Sat, Aug 29, 2026 at 10:49:01AM +0200, Peter Zijlstra wrote:
> > > On PREEMPT_RT, it is necessary to skip the call to
> > > alloc_pages_nolock_noprof() from under pi_lock, since with that
> > > configuration spin_trylock can end up needing to take pi_lock. But at
> > > least on !PREEMPT_RT, there is no risk of deadlock.
> > 
> > Yeah, which puts the lie to that horrific hack Alexei did. We should
> > probably teach lockdep about spin_trylock() not being safe and see the
> > house of cards crumble.
> 
> Why is spin_trylock() unsafe on PREEMPT_RT?  It's not intuitive since
> one can mutex_trylock() in interrupt context or under spinlock.

no, you shouldn't do mutex_trylock() in IRQ. There was something, I
don't remember but that is the reason people use semaphores because it
is okay to do down_trylock() in IRQ. It might be unlock path. 

Sebastian

