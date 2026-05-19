Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA545CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 14:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24EAB6B0095; Tue, 19 May 2026 10:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2002B6B0096; Tue, 19 May 2026 10:11:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EEC36B0098; Tue, 19 May 2026 10:11:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF85F6B0095
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:11:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9210A40419
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:11:36 +0000 (UTC)
X-FDA: 84784357392.23.00F12FF
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf13.hostedemail.com (Postfix) with ESMTP id D649E20007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:11:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779199894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jHytmBv/b5jZOgeLKijgr9G/v9hA9nRWqlvXcrmNExc=;
	b=8CZAbldLe9n9HZDo1TmrqGCeopXwsKaE5mcSiHsCj6YT9Bk6JNVnQQl5MlnmjmPaAS1/B2
	YjytT3d+F1OwSbTCMd+7m9pkKMjfYc4Rg3zNZ+rlfLY4mgSKOpM5XlkRDBRQdSMRFylsi6
	m/rz7nkgvMEb//l4E2WtzzegPp7YNYY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779199894; a=rsa-sha256;
	cv=none;
	b=k/Fh1qDjICkHR1ZDBwd+TN69urbsK1RXHUqzQmjGJjdmZb1aFATh/byNJqEV2LyzbDJO3P
	NkJKpRa+kLvhE5GteKJe8PfmIY6VRcE82oUl2z8drDM/kly0Dw3lcBniptE3N0aRCNJkEz
	pjqN4pCPjlEzb8VBRM4FTXpnOVJrekw=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gKc6V6rGjz8Xrrc;
	Tue, 19 May 2026 22:11:30 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 64JEBLBK098928;
	Tue, 19 May 2026 22:11:21 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 19 May 2026 22:11:24 +0800 (CST)
