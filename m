Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44DBCFD8FF5
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 19:15:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3342B6B00AD; Thu, 26 Feb 2026 14:15:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E12C6B00B7; Thu, 26 Feb 2026 14:15:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20DC96B0134; Thu, 26 Feb 2026 14:15:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF1E6B00AD
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:15:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8FBF8C05B8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:15:02 +0000 (UTC)
X-FDA: 84487560444.12.3C3B8F7
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf03.hostedemail.com (Postfix) with ESMTP id B97EB20013
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:15:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AK81tUuu;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772133300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cMr0rukwTOqGMK00EByy2+nr9vOp+eXR1iEsiwlAxyo=;
	b=5r+gdapPyP8dzHHvFqOnZiOAH1voaN0EpLWgJgc8XfuGl7fitVI9tXow5vbiwvUydVkOlt
	LvNTNBaT4eQnGeHSgUgHhx+feLLRt0MKru7XN6dT41oLNXscKe9C/S9uinDQDTUSlZu5FB
	7EOG9RkpUy5EcVHcbm1Tcunboa6ndtg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AK81tUuu;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772133300; a=rsa-sha256;
	cv=none;
	b=FHJQP3q9i0uSLLJLrIGWdGhtFGCZIiLa7MEV5U6aUzKJQTfXvobybTSiCgsp72K+Hs662u
	2/il9oA7LyN9Mp2b4vkdVa3Ixl1rxrrgaqAnk4nbWQXXp35jSQL+RuDdFcjnjv1604TxM/
	lWBGbSlfQfdO29IYRmxX+1zX9Zphk2g=
Date: Thu, 26 Feb 2026 11:14:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772133298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cMr0rukwTOqGMK00EByy2+nr9vOp+eXR1iEsiwlAxyo=;
	b=AK81tUuuH2+5kjOKOi6usmyIuPwftnYihxKK99Hz2av1fuLRhqn97eot6nkyeI3pkW/Gm+
	PjJZmkjdn/gii9Kzqs8ZA442M3QsfAyHLQHpAZzbhk5DkzEF1zXySQuJNMNuKkj5iDvc0F
	eguY8Pxb7Yt0Q8RKcnSNpgH9xXCnqmY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, kernel-team@meta.com, 
	Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v3 5/5] mm: add tracepoints for zone lock
Message-ID: <aaCbMwGNuUO1SbUb@linux.dev>
References: <cover.1772129168.git.d@ilvokhin.com>
 <378089dd269249d3d7981fe10eb8b49ad551d353.1772129168.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <378089dd269249d3d7981fe10eb8b49ad551d353.1772129168.git.d@ilvokhin.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: q81jsn89o6foo7wm9n3kapzrsrfci7dj
