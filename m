Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0E3BCD3436
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 23:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285AA6B0098; Mon,  4 May 2026 19:36:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20FC26B0099; Mon,  4 May 2026 19:36:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6A96B009B; Mon,  4 May 2026 19:36:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EDE106B0098
	for <linux-mm@kvack.org>; Mon,  4 May 2026 19:36:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A7E9414030C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:36:43 +0000 (UTC)
X-FDA: 84731349486.05.3C8AA12
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id C038920005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:36:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g2VynwIM;
	spf=pass (imf03.hostedemail.com: domain of 3iC35aQ0KCB856CDNC9F65K5OBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--abhishekbapat.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3iC35aQ0KCB856CDNC9F65K5OBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777937801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=clHgUoRKmFepHvgpWp4LqZgVIqiObGW8cZkna6OApEg=;
	b=hn5IZ5tP5LHzjKt/0C1PplOJfOQivo7q4ihanH/fJmpsFU5OgCvNkY87udAJpIQBJB/2uB
	cRX4GM7QqJLoPeWkkRTZceu6hzW58S0nmKEFmftGvf8BiUDHM1HqDpTwnyYXiE9fbUgVpr
	86l9DdmE0chasdTG2zzg65WifcialEs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g2VynwIM;
	spf=pass (imf03.hostedemail.com: domain of 3iC35aQ0KCB856CDNC9F65K5OBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--abhishekbapat.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3iC35aQ0KCB856CDNC9F65K5OBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777937801; a=rsa-sha256;
	cv=none;
	b=yWqAMT/Ad+a8NHAfVb4JCWcb1U7iG1Gv55risulkvER5hPP6q/4MR1vc2//pQWDLpo70ko
	10VeFD60ayWy9iwVHxAjuX+arhseWZTIWCtC/o7RcsfEz2c+KSssOgqKxzQR3IOXH6q1QC
	BEuk6tGPwCFcuazXtcISy2cjHrfU5JM=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-12dbf4f678eso25299615c88.0
        for <linux-mm@kvack.org>; Mon, 04 May 2026 16:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777937800; x=1778542600; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=clHgUoRKmFepHvgpWp4LqZgVIqiObGW8cZkna6OApEg=;
        b=g2VynwIMhNv+rkXo/PrBAUhL5tvONYWx2VkEhdfL04dxZAJ5s7co+PyV2wYIACA5rt
         xOOINVfOAQ5MoMTuf1jJ8pmxX3mG04GqNR7+i221YuQ/+CYSJskyNOET3qofWk1l32Y2
         didiY2iTyNZlXWPneY7oNvskWII1CYpnuX8l47AjArCqdXRblYr62nuoaMDsHtYW0RTE
         eD0AAJb4mJFMeZXO/FxFvv4xATOXUwNXD4LYuQd6uU9Ws3/exUd1N1M1/xak721tLBzP
         wSKQTbZv5ITd2mD/GSC3gxN2SNlx1qy4khN6C+usfiAxIWtIVen2b8my/+kSCiqXfoZQ
         ILew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777937800; x=1778542600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=clHgUoRKmFepHvgpWp4LqZgVIqiObGW8cZkna6OApEg=;
        b=A4EA3SrBQigdwzT+PiEYkuTVjTplYvX0D204OirE+rMpuy5KRq1OYtor+vpYpFPkYj
         JNZEr/mFSCvkZR7bAvg3pVBbtTHnl8sCbaJFPHwf0KpPWkSUSnJd9JfmhA3VH4KoDnta
         ynSvvTU2v66V8zEr+L4AR2w3YHKKZ1ORg6lC0WYohP9nbiIAIklBJmEaCM0wHyZdvtqF
         ML9O0znLKcpz+lhaVzG2wdxKDhvBH03u4orJFWACVXevZ68ORpKj7Z7lZyMPyvST07HZ
         6DvnL+G+p31TwJUe0cHevghRi2FuhJwim/acmnyqMYHASB2/gDLTK+qY6UctKsov/2X2
         S2Ug==
X-Forwarded-Encrypted: i=1; AFNElJ/4TywGzht1B18J8DWOuEfamxx1yFDGlpp1g3wHTqayjS4Ggx0Ty4X9ddT/rAQ9ZrWAhbNmKtvPyw==@kvack.org
X-Gm-Message-State: AOJu0YwK82PqfID0CpPOxMB645SfKrCDTPu1wLD6tBkEPAiOFf3ktjvs
	gtF8VbHcxc9TDkqj0qDe0jz6mlz3Egg45MRokQWLZa4UjnqrUArPPrboOUsnH4xk4TWlBx4SWVK
	CKH7kuBEWLoMxF2YZgrjseQCcz7bK/9eImA==
X-Received: from dyau17.prod.google.com ([2002:a05:7300:6011:b0:2ed:fa8:caa3])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:78f:b0:128:dedf:f56d with SMTP id a92af1059eb24-12dfd81a853mr5607329c88.24.1777937800218;
 Mon, 04 May 2026 16:36:40 -0700 (PDT)
Date: Mon,  4 May 2026 23:36:23 +0000
In-Reply-To: <cover.1777936301.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1777936301.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <6d8a2059a4625ef638062815d9586f7a083d02ec.1777936301.git.abhishekbapat@google.com>
Subject: [PATCH 5/6] kselftest: alloc_tag: add kselftest for ioctl interface
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 5xmoxzazz13nu5rcsti9qp6ztdog38q4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C038920005
X-Rspam-User: 
X-HE-Tag: 1777937801-92105
X-HE-Meta: U2FsdGVkX18EJb/y7pQQH3SEFA6+mzOJWZdeFfsckgnb2bA+vqGnZVdrHt9hrxdgEl6ERBOOwQa+Wh5hhwIB8lri/6Rnn6hDgV7/a4czboa2fcATqWeHT7fRbK0vcp69V61nDp2uXtNVf40ysX4RgdC48ZQKqL0mnTd6OYdKN7jBCmTPBot8V47ijtsw1uGyf46LaUWl4egu+oLNctgj1rZ/x4ew2qTbvzMmtQdlitZoReDHbhGj+YZ/dy8zweFqD3z5W6whKsgHB+vb4MnorTdgf2geNiQHgq1bZudF1PlfKW+MOEBEtZeO5d7tjmELgmbd4Xelt+m5qf02f2dltudAAthiDZ3Fu3b1osaNjW/0pU584ZCvKDlzUYR+WMqrlnnz3JoBZ+CD2KBZjf2HJGMAudrJx9fH7ZUhQ5YVjgz/P4qRLp6DdRMEkpZ7EO0LH+wv/DzI0k82BaxsI10/L+OvchI4P6RmOLYmyJ4X8cp+KoK2zJHqZWlnGVh/c0IMAIUof8MHoLprfuscUVm8QQLfgMBPI3RvIzloU6WajkVROoobvRgbcneRKF5Yx81eoPKKl0in6F0NBFyWzvz2n6HK4aNEH2/x7XAuHbSuYQvYg1eDHfF5ilPFm+mqm8/FmdpwXC1hf7fbxZM0W1DZt/17gAWqoX9kFDuGEJ3hr4WxoSW4tRy5VUGcQsggj5VZO4TiNZHfzzPIB33ceup8p5E5/+QFcr+KL39qdL8ji/GRboI9fx+yOUtaDixJ4+bKJa3EumsCC6gCyf3JyR6E0hZZ5whi+NcETVi5NFSdQWAddJCV2UTAQ36kO//F5IGz1HEel90L2HfFBQt8uNAo5FiDPck+76UWhr4Ptf4E4Qcpvz3wxcVpooQbvk5FNcxkXYlGzCE5+M5nU0QWn7O/p43Ignfvbv0V2GnPNX8p5DXmo8bmJYypaIWfjUmf5SHroqGNK9fNhPERXbo2eYt
 0oGu+UvS
 0DOx4oEphA6rRelZ3bl1NRgxLEk/XSX6G4WbJfLbhbW93FIoH5++yE8UQoXBe2GBM8goyatAZ0dGwtJQS/oS06NwjqU+FQy4QYh8hNSp7BN0X08e1ju2U+QewwGm3CeJbR/nk17X98NMIooJ/B+PVuqT93DNH5nF1w2rGxmVu+vj1ROvS6EkCoIEA9sX7aIJEiiLTLHv/64xZAgfLeM0tv1XKIZ9CcY+B2piKq0GRoCZ1dp6bYau/dHSwHXZ45hp2hMzrCjlAhCIglW+7YQq1ehxTDVofxakP9gm9pFmbXyhWFkmV8sEblFsgj+FCQMk6O7BUg2q5UBwIIn9eyvPmekq0P7ezckrlHelFHrU7Ob58+YyMBpA7N1F+leHmg1Ctf4/n4+xRW1meUFsta+2/9AToJHoH5i73Iud/vBIQ5ilfGN24vtE2kv3R7QnVjBmpjmRwxTtSfx/Uimxz7i2sEmYyEgzZmPH0dNkqKfnXb5/EgJ67OUlS8Fu41HrMOyE7orOM9U7mCKl1spdwz6YvgMxMDnDF2ap3ULh57LChFOtb7Aa6dH+tl4jCjMDpso0F2H94G4zM8nIYPXGDvBnTchH97jzUKSVtgGYv3k8R6C+oIoV1fcatl34rZ36CRAL1vplvdfED8PGOayBD7Z8SqVJag6tXAvPrd82ANoKy5YrfOxQ0sGgelZKc1q3ilbEIwldJUwFxKtHFW5+2Xsk+MuTcYWvwBMS93yE4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a kselftest to verify the new IOCTL-based interface for
/proc/allocinfo. The test covers:

1. Validation of the filename filter.
2. Validation of the function filter.

The first test validates the functionality of the filename filter. Using
"mm/memory.c" as the candidate filename filter, it retrieves filtered
entries from both procfs and ioctl and matches the first VEC_MAX_ENTRIES
entries.

The second test validates the functionality of the function filter.
It uses "dup_mm" as the candidate function as we do not expect this
function name to change frequently and hence won't be needing to modify
this test often.

Note that both the tests match line no, function name and file name
fields. Bytes allocated and calls are not matched as those values may
change in the time when the data is being read from procfs and ioctl and
hence can lead to false negatives.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 tools/testing/selftests/alloc_tag/Makefile    |   9 +
 .../alloc_tag/allocinfo_ioctl_test.c          | 316 ++++++++++++++++++
 2 files changed, 325 insertions(+)
 create mode 100644 tools/testing/selftests/alloc_tag/Makefile
 create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c

diff --git a/tools/testing/selftests/alloc_tag/Makefile b/tools/testing/selftests/alloc_tag/Makefile
new file mode 100644
index 000000000000..f2b8fc022c3b
--- /dev/null
+++ b/tools/testing/selftests/alloc_tag/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+
+TEST_GEN_PROGS := allocinfo_ioctl_test
+
+CFLAGS += -Wall
+CFLAGS += -I../../../../usr/include
+
+include ../lib.mk
+
diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
new file mode 100644
index 000000000000..543023ca3d27
--- /dev/null
+++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/* kselftest for allocinfo ioctl
+ * allocinfo ioctl retrives allocinfo data through ioctl
+ * Copyright (C) 2026 Google, Inc.
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdbool.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <linux/types.h>
+#include <linux/alloc_tag.h>
+#include "../kselftest.h"
+
+#define MAX_LINE_LEN		512
+#define ALLOCINFO_PROC		"/proc/allocinfo"
+
+enum ioctl_ret {
+	IOCTL_SUCCESS = 0,
+	IOCTL_FAILURE = 1,
+	IOCTL_INVALID_DATA = 2,
+};
+
+#define VEC_MAX_ENTRIES 32
+
+struct allocinfo_tag_data_vec {
+	struct allocinfo_tag_data tag[VEC_MAX_ENTRIES];
+	__u64 count;
+};
+
+static inline int __allocinfo_get_content_id(int dev_fd, struct allocinfo_content_id *params)
+{
+	return ioctl(dev_fd, ALLOCINFO_IOC_CONTENT_ID, params);
+}
+
+static inline int __allocinfo_get_at(int dev_fd, struct allocinfo_get_at *params)
+{
+	return ioctl(dev_fd, ALLOCINFO_IOC_GET_AT, params);
+}
+
+static inline int __allocinfo_get_next(int dev_fd, struct allocinfo_tag_data *params)
+{
+	return ioctl(dev_fd, ALLOCINFO_IOC_GET_NEXT, params);
+}
+
+static bool match_entry(const struct allocinfo_tag_data *procfs_entry,
+			const struct allocinfo_tag_data *tag_data,
+			bool match_bytes, bool match_calls, bool match_lineno,
+			bool match_function, bool match_filename)
+{
+	if (match_bytes && tag_data->counter.bytes != procfs_entry->counter.bytes) {
+		ksft_print_msg("size retrieved through ioctl does not match procfs\n");
+		return false;
+	}
+
+	if (match_calls && tag_data->counter.calls != procfs_entry->counter.calls) {
+		ksft_print_msg("call count retrieved through ioctl does not match procfs\n");
+		return false;
+	}
+
+	if (match_lineno && tag_data->tag.lineno != procfs_entry->tag.lineno) {
+		ksft_print_msg("lineno retrieved through ioctl does not match procfs\n");
+		return false;
+	}
+
+	if (match_function &&
+	    strncmp(tag_data->tag.function, procfs_entry->tag.function, ALLOCINFO_STR_SIZE)) {
+		ksft_print_msg("function retrieved through ioctl does not match procfs\n");
+		return false;
+	}
+
+	if (match_filename &&
+	    strncmp(tag_data->tag.filename, procfs_entry->tag.filename, ALLOCINFO_STR_SIZE)) {
+		ksft_print_msg("filename retrieved through ioctl does not match procfs\n");
+		return false;
+	}
+	return true;
+}
+
+static bool match_entries(const struct allocinfo_tag_data_vec *procfs_entries,
+			  const struct allocinfo_tag_data_vec *tags,
+			  bool match_bytes, bool match_calls, bool match_lineno,
+			  bool match_function, bool match_filename)
+{
+	__u64 i;
+
+	if (procfs_entries->count != tags->count) {
+		ksft_print_msg("Entry count mismatch. ioctl entries: %llu, proc entries: %llu\n",
+			       tags->count, procfs_entries->count);
+		return false;
+	}
+	for (i = 0; i < procfs_entries->count; i++) {
+		if (!match_entry(&procfs_entries->tag[i], &tags->tag[i],
+				 match_bytes, match_calls, match_lineno,
+				 match_function, match_filename)) {
+			ksft_print_msg("%lluth entry does not match.\n", i);
+			return false;
+		}
+	}
+	return true;
+}
+
+static int get_filtered_procfs_entries(struct allocinfo_tag_data_vec *procfs_entries,
+				       const struct allocinfo_filter *filter, int fd)
+{
+	FILE *fp = fdopen(fd, "r");
+	char line[MAX_LINE_LEN];
+	int matches, skip_lines = 2;
+	struct allocinfo_tag_data procfs_entry;
+
+	if (!fp) {
+		ksft_print_msg("Failed to open " ALLOCINFO_PROC " for reading\n");
+		return 1;
+	}
+	memset(procfs_entries, 0, sizeof(*procfs_entries));
+	while (fgets(line, sizeof(line), fp) && procfs_entries->count < VEC_MAX_ENTRIES) {
+		/*The first two procfs entries are for the header, so we skip them.*/
+		if (skip_lines-- > 0)
+			continue;
+
+		memset(&procfs_entry, 0, sizeof(procfs_entry));
+		matches = sscanf(line, "%llu %llu %[^:]:%llu func:%s",
+				 &procfs_entry.counter.bytes,
+				 &procfs_entry.counter.calls,
+				 procfs_entry.tag.filename,
+				 &procfs_entry.tag.lineno,
+				 procfs_entry.tag.function);
+
+		if (matches != 5)
+			continue;
+
+		if (filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) {
+			if (strncmp(procfs_entry.tag.filename,
+				    filter->fields.filename, ALLOCINFO_STR_SIZE))
+				continue;
+		}
+		if (filter->mask & ALLOCINFO_FILTER_MASK_FUNCTION) {
+			if (strncmp(procfs_entry.tag.function,
+				    filter->fields.function, ALLOCINFO_STR_SIZE))
+				continue;
+		}
+		if (filter->mask & ALLOCINFO_FILTER_MASK_LINENO) {
+			if (procfs_entry.tag.lineno != filter->fields.lineno)
+				continue;
+		}
+		if (filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) {
+			if (procfs_entry.counter.bytes < filter->fields.min_size)
+				continue;
+		}
+		if (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) {
+			if (procfs_entry.counter.bytes > filter->fields.max_size)
+				continue;
+		}
+
+		memcpy(&procfs_entries->tag[procfs_entries->count++], &procfs_entry,
+		       sizeof(procfs_entry));
+	}
+	return 0;
+}
+
+static enum ioctl_ret get_filtered_ioctl_entries(struct allocinfo_tag_data_vec *tags,
+						 const struct allocinfo_filter *filter, int fd,
+						 __u64 start_pos)
+{
+	struct allocinfo_content_id start_cont_id, end_cont_id;
+	struct allocinfo_get_at get_at_params;
+	const int max_retries = 10;
+	int retry_count = 0;
+	int status;
+
+	/*
+	 * __allocinfo_get_content_id may return different values if a kernel module was loaded
+	 * between the two calls. If that happens, the data gathered cannot be considered consistent
+	 * and hence needs to be fetched again to avoid flakiness.
+	 */
+	do {
+		if (__allocinfo_get_content_id(fd, &start_cont_id)) {
+			ksft_print_msg("allocinfo_get_content_id failed\n");
+			return IOCTL_FAILURE;
+		}
+
+		memset(tags, 0, sizeof(*tags));
+		memset(&get_at_params, 0, sizeof(get_at_params));
+		memcpy(&get_at_params.filter, filter, sizeof(*filter));
+		get_at_params.pos = start_pos;
+		if (__allocinfo_get_at(fd, &get_at_params)) {
+			ksft_print_msg("allocinfo_get_at failed\n");
+			return IOCTL_FAILURE;
+		}
+		memcpy(&tags->tag[tags->count++], &get_at_params.data, sizeof(get_at_params.data));
+
+		while (tags->count < VEC_MAX_ENTRIES &&
+		       __allocinfo_get_next(fd, &tags->tag[tags->count]) == 0)
+			tags->count++;
+
+		if (__allocinfo_get_content_id(fd, &end_cont_id)) {
+			ksft_print_msg("allocinfo_get_content_id failed\n");
+			return IOCTL_FAILURE;
+		}
+
+		if (start_cont_id.id == end_cont_id.id) {
+			status = IOCTL_SUCCESS;
+		} else {
+			ksft_print_msg("allocinfo_get_content_id mismatch, retrying...\n");
+			status = IOCTL_INVALID_DATA;
+		}
+	} while (status == IOCTL_INVALID_DATA && retry_count++ < max_retries);
+
+	return status;
+}
+
+static int run_filter_test(const struct allocinfo_filter *filter)
+{
+	int fd;
+	struct allocinfo_tag_data_vec *tags = malloc(sizeof(*tags));
+	struct allocinfo_tag_data_vec *procfs_entries = malloc(sizeof(*procfs_entries));
+	int ioctl_status;
+	int ret = KSFT_PASS;
+
+	if (!tags || !procfs_entries) {
+		ksft_print_msg("Memory allocation failed.\n");
+		ret = KSFT_FAIL;
+		goto freemem;
+	}
+
+	fd = open(ALLOCINFO_PROC, O_RDONLY);
+	if (fd < 0) {
+		ksft_exit_skip("Failed to open " ALLOCINFO_PROC ": %s\n", strerror(errno));
+		ret = KSFT_FAIL;
+		goto freemem;
+	}
+
+	if (get_filtered_procfs_entries(procfs_entries, filter, fd)) {
+		ksft_print_msg("Error retrieving entries from " ALLOCINFO_PROC "\n");
+		ret = KSFT_FAIL;
+		goto exit;
+	}
+
+	if (procfs_entries->count == 0) {
+		ksft_print_msg("No entries found in " ALLOCINFO_PROC ", skipping test\n");
+		ret = KSFT_SKIP;
+		goto exit;
+	}
+
+	ioctl_status = get_filtered_ioctl_entries(tags, filter, fd, 0);
+	if (ioctl_status == IOCTL_INVALID_DATA) {
+		ksft_print_msg("Trouble retrieving valid IOCTL entries, skipping.\n");
+		ret = KSFT_SKIP;
+		goto exit;
+	}
+	if (ioctl_status == IOCTL_FAILURE) {
+		ksft_print_msg("Error retrieving IOCTL entries.\n");
+		ret = KSFT_FAIL;
+		goto exit;
+	}
+
+	if (!match_entries(procfs_entries, tags, false, false, true, true, true))
+		ret = KSFT_FAIL;
+
+exit:
+	close(fd);
+freemem:
+	free(tags);
+	free(procfs_entries);
+	return ret;
+}
+
+static int test_filename_filter(void)
+{
+	struct allocinfo_filter filter;
+	const char *target_filename = "mm/memory.c";
+
+	memset(&filter, 0, sizeof(filter));
+	filter.mask |= ALLOCINFO_FILTER_MASK_FILENAME;
+	strncpy(filter.fields.filename, target_filename, ALLOCINFO_STR_SIZE);
+
+	return run_filter_test(&filter);
+}
+
+static int test_function_filter(void)
+{
+	struct allocinfo_filter filter;
+	const char *target_function = "dup_mm";
+
+	memset(&filter, 0, sizeof(filter));
+	filter.mask |= ALLOCINFO_FILTER_MASK_FUNCTION;
+	strncpy(filter.fields.function, target_function, ALLOCINFO_STR_SIZE);
+
+	return run_filter_test(&filter);
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	ksft_set_plan(2);
+
+	ret = test_filename_filter();
+	if (ret == KSFT_SKIP)
+		ksft_test_result_skip("Skipping test_filename_filter\n");
+	else
+		ksft_test_result(ret == KSFT_PASS, "test_filename_filter\n");
+
+	ret = test_function_filter();
+	if (ret == KSFT_SKIP)
+		ksft_test_result_skip("Skipping test_function_filter\n");
+	else
+		ksft_test_result(ret == KSFT_PASS, "test_function_filter\n");
+
+	ksft_finished();
+}
-- 
2.54.0.545.g6539524ca2-goog


