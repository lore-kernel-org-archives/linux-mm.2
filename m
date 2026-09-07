Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30B6BC79F8C
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 01:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BE1F6B0092; Sun,  6 Sep 2026 21:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09BEC6B0096; Sun,  6 Sep 2026 21:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E79146B0095; Sun,  6 Sep 2026 21:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCCDD6B0092
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:21:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56B2A1A0601
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:21:03 +0000 (UTC)
X-FDA: 85185212406.04.02DA76E
Received: from out-2uec-a100.jellyfish.systems (out-2uec-a100.jellyfish.systems [63.250.43.100])
	by imf21.hostedemail.com (Postfix) with ESMTP id 82EF81C0006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:21:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=izxF9O+b;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of hi@tychen.cc designates 63.250.43.100 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788744061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJ8Ln+jyy31Wa7u6fUJJyoQB3HH2yJgGsQqYaXNmcak=;
	b=NMuxPtyWs21XzgX3PeNBgMc8lSS10WTSTTw6wDIriagHzTwMpS52NCYejgP4IbF63nwCze
	L5AqfY4AxvmFVszvvopFpl0KKx4rndK6mf4mydqbPfLjGKLdPHUR9DMWewPV3u9TCLqCdO
	iF3bWfqxPM50Q8x1aI96z/vPX1Nr0oc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788744061;
	b=sfipFKr0IxqeA6cMxiLOGY3WDi6bO+opkLiq5RcyTvjZSArfjK9rPfrYE7tIGExpvEuYUM
	5ZKT4uu+P9N9ldI1RPtxN4+4xSxyfxf1JjFpnsd3cNZEcO2jBKoaTfr3ax/5EtI+mjWHr2
	q+/af4DD2HLmIM0I4D38gFJf4KURrTU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=izxF9O+b;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of hi@tychen.cc designates 63.250.43.100 as permitted sender) smtp.mailfrom=hi@tychen.cc
