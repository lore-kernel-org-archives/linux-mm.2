Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAA75D72347
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F68F6B0458; Fri, 23 Jan 2026 03:46:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A3DB6B045A; Fri, 23 Jan 2026 03:46:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AFF56B045B; Fri, 23 Jan 2026 03:46:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3792C6B0458
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:46:54 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C78B61A03BC
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:46:53 +0000 (UTC)
X-FDA: 84362598306.06.48AEE8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 460E91C0002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:46:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pMYi7O9W;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9JX+DeBwl7vjVTkeg5lPNjIJzfn7qArJKhN8g81jxQ=;
	b=AOs7BsUV3NN3lwV6TD2kMIeG3kJBE5kuH3V9CLydDuPjOSzdMrGTdvZEYtB4l18SG1xqKX
	gdGF+imgIjjzPKLzRsQNGVoerRRPLRknPacvhAwyDur9QbG00Bj8A5pxvkgTlaEY8MRr5G
	aB1Q8B2DJjKwnT/meBm+0smAJU2rvU8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pMYi7O9W;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158012; a=rsa-sha256;
	cv=none;
	b=jz2i2Hm2A6ByuGWRKI43bCw0mjIbpAR53Q5pg3vw2yBIQCdfrAiLRtB+zGqH+ryYxY3Du+
	aeNe5btfi0zGd1FXLJFpNQvpr9X3tGyOFhRRwHcrZuWYK94050z9rW5PmT0/ut/zJtQ83E
	HaYmgR+ipOSqTPLo9DKkQt2x4mnSLqU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B347C60010;
	Fri, 23 Jan 2026 08:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8B9C19423;
	Fri, 23 Jan 2026 08:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769158011;
	bh=zlDYEoOkDwoDamgPxSwYuVDpDkFq4ttprobmkbfSa0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pMYi7O9Wzk4xL+ptKZFskBEAy2sMbDOm21rkjCBTr3+31p+kgjN5ghCT3gKWYyQe5
	 eVaJBjV5V/Fo2ORr2P0xGrNN2fd8bluNWvUjOslB4mXahJXHK0aZ9WFz5EqxE0fI+m
	 RctiRAW9zH8dGPXigIaHsb5MwbrbqD2Jt27aYPxd+LiJlrrd5gBQ9Gk/MmjYNqJ/Bq
	 RU0zkQGrxBD7PcRxiucWCLvsDrBfeY/NdFZpUItPCUyvz8m5ksZLYTBz0ci6NHedY+
	 E3+W+e00I8qWZvMeCt91IM0DEwfMxoUmnHe2vCUWCYhpUXmGi+EMly11xgKB24ngut
	 n1yI2xhLvSrvg==
Date: Fri, 23 Jan 2026 10:46:44 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Waiman Long <longman@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v3] mm/mm_init: Don't cond_resched() in
 deferred_init_memmap_chunk() if called from deferred_grow_zone()
Message-ID: <aXM1dF6o3wwJltiV@kernel.org>
References: <20260122184343.546627-1-longman@redhat.com>
 <20260122112920.2b435873a0cc5f396df5d1a7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122112920.2b435873a0cc5f396df5d1a7@linux-foundation.org>
