Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A753C79F85
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 14:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46E1E6B008A; Sun,  6 Sep 2026 10:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41ED26B008C; Sun,  6 Sep 2026 10:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E75A6B0092; Sun,  6 Sep 2026 10:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 023636B008A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 10:40:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A599A490A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 14:40:47 +0000 (UTC)
X-FDA: 85183598934.23.05640C0
Received: from out-2uec-a118.jellyfish.systems (out-2uec-a118.jellyfish.systems [63.250.43.118])
	by imf22.hostedemail.com (Postfix) with ESMTP id ACFAAC0004
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 14:40:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=QIAPUXvE;
	spf=pass (imf22.hostedemail.com: domain of hi@tychen.cc designates 63.250.43.118 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788705646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=feTpTi+00SUdprpbkdceqwjpT54OJK30w6C0vNUQ/sU=;
	b=7b8IqgtPS+CxKw8iTBhX5LHTwkdYaTIL9yS+2MwiDDo2Q30r3uJX5cpMGWyEhfGj4G8tZq
	Ej6YKEARupLUN3E2unx3Po15nK3zZensu4l77lHDXAmuRbDtKuFDqbU1eEDLqWBRSCMn15
	CLFl+klCwg1A9GFfrU0Lbi4+bKw+i2U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=QIAPUXvE;
	spf=pass (imf22.hostedemail.com: domain of hi@tychen.cc designates 63.250.43.118 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788705646;
	b=478iI/1e4OMnUErw7xih/So663SIKZnyffAMn4pCZvquerGUcxcA3G7mP/d/KkVVoPBWtL
	bbVSJhoEHRP2BOeK0lD8AJeANjjMNh4fEJhFgmeDyPmKRLWGWx6+kzAj/8x56yrAelBQ2W
	7oWA9B0mmVbkkewN2QzB42r2+OLOMDI=
Received: from fedora (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hdCY46zn3z2x9q;
	Sun, 06 Sep 2026 14:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788705628;
	bh=feTpTi+00SUdprpbkdceqwjpT54OJK30w6C0vNUQ/sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QIAPUXvEXNd5HF+wi/dWJcbUXtHtbzSYsEkho5viyjFWCDh9U6BtogiOq180GJ0t3
	 vo5GN9OB6m3mbpA2+o7QTrzcpxeR1oovVhlYOS+B28sflt7EcxqBDf+8M0CAaxDMRF
	 X6FbZJxZ7RhTpkQqwIldSJoR6Us7ir2WXLUHNB/T9+//N0kyY7RS/H6QLHhg/UvfX+
	 Naeivx3lTxhlmT2jkXFZ9CjxYSDef9dykRO5X8rZHJrizooDXh8gwUYGO45UaboRiY
	 Pz1CX1E6aigp8s9bhvvfMa9sjaaAScyXFH8CuhKR8kfZgvOleRajX/Yflk6bJnn+1u
	 DdLoK6m203jTw==
From: Tianyi Chen <hi@tychen.cc>
To: rppt@kernel.org
Cc: Tianyi Chen <hi@tychen.cc>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] memblock tests: cover allocations below the low address limit
Date: Sun,  6 Sep 2026 22:40:11 +0800
Message-ID: <20260906144011.848898-2-hi@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906144011.848898-1-hi@tychen.cc>
References: <20260906144011.848898-1-hi@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Stat-Signature: me9486yko358abift8188hy34xszc6cd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ACFAAC0004
X-Rspam-User: 
X-HE-Tag: 1788705645-531701
X-HE-Meta: U2FsdGVkX1/HAhPyDMmTvO7kvXYHPa3esqfIxMPFeuVyayyf5n67mPpsMiYFY/ba5T0OuECM9N8/m3dEIozQfi3DMV7242ULbZ3/+j50TfFzIk2XkSV/5TDd4xuUKaTCqNswmIPmgqOCMseG/BNKN6rGLYXn5W5ApORzUHXZLPMvgP6yPxrjUYBZrGbx32aBma23OyfnNe3BI+gb5YMiYqHd88ePsO7T/dUvMke1XTK5DMKCvwuyMYWPDTebpPU1QMamsMtbtKpGReqturO85IjVO8F+jFruceT4Zck5X6OxXFLhYJUVk0NXeV9OuG0s2HQqPAERdtgPXaFJk+2VTnyvvUMQs5gCa8mPJAGUlY0bjyuexWGGUkg10FquuUegVR8pG9DtpjNs3SnUVFenFMhOpqjtWCxE2WteJ0q0k4Gd2nzA878u9mrd18C5Cm+WFL3zRMsVNUWFAiyiJSX4Rxt/VnG1Uub2LOua6JgfR9mRe2Op+5PQswR/jA7lzPtjH99HI91ZpUuczll02AbXXhpe+b2ulScWSxsVnCXcRTHNFCex7yHy/L1jBH7FUhoOs7KWTrkGVUEAavX/hmU0t49+NYpOyNcYjRAy4V6RUMLBLdbR0cTBaNXVsfyy+jG8Z2vjRXZUcb1OMlyooeJ0LlXVnIDa1irOK2t61iUqEsRTJE5fJB7Nlr1r/xSDvEiyX08c87qV3jc1VyVBysdBw38BGe/mCQkZIF7ERKYWIN/Fiwbo2NFbi7KIzmPSeLVf8Reekw84UwTTYYiLZjKHQy/6ghnlgvaqMENncA8HzsNaOI70AUf/l7tdksmpPYBHI8yRj5AzqzrfBEMlT9yApn+Yfe3aaKoOGEuhUOe/a/iyaKO0nKO3ZxCD3o+SE7D0U6VzPRj2+8Yjvjk2xzXV4lresOAAauKU1w/3knm8Jw9Xl3OMKebBuBujZwtHQKN1i1UeoUyuzsqKB8l1tNg
 vd6uCYb6
 EEHVVEy2IvYEHiHJ5K4rda1+Ze0me5E77U75UyrpIrVC+fVz59AhVLcpd7JAMuNIRCK347XykSy0IKsSy37011YdeN+8+bLW4N979uSa+ed8+Bzj7IY59rF+rvR+WJ4Gqz8/TDOcTKNzhJ5io1ZIEtYkty+feMT9bZQPPsECHFfGq8r6JiSPe+pd4e0oI0rkNBjd2m+nzY35MTdKe+XwlBYDFIykZcFiB7jlxn8y8yWkUJspZnmGItxoafRvAuDLtQZNQXINDSUFQVK1JYLq3cqm9JERBioqjo9H+sEqJHmbIMCCanP2htZLFAENdrjNfBgBeNe4Sybn9woQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add memblock_alloc_low() coverage using the simulator's low address
limit. Exercise aligned allocation, an allocation ending exactly at
the limit, an alignment constraint that prevents fitting below it,
and fully reserved low memory with high memory still available.

Run each case with bottom-up and top-down allocation. Check zeroing
and reserved-region accounting as well as returned addresses. Verify
that an unrestricted allocation can use the free high memory after
the low allocation fails.

Document the simulated limit and remove the completed TODO. The full
suite passes with ASan and UBSan in default, NUMA, 32-bit physical
address and debug configurations, with movable-node mode both enabled
and disabled.

Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/memblock/Makefile              |   3 +-
 tools/testing/memblock/README                |  13 +-
 tools/testing/memblock/TODO                  |   5 -
 tools/testing/memblock/main.c                |   2 +
 tools/testing/memblock/tests/alloc_low_api.c | 147 +++++++++++++++++++
 tools/testing/memblock/tests/alloc_low_api.h |   9 ++
 6 files changed, 166 insertions(+), 13 deletions(-)
 delete mode 100644 tools/testing/memblock/TODO
 create mode 100644 tools/testing/memblock/tests/alloc_low_api.c
 create mode 100644 tools/testing/memblock/tests/alloc_low_api.h

diff --git a/tools/testing/memblock/Makefile b/tools/testing/memblock/Makefile
index d80982ccdc2..20524fcbe3c 100644
--- a/tools/testing/memblock/Makefile
+++ b/tools/testing/memblock/Makefile
@@ -7,7 +7,8 @@ CFLAGS += -I. -I../../include -Wall -O2 -fsanitize=address \
 LDFLAGS += -fsanitize=address -fsanitize=undefined
 TARGETS = main
 TEST_OFILES = tests/alloc_nid_api.o tests/alloc_helpers_api.o tests/alloc_api.o \
-		  tests/basic_api.o tests/common.o tests/alloc_exact_nid_api.o
+		  tests/basic_api.o tests/common.o tests/alloc_exact_nid_api.o \
+		  tests/alloc_low_api.o
 DEP_OFILES = memblock.o lib/slab.o mmzone.o slab.o cmdline.o
 OFILES = main.o $(DEP_OFILES) $(TEST_OFILES)
 EXTR_SRC = ../../../mm/memblock.c
diff --git a/tools/testing/memblock/README b/tools/testing/memblock/README
index b435f48d8a7..e4fb5f23fb2 100644
--- a/tools/testing/memblock/README
+++ b/tools/testing/memblock/README
@@ -67,13 +67,13 @@ memblock
 |-- tests
 |    |-- alloc_api.(c|h)         -- memblock_alloc tests
 |    |-- alloc_helpers_api.(c|h) -- memblock_alloc_from tests
+|    |-- alloc_low_api.(c|h)     -- memblock_alloc_low tests
 |    |-- alloc_nid_api.(c|h)     -- memblock_alloc_try_nid tests
 |    |-- basic_api.(c|h)         -- memblock_add/memblock_reserve/... tests
 |    |-- common.(c|h)            -- helper functions for resetting memblock;
 |-- main.c        --------------.   dummy physical memory definition
 |-- Makefile                     `- test runner
 |-- README
-|-- TODO
 |-- .gitignore
 
 Simulating physical memory
@@ -101,12 +101,11 @@ There's no need to explicitly free the dummy memory from memblock via
 memblock_free() call. The entry will be erased by reset_memblock_regions(),
 called at the beginning of each test.
 
-Known issues
-============
-
-1. Tests for memblock_alloc_low() can't be easily implemented. The function uses
-   ARCH_LOW_ADDRESS_LIMIT marco, which can't be changed to point at the low
-   memory of the memory_block.
+The simulator defines ARCH_LOW_ADDRESS_LIMIT in asm/dma.h using the midpoint
+of the MEM_SIZE range beginning at the dummy physical memory base. This keeps
+the low-address limit within the allocated buffer even when malloc() returns
+an address above the kernel's default limit. The limit is an exclusive upper
+bound, as in the memblock allocation API.
 
 References
 ==========
diff --git a/tools/testing/memblock/TODO b/tools/testing/memblock/TODO
deleted file mode 100644
index c13ad0dae77..00000000000
--- a/tools/testing/memblock/TODO
+++ /dev/null
@@ -1,5 +0,0 @@
-TODO
-=====
-
-1. Add tests for memblock_alloc_low() once the simulator can model
-   ARCH_LOW_ADDRESS_LIMIT against the low memory in memory_block
diff --git a/tools/testing/memblock/main.c b/tools/testing/memblock/main.c
index 278f9dec500..9a96e178551 100644
--- a/tools/testing/memblock/main.c
+++ b/tools/testing/memblock/main.c
@@ -4,6 +4,7 @@
 #include "tests/alloc_helpers_api.h"
 #include "tests/alloc_nid_api.h"
 #include "tests/alloc_exact_nid_api.h"
+#include "tests/alloc_low_api.h"
 #include "tests/common.h"
 
 int main(int argc, char **argv)
@@ -12,6 +13,7 @@ int main(int argc, char **argv)
 	memblock_basic_checks();
 	memblock_alloc_checks();
 	memblock_alloc_helpers_checks();
+	memblock_alloc_low_checks();
 	memblock_alloc_nid_checks();
 	memblock_alloc_exact_nid_checks();
 
diff --git a/tools/testing/memblock/tests/alloc_low_api.c b/tools/testing/memblock/tests/alloc_low_api.c
new file mode 100644
index 00000000000..a0fae975a26
--- /dev/null
+++ b/tools/testing/memblock/tests/alloc_low_api.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include "alloc_low_api.h"
+#include <linux/align.h>
+
+/* Allocate at the first or last aligned address below the low limit. */
+static int alloc_low_simple_check(void)
+{
+	struct memblock_region *rgn = &memblock.reserved.regions[0];
+	phys_addr_t size = SZ_64;
+	phys_addr_t expected;
+	void *allocated_ptr;
+
+	PREFIX_PUSH();
+	setup_memblock();
+
+	if (memblock_bottom_up())
+		expected = ALIGN(memblock_start_of_DRAM(), SMP_CACHE_BYTES);
+	else
+		expected = ALIGN_DOWN(ARCH_LOW_ADDRESS_LIMIT - size,
+				      SMP_CACHE_BYTES);
+
+	allocated_ptr = memblock_alloc_low(size, SMP_CACHE_BYTES);
+
+	ASSERT_NE(allocated_ptr, NULL);
+	ASSERT_EQ((phys_addr_t)(uintptr_t)allocated_ptr, expected);
+	ASSERT_MEM_EQ(allocated_ptr, 0, size);
+	ASSERT_EQ(rgn->base, expected);
+	ASSERT_EQ(rgn->size, size);
+	ASSERT_LE(region_end(rgn), ARCH_LOW_ADDRESS_LIMIT);
+	ASSERT_EQ(memblock.reserved.cnt, 1);
+	ASSERT_EQ(memblock.reserved.total_size, size);
+
+	test_pass_pop();
+	return 0;
+}
+
+/* The only low memory available ends exactly at the exclusive limit. */
+static int alloc_low_exact_limit_check(void)
+{
+	phys_addr_t limit = ARCH_LOW_ADDRESS_LIMIT;
+	phys_addr_t base = ALIGN_DOWN(limit - SZ_64, SMP_CACHE_BYTES);
+	phys_addr_t size = limit - base;
+	void *allocated_ptr;
+
+	PREFIX_PUSH();
+	setup_memblock();
+	ASSERT_EQ(memblock_remove(memblock_start_of_DRAM(),
+				  base - memblock_start_of_DRAM()), 0);
+
+	allocated_ptr = memblock_alloc_low(size, SMP_CACHE_BYTES);
+
+	ASSERT_NE(allocated_ptr, NULL);
+	ASSERT_EQ((phys_addr_t)(uintptr_t)allocated_ptr, base);
+	ASSERT_MEM_EQ(allocated_ptr, 0, size);
+	ASSERT_EQ(memblock.reserved.regions[0].base, base);
+	ASSERT_EQ(region_end(&memblock.reserved.regions[0]), limit);
+	ASSERT_EQ(memblock.reserved.cnt, 1);
+	ASSERT_EQ(memblock.reserved.total_size, size);
+
+	test_pass_pop();
+	return 0;
+}
+
+/*
+ * There are size bytes below the limit, but aligning the start makes the
+ * allocation cross it. Memory above the limit must not satisfy the request.
+ */
+static int alloc_low_alignment_crosses_limit_check(void)
+{
+	phys_addr_t limit = ARCH_LOW_ADDRESS_LIMIT;
+	phys_addr_t base = ALIGN_DOWN(limit, SMP_CACHE_BYTES) - 1;
+	phys_addr_t size = limit - base;
+	void *allocated_ptr;
+
+	PREFIX_PUSH();
+	setup_memblock();
+	ASSERT_EQ(memblock_remove(memblock_start_of_DRAM(),
+				  base - memblock_start_of_DRAM()), 0);
+
+	allocated_ptr = memblock_alloc_low(size, SMP_CACHE_BYTES);
+
+	ASSERT_EQ(allocated_ptr, NULL);
+	ASSERT_EQ(memblock.reserved.cnt, 0);
+	ASSERT_EQ(memblock.reserved.total_size, 0);
+	ASSERT_MEM_EQ((void *)(uintptr_t)base, 1, memblock_end_of_DRAM() - base);
+
+	test_pass_pop();
+	return 0;
+}
+
+/* Reserving all low memory must fail even though high memory remains free. */
+static int alloc_low_reserved_check(void)
+{
+	phys_addr_t limit = ARCH_LOW_ADDRESS_LIMIT;
+	phys_addr_t base = dummy_physical_memory_base();
+	phys_addr_t size = SZ_64;
+	void *allocated_ptr;
+
+	PREFIX_PUSH();
+	setup_memblock();
+	ASSERT_EQ(memblock_reserve(base, limit - base), 0);
+
+	allocated_ptr = memblock_alloc_low(size, SMP_CACHE_BYTES);
+
+	ASSERT_EQ(allocated_ptr, NULL);
+	ASSERT_EQ(memblock.reserved.cnt, 1);
+	ASSERT_EQ(memblock.reserved.regions[0].base, base);
+	ASSERT_EQ(memblock.reserved.regions[0].size, limit - base);
+	ASSERT_EQ(memblock.reserved.total_size, limit - base);
+	ASSERT_MEM_EQ((void *)(uintptr_t)base, 1, MEM_SIZE);
+
+	allocated_ptr = memblock_alloc(size, SMP_CACHE_BYTES);
+	ASSERT_NE(allocated_ptr, NULL);
+	ASSERT_LE(limit, (phys_addr_t)(uintptr_t)allocated_ptr);
+	ASSERT_MEM_EQ(allocated_ptr, 0, size);
+
+	test_pass_pop();
+	return 0;
+}
+
+static int alloc_low_checks(void)
+{
+	alloc_low_simple_check();
+	alloc_low_exact_limit_check();
+	alloc_low_alignment_crosses_limit_check();
+	alloc_low_reserved_check();
+
+	return 0;
+}
+
+int memblock_alloc_low_checks(void)
+{
+	prefix_reset();
+	prefix_push("memblock_alloc_low");
+	test_print("Running memblock_alloc_low tests...\n");
+
+	reset_memblock_attributes();
+	dummy_physical_memory_init();
+
+	run_top_down(alloc_low_checks);
+	run_bottom_up(alloc_low_checks);
+
+	dummy_physical_memory_cleanup();
+	prefix_pop();
+
+	return 0;
+}
diff --git a/tools/testing/memblock/tests/alloc_low_api.h b/tools/testing/memblock/tests/alloc_low_api.h
new file mode 100644
index 00000000000..2e3cbe336f5
--- /dev/null
+++ b/tools/testing/memblock/tests/alloc_low_api.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _MEMBLOCK_ALLOC_LOW_H
+#define _MEMBLOCK_ALLOC_LOW_H
+
+#include "common.h"
+
+int memblock_alloc_low_checks(void);
+
+#endif
-- 
2.55.0


