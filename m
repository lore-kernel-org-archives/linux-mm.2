Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0C2BCD4F57
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 12:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 343B06B0088; Tue, 19 May 2026 08:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4906B008C; Tue, 19 May 2026 08:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3D96B0092; Tue, 19 May 2026 08:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B06D6B0088
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:05:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B41E2A030D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:05:32 +0000 (UTC)
X-FDA: 84784039704.23.9A0B1ED
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id E42DD1C000F
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:05:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="q/Gr1hmu";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779192331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=orXZjfHoApfwTwdgjGvatpLAD7Kmh7m9xq/4L1ET814=;
	b=B2O3hWly+OwY8470X6WznpgkDmLs4+b8scw4d6OIcBQqADkc7JqXLLWW67p2uZQ/s/3Zta
	BBqip7iXjtrpF8I0lpgcJiBEbLumig7B/RWNvrudJoUMj8ZBh21LP1iBeGoa79aClWjS8n
	q+eY+609eNHUykjbtSFAAyrntA1jYFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779192331; a=rsa-sha256;
	cv=none;
	b=t7jE4oFOdtAcQ5dyvsJeJgcSd+pscbMEwaVnToqFpQi/Ia9eh+g7Mv32iY/C5ARNF891X6
	PJtGbFgX5EgwmD5E2XC/9q0JagD4TRUdyWJ0QXe3YogsbsVbhNeDSkCzkrtYs7N1NW925Z
	gyQgVu408fhxNUtJ+EtSRCATTGoHEyE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="q/Gr1hmu";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCF2422FA;
	Tue, 19 May 2026 05:05:24 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 49D9F3F85F;
	Tue, 19 May 2026 05:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779192329; bh=sHKXDPRz5CC+ddYd15V+FzHYq1MYmq/fvhP1ENudmq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/Gr1hmuelIgB2MsYmOiR8H1U9DYH/D1x0vo5ToA6KtFqdFQ/6NSCBUPXnCcyegdm
	 hlzL71rfzgLS4GItmwZnC4r0x2RcXjImKWJpzlznhFG2TfnFS8hsay0NIgEC5tZK3c
	 msR13Zh0IzizadQ+PrGnM1RIbGBseQB4th/CHCXU=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v2 1/2] tools/mm: add a standalone GUP microbenchmark
