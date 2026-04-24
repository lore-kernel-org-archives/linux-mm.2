Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 664BAFED3CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 826D66B0096; Fri, 24 Apr 2026 10:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AF756B009F; Fri, 24 Apr 2026 10:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B3C16B00A7; Fri, 24 Apr 2026 10:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 451656B0096
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:01:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF9BBA01BF
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:01:37 +0000 (UTC)
X-FDA: 84693612234.25.D95A076
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A18A9100031
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:01:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lWd+BY+X;
	spf=pass (imf05.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777039295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91B6HSz86KqP/W3RACkrZuZqSNpMSCisFH8uK0y/cxQ=;
	b=BaRbdkbpLKa0aeFnhPpSS2MefCmlcbs7vV5nfMrMTROfTZ9zfAcPNUopm6eCiaRrJ1Y1p9
	9ezbcY/upTewbRhj851JdGh9auTF/6N800ZUXsLSNnFLDjOrxr+10tyTnsJYi4InGM3xmk
	rvi8stQJ/Gs34hFVsNwIPt93sm8l7ps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777039295; a=rsa-sha256;
	cv=none;
	b=avVPvL6r8S5dgxKyLzAbUSStFO0l4RqLRLdzPP/ONDM3iHoXdem6lStLqEZjKoEKTQ7hjC
	JGNuc0l5yAq55NjOYvYh/dDpNAC/7ovSSj1IyoFlivO0dbLT7nHjO9wTEJUhnZPHzziXQ6
	Nd0P8sh2hLp1hFqLYFeC1MX70pb5nTA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lWd+BY+X;
	spf=pass (imf05.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BEA44465F;
	Fri, 24 Apr 2026 14:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2C1C2BCB2;
	Fri, 24 Apr 2026 14:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777039294;
	bh=TBKrtjv7+bLe3/01VBt+c7tfJ2DPrZzmNjtiYrqNDtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWd+BY+X4r0dkO9VbE+etNI+pKWnytTiTzOSKdmSp+7vmV8Ojf342Ge77uF1k9BlB
	 KvsGTjRejWodx3rv4U/vgPAv06riz63gFti0yJDRlZaV0f5eFxbxSn4x+8NaHsruIP
	 PAliqU2OUAkrWZY9MGTnmX4oXUQ06hc+3sn1vxskkPZyRc/w3dmlAQjI2UA9elNsZr
	 /NYOB58iwuXMHJqYGpnWPYQHhQnPJle+sp8cmcNE7p2n597BYz77oP5zmcE8KvkzEh
	 WXtqjH7wrTrbiaSIK1yG8EFZglKjmXS75h/uCNTg8ww/n+6QdnLiwOxIo4ZqeWJwJD
	 D0ujBonCYLlGA==
From: Sasha Levin <sashal@kernel.org>
To: akpm@linux-foundation.org,
	david@kernel.org,
	corbet@lwn.net
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@nvidia.com>,
	Sanif Veeras <sveeras@nvidia.com>,
	"Claude:claude-opus-4-7" <noreply@anthropic.com>
Subject: [RFC 6/7] Documentation/mm: add page consistency checker documentation
Date: Fri, 24 Apr 2026 10:00:55 -0400
Message-ID: <20260424140056.2094777-7-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424140056.2094777-1-sashal@kernel.org>
References: <20260424140056.2094777-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zn35smt8iyixamxubt54hkpo8s8f9rnq
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A18A9100031
X-Rspam-User: 
X-HE-Tag: 1777039295-192190
X-HE-Meta: U2FsdGVkX18kK04fnvHQDtq2+8vmsssWYbytTdH62+jkze6QfNxgGcc5d1N/mW2dkMIsQ0fg6e4tVD8PYNgS4wpjlRVTxZ8mGUeJpRMaY4IyZxQk7/yzFv5OqCpZ6/O598E/0OPJiw8UfO9VNoI+AbSMzkMKWuolpyhOGTQqAXdPFgFRM42vD9GJi0qq3KR+KOhgtVh/DP050BtI/SSlGYEExXoHyrSCRkxO2u2WoyFWfzBJRv7aJdRq49y5AzP8uEYJImU29Y576rE2dhw8y0mH6m3gBFSeFh9Ls6V3NzFsW+hplNJQtpGZ+My6M6o07dgzlxOxt9BKr8uQ7vxSEDApZaGaKx95GCwTNAlYfosnY5bCuEOy9Oq7FT3IBipxb0IzsMrohTYBcYbKq34CekILhzUZWoYWlaDxGj3Ea8wJhfxPQunP0zvSTUEtSK8FErTEWmRiiH9N3UYmfAJAt+oGENaszn9NBPI27sVz13RJBog9Uk8DjFiFEbBPSoTwH73eryziK6ckXJswBE+B+xRqzCB5YNB0m+fvQ42705jExN9b3qknmwhKX4l489882ZYSqsXfp3hmqY6FGM031OAqEPeYN6505+VKRNZWYF5GIFZ0ER794dD0Z/rcqckdFwc/hms1lh7u4NJK8DH6pauV86jX/MX8o0+enCOhYDcYZUMxuqI4f2pLOuHCnLkHBtpoDyf3T4RMobpDEBSNUNJBHHcxMPguVX5k83gAQ9+ND0eR4efrTqtqC6dUBiOo4T2qIHV60tNQIZnU5q3xLHuAIGf7Ixzjt3gu64i9VsPX558TH2qD0XWjEfp53rf3Z1T7fx8J43UDp6QpO74Ek/YpT19tbGgmusweEhDHR36nqleXbMDPuRzLLXG1CLykKb696mzpSudnNqDfcdrE3SRETrlkINaYKzvB67jjloE9mKfDnyWMbR1lh5R0rAmQdFlIxs3HU3FTWanLCIM
 C65U00NJ
 BpD80KMSO1da/U2QR8SJLoE27I0MKDV9yzmOgHopdvlJWlQSX7g38aGWHXBIekdiwSDmvic3xLG5MMWXqtwSFDZZPIYlBm7R/MbR7iEzjH9JUJB76QnzB1OOu4yYKozkrSJ1o/5jUdY9jdvV7DDUFB8gAEfIVvVK1HluxF9r8xARnoK9K+liAJ8D5Johrylht4Iw0E/ljEeSPRYoYAKyaZQ2J7wmEj6C8bG5PFuf/YQT/EwtAX5ziNPOOcWT4lvvREKegpUf5NbjGDRj2wIJobbpX5jEcAEZWBE6BgMl4V/5b0BI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sasha Levin <sashal@nvidia.com>

Add documentation for the page consistency checker feature. The document
explains the dual-bitmap algorithm, describes the configuration options,
and covers the debugfs interface for monitoring and validation.

The algorithm section explains how the complementary bitmaps work: the
primary bitmap uses 1 for allocated and 0 for free, while the secondary
bitmap uses the opposite convention. This redundancy means any single-bit
corruption in either bitmap will cause a detectable violation of the
invariant that primary[bit] must equal ~secondary[bit].

The document also explains the intentional limitation around double-free
detection. During boot, free_reserved_area() releases pages that were
never allocated through the buddy allocator. Flagging these as errors
would generate many false positives, so double-free detection is
deferred until after boot completes.

Based-on-patch-by: Sanif Veeras <sveeras@nvidia.com>
Assisted-by: Claude:claude-opus-4-7 <noreply@anthropic.com>
Signed-off-by: Sasha Levin <sashal@nvidia.com>
---
 Documentation/mm/index.rst            |   1 +
 Documentation/mm/page_consistency.rst | 211 ++++++++++++++++++++++++++
 2 files changed, 212 insertions(+)
 create mode 100644 Documentation/mm/page_consistency.rst

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 7aa2a8886908..bef6c9bbc976 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -57,6 +57,7 @@ documentation, or deleted if it has served its purpose.
    page_frags
    page_owner
    page_table_check
+   page_consistency
    remap_file_pages
    split_page_table_lock
    transhuge
diff --git a/Documentation/mm/page_consistency.rst b/Documentation/mm/page_consistency.rst
new file mode 100644
index 000000000000..dd1bde68f1a5
--- /dev/null
+++ b/Documentation/mm/page_consistency.rst
@@ -0,0 +1,211 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======================
+Page Consistency Checker
+=======================
+
+The page consistency checker is a debugging feature that uses dual
+complementary bitmaps to detect corruption in page allocation tracking.
+It maintains the invariant that for every bit position, the primary
+bitmap value equals the bitwise complement of the secondary bitmap value.
+
+Overview
+========
+
+Memory corruption can silently flip bits in kernel data structures,
+leading to difficult-to-diagnose failures. The page consistency checker
+addresses this by maintaining redundant tracking of page allocation
+state. Any single-bit corruption in either bitmap will cause a detectable
+inconsistency, allowing the corruption to be caught rather than causing
+silent data corruption or mysterious crashes later.
+
+The bitmaps are flat, covering the entire PFN range from
+``memblock_start_of_DRAM()`` to ``memblock_end_of_DRAM()`` including any
+holes in physical memory. This is a deliberate design choice: simple
+``pfn - min_pfn`` indexing is trivially auditable, which matters for a
+safety mechanism. Sparse or section-aware indexing would add auxiliary
+data structures that could themselves be subject to corruption. See
+`Limitations`_ for a detailed analysis of memory overhead including
+holes.
+
+The approach is based on NVIDIA safety research and is
+particularly useful for safety-critical systems requiring Freedom From
+Interference (FFI) guarantees per ISO 26262 (ASIL-D) and IEC 61508
+(SIL-3).
+
+Algorithm
+=========
+
+The checker maintains two bitmaps tracking page allocation state:
+
+Primary bitmap
+  Bit set to 1 when page is allocated, 0 when free.
+
+Secondary bitmap
+  Bit set to 0 when page is allocated, 1 when free.
+
+The invariant that must always hold is::
+
+    primary[bit] == ~secondary[bit]
+
+When a page is allocated, the checker sets the bit in the primary bitmap
+and clears it in the secondary bitmap. When freed, it clears in primary
+and sets in secondary. If the operation finds the bit already in the
+expected final state, a double-allocation or double-free has occurred.
+
+Full validation can be performed by checking that every word in the
+primary bitmap equals the bitwise complement of the corresponding word
+in the secondary bitmap.
+
+Concurrency Handling
+====================
+
+The dual-bitmap update operations (set/clear) modify both bitmaps with
+separate atomic operations. This creates a brief window where a concurrent
+validation could observe a transient inconsistency.
+
+The implementation handles this by retrying validation when an inconsistency
+is detected. Real memory corruption is persistent and will fail all retries.
+Transient inconsistencies from concurrent updates resolve quickly and pass
+on retry.
+
+Double-Free Detection
+=====================
+
+Double-free detection is deferred until the system is fully running. During
+boot, free_reserved_area() and free_initmem() release memory pages that were
+never allocated through the buddy allocator. These would appear as double-frees
+but are expected behavior.
+
+The checker uses ``system_state >= SYSTEM_RUNNING`` to determine when boot
+is complete. This state is reached only after all init memory has been freed,
+ensuring no false positives from legitimate boot-time freeing. Any attempt to
+free a page that is not marked as allocated after this point will be flagged
+as a violation.
+
+Configuration
+=============
+
+The feature is controlled by two Kconfig options:
+
+``CONFIG_DEBUG_PAGE_CONSISTENCY``
+  Enable the page consistency checker. Memory overhead is two bits per
+  PFN in the spanned range (start to end of DRAM, including holes),
+  roughly 4 MB total for a 64 GB system. When this option is disabled,
+  the allocator hooks compile away. When enabled, a static key gates
+  tracking until initialization succeeds.
+
+``CONFIG_DEBUG_PAGE_CONSISTENCY_PANIC``
+  When enabled, the kernel will panic immediately upon detecting a
+  consistency violation. When disabled, a warning with a stack trace
+  is emitted and execution continues. Safety-critical systems should
+  enable this option.
+
+Debugfs Interface
+=================
+
+When CONFIG_DEBUG_FS is enabled, the checker exposes files under
+``/sys/kernel/debug/page_consistency/``:
+
+``stats``
+  Read-only file showing tracking statistics::
+
+    pages_tracked:       12345
+    alloc_count:         67890
+    free_count:          55545
+    violations_detected: 0
+    bitmap_size_bits:    1048576
+    pfn_range:           [256-1048831]
+
+``validate``
+  Write-only file. Writing any value triggers a full validation of
+  all bitmap words. Returns success if all words are consistent,
+  or -EIO if any violations are found.
+
+Usage
+=====
+
+To use the page consistency checker:
+
+1. Enable ``CONFIG_DEBUG_PAGE_CONSISTENCY`` in your kernel configuration.
+
+2. Optionally enable ``CONFIG_DEBUG_PAGE_CONSISTENCY_PANIC`` if you want
+   the kernel to halt immediately upon detecting corruption.
+
+3. Boot the kernel. The checker will automatically initialize and begin
+   tracking page allocations.
+
+4. Monitor statistics via debugfs::
+
+     cat /sys/kernel/debug/page_consistency/stats
+
+5. Trigger manual validation::
+
+     echo 1 > /sys/kernel/debug/page_consistency/validate
+
+Limitations
+===========
+
+As described in `Overview`_, the bitmaps use a flat layout covering the
+entire spanned PFN range, including any holes. Bits corresponding to
+holes are initialized to the free state and remain inert; they maintain
+the complement invariant and never trigger false positives. The kernel's
+own ``pageblock_flags`` bitmaps use the same flat approach, sizing to
+``zone->spanned_pages`` which includes holes.
+
+Memory overhead
+---------------
+
+The cost is 2 bits per PFN in the range (1 bit per bitmap x 2 bitmaps),
+allocated via ``memblock_alloc()`` before the buddy allocator is
+available. A hole wastes ``hole_size / PAGE_SIZE / 8`` bytes per bitmap.
+In practice the waste from holes is negligible::
+
+  System         Holes    Per-bitmap size   Hole waste   Waste/bitmap
+  -----------    ------   ---------------   ----------   ------------
+  64 GB, flat    none     2 MB              0            0%
+  256 GB, flat   none     8 MB              0            0%
+  256 GB         4 GB     8.1 MB            128 KB       1.5%
+  1 TB           16 GB    32.5 MB           512 KB       1.5%
+
+On x86_64 the typical hole between low memory (below 4 GB) and high
+memory is the largest source of waste. On arm64 with
+``memblock_start_of_DRAM()`` typically at 0x80000000 (2 GB), holes
+within the DRAM range are generally small or absent.
+
+Other limitations
+-----------------
+
+The feature is incompatible with ``CONFIG_MEMORY_HOTPLUG`` because the
+bitmaps are sized at boot based on the initial physical memory range.
+Hot-added memory would fall outside the tracked PFN range and be silently
+ignored.
+
+Boot-time reserved pages are not tracked as allocations. Freeing such a
+page before ``SYSTEM_RUNNING`` is expected and is ignored by the
+double-free detector. Freeing an untracked reserved page after boot is
+reported as a double-free.
+
+The feature detects corruption in the tracking bitmaps themselves, not
+corruption in the actual page contents. For page content verification,
+see CONFIG_PAGE_POISONING.
+
+Implementation Details
+======================
+
+The checker hooks into the page allocator at two points:
+
+- ``post_alloc_hook()`` calls ``page_consistency_alloc()`` after a
+  successful allocation.
+
+- ``free_pages_prepare()`` calls ``page_consistency_free()`` when pages
+  are being returned to the allocator.
+
+Both hooks use static keys (``static_branch_unlikely``) so the overhead
+is a single no-op when the feature is disabled.
+
+The bitmaps are allocated during ``mm_core_init()`` using
+``memblock_alloc()`` before ``memblock_free_all()`` releases memblock
+memory to the buddy allocator. The secondary bitmap is initialized with
+all bits set to 1, establishing the initial complementary relationship
+with the zeroed primary bitmap.
-- 
2.53.0


