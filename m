Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EDB2C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 18:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85C2A6B00BA; Mon,  6 Jul 2026 14:26:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835086B00BC; Mon,  6 Jul 2026 14:26:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9C16B00BA; Mon,  6 Jul 2026 14:26:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 306F66B00BA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:26:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A71B1201CE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:26:01 +0000 (UTC)
X-FDA: 84959180922.29.703C8C4
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id E1DAE1C0004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:25:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="IoZM/r8F";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3NvNLag0KCKUFGMNXMJPGFUFYLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--abhishekbapat.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3NvNLag0KCKUFGMNXMJPGFUFYLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783362359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HLFajhlOnPTNtof6Q3JbWy5fyX/S37WLvr0pNOAcOSk=;
	b=1rFCF5BUw92EGvF5qL6pADw8ys2zPxYG1svdFdkK8IjMzZAHtYd869ceSvb/bKGMbgi184
	fLdFmeSk35S0hQs9ykfStkpx4gjy0QggruW87PlUBpD+lomM2zF1vlio0wUxz7jK5L3hGA
	E0gNIHGc4kQFRKkCHf1/ZwZ6II4eo+I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="IoZM/r8F";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3NvNLag0KCKUFGMNXMJPGFUFYLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--abhishekbapat.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3NvNLag0KCKUFGMNXMJPGFUFYLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783362359;
	b=iaqoNOquzVaogxMSbvZAvohIf5OUb9mlaRVYbKro7d6wYP6OJBcZORn0C0UzCgi8w/57/0
	/1f4RpfIaqPduWgcQwPE2+w05UOzdX84wRPaOmKnurPCDtir4kJlVuxasvQWxYMsWy2Ou4
	ISBbWc4TWp1UYcS12F8J+IiPjlKS8UM=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c860544c077so9227324a12.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 11:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783362359; x=1783967159; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HLFajhlOnPTNtof6Q3JbWy5fyX/S37WLvr0pNOAcOSk=;
        b=IoZM/r8Fcr3JCM7t3p+r8KnRBr2ngt1Jp9A7vY295o6xz8aODMtoGwWD7HqZNjNjsV
         Y3pdF2jhhYKfltAFhwwdZfBMQn7z+a/Tiz9FncTA1K6cbiz7u4pFvfZp1otroNSM++bx
         vYSkJuHG4fVJikI2KmkM+oN1hYWxD42TDXGUicNyCTbozyHQNGfUU9vJCThPyj6J6Ea8
         D6Uk2DOKfr/mMVuRA6FJ1cIa+FmI6V5YaXUBhLgc8W4dTPZxIBsxkja0JwelEy/I0x1a
         Qz0BoXScaOyC4MKLVPFjo36uWhgjeQodZ6JioOdZJayEdwmoqQmG1cK+iSZx8ROjgb/m
         KR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783362359; x=1783967159;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HLFajhlOnPTNtof6Q3JbWy5fyX/S37WLvr0pNOAcOSk=;
        b=KIhi2dgracKox4hyXLnjixy+2ao/rxq0UJaFdyjJ+c4bGq7WNDJCu1kn9AwEEzdqgD
         +oEKK6S49lkvTbDS6sAtBUU8DYjasEvkaBTksmP0jBg69ryghfIQAAtv0N3G1kasudsR
         IaEoMBrLiIet3MSxTKXNZe6Cqm0Lo8YBbS1dJuAW6acftAJhUiyAYmg5qjlFCgPgoZrE
         aEGejd+hojmL3EQVVIienWm5rCODH7qaN5ImqviHXEZdyN1U88qgDfbEJEu/brc3R/8v
         9uuQa0R2vUahS9S9Qxkh9t2FYGh5UF1tRyKlbwwWqV+9vp7EMulvcJl64eLLRTtyRPS1
         dk/g==
X-Forwarded-Encrypted: i=1; AHgh+RqQJuAfKACCELJHNMGjBUmvEHesT5Yj8ROOmw6xFokHQAbhgqre2tp/uEDQJ89F9xEq8M8GpHfmFA==@kvack.org
X-Gm-Message-State: AOJu0Yy33rap143+Ms6D8fdRjyNpWmJ6jzcgd9FIdeg0iR1z6Xxqo2qA
	XKPOZlSQ66CNPqfZOobfINjfYD3LsItNXr+07l2ezq/qWOcaB6RSFlJ3mOmg07hVUFrOoKzotbK
	Vp6/8/DjjCefnPw+c8eQlX0QwM3o8oWz5YQ==
X-Received: from dycnl8.prod.google.com ([2002:a05:7300:d108:b0:30c:a5af:7269])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7491:b0:3bf:b1d3:393e with SMTP id adf61e73a8af0-3c08ec74548mr2000928637.2.1783362358527;
 Mon, 06 Jul 2026 11:25:58 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:25:48 +0000
