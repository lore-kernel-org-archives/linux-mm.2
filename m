Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FEDCD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 00:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433A36B00A0; Tue,  9 Jun 2026 20:13:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40B676B00A1; Tue,  9 Jun 2026 20:13:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31FEF6B00A2; Tue,  9 Jun 2026 20:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16EF06B00A0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:13:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D1AA51A07F5
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:13:16 +0000 (UTC)
X-FDA: 84862078392.21.CEF0474
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf18.hostedemail.com (Postfix) with ESMTP id 077931C000D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:13:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="OoViEg1/";
	spf=pass (imf18.hostedemail.com: domain of 3Gawoag0KCGwKLRScROULKZKdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3Gawoag0KCGwKLRScROULKZKdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781050395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nVf/RXEIe8nRDG8lQtZXHCUMhxu4R3A4/WUkqUAovZA=;
	b=OThFeMYMhWfuoSN2t9PgB6C8s6uWnIlujZRRwWlToSa5FuM+8LQsekk0i0pypD0n5/HWyv
	v3qVtuVQkHTcgWc9a4QXyHt5CTaRDYpXq2mnWYpjNEuQTGwzRon8x/41f3yDiiADO/nyH6
	CUR7eVqSRutMhNx5+z72yCTB87UlAzQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="OoViEg1/";
	spf=pass (imf18.hostedemail.com: domain of 3Gawoag0KCGwKLRScROULKZKdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3Gawoag0KCGwKLRScROULKZKdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781050395;
	b=YrOwaiG2c3QjGfg7ug48RYAxnMYPOFYYehUhCsD2VPbJbI05bJHErRYdRUEztFmrbnuYNy
	GbykdnSuuavC0WbvAg1TWVOxFK0B/rFlwenBT70y/5OaKsNu/sFdvjj5vLniSjL7q9oYAO
	3qLP11VdWgqx8aL9cME6gMCZViJ/YBA=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-304f23c55b2so6430411eec.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 17:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781050394; x=1781655194; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nVf/RXEIe8nRDG8lQtZXHCUMhxu4R3A4/WUkqUAovZA=;
        b=OoViEg1/xpQfyThSLaQPd6csvQCh4rG2JqDRbSi7rei31Lmg0WUyeNbgECnfjQv+ST
         ibc2A5WI9ZbGRHQnMmNqIcXmCfIgjXexChHuOtQiXaO757RrJfp2Jd9ZcoyvREhM49uP
         EQ3r0gQmdzoIkcI7aCM8fvhGFstQyVnnoUOXFVEFf4QLLshYaD/0ssxZkC9QWkLfU8+x
         yRbqFBG6dEcfwrbE3v8g5/xf6T8EDWXuqr0KWSGo85BU1rLABwtdFy00pNrLiCIQl0Km
         KP7TOWmd7/qjkc6X0rGgrHKaRjTijITEzlSKVRSoLlAlCAaBuvMwt2o5WlA53cG+6GYb
         12VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781050394; x=1781655194;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nVf/RXEIe8nRDG8lQtZXHCUMhxu4R3A4/WUkqUAovZA=;
        b=WfwVtQWlNW5fB95vtWsTJfIY4mR4qdVgyXtyWUPOu20Enpqc24xt5VyB5BSfS1GmGy
         i20WUrKdamV1Q11FsYQxX4pEAFmtIGUGH+fkwUTOGEvS0tsyI58os65UVpvWjJbBON0P
         Wpl6N+qRM//jVGEA9t5dg8S38q0gcr0XE+/Hzdh93KM1fDP4vbq5md7ypubl2kA+UGWn
         yGdJGMEbTPZRbmhvJiPcv667B9vp7GolwrsOzAcdFysDN8r7tN3TKPwX6F/hTxib83np
         y7iNy9yl4CE8T+M3jW6Zeph1yXVDCz/iFC2osnCbAnRAUQ8W9st5DBhRf99jPIW4Godf
         n4AA==
X-Forwarded-Encrypted: i=1; AFNElJ/hbRlzmhnkMaUbDyFZ69DF+wdthWcIX46sP24M8ezK72NPbdqsKixWqecrKQOSDH5aWR4cPXiovQ==@kvack.org
X-Gm-Message-State: AOJu0YxYzDYczUqVBW2c+xeqOCj/WLPBZQdIX+TtFoDbwYt2bNY74Jyh
	P2dKAVuu5GAfrOaT9kp4g2oynL8FksK8saAOVbhiNNW/zFpw8B15AC7KkDmJ86eTwhOMJsvpX/E
	5nqV4K762VQPC6NLYqy2zjgvMSW8i5PGQFQ==
X-Received: from dycso24.prod.google.com ([2002:a05:693c:3618:b0:304:e89d:c06b])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:4347:b0:304:bce9:25fa with SMTP id 5a478bee46e88-3077b3305c5mr13833111eec.4.1781050393499;
 Tue, 09 Jun 2026 17:13:13 -0700 (PDT)
Date: Wed, 10 Jun 2026 00:12:58 +0000
In-Reply-To: <cover.1781042698.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1781042698.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <dfc472e9d999318cfd74a9b753a563d225b3bc02.1781042698.git.abhishekbapat@google.com>
Subject: [PATCH v4 5/6] kselftest: alloc_tag: add kselftest for ioctl interface
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 077931C000D
X-Stat-Signature: 7fh1udjt3rsx3uchfhf36iabf7y735uz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781050394-995491
X-HE-Meta: U2FsdGVkX18F39xFMySBmV1ZXIuJDfU0PAyyYAi/5iAsGt0/Yt6dHYdiZM3Gwsmr9RIMk6P6/rwHkRQmEJqgz7EcxUv0Z/p2V/aBliPy1+QrFCm6P2q/hkt3gLKsLUDFMbpUqEXlD+fn/BcklV4fwdy7lxhbJsK1lTzJxlAa3yP5yktEk7flku7KWyCTskg+h6zXQ8k5HfqxWwsShIKtZmefc6x9hBc5NWCAbA0wQ+QGBwr1QD9t1z0oPMlT68X69wVVNEXP1Aeivj+j4RmWGNX8OSAZHtaGEuWU98YlJPsXOv3U+XZQiU32lhke+RboI3cGWDgvRgA0aLlsQ/fMXLXNXJIKhbqWFiqKam4FCuiZMsxZrBK7sz9LS/D8wbF935+XK9FH4ki489FNHLv7h3pL6WUTnEn4lGY04vHVt3NP2XZXYCD9ja/pbGvpJ+kqhCzgbFuYnZ6/QBfJKTAKT+uKAOdh/+5BnehB5f+Vzx+8BgthqEp4SVw4xoPld5rRyBXy8xaa1UhmN0IMeHYP0QICBcUkeQ69ZWwm7F0NFgGKxWlOalLNQvrwm0IFtPh36QTAI5I2778vugKOsaDHTPdhFpsoJH9Jzbj9voENCTaSPVGDSRqN+MdOJ1IqXRsIZnQurmMEOUclasCCYziGESnHiwJRR5rht+MQmWXgvf3s1Ur1NgFDYNIWSLnjUITJk8ZdTgCJ0Fggx26dofR9OZ/rBQUeqzaT33lGwpuFmlc/w9ZkmB4EdO+OMG8dmgoA5tk7CNO8LWjP2b5Sdjd2qyw/nDZxaZOL2WOlnL7HROGbTu2SCY/c7h9ppGprBtnJqfpFl3+o2cVv1bPa3VdE+gkKThXeNvsEyEyWbWO6aZxstbMTxmj3vnHK7Yj//qGjCUpX+KupqQ5qn9cu3idnt/hyiBfCJ4QgTifJHe0bBV6V1YXdXnj2msPrfMIqaYEKS60CqxUyvFBtvc7VSQ2
 lQiKoKE4
 lorZ9qk1/Cp6o70ixLAFa5OZmS8G0sNeW+0a9+e/U4vZPIbnjbYQZL8/3SxD0P6Y98rgRJxU5gQBgjBrCg7LrD91z7r8RTfEUgbB2C4LjGog+OReqNe+qjlw01Y758Eg/UkFtGLHlcQZGy9wHsa7sjZPusfrrMIh+J5WrKXDxSGYcJ7uQZlE14Q3a42HPkVIr+OQm1UmZwKyZgpTRF578GBGqGvnZ0wTZTC2mGyv3bmeQ7GWbkEaRVhwyuzJ3zg4WVQUpgO9ZvRs/17r4wCtKlhNXD4m6NuHQV49K7Jrp0QUMbSLHp98CCyeUGoWXSVdq3mEfBHlCQNrd3Pj02yOrmCfQ+Zqy8eC31wJD37v9Zm0cTpbVBM4SgWjPFH/RL8gqWL3qsJtROiEshn/sQy6jpW53WF21hd4Dlba9lccmQvyjIIIoMiHTc1qMlmLv3iqW1yYM+DMrv5S9Z/e//v4VGMjFOiiDWXRttFCz7Ll88OPX4uu67rXQBGXe3tD+71+ugeUk+uyjj1Mz6NBT8XtA6NP+HJGhlNyesjHL2EttylrNq7fxfB4Fxs8kFh5ngeKUV/5vCecKiew3LzrgpCKXROcBn6XsWXTxF8aRLOhTO7ZfNhJMdVtpMrIlonKIwgA+rM5HO14sBfBuO8jlBICRJyiMXtQ2FMufukKr
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
 .../alloc_tag/allocinfo_ioctl_test.c          | 333 ++++++++++++++++++
 3 files changed, 343 insertions(+)
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
index 000000000000..cd9cf229ae1f
--- /dev/null
+++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -0,0 +1,333 @@
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
+		ksft_print_msg("Failed to open " ALLOCINFO_PROC ": %s\n", strerror(errno));
+		ret = KSFT_SKIP;
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
2.54.0.1099.g489fc7bff1-goog


