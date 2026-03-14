Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A5110706E6
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 15:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758886B0095; Sat, 14 Mar 2026 11:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EFC86B0096; Sat, 14 Mar 2026 11:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C2F6B0098; Sat, 14 Mar 2026 11:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4BF6B0095
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:25:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F0F398C68D
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:25:42 +0000 (UTC)
X-FDA: 84545043324.19.C020367
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2507D180002
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:25:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UNI1Hfra;
	spf=pass (imf16.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=xaum.io@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773501941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0Kz3y41fQXpan3/BGcLXZfi5NToemQqFGHgZng3qvUQ=;
	b=HspDBRUjSAWMJRgkUGooUX5nJKQLnw2vffakHnlqrn4bYx7SI5+3MFvbbkEtbIO2Vnh3RX
	PBQhg8Xk+piJZmARni7WTRkoG9ud8ZSBo8/VOZ7CC0SzLYoUHugnfbTZ5ElMB/6bvAFomK
	4gOkshXPCsEkDLXiW+NaJPQjwhy0WSA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773501941; a=rsa-sha256;
	cv=none;
	b=bt/ruRLFBiFRlC7DP2E9ex0SkDuEWD6ZFjJgIkU+pxePgFSpfnmiqh1hzqi/MSlLj+zYYO
	bNPO/4OxbrqpcLoYI9miiVn5MazInJGAkYy5S6F2jrtX1AAXK2K+K104piqtvAV63BgqCl
	rbPUhubPxkoJuBykMzyWxEGxJezcGLI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UNI1Hfra;
	spf=pass (imf16.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=xaum.io@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4852f73d0a3so24183755e9.3
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 08:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773501940; x=1774106740; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0Kz3y41fQXpan3/BGcLXZfi5NToemQqFGHgZng3qvUQ=;
        b=UNI1HfraysS3pv67JxGOyBuC5yKaB2LEjcTASMgvw40gyh4n2a1750Pnq5df8GDpNF
         j4JB9ftXRi2g/TmwuQP6MKnX1Gy2XGyKlATsewrFSg8X7O+lJ0tyzlWxjfQOc8klZxaq
         fOkTAg/dpcM1MklqaAmT3Mu3H3cG1ykvv1sl5R5DrSgnrkjYM84Svt/TlkZKQ/nOd36o
         yq8LNCFvofU6a99m7Kl/1La7IYYxvZ2i2wzgbuLBlWT8+prJd1UatfMAuuBTMk30eFmo
         mPrpIyrj1Kidz3skVEyLzASZd98iXKKoCNyG+1yWxpMJBiaiGD3dtpf+5MRdv2tDd2cJ
         8g+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773501940; x=1774106740;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Kz3y41fQXpan3/BGcLXZfi5NToemQqFGHgZng3qvUQ=;
        b=ZSLiCMbGxt5DFXrjITsnalhzH0IddBM4iqOcxNnpFjcznzGvTqcrCK8G5IabIVZvMu
         DrH3AMT2nURroED3gFWrQGTnauZuthYT6cOtn3hzpfSOHjWYQFexKf6ePBm8CkKo3t9y
         zovvTeB7UjMCrHvzG2BGVupIfqRnIW382YCo40AWBWNUW0/zo/PlWnotSnftOQfKWb1J
         nvCeYlCE1LwNLbru2Im5ZN3adtPkD+4aoNqxNvTIH5xNB8izDmtdzUZIfQCxe27oLA1j
         O/HXlgNseBGye+WkhriadUZhL3SiHP8bPLR7bMmePhY6Q5IhvAezRO3VqGdK15eyc8YN
         IZpQ==
X-Gm-Message-State: AOJu0YzMnQQ4FieO8vAFjvCjihzBhLX9p7tuuA0Lk30kMNUzuwd+HASq
	f2DcyNmMEeg6zCKFg4KJ5yskaQ6reZcbVqSxc9CrvBc6QZ1y5hRTJeQg
X-Gm-Gg: ATEYQzxBWoVzXm73bg+OgUo7+TqcGrAl76rzQtCIpr6iQR8MB6oEa5cglR8bnyeMGsw
	ey3WZ4s5tmNDolqFtCYYxTZHDdUC78Z+aXxe7JPaWK2I0hN4yc/KIVFIRydcw8berGcMlh/Z2JY
	OHwtI4tKE3AN7tAit0PepOlLB0B4d9AppuB+l8ODHVda8r7IPCX8eYZW/y2sIGo2Xds5MYtlETG
	AEwNF48X5wK6HI1m92fAebTL4y5GMjwtAVEj6ao3+rLchfsB89GQ/EsFnsTam7mhHwWzzqmT1qe
	FxYqC5bYhDH2OrYlbvoaTfWYZbb8OhTaqRDH4los8XY0c/Tsm8vog5p+/yjoB6IKuVQWndyNtPh
	nVGKJA0lK6pEIvJuqJ7bFOaXIkCuzeiLaKzkxM5i3Cj2A76cWP787udciETtfw0KDOnCWTLq9Kj
	HeaUpe4TnCHfmtuV+p1ZEfqdBsDogw9CIYBL2oqbkdJpJLeHS8+VRf2ni2rGvI/Y/ifqi0+S9S5
	/P4zUUxzKqFUx27if07gz2QB8Q0yxXW6wUfhY1O
X-Received: by 2002:a05:600c:3ba4:b0:485:3f72:3230 with SMTP id 5b1f17b1804b1-485566d936dmr123975255e9.15.1773501938817;
        Sat, 14 Mar 2026 08:25:38 -0700 (PDT)
Received: from DESKTOP-TILNSD1.localdomain ([139.47.104.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe1a78cesm25752310f8f.11.2026.03.14.08.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 08:25:38 -0700 (PDT)
From: Kit Dallege <xaum.io@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	corbet@lwn.net
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Kit Dallege <xaum.io@gmail.com>
Subject: [PATCH] Docs/mm: document Swap
Date: Sat, 14 Mar 2026 16:25:36 +0100
Message-ID: <20260314152536.100531-1-xaum.io@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2507D180002
X-Stat-Signature: b7qajd7ycdsmt6nwa3dfydw31wo9jrpt
X-HE-Tag: 1773501940-102276
X-HE-Meta: U2FsdGVkX18I3BLjWWVnpue37PM20cjcTX7DdlmJnXrx/xC1Zuoaoz6RKRwPLWyhVTCQwoazx4CZGvdMdTE1qPdzzLEZKl6oX9ll+LC/A+jM65yYFZKMkBe34n+Z5sz3uexa+yZXd1W4RfTkWKVSRsFrD9/DZVDMiGuZB5mUUerwmMXoK7n75CpC7tSUpAiIdlqc1i5xfrnuSEuCed8lQjTs2P5sFM6+rBWoJ2+2tRBKe6bzxLtp1JuBjilenynaeeEsAqbcz3UzGcwsKSwwjf7uD+xHpbQzT4tbxC+OYAgeNgfmVHDcp9dFy4xggc8OlomPJChM3Ipz9LJdsnMplW1jRDOSPIas0Z7X3Omt2v7B/dqBW1bkFqShuO6iuTR/Tpp5l++rHLS38VekKKeNQ7aS3fnqiYsmVhBsvs29E5kKZIiGtfgwtGjCoR13yzrZ+lEAX9tag4bzi/kzF1pfhSYR6Otge0jUw41ZIm1QYskhAH7vXnzUuWVPqYOEV1kRJ7393l1QzC7AJ+qWlNmj1VMM5NVoPLZd3U4NFvnENLKs2eYUn3Y7aA+i8K8Drd6MkyPxT5YJffgLYTgJGyU4ebOkeCCmuZhzVt+k0EDPwLn4sfJspgFqtjKiXFGk1o6sFGQGROM+pXd6qDjP0GhwBDlMptgiEFjagWdyz+y6gtzLN+NHFhQQL5ORckLT5YzLyUGdpQDlvtYOpDUAIvjzxNGNUEuFqtJm4JLLDsymKKLMut7Y0acOO8636Q2KNCuk3WTEfVjjzyDQryu9oZF7YdsFu0iNKwDEL7yO7SH8+W3dfN9K4aQHkGEPaiUjUecsdCqLJUU3xo8MegMJvBxwUyR/3lMlHDqId+C8w7bpjT00HPsLmdQ2QigMDoQgSm9kbIBwNqs2QgupkRtR1vTrEgL9aF9IsBc9utRr8UAidi/ieLZ3SGv6qXDFim93PAlQiu7f3739WfKdg18Ibyb
 nV7JNUfK
 pbslsvs11YFE65LMhmgqscSJo/i0m57Iwqmk2xxlNUY/SvBplw3thopjgIwt5vkjuIgj5Ush/LC3dkj8DxwplEUpUJbZTmoWhIAobmCXmYngboU+lYJzJjlaEqKimt/MjAfnvNdcDdBmk3FFNw6BEtK0nDuL40y3BDNB7zB9pXR+E8rPDbDEI1hJqTrLk4Q7MIxDzHDeDom7sI0k6lVljIanq0Z06uXHmIgL1DPtgCf9aLXeH0QrlkGfPLNxsq2SVOYUys9vP3OpzI39A8Eh13XcZLD+HZprs9lFpIxTaOgvwWFdLywg4FkMVkQs6p/TWjVve7ucZK02Y0KSLSdGPDwCErfHM35tSlnVR6Xa63vVijJ0h0EzgZNQwoT0ckRL67gZsooTANWpMYNT8vdmMZYBDDL0TFl5Nb5gbSUdRupctItrKOIMVBWx5MG6Ty9uyMm7iMmwxAotyVnwOQSTDnGuVQmgz9125+tXjJutVvd1mL+1nIF4EATq757jDClzaRq6wjstjN366DLXCSd7TZuuXUIDcqTbwmcHBmV4WN13EGus=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fill in the swap.rst stub created in commit 481cc97349d6
("mm,doc: Add new documentation structure") as part of
the structured memory management documentation following
Mel Gorman's book outline.

Signed-off-by: Kit Dallege <xaum.io@gmail.com>
---
 Documentation/mm/swap.rst | 154 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 154 insertions(+)

diff --git a/Documentation/mm/swap.rst b/Documentation/mm/swap.rst
index 78819bd4d745..89a93cc081d4 100644
--- a/Documentation/mm/swap.rst
+++ b/Documentation/mm/swap.rst
@@ -3,3 +3,157 @@
 ====
 Swap
 ====
+
+Swap allows the kernel to evict anonymous pages (those not backed by a
+file) to a swap device so that physical memory can be reused.  When the
+pages are needed again, they are read back in.  The swap subsystem spans
+several files: ``mm/swapfile.c`` manages swap devices, ``mm/swap_state.c``
+implements the swap cache, ``mm/page_io.c`` handles disk I/O, and
+``mm/zswap.c`` provides an optional compressed cache layer.
+
+.. contents:: :local:
+
+Swap Entries
+============
+
+A swap entry is a compact identifier that encodes which swap device to use
+and the offset within that device.  When a page is swapped out, its page
+table entry is replaced with a swap entry so that the kernel knows where to
+find the data on a subsequent fault.  Swap entries are also used internally
+as keys into the swap cache.
+
+Swap Devices
+============
+
+A swap device is a disk partition or file registered with the ``swapon()``
+system call.  Each device is described by a ``swap_info_struct`` that holds
+the device's extent map, cluster state, and per-CPU allocation hints.
+
+The kernel maps virtual swap offsets to disk locations through a tree of
+``swap_extent`` structures.  For raw partitions the mapping is trivial
+(one extent covering the whole device); for swap files the mapping follows
+the file's block layout on disk.
+
+Cluster Allocation
+------------------
+
+Swap space is allocated in clusters (groups of contiguous slots, typically
+32 pages).  Each cluster tracks which slots are free and whether it has
+pending discards.  Per-CPU hints point to the most recently used cluster
+so that allocations from the same CPU tend to land in the same cluster,
+improving spatial locality for both SSDs and spinning disks.
+
+When a cluster is full, the allocator scans for a new one.  Under heavy
+swap pressure, it may also reclaim slots from full clusters if the pages
+they reference have since been freed or swapped back in.
+
+TRIM / Discard
+--------------
+
+For SSD-backed swap, the kernel can issue discard (TRIM) commands when
+swap slots are freed.  This is batched per-cluster: once all slots in a
+cluster are free, a single discard is issued for the entire range.  This
+avoids the overhead of per-page discards while still informing the device
+that the blocks are unused.
+
+Swap counts
+-----------
+
+Each swap slot has a reference count tracking how many page table entries
+point to it (due to ``fork()`` and copy-on-write).  For slots referenced
+by very many processes, a continuation mechanism extends the counter
+beyond its inline capacity.
+
+Swap Cache
+==========
+
+The swap cache keeps recently swapped-in (or about to be swapped-out)
+pages in memory, indexed by their swap entry.  This serves several
+purposes:
+
+- **Deduplication**: when multiple processes share a swapped page (via
+  ``fork()``), only one copy is read from disk; subsequent faults find
+  the page in the swap cache.
+- **Write coalescing**: if a page is modified and swapped out again before
+  the previous write completes, the swap cache absorbs the update without
+  issuing a new write.
+- **Readahead**: when one page is swapped in, adjacent swap entries are
+  speculatively read to exploit spatial and temporal locality.
+
+The swap cache is implemented as a per-cluster array of pointers
+(the "swap table"), providing O(1) lookup by swap entry.
+See also Documentation/mm/swap-table.rst.
+
+Readahead
+---------
+
+Swap readahead pre-fetches pages from swap before they are faulted in.
+Two strategies are used:
+
+- **Cluster readahead**: reads a window of swap entries around the faulting
+  entry, betting on spatial locality in the swap device.
+- **VMA readahead**: uses the virtual address layout to predict which swap
+  entries will be needed next, which is more effective when the access
+  pattern follows the process's address space layout rather than the swap
+  device layout.
+
+``vm.page-cluster`` controls the readahead window size (as a power of two).
+
+Compressed Swap (zswap)
+=======================
+
+zswap (``mm/zswap.c``) is an optional write-behind compressed cache that
+sits between the reclaim path and the swap device.  When reclaim evicts a
+page, zswap attempts to compress it and store the compressed data in a
+RAM-based pool (using the zsmalloc allocator).
+
+If the page is faulted back in before the pool fills, no disk I/O occurs —
+the page is decompressed directly from memory.  This is significantly
+faster than reading from even an SSD.
+
+Pool Management
+---------------
+
+Each zswap pool pairs a compression algorithm (lzo, lz4, zstd, etc.) with
+a zsmalloc memory pool.  Per-CPU compression contexts avoid lock
+contention during compression and decompression.
+
+When the pool reaches its size limit (controlled by
+``/sys/module/zswap/parameters/max_pool_percent``), the oldest entries are
+evicted: zswap writes them out to the backing swap device, falling back to
+the normal swap I/O path.  An LRU list tracks entries for this purpose.
+
+Writeback
+---------
+
+zswap writeback decompresses the page, allocates a swap slot, and writes
+the uncompressed page to the swap device.  This is the slow path —
+ideally most pages are either faulted back in from the compressed cache
+or freed without ever reaching disk.
+
+Zero-Filled Pages
+=================
+
+``mm/page_io.c`` maintains a bitmap (``swap_zeromap``) tracking swap slots
+that contained zero-filled pages.  When such a page is swapped in, the
+kernel returns a zeroed page without performing any I/O.  When a zero
+page is swapped out, the bitmap bit is set instead of issuing a write.
+This optimization is significant for workloads that allocate large amounts
+of memory that is never written to.
+
+Swap I/O
+========
+
+``mm/page_io.c`` handles the mechanics of reading and writing pages to
+swap.  The I/O path checks three layers in order before falling through to
+disk:
+
+1. The zero page bitmap — if the slot is known to be zero-filled, return
+   a zeroed page (read) or set the bit (write) with no I/O.
+2. zswap — if enabled, attempt to store/load the page in the compressed
+   cache.
+3. Block I/O — submit a bio to the swap device, using the swap extent
+   tree to map the slot to a disk sector.
+
+For swap files (as opposed to raw partitions), the I/O follows the
+filesystem's block mapping rather than issuing direct device I/O.
-- 
2.53.0


