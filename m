Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A6C6CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D4A26B008C; Fri, 15 May 2026 05:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 810D26B0092; Fri, 15 May 2026 05:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1A76B0093; Fri, 15 May 2026 05:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 50C556B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:20:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0659440892
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:20:05 +0000 (UTC)
X-FDA: 84769107570.16.90D1AC9
Received: from mail-m82158.xmail.ntesmail.com (mail-m82158.xmail.ntesmail.com [156.224.82.158])
	by imf03.hostedemail.com (Postfix) with ESMTP id B3FB22000D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:20:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf03.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.158 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778836803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gz60cvdv6+9lZqoyETnYmKM1i1x0QcH9tk1lgwijzd8=;
	b=b2aYbvZBWWBjW26NKzhRkw7hePv8yFtuGiYMhzcQOIrmiMpb1W7bF9FOxuBwVRp31l6Uel
	ZszGLbOLFMes47ERPO4QcigNamZueyw5cmIkBEXXQrdhuwiHzrLU+HIBB+zSbnyr5fHu7g
	ikJEKeZduTS4lHdzbiaWJQ+IB2s6mKE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778836803; a=rsa-sha256;
	cv=none;
	b=jfHYPsuJV+cbGa1Sv7fDP1GRvwqRItSfNEAPuemVBMpUN4ONHMasv5JmJmAaTXHf5ZPpKj
	ssW1J2ZMi4kinoAXUNNJKi6EDB4oSF2/EKHD75Pylrnw6oVrBzIU8AyfwRwEx0CJBYsiLI
	uP85bTSTMdK1LVCqKZ0lf1N3f6kuDuE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf03.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.158 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1a2c1b5b1;
	Fri, 15 May 2026 17:19:58 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH v7 3/4] tools/mm: add page_owner_filter userspace tool
Date: Fri, 15 May 2026 17:19:41 +0800
Message-Id: <20260515091942.1535677-4-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260515091942.1535677-1-zhen.ni@easystack.cn>
References: <20260515091942.1535677-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e2aef7dbc0229kunm2e28cf4e137233
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDSxhDVkpOTR4dTEsaSxlJSFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B3FB22000D
X-Stat-Signature: pp8iua3zyusxpkareai1x5oe8bdsd94e
X-Rspam-User: 
X-HE-Tag: 1778836802-236752
X-HE-Meta: U2FsdGVkX1+eYb2bPUKRyziMDe7uotYBnWXSy9AxGO18+huoJUtL08n9sgvSMVxP2oNn1xw4HGi4oWAnjtBpLUQsiB+pB4FSnRXolC22daY7yrsp5z9L3rQ0krV1+3E6Jd1G1hFmvBfkHIZT2zNDKgX/goYV9pPcSWG7D+nWV1VmYSN2aLEcWRWMfu+l/7HfZSmElVpjFlDOQfjIw3C3QpmfRCI4lZDkSr7UWIt66iPLprDBv4+oIBsrOg0+g7BxqTApFxAnlcLuiU1CGxnDQYBberOj0/t9ROBWS2PvPNaZziugeeYXuu72ZIuvNeZQKL6HHEVZfSHupbCRDC4h5k7u8h5bQNuggCemnPjsYKfHTqrs4Speu1UIqBy3oZ3kE7ZKiVJbclON4PcXfbbfmxrLHt8mXUZ8Svo/0zUOE7XwVyWctbODGkvbdVWyZkAp7NBYiVVBxIvffC+OquxmVpclSLLVgtJCG/Oyb0sjYZrcjkuv/ll7xpxutDhLE/+mATeoJXikH0uLVFqrOCKI49/m4TXxkpWYQbC2QD1rL4zfymwFQKSL0ZRtrBHAw3DCl+uHsnSZb/40U2CTWjT+tmiSYhfTyJoTblbldmkV2sdHfV+4kg6zMu20q3NLUipl1QFP393jrTFAb5I6qBvB+zHam8vNIBTAwyxKbJTYWBOWyxHq0hdQedlIZcyQ0yYA5IPI4OlMey88m8d2d34nM+hFERVAUc5PvpExKFsdHHzx4crhjRlR1/waslPcamj+CzhxNXh8LwlvNVGgxwvl2eqJgCdxDCGVki/ALcqiUqqaXfTCyv/n5X0pFBokJo1QTg/58di57KGWBxRC2Iib5n+55q/pKvDkmYX52nbi0YzkicBLs6IqbFLHAtSyyOXvWJVgafMJlXnnOho7zEaYhU01c5ofBeKx9j1A3cMEqhadHuvcFUZRTWVBOtahs8wPUXhY+UfXBDctIwnxVKg
 BpG1nwKz
 3JPQQBxXeb1ps4vQ2bBBuVuNbIvQCnUf1rqOaeoxPQo/wHWAbvUl3YR6XX8wJv+6DEXJrcbR0+O/QC4FBrddn2TqKfHmBwg1rvAAtM9GUbTBShKuSG89vAajPkkLEaVRUCERcGABj0O6LqAA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a userspace filtering tool for page_owner that supports per-fd
