Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17056C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 11:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75906B009F; Tue,  7 Jul 2026 07:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C264D6B00A1; Tue,  7 Jul 2026 07:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3BCB6B00A2; Tue,  7 Jul 2026 07:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CAFA6B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:54:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B893A03C2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:54:37 +0000 (UTC)
X-FDA: 84961823394.12.1BFB922
Received: from mail-m82136.xmail.ntesmail.com (mail-m82136.xmail.ntesmail.com [156.224.82.136])
	by imf23.hostedemail.com (Postfix) with ESMTP id 758D414000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:54:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf23.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.136 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783425275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xMLfFf3O8rXGSgATq8YSoobN8U6K0IuX4v1SD2D/9kU=;
	b=xjUXvgTovW0vdjOa5SzG5jOEl3xTv5S+c0s3xA63gtyBzbgEKcJWP7GTtYi/z138XnIr4Q
	xVoGM5vO/qkn3LJvlf6a5b9XbiXkXXrZg2+ap/OaLRIovtIVtDncPHS1dDTjsWADyEfIOD
	k0qQJV/hNyJpU9bTuey8bhsjPNDXhm4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf23.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.136 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783425275;
	b=LDvLcfEApr8UrlntgcnlC+/0f9ngYm+2dO6eZFe4Wqj+BfCojy97rxLJKq9jcDpyhIe1Ld
	ds4jQT4I7dDvkaPJXfmZU06x/I9mq5XnyEEZC6lTmWCoMFyB/r6lp2foZBrh3KpDo0Ym13
	399B71EXsx1aBiNKBngwO7sWL0QoGdA=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1c66e4ef7;
	Tue, 7 Jul 2026 19:54:30 +0800 (GMT+08:00)
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
Subject: [PATCH v12 3/4] tools/mm: add page_owner_filter userspace tool
Date: Tue,  7 Jul 2026 19:54:10 +0800
Message-Id: <20260707115411.1714314-4-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260707115411.1714314-1-zhen.ni@easystack.cn>
References: <20260707115411.1714314-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f3c6e02d10229kunm476cca175faac
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZHUwaVkhOTUNDGk8aSE8aHVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 758D414000B
X-Stat-Signature: g3n19nfc1e5uizkgejfzeapcee7c6prr
X-Rspam-User: 
X-HE-Tag: 1783425274-847275
X-HE-Meta: U2FsdGVkX1/owBoOetyIDMC+S5BejxdGDG+Sk9ZJCojtXuIQ3gfTzX2AUtrJwlcsgZgCkpZwxRfJyYRsJggN2VpPzyLn1d4Ox37wzH74wOtWv3U5hD/eTadDxAsg4pvzvmpVUKCSK9sNk/l9YO2TyeYDywXoPJOzOmjy2lZb2hj8lH2L4DgLryXB9VgXeB2BTIcUVSnMql+Gab881J9JcmJrS+rbxMfhvCc9lfe5RhTDKRdQFQBmYPN1FCJhLNXKb2TNKG0QyT5Z68W+PCDlDadNiRWS6xJeZ7fInMxztFEPjXRF71rDtckv52iXsipIywK1/quqpiQzQIlgSOx31q8xTpxcf2JbXXIUklSO+UXBtEpSSijOttdOuVtuTzH+wTJAGSax64qxWexFuVHaZnqrrBh4W8gSx26xY5b82rloBndfP+CXasW6qaRW+1Vt92yFRlj6mrtqOwlcY3oQKg8rvMI07cELrXN+pXKpShLojnOTvx32dChoMERuVgwCZRiXK2ZS/cjF/j+oSWmmWwSitNzSEq7sGEUWtbA02kiZaHLqSwLq4y7x8VgXkq45XfvaLpNsDw9sDG7kjs2G1PvV0WX7CWPdG4DAmy2nosg84bohYNen4j/tFbojSoJOSGPuodDtgwPcl/npgnGiReQE1eu5F9QASNhQOGKh02rDb18pXUl7SB/UjmmJVghu/0gDu11SV0GdOMoZqVgn+KIh4CoSFfapLsHIvfGeCMj9cvOIi8czpzcXwwoq1ZZWQh3WQof4MENtsj+l5xOb6SY7hfPwxXHPA8cCOZOmbY4vmtHPwchEjvZ3tJzKNIHnOLcNoP/tNt4QG7ZBAFc7wfKOuFGODJBA9uc6lLnuyK33YViEVMDwOWB76Ss+ox8wcQCupIiRFeDyNHXJ+yVNDQK5IKJTndORukW07BICjt9nWtIK1uv05+l6nsVZSJ+uuR7Yhsto3Q/eRyD0EIN
 pRKc+yt1
 M+AE5k6nAXUozy8yyO0KVJkVjhLTV1Z1Cl5XGx0PA49jagXIdS/C8a2lYI0WYr7O9TD39otPE5AGjt7WPcLYM4KvbLdRJ7RlZgJ+qdD+KAQbe3wVe+N4tKCgsHtWBd7x3hmBb0IEvLwEZi5peHkecPriWW1af0tCFxVVC13j9ec8WYXyl6gOyrQmAGX1jklqD5Ett
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
Tested-by: Zi Yan <ziy@nvidia.com>
---
Changes in v12:
- No changes

Changes in v11:
- Add signal(SIGPIPE, SIG_IGN) to ignore SIGPIPE and handle EPIPE gracefully
- Treat EPIPE from fwrite() and fflush() as success (broken pipe case)

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

v11: https://lore.kernel.org/linux-mm/20260625043101.338794-4-zhen.ni@easystack.cn/
v10: https://lore.kernel.org/linux-mm/20260618035750.3724613-4-zhen.ni@easystack.cn/
v9: https://lore.kernel.org/linux-mm/20260525081652.2210206-4-zhen.ni@easystack.cn/
v8: https://lore.kernel.org/linux-mm/20260520075641.1931080-4-zhen.ni@easystack.cn/
v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-4-zhen.ni@easystack.cn/
---
 tools/mm/Makefile            |   4 +-
 tools/mm/page_owner_filter.c | 310 +++++++++++++++++++++++++++++++++++
 2 files changed, 312 insertions(+), 2 deletions(-)
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
index 000000000000..1d1f0a38678a
--- /dev/null
+++ b/tools/mm/page_owner_filter.c
@@ -0,0 +1,310 @@
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
+#include <signal.h>
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
+	signal(SIGPIPE, SIG_IGN);
+
+	static struct option long_options[] = {
+		{"mode",	required_argument, 0, 'm'},
+		{"nid",		required_argument, 0, 'n'},
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
+		if (errno == EPIPE) {
+			/* Pipe closed, treat as success */
+			ret = 0;
+		} else {
+			perror("flush output");
+			ret = -1;
+		}
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


