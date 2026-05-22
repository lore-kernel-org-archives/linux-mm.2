Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37D19CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 02:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842566B0093; Thu, 21 May 2026 22:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3146B0095; Thu, 21 May 2026 22:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7086A6B0096; Thu, 21 May 2026 22:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D45C6B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:57:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 091051209C9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:57:07 +0000 (UTC)
X-FDA: 84793544094.15.EDC27C7
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8A376A0002
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:57:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf25.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779418625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mBlHkSBgsmAQ7yWqHeoHCPrZSwt1kfetEya0+ZmjYRs=;
	b=hMtqfwJEKt2eeH1bjykIBB3NKtfXqnjktAxBE4tVwe8+FeRCVyGBAkZEFzNkFIj6Bn1gEI
	lQI3XKwgmG0U6ktuqScKp9zz1kweNpZsnbwZ1ZsNoO0Nx2X1M9pfXYZT+1F7SyFdDJxPCh
	w4FwglICpN4Ff8B8T4iqPRKu5r8W0cM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779418625; a=rsa-sha256;
	cv=none;
	b=IbLNFlvv6G0pe4Vqu3iuMy1AFSZM+iKexHeVQzYYRzw78gVEvQHYjp5qUnWzYnbLN/QI+m
	IUNiwoYmTS5mTbgUoySjXgSz7Oxcfw/e0Xtja+odDRvSIVOVXZhzAkYEfwTHn+o3WrBbSV
	VvNx7rhCxDo741etOCZkexnidXpzFz8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf25.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gM90q6KHkz51Srq;
	Fri, 22 May 2026 10:56:59 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 64M2un9r020614;
	Fri, 22 May 2026 10:56:49 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 22 May 2026 10:56:50 +0800 (CST)