Date: Tue, 19 May 2026 17:35:05 +0530
Message-ID: <20260519120506.184512-2-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260519120506.184512-1-sarthak.sharma@arm.com>
References: <20260519120506.184512-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E42DD1C000F
X-Stat-Signature: bd15tt4aicw3skewyuoiyegp8gmqag9i
X-Rspam-User: 
X-HE-Tag: 1779192330-439151
X-HE-Meta: U2FsdGVkX1/YlqTBYooHR+HPVsPG/05FpozQY7gP5zKdQqt/AlbmSy0EUlVswxiCIcIKWa/tiLRq0H/hhwhcS10p/rSxLCNpl9KK16x4gHuuw5TTf9Op8NsfgPd7HRSnsy5B5n2ZddZAZiE1/KTEu1hV6Ybqr28DkP97IFv2qcO23Uy9zckhBF+YH08kZZWeTsVrmk9a0XunR54m0kRBRDekkawTwwp5Pg8ct/jPjYkRbaVk0fG/3l8scoU+U0ndHYKhK/wx8ytqbdlgUpPea2yH9fMH11Gk9kZkPzARbu4IRRW+lQiX/kp7SKv33sMtF9djSnrQa0SHQVes+DES8RUrZrSvqwl2iIoAdU/eQG8nujY8JhDFmzWZMe556c0rbJhMxqqzZvHThx79nd+tKFIr/JpEGX7bO61yjdsc2tFb4qeiCAnsFXcL1F0uiN/NCImg4NQt56Nqug9/ylUEAvsYNlzAWZR3zIP7k+IBMnVxULleRIAvUUD3S1yA0oEJYxLxxHeRYmzG2tRL7cMLaKTnXqyc+i9Q0xVR1YQj1oxlifhonPY72rcz7AVdzZPt+tj0Ib9Wx8+O47TkAhNrd6AawRJFlDXBIUg3E812h7RKuLp5XJWtcXqW1Av5mj1XCd+/w+Y89BYlbtNhv3FsAlXzTEwkxFTR8nYgp3sUdxXjebEmzvQWzvpVa2o5Uglbmoe3ssjLLBCaY70hPzBICfWZbRqKpAABTJ7o7Cb8haKvdyiD3QpyxapnWYAjZjrZMK/MiZQVngZPh1LNujrTwCn3i7xrM2vmAqFpSKgTXiyD0/Zm8/lLok1dkRKpiIg46py+Z8IWIcB5Yu3vj+fCJOTmrJYaXpWXpC+eFwPut22q7Z3bdcJSb4rBvU3GqLt6oM7NJutCjDI8s/FTjUo+3N6ZsD9DwSPn6iq4hrhAZsH8Vm3x/6kzC8Zdh1ZE1hk5Ad/i8fdQKfikgSHrmKW
 GK4qTuOR
 B1zVsP+++nAbHbF0TJ1aTYPfXyRkZX98AQeUc/w6UcjoiZyG4Cj5d0u9kLW7mIW4lZLPu9Tk5MbKc97PcF+y7oEX0FRii1YhnhTnAhxkwdmZTzChFr0DOFtgxm7n/0c7P+CyYVKEY6yQHlqiLR8cvMHITjB7t2X5lx160MMfwOeIrOybb+F5SiuulosXqb+shkqKhKV87NfJ3sPAOlAb2gJ2L8kpT9Nxg4cY6OhKkk/pS6/SanvvjfZaR70zMdAmOn8kJq/BSu9wRYcg=
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
integration are added here so tools/mm does not depend on kselftest.

Add gup_bench to BUILD_TARGETS and INSTALL_TARGETS in tools/mm/Makefile,
and ignore the resulting binary in tools/mm/.gitignore. While here, also
add the missing thp_swap_allocator_test entry to .gitignore.

Add tools/mm/gup_bench.c to the GUP entry in MAINTAINERS.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 MAINTAINERS          |   1 +
 tools/mm/.gitignore  |   2 +
 tools/mm/Makefile    |   6 +-
 tools/mm/gup_bench.c | 491 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 497 insertions(+), 3 deletions(-)
 create mode 100644 tools/mm/gup_bench.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 98d0a7a1c689..c91165b9280e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16830,6 +16830,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
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
index f5725b5c23aa..8e4db797a17a 100644
--- a/tools/mm/Makefile
+++ b/tools/mm/Makefile
@@ -3,13 +3,13 @@
 #
 include ../scripts/Makefile.include
 
-BUILD_TARGETS=page-types slabinfo page_owner_sort thp_swap_allocator_test
+BUILD_TARGETS=page-types slabinfo page_owner_sort thp_swap_allocator_test gup_bench
 INSTALL_TARGETS = $(BUILD_TARGETS) thpmaps
 
 LIB_DIR = ../lib/api
 LIBS = $(LIB_DIR)/libapi.a
 
-CFLAGS += -Wall -Wextra -I../lib/ -pthread
+CFLAGS += -Wall -Wextra -I../lib/ -I../.. -pthread
 LDFLAGS += $(LIBS) -pthread
 
 all: $(BUILD_TARGETS)
@@ -23,7 +23,7 @@ $(LIBS):
 	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
 
 clean:
-	$(RM) page-types slabinfo page_owner_sort thp_swap_allocator_test
+	$(RM) page-types slabinfo page_owner_sort thp_swap_allocator_test gup_bench
 	make -C $(LIB_DIR) clean
 
 sbindir ?= /usr/sbin
