Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A9D8CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 01:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0E86B0088; Tue,  2 Jun 2026 21:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9819A6B008A; Tue,  2 Jun 2026 21:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 870286B008C; Tue,  2 Jun 2026 21:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 752CE6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:29:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C133B401B4
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 01:29:44 +0000 (UTC)
X-FDA: 84836869488.14.70BEB08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0BEE18000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 01:29:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MYJindhJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780450183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZAzYbDB7KwJFZUH3vb8G02tWQdnEGJhvMuTYhptPfs=;
	b=NXdTeg6SOKUN+VRlI09QJi4WnyTryTSjFbM1cgoZ8NxVl35CG2oU+OODnEtw1AthKi4Gvg
	pVZ/enLbBsYRzvmvxDivV3a9iCJH5fv8oJ2KwhDpKz+H17guhMG81MXbJZtIybRj93pSAt
	DI7fgP1YJxtkB+/jN+efD8bNGKjUP3o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MYJindhJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780450183;
	b=zPBRjTB+tPznwmUYTvEfHETdcTnmBN/YEarpaN1h981WgjUk8W6eSRGAhE6ziFytg36PZE
	G/1PPk+mCSGAlPkceAa+012FYgy2GOItuem5f86X3JiYgPbS07OfiQjfqnF0AjcKHM+Uck
	hT9HlulKZYiTCIDhvLKFFEBhUMZ0nSk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35AB0435CF;
	Wed,  3 Jun 2026 01:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2672E1F00893;
	Wed,  3 Jun 2026 01:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780450182;
	bh=mZAzYbDB7KwJFZUH3vb8G02tWQdnEGJhvMuTYhptPfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MYJindhJEOgi3egpo83m3LLIjCZkbjHljb1eimGJLVd2HYZEssloRJdsZjHNStpYg
	 Y81g27zHb6dOtsvZIf3UR/rJJxa2sAvqWWYDXmXsALjsh3Wno1queunjXOvTCz3oFH
	 FlCgwRmpHCNWM7Ql8sPDhiYr4PZwIhEuHiqWT6muRp65CpV241uEGPVaesnG8gzQcn
	 4Xx7iARzxHR3xwlfy1D+IsrtYqI5Niqx3bllX97pFE65V53CuA+L6P7L9Xz/M+QNv7
	 rIe4/b4oycBj7Z1TjAXPsdP3w9lAK0ffZolxG7+qHdYMH3bZNDrjc4byNIry7gzmz0
	 rGSNgEddqn5mw==
