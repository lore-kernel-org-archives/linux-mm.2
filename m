Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D9DACD8C81
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 23:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665AA6B0095; Fri,  5 Jun 2026 19:37:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 616F46B0096; Fri,  5 Jun 2026 19:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF706B0098; Fri,  5 Jun 2026 19:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5BB6B0095
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 19:37:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE37F40318
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:37:02 +0000 (UTC)
X-FDA: 84847471884.04.B372E7C
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2841214000B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:37:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CWPsENy8;
	spf=pass (imf23.hostedemail.com: domain of 3m10jag0KCDwYZfgqfciZYnYremmejc.amkjglsv-kkitYai.mpe@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3m10jag0KCDwYZfgqfciZYnYremmejc.amkjglsv-kkitYai.mpe@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780702621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NxfV6YXwXpQ4VQFQi0PhdP0vstNIfBR6RPix449NHw=;
	b=LVQeD3SKSeRXmM/QgEZXEDVevf2G/uxhaRRbocpR/6wIWUIz178G5dez5l6xkQOojPcNKx
	/P5IV07IK+7dKU03ax9A5HTGXphjxbqr68dTgEqXMVs5nahFzMmT28M1i+wM+NZE4ycD8k
	UPb5u/UkYd0nrTjRyZ5dN4ZipksLsqo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780702621;
	b=jKw3GYoR4N8+d89FCUQVcDGhNqdY/j0veKCjnQu9pl8YOhquEw9vgMqUTHCfPlos4hV05e
	PfSvjIoBsWwuPMMAAtRCJDYQ/R1n9BoQV4Uc8l8Gu0wtNg67qvVL/s1saIjxCM4UAjedAB
	ued0olB7mJyTRyUORf6jsEeH5ZsMg90=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CWPsENy8;
	spf=pass (imf23.hostedemail.com: domain of 3m10jag0KCDwYZfgqfciZYnYremmejc.amkjglsv-kkitYai.mpe@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3m10jag0KCDwYZfgqfciZYnYremmejc.amkjglsv-kkitYai.mpe@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-304df51ff3eso2170841eec.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 16:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780702620; x=1781307420; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9NxfV6YXwXpQ4VQFQi0PhdP0vstNIfBR6RPix449NHw=;
        b=CWPsENy8xW8LX54v9fc+WWgaG5i91R8X7Vl8GkOiCtO2nSshpzOqEqm7yU3+Sbira2
         HWVz8IgEYshLwpDYjUwLygEt4GJALmzXx5QI/g2ZJOwhwwZYpr6dCAnYvX+407z//Zqe
         24L9TIvdX+GAOhcOMOs2mlUkk8vDFYFDERp2xT2uvrQWkDWx2aEy3o/4lERVibaKMzE/
         rGdVJP9aL7Sf8MTsmQ1yBynNWkDi+OgYpdiEFS50IgC8v6r2svW4i1q+XmOgdhaDPdn0
         apIdShgCWPuOxmZXjYBg/8lx1+XZ+7pvDk9xvjDuIITszAGmUzuCJgqNhtlO18oBH+3B
         5Pug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780702620; x=1781307420;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9NxfV6YXwXpQ4VQFQi0PhdP0vstNIfBR6RPix449NHw=;
        b=f4go6S9SGNmNwQfXXDXyejrqEOXu8lrlDtnypGsPC4hITv9CFvIKirfx09ap0xftWa
         2hpQ6J18bJx1uhunA0euYm0vU7oZQTqo/Q62uJcOKZAiEITfcy2AAdHJlO+UYbKHwd18
         dUho5Fbo44Vd1sK2Uo6spF1EtT50VIOykzFMu2JLaDaH+psl/OdEtOGK0xFr+RgfaxVj
         jaSDIi0FLNd61V1vP4O/5I3Vs5uDo0yRh3r9H1xP0piu5XFsO47CpzdZqAoICWqOSpUC
         Ws5bz/D34CvyYv4ZssoLEiOst77seA68l+RQvbpgwNl5msFI5W4H/5VY2nqwiMCLmBz0
         G9Qg==
X-Forwarded-Encrypted: i=1; AFNElJ9rg/lTBCINoVLs7Zmb09QPVRUg0nVs6VecYHi9ny2vYA2gZo1cQ9ugq9GD/yUowbrFKQQHu1Nd0w==@kvack.org
X-Gm-Message-State: AOJu0YzLVqji43gVMf6Bg24S7s3pwvyuH9WNkF3kNRjN5ztvNuchWy5Q
	1RaaOdkPuaPvC7XB8F5fK955k0wHqzhpgiADx3Mfc1mhA/GFmqkDFiWnA3fHt4WQXD+dwBpbx+i
	7n0O5SdipNuAxaoIrQ+Zz7Wig1nMCPIYD0A==
X-Received: from dybrh10.prod.google.com ([2002:a05:7300:f00a:b0:304:561f:1afb])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:8ca0:b0:2ea:b85c:153d with SMTP id 5a478bee46e88-3077b285d5bmr3088153eec.27.1780702619770;
 Fri, 05 Jun 2026 16:36:59 -0700 (PDT)
Date: Fri,  5 Jun 2026 23:36:50 +0000
In-Reply-To: <cover.1780701922.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <2e55b3b1388a4f7a59f670a83f222ba6c836ac4e.1780701922.git.abhishekbapat@google.com>
Subject: [PATCH v3 5/6] kselftest: alloc_tag: add kselftest for ioctl interface
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2841214000B
X-Stat-Signature: wdbrcmgoyxfxf7cummp85khrbqche9ox
X-HE-Tag: 1780702620-330276
X-HE-Meta: U2FsdGVkX1/8cW8VAULuq5LvHGeZOdvd9ddhGj0420aSgTlQcvdNVy4iAV93FpoWocSsVw71/LsSe769px3TN3w2Slg4OBVLmla0pAPNgfWnzv3SPINI7/r0ClRdMDYhxdq5xJWhGQTbvidWrVbexEQL7ZVQx9ZtQiqU5p+1EKa4fLnblCSTHvf3xuCYcQvbGO+KWQ1DTRFHsY2K5GfUfbPlLTOEVggxolv1dvKu5WVHydOl+nQrBCdLG+MHQ8Ku0070kHDimOC9LVsEjzUdLrTWsMTmhSVIKHo6ARlXl8axyQ9wUjEt3YabpVLA5unZogOcgHV22BN/T2gTksfQiC9gaIQlO/SEEzgtbhs0CHilTlzx2Yb+94c9HVawLzqdcC7IQaa9PH2PEHLKP9Xi++PYbpDNvqT2isoLsv1Nprro9qN1TL7XQ6rvFF330yFg58bXutHO8g8Y5j2Z+jp4ldRNj4qig+NZakSNctFB0SHfxvQfwY/s31qTHpQkDULBVKpZrAKjjpALKtCROdMjSTuYcaNvIj8FY9M7egwCT9tRYAK1G1tdHygT+H6s97tPmQnosx+dSjVDgIRJw3QI2KG2E45kXlVTNf0dYz56nZf955s+akPXB2mJyCH3dtR6AYVzboafjSeB+5OffHbVvI2xOmjwcGncxkvxVdJt8SaAs9TG2GEj7NM3RLxNR8q3Mk8hpFpyq9iDSIFnCFOEd0tqVb5+AiLPoBMz5gfBgujlcWXNS7A6pUkm2r8FCFlOnyJlczS3vXYASOt8rnwqiSKsndEWnmNV/ZV1LyaoMwcet5meLH868tsc0W3Gry2yDImFP9IR11cBKVpP1B+3bUc8sRR1zPDFFXgBmgi7HE+NUvp8MM7mNlC9IVeZZvtG9oTOlBHcan9/dXSUYyOvz5yAEa72OGZQazsZNG1hTnL+wZUmzyQQ9iacyWYRRWnLLCW0TULSXI0QLmYO6p5
 Afg5GKGN
 JDivFcV043wmN2ySXwsKqQ4FxWaCXR35R9tVPGw1LvyHYI4A88TnE0ZF3fUcMVmusiGrwU4b/kCRinYPPC3V3H4K6GpyQqLZj1pSgcFw2YQSxSFmTdvRf9aoHCvQYQ+iLsgp3PYLTIbHLfjpNtMzuRQFuRSxwAMu2zI9enWSOQWducwBteSuGN519jgPOdyQJjc2P4IjjC0lxRR5s25XRNguuxOBaF0funw7nHipT6xZz+ySDRwsL9qRxeHNAEHGNJ4IokxNW+ifFDc9ddygvJzeTowCkjO2we+Tzl/ua8qLcMXaMTMG8696jmreyL9afsD5wa2PDyieB8M40dXtIBdpJAN/wfwnXn3UF2XWrNZEPvn2dBfaKPWLCPadEbQoyfx6cGcIvApSiKVFgy8bCdvxfbI/Cqc92uNv3krs9TGiKvmVtFYrvGWLHSKgHIw3rcFDF0Sk9iTHYiP3K59PEppD4JV1aH82Tqt3bEYSWlrBsQyBJa/c59F20kDmAkpCiCZL7NXVg1emDfk+JOww23bSKgGyX6GCIMcTYd4QUmZVg3CUpt3Y8oZHMbkwsJ/cJp9xPSGhkXzHbDQ1dvcy+25driXomMD7BZOd/ICF4QE397i8HM1i5oZYFswOB5zRd15XpwBFHuTplh57WKqNIswvhFn5mBFR7yF4U
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
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/alloc_tag/Makefile    |   9 +
 .../alloc_tag/allocinfo_ioctl_test.c          | 313 ++++++++++++++++++
 3 files changed, 323 insertions(+)
 create mode 100644 tools/testing/selftests/alloc_tag/Makefile
 create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 77f3fc487691..80560f5f1292 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16713,6 +16713,7 @@ F:	include/linux/alloc_tag.h
 F:	include/linux/pgalloc_tag.h
 F:	include/uapi/linux/alloc_tag.h
 F:	lib/alloc_tag.c
+F:	tools/testing/selftests/alloc_tag/
 
 MEMORY CONTROLLER DRIVERS
 M:	Krzysztof Kozlowski <krzk@kernel.org>
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
index 000000000000..5c3c16e86c23
--- /dev/null
+++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -0,0 +1,313 @@
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
+	int matches;
+	struct allocinfo_tag_data procfs_entry;
+
+	if (!fp) {
+		ksft_print_msg("Failed to open " ALLOCINFO_PROC " for reading\n");
+		return 1;
+	}
+	memset(procfs_entries, 0, sizeof(*procfs_entries));
+	while (fgets(line, sizeof(line), fp) && procfs_entries->count < VEC_MAX_ENTRIES) {
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
+			if (procfs_entry.counter.bytes < filter->min_size)
+				continue;
+		}
+		if (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) {
+			if (procfs_entry.counter.bytes > filter->max_size)
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
2.54.0.1032.g2f8565e1d1-goog


