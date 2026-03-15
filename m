Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F7C7F30283
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 20:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813D66B009D; Sun, 15 Mar 2026 16:26:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1B26B009F; Sun, 15 Mar 2026 16:26:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F8366B00A1; Sun, 15 Mar 2026 16:26:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0356B009D
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:26:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 18E5C1A0C95
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:26:01 +0000 (UTC)
X-FDA: 84549428922.07.AAF50DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 71FB91C0010
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:25:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jqGHc/zU";
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773606359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XDBfLPa+K3JieQNj5NGa8BuODSRZQIDV1/qbTTVq3p8=;
	b=D9mRCASFL79FHjn7BGU55vqcDKoCkwkl9GMVfz7aOjWxMvVwo4X7Sy7LeUtcv63lJj0nPV
	4BVyL+YB9Gk/ZfDr3HPBX8yqkRV6sbepQv3TuEE1Ct+auEyg8sZ/ag0j9Kef/S5Fm/4Rrv
	MLzevml6RiHB7c0xZmAMWd1RNgDPHL8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773606359; a=rsa-sha256;
	cv=none;
	b=kEXIic/sS+RH3CfuwFqOc7TrgrzzZMM7Mra+ib9KZtgcF9r+YScMV4C/+uo5hWbxyhdT43
	NGxlSi7TXyQWKfTS6zsQDpzPpuomBe8CJJ3QoOFdE8x4ehDHt7hOPZtO9WrkwGUNkYV563
	fBmINeht/VwB6qIf/sxHp6dLjy48ac4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jqGHc/zU";
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C29EF6183B;
	Sun, 15 Mar 2026 20:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96B3C4CEF7;
	Sun, 15 Mar 2026 20:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773606358;
	bh=sgRC+UgRjYWfAtg2Gh8ZUTPf4K9hJS3ZcITRUG2mzJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jqGHc/zUlNQ3N25R09KuPAjq1k6oyFacL7HUkShhQvBPzYHY3EHOqjnuc9x2eiB+B
	 cUrh0Ls+REzQzGwVPtJFk9sHdUAqx63bBj1v+WOzgm8iYRDNc/PDpA7oJsmOu6HQw9
	 3MqfBZGdmu2qb7CRZ6ZNrzAar95L1iWGIqlXQMKE7xQ2uIEX0uCwIhHki7nyj5ukH9
	 Dj9E50CxLS4V0gCdr0ok/bqpCEElcY6cgusnFiqK877xja1kA5nHvYhp1aa9t4p524
	 V8C+1pHUC7Gcv2b75+P36hqNYE48My1i4z79GLXMdvn9bcYYloc3RjY0aKRqdi2FSb
	 wvTXCsFOB7Vkw==