Date: Wed, 3 Jun 2026 01:29:38 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org, 
	vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com, 
	yosry.ahmed@linux.dev, yuanchu@google.com, zhengqi.arch@bytedance.com, ziy@nvidia.com, 
	kernel-team@meta.com, riel@surriel.com, haowenchao22@gmail.com
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
Message-ID: <ah-A2gQ0GPgerXop@google.com>
References: <20260528212955.1912856-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260528212955.1912856-1-nphamcs@gmail.com>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: cf9ajktz3wj8twwp693z9jrm86brz4by
X-Rspamd-Queue-Id: 0BEE18000A
X-HE-Tag: 1780450182-233133
X-HE-Meta: U2FsdGVkX18OiBZ5qKuSwDbr4zalbKscVJ/wjZi9Eoq9GMwEv73Nyg5KsL0Qc/BG0FMdOWn6NK2WU2NpHBdYR2OgQ5K2s0LfITEe7LN6JUgdnUx3OJzrdxYzSSnti0ronIuR9gQysq/QzCT1DZapMY1gjWhvjHPfBEYGPUdSV+NqZ9Q3rexSaJ0WHdH/LpcpHH3YvNvjpEn01qg9CQ3Q2Qxv70OEuXLgrR5IYda8yWcMfiRog0ugj74SyQPufQ/VEGw3fV+dyXFcYMwT62uACduvy+S3lL6/0MjIwyjPiKWG81ZGHrltcpVuPQWDKwetha5osjaQ6ReLBCX/JjFNTr8MhLAJUja55X2Iv8VWlmrs2IBYmbVE2qIYi1/e+5cNwY2iDdGrEzvwEWx3PKRMUCs3poYe3VsOMtca6nDLoZanWWhOp9pTiuY38wg7tzUyjc9EUxKTdmvbqTXccRntuW+cC5fOZHj3m3uj84AdyH3N1GUlNMB5D3/NSIci4MDmHZXLFsBLQ3nr0APeY1Bf1240kcG9LPn7CStDaArzBi2qwRzrYYt7PEhtGTOT9VJB29ClaHd8jdnt4ccwcaV+2AJ7IG3yEQM0aWBRtcCduOKDw5nXVK4hmHRBwLOWqyvVXb4KymIr5HOtYzq+tb/OStNqxuiNWOp3YaW4qlvdcqX1FrJp7MIunAEOllaOgxDNxcnGUkeg2N0ryinnGnO9hdYBYW3Aoxc/pq8WrCtzT1UpHKkKp3bon8RUrhuwEdR+av2SaUjc3SlqoZJp0sCpbik6ADlPJb+IypbUGvszScxMCTWxLEi2jcYf6iUGWiDEaON7WRFW3eTURAEAXQRuGscY7vm2r7VMT4vvjK1hz5plAg8xnIMA2ubyozwJNDxO+NUB7v5ZVtCpx61/j4cJo0QYWTxCHW/3UG2BCbSYl+HF8DaB5yWioTs+rIJwBgigV8FU7Pf7SYAQIygAxmw
 pNRYyUjj
 xdILxB0mb13YBNkUNM3G5Y7VffsYSWTyZ3o1G/TvkAqU4FtO3VPYKW8b9P0gpzPHqkLwyWCLl7R9svT05pWFqwsmtkIWOHabTXybE1B0Utj3K9j9QGDqGOKdsZjGn4oVtltoEdLTprw0KqGofYcD3PBgVG1Eu0X7oJAkLVdszLrWcI9wVPp7zzOvAl7kKJJkptvJdKhNSqF8lt3FuH2GyQruTNy30SBg3slGet5Pqw84UT4oXYWHsOV+MeHJ2PkkmoH4up3QF8aj7yWI0lyKzrGHG/PrjkU7C9Xxd9xgexNlLF07Ef7y9ggIybuzV0GtMU0tlq035K1jy7YWcCCQV+t4WGKJnN2KnVyP5Swd2LTpVPE6WMTCO/QQqm5B0/IkdUVCc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> II. Design
