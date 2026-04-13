Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E552EBFD16
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 09:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFEC86B0089; Mon, 13 Apr 2026 05:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB01E6B008A; Mon, 13 Apr 2026 05:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC6056B0092; Mon, 13 Apr 2026 05:15:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB94D6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:15:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 459405D273
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:15:14 +0000 (UTC)
X-FDA: 84652973748.16.19D1FDF
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 78E2520009
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:15:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jpY99P6n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of priyanshukumarpu@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=priyanshukumarpu@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776071712; a=rsa-sha256;
	cv=none;
	b=V4SNcv22eQxFJAU4WSOhISP7h/YzfNj0AuhUgKPnp9J8yJ+KXDSMAiNhQ2QalIqbK/UVS2
	iVrNMFTA0AifkED+UAfLfj5zJG/nOT+IcOE0GcIUrGv04Z3CmoyBCPWQa4JwCXhp7LXk1/
	zL8aV9b6HB9GIDMbbZOj11LrAWgVSgM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jpY99P6n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of priyanshukumarpu@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=priyanshukumarpu@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776071712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sVvly2PF4cqASTSkfAPhOU0sngUvFWG9o3pu6vpsY/k=;
	b=ZL+ieWNGKTzcLsK4Jpktp2jktRkWd2BtQ7FCqwrfJmHbBs/ZBWWhON9xp3I3Z/HGEckbd9
	fEPnN3JveXPko9STD1rQsB1Vljl3bRoLOtYFDqTuuB3ws4TWSE7KKW61g+vU6N0yO7GbAb
	XDxKRIPBKfcwJ+wsH/zd4lpt3g2Xd0w=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8296d553142so2082568b3a.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 02:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776071711; x=1776676511; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sVvly2PF4cqASTSkfAPhOU0sngUvFWG9o3pu6vpsY/k=;
        b=jpY99P6nBFQx0teN8qsqxT+EpPUAUz21XYFVPm/ChhLJjSoY0bQcda2I10QNZcvgf3
         ADo/uKlTfaOTKzY8aZtokHj9j9ZxvA9I+z5GbsNqUyB4VNtPZEqXECheN6YZ1otX/Dd8
         u3l9gyf7XaIHLy/XIn2YP2+dns6/ORTo6LAiJg70GBKYgVGTJtCuBhZWJaDKoiQ7oBHT
         SKyjAFhOuzVvuDVljJEnuuw3woxzHD/dTRIf/s6WbI7rmtTvtOAd+EpSNUoDZLqGzM1g
         mb83zPUCJkU86qzWpSCS3WsHqCZTUOpAAx2U1cAfEr7CjzRbYmBaRsVDR1zj/fYAzsIC
         oaGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776071711; x=1776676511;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sVvly2PF4cqASTSkfAPhOU0sngUvFWG9o3pu6vpsY/k=;
        b=iwp27RJMI3VhfMDyy4KdEffdOsHt+RAbTuyAdu2uIGjIbVsPewk+jAHQAyu8U+cSe0
         Vzd7K59wYl3VRUgKr9DfY1bP7YZpqw5wIElxyQeWuwdq2xxXiQCYhhtPn5kk6Ry526DL
         sRMfy67ZP3GXeAk4QFspLe+FufPbpbA3ckdzTpRNypY9iGwpeaiPKgpPot4TlVPs3xoJ
         5uMcowXMzgGAlVQJjcg8/ikBJhFAIRLsT1KMzRzBdgQF2/YNqX7rjomze39bG5Qo48sg
         iB4pNm4R/WqYTEX40yHPwOOXuTpmQQ7IP7f2/hRjLehwbJa6x875B3y3300/6GrEmjnr
         PVbA==
X-Forwarded-Encrypted: i=1; AFNElJ9J8J54W/AmtI6DM+Vx9uxaEYTuwjF3S76Ex/pU9eTIsg0WM7bGUBR4shUT0meMnRU5iYNTsblZFA==@kvack.org
X-Gm-Message-State: AOJu0YyxmeSRP1Rdn2hPXsR/fE2d2PZ4j8lapYI1Q+vdnj6d6YmAMmJ9
	Nn24Dhb41O8LfQrNgS/wxvoS3Y7RqWfm0zgINxaWrbWy2o0fmKHapLVg
