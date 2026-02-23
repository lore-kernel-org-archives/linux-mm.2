Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31AC0EC1109
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EC316B0005; Mon, 23 Feb 2026 11:46:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89A676B0089; Mon, 23 Feb 2026 11:46:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B466B008A; Mon, 23 Feb 2026 11:46:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 623FE6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:46:50 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10A83139C2F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:46:50 +0000 (UTC)
X-FDA: 84476300580.10.6AFC9B0
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3B35D4000E
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:46:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Ez5r3CS0;
	spf=pass (imf04.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771865208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJU/c2ANGiupnU+sNCDAu4d01p6h+HYD6nV72nQ/8io=;
	b=uHXj3TlXXnG9tPkMyh1DI5/S6aC4XbkuxC2IQyFL9CuOOi0NLL7mpNiwfZWmJrflT7SHgh
	SLM7fNLvXc3JLjP5+0WLxaoQELXI0mjdsCvQRIDDZ6MFUYQy4mOqWYDjCxu1FSmcepFJvQ
	yrFKqO6oQtNYNCvj4oyrS0rfY1pGGY8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771865208; a=rsa-sha256;
	cv=none;
	b=0vOkayyn38NA6Sv0L9/kVkkXzTJKELi7vQUHtfl3crm0TgLZAanEDQuVaaJMDXFrX+oz7X
	AvOzv+mZvOjHBCqDYjtNd0KiJdtNSFWM0/+ep/hi185YKUpmwV5jPdjno/j/RO73PjHUu2
	RPjKBYdcUfYllxViSnXAqJ54GkJ2wE8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Ez5r3CS0;
	spf=pass (imf04.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 306DCB2B38;
	Mon, 23 Feb 2026 16:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1771865206;
	bh=TJU/c2ANGiupnU+sNCDAu4d01p6h+HYD6nV72nQ/8io=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ez5r3CS0SktKVrjI5VhlqUZ/251A3OUIM41kfLezdKCG2T+l+22yDhHSpHd407S1t
	 eIOzh1MKKab9MJFHEvCVc0pbOEePdKuMGxRWCD+kXVKL8nmM8Zk4iEGuKOcXo61A8S
	 iPkEJrq7iki2d0E/l7SJ15+1J/j6+hxGHSxWGJHs=
Date: Mon, 23 Feb 2026 16:46:42 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Subject: Re: [PATCH 0/4] mm: zone lock tracepoint instrumentation
Message-ID: <aZyEctoThn0anlz8@shell.ilvokhin.com>
References: <cover.1770821420.git.d@ilvokhin.com>
 <06b2a2b6-d5c8-4522-8e22-10616f887846@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06b2a2b6-d5c8-4522-8e22-10616f887846@amd.com>
X-Rspamd-Queue-Id: 3B35D4000E
X-Stat-Signature: euitrczhy4xdbu5stf9fn45cpr7ep446
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771865207-32744
X-HE-Meta: U2FsdGVkX1/ZX9iCYPLCdU4I7bjH043eNrbmIvY9WvOYr+O9im9aaoPMzjro1d6PODOQP6jqd+fcOTOf5xF+QLhibNXzCWm2XzJMthUcbrZ39i0MkpEPF31sOis33QZk/fx/qNq8LWi4xLuGxuQXZ0j/wZqJEeSGAhuJEgXdri0wHiDfywKZ01AJ3w+YTOAm+McpZFhrOmgljX08iZmlw3/1Q1DoRrt7BDsWTY17hbGLUNFLtp1eAxn14bKraZ85taPEsw6IEBT90SbhBeh7ZwCGwJRe0epN/iyw9su/s+LzeCUwbGGKftXkEYfIo+nemmxTLqHlHT957ng+88MaMgwzzB61IOql6V+zzaajcawY+nCzfPhNLXeQ1FpYGhwxaKh6B8h+CC++i7lg4oHoo7BmKGi3BulEk+D5GvI3F0Us6onJWb03L2pNUVFJvRVhyjY/xdlIQx8eK8Y6hj2aWc63OE4EAdjB7BgFZpv2JMhebCLJYl1i/VXFUNnZ+6TbJbWL5ZYoi+LtQV3QtOkzRpdDlkPF/QUs8JbPAYLoA3bUVT08UkKzmJfTZNA6Ds5TKQNpRy0mkqbxzpw2c5x9EyYR6k40YyboHItCmMtSikazJlG9Hksg6QdeL8fwDVIzlH/7Nkg+w/mrAQsMxb7c6kJjnTWZHM6xFM+RsMDWeA5iK5b43+L7bmUWyPJnORVTDOD0R8tQJ7H1YWnwEWLdqR6l6/Oue0e18j9k6E3o3TABYzvHMsdpOdqdwNvXgNFsjqvQMoENXYRPbtIc2qmIymreVVvf6zc79l6BYttzsY32q7WxwuuJisHN2Bi8Q1uu6dkozwDdKqENTHsfEJBwyHr8Nm4qq6gFKbNRdzm5rW/hpAr7B3b5oUdk/3TPnVNy+OpDrklcE9+21g8yRzSS49CDCOmU6Mu4RVWlwCxDK5QEar7CG0FWELa6HwfCzk+inTHPU2MY2RSZRmAA7wO
 2r4Pzc1G
 2JcNnmD1bUbrwyKbeEWD06WarZgBKeEJ+udCm2USsKUc2hjd2ZnkaQArR9dld+oTl6btr4O7ND5PON/KXW3m3+OmebzSCzXeXm5EFl+JGBPPpp2wz39uLzSAIHZUf+V8WEv1pFKTLt+Ky+6lzG+BvceP0oSoIATIZcEig8EvQ8wjX/qZnnAdHHX/BfgCcYF14ioJk1389mVuqCe18YUYtKK6FYhy3VyuTanYm/XfWAZeHywM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 01:09:59PM -0600, Cheatham, Benjamin wrote:
> On 2/11/2026 9:22 AM, Dmitry Ilvokhin wrote:
> > Zone lock contention can significantly impact allocation and
> > reclaim latency, as it is a central synchronization point in
> > the page allocator and reclaim paths. Improved visibility into
> > its behavior is therefore important for diagnosing performance
> > issues in memory-intensive workloads.
> > 
> > On some production workloads at Meta, we have observed noticeable
> > zone lock contention. Deeper analysis of lock holders and waiters
> > is currently difficult with existing instrumentation.
> > 
> > While generic lock contention_begin/contention_end tracepoints
> > cover the slow path, they do not provide sufficient visibility
> > into lock hold times. In particular, the lack of a release-side
> > event makes it difficult to identify long lock holders and
> > correlate them with waiters. As a result, distinguishing between
> > short bursts of contention and pathological long hold times
> > requires additional instrumentation.
> > 
> > This patch series adds dedicated tracepoint instrumentation to
> > zone lock, following the existing mmap_lock tracing model.
> > 
> > The goal is to enable detailed holder/waiter analysis and lock
> > hold time measurements without affecting the fast path when
> > tracing is disabled.
> > 
> > The series is structured as follows:
> > 
> >   1. Introduce zone lock wrappers.
> >   2. Mechanically convert zone lock users to the wrappers.
> >   3. Convert compaction to use the wrappers (requires minor
> >      restructuring of compact_lock_irqsave()).
> >   4. Add zone lock tracepoints.
> 
> I think you can improve the flow of this series if reorder as follows:
> 	1. Introduce zone lock wrappers
> 	4. Add zone lock tracepoints
> 	2. Mechanically convert zone lock users to the wrappers
> 	3. Convert compaction to use the wrappers...
> 
> and possibly squash 1 & 4 (though that might be too big of a patch). It's better to introduce the
> wrappers and their tracepoints together before the reviewer (i.e. me) forgets what was added in
> patch 1 by the time they get to patch 4.

Hi Ben,

Thanks for the suggestion.

I structured the series intentionally to keep all behavior-preserving
refactoring separate from the actual instrumentation change.

In particular, I had to split the conversion into two patches to
separate the purely mechanical changes from the compaction
restructuring. With the current order, tracepoints addition remains a
single, atomic functional change on top of a fully converted tree. This
keeps the instrumentation isolated from the refactoring and with an
intention to make bisection and review of the behavioral change easier.

Reordering as suggested would mix instrumentation with intermediate
refactoring states, which I'd prefer to avoid.

I hope this reasoning makes sense, but I'm happy to discuss if there are
strong objections.

> 
> Thanks,
> Ben

