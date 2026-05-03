Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 601B2CD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 12:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1A636B0005; Sun,  3 May 2026 08:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB656B008A; Sun,  3 May 2026 08:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA906B0092; Sun,  3 May 2026 08:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 749C36B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:42:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AB5D1605E8
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:42:44 +0000 (UTC)
X-FDA: 84726072648.06.F0AF642
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf12.hostedemail.com (Postfix) with ESMTP id 03FCC40002
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:42:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777812162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pumy/lFLWMtj1IZZ0yExX8Z/+JX3vX2fk0y6LprUvF8=;
	b=BLxBik0cnewdbnK31j1NVKjkEuWWKun8RFSCup5PlzY1vWvJsghtdSA8cLfXhZRmm6No7J
	GSzEYrhoyZBVZ0h5t+jC1xJVQtyfpKEo2MV02YLZgdfCLdblEhdetRSmIDj5widTEdDyW5
	etGON8Q6wL2dlOrvmNp545ufaSP4knY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777812162; a=rsa-sha256;
	cv=none;
	b=KP1jnmQd7WPjaL3a+Mjb7OMwSUgqCDaARMy9vV4M9gICwg4Hfr+7O2jDv7zQmlJE8m+cAf
	6v5X+tUqCUbB9OovmnfizwbNSiTQ5ZMYP0mxNcrHPZYYxuFPJJcKBr3+doTlN7/kvZ5SKY
	T2dhU9Z+uqaH//YPO2KjxMFCrWhbZF4=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4g7kvJ3jwcz7QYRR;
	Sun, 03 May 2026 20:42:36 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 643CgR3p017591;
	Sun, 3 May 2026 20:42:27 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 3 May 2026 20:42:29 +0800 (CST)
X-Zmail-TransId: 2afb69f742b5f35-4cc0a
X-Mailer: Zmail v1.0
Message-ID: <20260503204229576-jholQsdeuUrbvCpv2PfI@zte.com.cn>
In-Reply-To: <20260503203538194jFwVGloy43M1F3sQGaFt7@zte.com.cn>
References: 20260503203538194jFwVGloy43M1F3sQGaFt7@zte.com.cn
Date: Sun, 3 May 2026 20:42:29 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <xu.xin16@zte.com.cn>, <akpm@linux-foundation.org>, <david@kernel.org>,
        <ljs@kernel.org>
