Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90E76C79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 23:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 401A66B0088; Sun,  6 Sep 2026 19:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2A26B008A; Sun,  6 Sep 2026 19:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C8A26B008C; Sun,  6 Sep 2026 19:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 040A06B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 19:05:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06B58A2C17
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:05:20 +0000 (UTC)
X-FDA: 85184870400.27.7C9250C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 63F06140010
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:05:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JKpgL+U4;
	spf=pass (imf26.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788735918;
	b=eIfKL9WTsuQuLl80BARrQUyYpvfQ3OdkB+qljsyq61tXkymV4NYy/SonfCiCQzU7/3h4Dt
	4g5TUZVuFQlUIHEqM7svkj7+V6a2okbCjdS/XSxuhiSQ3Xa9CelDoJyEKC52Hy/YgS9pk/
	Mra9GVgSZjHWerkANAmYkRDq9aQQSHo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JKpgL+U4;
	spf=pass (imf26.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788735918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azoo0pX+3AIYzE2g/eGc3kL5OniqDxseTzcbFubdQLU=;
	b=J/nDUtDiDd3zLoqvQ3vjqR8DGFi6aaU4AE5w4UMI+/o6DaH+KDDI/MT8x7m9qBt1p6DEXk
	Hy4j3GpHd+uygpeSvHZZEvn4+grVtG+fH2HeFVyde5TmsCb4JdwvkqCVHDgia5ohJ/MoEJ
	p2JxZ3JbahOGFS1hrR5OD1TRcCgI0l0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7BFA9601DE;
	Sun,  6 Sep 2026 23:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B921F00A3A;
	Sun,  6 Sep 2026 23:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788735917;
	bh=azoo0pX+3AIYzE2g/eGc3kL5OniqDxseTzcbFubdQLU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JKpgL+U4xlNFixXBnAA2Wa3j8oJlvb3HTDY/coujxaGy/qHOJQh2CmKsxLkS9wo9R
	 uhwE4PG1QlCwceNT55FSQy3XrsxhCp1+kyeJZ40sqoOVtu8kelfuKIxzgocLIpGdo7
	 G4obCwQW0MzajzT0pPNZk43gdWUI9ECvp46xtGiooOd5DgB14rMVKbof/EtlxOR4P4
	 UBRK8cRL3A3FTO+K4RxYf5s3QzHFH8DelKXPWqtJNo0K59JC5KxUKt3g9niGpQRgqQ
	 KDLCp+FRrJTuMFurhbWUD+CoijRR9YL5pfH5usQ3AMMCWVn/6M4F1L2LfhPisCF3HS
	 FSiyRpjbdZRUQ==
Date: Mon, 7 Sep 2026 09:05:04 +1000
From: Dave Chinner <dgc@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Salvatore Dipietro <dipiets@amazon.it>, linux-kernel@vger.kernel.org,
	hch@infradead.org, abuehaze@amazon.com, alisaidi@amazon.com,
	blakgeof@amazon.com, brauner@kernel.org,
	dipietro.salvatore@gmail.com, djwong@kernel.org, hannes@cmpxchg.org,
	jackmanb@google.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, mhocko@suse.com,
	ritesh.list@gmail.com, rvvandan@amazon.com, stable@vger.kernel.org,
	surenb@google.com, vbabka@kernel.org, willy@infradead.org,
	ziy@nvidia.com, Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Brendan Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <ap3xoHb-GtxZXkMd@dread>
References: <20260904115629.3993331-1-dipiets@amazon.it>
 <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: upynhfn9o1tjgkb8t1bzpp3k17qori94
X-Rspamd-Queue-Id: 63F06140010
X-Rspamd-Server: rspam06
X-HE-Tag: 1788735918-452866
X-HE-Meta: U2FsdGVkX1/IQsngdCFDtwLCtnE0XbPhMVsth94nZlExWAD4QELRLbeDBcHqDXX2tXA+49FNpbAsejBxkWwTfmBEBEwJNCnajqfJpopYnbFfYU726wASkZCRP++HcFX2byi/Lmx2ojQcCK96+qYXDkIC9zvFxWRqHC8NigBlHoJqDtj1cw+XGfZ/NONI2WQcRF8m0jT5KFJaVLSDg2JKxk4J+E/rurYtzm8+6F6hD9BoU6qqxCCz4s7oQWgw4af0hm62BUxRCjWYZM3ZPooz6iImyCrmRG5g7Tvyx7zoHsEz83NvAKR3rDnh/thDQS18U7YvDtNqkGiCu8BQd3O0V67DrwfA6DO4y4wSFmbL4TLenUrX4VwNBUn06Irsf/dLw7v1MEtZNSooaacc/2lGELX4N7LEI3TCuLT94bFH9SLEYQ/0GueDeDBnqQv+pDjZJ/+gfSFr4a8jgEhI4N/94RX607H7ED+habSb5CN+cwvQh6pZVm9qHldln6/Sor8bRjNtDD0pi/xKdOv3CG2N+9RUjvKGOqbsaSYIAoERlw2d4oxOfj/QnDqHpsWAl5NAva5Mn41BdIAQNXw5VKeMBWWvL94bIsKW1mzpweBr6da8iQOqqJYrqFJQFtuCC5rswjasZHvlKxmsjJ99F5cMNbhjNL8uVdTJV4m0TgYJP7EIB6MLNzIxbakhBAKfPw0THiFb8y666j02+zeZTUtwEt3I3xMziWXiCLrpTKUOgYlV7pE1rsRLEOrTOrP15ju1OZSWzhlzbzrV9ks2VbGI85sb3wZW+XuebUBSH1IoIve9jPtZYwolClP+KwJAXcQKpfuRF+lsXg3xIcQ5LVzM7EDAVHhJm/074K/VjS0xmWt8nSJDNnM6DIvhtQ/Iux1j4u8Qdg5IQTQsHetE2avmcRQkZ5TIqFoi9cwxpTjdMUNeEIZgUAQn4x+wjvNpbzA7kuganslrWVccSW4b6Rj
 LOSrauI1
 4sAk08t1gxBpl77Bx44kfgB/5xp8grnJfz/tf0ZpVRUFVUJJAKgmUGAEf/8QhuXXaKDK5F2BCOhwcKmdPR8yxeXxbtpJUV8opBEVO8CVb6ODp9rGoea0nRrMuk5E6QibiM6y2jWkAZmXEdWNyRALSY0RJwmlpg6robOFJlYVYSqQs/g2cwBqtTyx+JCPkDuSU431mr1KImUwlB9ojwOrKTFoTKrSnuyYKNshBSUx5nFQssCvvKGqQJGf1Xfknd9d3b6J2/tYe5Ffy+6TVE0cVmgNHCITKW14o9BsZ1XiuaK0oNHt4aB3p+KfU1L+0mAhGIYUjFQpGq5dETx2B4bTsagfwawwm6fHZp2tPJhxM8nBM03viYDJDz6hRXV4KhyNv9J96kzdZjPAVPhM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 05, 2026 at 05:42:39PM -0700, Andrew Morton wrote:
> On Fri, 4 Sep 2026 11:56:28 +0000 Salvatore Dipietro <dipiets@amazon.it> wrote:
> 
> > Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> > introduced high-order folio allocations in the iomap buffered write
> > path.  When memory is fragmented, each failed costly-order allocation
> > enters __alloc_pages_slowpath() which runs direct compaction and
> > drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
> > pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.
> 
> Is there anything particularly unusual about this test case?
> 
> > Results (average of 3 runs, TPS):
> > 
> >   Config                   Avg TPS      % vs Baseline
> >   baseline (no patch)       59,408       -
> >   With this patch          155,409      +161.6%
> 
> Is this back to pre-5d8edfb900d5 performance?
> 
> > Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
> > Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
> > Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
> > Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> 
> That's three years old.  v6.10.  
> 
> This is not good.  Can you think of an exceptional reason why this took
> so long to surface, or is it simply that our testing isn't good?

Neither.  We've know about these excessive high-order allocation->
direct reclaim compaction costs for a lot longer than this, and have
quite a number of filesystem based workloads that have been easily
able to reproduce it on demand.  XFS first worked around direct
compaction overhead back around ~5.17/18.

So why has it taken so long for this to be (kinda) fixed in the
memory reclaim code?

It is not for lack of awareness or trying.

I've responded to about half a dozen "direct compaction is
expensive" bug reports in the past couple of years where I've said
"this needs to be fixed in the reclaim code, not at the individual
call sites". Not just fs stuff, but graphics and other subsystems,
too.

However, convincing the MM manintainers to do anything w.r.t.
changing memory reclaim takes forever, and requires excessive
amounts of persistence before anything happens despite clear
evidence of the issue and the performance numbers showing how costly
direct compaction actually is.

A directly relatable example of this is kvmalloc() semantics. We
needed kvmalloc() use fail fast semantics for the high order
kmalloc() because it is much less costly to fall back to vmalloc()
than do direct compaction....

This was what the XFS changes in 5.17 worked around, and that fix
didn't get pulled into the kvmalloc() implementation until 6.15 with
commit 46459154f997 ("mm: kvmalloc: make kmalloc fast path real fast
path").

IOWs, it often takes years from "bad behaviour known" to "fixed in
MM infrastructure", and most of that time is spent trying to
convince the MM maintainers that the (relatively simple) fix needs
to be done in the MM code itself...

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org

