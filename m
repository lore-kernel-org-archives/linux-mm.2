Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2458BFCA179
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 19:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 825636B0005; Mon,  9 Mar 2026 15:13:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9106B0089; Mon,  9 Mar 2026 15:13:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB366B008A; Mon,  9 Mar 2026 15:13:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58BA96B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:13:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD18B58613
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 19:13:19 +0000 (UTC)
X-FDA: 84527472918.09.BAA2946
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1AFF9120003
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 19:13:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773083598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=405DxsN4405tuURLsEbdjbyCYCZ0c0PIcgEbBX/VCL8=;
	b=gfK0QKudPmgZxnlsPpilg1QlF5+cgawJ8IX1jTT3oJt93LbHAkBdrk0KqRNuLdGTDEPYWA
	UVkaCqI1F0ATysgpf6KiEV5QrI6XPKeGXrw9akYYSB8eQXmXPozOZza+Wo9780b6DOQHRt
	rj/SycKujwSnjFaatFDBC6/LhuxF0c8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773083598; a=rsa-sha256;
	cv=none;
	b=uegsf3c3hepZRx+PEETmegQzALeowfHex/Nmu3Dd8YSRrCVpgGnlr40UNeNMeTcaR1Qj8u
	UNgr0uEa7RIKaTR/zdPdanOM6byOu/lE1EbgJTjiwYfnTElGQ+P1h1eRff2HzKuRjrGd5m
	MqT9i9fds+zaQ55s+NjkPmmw0ezfBhQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	none
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F80E8B40B;
	Mon,  9 Mar 2026 19:13:15 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 0D2EF20026;
	Mon,  9 Mar 2026 19:13:09 +0000 (UTC)
Date: Mon, 9 Mar 2026 15:13:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
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
Message-ID: <20260309151317.7bba06dd@gandalf.local.home>
In-Reply-To: <aa7dgQDMEz34eadj@casper.infradead.org>
References: <cover.1772206930.git.d@ilvokhin.com>
	<aa7G1nD7Rd9F4eBH@casper.infradead.org>
	<aa7XdpIVtLFS3FIu@shell.ilvokhin.com>
	<aa7dgQDMEz34eadj@casper.infradead.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/t1Ugy1fVfjXyAi0RgUyUMU3bb6SSTt54=
X-HE-Meta: U2FsdGVkX1/Wx0umbTtULg2v9su5xeKShIbhebg44QdCcqtOibGO+Ihs1xBog4RL/GQxhiUtLwc8NNVFs8NrifJeiVuZCaBnsyIP5ll9GwHE+DuXexFcf7tzPaO+zm9jcDgS1fMOvX6sNJWwEPx9pBTyzyNPuBu8QJhCoXE92GFp1mdZECY+Okz/VjQo05ivbANloz/uuoLMjauDe+H8knTs5XdzvK9d0uSl4QWvGP+ulTi4xxM518Qk8ORZtElmWksx0uJukhu2dIcBzyH4pmVT7F+Fvs72WiT66l6E4l84judGtvbb7e71dICUFeB/g0OgzEtJORBzgxZX9liw1aXv9m8ED5+yT5Gj3BiGQgUBQ4rPqL2GBiO0rUh+8cxQ
X-HE-Tag-Orig: 1773083589-71908
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1AFF9120003
X-Stat-Signature: q3yxck1isxs11rr5dx37zbn637abuzme
X-Rspam-User: 
X-HE-Tag: 1773083597-900226
X-HE-Meta: U2FsdGVkX183AYKpSqKm7aXGAApiSh4G7aLcat3L5gSB9ZbH5cJMkcrv2a3tZlHGY8Bbi1EQvTPDNhSHaNJXjnuowCMFSvB4zOfFc8cEOpInWcbBlQITsFau5yJskvjED2xS8qhatSC3u5KhcdyY02TMxcVU0xz1d0KW5FcAX1DWzxExSJR8HTwZtlX3B+FWrxpgOelVwCYgMjLAm9qxvVb6jGmDww4J8RxxYIHuZmapRKMIpVnvTxAjXfh0tcnjOgtGYvT4fIPcTb3SRFWBL4rF74jYv3Qse9SYrZ+ld49RPZc9wOjTtNe+F1LWE4bqCLzH1E3eVJuvHi+azVFhKAS+D8LEKqQlJU80CgLQSyQPtmoUSE1eK+nQ1Xds1LYAd9JGNisUIQfXgdgJK+cHALV1dzQeVKExC+1jimcxRuu35bq04ai8erska10Qwin73UKnUmuydlINXVn0/2+++osHshNNyRA6uUXWMbFxH3IoHnitlO1sYKX1a6HZw6WqY+aZB/YuvdrwN0lRiplHUPJIUfWBajV5hEAR11dvrUTsEO/XhT/7qMbzvwSP39rOL3kOPpS9pqjWtK9nqBznB1pzOHZCrUaZxO2NhEQASUw7n1QjXuhggS016s81ao5N7lK9rLrWZbBeHl1d34QCeRogR19uPjMBgt/x5ecbVQ+Qnq2Ef383B4Nbf38vwqWMzKoDrQ+aqbXAxXepscuKF4uIDwmlycBwkmGijiUHf5mmHkf0mJBieApZb/qmGH1W3ZuE0fDI8yMMS2N0Lr5ETwKe0yGf9jAx942WXOkmrrv8CNYtO0ATDYKCYPrPmIMXNRSWMAYZBEu4RRU/e6dAT4JTreIk/Q2wvneeqtWI07V7vCaxkxwcwDa7jUkUG8CHgLYuOJXrGWyriWSuoK+b6yj/4Styc9XPwEqSodaK6IE2k3/9eldZP7Yy05u+LFeo9ekMjs25rf/X5H4P/tZ
 inQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 9 Mar 2026 14:47:29 +0000
Matthew Wilcox <willy@infradead.org> wrote:

> > CONFIG_LOCK_STAT provides useful statistics, but it is primarily a
> > debug facility and is generally too heavyweight for the production
> > environments.  
> 
> Yes, agreed.  I think that is what needs to change.

The biggest issue with making a generic light weight LOCK_STAT is that
locks are extremely optimized. Any addition of generic lock encoding will
cause a noticeable overhead when compiled in, even when disabled.

Most of the lock code is inlined for the fast path. Now if we want to add
lock stats, we would need to add hooks into those inlined paths. This will
undoubtedly increase the size of text, which will have an impact on I$.

The other issue is the data we store for the lock. A lock is usually just a
word (or long) in size, embedded in a structure. LOCKDEP and LOCK_STAT adds
a key per lock. This increases the data size of the kernel.

LOCK_STAT was designed on top of LOCKDEP. Perhaps a lighter version of
LOCK_STAT could be designed without LOCKDEP, but it would be a project on
its own.

-- Steve

