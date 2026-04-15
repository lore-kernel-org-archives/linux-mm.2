Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80C4BF4199C
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 12:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05FA6B0089; Wed, 15 Apr 2026 08:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6C86B008C; Wed, 15 Apr 2026 08:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5586B0092; Wed, 15 Apr 2026 08:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 88EBC6B0089
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:28:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 326CB1A038C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:28:03 +0000 (UTC)
X-FDA: 84660717246.17.90B6DB0
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3126C14000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:28:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cwj8k8bS;
	spf=pass (imf09.hostedemail.com: domain of priyanshukumarpu@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=priyanshukumarpu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776256081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGXqlQS/KnXB9/V1z19COjJZUtHkidF1KtI4LzcaBPE=;
	b=AYBsupUySnZ8zlHc8Qe7SHgINfUw0KLEbt+289ZZ4UET9gBb+LqpxQ4CBGNe4VsGdWpcXq
	GorE+0ytp73FLuKqzcHxhyX9LeXBxkFnVdF4snxYlMz6FVn+3JRbgjjZ6q0EXM6T5BBQ/B
	fURi4nx5W9WBAznbL9SyW7wF3lDjBQ0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cwj8k8bS;
	spf=pass (imf09.hostedemail.com: domain of priyanshukumarpu@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=priyanshukumarpu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776256081; a=rsa-sha256;
	cv=none;
	b=6KPV+SBL0y52bHIVrI84fbSa/+HY6O2gm+0iCj3UCf5o8GTxL9bsXDCwn+/SAA8LZPq6qZ
	mNaabuCcxUEyU0OY9mUZrsQDk8mhU9HUNlMH2SuWMWCxwaO5vBtQkZ+WgRbA90FehyCPLh
	pmR+gYaUFMGSVUZ1MQZps03kFolSP1w=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82f33d28c1dso2001703b3a.3
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776256080; x=1776860880; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MGXqlQS/KnXB9/V1z19COjJZUtHkidF1KtI4LzcaBPE=;
        b=cwj8k8bSCvOUs7gf2TV3NBmFuXXHXNJ/fr3OJb03pdilqMggcatImSMKmqCHohr7v8
         VjwQnqUGd+jzAiTvJiH+Pbav+2XwSwmfathkuKXaMu4Mj+AMRqEjJmdBM0TAkZi/UJ9l
         sp95aAVjX32lycbGYnX/QJyEZk/Y79Zzq9yOa5cLEoce+fH9GGSVx/83MIHoIYB29+pn
         Vqy5dU61Cw8zDixXArGwirhaHo2j5aNEPZpiFVqWKRoWDN7Nghp8eZWNZ04L1s10CwN/
         +d8GtBVa+qbJpFECwtLxVg8klLsAkUx0AM15a8++EjwCONacvGqmcKBdYqzMle3gXTol
         uweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776256080; x=1776860880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MGXqlQS/KnXB9/V1z19COjJZUtHkidF1KtI4LzcaBPE=;
        b=TP8oUUxaRsk1BvFyjEzt9MUI3yd9Y7Si3TeRyqYLCf1C3eddkziTiJpcFGNHU/ijMv
         461TJtxxs5798h3eoNtJgqKvE8nc8lyO6EeTaMifIByu/nWJ1x+eJoetBVOVG0U5ajtW
         XIeKYngA9h8KbCQZV5laglouOmtx9tp5AZUd5kKa6qUNPdb4ROVce30yFx7kNS/OoTMz
         xxCqQzvRGtkKwenT4fLjjxj2gob2T8Hd4sYAEjz1x79rqcYrTZ5aL0YBhZBQToZXGhuF
         Oma83dfe8VxDscGzeEFloiI2n83P54+sPog9fiuzDncsD4hJnxC/02HS0btdIVHptBbA
         5Isg==
X-Forwarded-Encrypted: i=1; AFNElJ+PE51VMfk4FJKAwXIbBPuLPGVhfpm7kGw+MZLH3/3w/AWWLG1dY4QaUscU2MVQGyn8e+ngo2/Xzw==@kvack.org
X-Gm-Message-State: AOJu0YxHRJ9GXMma3XhlKM55n6pKYm0IGyoj9P8JMdAtLKKFSwSLEmlp
	DfuPkVm87qqijJugz8/r92O0GaXUbLsVAehcvWcN65vs1/Y2lHM7ClMZ
X-Gm-Gg: AeBDieuqNrL/9dJac0Yi7dV2WSR+YGLCSlUxevAbT7xGf24rNBVv2DbajYWX6Ds78Rd
	zzWBGnC9Esglq//9kaHjBsvA62X9xTYMy24KcpKWKbyw2+ntpWGjQ+jlo9TFpj9XZZg9gycUX5Y
	XqNSW5Lkpj+bglyZP5CwSSN2flIw37Pc7HASBmkHyj7RlcHaCPcOPGVyKFrEY6hW4FIEpGov4NH
	Lv3PZ5j7HGQ8Cdv7vE05IqihFXH693m/dEO4FrmU2hj5WdLmgfOJlokbLBoBJ2s+mh6ogSGCl6+
	u/buVZgygc/Uu26TuWhHNVHnXpX+vsJmTcRYEpnQJYH+nq9E3hgWf0mlW38ydOd8nx/x6nn7RJM
	m4YzdfX9AXlNByRpCc/aT8hd2NdaLuHTd0+IsjTtT7jj0gnK+ke/zFHb/ov558K/gp2t2O+EWI4
	71pjbXnhMxYByFp+52eKSyMnu6LFA=
X-Received: by 2002:a05:6a00:2ea2:b0:82d:30f:b197 with SMTP id d2e1a72fcca58-82f0c28b84bmr23171264b3a.22.1776256079805;
        Wed, 15 Apr 2026 05:27:59 -0700 (PDT)
Received: from potato.. ([192.19.252.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e149fsm1824361b3a.32.2026.04.15.05.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 05:27:59 -0700 (PDT)
From: priyanshukumarpu@gmail.com
To: rppt@kernel.org
Cc: akpm@linux-foundation.org,
	changyuanl@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Priyanshu Kumar <priyanshukumarpu@gmail.com>
Subject: [PATCH v2] tools/testing/memblock: fix stale NUMA reservation tests
Date: Wed, 15 Apr 2026 12:27:31 +0000
Message-ID: <20260415122731.1768912-1-priyanshukumarpu@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413091458.774770-1-priyanshukumarpu@gmail.com>
References: <20260413091458.774770-1-priyanshukumarpu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3126C14000B
X-Stat-Signature: 1hbtzc7ep7xg9yhih5tr15kgb1qzxuf5
X-Rspam-User: 
X-HE-Tag: 1776256080-398679
X-HE-Meta: U2FsdGVkX18TQVMxx7sj/3LwdcIUKTNHooaFJr0VPnC57ARXQ1qIV+s5ClaVrzO7aK9UrQ38BlwKM+Hp8hhIo5NDXKPuZyFQryXnTN9ItYXIGU9wJe1K0rAauXJDjiM+wgEaqVle6jTePSPW1wOtTuLbZJL+c4jE2Lwp1R2ecR+r2jGxpGqeQjXrLoqyiP0cjGUohXxpj8RW1CMx0LfxDh2STtXumcxrq2yiKaIgb/8mOX2Pw/GTYD7E2hEQt+fIRj8/tbqFOw8QxjOuedEW2qg0vgiLu5ftn+JvOaDYuufl+L/OJh5yR1DWND7maF9kUltfQAiabGCP5xDGUf+LlqrjtV4MFeM2gdzD7l4rm9gmdYYUIRPlEKV7CtiZl4tQ2boxyBQSnBNSKUeD5xvJlD3We/e3etXQj8KWO+wtgENXBjqZu+FjlAnhNaO+KbdlLFqMa2moyFFsyPHAbGnruRp0KJJEd9bq6/qXaG54+SZ8b5dOHEnnY+UfL0hJrRut4H8/bDoG2sZ7AaDoGfKTi/8GZGXpoPMqIBGr6/kDJXWvAXMuPFBPPiBM+w9ZxoFXjb3GWCgt6VfeZOOzBMJms+yEsOlXGIKnSLlhAHn9BalOvFt491DPPLaS7EGzdTYtQUllykXZs72vKkTrh3kRARZsKkywWOtyVOrE5k9yQHozuZtUTnW2oYJYkSNfC2sc82o0GvGlWwML+MBlZnWy/ZeQGvRNbvgtuY6oRXaeY92LCht64le8/Jer3TMb9tGLC3Wa53FZTrx9+gq7GUtKT6RX+iKgn2PuFV1Hn9wVRYvkLkap8i7YZz2iqgPYpI8PlEMThtwLcFSQQXa3jn/EqVd4M/0p9aM5qNwkeY9rGiz8douEz485IKStJpykoyf6RdUshAGrnXq/xC0EjYSAmO2LLFiefS+86Efv23FElhP5f+uHIZ+UtEFubfO5l7W2Qnzxo+92D249YFv+QkQ
 b2ikOhyY
 yFZU98v35fZkDpbxDIU07Z64uHTFd+/gu7UWwGmh7VCL03usYDxdtmc7L/OcIouBP1G5LqPKG+dKKj/d9Lr/sNawEpl9ya5e45znf1hcncGvpuzX+8fQOBxHGkdsyn+rAxB/Ruvz9t+AzH3Eu6SaHSkqlYS5HyWJbN7jMmlhuD74hwzfWHhpQLnXd4yLs40ICtGe79it7Am0Alhh+SQ9lTHcXE/agchIgxOmdwdf1wEbz6x+8xeE9Zrh0yE8JG0jEO+D9iUV+ZTBH9oXe+pAq64l3Rdk3pmaSh1TqSe6ouX9lxrejWWysFK2wmqAKauA5mqzgDTavwGZyJC62cqN/00I9nmcTJdpR1qy1B0Dl7EB5bxRNgw7StKYB7/iBNax2/mvxuFqViN5/P/h+555dYzq99Q==
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
 tools/testing/memblock/README                 |  5 +----
 tools/testing/memblock/TODO                   |  4 ++--
 .../memblock/tests/alloc_exact_nid_api.c      |  6 +++---
 tools/testing/memblock/tests/alloc_nid_api.c  | 21 +++++++++++++------
 4 files changed, 21 insertions(+), 15 deletions(-)

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
index 6e14447da6e1..0c46c73b5e04 100644
--- a/tools/testing/memblock/tests/alloc_exact_nid_api.c
+++ b/tools/testing/memblock/tests/alloc_exact_nid_api.c
@@ -368,7 +368,7 @@ static int alloc_exact_nid_bottom_up_numa_part_reserved_check(void)
 	max_addr = memblock_end_of_DRAM();
 	total_size = size + r1.size;
 
-	memblock_reserve(r1.base, r1.size);
+	__memblock_reserve(r1.base, r1.size, nid_req, MEMBLOCK_RSRV_KERN);
 	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
 						     min_addr, max_addr,
 						     nid_req);
@@ -861,8 +861,8 @@ static int alloc_exact_nid_numa_reserved_full_merge_generic_check(void)
 	min_addr = r2.base + r2.size;
 	max_addr = r1.base;
 
-	memblock_reserve(r1.base, r1.size);
-	memblock_reserve(r2.base, r2.size);
+	__memblock_reserve(r1.base, r1.size, nid_req, MEMBLOCK_RSRV_KERN);
+	__memblock_reserve(r2.base, r2.size, nid_req, MEMBLOCK_RSRV_KERN);
 
 	allocated_ptr = memblock_alloc_exact_nid_raw(size, SMP_CACHE_BYTES,
 						     min_addr, max_addr,
diff --git a/tools/testing/memblock/tests/alloc_nid_api.c b/tools/testing/memblock/tests/alloc_nid_api.c
index 562e4701b0e0..c23652727976 100644
--- a/tools/testing/memblock/tests/alloc_nid_api.c
+++ b/tools/testing/memblock/tests/alloc_nid_api.c
@@ -1965,7 +1965,7 @@ static int alloc_nid_bottom_up_numa_part_reserved_check(void)
 	max_addr = memblock_end_of_DRAM();
 	total_size = size + r1.size;
 
-	memblock_reserve(r1.base, r1.size);
+	__memblock_reserve(r1.base, r1.size, nid_req, MEMBLOCK_RSRV_KERN);
 	allocated_ptr = run_memblock_alloc_nid(size, SMP_CACHE_BYTES,
 					       min_addr, max_addr, nid_req);
 
@@ -2412,8 +2412,8 @@ static int alloc_nid_numa_reserved_full_merge_generic_check(void)
 	min_addr = r2.base + r2.size;
 	max_addr = r1.base;
 
-	memblock_reserve(r1.base, r1.size);
-	memblock_reserve(r2.base, r2.size);
+	__memblock_reserve(r1.base, r1.size, nid_req, MEMBLOCK_RSRV_KERN);
+	__memblock_reserve(r2.base, r2.size, nid_req, MEMBLOCK_RSRV_KERN);
 
 	allocated_ptr = run_memblock_alloc_nid(size, SMP_CACHE_BYTES,
 					       min_addr, max_addr, nid_req);
@@ -2496,15 +2496,18 @@ static int alloc_nid_numa_split_all_reserved_generic_check(void)
 
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
 
@@ -2515,7 +2518,13 @@ static int alloc_node_on_correct_nid(void)
 
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


