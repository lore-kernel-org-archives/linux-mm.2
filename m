Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD9C2C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA1786B007B; Wed, 22 Jul 2026 11:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51066B008C; Wed, 22 Jul 2026 11:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF26D6B0096; Wed, 22 Jul 2026 11:22:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87C646B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:22:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A0F6A0216
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:22:55 +0000 (UTC)
X-FDA: 85016780310.20.DB92D4C
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf23.hostedemail.com (Postfix) with ESMTP id 28A07140004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:22:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tp2wjN40;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784733773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVUAqimjXtLI3JVFMZHEknW0nBd4Jma1uKQaQIujWB8=;
	b=NTypVGDBb0bgryz23KikcbX2/AHF+iyahQYzva1/zONjwMINsUr8Vi5htz8xz3Q+oij432
	h4+5hN8xIjaJoge17mr6+nEyeHibRw4lI65NJxiHRm3QTe8ugA5MlkyJahdzrhNf3h3KhN
	cAOnTauYgPSjFSafozkb1SFg/zaGJ2A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784733773;
	b=3nbtgShlT8q0Btz01++uR1xtROj3D2KoAZwKQZXmkYjWPEhDncdlFwqejtAA5ZvMFwv+Ez
	8Ruw/UgA3XF2HRQR+ceo2voiw9x1QxZMD4mf5oOj4Bi9Dpf88OEPrFuMbl+P/4tCuSWeQ2
	bOXtp+O/0xDtnk6RUD10q+tVlWAnUrY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tp2wjN40;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784733771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AVUAqimjXtLI3JVFMZHEknW0nBd4Jma1uKQaQIujWB8=;
	b=tp2wjN40lpg0oRu8S0LAUHZykEXMNZvzWgT+1KnxheRZmSMbYWWFLVRn+k81SJNwjQJl7x
	6mrzdhYrHOXxbAx3YPLqxdw5MNrQ9Eng/BtAeMiwrcdssQ56rJ9w9TSVIa4YVjfXQfZtMx
	trKLtn8Jj66ZURgkcQp3vgYhTHAjxgg=
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
Subject: [PATCH v5 11/11] selftests/mm: add PMD swap entry tests
Date: Wed, 22 Jul 2026 08:19:42 -0700
Message-ID: <20260722152043.2273289-12-usama.arif@linux.dev>
In-Reply-To: <20260722152043.2273289-1-usama.arif@linux.dev>
References: <20260722152043.2273289-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 28A07140004
X-Stat-Signature: u1gx5aznqt59f9kn9ou3zx1bp7b8b9hn
X-Rspam-User: 
X-HE-Tag: 1784733773-621619
X-HE-Meta: U2FsdGVkX19vOM8G5CKm1bWrxCga3mFc6/XdzoZdOfX/Ugk78HjNFskCC46WKmf1gT7pstXlrZuQtD3IfwFld79cYxYNPb9H1X1doFNqqQgDPVucWKtH69VnrNN4Ti8ENhZ/fAPL42P8dbC9m9iGTtmkchSeEqLskcsf3NOYzjGV/5yyui++tXB4ghLEIUJMuN1NYIZJdF/4VWhDKtgFAq0YMK2v2xqvxaN7lDvpcyAu2rnbgsXDqxM2Xc69RXB+ez9XXRoEotOTfdSxbHnAYtgXe8Skf2d7oflPmEx/75ES8PUfQYFws+j4MfZZiNrqFPHG4LbW+HY7BvovQnA+uOhodd7IMb4nTPAKb2EUWDMIjhvk52ENwdgUnS2gS1fGz6neamRtunByUsGjjs1lDeixnoOCriN2lCggHe6lHceDaMT8v+UQTh/uhI6P0UB0xu9t2pnH/4t7+2kW8iSk/Fm5hPgW6N1p2rh28g5df20leKG7u8gfLNNXnWQxPM+2r2ZwXwJDVK5+wjajeSagZ28A/TMWvwfpJQnBzKxE6825holVNHnVnnwMudfyY4z7jR3WWQUkY+zNVmhxUaKttg1zK4ptVwqHaayKkfSd2AC/O++wUN9trmOo3vKWpT1mVHnh/ovm5IG7QQfpIB0CJfFQ0Uw6k9cjVJCoZheshuI3bDmRe7rTTi3cIhFHgkiIhZ6NC7yYeXv6hWfuT7e4PdNFgjIC9mtaDFyBRNk7ewX8u3Y0meuKcce7PKtUhxw0e9w/ct+kHBNny2kCLJ/XJ06uJg/KmuHZQgt02s4PZGnggjvRNWgvNLDetqxHVErzNUYt2GR2kgidZcu+Vof9wYI4rQjImKx5wqZAolPllr2CKO5My7QER5yw+TWWkTS5CMJqp4Qd6jx17l2h2kDKWtZLAi66b/rEgipS159+NjFHdJ3AsEquWkKdLC5ETWITe7KVciE5M8Z1G7/fIQu
 zv69oga1
 uSH1ruS3MdLRQDxVHHaCIm0YQ6VTcY10bGDx6sqt7VdG2QYXDD9GPFFuOfpSHcs+uxcE5qM/L7Mm0h9EmOZWv4AjlSYEBvb7UPwZyoDeWTysBoT+ggY1Uu7ZqTdBBUNWQWaZNz4uDniUOX+0ZIa9Nmt8/9Nc4I7T6lGLxVbDdJMqgoo7ZprtIYLcpFi1CPqosHx7OQPyiNSMPlPM3gn8Va0N14+47X/xGjIQUbopcp7Kiwpw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Exercise the PMD swap entry paths. The tests allocate a PMD-mapped
