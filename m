Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B793C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 13:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED4FC6B008A; Sat, 19 Sep 2026 09:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E346B008C; Sat, 19 Sep 2026 09:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54D26B0092; Sat, 19 Sep 2026 09:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6BA16B008A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 09:54:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC63DA0271
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 13:54:06 +0000 (UTC)
X-FDA: 85230655692.20.D9C18F3
Received: from mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id C56C340007
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 13:54:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cYmErVfx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789826045;
	b=LCdUBZKMg20n298JZ6KNUXD5lmATGftNU1RcOU5BgtLoO66031HKp4pNsz+3jzSDGGYavp
	Yv4KhhMm+linWYP49QBuoj6QNLS5E0WCW++IGMgOjidpYT50pMRuc3CE4ucUfm4b72wpG0
	2ztIDogXDnjvtc4qYAhA09x+67lgQHg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cYmErVfx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789826045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LfoNEn9zQpSZgGoQJRQ43Lffa3wR0daxMtiAprjTCgs=;
	b=po89w1u8mS8utehUGL5T5F4dr13GQ20EFdy72kxmwiqqCz76AgbscQiQD0/gDbAgtqc8cF
	lcaXF/LxMip+C0tROCOSy3TuaNYvR2Svm5dQ4Avr6n9E4+Z2aslrBqTpTNJt0/pxHgtAY1
	Qip703DdlYOtS+gVLkFAj5eqVtaGlV4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=f8XLjDDRDprhZX8DUAElzZf6KZ+YOj4wp6B2faOPI5s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789826043; v=1; x=1790430843;
 b=cYmErVfxbWmFKMtqK4GmCOVhvpV0tQJwQ7pvBozY5YCzvdO2PGc/qy5TljyutmATaLdiJpaK
 vQKzxjcwdn2NjJ4dRKc4TUeVzhzzcyX9zwget7RoYEANynjGrB+RR2X7INFVAJkHch5+FSZCqix
 L+zn1NnG3OSWf9czffsTZSLU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cdcfe7b929a8dca0;
	Sat, 19 Sep 2026 13:54:03 +0000
X-Mizu-Trace-ID: cdcfe7b929a8dca0
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>
Cc: Priyanshu Kumar <priyanshukumarpu@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v2 2/3] memblock tests: Move exact nid tests to memblock_alloc_range_nid()
Date: Sat, 19 Sep 2026 21:53:26 +0800
Message-ID: <20260919135327.74089-3-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260919135327.74089-1-kaitao.cheng@linux.dev>
References: <20260919135327.74089-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C56C340007
X-Stat-Signature: 39s39qff9q6fmp7x4yajac8srdpbajhs
X-HE-Tag: 1789826044-549870
X-HE-Meta: U2FsdGVkX18cebpA2hz8H2txSW/1/VTeGlel3Ni8ULD7Zu+Jktfi/nu67iUpTBm2Div03itF5tBPLR/wZZUQGf1HDkA/6EBP3IFo/ySZQSRvV0cikgnbjXonRx5Oqy3lKn6zHKna6PnpkbM0pX2v1sQLl/LLT5kbK7SJUUhFnxZCil3cHL7heycP1cPiMoR8JFY1aDDhKX0oklBn+y7ZDtqFUi0a83K1RAJKOwAeQUFMtu/0/lrM04iXFzopTkbqHxswtkvpdvsFYr92VSvdbtch80BokVixevInpo+07y9W2bi2jlgiWn/OddFxyvC/2mi2jZSeYh9FDAyWiACGgZv8pggAS0bRCntR+IhV1y8hsS5bMwPhlxINgksUNMpR6/Ad/36sDqilVL3AcGIcxnphBhOcjLE21tqY5t2DGEOLo/eEGT9M7howDvAaMmfFwOjz2qRc2LaWkzaznFIxkKes9hGzYKmpMHXYFcpik6Q5pxYS2yzAlTI8thsMPDKL3wDVz0NDJxQ5MxfQ6jd4ye5uRrlZ3TawpdgQhXH2qE/jO6pnHWJXXcq2pTYLd/5Qo02rgypK54fMs4k3JlrGccwiUgMjd6bM3cKRjKoI0PhUPDbN3o0pAGZi0vR+GU0b5Mfh7AuzV5C4X9D4xuPJm9WY6Rqurf8yTIhbfY5tuRbTRgwzDQjzOg2Z5bS4LwOMlj1/D+vYaXodtRhe8f9FoifzzNdqLWelH0rkFSmqwzxA3GXAO9dK/G2jIrReZbtoLp93O5FtFewwQeQ/6g5TfIqjinZFuqJoQ5H4PKdmv5Z/iUDcfF6Ojufm2oH5gVeyQnNWfjvRry0lPjsaIFKT5u5qLfcrJdxAlvvTQJx0fUuNYVM8Mz0gfHUm/Ss3mzggsJNQU1iBqLp+01hgpN1+Fq5/SkLqBGS2TBNh6zH+cxddGsHejfLDe/FgnnXmhtQX+4wSy+LMeBBBWiSCQzp
 lSHAsZSo
 zmOduCoipe+sTSnLCQs0pjImupZgD7USCq2tKsGV7SPFaoysWop1l8Rr5iHLemDY3syzManSG0h0sG0fI6H1R5SCHjVDFQiASa6b94rdYJphgV0k29XvDKcHoT9IU4wUcfJteK+3gBGcm9Yzmhy9LT5mG04AE+K5Zkt4hZb3NjjDYhw3gZn5OM0MI9bsYv6W+fi82d3nwzoxkSf0+0SRObrLyBf1GsQrv/upbFeeG33G9k5YDjLcTPL1O+ehkR0jEs4q5WeXHTwtThbybZw6RJL462MxfICnv+cQnEzMK2zZcArQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

