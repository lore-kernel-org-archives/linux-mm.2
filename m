Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A44D6C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 10:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB89D6B0092; Wed, 19 Aug 2026 06:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90706B009B; Wed, 19 Aug 2026 06:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6626B009D; Wed, 19 Aug 2026 06:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 826F56B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:10:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C8E1160373
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:10:48 +0000 (UTC)
X-FDA: 85117600176.09.5C40103
Received: from mta1.migadu.com (out-166.mta1.migadu.com [95.215.58.166])
	by imf31.hostedemail.com (Postfix) with ESMTP id E9BAC20003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:10:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uPzNvt7v;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.166 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787134246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NeIsA2yNbRdhRuP4co13mYUkl3pJ6JrmXQy8ZDfa+A8=;
	b=URZSI37gbQ7a5dMoGnubAf2pPfQZo6gEwARut3mLf+QmopXnz0qo4G4rlLse2V1niMdKNk
	kf35lFuwhAqjBDT1KqGbH03UyVaac4TdcWOqUlO8xlWxxRHIb955zUHwqJ7LJslP9Z73VP
	P1MWIohTwA08VjQ/MGbhDbN+DJE+HLI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uPzNvt7v;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.166 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787134246;
	b=FobAp/n0yvL1pL5yC8xP4cSSchsaebqxZzTJhSi9CGE7YEBbGJkBovocj5fb4SHlqiunL1
	wSOC6hngHfJybwmzCdng9VfAtQd26/XqHrgTpAmzeZlUYIXTEDYDZkY4p9rUqJi781twiJ
	5Z6RA9ebsT4kTpHlMrIR6SD0CL7U6hI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HcEOAeEv9nvGtSws/ZJ3EoQJep/fNYtfBTApIagdX20=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787134244; v=1; x=1787739044;
 b=uPzNvt7v9zpEa1hARSKzhVtdzHGlG7PaGkn8jyYgq0zLJW83w5Ju8wASotCv4qz7nlw6BSn2
 vSkwbts3rKg8Fyhxmzz6qAGk3Xutc6TxXkwCXgfM/YM+0+eUpOrIGlb8PyeQmfi3PXZey4hXa6L
 G0QMUxe3TLfL1ozpxOqN7eSg=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 42eb13369127e64b;
	Wed, 19 Aug 2026 10:10:44 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: usama.arif@linux.dev
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	baoquan.he@linux.dev,
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
	nico.pache@linux.dev,
	liam@infradead.org,
	ryan.roberts@arm.com,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	kernel-team@meta.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v6 12/12] selftests/mm: add PMD swap entry tests
Date: Wed, 19 Aug 2026 18:10:33 +0800
Message-Id: <20260819101033.48064-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260818131202.494754-13-usama.arif@linux.dev>
References: <20260818131202.494754-13-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E9BAC20003
X-Stat-Signature: 1dmahxbd1iew7xkydiof1ckt7bbxqibf
X-Rspam-User: 
X-HE-Tag: 1787134245-451530
X-HE-Meta: U2FsdGVkX1+kMOtaq487stqS73IykUY/iMoDUmbmea/faiE/+DsgyhiVNCuP/ONQ40aKjkFs4/y9O/Q/d7NBchBc7R28xjE9Y3eiPSAaobUspAv/rMUgAqK3RRp0pwPsRK2Ybibx6bLOrW5ZK4g9KrqAV2Br7aNDlITZ4nYTZNSYOXbZyFs4QXnvOgNju3zp6ltU3pVgguj0iOIxo46VbAz/BfakSc7Dgjrdyy3YJFQrx9ujUU3ITdOPdgFgfCEehRBjoe8D4j5TrSnTrRI0OW18xhooma+awoRxoWD/1HY714NNRTt8gCsxQANj7/7eTdndV5JcX5SJnojUFVS7jNzl9jebKGYTW3NnZD2ev+t/sY1ucJkiJuKrayTCPVfmLaWdcLE7D7q7kstwNzMimQkrtbce+jgHeR01DL9NaXi7bJIxmX9zu/TD9ZqN+EXN9soof0kq1DrswIKcLZlr5jukNGziQtw2ayg/+TT5p+fsM9reHL5MhMiFG+zlzm3p2Ojll7oMa4T+29f6MnFiQ7kGyQZTaamEQwNCQjS3pSE1HjQvymjFXaAZ+AYur8DlSyexr4BHUJTED4f1IxKV+kZTJhaPa0fkzYpJRMWcQYdVb9DkrYp5ny1HLKsettN2t4SVhqiUN+cOvnl4dPkPXEGL7xVKR73p6kQcGvT8d/AAjdYakThtWTWnJI/U6bmOr98tyOQ3SFGPmYTq8wxfmnxzkDJRZQ4a92SflB9fTtH6MXv706JEDJsPibGzuUDwG/81gSwyrhXWThW+qU4RJCpzLv7oZLzQZlDUCQYOuaBzP9tHAMWmsr+qs4b2itj9a+qxVJ2mCjuFhwnvIsyxDTSivXk/uaQepIwSm3DGGV3zLamuGydwh+lHqM5iM1ELP5XqEPE4pFois77Us15jDY6irxmYA74RnhZKPtmud/+Amcc18K5BzyT99A1QPuAKkpbzBw2V2uIYGl6DcK+
 Xs0sD+1M
 vDWd5Oqqm/d4F+WM4aBMYX/FSaVlL9WNOUmaB7tLxVvJRaqbdA4Qj7JiSfc2Du0GJlb+FyuKbBKRiCZAww0Bl+04rDK855EsMy80XI80AJlJyJKdkmxd3IDLx4fPEBDXTNavbRwtLpYYif93n+xweAu7BfR6OC9pEZuDhjRf3j5s0QPDmqKCc57dOnn+49Cl9GLDmwcKTJPHLDaONAIetLhlSGcdaAz7ZCwAxqfCCoI4V+cH/HMcv1/Ixh9B74Ig4YrZLyUx/dBy2rNKWw3zwQ19gKqUgmYPLVLlj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Aug 18, 2026 at 06:09:53AM -0700, Usama Arif wrote:
