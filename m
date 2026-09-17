Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56AB4C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 08:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8256B0092; Thu, 17 Sep 2026 04:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF936B0093; Thu, 17 Sep 2026 04:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C57B6B0095; Thu, 17 Sep 2026 04:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21FDC6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:15:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2E72C1C1847
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:15:44 +0000 (UTC)
X-FDA: 85222545408.10.E59F906
Received: from mta0.migadu.com (out-139.mta0.migadu.com [91.218.175.139])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1C07F120006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:15:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m6H6TRDI;
	spf=pass (imf29.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.139 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789632942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LfoNEn9zQpSZgGoQJRQ43Lffa3wR0daxMtiAprjTCgs=;
	b=uXEH3M1qKmnroAQ0khx0A2nShiFyINtC57joN5bXTiSkJMIw/CPwkqVtNWJ+QfP/9NR3Se
	TLst2PX4I5A7A+yt4R47cklvpso70jS+hd14maunxZEpOLx8e6ntb1zYUscDVVbp4wBatF
	kuApfklA+rUgSYFUL719J+qsOOBUOVc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m6H6TRDI;
	spf=pass (imf29.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.139 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789632942;
	b=dh/b8jPWJbsOPhqrV2ulFttmsqv5N5q+kM5kEl3ApbnfxthpsnM+mWBAR3Vj86E7fy7g/7
	nO/1AokjbEJUsAWRK/mkE6u6+nbWLqjreB1OU0JqYhsLPN5V/h3BECHxqmag5z4aCvp81c
	t7FhLmYA44MysR3YI9g/hMwPYel3nao=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=f8XLjDDRDprhZX8DUAElzZf6KZ+YOj4wp6B2faOPI5s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789632940; v=1; x=1790237740;
 b=m6H6TRDIt4SckgYf4SrnTqrLCi59OxxGWEhjs8dECDQDCBqsVZbJKxjSzYuANvJkRchpDX6r
 OQF+Ub0KkKDSaLffWnEoI20l6//NVjNGAK7mnx8fEFFd5lm0wlM1B15i9z0QDn2sNXpr81SLUR2
 e+KN8I3ZdYGhtHMyIAskwxXA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b23b0d3060cb75fd;
	Thu, 17 Sep 2026 08:15:40 +0000
X-Mizu-Trace-ID: b23b0d3060cb75fd
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Priyanshu Kumar <priyanshukumarpu@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH 1/2] memblock tests: Move exact nid tests to memblock_alloc_range_nid()
Date: Thu, 17 Sep 2026 16:15:03 +0800
Message-ID: <20260917081504.30426-2-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260917081504.30426-1-kaitao.cheng@linux.dev>
References: <20260917081504.30426-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1C07F120006
X-Stat-Signature: sid9kjj7oukpa86akqwo3xaombwt79j4
X-Rspam-User: 
X-HE-Tag: 1789632941-256515
X-HE-Meta: U2FsdGVkX19+a3dOXM7CIh+HD6vgv8ydmeEVvuwGRYUCVvncEYjC/lPFHS2f91qZa/uwt4n32G8A7NJ/ViH7s1URabriVY/f2AbQlYYTpvWXBH1bY0Fepw0koza+iNcFY6yuqIBr21bOnnFXiKZoVcXvc3IL5Un6aGtycMmmzUnzMOCXv1ZCbez3XhO4ep/1m//d1gcYCc0Czvp+KE+DaeI78wjCs4bHtPLP7Nfkj0noqapJ0SXd5GAfBm44ScsaQVmOfDdqfE+KaUIRyYtxf9mAwPY/SCvvQIeHcd1QFoiJvP687s3k3oGw2EH0gv9EIAkN5IVdlea7rej8T9a6ESl9vq1JYrFrsPDAOKHwtWA2jnCYer3gTqFJbB8vf5nrCIv2W9vLDGGVItpilmKLcnLBYmg5X2//OHPRv1C+trh7BHjEs3jV0zQGpOCVZ7pG/kw3DUP27jHfUBch64bvMaZDVGDu5PI6BAvaaGsG6jUswZutYI8mzhiJWYRCNVDFUeOwW9FxjHAqpxgvC0VJSrj6BWOYgq8SCM8hYj6Ps73IMI/35giuIjS/A2VlXHvX5zTPcd6O3xUMVEHBCBLAtHtDndA4Z1L0AwA4vN9x0jHRq9btB516fN19R39vOQCIOocrQfjpU1Qkd77gZQRU3xHWuDclpv9Irlr2o+AZTOJB8etVtzfj83D88LSXT9ZlINRML8FrOYUZj2SDYv3Nvm8X36lsx4KsnmwhWB75yCG8+CJrKZaW/FbIp6yBzuTqVthUyIc071z8JHaFwD8qCFs7pOt2Tr5VIiPWMg3xWWoDo2ACjw3oC5pO4RgpI5QLGMdsC0KK3fhKKnWUldOwPy5u6KRl/LNoWGKIfeqU368Asvhuzcb0XSOLVCi0S/ij0NJlk2M9gXbhUmgXqswNDpQdgv+6RfZi2ULk552s1nPmUIxohBkoV8I8uCvktzsEW1peNcEk0H9VP7JG6Wu
 2WJVGb5X
 YBU3l7aBqJJn5pSggqsrBBAfDA2aUzCb9DGWW0m4OnswJ0F1Sm7RwFjjRaqWBVyKgfuXk9wEwHMxm4IzIaWYyFyxRorZTeVk6DmpqhnkoildHNOaI2gRU7gp3fwx3uyvFzJnfk5ivj/eBA+iFOoPUIXzd8sS6MMYxZGeVd28A5eArxCBPgaGKf0vxFSS035hC8/RYwUkCiuAlQKRflcRPRCKhVJ3wW+6gRUQVZM7fRhFXWnASeME9n3UB2C/QOK4uzRCSArdlaOh7wo6DROen/0Ukd2xHsPVD3gYqqMRyjc1Au/M=
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


