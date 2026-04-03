Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AF65E85368
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 19:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C19886B0092; Fri,  3 Apr 2026 15:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCAF06B0093; Fri,  3 Apr 2026 15:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9A66B0095; Fri,  3 Apr 2026 15:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 95E8E6B0092
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 15:40:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4760089AC1
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:40:35 +0000 (UTC)
X-FDA: 84618261630.07.4A3CD27
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id B1826180005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:40:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Go2tvX9v;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775245233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7sKn/9elOClwuNbRS7A99/e/z7V7WIjF22TNtuAo2jE=;
	b=KZr1eN8RiOyE225XAVF2ukfxJ0St28b5Qv85HJbXMpzKtdbgpcXE7G6GdN46lIR/3Sg3E1
	D1mj4GH1/datbUEi/DRKwwfz6QBtFDSsITFwm9IF425nYpf0pcBYzIYYXP5VZUywr/2NuF
	szoeiFZtmymoSCQ/U88ydjSoTuUEQd4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Go2tvX9v;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775245233; a=rsa-sha256;
	cv=none;
	b=lq6u69Ssv7V6/CdzapVDzQdSVTrxQWLoLMQXxKtJ66MHWyuJnqNU7GbAEMYFNCY1Ojjlcn
	NkRRQBYC4yN3V6lB7D2LhCDaDQc3a3bXW1AnLFgrzXTv5T4FakNjbIUsvIwmHOZtjKuvS2
	1stgmVOHen03JZpc53GWFoQe5d8Rt9c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F43D60008;
	Fri,  3 Apr 2026 19:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2E5C2BCB3;
	Fri,  3 Apr 2026 19:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775245232;
	bh=4sQ2am7P1fIKmx4JakwbC3BEjgsHp2lmwc8hACFKRSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Go2tvX9vIXO8EQ7FnchajHLDwJAyDeUd2ba9pglp4R8p4TfPwtbTRxvwWW8nAex8z
	 riJFtzogQZha0TsAVk6oEpL5fa6Q1IDjFFZirOhY2UxemaonhgAqvut8CQ/gE4f7Ne
	 SNMgJq17zo4XkmuluRT1n2FCChbhIcTWBPfI4smS2mjYs+MYHr+t6PhRWSL5lbEoMB
	 SSpZZ4DBKE6SvQPew1OX2ROC5OgUOLteIWDz+pX4rV5+DgXIFzIDztY/h21VJNhvNB
	 reMVhu3ewxbXcTdsYDbJvmYi0jwjpJX4QNxMcI4tvAP7WwQGRDBznGTwfm8N7onmLv
	 3C3Pz6cKJsRPg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Pratyush Yadav <ptyadav@amazon.de>