Date: Sun, 15 Mar 2026 20:25:55 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kit Dallege <xaum.io@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, corbet@lwn.net, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Docs/mm: document Page Reclaim
Message-ID: <8b43807b-b542-4861-8757-3e008d0e39d2@lucifer.local>
References: <20260314152534.100473-1-xaum.io@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260314152534.100473-1-xaum.io@gmail.com>
X-Stat-Signature: 1mya6pzmhe99woaxmarzqwfrff9zrpsp
X-Rspam-User: 
X-Rspamd-Queue-Id: 71FB91C0010
X-Rspamd-Server: rspam12
X-HE-Tag: 1773606359-358670
X-HE-Meta: U2FsdGVkX1/OZJIwBJTFdGOOnNtcJkB/i9ccEA3UxR4YyPMsMdssgTg0mgKr6Yfst+bHfrNDwGiaDgJqQ3ag6MNf+KMToN5RKnEEp8xnmNJrl6NHZ+bLIsUPudbJEvtqNsRO3FZkM2QgHiPNcB9iGgbEwIBdEiJtkjTTeWPEUQniv/Dugpo2rxbuORVewVwsw/O6IvOkHbXXeDJGyn6TUdqzr0LabP5J/WjdBG75oeGjc4JmYwlU6W90IPzvORYdq0HGygBXToR/rHHoJxA3ZbB2/6kyPRgmAgppj0fBXDT9ab5mW8FxPB9sOrqo9acib0HqkL11MzDA7cmadUKGjCHZQhRmeg1acxKMJFRbeGIBO/JXO619ob7WvDZrGZ8/+rSVGOxPWtsab33c/pqTMXhAo8ClRAQp52/4K67E0bqQGQ8Od7AZ8SOs+YWEL4dpBMRh9wxaYb/Hz5mK/uCXVC3iuTjzJWAhEshJrB3RoRX+4OZj6kN9lm6dkUHV/RjJrv91jUUxrKjxYDKFXJGm74TA+cJ113dAljI28Xf0BcUALjGGB3FHRBfyBPDwEuHJdMeE4rBQkrGvuhXZFb9TG5MJ4PNOZnqmcT9xwxGZHSvtfDgFvf112cotCIP0Tbqi5w+1Fm1yRCpkUna5qYBU0e1V3Th4S6354arWJuIdiSqMB1bLHHkS9fIbYBcUM5/PGw+u41DQOGa4jXE2vOKRPYGEFYl3Zym+t+c9jqXj2dhHsBgKthnStTf958hDViYjj8zzsQcVy+SWlGd/OzgpW98hqqZw24Ys/4NNvRyOCj6lQsII6zlCuTOlkiDrB2p4GNv6nsGXB6RfNfONXNsMGhrV6s9hX7bCy8a9hLWowoABuiUCo30dKoGwBa689O/Vc66r+zvc9FYRqIBCkHVMX/+8OMeVnZ/vGJHRVZVBSJIJ7ijpDNsKz4J/xF/nW8vDgGEPAmsIOM4sO/1xMdh
 nK2hE8vF
 Z5Ir/FsKQQCMzKtNoqEl/ZN3Xos8XUHSV81aIUwg/uMlHsmTdI4Ydnb/+yyGRLJG3YSz7/W1iuLzqgq5gHF7a+AHA3Lz2TIUGZPmTPpMIK2eP13/17Ye9Hf47tpePG8TVunootiBv7yyuFdILPlXn0+G+QppA40IHzEnZ8PFBYFny7PrBISLUdnKZ8JRkKtdq7lM/6f2rbSHY9DwzTUeBLtP+vcd0ELlGBiUVD/KGd83PB8OzVCcXc+bNEiY3i70hetwgk142kj6H74Younuhk0MI+4DLVjVKrUcZPYrv8n02MMrrPWUrkp+AJQRTBz1IGWA4+OAFgPeDVTtDF5aAOLXa9BMhmJAw6vVxG6MXTjCNx+LVyYjOIzhlDI8CWXWN/tKRpa4ROq/+DT7xI99waVxNsE/U1k8Wnf9wTEwe4oKuE1JVCfGKBJEVnloWuTDi7iQNYJvM5W5CNZDhML+BUBkfm75VJBJXMXEiApScA+njbCQTpaIi05bnDy9W2b+3UDLPrGYpNVG3v7jP46oP/Vwce9h00hIJTncJW+zaZNQgdUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK because clearly AI slop, again.

(side note - 'page' reclaim is a misnomer now, we should just call this doc
reclaim - we reclaim folios not pages :)

Anway, again, you've not bothered finding out who maintains reclaim, I just
looked and it took me 10 seconds:

MEMORY MANAGEMENT - RECLAIM
M:	Andrew Morton <akpm@linux-foundation.org>
M:	Johannes Weiner <hannes@cmpxchg.org>
R:	David Hildenbrand <david@kernel.org> <- by chance you have David :)
R:	Michal Hocko <mhocko@kernel.org>
R:	Qi Zheng <zhengqi.arch@bytedance.com>
R:	Shakeel Butt <shakeel.butt@linux.dev>
R:	Lorenzo Stoakes <ljs@kernel.org>
L:	linux-mm@kvack.org
S:	Maintained
F:	mm/vmscan.c
F:	mm/workingset.c

You've not even done that, let alone thought to cc- anybody on that list, 5
minutes glancing over the mailing list would tell you this is is common
courtesy.

The documentation is useless hand-waving that maintainers would have to
essentially rewrite for you on 'review'.

This is not a good use of maintainer time, and we don't want stuff we could
generate ourselves.

