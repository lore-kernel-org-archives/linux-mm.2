Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20F9EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 18:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B0286B0095; Wed,  8 Jul 2026 14:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ECB46B0096; Wed,  8 Jul 2026 14:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B47C6B0098; Wed,  8 Jul 2026 14:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 081046B0095
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:01:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6FF28168C22
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:01:37 +0000 (UTC)
X-FDA: 84966377034.01.664CA17
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id 77B7D40016
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:01:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LIrLUco7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3fpBOag0KCDMPQWXhWTZQPePiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--abhishekbapat.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3fpBOag0KCDMPQWXhWTZQPePiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783533695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A6X8r8rQ/Mw4midEfwWpr3JWxz84HeG7RSkGh/VwP3w=;
	b=z/2WwtEZnCTIjlfu+Wtv+Ie6A+bw9f1w71QO+B85CMJ4LHJnliBoTBnMSUCASgINdj5cVC
	HgXhpbLpAiJ4gS+YqI+GiTQrVC0UDuaN8j9aoSy7Pi8kTNeXcsW82bol/Iqr1zPoJMpyFx
	2dHmL2YcFqsvQB033PhJiaCWgswZ1js=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LIrLUco7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3fpBOag0KCDMPQWXhWTZQPePiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--abhishekbapat.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3fpBOag0KCDMPQWXhWTZQPePiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783533695;
	b=2Oi50r0i4j0s6tjEAZBlcL8JNW+FPpeGxRx3EKRH0XytVvM8ZKpm2gU215DmD3w7SRwSVk
	cJWc9dfr6LHOD9r29BmoJfeTW0Pnc4x/oN4bP7gGAX6FAkvIeeUpYdPbbMjbKVWZ29cT0v
	nd1fxFNq9FZ1nZmAewCnJ/MLNRbh7mY=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c894391f000so2150289a12.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 11:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783533694; x=1784138494; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A6X8r8rQ/Mw4midEfwWpr3JWxz84HeG7RSkGh/VwP3w=;
        b=LIrLUco7CZsVTjoeC6L3ZOEldvoQufQgrdebj8ug5EhryQfl81x9Enq21O+yltn+vx
         3C29mKLGqJ/mS60tHJoWUPKPOxPVEuOazx0+ifgQkR7RGHVLEaYCrNPa3EhLUFH+rtcb
         E1R+Wzhmh3t1bJqN5Ul94d7tctsH7SsQ2mXd8P2iK1DStkYmd0CguADSwP6Wd9ILZMHF
         25uQFsPUlcteSqwjtIusPridKAa+TxKzv2vG3q23SA0Y7HIL1as1ywqCv2XhI9BurAOi
         thvHfhD+m3W+r09dA00tU6Sah7RDyflTWYtwH1OETpXiL2TIKAnL5kitjUK+ZzyxSPaJ
         cw+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783533694; x=1784138494;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A6X8r8rQ/Mw4midEfwWpr3JWxz84HeG7RSkGh/VwP3w=;
        b=sPBmmz7LmyzQ0huql30k917/eDCoTZEyh/Jt8FAg6MMj2dq8TM+USnHdd8Njpkde67
         hLcow/yLBMAOMc+EIR36trXGYEaxeh9AU4d+BMSUB/UYV6mqllUN8gN89VumzoMySH1L
         v2h0RzZZ7tlMag54eJPUNdW59rrt8fJja99lq5DCjMqBjjqMiwUWkT4j23X1Qu8RWL8G
         JUKf2mWcU4wEXPj5UUXPaW91ZI4YhIDL2gz4Q3LKLJrHdZkFPi7cIHJkhOKCX4k6FCfM
         qE123k4qvbtQoGOeMG/G5s5UdXqyBWh0809Vh5xDnc4AkArFQg/fWBZq7FZVaz6NTOr0
         r6Kw==
X-Forwarded-Encrypted: i=1; AHgh+RrSTdNGKL1vlA2fo53UqQ9AfMX7E4ZTZpLZ8LfsLrUW0xZcmZtFBenwIw5gMaf2qzQP3fcQYQnyyQ==@kvack.org
X-Gm-Message-State: AOJu0YxKGLYns8ixkebdHKAteCYWDtq2hGS5xSXWCDbSWWnec7KRTs08
	f3PdbHWfaEZ+UqHQ0B8bslu5l2kqJHM7T8ihMkLcnJMXZKWwUjxsiVlPenvfSBrgKt9urt5Kcem
	ZTuaoLHJEhmaXIgMAFsjBPWrSL6cbcEaI0w==
X-Received: from dlbqd12.prod.google.com ([2002:a05:7023:b0c:b0:13a:4c0:f1f])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:a124:b0:3bf:a881:4093 with SMTP id adf61e73a8af0-3c0bcf16146mr4376423637.9.1783533694204;
 Wed, 08 Jul 2026 11:01:34 -0700 (PDT)
