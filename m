Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E1DECD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0322E6B00ED; Wed, 27 May 2026 10:25:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23656B00FB; Wed, 27 May 2026 10:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB806B00FC; Wed, 27 May 2026 10:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C8C036B00ED
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:25:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94F06A061A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:25:34 +0000 (UTC)
X-FDA: 84813422988.20.7D2A82A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id C6697140005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:25:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="e0/VrrN3";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779891932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xj/18EU8MggOrPOIn98SEpLbOCP+RXecZ3tokxGFt9k=;
	b=w6kbRZxikSBnht2Cv48av+vgSjFs3IzQDjwogi3R8+s8nnoLeIFNJ+1ms4O7HLZEy2NiSK
	QRDcG/PMsE/knwUzGOFXgERS2u5ApJ0JKLArNOL0Tcdu/jaWLpWeTVcKcZIers80UXdvb9
	w/eNq789/Daqq0u5DREMB0AmqmzfVs8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="e0/VrrN3";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779891932; a=rsa-sha256;
	cv=none;
	b=JCLHj9jtUcWK/tjoXVD4V9mnzDj92Pfx2i7E3cZoTuxMPOdQXZjKWtpiP5FinByLUuBorJ
	aI1O1rtgyn/fVIDrSzKFv8NfpwalmgXx3Xs3xn2s5u/CA7gl+YI7H6W7/NlUCZXCK95J4d
	WKkNxUcg+nNkQgUvUhDreQfvs8j4hAY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC87727DC;
	Wed, 27 May 2026 07:25:26 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7CD223F905;
	Wed, 27 May 2026 07:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779891931; bh=ukUyIa/lSr5zxWMkQop+vroAz1QmgjIK6x8ZvMDYGAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0/VrrN3pSOjUoBCAxskSUU2iEpS71XbQH64Eo6ItPrn4E9mdTwe/QuXvK6sNrm9N
	 SE+aMy3InVifTZIxhXHyW89tdKjcVNWKF0gs3h1+E+tKj25rCGscHvyPgTintKMphp
	 KbgcsjbbMFuX/2tmmAflWlmJNK78YvvjKJDgR1Nc=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mark Brown <broonie@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v4 4/5] tools/mm: add a standalone GUP microbenchmark
