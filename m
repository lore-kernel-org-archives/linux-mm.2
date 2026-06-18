Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE8FCCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 17:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA3F6B0095; Thu, 18 Jun 2026 13:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C92406B0096; Thu, 18 Jun 2026 13:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B58D66B0098; Thu, 18 Jun 2026 13:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87C536B0095
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:36:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 133561C400E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:36:47 +0000 (UTC)
X-FDA: 84893738454.23.B07C3A1
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id 43A3440017
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:36:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BGf+D+bV;
	spf=pass (imf27.hostedemail.com: domain of 3qyw0ag0KCC4KLRScROULKZKdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--abhishekbapat.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3qyw0ag0KCC4KLRScROULKZKdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781804205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SJ5dFOiSjPf9OrULYCjNPZvX3O6ck7gOoqkGo0Qh7k8=;
	b=Z08ndWJ3hvJBpQsdrLGRG0jG+dMxqSewZ+tqD5tZiG+9GgdJm/ZkSfJ/b7hEf8cl/Yd4Ju
	X8HrulIvL7o97vbsnlj3jzXMu0JBr0UWqvkPz1l3g6a/rragPBL0i4TamTb1NxB7xkg14l
	Hs7IxyWG6qszI9JFUduz9Yx0eGw602M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781804205;
	b=M3arS+4X+K1Y0cho36HnJM0RhSYVmL+PTmN2wlANaSz1QkrRbs8rpM2uyY//nPyU3QKdBD
	DCGXAfqVuNRhMBNCm2FlV4rCwAU9yqlZgBh+LCGO5Yd8U22jpjV5ZRvhJGk0286Kvg4vkI
	0bukYb+h5h6xwd80HngKxMWm3cEAyk4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BGf+D+bV;
	spf=pass (imf27.hostedemail.com: domain of 3qyw0ag0KCC4KLRScROULKZKdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--abhishekbapat.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3qyw0ag0KCC4KLRScROULKZKdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-1394c3ee7f2so6392945c88.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781804204; x=1782409004; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SJ5dFOiSjPf9OrULYCjNPZvX3O6ck7gOoqkGo0Qh7k8=;
        b=BGf+D+bV7ReQmggAqIga+fmQk7jAPtDXFdzrXZ7pqGdOPpZICOgorvjukiV23Vu23w
         GWH+wmGQJnICLtRHTBfCGx2e9C/F+UiA2ZBAvrjEvVolBWUmMt8+TqdFH2ORVLW90e3K
         zbGBsZOyDF6WxfvRoD4F+9/xMu7RMKo4hYsVGRwZQ/EjkI4tGCUP9nLjF0PFS0HEN3Gn
         +n/tbJVbcUNYI6JjRWjqg9EOKlnwSOr9IOpVEmzLAU8JWs0C0uwguhtZZOqqFvWHZ5g2
         X2wKC36oVCN3WDeaSJFi0w6SMUDRmWljk77qus3a87jS6jZddN9zgsNfpCgA2PnDG2kG
         a5Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781804204; x=1782409004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SJ5dFOiSjPf9OrULYCjNPZvX3O6ck7gOoqkGo0Qh7k8=;
        b=AWRWDnNVJ4uhAkrvxIJkvWCYUKnro/fTMz0/6mj5qpX6t/UU4IjzxJ6ODf1lVLJC7A
         /b3uvEiO+Qt08LlM5W4xQNuZ0f2zdewx7o0DEXJhLTOeH7M+ZU6N7AuwPMwDEuPzAbr+
         ryoS62ofBfsBd+AbWcmd/ExDuMVI48Nr1xaDMPlGuak+8UPe2awbmDn2KWf288RdM7e0
         ZzgL7qYYt1FHR5ao80NGAlXNmaiVrAt+TF5XO6HeTzcDwyh0+XsMS9gIz97mXjdj1kit
         BQ2WT/DV6XS5gNplV7D1TiarkGFnc5M7RJCT3uHrxnuNRJ1gWUh/BCCySmNmjggYDdhf
         pvCw==
X-Forwarded-Encrypted: i=1; AFNElJ8fh9kvinxLwTCQIlF7N9NbdXsrQ85pf4YhPjtCxcvUb1ecJCv2uvoIvcy1hEyUNUUCWa2uSbMQOA==@kvack.org
X-Gm-Message-State: AOJu0YwFtcNQjZRjM2OH4aT1WbIUjJff+i3F32LHiK8JV9SJRLX46ivQ
	RXGFqSaQL5C7mh/vaGIRtQbiNCWBen0SEH2cwXz0OXSrVHnBlRm8JECveLyBLzK9O9z6Q/8kTfs
	UKSi1TmLF+JhocD9nh84E6XjSWFQz8rlu9w==
X-Received: from dyer31.prod.google.com ([2002:a05:7300:231f:b0:304:2d1f:6ca6])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:911:b0:134:df7f:910d with SMTP id a92af1059eb24-139a2035fdemr476935c88.7.1781804203522;
 Thu, 18 Jun 2026 10:36:43 -0700 (PDT)
Date: Thu, 18 Jun 2026 17:36:34 +0000
In-Reply-To: <cover.1781803482.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1781803482.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <1d729195a8d11fadb1a1fb78c64633d46843ffe3.1781803482.git.abhishekbapat@google.com>
Subject: [PATCH v6 5/6] kselftest: alloc_tag: add kselftest for ioctl interface
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 43A3440017
X-Stat-Signature: a8d7q3yxegacdsbh4xh414sqhxj7h6wi
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781804204-48023
X-HE-Meta: U2FsdGVkX18m72V8zr8wp02+o1alXGqYj8uXnDie9g6h0nloYrAlvbXwdzuLTvY5aWAYAVD9ZWCB4ET6YbaBR13pgJVodMxiU06iR4nffofPfMDBH6v0tdAvHtGjWW3XNz2pfKcT1bCSVOH3VPUAf41LJDmQlkJAN6XT6EsCwjZPjb2BnKhNxUkv16boyFylSKhtsunsLX41Aycq1X8Kaet4PBybyc3VcWzVXgYX6lTp66vXyRO5xCBvti2TYwo5NqlCaOkdEMGYML2GnchsvpC5JxzKVDzSdI5HmMTl22X8obUz07bgCaBqaK8pS5c5K+r4dt/NRp9NFDSrYO7kBnl/068hVyBdpM3vnwn5M06Qyx7fl9aeZ4N/NROneVinI1NLTX5XCaguwN5XIc3VyrPEw0Id1dEXTotD2sGg6Df+8KjBl/eLgF1htWG5/BcpOEE3MkHRa+IVBbjmRC5Rzl5GR4Y6vhXNVvnkP4YulTqVpxhKu/BjDKB8x3e3LcmllVApT1HWja42p7Vs0jaJ1mTAfH1JAuk2U26147W/VhHZNJWd2/sovimQevA9O7zFp4uFOBarxGYJNAIU/UsBLSgkVlSAInhYeETfUwo0xqF2b8C7mvbqnsD1jS/0POZwjFvXlRzt4TuFwDYCpJuFoB3A91Ev9iLIqIt1Mh77c5eCGPc5c0MW8DpYdSvxQ+/RLVStkVk5i/6yIPWkQ0eApfC60Y1TiW0YzKU1oogOPppTxPD2Jvypme9JJDHW/wzMGg/yFIS05p0nAqL8pq8va0qAx+m/0OI+jHQ/U2EOcysYkj4dA+IPpzBns12wUZ9ACSDEPN3oOIkpAOJDubyOocYIHT5Dq0Q8NopIVfJWoJ78ypBuMlmcihL3YlGe3MzOKL17upcYBkj/4QgLFgHaQgSvsHs/NU1ZIyZ9qBsL0Jc4PHn8rJWzWih3dZqkCH5IM0buqQjV+fra7I61b0V
 NLh0jvXg
 udH3yBeXhTWuGT6TY5NA26+tDPF/riRaPSGYTKEM+cx9OMxrEWjhXO025S32TdJnhT8aZimW0Iw5rCK9QfCrazIQCbdeA1LYmjP+a4ux0cIMO5/R5dWlxVovusJ/s5ZoMDwhD9JPH1w3njVVwoFiSQKokkqrdMzRtZ0quwNW5h2rc1Wf7kbUBQSYP2l2gE75AxcmpH0ac8UFtkbOzxcchp55HPzexiZ/4CTcBc6BwTK7TbEL9pQUbiL84MRllCSQ96BgWSfcF4R8vsVS0jpu77/xNo6OhACz3pB66D+nZqI4kt0+cJG9QJ/O0KDU1PhYw7Ym5PMLWDBl+BnqdTkAG518iLbsdZN+lczsjxQ2Qge1fJQqukPTTSPAy83ZBHNgLZi8W+wEBmrAeV/NuH8qUGY06E1qsagQGi+58lB5Cud5fRdLZLkieSWQwielYUvWBbqNaRoliukYwR1KRXfS3F786arvQCCYBoq1Qops58CUWAsIlE5nPpnof6SgrAGysEk1JM/MjlND9uEB41VnV4pSXNFeNhWOdb82tF7K1aKDaWJuOgmlBkjZ5eyGFoIdj7pmht8oGdsFK0SbyYUKk+SvWwmYC7MsYy818XJBp3aYFX2giTSYHrUQi4zY7/19JZH5jmsc73AiC3c6janKe7gNFZV/57zH7OVCN
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
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/alloc_tag/Makefile    |   9 +
 .../alloc_tag/allocinfo_ioctl_test.c          | 335 ++++++++++++++++++
 4 files changed, 346 insertions(+)
 create mode 100644 tools/testing/selftests/alloc_tag/Makefile
 create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 019cc4c285a3..6610dd42e484 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16715,6 +16715,7 @@ F:	include/linux/alloc_tag.h
 F:	include/linux/pgalloc_tag.h
 F:	include/uapi/linux/alloc_tag.h
 F:	lib/alloc_tag.c
+F:	tools/testing/selftests/alloc_tag/
 
 MEMORY CONTROLLER DRIVERS
 M:	Krzysztof Kozlowski <krzk@kernel.org>
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 6e59b8f63e41..276a78c64736 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 TARGETS += acct
+TARGETS += alloc_tag
 TARGETS += alsa
 TARGETS += amd-pstate
 TARGETS += arm64
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
index 000000000000..1ae0291f2245
--- /dev/null
+++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -0,0 +1,335 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/* kselftest for allocinfo ioctl
+ * allocinfo ioctl retrives allocinfo data through ioctl
+ * Copyright (C) 2026 Google, Inc.
+ */
+
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
+static const char *allocinfo_str(const char *str)
+{
+	size_t len = strlen(str);
+
+	if (len >= ALLOCINFO_STR_SIZE)
+		str += (len - ALLOCINFO_STR_SIZE) + 1;
+	return str;
+}
+
+static void allocinfo_copy_str(char *dest, const char *src)
+{
+	strncpy(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE - 1);
+	dest[ALLOCINFO_STR_SIZE - 1] = '\0';
+}
+
+static int get_filtered_procfs_entries(struct allocinfo_tag_data_vec *procfs_entries,
+				       const struct allocinfo_filter *filter)
+{
+	FILE *fp = fopen(ALLOCINFO_PROC, "r");
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
+		char filename[MAX_LINE_LEN];
+		char function[MAX_LINE_LEN];
+
+		memset(&procfs_entry, 0, sizeof(procfs_entry));
+		matches = sscanf(line, "%llu %llu %[^:]:%llu func:%s",
+				 &procfs_entry.counter.bytes,
+				 &procfs_entry.counter.calls,
+				 filename,
+				 &procfs_entry.tag.lineno,
+				 function);
+
+		if (matches != 5)
+			continue;
+
+		allocinfo_copy_str(procfs_entry.tag.filename, filename);
+		allocinfo_copy_str(procfs_entry.tag.function, function);
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
+	fclose(fp);
+	return 0;
+}
+
+static enum ioctl_ret get_filtered_ioctl_entries(struct allocinfo_tag_data_vec *tags,
+						 const struct allocinfo_filter *filter,
+						 __u64 start_pos)
+{
+	int fd = open(ALLOCINFO_PROC, O_RDONLY);
+
+	if (fd < 0) {
+		ksft_print_msg("Failed to open " ALLOCINFO_PROC " for IOCTL\n");
+		return IOCTL_FAILURE;
+	}
+
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
+			status = IOCTL_FAILURE;
+			goto exit;
+		}
+
+		memset(tags, 0, sizeof(*tags));
+		memset(&get_at_params, 0, sizeof(get_at_params));
+		memcpy(&get_at_params.filter, filter, sizeof(*filter));
+		get_at_params.pos = start_pos;
+		if (__allocinfo_get_at(fd, &get_at_params)) {
+			ksft_print_msg("allocinfo_get_at failed\n");
+			status = IOCTL_FAILURE;
+			goto exit;
+		}
+		memcpy(&tags->tag[tags->count++], &get_at_params.data, sizeof(get_at_params.data));
+
+		while (tags->count < VEC_MAX_ENTRIES &&
+		       __allocinfo_get_next(fd, &tags->tag[tags->count]) == 0)
+			tags->count++;
+
+		if (__allocinfo_get_content_id(fd, &end_cont_id)) {
+			ksft_print_msg("allocinfo_get_content_id failed\n");
+			status = IOCTL_FAILURE;
+			goto exit;
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
+exit:
+	close(fd);
+	return status;
+}
+
+static int run_filter_test(const struct allocinfo_filter *filter)
+{
+	struct allocinfo_tag_data_vec *tags = malloc(sizeof(*tags));
+	struct allocinfo_tag_data_vec *procfs_entries = malloc(sizeof(*procfs_entries));
+	int ioctl_status;
+	int ret = KSFT_PASS;
+
+	if (!tags || !procfs_entries) {
+		ksft_print_msg("Memory allocation failed.\n");
+		ret = KSFT_FAIL;
+		goto exit;
+	}
+
+	if (get_filtered_procfs_entries(procfs_entries, filter)) {
+		ksft_print_msg("Error retrieving entries from " ALLOCINFO_PROC "\n");
+		ret = KSFT_SKIP;
+		goto exit;
+	}
+
+	if (procfs_entries->count == 0) {
+		ksft_print_msg("No entries found in " ALLOCINFO_PROC ", skipping test\n");
+		ret = KSFT_SKIP;
+		goto exit;
+	}
+
+	ioctl_status = get_filtered_ioctl_entries(tags, filter, 0);
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
2.55.0.rc0.786.g65d90a0328-goog


