Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2119FC72D2
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 23:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDD546B0088; Tue, 24 Mar 2026 19:39:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E2F6B0089; Tue, 24 Mar 2026 19:39:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA4056B008A; Tue, 24 Mar 2026 19:39:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C937C6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:39:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C33F1404FC
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:39:23 +0000 (UTC)
X-FDA: 84582575406.21.C700277
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id ABB4B40003
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:39:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Am+pA5J8;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774395561; a=rsa-sha256;
	cv=none;
	b=atEORKq9bc4405UNIThCmlVQnSNpQm6Kks728faPFHa3KWTV05Ccet8ks8u8qM135e/jdM
	mmBz2ldqWN0NJ9jMAqHkoWCxd3Y7mLPXHA/n0C8B2Wg2wVFGIct6SwtSXNfRPSSvolhjB/
	+JsoAo1HZzmazAavuYU2lb9DLXlxfg4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Am+pA5J8;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774395561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/rQh3YM2FO1YfUrD0BajXAbfyBIb2stcMQF6I1z09k=;
	b=TEx51/loVMYCle0/5lZwvZLQ4FVTvFDPiu/s+eYJJVP4pL748S4vI1ZTFOGCqOqxOnIctz
	NnAPnF7lKIBXzB6XQhBEIb/vE1KUhtypJ1X6QoQl6Bg55bpmBLhBkI0GmJ6SG1nt4hRsTq
	s6PN7XBu1j946GFW+QS5c7y/biSbPl8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 499AB40B77;
	Tue, 24 Mar 2026 23:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D3DC19424;
	Tue, 24 Mar 2026 23:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774395560;
	bh=jETE0JFh9GTipM2rvyBs79WhM9MfsbUHhqii5B1SqNc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Am+pA5J8RIhJGHXOHNLoJerq3KOkRiSX+TnB+uUK6YAtNjx0bQOs9nsD3kGKZWK2g
	 hHacwO5MIbIxdD1FRQ+HD0QG3qnYPMgc98IpL3QkBHg137OAaEJeTphVvGqAFpYYfv
	 6/nE2/SDD0VEvYSxXKeMbX8afBbcov4AQ+VxXGWs=
Date: Tue, 24 Mar 2026 16:39:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Matthew Wilcox
 <willy@infradead.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Oscar
 Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 0/5] mm: zone lock tracepoint instrumentation
Message-Id: <20260324163918.1a3c5c960d85a4243c9ae314@linux-foundation.org>
In-Reply-To: <abv4riGLlubast8v@shell.ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
	<aa7G1nD7Rd9F4eBH@casper.infradead.org>
	<aa7XdpIVtLFS3FIu@shell.ilvokhin.com>
	<aa7dgQDMEz34eadj@casper.infradead.org>
	<20260309151317.7bba06dd@gandalf.local.home>
	<aa8xawMxLeUjkyHx@casper.infradead.org>
	<20260309171700.063318b5@gandalf.local.home>
	<abhAoF5EpiPigsx7@shell.ilvokhin.com>
	<abv4riGLlubast8v@shell.ilvokhin.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ABB4B40003