Cc: <hughd@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <michel@lespinasse.org>
Subject: =?UTF-8?B?W1BBVENIIHY0IDIvNV0gdG9vbHMvdGVzdGluZzogYWRkIHJtYXAgd2FsayBsYXRlbmN5IGJlbmNobWFyayBmb3LCoEtTTSwgYW5vbnltb3VzIGFuZCBmaWxlIHBhZ2Vz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 643CgR3p017591
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Sun, 03 May 2026 20:42:36 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69F742BC.000/4g7kvJ3jwcz7QYRR
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 03FCC40002
X-Stat-Signature: n8ibqyofdu1nnoybpzfryaybzxf7td9k
X-HE-Tag: 1777812160-173386
X-HE-Meta: U2FsdGVkX18g+tvFE1vIJ7fN3b4LzoCfwpLlRFpFcxDCVRG3KHpCDam6JLPX8BvHMQu6GME9tfnB9Xu1FfE/hk+DkVgh55epoC+UxnCPVui2JJ0KT6vJrUIc2W6fBwv8j9sQuhWBlirofSXVfNsQZjlYqwPV+b9Kgr8PIHI/nMF6cUezo2vDl9PW+iZc/R/j4HID/QsyBK+CKbkbb6Sm3cVW+87vru7/7wUb3sJbeg5H9amuyuopcxzBf/J/mWb78qfhfbC2MgKNNOXqy9qzDQRqxJpHalWeh++jKCRotNn61oegOkRG+QZ11pllo2hWAUdnRF3RtQJjw8iy+6l+uWvh2PfrX4QXK+eAsOLNP4WTocj7TgHsNSNQ5xUNefctgehiloTrPClt4FFLh/yTz5jFk8elY+Tvo39DAed+EYBvdDHgxPmcFRBlnbW5sPl2E4CxYdCx9JTMUy3AY5iih99fKTp2EB6zdYZ0q0JqFXzOu5jM0W5WdYju0VYijYKpHW6QG6g2w9HWqdE3mB4y/hSvGanSCeY0spaIxT6U6jUVGK16HqOuMXdsnCJ49k1CzT15z1/OTxTw171PR0f9eCz+gZ9sReSLZ9LYWfud6RcfvZ8/OKhdHYWdbnDqQvgVR5amlz5tYNG5pIY+xUjF67rhykNW0Yy+kwFtx9lrz2PFP+J5+PTsUvMDdeL5XK0B1KtQWMCwGhYx8Hy6Zg4e28TgyzINTvkeh1d4RaEEnn/R4EYw9Toh/b+BpJUMrOmj73PLc1YwAOSu9KTdo0xIxRWoMftie0qgblOn4u88z+55mKsT33IPZojzl0MWmXLdvOWlm9jE0ab98y5JWrhp5b5J9Teg99eLzMcxRAMTSx/x4BU9Qzu9fBBqn1jJDnAI+D1D81+lYLwqHDIK7PU/OlguKYVOqusHxXac030pq7t/PhFiFM0tA3DxKp5DgCiy4wIJoShQaPtU+ic7r/V
 9eCPf3Rv
 D7Rdyo95tpxwocJOrUqa80SYlkGL8hu+w12lMOkEAgqq+1IXC0ttTPfFlhNs7acgBZ0ykm0EiThJ4RmOEM4efsGnKxZ9MZIvtZr1TN7sgK5Jj6fk1qeeiWpMXEK06tl9Ho42tijHFmmTlDywKnns02kP3NjfSRrdKxhunyaZW1Ml05doXhahvHxzUCk3ZlpPz3N6lez7lSQ+nHEoosPrKVCnn88nLKKpdbMDMwA/0QR13t4ias/434vmKsXjG+igQtxtbxhf/vN261vuLMKev5bN9iWH/ysWGPfX1uCZnkJPMratuc8ZVgis3IxRo/Tvno6Vx3J6aVqUAMPcLjlPV/dANrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

When a physical page is shared among many VMAs (e.g., KSM merging or
fork with COW), reverse mapping traversal (rmap_walk) can become a
performance bottleneck. The cost of walking the stable_node->hlist and
checking each VMA's page tables increases linearly with the number of
sharers. KSM pages that are merged across many processes are especially
vulnerable.

Add a new benchmark that measures rmap_walk latency under controlled
conditions. The test creates a large region (20,000 pages by default),
optionally splits the VMA into many small VMAs by mprotect(PROT_READ)
on every other page, then triggers rmap_walk via move_pages() (or mbind
if NUMA is not available). The existing rmap_walk tracepoint
(events/rmap/rmap_walk) is used to collect duration_ns for events
with page_type=ksm, page_type=anon, and page_type=file.

Three separate test cases are run:

KSM pages: allocate an anonymous region, fill with identical data,
mark MADV_MERGEABLE, wait for KSM to merge all pages (by polling
/sys/kernel/mm/ksm/full_scans), then trigger migration.

Anonymous pages: similar but without KSM merging.

File pages: mmap a temporary file with shared mapping and fill with
identical data.

For each test, the program prints the number of captured events and
the maximum / average latency in milliseconds.

This benchmark helps developers evaluate optimizations in the reverse
mapping code, such as limiting max_page_sharing or improving tree
traversal efficiency.

Usage (must be run as root):
cd tools/testing/rmap/ && make
sudo ./rmap_bench
=== Testing KSM pages ===
Triggering rmap_walk via move_pages...
KSM rmap_walk latency:
  Maximum duration: 705.12 ms (705119858 ns)
  Average duration: 532.04 ms (532041586 ns)
  Count: 4 events

=== Testing anonymous pages ===
Triggering rmap_walk via move_pages...
Anonymous page rmap_walk latency:
  Maximum duration: 0.07 ms (69329 ns)
  Average duration: 0.05 ms (48287 ns)
  Count: 2 events

=== Testing file pages ===
Triggering rmap_walk via move_pages...
File page rmap_walk latency:
  Maximum duration: 0.07 ms (67090 ns)
  Average duration: 0.03 ms (30082 ns)
  Count: 4 events

