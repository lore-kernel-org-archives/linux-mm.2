Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98A2EC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52B536B0093; Fri, 11 Sep 2026 12:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503FB6B0095; Fri, 11 Sep 2026 12:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418EE6B0096; Fri, 11 Sep 2026 12:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9836B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:32:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80A37A45D3
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:32:13 +0000 (UTC)
X-FDA: 85202023746.12.5715ABE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B61C8180016
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:32:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gy1m7qOG;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789144331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9rqeVVJkLJL7hyeN+ZhuUze7JPnMyhzvchT9akDlcM=;
	b=Cb2ob6690qoSaUFtBweXqUZXhd5jwldpJhgYxKqltNhowYFbSFJHTwMK8sqr+ZtdJ8lETc
	6wSFds8NlGEqZbGoDTxtnhMgeSZvYOKx8SrijpoJrvZ5kMJqBya13xAVHeYkIxF/KeNCSN
	gDRYkJ/Iyxqebr6tntxcUwDGOzZtqIA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789144331;
	b=yI0SNPm5cX7JLwu3jOtkGJ24ivHE3YCf/q0JFQld+SGN9/sXpoOmbFxkzHRboVqEHczGQy
	6MRT98vX7jvpaTRRIj1DUDwwvS9jYX7g0yB5+foJoCmp448vTb5CroqZEcVlvmudAUe3A0
	EZsJnduDgtKTmYjYOUPGFzGVXfJbk9U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gy1m7qOG;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A4F860142;
	Fri, 11 Sep 2026 16:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C3D1F00893;
	Fri, 11 Sep 2026 16:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789144330;
	bh=j9rqeVVJkLJL7hyeN+ZhuUze7JPnMyhzvchT9akDlcM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gy1m7qOGyWRZPMTSfQJX9GQn8OMxswkKp0FjsuSudkheza3eMi6XvIr048H2mPW3M
	 PL8rI73VtGnov+Hua7Sm836ztsrYcARh0SXYdWOwul2HOk/YsGB76Z9LE6hNVa3jgU
	 bkeKe0wZLVavneFVz57sps8mALXwElCoNhR6bGFA=
Date: Fri, 11 Sep 2026 09:32:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
 <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
 <brauner@kernel.org>, <dgc@kernel.org>, <dipietro.salvatore@gmail.com>,
 <djwong@kernel.org>, <hannes@cmpxchg.org>, <jackmanb@google.com>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
 <rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
 <vbabka@kernel.org>, <willy@infradead.org>, <ziy@nvidia.com>, Vlastimil
 Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Christoph
 Hellwig <hch@lst.de>, Brendan Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH v5] mm/page_alloc: avoid direct compaction for costly 
 __GFP_NORETRY allocations
Message-Id: <20260911093209.d9181d5950778897935f6bcb@linux-foundation.org>
In-Reply-To: <20260911142102.2294202-1-dipiets@amazon.it>
References: <20260911142102.2294202-1-dipiets@amazon.it>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: efzyozzmmoqopun3q4d1owhdk6hezdje
X-Rspam-User: 
X-Rspamd-Queue-Id: B61C8180016
X-Rspamd-Server: rspam03
X-HE-Tag: 1789144331-648351
X-HE-Meta: U2FsdGVkX18H09r7oG4CWVZW2wJ4lg/eee9ckYwgS1nGWaDrfVxuuQmYZrRwxAPh/xKkMDj7yZazvJ9JbrcDS0lOTnSE56aR7oInZtJW+4WrtdWa/sa0bLpukkMRut0Kvg+59VEF6TpX7PcTGiG6LInmP7zTu9DtNF/e8qHCugy7f7lRuMvKLcg5oYCHOeLaI1l8gDxev0eG0H7yzUS0gh/8mAgnHF7slgAszdINy2nsQMQuYbkiqGDsIPdwqtJU7TdamzAM/NRhC7/cRW+VVNpDG9zsZLfsRegNV39KHFSCzGmey5Nx2ujCmkzC5UYI0VkVfZdhIwoTWEalZQwfD9dYgHImYwqlzxzrfvCdCTpE5N2ken7m+8Wxn70viK0w0+Zzop4JIm/G9VA2LpDI4qy9NgcgPf6lE5hlXAFW7mBQN+ZZvHcdn34LaftT+k0yJPyUqsUMOwFRga6505xeLX9sBu7ycEC3XGDndFv7/5jgMkTodDNrUgwUv9bDjg9MUfQFIEYaRYVLkpcjwNnWIxghMUjg3AzDmsR5lmlq1LmZ/rJLB+JMZLDAG/QW4Y6EaOUYH/lSpC35NS7xn9o5Cu7qODXo6kwm/Z5Q7XJ0iM894bFxiUw8qM4j1q2BPaMKHg8pvZ51udxP63YBmwwQZjjlQLTd/50vY+qmNx+70RovkkFpP0nh+WHV1FjW2p7QmBljhmYi1Fk7rt35ORPOo5uvI9oUUUw4Pe199g+ilytz1Tp3hvB7z0DY61xSQ5PdeurTe1ZPYRWlIgU5dJOxRxCG3a6jpfsjPkmQkHy7gW3+0yMy3WsEMD+vfKiIFgWP1K3c9KuIGfnb9uz9bbwoafaJ76RZ0hwgvUXZ1TGCUwty4wAmBJ4zo+iGreQVPOaz+/SCfKMNWt0z+rjmOl0m0/4XdlZYP9yESnasuiw34GsCvRefNsdzJz+otjJyA0FLiN68DjtPU7TkNBqXGt4
 5fbJ+VrR
 9yEY+1ctTAZzkM6sRYY6/qnAFKQ/3Dtl+K8MxAtd06x8tk4tg7bOzU5VgYsz+UuGGrHWzUJjsW0WwXzFNJb8bAJgKcNK1AJrrlgg2/1K41SLAwGUE2SlcB8gIIBQ2nvXuxEIm88QaQUTXqsmRt4umafXXbrMvH+iqMP4YOfPxwjsm4k6nODS7d1+1u5+h6w4l/2+y2jRXqviMqL0x8dWkNtoMppxHc55w0YCu1FAp9g9uf/CMwuGeFBojZtQgiY2LpRSTKRro68BQPzS0XI1lG1lbJujjbU2UTOYV2tFX0/kvMVnBPCVgHqbv4vTW8/YoWwbuy/IztGzGeOyBpltfWFlJE0mlQ1P62/Vfrn/8AVn30eMxWLQ1S3i9eK4cN6G7rQssCTGnijB10Gh8DhzzwtuG1KJtKKos44OLcRYQWKXJmPDyw61CKWIVpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 14:21:02 +0000 Salvatore Dipietro <dipiets@amazon.it> wrote:

> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write
> path.  When memory is fragmented, each failed costly-order allocation
> enters __alloc_pages_slowpath() which runs direct compaction and
> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
> pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.
> 
> The root issue is that direct compaction is too expensive for hot
> allocation paths that have fallbacks to smaller allocations.
> __filemap_get_folio_mpol() already marks higher-order allocations with
> __GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
> failure.  However, the page allocator still attempts full direct
> compaction for costly orders with __GFP_NORETRY, which is unnecessarily
> aggressive when the caller will simply retry at a lower order.
> 
> For costly-order allocations with __GFP_NORETRY, suppress direct reclaim
> for the whole slowpath by computing can_direct_reclaim (and hence
> can_compact) as false.  The !can_direct_reclaim check near the top of
> the slowpath then short-circuits to nopage: no direct reclaim, no direct
> compaction and no drain_all_pages() IPI across every CPU.  kswapd (and
> in turn kcompactd) is still woken further down for background
> defragmentation, so compaction keeps working for long-term system health
> while being removed from the latency-critical direct allocation path.
> 
> Allocations that also request __GFP_THISNODE are exempted.  That flag
> pairing identifies the local-node-first THP attempt issued by
> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
> form transparent huge pages.  __GFP_NOFAIL is exempted as well, so a
> must-not-fail allocation is never made to fail.
> 
> Test environment:
>   Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
>              12x 1TB IO2 32000 IOPS RAID0 XFS
>   OS:        AL2023
>   Kernel:    v7.3-rc1
>   Database:  PostgreSQL 18.4
>   Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s
> 
> Results (average of 3 runs, TPS):
>   Config                                       Avg TPS   % vs baseline
>   AL2023 stock 6.1 kernel (pre-5d8edfb900d5)   136,942           n/a
>   v7.3-rc1 baseline (no patch)                  59,408             -
>   v7.3-rc1 + this patch                        161,994       +172.7%
> 
> The patch fully recovers the pre-5d8edfb900d5 performance, bringing
> throughput back above the pre-regression level and well clear of the
> ~59k baseline.  The AL2023 6.1 row runs a kernel that predates commit
> 5d8edfb900d5 ("iomap: Copy larger chunks from userspace"), so it is not
> directly comparable, but it shows the pre-regression level and confirms
> that the ~59k baseline is the anomaly and not the norm.

Thanks, I'll update mm.git's mm-hotfixes-unstable branch with this.


> v5: Derive the decision into a local flag instead of mutating gfp_mask

The acks from vbabka, hannes and hch were dropped.  Fair enough -
that's always a hard call.

Sashiko is worried:
	https://sashiko.dev/#/patchset/20260911142102.2294202-1-dipiets@amazon.it

That's different from Sashiko's v4 complaints:

	https://sashiko.dev/#/patchset/20260904115629.3993331-1-dipiets@amazon.it

does any of this look real?