Date: Wed, 27 May 2026 19:54:31 +0530
Message-ID: <20260527142432.230127-5-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260527142432.230127-1-sarthak.sharma@arm.com>
References: <20260527142432.230127-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C6697140005
X-Stat-Signature: d5yzm84ii1mhwtzyjxa5q6jwcr5xwgzu
X-Rspam-User: 
X-HE-Tag: 1779891932-473566
X-HE-Meta: U2FsdGVkX1+uRyPfB4/3mzMNir2ZJW5ktjoTCeWGhMJozqtdJ8u65VnsX5GJ6FRfYQWOXwfY42oHGBjdeYNvTYJZikATwrit+ufTNwE1LQn/FBfJPbMQZsnnabqI/kgjs7zUI9lNoFCFuUCx+6EKT5TPjCZL+Hqcguz4feSQW6qXu4XvqTlIp6TRgTUVfUrFifPWSSFmYPnhJeatn8QN0Wnbo621gWFFSCoUToR7ZRkLuNqHG6prPiHTzUbSC0dWmEJi/lIlJ+CNwx/B4jeouDncftQmlLx11q7PiWG4p5x/Y/9E5ObnqKSlEv0c92gNupUSo9meXHJY5gsAbSO6tYvs0dnVjpAcAl0LTQkq2/a6GlYLpK2TBbqnVk3X5wRDwieqB3Y27aKMQVlGpEU01XFtUQZxT3209DlFGCi84phuqQKTYGw9Qp11h9QHhcplYbjxHPKcqkeE+G/LZ9FZEmB4AKXFwzBAWTgDs3PHwUGbtaUb85dNjak/eZPTPTaP8c512an1LCIY3Gg57MjfarDaevpP8iiYGsLhpKDsXcfVfCqzmU9DcBqR8GOW7ABB65VyuUn41ZnfZ7N0ISWNRpaAjm7px/hMXRq6Wax4LjqkRfKnssxJICo5S88Eh6zv1W6dA5t/MyQIfgrqM3uqAKvtc0AbLpVnSFd7kkjrfT9xR3G+X+FjzGb3lqaCcZV8KJuZvuIh3oap0HKPG0F/02mqmnWjady+O9uiQ0NrqXZ0PelfJU6OO5G4Zvl4ZM0GFy6/XDl3TLDAKDF6hzAm4THmKDFduj0y+4963NTElmq4yRAQAT3X/1ebCsADXANC8fEJVU3vFH/R7Laxrj7ql1tkLE8DkfJj8gdE+dhBXeBDv+Hwovi5kIcaXXcYAvB6HzPp+5kT3sw5gahSy88AtSmsEJLpzPhQHQi0lv4I5HGRLMLM540o4kSrPIT3VrA3vr4/fnYdsBiIDk8RiHH
 JARZS738
 80mAd3t8CgaUe+F6t5CMBd3Pu2Z+cdyZk3yHEMJntqtt6XWUjol5zOT8TSA9eMiS/pNtR9GpWnvkfOk+85CpIcGkY6yfK+Gw+qv5Xqzb8fBaXmTTD0Jc5GhpsNHd5D3/RQYB67b7nDDB+SAmTjjE4xE2tkkusR/wRoDKa5ct2cpsM2I6dP+SCQmfr1++40b6ZrWAY0w12qA3IGmnt+9p8J0BzjBb9sWu8HwgY4KmU3vEuyefYprbQsr76Z/m7CpM8Cofr02sFryETuno=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a command-line tool for benchmarking get_user_pages fast-path
(GUP_FAST), pin_user_pages fast-path (PIN_FAST), and pin_user_pages
longterm (PIN_LONGTERM) via the CONFIG_GUP_TEST debugfs interface.

When invoked without arguments, gup_bench runs the same matrix of
configurations as run_gup_matrix() in run_vmtests.sh: all three GUP
commands across read/write, private/shared mappings, and a range of
page counts, with THP on/off for regular mappings and hugetlb for huge
page mappings. Restore HugeTLB settings after each hugetlb benchmark
run. Validate numeric command-line arguments instead of relying on
atoi().

This tool is a mix of reused and new logic. The mapping/setup path comes
from selftests/mm/gup_test.c, while the default benchmark matrix matches
run_gup_matrix() in run_vmtests.sh. The standalone CLI and tools/mm
integration are added here and the HugeTLB setup code is shared via
tools/lib/mm.

Add gup_bench to BUILD_TARGETS and INSTALL_TARGETS in tools/mm/Makefile,
link it against the shared tools/lib/mm hugepage helpers, and ignore the
resulting binary in tools/mm/.gitignore. While here, also add the
missing thp_swap_allocator_test entry to .gitignore.

Add tools/mm/gup_bench.c to the GUP entry in MAINTAINERS.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 MAINTAINERS          |   1 +
 tools/mm/.gitignore  |   2 +
 tools/mm/Makefile    |  10 +-
 tools/mm/gup_bench.c | 433 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 443 insertions(+), 3 deletions(-)
 create mode 100644 tools/mm/gup_bench.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 5d2f72bbd128..402b4de7b7e8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16839,6 +16839,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	mm/gup.c
 F:	mm/gup_test.c
 F:	mm/gup_test.h
+F:	tools/mm/gup_bench.c
 F:	tools/testing/selftests/mm/gup_longterm.c
 F:	tools/testing/selftests/mm/gup_test.c
 
diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
index 922879f93fc8..154d740be02e 100644
--- a/tools/mm/.gitignore
+++ b/tools/mm/.gitignore
@@ -2,3 +2,5 @@
 slabinfo
 page-types
 page_owner_sort