X-Stat-Signature: jhoh8geoc9qhqrr1nhdj1es4u5m9ccnk
X-Rspamd-Queue-Id: 460E91C0002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769158012-292361
X-HE-Meta: U2FsdGVkX1+7P2fXQa7zrhaPiO+b6lEox1L4YbIPqgkNaOnSe8yz0hkeCe4unX0sJ/bPuZ/tPyDrYunEyGu0quZ2A+9TTfQHTmGO62AetewCUA8wmVx9/S9SFleEdAnnknCFjECVxH1fMyluSRVCgVoU6MayO1kWHIv13LovCSUa39Nxl7znYCb4Z0N8E1eslfhvPSV89ZgcufV9kNRZCKzbgWKTkf1zSgkBNoyOv9T1cGHIYS0A6ITsd7YPXyfgR5ueQ3ibTMv9CuYo2v4o/PKn9/3PpO4Tiop7sq2AlWjgp0/kkzWVfp3P1jJNaS9fxLwk9NzUxdK/lrz+yzBB5wdni775Hs3OY/uRbqP+EJ5Zj7MBwRZWdFas9kVaRURJMU/RrLGpKP2vFXtlMygpUv6OB/e/4VS5HRkHNTzTB5S/s7dH9iV/yvzlLBcaA1aJCmzvycglUdC2imqODhT6tOXu037A2PaKpvYWo2XY09a72a9hAG+TwhYC3YUENCRRckzY2svq9vj7sdouSytkcVV1W0fur8UKcJv6BOghHLpXrg4xvZVAXnl4D0wtgJ5/vwIA92aQJL9GWqeAIJO9aCp2hnX2uHUQ/Drh65Avo2JvFzuBNrWCNL/AGOasXL/HtjPvSnVpuT5uKRgsIt4gTbY8lpu2Svi2wCiyoZe4NXTlvjbzF9z2i/XE5BQ7JbEUNayVHugy6GMTTLt6XGx30qY1ZskeOLa/A2D6GvZJ81HQB9yE27BmolOadA8YGhkvMaT3sSRFcFrInDfcq4pPOYW11/XN6nT43EJ71vtK6QtSKQl90oDt1BZeFYM68/L699FugJ64xYzgNoHKANNq/7BS41WKWTKrUc5mUf4PvNcFH/gZU99ijIX2Q+YmuMfoGIJHvXsxOSncKs66/pcqWCfVMb3DaYcU/Nq4jApBpKv4eCVDwI8bithaTGEQf094woPzGgpNGf1G/AFwAaF
 Z5AO8Jvb
 kBbe7kwiWKhluih7MUECPc5UQ2RU0BWT/FON+uIGf/MO3JOaqcg9+RJ9bNp2COMD38UX84aqcVmdSJgO2RQAxB2YwpYCqwcmImuevsjOUzHCua7B1mm7tu7lBWCZZbsXSSdMuhGo+fabGa75Wxo6/vVE5bHMLvYjlAQfLxM/kvBk8fnAX3qa5twn2h5KqZcoQFwahjfgWpYmcojAajsCC1B5glte4fXF3MDvUuYiwX8XRfjFyvzqyXet23k89LSeSN5caWq59eXMDsLFlYXrLGQGl41TdPBduEtRKaDVS2i9h0P0mcKtqG2wR57zkzUjdl3pRaQ1SoPtlUdMrp9i+cQ+mpKGfrh6b1bE5cGtnCDKK1mbBqa//lEmFNTL8a9rMa2IuEjsbiQN8rMs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 11:29:20AM -0800, Andrew Morton wrote:
> On Thu, 22 Jan 2026 13:43:43 -0500 Waiman Long <longman@redhat.com> wrote:
> 
> > Commit 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk()
> > in deferred_grow_zone()") made deferred_grow_zone() call
> > deferred_init_memmap_chunk() within a pgdat_resize_lock() critical
> > section with irqs disabled.
> >
> > It did check for irqs_disabled() in
> > deferred_init_memmap_chunk() to avoid calling cond_resched(). For a
> > PREEMPT_RT kernel build, however, spin_lock_irqsave() does not disable
> > interrupt but rcu_read_lock() is called. This leads to the following
> > bug report.
> > 
> >   BUG: sleeping function called from invalid context at mm/mm_init.c:2091
> >   in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
> >   preempt_count: 0, expected: 0
> >
> > @@ -2085,10 +2085,10 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
> >  
> >  			spfn = chunk_end;
> >  
> > -			if (irqs_disabled())
> > -				touch_nmi_watchdog();
> > -			else
> > +			if (can_resched)
> >  				cond_resched();
> > +			else
> > +				touch_nmi_watchdog();
> >  		}
> >  	}
> 
> Disables the cond_resched() in some situations.  Can this reintroduce
> the watchdog warnings which that cond_resched() was intended to
> prevent?
> 
> The cond_resched() was added by <dig, dig> da97f2d56bbd ("mm: call
> cond_resched() from deferred_init_memmap()").
> 
> Pasha's 2020 patch replaced touch_nmi_watchdog() with cond_resched() to
> prevent RCU stall warnings.  So I think the answer to my question is
> yes, going back to touch_nmi_watchdog() could reintroduce those RCU
> warnings.

Before 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk() we had
touch_nmi_watchdog() in deferred_grow_zone() and cond_resched() in the
deferred_init_memmap()->deferred_init_memmap_chunk() that ran in a thread context.

I thought irqs_disabled() would be enough to differentiate these cases
because deferred_grow_zone() takes a spinlock, but I missed that with RT
spinlock also sleeps.

Using a boolean essentially restores the behaviour we had before the
refactoring.

-- 
Sincerely yours,
Mike.