After memmap_alloc() stopped requesting allocations from an exact NUMA
node, memblock_alloc_exact_nid_raw() no longer has any in-kernel users
and is being removed.

Preserve coverage of exact-node allocation by converting the applicable
NUMA tests to call memblock_alloc_range_nid() with exact_nid set. Remove
the tests that depend on memblock_alloc_internal() retrying below
min_addr, as memblock_alloc_range_nid() treats its address range as a
hard constraint.

Remove the now-unused TEST_F_EXACT support from the shared allocation
tests.

Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 .../memblock/tests/alloc_exact_nid_api.c      | 454 ++----------------
 tools/testing/memblock/tests/alloc_nid_api.c  |  20 -
 tools/testing/memblock/tests/alloc_nid_api.h  |   1 -
 tools/testing/memblock/tests/common.h         |   2 -
 4 files changed, 37 insertions(+), 440 deletions(-)

diff --git a/tools/testing/memblock/tests/alloc_exact_nid_api.c b/tools/testing/memblock/tests/alloc_exact_nid_api.c
index 0c46c73b5e04..52c63d011870 100644
--- a/tools/testing/memblock/tests/alloc_exact_nid_api.c
+++ b/tools/testing/memblock/tests/alloc_exact_nid_api.c
@@ -1,8 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 #include "alloc_exact_nid_api.h"
-#include "alloc_nid_api.h"
 
-#define FUNC_NAME			"memblock_alloc_exact_nid_raw"
+#define FUNC_NAME			"memblock_alloc_range_nid(exact)"
 
 /*
  * contains the fraction of MEM_SIZE contained in each node in basis point
@@ -19,6 +18,18 @@ static const unsigned int node_fractions[] = {
 	 625, /* 1/16 */
 };
 
