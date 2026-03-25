Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADDFB106B50D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 12:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 210EE6B00A4; Wed, 25 Mar 2026 08:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1776B00A6; Wed, 25 Mar 2026 08:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D7B46B00A7; Wed, 25 Mar 2026 08:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F17ED6B00A4
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:14:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A3F428C535
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:14:40 +0000 (UTC)
X-FDA: 84584478720.13.819FFB1
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf16.hostedemail.com (Postfix) with ESMTP id A7C84180005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:14:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=zu6ayGgX;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf16.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774440879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlG0lXGt3ihgGzr2zmzy5cEjDh7Y5/V+vvfJk0BQROA=;
	b=nMNNuj9YThZZEkJdoIgiwvREYbCCOAxyxgQwQKkXHOT/tGjmcMgDwB6Lazq31qSi17PNcx
	ZJ79Z4wd1M5JgAkaRoHb+cCjDnFCqiIbNWF4yjn/kXw/o2/YO8dOJ38alJTcWqtOfK6xle
	nHsx62ZV867LfiCSw8oqc+YzV5FL+Mw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774440879; a=rsa-sha256;
	cv=none;
	b=5xUCcwRUcvLIYA/YTIUA+4Ik3FxbrqU8+pOqpbtfw74LmUEligWABqaxUEeCtL9zYIWxFw
	CXf5VcHiD1NcbSZ1nZWj827BqnM7EeHQas4Ox4QvuUT2TWeh1L88OMEwbJYqCHG2CRlS9a
	mfPQotk49LDQ1hmGDvqu08qVE5P1jQk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=zu6ayGgX;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf16.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 6AD19BDCF2;
	Wed, 25 Mar 2026 12:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774440876;
	bh=qlG0lXGt3ihgGzr2zmzy5cEjDh7Y5/V+vvfJk0BQROA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=zu6ayGgXCX0hcZJvTh3J9FChG/6KiLH3P1J7k0JVvWTPTPwZtvYJVhLyJS5uBHtdC
	 6CcIxgxYmZBERel4KjS0dtjFi+Cizpjmz764CTTjAyJAxloip9zr3IM5unS/Ll578z
	 Qr+w0As2/AEnYMg2xU6dWsULHH5gulRX1tOolGdk=
Date: Wed, 25 Mar 2026 12:14:35 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 0/5] mm: zone lock tracepoint instrumentation
Message-ID: <acPRq1YPeGR8EqMB@shell.ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
 <aa7G1nD7Rd9F4eBH@casper.infradead.org>
 <aa7XdpIVtLFS3FIu@shell.ilvokhin.com>
 <aa7dgQDMEz34eadj@casper.infradead.org>
 <20260309151317.7bba06dd@gandalf.local.home>
 <aa8xawMxLeUjkyHx@casper.infradead.org>
 <20260309171700.063318b5@gandalf.local.home>
 <abhAoF5EpiPigsx7@shell.ilvokhin.com>
 <abv4riGLlubast8v@shell.ilvokhin.com>
 <20260324163918.1a3c5c960d85a4243c9ae314@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324163918.1a3c5c960d85a4243c9ae314@linux-foundation.org>