On Sat, Mar 14, 2026 at 04:25:34PM +0100, Kit Dallege wrote:
> Fill in the page_reclaim.rst stub created in commit 481cc97349d6
> ("mm,doc: Add new documentation structure") as part of
> the structured memory management documentation following
> Mel Gorman's book outline.

You've also, again, used a copy/paste meaningless, worthless commit message - 5
minutes glacing through the linux-mm list would tell you what we expect.

I mean I say 'you', this was Claude surely?

>
> Signed-off-by: Kit Dallege <xaum.io@gmail.com>
> ---
>  Documentation/mm/page_reclaim.rst | 164 ++++++++++++++++++++++++++++++
>  1 file changed, 164 insertions(+)
>
> diff --git a/Documentation/mm/page_reclaim.rst b/Documentation/mm/page_reclaim.rst
> index 50a30b7f8ac3..bfa53bee98c2 100644
> --- a/Documentation/mm/page_reclaim.rst
> +++ b/Documentation/mm/page_reclaim.rst
> @@ -3,3 +3,167 @@
>  ============
>  Page Reclaim
>  ============
> +
> +Page reclaim frees memory by evicting pages that can be reloaded from disk
> +or regenerated.  File-backed pages are dropped (clean) or written back

Or regenerated?... This isn't doctor who?

> +(dirty); anonymous pages are swapped out.  The bulk of the implementation
> +is in ``mm/vmscan.c``.

Yeah let's not bother discuss what clean or dirty means, or why that matters, or
anything useful...

etc.