X-Gm-Gg: AeBDietsZB4NeFWuGZLvIfelQI4J0sKPDiPog4P0P/Oefi9KbQuKpJnHF5mcnFp3HCX
	XOtUWs22rS0Aat7u/HDXp7XqNuhtVrFuNc1WssN5JniOW4OSh2za8uEoIEtpd/TLMnvDAnW1Fsn
	k4H+OUi0nbUMJk9L3Fd9V+dFCKZbBP9krtaXVJuQSxbpV+N+7zyQ/ZHomj5z6utOF6xvvair6vI
	jlQ2vxg2uv0I+TLwBYnDHuwtPXCbEsAgd63lN3DWj/1nvAZNaLiVqZwUFpmWKAPImIakOeoifYE
	+ppv1jCe7bkBZq53amK53sq42lBfzLyTn9X4T+tQhA3hvRzqUtw6jShUvXBfi1S6Yxa2Mq2b/IN
	Fsx/eF/edt/5zbOB8SAaz8zHVsYURf17klHzmVq09PuEdGQt/nEs7hvH6UNOhgLGHXRAVnEhts8
	m1WGab+pvke0zHsKVbkd4L2WSlL50=
X-Received: by 2002:a05:6a20:748b:b0:39b:9644:6ea4 with SMTP id adf61e73a8af0-39fe3cf20c5mr13988935637.16.1776071711131;
        Mon, 13 Apr 2026 02:15:11 -0700 (PDT)
Received: from potato.. ([192.19.252.250])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c79216fedfdsm10138849a12.4.2026.04.13.02.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 02:15:10 -0700 (PDT)
From: priyanshukumarpu@gmail.com
To: rppt@kernel.org
Cc: akpm@linux-foundation.org,
	changyuanl@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Priyanshu Kumar <priyanshukumarpu@gmail.com>
Subject: [PATCH] tools/testing/memblock: fix stale NUMA reservation tests
Date: Mon, 13 Apr 2026 09:14:58 +0000
Message-ID: <20260413091458.774770-1-priyanshukumarpu@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 78E2520009
X-Stat-Signature: cb5ad6nhrgpujbnjd93epqma86ooxw7m
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776071712-415201
X-HE-Meta: U2FsdGVkX1+oHPkrZWkJIFWPkqZ6mZVsR10KVb5QiKgDawwYw4J8ZDYzdgGIrb6391mmmcovkbWwForJ0KAMPPKzTn7b+so58MkPtC67/vY+/cnLcbf9WA/Qhsx4Hwk4ByKlGfEGYyuzpNjuVcVY4aUFnuJQeUG5DaRIvwWWezmc/ErAvig4H0RCQ7xBP3UqyHXLILHYESbnraYVTBbtlwsdT1kj4W5kvdkCO0qeqlswhs84UwXuggDe2jtpltXHHqE6cJLwZg91ioYm5VpBkeK3zr7svj/nG9vJOVaTfTKiuVv/eTBhuWd5yMLtfcI6W1r3/xTbkpF10dUAbNbh4l9N9u5cSsSJRHxyFcamqUUUQIHW+DYnlo/5pW+KJx8b/BEFCyO8XGG7SoTbSjGZNQyrBW6zZRZ6cq5e/DTMGnddZehBPzJ/sfcbYauh1MBNFupSoTRoMkFZ+I0WGxgtRcHuwdyaVOhW86jsUvzPUkS8I50hYP461e7q0Vi5NWuaV/u9rqF5GjGpA4IKXHVsgRrDxfZF6qoy5RS9+jWOxOj0Bu5p8hDlDTdenXLlRj6GKweZt5eXkbFuQYeTAvIdS2uvqgF98l6BCQ3yBJp0i1mn8opAXi9+k2/zj4lBB1sIcflOIOV7jtlQUS5h/wrYxGHKbdRD1lfsxF8GAmQhAxBvDaxXdthvMylD+dvOZmabOC3VTUYD/Bw+icWI051nGC5NJy+gy2manItn9BcETRJdreCvmycO/2EOCJrOqyMEK9/oLe1UhMdkpR1JYqaToqNC4UHexE4FaN+oDFaJ64KicxRlWlyP8oYCxcXdEI12AeS5h+k+bJki0mRu0dm6dKpkkNSt3rl9r8tJ6l0zIkLA/l5qraZuAbUGP5zBZSIxpe4y1dqdCnMHja4J0SRkKIQcfHKmWYODSuPqUkBHkSQJVULh92W/DpFofKGF90TyZRZg7zC9OKbiESg0keH
 rQpSzpDG
 G43iTmZawhfbOAbxMoOF0MWlC3FJ1t2odvXRKHOHRTQuXO9RBU7j7jyyMK/mW/B5xGjw6piWFTaZ697Dh9aWVTe3TSnp1TxoBcvfUoebl802hdMsFZdJBlsaWUVle2pq3vXeC3WvLqDGqXbz5tuUvlkBsM3FrBizpgt/S3A2RO4gThPmAulfVWdy4Nck/q9nDZvLR6picFH64K9sNix0MZlQsUZ983j1hIczaTRVOfadDkilKmFRrlts6ryp+wkBJq3xI5aOyKkS9YP5jxUbUy+vbdbUqzyvJdcnlGzT5T9mI17aiQ3PZ7le2EKv2NBgbSt8unPzZKUQ7S/oLxjsKiZQRAJjRPMK74bYqawBDNGaJ1cTCa5CKI7TnbtPYUK7WAswu/gXmi9jYbuN4RvzB2UXlTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Priyanshu Kumar <priyanshukumarpu@gmail.com>