diff --git a/tools/mm/gup_bench.c b/tools/mm/gup_bench.c
new file mode 100644
index 000000000000..2806ee0d7453
--- /dev/null
+++ b/tools/mm/gup_bench.c
@@ -0,0 +1,491 @@
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
+#include <assert.h>
+#include <stdbool.h>
+#include <stdatomic.h>
+#include <limits.h>
+#include <mm/gup_test.h>
+#include <string.h>
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
+/*
+ * Local HugeTLB setup helpers for gup_bench.
+ *
+ * These helpers were copied from tools/testing/selftests/mm/ and adjusted to
+ * remove the ksft formatting. Keep this copy local so tools/mm does not
+ * depend on ksft output behavior.
+ */
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
+static unsigned long default_huge_page_size(void)
+{
+	FILE *f = fopen("/proc/meminfo", "r");
+	unsigned long hpage_size = 0;
+	char buf[256];
+
+	if (!f)
+		return 0;
+	while (fgets(buf, sizeof(buf), f)) {
+		if (sscanf(buf, "Hugepagesize:       %lu kB", &hpage_size) == 1)
+			break;
+	}
+	fclose(f);
+	hpage_size <<= 10;
+	return hpage_size;
+}
+
+static void hugetlb_sysfs_path(char *buf, size_t buflen,
+			       unsigned long size, const char *attr)
+{
+	snprintf(buf, buflen, "/sys/kernel/mm/hugepages/hugepages-%lukB/%s",
+		 size / 1024, attr);
+}
+
+static unsigned long hugetlb_read_num(const char *path)
+{
+	char buf[32];
+	FILE *f = fopen(path, "r");
+	unsigned long val = 0;
+
+	if (!f)
+		return 0;
+	if (fgets(buf, sizeof(buf), f))
+		val = strtoul(buf, NULL, 10);
+	fclose(f);
+	return val;
+}
+
+static void hugetlb_write_num(const char *path, unsigned long num)
+{
+	FILE *f = fopen(path, "w");
+
+	if (!f)
+		return;
+	fprintf(f, "%lu\n", num);
+	fclose(f);
+}
+
+static unsigned long hugetlb_nr_pages(unsigned long size)
+{
+	char path[PATH_MAX];
+
+	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
+	return hugetlb_read_num(path);
+}
+
+static void hugetlb_set_nr_pages(unsigned long size, unsigned long nr)
+{
+	char path[PATH_MAX];
+
+	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
+	hugetlb_write_num(path, nr);
+}
+
+static unsigned long hugetlb_free_pages(unsigned long size)
+{
+	char path[PATH_MAX];
+
+	hugetlb_sysfs_path(path, sizeof(path), size, "free_hugepages");
+	return hugetlb_read_num(path);
+}
+
+/* Saved pool size to restore on exit */
+static unsigned long hugetlb_saved_nr;
+static unsigned long hugetlb_saved_size;
+
+static void hugetlb_restore_atexit(void)
+{
+	if (hugetlb_saved_size)
+		hugetlb_set_nr_pages(hugetlb_saved_size, hugetlb_saved_nr);
+}
+
+static bool __hugetlb_setup(unsigned long size, unsigned long nr)
+{
+	unsigned long free = hugetlb_free_pages(size);
+	unsigned long total = hugetlb_nr_pages(size);
+
+	if (free >= nr)
+		return true;
+
+	hugetlb_set_nr_pages(size, total + (nr - free));
+
+	return hugetlb_free_pages(size) >= nr;
+}
+
+static bool hugetlb_setup_default(unsigned long nr)
+{
+	unsigned long hsize = default_huge_page_size();
+
+	if (!hsize)
+		return false;
+
+	/* Save current pool so we can restore it on exit (only on first call) */
+	if (!hugetlb_saved_size) {
+		hugetlb_saved_size = hsize;
+		hugetlb_saved_nr = hugetlb_nr_pages(hsize);
+		atexit(hugetlb_restore_atexit);
+	}
+
+	return __hugetlb_setup(hsize, nr);
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
+	assert(tid);
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
+		case 'j':
+			run.nthreads = atoi(optarg);
+			break;
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


