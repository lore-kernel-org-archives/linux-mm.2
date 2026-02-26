Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5902CFD9E0A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 21:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCC676B01B3; Thu, 26 Feb 2026 16:25:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5B0F6B01FC; Thu, 26 Feb 2026 16:25:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82DB6B01FF; Thu, 26 Feb 2026 16:25:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 958EE6B01B3
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:25:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B2C08AE47
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:25:06 +0000 (UTC)
X-FDA: 84487888212.04.1311652
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5E85C20002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:25:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D2fLiuvl;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772141104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDUIaCFizeZdLfehShv9aSki8iur9YdmUOd1arRm34s=;
	b=Y5GZCib5ZYA647WNNZ9187/4MU8LMmqWP8qL3vG2G0/3lxIQYdRt1RFm7loyhGt5HSmN72
	0a4ol/0b8NUnCkOP/SOzbev8vIF9514oikNZkqJ2I/HfdXGWmt1cWzD6eASq8NWrrHDRV/
	5si5Syx/Kziv42i0GYnrw/L5FDqDDac=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772141104; a=rsa-sha256;
	cv=none;
	b=jhptM7lH96dmcUvN7ztElV1QqXWXPcIIpAqH8QqnZRS50rFlU/HjXzlTTp3vdrbbrio38X
	G8NkXYEQQ+tBwRfVJe1neWyNJ6HcMrWUtL8Plm0HVpTyYQR39+aujDn9+2djTkO1+ebgoO
	kxeI6X0rGgVWaHXZoF78fn3wnv2pyxg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D2fLiuvl;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1946A4345C;
	Thu, 26 Feb 2026 21:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3127AC116C6;
	Thu, 26 Feb 2026 21:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772141103;
	bh=TK9rkBAvvg4o3PRRG7ZVkuu7ATGJbZIF4YPRlRFQSLg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=D2fLiuvldUwv1h2AWaUU5JWohz8ay95owgAQ1nxknK2oEr+xUU8haTPAO9WpznJ9e
	 RgN+BkHG3DWGZ5fk3gP1TCe2HHAxUs0B07WZJgYiYwwZroxbm+jYyTL7T+Ko16pORa
	 kQcLJNqTUzStzftpWjY9k694tncouhnOliWYcKkE=
Date: Thu, 26 Feb 2026 13:25:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>, Qi Zheng
 <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, kernel-team@meta.com, Benjamin Cheatham
 <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v3 5/5] mm: add tracepoints for zone lock
Message-Id: <20260226132501.5b70914daf9438a1103189ee@linux-foundation.org>
In-Reply-To: <aaCbMwGNuUO1SbUb@linux.dev>
References: <cover.1772129168.git.d@ilvokhin.com>
	<378089dd269249d3d7981fe10eb8b49ad551d353.1772129168.git.d@ilvokhin.com>
	<aaCbMwGNuUO1SbUb@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5E85C20002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: n9wo5a6skemyhyn4mjzor9r8bho1oo45
X-HE-Tag: 1772141104-349449
X-HE-Meta: U2FsdGVkX1+Nav/ThwNgdxT9hbD6p9ApagP0QBGVOiD0UOWZaHup8aPjbJWhTlebMpWjKNMalhDquXHxfVpHRzMK/PpzTLxuWz7UMqo9HWjmwfx6Xg32BEBuQCFYlzVYaQbab1+0Z5BOwIy+fWuaIutF8zB33LAXFYizJYoTXUlBVAWUYWsXBKOyFY8hBd4+aHjdNmsUczluLYdDAauOGogsteXZ08Fqxc00lpHbW9gopWzm7oHjaK39Obp1yjpWpR2D2Zsp8xK4UyCq2lhVqge/sXwZt1CX9j/OXG/wur+tobxvSwMwaSYqIVNWQBazmLkSKTTchg35a9SXWy6gbtqGmNq0zK97dJPjx+yLtwkdDf3caCUfFnw58oyqYcwFaJBAkGRH6sSJSmxgrjOSaTuage9Ke9drHqmq53yopI901Mw5aDqYDbuIwJyjUqRQHtU/A5aChOWk8Nmr0acKWKB98yBhQjDFP/+cYY6Z6mcmhm4s/nMLB72H/WBAvkqnBbN/Qot0vMHRBvd1w9rGeZTuKWaNNnaShFUDwchhjeB/R9mvrvrjB+opCYPZFjDgCrqbEcmI0/zuqwwxmKzS8h61KDyn9zoDNz/JHX0BkhAaiHlSd72P47s//WCvXKfFOb8fzmDCP+ih8jleoyce3j1dULaBqI4YeFMBJPsv99isfxjHV8OFCQgoJDu2ghOPQFScCjff1FNNFuWOY5YLd1WGYyaGZYp5V5IWsfRTrVYQb8MzX4m8eW/IKl8a5NabSfWevR5rSmENcrMoAX0XhqwD9DaShsYmCAyt6RwKJ/lAc6J8Fra1LQ48MZ2Cejstc7xKEnRNL7p8WmVCZxODKjSoFWGpjFtCwQOpGuGDMM88DYaIlpc2IS3gada+aAZxXVY8cqkMsgqsmpARNXIP0uGy2VrMMMoqV3EJwg65UUGC/nPZYaCBApjdCQ6FqQAL1iHXwAc+yYSpqPgO5Hb
 rHwM/Qoy
 5fadPRlfy6p+2Rgya8wu1HSUVt2PSohGxqkt7WsLlGTsoS7ZPA0b4bQyASsVAB7uzneLZDUszuT/g9AyUCjFYTTxwwgLaU016tNEslh7qNOoYKhbEf8qjF0Aljt/hA/t1Ss8acc/p32Sxqdf6vIeKV8ph93RQJr9HnjSMP5+abhh4tYDN1uLRp9LlBoViflcZ5BlRCPtY+3PU9MJeiOAumq80gkLNmKfhtmkLLk7nKtZ+pFw3puqVakoJ5MWGJQ35MgeV13GBZ3+zcRbTZzpsqUFaFtHGAp0Zu5F+EQMX3O3Ii+4d/RRD1rFX4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 11:14:52 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Thu, Feb 26, 2026 at 06:26:22PM +0000, Dmitry Ilvokhin wrote:
> > Add tracepoint instrumentation to zone lock acquire/release operations
> > via the previously introduced wrappers.
> > 
> > The implementation follows the mmap_lock tracepoint pattern: a
> > lightweight inline helper checks whether the tracepoint is enabled and
> > calls into an out-of-line helper when tracing is active. When
> > CONFIG_TRACING is disabled, helpers compile to empty inline stubs.
> > 
> > The fast path is unaffected when tracing is disabled.
> > 
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> 
> ...
>
> > +void __zone_lock_do_trace_start_locking(struct zone *zone)
> > +{
> > +	trace_zone_lock_start_locking(zone);
> > +}
> > +EXPORT_SYMBOL(__zone_lock_do_trace_start_locking);
> 
> No reason to not have these as EXPORT_SYMBOL_GPL (& below)

Do we need the exports at all?

include/linux/mmzone.h
include/linux/zone_lock.h
include/trace/events/zone_lock.h
MAINTAINERS
mm/compaction.c
mm/internal.h
mm/Makefile
mm/memory_hotplug.c
mm/mm_init.c
mm/page_alloc.c
mm/page_isolation.c
mm/page_owner.c
mm/page_reporting.c
mm/show_mem.c
mm/vmscan.c
mm/vmstat.c
mm/zone_lock.c