Subject: [PATCH v2 3/6] selftests/liveupdate: add test for memfd content preservation
Date: Fri,  3 Apr 2026 19:40:09 +0000
Message-ID: <20260403194014.3704180-4-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260403194014.3704180-1-pratyush@kernel.org>
References: <20260403194014.3704180-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B1826180005
X-Stat-Signature: nigjso7mudgpqr5hh6kwkgywtu4g8tc8
X-Rspamd-Server: rspam06
X-HE-Tag: 1775245233-591550
X-HE-Meta: U2FsdGVkX1/FUIXx2n/x/9vOWOeKu97StrLTmiC1hxpF6dZzAeKqfy/w3+nuU3/cDFgTtM1VKgZjD1ALPC46d80EXMDckAmXhsvjw/e1ufCk/uElBRajRJcQgpulKNOs1Ubi8927aIleOb5b0DWeY6w/K0r23MemZqfr33g1T3RxlqVtzcQZwYh5+Gje3axGACIaXyNCTFzoSu6PC4Fp/oNhtutbJvNh5MmSbaxvE6GIoiTNoUyhw67kYOZQpyCbapL6izZxweRTqTxX0zTQ/MFQmxzY9vme/rMfyHcPjpIpEaYpjwenorTNOH0J4YV+8i8N7QVk76AF7aC2qLjF4ZmuxzKtFWAJLQx+vx1oDRH1WlDcZ62ma3hOWBWTBurR6bO/B65lWflWVtHmZKElpOCJejPeKNU/8y1XnNmVyLXrNBvErrqd9gw0WdoMRMDOmVBLf8r3afOy1BDjJqJ0cD420bMLCuT8z9lXFD0phdc494zSO8LPg4LCE9b8YGre7aZL+YNDlXnyiw/bJ9KXfQgBBbbfvuVnlz2f93hxL+u5BwtqaERgZlOnbie8lfS7csV+0/r69w5Mwkwoh1p0PwPakXa1DFXoL8wq1DAWMQulfiGtvNLr9ZblFF9SLaDbeRXMXlo0LRcHSUiDk/WiALVteT72tBXVJoLpvPFy6jfI0kWLdcJ1KmYsBwIr5k7wwE9RKOAYs1K6Y6NMMMHrLHXT7nz0cEhOOvwUH8DRWBb3kZBZGWrDnhcqg3qFFOHWAMyfss2hEaoF46yg1Gz6/Ls/09dVupU8WMgBvk7OCwuPoHgLKeAtNzBHwTJF9cD4zw0wvplzWDJU8gdI5p/JknZ+FyvRZIQgzWvaOhkIW2G6ON13nKmJiNsIcQl6sMN7jpQpU6Hr0laIjuo4u4mZFLjie+Ir38/chtJmWP9Zsl+zMVrHhCRjTdicNZcB6/Jip4SdANXtANS7jKTgzig
 PU3UInPZ
 /meehlHH8W/Y1lJMALEG9/XNI1xSXQyG4c+CJbSzolzg2Qzz0YJnCzqcBbq082SSLcZL6n+TDJ3UW6euZIRMCc9dlhrmRWYl6aBYd8dZR8zfj6dj24Z1OCSkLBItb92K0JVvA3kcRx+VN8tZImHgJZnuH5xJ6FACzB1flO2D5qHZHtL441D8rfWo4GCX9Ojn9ceAsg8nOG3lPaWYlQKftIKnn9rrVgp5aHrZrmqT8ux001K+snhg7gAzakHim4sRfwMMQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Add a selftest that makes sure the contents of a memfd are correctly
preserved across a live update. In stage 1, create a memfd and fill it
with random data, and preserve it. Save the random data to the file
system. This will be used by stage 2 to verify the contents are correct.

In stage 2, retrieve the memfd and compare its contents with the
contents saved on the file system.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 tools/testing/selftests/liveupdate/Makefile   |  1 +
 .../testing/selftests/liveupdate/luo_memfd.c  | 80 +++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 051daae55eec..8e2eb6500c07 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -13,6 +13,7 @@ TEST_FILES += do_kexec.sh
 include ../lib.mk
 
 CFLAGS += $(KHDR_INCLUDES)
+CFLAGS += -I$(top_srcdir)/tools/include
 CFLAGS += -Wall -O2 -Wno-unused-function
 CFLAGS += -MD
 
