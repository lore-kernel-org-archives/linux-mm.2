Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A041CC61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 08:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CEF26B008C; Sat, 29 Aug 2026 04:39:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6805A6B0092; Sat, 29 Aug 2026 04:39:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56E916B0095; Sat, 29 Aug 2026 04:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 346EA6B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:39:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B52781C2254
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:39:44 +0000 (UTC)
X-FDA: 85153658688.11.5A2470A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 48D821C0003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:39:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZahZMba6;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787992783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RETR9ZdOPAaJvJ2OaRnDzRNeiap5w2m3NE8auivvriM=;
	b=kMoiKLvQwTKm3tnzYnBqb9CIMWwRmfQw0Jd4rxfP1ydiy5+HsdRdnAJhFWvv6DQNMZLIb1
	kRA3sXphI+9murwj1ORRs0aT8QIytOoqHi6caB+bE5kqqxsoZR2aFP8EcQAtHIUh0+7o8A
	zXEohUwq+I0itKDFNFml/vvvixdr+Qo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787992783;
	b=JG2uH+RXd6Bks+InOTf6J3A5WbNF784T4aGeJNkBFiuepglAa2mAV5bJePw86tfhVSrMVe
	XttA5555pJNswEcyIhGBTXU9+jeQLjcen3IWEaOMerqsXUs2Zatw9f+XGbqKuXcbGixorr
	WrfGPiCmwE3j7rVs4xjCDUOH4JPxmzA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZahZMba6;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=RETR9ZdOPAaJvJ2OaRnDzRNeiap5w2m3NE8auivvriM=; b=ZahZMba6YhGKTDAO0it9zThjzz
	qVFXjLyX9C94Dx+HFaJOa88kQDZap5Jeb+13KyHd0/9uToz0Dt7AlGI55zenIlLQBEqoczN8iuTu0
	lcZroASoO7g7JUUzZYe4zw9Ryu9lOmTI3fBvMBTjU4+nBPFQsw8pVqnvRfq/GHWWy1JqOB796HsqN
	N5s4wqHnJiC/+ySxurnFsFV9JdZLBGXTrp5TPvCQPfJhjg93D0WZuA6gzN1D4w2gkn0WMeJq70/9e
	F/QsyB+1jst0mjCSS8+68Sg0INtvJS6/UK3fv7jsyJMn1K81YfUfBNGA0dIJwBfdpEmOOT4MXeKjs
	V2Ea1z2A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0Eb3-0000000GD4W-4BR2;
	Sat, 29 Aug 2026 08:39:30 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 72E64300382; Sat, 29 Aug 2026 10:39:29 +0200 (CEST)
Date: Sat, 29 Aug 2026 10:39:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Stevens <stevensd@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
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
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260829083929.GZ776954@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828120408.GN687043@noisy.programming.kicks-ass.net>
 <CAOiLmNHWGSwAqH815X3JWMrQCc2nh-fRNsNZ0hjQGv8JvFndag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOiLmNHWGSwAqH815X3JWMrQCc2nh-fRNsNZ0hjQGv8JvFndag@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 48D821C0003
