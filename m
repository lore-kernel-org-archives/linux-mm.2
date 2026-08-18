Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67146C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABC836B01A9; Tue, 18 Aug 2026 09:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1EF66B01AB; Tue, 18 Aug 2026 09:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BFB26B01AE; Tue, 18 Aug 2026 09:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4506A6B01A9
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:13:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C78AAA0A2A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:13:02 +0000 (UTC)
X-FDA: 85114430604.01.3A41EFD
Received: from mta1.migadu.com (out-11.mta1.migadu.com [95.215.58.11])
	by imf28.hostedemail.com (Postfix) with ESMTP id D8B38C0009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:13:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yx3sMq+A;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.11 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zq0bUKU+j7Zk31zzbZSb/HLNY8HkDWM+5W1Mn5ee/yk=;
	b=SMyqac2vU+UWH0H+XeReMpc30F8EkutCuxHAPxgmWcqhYiIDFahMChGjlWy0eIGvvU1D9a
	iOkJsqaF/oUb2hQQc7NIpJLxmY2psunsO14HSXXvQs30ashdHPbRpJ3yD1O25aU/a8r68F
	d4MMM3khcgtP+jzJ6YfDsxzrUGtTSLI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yx3sMq+A;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.11 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058781;
	b=hQvF4516GnvhLYn+UjDdFDGG7zzzer+YkyFFD6AEAdyhU9gYh1iAxA415TfoFsXsxa7OFK
	J2q2gA9Ne+L5YRVE/rvo2OXThr81ZoPC7T+bX/bpQTQSqwynTCSUHofkB7au7IE31vWYHG
	dN1XkKr/OIIwzQH9xFfhdsWsNZ680Jo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uDZbM4DLAiIeCyYKYiSCL2eLy15fVFg3+DOrPDm/rRA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787058779; v=1; x=1787663579;
 b=Yx3sMq+A3CkrRWo6Jr1S36nhGOFlHEk50dErjDYt244xqxQEQhZ8FQl3RbSUzWIwFPDBB+xE
 fZ1uqiZ5gl5LbagmUS9zEFLX9tTXKVq1TR2SLgXB4Lqu3ZSde5mMdqtIU8crbDvmSYVB4d1l1xu
 f1BOpMpJDc1fXTDZlPB9DIl4=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:14::)
	by mta11.migadu.com with ESMTPS id d54d858bd5989204;
	Tue, 18 Aug 2026 13:12:59 +0000
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v6 12/12] selftests/mm: add PMD swap entry tests
Date: Tue, 18 Aug 2026 06:09:53 -0700
Message-ID: <20260818131202.494754-13-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818131202.494754-1-usama.arif@linux.dev>
References: <20260818131202.494754-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fpxnywhih1czxhaib5n6jqu9qcx6srqe
X-Rspamd-Queue-Id: D8B38C0009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787058780-130361
X-HE-Meta: U2FsdGVkX18TFkGMhJ/etNxCunNf8NRjz7nIOk6BrUDdIkxBjoETRRu8cgMB4IHapaoTVbQRJf0MSya0pOZw4ESLDdBXPk7d2LpoKzI7RY5w3LynxSh9FJWUIDcUTYicbmjdtWDLBBnqvdg27lUda7fwCmIGkP/lLVAZdQ8Wx5vhSpn0i0oCvRjtzw5ZYHs6hSHWHeGdWEYzfkmcW+K1sbLTCUuYr3fsKNbd7ebQyEAx5bbDH9FgPP2x+ZKwVbwUfzBcR0yiRGjFnuwsgaQ8jucfw7hlJPgq8ljsRo+Vn1MDZbnEn5YjAMnqpW0j/KfWtVfEYJdaEcDb9Se2nMSMy86A+pR3wZjmgeU/RR6YfJ7ePYwd5qe2zixaiA9tgKNPmJHm1BgE/RuMt4FTO3/eiSY9TXyIrmM9O8791C30kzVOEILpgiFwQxzrOghqOMRJCJi2XaW8/jRr5SO1N821DCWAcfeZlj9tIFgt4D4HFC7z0SDT8qYG3D5NplJ8mACYx+Sh55kZK53pRBqO+RC8Baa0LUWdwW1JMJyhqsv3HNI2WHOsESx1RXdecDfdq+JVJ3n8o3EAWZhcbMbPD3yuK4n1Qgbr7dqGszicsCjoGn33ItLq7bjGpNDalr4opDNSkcdYPgNe6QMVCB92x2sSlkDQC4heqvMfSKo8QBRqk09Bmk3iXDHil/9dD6/exMqzNrn8lzuxbkfNcLK6HCGP+NalOzZZMofvg7jEAeq65t9yoLHBE4mjRfoPz+WfrvydRhqxsURN9mey4VkDYXClzGdmeshfHEfp4SZGdLVSvMoV/uNFM+3pI+d/2yLfE9xfoFFs+0hgVwPzcFcjsYOFn47QD79kZ868J/3qoD9oLmh9gZ/FwCqamUj5xJBE48myTgC6GUH49iFw895Xk3vfmcxihnz93YOUNP7pJiAPXnAQPUugCux2R+zdu16DE7y6owc1wjjHevGpa1kHcq3
 lMdXpugp
 85H6rBRNhfby15sZYjRRevqyy/nsZWdjXPaI2cMeAkAqfBZqhRmQSIsaYVkslvemgx/eLGT/yBt6RQws5VyMLkeKiWpHxvOukpjJUBJaZJU5o85cNgTRM89fSSq0O2Q99gOtbWhLi18zNPsLiN3+YncgE0WyYjkJxFDbII3b35CTcw5hagT65MkYJlO4eSNIvNuXCFIQcfRxdoq0SIE6GtOb/gIohfNWIdEBRapkbNtGI2H0EoeP10stHqfmBJkAv5Km3RwgiypmLzZUJ8S5yefvGxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Exercise the PMD swap entry paths.  Each test gets a fresh PMD-mapped
