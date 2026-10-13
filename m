Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CA59CC6B0F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 22:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B1B66B0095; Tue, 13 Oct 2026 18:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562526B0096; Tue, 13 Oct 2026 18:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477C16B0098; Tue, 13 Oct 2026 18:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 293AB6B0095
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:23:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B112C1C1F11
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 22:23:21 +0000 (UTC)
X-FDA: 85319030202.13.8C06288
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 24DCB100008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 22:23:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HbVHmQjn;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791930200;
	b=FlJcMj3vqDQWfVYyk0M+ZHvq3aTQYBDdjtIZwfWl4/2eaPQh9GncZJ/VVwfkxITNjUSjC2
	MeGMLFiQvqyMCfZ7Rn6LumpuQ/EVQI5nLtK2ZFvOtZ2vQjfnUVCiW+dn/2oXPDyyjP053w
	/3GN6cbXqRtAfz0CboLGVCy3QwCYmnw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HbVHmQjn;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791930200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3B0t0pdUPQGVbD/gYqKOzHdQS5+TzS1sAbmVd8BmAOk=;
	b=h1lAVPNs2Tp3YZgUIgXoY9eRAdKLqDGUmFY1lqel3ZI+9rVUhqIZQzVLkupljYuTOhMRPr
	TL2rECLRkFwNGVD44mq+WS3g2DLP20wzNseFrvtBpplkCIsTfzeT7qR2iQadrDjWpkmVHN
	7hlt3zivG2HURvCQvbDVlcx2FB1no4I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95B71600CB;
	Tue, 13 Oct 2026 22:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFADF1F000FF;
	Tue, 13 Oct 2026 22:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791930199;
	bh=3B0t0pdUPQGVbD/gYqKOzHdQS5+TzS1sAbmVd8BmAOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HbVHmQjniSdrw4laRku1zJeS7ADy9DQNNJGRWW/2zecE+CC0aCmk7Eahfai3NuAO/
	 dsyxCQoCwPRS4eEvkzidDE1gyq1gXJWZ26wa6nR9azrXf8Qe6mzHJCV6tsDd1X0c8q
	 ya6XT2Mcl5NMdzqYRZvJuUERl29POpqBdK0d1/B1ZdKsHoNCsjtzI2qoontsuZdNir
	 JfuOQn8o5YgkGSjftARoSXunQ/HLt6qaaE6Xq9uevirNZw9OnQQPSn0TlNc2bAilYP
	 3sKtMrjF5AHNopSU1yIp9KZQRK6amhb4+08RcApa9ivMzkjLR9Kph/J4grSOw7Iie8
	 q79KXmXj/GUzQ==
Date: Tue, 13 Oct 2026 23:23:17 +0100
From: Harry Yoo <harry@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Suren Baghdasaryan <surenb@google.com>, 
	Hao Ge <hao.ge@linux.dev>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/percpu: account full object size for percpu memory
 allocations
Message-ID: <as6q8H5qxb5Gd471@thinkpad>
References: <20261013-fix-alloc-percpu-accounting-v1-1-03e788a1e41f@kernel.org>
 <20261013145424.341cb25ffdd488297bffd1a1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013145424.341cb25ffdd488297bffd1a1@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 24DCB100008
