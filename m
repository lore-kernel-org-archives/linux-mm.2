Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47E60C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440A76B0088; Mon, 31 Aug 2026 03:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4190E6B008A; Mon, 31 Aug 2026 03:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32F1A6B008C; Mon, 31 Aug 2026 03:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 110086B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:15:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 940211C1E9C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:14:59 +0000 (UTC)
X-FDA: 85160702718.07.9F41345
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf24.hostedemail.com (Postfix) with ESMTP id BCFBB180009
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:14:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=pGIgXFEK;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf24.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788160497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2115nKGBEwObmSrqlfs2WcBhmzv4iDh4H0qiO5lvUM=;
	b=sm/OrzgJJsS4VxTy6MUUuesi77I73yF7YdxZh/oMnRdbtFwRio7Rg4YE2YMxNBHA5zI9wm
	LMAfsaKOANuzn41qFQ0xYNIvz6d3nBDpapXAxv635awu6/+7STS0wyMNw1c6dowUwTrSAS
	bTbZ66XN0VleGpF5WJnaJhFTBsqU9FU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=pGIgXFEK;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf24.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788160497;
	b=k4//0N3CUjNtro/U/TQQ5FAV/7dT8CwqsQkpuH/aVIQCVK5QVSqyrF5oV9aJmZdcIo7GF7
	lCtFoPUSNP7D9i4yXu0ZrzWB0xOB0eAZjP9ZVtEuUSnVw4KMG1snzfKfzC3X2p70lHBGYm
	lpVA1i7txULqoed9fTafcDSV7s/kZMk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=c2115nKGBEwObmSrqlfs2WcBhmzv4iDh4H0qiO5lvUM=; b=pGIgXFEKAN/kTi6sG6t/00uMvv
	+WycgRgKlg/+rvkAKsveOmQTewMEVutHhuo5hVygDJWrzcNnYzE7wD+mQYmhxZKmHutXGdW+zNJ0H
	OyUKRZQJE2oXdf8gdmVvf7G1wf0r5LcVy71HIPmPUrpkyzANAaTHG15lLBvSqf7FaJ+gA2Uq5rV/g
	uj+0F9R8YG0UxT1bpDWxxd/xYyYYqc1wmAynqepmWo4TB9B5IPbw0uCJKDqp/H3ooTXtSvGJdRSlP
	0TMmHkfzu51BKdWUabDiW6kkL6aNKnDGgLILH9HbPwmWZLqpYHo+pm82f0/WFES3FAUGqRxoYI3Qf
	7tFNNdGA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x0wEA-00000009bM1-2gNA;
	Mon, 31 Aug 2026 07:14:47 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E7EBA3002D8; Mon, 31 Aug 2026 09:14:44 +0200 (CEST)
Date: Mon, 31 Aug 2026 09:14:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: David Stevens <stevensd@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
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
Message-ID: <20260831071444.GT687043@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de>
 <20260828135947.GU776954@noisy.programming.kicks-ass.net>
 <CAOiLmNHrbXeTY7zoNodmaZUoMWf+NgvGvZ_LjfWD-1sKAoiLeQ@mail.gmail.com>
 <20260829084901.GA776954@noisy.programming.kicks-ass.net>
 <apLxcg3Lgy0-nXA4@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apLxcg3Lgy0-nXA4@casper.infradead.org>
X-Stat-Signature: c6gnyii53nd3668ynahy59mzbffnex9o
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BCFBB180009
X-Rspam-User: 
X-HE-Tag: 1788160496-201421
X-HE-Meta: U2FsdGVkX185EzyaSwTPDbd71+PBNUBntoj58CQJMuWP4vm2Cj5mbYbExyeptOmHq0uvtmbnylGONS2qDsKbVSvA5ggHQF3RbSe/jH4xfpWvSHjd9JG6HVh41hWIaRnJjwgPXuLnPzt2gc8UyFiSHTV3UJwfRPMnwV0EjD8Xi7gbRf3tRWQnWsC5wnWTDFOFOjuCT6FlyIviwSV7JQBwo59CKqzDdRCI+IlRHOkSl9I5Yu81ugfZcbukKzKPDAWn+B2Nt8301PwO3GuAWHqIzs1yc2c3xEB4yFZw4wxPPlWtRR0gHPgnrSWtdZiTfvHCwz260/VgtAkDIKzSfvIW4E+aq3D+RUSpZmKyk8fWzkR8if859mQTe8H+1xRLSEE1e7m3xcX5ZVdbR79ZOgfB+1uAzIc38MgQPFIRsFD1AXHIdIhHqvFVl1hlj9GtNQwpO6Vjej1NR7sanWdXannQzmfbisdbvzOGcqmypNJKWmsE/UBlaoz9kk5G6PqiXp6dN2zBEjBf7SJhGi4TT8CnCfn15TsIj1MrwuVtj8e99aI583bfK/VZHEwH6EwE14Pu4U1yVI+M5bpYaVrAoe0v4RD/FIizPr7WZu/AF6QiRtN8ap6ZLvZ/zMGPABXnRW0dygBee3Ua22kVd3yFpx7OFczWEU1mvOKxHrIC3zTEjltbFYa7/DHJpKP3zEtQUh8sro3v5HOqsxEXGpZVulihKuu8/6yY/OznhJZRR3jt5P38TsfFyDbWZHdclInUcU19Z0GUOwtoZ3wDd+rnxtwfJ2HuJTWE4PgaIhoKmTgGi+u5bBNLEdd30yM7mkQOh4lA/S8hGMnQvCecJ7Q694zxjYQvYzuvsy5Eb2a21ZJtWr1pPdIxbi94BDXhwr7Znykt1019Xq37blzADbeL0RYpV8OTUvGGoveq3HyzfdW+AJCxmdzbXIddJRQP4pbHVebd0lIA2BdkhQOL1LiNQE9
 YKKMfCHU
 KhYHEq/SBPStfujBc4/BLc8svCmWHKrcXHMV72ceSSz8b90YfR6ZXUq+qI01JDHV6mLcCS+IEJJ8A6Z5c16iC1QMfq44eV1a31TP21oCIhSdNLqw+KqepQAHMOmmdqn0QOnZKY9B2f1cC9WOErA/uexOena17WJ6n4VfJy++h3s7kpf1u2EBroh4aCrmI5oB2imtUY82oXImQ8ZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 03:49:22PM +0100, Matthew Wilcox wrote:
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

We should not be able to do mutex_trylock() from interrupt context.

Because then we end up with an owner that is not a task, or if we
account the interrupted task as the owner, idle that owns a sleeping
lock, which also leads to problems, such as trying to boost idle and
other such nonsense.



