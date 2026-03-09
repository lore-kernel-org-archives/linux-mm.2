Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA34F3C269
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 14:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9DA06B0005; Mon,  9 Mar 2026 10:21:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A210D6B0088; Mon,  9 Mar 2026 10:21:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92CE86B0089; Mon,  9 Mar 2026 10:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 844DA6B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 10:21:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E5A81C14E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:21:49 +0000 (UTC)
X-FDA: 84526738338.28.5BD0C92
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7BEB84000A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:21:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=pyKkhJWQ;
	spf=pass (imf07.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773066107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89Q59i3cmlvIuCaU6IMXcnS9oldz7qFt8v/vCBuKyH4=;
	b=o4S7TfwcSaSOaIEj6EQdqJ2+MlQQhH6SmUMSw1DaEorCBaAlvwOlDASv3OOmHElqF4xehU
	N3LYaoZM+tpqalATunTApH/KlwSlK3qPexCng1yUWoCZtyUD8aSUCwB87F3fhgu2HYMvAB
	4yl20aL1PD+HuyzrknFSGlM7yomG57I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773066107; a=rsa-sha256;
	cv=none;
	b=KeMi8Gd3T4v31V4LqbqSTjWxhM6HaoJ8jeV8SGeeRr0Pm7n0kEk29RE6DVHNjtYkIVJ49e
	zFuujr7umtBiQyOJCyPDGpgmsgWWpcZjTNRtgyhs7vkhuGqvWlhpAfXjvqS2U734IRTH2r
	gMdSQyd/zFRj7ZkPDWVyrp/U7DEaNI0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=pyKkhJWQ;
	spf=pass (imf07.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 9317AB36CF;
	Mon, 09 Mar 2026 14:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1773066105;
	bh=89Q59i3cmlvIuCaU6IMXcnS9oldz7qFt8v/vCBuKyH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=pyKkhJWQnjig5kCqeP6hPYZL4qkV2wpdupo53NVcZ3mea6inhIPXBmcwS67BHdur+
	 nSuzcghck0UixFHftToE/hLhexverWNxCN53oAJfLOtGCAJR3ozlthcuBtJqj1LMx4
	 cdrhLDyOjnTT0nroLki1F7MdfAr3DvANC4ja6Tfo=
Date: Mon, 9 Mar 2026 14:21:42 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <aa7XdpIVtLFS3FIu@shell.ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
 <aa7G1nD7Rd9F4eBH@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa7G1nD7Rd9F4eBH@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7BEB84000A
X-Stat-Signature: hfkc3paxn486cdfpcqazn7kgybfuect6
X-HE-Tag: 1773066107-351189
X-HE-Meta: U2FsdGVkX1/JNE+K2wAdfY2eoE1/0DFHXMPhOIToQcc5Tne/e18tktono2hIMakG25RX9DfAuJAuKgTnIoj11il/xsJCFUghd4LsHseILp7WjfqEnZEWvwvvMKq6pF/L3ML0p51kTcA60liExkMPkOb62GWmugAE/NvaQC6VOPLKcZfdM/nj5vJuh+3oP2LxfKJMB3PwKuj/iNt0lEuGBFpyCr9tdHWtIUOw9o+aMnhQYpzjkCgVxLnn8wW8cwjSR/XgzXS7K0bm7uFzJ3z8Hxn0oXWj0sQ1C0CGY/CDp78FdZXcX34ebe9GJPwE5gCSOLXBgtu5/HQaQkwxEgPnrPSCd+uCw9JLx2U4CEtjvYtBjRZQE5A4LM59zH3kr4CvIyIewJTaLy+gogu2bZ8naNR278ZgTQS2mSuQDXbOp7N6US09Phd2SpkJ7KkCNIR94GEWMRSSsp6JenM9EGMZpoc7V4X76yKqyNmnPqPQBBwrNcC2UlN/MYCNWKNV8tkecTmYi59tTVATecmLJaTkgo97v//fMabBfehGNlR3MPWWwSkgi51uJgiCNQdTcnfTCFXVFZECxPGF7/V6wcqG0c6xeTesP3U8q5uF+OhoYsrGF2ghvhKQdoEwxvedszLy/Uu3fvpMRmmyfH6ZagD2GbWADH2Azo8d0b/IZFjwL1V1aE/8rnsR6mwQ7nEiqpqgCZQguDPCA9oglIFMlo+uabZRCw1adautgIDOoEf+l3dNoQuBOVqbP3weQEiMG6y24GbExeOQ8/Zk19cg2iqTyq5x0PVsvWHwDP+sOuVudekPRFxr1ROs97ljK6DORYTObmQUwYstMAofEcHBzP4TMD43M7/F/xILQ8SdM70UcOGAanqrrrOzhJ7aUnkZoUu22YM2WByauw8ITsMF0JaV2AisNAwOAImE8RMadUA6m5U7U9u6oVZgwyOEfRCmRnnQzZjx7X5j4yYTRCw6PI4
 yTc245gO
 EZVdAJ1bMNTqFjzfu9K5RB5mQskNLVefEpAivIdootbThE1Hjkk9RMAf+zknSFBOrcrtjKsdAWGTlAKDWYxrsH2WqqaBu+6RXVnJ6P+4BwLj897ZAm0Xj6s8UAiI48Gvy1bZ/q8jmbSctYdLUx0Si9bPgW8GPZ8dgLLv4s4fTIvSDq/AyMf4eUOizYzbUpu0/ksFXURuPrJHngbd+MhSJc1xANr4wrnDLciXWY6/jZkNaUVzTk5XtRvjiPvHGme144Njh6mrtIiQoDe2X8P514mJo/9OJUJqlWUZ873S4OWvbeMMXyVxGpK+MLRGkipZ/5Why
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 01:10:46PM +0000, Matthew Wilcox wrote:
> On Fri, Feb 27, 2026 at 04:00:22PM +0000, Dmitry Ilvokhin wrote:
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
> 
> I don't like this at all.  We have CONFIG_LOCK_STAT.  That should be
> improved insted of coming up with one-offs for every single lock
> that someone deems "special".

Thanks for the feedback, Matthew.

CONFIG_LOCK_STAT provides useful statistics, but it is primarily a
debug facility and is generally too heavyweight for the production
environments.

The motivation for this series was to provide lightweight observability
for the zone lock in production workloads.

I agree that improving generic lock instrumentation would be preferable.
I did consider whether something similar could be done generically for
spinlocks, but the unlock path there is typically just a single atomic
store, so adding generic lightweight instrumentation without affecting
the fast path is difficult.

In parallel, I've been experimenting with improving observability for
sleepable locks by adding a contended_release tracepoint, which would
allow correlating lock holders and waiters in a more generic way. I've
posted an RFC here:

https://lore.kernel.org/all/cover.1772642407.git.d@ilvokhin.com/

I'd appreciate feedback on whether that direction makes sense for
improving the generic lock tracing infrastructure.