X-Rspamd-Queue-Id: A7C84180005
X-Stat-Signature: czkinedd8jgzysa1snukdaqsnj3uwiwb
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774440878-115464
X-HE-Meta: U2FsdGVkX1/S2jK6nEqVhydqxMqSQ5FVhMKz2poTy8GZCTMx3mWzodhEB0smi9RxjBNASh1ehYzld/Y130GirebU/Ruvu8t5sUYIGuyY40Gfc6WlGAQBtvQRc1QHvx6zPslV0UBHpvJL+zsBmo9Vim3DJJwv17LEJQ8vWoqH0+kbBujQT1btnfgmU6IFm2dfPhyt+isAQbvvcMkIJXELfPeanCS2VM+IwJxaolAN7ibsvS4DzczjKPuOo/RITqXYkf2WG1ui8KcgYqKS83u0c46TRP6vlk4R4o45IprV/N91YlipHMbKlu1+jj10JEIejiJctaFG5Is4O/uFDI8+s7A8ve1eYLEU4zWxm/A0mnR8rkmYxJJQ5RY2c5KS3xUfdp3lQz4ShddzQwb71LLEZ/kGTRGa7kXQs2LRay36y/DHqSbk+Y91Rgai3zVyNEIG8MMBCxYfMyousO8kJWhi3pPAUbODeP6xdpf+1Am++m7pFWlEorK3jamu91Qn1dIza4OPtC1Mdyz3CihiBcs7njlqHnuDfKyW4sheuUl98RqWvCCWr1hKgLoaUiKcOWSHQWwuRNYyW1Iq5p3btULQSjyjZnQXjESs/vywu026EHCkEZOhHIM6t8qKHCiZjACGRPWiNOGnIABLk9qTDpmxyItazIf71AWpgGNoRIjI3X29d+2Svvy/YD1YMtKSnBSwiEkBQMASKHNfsqLESeIb0e0Ckb7NGabB/e0Teh4PxLZnh0Hl40AycOG+uOsszDoHsvj/KAJRf2Wv4B6aYIVa/iLv9GVTO/vgxMrEGIWMUCwqUtnDUHMX5iPCBWFPsHvdBXDwr1WDhUbqLLWhLGrVazrkR9qRaps0R0HiiEp8/k6bLhiwew0VSm647sIpW0CWSaLvg1xePiE3nhPtY2fs35Zy+yYdAO5tvoQvxyM5hDpz0+tgRAlmvv6Di2kc0Ad4kI3ZnODauIVqe5/nz7K
 jA0EhPBT
 u7SJyvldgmH02XmorT2lV81TM38jqqF1fPH23NbrX6qpEG4v0VvcZcDABhA0wiHVTGo5Gp7ruD4E50HJe3NXa7P3hQYzHnK3xj2gml1A1V5G4mqi01l8PxMqryK8OuYTIY4kx76ZkXdmECT5XSlBHktEwkdq++fCs4WS5f3sNUzrSmZ7qsNTSm/JNw23cKNwuFApbPXUxE7YhzAxYptjv8pmE7K3RzDZ5GImfAxBn8AEK92CyzmOMWUNdr5O/rHduwfcvU2L9onk2k/uYBw4CSUPTdPVxsRbybhDGjvhQNViIXJ4xLiyXSTCJzimVIrXdjBan
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 04:39:18PM -0700, Andrew Morton wrote:
> On Thu, 19 Mar 2026 13:22:54 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > On Mon, Mar 16, 2026 at 05:40:50PM +0000, Dmitry Ilvokhin wrote:
> > 
> > [...]
> > 
> > > A possible generic solution is a trace_contended_release() for spin
> > > locks, for example:
> > > 
> > >     if (trace_contended_release_enabled() &&
> > >         atomic_read(&lock->val) & ~_Q_LOCKED_MASK)
> > >         trace_contended_release(lock);
> > > 
> > > This might work on x86, but could increase code size and regress
> > > performance on arches where spin_unlock() is inlined, such as arm64
> > > under !PREEMPTION.
> > 
> > I took a stab at this idea and submitted an RFC [1].
> > 
> > The implementation builds on your earlier observation from Matthew that
> > _raw_spin_unlock() is not inlined in most configurations. In those
> > cases, when the tracepoint is disabled, this adds a single NOP on the
> > fast path, with the conditional check staying out of line. The measured
> > text size increase in this configuration is +983 bytes.
> > 
> > For configurations where _raw_spin_unlock() is inlined, the
> > instrumentation does increase code size more noticeably
> > (+71 KB in my measurements), since the check and out of line call is
> > replicated at each call site.
> > 
> > This provides a generic release-side signal for contended locks,
> > allowing: correlation of lock holders with waiters and measurement of
> > contended hold times
> > 
> > This RFC addressing the same visibility gap without introducing per-lock
> > instrumentation.
> > 
> > If this tradeoff is acceptable, this could be a generic alternative to
> > lock-specific tracepoints.
> > 
> > [1]: https://lore.kernel.org/all/51aad0415b78c5a39f2029722118fa01eac77538.1773858853.git.d@ilvokhin.com 
> 
> That submission has met a disappointing response.
> 
> How should I proceed with this series "mm: zone lock tracepoint
> instrumentation"?  It's not urgent so I'm inclined to put this on hold
> while you pursue "locking: Add contended_release tracepoint to spinning
> locks"?

Thanks for the follow-up, Andrew.

My current plan is to focus on the "locking: Add contended_release
tracepoint to spinning locks" work and drive it to a clear conclusion:
either by getting feedback that it's not a good direction, or by getting
it into mainline.

In the meantime, it seems reasonable to drop the "mm: zone lock
tracepoint instrumentation" patchset from mm-new to avoid confusion
until the direction is clearer. I can revisit and respin it if the more
generic locking approach doesn't pan out.

> 
> Please send that v2 sometime and hopefully Steven can help push it along?

I'll send the next version of the generic locking series soon. Any help
in pushing it along would be appreciated.