In-Reply-To: <cover.1783361692.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1783361692.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20cee95a3fc50a146d4ced85007c9d7fb539629b.1783361692.git.abhishekbapat@google.com>
Subject: [PATCH v7 5/6] kselftest: alloc_tag: add kselftest for ioctl interface
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: cjrrjf55adwrhekme7tyn7fqi3mysmyq
X-Rspamd-Queue-Id: E1DAE1C0004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783362359-264651
X-HE-Meta: U2FsdGVkX1/dGX7Fs8kzQ6yQBPtUSSH4NLp99i9dk1RGM0eA+gq4lgSY+e/Zmu03TErSCK0+zeQDLfbzWWNYZEkFuP/iE1H8P/DiHFH4OZehcR2fB4tww/sy4twzX5gwSIYAxKEuFJN6rSNs07tu3AnqE/TQgc0CD4uIeracHm9FOVFQj0O1y6dv4C2hY539i1pj9oB9bRNSjb3pUsdW1co6P8P0eBGVJxzdgBYDkwproeGJEa0aHPVNSKCkA2ZVJPvStdsPL6mGNGpn94kcXxrSX3qHUUPPyktov4DxFvZjxrNbWKguBlmSdzcSC21AZ9Ua3yVU+aTmTHXXM969+qVBkbDC9Annk9ULFYJE/g/KBD+W2fgpN5x/9pXADMgFRY3WpvbimXbmsXBjKsCA0PDtlbSQi2TFlShfj0MFmf/jxHwnlXhiagqV+OUE45GKa8iINUYOeAMisM5pILaVqOgUsli8NznMLzsIGdVJfJaW8QdsVChog4ipLcMxX+bBgPWy0yRZyMnx5WfldXwVon1YpBlT60lYY83hT7CeQkEzr8ppx9ildwMUn7TcSGpg/tezXHaL5yZr8rfekKk+Xhd8To+XIoFIezSYqy/plBln4e+BOJL52ERCMQDjthkDuAemPFmiUzJnBPxolIKv1+Nb53yvbbBGcVe4qLSBoArqDHqMx9WcNKhJY2BIyOvCv48suN4KPp9yQxK/gyBYrNLDiO3uEzNrjE1wI9MCT9C69CWe0UBsIr1MXAHdYiLUeweA00L4XYVd6xvlhVBuV4wuIUBnhXeKuNg7gAmgT/AkrebdYejSP86STCsUszcEj5tZ6TYqgDWIhx0O4j8uZyYMTfgqsSw9VG7MyvEU4ffTTzzvjRJ2ep2dvvyW87trv5ygVsz97mTGv/feo8TqWS4q9hvhs1c8xmcENnerOtLnYVMPI19YAhMXuIcqb54QMPS0mR7TCkW7XDBQIe5
 ChGU2tur
 RRJzzMBvzX1eea9g3oBwePk/aGgWgcvIlRaOOiZpnNQygwkN9cEk9fXXXMqCtH+oc00PkTLKOFw9UwH3yBv7zMTywyR60s8BhIqJdnqeQUAOBP3GjMSL1yMUvUSUoJQYMjN1e5Jd8c7a2JsCLjHaNlgo3IoMirxBKxftPIzjJKvwJyv39opvk2JwxKAmFfvLFHhAEGhCcLNXa2EIuBfgVFMlu+sIlYhU8yCwf3tUj76ZGL1prEl2Vq6Fat0cq6DKy/4zDqpgcOPq2ds6Pme3Lq0H/rOtLK4Gm3UIQSvmxDQjOeirj8q4n1DZXV/vRJE7WTJD6cbSXzdILdDaGg2zV8FYubZQKCwcIG/zC9Gs01Lm22RW5Hxhp5ABL2mWEnMq1gcXx+YdbdUwujtZkQ0H0g1t+3zndWIjXc1RBRwlGZW/8Qu/Pru7DrTTxpGcG25wnZPYs/B/J/JSgcuxz6Yf0bmaXrZVHxh9Oi/8kq6MVe25BrL5pRjMTO9FlQTN/swMwnYgeIV6cLxuaSkl8Zqmc/eEEOu3iEObyzuB38inOJXiKYTDkyBSveBLrp0HYRzbdmOlmjMypnh/UXTpJLKHtH8Amt3gDn/Sd82fdomCCJ6RoSBG5d/TuiUGuEA4werDzpMZw6hmU6FVZw4M0JLzY9D/Z3oXPVv+Cgb5A7GdPGEEIHuktjUDaKEB0vCvP7LZJyc217XsjNP8jPbnWQcpJYCI4t3lADSM+/shIQdBkPbwSfIM=
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
index 200b92ec1ef6..867d4ad58fb4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16939,6 +16939,7 @@ F:	include/linux/alloc_tag.h
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
2.55.0.rc2.803.g1fd1e6609c-goog