+thp_swap_allocator_test
+gup_bench
diff --git a/tools/mm/Makefile b/tools/mm/Makefile
index f5725b5c23aa..d82cc8c43ee0 100644
--- a/tools/mm/Makefile
+++ b/tools/mm/Makefile
@@ -3,13 +3,14 @@
 #
 include ../scripts/Makefile.include
 
-BUILD_TARGETS=page-types slabinfo page_owner_sort thp_swap_allocator_test
+BUILD_TARGETS=page-types slabinfo page_owner_sort thp_swap_allocator_test gup_bench
 INSTALL_TARGETS = $(BUILD_TARGETS) thpmaps
 
 LIB_DIR = ../lib/api
 LIBS = $(LIB_DIR)/libapi.a
+GUP_BENCH_OBJS = gup_bench.c ../lib/mm/hugepage_settings.c ../lib/mm/file_utils.c
 
-CFLAGS += -Wall -Wextra -I../lib/ -pthread
+CFLAGS += -Wall -Wextra -I../lib/ -I../.. -pthread
 LDFLAGS += $(LIBS) -pthread
 
 all: $(BUILD_TARGETS)
@@ -22,8 +23,11 @@ $(LIBS):
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
 
+gup_bench: $(GUP_BENCH_OBJS) $(LIBS)
+	$(CC) $(CFLAGS) -o $@ $(GUP_BENCH_OBJS) $(LDFLAGS)
+
 clean:
-	$(RM) page-types slabinfo page_owner_sort thp_swap_allocator_test
+	$(RM) page-types slabinfo page_owner_sort thp_swap_allocator_test gup_bench
 	make -C $(LIB_DIR) clean
 
 sbindir ?= /usr/sbin
