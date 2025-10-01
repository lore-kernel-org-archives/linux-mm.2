Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FF15CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 14:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABCC68E0006; Wed,  1 Oct 2025 10:58:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71F08E0002; Wed,  1 Oct 2025 10:58:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95BF18E0006; Wed,  1 Oct 2025 10:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7428E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:58:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48BDD16012B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:58:32 +0000 (UTC)
X-FDA: 83949851664.30.A0B2B1F
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5895B14000A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:58:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759330710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XMg6g0QbNb+JlymhYFo/ripFFnZ5ilX30XVAEr/J92s=;
	b=yXfkNz8wdOFVZuO2298bacwHO0gZOlK0n9KZo0DFG0VfZBzqILIEUn7dJcWJh8E85KzV+h
	u7l/MSToB3yREZjWBdXa13CnM8UOagCg5ryEzxnfURU3L1ANEGeoLlaECdKV7i19+DJ8EU
	hVLAsxCZj+P3Pm+b0GRPtbPRlhz/yb4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759330710; a=rsa-sha256;
	cv=none;
	b=J+k7dP/KIDpXH6ejQ3sZBJHTg5/gQ5lFFckafbrWD1Y5Rhf/UsSo4eRewezG20gwnyRCbn
	PMZf6Ld/u0+TLvsuADgjHR04fxU7z0jNLDMvPyc/hZX1VskF3rt1xqH4s04VgbOtQRfPmh
	vpKKspB3cRP9JaWo8WSTsN9VMr0LOBU=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4ccJ2p3H10z5PM3G;
	Wed, 01 Oct 2025 22:58:26 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 591EwIHk093105;
	Wed, 1 Oct 2025 22:58:18 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 1 Oct 2025 22:58:19 +0800 (CST)
Date: Wed, 1 Oct 2025 22:58:19 +0800 (CST)
X-Zmail-TransId: 2afc68dd418b3ca-061c6
X-Mailer: Zmail v1.0
Message-ID: <202510012258194755dOoRXl-9afv5zIk0QwO_@zte.com.cn>
In-Reply-To: <202510012256278259zrhgATlLA2C510DMD3qI@zte.com.cn>
References: 202510012256278259zrhgATlLA2C510DMD3qI@zte.com.cn
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@redhat.com>
Cc: <chengming.zhou@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <tujinjiang@huawei.com>, <shr@devkernel.io>, <wang.yaxin@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgMS8yXSB0b29sczogYWRkIGtzbS11dGlscyB0b29scw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 591EwIHk093105
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Wed, 01 Oct 2025 22:58:26 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68DD4192.000/4ccJ2p3H10z5PM3G
X-Rspamd-Queue-Id: 5895B14000A
X-Stat-Signature: 4htk1jfj6fefhup49ep8npmokj3umkbj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759330708-978621
X-HE-Meta: U2FsdGVkX1/aqIRCB0m2ZoThYJU9kAOOmbV52PriamX2Up240Jict4SCc+geFraekJKTCtbYG+67H3Stf4vsVMGMW6oYWDiiCaNmD2cWRhcLx3vp/Ybbwiz+ciuxm7Yats6nHG2mluQoLPPLy18K8alkB0XGRn3bXWmfWIiwTShj6aC/yEL5tfu8wuzwRq7jTFLy8L5UmT/sjPcVKM9GaSTLZEObqJ/18WjOzyn9MaPv0A1QwqUEtSqZKyOJ2hIpRak4pSiIV14BnRFp2CnT/S1B1XjJu6D4K5PbXqHkcu3q7Utw1jA1yKXiIATfp1TOhkDU2/JlvYnawbFXs0yyOfH0bkbuV0Zl9xA9v8LuaGagPt+SJdMPzrHZ3NU2ffaUCCkWGgDD2w519JNYQyYvO3X/FwOr+UYsVdwpNOoPhp05E1dZQxV/pZ+4Beysk9ks4w90trBt6bfCYCPMrbuF2ejfnallsKbziKcrWPvAlHbYR6+6Rpf96MflciSxFKuZmGxOxcX7M9kH7zOzm7u0nVLLuZ3mVYuuNZ4X0CpA0Aj5T794zg8GmVRoMyKgHJmDHijvowvqJW44lLy+H1fIVY1VKE0+jeASxU8PxPyL/MgRO4mFerOLJveFn/KMgLyYQ0kLJicppSWJg48ZEC7ggwBoeQqhWkZmz4BRJO0CIHmIXlsq1g2Zk4+TVfzhghz1HIfIj3QT9lYEjLWxpS8tC3A+wWalU7u4KDG4cKXORaaEwz1sJL7O3ImZyrtt3SFHdsFu2HsFuMziDiu7sEqx5HJjj6FrqplI+dVHqpYcuJk2t25H5UuDDq+y70m04WpPtEZDwOWKf3lOSzkniVbRT6kf5habq43trR0VQldVj6cyD72mi5vPblSMcQwwIu75/jWtDrRqvjo/WiIg0VVUf6J5WqjJT/Ru9DYNznDQpXRntB2YzVzeiln/ZNCzFLuBOfZ2nhbDSkhbQX1S2Ni
 e6Ffu/gT
 WQYVtppH2kaxN9kTTBsTaemAV6wdq7LOUhf/arx0bx/ZO0TBV/yilFzR74RP2qw/79DpckGB5uf84YzAHVmDFXdiEIJt3HOZ4Mw0gexIIJeP7bMtMeRqcIRveVb76cumHN8PEswoN4LHwHMjcFi+SD8CASo1AdrSuUCigVOx+3aLrEoBa6oRvjxy8OnsDOtHxX5PQGPfJnyhiP7rGX80vugAK5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