Received: from 192.168.5.3 (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hdTlt1r8xz6tlq;
	Mon, 07 Sep 2026 01:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788744045;
	bh=GJ8Ln+jyy31Wa7u6fUJJyoQB3HH2yJgGsQqYaXNmcak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izxF9O+bpDX4/r9946K3Xd+qZc+pi3R1kKotELCUFrBqjOCH1OQ6Zp4C3hAnmlNf4
	 I3sfdsBOLwNjgDem4khzok9OL68+JITX9jArTPV8r6Y3vNkVG7vPKbsH/oHbIbBGcc
	 iX2Mt5JmemokecGVQH+GWS4dTey9msbcLvfTIvSHTKd5UiY+Zf1sKudFEr/joQxaWa
	 BFb+s68TWUVO9Oabeg41mg1sxBNwyYX9x8uz1IDz9P61bh1MpyolZkrYiWB3ZkEdjt
	 LG7MrK/eFpAaQz6cfcD+uOfwubL+mVRj1y7xI5prC4fXWL7y6tKj6077OKCbQRuIic
	 2i0C9FF/KeW8A==
From: Tianyi Chen <hi@tychen.cc>
To: rppt@kernel.org
Cc: Tianyi Chen <hi@tychen.cc>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] memblock tests: cover allocations below the low address limit
Date: Mon,  7 Sep 2026 09:20:33 +0800
Message-ID: <178874362959.1415955.5009708808960886376.memblock-v2-2@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <178874362959.1415955.18132997964995947947.memblock-v2-0@tychen.cc>
References: <20260906144011.848898-1-hi@tychen.cc> <178874362959.1415955.18132997964995947947.memblock-v2-0@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 82EF81C0006
X-Stat-Signature: yce3bc78uh3c7boditbce9bcgtt684sm
X-Rspam-User: 
X-HE-Tag: 1788744061-705
X-HE-Meta: U2FsdGVkX1+Dm83/LO3qBUJiOzn3SBaWKAieP3Xg9GgiAt7zRj0FBxpg+DSlG8AJhpLaS5Bu0Ss2aD68BQaNgbBTfYQ1NNRsJ7ilSObMZrcqXn61L/sfIpSVo3GdAANA4G5kqrVErcIygMPUv5W4zZ+PeiCIYPIZ3NQMZ22aQ9FgaTZLd4Nq8JWFmZMS3gUsqlUmgACGLWuFvSFEhTi4R7r5P9E5ENmYn32nOgvwANe/ydn/mdJirSXosKm3JJbCbA+NwmTeGsgTqK2J7ZiFIzD4WWiCrFVMO1EQduzGZOCFH1pAt2K5AwF4w09SlZjwqf1wGgwo8WwHWRdwBYwtKKY+Vh8E9bWwrehSRlHzKfAxGeShbBlY0O2Uhsa+0s2dI4ckN2LiG/L67XuG+dymRLO67Bhh6mGbWDDu1SK3QV7SzdBEkjwzGAHoNpq4jDs4Q5zSpLXpDwBVhxbRJtX6Mzt1pm8qo5VU45aaWbdYUsmYBiQFhlAffjhFfPirMeLc0yQokmfbUNpfvzk3ajkpROEYCjVj1jos0msSApLHJZGH6eof2IyQdUxKewe/HihSoDIL2Eqw8mCLIwGJxdl5ruiquiyDj9uvoGDwtM7hM/RhImiLlQxRTj1FaL6URSKAFPw9zCv2tQAE06cXGtw/MqiN5bTeDQiuqpTFXyqOUklD/8BZz4tfPheMbhnUi7OQE++yEHamiistoCxbZLAiMF8KMNRPW+aC3/3Jf2Jonkp/aYrcAYphk/bzzvTVYdyzXyG3zbeGo21ASJe0jCzJINwFioY7odN7AWwSutOSXcGwpDniZvimPZ7RhGavXhRPeYVKk6kzgUEYne0kCB9m5/FmwpSql7MlSBYCtnPmOt1PFmAASeZMjSvcBPNYPU9s5VWSTAHopc+WSMZmfGHomcTFGmlm7/zRfTBLZVvTyYcquDQueiGdrUtkUepoDA6UtWozEy/XFdWRTCg8fj/
 1Kjx8jUz
 LiN9eeBH1zsmPPcsdT9QE6QtmloRWkk/RhjHeIOiiiTsigAHjHRzpzMRvv1ZeZUkjRU/eOZ/FVlGv+aN0cOqNRhwfeqW8ft9f5saMoQB2Ma73TTOJZU/Z/su5PQZaqxySYvKKbt8SiXYEgk4CgoXZjR0PMc4EjYAYcDUs4qbdtcGlUaYE5uC+nPERoI7qML8pzVQkR9+nFWL1plzrz69+NJ3JAm0+e7BgNVXtKB1nY0w4ZW0DfvOHYAyN3wmSWHX5AtoMuvCQ3jem1I6y0DOH/6ujDzodtNB7sxzM0+xz+seB1+ZJtwOgPDJtVMhGGgQ3SvSGbfOIQCHVzgk=
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

Document the registered memory range and its simulated limit, clarify
the allocation boundary, and remove the completed TODO.

Assisted-by: Codex:GPT-6
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/memblock/Makefile              |   3 +-
 tools/testing/memblock/README                |  14 +-
 tools/testing/memblock/TODO                  |   5 -
 tools/testing/memblock/main.c                |   2 +
 tools/testing/memblock/tests/alloc_low_api.c | 148 +++++++++++++++++++
 tools/testing/memblock/tests/alloc_low_api.h |   9 ++
 6 files changed, 168 insertions(+), 13 deletions(-)
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
index b435f48d8a7..13b7f58b2ee 100644
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
@@ -101,12 +101,12 @@ There's no need to explicitly free the dummy memory from memblock via
 memblock_free() call. The entry will be erased by reset_memblock_regions(),
 called at the beginning of each test.
 
-Known issues
-============
-
-1. Tests for memblock_alloc_low() can't be easily implemented. The function uses
-   ARCH_LOW_ADDRESS_LIMIT marco, which can't be changed to point at the low
-   memory of the memory_block.
+The simulator defines ARCH_LOW_ADDRESS_LIMIT in asm/dma.h using the midpoint
+of the MEM_SIZE range registered by setup_memblock(), rather than the larger
+PHYS_MEM_SIZE backing buffer. This leaves registered memory both below and
+above the limit, even when malloc() returns an address above the kernel's
+default limit. The limit is the first address an allocation must not use;
+an allocation's base plus its size may equal the limit.
 
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
index 00000000000..1ea5a36fcf0
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
+	/* malloc() does not guarantee SMP_CACHE_BYTES alignment. */
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