X-Zmail-TransId: 2af96a0c6f8c669-fabe1
X-Mailer: Zmail v1.0
Message-ID: <20260519221124806bCFNrWzKpCZlGtL4guMKZ@zte.com.cn>
In-Reply-To: <20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn>
References: 20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn
Date: Tue, 19 May 2026 22:11:24 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <ljs@kernel.org>, <hughd@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <michel@lespinasse.org>,
        <corbet@lwn.net>, <wang.yaxin@zte.com.cn>, <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHY1IDIvNV0gdG9vbHMvdGVzdGluZzogYWRkIHJtYXAgd2FsayBsYXRlbmN5IGJlbmNobWFyaw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64JEBLBK098928
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 19 May 2026 22:11:30 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0C6F92.001/4gKc6V6rGjz8Xrrc
X-Stat-Signature: wgh3iiz1dfe6ob5prb7hywfq37htkqxa
X-Rspamd-Queue-Id: D649E20007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779199893-171416
X-HE-Meta: U2FsdGVkX18vaACgfRc2Xd1k4icsUOzwRYdPBUxmBh/5XtdkdaP8nuEANPDSS50vTl9Uw6XSk887Qbu19uswEYuVoROGwiHuQvPbXEFt913n1A8xVaPjDoGcC3O21XVz9Ut19MlCp62uqVCrzQmVYfKj3PTFf/4eugJ5z3S5rK3pA57IloigcPBrPb2nfnfyojJWFiqxhQxv1gtH0F0N6bvJqVdVKQfR9uDVZrlgPYP8ATnF5/tpSh8KVW0eTtoCAaVfWxOPYkTToKETRWKeWhLDITnmXrm7YVYGorbX//QLHC6L2F0jiKErxmjrv+AToSbhf6RBL95BjupVSjEJH6JKs7wxuatu2wBixvDuGQOyACuGv5BJOE/A8nsQ0bZFURDbs8umzpJcS3HLIVjnjfH/crKTa1NqClEUTFupw53uGqkJ/XKzqJHAN2lc4IcOjB3LXZgg+LKVvHpN9zFxoISjkr+yiZ6q7cCJotr6MKTvNCnCI38xoCCmcQeeVp2zPm+/CiwEkneN0XXF8FalIzZmLJRrawFsn+Y3qhBDSbt4Op5KOB9cBnIUc/KlKT6hhhMLGu+rJLK+kIN13gdCN0ZUcW+D51lbitwfsrEtLxQJ7vIr5K7/o81DRthSlv2YgCA6YNGvp1hJYR9V00+CgtJnYS8lC5CddOIRqnaNTi3P2LqGw9Y4528e5tt7JnxLPjDiLs399haqc7v67HhG2Njq9Hg5k6a4jjkAJNKUkWJTL7DwtyxGhztRcKBuKGkgkIMfSv1ZH66IaEBH6sl6QwjL8o4L5p2pwafwFIGcU7s+bQLb+qxJW6hCMWK4FwYs77SSayPdUBfSzYR9YQPXz6Wpd8rUd7iD8vx91cPz7AgVakMmtjx9Rqv+nUsEbGpWzM4XlmunMizDk4g61Q46H7+7h3V9+nOKZO5lNotdtFsn3zFDHiY2cZ0mOz0vBhHAcNl9VgVx0PKsPy7Fnvf
 efuKQPu2
 koWCsHJP9tujPLPpblrAkgFeWighoVr3OwOboIXtrWnKnMxAuRuoD6kZ26WSWlPkPhqn49rKzcuE2sA3ol3DT00YUijcPknjBfQZDZE4HsVAxmduVUZ1VgAFig1hO0uzmF8NEwVqPvNgvarZOS9ai854rLj9Ws8k/XQdZ94RBUEC7FHHb38llrJjdtbrXx/iSjmc0KKfN993JeOm75+1kz96iJfLIZfiP2amlKNMBBS1I3mi16lQ6hFjNe4z/J4R2BQwVrNJgPQ8gX8dypeQnyC7jIZmle9wEj0OF5L5RJV/I4VxPGtgjs2emYrsuXKXfZ+o1iyyV9tUBRj8TEVqh9sKPDxAYqSkyUuAhWQcQFBiXhhXZXgf2iAA+Kwv4zLHAfMz3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Add a new benchmark that measures rmap_walk latency under controlled
conditions. The test creates a large region (20,000 pages by default),
optionally splits the VMA into many small VMAs by mprotect(PROT_READ)
on every other page, then triggers rmap_walk via move_pages().
The existing rmap_walk tracepoints (events/rmap/rmap_walk_start and
events/rmap/rmap_walk_end) are used to collect duration for events with
page_type=ksm, page_type=anon, and page_type=file.

Three separate test cases are run:

- KSM pages: allocate an anonymous region, fill with identical data,
mark MADV_MERGEABLE, wait for KSM to merge all pages (by polling
/sys/kernel/mm/ksm/full_scans), then trigger migration.

- Anonymous pages: similar but without KSM merging.

- File pages: mmap a temporary file with shared mapping and fill with
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
  Maximum duration: 705.12 ms (705119 us)
  Average duration: 532.04 ms (532041 us)
  Count: 4 events

=== Testing anonymous pages ===
Triggering rmap_walk via move_pages...
Anonymous page rmap_walk latency:
  Maximum duration: 0.07 ms (69 us)
  Average duration: 0.05 ms (48 us)
  Count: 2 events

=== Testing file pages ===
Triggering rmap_walk via move_pages...
File page rmap_walk latency:
  Maximum duration: 0.07 ms (67 us)
  Average duration: 0.03 ms (30 us)
  Count: 4 events