The ksm-utils contains two tools which are ksm-get and ksm-show.
The tools are introduced to easily control a process'KSM enabling
or display the ksm state of processes by PID.

1) enable/disable a process's all anonymous VMAs to be scanned by KSM

    ksm-set -s on <command> [<arg>...]
    ksm-set -s off <command> [<arg>...]

2) inquiry the ksm_state of a process or all process ksm pages.

    ksm-get -a -e      # Get all processes's KSM status
    ksm-get -p pid     # Get the specified processs' KSM status

3) Other detailed information, please try

   ksm-set -h or ksm-get -h

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 tools/mm/Makefile            |  12 +-
 tools/mm/ksm-utils/Makefile  |  10 +
 tools/mm/ksm-utils/ksm-get.c | 397 +++++++++++++++++++++++++++++++++++
 tools/mm/ksm-utils/ksm-set.c | 144 +++++++++++++
 4 files changed, 560 insertions(+), 3 deletions(-)
 create mode 100644 tools/mm/ksm-utils/Makefile
 create mode 100644 tools/mm/ksm-utils/ksm-get.c
 create mode 100644 tools/mm/ksm-utils/ksm-set.c

diff --git a/tools/mm/Makefile b/tools/mm/Makefile
index f5725b5c23aa..7a9ba08548a3 100644
--- a/tools/mm/Makefile
+++ b/tools/mm/Makefile
@@ -3,7 +3,8 @@
 #
 include ../scripts/Makefile.include

-BUILD_TARGETS=page-types slabinfo page_owner_sort thp_swap_allocator_test
+BUILD_TARGETS=page-types slabinfo page_owner_sort thp_swap_allocator_test \
+	      ksm-utils
 INSTALL_TARGETS = $(BUILD_TARGETS) thpmaps

 LIB_DIR = ../lib/api
@@ -12,7 +13,7 @@ LIBS = $(LIB_DIR)/libapi.a
 CFLAGS += -Wall -Wextra -I../lib/ -pthread
 LDFLAGS += $(LIBS) -pthread

-all: $(BUILD_TARGETS)
+all: $(BUILD_TARGETS) ksm-utils

 $(BUILD_TARGETS): $(LIBS)

@@ -22,10 +23,15 @@ $(LIBS):
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

-clean:
+clean:  ksm-utils_clean
 	$(RM) page-types slabinfo page_owner_sort thp_swap_allocator_test
 	make -C $(LIB_DIR) clean

+ksm-utils:
+	$(call descend,ksm-utils)
+ksm-utils_clean:
+	$(call descend,ksm-utils,clean)
+
 sbindir ?= /usr/sbin

 install: all