> +
> +.. contents:: :local:
> +
> +When Reclaim Runs
> +=================
> +
> +Reclaim is triggered in two ways:
> +
> +- **kswapd**: a per-node kernel thread that runs in the background when
> +  free pages in any zone drop below the low watermark.  It reclaims until
> +  free pages reach the high watermark, then sleeps.
> +
> +- **Direct reclaim**: when an allocation cannot be satisfied even after
> +  kswapd has been woken, the allocating task reclaims pages synchronously
> +  in its own context.  This adds latency to the allocation but is necessary
> +  when background reclaim cannot keep up.
> +
> +Reclaim Priority
> +================
> +
> +The reclaim path operates at decreasing priority levels (from
> +``DEF_PRIORITY`` down to 0).  At each level, a larger fraction of the LRU
> +lists is scanned.  At the default priority, only 1/4096th of pages are
> +considered; at priority 0, the entire list is scanned.
> +
> +If a full scan at priority 0 still does not free enough memory, the OOM
> +killer is invoked (see Documentation/mm/oom.rst).  This escalation
> +prevents the system from spinning indefinitely in reclaim.
> +
> +Scan Control
> +============
> +
> +Each reclaim invocation is parameterized by a ``struct scan_control`` that
> +captures the allocation context: which GFP flags were used, how many pages
> +are needed, which node or memory cgroup to reclaim from, and whether
> +writeback or swap are allowed.  This struct threads through the entire
> +reclaim stack, ensuring consistent policy at every level.
> +
> +LRU Lists
> +=========
> +
> +Each ``lruvec`` (one per node, or per node and memory cgroup combination)
> +maintains lists of pages ordered by access recency.
> +
> +Classic LRU
> +-----------
> +
> +The classic scheme uses four LRU lists per lruvec: active and inactive for
> +both anonymous and file-backed pages.  This approximates a second-chance
> +(clock) algorithm:
> +
> +- Pages start on the inactive list when first allocated.
> +- If accessed again while on the inactive list, they are promoted to the
> +  active list.
> +- Reclaim scans the inactive list and evicts pages that have not been
> +  recently accessed.
> +- To prevent the active list from growing without bound, pages are
> +  periodically demoted from active to inactive.
> +
> +The split between anonymous and file-backed lists allows the reclaim path
> +to balance eviction pressure between the two types based on their relative
> +cost.  Swapping anonymous pages is generally more expensive than dropping
> +clean file pages, so the scanner adjusts the ratio using IO cost
> +accounting and the ``vm.swappiness`` tunable.
> +
> +Multi-Gen LRU
> +-------------
> +
> +The multi-gen LRU is an alternative reclaim algorithm that groups pages
> +into generations by access time rather than a simple active/inactive
> +split.  It is documented separately in Documentation/mm/multigen_lru.rst.
> +
> +LRU Batching
> +------------
> +
> +To avoid taking the lruvec lock on every page access, LRU operations are
> +batched per-CPU (``mm/swap.c``).  Functions like ``folio_add_lru()`` and
> +``folio_mark_accessed()`` queue pages into per-CPU folio batches that are
> +drained to the actual LRU lists periodically or when the batch is full.
> +This batching is critical for scalability on systems with many CPUs.
> +
> +Reclaiming Pages
> +================
> +
> +The core reclaim loop (``shrink_node()``) divides its work between page
> +cache / anonymous pages and slab caches.  For each lruvec, it scans the
> +inactive LRU lists, evaluating each page:
> +
> +- **Clean file pages** can be dropped immediately — they can be re-read
> +  from disk.
> +- **Dirty file pages** are queued for writeback.  Reclaim typically skips
> +  them and returns later, but under severe pressure it may wait for
> +  writeback to complete.
> +- **Anonymous pages** are swapped out if swap space is available and
> +  ``vm.swappiness`` allows it.
> +- **Mapped pages** require TLB invalidation (unmapping) before they can
> +  be freed.  The rmap (reverse mapping) system is used to find and
> +  remove all page table entries pointing to the page.
> +- **Unevictable pages** (locked with ``mlock()``) are skipped entirely.
> +  See Documentation/mm/unevictable-lru.rst.
> +
> +Memory Cgroup Reclaim
> +---------------------
> +
> +When memory cgroup limits are exceeded, reclaim targets only the pages
> +belonging to that cgroup.  Each memory cgroup has its own lruvec per node,
> +so the scanner can isolate its pages without disturbing the rest of the
> +system.  ``try_to_free_mem_cgroup_pages()`` is the entry point for
> +cgroup-scoped reclaim.
> +
> +NUMA Demotion
> +-------------
> +
> +On systems with tiered memory (e.g., fast DRAM and slower persistent
> +memory), reclaim can demote pages to a slower tier instead of evicting
> +them.  This keeps the data in memory but frees the faster tier for
> +actively accessed pages.
> +
> +Shrinkers
> +=========
> +
> +Besides page cache and anonymous pages, kernel caches (dentries, inodes,
> +and driver-specific caches) are reclaimed through the shrinker interface
> +(``mm/shrinker.c``).  A shrinker registers two callbacks:
> +
> +- ``count_objects()``: report how many objects are reclaimable.
> +- ``scan_objects()``: free up to a requested number of objects.
> +
> +The reclaim path calls all registered shrinkers proportionally to the
> +amount of reclaimable memory they report.  Shrinkers are NUMA-aware: on
> +NUMA systems, each shrinker is called with the node being reclaimed so it
> +can prioritize freeing objects local to that node.
> +
> +Per-memcg shrinker tracking uses bitmap arrays (``shrinker_info``) so that
> +the reclaim path only invokes shrinkers that actually have objects in the
> +target cgroup, avoiding unnecessary work when there are many cgroups.
> +
> +Working Set Detection
> +=====================
> +
> +When a page is evicted, a compact shadow entry is stored in its place in
> +the page cache or swap cache.  The shadow records the eviction timestamp
> +(in terms of the lruvec's nonresident age counter) and the cgroup and
> +node that owned the page.
> +
> +If the page is faulted back in (a "refault"), the shadow entry allows the
> +kernel to compute the *refault distance* — how many other pages were
> +activated or evicted between this page's eviction and its refault.  If the
> +refault distance is shorter than the size of the inactive list, the page
> +was part of the active working set and is immediately activated rather
> +than placed on the inactive list.  This reduces thrashing by protecting
> +frequently accessed pages that would otherwise be repeatedly evicted and
> +refaulted.
> +
> +Shadow entries consume a small amount of memory.  To prevent them from
> +accumulating indefinitely, a shrinker reclaims shadow entries from page
> +cache radix tree nodes that contain only shadows and no actual pages.
> +
> +This logic is implemented in ``mm/workingset.c``.
> --
> 2.53.0
>
>
>