diff --git a/tools/mm/gup_bench.c b/tools/mm/gup_bench.c
new file mode 100644
index 000000000000..b3990fd7c1d9
--- /dev/null
+++ b/tools/mm/gup_bench.c
@@ -0,0 +1,433 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Microbenchmark for get_user_pages (GUP) kernel interfaces.
+ *
+ * Exercises GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK, and
+ * PIN_LONGTERM_BENCHMARK via the CONFIG_GUP_TEST debugfs interface.
+ *
+ * Example use:
+ *   # Run the full matrix (all commands, access modes, page counts):
+ *   ./gup_bench
+ *
+ *   # Single run: pin_user_pages_fast, 512 pages, write access, hugetlb:
+ *   ./gup_bench -a -n 512 -w -H
+ *
+ * Requires CONFIG_GUP_TEST=y and debugfs mounted at /sys/kernel/debug.
+ * Must be run as root.
+ */
+
+#define __SANE_USERSPACE_TYPES__ // Use ll64
+#include <fcntl.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <dirent.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <pthread.h>
+#include <stdbool.h>
+#include <stdatomic.h>
+#include <stdint.h>
+#include <limits.h>
+#include <string.h>
+#include <mm/gup_test.h>
+#include <mm/hugepage_settings.h>
+
+#define MB (1UL << 20)
+
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+#endif
+
+/* Just the flags we need, copied from the kernel internals. */
+#define FOLL_WRITE	0x01	/* check pte is writable */
+
+#define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
+
+static unsigned int psize(void)
+{
+	static unsigned int __page_size;
+
+	if (!__page_size)
+		__page_size = sysconf(_SC_PAGESIZE);
+	return __page_size;
+}
+
+static unsigned long cmd;
+static const char *bench_label;
+static int gup_fd, repeats = 1;
+static unsigned long size = 128 * MB;
+static atomic_int bench_error;
+/* Serialize prints */
+static pthread_mutex_t print_mutex = PTHREAD_MUTEX_INITIALIZER;
+
+static const unsigned long bench_cmds[] = {
+	GUP_FAST_BENCHMARK,
+	PIN_FAST_BENCHMARK,
+	PIN_LONGTERM_BENCHMARK,
+};
+
+static const int bench_thp_modes[] = { 1, 0 };	/* on, off */
+static const int bench_nr_pages_list[] = { 1, 512, 123, -1 };
+
+static const char *cmd_to_str(unsigned long cmd)
+{
+	switch (cmd) {
+	case GUP_FAST_BENCHMARK:
+		return "GUP_FAST_BENCHMARK";
+	case PIN_FAST_BENCHMARK:
+		return "PIN_FAST_BENCHMARK";
+	case PIN_LONGTERM_BENCHMARK:
+		return "PIN_LONGTERM_BENCHMARK";
+	}
+	return "Unknown command";
+}
+
+static long parse_long_arg(const char *arg, const char *name)
+{
+	char *end;
+	long val;
+
+	errno = 0;
+	val = strtol(arg, &end, 10);
+	if (errno || end == arg || *end != '\0') {
+		fprintf(stderr, "Invalid %s '%s'\n", name, arg);
+		exit(1);
+	}
+
+	return val;
+}
+
+static long parse_positive_long_arg(const char *arg, const char *name)
+{
+	long val = parse_long_arg(arg, name);
+
+	if (val < 1) {
+		fprintf(stderr, "Invalid %s '%s'\n", name, arg);
+		exit(1);
+	}
+
+	return val;
+}
+
+struct bench_run {
+	unsigned long cmd;
+	int thp;		/* -1: default, 0: off, 1: on */
+	bool hugetlb;
+	bool write;
+	bool shared;
+	int nr_pages;		/* -1 means all pages (size / psize()) */
+	unsigned long size;
+	char *file;
+	int nthreads;
+	unsigned int gup_flags;
+};
+
+void *gup_thread(void *data)
+{
+	struct gup_test gup = *(struct gup_test *)data;
+	int i, status;
+
+	for (i = 0; i < repeats; i++) {
+		gup.size = size;
+		status = ioctl(gup_fd, cmd, &gup);
+		if (status) {
+			bench_error = 1;
+			break;
+		}
+
+		pthread_mutex_lock(&print_mutex);
+		printf("%s time: get:%lld put:%lld us",
+		       bench_label, gup.get_delta_usec,
+		       gup.put_delta_usec);
+		if (gup.size != size)
+			printf(", truncated (size: %lld)", gup.size);
+		printf("\n");
+		pthread_mutex_unlock(&print_mutex);
+	}
+
+	return NULL;
+}
+
+static int run_bench(struct bench_run *run)
+{
+	struct gup_test gup = { 0 };
+	int zero_fd, i, ret, started_threads = 0;
+	int flags = MAP_PRIVATE;
+	pthread_t *tid;
+	char label[128];
+	char *p;
+	bool restore_hugetlb = false;
+
+	/* Set globals consumed by gup_thread */
+	cmd = run->cmd;
+	size = run->size;
+	bench_error = 0;
+
+	if (run->hugetlb) {
+		unsigned long hp_size = default_huge_page_size();
+
+		if (!hp_size) {
+			fprintf(stderr, "Could not determine huge page size\n");
+			return 1;
+		}
+		size = (size + hp_size - 1) & ~(hp_size - 1);
+		if (!hugetlb_setup_default(size / hp_size)) {
+			fprintf(stderr, "Not enough huge pages\n");
+			hugetlb_restore_settings();
+			return 1;
+		}
+		restore_hugetlb = true;
+		flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
+	}
+
+	if (run->shared) {
+		flags &= ~MAP_PRIVATE;
+		flags |= MAP_SHARED;
+	}
+
+	gup.nr_pages_per_call = run->nr_pages < 0 ? size / psize() :
+		(unsigned long)run->nr_pages;
+
+	gup.gup_flags = run->gup_flags;
+	if (run->write)
+		gup.gup_flags |= FOLL_WRITE;
+
+	snprintf(label, sizeof(label), "%s (nr_pages=%-4u %s %s %s %s)",
+		 cmd_to_str(run->cmd),
+		 gup.nr_pages_per_call,
+		 run->write  ? "write"   : "read",
+		 run->shared ? "shared"  : "private",
+		 run->hugetlb ? "hugetlb=on" : "hugetlb=off",
+		 run->hugetlb ? "thp=off" :
+		 (run->thp == 1 ? "thp=on" :
+		 (run->thp == 0 ? "thp=off" : "thp=default")));
+	bench_label = label;
+
+	zero_fd = open(run->file, O_RDWR);
+	if (zero_fd < 0) {
+		fprintf(stderr, "Unable to open %s: %s\n", run->file, strerror(errno));
+		if (restore_hugetlb)
+			hugetlb_restore_settings();
+		return 1;
+	}
+
+	p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, zero_fd, 0);
+	close(zero_fd);
+	if (p == MAP_FAILED) {
+		fprintf(stderr, "mmap: %s\n", strerror(errno));
+		if (restore_hugetlb)
+			hugetlb_restore_settings();
+		return 1;
+	}
+	gup.addr = (unsigned long)p;
+
+	if (run->thp == 1)
+		madvise(p, size, MADV_HUGEPAGE);
+	else if (run->thp == 0)
+		madvise(p, size, MADV_NOHUGEPAGE);
+
+	/* Fault them in here, from user space. */
+	for (; (unsigned long)p < gup.addr + size; p += psize())
+		p[0] = 0;
+
+	tid = malloc(sizeof(pthread_t) * run->nthreads);
+	if (!tid) {
+		fprintf(stderr, "Failed to allocate %d threads: %s\n",
+			run->nthreads, strerror(errno));
+		munmap((void *)gup.addr, size);
+		if (restore_hugetlb)
+			hugetlb_restore_settings();
+		return 1;
+	}
+
+	for (i = 0; i < run->nthreads; i++) {
+		ret = pthread_create(&tid[i], NULL, gup_thread, &gup);
+		if (ret) {
+			fprintf(stderr, "pthread_create failed: %s\n", strerror(ret));
+			bench_error = 1;
+			break;
+		}
+		started_threads++;
+	}
+	for (i = 0; i < started_threads; i++) {
+		ret = pthread_join(tid[i], NULL);
+		if (ret) {
+			fprintf(stderr, "pthread_join failed: %s\n", strerror(ret));
+			bench_error = 1;
+		}
+	}
+
+	free(tid);
+	munmap((void *)gup.addr, size);
+	if (restore_hugetlb)
+		hugetlb_restore_settings();
+
+	return bench_error ? 1 : 0;
+}
+
+static int run_matrix(void)
+{
+	unsigned int c, t, w, s, n;
+	int ret = 0;
+
+	for (c = 0; c < ARRAY_SIZE(bench_cmds); c++) {
+		for (w = 0; w <= 1; w++) {
+			for (s = 0; s <= 1; s++) {
+				for (t = 0; t < ARRAY_SIZE(bench_thp_modes); t++) {
+					for (n = 0; n < ARRAY_SIZE(bench_nr_pages_list); n++) {
+						struct bench_run run = {
+							.cmd	  = bench_cmds[c],
+							.thp	  = bench_thp_modes[t],
+							.hugetlb  = false,
+							.write	  = w,
+							.shared	  = s,
+							.nr_pages = bench_nr_pages_list[n],
+							.size	  = 128 * MB,
+							.file	  = "/dev/zero",
+							.nthreads = 1,
+						};
+						ret |= run_bench(&run);
+					}
+				}
+				/* hugetlb: 256M to match run_gup_matrix() in run_vmtests.sh */
+				for (n = 0; n < ARRAY_SIZE(bench_nr_pages_list); n++) {
+					struct bench_run run = {
+						.cmd	  = bench_cmds[c],
+						.thp	  = -1,
+						.hugetlb  = true,
+						.write	  = w,
+						.shared	  = s,
+						.nr_pages = bench_nr_pages_list[n],
+						.size	  = 256 * MB,
+						.file	  = "/dev/zero",
+						.nthreads = 1,
+					};
+					ret |= run_bench(&run);
+				}
+			}
+		}
+	}
+	return ret;
+}
+
+int main(int argc, char **argv)
+{
+	struct bench_run run = {
+		.cmd	  = GUP_FAST_BENCHMARK,
+		.thp	  = -1,
+		.hugetlb  = false,
+		.write	  = true,
+		.shared	  = false,
+		.nr_pages = 1,
+		.size	  = 128 * MB,
+		.file	  = "/dev/zero",
+		.nthreads = 1,
+	};
+	int opt, result;
+
+	while ((opt = getopt(argc, argv, "m:r:n:F:f:aj:tTLuwWSH")) != -1) {
+		switch (opt) {
+		/* Command selection */
+		case 'u':
+			run.cmd = GUP_FAST_BENCHMARK;
+			break;
+		case 'a':
+			run.cmd = PIN_FAST_BENCHMARK;
+			break;
+		case 'L':
+			run.cmd = PIN_LONGTERM_BENCHMARK;
+			break;
+
+		/* Memory type */
+		case 'H':
+			run.hugetlb = true;
+			break;
+		case 't':
+			run.thp = 1;
+			break;
+		case 'T':
+			run.thp = 0;
+			break;
+
+		/* Access mode */
+		case 'w':
+			run.write = true;
+			break;
+		case 'W':
+			run.write = false;
+			break;
+		case 'S':
+			run.shared = true;
+			break;
+
+		/* Mapping */
+		case 'f':
+			run.file = optarg;
+			break;
+
+		/* Sizing and iteration */
+		case 'm':
+			run.size = parse_positive_long_arg(optarg, "size") * MB;
+			break;
+		case 'n':
+			run.nr_pages = parse_long_arg(optarg, "page count");
+			if (run.nr_pages < -1) {
+				fprintf(stderr, "Invalid page count '%s'\n", optarg);
+				exit(1);
+			}
+			break;
+		case 'r':
+			repeats = parse_positive_long_arg(optarg, "repeat count");
+			break;
+		case 'j': {
+			long val;
+
+			val = parse_positive_long_arg(optarg, "thread count");
+			if (val > INT_MAX ||
+			    (size_t)val > SIZE_MAX / sizeof(pthread_t)) {
+				fprintf(stderr, "Invalid thread count '%s'\n", optarg);
+				exit(1);
+			}
+			run.nthreads = val;
+			break;
+		}
+
+		/* Advanced */
+		case 'F':
+			/* strtol, so you can pass flags in hex form */
+			run.gup_flags = strtol(optarg, 0, 0);
+			break;
+
+		default:
+			fprintf(stderr, "Wrong argument\n");
+			exit(1);
+		}
+	}
+
+	gup_fd = open(GUP_TEST_FILE, O_RDWR);
+	if (gup_fd == -1) {
+		if (errno == EACCES) {
+			fprintf(stderr, "Please run as root\n");
+		} else if (errno == ENOENT) {
+			DIR *debugfs = opendir("/sys/kernel/debug");
+
+			if (!debugfs) {
+				fprintf(stderr, "Mount debugfs at /sys/kernel/debug\n");
+			} else {
+				closedir(debugfs);
+				fprintf(stderr, "Check CONFIG_GUP_TEST in kernel config\n");
+			}
+		} else {
+			fprintf(stderr, "Failed to open %s: %s\n", GUP_TEST_FILE,
+				strerror(errno));
+		}
+		exit(1);
+	}
+
+	result = (argc == 1) ? run_matrix() : run_bench(&run);
+	close(gup_fd);
+	return result;
+}
-- 
2.39.5