THP from fixture setup, fills it with a page-distinct pattern, swaps it
out with MADV_PAGEOUT, and verifies that thp_swpout_pmd increased.

The tests are:

  - basic: fault in a swapped PMD and verify its contents.
  - fork: verify parent and child can fault in the shared swap entry.
  - fork_cow: verify parent and child writes remain isolated.
  - write: fault in by writing one byte and preserve the rest of the THP.
  - rwp_swapin: verify userfaultfd RWP survives PMD-order swap-in.
  - munmap: unmap the full entry and check that VmSwap drops.
  - mprotect: change full-range protections without faulting the entry in.
  - split_mprotect: change half-range protections and verify the data.
  - split_munmap: unmap half, drop its accounting, and preserve the rest.
  - uffdio_move: move the entry and RWP state, then fault it in at dst.
  - mremap: force the entry to a new aligned address and verify the data.
  - pagemap: verify swapped bits and consecutive swap-slot offsets.
  - mincore: walk the entry without faulting it in.
  - madvise_free: release the slots, clear the entry, and verify zeroes.
  - madvise_willneed: prefetch the entry and verify subsequent swap-in.
  - swapoff: unuse the entry and preserve data and PMD/RWP state.

Fixture teardown owns the mappings and file descriptors and restores
swap after assertion failures.  PMD_SWAP_DEVICE remains optional for
swapoff.

Distinguish an environment that cannot allocate a PMD THP from a failure
to install a PMD swap entry, so the former skips while the latter fails.
Also check VmSwap accounting, pagemap slot offsets, swapped state after
non-faulting operations, and PMD restoration when zswap does not require
PTE fallback.

Register the test with run_vmtests.sh and the default kselftest runner.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 tools/testing/selftests/mm/Makefile         |   2 +
 tools/testing/selftests/mm/ksft_pmd_swap.sh |   4 +
 tools/testing/selftests/mm/pmd_swap.c       | 742 ++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh   |   4 +
 4 files changed, 752 insertions(+)
 create mode 100755 tools/testing/selftests/mm/ksft_pmd_swap.sh
 create mode 100644 tools/testing/selftests/mm/pmd_swap.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 2d5366196e309..dafa3a482451d 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -104,6 +104,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
+TEST_GEN_FILES += pmd_swap
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
@@ -165,6 +166,7 @@ TEST_PROGS += ksft_mremap.sh
 TEST_PROGS += ksft_pagemap.sh
 TEST_PROGS += ksft_pfnmap.sh
 TEST_PROGS += ksft_pkey.sh
+TEST_PROGS += ksft_pmd_swap.sh
 TEST_PROGS += ksft_process_madv.sh
 TEST_PROGS += ksft_process_mrelease.sh
 TEST_PROGS += ksft_rmap.sh