Date: Wed,  8 Jul 2026 18:01:27 +0000
In-Reply-To: <cover.1783532853.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1783532853.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <e2a3795677a14aeab249758ba570cd5e98402032.1783532853.git.abhishekbapat@google.com>
Subject: [PATCH v8 5/6] kselftest: alloc_tag: add kselftest for ioctl interface
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 77B7D40016
X-Stat-Signature: t4zynmx33n5iocosd8j9xjigh54qpatm
X-Rspam-User: 
X-HE-Tag: 1783533695-216643
X-HE-Meta: U2FsdGVkX1+KRAZMROG3kRVhmAM7yUawCxdlfhxfHSQ14VB5pRL6kjKvxU8kfIbAtmHjsJEjGFlwkrKXENVGtedBFCTapDgtfyxVv8Fveuy+TJ7XX/ocCm+X+hy4M2OiSAI/IsF6pZGWobR87JrTB0IVjWZy7i+u4CcwV5VbKe3HxLycLsKSQIRxmF/6i9zAM5/IR1CNkCYWwolegnaaIb4U7Uc4uWDutkeB0byA92Blwep5BFe4Ec/JYlsssjPg6cCmUA1xXvyIv68kQCxznLV0uDOHTaQ2z9DsAGdkDYlfyVO13esfZLKqLdGz79mO1FYbBemVqciVYjMiqYN5kWWCOK9Hr+N3/XSeCh0TvPVAvIrbvaFl8LzVcHcfpQiVFCqGWk6g7WxKE9GqT7IJEVeFCwlF7gecoB2pJ4K9vLXSCOEe9MHxvGNEyplABMXPrmCWKt26h2jMq3bCp4ABPOzVZ/O4XonVlEmexYQKQK8g5IPPMHXVYaL1R+W9HVnEXm63pmLkWFQ7QxeqAnGpJoHj9jmgkhlqKPT2HFZ8jn/9TzgzPAswaPARynNF/PnKptFBu58Ezfkwc6WPj7wLz/TnIQWkaYDTG1ZWo+SSYmVNOjuwSAX5+vyWZTfeVVE1zm/dFv/pHTCtzzMQ41AXkTiTUw9B9IRcFdXDm5GoTxFj6YXjZkqi5hfQe/MaGvRjHX3O3qhyPzGSVxxVzALu6sjKfxRVVykyoHp2uslGDrtTsyBm8aI70n88gRBCgijyU+IPmpJ/YRUXXlxoCr8lLmtp9f4bMU4f94F4KW5OOC1zCIgKcKEZVtwpZirb349uR8H05wKL4eQFtBzPFgTdKfufuXrGtTEzuuKb09/dLYq8NA/IpAD1OmduI/v32mFkR7cCt6+pTOXYj0CZ6tQsl450OZdfacShaN4f3DvqFU0EJmTui2GQcgAvkEBqVxBhszVdFW0VATXWF8varfG
 4fcB/AGc
 NS5OVp+5prq+AN6kJ1Hfc9udq53PabkoaKAhW9x/u28BtTqsLnj6xBNwjRVgWUaBa9SbbfxUTSLOF9kFHGf9iedI/KZnFC/9JA69aFUPF0lQEPds/0Eph1ExX97/hmsaHFbPTNVbqeDkQVOqYJG81YE+HSKl18MkoV7gSuoPfI+JW4xdNG0amtLLzft18C4BPC2CTqOjp5OyZnNcTrsRAX/KX/5mmDcgHXtpiEgqkAcIF0F/4Fv227e0X24kkg66pOnyE4b8zCTJuHiIlJ4FlN4NKlGt1VeO0H+b8pM218JETiXFMNQx0uM2TmuySV3Be1oIp6ilS+VDNeN0LPoJvXcIYs1epqhLC2zK34voe4qb6bFdyM2AOl17Aak6ceFfQURfDgGtkG6ZHb/dIcwtDjIcip+C74WHxHW5VPqZFuhTl0p82ydGZYdedv0CtA9SX70NXuZV5NFbbZuAcIfF5t/9//YP9XwC8DsrSJSXmFvJm8GBk5ahh62txeTHHypHeXswJCvE6fX2x1rudvWqnimrp6UYt3hGHspjHwh3T9ItVYnzsDtj1Kapq3xctDdOW5zx73Rs2Aw1ZI2hmM2NgK2KApm3w8mzPXNWqVFDaHBRheVY4etgSJFcHlFYqiTNLYstK8VlC2OcREf+WV/dNwjp7nUun38DjSdC4k/6mljmflR/P0TMTE/8lp7cRumMahZuAxDXsFkxyWA8jYQek40gzT70xQmKgEVAte3AHUyTpszM=
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
 .../alloc_tag/allocinfo_ioctl_test.c          | 334 ++++++++++++++++++
 4 files changed, 345 insertions(+)
 create mode 100644 tools/testing/selftests/alloc_tag/Makefile
 create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8e316eba7b4c..3d54fd8d69c1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16938,6 +16938,7 @@ F:	include/linux/alloc_tag.h
 F:	include/linux/pgalloc_tag.h
 F:	include/uapi/linux/alloc_tag.h
 F:	mm/alloc_tag.c
+F:	tools/testing/selftests/alloc_tag/
 
 MEMORY MANAGEMENT - BALLOON
 M:	Andrew Morton <akpm@linux-foundation.org>
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 8d4db2241cc2..12941d68a7f8 100644
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
index 000000000000..f41d92d06b18
--- /dev/null
+++ b/tools/testing/selftests/alloc_tag/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+
+TEST_GEN_PROGS := allocinfo_ioctl_test
+
+CFLAGS += -Wall
+CFLAGS += $(KHDR_INCLUDES)
+
+include ../lib.mk
+
diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
new file mode 100644
index 000000000000..9ce7b53078b1
--- /dev/null
+++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -0,0 +1,334 @@
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
+			break;
+		}
+
+		memset(tags, 0, sizeof(*tags));
+		memset(&get_at_params, 0, sizeof(get_at_params));
+		memcpy(&get_at_params.filter, filter, sizeof(*filter));
+		get_at_params.pos = start_pos;
+		if (__allocinfo_get_at(fd, &get_at_params)) {
+			ksft_print_msg("allocinfo_get_at failed\n");
+			status = IOCTL_FAILURE;
+			break;
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
+			break;
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
2.55.0.795.g602f6c329a-goog