THP, write a known pattern, swap it out via MADV_PAGEOUT, and then
exercise different code paths:

 - swap-out / swap-in round-trip with data verification
 - fork with read-only access from both parent and child
 - fork with writes in both processes to verify COW isolation
 - repeated swap cycles to catch reference counting issues
 - write fault on a swapped PMD to verify dirty handling and PMD
   mapping restoration
 - userfaultfd RWP preservation across PMD-order swap-in
 - munmap of a swapped PMD (zap_huge_pmd swap slot cleanup)
 - mprotect on a swapped PMD (change_non_present_huge_pmd)
 - UFFDIO_MOVE on a swapped PMD, including destination RWP preservation
 - mremap of a swapped PMD (move_soft_dirty_pmd)
 - pagemap reading (pagemap_pmd_range_thp softleaf_has_pfn guard)
 - mincore on a swapped PMD without faulting it in
 - MADV_FREE on a swapped PMD: verifies swap slots are freed via
   pagemap and the memory reads back as zero
 - MADV_WILLNEED on a swapped PMD
 - swapoff with active PMD swap entries, including RWP preservation

Add a pmd_swap category and ksft_pmd_swap.sh wrapper so the default mm
selftest invocation and CI execute the test. PMD_SWAP_DEVICE remains
optional for the destructive swapoff case.