X-Stat-Signature: 8pofxstaq1eaoj1cr6r4zn3hy3nm1k3y
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774395561-881532
X-HE-Meta: U2FsdGVkX1/ETUUFtYU75kWhT/mhNexmJ2Io6hy6PjvSFKyfY11GacF5bCTblFfa7bZVOl5Xob6MhzLB+L3oG6wEf/fk4qR4qsg91FQ4if4waCdXwVir84ltoqSQRh1DLQ5kO1RWKq461iUCVd6sWZFf67W53tAYMAZOnCbg1WfoIT4MxmHLDEDl6d7SKJhFami8rK+YIYwSMf4URaFoBdAZejqX3mWvhR5u4FJhPdl6tykesrdTrsHjY/nZQyWk0biKjiifH6HfrLzxv8la8dJx0aMLWTLwpcxokRWO7aMSAbz5tStYyo3aISFpN9c5UcDIorieY+j28+OqwrBexkZxRu9HakvAFwjEP4R7GeIqb6Tno07Zh8kRvMLh3xUTcmARLjmrRdrdnxAheAhihzspI6vJNolrVtF/lvRu2cZSGG0G/Z4qkIfbjd0s0qh7rBtgWYyMSPiSFvvnU+NNwGMZCkOnxWICJTU/OH2APiz2BTCi+aLMZdp3hRjr3i1gnsyJdj2I3wIojuRUjH8b5+YhPNf6qmCEZsGz2hJn8gXWnMZrB6D3rKi8J+e70FJPmrNJYHRa8gU8cO4UXwXbNxlThnnB/ZRizhVd+ISqknUZuN77UTlgUN/TWp32eXjJSu5OOB4sjl6vwHtKGmmonPZQwBaa3fh3B3ssHkR+c2WnkPOM9VbpMZW1M4MH6P8g0+0tUOzw2kd/H7aZ8JJZnglrc6RJ/m9nU9FpEUfpD38lU5bcQnMyviKiBmOoMPVEVlwYpZJYUpY/qwbYpWrUYocQPvHAe9VaDWFB3bav0MxyYU5jc0RLndq/O2sUmdCy7aJpjc7L2djrZHeZCuOIoAtmkGnO0Hh5wGRjJ1mmd7yNnbsSAOa+dNFGNasVAvsluZ4+y4iyH5F2H1vMOp11THJJ9R8VxB2ZKJIBVjoAzmMQOUIP3qHfqs+v6KXIW+vhZuElivMeWsyO3lIl7FK
 T4wkj6VW
 b0rNUpqyNR1vKrVU6QClG8i0UFuOGsIV0Y86XKgAWFdcvODpbwaPbxCWSIuO4gUcpkUCRmMHCoqBc7F7gST2qJHhI8APSCorbvwYzibkzSnPT6k9f1HldMipH1feSSGMtkjn7dWR5PWAuDnzsjBl5CC4S86XDJjXNOb/Lei4cmBhXphFVlXbquWuSD60OfsmGQGeXQAJasWhJo4df57fGLl9e/f0IAGIvMVkkbDQfwFCz3NaGe8/wOvMUnGSqIBfN+4jWfM7sMkhocUKTJ7JPGF0Vh92bNQYrPjQbSxicp0mddV14ZHbD8q8WI2rlkgAmXfniQophvjA4JhY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 13:22:54 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> On Mon, Mar 16, 2026 at 05:40:50PM +0000, Dmitry Ilvokhin wrote:
> 
> [...]
> 
> > A possible generic solution is a trace_contended_release() for spin
> > locks, for example:
> > 
> >     if (trace_contended_release_enabled() &&
> >         atomic_read(&lock->val) & ~_Q_LOCKED_MASK)
> >         trace_contended_release(lock);
> > 
> > This might work on x86, but could increase code size and regress
> > performance on arches where spin_unlock() is inlined, such as arm64
> > under !PREEMPTION.
> 
> I took a stab at this idea and submitted an RFC [1].
> 
> The implementation builds on your earlier observation from Matthew that
> _raw_spin_unlock() is not inlined in most configurations. In those
> cases, when the tracepoint is disabled, this adds a single NOP on the
> fast path, with the conditional check staying out of line. The measured
> text size increase in this configuration is +983 bytes.
> 
> For configurations where _raw_spin_unlock() is inlined, the
> instrumentation does increase code size more noticeably
> (+71 KB in my measurements), since the check and out of line call is
> replicated at each call site.
> 
> This provides a generic release-side signal for contended locks,
> allowing: correlation of lock holders with waiters and measurement of
> contended hold times
> 
> This RFC addressing the same visibility gap without introducing per-lock
> instrumentation.
> 
> If this tradeoff is acceptable, this could be a generic alternative to
> lock-specific tracepoints.
> 
> [1]: https://lore.kernel.org/all/51aad0415b78c5a39f2029722118fa01eac77538.1773858853.git.d@ilvokhin.com 

That submission has met a disappointing response.

How should I proceed with this series "mm: zone lock tracepoint
instrumentation"?  It's not urgent so I'm inclined to put this on hold
while you pursue "locking: Add contended_release tracepoint to spinning
locks"?

Please send that v2 sometime and hopefully Steven can help push it along?