filtering with print_mode and NUMA node filters.

Features:
- Three print modes: stack (default), handle, stack_handle
- NUMA node filtering with flexible formats (single: 0, multiple: 0,1,2,
  range: 0-3, mixed: 0,2-3)
- Per-file-descriptor filter state for independent filtering

Usage examples:
  # Filter by print mode
  ./page_owner_filter -m handle
  ./page_owner_filter -m stack_handle

  # Filter by NUMA node
  ./page_owner_filter -n 0
  ./page_owner_filter -n 0-3

  # Combined filters
  ./page_owner_filter -m stack -n 0,1,2
  ./page_owner_filter -m handle -n 0,2-3

The tool validates inputs before sending commands to the kernel and
provides clear error messages when the kernel does not support
per-fd filtering.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---

Changes in v7:
- New patch for userspace tool
---
 tools/mm/Makefile            |   4 +-
 tools/mm/page_owner_filter.c | 277 +++++++++++++++++++++++++++++++++++
 2 files changed, 279 insertions(+), 2 deletions(-)
 create mode 100644 tools/mm/page_owner_filter.c

diff --git a/tools/mm/Makefile b/tools/mm/Makefile
index f5725b5c23aa..858186a6eefd 100644
--- a/tools/mm/Makefile
+++ b/tools/mm/Makefile
@@ -3,7 +3,7 @@
 #
 include ../scripts/Makefile.include
 
-BUILD_TARGETS=page-types slabinfo page_owner_sort thp_swap_allocator_test
+BUILD_TARGETS=page-types slabinfo page_owner_sort page_owner_filter thp_swap_allocator_test
 INSTALL_TARGETS = $(BUILD_TARGETS) thpmaps
 
 LIB_DIR = ../lib/api
@@ -23,7 +23,7 @@ $(LIBS):
 	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
 
 clean:
-	$(RM) page-types slabinfo page_owner_sort thp_swap_allocator_test
+	$(RM) page-types slabinfo page_owner_sort page_owner_filter thp_swap_allocator_test
 	make -C $(LIB_DIR) clean
 
 sbindir ?= /usr/sbin