>Exercise the PMD swap entry paths.  Each test gets a fresh PMD-mapped
>THP from fixture setup, fills it with a page-distinct pattern, swaps it
>out with MADV_PAGEOUT, and verifies that thp_swpout_pmd increased.
>
>The tests are:
>
>  - basic: fault in a swapped PMD and verify its contents.
>  - fork: verify parent and child can fault in the shared swap entry.
>  - fork_cow: verify parent and child writes remain isolated.
>  - write: fault in by writing one byte and preserve the rest of the THP.
>  - rwp_swapin: verify userfaultfd RWP survives PMD-order swap-in.
>  - munmap: unmap the full entry and check that VmSwap drops.
>  - mprotect: change full-range protections without faulting the entry in.
>  - split_mprotect: change half-range protections and verify the data.
>  - split_munmap: unmap half, drop its accounting, and preserve the rest.
>  - uffdio_move: move the entry and RWP state, then fault it in at dst.
>  - mremap: force the entry to a new aligned address and verify the data.
>  - pagemap: verify swapped bits and consecutive swap-slot offsets.
>  - mincore: walk the entry without faulting it in.
>  - madvise_free: release the slots, clear the entry, and verify zeroes.
>  - madvise_willneed: prefetch the entry and verify subsequent swap-in.
>  - swapoff: unuse the entry and preserve data and PMD/RWP state.
>
>Fixture teardown owns the mappings and file descriptors and restores
>swap after assertion failures.  PMD_SWAP_DEVICE remains optional for
>swapoff.

How do we know the PMD swap entry is on PMD_SWAP_DEVICE?

Assume another higher-priority swap device is active. MADV_PAGEOUT may
place the entry there, so swapoff() operates on the wrong device. This
can make the test pass with zswap enabled and fail with it disabled.

Should PMD_SWAP_DEVICE be required to be the only active swap device?

Cheers, Lance