diff --git a/tools/testing/selftests/mm/ksft_pmd_swap.sh b/tools/testing/selftests/mm/ksft_pmd_swap.sh
new file mode 100755
index 0000000000000..0f070b4729a89
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_pmd_swap.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t pmd_swap
diff --git a/tools/testing/selftests/mm/pmd_swap.c b/tools/testing/selftests/mm/pmd_swap.c
new file mode 100644
index 0000000000000..30911ef6480f3
--- /dev/null
+++ b/tools/testing/selftests/mm/pmd_swap.c
@@ -0,0 +1,742 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Test PMD-level swap entries and their users. */
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <stdint.h>
+#include <sys/random.h>
+#include <sys/swap.h>
+#include <sys/syscall.h>
+#include <sys/ioctl.h>
+#include <poll.h>
+#include <pthread.h>
+#include <linux/userfaultfd.h>
+#include <time.h>
+
+#include "kselftest_harness.h"
+#include "vm_util.h"
+
+#define ZSWAP_ENABLED_PATH "/sys/module/zswap/parameters/enabled"
+
+/* pagemap: bits 0-54 hold the PFN, or type|offset for a swap entry. */
+#define PM_PFRAME_MASK		((1ULL << 55) - 1)
+/* Must match MAX_SWAPFILES_SHIFT in include/linux/swap.h. */
+#define MAX_SWAPFILES_SHIFT	5
+
+static bool check_swapped(int pagemap_fd, char *addr, unsigned long size)
+{
+	unsigned long off;
+
+	for (off = 0; off < size; off += getpagesize())
+		if (!pagemap_is_swapped(pagemap_fd, addr + off))
+			return false;
+	return true;
+}
+
+static bool zswap_enabled(void)
+{
+	char enabled = 0;
+	FILE *f;
+
+	f = fopen(ZSWAP_ENABLED_PATH, "r");
+	if (!f)
+		return false;
+
+	if (fscanf(f, " %c", &enabled) != 1)
+		enabled = 0;
+	fclose(f);
+
+	return enabled == 'Y' || enabled == 'y' || enabled == '1';
+}
+
+static bool swap_available(unsigned long required_bytes)
+{
+	unsigned long required_kb = (required_bytes + 1023) / 1024;
+	unsigned long size_kb, used_kb;
+	char line[256];
+	bool ret = false;
+	FILE *f;
+
+	f = fopen("/proc/swaps", "r");
+	if (!f)
+		return false;
+
+	/* Skip the header. */
+	if (!fgets(line, sizeof(line), f))
+		goto out;
+
+	while (fgets(line, sizeof(line), f)) {
+		if (sscanf(line, "%*s %*s %lu %lu", &size_kb, &used_kb) == 2 &&
+		    size_kb >= used_kb && size_kb - used_kb >= required_kb) {
+			ret = true;
+			break;
+		}
+	}
+
+out:
+	fclose(f);
+	return ret;
+}
+
+static unsigned long read_vm_event(const char *name)
+{
+	char line[256];
+	size_t name_len = strlen(name);
+	unsigned long val = 0;
+	FILE *f;
+
+	f = fopen("/proc/vmstat", "r");
+	if (!f)
+		return 0;
+	while (fgets(line, sizeof(line), f)) {
+		if (!strncmp(line, name, name_len) && line[name_len] == ' ') {
+			val = strtoul(line + name_len + 1, NULL, 10);
+			break;
+		}
+	}
+	fclose(f);
+	return val;
+}
+
+static unsigned int random_seed(void)
+{
+	unsigned int seed;
+
+	if (getrandom(&seed, sizeof(seed), 0) != sizeof(seed))
+		seed = (unsigned int)time(NULL);
+	return seed;
+}
+
+static unsigned char pattern_byte(unsigned int seed, unsigned long off)
+{
+	return (unsigned char)(seed + off + (off >> 8) + (off >> 16));
+}
+
+static void fill_pattern(char *buf, unsigned long size, unsigned int seed)
+{
+	unsigned long i;
+
+	for (i = 0; i < size; i++)
+		buf[i] = (char)pattern_byte(seed, i);
+}
+
+static bool verify_pattern_range(char *buf, unsigned long size,
+				 unsigned int seed, unsigned long offset)
+{
+	unsigned long i;
+
+	for (i = 0; i < size; i++)
+		if ((unsigned char)buf[i] != pattern_byte(seed, offset + i))
+			return false;
+	return true;
+}
+
+static bool verify_pattern(char *buf, unsigned long size, unsigned int seed)
+{
+	return verify_pattern_range(buf, size, seed, 0);
+}
+
+static bool verify_zero(char *buf, unsigned long size)
+{
+	unsigned long i;
+
+	for (i = 0; i < size; i++)
+		if (buf[i])
+			return false;
+	return true;
+}
+
+/*
+ * mmap an anonymous PMD-aligned region of pmd_size bytes. Over-allocates
+ * by one PMD and trims the unaligned head/tail so the returned address is
+ * PMD-aligned (required for whole-PMD UFFDIO_MOVE).
+ */
+static char *mmap_pmd_aligned(unsigned long pmd_size)
+{
+	unsigned long pad = pmd_size;
+	char *raw, *aligned;
+
+	raw = mmap(NULL, pmd_size + pad, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (raw == MAP_FAILED)
+		return MAP_FAILED;
+
+	aligned = (char *)(((uintptr_t)raw + pmd_size - 1) & ~(pmd_size - 1));
+	if (aligned != raw)
+		munmap(raw, aligned - raw);
+	if (aligned + pmd_size != raw + pmd_size + pad)
+		munmap(aligned + pmd_size,
+		       (raw + pmd_size + pad) - (aligned + pmd_size));
+	return aligned;
+}
+
+enum swap_thp_result {
+	SWAP_THP_OK,
+	SWAP_THP_UNAVAILABLE,
+	SWAP_THP_FAILED,
+};
+
+/* Per-process swapped size in bytes, from /proc/self/status VmSwap. */
+static unsigned long read_vmswap(void)
+{
+	char line[256];
+	unsigned long kb = 0;
+	FILE *f;
+
+	f = fopen("/proc/self/status", "r");
+	if (!f)
+		return 0;
+	while (fgets(line, sizeof(line), f)) {
+		if (!strncmp(line, "VmSwap:", 7)) {
+			kb = strtoul(line + 7, NULL, 10);
+			break;
+		}
+	}
+	fclose(f);
+	return kb * 1024;
+}
+
+static bool swap_out_pmd(char *mem, unsigned long pmd_size, int pagemap_fd)
+{
+	unsigned long before = read_vm_event("thp_swpout_pmd");
+	unsigned long after;
+
+	if (madvise(mem, pmd_size, MADV_PAGEOUT)) {
+		ksft_print_msg("MADV_PAGEOUT failed: %s\n", strerror(errno));
+		return false;
+	}
+	if (!check_swapped(pagemap_fd, mem, pmd_size)) {
+		ksft_print_msg("MADV_PAGEOUT did not swap the whole PMD range\n");
+		return false;
+	}
+
+	after = read_vm_event("thp_swpout_pmd");
+	ksft_print_msg("thp_swpout_pmd: %lu -> %lu\n", before, after);
+	return after > before;
+}
+
+static char *alloc_fill_swap_thp(unsigned long pmd_size, int pagemap_fd,
+				 unsigned int seed, enum swap_thp_result *res)
+{
+	char *mem;
+
+	*res = SWAP_THP_UNAVAILABLE;
+
+	mem = mmap_pmd_aligned(pmd_size);
+	if (mem == MAP_FAILED)
+		return MAP_FAILED;
+
+	if (madvise(mem, pmd_size, MADV_HUGEPAGE)) {
+		ksft_print_msg("MADV_HUGEPAGE failed: %s\n", strerror(errno));
+		munmap(mem, pmd_size);
+		return MAP_FAILED;
+	}
+	fill_pattern(mem, pmd_size, seed);
+
+	if (!check_huge_anon(mem, pmd_size, 1, pmd_size)) {
+		munmap(mem, pmd_size);
+		return MAP_FAILED;
+	}
+	*res = SWAP_THP_FAILED;
+
+	if (!swap_out_pmd(mem, pmd_size, pagemap_fd)) {
+		munmap(mem, pmd_size);
+		return MAP_FAILED;
+	}
+
+	*res = SWAP_THP_OK;
+	return mem;
+}
+
+struct rwp_access_args {
+	unsigned char *addr;
+	unsigned char expected;
+	bool write;
+	bool ok;
+};
+
+static void *rwp_access_thread(void *data)
+{
+	struct rwp_access_args *args = data;
+
+	if (args->write)
+		*args->addr = args->expected;
+	args->ok = *args->addr == args->expected;
+	return NULL;
+}
+
+static int register_rwp(char *addr, unsigned long size, bool protect)
+{
+	struct uffdio_register reg = {};
+	struct uffdio_rwprotect rwp = {};
+	struct uffdio_api api = {};
+	int uffd;
+
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (uffd < 0)
+		return -1;
+
+	api.api = UFFD_API;
+	api.features = UFFD_FEATURE_RWP;
+	if (ioctl(uffd, UFFDIO_API, &api) ||
+	    !(api.features & UFFD_FEATURE_RWP))
+		goto error;
+
+	reg.range.start = (unsigned long)addr;
+	reg.range.len = size;
+	reg.mode = UFFDIO_REGISTER_MODE_RWP;
+	if (ioctl(uffd, UFFDIO_REGISTER, &reg))
+		goto error;
+
+	if (!protect)
+		return uffd;
+
+	rwp.range.start = (unsigned long)addr;
+	rwp.range.len = size;
+	rwp.mode = UFFDIO_RWPROTECT_MODE_RWP;
+	if (!ioctl(uffd, UFFDIO_RWPROTECT, &rwp))
+		return uffd;
+
+error:
+	close(uffd);
+	return -1;
+}
+
+static bool expect_rwp_fault(int uffd, char *addr, unsigned long size,
+			     unsigned char expected, bool write)
+{
+	struct rwp_access_args args = {
+		.addr = (unsigned char *)addr,
+		.expected = expected,
+		.write = write,
+	};
+	struct uffdio_rwprotect rwp = {
+		.range = {
+			.start = (unsigned long)addr,
+			.len = size,
+		},
+	};
+	struct pollfd pollfd = {
+		.fd = uffd,
+		.events = POLLIN,
+	};
+	struct uffd_msg msg = {};
+	pthread_t thread;
+	bool saw_rwp = false;
+	int ret;
+
+	if (pthread_create(&thread, NULL, rwp_access_thread, &args))
+		return false;
+
+	ret = poll(&pollfd, 1, 5000);
+	if (ret == 1 && (pollfd.revents & POLLIN) &&
+	    read(uffd, &msg, sizeof(msg)) == (ssize_t)sizeof(msg)) {
+		saw_rwp = msg.event == UFFD_EVENT_PAGEFAULT &&
+			  (msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_RWP);
+	}
+
+	/* Resolve the access even on failure so the worker cannot remain blocked. */
+	ioctl(uffd, UFFDIO_RWPROTECT, &rwp);
+	if (pthread_join(thread, NULL))
+		return false;
+	return saw_rwp && args.ok;
+}
+
+FIXTURE(pmd_swap)
+{
+	unsigned long pmd_size;
+	unsigned long mem_len;
+	int pagemap_fd;
+	int uffd;
+	unsigned int seed;
+	bool zswap_enabled;
+	bool swap_disabled;
+	const char *swap_dev;
+	char *mem;
+	char *aux;
+};
+
+FIXTURE_SETUP(pmd_swap)
+{
+	enum swap_thp_result res;
+
+	self->pagemap_fd = -1;
+	self->uffd = -1;
+	self->mem = MAP_FAILED;
+	self->aux = MAP_FAILED;
+	self->mem_len = 0;
+	self->swap_disabled = false;
+	self->swap_dev = getenv("PMD_SWAP_DEVICE");
+	if (!strcmp(_metadata->name, "swapoff") && !self->swap_dev)
+		SKIP(return, "PMD_SWAP_DEVICE env var not set\n");
+
+	self->pmd_size = read_pmd_pagesize();
+	if (!self->pmd_size)
+		SKIP(return, "Cannot determine PMD size\n");
+
+	self->pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (self->pagemap_fd < 0)
+		SKIP(return, "Cannot open /proc/self/pagemap\n");
+
+	if (!swap_available(self->pmd_size))
+		SKIP(return, "No active swap device has enough free space\n");
+
+	self->seed = random_seed();
+	self->zswap_enabled = zswap_enabled();
+	self->mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd,
+					self->seed, &res);
+	if (self->mem == MAP_FAILED) {
+		ASSERT_NE(res, SWAP_THP_FAILED);
+		SKIP(return, "Could not create swapped THP\n");
+	}
+	self->mem_len = self->pmd_size;
+}
+
+FIXTURE_TEARDOWN(pmd_swap)
+{
+	int swap_err = 0;
+	int swap_ret = 0;
+
+	if (self->swap_disabled) {
+		swap_ret = swapon(self->swap_dev, 0);
+		swap_err = errno;
+	}
+	if (self->uffd >= 0)
+		close(self->uffd);
+	if (self->aux != MAP_FAILED)
+		munmap(self->aux, self->pmd_size);
+	if (self->mem != MAP_FAILED)
+		munmap(self->mem, self->mem_len);
+	if (self->pagemap_fd >= 0)
+		close(self->pagemap_fd);
+
+	EXPECT_EQ(swap_ret, 0) {
+		TH_LOG("swapon(%s) failed: %s", self->swap_dev,
+		       strerror(swap_err));
+	}
+}
+
+TEST_F(pmd_swap, basic)
+{
+	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
+}
+
+TEST_F(pmd_swap, fork)
+{
+	pid_t pid;
+	int status;
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0)
+		_exit(verify_pattern(self->mem, self->pmd_size,
+				     self->seed) ? 0 : 1);
+
+	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
+
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), 0);
+}
+
+TEST_F(pmd_swap, fork_cow)
+{
+	unsigned int parent_seed = self->seed;
+	unsigned int child_seed = ~self->seed;
+	unsigned int new_seed = self->seed ^ 0xa5a5a5a5;
+	int release_child[2];
+	bool parent_ok;
+	char c = 0;
+	pid_t pid;
+	int status, ret;
+
+	ASSERT_EQ(pipe(release_child), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		close(release_child[1]);
+		if (read(release_child[0], &c, 1) != 1)
+			_exit(1);
+		if (!verify_pattern(self->mem, self->pmd_size, parent_seed))
+			_exit(2);
+		fill_pattern(self->mem, self->pmd_size, child_seed);
+		if (!verify_pattern(self->mem, self->pmd_size, child_seed))
+			_exit(3);
+		_exit(0);
+	}
+
+	close(release_child[0]);
+	fill_pattern(self->mem, self->pmd_size, new_seed);
+	parent_ok = verify_pattern(self->mem, self->pmd_size, new_seed);
+	ret = write(release_child[1], &c, 1);
+	close(release_child[1]);
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+	ASSERT_EQ(ret, 1);
+	ASSERT_TRUE(parent_ok);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), 0);
+	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, new_seed));
+}
+
+TEST_F(pmd_swap, write)
+{
+	self->mem[0] = 0xbb;
+	ASSERT_EQ(self->mem[0], (char)0xbb);
+	ASSERT_TRUE(verify_pattern_range(self->mem + 1, self->pmd_size - 1,
+					 self->seed, 1));
+	if (!self->zswap_enabled)
+		ASSERT_TRUE(check_huge_anon(self->mem, self->pmd_size, 1,
+					    self->pmd_size));
+}
+
+TEST_F(pmd_swap, rwp_swapin)
+{
+	self->uffd = register_rwp(self->mem, self->pmd_size, true);
+	if (self->uffd < 0)
+		SKIP(return, "Userfaultfd RWP unsupported\n");
+
+	ASSERT_TRUE(expect_rwp_fault(self->uffd, self->mem, self->pmd_size,
+				     pattern_byte(self->seed, 0), false));
+	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
+}
+
+TEST_F(pmd_swap, munmap)
+{
+	unsigned long swap_before, swap_after;
+	int ret;
+
+	swap_before = read_vmswap();
+	ASSERT_GE(swap_before, self->pmd_size);
+
+	ret = munmap(self->mem, self->pmd_size);
+	if (!ret) {
+		self->mem = MAP_FAILED;
+		self->mem_len = 0;
+	}
+	ASSERT_EQ(ret, 0);
+
+	swap_after = read_vmswap();
+	ASSERT_LE(swap_after, swap_before - self->pmd_size);
+}
+
+TEST_F(pmd_swap, mprotect)
+{
+	ASSERT_EQ(mprotect(self->mem, self->pmd_size, PROT_READ), 0);
+	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
+				  self->pmd_size));
+	ASSERT_EQ(mprotect(self->mem, self->pmd_size,
+			   PROT_READ | PROT_WRITE), 0);
+	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
+				  self->pmd_size));
+	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
+}
+
+TEST_F(pmd_swap, split_mprotect)
+{
+	unsigned long half = self->pmd_size / 2;
+
+	ASSERT_EQ(mprotect(self->mem, half, PROT_READ), 0);
+	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
+				  self->pmd_size));
+	ASSERT_EQ(mprotect(self->mem, half, PROT_READ | PROT_WRITE), 0);
+	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
+}
+
+TEST_F(pmd_swap, split_munmap)
+{
+	unsigned long half = self->pmd_size / 2;
+	unsigned long swap_before = read_vmswap();
+	unsigned long i;
+	char *base = self->mem;
+	int ret;
+
+	ASSERT_GE(swap_before, half);
+	ret = munmap(base, half);
+	if (!ret) {
+		self->mem = base + half;
+		self->mem_len = half;
+	}
+	ASSERT_EQ(ret, 0);
+	ASSERT_LE(read_vmswap(), swap_before - half);
+
+	for (i = 0; i < half; i += getpagesize())
+		ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd,
+					       self->mem + i));
+	ASSERT_TRUE(verify_pattern_range(self->mem, half, self->seed, half));
+}
+
+TEST_F(pmd_swap, uffdio_move)
+{
+	struct uffdio_register reg = {};
+	struct uffdio_move move = {};
+	struct uffdio_api api = {};
+	bool rwp;
+
+	self->aux = mmap_pmd_aligned(self->pmd_size);
+	if (self->aux == MAP_FAILED)
+		SKIP(return, "Could not mmap aligned dst\n");
+	ASSERT_EQ(madvise(self->aux, self->pmd_size, MADV_HUGEPAGE), 0);
+
+	self->uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (self->uffd < 0)
+		SKIP(return, "userfaultfd unavailable\n");
+
+	api.api = UFFD_API;
+	api.features = UFFD_FEATURE_MOVE | UFFD_FEATURE_RWP;
+	if (ioctl(self->uffd, UFFDIO_API, &api) ||
+	    !(api.features & UFFD_FEATURE_MOVE))
+		SKIP(return, "UFFD_FEATURE_MOVE unsupported\n");
+	rwp = api.features & UFFD_FEATURE_RWP;
+
+	reg.range.start = (unsigned long)self->aux;
+	reg.range.len = self->pmd_size;
+	reg.mode = UFFDIO_REGISTER_MODE_MISSING |
+		   (rwp ? UFFDIO_REGISTER_MODE_RWP : 0);
+	ASSERT_EQ(ioctl(self->uffd, UFFDIO_REGISTER, &reg), 0);
+
+	move.dst = (unsigned long)self->aux;
+	move.src = (unsigned long)self->mem;
+	move.len = self->pmd_size;
+	ASSERT_EQ(ioctl(self->uffd, UFFDIO_MOVE, &move), 0);
+	ASSERT_EQ(move.move, self->pmd_size);
+
+	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->aux,
+				  self->pmd_size));
+	if (rwp)
+		ASSERT_TRUE(expect_rwp_fault(self->uffd, self->aux,
+					     self->pmd_size,
+					     pattern_byte(self->seed, 0), false));
+	ASSERT_TRUE(verify_pattern(self->aux, self->pmd_size, self->seed));
+	if (!self->zswap_enabled)
+		ASSERT_TRUE(check_huge_anon(self->aux, self->pmd_size, 1,
+					    self->pmd_size));
+}
+
+TEST_F(pmd_swap, mremap)
+{
+	char *new_mem, *dst;
+
+	self->aux = mmap_pmd_aligned(self->pmd_size);
+	if (self->aux == MAP_FAILED)
+		SKIP(return, "Could not mmap aligned dst\n");
+	dst = self->aux;
+
+	new_mem = mremap(self->mem, self->pmd_size, self->pmd_size,
+			 MREMAP_MAYMOVE | MREMAP_FIXED, dst);
+	if (new_mem != MAP_FAILED) {
+		self->mem = new_mem;
+		self->aux = MAP_FAILED;
+	}
+	ASSERT_NE(new_mem, MAP_FAILED);
+	ASSERT_EQ(new_mem, dst);
+
+	ASSERT_TRUE(check_swapped(self->pagemap_fd, new_mem, self->pmd_size));
+	ASSERT_TRUE(verify_pattern(new_mem, self->pmd_size, self->seed));
+}
+
+TEST_F(pmd_swap, pagemap)
+{
+	uint64_t entry, first = 0;
+	unsigned long off;
+
+	for (off = 0; off < self->pmd_size; off += getpagesize()) {
+		entry = pagemap_get_entry(self->pagemap_fd, self->mem + off);
+		ASSERT_TRUE(entry & (1ULL << 62));
+		ASSERT_FALSE(entry & (1ULL << 63));
+
+		if (entry & PM_PFRAME_MASK) {
+			uint64_t idx = off / getpagesize();
+
+			if (!off)
+				first = entry & PM_PFRAME_MASK;
+			ASSERT_EQ(entry & PM_PFRAME_MASK,
+				  first + (idx << MAX_SWAPFILES_SHIFT));
+		}
+	}
+}
+
+TEST_F(pmd_swap, mincore)
+{
+	unsigned long pages = self->pmd_size / getpagesize();
+	unsigned char vec[pages];
+
+	ASSERT_EQ(mincore(self->mem, self->pmd_size, vec), 0);
+	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
+				  self->pmd_size));
+}
+
+TEST_F(pmd_swap, madvise_free)
+{
+	unsigned long swap_before = read_vmswap();
+	unsigned long i;
+
+	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
+				  self->pmd_size));
+	ASSERT_GE(swap_before, self->pmd_size);
+	ASSERT_EQ(madvise(self->mem, self->pmd_size, MADV_FREE), 0);
+	for (i = 0; i < self->pmd_size; i += getpagesize())
+		ASSERT_FALSE(pagemap_is_swapped(self->pagemap_fd,
+						self->mem + i));
+	ASSERT_LE(read_vmswap(), swap_before - self->pmd_size);
+	ASSERT_TRUE(verify_zero(self->mem, self->pmd_size));
+}
+
+TEST_F(pmd_swap, madvise_willneed)
+{
+	ASSERT_EQ(madvise(self->mem, self->pmd_size, MADV_WILLNEED), 0);
+	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
+				  self->pmd_size));
+	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
+	if (!self->zswap_enabled)
+		ASSERT_TRUE(check_huge_anon(self->mem, self->pmd_size, 1,
+					    self->pmd_size));
+}
+
+TEST_F(pmd_swap, swapoff)
+{
+	int ret, err;
+
+	self->uffd = register_rwp(self->mem, self->pmd_size, true);
+
+	ret = swapoff(self->swap_dev);
+	err = errno;
+	if (!ret)
+		self->swap_disabled = true;
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("swapoff(%s) failed: %s", self->swap_dev, strerror(err));
+	}
+
+	/*
+	 * Check residency before touching the memory. If we read
+	 * first, a bug that left a PMD swap entry in place after swapoff
+	 * would silently trigger do_huge_pmd_swap_page() and reinstall a
+	 * PMD mapping, masking the regression.
+	 */
+	if (!self->zswap_enabled)
+		ASSERT_TRUE(check_huge_anon(self->mem, self->pmd_size, 1,
+					    self->pmd_size));
+	if (self->uffd >= 0)
+		ASSERT_TRUE(expect_rwp_fault(self->uffd, self->mem,
+					     self->pmd_size,
+					     pattern_byte(self->seed, 0), false));
+	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
+
+	ret = swapon(self->swap_dev, 0);
+	err = errno;
+	if (!ret)
+		self->swap_disabled = false;
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("swapon(%s) failed: %s", self->swap_dev, strerror(err));
+	}
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d09f9f6a384ee..ff53ff28c0042 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -69,6 +69,8 @@ separated by spaces:
 	test pagemap_scan IOCTL
 - pfnmap
 	tests for VM_PFNMAP handling
+- pmd_swap
+	tests for PMD-level swap entries
 - process_madv
 	test for process_madv
 - cow
@@ -399,6 +401,8 @@ CATEGORY="pagemap" run_test ./pagemap_ioctl
 
 CATEGORY="pfnmap" run_test ./pfnmap
 
+CATEGORY="pmd_swap" run_test ./pmd_swap
+
 # COW tests
 CATEGORY="cow" run_test ./cow
 
-- 
2.53.0-Meta