memblock allocations now reserve memory with MEMBLOCK_RSRV_KERN and,
on NUMA configurations, record the requested node on the reserved
region. Several memblock simulator NUMA tests still expected merges
that only worked before those reservation semantics changed, so the
suite aborted even though the allocator behavior was correct.

Update the NUMA merge expectations in the memblock_alloc_try_nid()
and memblock_alloc_exact_nid_raw() tests to match the current reserved
region metadata rules. For cases that should still merge, create the
pre-existing reservation with matching nid and MEMBLOCK_RSRV_KERN
metadata. Also strengthen the memblock_alloc_node() coverage by
checking the newly created reserved region directly instead of
re-reading the source memory node descriptor.

Finally, drop the stale README/TODO notes that still claimed
memblock_alloc_node() could not be tested.

The memblock simulator passes again with NUMA enabled after these
updates.

Signed-off-by: Priyanshu Kumar <priyanshukumarpu@gmail.com>
---
 tools/testing/memblock/README                 |  5 +--
 tools/testing/memblock/TODO                   |  4 +-
 .../memblock/tests/alloc_exact_nid_api.c      | 29 +++++++-----
 tools/testing/memblock/tests/alloc_nid_api.c  | 44 +++++++++++++------
 4 files changed, 53 insertions(+), 29 deletions(-)

diff --git a/tools/testing/memblock/README b/tools/testing/memblock/README
index 7ca437d81806..b435f48d8a70 100644
--- a/tools/testing/memblock/README
+++ b/tools/testing/memblock/README
@@ -104,10 +104,7 @@ called at the beginning of each test.
 Known issues
 ============
 
-1. Requesting a specific NUMA node via memblock_alloc_node() does not work as
-   intended. Once the fix is in place, tests for this function can be added.
-
-2. Tests for memblock_alloc_low() can't be easily implemented. The function uses
+1. Tests for memblock_alloc_low() can't be easily implemented. The function uses
    ARCH_LOW_ADDRESS_LIMIT marco, which can't be changed to point at the low
    memory of the memory_block.
 
diff --git a/tools/testing/memblock/TODO b/tools/testing/memblock/TODO
index e306c90c535f..c13ad0dae776 100644
--- a/tools/testing/memblock/TODO
+++ b/tools/testing/memblock/TODO
@@ -1,5 +1,5 @@
 TODO
 =====
 
-1. Add tests for memblock_alloc_node() to check if the correct NUMA node is set
-   for the new region
+1. Add tests for memblock_alloc_low() once the simulator can model
+   ARCH_LOW_ADDRESS_LIMIT against the low memory in memory_block
diff --git a/tools/testing/memblock/tests/alloc_exact_nid_api.c b/tools/testing/memblock/tests/alloc_exact_nid_api.c
index 6e14447da6e1..3f5ab994f63a 100644
--- a/tools/testing/memblock/tests/alloc_exact_nid_api.c
+++ b/tools/testing/memblock/tests/alloc_exact_nid_api.c
@@ -368,7 +368,8 @@ static int alloc_exact_nid_bottom_up_numa_part_reserved_check(void)
 	max_addr = memblock_end_of_DRAM();
 	total_size = size + r1.size;
 