>
>Distinguish an environment that cannot allocate a PMD THP from a failure
>to install a PMD swap entry, so the former skips while the latter fails.
>Also check VmSwap accounting, pagemap slot offsets, swapped state after
>non-faulting operations, and PMD restoration when zswap does not require
>PTE fallback.
>
>Register the test with run_vmtests.sh and the default kselftest runner.
>
>Signed-off-by: Usama Arif <usama.arif@linux.dev>
>---
> tools/testing/selftests/mm/Makefile         |   2 +
> tools/testing/selftests/mm/ksft_pmd_swap.sh |   4 +
> tools/testing/selftests/mm/pmd_swap.c       | 742 ++++++++++++++++++++
> tools/testing/selftests/mm/run_vmtests.sh   |   4 +
> 4 files changed, 752 insertions(+)
> create mode 100755 tools/testing/selftests/mm/ksft_pmd_swap.sh
> create mode 100644 tools/testing/selftests/mm/pmd_swap.c
>
>diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
>index 2d5366196e309..dafa3a482451d 100644
>--- a/tools/testing/selftests/mm/Makefile
>+++ b/tools/testing/selftests/mm/Makefile
>@@ -104,6 +104,7 @@ TEST_GEN_FILES += guard-regions
> TEST_GEN_FILES += merge
> TEST_GEN_FILES += rmap
> TEST_GEN_FILES += folio_split_race_test
>+TEST_GEN_FILES += pmd_swap
> 
> ifneq ($(ARCH),arm64)
> TEST_GEN_FILES += soft-dirty
>@@ -165,6 +166,7 @@ TEST_PROGS += ksft_mremap.sh
> TEST_PROGS += ksft_pagemap.sh
> TEST_PROGS += ksft_pfnmap.sh
> TEST_PROGS += ksft_pkey.sh
>+TEST_PROGS += ksft_pmd_swap.sh
> TEST_PROGS += ksft_process_madv.sh
> TEST_PROGS += ksft_process_mrelease.sh
> TEST_PROGS += ksft_rmap.sh
>diff --git a/tools/testing/selftests/mm/ksft_pmd_swap.sh b/tools/testing/selftests/mm/ksft_pmd_swap.sh
>new file mode 100755
>index 0000000000000..0f070b4729a89
>--- /dev/null
>+++ b/tools/testing/selftests/mm/ksft_pmd_swap.sh
>@@ -0,0 +1,4 @@
>+#!/bin/sh -e
>+# SPDX-License-Identifier: GPL-2.0
>+
>+./run_vmtests.sh -t pmd_swap
>diff --git a/tools/testing/selftests/mm/pmd_swap.c b/tools/testing/selftests/mm/pmd_swap.c
>new file mode 100644
>index 0000000000000..30911ef6480f3
>--- /dev/null
>+++ b/tools/testing/selftests/mm/pmd_swap.c
>@@ -0,0 +1,742 @@
>+// SPDX-License-Identifier: GPL-2.0
>+/* Test PMD-level swap entries and their users. */
>+#define _GNU_SOURCE
>+#include <stdio.h>
>+#include <stdlib.h>
>+#include <string.h>
>+#include <unistd.h>
>+#include <sys/mman.h>
>+#include <sys/wait.h>
>+#include <fcntl.h>
>+#include <errno.h>
>+#include <stdint.h>
>+#include <sys/random.h>
>+#include <sys/swap.h>
>+#include <sys/syscall.h>
>+#include <sys/ioctl.h>
>+#include <poll.h>
>+#include <pthread.h>
>+#include <linux/userfaultfd.h>
>+#include <time.h>
>+
>+#include "kselftest_harness.h"
>+#include "vm_util.h"
>+
>+#define ZSWAP_ENABLED_PATH "/sys/module/zswap/parameters/enabled"
>+
>+/* pagemap: bits 0-54 hold the PFN, or type|offset for a swap entry. */
>+#define PM_PFRAME_MASK		((1ULL << 55) - 1)
>+/* Must match MAX_SWAPFILES_SHIFT in include/linux/swap.h. */
>+#define MAX_SWAPFILES_SHIFT	5
>+
>+static bool check_swapped(int pagemap_fd, char *addr, unsigned long size)
>+{
>+	unsigned long off;
>+
>+	for (off = 0; off < size; off += getpagesize())
>+		if (!pagemap_is_swapped(pagemap_fd, addr + off))
>+			return false;
>+	return true;
>+}
>+
>+static bool zswap_enabled(void)
>+{
>+	char enabled = 0;
>+	FILE *f;
>+
>+	f = fopen(ZSWAP_ENABLED_PATH, "r");
>+	if (!f)
>+		return false;
>+
>+	if (fscanf(f, " %c", &enabled) != 1)
>+		enabled = 0;
>+	fclose(f);
>+
>+	return enabled == 'Y' || enabled == 'y' || enabled == '1';
>+}
>+
>+static bool swap_available(unsigned long required_bytes)
>+{
>+	unsigned long required_kb = (required_bytes + 1023) / 1024;
>+	unsigned long size_kb, used_kb;
>+	char line[256];
>+	bool ret = false;
>+	FILE *f;
>+
>+	f = fopen("/proc/swaps", "r");
>+	if (!f)
>+		return false;
>+
>+	/* Skip the header. */
>+	if (!fgets(line, sizeof(line), f))
>+		goto out;
>+
>+	while (fgets(line, sizeof(line), f)) {
>+		if (sscanf(line, "%*s %*s %lu %lu", &size_kb, &used_kb) == 2 &&
>+		    size_kb >= used_kb && size_kb - used_kb >= required_kb) {
>+			ret = true;
>+			break;
>+		}
>+	}
>+
>+out:
>+	fclose(f);
>+	return ret;
>+}
>+
>+static unsigned long read_vm_event(const char *name)
>+{
>+	char line[256];
>+	size_t name_len = strlen(name);
>+	unsigned long val = 0;
>+	FILE *f;
>+
>+	f = fopen("/proc/vmstat", "r");
>+	if (!f)
>+		return 0;
>+	while (fgets(line, sizeof(line), f)) {
>+		if (!strncmp(line, name, name_len) && line[name_len] == ' ') {
>+			val = strtoul(line + name_len + 1, NULL, 10);
>+			break;
>+		}
>+	}
>+	fclose(f);
>+	return val;
>+}
>+
>+static unsigned int random_seed(void)
>+{
>+	unsigned int seed;
>+
>+	if (getrandom(&seed, sizeof(seed), 0) != sizeof(seed))
>+		seed = (unsigned int)time(NULL);
>+	return seed;
>+}
>+
>+static unsigned char pattern_byte(unsigned int seed, unsigned long off)
>+{
>+	return (unsigned char)(seed + off + (off >> 8) + (off >> 16));
>+}
>+
>+static void fill_pattern(char *buf, unsigned long size, unsigned int seed)
>+{
>+	unsigned long i;
>+
>+	for (i = 0; i < size; i++)
>+		buf[i] = (char)pattern_byte(seed, i);
>+}
>+
>+static bool verify_pattern_range(char *buf, unsigned long size,
>+				 unsigned int seed, unsigned long offset)
>+{
>+	unsigned long i;
>+
>+	for (i = 0; i < size; i++)
>+		if ((unsigned char)buf[i] != pattern_byte(seed, offset + i))
>+			return false;
>+	return true;
>+}
>+
>+static bool verify_pattern(char *buf, unsigned long size, unsigned int seed)
>+{
>+	return verify_pattern_range(buf, size, seed, 0);
>+}
>+
>+static bool verify_zero(char *buf, unsigned long size)
>+{
>+	unsigned long i;
>+
>+	for (i = 0; i < size; i++)
>+		if (buf[i])
>+			return false;
>+	return true;
>+}
>+
>+/*
>+ * mmap an anonymous PMD-aligned region of pmd_size bytes. Over-allocates
>+ * by one PMD and trims the unaligned head/tail so the returned address is
>+ * PMD-aligned (required for whole-PMD UFFDIO_MOVE).
>+ */
>+static char *mmap_pmd_aligned(unsigned long pmd_size)
>+{
>+	unsigned long pad = pmd_size;
>+	char *raw, *aligned;
>+
>+	raw = mmap(NULL, pmd_size + pad, PROT_READ | PROT_WRITE,
>+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>+	if (raw == MAP_FAILED)
>+		return MAP_FAILED;
>+
>+	aligned = (char *)(((uintptr_t)raw + pmd_size - 1) & ~(pmd_size - 1));
>+	if (aligned != raw)
>+		munmap(raw, aligned - raw);
>+	if (aligned + pmd_size != raw + pmd_size + pad)
>+		munmap(aligned + pmd_size,
>+		       (raw + pmd_size + pad) - (aligned + pmd_size));
>+	return aligned;
>+}
>+
>+enum swap_thp_result {
>+	SWAP_THP_OK,
>+	SWAP_THP_UNAVAILABLE,
>+	SWAP_THP_FAILED,
>+};
>+
>+/* Per-process swapped size in bytes, from /proc/self/status VmSwap. */
>+static unsigned long read_vmswap(void)
>+{
>+	char line[256];
>+	unsigned long kb = 0;
>+	FILE *f;
>+
>+	f = fopen("/proc/self/status", "r");
>+	if (!f)
>+		return 0;
>+	while (fgets(line, sizeof(line), f)) {
>+		if (!strncmp(line, "VmSwap:", 7)) {
>+			kb = strtoul(line + 7, NULL, 10);
>+			break;
>+		}
>+	}
>+	fclose(f);
>+	return kb * 1024;
>+}
>+
>+static bool swap_out_pmd(char *mem, unsigned long pmd_size, int pagemap_fd)
>+{
>+	unsigned long before = read_vm_event("thp_swpout_pmd");
>+	unsigned long after;
>+
>+	if (madvise(mem, pmd_size, MADV_PAGEOUT)) {
>+		ksft_print_msg("MADV_PAGEOUT failed: %s\n", strerror(errno));
>+		return false;
>+	}
>+	if (!check_swapped(pagemap_fd, mem, pmd_size)) {
>+		ksft_print_msg("MADV_PAGEOUT did not swap the whole PMD range\n");
>+		return false;
>+	}
>+
>+	after = read_vm_event("thp_swpout_pmd");
>+	ksft_print_msg("thp_swpout_pmd: %lu -> %lu\n", before, after);
>+	return after > before;
>+}
>+
>+static char *alloc_fill_swap_thp(unsigned long pmd_size, int pagemap_fd,
>+				 unsigned int seed, enum swap_thp_result *res)
>+{
>+	char *mem;
>+
>+	*res = SWAP_THP_UNAVAILABLE;
>+
>+	mem = mmap_pmd_aligned(pmd_size);
>+	if (mem == MAP_FAILED)
>+		return MAP_FAILED;
>+
>+	if (madvise(mem, pmd_size, MADV_HUGEPAGE)) {
>+		ksft_print_msg("MADV_HUGEPAGE failed: %s\n", strerror(errno));
>+		munmap(mem, pmd_size);
>+		return MAP_FAILED;
>+	}
>+	fill_pattern(mem, pmd_size, seed);
>+
>+	if (!check_huge_anon(mem, pmd_size, 1, pmd_size)) {
>+		munmap(mem, pmd_size);
>+		return MAP_FAILED;
>+	}
>+	*res = SWAP_THP_FAILED;
>+
>+	if (!swap_out_pmd(mem, pmd_size, pagemap_fd)) {
>+		munmap(mem, pmd_size);
>+		return MAP_FAILED;
>+	}
>+
>+	*res = SWAP_THP_OK;
>+	return mem;
>+}
>+
>+struct rwp_access_args {
>+	unsigned char *addr;
>+	unsigned char expected;
>+	bool write;
>+	bool ok;
>+};
>+
>+static void *rwp_access_thread(void *data)
>+{
>+	struct rwp_access_args *args = data;
>+
>+	if (args->write)
>+		*args->addr = args->expected;
>+	args->ok = *args->addr == args->expected;
>+	return NULL;
>+}
>+
>+static int register_rwp(char *addr, unsigned long size, bool protect)
>+{
>+	struct uffdio_register reg = {};
>+	struct uffdio_rwprotect rwp = {};
>+	struct uffdio_api api = {};
>+	int uffd;
>+
>+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
>+	if (uffd < 0)
>+		return -1;
>+
>+	api.api = UFFD_API;
>+	api.features = UFFD_FEATURE_RWP;
>+	if (ioctl(uffd, UFFDIO_API, &api) ||
>+	    !(api.features & UFFD_FEATURE_RWP))
>+		goto error;
>+
>+	reg.range.start = (unsigned long)addr;
>+	reg.range.len = size;
>+	reg.mode = UFFDIO_REGISTER_MODE_RWP;
>+	if (ioctl(uffd, UFFDIO_REGISTER, &reg))
>+		goto error;
>+
>+	if (!protect)
>+		return uffd;
>+
>+	rwp.range.start = (unsigned long)addr;
>+	rwp.range.len = size;
>+	rwp.mode = UFFDIO_RWPROTECT_MODE_RWP;
>+	if (!ioctl(uffd, UFFDIO_RWPROTECT, &rwp))
>+		return uffd;
>+
>+error:
>+	close(uffd);
>+	return -1;
>+}
>+
>+static bool expect_rwp_fault(int uffd, char *addr, unsigned long size,
>+			     unsigned char expected, bool write)
>+{
>+	struct rwp_access_args args = {
>+		.addr = (unsigned char *)addr,
>+		.expected = expected,
>+		.write = write,
>+	};
>+	struct uffdio_rwprotect rwp = {
>+		.range = {
>+			.start = (unsigned long)addr,
>+			.len = size,
>+		},
>+	};
>+	struct pollfd pollfd = {
>+		.fd = uffd,
>+		.events = POLLIN,
>+	};
>+	struct uffd_msg msg = {};
>+	pthread_t thread;
>+	bool saw_rwp = false;
>+	int ret;
>+
>+	if (pthread_create(&thread, NULL, rwp_access_thread, &args))
>+		return false;
>+
>+	ret = poll(&pollfd, 1, 5000);
>+	if (ret == 1 && (pollfd.revents & POLLIN) &&
>+	    read(uffd, &msg, sizeof(msg)) == (ssize_t)sizeof(msg)) {
>+		saw_rwp = msg.event == UFFD_EVENT_PAGEFAULT &&
>+			  (msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_RWP);
>+	}
>+
>+	/* Resolve the access even on failure so the worker cannot remain blocked. */
>+	ioctl(uffd, UFFDIO_RWPROTECT, &rwp);
>+	if (pthread_join(thread, NULL))
>+		return false;
>+	return saw_rwp && args.ok;
>+}
>+
>+FIXTURE(pmd_swap)
>+{
>+	unsigned long pmd_size;
>+	unsigned long mem_len;
>+	int pagemap_fd;
>+	int uffd;
>+	unsigned int seed;
>+	bool zswap_enabled;
>+	bool swap_disabled;
>+	const char *swap_dev;
>+	char *mem;
>+	char *aux;
>+};
>+
>+FIXTURE_SETUP(pmd_swap)
>+{
>+	enum swap_thp_result res;
>+
>+	self->pagemap_fd = -1;
>+	self->uffd = -1;
>+	self->mem = MAP_FAILED;
>+	self->aux = MAP_FAILED;
>+	self->mem_len = 0;
>+	self->swap_disabled = false;
>+	self->swap_dev = getenv("PMD_SWAP_DEVICE");
>+	if (!strcmp(_metadata->name, "swapoff") && !self->swap_dev)
>+		SKIP(return, "PMD_SWAP_DEVICE env var not set\n");
>+
>+	self->pmd_size = read_pmd_pagesize();
>+	if (!self->pmd_size)
>+		SKIP(return, "Cannot determine PMD size\n");
>+
>+	self->pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
>+	if (self->pagemap_fd < 0)
>+		SKIP(return, "Cannot open /proc/self/pagemap\n");
>+
>+	if (!swap_available(self->pmd_size))
>+		SKIP(return, "No active swap device has enough free space\n");
>+
>+	self->seed = random_seed();
>+	self->zswap_enabled = zswap_enabled();
>+	self->mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd,
>+					self->seed, &res);
>+	if (self->mem == MAP_FAILED) {
>+		ASSERT_NE(res, SWAP_THP_FAILED);
>+		SKIP(return, "Could not create swapped THP\n");
>+	}
>+	self->mem_len = self->pmd_size;
>+}
>+
>+FIXTURE_TEARDOWN(pmd_swap)
>+{
>+	int swap_err = 0;
>+	int swap_ret = 0;
>+
>+	if (self->swap_disabled) {
>+		swap_ret = swapon(self->swap_dev, 0);
>+		swap_err = errno;
>+	}
>+	if (self->uffd >= 0)
>+		close(self->uffd);
>+	if (self->aux != MAP_FAILED)
>+		munmap(self->aux, self->pmd_size);
>+	if (self->mem != MAP_FAILED)
>+		munmap(self->mem, self->mem_len);
>+	if (self->pagemap_fd >= 0)
>+		close(self->pagemap_fd);
>+
>+	EXPECT_EQ(swap_ret, 0) {
>+		TH_LOG("swapon(%s) failed: %s", self->swap_dev,
>+		       strerror(swap_err));
>+	}
>+}
>+
>+TEST_F(pmd_swap, basic)
>+{
>+	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
>+}
>+
>+TEST_F(pmd_swap, fork)
>+{
>+	pid_t pid;
>+	int status;
>+
>+	pid = fork();
>+	ASSERT_GE(pid, 0);
>+
>+	if (pid == 0)
>+		_exit(verify_pattern(self->mem, self->pmd_size,
>+				     self->seed) ? 0 : 1);
>+
>+	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
>+
>+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
>+	ASSERT_TRUE(WIFEXITED(status));
>+	ASSERT_EQ(WEXITSTATUS(status), 0);
>+}
>+
>+TEST_F(pmd_swap, fork_cow)
>+{
>+	unsigned int parent_seed = self->seed;
>+	unsigned int child_seed = ~self->seed;
>+	unsigned int new_seed = self->seed ^ 0xa5a5a5a5;
>+	int release_child[2];
>+	bool parent_ok;
>+	char c = 0;
>+	pid_t pid;
>+	int status, ret;
>+
>+	ASSERT_EQ(pipe(release_child), 0);
>+
>+	pid = fork();
>+	ASSERT_GE(pid, 0);
>+
>+	if (pid == 0) {
>+		close(release_child[1]);
>+		if (read(release_child[0], &c, 1) != 1)
>+			_exit(1);
>+		if (!verify_pattern(self->mem, self->pmd_size, parent_seed))
>+			_exit(2);
>+		fill_pattern(self->mem, self->pmd_size, child_seed);
>+		if (!verify_pattern(self->mem, self->pmd_size, child_seed))
>+			_exit(3);
>+		_exit(0);
>+	}
>+
>+	close(release_child[0]);
>+	fill_pattern(self->mem, self->pmd_size, new_seed);
>+	parent_ok = verify_pattern(self->mem, self->pmd_size, new_seed);
>+	ret = write(release_child[1], &c, 1);
>+	close(release_child[1]);
>+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
>+	ASSERT_EQ(ret, 1);
>+	ASSERT_TRUE(parent_ok);
>+	ASSERT_TRUE(WIFEXITED(status));
>+	ASSERT_EQ(WEXITSTATUS(status), 0);
>+	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, new_seed));
>+}
>+
>+TEST_F(pmd_swap, write)
>+{
>+	self->mem[0] = 0xbb;
>+	ASSERT_EQ(self->mem[0], (char)0xbb);
>+	ASSERT_TRUE(verify_pattern_range(self->mem + 1, self->pmd_size - 1,
>+					 self->seed, 1));
>+	if (!self->zswap_enabled)
>+		ASSERT_TRUE(check_huge_anon(self->mem, self->pmd_size, 1,
>+					    self->pmd_size));
>+}
>+
>+TEST_F(pmd_swap, rwp_swapin)
>+{
>+	self->uffd = register_rwp(self->mem, self->pmd_size, true);
>+	if (self->uffd < 0)
>+		SKIP(return, "Userfaultfd RWP unsupported\n");
>+
>+	ASSERT_TRUE(expect_rwp_fault(self->uffd, self->mem, self->pmd_size,
>+				     pattern_byte(self->seed, 0), false));
>+	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
>+}
>+
>+TEST_F(pmd_swap, munmap)
>+{
>+	unsigned long swap_before, swap_after;
>+	int ret;
>+
>+	swap_before = read_vmswap();
>+	ASSERT_GE(swap_before, self->pmd_size);
>+
>+	ret = munmap(self->mem, self->pmd_size);
>+	if (!ret) {
>+		self->mem = MAP_FAILED;
>+		self->mem_len = 0;
>+	}
>+	ASSERT_EQ(ret, 0);
>+
>+	swap_after = read_vmswap();
>+	ASSERT_LE(swap_after, swap_before - self->pmd_size);
>+}
>+
>+TEST_F(pmd_swap, mprotect)
>+{
>+	ASSERT_EQ(mprotect(self->mem, self->pmd_size, PROT_READ), 0);
>+	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
>+				  self->pmd_size));
>+	ASSERT_EQ(mprotect(self->mem, self->pmd_size,
>+			   PROT_READ | PROT_WRITE), 0);
>+	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
>+				  self->pmd_size));
>+	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
>+}
>+
>+TEST_F(pmd_swap, split_mprotect)
>+{
>+	unsigned long half = self->pmd_size / 2;
>+
>+	ASSERT_EQ(mprotect(self->mem, half, PROT_READ), 0);
>+	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
>+				  self->pmd_size));
>+	ASSERT_EQ(mprotect(self->mem, half, PROT_READ | PROT_WRITE), 0);
>+	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
>+}
>+
>+TEST_F(pmd_swap, split_munmap)
>+{
>+	unsigned long half = self->pmd_size / 2;
>+	unsigned long swap_before = read_vmswap();
>+	unsigned long i;
>+	char *base = self->mem;
>+	int ret;
>+
>+	ASSERT_GE(swap_before, half);
>+	ret = munmap(base, half);
>+	if (!ret) {
>+		self->mem = base + half;
>+		self->mem_len = half;
>+	}
>+	ASSERT_EQ(ret, 0);
>+	ASSERT_LE(read_vmswap(), swap_before - half);
>+
>+	for (i = 0; i < half; i += getpagesize())
>+		ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd,
>+					       self->mem + i));
>+	ASSERT_TRUE(verify_pattern_range(self->mem, half, self->seed, half));
>+}
>+
>+TEST_F(pmd_swap, uffdio_move)
>+{
>+	struct uffdio_register reg = {};
>+	struct uffdio_move move = {};
>+	struct uffdio_api api = {};
>+	bool rwp;
>+
>+	self->aux = mmap_pmd_aligned(self->pmd_size);
>+	if (self->aux == MAP_FAILED)
>+		SKIP(return, "Could not mmap aligned dst\n");
>+	ASSERT_EQ(madvise(self->aux, self->pmd_size, MADV_HUGEPAGE), 0);
>+
>+	self->uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
>+	if (self->uffd < 0)
>+		SKIP(return, "userfaultfd unavailable\n");
>+
>+	api.api = UFFD_API;
>+	api.features = UFFD_FEATURE_MOVE | UFFD_FEATURE_RWP;
>+	if (ioctl(self->uffd, UFFDIO_API, &api) ||
>+	    !(api.features & UFFD_FEATURE_MOVE))
>+		SKIP(return, "UFFD_FEATURE_MOVE unsupported\n");
>+	rwp = api.features & UFFD_FEATURE_RWP;
>+
>+	reg.range.start = (unsigned long)self->aux;
>+	reg.range.len = self->pmd_size;
>+	reg.mode = UFFDIO_REGISTER_MODE_MISSING |
>+		   (rwp ? UFFDIO_REGISTER_MODE_RWP : 0);
>+	ASSERT_EQ(ioctl(self->uffd, UFFDIO_REGISTER, &reg), 0);
>+
>+	move.dst = (unsigned long)self->aux;
>+	move.src = (unsigned long)self->mem;
>+	move.len = self->pmd_size;
>+	ASSERT_EQ(ioctl(self->uffd, UFFDIO_MOVE, &move), 0);
>+	ASSERT_EQ(move.move, self->pmd_size);
>+
>+	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->aux,
>+				  self->pmd_size));
>+	if (rwp)
>+		ASSERT_TRUE(expect_rwp_fault(self->uffd, self->aux,
>+					     self->pmd_size,
>+					     pattern_byte(self->seed, 0), false));
>+	ASSERT_TRUE(verify_pattern(self->aux, self->pmd_size, self->seed));
>+	if (!self->zswap_enabled)
>+		ASSERT_TRUE(check_huge_anon(self->aux, self->pmd_size, 1,
>+					    self->pmd_size));
>+}
>+
>+TEST_F(pmd_swap, mremap)
>+{
>+	char *new_mem, *dst;
>+
>+	self->aux = mmap_pmd_aligned(self->pmd_size);
>+	if (self->aux == MAP_FAILED)
>+		SKIP(return, "Could not mmap aligned dst\n");
>+	dst = self->aux;
>+
>+	new_mem = mremap(self->mem, self->pmd_size, self->pmd_size,
>+			 MREMAP_MAYMOVE | MREMAP_FIXED, dst);
>+	if (new_mem != MAP_FAILED) {
>+		self->mem = new_mem;
>+		self->aux = MAP_FAILED;
>+	}
>+	ASSERT_NE(new_mem, MAP_FAILED);
>+	ASSERT_EQ(new_mem, dst);
>+
>+	ASSERT_TRUE(check_swapped(self->pagemap_fd, new_mem, self->pmd_size));
>+	ASSERT_TRUE(verify_pattern(new_mem, self->pmd_size, self->seed));
>+}
>+
>+TEST_F(pmd_swap, pagemap)
>+{
>+	uint64_t entry, first = 0;
>+	unsigned long off;
>+
>+	for (off = 0; off < self->pmd_size; off += getpagesize()) {
>+		entry = pagemap_get_entry(self->pagemap_fd, self->mem + off);
>+		ASSERT_TRUE(entry & (1ULL << 62));
>+		ASSERT_FALSE(entry & (1ULL << 63));
>+
>+		if (entry & PM_PFRAME_MASK) {
>+			uint64_t idx = off / getpagesize();
>+
>+			if (!off)
>+				first = entry & PM_PFRAME_MASK;
>+			ASSERT_EQ(entry & PM_PFRAME_MASK,
>+				  first + (idx << MAX_SWAPFILES_SHIFT));
>+		}
>+	}
>+}
>+
>+TEST_F(pmd_swap, mincore)
>+{
>+	unsigned long pages = self->pmd_size / getpagesize();
>+	unsigned char vec[pages];
>+
>+	ASSERT_EQ(mincore(self->mem, self->pmd_size, vec), 0);
>+	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
>+				  self->pmd_size));
>+}
>+
>+TEST_F(pmd_swap, madvise_free)
>+{
>+	unsigned long swap_before = read_vmswap();
>+	unsigned long i;
>+
>+	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
>+				  self->pmd_size));
>+	ASSERT_GE(swap_before, self->pmd_size);
>+	ASSERT_EQ(madvise(self->mem, self->pmd_size, MADV_FREE), 0);
>+	for (i = 0; i < self->pmd_size; i += getpagesize())
>+		ASSERT_FALSE(pagemap_is_swapped(self->pagemap_fd,
>+						self->mem + i));
>+	ASSERT_LE(read_vmswap(), swap_before - self->pmd_size);
>+	ASSERT_TRUE(verify_zero(self->mem, self->pmd_size));
>+}
>+
>+TEST_F(pmd_swap, madvise_willneed)
>+{
>+	ASSERT_EQ(madvise(self->mem, self->pmd_size, MADV_WILLNEED), 0);
>+	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
>+				  self->pmd_size));
>+	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
>+	if (!self->zswap_enabled)
>+		ASSERT_TRUE(check_huge_anon(self->mem, self->pmd_size, 1,
>+					    self->pmd_size));
>+}
>+
>+TEST_F(pmd_swap, swapoff)
>+{
>+	int ret, err;
>+
>+	self->uffd = register_rwp(self->mem, self->pmd_size, true);
>+
>+	ret = swapoff(self->swap_dev);
>+	err = errno;
>+	if (!ret)
>+		self->swap_disabled = true;
>+	ASSERT_EQ(ret, 0) {
>+		TH_LOG("swapoff(%s) failed: %s", self->swap_dev, strerror(err));
>+	}
>+
>+	/*
>+	 * Check residency before touching the memory. If we read
>+	 * first, a bug that left a PMD swap entry in place after swapoff
>+	 * would silently trigger do_huge_pmd_swap_page() and reinstall a
>+	 * PMD mapping, masking the regression.
>+	 */
>+	if (!self->zswap_enabled)
>+		ASSERT_TRUE(check_huge_anon(self->mem, self->pmd_size, 1,
>+					    self->pmd_size));
>+	if (self->uffd >= 0)
>+		ASSERT_TRUE(expect_rwp_fault(self->uffd, self->mem,
>+					     self->pmd_size,
>+					     pattern_byte(self->seed, 0), false));
>+	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
>+
>+	ret = swapon(self->swap_dev, 0);
>+	err = errno;
>+	if (!ret)
>+		self->swap_disabled = false;
>+	ASSERT_EQ(ret, 0) {
>+		TH_LOG("swapon(%s) failed: %s", self->swap_dev, strerror(err));
>+	}
>+}
>+
>+TEST_HARNESS_MAIN
>diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
>index d09f9f6a384ee..ff53ff28c0042 100755
>--- a/tools/testing/selftests/mm/run_vmtests.sh
>+++ b/tools/testing/selftests/mm/run_vmtests.sh
>@@ -69,6 +69,8 @@ separated by spaces:
> 	test pagemap_scan IOCTL
> - pfnmap
> 	tests for VM_PFNMAP handling
>+- pmd_swap
>+	tests for PMD-level swap entries
> - process_madv
> 	test for process_madv
> - cow
>@@ -399,6 +401,8 @@ CATEGORY="pagemap" run_test ./pagemap_ioctl
> 
> CATEGORY="pfnmap" run_test ./pfnmap
> 
>+CATEGORY="pmd_swap" run_test ./pmd_swap
>+
> # COW tests
> CATEGORY="cow" run_test ./cow
> 
>-- 
>2.53.0-Meta
>
>