X-Rspamd-Queue-Id: B97EB20013
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772133300-588249
X-HE-Meta: U2FsdGVkX19diyelDLZWZ82pd/et6dN/fcef/POe9c5yklTSoryAe/bQ8DOm13MU1IMrppCDvy9AcTIHp9sqoybRs4P5dzYwk5Vkz3ugZB0bYmYPCpqHSV/8w4QrqsLLGPkQhipgS05T6B5QKamp4kesqh3tNwEu1iU5R3x6naieRZ3jcE08RmZ0gipzCCx2DhhCq+YONw8638cTGGtYJgrHATy0A1bRRbshNbOyhzzNmAER+waiGaQ3haCbgCDC4r7DDzkVCPZ3FRW+HuC1HEKn8xtdbYI/GghP3grnl00or2I8C375hUt2YIOAr1oX/1saUWrIzfL6GBgWZMjwdFflDDQdWBX+4yCmBTaHgn9hCSfK/bQfgLbg5Qef1fMqCa8QRL6SBelxLvF/1tz4RyKqiHMSm1bnbqwuu7Q/WgKkD/5yP2SrBI4hdCH23p/jsPC0twAD21N8JuyYhlGgQ/pXZrmjcWN4Cj6hwAthPFFkQVjv5nzI50F6rsRE2wT64BU8P/4LQBxWZq3Q0MM7pr1ST9MiiV+RLiEnuoSUpban4gQFxD06bPU10bJNCLS+6vJYwFrwAxHo2ssFUPCNrCwx4XUgFLC/jyFmw0JY9L7BasxaQWExWXD99K3E71uXa4oHKQAYCz1qQXSzWa0Eh5wpSPbRqyjrfDRKo0RMv2RMxKqzkUQus1c+7d4k6ydM3EAdgykfKv+OrdUD1CVRb3rpj/F33iR4ogurZBrI5G9VygwCbn3XhrsRuDtTgI3RfwKB2Be+3IVZUYSybf/p5UGNTq0wajEfmsZ+p6AfS9tbvIANe2I51bFdP13IfdafjA/5dFMjbQYv9Vf1Y6OZPcoeC1rPe+TWvv4qOnHBPbKKHzNdVVHZ3yaS1koObYkJngvmztEtZSOsE2Rbx8yLvP0TSNG6X9t3M5dsips8K4cR53UKfstkBDfJ6HP27nC7J6o3eVEOLRFM/vKuCaq
 HQotAdzj
 LCQhWaz4gJzY+utdO+RFDeELpKJGfZwOMgoAKUb+diHmYhrqGfbTkfMGvZ+L7SFt5Jb/Mfdto5IeOorvOpNnAUsGcIR76GOOs95i6p5+GNkUP7zHn5tXebZ9jXpEXqGmIKrV5gGwh0ok6+eosSXEQG5sbSoFu2ZP8+UtRS46gBDFTopfvPKD4f8znuumMrh2JwGwRSBoVDwtU0pMUdz6bT2MsJ3yjkzqKWdiq7p9mswCNMF0ZgMJJljlQIiTDIKaT5apGm8ZqYKu0DlTCAYHwMu4MkZVmKY63V4tKFEApB7fPc7arUGQwCSWoqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 06:26:22PM +0000, Dmitry Ilvokhin wrote:
> Add tracepoint instrumentation to zone lock acquire/release operations
> via the previously introduced wrappers.
> 
> The implementation follows the mmap_lock tracepoint pattern: a
> lightweight inline helper checks whether the tracepoint is enabled and
> calls into an out-of-line helper when tracing is active. When
> CONFIG_TRACING is disabled, helpers compile to empty inline stubs.
> 
> The fast path is unaffected when tracing is disabled.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

One nit below other than that:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

[...]
> --- /dev/null
> +++ b/mm/zone_lock.c
> @@ -0,0 +1,31 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/zone_lock.h>
> +
> +#include <linux/zone_lock.h>
> +
> +EXPORT_TRACEPOINT_SYMBOL(zone_lock_start_locking);
> +EXPORT_TRACEPOINT_SYMBOL(zone_lock_acquire_returned);
> +EXPORT_TRACEPOINT_SYMBOL(zone_lock_released);
> +
> +#ifdef CONFIG_TRACING
> +
> +void __zone_lock_do_trace_start_locking(struct zone *zone)
> +{
> +	trace_zone_lock_start_locking(zone);
> +}
> +EXPORT_SYMBOL(__zone_lock_do_trace_start_locking);

No reason to not have these as EXPORT_SYMBOL_GPL (& below)

> +
> +void __zone_lock_do_trace_acquire_returned(struct zone *zone, bool success)
> +{
> +	trace_zone_lock_acquire_returned(zone, success);
> +}
> +EXPORT_SYMBOL(__zone_lock_do_trace_acquire_returned);
> +
> +void __zone_lock_do_trace_released(struct zone *zone)
> +{
> +	trace_zone_lock_released(zone);
> +}
> +EXPORT_SYMBOL(__zone_lock_do_trace_released);
> +
> +#endif /* CONFIG_TRACING */
> -- 
> 2.47.3
> 

