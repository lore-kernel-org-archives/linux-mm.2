Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0808C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9943D6B00CB; Fri,  3 Jul 2026 13:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969CC6B00CD; Fri,  3 Jul 2026 13:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880306B00CE; Fri,  3 Jul 2026 13:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC866B00CB
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:40:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D72861C16E2
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:40:34 +0000 (UTC)
X-FDA: 84948179988.20.AB1F937
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 22814A0005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:40:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O3ZlaExn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783100433;
	b=TpkBQ7XxyftD1abln2MIochoQQtrkofYFvpefmJjW5ilYpMGLlLqW0dFg0yTn4Iwtrvqeh
	H2xzEdc5K6Mbos9BBZ2iCYZAQG8HaImGdY8U58AC8o1WxnWEu1XGIK+LQh3nyG7rIGURI7
	IzTd9FzX8PtIQe66SZPGU79UuUtfN5A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783100433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WU27HfqOCGLQs5g/bhuZOuVoFjIr7LFmlhzYICznf98=;
	b=qgnYUQu3cfuEXcLS+Q8E2HL5MAwn7vJwgcfkjsFK/4TI1GEcUFvHsAOWwid4IdF/EBrCi8
	aryP0cH0zFyYFim5aOfqu6A+STWZWeV1T8TpDqZBypN7v6u+sIcTmciUq3AE2/I1AHweif
	N7LHRdIhxpbU5D8WPTTMs82bI5E5Hgk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O3ZlaExn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783100431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WU27HfqOCGLQs5g/bhuZOuVoFjIr7LFmlhzYICznf98=;
	b=O3ZlaExno8oPdXsWeLF7CwHYFDWJliRgEYpsea5u/Yvel53fFhKWblj/IB9mW0quAXNrKq
	gMgU+5ro+qOeok+d79XhsxEeRvD788TWWZNHnezG9yxwx6T7hVxq/11SmgL6F78hFq+WNZ
	4sYIZlJGp7wdLLS9DmGJ1DFat2cUekI=
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
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 11/11] selftests/mm: add PMD swap entry tests
Date: Fri,  3 Jul 2026 10:38:28 -0700
Message-ID: <20260703173903.3789516-12-usama.arif@linux.dev>
In-Reply-To: <20260703173903.3789516-1-usama.arif@linux.dev>
References: <20260703173903.3789516-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: i7humqb9se3sdqcywagbhxxqyiksnfpk
X-Rspamd-Queue-Id: 22814A0005
X-HE-Tag: 1783100432-634042
X-HE-Meta: U2FsdGVkX18ygItAR4vwZeW3KlIw0v14Qag/1rmh+CyyEEryObrl18lqhl71hxreJwkKKbnBXclyCvigqWvypM0k9WHwvE00uV/XSPk84yKrSYnjaH7bHiMttuKlo71vfUuMK5UcrWUawhQKQlCeP9EIC4pPgq0zu2T0nrxbaYanyC01LkoQUkAD2nRufCxrot/9imCSgT6/JDProaxYfmvgwSa87ElDLDjaeeTiOFDrdOviqMssjw/xRECd+vDiE6CXOz00tjBl/jdkyNaJq7xMc2/aeRO3THSoSRq5kQxWSqnFzmWuh13U3Nnz8dkgQlpsVYEzOL+I+aEfXAD+d1YUQw12druZGjrgcYRRVEz7poh7r8BlKMM/nyjgpMq7+hR7oWoETaauSsapG1dHz0JiO+XX8bCEO1EbwdvLKP1lEGdGvO9aavCzspIeXgNGlj40TQtdHNpCuE2naPkqTpKQPWAZc7xo8EE5dVz864HEgMI9I/eSG/8V9flHbY3vJ0tl87e6vVEBIpvEqIUy0WJfZ13PXhpafUQsCxmbccBfk1fftjEfS4NvvTUhtF4xlGhGkNmL5qszBOR/SvUj2+qrr+AAy4SO9bbNgJTUXhMvsjJKY4285Jdr8S/8t9VZb3M9mHbYk9e31hSxSKbXn5Lja4ZE+UAnwh8efKBIcCBvnHqiIomhovagLViYVRaFuXCyMWXmDlggTepwEtU5eyFlmJhLuxjwQa6Ni+ed8i+aJ6VFt0aCFHFxZArE6xCxLc56rpoSxKOT1L5ql1LIaykml4M6SzZ4tRapU9EtoHoNe9vPApGOrRgQo8TYLK3+wA60xXv4Y0G/hfBUOYulmyym3St8b3wL6L25hy+WzDaswfBHY6rwV9hQqsNAU8MGBXqWDvax88eTjSj14v9VBeXJBoEsk8wqx7ylf3mG+B8ZMYytYaLcm/Yby9+fIETb/va3xq07maD9b6t6dSi
 CXN+bH5M
 ACIQRGx0YX2VEwaBmwbDpfJQ+sE7oImtGIrBh7u5Fg7bbnR/NgDaJSPdrRiBL+BXmahUt67iiDm2HscS/Lebh8jPOqO9kqI4T+eBPXW+3ZKZzTATgZQqL+I2qIWBcoF1nZOAoN4HoQdid7LmkgLjL1gMevZmKtkwnUbF0g3K27WoGiH4F8a15jkhqn1lGVUP46l9Gn4UThTRng87L5M6fM1Z7DUx1IeVztdsnWT2fQiCnNz8=
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
 - munmap of a swapped PMD (zap_huge_pmd swap slot cleanup)
 - mprotect on a swapped PMD (change_non_present_huge_pmd)
 - UFFDIO_MOVE on a swapped PMD (move_pages_huge_pmd swap path)
 - mremap of a swapped PMD (move_soft_dirty_pmd)
 - pagemap reading (pagemap_pmd_range_thp softleaf_has_pfn guard)
 - mincore on a swapped PMD without faulting it in
 - MADV_FREE on a swapped PMD: verifies swap slots are freed via
   pagemap and the memory reads back as zero
 - MADV_WILLNEED on a swapped PMD
 - swapoff with active PMD swap entries