X-Stat-Signature: ikf8w4uytjrr6gnxnx58wbkbqou4wahp
X-Rspam-User: 
X-HE-Tag: 1787992782-366965
X-HE-Meta: U2FsdGVkX18ZF3J2/zQWwWDyH3AKJEkxxhXk/04fixTXIbPrd8ok2EsHNaPc2HFDhNUC50v6z6dSxmWbY7i/96HLiBe8DC4iOdbD6jphmXZUl5HQdLGOV6mscqWw84Qz5l5e48c3yDe54NK5QdmR4J3d1QO9LRHFvHUnaEPU589yDu6NiVHG/WiE6Z64h6xWvY/p4wyJslbMmXF4/gvEkcqiZ9OkP+ZS0GCxaQeQnpOOaoHEL/5/DGfGlmFAcJqxMU7k4XkfRZp2qGLXsDmy0ezYWhdWe+8Q+Oxa9tlphScUGql7DLj0wH0Yxw5TMHyR2YJ/TH/TFt3ByISK2rkt2DyvVu3pBoijuYnaeTK47iJMvfhS8RJNeSwN6FrxPkLj9JbRLrHcbecuUnRIl3rcmC4hChGcysmgv9JFCgHMLjwqbqeBPcIBax+3mFskz9pz27Z2sajdJ4ILH3kKOgMPAehHqpe/L5dFkdU7SgLruLGCArWpy1RZeTmX2mtdQetq0/QVirDJwv7A/BCJFTIYvMBy6vCtv7JZ1HJQf4lp6uv/pzltT3jbU/lVBYIVUtDYHm6i9gfHKud3On1R2jGP2FLpotcb9adLv+TZ9M637FYCRCrURre+kWgkV3tO6BjTCWxwhhR5Psw6sJFDwUrAGprluHwBFykA+DnyD421chYbclLh/lJH4IVJKd1onHfsxFhRQOexV0LI3q2FqK0v9JPBs5GarOlTwfu+dCNGkA5sz9mPy6o7oryVEIEr+u8bEA9DhSD1WgLKa10YpSebsedlshP4QrXehQ+O63TK43XpHoDj22xYDiZkJ8JjJ0WDeCqW+06wICTjBawuc+ucWEgQDYgIyoERWusLaaz2qUNMFiMKQgdNCPUye22SpJUTARgdBFOCVxL5HPspXl+mj0XLvBiEvBLn2ZxdwcXrTsK3CSgez3VqZrioBI2zJZaRV9wS41SyED6RLvX2foQ
 TikQF3HP
 XME6OI3Nqz1U/1149gbpN1aU8i2H6rftUqRhtkANvAOrjoDda8zYwcKaKJhYRtt+k18t7hs4mLpXK4N37Rsl/EGUmrUPlOHqZaEBb+vLpLKnAJt1TnMtCPC3RhN0s9Xyy/Rm4VvIyQLO+8RHc4CNA3ZenmT71bQ7BpcveN62WIbR+8oYvCRlm2Q74O5pKbpf0JrxGzcLQSmAqMzyAU45u0yKLGn7SzUkB3NVEbB+18iJiAQLw4ji9WLZpBse2xpICfbALiPt3YbtbNYZjtGtsU8pfiFo8kAOQgYx7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 05:18:05PM -0700, David Stevens wrote:
> On Fri, Aug 28, 2026 at 5:04 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Thu, Aug 27, 2026 at 04:29:44PM -0700, David Stevens wrote:
> > > @@ -4320,8 +4319,18 @@ int try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
> > >                * A similar smp_rmb() lives in __task_needs_rq_lock().
> > >                */
> > >               smp_rmb();
> > > -             if (READ_ONCE(p->on_rq) && ttwu_runnable(p, wake_flags))
> > > +             if (READ_ONCE(p->on_rq) && ttwu_runnable(p, wake_flags)) {
> > > +                     trace_sched_waking(p);
> > > +                     break;
> > > +             }
> > > +
> > > +             if (!ensure_stack_is_present(p, &need_deferred_repopulate)) {
> > > +                     WRITE_ONCE(p->__state, TASK_STACK_RECLAIM);
> > > +                     do_deferred_repopulate_wake = need_deferred_repopulate;
> > >                       break;
> > > +             }
> > > +
> > > +             trace_sched_waking(p);
> >
> > Absolutely not; ensure_stack_is_present() must not call
> > repopulate_stack() while holding ->pi_lock. Not happening.
> 
> The optimistic fast path for repopulate_stack() could be modified to
> try pulling from a pre-allocated pool of zero'ed pages. That would
> reduce the function to a couple of memcg_kmem_charge_page() calls and

Afaict memcg_kmem_charge_page() ends up in a local_lock, which is a
spinlock, so that cannot be.

Most, if not everything, in mm/ is build around being preemptible and
thus not suitable for use under raw_spinlock_t.

> then vmap_pages_range() to repopulate the stack's page tables. That

vmap_page_range() can end up in the allocator, which I suppose is ruled
out by the vmap having been populated before, but it still has a
might_sleep() that will scream AFAICT.

> wouldn't require touching any locks except a raw_spinlock protecting
> the pre-allocated pool (or just make it per_cpu). In terms of cost,
> this would involve a couple of atomic operations for the page pool
> lock and the memcg charging plus non-atomic operations on 5-10 other
> cache lines.
> 
> Is that within the scope of what can be done under the pi_lock? If
> that's still not happening, I can see how things look if we always
> defer wakeup to a workqueue.

As long as it really is all atomics it should be fine. If there is a
lock, it must be raw_spinlock_t, but ideally no new locks nested under
pi_lock.


