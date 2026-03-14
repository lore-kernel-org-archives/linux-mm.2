Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AC0410706E7
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 15:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC5FA6B0093; Sat, 14 Mar 2026 11:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4506B0095; Sat, 14 Mar 2026 11:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7096B0096; Sat, 14 Mar 2026 11:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE35F6B0093
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:25:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81C4E8C7D6
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:25:40 +0000 (UTC)
X-FDA: 84545043240.22.C69949F
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id AAC6680009
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:25:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AuEjWcxw;
	spf=pass (imf02.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=xaum.io@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773501938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dIz1kkSGyHzWi6Er8nXwrnDFrMDopmJhQ9G+kvCuRCE=;
	b=i8B8oVJSWedA4gnYEsAOfdrHEx+WgHLM5HDtMUtPxo7jjWw+gCF/yVUluCLNOrG9xCTorP
	jdGe7kgEvdIL2HYPeXXPdQGx8Vb3OjZ5a0Q1L2Hsmbf3/3BFAHGqV9e/jIzV6+TSxTF62V
	HqtWVRsoFTprgY3+d3Lmc42GMmfGxtc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773501938; a=rsa-sha256;
	cv=none;
	b=PTQW1+F4jIoGb2MFtWbN5RnI7cCpsy0vjhlNwGcYlMmj4+yhnGC142jIdcJv11kB7uhXSU
	azUgAWPXA0x56efdbsHl+tmxgOcQQYbuNSIOqQ/0mYQ6vPeRn8dBEtf9GanKI+kcyeNLkl
	CSiKisOFZv67Hg7TFPZGme4u5PMGV90=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AuEjWcxw;
	spf=pass (imf02.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=xaum.io@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43b3cfc38edso124054f8f.3
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 08:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773501937; x=1774106737; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dIz1kkSGyHzWi6Er8nXwrnDFrMDopmJhQ9G+kvCuRCE=;
        b=AuEjWcxwiULdv5CRdbEpz4cKUJT4OEzKsuNEITCatgniFnPjQo+wEbAXKtEivIPlZq
         jNWcf7uVuv7fg4jAEvLde3mXLmM7RpPu+7h2UArRkByIe+tdanvKkR+r4f6vh2qRmk6E
         VYE9qkqr0YsbwAfch9EHsHFhYVGf9v2WiZxrhVjlwsJYlANg7lz30B5hGNBYPA6C+Jmt
         /Tym7iXyj2YDGzlzBAxke7OhmNEPM+HTagkRNKhPwasG7bnKqCaKnSSiLKeBKdptn4eV
         6Dz5xF00H7hG3adb9YehoAXZ2LohGljQ+FTY0W9uzAouh5MVa9UqISJaEPPGyxkM0ptP
         lDjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773501937; x=1774106737;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIz1kkSGyHzWi6Er8nXwrnDFrMDopmJhQ9G+kvCuRCE=;
        b=CMnP+g4PXr+9lZvJEeUi4UJAuF24WykWYe4Ck9PcNsAPtHpzKPPad0f+/yglll7pG3
         ziZdebCXTDIcsll594NnK3RM6E7QOJ8HzmrKolDn2FAagGt0adskI7WOsdfo4CGV6L8j
         nOSOQOQxHsRwmHxON0iopMXXJTSGE48NKDb+dVlzrQKR9PzdATxOPR7h44Pl+fnVNq6A
         6TtZwFf8UdgA1W/XXPHeOTgV9LMkw5js4yCnT+4rhHtzxC3cNAPxx1LyzvJyXLaF/gP4
         qfOro9oaLtRjXj768FN9L1UpLnfZ5QYWX09zj7z8bL2iGZUaI7/PTbEhQVUsesBoeJ3D
         47Zw==
X-Gm-Message-State: AOJu0Yz/XpiLRhyuSRhzAd3lnHQAT34NUUpj0i5iVgq7MNs3mOi0Zvad
	zXtzC1KywadCQ3DEzB6i9B+egBk7oFiKbsIBqiz6GHqjL66a8h+W8UEx4ePbYY9aJVU=
X-Gm-Gg: ATEYQzx7Smr7WQHP/yr/f9ZjwdySb3g5iWwm+cx2RWPaLBvRH1Sxk0xz3MATjiyEEx+
	WcYyrbmiZ9F2nJJpoJTC3NjjFAd/2CqlZp0PqSRlE/xzXJW3USDwesKG9GJqUE0lJOkCZ2EQKMB
	yUUxpEtIYQtCupzR+qReQwW5cWHrRBXVkv2WWnkPck4nAU3PbjzrrEbwXDgktxBqdf1owYg6l8n
	+5hQWRomUHtqhhbJFPA1MPkz9XQ4VyVMa00w311wa+cgIvVqeWWo7v6dUKuVMJfEKQ0PdS547Yk
	H47qW4Oc9adGOBRlZQk8bJ5R3jOTwJxvrWljicRNLjjV9P77zE9Fw1fsfTGKgCwlbfdRv8DWNtf
	5FKQReTVOD9t4PVv4H26ijTxSCA7CIMwEjy3+i3j4bmfBtZcQVEXYJOjycv9gHlMIXA7reujtqc
	JzhZsH3inQw7tn+OZHvakdlR1KbYWjY7ffOE87mtVH26qtE4xVo47xWfPIQJ2egQC6lQgRBsSH1
	GpFsKgSkoi4dAlp3r0gwwYyu8jGtA==
X-Received: by 2002:a05:600c:468e:b0:485:3f58:d9d with SMTP id 5b1f17b1804b1-48556714b67mr114810065e9.32.1773501936605;
        Sat, 14 Mar 2026 08:25:36 -0700 (PDT)
Received: from DESKTOP-TILNSD1.localdomain ([139.47.104.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe1a72cdsm27061433f8f.9.2026.03.14.08.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 08:25:36 -0700 (PDT)
From: Kit Dallege <xaum.io@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	corbet@lwn.net
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Kit Dallege <xaum.io@gmail.com>
Subject: [PATCH] Docs/mm: document Page Reclaim
Date: Sat, 14 Mar 2026 16:25:34 +0100
Message-ID: <20260314152534.100473-1-xaum.io@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ohoikkce7ueb55aoqm4cgff86yejiwaw
X-Rspam-User: 
X-Rspamd-Queue-Id: AAC6680009
X-Rspamd-Server: rspam12
X-HE-Tag: 1773501938-423862
X-HE-Meta: U2FsdGVkX19yXTD/EMo0euU5ck+eBFG8su3F3f+QdGdMdCjbybjhxz7Vye2DVk9pXwBRITVCxOsAcjCz4OouhpCyOVfkNLRnF1K5g5ILYh6oveyxa0ex2ZkpDOQ4fM9UfiFP1r+eS91D+XAqJahrtnbi9KMacjtafL31zf78Y95b1D+U5CffbcVd9Oig3gOIvrix52+1AyVsH8VUpAw7vxWhyOdQakHNBr3ijhNpCpNw8ZEQw2zfCaaejd5F6OfCfPoOvpMDyLD156A+tDSR33SfnOtFAQz1D6bjnLYF1iq0WMoRvP99tFpa3OKn4wzSfwc3cN4dRWV8RBC8UKFJLFqYxnsdrtX0vTFjuME74aIDQVEIijh9nJlaiqszemPmeJobVUCFPWFQYB1pfYXbOKVYymg/SiJIoUoG018Eabklc0twrPBGaA2nozAz9FlHVQYMMJuVwhsvzkkRieVg2hztxDZX2mg4/5ESoNiEcBecxrt7tL/gfs/hco7/CpbGa2ztt85HSveuG9YhWJDpCfbKY/h9mznWkDrwH0FRqs4I1PYX2UkA7StkmR9yaL7GWSpxXC0YKGIaWwbCkMoeMSa7GKQuqMVAT7I5cLaN+WtZlGXGQ4qRr+ABMqV05jWzxJOQG3LitBHE7IF43KMUV0QoleYD7zuwni2IY1eA99e36JNdtL2R5EEtI0/Y6eSNSeLwYIbauikXQ//L1V4bmL4+SCI3KscXL9ZONV8zpx/cn+ZQqdUT5Zjz2c59UZsTRCmy01A+JLBHSf0EUJOXrM2BmXmFMi4zUMqd5WDvsqQ2D7qD+IeAOcrdB2ASwmykfsqnne+g5cKKL6Uz0nV4zfub/kTJ/XUC2yoocY95s2WUjU7jPj9VqJMbq90gbfpGmQNHM19OKb0rm4UftYJVGFcqZOY5/RwIh01gyZzVknjD/Jn2t4T8Hx/+JyX0qXFZUBEJzcUCjeG2QlBTl+v
 Py7r1gtI
 kXiBmRlN3bIAxy/xjn/R5w2ejPskBAltISZy89pd5GyNe1jMOMPiG0zcE2MDEoERMQpGw5Upc7thS+zAd5RWOQTpAVs/ZdB4P7gFr/y6nWvQu2Il9B9g55Lrzuz1myyRqFGAqMIKaMfVQqFYbbER8oEogoMXLI7UlWi4iRCd7GCcfHWNLq0fEuDLkP3E6cidWTqJMbVbqHsTIlytdbiB/9s5Zq2dPQyFHij6eZIg64filvq901lziVzNjls83quFUETs9XGbJzNddjPaKCoW7p5Ynu4gTW7mgD4VGMXlFIdMIuohgRlruGS68m+r/ebcD5+GQ4f3JO4UsztpyYOagtyWe1Lp78fEvFz387aq8bSgLxRam7kCbPIt/sefZmsjMAgc524tc/XOL2rWtKEL9GBcoi6JsRCYvE9xZmiPeslYrod8cqghK/Rg9CvJQNl5qpg+grhjDA0Wrxiqvsxf3mrp2iv2F5FqphI7jFYZsFQ1iA4s7GGHDCbinCiFxP0f6i32LHaPOWgiGiX4EGV6bzD7yVpd1OEn+FiYMwG5E7Kk/Zd8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fill in the page_reclaim.rst stub created in commit 481cc97349d6
("mm,doc: Add new documentation structure") as part of
the structured memory management documentation following
Mel Gorman's book outline.

Signed-off-by: Kit Dallege <xaum.io@gmail.com>
---
 Documentation/mm/page_reclaim.rst | 164 ++++++++++++++++++++++++++++++
 1 file changed, 164 insertions(+)

diff --git a/Documentation/mm/page_reclaim.rst b/Documentation/mm/page_reclaim.rst
index 50a30b7f8ac3..bfa53bee98c2 100644
--- a/Documentation/mm/page_reclaim.rst
+++ b/Documentation/mm/page_reclaim.rst
@@ -3,3 +3,167 @@
 ============
 Page Reclaim
 ============
+
+Page reclaim frees memory by evicting pages that can be reloaded from disk
+or regenerated.  File-backed pages are dropped (clean) or written back
+(dirty); anonymous pages are swapped out.  The bulk of the implementation
+is in ``mm/vmscan.c``.
+
+.. contents:: :local:
+
+When Reclaim Runs
+=================
+
+Reclaim is triggered in two ways:
+
+- **kswapd**: a per-node kernel thread that runs in the background when
+  free pages in any zone drop below the low watermark.  It reclaims until
+  free pages reach the high watermark, then sleeps.
+
+- **Direct reclaim**: when an allocation cannot be satisfied even after
+  kswapd has been woken, the allocating task reclaims pages synchronously
+  in its own context.  This adds latency to the allocation but is necessary
+  when background reclaim cannot keep up.
+
+Reclaim Priority
+================
+
+The reclaim path operates at decreasing priority levels (from
+``DEF_PRIORITY`` down to 0).  At each level, a larger fraction of the LRU
+lists is scanned.  At the default priority, only 1/4096th of pages are
+considered; at priority 0, the entire list is scanned.
+
+If a full scan at priority 0 still does not free enough memory, the OOM
+killer is invoked (see Documentation/mm/oom.rst).  This escalation
+prevents the system from spinning indefinitely in reclaim.
+
+Scan Control
+============
+
+Each reclaim invocation is parameterized by a ``struct scan_control`` that
+captures the allocation context: which GFP flags were used, how many pages
+are needed, which node or memory cgroup to reclaim from, and whether
+writeback or swap are allowed.  This struct threads through the entire
+reclaim stack, ensuring consistent policy at every level.
+
+LRU Lists
+=========
+
+Each ``lruvec`` (one per node, or per node and memory cgroup combination)
+maintains lists of pages ordered by access recency.
+
+Classic LRU
+-----------
+
+The classic scheme uses four LRU lists per lruvec: active and inactive for
+both anonymous and file-backed pages.  This approximates a second-chance
+(clock) algorithm:
+
+- Pages start on the inactive list when first allocated.
+- If accessed again while on the inactive list, they are promoted to the
+  active list.
+- Reclaim scans the inactive list and evicts pages that have not been
+  recently accessed.
+- To prevent the active list from growing without bound, pages are
+  periodically demoted from active to inactive.
+
+The split between anonymous and file-backed lists allows the reclaim path
+to balance eviction pressure between the two types based on their relative
+cost.  Swapping anonymous pages is generally more expensive than dropping
+clean file pages, so the scanner adjusts the ratio using IO cost
+accounting and the ``vm.swappiness`` tunable.
+
+Multi-Gen LRU
+-------------
+
+The multi-gen LRU is an alternative reclaim algorithm that groups pages
+into generations by access time rather than a simple active/inactive
+split.  It is documented separately in Documentation/mm/multigen_lru.rst.
+
+LRU Batching
+------------
+
+To avoid taking the lruvec lock on every page access, LRU operations are
+batched per-CPU (``mm/swap.c``).  Functions like ``folio_add_lru()`` and
+``folio_mark_accessed()`` queue pages into per-CPU folio batches that are
+drained to the actual LRU lists periodically or when the batch is full.
+This batching is critical for scalability on systems with many CPUs.
+
+Reclaiming Pages
+================
+
+The core reclaim loop (``shrink_node()``) divides its work between page
+cache / anonymous pages and slab caches.  For each lruvec, it scans the
+inactive LRU lists, evaluating each page:
+
+- **Clean file pages** can be dropped immediately — they can be re-read
+  from disk.
+- **Dirty file pages** are queued for writeback.  Reclaim typically skips
+  them and returns later, but under severe pressure it may wait for
+  writeback to complete.
+- **Anonymous pages** are swapped out if swap space is available and
+  ``vm.swappiness`` allows it.
+- **Mapped pages** require TLB invalidation (unmapping) before they can
+  be freed.  The rmap (reverse mapping) system is used to find and
+  remove all page table entries pointing to the page.
+- **Unevictable pages** (locked with ``mlock()``) are skipped entirely.
+  See Documentation/mm/unevictable-lru.rst.
+
+Memory Cgroup Reclaim
+---------------------
+
+When memory cgroup limits are exceeded, reclaim targets only the pages
+belonging to that cgroup.  Each memory cgroup has its own lruvec per node,
+so the scanner can isolate its pages without disturbing the rest of the
+system.  ``try_to_free_mem_cgroup_pages()`` is the entry point for
+cgroup-scoped reclaim.
+
+NUMA Demotion
+-------------
+
+On systems with tiered memory (e.g., fast DRAM and slower persistent
+memory), reclaim can demote pages to a slower tier instead of evicting
+them.  This keeps the data in memory but frees the faster tier for
+actively accessed pages.
+
+Shrinkers
+=========
+
+Besides page cache and anonymous pages, kernel caches (dentries, inodes,
+and driver-specific caches) are reclaimed through the shrinker interface
+(``mm/shrinker.c``).  A shrinker registers two callbacks:
+
+- ``count_objects()``: report how many objects are reclaimable.
+- ``scan_objects()``: free up to a requested number of objects.
+
+The reclaim path calls all registered shrinkers proportionally to the
+amount of reclaimable memory they report.  Shrinkers are NUMA-aware: on
+NUMA systems, each shrinker is called with the node being reclaimed so it
+can prioritize freeing objects local to that node.
+
+Per-memcg shrinker tracking uses bitmap arrays (``shrinker_info``) so that
+the reclaim path only invokes shrinkers that actually have objects in the
+target cgroup, avoiding unnecessary work when there are many cgroups.
+
+Working Set Detection
+=====================
+
+When a page is evicted, a compact shadow entry is stored in its place in
+the page cache or swap cache.  The shadow records the eviction timestamp
+(in terms of the lruvec's nonresident age counter) and the cgroup and
+node that owned the page.
+
+If the page is faulted back in (a "refault"), the shadow entry allows the
+kernel to compute the *refault distance* — how many other pages were
+activated or evicted between this page's eviction and its refault.  If the
+refault distance is shorter than the size of the inactive list, the page
+was part of the active working set and is immediately activated rather
+than placed on the inactive list.  This reduces thrashing by protecting
+frequently accessed pages that would otherwise be repeatedly evicted and
+refaulted.
+
+Shadow entries consume a small amount of memory.  To prevent them from
+accumulating indefinitely, a shrinker reclaims shadow entries from page
+cache radix tree nodes that contain only shadows and no actual pages.
+
+This logic is implemented in ``mm/workingset.c``.
-- 
2.53.0