X-Stat-Signature: uiyzwxg7optm3jjd6c3sfyewfftemm9s
X-HE-Tag: 1791930199-130568
X-HE-Meta: U2FsdGVkX18DrSCq0SskbOumHHLfk2+Fza+2L4zT1nLF8C3D6puEmc1JnAa8+teEjKlwdOSeyBvSVOhyp1vqIlaK7B/oVSLntG+iIcc0bqO445eNWyPgzAChBGc6Q8eH4O91qX2ZcXG4F5cYjfThRsIA6uDnebtFbuKXf6CU9ymYxcJeQITdPjANQcO/jGg4yWhrPOzzXotK3T0bjbu9oDh2rKN82z1sXcG8h1GYzIuHQVjVh1bUHA9zeivNagUr5rqzEdNC5wkXpbAflyQ/qi+Wbi6oINa0NLV7/3oXgLveYubpaA2iR4ntC+7BbSQNs5PZsDB5kbQ2mTl5OgzUC7fXhBP7wt33h7iYcnjdZ9HSO57tKV+jvh7VnZEws/SiHIO1GcACAn8+AIraZNn98Pq5j674CQUEaQxy5KqYi86SW7q6qfyeBymZf1SoADAe51YAbGBfQVfuEY6Ne5cPsAxrpzgNr/oLtZ1hjJWvk7qXPDmhtPd/WNhYxp5WapNrU+33nqTmAhGoy4j+xmIAHI6DtrT9hrcbTsLXf8EZQ9MeOCfoFDJElry/zPQaeREWh+z3xFOw0Gq+bCJ9nV60Zzmg/zdiQobl8nLMaJWKU9CP6DXce4DfytUUbhgrGjWIb3d1LZ9Q9JMLmCSTZHiIEvhtcWa1jwJBIyItd6BnvU7Se3HKWwEtMUCoftequb21qO05UiAjlju12LmOIkGAYoF9w1MuwXmCYqK5nyTUSoKnNSlPIhy2LqOH+GHaCM+5wMHhIjKotdYOWMkMJYCkkXJbsOT1WrH5QhQIe/6YmMpZwTiP4c6bVekGWVkHtj/bIBnxvoDTtTIpJp3EpYEAH2ERCogowLAmU2MXoHxq1oG4qVvEbpe0vgpd2D6QVAy1NoxiJcs8LIDa12owOL545PgX7wwBB5S/knPAG2lyNSGkmO7ATMX7I6l8UJRxcLpeGAoYW6Mr9fJ1yehdrGO
 g5xUc19z
 lZN8yINWrmhf3vfS3NaChWn4/FtAxAwdbYHE4dHJAjAkz5SUk5c34eMt4kYuoBbwA8T6y1zBFp6j1aaOyfBXNEBpTGne8mhaqbtWBR2AuzLhRDrieNrKU+CdaeeDlj/ayCpaIh+bHWATIuraTZqYbOg0oa3DVtvQkmdH5uH7TmYK/dCwJJZUgFf1zDs7uRmIYmo5lkMwc5Bgok9yR9dycO4NWgGmMUyqbB2ptrOe3i+M3HVJCDdKJt4WCU2HHg/iUvdB//9Jew57u6lvK6A1v3YGmcF987FJWrbWZ9lmjrQYlWCc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 02:54:24PM -0700, Andrew Morton wrote:
> On Tue, 13 Oct 2026 20:34:39 +0100 "Harry Yoo (Meta)" <harry@kernel.org> wrote:
> 
> > When memory allocation profiling is enabled, the pages backing percpu
> > memory chunks are attributed to func:pcpu_alloc_pages. However, the
> > accounting of individual percpu memory allocations via alloc_percpu()
> > and friends record only the size of a single object rather than its
> > full size across all CPUs.
> > 
> > As a result, it is often not straightforward to identify which kernel
> > code is actually responsible for percpu memory, because the size is
> > under-accounted by a factor of num_possible_cpus().
> > 
> > Account full object size with pcpu_obj_full_size(size) instead, which
> > multiplies the object size by num_possible_cpus() and adds the objcg
> > pointer overhead. This is consistent with what memcg already does for
> > charging percpu allocations.
> > 
> > Verified with 64-CPU VM by spawning 400 processes in a memory cgroup and
> > measuring mm_init()'s rss_stat counters.
> > 
> > Delta of kernel/fork.c:1142 func:mm_init in /proc/allocinfo:
> 
> Please make it use mm_init() rather than func:mm_init.

This is the output format of /proc/allocinfo:
https://docs.kernel.org/filesystems/proc.html#allocinfo
> Example output.
> 
>  > tail -n +3 /proc/allocinfo | sort -rn
> 127664128    31168 mm/page_ext.c:270 func:alloc_page_ext
>  56373248     4737 mm/slub.c:2259 func:alloc_slab_page
>  14880768     3633 mm/readahead.c:247 func:page_cache_ra_unbounded

> > 
> >                   bytes   calls   per allocation
> >     unpatched      6320     395         16
> >     patched      418176     396       1056
> > 
> > 'percpu' field in memory.stat: 422400 (1056 bytes per process)
> > 
> > Memory allocation profiling now accounts the same amount of memory as
> > what memcg charges.
> 
> Fair enough.
> 
> > Cc: stable@vger.kernel.org
> 
> Why cc:stable?

For anyone who uses memory allocation profiling to understand which
code locations allocated how much memory, it gives a false impression
that certain perpcu memory allocations are not as big as they actually
are.

On some workloads percpu memory (func:pcpu_alloc_pages) shows up as one
of the biggest memory allocations, but the actual users of percpu
memory allocator don't show up as they are under-reported.

-- 
Cheers,
Harry / Hyeonggon

