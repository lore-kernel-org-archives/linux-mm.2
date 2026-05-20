Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2058CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 07:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4CAA6B008C; Wed, 20 May 2026 03:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24856B0092; Wed, 20 May 2026 03:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1366B0095; Wed, 20 May 2026 03:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD6FC6B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:57:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70850140125
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:57:07 +0000 (UTC)
X-FDA: 84787042494.30.1974D75
Received: from mail-m24125.xmail.ntesmail.com (mail-m24125.xmail.ntesmail.com [45.195.24.125])
	by imf20.hostedemail.com (Postfix) with ESMTP id 38B7D1C0004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:57:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf20.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.125 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779263825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+HT11rkKXP8WcsOvEw61+li05RrrGFohphIzbJ4WvZ4=;
	b=0b1leGArwxVyxBGJDCSRJbZ1nE3iRTH/XkNbHRmqGJ1JYH/9SJCYQcLLNU9z3B+dCPXhcg
	xgld4oZhabEkHBBDX2uHISOk5d2d/v8ytwte7/EYOyofSZjRj63rfYZegP1juWkXn5JJ2a
	IVTCqCA6fy8gnsM1iDY+OEIM1swHiHY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779263825; a=rsa-sha256;
	cv=none;
	b=S2T9PhhmF7XZwFdOL799+skSbJ1lKEIepjQOT1KslQ7R/joR2l9VaL9N8bPJXyGxFrfIFI
	T13hfXpCq7/XWUAZobX3pbG4wuLGKelVl4CSzgnYnBWjpmwa0oOKCWlLuBNZ+/0eG3+vT+
	4vdLsIAk4sa36VAu0VNmz7TTpK6XOU0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf20.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.125 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1a5d18cb9;
	Wed, 20 May 2026 15:57:00 +0800 (GMT+08:00)
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
Subject: [PATCH v8 3/4] tools/mm: add page_owner_filter userspace tool
Date: Wed, 20 May 2026 15:56:40 +0800
Message-Id: <20260520075641.1931080-4-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260520075641.1931080-1-zhen.ni@easystack.cn>
References: <20260520075641.1931080-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e4463538c0229kunm5cf2619843998
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCThkdVkJNSRpIHUMYThlLSVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 38B7D1C0004
X-Rspam-User: 
X-Stat-Signature: x8g4g1ngbb59paxebthyuudr94wqd6of
X-HE-Tag: 1779263824-906916
X-HE-Meta: U2FsdGVkX1/JgZuSPYQ/ZWtOXBb2xa0gT9GHtLje4ILPMY6WWqAVrlRdeFqiqjeXvzBNNcPkILYrLwGnCeEpIjkmXz0bf+n851NvXrE5diwPgpLbiUXaAEWtp0xgQsa6yYnTRzQAcTux6gf/UFn5YKI8muVC/ZXFvqp00La9AB46jToIHuJ83QgZy7AwNNuubGIcbqnmym9cYbKjm8Y5SCZGYeK5aChhFqQC590L5DHcn52Oyk/nbxWKAYAXpCIaoE/l3/FWR5tYH0y70AT1Yq9uYEiUBrv0ym1kgUH6LWNvfDxFw0PxUoL4Fvt4RMIpzPRMdl57eKBhPhe3ex4KUxxYADKiWbtvs545c6DzTUr2c36Ffe7+GTo8Mtyn1hiyGye5YxdAjrh1kZNymwwiuB3yHvqozPY8UtXU9qgxox19C4RuuFOqPIm9d9t8UW9ou8mMJENJLrGj6emvP3RkDMjYwUhOVyCDo/pXnzmIi6M+OHLPIV2hbG9/XLQs5klM3/D3aGf7wE0G5wcgrk+meD2DJUeKHCPK5FW8PFt2KEu9F+4/K/7Yq/TAr7FjNfta8/onyH1airyaWhQLUIiFmAUNWONSUtcTSIX1S2vpDHsqhQePDBB7pNyJZmlQGlRg60muUFanxxbRLQo18DcKCz8qxZcijWHgIDXopD2KnxP20JMvLW8VUFcOU8iFSvjujVmCdPwaNxJ3v6UrBeGfIHzEmqx8AlCnMuS6+WUs3kT3/nI71Td5vIBKOHOZw9cdBlsuyXJ+OMOQZl/+UvBMgc3h0jMV8ZsU/sidq7beO3tZD/o4O925M/ckZxdTFXfRTKsTFt8jTr7fOHcI4fZAhGH1EzYhTReelp22F0bBTj3H07X76hPpDgEJv0h0OVDPIsuGZk0AIwH6QwJJnxrr6JQCWkkQfVifiKhw7/YymDOp/tMjmbS/cbUbDW4I+VUE64o8r2xgBAPHwnW7GqA
 wDtMfyQ9
 KaFR2v0u4138v8ipwqDN31pwNBX1z8RDqXu8O3kb3wpbcV2N8Ba+L0B1jk7lu15veWFjh2Omr00pVImG5dusKEj7Mxd8QJm8XFUIdm+cUfoj9WaynLAVIiZH6ADYuS572UCJb1KKaqDXtC4E8CQz6fZLzTg4AJQjUS/RtJV/EddMo6xo=
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

Changes in v8:
- Add validation to reject multiple dashes in nid list (e.g., "1-2-3")
- Fix snprintf return value handling to prevent command overflow

Changes in v7:
- New patch for userspace tool

v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-4-zhen.ni@easystack.cn/
---
 tools/mm/Makefile            |   4 +-
 tools/mm/page_owner_filter.c | 293 +++++++++++++++++++++++++++++++++++
 2 files changed, 295 insertions(+), 2 deletions(-)
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
index 000000000000..d056b9bb626a
--- /dev/null
+++ b/tools/mm/page_owner_filter.c
@@ -0,0 +1,293 @@
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