When zswap is enabled, PMD-order consumers may split a PMD swap entry
and retry through the PTE path because zswap stores the range as
per-page entries. In that configuration, the tests still verify data
correctness and log that the PMD mapping assertion is skipped. With
zswap disabled, the tests assert that write faults, UFFDIO_MOVE,
MADV_WILLNEED, and swapoff restore a PMD-mapped THP where expected.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 tools/testing/selftests/mm/Makefile         |   2 +
 tools/testing/selftests/mm/ksft_pmd_swap.sh |   4 +
 tools/testing/selftests/mm/pmd_swap.c       | 874 ++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh   |   4 +
 4 files changed, 884 insertions(+)
 create mode 100755 tools/testing/selftests/mm/ksft_pmd_swap.sh
 create mode 100644 tools/testing/selftests/mm/pmd_swap.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index eae504bd94c8..25af4d7b633e 100644
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
index 000000000000..0f070b4729a8
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_pmd_swap.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t pmd_swap
diff --git a/tools/testing/selftests/mm/pmd_swap.c b/tools/testing/selftests/mm/pmd_swap.c
new file mode 100644
index 000000000000..7cf9ac074e96
--- /dev/null
+++ b/tools/testing/selftests/mm/pmd_swap.c
@@ -0,0 +1,874 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test PMD-level swap entries.
+ *
+ * Verifies that when a PMD-mapped THP is swapped out the kernel installs
+ * a single PMD-level swap entry (instead of splitting into 512 PTE-level
+ * entries), and that operations on the swapped region behave correctly:
+ *   basic         - swap out + swap in preserves data
+ *   fork          - parent and child both see the data
+ *   fork_cow      - COW after fork keeps parent's data isolated
+ *   cycles        - repeated swap out/in does not corrupt data
+ *   write         - faulting in via a write restores a PMD-mapped THP
+ *   rwp_swapin    - userfaultfd RWP survives PMD-order swap-in
+ *   munmap        - munmap on a PMD swap entry frees swap slots cleanly
+ *   mprotect      - mprotect on a PMD swap entry preserves data
+ *   mremap        - mremap on a PMD swap entry preserves data
+ *   pagemap        - pagemap reports the entries as swapped
+ *   mincore        - mincore walks a PMD swap entry without faulting it in
+ *   madvise_free   - MADV_FREE on a PMD swap entry does not crash
+ *   madvise_willneed - MADV_WILLNEED handles a PMD swap entry
+ *   uffdio_move    - UFFDIO_MOVE moves a PMD swap entry
+ *   swapoff        - swapoff handles PMD swap entries (needs PMD_SWAP_DEVICE)
+ */
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
+static bool swap_available(int pagemap_fd)
+{
+	char *p;
+	bool ret;
+
+	p = mmap(NULL, getpagesize(), PROT_READ | PROT_WRITE,
+		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (p == MAP_FAILED)
+		return false;
+
+	memset(p, 0xab, getpagesize());
+	madvise(p, getpagesize(), MADV_PAGEOUT);
+	ret = pagemap_is_swapped(pagemap_fd, p);
+	munmap(p, getpagesize());
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
+	return (unsigned char)(seed + off);
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
+static bool verify_pattern(char *buf, unsigned long size, unsigned int seed)
+{
+	unsigned long i;
+
+	for (i = 0; i < size; i++)
+		if ((unsigned char)buf[i] != pattern_byte(seed, i))
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
+/*
+ * mmap a PMD-aligned PMD-sized region, request THP, fill with a pattern,
+ * and swap it out. Verifies via the thp_swpout_pmd vmstat counter that
+ * the swap-out installed a PMD swap entry rather than splitting to PTEs.
+ */
+static char *alloc_fill_swap_thp(unsigned long pmd_size, int pagemap_fd,
+				 unsigned int seed)
+{
+	unsigned long pmd_before, pmd_after;
+	char *mem;
+
+	mem = mmap_pmd_aligned(pmd_size);
+	if (mem == MAP_FAILED)
+		return MAP_FAILED;
+
+	madvise(mem, pmd_size, MADV_HUGEPAGE);
+	fill_pattern(mem, pmd_size, seed);
+
+	pmd_before = read_vm_event("thp_swpout_pmd");
+
+	if (madvise(mem, pmd_size, MADV_PAGEOUT) ||
+	    !check_swapped(pagemap_fd, mem, pmd_size)) {
+		munmap(mem, pmd_size);
+		return MAP_FAILED;
+	}
+
+	pmd_after = read_vm_event("thp_swpout_pmd");
+	printf("# thp_swpout_pmd: %lu -> %lu\n", pmd_before, pmd_after);
+	if (pmd_after - pmd_before < 1) {
+		munmap(mem, pmd_size);
+		return MAP_FAILED;
+	}
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
+	int pagemap_fd;
+	unsigned int seed;
+	bool zswap_enabled;
+};
+
+FIXTURE_SETUP(pmd_swap)
+{
+	self->pagemap_fd = -1;
+
+	self->pmd_size = read_pmd_pagesize();
+	if (!self->pmd_size)
+		SKIP(return, "Cannot determine PMD size\n");
+
+	self->pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (self->pagemap_fd < 0)
+		SKIP(return, "Cannot open /proc/self/pagemap\n");
+
+	if (!swap_available(self->pagemap_fd))
+		SKIP(return, "Swap not available or not working\n");
+
+	self->seed = random_seed();
+	self->zswap_enabled = zswap_enabled();
+}
+
+FIXTURE_TEARDOWN(pmd_swap)
+{
+	if (self->pagemap_fd >= 0)
+		close(self->pagemap_fd);
+}
+
+/*
+ * Allocate a PMD-sized THP, write a pattern, swap it out, read it back,
+ * verify the pattern.
+ */
+TEST_F(pmd_swap, basic)
+{
+	char *mem;
+
+	mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd, self->seed);
+	if (mem == MAP_FAILED)
+		SKIP(return, "Could not create swapped THP\n");
+
+	ASSERT_TRUE(verify_pattern(mem, self->pmd_size, self->seed));
+
+	munmap(mem, self->pmd_size);
+}
+
+/*
+ * Allocate a THP, swap it out, fork, verify both parent and child see
+ * the correct data.
+ */
+TEST_F(pmd_swap, fork)
+{
+	char *mem;
+	pid_t pid;
+	int status;
+
+	mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd, self->seed);
+	if (mem == MAP_FAILED)
+		SKIP(return, "Could not create swapped THP\n");
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0)
+		_exit(verify_pattern(mem, self->pmd_size, self->seed) ? 0 : 1);
+
+	ASSERT_TRUE(verify_pattern(mem, self->pmd_size, self->seed));
+
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), 0);
+
+	munmap(mem, self->pmd_size);
+}
+
+/*
+ * Swap out, fork, then have parent and child write different patterns.
+ * Exercises COW on shared PMD swap entries: writes after fork must
+ * trigger copy-on-write so the parent's data stays isolated from the
+ * child's.  Both processes write and then verify their own pattern so
+ * the parent-side COW path is exercised too (a parent-only-read variant
+ * only proves the swap entry survived fork).
+ */
+TEST_F(pmd_swap, fork_cow)
+{
+	unsigned int parent_seed = self->seed;
+	unsigned int child_seed = ~self->seed;
+	unsigned int post_seed = self->seed ^ 0xa5a5a5a5;
+	char *mem;
+	pid_t pid;
+	int status;
+
+	mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd, parent_seed);
+	if (mem == MAP_FAILED)
+		SKIP(return, "Could not create swapped THP\n");
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		fill_pattern(mem, self->pmd_size, child_seed);
+		_exit(verify_pattern(mem, self->pmd_size, child_seed) ? 0 : 1);
+	}
+
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+
+	/* Child's writes must not leak back into the parent. */
+	ASSERT_TRUE(verify_pattern(mem, self->pmd_size, parent_seed));
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), 0);
+
+	/* Now trigger the parent-side COW and confirm the write sticks. */
+	fill_pattern(mem, self->pmd_size, post_seed);
+	ASSERT_TRUE(verify_pattern(mem, self->pmd_size, post_seed));
+
+	munmap(mem, self->pmd_size);
+}
+
+/*
+ * Swap a THP out and in repeatedly without data corruption.
+ */
+TEST_F(pmd_swap, cycles)
+{
+	const int num_cycles = 5;
+	char *mem;
+	int cycle;
+
+	for (cycle = 0; cycle < num_cycles; cycle++) {
+		unsigned int seed = self->seed + cycle;
+
+		mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd, seed);
+		if (mem == MAP_FAILED)
+			SKIP(return, "Could not create swapped THP at cycle %d\n",
+			     cycle);
+
+		ASSERT_TRUE(verify_pattern(mem, self->pmd_size, seed));
+
+		munmap(mem, self->pmd_size);
+	}
+}
+
+/*
+ * Swap out, fault in via a write to the first page, verify the write
+ * reinstates a THP mapping and the rest of the THP is preserved.
+ */
+TEST_F(pmd_swap, write)
+{
+	unsigned int seed = self->seed;
+	char *mem;
+	unsigned long i;
+
+	mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd, seed);
+	if (mem == MAP_FAILED)
+		SKIP(return, "Could not create swapped THP\n");
+
+	mem[0] = 0xbb;
+	ASSERT_EQ(mem[0], (char)0xbb);
+
+	if (self->zswap_enabled) {
+		TH_LOG("zswap is enabled, so PMD mapping is not checked");
+	} else {
+		ASSERT_TRUE(check_huge_anon(mem, 1, self->pmd_size));
+	}
+
+	for (i = 1; i < self->pmd_size; i++)
+		ASSERT_EQ((unsigned char)mem[i], pattern_byte(seed, i));
+
+	munmap(mem, self->pmd_size);
+}
+
+/* RWP protection on a swap PMD must survive PMD-order swap-in. */
+TEST_F(pmd_swap, rwp_swapin)
+{
+	unsigned int seed = self->seed;
+	char *mem;
+	int uffd;
+
+	mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd, seed);
+	if (mem == MAP_FAILED)
+		SKIP(return, "Could not create swapped THP\n");
+
+	uffd = register_rwp(mem, self->pmd_size, true);
+	if (uffd < 0) {
+		munmap(mem, self->pmd_size);
+		SKIP(return, "Userfaultfd RWP unsupported\n");
+	}
+
+	ASSERT_TRUE(expect_rwp_fault(uffd, mem, self->pmd_size,
+				     pattern_byte(seed, 0), false)) {
+		close(uffd);
+		munmap(mem, self->pmd_size);
+	}
+	ASSERT_TRUE(verify_pattern(mem, self->pmd_size, seed));
+
+	close(uffd);
+	munmap(mem, self->pmd_size);
+}
+
+/*
+ * munmap while the folio is swapped out. Exercises zap_huge_pmd() on a
+ * PMD swap entry — must free the swap slots without trying to look up
+ * a folio.
+ */
+TEST_F(pmd_swap, munmap)
+{
+	char *mem;
+
+	mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd, self->seed);
+	if (mem == MAP_FAILED)
+		SKIP(return, "Could not create swapped THP\n");
+
+	munmap(mem, self->pmd_size);
+}
+
+/*
+ * Change protection on a swapped PMD entry, then fault back in and
+ * verify data. Exercises change_non_present_huge_pmd().
+ */
+TEST_F(pmd_swap, mprotect)
+{
+	unsigned int seed = self->seed;
+	char *mem;
+
+	mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd, seed);
+	if (mem == MAP_FAILED)
+		SKIP(return, "Could not create swapped THP\n");
+
+	ASSERT_EQ(mprotect(mem, self->pmd_size, PROT_READ), 0);
+	ASSERT_EQ(mprotect(mem, self->pmd_size, PROT_READ | PROT_WRITE), 0);
+
+	ASSERT_TRUE(verify_pattern(mem, self->pmd_size, seed));
+
+	munmap(mem, self->pmd_size);
+}
+
+/*
+ * UFFDIO_MOVE a PMD swap entry from src to a registered dst. Exercises
+ * move_pages_huge_pmd() handling of pmd_is_swap_entry: the whole PMD swap
+ * entry must move to dst without splitting, and the destination must
+ * read back the original pattern after a swap-in fault.
+ */
+TEST_F(pmd_swap, uffdio_move)
+{
+	unsigned int seed = self->seed;
+	struct uffdio_register reg = {};
+	struct uffdio_move move = {};
+	struct uffdio_api api = {};
+	char *src, *dst;
+	bool rwp;
+	int uffd;
+
+	dst = mmap_pmd_aligned(self->pmd_size);
+	if (dst == MAP_FAILED)
+		SKIP(return, "Could not mmap aligned dst\n");
+
+	src = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd, seed);
+	if (src == MAP_FAILED) {
+		munmap(dst, self->pmd_size);
+		SKIP(return, "Could not create swapped THP\n");
+	}
+	if ((uintptr_t)src & (self->pmd_size - 1)) {
+		munmap(src, self->pmd_size);
+		munmap(dst, self->pmd_size);
+		SKIP(return, "src not PMD-aligned\n");
+	}
+
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (uffd < 0) {
+		munmap(src, self->pmd_size);
+		munmap(dst, self->pmd_size);
+		SKIP(return, "userfaultfd unavailable\n");
+	}
+
+	api.api = UFFD_API;
+	api.features = UFFD_FEATURE_MOVE | UFFD_FEATURE_RWP;
+	if (ioctl(uffd, UFFDIO_API, &api) ||
+	    !(api.features & UFFD_FEATURE_MOVE)) {
+		close(uffd);
+		munmap(src, self->pmd_size);
+		munmap(dst, self->pmd_size);
+		SKIP(return, "UFFD_FEATURE_MOVE unsupported\n");
+	}
+	rwp = api.features & UFFD_FEATURE_RWP;
+
+	reg.range.start = (unsigned long)dst;
+	reg.range.len = self->pmd_size;
+	reg.mode = UFFDIO_REGISTER_MODE_MISSING |
+		   (rwp ? UFFDIO_REGISTER_MODE_RWP : 0);
+	if (ioctl(uffd, UFFDIO_REGISTER, &reg)) {
+		close(uffd);
+		munmap(src, self->pmd_size);
+		munmap(dst, self->pmd_size);
+		SKIP(return, "UFFDIO_REGISTER failed\n");
+	}
+
+	move.dst = (unsigned long)dst;
+	move.src = (unsigned long)src;
+	move.len = self->pmd_size;
+	if (ioctl(uffd, UFFDIO_MOVE, &move)) {
+		int saved_errno = errno;
+
+		close(uffd);
+		munmap(src, self->pmd_size);
+		munmap(dst, self->pmd_size);
+		ASSERT_EQ(saved_errno, 0);
+	}
+	ASSERT_EQ(move.move, self->pmd_size);
+
+	/* dst inherits the PMD swap entry; reading it must restore the data. */
+	ASSERT_TRUE(check_swapped(self->pagemap_fd, dst, self->pmd_size));
+	if (rwp) {
+		ASSERT_TRUE(expect_rwp_fault(uffd, dst, self->pmd_size,
+					     pattern_byte(seed, 0), false)) {
+			close(uffd);
+			munmap(src, self->pmd_size);
+			munmap(dst, self->pmd_size);
+		}
+	}
+	ASSERT_TRUE(verify_pattern(dst, self->pmd_size, seed));
+	if (self->zswap_enabled) {
+		TH_LOG("zswap is enabled, so PMD mapping is not checked");
+	} else {
+		/* The whole-PMD path must reinstate a THP, not 512 PTE folios. */
+		ASSERT_TRUE(check_huge_anon(dst, 1, self->pmd_size));
+	}
+
+	close(uffd);
+	munmap(src, self->pmd_size);
+	munmap(dst, self->pmd_size);
+}
+
+/*
+ * Move a swapped PMD entry to a new address, fault in, verify data.
+ * Exercises move_huge_pmd() and move_soft_dirty_pmd().
+ */
+TEST_F(pmd_swap, mremap)
+{
+	unsigned int seed = self->seed;
+	char *mem, *new_mem;
+
+	mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd, seed);
+	if (mem == MAP_FAILED)
+		SKIP(return, "Could not create swapped THP\n");
+
+	new_mem = mremap(mem, self->pmd_size, self->pmd_size, MREMAP_MAYMOVE);
+	if (new_mem == MAP_FAILED) {
+		munmap(mem, self->pmd_size);
+		ASSERT_NE(new_mem, MAP_FAILED);
+	}
+
+	ASSERT_TRUE(verify_pattern(new_mem, self->pmd_size, seed));
+
+	munmap(new_mem, self->pmd_size);
+}
+
+/*
+ * Read /proc/self/pagemap on a PMD swap entry. Exercises the pagemap
+ * PMD walker which must handle PMD swap entries without trying to
+ * convert them to a page via softleaf_to_page().
+ */
+TEST_F(pmd_swap, pagemap)
+{
+	char *mem;
+	uint64_t entry;
+	unsigned long off;
+
+	mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd, self->seed);
+	if (mem == MAP_FAILED)
+		SKIP(return, "Could not create swapped THP\n");
+
+	for (off = 0; off < self->pmd_size; off += getpagesize()) {
+		entry = pagemap_get_entry(self->pagemap_fd, mem + off);
+		/* Bit 62 = swapped */
+		ASSERT_TRUE(entry & (1ULL << 62));
+	}
+
+	munmap(mem, self->pmd_size);
+}
+
+/*
+ * mincore() on a swapped-out PMD-mapped THP must handle the non-present PMD
+ * entry in place. The call must not fault the PMD back in or split the entry.
+ */
+TEST_F(pmd_swap, mincore)
+{
+	unsigned long pages = self->pmd_size / getpagesize();
+	unsigned char *vec;
+	char *mem;
+
+	mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd, self->seed);
+	if (mem == MAP_FAILED)
+		SKIP(return, "Could not create swapped THP\n");
+
+	vec = calloc(pages, sizeof(*vec));
+	ASSERT_NE(vec, NULL) {
+		munmap(mem, self->pmd_size);
+	}
+
+	ASSERT_EQ(mincore(mem, self->pmd_size, vec), 0) {
+		free(vec);
+		munmap(mem, self->pmd_size);
+	}
+	ASSERT_TRUE(check_swapped(self->pagemap_fd, mem, self->pmd_size)) {
+		free(vec);
+		munmap(mem, self->pmd_size);
+	}
+
+	free(vec);
+	munmap(mem, self->pmd_size);
+}
+
+/*
+ * MADV_FREE on a swapped-out PMD must free the swap slots and clear the
+ * entry. After the call, pagemap must no longer report the pages as
+ * swapped, and accessing the region must yield zero pages.
+ */
+TEST_F(pmd_swap, madvise_free)
+{
+	char *mem;
+	unsigned long i;
+
+	mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd, self->seed);
+	if (mem == MAP_FAILED)
+		SKIP(return, "Could not create swapped THP\n");
+
+	ASSERT_TRUE(check_swapped(self->pagemap_fd, mem, self->pmd_size));
+	ASSERT_EQ(madvise(mem, self->pmd_size, MADV_FREE), 0);
+	ASSERT_FALSE(check_swapped(self->pagemap_fd, mem, self->pmd_size));
+
+	for (i = 0; i < self->pmd_size; i += getpagesize())
+		ASSERT_EQ(mem[i], 0);
+
+	munmap(mem, self->pmd_size);
+}
+
+/*
+ * MADV_WILLNEED on a swapped-out PMD-mapped THP may schedule PMD-order
+ * swapin I/O, find the PMD-sized folio already resident in the swap cache,
+ * or split to the PTE path when zswap has per-page state for the range.
+ */
+TEST_F(pmd_swap, madvise_willneed)
+{
+	char *mem;
+
+	mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd, self->seed);
+	if (mem == MAP_FAILED)
+		SKIP(return, "Could not create swapped THP\n");
+
+	ASSERT_EQ(madvise(mem, self->pmd_size, MADV_WILLNEED), 0);
+	ASSERT_TRUE(check_swapped(self->pagemap_fd, mem, self->pmd_size));
+
+	/* First touch faults the data back in. */
+	ASSERT_TRUE(verify_pattern(mem, self->pmd_size, self->seed));
+
+	if (self->zswap_enabled)
+		TH_LOG("zswap is enabled, so PMD mapping is not checked");
+	else
+		ASSERT_TRUE(check_huge_anon(mem, 1, self->pmd_size));
+
+	munmap(mem, self->pmd_size);
+}
+
+/*
+ * swapoff requires a dedicated swap device path. Use a separate fixture
+ * that picks the device up from the PMD_SWAP_DEVICE environment variable
+ * and skips when unset.
+ */
+FIXTURE(pmd_swap_swapoff)
+{
+	unsigned long pmd_size;
+	int pagemap_fd;
+	const char *swap_dev;
+	unsigned int seed;
+	bool zswap_enabled;
+};
+
+FIXTURE_SETUP(pmd_swap_swapoff)
+{
+	self->pagemap_fd = -1;
+	self->swap_dev = getenv("PMD_SWAP_DEVICE");
+	if (!self->swap_dev)
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
+	if (!swap_available(self->pagemap_fd))
+		SKIP(return, "Swap not available or not working\n");
+
+	self->seed = random_seed();
+	self->zswap_enabled = zswap_enabled();
+}
+
+FIXTURE_TEARDOWN(pmd_swap_swapoff)
+{
+	if (self->pagemap_fd >= 0)
+		close(self->pagemap_fd);
+}
+
+/*
+ * Swap out a THP, then turn off swap. Verify data is intact. When zswap is
+ * not active, the PMD-order swapoff path should preserve the huge mapping.
+ */
+TEST_F(pmd_swap_swapoff, basic)
+{
+	unsigned int seed = self->seed;
+	char *mem;
+	int uffd, ret, err;
+
+	mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd, seed);
+	if (mem == MAP_FAILED)
+		SKIP(return, "Could not create swapped THP\n");
+	uffd = register_rwp(mem, self->pmd_size, true);
+
+	ret = swapoff(self->swap_dev);
+	err = errno;
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("swapoff(%s) failed: %s", self->swap_dev, strerror(err));
+		if (uffd >= 0)
+			close(uffd);
+		munmap(mem, self->pmd_size);
+	}
+
+	/*
+	 * Check the PMD residency before touching the memory.  If we read
+	 * first, a bug that left a PMD swap entry in place after swapoff
+	 * would silently trigger do_huge_pmd_swap_page() and reinstall a
+	 * PMD mapping, masking the regression.
+	 */
+	if (self->zswap_enabled) {
+		TH_LOG("zswap is enabled, so PMD mapping is not checked");
+	} else {
+		ASSERT_TRUE(check_huge_anon(mem, 1, self->pmd_size)) {
+			swapon(self->swap_dev, 0);
+			if (uffd >= 0)
+				close(uffd);
+			munmap(mem, self->pmd_size);
+		}
+	}
+	if (uffd >= 0) {
+		ASSERT_TRUE(expect_rwp_fault(uffd, mem, self->pmd_size,
+					     pattern_byte(seed, 0), false)) {
+			swapon(self->swap_dev, 0);
+			close(uffd);
+			munmap(mem, self->pmd_size);
+		}
+	}
+
+	ASSERT_TRUE(verify_pattern(mem, self->pmd_size, seed)) {
+		swapon(self->swap_dev, 0);
+		if (uffd >= 0)
+			close(uffd);
+		munmap(mem, self->pmd_size);
+	}
+
+	ret = swapon(self->swap_dev, 0);
+	err = errno;
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("swapon(%s) failed: %s", self->swap_dev, strerror(err));
+		if (uffd >= 0)
+			close(uffd);
+		munmap(mem, self->pmd_size);
+	}
+
+	if (uffd >= 0)
+		close(uffd);
+	munmap(mem, self->pmd_size);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 687d115e3bd8..0a860c4852f2 100755
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