> 
> With vswap, pages are assigned virtual swap entries on a ghost device
> with no backing storage. These entries are backed by zswap, zero pages,
> or (lazily) physical swap slots. Physical backing is allocated only
> when needed — on zswap writeback or reclaim writeout, after the rmap
> step.
> 
> Compared to the standalone v6 implementation [1], which introduces a
> 24-byte per-entry swap descriptor and its own cluster allocator, this
> edition uses swap_table infrastructure, and share a lot of the allocator
> logic. Per-slot metadata is stored in a tag-encoded virtual_table
> (atomic_long_t, 8 bytes per slot), and physical clusters store
> Pointer-tagged rmap entries in the swap_table for reverse lookup back to
> the virtual cluster.
> 
> Here are some data layout diagrams:
> 
>   Case 1: vswap entry (virtualized)
> 
>   PTE                  swap_cluster_info_dynamic
>   vswap_entry          +-------------------------+
>   (swp_entry_t) ------>| swap_cluster_info (ci)  |
>                        | +--------------------+  |
>                        | | swap_table         |  |
>                        | |   PFN / Shadow     |  |
>                        | | memcg_table        |  |
>                        | | count,flags,order  |  |
>                        | | lock, list         |  |
>                        | +--------------------+  |
>                        |                         |
>                        | virtual_table           |
>                        | +--------------------+  |
>                        | | NONE               |  |
>                        | | PHYS               |  |
>                        | | ZERO               |  |
>                        | | ZSWAP(entry*)      |  |
>                        | | FOLIO(folio*)      |  |
>                        | +--------------------+  |
>                        +-------------------------+
>                               |
>                               | PHYS resolves to
>                               v
>                        PHYSICAL CLUSTER (swap_cluster_info)
>                        +--------------------------+
>                        | swap_table per-slot:     |
>                        |   NULL   - free          |
>                        |   PFN    - cached folio  |
>                        |   Shadow - swapped out   |
>                        |   Pointer- vswap rmap    |
>                        |   Bad    - unusable      |
>                        |                          |
>                        | Vswap-backing slot:      |
>                        |   Pointer(C|swp_entry_t) |
>                        |     rmap back to vswap   |
>                        +--------------------------+
> 
>   Case 2: direct-mapped physical entry (no vswap)
> 
>   PTE                  PHYSICAL CLUSTER (swap_cluster_info)
>   phys_entry           +--------------------------+
>   (swp_entry_t) ------>| swap_table per-slot:     |
>                        |   NULL   - free          |
>                        |   PFN    - cached folio  |
>                        |   Shadow - swapped out   |
>                        |   Bad    - unusable      |
>                        +--------------------------+
> 
> struct swap_cluster_info_dynamic {
>     struct swap_cluster_info ci;       /* swap_table, lock, etc. */
>     unsigned int index;                /* position in xarray */
>     struct rcu_head rcu;               /* kfree_rcu deferred free */
>     atomic_long_t *virtual_table;      /* backend info, 8 B/slot */
> };
> 
> Each vswap cluster (swap_cluster_info_dynamic) extends the classic
> swap_cluster_info struct with a virtual_table array that stores the
> backend information for each virtual swap entry in the cluster. Each
> entry is tag-encoded in the low 3 bits to indicate backend types:
> 
>   NONE:   |----- 0000 ------|000|  free / unbacked
>   PHYS:   |-- (type:5,off:N)|001|  on a physical swapfile (shifted)
>   ZERO:   |----- 0000 ------|010|  zero-filled page
>   ZSWAP:  |--- zswap_entry* |011|  compressed in zswap
>   FOLIO:  |--- folio* ------|100|  in-memory folio
> 
> We still have room for 3 more future backend types, for e.g. CRAM, i.e
> compressed-CXL-as-swap, which is laid out in [10] and [11]. Worst
> case scenario, we can add more fields to this extended struct.
> 
> Other design points:
> - Both vswap entries (Case 1) and directly-mapped physical entries
>   (Case 2) coexist as first-class citizens. All the common swap
>   code paths — swapout, swapin, swap freeing, swapoff, zswap
>   writeback, THP swapin, etc. work for both. When CONFIG_VSWAP=n,
>   the vswap branches compile out and behavior should be identical to
>   today's swap-table P4 (at least that is my intention).
> - Pointer-tagged swap_table on physical clusters for rmap (physical
>   -> virtual) lookup.
> - Virtual swap slots not backed by physical swap are not charged to
>   memcg swap counters — only physical backing is charged (I made the
>   case for this in [7]).
> - Careful separation of vswap and physical swap allocation paths and
>   structures adds a lot of complexity, but is crucial to make sure
>   both paths are efficient and do not conflict with each other (for
>   correctness and performance). I do re-use a lot of the allocation
>   logic wherever possible though.

Thanks for working on this! I mostly looked at the high-level design and
the zswap parts, as the swap code has changed a lot since I was familiar
with it :)

It seems like the direction being taken here is that we have one
(massive) vswap swap device, and we keep normal physical swap devices
around as well.

A vswap entry can point at a physical swap entry, or zswap, or zeromap.
If a vswap entry points at a physical swap entry, then the physical swap
entry points back at the vswap entry (a reverse mapping).

I assume the main reason here is to avoid the extra overhead if
everything uses vswap, which would mainly be the reverse mapping
overhead? I guess there's also some simplicity that comes from reusing
the swap info infra as a whole, including the swap table.

I don't like that the code bifurcates for vswap vs. normal swap entries
though. Not sure if this is an issue that can be fixed with proper
abstractions to hide it, or if the design needs modifications. I was
honestly really hoping we don't end up with this. I was hoping that the
physical swap device no longer uses a full swap table and all, and
everything goes through vswap.

I hoping that if redirection isn't needed (e.g. zswap is disabled),
vswap can directly encode the physical swap slot so that the reverse
mapping isn't needed -- so we avoid the overhead without keeping the
physical swap device using a fully-fledged swap table.

All that being said, perhaps I am too out of touch with the code to
realize it's simply not possible.

Honestly, if the main reason we can't have a single swap table for vswap
is saving 8 bytes on the reverse mapping, it sounds like a weak-ish
argument, even if we can't optimize the reverse mapping away. But maybe
I am also out of touch with RAM prices :)

I at least hope that, the current design is not painting us into a
corner (e.g. through userspace interfaces), and we can still achieve a
vswap-for-all implementation in the future (maybe that's what you have
in mind already?).

Aside from the swap code, the only sticking point for me is the logic
bifurcation in zswap. Why does zswap need to handle vswap vs. not vswap?
I thought the point of the design is to use vswap when zswap is used,
and otherwise use a normal swap table. In a way, one of the goals is to
make zswap a first class swap citizen, but it doesn't seem like we are
achieving that?