+static void *alloc_range_exact_nid(phys_addr_t size, phys_addr_t align,
+				   phys_addr_t min_addr,
+				   phys_addr_t max_addr, int nid)
+{
+	phys_addr_t addr;
+
+	addr = memblock_alloc_range_nid(size, align, min_addr, max_addr, nid,
+					true);
+
+	return addr ? phys_to_virt(addr) : NULL;
+}
+
 /*
  * A test that tries to allocate a memory region in a specific NUMA node that
  * has enough memory to allocate a region of the requested size.
@@ -42,9 +53,8 @@ static int alloc_exact_nid_top_down_numa_simple_check(void)
 	min_addr = memblock_start_of_DRAM();
 	max_addr = memblock_end_of_DRAM();
 
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
+	allocated_ptr = alloc_range_exact_nid(size, SMP_CACHE_BYTES,
+					      min_addr, max_addr, nid_req);
 
 	ASSERT_NE(allocated_ptr, NULL);
 	ASSERT_MEM_NE(allocated_ptr, 0, size);
@@ -98,9 +108,8 @@ static int alloc_exact_nid_top_down_numa_part_reserved_check(void)
 	max_addr = memblock_end_of_DRAM();
 
 	memblock_reserve(r1.base, r1.size);
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
+	allocated_ptr = alloc_range_exact_nid(size, SMP_CACHE_BYTES,
+					      min_addr, max_addr, nid_req);
 
 	ASSERT_NE(allocated_ptr, NULL);
 	ASSERT_MEM_NE(allocated_ptr, 0, size);
@@ -117,177 +126,6 @@ static int alloc_exact_nid_top_down_numa_part_reserved_check(void)
 	return 0;
 }
 
-/*
- * A test that tries to allocate a memory region that spans over the min_addr
- * and max_addr range and overlaps with two different nodes, where the first
- * node is the requested node:
- *
- *                                min_addr
- *                                |           max_addr
- *                                |           |
- *                                v           v
- *  |           +-----------------------+-----------+              |
- *  |           |       requested       |   node3   |              |
- *  +-----------+-----------------------+-----------+--------------+
- *                                +           +
- *  |                       +-----------+                          |
- *  |                       |    rgn    |                          |
- *  +-----------------------+-----------+--------------------------+
- *
- * Expect to drop the lower limit and allocate a memory region that ends at
- * the end of the requested node.
- */
-static int alloc_exact_nid_top_down_numa_split_range_low_check(void)
-{
-	int nid_req = 2;
-	struct memblock_region *new_rgn = &memblock.reserved.regions[0];
-	struct memblock_region *req_node = &memblock.memory.regions[nid_req];
-	void *allocated_ptr = NULL;
-	phys_addr_t size = SZ_512;
-	phys_addr_t min_addr;
-	phys_addr_t max_addr;
-	phys_addr_t req_node_end;
-
-	PREFIX_PUSH();
-	setup_numa_memblock(node_fractions);
-
-	req_node_end = region_end(req_node);
-	min_addr = req_node_end - SZ_256;
-	max_addr = min_addr + size;
-
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
-
-	ASSERT_NE(allocated_ptr, NULL);
-	ASSERT_MEM_NE(allocated_ptr, 0, size);
-
-	ASSERT_EQ(new_rgn->size, size);
-	ASSERT_EQ(new_rgn->base, req_node_end - size);
-	ASSERT_LE(req_node->base, new_rgn->base);
-
-	ASSERT_EQ(memblock.reserved.cnt, 1);
-	ASSERT_EQ(memblock.reserved.total_size, size);
-
-	test_pass_pop();
-
-	return 0;
-}
-
-/*
- * A test that tries to allocate a memory region that spans over the min_addr
- * and max_addr range and overlaps with two different nodes, where the requested
- * node ends before min_addr:
- *
- *                                         min_addr
- *                                         |         max_addr
- *                                         |         |
- *                                         v         v
- *  |    +---------------+        +-------------+---------+          |
- *  |    |   requested   |        |    node1    |  node2  |          |
- *  +----+---------------+--------+-------------+---------+----------+
- *                                         +         +
- *  |          +---------+                                           |
- *  |          |   rgn   |                                           |
- *  +----------+---------+-------------------------------------------+
- *
- * Expect to drop the lower limit and allocate a memory region that ends at
- * the end of the requested node.
- */
-static int alloc_exact_nid_top_down_numa_no_overlap_split_check(void)
-{
-	int nid_req = 2;
-	struct memblock_region *new_rgn = &memblock.reserved.regions[0];
-	struct memblock_region *req_node = &memblock.memory.regions[nid_req];
-	struct memblock_region *node2 = &memblock.memory.regions[6];
-	void *allocated_ptr = NULL;
-	phys_addr_t size;
-	phys_addr_t min_addr;
-	phys_addr_t max_addr;
-
-	PREFIX_PUSH();
-	setup_numa_memblock(node_fractions);
-
-	size = SZ_512;
-	min_addr = node2->base - SZ_256;
-	max_addr = min_addr + size;
-
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
-
-	ASSERT_NE(allocated_ptr, NULL);
-	ASSERT_MEM_NE(allocated_ptr, 0, size);
-
-	ASSERT_EQ(new_rgn->size, size);
-	ASSERT_EQ(new_rgn->base, region_end(req_node) - size);
-	ASSERT_LE(req_node->base, new_rgn->base);
-
-	ASSERT_EQ(memblock.reserved.cnt, 1);
-	ASSERT_EQ(memblock.reserved.total_size, size);
-
-	test_pass_pop();
-
-	return 0;
-}
-
-/*
- * A test that tries to allocate memory within min_addr and max_add range when
- * the requested node and the range do not overlap, and requested node ends
- * before min_addr. The range overlaps with multiple nodes along node
- * boundaries:
- *
- *                          min_addr
- *                          |                                 max_addr
- *                          |                                 |
- *                          v                                 v
- *  |-----------+           +----------+----...----+----------+      |
- *  | requested |           | min node |    ...    | max node |      |
- *  +-----------+-----------+----------+----...----+----------+------+
- *                          +                                 +
- *  |     +-----+                                                    |
- *  |     | rgn |                                                    |
- *  +-----+-----+----------------------------------------------------+
- *
- * Expect to drop the lower limit and allocate a memory region that ends at
- * the end of the requested node.
- */
-static int alloc_exact_nid_top_down_numa_no_overlap_low_check(void)
-{
-	int nid_req = 0;
-	struct memblock_region *new_rgn = &memblock.reserved.regions[0];
-	struct memblock_region *req_node = &memblock.memory.regions[nid_req];
-	struct memblock_region *min_node = &memblock.memory.regions[2];
-	struct memblock_region *max_node = &memblock.memory.regions[5];
-	void *allocated_ptr = NULL;
-	phys_addr_t size = SZ_64;
-	phys_addr_t max_addr;
-	phys_addr_t min_addr;
-
-	PREFIX_PUSH();
-	setup_numa_memblock(node_fractions);
-
-	min_addr = min_node->base;
-	max_addr = region_end(max_node);
-
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
-
-	ASSERT_NE(allocated_ptr, NULL);
-	ASSERT_MEM_NE(allocated_ptr, 0, size);
-
-	ASSERT_EQ(new_rgn->size, size);
-	ASSERT_EQ(new_rgn->base, region_end(req_node) - size);
-
-	ASSERT_EQ(memblock.reserved.cnt, 1);
-	ASSERT_EQ(memblock.reserved.total_size, size);
-
-	test_pass_pop();
-
-	return 0;
-}
-
 /*
  * A test that tries to allocate a memory region in a specific NUMA node that
  * has enough memory to allocate a region of the requested size.
@@ -311,9 +149,8 @@ static int alloc_exact_nid_bottom_up_numa_simple_check(void)
 	min_addr = memblock_start_of_DRAM();
 	max_addr = memblock_end_of_DRAM();
 
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
+	allocated_ptr = alloc_range_exact_nid(size, SMP_CACHE_BYTES,
+					      min_addr, max_addr, nid_req);
 
 	ASSERT_NE(allocated_ptr, NULL);
 	ASSERT_MEM_NE(allocated_ptr, 0, size);
@@ -369,9 +206,8 @@ static int alloc_exact_nid_bottom_up_numa_part_reserved_check(void)
 	total_size = size + r1.size;
 
 	__memblock_reserve(r1.base, r1.size, nid_req, MEMBLOCK_RSRV_KERN);
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
+	allocated_ptr = alloc_range_exact_nid(size, SMP_CACHE_BYTES,
+					      min_addr, max_addr, nid_req);
 
 	ASSERT_NE(allocated_ptr, NULL);
 	ASSERT_MEM_NE(allocated_ptr, 0, size);
@@ -388,178 +224,6 @@ static int alloc_exact_nid_bottom_up_numa_part_reserved_check(void)
 	return 0;
 }
 
-/*
- * A test that tries to allocate a memory region that spans over the min_addr
- * and max_addr range and overlaps with two different nodes, where the first
- * node is the requested node:
- *
- *                                min_addr
- *                                |           max_addr
- *                                |           |
- *                                v           v
- *  |           +-----------------------+-----------+              |
- *  |           |       requested       |   node3   |              |
- *  +-----------+-----------------------+-----------+--------------+
- *                                +           +
- *  |           +-----------+                                      |
- *  |           |    rgn    |                                      |
- *  +-----------+-----------+--------------------------------------+
- *
- * Expect to drop the lower limit and allocate a memory region at the beginning
- * of the requested node.
- */
-static int alloc_exact_nid_bottom_up_numa_split_range_low_check(void)
-{
-	int nid_req = 2;
-	struct memblock_region *new_rgn = &memblock.reserved.regions[0];
-	struct memblock_region *req_node = &memblock.memory.regions[nid_req];
-	void *allocated_ptr = NULL;
-	phys_addr_t size = SZ_512;
-	phys_addr_t min_addr;
-	phys_addr_t max_addr;
-	phys_addr_t req_node_end;
-
-	PREFIX_PUSH();
-	setup_numa_memblock(node_fractions);
-
-	req_node_end = region_end(req_node);
-	min_addr = req_node_end - SZ_256;
-	max_addr = min_addr + size;
-
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
-
-	ASSERT_NE(allocated_ptr, NULL);
-	ASSERT_MEM_NE(allocated_ptr, 0, size);
-
-	ASSERT_EQ(new_rgn->size, size);
-	ASSERT_EQ(new_rgn->base, req_node->base);
-	ASSERT_LE(region_end(new_rgn), req_node_end);
-
-	ASSERT_EQ(memblock.reserved.cnt, 1);
-	ASSERT_EQ(memblock.reserved.total_size, size);
-
-	test_pass_pop();
-
-	return 0;
-}
-
-/*
- * A test that tries to allocate a memory region that spans over the min_addr
- * and max_addr range and overlaps with two different nodes, where the requested
- * node ends before min_addr:
- *
- *                                          min_addr
- *                                         |         max_addr
- *                                         |         |
- *                                         v         v
- *  |    +---------------+        +-------------+---------+         |
- *  |    |   requested   |        |    node1    |  node2  |         |
- *  +----+---------------+--------+-------------+---------+---------+
- *                                         +         +
- *  |    +---------+                                                |
- *  |    |   rgn   |                                                |
- *  +----+---------+------------------------------------------------+
- *
- * Expect to drop the lower limit and allocate a memory region that starts at
- * the beginning of the requested node.
- */
-static int alloc_exact_nid_bottom_up_numa_no_overlap_split_check(void)
-{
-	int nid_req = 2;
-	struct memblock_region *new_rgn = &memblock.reserved.regions[0];
-	struct memblock_region *req_node = &memblock.memory.regions[nid_req];
-	struct memblock_region *node2 = &memblock.memory.regions[6];
-	void *allocated_ptr = NULL;
-	phys_addr_t size;
-	phys_addr_t min_addr;
-	phys_addr_t max_addr;
-
-	PREFIX_PUSH();
-	setup_numa_memblock(node_fractions);
-
-	size = SZ_512;
-	min_addr = node2->base - SZ_256;
-	max_addr = min_addr + size;
-
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
-
-	ASSERT_NE(allocated_ptr, NULL);
-	ASSERT_MEM_NE(allocated_ptr, 0, size);
-
-	ASSERT_EQ(new_rgn->size, size);
-	ASSERT_EQ(new_rgn->base, req_node->base);
-	ASSERT_LE(region_end(new_rgn), region_end(req_node));
-
-	ASSERT_EQ(memblock.reserved.cnt, 1);
-	ASSERT_EQ(memblock.reserved.total_size, size);
-
-	test_pass_pop();
-
-	return 0;
-}
-
-/*
- * A test that tries to allocate memory within min_addr and max_add range when
- * the requested node and the range do not overlap, and requested node ends
- * before min_addr. The range overlaps with multiple nodes along node
- * boundaries:
- *
- *                          min_addr
- *                          |                                 max_addr
- *                          |                                 |
- *                          v                                 v
- *  |-----------+           +----------+----...----+----------+      |
- *  | requested |           | min node |    ...    | max node |      |
- *  +-----------+-----------+----------+----...----+----------+------+
- *                          +                                 +
- *  |-----+                                                          |
- *  | rgn |                                                          |
- *  +-----+----------------------------------------------------------+
- *
- * Expect to drop the lower limit and allocate a memory region that starts at
- * the beginning of the requested node.
- */
-static int alloc_exact_nid_bottom_up_numa_no_overlap_low_check(void)
-{
-	int nid_req = 0;
-	struct memblock_region *new_rgn = &memblock.reserved.regions[0];
-	struct memblock_region *req_node = &memblock.memory.regions[nid_req];
-	struct memblock_region *min_node = &memblock.memory.regions[2];
-	struct memblock_region *max_node = &memblock.memory.regions[5];
-	void *allocated_ptr = NULL;
-	phys_addr_t size = SZ_64;
-	phys_addr_t max_addr;
-	phys_addr_t min_addr;
-
-	PREFIX_PUSH();
-	setup_numa_memblock(node_fractions);
-
-	min_addr = min_node->base;
-	max_addr = region_end(max_node);
-
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
-
-	ASSERT_NE(allocated_ptr, NULL);
-	ASSERT_MEM_NE(allocated_ptr, 0, size);
-
-	ASSERT_EQ(new_rgn->size, size);
-	ASSERT_EQ(new_rgn->base, req_node->base);
-	ASSERT_LE(region_end(new_rgn), region_end(req_node));
-
-	ASSERT_EQ(memblock.reserved.cnt, 1);
-	ASSERT_EQ(memblock.reserved.total_size, size);
-
-	test_pass_pop();
-
-	return 0;
-}
-
 /*
  * A test that tries to allocate a memory region in a specific NUMA node that
  * does not have enough memory to allocate a region of the requested size:
@@ -590,9 +254,8 @@ static int alloc_exact_nid_numa_small_node_generic_check(void)
 	min_addr = memblock_start_of_DRAM();
 	max_addr = memblock_end_of_DRAM();
 
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
+	allocated_ptr = alloc_range_exact_nid(size, SMP_CACHE_BYTES,
+					      min_addr, max_addr, nid_req);
 
 	ASSERT_EQ(allocated_ptr, NULL);
 
@@ -632,9 +295,8 @@ static int alloc_exact_nid_numa_node_reserved_generic_check(void)
 	max_addr = memblock_end_of_DRAM();
 
 	memblock_reserve(req_node->base, req_node->size);
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
+	allocated_ptr = alloc_range_exact_nid(size, SMP_CACHE_BYTES,
+					      min_addr, max_addr, nid_req);
 
 	ASSERT_EQ(allocated_ptr, NULL);
 
@@ -680,9 +342,8 @@ static int alloc_exact_nid_numa_part_reserved_fail_generic_check(void)
 	max_addr = memblock_end_of_DRAM();
 
 	memblock_reserve(r1.base, r1.size);
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
+	allocated_ptr = alloc_range_exact_nid(size, SMP_CACHE_BYTES,
+					      min_addr, max_addr, nid_req);
 
 	ASSERT_EQ(allocated_ptr, NULL);
 
@@ -721,9 +382,8 @@ static int alloc_exact_nid_numa_split_range_high_generic_check(void)
 	min_addr = req_node->base - SZ_256;
 	max_addr = min_addr + size;
 
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
+	allocated_ptr = alloc_range_exact_nid(size, SMP_CACHE_BYTES,
+					      min_addr, max_addr, nid_req);
 
 	ASSERT_EQ(allocated_ptr, NULL);
 
@@ -764,9 +424,8 @@ static int alloc_exact_nid_numa_no_overlap_high_generic_check(void)
 	min_addr = min_node->base;
 	max_addr = region_end(max_node);
 
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
+	allocated_ptr = alloc_range_exact_nid(size, SMP_CACHE_BYTES,
+					      min_addr, max_addr, nid_req);
 
 	ASSERT_EQ(allocated_ptr, NULL);
 
@@ -803,9 +462,8 @@ static int alloc_exact_nid_numa_large_region_generic_check(void)
 	min_addr = memblock_start_of_DRAM();
 	max_addr = memblock_end_of_DRAM();
 
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
+	allocated_ptr = alloc_range_exact_nid(size, SMP_CACHE_BYTES,
+					      min_addr, max_addr, nid_req);
 	ASSERT_EQ(allocated_ptr, NULL);
 
 	test_pass_pop();
@@ -864,9 +522,8 @@ static int alloc_exact_nid_numa_reserved_full_merge_generic_check(void)
 	__memblock_reserve(r1.base, r1.size, nid_req, MEMBLOCK_RSRV_KERN);
 	__memblock_reserve(r2.base, r2.size, nid_req, MEMBLOCK_RSRV_KERN);
 
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     nid_req);
+	allocated_ptr = alloc_range_exact_nid(size, SMP_CACHE_BYTES,
+					      min_addr, max_addr, nid_req);
 
 	ASSERT_NE(allocated_ptr, NULL);
 	ASSERT_MEM_NE(allocated_ptr, 0, size);
@@ -933,9 +590,8 @@ static int alloc_exact_nid_numa_split_all_reserved_generic_check(void)
 	memblock_reserve(r1.base, r1.size);
 	memblock_reserve(r2.base, r2.size);
 
-	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
-						     min_addr, max_addr,
-						     NUMA_NO_NODE);
+	allocated_ptr = alloc_range_exact_nid(size, SMP_CACHE_BYTES,
+					      min_addr, max_addr, NUMA_NO_NODE);
 
 	ASSERT_EQ(allocated_ptr, NULL);
 
@@ -967,38 +623,6 @@ static int alloc_exact_nid_numa_part_reserved_check(void)
 	return 0;
 }
 
-static int alloc_exact_nid_numa_split_range_low_check(void)
-{
-	test_print("\tRunning %s...\n", __func__);
-	memblock_set_bottom_up(false);
-	alloc_exact_nid_top_down_numa_split_range_low_check();
-	memblock_set_bottom_up(true);
-	alloc_exact_nid_bottom_up_numa_split_range_low_check();
-
-	return 0;
-}
-
-static int alloc_exact_nid_numa_no_overlap_split_check(void)
-{
-	test_print("\tRunning %s...\n", __func__);
-	memblock_set_bottom_up(false);
-	alloc_exact_nid_top_down_numa_no_overlap_split_check();
-	memblock_set_bottom_up(true);
-	alloc_exact_nid_bottom_up_numa_no_overlap_split_check();
-
-	return 0;
-}
-
-static int alloc_exact_nid_numa_no_overlap_low_check(void)
-{
-	test_print("\tRunning %s...\n", __func__);
-	memblock_set_bottom_up(false);
-	alloc_exact_nid_top_down_numa_no_overlap_low_check();
-	memblock_set_bottom_up(true);
-	alloc_exact_nid_bottom_up_numa_no_overlap_low_check();
-
-	return 0;
-}
 
 static int alloc_exact_nid_numa_small_node_check(void)
 {
@@ -1078,9 +702,6 @@ int __memblock_alloc_exact_nid_numa_checks(void)
 
 	alloc_exact_nid_numa_simple_check();
 	alloc_exact_nid_numa_part_reserved_check();
-	alloc_exact_nid_numa_split_range_low_check();
-	alloc_exact_nid_numa_no_overlap_split_check();
-	alloc_exact_nid_numa_no_overlap_low_check();
 
 	alloc_exact_nid_numa_small_node_check();
 	alloc_exact_nid_numa_node_reserved_check();
@@ -1102,7 +723,6 @@ int memblock_alloc_exact_nid_checks(void)
 	reset_memblock_attributes();
 	dummy_physical_memory_init();
 
-	memblock_alloc_exact_nid_range_checks();
 	memblock_alloc_exact_nid_numa_checks();
 
 	dummy_physical_memory_cleanup();
diff --git a/tools/testing/memblock/tests/alloc_nid_api.c b/tools/testing/memblock/tests/alloc_nid_api.c
index c04923532159..3dd4c0bebc41 100644
--- a/tools/testing/memblock/tests/alloc_nid_api.c
+++ b/tools/testing/memblock/tests/alloc_nid_api.c
@@ -20,8 +20,6 @@ static const unsigned int node_fractions[] = {
 
 static inline const char * const get_memblock_alloc_nid_name(int flags)
 {
-	if (flags & TEST_F_EXACT)
-		return "memblock_alloc_exact_nid_raw";
 	if (flags & TEST_F_RAW)
 		return "memblock_alloc_try_nid_raw";
 	return "memblock_alloc_try_nid";
@@ -32,15 +30,6 @@ static inline void *run_memblock_alloc_nid(phys_addr_t size,
 					   phys_addr_t min_addr,
 					   phys_addr_t max_addr, int nid)
 {
-	assert(!(alloc_nid_test_flags & TEST_F_EXACT) ||
-	       (alloc_nid_test_flags & TEST_F_RAW));
-	/*
-	 * TEST_F_EXACT should be checked before TEST_F_RAW since
-	 * memblock_alloc_exact_nid_raw() performs raw allocations.
-	 */
-	if (alloc_nid_test_flags & TEST_F_EXACT)
-		return memblock_alloc_exact_nid_raw(size, align, min_addr,
-						    max_addr, nid);
 	if (alloc_nid_test_flags & TEST_F_RAW)
 		return memblock_alloc_try_nid_raw(size, align, min_addr,
 						  max_addr, nid);
