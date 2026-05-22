Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9826CCD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E657C6B00B9; Fri, 22 May 2026 13:45:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC84F6B00BC; Fri, 22 May 2026 13:45:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7E686B00BD; Fri, 22 May 2026 13:45:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 958C96B00B9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:45:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4EDD440849
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:45:54 +0000 (UTC)
X-FDA: 84795783828.02.D0A027A
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf06.hostedemail.com (Postfix) with ESMTP id 86E4D18000E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:45:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AvuDNx50;
	spf=pass (imf06.hostedemail.com: domain of 3T5YQag0KCBYwx34E306xwBwF2AA270.yA8749GJ-886Hwy6.AD2@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3T5YQag0KCBYwx34E306xwBwF2AA270.yA8749GJ-886Hwy6.AD2@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779471952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnHehlpVxhvjKQsbhhQoILWStBVOI+qC0gTD8ncby9A=;
	b=fHvhhurg2palfNPA1YsOk/I6VxVrEM5+RoLz8Dl4vD0PLeUl702XaRux0Birgc5KIqOPvq
	aBY1mHYp9RV7Qs7AtjIEiifK81Qysbqcic1Mfp/dRxnVI10WI7e8/0P66zfJaHdATqyYyd
	Paqc42mjIPXXQQSWdTi3/jSi5n+wIFg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779471952; a=rsa-sha256;
	cv=none;
	b=oeoeaZQEMB75mVKsc8d+LtMLrUba9+4gLUumkxVxVScmLWNaTrhvSpEoxoQdmu405ifEBO
	BxQOhfl3koHKypVG8K/Cqr6A+/rVQ3wBLTqA4JkTsq/xNsZcDMY5eSdKVOqaTQOF3uvj/2
	MpWrWE4f+em+ysYtfy/4MDRhE5V2x7k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AvuDNx50;
	spf=pass (imf06.hostedemail.com: domain of 3T5YQag0KCBYwx34E306xwBwF2AA270.yA8749GJ-886Hwy6.AD2@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3T5YQag0KCBYwx34E306xwBwF2AA270.yA8749GJ-886Hwy6.AD2@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2f5943ca81aso28034233eec.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 10:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779471951; x=1780076751; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pnHehlpVxhvjKQsbhhQoILWStBVOI+qC0gTD8ncby9A=;
        b=AvuDNx50J0Ge6jbV0MUO+R1ae3sOkEYeS69WWmu0MQyL3FBtWhNU9CBD00hHR4mNW0
         0pOWUvMHfWRjMaBdW/DvY3h7oksPhaGCGHH2yPvdLZ0BAHyNbmoFMfPyo34T91nZFeOg
         vZywvbL3CpQe5CmnMZgE/NAaTN3x5c1jUAywvC2crQPgPwfcQHnpL54FZ6gu/mnDg9T0
         U0WSH9R5oCWmpp/SW/Z0+GV23EyIkD76sHvUKdJ9RvFXAWgkKkYJFj5RzcYk2L7zB7q0
         AFoiKSY1SzCvvzEjioi4bVQ0vEB6sp3dguMRAdrJe3UJ97MbR7T9GgWWw/QN//p1YSjz
         e03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779471951; x=1780076751;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pnHehlpVxhvjKQsbhhQoILWStBVOI+qC0gTD8ncby9A=;
        b=qBArAvjgsLFRbfRHkBcEw0YFqNsgWisVxdnI6gMzAp7rRDVPkuemqa++ewq9JxYWbd
         EI4PUceurmsdM9VhjRcuL3u8BEq+BAZEhUDTvqneqpOLq7HVFugiDnYUSTE/4pZMuqIK
         cs7wY9S7bxHhOPhmeZPVmqUFg5QkrhjV0WmMNnTImB1CYZzwSzCeUuNPh1N7jDWgi+wa
         zklzX9BeUr4yV/No2V6c8rN5QFtu4SkhDmczuVEQYgkolssklxEl2WOOJUjFi5rE7v5O
         clGe30LFGLE2kh+ocdDZ/3kRR+notYF1xa68DYOmKtyC0DDTa6NlXuriDNCdX/AKYQvK
         GTxA==
X-Forwarded-Encrypted: i=1; AFNElJ/xDgqDMrQNIBsrBX+fs6dj8fa3L9h+fatorMeHst9KfX1Bxn2ho5596ZD+jdLKjlfhNbsWUR8vzw==@kvack.org
X-Gm-Message-State: AOJu0Ywhb+Nzjj8jPdp9/FfMCBT4Pu1Cy8G1XMhGKZIwYVCnkPeWPsJi
	/n9n5srmseeSjQ7JLlv5Sy/uVveKAqv6NN96adJ9CIO2VyMuGkgbRudthBex9WpBz+BIBStUHzr
	AiYJjfmYBdQNNfWHf6W+3148tzoNdB2K3Sg==
X-Received: from dyab3.prod.google.com ([2002:a05:693c:8303:b0:2ee:de47:cde3])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:ef83:b0:2f2:b544:2fd4 with SMTP id 5a478bee46e88-30449201503mr2426796eec.34.1779471951108;
 Fri, 22 May 2026 10:45:51 -0700 (PDT)
Date: Fri, 22 May 2026 17:45:37 +0000
In-Reply-To: <cover.1779471082.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1779471082.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <67aaeca4f720b13e84d89fdffcf96a2a66507dc0.1779471082.git.abhishekbapat@google.com>
Subject: [PATCH v2 5/6] kselftest: alloc_tag: add kselftest for ioctl interface
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 86E4D18000E
X-Stat-Signature: wof79bwqh8bf6z9uspnkai3qrbgpot8u
X-Rspamd-Server: rspam06
X-HE-Tag: 1779471952-552281
X-HE-Meta: U2FsdGVkX1/30RufH6JB8ysohNrOGAHZTAQDRF8PmJ15hXR52hEwsTPpxAnHDMJiTVByEm/pTepOE9fMl7VyniJUU51LIGAQS5FKH9Dg8sq4qIA4Jh+TkcQsqeFGy1rG2B+KlI6Eo+ccTAP0cQYvXgQ8zXUcn+R/a0hCfsSOnZC2Zj7/y1UO3IWmwpzgzK+1TZInUTGsbdzf7WibGFMtldaFFBP1xpHPA0PgZE4cEXbYs1YN5bK3n1LB3J5yojutMZw2Lj4QheJV4pd/DS147oEOeZhTG5drVnnzsVCNTqUJIioom5yPYH863s52DDSF8xU5h8JyOVR9mbqH4p/3EGqdjlXZQ9eocD8zIwOsr+UoZb3nOlFMXYLZ2rYFWlqHnt8XM8tB1DI+SijWzj+g4Yb2V4pm5LcpTxyQGQKv0vm7HoZOjZ0UESsPxQfs2isqdPNqdAi/BpSW315No7jVGxgzzYvZ8qDQTUUS/RlkuEgvzrGUBIhz/dPkLM5NfXqszIeIKl3TwKFGvGmRqLh6o6SIxZtMUwzv40oIpnU5DDldWk5MW1578CGGRxw+MfCwiL7JZstLWHxd5BhLgNhkc5ObNgc8TzXmvakANZqbPvFBwTRk7n9zVyR/ubvmFBdtlBJwjaC9zdluZO0rM+Qjvl0K/5QjSO0ZDt6eq3fjzeW1OUfQe6tIc8PziS3Hxpwu4JqUiC5/nPwx2HHfYcOc3XC8fMsKdbYgLvv6KKOtbIOLnMlxPiVcewFCM5At4FqGuW1ZtCKkPOZke83TguzgfW9U/eHMEJmt1k8QH4UaaESAZaqWxuDj+Esp4ejBhIKEy61bwxRYU7zt20RjCXfpMXKG2Ew0BtMXbHDrnhoyNUfmDrItmQZFnCF5TEJ89sIh4Na7k+p5x/hUCnzS63cpFm5SizUVO1gwelmcBrYVUT27hA/bCu2neMEUfFnc1uGcKE173/VlbVKwcIJ+438
 +Kv6rA2M
 Hm0xL60CXVPr9Oqu8W/hKHQuo8Ly0U3S1EEjj8/0jorAMr827tbyLC8jAvJs4Wk2MfzA31G5R7e2eLdE4azlvqLaVYiqFw0gdQT2YQ4TYwgjW9lCchFNbd9w8DTaJ3e9VW+VAsW6BR+T+VZgUH/5WA3lW5MWNDJVBg5hlbYe6uvZGYZ8LIa/rOPRTyUTG4DKCMLoPIqI4UEEKrhy8kgbinvlBa5ikmpNWV4IeybvYvYKJB+tzjm4x/0bq3iIXJGaE5AbEcXqhV1Vk2tGiydM0LqDVn7Yy/DwI0z6BTT8B+1AofBvpB+U30s5aDCz4gBwmqc8TLpFYPVGEfe80HAAuCpkwkX8eeVipIScxVE/pW1/ep6IPFvoxwL0pFAlGQYi1iiCgdKrg6h4T38Z3YM/bJmoqoQKTD5W6cE2oCkMaDjq0owhW3ze+Zn1sA7z26oczfQZIpou8nIUAGTe9tD08IrHDdXXFsNQY0NDpXdwWPwils2tkCquYcU8mQ3ZrybkYLsVooVjnm3Mj3bo4j9XKspoHQO99CnOThk7y1fpLvWCjN4jH5/oK0Tl4tQnxEuQ4Vxu4ZJGUiGHi6DEkV/PO05VfQsC18J4hCKMa0mzz7O+KErBCY6c7S4f64LCLDX32+YM7zP6K4ugp9858+NuCeFaG/d7rQMmg/IqW
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
index d176bde8fbfc..6d57ab4dfb8f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16711,6 +16711,7 @@ F:	include/linux/alloc_tag.h
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
2.54.0.746.g67dd491aae-goog