-	memblock_reserve(r1.base, r1.size);
+	ASSERT_EQ(0, __memblock_reserve(r1.base, r1.size, nid_req,
+					MEMBLOCK_RSRV_KERN));
 	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
 						     min_addr, max_addr,
 						     nid_req);
@@ -831,14 +832,17 @@ static int alloc_exact_nid_numa_large_region_generic_check(void)
  *  |             | r2 |          new          | r1 |                  |
  *  +-------------+----+-----------------------+----+------------------+
  *
- * Expect to merge all of the regions into one. The region counter and total
- * size fields get updated.
+ * Expect to allocate the requested node as a separate kernel-reserved region.
+ * The neighboring reservations remain distinct because the new region records
+ * the requested NUMA node and MEMBLOCK_RSRV_KERN flag.
  */
 static int alloc_exact_nid_numa_reserved_full_merge_generic_check(void)
 {
 	int nid_req = 6;
 	int nid_next = nid_req + 1;
-	struct memblock_region *new_rgn = &memblock.reserved.regions[0];
+	struct memblock_region *left_rgn = &memblock.reserved.regions[0];
+	struct memblock_region *new_rgn = &memblock.reserved.regions[1];
+	struct memblock_region *right_rgn = &memblock.reserved.regions[2];
 	struct memblock_region *req_node = &memblock.memory.regions[nid_req];
 	struct memblock_region *next_node = &memblock.memory.regions[nid_next];
 	void *allocated_ptr = NULL;
@@ -871,13 +875,18 @@ static int alloc_exact_nid_numa_reserved_full_merge_generic_check(void)
 	ASSERT_NE(allocated_ptr, NULL);
 	ASSERT_MEM_NE(allocated_ptr, 0, size);
 
-	ASSERT_EQ(new_rgn->size, total_size);
-	ASSERT_EQ(new_rgn->base, r2.base);
-
-	ASSERT_LE(new_rgn->base, req_node->base);
-	ASSERT_LE(region_end(req_node), region_end(new_rgn));
+	ASSERT_EQ(left_rgn->base, r2.base);
+	ASSERT_EQ(left_rgn->size, r2.size);
+	ASSERT_EQ(right_rgn->base, r1.base);
+	ASSERT_EQ(right_rgn->size, r1.size);
+	ASSERT_EQ(new_rgn->base, req_node->base);
+	ASSERT_EQ(new_rgn->size, size);
+	ASSERT_EQ(new_rgn->flags, MEMBLOCK_RSRV_KERN);
+	ASSERT_EQ(memblock_get_region_node(new_rgn), nid_req);
+	ASSERT_LE(req_node->base, new_rgn->base);
+	ASSERT_LE(region_end(new_rgn), region_end(req_node));
 
-	ASSERT_EQ(memblock.reserved.cnt, 1);
+	ASSERT_EQ(memblock.reserved.cnt, 3);
 	ASSERT_EQ(memblock.reserved.total_size, total_size);
 
 	test_pass_pop();
diff --git a/tools/testing/memblock/tests/alloc_nid_api.c b/tools/testing/memblock/tests/alloc_nid_api.c
index 562e4701b0e0..3d7a8c370844 100644
--- a/tools/testing/memblock/tests/alloc_nid_api.c
+++ b/tools/testing/memblock/tests/alloc_nid_api.c
@@ -1965,7 +1965,8 @@ static int alloc_nid_bottom_up_numa_part_reserved_check(void)
 	max_addr = memblock_end_of_DRAM();
 	total_size = size + r1.size;
 
-	memblock_reserve(r1.base, r1.size);
+	ASSERT_EQ(0, __memblock_reserve(r1.base, r1.size, nid_req,
+					MEMBLOCK_RSRV_KERN));
 	allocated_ptr = run_memblock_alloc_nid(size, SMP_CACHE_BYTES,
 					       min_addr, max_addr, nid_req);
 
@@ -2382,14 +2383,17 @@ static int alloc_nid_numa_large_region_generic_check(void)
  *  |             | r2 |          new          | r1 |                  |
  *  +-------------+----+-----------------------+----+------------------+
  *
- * Expect to merge all of the regions into one. The region counter and total
- * size fields get updated.
+ * Expect to allocate the requested node as a separate kernel-reserved region.
+ * The neighboring reservations remain distinct because the new region records
+ * the requested NUMA node and MEMBLOCK_RSRV_KERN flag.
  */
 static int alloc_nid_numa_reserved_full_merge_generic_check(void)
 {
 	int nid_req = 6;
 	int nid_next = nid_req + 1;
-	struct memblock_region *new_rgn = &memblock.reserved.regions[0];
+	struct memblock_region *left_rgn = &memblock.reserved.regions[0];
+	struct memblock_region *new_rgn = &memblock.reserved.regions[1];
+	struct memblock_region *right_rgn = &memblock.reserved.regions[2];
 	struct memblock_region *req_node = &memblock.memory.regions[nid_req];
 	struct memblock_region *next_node = &memblock.memory.regions[nid_next];
 	void *allocated_ptr = NULL;
@@ -2421,13 +2425,18 @@ static int alloc_nid_numa_reserved_full_merge_generic_check(void)
 	ASSERT_NE(allocated_ptr, NULL);
 	assert_mem_content(allocated_ptr, size, alloc_nid_test_flags);
 
-	ASSERT_EQ(new_rgn->size, total_size);
-	ASSERT_EQ(new_rgn->base, r2.base);
-
-	ASSERT_LE(new_rgn->base, req_node->base);
-	ASSERT_LE(region_end(req_node), region_end(new_rgn));
+	ASSERT_EQ(left_rgn->base, r2.base);
+	ASSERT_EQ(left_rgn->size, r2.size);
+	ASSERT_EQ(right_rgn->base, r1.base);
+	ASSERT_EQ(right_rgn->size, r1.size);
+	ASSERT_EQ(new_rgn->base, req_node->base);
+	ASSERT_EQ(new_rgn->size, size);
+	ASSERT_EQ(new_rgn->flags, MEMBLOCK_RSRV_KERN);
+	ASSERT_EQ(memblock_get_region_node(new_rgn), nid_req);
+	ASSERT_LE(req_node->base, new_rgn->base);
+	ASSERT_LE(region_end(new_rgn), region_end(req_node));
 
-	ASSERT_EQ(memblock.reserved.cnt, 1);
+	ASSERT_EQ(memblock.reserved.cnt, 3);
 	ASSERT_EQ(memblock.reserved.total_size, total_size);
 
 	test_pass_pop();
@@ -2496,15 +2505,18 @@ static int alloc_nid_numa_split_all_reserved_generic_check(void)
 
 /*
  * A simple test that tries to allocate a memory region through the
- * memblock_alloc_node() on a NUMA node with id `nid`. Expected to have the
- * correct NUMA node set for the new region.
+ * memblock_alloc_node() on a NUMA node with id `nid`. Expected to allocate
+ * the region within the requested node and mark the new reservation with the
+ * correct NUMA node.
  */
 static int alloc_node_on_correct_nid(void)
 {
 	int nid_req = 2;
 	void *allocated_ptr = NULL;
 #ifdef CONFIG_NUMA
+	struct memblock_region *new_rgn = &memblock.reserved.regions[0];
 	struct memblock_region *req_node = &memblock.memory.regions[nid_req];
+	phys_addr_t req_node_end = region_end(req_node);
 #endif
 	phys_addr_t size = SZ_512;
 
@@ -2515,7 +2527,13 @@ static int alloc_node_on_correct_nid(void)
 
 	ASSERT_NE(allocated_ptr, NULL);
 #ifdef CONFIG_NUMA
-	ASSERT_EQ(nid_req, req_node->nid);
+	ASSERT_EQ(memblock.reserved.cnt, 1);
+	ASSERT_EQ(new_rgn->size, size);
+	ASSERT_EQ(new_rgn->base, (phys_addr_t)allocated_ptr);
+	ASSERT_EQ(new_rgn->flags, MEMBLOCK_RSRV_KERN);
+	ASSERT_EQ(nid_req, memblock_get_region_node(new_rgn));
+	ASSERT_LE(req_node->base, new_rgn->base);
+	ASSERT_LE(region_end(new_rgn), req_node_end);
 #endif
 
 	test_pass_pop();
-- 
2.43.0


