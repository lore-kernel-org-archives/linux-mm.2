Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D5B10706E4
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 15:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320236B0092; Sat, 14 Mar 2026 11:25:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3436B0093; Sat, 14 Mar 2026 11:25:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1192E6B0095; Sat, 14 Mar 2026 11:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED68B6B0092
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:25:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91C92C25D9
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:25:38 +0000 (UTC)
X-FDA: 84545043156.30.8E63EA4
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id EB1DCC000C
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:25:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E0m+um6g;
	spf=pass (imf10.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=xaum.io@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773501937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=d2eBAZtzNWnpWbtJR/5rxUrUpXwLDR+PqKZhvhnDrwI=;
	b=M/n217pRX01LpnJGwb5VBknbnzg1Qbyro0UiS5gidn56pPAm4C5rE5OZwRBw4KSTntzxMF
	xJQ3j8UfcmP2lNW5o0QF+tbB9Qo8WhSphrzU1viHUOv4Od82pzYp4aCJAo7Ka03HlgoraV
	5B8VuDTMsTln5BU9IptmGpwxV6/AP7E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773501937; a=rsa-sha256;
	cv=none;
	b=nF+A7B4KMrST9PONJXTR0jLnSiprZkUmNCrvYkuufLwEHxdwy7yVFPTUc23v07AuhNRgtN
	TO0nujQI+K0+ij8izjrP4pkQW1W1g6QWQPyAHDim8KxkFkTuWx9hmftBuPvIqT+htOyIpI
	PBY9QSJfjj1Or1vgPEeZboo75omKpUs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E0m+um6g;
	spf=pass (imf10.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=xaum.io@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4853c3c2fe7so18988045e9.0
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 08:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773501935; x=1774106735; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d2eBAZtzNWnpWbtJR/5rxUrUpXwLDR+PqKZhvhnDrwI=;
        b=E0m+um6giH2q2bDJUHyqQZePtMsKdP8vbqPb49zFGaE7QYa2RuWThza2IQHjBlSmX2
         ekZe3FSzr7wrtFoMPSXKMTCDFrJaAOwlk9LcJ9325qRNV7tR6HeUygOs6S3qM8vLiOLb
         o+eDIpnnjmrDTqDNPT/uKRfebdafNNz2gQHLga+eIwm42eRXxpf/FudefyIwwaEaKqkk
         /+NPf0x9JVhJZ9FYvDXoRY8dW2etxly79pmqa7nSWL/5YAt+konIt4a9/iwdaA1ieugW
         B7tZXJwOURTPvjct24Ylm6lXSlVuNuQc6I/OfKKhMOP/WwCwyYUNs1H6O3YXzEsrlrwS
         drbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773501935; x=1774106735;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d2eBAZtzNWnpWbtJR/5rxUrUpXwLDR+PqKZhvhnDrwI=;
        b=Tdoyz8hvXHJT6h5rfc3opQL2WewwFYUMBrt6j4bVDOqXqpLAbv0bDiZu0YX66Yk76U
         JUPv8e0Nw6Ekm7SMSxyuXujQve+COY26zpBUDMJod0o8TYFLIOe99eZcJkesenQpzawK
         ovyyb6uv+ywtVzPGDZV/kniAayH+wEfjn53DkGgSuVTV+iiStPVPox9AdBU6i0Z4mM/b
         UiMANDmTORK5TVztDOpnRtLJAsJt9+nu0d7FipFhL9P1PgiP9L+Sy659KGIhcBa8ed+k
         X79rivHwqsTig5hFgeDX4tEvCvJJv/xdxyfZfBc3+772cvWpUp3JMY+UyG3tcyDU+WxI
         w1PQ==
X-Gm-Message-State: AOJu0Yz3+VcCoh9VeXgVhmZte2tKv8gx9S4EXYA37scfBzSaNhMWOoSY
	kkI53yUWSgfQsBocUxwuUSSOtOiXMPLs3Z7gR5OmjVMLDoPIjTSDVFT0
X-Gm-Gg: ATEYQzzD6TmAuTmR7tpN+TwDHKLsF5x8y9FrgJfKzsTmwdtvfVdqe5hCYRH6IBwX/zQ
	2qFFVjadYUpeW+Wh+HODBCWdkQvCSenxWHWGCTH5uQvI8jJLW+DKw6cJDVYgsdJ1IT8aTie25iq
	SGbc5h7mBQz/l6ZeFM6Q45SOTq2AnE0tv23yslUKijdceWueq7kyuRrYCNMEygIV6Tt4r+M4/Ye
	Ut136+PK8BTwLogOTL+bRyC3tfnOMlWFSw2JZSPsy+k1noeJ+KnKDyZh9OSZqmb4B6+YovrqreZ
	+B8jLJYQuCyZTObT6VvbKI9+pbkTcw2xiLOaP0QZVpvlBa208VLQPx+/WvF7dK0573SdM74nMoW
	55eL43APa1Lpx4r7nGP3dJwCZ9fNWdYI+UeyKjuN6pTyqcBHDwnSPMmp7i+8U3vFN4OS5mxodWs
	DcJBkNNSKS8npCXq0gFNwSH1hvbCiemClzrq0HijRfHMZ6UebJWcWcRnZR1XIwDMaqC/2px9jX2
	myzn+ngb1Qfa2stZ3bWjVUi85SL4A==
X-Received: by 2002:a05:600c:3552:b0:485:3a59:99ca with SMTP id 5b1f17b1804b1-485566fab0bmr113391445e9.16.1773501934612;
        Sat, 14 Mar 2026 08:25:34 -0700 (PDT)
Received: from DESKTOP-TILNSD1.localdomain ([139.47.104.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe2273d9sm30479525f8f.34.2026.03.14.08.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 08:25:34 -0700 (PDT)
From: Kit Dallege <xaum.io@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	corbet@lwn.net
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Kit Dallege <xaum.io@gmail.com>
Subject: [PATCH] Docs/mm: document Virtually Contiguous Memory Allocation
Date: Sat, 14 Mar 2026 16:25:32 +0100
Message-ID: <20260314152532.100411-1-xaum.io@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wfrs1p9t6xdcfyrxa51779pt3f88wzz9
X-Rspam-User: 
X-Rspamd-Queue-Id: EB1DCC000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1773501936-848737
X-HE-Meta: U2FsdGVkX18JO3oNq2GkUa6JWddQf0crlAK/z8tJD4tea3tRJhDaEoU2+J42QThbJoCBRrlMTZu5zIK0XdSA6EB3wtwN4mxnlyKjDxqUONoweLjhacCyxiDqiU3AOEE9nmJs6SZUryjSaaC7V/dsQwHJA5wnjiMg1l5cbNsGblfxdrAdQBTNhTr6FcbjJ08ULX8sbk/CXKTHvgoj2+a7Lrua4hB+J0tdHqS2USgcqHmppKt3nD6BEx3T1Kc7gFXtB1kO0o9ByP0/SNCIhpoftkZFv4Br1AdBOR2j/gD5NS/48xUXSS27WOGD407c4irq7SlO+aH/Q6G+fbFQDJ4t06PFqrdnQhNsXYLb+fp+B3i4qmoXHmd2xSVXcM+/ob7zw5XgfWEaM/iKIjzrq8fDj0RNERSBQN3PgHdpyBFdTyyPozXl+3hqhOAvHpzgEL0nIOOw2cTS9tY0QrrUE7cCKQDQAxllH+X/t4WdNTRyJMhxaQYT4o7m2KS/MeOWJ/46rzIDmGABI3dv3FxTkNeIAmaio6KfBt7UenCxItlJgN6GQmjhXnKW2GzQHloq3PK0v0+IoGHQLoQZ3VjVyt3SquUgbnVnRXJWObm1uxIGpz/cgVHuxh0CfxK84hZQCKw11JZqVi8aCBtJdC+5K5wYHGLoqCqTV2cAz0L5HC6moZ1Q2eKykuD+kboKvTQ/5bTKKW/namVl9Xaau6/wrainjKXnzDv9WfhIqBzTUjM7py9a32+C0i+puEVr1wXW/TijCCLQxbM1dECZcDM1y2PnK3OALQD85V0e/cOxWQ0fvw3AJZp/GSRXcquaBYHGOtlnEq1OIrlLAuFyNRK6Rj0sLqXgcgYUxqwn6YUKK9WCBii5arD8d5Nwh49qpbXXy99H4BP0xdeRlg1l0lyErE1xEfuhp9DmQr6+6CVcmdGlYACmipPgkXec6VTCk9Anmv8I18D4E6tBDw4UVoUlF5J
 UNyrFpBI
 DrMih7Re3ahD4IC1knWxB6SEzHzZkbMPW4NNHDmbVHK5WdN+7KbbuWkjpHZ0owijJh2A29/Ls704e7sqFWEQAXj5bOOR6m26/lnNUeyGH9VvEJiQQD+RGNW9e5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fill in the vmalloc.rst stub created in commit 481cc97349d6
("mm,doc: Add new documentation structure") as part of
the structured memory management documentation following
Mel Gorman's book outline.

Signed-off-by: Kit Dallege <xaum.io@gmail.com>
---
 Documentation/mm/vmalloc.rst | 128 +++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/Documentation/mm/vmalloc.rst b/Documentation/mm/vmalloc.rst
index 363fe20d6b9f..2c478b341e73 100644
--- a/Documentation/mm/vmalloc.rst
+++ b/Documentation/mm/vmalloc.rst
@@ -3,3 +3,131 @@
 ======================================
 Virtually Contiguous Memory Allocation
 ======================================
+
+``vmalloc()`` allocates memory that is contiguous in kernel virtual address
+space but may be backed by physically discontiguous pages.  This is useful
+for large allocations where finding a contiguous physical range would be
+difficult or impossible.  The implementation is in ``mm/vmalloc.c``.
+
+.. contents:: :local:
+
+How It Works
+============
+
+A vmalloc allocation has three steps: reserve a range of kernel virtual
+addresses, allocate physical pages (individually, via the page allocator),
+and create page table mappings that connect the two.
+
+Virtual Address Management
+--------------------------
+
+The kernel reserves a large region of virtual address space for vmalloc
+(on x86-64 this is hundreds of terabytes).  Within this region, allocated
+and free ranges are tracked by ``struct vmap_area`` nodes organized in two
+red-black trees — one sorted by address for the busy areas, and one
+augmented with subtree maximum gap size for the free areas.  The augmented
+tree allows free-space searches in O(log n) time.
+
+Each allocated area also has a ``struct vm_struct`` that records the
+virtual address, size, array of backing ``struct page`` pointers, and flags
+indicating how the area was created (``VM_ALLOC`` for vmalloc,
+``VM_IOREMAP`` for I/O mappings, ``VM_MAP`` for vmap, etc.).
+
+Guard Pages
+-----------
+
+By default, each vmalloc area is surrounded by a guard page — an unmapped
+page that causes an immediate fault if code overruns the allocation.  This
+costs one page of virtual address space (not physical memory) per
+allocation.  The ``VM_NO_GUARD`` flag disables this for internal users that
+manage their own safety margins.
+
+Huge Page Support
+-----------------
+
+On architectures that support it, vmalloc can use PMD- or PUD-level
+mappings instead of individual PTEs, reducing TLB pressure for large
+allocations.  ``vmalloc_huge()`` requests this explicitly.  The decision
+is per-architecture: each architecture provides callbacks
+(``arch_vmap_pmd_supported()``, ``arch_vmap_pud_supported()``) to indicate
+which levels are available.
+
+Even when huge pages are requested, the allocator falls back to base pages
+transparently if the physical pages cannot be allocated at the required
+alignment.
+
+Lazy TLB Flushing
+-----------------
+
+Unmapping a vmalloc area requires a global TLB flush (IPI to all CPUs) to
+ensure no stale translations remain.  To amortize this cost, vmalloc defers
+the flush: page table entries are cleared immediately but the TLB
+invalidation is batched across multiple frees.  The flush is forced when
+the free area needs to be reused or when ``vm_unmap_aliases()`` is called
+explicitly.
+
+Per-CPU Allocations
+-------------------
+
+The per-CPU allocator uses vmalloc internally to obtain virtually
+contiguous backing for per-CPU variables across all CPUs.  It allocates
+multiple vmalloc areas with specific size and alignment requirements in a
+single call, ensuring that each CPU's copy is at a consistent offset from
+the per-CPU base.
+
+vmap and Temporary Mappings
+===========================
+
+Besides vmalloc (which allocates both virtual space and physical pages),
+the subsystem provides two related mechanisms:
+
+- **vmap/vunmap**: maps an existing array of ``struct page`` pointers into
+  contiguous kernel virtual space.  This is used when pages have already
+  been allocated (e.g., by a device driver) and just need a contiguous
+  kernel mapping.
+
+- **vm_map_ram/vm_unmap_ram**: lightweight temporary mappings for
+  short-lived use, with lower overhead than full vmap.
+
+Freeing
+=======
+
+``vfree()`` can be called from any context, including interrupt handlers.
+When called from interrupt context the actual work (page table teardown,
+TLB flush, page freeing) is deferred to a workqueue.  This is safe because
+the virtual address range is immediately removed from the busy tree, so no
+new mappings can be created in the freed region.
+
+Page Table Management
+=====================
+
+vmalloc maintains its own kernel page tables to map virtual addresses to
+the backing physical pages.  On allocation, page table entries are created
+at the appropriate level (PTE, PMD, or PUD depending on huge page support).
+On free, the entries are cleared.
+
+The page table setup must handle architectures where the kernel page tables
+are not shared across all CPUs.  On such systems, a vmalloc fault mechanism
+lazily propagates new mappings: when a CPU accesses a vmalloc address for
+the first time and takes a fault, the fault handler copies the page table
+entry from the reference page table (init_mm) into the CPU's page table.
+
+NUMA Awareness
+==============
+
+By default, vmalloc allocates physical pages from any NUMA node.  The
+``vmalloc_node()`` and ``vzalloc_node()`` variants prefer a specific node,
+which is useful for data structures that are predominantly accessed from
+one node.  The pages are still mapped into the global kernel virtual
+address space, so they remain accessible from all CPUs regardless of
+which node they were allocated from.
+
+KASAN Integration
+=================
+
+When KASAN (Kernel Address Sanitizer) is enabled with
+``CONFIG_KASAN_VMALLOC``, vmalloc allocates shadow memory to track the
+validity of each vmalloc region.  The shadow memory is itself vmalloc'd
+and mapped lazily.  This allows KASAN to detect out-of-bounds accesses
+and use-after-free bugs in vmalloc'd memory, which is particularly useful
+for catching bugs in kernel modules (whose code and data are vmalloc'd).
-- 
2.53.0