When zswap is enabled, PMD-order consumers may split a PMD swap entry
and retry through the PTE path because zswap stores the range as
per-page entries. In that configuration, the tests still verify data
correctness and log that the PMD mapping assertion is skipped. With
zswap disabled, the tests assert that write faults, UFFDIO_MOVE,
MADV_WILLNEED, and swapoff restore a PMD-mapped THP where expected.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 tools/testing/selftests/mm/Makefile   |   1 +
 tools/testing/selftests/mm/pmd_swap.c | 702 ++++++++++++++++++++++++++
 2 files changed, 703 insertions(+)
 create mode 100644 tools/testing/selftests/mm/pmd_swap.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index ed321ae709da..4561fa2ac80f 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -105,6 +105,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
+TEST_GEN_FILES += pmd_swap
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/pmd_swap.c b/tools/testing/selftests/mm/pmd_swap.c
new file mode 100644
index 000000000000..b4a60a6b50d9
--- /dev/null
+++ b/tools/testing/selftests/mm/pmd_swap.c
@@ -0,0 +1,702 @@
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
+ * trigger copy-on-write so the parent's data stays isolated.
+ */
+TEST_F(pmd_swap, fork_cow)
+{
+	unsigned int parent_seed = self->seed;
+	unsigned int child_seed = ~self->seed;
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
+	ASSERT_TRUE(verify_pattern(mem, self->pmd_size, parent_seed));
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), 0);
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
+	api.features = UFFD_FEATURE_MOVE;
+	if (ioctl(uffd, UFFDIO_API, &api) ||
+	    !(api.features & UFFD_FEATURE_MOVE)) {
+		close(uffd);
+		munmap(src, self->pmd_size);
+		munmap(dst, self->pmd_size);
+		SKIP(return, "UFFD_FEATURE_MOVE unsupported\n");
+	}
+
+	reg.range.start = (unsigned long)dst;
+	reg.range.len = self->pmd_size;
+	reg.mode = UFFDIO_REGISTER_MODE_MISSING;
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
+		close(uffd);
+		munmap(src, self->pmd_size);
+		munmap(dst, self->pmd_size);
+		ASSERT_EQ(errno, 0);
+	}
+	ASSERT_EQ(move.move, self->pmd_size);
+
+	/* dst inherits the PMD swap entry; reading it must restore the data. */
+	ASSERT_TRUE(check_swapped(self->pagemap_fd, dst, self->pmd_size));
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
+	int ret, err;
+
+	mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd, seed);
+	if (mem == MAP_FAILED)
+		SKIP(return, "Could not create swapped THP\n");
+
+	ret = swapoff(self->swap_dev);
+	err = errno;
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("swapoff(%s) failed: %s", self->swap_dev, strerror(err));
+		munmap(mem, self->pmd_size);
+	}
+
+	ASSERT_TRUE(verify_pattern(mem, self->pmd_size, seed)) {
+		swapon(self->swap_dev, 0);
+		munmap(mem, self->pmd_size);
+	}
+
+	if (self->zswap_enabled) {
+		TH_LOG("zswap is enabled, so PMD mapping is not checked");
+	} else {
+		ASSERT_TRUE(check_huge_anon(mem, 1, self->pmd_size)) {
+			swapon(self->swap_dev, 0);
+			munmap(mem, self->pmd_size);
+		}
+	}
+
+	ret = swapon(self->swap_dev, 0);
+	err = errno;
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("swapon(%s) failed: %s", self->swap_dev, strerror(err));
+		munmap(mem, self->pmd_size);
+	}
+
+	munmap(mem, self->pmd_size);
+}
+
+TEST_HARNESS_MAIN
-- 
2.53.0-Meta


