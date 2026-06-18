Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C00ACCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 03:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BF826B0092; Wed, 17 Jun 2026 23:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696E66B0093; Wed, 17 Jun 2026 23:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5382E6B0095; Wed, 17 Jun 2026 23:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 198466B0092
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 23:58:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D4A78FB57
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:58:16 +0000 (UTC)
X-FDA: 84891675792.23.92144E2
Received: from mail-m82137.xmail.ntesmail.com (mail-m82137.xmail.ntesmail.com [156.224.82.137])
	by imf10.hostedemail.com (Postfix) with ESMTP id 268E4C0005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:58:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.137 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781755094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rfOXlo3pERoZ+fRV6En9ISpCulgzjjOaF9k9NSVWNE4=;
	b=i3WJfBSQd1RbQcY9HQUAXKVFGRKfkjwys/R40GynB4leV1v6WAUnop17EFwuSKkQGYY6LH
	SW9uY4Tojkr/3xdAeo/ZOV9jpniuC14nAz1KK9HuWvWXZU77YGnuiOQx2LFMTnXGf4z7kS
	R2b4yqDme3AgzjChQBs5dTeM7k9pfCA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.137 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781755094;
	b=6iOheuyDFLg4b3hXy0PstWPfeZzx8gFThAn+P/eQsQxMI5nUfY/t7nfIjvRHhOA0Ah69b7
	KqGNsPa8x9WnAl6ydQiprIe4/iMRnXofys6iNCLmQiBw1T/SNk02IOALJ6HWRcoh+nAowb
	ZCyAY8cEFfLFzzUrl2zbJWHPqsEJx6Q=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1b9899930;
	Thu, 18 Jun 2026 11:58:10 +0800 (GMT+08:00)
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
Subject: [PATCH v10 3/4] tools/mm: add page_owner_filter userspace tool
Date: Thu, 18 Jun 2026 11:57:49 +0800
Message-Id: <20260618035750.3724613-4-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260618035750.3724613-1-zhen.ni@easystack.cn>
References: <20260618035750.3724613-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ed8e115b60229kunm88c9600fddaaf
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGR0eVk9DTBpCSE5DHk8YSFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 268E4C0005
X-Stat-Signature: z6gjoiesb15snqwu4kuckf6oqaye3rbk
X-Rspam-User: 
X-HE-Tag: 1781755093-583392
X-HE-Meta: U2FsdGVkX19NHl0xtJ83b9fWd0Z+PmyPZi2jWJOwkEh1ZncleRN9ZJKejNkUqTvYlf2uEP2gzEd51NiXugywslEk9PXIeZb/2Jyvt1YxERzF8HkpbtH8UGMFD1Tf9fMqQXC01HKIx79YhhY0SJ1jPpavRj3OEPhPXjvdL4iaZWE8VdObnHGlPalQKbfnbMXcXYo03bZPsvH/K8AI1AhMCn+owVKin6CRqt+lWn+usA+fCfCWT3px591drZHHscHQPkXF6c8bCrGsil8V7Pt7JArXS32H8or93bJ2R6f7glmuR0OU7WQbCACrr4cZ9oHpbZIVCavBKXqOIcqaQSzdKXtnaAI+c4zXCbdE1bwqqQft9e7KZC3nz2ZjJZyIICCGgRInpeS/IMK0BFaNnCOrskm5MHpPIVZkdBj6rRCEiGKy3dw6BNjnBRVMyrh4TzrD/DwMMPjg41AeacATeXZsMlmuJB6sWD7KbiaA7l/mOYDhvPYw5BEIojTEAs91/Ea8SySJ5EMDfhnGJ79Z4eCz5BvkKRWN2M1HVSShgjxCusTVY4NlwQJZTHluXOY5g+sMWhuUtePj3jRPg7XQSDCwq4IeW2ssxX/BNEA3UZ6MsYwOxYX+jhDF1F4rLx04FCAJPT6t9kmxyq5VXl63od5lV9gg9QpX2NQg654rQnoPZKgwhBuSSd5L6TCJc6ygTA3pU4aPhAfdYnppmtWELrxpOv498ty8YyzOoLjpmXyGF7wXEw2kRiMD6QZIgfj1zBYeuF5mKFHSmQWAJPlmEyO97Sos/bCyzPE/aSFYmsnvLQ1Rejupujq3XHVamPCHGALKsoGxdHcBRohWv7wjla42IZKJWZ8gpIdupEtwmgUCg/uiShtjDeEXx+fkfq8uVIfhuvJ09a/VNBF52Wvb8NJ3kTNKihkniVz74DcRVfeFoJ6+u7rsTGR7Ck8ixFHRyZwMRBZ3E5GeIeRi+jNuUb+
 1BB1342Y
 vTM08qs11JIMENC+A3BiEvHkwqHy1tbJdQs03dr5TRdpQ73650X21vWEHFx5dFmU0HRAjMxLmt4UXcN+/tNxNrEGihuxQCEorK+sbKPwCJcKRReRDMb40CR7h67GU8M8l/EXiJXFJt6/8YgCPt5IiOxHJ9yLXqE/zPy3BtKNiVmYHJaY=
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
Changes in v10:
- Improve error handling: check fwrite() and fflush() return values
- Handle EPIPE correctly: treat broken pipe as success