diff --git a/tools/testing/selftests/liveupdate/luo_memfd.c b/tools/testing/selftests/liveupdate/luo_memfd.c
index 47d2c3163b62..70eb96950f04 100644
--- a/tools/testing/selftests/liveupdate/luo_memfd.c
+++ b/tools/testing/selftests/liveupdate/luo_memfd.c
@@ -3,6 +3,9 @@
 /*
  * Copyright (c) 2026, Google LLC.
  * Pratyush Yadav (Google) <pratyush@kernel.org>
+ *
+ * Copyright (C) 2025 Amazon.com Inc. or its affiliates.
+ * Pratyush Yadav <ptyadav@amazon.de>
  */
 
 /*
@@ -11,11 +14,14 @@
 
 #include <errno.h>
 #include <fcntl.h>
+#include <stdlib.h>
 #include <string.h>
 #include <sys/ioctl.h>
+#include <sys/mman.h>
 #include <unistd.h>
 
 #include <linux/liveupdate.h>
+#include <linux/sizes.h>
 
 #include "../kselftest.h"
 #include "../kselftest_harness.h"
@@ -25,9 +31,83 @@
 #define STATE_SESSION_NAME "luo-state"
 #define STATE_MEMFD_TOKEN 1
 
+#define MEMFD_DATA_SESSION_NAME "memfd_data_session"
+#define MEMFD_DATA_TOKEN 1
+#define MEMFD_DATA_BUFFER_SIZE SZ_1M
+#define MEMFD_DATA_FS_COPY "memfd_data_fs_copy.bin"
+
 static int luo_fd = -1;
 static int stage;
 
+static void memfd_data_stage_1(struct __test_metadata *_metadata)
+{
+	int fd, session;
+	char *buffer;
+	struct liveupdate_session_preserve_fd preserve_arg = { .size = sizeof(preserve_arg) };
+
+	buffer = malloc(MEMFD_DATA_BUFFER_SIZE);
+	ASSERT_NE(buffer, NULL);
+
+	session = luo_create_session(luo_fd, MEMFD_DATA_SESSION_NAME);
+	ASSERT_GE(session, 0);
+
+	fd = create_random_memfd("memfd_data", buffer, MEMFD_DATA_BUFFER_SIZE);
+	ASSERT_GE(fd, 0);
+
+	ASSERT_EQ(save_test_data(MEMFD_DATA_FS_COPY, buffer, MEMFD_DATA_BUFFER_SIZE), 0);
+
+	preserve_arg.fd = fd;
+	preserve_arg.token = MEMFD_DATA_TOKEN;
+	ASSERT_GE(ioctl(session, LIVEUPDATE_SESSION_PRESERVE_FD, &preserve_arg), 0);
+
+	daemonize_and_wait();
+}
+
+static void memfd_data_stage_2(struct __test_metadata *_metadata)
+{
+	int fd, session;
+	char *buffer;
+	struct liveupdate_session_retrieve_fd retrieve_arg = { .size = sizeof(retrieve_arg) };
+
+	buffer = malloc(MEMFD_DATA_BUFFER_SIZE);
+	ASSERT_NE(buffer, NULL);
+
+	session = luo_retrieve_session(luo_fd, MEMFD_DATA_SESSION_NAME);
+	ASSERT_GE(session, 0);
+
+	ASSERT_EQ(load_test_data(MEMFD_DATA_FS_COPY, buffer, MEMFD_DATA_BUFFER_SIZE), 0);
+
+	retrieve_arg.token = MEMFD_DATA_TOKEN;
+	ASSERT_GE(ioctl(session, LIVEUPDATE_SESSION_RETRIEVE_FD, &retrieve_arg), 0);
+	fd = retrieve_arg.fd;
+	ASSERT_GE(fd, 0);
+
+	ASSERT_EQ(verify_fd_content_read(fd, buffer, MEMFD_DATA_BUFFER_SIZE), 0);
+
+	ASSERT_EQ(luo_session_finish(session), 0);
+}
+
+/*
+ * Test that a memfd with its data is preserved across live update.
+ */
+TEST(memfd_data)
+{
+	if (cwd_is_tmpfs())
+		SKIP(return, "test saves data to rootfs, cannot run on tmpfs");
+
+	switch (stage) {
+	case 1:
+		memfd_data_stage_1(_metadata);
+		break;
+	case 2:
+		memfd_data_stage_2(_metadata);
+		break;
+	default:
+		TH_LOG("Unknown stage %d\n", stage);
+		ASSERT_FALSE(true);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	int expected_stage = 0;
-- 
2.53.0.1213.gd9a14994de-goog