diff --git a/tools/mm/page_owner_filter.c b/tools/mm/page_owner_filter.c
new file mode 100644
index 000000000000..cea7dacf1245
--- /dev/null
+++ b/tools/mm/page_owner_filter.c
@@ -0,0 +1,277 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * User-space helper to filter page_owner output per-fd
+ *
+ * Example use:
+ *   ./page_owner_filter -m handle
+ *   ./page_owner_filter -m stack_handle
+ *   ./page_owner_filter -n 0,1,2
+ *
+ * See Documentation/mm/page_owner.rst
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <ctype.h>
+#include <getopt.h>
+
+#define MAX_CMD_LEN	512
+
+static void usage(const char *prog)
+{
+	fprintf(stderr, "Usage: %s [OPTIONS]\n", prog);
+	fprintf(stderr, "\nOptions:\n");
+	fprintf(stderr, "  -m, --mode MODE      : print_mode (stack, handle, or stack_handle)\n");
+	fprintf(stderr, "  -n, --nid NID_LIST   : NUMA node IDs (comma-separated or ranges)\n");
+	fprintf(stderr, "  -o, --output FILE    : output file (default: stdout)\n");
+	fprintf(stderr, "  -h, --help           : show this help message\n");
+	fprintf(stderr, "\nExamples:\n");
+	fprintf(stderr, "  %s -m stack\n", prog);
+	fprintf(stderr, "  %s -m handle\n", prog);
+	fprintf(stderr, "  %s -m stack_handle\n", prog);
+	fprintf(stderr, "  %s -m stack -o output.txt\n", prog);
+	fprintf(stderr, "  %s -n 0,1,2\n", prog);
+	fprintf(stderr, "  %s -m stack -n 0\n", prog);
+}
+
+static int validate_mode(const char *mode)
+{
+	if (strcmp(mode, "stack") == 0 ||
+	    strcmp(mode, "handle") == 0 ||
+	    strcmp(mode, "stack_handle") == 0)
+		return 0;
+
+	fprintf(stderr, "Error: Invalid mode '%s'\n", mode);
+	fprintf(stderr, "Valid modes: stack, handle, stack_handle\n");
+	return -1;
+}
+
+static int validate_nid_list(const char *nid_list)
+{
+	const char *p;
+	int i = 0;
+	int has_digit = 0;
+	int in_range = 0;
+	int prev_num = 0;
+	int curr_num = 0;
+
+	if (!nid_list || strlen(nid_list) == 0)
+		return 0;
+
+	for (p = nid_list; *p; p++) {
+		if (*p == ',') {
+			if (!has_digit) {
+				fprintf(stderr, "Error: Invalid nid_list format\n");
+				return -1;
+			}
+			if (in_range && prev_num > curr_num) {
+				fprintf(stderr,
+					"Error: Invalid range %d-%d (start must be <= end)\n",
+					prev_num, curr_num);
+				return -1;
+			}
+			i = 0;
+			has_digit = 0;
+			in_range = 0;
+			prev_num = 0;
+			curr_num = 0;
+			continue;
+		}
+
+		if (*p == '-') {
+			if (!has_digit) {
+				fprintf(stderr,
+					"Error: Invalid nid_list format ");
+				fprintf(stderr,
+					"(dash without preceding number)\n");
+				return -1;
+			}
+			prev_num = curr_num;
+			curr_num = 0;
+			i = 0;
+			has_digit = 0;
+			in_range = 1;
+			continue;
+		}
+
+		if (!isdigit(*p)) {
+			fprintf(stderr, "Error: Invalid character '%c' in nid_list\n", *p);
+			return -1;
+		}
+
+		if (i > 5) {
+			fprintf(stderr, "Error: NID too long (max 65536)\n");
+			return -1;
+		}
+		curr_num = curr_num * 10 + (*p - '0');
+		i++;
+		has_digit = 1;
+	}
+
+	if (!has_digit) {
+		fprintf(stderr, "Error: Invalid nid_list format\n");
+		return -1;
+	}
+
+	if (in_range && prev_num > curr_num) {
+		fprintf(stderr,
+			"Error: Invalid range %d-%d (start must be <= end)\n",
+			prev_num, curr_num);
+		return -1;
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	const char *output_file = NULL;
+	char filter_cmd[MAX_CMD_LEN];
+	FILE *output = NULL;
+	int fd = -1;
+	ssize_t ret;
+	char buf[4096];
+	int opt;
+	size_t cmd_len = 0;
+
+	static struct option long_options[] = {
+		{"mode",	required_argument, 0, 'm'},
+		{"nid",	required_argument, 0, 'n'},
+		{"output",	required_argument, 0, 'o'},
+		{"help",	no_argument,	   0, 'h'},
+		{0, 0, 0, 0}
+	};
+
+	filter_cmd[0] = '\0';
+
+	if (argc > 1) {
+		for (int i = 1; i < argc; i++) {
+			if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
+				usage(argv[0]);
+				return 0;
+			}
+		}
+	}
+
+	/* Check if page_owner exists and is readable */
+	if (access("/sys/kernel/debug/page_owner", F_OK) != 0) {
+		if (errno == ENOENT)
+			fprintf(stderr, "Error: /sys/kernel/debug/page_owner does not exist\n");
+		else
+			perror("Error accessing /sys/kernel/debug/page_owner");
+		fprintf(stderr, "Make sure page_owner is enabled in kernel\n");
+		return 1;
+	}
+
+	while ((opt = getopt_long(argc, argv, "m:n:o:h", long_options, NULL)) != -1) {
+		switch (opt) {
+		case 'm': {
+			const char *mode = optarg;
+
+			if (validate_mode(mode) < 0)
+				return 1;
+			cmd_len += snprintf(filter_cmd + cmd_len, MAX_CMD_LEN - cmd_len,
+					   "%smode=%s", cmd_len > 0 ? " " : "", mode);
+			break;
+		}
+		case 'n': {
+			const char *nid_list = optarg;
+
+			if (validate_nid_list(nid_list) < 0)
+				return 1;
+			cmd_len += snprintf(filter_cmd + cmd_len, MAX_CMD_LEN - cmd_len,
+					   "%snid=%s", cmd_len > 0 ? " " : "", nid_list);
+			break;
+		}
+		case 'o':
+			output_file = optarg;
+			break;
+		case 'h':
+			/* Already handled above */
+			break;
+		default:
+			usage(argv[0]);
+			return 1;
+		}
+	}
+
+	/* At least one filter must be specified */
+	if (cmd_len == 0) {
+		fprintf(stderr, "Error: At least one filter (-m or -n) must be specified\n\n");
+		usage(argv[0]);
+		return 1;
+	}
+
+	/* Open page_owner for read-write - this will fail if kernel doesn't support write */
+	fd = open("/sys/kernel/debug/page_owner", O_RDWR);
+	if (fd < 0) {
+		if (errno == EACCES || errno == EPERM) {
+			fprintf(stderr, "Error: /sys/kernel/debug/page_owner ");
+			fprintf(stderr, "does not support write access\n");
+			fprintf(stderr, "This kernel does not support ");
+			fprintf(stderr, "per-fd filtering.\n");
+			fprintf(stderr, "Please ensure you have a kernel with ");
+			fprintf(stderr, "per-fd filtering support.\n");
+		} else {
+			perror("Error opening /sys/kernel/debug/page_owner");
+		}
+		return 1;
+	}
+
+	if (output_file) {
+		output = fopen(output_file, "w");
+		if (!output) {
+			perror("open output file");
+			close(fd);
+			return 1;
+		}
+	} else {
+		output = stdout;
+	}
+
+	ret = write(fd, filter_cmd, strlen(filter_cmd));
+
+	if (ret < 0) {
+		if (errno == EINVAL) {
+			fprintf(stderr, "Error: Kernel rejected the filter command.\n");
+			fprintf(stderr, "Possible causes:\n");
+			fprintf(stderr, "  - Kernel does not support per-fd filtering\n");
+			fprintf(stderr, "  - NUMA node has no memory\n");
+			fprintf(stderr, "  - Unknown reason\n");
+		} else {
+			perror("write filter command");
+		}
+		close(fd);
+		if (output != stdout)
+			fclose(output);
+		return 1;
+	}
+
+	if ((size_t)ret != strlen(filter_cmd))
+		fprintf(stderr, "Warning: Partial write (%zd/%zu)\n", ret, strlen(filter_cmd));
+
+	/* Read and display filtered output */
+	while ((ret = read(fd, buf, sizeof(buf) - 1)) > 0) {
+		buf[ret] = '\0';
+		fprintf(output, "%s", buf);
+		fflush(output);
+	}
+
+	if (ret < 0) {
+		perror("read page_owner");
+		close(fd);
+		if (output != stdout)
+			fclose(output);
+		return 1;
+	}
+
+	close(fd);
+	if (output != stdout)
+		fclose(output);
+
+	return 0;
+}
-- 
2.20.1


