Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81AE410706E7
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 15:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5026B008C; Sat, 14 Mar 2026 11:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62E26B0092; Sat, 14 Mar 2026 11:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B8026B0093; Sat, 14 Mar 2026 11:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9FB6B008C
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:25:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 462095B67E
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:25:36 +0000 (UTC)
X-FDA: 84545043072.05.F97671A
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 72892C0009
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:25:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gpCMJ1oA;
	spf=pass (imf22.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=xaum.io@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773501934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dNO6G/5iszc0dA2Qr9qRG/4piwdA9zP6EkYX9lmlJQ4=;
	b=eO78q1L5QB5kkgG1Y+xnSg1oCHKqLSITcry11S0SyqH6CoWsP4pj1LcRQhgN4PqQe9PNrS
	Ws7IwW/kc8vY9LgKzh+ofZq1WJwqgcUx/FsbH3dg4soTg/rMB/omoxArf7Xhohf3poZv+Q
	Opy8Q2HUcXZJt0mkf9Edsi1sD5kSmNQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gpCMJ1oA;
	spf=pass (imf22.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=xaum.io@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773501934; a=rsa-sha256;
	cv=none;
	b=YSuTuMHg2ZdZv/zTfJpRm/YUMggA9tFEbv509PC1F1LQBDu2rnCOjmelqEL+B61sgZKPqE
	wh3QFX0jUhmq2LYqjlesNnCgLVeypUE9GiWtaDky6czGoe8PM66at0uyWA0/pwfNTBd2C8
	tGcPs3fHd1S0zD0n2qXaROu8YBJV5Us=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48529c325f0so22960055e9.0
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 08:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773501933; x=1774106733; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dNO6G/5iszc0dA2Qr9qRG/4piwdA9zP6EkYX9lmlJQ4=;
        b=gpCMJ1oA/A1c/JhG+ZUVDjD+LIj2ims+Ydh8OoGkm0arQi9gJzBIdAG5nbnl9hptf7
         JYA/oCLrSynvTLfx5h2pbpAiMP941gMOX7lm9cZN74DB3pK7uFhzm58m1xt3ZrJ8ipC3
         EETp8KqVOsfvyLNiPNJRFRk5PFzo+OXZITkPAMRh9pLqGjOrO6GmFzsxVN69/JRJ17Dy
         tOK7yHcexp13/ywGRztGVlmXDsKiQK1PwIvN0U174mt1rqdqufChroyGSzjeOofE1NKi
         hEaAVGrmTTK5Odc8ygGhi417t3hEkbIkyPaqOgjrSxeJS920tcQm837sDQm1f2CYiSHG
         N5Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773501933; x=1774106733;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dNO6G/5iszc0dA2Qr9qRG/4piwdA9zP6EkYX9lmlJQ4=;
        b=ZsdIu4hFV0/r4Z3LB+LlCwyBirWD/gdfIpd18MXo1dmgH3LYb0EG3vMsR2aD08PUn+
         H+FadLXFvuapKvgil59+3X0VBp7dufNgsVhn/zq6BCsj6Y/Zh8nVRHjgrifmmYrZgmCH
         u0YZazyQRdggvUy8pIJJTGoAOQudJd5OO/KJ2LuO3/j0hekWf79crzlEnC14ndN8u/7B
         INN3LSgWaLsYGFbiR3cfvnhbNAM0DmSq2Fg7NlVcUfX2wz6OAaaE7JUgGu0KBtykK/ku
         mucs4ksbXatJppyf9dWCf5YH3W2kPZjCeFsHWaax8rusZq+5fbCWkyS6gvBSRT8gR1Yt
         bBaQ==
X-Gm-Message-State: AOJu0YzoQDfrM/mbWBeeNqmRTFv37fvODzyrv+lbl4byUcszUPWVR5jy
	Tx5+LuraHZfAnx9w4WF90XsDI1KhXxq/Rxw2swj29DKYYk8kffoi9m+S
X-Gm-Gg: ATEYQzyCVxBw0X3lwHguzV+j++CsmSawf5SWnBzO42FwWjfhnEOzuQ68xeOBL2nnUEs
	NoSv1vG2/T+XGsS9RPZMZemj/k15Nfd2Jmih1d9WdTyc+IMLc0VhP5K4skw1sJpDueaM0+AyI/H
	IedTYjKWxKeqnUz1b2iOomqDryf4QVr6CdDGghhdgfBbVYdz+JIV5IONdTNESAXUDXKWj8mAI0T
	xzwbSqKQ6b8W+SJx+bz9Klr+TLh5eqs4ULj4gRJaOkBDHirT8oTKv5wBTvk97xbG7EqLPb3kfsn
	hTDWLIq1ylp1fvxr79v/7PTonS8fwAl1P6DoiQSCYJfjSi6eioy4Z7cxQ0KHIcbb23b4oQA8dko
	vTb4jmZRPae36dYOJgWG1vOlzCMqMidbPd6ogJCuWqg2Mll3eWF6zd/Tqdb96jA6+tcm+eSVIrL
	QvyACKK3lx6O9ZbZbIgP1ByWx5wuidPBeXbYqGp5ywjLmJOQB78+RvYs1C2hG86pr5zMxXi73t1
	F91Q6R/HLUpzZJHKXjEktxtoemmAA==
X-Received: by 2002:a05:600c:8b72:b0:485:3c2d:d02b with SMTP id 5b1f17b1804b1-485566f7a1bmr110614145e9.22.1773501932414;
        Sat, 14 Mar 2026 08:25:32 -0700 (PDT)
Received: from DESKTOP-TILNSD1.localdomain ([139.47.104.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe20bd9csm26590350f8f.21.2026.03.14.08.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 08:25:31 -0700 (PDT)
From: Kit Dallege <xaum.io@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	corbet@lwn.net
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Kit Dallege <xaum.io@gmail.com>
Subject: [PATCH] Docs/mm: document Page Allocation
Date: Sat, 14 Mar 2026 16:25:30 +0100
Message-ID: <20260314152530.100357-1-xaum.io@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 72892C0009
X-Stat-Signature: 3aoqoctkpziq5km1pasnpbg8ujnukkgn
X-Rspam-User: 
X-HE-Tag: 1773501934-829168
X-HE-Meta: U2FsdGVkX18MVsUslcVjC9k1HvhmYQlvWZ7x3Er0TeXukDjf5rCa0fHtDUQYaViKV/ofMplFG+e0g5LeRJ081zqb6CCpzYBKP45ZjSjEmMNoKSVbAbRIwgiOvxAKD9QRGYcZwxk6z7STCDEZXRTZ5rB56YQytN81ddrmKitL/4A3vrIXkXuhlfy1iMj7qqeqLMOLrKy+VZM4GOMsiTNkLx/GNFXXbe72adSpFhGBv57qS7HXCjCeBBLueHPNSSg9barD5DeayNP0lilLQbz/NEk+YORQlIO2C9uO4QI1NsRhoKFjVyILgg5XZX/CLc0Kk5N+woyhifDksFx9WoW9tQg7Wxorslj2zRiSQXuR+6RLpGrmtDtuxV81f8WmpOhvOzx0uHg9xK3CrY6De+2vK8wffJdlqxcJlCbDgFaoy/nhUbKfEf4q/T2BbFsOgcHvOKYX+0Ya32UEXhsGNFA8+PeLc0EX1fN2dFb3V+U6zG1fF7PoBtvLRczylOM2taLwJD5EqzEnopA00ctcPZoNer8yBS4FSt/aOEMPNbj6mZR4KNK6zSbok3FO8UVwyJKR5eaKM7AB47PPrljBOmKq6RnapxUamZ/qEx1ELSusArL9VSjCcw2U4mT8KzNO/BFdUM17djo2dqGGxvMX/xLC/027wp6UsTrtUnv7VxnR26UJCrxVqz/huMJQsnfDJ9wp+x2uX70tjx1Gamsq3LA0W6DkqwtCdwWtAIczawoLcsPgxEFZhRoUeQunIzM/lb61MPoyrZ3xM6y4sFp3DYq0Oay9EAM4b1LkLwxbm/BRYGPEQ1dVGsObCcFhsQqlscVUzh1eYZyOdjvZs4ZS9L4dSznLyg8SO9BnRCAPbgZIyFjXu99Hd+YJ92tRUBzg4eIR/UgcidTprOO3doyekijn5i638wikc47XZezTg/f18Y6pD/qXFCanTnIwMnPev2vigiQPhI7Qi428Efspw4w
 jIVMAP3v
 8gEYHLA5uDZmJtJ/PXIV+VlPeT0GUVvcVd/fqbadL0OW1eRths6esIVgBwYjJkZGf0lxIIb+zFqH84JO/254cwOjInDOd4bL6u4B9qZzKI9uOq/MN5xDGdAOgYk9ayrLPYrZYLQzf2E0khaNZ3oaWgktSZy623CfB6y5QHZu7qFGb+Znpv+cf0HVSFj6q/ClKB9OXts9GWQr/cTGcc7xFkwC89czw481amakYBt1HJ9vejSwpXyzr+p7WgokXgQphL0VgI7Dba3AF3OAO0fCvBlsDQWgJmCMBSW090wowK9hzP4phZxxjeYT0+PH0vmlt6ivvj8ErIgp3xFMrG93OpA7QoVi6htrmgeP3S5VBhk62jMlDY5hQQ1qLKPDzwNQgLVBlVOS7jqa9BgtDYpijzk9AkT2KSlpPDROgL94OCEbaRiLTtQ/lXhsgJuiR188XBbn3Rn7K5tXKRpHFbpdf9ixL1/iBNf7SNrb6lK3lMTqXHegBCO2G3DWp6S/2jRvSc+CVSjM3HVdEZj2i/6mJiuvJE4nJLJWrPlVnAsOAVdw5oE4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fill in the page_allocation.rst stub created in commit 481cc97349d6
("mm,doc: Add new documentation structure") as part of
the structured memory management documentation following
Mel Gorman's book outline.

Signed-off-by: Kit Dallege <xaum.io@gmail.com>
---
 Documentation/mm/page_allocation.rst | 219 +++++++++++++++++++++++++++
 1 file changed, 219 insertions(+)

diff --git a/Documentation/mm/page_allocation.rst b/Documentation/mm/page_allocation.rst
index d9b4495561f1..4d0c1f2db9af 100644
--- a/Documentation/mm/page_allocation.rst
+++ b/Documentation/mm/page_allocation.rst
@@ -3,3 +3,222 @@
 ===============
 Page Allocation
 ===============
+
+The page allocator is the kernel's primary interface for obtaining and
+releasing physical page frames.  It is built on the buddy algorithm and
+implemented in ``mm/page_alloc.c``.
+
+.. contents:: :local:
+
+Buddy Allocator
+===============
+
+Free pages are grouped by order (power-of-two size) in per-zone
+``free_area`` arrays, where order 0 is a single page and the maximum is
+``MAX_PAGE_ORDER``.  To satisfy an allocation of order N, the allocator
+looks for a free block of that order.  If none is available, it splits a
+higher-order block in half repeatedly until one of the right size is
+produced.  When a page is freed, the allocator checks whether its "buddy"
+(the adjacent block of the same order) is also free; if so, the two are
+merged into a block of the next higher order.  This coalescing continues
+as high as possible, rebuilding large contiguous blocks over time.
+
+Migratetypes
+============
+
+Each pageblock (typically 2MB on x86) carries a migratetype tag that
+describes the kind of allocations it serves:
+
+- **MIGRATE_UNMOVABLE**: kernel allocations that cannot be relocated
+  (slab objects, page tables).
+- **MIGRATE_MOVABLE**: user pages and other content that can be migrated
+  or reclaimed (used by compaction and memory hot-remove).
+- **MIGRATE_RECLAIMABLE**: caches that can be dropped under pressure
+  (page cache, dentries).
+- **MIGRATE_CMA**: reserved for the contiguous memory allocator;
+  behaves as movable when not in use by CMA.
+- **MIGRATE_ISOLATE**: temporarily prevents allocation from a range,
+  used during compaction and memory hot-remove.
+
+When a free list for the requested migratetype is empty, the allocator
+falls back to other types in a defined order.  It may also "steal" an
+entire pageblock from another migratetype if it needs to take pages from
+it, changing the pageblock's tag to reduce future fragmentation.  This
+fallback and stealing logic is a key mechanism for balancing fragmentation
+against allocation success.
+
+Per-CPU Pagesets
+================
+
+Most order-0 allocations are served from per-CPU page lists (PCP) rather
+than the global ``free_area``.  This avoids taking the zone lock on the
+common path, which is critical for scalability on large systems.
+
+Each CPU maintains lists of free pages grouped by migratetype.  Pages are
+moved between the per-CPU lists and the buddy in batches.  The batch size
+and high watermark for each per-CPU list are tuned based on zone size and
+the number of CPUs.
+
+When a per-CPU list is empty, a batch of pages is taken from the buddy.
+When it exceeds its high watermark, excess pages are returned.
+``lru_add_drain()`` and ``drain_all_pages()`` flush per-CPU lists when
+the system needs an accurate count of free pages, such as during memory
+hot-remove.
+
+GFP Flags
+=========
+
+Every allocation request carries a set of GFP (Get Free Pages) flags,
+defined in ``include/linux/gfp.h``, that describe what the allocator is
+allowed to do:
+
+Zone selection
+  ``__GFP_DMA``, ``__GFP_DMA32``, ``__GFP_HIGHMEM``, ``__GFP_MOVABLE``
+  select the highest zone the allocation may use.  ``gfp_zone()`` maps
+  flags to a zone type; the allocator then scans the zonelist from that
+  zone downward.
+
+Reclaim and compaction
+  ``__GFP_DIRECT_RECLAIM`` allows the allocator to invoke direct reclaim.
+  ``__GFP_KSWAPD_RECLAIM`` allows it to wake kswapd.  Together these form
+  ``GFP_KERNEL``, the most common flag combination.
+
+Retry behavior
+  ``__GFP_NORETRY`` gives up after one attempt at reclaim.
+  ``__GFP_RETRY_MAYFAIL`` retries as long as progress is being made.
+  ``__GFP_NOFAIL`` never fails — the allocator retries indefinitely,
+  which is appropriate only for small allocations in contexts that
+  cannot handle failure.
+
+Migratetype
+  ``__GFP_MOVABLE`` and ``__GFP_RECLAIMABLE`` select the migratetype.
+  ``gfp_migratetype()`` maps flags to the appropriate type.
+
+Allocation Path
+===============
+
+Fast path
+---------
+
+``get_page_from_freelist()`` is the fast path.  It walks the zonelist
+(an ordered list of zones across all nodes, starting with the preferred
+node) looking for a zone with enough free pages above its watermarks.
+When it finds one, it pulls a page from the per-CPU list or buddy.
+
+The fast path also checks NUMA locality, cpuset constraints, and memory
+cgroup limits.  If no zone can satisfy the request, control passes to
+the slow path.
+
+Slow path
+---------
+
+``__alloc_pages_slowpath()`` engages increasingly aggressive measures:
+
+1. Wake kswapd to begin background reclaim.
+2. Attempt direct reclaim — the allocating task itself reclaims pages.
+3. Attempt direct compaction — migrate pages to create contiguous blocks
+   (for high-order allocations).
+4. Retry with lowered watermarks if progress was made.
+5. As a last resort, invoke the OOM killer (see Documentation/mm/oom.rst).
+
+Each step may succeed, in which case the allocation is retried.  The
+``__GFP_NORETRY``, ``__GFP_RETRY_MAYFAIL``, and ``__GFP_NOFAIL`` flags
+control how far down this chain the allocator goes.
+
+Watermarks
+==========
+
+Each zone maintains min, low, high, and promo watermarks that govern
+reclaim behavior:
+
+- **min**: below this level, only emergency allocations (those with
+  ``__GFP_MEMALLOC`` or from the OOM victim) can proceed.  Direct reclaim
+  may be triggered.
+- **low**: when free pages drop below this level, kswapd is woken to
+  begin background reclaim.
+- **high**: kswapd stops reclaiming when free pages reach this level.
+  The zone is considered "balanced."
+- **promo**: used for NUMA memory tiering; controls when kswapd stops
+  reclaiming when tier promotion is enabled.
+
+The min watermark is derived from ``vm.min_free_kbytes``.  The distance
+between watermarks is scaled by ``vm.watermark_scale_factor``.
+
+Watermark boosting temporarily raises watermarks after a pageblock is
+stolen from a different migratetype, increasing reclaim pressure to
+recover from the fragmentation event.
+
+High-Atomic Reserves
+--------------------
+
+The allocator reserves a small number of high-order pageblocks for atomic
+(non-sleeping) allocations.  When a high-order atomic allocation succeeds
+from unreserved memory, the containing pageblock is moved to the reserve.
+When memory pressure is high, unreserved pageblocks are released back to
+the general pool.
+
+Compaction
+==========
+
+Memory compaction (``mm/compaction.c``) creates contiguous free blocks for
+high-order allocations by relocating movable pages.  It runs two scanners
+across a zone: one walks from the bottom to find movable in-use pages, the
+other walks from the top to find free pages.  Movable pages are migrated
+to the free locations, consolidating free space in the middle.
+
+Sync modes
+----------
+
+Compaction operates in three modes:
+
+- **ASYNC**: skips pages that require blocking to isolate or migrate.
+  Used in the allocation fast path and by kcompactd.
+- **SYNC_LIGHT**: allows some blocking but skips pages under writeback.
+- **SYNC**: allows full blocking.  Used when direct compaction is the
+  last option before OOM.
+
+Deferral
+--------
+
+When compaction fails for a given order in a zone, it is deferred for an
+exponentially increasing number of attempts to avoid wasting CPU on zones
+that are too fragmented.  A successful high-order allocation resets the
+deferral.
+
+kcompactd
+---------
+
+Each node has a kcompactd kernel thread that performs background
+compaction.  It is woken when kswapd finishes reclaiming but high-order
+allocations are still failing due to fragmentation.  kcompactd runs at
+low priority to avoid interfering with foreground work.
+
+Capture Control
+---------------
+
+During direct compaction, the allocator uses a capture mechanism: when
+compaction frees a block of the right order, the allocation can claim it
+immediately rather than racing with other allocators on the free list.
+
+Page Isolation
+==============
+
+``mm/page_isolation.c`` supports marking pageblocks as ``MIGRATE_ISOLATE``
+to prevent new allocations from those ranges.  Existing free pages are
+moved out; the caller then migrates all in-use pages away.  Once the range
+is fully evacuated, it can be used for a contiguous allocation or taken
+offline.
+
+This mechanism is used by:
+
+- **CMA** (contiguous memory allocator): reserves regions at boot for
+  device drivers that need physically contiguous buffers.  The reserved
+  pages serve normal movable allocations until a CMA allocation claims
+  the range.
+- **Memory hot-remove**: isolates a memory block before offlining it.
+- **alloc_contig_range()**: general-purpose contiguous allocation used
+  by gigantic huge pages and other subsystems.
+
+The isolation process must handle pageblocks that straddle the requested
+range boundaries, compound pages (huge pages, THP) that overlap the
+boundary, and unmovable pages that prevent evacuation.
-- 
2.53.0