diff --git a/tools/mm/ksm-utils/Makefile b/tools/mm/ksm-utils/Makefile
new file mode 100644
index 000000000000..08eb7c38ee99
--- /dev/null
+++ b/tools/mm/ksm-utils/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+CC := $(CROSS_COMPILE)gcc
+CFLAGS := -I../../../usr/include
+
+PROGS := ksm-get ksm-set
+
+all: $(PROGS)
+
+clean:
+	rm -fr $(PROGS)
diff --git a/tools/mm/ksm-utils/ksm-get.c b/tools/mm/ksm-utils/ksm-get.c
new file mode 100644
index 000000000000..6ae4e8e14126
--- /dev/null
+++ b/tools/mm/ksm-utils/ksm-get.c
@@ -0,0 +1,397 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * ksm-get: Tool for acquire KSM-merging metrics for processes.
+ *
+ * Copyright (C) 2025 ZTE corporation
+ *
+ * Authors: xu xin <xu.xin16@zte.com.cn>
+ */
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <string.h>
+#include <dirent.h>
+#include <stdbool.h>
+#include <errno.h>
+#include <sys/prctl.h>
+#include <ctype.h>
+#include <getopt.h>
+
+#define INVALID_PID -1
+#define MAX_FILE_NAME_SIZE 64
+#define COMM_MAX_SIZE 16
+#define MAX_PROCESSES 65536
+
+/* Enum option for sorting*/
+typedef enum {
+	SORT_MERGING_PAGES,    /* Default, by ksm_merging_pages*/
+	SORT_PROFIT
+} sort_field_t;
+
+typedef struct {
+	int pid;
+	char comm[COMM_MAX_SIZE];
+	long ksm_merging_pages;
+	long ksm_zero_pages;
+	long ksm_profit;
+	long ksm_rmap_items;
+	int KSM_mergeable;
+	int KSM_merge_any;
+	int valid; /* indicate if the data is valid */
+} ksm_info_t;
+
+int pid = INVALID_PID;
+int lookup_all_pid;
+int need_extend_info;
+sort_field_t sort_field = SORT_MERGING_PAGES;
+
+static void usage(void)
+{
+	fprintf(stderr, "Usage: ksm-show [-a] [-p pid] [--sort field] [-e]\n\n");
+	printf("Show KSM merging information of processes.\n\n"
+		"Get KSM merging information of a specific process:\n"
+		" ksm-show -p pid\n\n"
+		"Get KSM merging information of all processes:\n"
+		" ksm-show -a\n\n"
+		"Options:\n"
+		"-a, --all              show all processes (default sort by merging_pages)\n"
+		"-p, --pid [pid]        show specific process\n"
+		"--sort [field]         sort field: merging_pages or profit\n"
+		"-e                     display extended information\n"
+		"-h, --help             show this help\n\n"
+		"Default columns: Pid, Comm, Merging_pages, Ksm_zero_pages, Ksm_profit\n"
+	);
+}
+
+static inline bool pid_is_set(void)
+{
+	return (pid != INVALID_PID);
+}
+
+static int check_arguments(void)
+{
+	if (pid_is_set() && lookup_all_pid) {
+		fprintf(stderr, "error: Options -a and -p cannot be used together.\n");
+		return -EINVAL;
+	}
+
+	if (!pid_is_set() && !lookup_all_pid) {
+		fprintf(stderr, "error: Either -a or -p must be specified.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void print_header(void)
+{
+	printf("%-12s", "Pid");
+	printf("%-20s", "Comm");
+	printf("%-15s", "Merging_pages");
+	printf("%-18s", "Ksm_zero_pages");
+	printf("%-15s", "Ksm_profit");
+	if (need_extend_info) {
+		printf("%-18s", "Ksm_mergeable");
+		printf("%-18s", "Ksm_merge_any");
+	}
+	printf("\n");
+}
+
+static long parse_proc_ksm_stat(char *buf, char *field)
+{
+	char *substr;
+	size_t value_pos;
+
+	substr = strstr(buf, field);
+	if (!substr)
+		return -1;
+
+	if (!strcmp(field, "ksm_mergeable") ||
+	    !strcmp(field, "ksm_merge_any")) {
+		if (!strncmp(substr + strlen(field) + 2, "yes", 3))
+			return 1;
+		else
+			return 0;
+	}
+
+	value_pos = strcspn(substr, "0123456789");
+	return strtol(substr + value_pos, NULL, 10);
+}
+
+static void get_pid_comm(int this_pid, char *comm, int len)
+{
+	int comm_fd, read_size;
+	char proc_comm_name[MAX_FILE_NAME_SIZE];
+
+	snprintf(proc_comm_name, MAX_FILE_NAME_SIZE, "/proc/%d/comm", this_pid);
+	comm_fd = open(proc_comm_name, O_RDONLY);
+	if (comm_fd < 0)
+		return;
+
+	read_size = pread(comm_fd, comm, len - 1, 0);
+	close(comm_fd);
+
+	if (read_size <= 0)
+		return;
+
+	/* make sure string end with \0 */
+	if (comm[read_size - 1] == '\n')
+		comm[read_size - 1] = '\0';
+	else if (read_size < len - 1)
+		comm[read_size] = '\0';
+	else
+		comm[len - 1] = '\0';
+}
+
+static int get_pid_ksm_info(int this_pid, ksm_info_t *info)
+{
+	int proc_fd, read_size;
+	char proc_name[MAX_FILE_NAME_SIZE];
+	char buf[256];
+
+	memset(info, 0, sizeof(ksm_info_t));
+	info->pid = this_pid;
+	info->valid = 0;
+
+	get_pid_comm(this_pid, info->comm, COMM_MAX_SIZE);
+	snprintf(proc_name, MAX_FILE_NAME_SIZE, "/proc/%d/ksm_stat", this_pid);
+
+	proc_fd = open(proc_name, O_RDONLY);
+	/* ksm_stat doesn't exist, maybe kthread or CONFIG_KSM disabled. */
+	if (proc_fd < 0)
+		return -1;
+
+	read_size = pread(proc_fd, buf, sizeof(buf) - 1, 0);
+	close(proc_fd);
+
+	if (read_size <= 0)
+		return -1;
+
+
+	buf[read_size] = 0;
+
+	info->ksm_merging_pages = parse_proc_ksm_stat(buf, "ksm_merging_pages");
+	info->ksm_zero_pages = parse_proc_ksm_stat(buf, "ksm_zero_pages");
+	info->ksm_profit = parse_proc_ksm_stat(buf, "ksm_process_profit");
+	info->ksm_rmap_items = parse_proc_ksm_stat(buf, "ksm_rmap_items");
+	info->KSM_mergeable = parse_proc_ksm_stat(buf, "ksm_mergeable");
+	info->KSM_merge_any = parse_proc_ksm_stat(buf, "ksm_merge_any");
+
+	if (info->ksm_merging_pages < 0 || info->ksm_profit < 0)
+		return -1;
+
+	info->valid = 1;
+	return 0;
+}
+
+static void print_ksm_info(ksm_info_t *info)
+{
+	if (!info->valid) {
+		printf("%-12d", info->pid);
+		printf("%-20s", info->comm);
+		printf("%-15s", "N/A");
+		printf("%-18s", "N/A");
+		printf("%-15s", "N/A");
+		printf("\n");
+		return;
+	}
+
+	printf("%-12d", info->pid);
+	printf("%-20s", info->comm);
+	printf("%-15ld", info->ksm_merging_pages);
+	printf("%-18ld", info->ksm_zero_pages);
+	printf("%-15ld", info->ksm_profit);
+	if (need_extend_info) {
+		printf("%-18s", info->KSM_mergeable >= 0 ?
+			(info->KSM_mergeable ? "yes" : "no") : "N/A");
+		printf("%-18s", info->KSM_merge_any >= 0 ?
+			(info->KSM_merge_any ? "yes" : "no") : "N/A");
+	}
+	printf("\n");
+}
+
+/* sort by ksm_merging_pages in descending order */
+static int compare_by_merging_pages(const void *a, const void *b)
+{
+	const ksm_info_t *info_a = (const ksm_info_t *)a;
+	const ksm_info_t *info_b = (const ksm_info_t *)b;
+
+	/* The valid data is put at first */
+	if (info_a->valid && !info_b->valid)
+		return -1;
+	if (!info_a->valid && info_b->valid)
+		return 1;
+	if (!info_a->valid && !info_b->valid)
+		return 0;
+
+	/*  list in descending order */
+	if (info_a->ksm_merging_pages > info_b->ksm_merging_pages)
+		return -1;
+	if (info_a->ksm_merging_pages < info_b->ksm_merging_pages)
+		return 1;
+
+	return 0;
+}
+
+/* sort by ksm_profit in descending order */
+static int compare_by_profit(const void *a, const void *b)
+{
+	const ksm_info_t *info_a = (const ksm_info_t *)a;
+	const ksm_info_t *info_b = (const ksm_info_t *)b;
+
+	/* The valid data is put at first */
+	if (info_a->valid && !info_b->valid)
+		return -1;
+	if (!info_a->valid && info_b->valid)
+		return 1;
+	if (!info_a->valid && !info_b->valid)
+		return 0;
+
+	/*  list in descending order */
+	if (info_a->ksm_profit > info_b->ksm_profit)
+		return -1;
+	if (info_a->ksm_profit < info_b->ksm_profit)
+		return 1;
+
+	return 0;
+}
+
+static int collect_all_ksm_info(ksm_info_t *infos, int max_infos)
+{
+	DIR *dir;
+	struct dirent *entry;
+	int this_pid;
+	int count = 0;
+
+	dir = opendir("/proc");
+	if (!dir) {
+		perror("cannot open /proc");
+		return -1;
+	}
+
+	while ((entry = readdir(dir)) != NULL && count < max_infos) {
+		/* Check if the dir name is digital (process dir) */
+		if (isdigit(entry->d_name[0]))
+			if (sscanf(entry->d_name, "%d", &this_pid) == 1)
+				if (get_pid_ksm_info(this_pid, &infos[count]) == 0)
+					count++;
+	}
+
+	closedir(dir);
+	return count;
+}
+
+static void show_sorted_ksm_stat(void)
+{
+	ksm_info_t *infos;
+	int count, i;
+
+	infos = malloc(MAX_PROCESSES * sizeof(ksm_info_t));
+	if (!infos) {
+		perror("malloc failed");
+		return;
+	}
+
+	count = collect_all_ksm_info(infos, MAX_PROCESSES);
+	if (count < 0) {
+		free(infos);
+		return;
+	}
+
+	/* pick the sort function by sort filed */
+	if (sort_field == SORT_MERGING_PAGES)
+		qsort(infos, count, sizeof(ksm_info_t), compare_by_merging_pages);
+	else if (sort_field == SORT_PROFIT)
+		qsort(infos, count, sizeof(ksm_info_t), compare_by_profit);
+
+	for (i = 0; i < count; i++)
+		print_ksm_info(&infos[i]);
+
+	free(infos);
+}
+
+static void show_single_ksm_stat(void)
+{
+	ksm_info_t info;
+
+	if (get_pid_ksm_info(pid, &info) == 0)
+		print_ksm_info(&info);
+	else
+		fprintf(stderr, "Error: Cannot get KSM info for pid %d\n", pid);
+}
+
+int main(int argc, char **argv)
+{
+	int err;
+	int opt;
+	int option_index = 0;
+
+	// Define long-option
+	static struct option long_options[] = {
+		{"all", no_argument, 0, 'a'},
+		{"pid", required_argument, 0, 'p'},
+		{"sort", required_argument, 0, 's'},
+		{"help", no_argument, 0, 'h'},
+		{0, 0, 0, 0}
+	};
+
+	if (argc == 1) {
+		usage();
+		return 1;
+	}
+
+	/* Parse the arguments */
+	while ((opt = getopt_long(argc, argv, "ap:s:eh", long_options, &option_index)) != -1) {
+		switch (opt) {
+		case 'a':
+			lookup_all_pid = 1;
+			break;
+		case 'p':
+			if (sscanf(optarg, "%d", &pid) != 1) {
+				fprintf(stderr, "Invalid argument for -p: %s\n", optarg);
+				return 1;
+			}
+			break;
+		case 's':  // sort option
+			if (strcmp(optarg, "merging_pages") == 0) {
+				sort_field = SORT_MERGING_PAGES;
+			} else if (strcmp(optarg, "profit") == 0) {
+				sort_field = SORT_PROFIT;
+			} else {
+				fprintf(stderr, "Error sort field: %s. Use merging_pages or profit\n",
+					optarg);
+				return 1;
+			}
+			break;
+		case 'e':
+			need_extend_info = 1;
+			break;
+		case 'h':
+			usage();
+			return 0;
+		default:
+			usage();
+			return 1;
+		}
+	}
+
+	/* Chech if there is unknown argument.*/
+	if (optind < argc) {
+		fprintf(stderr, "Unexpected argument: %s\n", argv[optind]);
+		usage();
+		return 1;
+	}
+
+	err = check_arguments();
+	if (err < 0)
+		return -EINVAL;
+
+	print_header();
+	if (lookup_all_pid)
+		show_sorted_ksm_stat();
+	else
+		show_single_ksm_stat();
+
+	return 0;
+}
diff --git a/tools/mm/ksm-utils/ksm-set.c b/tools/mm/ksm-utils/ksm-set.c
new file mode 100644
index 000000000000..7ca8e459d256
--- /dev/null
+++ b/tools/mm/ksm-utils/ksm-set.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * ksm-set: Tool for enabling/disabling KSM-merging for a process.
+ *
+ * Copyright (C) 2024 ZTE corporation
+ *
+ * Authors: xu xin <xu.xin16@zte.com.cn>
+ */
+
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <sys/prctl.h>
+#include <stdbool.h>
+
+#include <linux/prctl.h>
+
+#define INVALID_PID -1
+#define KSM_ENABLE_UNSET -1
+
+char **command;
+int ksm_enable = KSM_ENABLE_UNSET;
+int pid = INVALID_PID;
+
+static inline bool command_is_set(void)
+{
+	return (!!command);
+}
+
+static inline bool ksm_enable_is_set(void)
+{
+	return (ksm_enable != KSM_ENABLE_UNSET);
+}
+
+static void usage(void)
+{
+	fprintf(stderr, "Usage: ksm-set -s [on|off] [<command> [<arg>...]]\n\n");
+	printf("Change the KSM merging attributes of processes.\n\n"
+	   "Enable/disable KSM merging any anonymous VMA when starting a new process:\n"
+	   " ksm-set -s [on|off] <command> [<arg>...]\n\n"
+	   "Options:\n"
+	   "-s [on|off]    enable or disable KSM merging\n"
+	   "-h,--help      show this help\n\n"
+	);
+}
+
+static int check_arguments(void)
+{
+	if (!ksm_enable_is_set()) {
+		fprintf(stderr, "error: Option -s is required.\n");
+		return -EINVAL;
+	}
+
+	if (!command_is_set()) {
+		fprintf(stderr, "error: Command must be specified.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	int index, nr_cmd_args, err;
+	char *buffer = NULL;
+
+	if (argc == 1) {
+		usage();
+		return 1;
+	}
+
+	/* Parsing the argument*/
+	for (index = 1; index < argc; index++) {
+		if (argv[index][0] == '-') {
+			switch (argv[index][1]) {
+			case 'p':
+				if (index >= argc - 1) {
+					fprintf(stderr, "Invalid argument for -p\n");
+					return 1;
+				}
+				if (sscanf(argv[index + 1], "%d", &pid) != 1) {
+					fprintf(stderr, "Invalid argument for -p\n");
+					return 1;
+				}
+				index++;
+				break;
+			case 's':
+				if (index >= argc - 1) {
+					fprintf(stderr, "Invalid argument for -s\n");
+					return -EINVAL;
+				}
+				buffer = argv[index + 1];
+				if (strcmp(buffer, "on") == 0)
+					ksm_enable = 1;
+				else if (strcmp(buffer, "off") == 0)
+					ksm_enable = 0;
+				else {
+					fprintf(stderr, "Invalid argument for-s: must be 'on' or 'off'\n");
+					return -EINVAL;
+				}
+				index++;
+				break;
+			case 'h':
+				usage();
+				return 0;
+			default:
+				fprintf(stderr, "Unknown option: %s\n", argv[index]);
+				usage();
+				return 1;
+			}
+		} else {
+			/*
+			 * The remained arguments is seen as a command
+			 * with arguments.
+			 */
+			command = argv + index;
+			nr_cmd_args = argc - index;
+			break;
+		}
+	}
+
+	err = check_arguments();
+	if (err < 0)
+		return -EINVAL;
+
+	printf("KSM %s: ", ksm_enable ? "enabled" : "disabled");
+	for (index = 0; index < nr_cmd_args; index++)
+		printf("%s ", command[index]);
+	printf("\n");
+
+	err = prctl(PR_SET_MEMORY_MERGE, ksm_enable, 0, 0, 0);
+	if (err != 0) {
+		perror("prctl PR_SET_MEMORY_MERGE failed");
+		return -errno;
+	}
+
+	execvp(command[0], command);
+	perror("execvp failed");
+	return -errno;
+
+	return 0;
+}
-- 
2.25.1

