Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1D17CD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 11:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030766B0099; Thu, 21 May 2026 07:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23CD6B009B; Thu, 21 May 2026 07:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB916B009D; Thu, 21 May 2026 07:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA67E6B0099
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:20:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 669E5405CC
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:20:28 +0000 (UTC)
X-FDA: 84791183736.19.356A1E0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9C1DF140005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:20:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=c+AfKhZs;
	spf=pass (imf09.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779362426; a=rsa-sha256;
	cv=none;
	b=yGKBqhfkuLk2T2N2w3px+guEqwu700Qe+L+RO9DshGC9p+njfsegssMb7p3YIu0n7L9wdT
	sT1DIvix1v4KRMJjdUwlOHsdnNc5zjWsD+z6gKjAD17skwuregxsKvqdfrhNuZGWAu5xma
	13eN1aMG/C6JHjD5vLGzBANpoTMmML8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=c+AfKhZs;
	spf=pass (imf09.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779362426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=urQahmtitkUQc+kkM0En6+s588BOVZIiHHDGoFiQlMY=;
	b=gMPoMoV9woByIUhVZzkL0p5sc2haOm8FaTuUR9zOx5B0gbu6bKdxWOuKd4DeakvJpDaR2N
	u2AieyWB+s+Sq+wy+rW4+wIPFjbUtRJYbDpqvWBW1vGR+DnUO2eafFVMUFrJW6RL1K7ba7
	FUXSqpjbjWdYK9ZL3OggH0nQrREUj7I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7038C49FB;
	Thu, 21 May 2026 04:20:20 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0F2CE3F7B4;
	Thu, 21 May 2026 04:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779362425; bh=4ulMEzBkpsEhSV31ufN/gnDTSDmcCXYY7UHU+NqifjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+AfKhZsJZ/D6dgfK3zlkNEK8sWB2PXghKu08njylyPPhtwI+JFr/6tAS553XnT53
	 kb3VxQzI3bNglnwcATt8vslYdq6zvdlNNc9didsZdzm9J1Lh9c5sRtpMeiJORYlAzq
	 5l9KR7IXg48y23vA9Up7xJM3fZxV09fdObjotQGM=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v3 3/4] tools/mm: add a standalone GUP microbenchmark
Date: Thu, 21 May 2026 16:48:00 +0530
Message-ID: <20260521111801.173019-4-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260521111801.173019-1-sarthak.sharma@arm.com>
References: <20260521111801.173019-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C1DF140005
X-Rspamd-Server: rspam03
X-Stat-Signature: umh5f33c734wt53ryp657jcyhtm5phea
X-HE-Tag: 1779362426-893845
X-HE-Meta: U2FsdGVkX1+prSEb3GjegUWcARn5BuKnh8DdMnAYXaEd6o3NKh6+nj17xIPLbsaEzfH+odeRR7WIk3JLKjNR47tEhWQ1FrJ5XsDGGkYhGGvXdJPvA6NYxQP+QI8PA8i6Vvl+uvUZWKmPD6fgBnNBKveZYk80rz5UxpBFso0Upoul0sQpKd3ltw0PDC8eOBIGWOdEuf40rQVcpmKGcYGFy6CMRpsknbArZDA/p32xiPPtuWrsMeWv7xl+vBwVzDMSm+UAq/XhLD7vRC/QFyObLuKL0pmR6ljdl5vsCQuE8W/yXedIWTgaT5DGC3AXrLhIvbRolPVnE5TR1ODmOHge9KUavejtPak5mab+O6m03B9G9J9hqp0GxrEFu+hJbr710+TpI0j03mmWcPMx65RcbdxgKtqOeeV0vyNtAbFBP5rVqDfvTJBTGQCYJ1/f0CuafjJ5hwXBOrmCG+rEP5OHG2XbMNDTx+jHRHpg10izdi12aHib6tdNlck5OQa5JKxzT66vyUjW/5AOJxytXEG/MIo0plpp0bOx+dlk9URRQ2SW30YNOscPlqBcDAMqLOKxcLoqI+VY3qHvKVarX2HBr06Bi+0HNlYzHDo8wBAApozVcE7YyH0D9xgucgtMmbP21ghF0kBPBONH+1lcE01zOfsFdsusVuwKpuiGA07U6k9zBfjh6QAVreGwKlhqCNCyAfvxUuYTS6lwGvLiszIs2QLgQa0SZ1Q0VX9BgwbEEcgU2laiyGDbFSCS0M6oGYWuh+SDXho++1an5hdk5laYhocuB7ZQ2Lkjzed6TeUeHD+ur5sn5h1JzGai1lqZ9i8JvWYJUxgFc0/5NwOCBXlSExK0TXDOFnuJEHihHWT0z/vSgZy2/7FyAWR0jnXoTttONgmyXr+XdjwChLveW+qnsE577XuGI0FMDpJFot6xRPxlyAuUoqIN0JfBc3CWic1+bDzdv5Fr7PO0alXjF1B
 JC6KjyTT
 UscISvZ11D/TVbSM32RPFPaKSNNj4Sg/YeIz+dg6jGyJ1TYLF6WqhGCnOQEuihNEvEqj+5TcudhSSXtg/ZZIT8RjMITDsbvUBP9F4srVYyDjCQmLjLp6S2v2rqsDOfHdDTDF6hlylS4GTwKip8ez0eQDU112z02pr9LS/6r+a6SinYZ4wcEisVv/X94cUtOWL07fO4WUdarzWV0oAUnWwEfAIV437xzy0+E94azA/9Z/M4OwX87MpE9eUee89lbktsQUL5NR0CmnULGM=
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
page mappings.

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
 tools/mm/gup_bench.c | 390 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 400 insertions(+), 3 deletions(-)
 create mode 100644 tools/mm/gup_bench.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 7887a3263373..0dbb90247a75 100644
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
index 000000000000..50faff4527e5
--- /dev/null
+++ b/tools/mm/gup_bench.c
@@ -0,0 +1,390 @@
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
+			    bench_label, gup.get_delta_usec,
+				    gup.put_delta_usec);
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
+			return 1;
+		}
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
+		return 1;
+	}
+
+	p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, zero_fd, 0);
+	close(zero_fd);
+	if (p == MAP_FAILED) {
+		fprintf(stderr, "mmap: %s\n", strerror(errno));
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
+
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
+			run.size = atoi(optarg) * MB;
+			break;
+		case 'n':
+			run.nr_pages = atoi(optarg);
+			break;
+		case 'r':
+			repeats = atoi(optarg);
+			break;
+		case 'j': {
+			char *end;
+			long val;
+
+			errno = 0;
+			val = strtol(optarg, &end, 10);
+			if (errno || end == optarg || *end != '\0' || val < 1 ||
+			    val > INT_MAX ||
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
+			if (opendir("/sys/kernel/debug") == NULL)
+				fprintf(stderr, "Mount debugfs at /sys/kernel/debug\n");
+			else
+				fprintf(stderr, "Check CONFIG_GUP_TEST in kernel config\n");
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