By the way, update the section of REVERSE MAPPING in MAINTAINERS.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 MAINTAINERS                         |   3 +
 tools/testing/rmap/Makefile         |  11 +
 tools/testing/rmap/rmap_benchmark.c | 529 ++++++++++++++++++++++++++++
 3 files changed, 543 insertions(+)
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
index 000000000000..77dac93c794d
--- /dev/null
+++ b/tools/testing/rmap/rmap_benchmark.c
@@ -0,0 +1,529 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Reverse mapping latency test for KSM, anonymous and file pages
+ *
+ * This program creates a large number of pages (KSM merged, normal anonymous,
+ * or file mapped), splits the VMA into many small VMAs via mprotect,
+ * triggers rmap_walk by move_pages(), and collects latency data from the
+ * tracepoints 'rmap_walk_start' and 'rmap_walk_end' (offline timestamp diff).
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
+int page_size;
+#define NR_PAGES		20000	/* Number of virtual pages */
+#define TEST_PATTERN		0xaa
+
+/* KSM sysfs paths */
+#define KSM_RUN_PATH		"/sys/kernel/mm/ksm/run"
+#define KSM_SLEEP_MS_PATH	"/sys/kernel/mm/ksm/sleep_millisecs"
+#define KSM_PAGES_TO_SCAN	"/sys/kernel/mm/ksm/pages_to_scan"
+#define KSM_FULL_SCANS_PATH	"/sys/kernel/mm/ksm/full_scans"
+
+/* Tracepoint control paths - enable all events under rmap */
+#define TRACE_ENABLE		"/sys/kernel/tracing/events/rmap/enable"
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
+ * Enable the rmap tracepoints and clear the trace buffer.
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
+ * Disable the rmap tracepoints.
+ */
+static void disable_tracepoint(void)
+{
+	write_sys(TRACE_ENABLE, "0");
+}
+
+/*
+ * Extract timestamp from a trace line (the 5th field, before colon).
+ * Returns timestamp in microseconds.
+ */
+static unsigned long long extract_timestamp_us(const char *line)
+{
+	char time_str[32];
+	double ts_sec = 0.0;
+
+	/* %*s skip first field (task-name), second field (PID in brackets? Actually "[CPU]"?
+	 * The format is: <COMM>-<PID> [CPU] FLAGS TIMESTAMP: ...
+	 * Example: "rmap_benchmark_-467     [003] ..... 17258.057760: rmap_walk_start: ..."
+	 * Split by whitespace:
+	 * 0: "rmap_benchmark_-467"
+	 * 1: "[003]"
+	 * 2: "....."
+	 * 3: "17258.057760:"  <-- timestamp with colon
+	 * Therefore timestamp is the 4th field (index 3). But careful: there might be extra spaces.
+	 * So we need to skip three fields: %*s %*s %*s, then read the timestamp string.
+	 */
+	if (sscanf(line, "%*s %*s %*s %31s", time_str) == 1) {
+		/* Remove trailing colon if present */
+		char *colon = strchr(time_str, ':');
+
+		if (colon)
+			*colon = '\0';
+		ts_sec = strtod(time_str, NULL);
+	}
+	return (unsigned long long)(ts_sec * 1e6);
+}
+
+/*
+ * Parse the trace file and compute latency from start/end events for a given page_type.
+ * Returns 0 on success, -1 if no matching events.
+ */
+static int parse_trace_and_print(enum page_type type, unsigned long long *max_us,
+				 unsigned long long *avg_us, int *count)
+{
+	FILE *fp;
+	char line[1024];
+	unsigned long long start_ts = 0;
+	unsigned long long delta;
+	unsigned long long sum = 0, max_val = 0;
+	int pairs = 0;
+	const char *type_str = page_type_str(type);
+	char type_pattern[64];
+
+	snprintf(type_pattern, sizeof(type_pattern), "page_type=%s", type_str);
+
+	fp = fopen(TRACE_FILE, "r");
+	if (!fp) {
+		perror("fopen " TRACE_FILE);
+		return -1;
+	}
+
+	while (fgets(line, sizeof(line), fp)) {
+		/* Check if line contains our page_type */
+		if (!strstr(line, type_pattern))
+			continue;
+
+		if (strstr(line, "rmap_walk_start:")) {
+			start_ts = extract_timestamp_us(line);
+		} else if (strstr(line, "rmap_walk_end:")) {
+			if (start_ts) {
+				unsigned long long end_ts = extract_timestamp_us(line);
+
+				if (end_ts > start_ts) {
+					delta = end_ts - start_ts;
+					sum += delta;
+					if (delta > max_val)
+						max_val = delta;
+					pairs++;
+				}
+				start_ts = 0; /* reset after pairing */
+			}
+		}
+	}
+	fclose(fp);
+
+	if (pairs == 0) {
+		printf("No rmap_walk events with page_type=%s found.\n", type_str);
+		return -1;
+	}
+
+	*max_us = max_val;
+	*avg_us = sum / pairs;
+	*count = pairs;
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
+	for (size_t i = 0; i < size / page_size; i++) {
+		if (i % 2 == 0) {
+			if (mprotect(addr + i * page_size, page_size, PROT_READ) < 0) {
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
+	size_t size = NR_PAGES * page_size;
+	unsigned long long max_us, avg_us;
+	int count;
+
+	printf("\n=== Testing KSM pages ===\n");
+
+	/* Stop KSM and set aggressive scan parameters */
+	if (write_sys(KSM_RUN_PATH, "2") < 0) {
+		printf("Warning: CONFIG_KSM might be not build, skip testing.\n");
+		return;
+	}
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
+	/* Move the page at offset page_size (any page is fine) */
+	trigger_rmap_walk(region + page_size);
+	usleep(100000);		/* allow trace to be written */
+	disable_tracepoint();
+
+	if (parse_trace_and_print(PAGE_TYPE_KSM, &max_us, &avg_us, &count) == 0) {
+		printf("KSM rmap_walk latency:\n");
+		printf("  Maximum duration: %.2f ms (%.0f us)\n",
+		       max_us / 1000.0, (double)max_us);
+		printf("  Average duration: %.2f ms (%.0f us)\n",
+		       avg_us / 1000.0, (double)avg_us);
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
+	size_t size = NR_PAGES * page_size;
+	unsigned long long max_us, avg_us;
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
+	trigger_rmap_walk(region + page_size);
+	usleep(100000);
+	disable_tracepoint();
+
+	if (parse_trace_and_print(PAGE_TYPE_ANON, &max_us, &avg_us, &count) == 0) {
+		printf("Anonymous page rmap_walk latency:\n");
+		printf("  Maximum duration: %.2f ms (%.0f us)\n",
+		       max_us / 1000.0, (double)max_us);
+		printf("  Average duration: %.2f ms (%.0f us)\n",
+		       avg_us / 1000.0, (double)avg_us);
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
+	size_t size = NR_PAGES * page_size;
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
+	trigger_rmap_walk(region + page_size);
+	usleep(100000);
+	disable_tracepoint();
+
+	unsigned long long max_us, avg_us;
+	int count;
+
+	if (parse_trace_and_print(PAGE_TYPE_FILE, &max_us, &avg_us, &count) == 0) {
+		printf("File page rmap_walk latency:\n");
+		printf("  Maximum duration: %.2f ms (%.0f us)\n",
+		       max_us / 1000.0, (double)max_us);
+		printf("  Average duration: %.2f ms (%.0f us)\n",
+		       avg_us / 1000.0, (double)avg_us);
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
+	page_size = getpagesize();
+
+	/* Need root for tracefs and KSM sysfs */
+	if (geteuid() != 0) {
+		fprintf(stderr, "This program must be run as root.\n");
+		exit(1);
+	}
+
+	if (numa_available() < 0) {
+		printf("Warning: NUMA not available, move_pages may not work.\n");
+		exit(1);
+	}
+
+	/* Run three tests */
+	test_ksm();
+	test_anon();
+	test_file();
+
+	return 0;
+}
-- 
2.25.