@@ -2722,12 +2711,3 @@ int memblock_alloc_nid_checks(void)
 
 	return 0;
 }
-
-int memblock_alloc_exact_nid_range_checks(void)
-{
-	alloc_nid_test_flags = (TEST_F_RAW | TEST_F_EXACT);
-
-	memblock_alloc_nid_range_checks();
-
-	return 0;
-}
diff --git a/tools/testing/memblock/tests/alloc_nid_api.h b/tools/testing/memblock/tests/alloc_nid_api.h
index 2b8cabacacb8..92d07d230e18 100644
--- a/tools/testing/memblock/tests/alloc_nid_api.h
+++ b/tools/testing/memblock/tests/alloc_nid_api.h
@@ -5,7 +5,6 @@
 #include "common.h"
 
 int memblock_alloc_nid_checks(void);
-int memblock_alloc_exact_nid_range_checks(void);
 int __memblock_alloc_nid_numa_checks(void);
 
 #ifdef CONFIG_NUMA
diff --git a/tools/testing/memblock/tests/common.h b/tools/testing/memblock/tests/common.h
index e1138e06c903..c3cca972dcca 100644
--- a/tools/testing/memblock/tests/common.h
+++ b/tools/testing/memblock/tests/common.h
@@ -23,8 +23,6 @@ enum test_flags {
 	TEST_F_NONE = 0x0,
 	/* Perform raw allocations (no zeroing of memory). */
 	TEST_F_RAW = 0x1,
-	/* Perform allocations on the exact node specified. */
-	TEST_F_EXACT = 0x2
 };
 
 /**
-- 
2.54.0 (Apple Git-157)