X-Zmail-TransId: 2afc6a0fc5f225e-0b7d5
X-Mailer: Zmail v1.0
Message-ID: <20260522105650750eZ1hZ7TTa353dYy_uXG3i@zte.com.cn>
In-Reply-To: <20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn>
References: 20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn
Date: Fri, 22 May 2026 10:56:50 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <corbet@lwn.net>
Subject: =?UTF-8?B?W1BBVENIIHY2IDIvNl0gdG9vbHMvdGVzdGluZzogYWRkIHJtYXAgd2FsayBsYXRlbmN5IGJlbmNobWFyayBmb3LCoEtTTSwgYW5vbnltb3VzIGFuZCBmaWxlIHBhZ2Vz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64M2un9r020614
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 22 May 2026 10:56:59 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0FC5FB.001/4gM90q6KHkz51Srq
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A376A0002
X-Stat-Signature: payuf1eeupygt8cpkkjbcig1qhx56u1z
X-Rspamd-Server: rspam06
X-HE-Tag: 1779418624-668204
X-HE-Meta: U2FsdGVkX1+STI5mtbfFY4F38L7TIL24p2fZBhxS79UeNng8hs/Juk0WUSM8cCxREpGzMOXIJR6cB8+QMHbBlFnEmEKM4rARgC0kDObBI491smV9g3FQhljwqEWj07K2JubLvRacfCaOxXWapttQbdBDFJusQKbcp+VBp9740u52psw5Do5kF55Qgt0QdzdRDOA8/XGlNKWO95zztd8XmeYGE0AQNXqLyb1wisT3VrczmX0jKevx61wJkcm/dlEPOMnR0zRZOSaBKxB4pLXJqfbRB65dd26fwDlYeCHo2oZJNBanXR55P4CSqsNimzZ82HGietzKDbU/zAHk4wnfOEzdKbgxESylHA830XcTSdmtCEaBVIRkzcRkxDKfUVn2I2/URAdwJ99KDBkIBn26x0X/N0tKNIYRQWmemivNvuw/GjU62yDrpKm3MBPEsFr4Ut2S6E5aU7cFV1V5D43spw0gN5B/gvud7emKczVLmykzv2RKLez1j75e5C1vufYcbY9SvFtfHlOiLf5iAD5hijoCrMHc76IweK0Vbava8H1RmcaAvJ7EwrSK9P1+nXmbmX3XB/OL5rwYvXf9YFDnqM5z/KMttSM8roSto/jwNpogn041tAPeRZFiTttysCGZll7jREm/j14r2wC2HcLW9eFSr1tFRkv68GMsXgby5xHQ+aGrg6bJ7cTGVXtDVZZBufSVlM+I9UL6AFdWHOkDYy4b6mL/Ts0zDsJFDzjxJ/BIDYLb/2uUEJS4tEdciSDFgb36Sd61rYosxh2FcB+jOT8baflzkhvjCNU1jI8DKKAvOw++YH9bOyhojRWS7+jjkfUnPU8xR3vN95CDYU1ILdoPU75bkIOwT6hGk3KZXmJdzZsfs13dzQyQdjspFVCeytfSm/wZlCpFQfvmy/aaThRdZ6MySyzAsfDXTdfPrS4lPfiESGvLxp9O8Y+snAr2EHCMJ07+F/H7kSZ1+lL
 xIsr3ejy
 6NTxLtk9Ig3OkhM61ESRpH31RT11NOUoGYxKLZ1OKbGAM5mHUVqNUWT8oJsnvb3wDb//6wlytiq/fG7aYRnUVvAB60T6T3simOMiAVRj2LntvJ+3jyIKY0Rlguk5nhQuxmuaccF/V84WunpTxT9kVRB+4DpP7VqqeFfYTdhuUk6ITPEY=
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

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 tools/testing/rmap/Makefile         |  11 +
 tools/testing/rmap/rmap_benchmark.c | 461 ++++++++++++++++++++++++++++
 2 files changed, 472 insertions(+)
 create mode 100644 tools/testing/rmap/Makefile
 create mode 100644 tools/testing/rmap/rmap_benchmark.c

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
index 000000000000..b163f4d6aec3
--- /dev/null
+++ b/tools/testing/rmap/rmap_benchmark.c
@@ -0,0 +1,461 @@
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
+/* Helper: read/write sysfs */
+static int write_sys(const char *path, const char *value)
+{
+	int fd = open(path, O_WRONLY);
+	if (fd < 0) {
+		fprintf(stderr, "open %s failed: %s\n", path, strerror(errno));
+		return -1;
+	}
+	ssize_t ret = write(fd, value, strlen(value));
+	close(fd);
+	if (ret != (ssize_t)strlen(value)) {
+		fprintf(stderr, "write %s failed: %s\n", path, strerror(errno));
+		return -1;
+	}
+	return 0;
+}
+
+static int read_sys_int(const char *path, int *val)
+{
+	FILE *fp = fopen(path, "r");
+	if (!fp)
+		return -1;
+	if (fscanf(fp, "%d", val) != 1) {
+		fclose(fp);
+		return -1;
+	}
+	fclose(fp);
+	return 0;
+}
+
+/* KSM full scan count */
+static int ksm_get_full_scans(void)
+{
+	int val;
+	if (read_sys_int(KSM_FULL_SCANS_PATH, &val))
+		return -1;
+	return val;
+}
+
+/* Wait for KSM full scans */
+static void wait_ksm_merge(void)
+{
+	int start_scans, end_scans;
+	int max_wait = 60, waited = 0;
+
+	start_scans = ksm_get_full_scans();
+	if (start_scans < 0) {
+		fprintf(stderr, "Failed to read initial full_scans\n");
+		return;
+	}
+	if (write_sys(KSM_RUN_PATH, "1") < 0) {
+		fprintf(stderr, "Failed to start KSM\n");
+		return;
+	}
+	do {
+		sleep(1);
+		end_scans = ksm_get_full_scans();
+		if (end_scans < 0)
+			return;
+		waited++;
+		if (waited > max_wait) {
+			fprintf(stderr, "Warning: KSM full_scans not increased after %ds\n", max_wait);
+			break;
+		}
+	} while (end_scans < start_scans + 2);
+}
+
+/* Tracepoint enable/disable */
+static void enable_tracepoint(void)
+{
+	struct stat st;
+	if (stat("/sys/kernel/tracing/trace", &st) != 0) {
+		if (mount("tracefs", "/sys/kernel/tracing", "tracefs", 0, NULL) != 0)
+			fprintf(stderr, "Warning: mount tracefs failed: %s\n", strerror(errno));
+	}
+	if (write_sys(TRACE_ENABLE, "1") < 0)
+		exit(1);
+	int fd = open(TRACE_FILE, O_WRONLY | O_TRUNC);
+	if (fd < 0) {
+		perror("open " TRACE_FILE);
+		exit(1);
+	}
+	close(fd);
+}
+
+static void disable_tracepoint(void)
+{
+	write_sys(TRACE_ENABLE, "0");
+}
+
+/* Timestamp extraction (us) */
+static unsigned long long extract_timestamp_us(const char *line)
+{
+	char time_str[32];
+	double ts_sec = 0.0;
+	if (sscanf(line, "%*s %*s %*s %31s", time_str) == 1) {
+		char *colon = strchr(time_str, ':');
+		if (colon) *colon = '\0';
+		ts_sec = strtod(time_str, NULL);
+	}
+	return (unsigned long long)(ts_sec * 1e6);
+}
+
+/* Safe start/end pairing using folio and rwc addresses */
+struct pending_start {
+	unsigned long long ts;
+	unsigned long folio;
+	unsigned long rwc;
+};
+
+static int parse_trace_and_print(enum page_type type, unsigned long long *max_us,
+				 unsigned long long *avg_us, int *count)
+{
+	FILE *fp = fopen(TRACE_FILE, "r");
+	if (!fp) {
+		perror("fopen " TRACE_FILE);
+		return -1;
+	}
+
+	char line[1024];
+	struct pending_start pending[128];
+	int pending_cnt = 0;
+	unsigned long long sum = 0, max_val = 0;
+	int pairs = 0;
+	const char *type_str = page_type_str(type);
+	char type_pattern[64];
+	snprintf(type_pattern, sizeof(type_pattern), "page_type=%s", type_str);
+
+	while (fgets(line, sizeof(line), fp)) {
+		if (!strstr(line, type_pattern))
+			continue;
+
+		/* Extract folio and rwc addresses */
+		unsigned long folio = 0, rwc = 0;
+		char *folio_str = strstr(line, "folio=");
+		char *rwc_str = strstr(line, "rwc=");
+		if (folio_str && rwc_str) {
+			folio = strtoul(folio_str + 6, NULL, 16);
+			rwc = strtoul(rwc_str + 4, NULL, 16);
+		} else {
+			continue;
+		}
+
+		if (strstr(line, "rmap_walk_start:")) {
+			if (pending_cnt < 128) {
+				pending[pending_cnt].ts = extract_timestamp_us(line);
+				pending[pending_cnt].folio = folio;
+				pending[pending_cnt].rwc = rwc;
+				pending_cnt++;
+			}
+		} else if (strstr(line, "rmap_walk_end:")) {
+			unsigned long long end_ts = extract_timestamp_us(line);
+			/* Find matching start event */
+			for (int i = 0; i < pending_cnt; i++) {
+				if (pending[i].folio == folio && pending[i].rwc == rwc) {
+					unsigned long long delta = end_ts - pending[i].ts;
+					if (delta > max_val) max_val = delta;
+					sum += delta;
+					pairs++;
+					/* Remove this pending entry */
+					pending[i] = pending[--pending_cnt];
+					break;
+				}
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
+/* Trigger rmap_walk via move_pages */
+static void trigger_rmap_walk(void *region)
+{
+	int ret, status, cur_node, target_node;
+	void *pages[1];
+	int nodes[1];
+
+	ret = move_pages(0, 1, (void **)&region, NULL, &status, MPOL_MF_MOVE_ALL);
+	if (ret != 0) {
+		perror("Failed to get original numa");
+		exit(1);
+	}
+	cur_node = status;
+
+	for (target_node = 0; target_node <= numa_max_node(); target_node++) {
+		if (numa_bitmask_isbitset(numa_all_nodes_ptr, target_node) && target_node != cur_node)
+			break;
+	}
+	if (target_node > numa_max_node()) {
+		fprintf(stderr, "No other NUMA node\n");
+		exit(1);
+	}
+
+	pages[0] = region;
+	nodes[0] = target_node;
+	ret = move_pages(0, 1, pages, nodes, &status, MPOL_MF_MOVE_ALL);
+	if (ret < 0)
+		perror("move_pages");
+}
+
+/* Split VMA with mprotect */
+static void split_vma_with_mprotect(void *addr, size_t size)
+{
+	for (size_t i = 0; i < size / page_size; i++) {
+		if (i % 2 == 0) {
+			if (mprotect(addr + i * page_size, page_size, PROT_READ) < 0 && errno != EACCES)
+				perror("mprotect");
+		}
+	}
+}
+
+/* KSM configuration save/restore */
+static struct ksm_config {
+	int run;
+	int sleep_ms;
+	int pages_to_scan;
+} orig_ksm;
+
+static int save_ksm_config(void)
+{
+	if (read_sys_int(KSM_RUN_PATH, &orig_ksm.run) ||
+	    read_sys_int(KSM_SLEEP_MS_PATH, &orig_ksm.sleep_ms) ||
+	    read_sys_int(KSM_PAGES_TO_SCAN, &orig_ksm.pages_to_scan)) {
+		fprintf(stderr, "Failed to read KSM config\n");
+		return -1;
+	}
+	return 0;
+}
+
+static void restore_ksm_config(void)
+{
+	char buf[32];
+	snprintf(buf, sizeof(buf), "%d", orig_ksm.run);
+	write_sys(KSM_RUN_PATH, buf);
+	snprintf(buf, sizeof(buf), "%d", orig_ksm.sleep_ms);
+	write_sys(KSM_SLEEP_MS_PATH, buf);
+	snprintf(buf, sizeof(buf), "%d", orig_ksm.pages_to_scan);
+	write_sys(KSM_PAGES_TO_SCAN, buf);
+}
+
+/* KSM test */
+static void test_ksm(void)
+{
+	size_t size = NR_PAGES * page_size;
+	unsigned long long max_us, avg_us;
+	int count;
+
+	if (save_ksm_config() < 0) {
+		printf("KSM not available, skip KSM test.\n");
+		return;
+	}
+
+	if (write_sys(KSM_RUN_PATH, "2") < 0 ||
+	    write_sys(KSM_SLEEP_MS_PATH, "0") < 0 ||
+	    write_sys(KSM_PAGES_TO_SCAN, "10000") < 0) {
+		fprintf(stderr, "Failed to configure KSM\n");
+		restore_ksm_config();
+		return;
+	}
+
+	void *region = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (region == MAP_FAILED) {
+		perror("mmap for KSM");
+		restore_ksm_config();
+		return;
+	}
+
+	memset(region, TEST_PATTERN, size);
+	if (madvise(region, size, MADV_MERGEABLE) != 0) {
+		perror("madvise MADV_MERGEABLE");
+		munmap(region, size);
+		restore_ksm_config();
+		return;
+	}
+
+	if (write_sys(KSM_RUN_PATH, "1") < 0) {
+		perror("Start KSM");
+		munmap(region, size);
+		restore_ksm_config();
+		return;
+	}
+
+	/* Construct a anon_vma shared by a number of unrelated VMAs */
+	split_vma_with_mprotect(region, size);
+	wait_ksm_merge();
+
+	/* Trigger one page to be rmapped */
+	enable_tracepoint();
+	trigger_rmap_walk(region + page_size);
+	usleep(100000);
+	disable_tracepoint();
+
+	if (parse_trace_and_print(PAGE_TYPE_KSM, &max_us, &avg_us, &count) == 0) {
+		printf("KSM rmap_walk latency:\n");
+		printf("  Max: %.2f ms (%.0f us)\n", max_us/1000.0, (double)max_us);
+		printf("  Avg: %.2f ms (%.0f us)\n", avg_us/1000.0, (double)avg_us);
+		printf("  Count: %d\n", count);
+	}
+	munmap(region, size);
+	restore_ksm_config();
+}
+
+/* Anonymous test */
+static void test_anon(void)
+{
+	size_t size = NR_PAGES * page_size;
+	unsigned long long max_us, avg_us;
+	int count;
+	void *region = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (region == MAP_FAILED) {
+		perror("mmap anon");
+		return;
+	}
+	memset(region, TEST_PATTERN, size);
+	split_vma_with_mprotect(region, size);
+	enable_tracepoint();
+	trigger_rmap_walk(region + page_size);
+	usleep(100000);
+	disable_tracepoint();
+	if (parse_trace_and_print(PAGE_TYPE_ANON, &max_us, &avg_us, &count) == 0) {
+		printf("Anonymous page rmap_walk latency:\n");
+		printf("  Max: %.2f ms (%.0f us)\n", max_us/1000.0, (double)max_us);
+		printf("  Avg: %.2f ms (%.0f us)\n", avg_us/1000.0, (double)avg_us);
+		printf("  Count: %d\n", count);
+	}
+	munmap(region, size);
+}
+
+/* File-backed test (with early unlink) */
+static void test_file(void)
+{
+	size_t size = NR_PAGES * page_size;
+	char filename[] = "/tmp/rmap_test_file_XXXXXX";
+	int fd = mkstemp(filename);
+	if (fd < 0) {
+		perror("mkstemp");
+		return;
+	}
+	unlink(filename);  /* file will vanish when fd closed, even on crash */
+	if (ftruncate(fd, size) < 0) {
+		perror("ftruncate");
+		close(fd);
+		return;
+	}
+	void *region = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if (region == MAP_FAILED) {
+		perror("mmap file");
+		close(fd);
+		return;
+	}
+	memset(region, TEST_PATTERN, size);
+	split_vma_with_mprotect(region, size);
+	enable_tracepoint();
+	trigger_rmap_walk(region + page_size);
+	usleep(100000);
+	disable_tracepoint();
+
+	unsigned long long max_us, avg_us;
+	int count;
+	if (parse_trace_and_print(PAGE_TYPE_FILE, &max_us, &avg_us, &count) == 0) {
+		printf("File page rmap_walk latency:\n");
+		printf("  Max: %.2f ms (%.0f us)\n", max_us/1000.0, (double)max_us);
+		printf("  Avg: %.2f ms (%.0f us)\n", avg_us/1000.0, (double)avg_us);
+		printf("  Count: %d\n", count);
+	}
+	munmap(region, size);
+	close(fd);
+}
+
+int main(void)
+{
+	page_size = getpagesize();
+
+	if (geteuid() != 0) {
+		fprintf(stderr, "Must be run as root.\n");
+		return 1;
+	}
+	if (numa_available() < 0) {
+		fprintf(stderr, "NUMA not available.\n");
+		return 1;
+	}
+
+	test_ksm();
+	test_anon();
+	test_file();
+	return 0;
+}
-- 
2.25.1

