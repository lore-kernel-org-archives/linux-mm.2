Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5950BC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 23:55:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 153CE6B008A; Wed,  9 Sep 2026 19:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE446B008C; Wed,  9 Sep 2026 19:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEAD86B0092; Wed,  9 Sep 2026 19:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B78E86B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:55:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C49F4032B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:55:49 +0000 (UTC)
X-FDA: 85195884018.15.017B5D7
Received: from out-2uec-a122.jellyfish.systems (out-2uec-a122.jellyfish.systems [63.250.43.122])
	by imf21.hostedemail.com (Postfix) with ESMTP id 442E21C0003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:55:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=PRwKdnpQ;
	spf=pass (imf21.hostedemail.com: domain of hi@tychen.cc designates 63.250.43.122 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=pass (policy=none) header.from=tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788998147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqlhQP7/rcLpP1L94OJdJPvDYnSuPnzWrOMZcm1+ctk=;
	b=w5XVQztgw1364L01j98+QB78WWqsi95Wp69EW5fFnjMQBsIriXGPpfNs7Hrro81NNBqfUf
	/yKGsJKjahZQUbns0bIWF13MyfiH6yi0BHLkc1pMJJzuA6GfY3pWsQqco1+UhMsaoNCb8p
	TZ55SSDRwCbl4HyAG/7p9iaSrcdAqvw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788998147;
	b=UPkcCetclKNuLd1nXCILJJMgHyyd/mCvZOXUifbqyuz6yBTPUpJHJwRIxvn+hVHhZLNAwk
	x9RFU3saMQv3EieEtepHq0iOZ/16KXEPEx3IfAlpqAxh9pSPQo8aqVe2XeEPtfrlg3dg0d
	usKh8EGxAiDaeKBnCTGXHgiw1VOSFHk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=PRwKdnpQ;
	spf=pass (imf21.hostedemail.com: domain of hi@tychen.cc designates 63.250.43.122 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=pass (policy=none) header.from=tychen.cc
Received: from 192.168.5.7 (unknown [23.142.132.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hgHkJ4BJqz8sWx;
	Wed, 09 Sep 2026 23:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788998139;
	bh=gqlhQP7/rcLpP1L94OJdJPvDYnSuPnzWrOMZcm1+ctk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRwKdnpQCuj0IQlh8gj0eKl/m+Que9hj8iaNZSqqYUjrOnMMubtS4vz6X0U7E3SEl
	 hXwT4TyghX12pxYDv59MvDg7afpBenbENFnvcN5ZGC7OZ558ZU6tS2+YxZtMik+e4J
	 DEupObNhAO9WG2ynZE8X3Vfto9wRhXyR+GTZG7iFpUf5ulUKXI/7ogQwJe9PQA9e2o
	 5bMn+z8fdautAj13feG2mz9d22B3FKoZtD0oquAPr5ZSTQsTzdL+Y+6NcRy8BNvwtf
	 eyKKqeTmc6n28mIBWYV73rDWFlf+MoH7DHodYKdD39IAWRmuKd5zOaopqD8MdEw5hM
	 JFZcRmHaw4fKA==
From: Tianyi Chen <hi@tychen.cc>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hi@tychen.cc
Subject: [PATCH v3 2/2] memblock tests: cover allocations below the low address limit
Date: Thu, 10 Sep 2026 07:55:33 +0800
Message-ID: <142ab1025fd1e4b5dcd2a1591b964626ebce9d23.1788997523.git.hi@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788997523.git.hi@tychen.cc>
References: <cover.1788997523.git.hi@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Stat-Signature: 9753r8qisazmhr9ekhhpw49pjs7w5rxd
X-Rspam-User: 
X-Rspamd-Queue-Id: 442E21C0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1788998147-821932
X-HE-Meta: U2FsdGVkX1/zmD7zH+RMo+VNaakynZ570COu6pY4hrBVjrrlncwR6jrhmsfILAacmeQ9QQJVuNFuvWa9ELSf8qMB02FfI39G0kYNf+WtzXEYgrnHquWz4+x6sJC1tVdv2oCRvAO5vz8Zf97bzBpM1NyezeCLkkksG8FtzBra+M5M2y7R/d2K35AWgVsCtZmWtsWwlUgVjCKK1utHqlj64N9YGzfX3/As8ZB8iCyXtXqBjENtQetmdURUUgJNB2xpGT7ndnYcEMzcfuUP5UwaB2x6hhuiCJpB2o9gpT2LyERhrg4VokT6ramXjWCFSOVxfxnII8dk18Hvr1GR1FbolyrCFw5mt4Nu/t9MVCJsY+pSnUa5dCW1BrISnuKyLirCg1ImxQOSIh4b+FOb2+STDHCDOOkL4ReMsW38EH+Gg8SsFWme2Q0m1MHJKR6E5UveNiqFVpiHvmfxu4ddXLaMN53bd1aEKLNbDifgB/gOdrYzGNh7zXS18+D/7Ru0V3kowjlIqvepa8Y1x9InjSBgTdyDQ8D86+0zHiTkMzcOeuhZGEb07kwQp+3ygyU7kk1ZDLUVHTMGsumIXv968uzlHBTo4JLUgm4RcUpFxIYAW6Oeu9TZr1rHsDJTUmoWL8mAA/ccMA9QCJJEjT4aOsIACn2S+fTl+QRl5OydN5w+J6ZLjj5njOWIErf53fT1++i5tM8RiRuAEzv3UZCNOAuxEJU1b07Z8mtMxK9rAJjse33VKKE4eMoR21nG+VT1N0N/r6mYaBBwxy3JwHFMxgdVEn+A1lJ5Hfq1WGjd4zAbH48GoM3GJj9bi0U+Bmo6KjMeYzSPbN4K48Sp5lAfbaP4EDtjuuuvQjwniAcI07gPQddBBeoxA3O8nEaywEeDWEDpe25ZGHbt30E26Q0EiW+MTVEN8kKvziKLdRU9Rbe51EQZJ4ZU4G49HD9YdsLxJzWOiIW5cqOMh6X378z66/m
 TmFmvCtQ
 9PD3vS9+XzrwSq3wBHVrA/SmcsMGEfN/Wc2aGitLI4GRw5aVDfP6ocp4U1JtECsD9pMmTdgKAnnG3yXdr1DYkwa7unB7H7ka4Jp64VlFk72nNnR8iyk4rBewUArd6SIqcYh4seNq4hG3U9SIATWGMD5Kz/w8y+9WpPjACfnA6QAYtCnVxzOhA0CUH0XrPBQs6h1uJOLJ6LzvAsmb51rLeojti31EkbaY3rJ6ETYYZxuHWR2o5zdsXf1xPgBCH/ZHQndoKKIVfHThLjDWe5Lqp6ca1jJoI/JjN5MJv5lGcAcF5ekQmNn8S1hQO7HaxnKwy2FhvwuiGawzdgZ862qvOh+rwgY6hr5dsFxP5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add memblock_alloc_low() coverage using the simulator's low address
limit. Exercise aligned allocation, an allocation whose last byte is
immediately below the limit, an alignment constraint that prevents
fitting below it, and fully reserved low memory with high memory still
available.

Run each case with bottom-up and top-down allocation. Check zeroing
and reserved-region accounting as well as returned addresses. Verify
that an unrestricted allocation can use the free high memory after
the low allocation fails.

Document the simulated limit and remove the completed TODO.

Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/memblock/Makefile              |   3 +-
 tools/testing/memblock/README                |  12 +-
 tools/testing/memblock/TODO                  |   5 -
 tools/testing/memblock/main.c                |   2 +
 tools/testing/memblock/tests/alloc_low_api.c | 148 +++++++++++++++++++
 tools/testing/memblock/tests/alloc_low_api.h |   9 ++
 6 files changed, 166 insertions(+), 13 deletions(-)
 delete mode 100644 tools/testing/memblock/TODO
 create mode 100644 tools/testing/memblock/tests/alloc_low_api.c
 create mode 100644 tools/testing/memblock/tests/alloc_low_api.h

diff --git a/tools/testing/memblock/Makefile b/tools/testing/memblock/Makefile
index d80982ccdc20..20524fcbe3c7 100644
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
index b435f48d8a70..4ea293209548 100644
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
@@ -101,12 +101,10 @@ There's no need to explicitly free the dummy memory from memblock via
 memblock_free() call. The entry will be erased by reset_memblock_regions(),
 called at the beginning of each test.
 
-Known issues
-============
-
-1. Tests for memblock_alloc_low() can't be easily implemented. The function uses
-   ARCH_LOW_ADDRESS_LIMIT marco, which can't be changed to point at the low
-   memory of the memory_block.
+The simulator defines ARCH_LOW_ADDRESS_LIMIT in asm/dma.h using the midpoint
+of the MEM_SIZE range registered by setup_memblock(). This leaves registered
+memory both below and above the limit. The limit is the first address an
+allocation must not use; an allocation's base plus its size may equal the limit.
 
 References
 ==========
diff --git a/tools/testing/memblock/TODO b/tools/testing/memblock/TODO
deleted file mode 100644
index c13ad0dae776..000000000000
--- a/tools/testing/memblock/TODO
+++ /dev/null
@@ -1,5 +0,0 @@
-TODO
-=====
-
-1. Add tests for memblock_alloc_low() once the simulator can model
-   ARCH_LOW_ADDRESS_LIMIT against the low memory in memory_block
diff --git a/tools/testing/memblock/main.c b/tools/testing/memblock/main.c
index 278f9dec5008..9a96e178551b 100644
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
index 000000000000..a117431f1f71
--- /dev/null
+++ b/tools/testing/memblock/tests/alloc_low_api.c
@@ -0,0 +1,148 @@
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
+	/* Simulated physical RAM is not necessarily SMP_CACHE_BYTES aligned. */
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
+/* The last byte of the allocation is immediately below the low limit. */
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
+/* Allocation must fail after reserving all low memory, with high memory free. */
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
index 000000000000..2e3cbe336f5d
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