Changes in v9:
- Fix isdigit() usage: cast to unsigned char to avoid undefined behavior with non-ASCII input
- Optimize I/O performance: replace fprintf() + fflush() in loop with fwrite() + single fflush() after loop

Changes in v8:
- Add validation to reject multiple dashes in nid list (e.g., "1-2-3")
- Fix snprintf return value handling to prevent command overflow

Changes in v7:
- New patch for userspace tool

v9: https://lore.kernel.org/linux-mm/20260525081652.2210206-4-zhen.ni@easystack.cn/
v8: https://lore.kernel.org/linux-mm/20260520075641.1931080-4-zhen.ni@easystack.cn/
v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-4-zhen.ni@easystack.cn/
---
 tools/mm/Makefile            |   4 +-
 tools/mm/page_owner_filter.c | 302 +++++++++++++++++++++++++++++++++++
 2 files changed, 304 insertions(+), 2 deletions(-)
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
index 000000000000..cc5e110a7775
--- /dev/null
+++ b/tools/mm/page_owner_filter.c
@@ -0,0 +1,302 @@
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
+			if (in_range) {
+				fprintf(stderr, "Error: Multiple dashes in nid_list\n");
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
+		if (!isdigit((unsigned char)*p)) {
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
+		int len;
+
+		switch (opt) {
+		case 'm': {
+			const char *mode = optarg;
+
+			if (validate_mode(mode) < 0)
+				return 1;
+			len = snprintf(filter_cmd + cmd_len, MAX_CMD_LEN - cmd_len,
+				       "%smode=%s", cmd_len > 0 ? " " : "", mode);
+			if (len < 0 || cmd_len + len >= MAX_CMD_LEN) {
+				fprintf(stderr, "Error: Command too long\n");
+				return 1;
+			}
+			cmd_len += len;
+			break;
+		}
+		case 'n': {
+			const char *nid_list = optarg;
+
+			if (validate_nid_list(nid_list) < 0)
+				return 1;
+			len = snprintf(filter_cmd + cmd_len, MAX_CMD_LEN - cmd_len,
+				       "%snid=%s", cmd_len > 0 ? " " : "", nid_list);
+			if (len < 0 || cmd_len + len >= MAX_CMD_LEN) {
+				fprintf(stderr, "Error: Command too long\n");
+				return 1;
+			}
+			cmd_len += len;
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
+		goto out;
+	}
+
+	if ((size_t)ret != strlen(filter_cmd))
+		fprintf(stderr, "Warning: Partial write (%zd/%zu)\n", ret, strlen(filter_cmd));
+
+	/* Read and display filtered output */
+	ret = 0;
+	while ((ret = read(fd, buf, sizeof(buf))) > 0) {
+		size_t written = fwrite(buf, 1, ret, output);
+
+		if (written != (size_t)ret) {
+			if (errno == EPIPE) {
+				/* Pipe closed, treat as success */
+				ret = 0;
+				goto out;
+			}
+			perror("write output");
+			ret = -1;
+			goto out;
+		}
+	}
+
+	if (ret < 0) {
+		perror("read page_owner");
+		goto out;
+	}
+
+	if (fflush(output)) {
+		perror("flush output");
+		ret = -1;
+	}
+
+out:
+	close(fd);
+	if (output != stdout)
+		fclose(output);
+	return ret < 0 ? 1 : 0;
+}
-- 
2.20.1