By the way, update the section of REVERSE MAPPING in MAINTAINERS.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 MAINTAINERS                         |   3 +
 tools/testing/rmap/Makefile         |  11 +
 tools/testing/rmap/rmap_benchmark.c | 488 ++++++++++++++++++++++++++++
 3 files changed, 502 insertions(+)
 create mode 100644 tools/testing/rmap/Makefile
 create mode 100644 tools/testing/rmap/rmap_benchmark.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8e7268d2f6ec..01cc34cc83a2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17006,11 +17006,14 @@ R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Harry Yoo <harry@kernel.org>
 R:	Jann Horn <jannh@google.com>
+R:	Xu Xin <xu.xin16@zte.com.cn>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/rmap.h
+F:	include/trace/events/rmap.h
 F:	mm/page_vma_mapped.c
 F:	mm/rmap.c
+F:	tools/testing/rmap/rmap_benchmark.c
 F:	tools/testing/selftests/mm/rmap.c

 MEMORY MANAGEMENT - SECRETMEM
diff --git a/tools/testing/rmap/Makefile b/tools/testing/rmap/Makefile
new file mode 100644
index 000000000000..200bd364cafb
--- /dev/null
+++ b/tools/testing/rmap/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0
+CC := $(CROSS_COMPILE)gcc
+
+PROGS := rmap_benchmark
+
+all: $(PROGS)
+
+rmap_benchmark: LDLIBS = -lnuma
+
+clean:
+	rm -fr $(PROGS)
diff --git a/tools/testing/rmap/rmap_benchmark.c b/tools/testing/rmap/rmap_benchmark.c
new file mode 100644
index 000000000000..5bbeb26fb2b8
--- /dev/null
+++ b/tools/testing/rmap/rmap_benchmark.c
@@ -0,0 +1,488 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Reverse mapping latency test for KSM, anonymous and file pages
+ *
+ * This program creates a large number of pages (KSM merged, normal anonymous,
+ * or file mapped), splits the VMA into many small VMAs via mprotect,
+ * triggers rmap_walk by move_pages(), and collects latency data from the
+ * tracepoint 'rmap_walk'.
+ *
+ * Usage: must be run as root (to access tracefs and KSM sysfs).
+ *
+ * Copyright 2026, ZTE Corp.
+ *
+ * Author(s): Xu Xin <xu.xin16@zte.com.cn>
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <sys/mount.h>
+#include <numaif.h>
+#include <numa.h>
+#include <time.h>
+#include <ctype.h>
+
+/* Page size and test parameters */
+#define PAGE_SIZE		4096
+#define NR_PAGES		20000	/* Number of virtual pages */
+#define TEST_PATTERN		0xaa
+
+/* KSM sysfs paths */
+#define KSM_RUN_PATH		"/sys/kernel/mm/ksm/run"
+#define KSM_SLEEP_MS_PATH	"/sys/kernel/mm/ksm/sleep_millisecs"
+#define KSM_PAGES_TO_SCAN	"/sys/kernel/mm/ksm/pages_to_scan"
+#define KSM_FULL_SCANS_PATH	"/sys/kernel/mm/ksm/full_scans"
+
+/* Tracepoint control paths */
+#define TRACE_ENABLE		"/sys/kernel/tracing/events/rmap/rmap_walk/enable"
+#define TRACE_FILE		"/sys/kernel/tracing/trace"
+
+/*
+ * Page types for rmap_walk tracepoint filtering
+ */
+enum page_type {
+	PAGE_TYPE_KSM,
+	PAGE_TYPE_ANON,
+	PAGE_TYPE_FILE,
+};
+
+static const char *page_type_str(enum page_type type)
+{
+	switch (type) {
+	case PAGE_TYPE_KSM:	return "ksm";
+	case PAGE_TYPE_ANON:	return "anon";
+	case PAGE_TYPE_FILE:	return "file";
+	default:		return "unknown";
+	}
+}
+
+/*
+ * Write a string to a sysfs file.
+ */
+static int write_sys(const char *path, const char *value)
+{
+	int fd;
+	ssize_t ret;
+
+	fd = open(path, O_WRONLY);
+	if (fd < 0) {
+		fprintf(stderr, "open %s failed: %s\n", path, strerror(errno));
+		return -1;
+	}
+	ret = write(fd, value, strlen(value));
+	close(fd);
+	if (ret != (ssize_t)strlen(value)) {
+		fprintf(stderr, "write %s failed: %s\n", path, strerror(errno));
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * Read an integer from a sysfs file.
+ */
+static int read_sys_int(const char *path)
+{
+	FILE *fp;
+	int val;
+
+	fp = fopen(path, "r");
+	if (!fp) {
+		fprintf(stderr, "fopen %s failed: %s\n", path, strerror(errno));
+		return -1;
+	}
+	if (fscanf(fp, "%d", &val) != 1) {
+		fprintf(stderr, "fscanf %s failed\n", path);
+		fclose(fp);
+		return -1;
+	}
+	fclose(fp);
+	return val;
+}
+
+/*
+ * Get KSM full scan count.
+ */
+static int ksm_get_full_scans(void)
+{
+	return read_sys_int(KSM_FULL_SCANS_PATH);
+}
+
+/*
+ * Wait for KSM to complete at least two full scans, which ensures that
+ * merging has had a chance to happen.
+ */
+static void wait_ksm_merge(void)
+{
+	int start_scans, end_scans;
+	int max_wait = 60;
+	int waited = 0;
+
+	start_scans = ksm_get_full_scans();
+	if (start_scans < 0) {
+		fprintf(stderr, "Failed to read initial full_scans\n");
+		return;
+	}
+
+	/* Make sure KSM is running */
+	if (write_sys(KSM_RUN_PATH, "1") < 0) {
+		fprintf(stderr, "Failed to start KSM\n");
+		return;
+	}
+
+	do {
+		sleep(1);
+		end_scans = ksm_get_full_scans();
+		if (end_scans < 0) {
+			fprintf(stderr, "Failed to read full_scans\n");
+			return;
+		}
+		waited++;
+		if (waited > max_wait) {
+			fprintf(stderr, "Warning: KSM full_scans not increased "
+				"after %d seconds\n", max_wait);
+			break;
+		}
+	} while (end_scans < start_scans + 2);
+}
+
+/*
+ * Enable the rmap_walk tracepoint and clear the trace buffer.
+ */
+static void enable_tracepoint(void)
+{
+	int fd;
+	struct stat st;
+
+	/* Check if tracefs is already accessible */
+	if (stat("/sys/kernel/tracing/trace", &st) != 0) {
+		/* Try to mount tracefs */
+		if (mount("tracefs", "/sys/kernel/tracing", "tracefs", 0, NULL) != 0) {
+			fprintf(stderr, "Warning: Failed to mount tracefs: %s\n",
+				strerror(errno));
+			/* Continue anyway, maybe it's already mounted elsewhere */
+		}
+	}
+
+	if (write_sys(TRACE_ENABLE, "1") < 0)
+		exit(1);
+	/* Truncate the trace file to clear old data */
+	fd = open(TRACE_FILE, O_WRONLY | O_TRUNC);
+	if (fd < 0) {
+		perror("open " TRACE_FILE);
+		exit(1);
+	}
+	close(fd);
+}
+
+/*
+ * Disable the rmap_walk tracepoint.
+ */
+static void disable_tracepoint(void)
+{
+	write_sys(TRACE_ENABLE, "0");
+}
+
+/*
+ * Parse the trace file and collect duration statistics for a given page_type.
+ * Returns 0 on success, -1 if no events found.
+ */
+static int parse_trace_and_print(enum page_type type, unsigned long long *max_ns,
+				 unsigned long long *avg_ns, int *count)
+{
+	FILE *fp;
+	char line[1024];
+	unsigned long long duration_ns;
+	unsigned long long max_val = 0;
+	unsigned long long sum = 0;
+	int cnt = 0;
+	const char *type_str = page_type_str(type);
+	char search_str[64];
+
+	snprintf(search_str, sizeof(search_str), "page_type=%s", type_str);
+
+	fp = fopen(TRACE_FILE, "r");
+	if (!fp) {
+		perror("fopen " TRACE_FILE);
+		return -1;
+	}
+
+	while (fgets(line, sizeof(line), fp)) {
+		char *dur = strstr(line, "duration_ns=");
+		char *type_match = strstr(line, search_str);
+
+		if (dur && type_match) {
+			char *end;
+
+			dur += 12;	/* skip "duration_ns=" */
+			duration_ns = strtoull(dur, &end, 10);
+			if (end != dur) {
+				if (duration_ns > max_val)
+					max_val = duration_ns;
+				sum += duration_ns;
+				cnt++;
+			}
+		}
+	}
+	fclose(fp);
+
+	if (cnt == 0) {
+		printf("No rmap_walk events with page_type=%s found.\n", type_str);
+		return -1;
+	}
+
+	*max_ns = max_val;
+	*avg_ns = sum / cnt;
+	*count = cnt;
+	return 0;
+}
+
+/*
+ * Trigger rmap_walk by moving a single page.
+ * region: pointer to the page (any page in the mapped region).
+ * The function will try to move that page to a different NUMA node.
+ */
+static void trigger_rmap_walk(void *region)
+{
+	int ret, status, cur_node, target_node;
+	void *pages[1];
+	int nodes[1];
+
+	printf("Triggering rmap_walk via move_pages...\n");
+
+	ret = move_pages(0, 1, (void **)&region, NULL, &status, MPOL_MF_MOVE_ALL);
+	if (ret != 0) {
+		perror("Failed to get original numa");
+		exit(1);
+	}
+	cur_node = status;
+
+	for (target_node = 0; target_node <= numa_max_node(); target_node++) {
+		if (numa_bitmask_isbitset(numa_all_nodes_ptr, target_node) &&
+		    target_node != cur_node)
+			break;
+	}
+	if (target_node > numa_max_node()) {
+		printf("Couldn't find available numa node for testing\n");
+		exit(1);
+	}
+
+	pages[0] = region;
+	nodes[0] = target_node;
+
+	/*
+	 * Note: We ignore the return value when ret >= 0, since there's probability
+	 * that ksmd's ksm_get_folio collides with do_move_page(), which cause
+	 * __migrate_folio failed due to the check "folio_ref_count(src) !=
+	 * expected_count".
+	 */
+	ret = move_pages(0, 1, pages, nodes, &status, MPOL_MF_MOVE_ALL);
+	if (ret < 0)
+		perror("move_pages");
+}
+
+/*
+ * Split a VMA into many small VMAs by changing protection on every other page.
+ * This increases the number of anon_vma_chain entries and makes rmap_walk slower.
+ */
+static void split_vma_with_mprotect(void *addr, size_t size)
+{
+	for (size_t i = 0; i < size / PAGE_SIZE; i++) {
+		if (i % 2 == 0) {
+			if (mprotect(addr + i * PAGE_SIZE, PAGE_SIZE, PROT_READ) < 0) {
+				if (errno != EACCES)
+					perror("mprotect");
+			}
+		}
+	}
+}
+
+/*
+ * Test for KSM pages.
+ */
+static void test_ksm(void)
+{
+	void *region;
+	size_t size = NR_PAGES * PAGE_SIZE;
+	unsigned long long max_ns, avg_ns;
+	int count;
+
+	printf("\n=== Testing KSM pages ===\n");
+
+	/* Stop KSM and set aggressive scan parameters */
+	if (write_sys(KSM_RUN_PATH, "2") < 0)
+		exit(1);
+	if (write_sys(KSM_SLEEP_MS_PATH, "0") < 0 ||
+	    write_sys(KSM_PAGES_TO_SCAN, "10000") < 0)
+		exit(1);
+
+	region = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (region == MAP_FAILED) {
+		perror("mmap for KSM");
+		exit(1);
+	}
+	memset(region, TEST_PATTERN, size);
+
+	if (madvise(region, size, MADV_MERGEABLE) != 0) {
+		perror("madvise MADV_MERGEABLE");
+		munmap(region, size);
+		exit(1);
+	}
+
+	/* Start KSM scanner */
+	if (write_sys(KSM_RUN_PATH, "1") < 0) {
+		munmap(region, size);
+		exit(1);
+	}
+
+	split_vma_with_mprotect(region, size);
+
+	/* Wait full merging */
+	wait_ksm_merge();
+
+	enable_tracepoint();
+	/* Move the page at offset PAGE_SIZE (any page is fine) */
+	trigger_rmap_walk(region + PAGE_SIZE);
+	usleep(100000);		/* allow trace to be written */
+	disable_tracepoint();
+
+	if (parse_trace_and_print(PAGE_TYPE_KSM, &max_ns, &avg_ns, &count) == 0) {
+		printf("KSM rmap_walk latency:\n");
+		printf("  Maximum duration: %.2f ms (%.0f ns)\n",
+		       max_ns / 1000000.0, (double)max_ns);
+		printf("  Average duration: %.2f ms (%.0f ns)\n",
+		       avg_ns / 1000000.0, (double)avg_ns);
+		printf("  Count: %d events\n", count);
+	}
+
+	munmap(region, size);
+	write_sys(KSM_RUN_PATH, "2");	/* stop KSM */
+}
+
+/*
+ * Test for normal anonymous pages.
+ */
+static void test_anon(void)
+{
+	void *region;
+	size_t size = NR_PAGES * PAGE_SIZE;
+	unsigned long long max_ns, avg_ns;
+	int count;
+
+	printf("\n=== Testing anonymous pages ===\n");
+
+	region = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (region == MAP_FAILED) {
+		perror("mmap for anonymous");
+		exit(1);
+	}
+	memset(region, TEST_PATTERN, size);
+
+	split_vma_with_mprotect(region, size);
+
+	enable_tracepoint();
+	trigger_rmap_walk(region + PAGE_SIZE);
+	usleep(100000);
+	disable_tracepoint();
+
+	if (parse_trace_and_print(PAGE_TYPE_ANON, &max_ns, &avg_ns, &count) == 0) {
+		printf("Anonymous page rmap_walk latency:\n");
+		printf("  Maximum duration: %.2f ms (%.0f ns)\n",
+		       max_ns / 1000000.0, (double)max_ns);
+		printf("  Average duration: %.2f ms (%.0f ns)\n",
+		       avg_ns / 1000000.0, (double)avg_ns);
+		printf("  Count: %d events\n", count);
+	}
+
+	munmap(region, size);
+}
+
+/*
+ * Test for file-backed pages (mmap of a temporary file).
+ */
+static void test_file(void)
+{
+	void *region;
+	size_t size = NR_PAGES * PAGE_SIZE;
+	int fd;
+	char filename[] = "/tmp/rmap_test_file_XXXXXX";
+
+	printf("\n=== Testing file pages ===\n");
+
+	fd = mkstemp(filename);
+	if (fd < 0) {
+		perror("mkstemp");
+		exit(1);
+	}
+	if (ftruncate(fd, size) < 0) {
+		perror("ftruncate");
+		unlink(filename);
+		close(fd);
+		exit(1);
+	}
+
+	region = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		      MAP_SHARED, fd, 0);
+	if (region == MAP_FAILED) {
+		perror("mmap for file");
+		unlink(filename);
+		close(fd);
+		exit(1);
+	}
+	memset(region, TEST_PATTERN, size);
+
+	split_vma_with_mprotect(region, size);
+
+	enable_tracepoint();
+	trigger_rmap_walk(region + PAGE_SIZE);
+	usleep(100000);
+	disable_tracepoint();
+
+	unsigned long long max_ns, avg_ns;
+	int count;
+
+	if (parse_trace_and_print(PAGE_TYPE_FILE, &max_ns, &avg_ns, &count) == 0) {
+		printf("File page rmap_walk latency:\n");
+		printf("  Maximum duration: %.2f ms (%.0f ns)\n",
+		       max_ns / 1000000.0, (double)max_ns);
+		printf("  Average duration: %.2f ms (%.0f ns)\n",
+		       avg_ns / 1000000.0, (double)avg_ns);
+		printf("  Count: %d events\n", count);
+	}
+
+	munmap(region, size);
+	unlink(filename);
+	close(fd);
+}
+
+int main(void)
+{
+	/* Need root for tracefs and KSM sysfs */
+	if (geteuid() != 0) {
+		fprintf(stderr, "This program must be run as root.\n");
+		exit(1);
+	}
+
+	if (numa_available() < 0)
+		printf("Warning: NUMA not available, move_pages may not work.\n");
+
+	/* Run three tests */
+	test_ksm();
+	test_anon();
+	test_file();
+
+	return 0;
+}
+
-- 
2.25.1

