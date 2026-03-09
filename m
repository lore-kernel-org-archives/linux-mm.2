Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BCC5EFCD9E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E356B008C; Mon,  9 Mar 2026 07:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA5F6B0092; Mon,  9 Mar 2026 07:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856DA6B0093; Mon,  9 Mar 2026 07:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7175F6B008C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:55:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 425DE1B6C8D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:55:00 +0000 (UTC)
X-FDA: 84526368360.07.2A438FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7A98C14000D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:54:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h+V272oD;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773057298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8zgzy0KyQ/CDz3ciYrvjwSb1oYSJ2X8/PrmedrWqZQY=;
	b=pCH2GU507WI7bVdPF8wZu1ITai42wuY98h4Xq5iO6sb26YtWCY0Xwy7Oi5fo4EP3xrYQwa
	hxWgiPnsI79tSu9K8knMqcUKgCC4CP1x4VIqe9QdnFetQllZfiiw1nb53rP6o5gOhBZBK7
	uKUKVSrVe0iOg5im+Ksw8YnCNNkrNCM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773057298; a=rsa-sha256;
	cv=none;
	b=HfdN9Gn4JuCtahgU7KaO75XXaqF8pDrYp44V7LL1rmy6VzMBi+n1Xbqd/95S5QU0UJwFEA
	Sxyte/OhbkqGO6+FYt9V26XMLrbBcl6aqFjshTqnnEfL1Un+UpyGr8Rrq4vbN6IPolI7DP
	miCeOD7AYrIZZ1kPs2HZM5ds+TIYrVI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h+V272oD;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 813EC40359;
	Mon,  9 Mar 2026 11:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF58C2BCB3;
	Mon,  9 Mar 2026 11:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773057297;
	bh=aukVArEnfq1vpcp1oDLYNMSSeQUJHmSNYgjjmrkbTRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+V272oDbkvOesj7cS1BfEoE2WszM4TfVldXlBBN7FHsPHmmU1wSSAeLBK4g024Lr
	 Gp0Zz69XpjGr2mm4qQzw2Q/KWj1A8kp9Qjj7BwCGbqcMEAVdolh0wrKtv9gshb4cgn
	 kn//cXAoPr5C3IBPgHPPKEDX77h3VqoU7F/ztuqNtnWtM5eGZpwV5y51Fus0UjEkh6
	 Lf0bh5McIuQz6HfUyCP9D80ZWjOzFIXQmLTxMphUxFh6H/yYy4gnbC0ykCxnUe1GA+
	 pasfd3hbqDrfdrWUsRrzJb1/rod++t47KYmNqYtC4LjX1LZgUplCKuZP+8wifeZNmX
	 AUQg612eBKvGg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/6] selftests/liveupdate: add test for memfd content preservation
Date: Mon,  9 Mar 2026 11:54:36 +0000
Message-ID: <20260309115441.266805-4-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260309115441.266805-1-pratyush@kernel.org>
References: <20260309115441.266805-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7A98C14000D
X-Stat-Signature: fr3g967gyr4kiuc8q46sz6ap5gzpzxrm
X-HE-Tag: 1773057298-472979
X-HE-Meta: U2FsdGVkX1//lYggWlBreYycyrQ6t9PBlrJqUEpzRQikcNwGmbjp4yJXFhVJIsvVTr//QV2aB7P6YtmABrKdnMXZ0NucyJgypd2h4gmzrNZGYTxX1n7/AVkBFhHZBgJs/CtdfwBqWNFQzTfj2zBubvgXooFsbi8bYvZfFgWNqmh+HVetviX/lSR5WcNrS/Hp/jpc2L4WFsyj7BN0MyzrSIJnCB0i0pCqteOhPDNF3AJ0NpzrQQZPIT+9Y/PmI2cez32bueRYwiHO/CbL0iIxVNm+Uhw+sCxNgt1tsPkqrzjw9qTdKCMm/Jt/8zHOs3Ol0tEUVjO/d/5tLIGssAcIwlf3D1S8BTqDVjNz9zxRBuAp3EY+LLTj3nysf5yg+JO57Ki41KYooVJAqsX1Hqxn5YV/u1sojEyA2h1WWD5WBzk99t9isrIKRemjqQ+fu4ES/KVbBuQu0aSnwE1HkBzTptKHc6KBx49E1PNvfHjQu5xT9ocu11RIB0iPkfjOGSXwsJOFOeIoGUGaUl8/Z1++nrUplqcw4vyKgn+Btr9gvs+jrZ+cOpxunJLx42nQnqGmR2n/iSBJJn7moaiZl8CmxVPeKLv7q4BMmE5/8hLI8/+K6iWZhsMpfl+OFjhzfl95995er6ec/RDTlaBi0yl68KBXGJuUdu0A9VsVoqLf34WqrqUXAEUwWn1dNhRSALhxYXv6j6X08Fp7BDA1XjyM5S9ioY/A0aTnf/wQizEUOO8mwYZp1ffJi74w1DZZbiFYQHh5x7uM1CkCP9W7g2R7eWr1vQ9grw+bwjSNRWAwVvONIplH0O4bB7XXtJxBkfaq91V4GQaGj9TiBM8NPwGgCazDEdKYPSNfDzALZ6k+r1QQfy5AN9yKaC42VQILBUN5wb2euDoWXpKn1KlEqCL4/ezPrxxoZYqNXDd7njJs9HBdHVH9ywU20Hh2CBDGRYRLQ77uudmm+49/hxI9ZtD
 p+HyiJv9
 WsFTV6+Yv80L4tYlR8UjBIes4DpxJoRiMjXGyZvgNJilfZiHzhjZZC9EZigFInp7L+yqTm9NpD5jp9xG3RmVogWz7Guqp2t1RgNVhWPM1onNzqBWK/HN+PHgrkcoSKfRxzmdszLYpWsxrU1ix1D25dbJZfDPOzV/DvLssJLlzhbHPGvmrbyyHqG6spPN4AyHR6pyWIYsFQNcNjAVcq2UD7v3BurpTRgyEoInaDBdItk6e+yMyTPIgW1VVduIoYBwLFbLD
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
 .../testing/selftests/liveupdate/luo_memfd.c  | 61 +++++++++++++++++++
 2 files changed, 62 insertions(+)

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
index b779eee18387..52b5f6b16e19 100644
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
@@ -25,9 +31,64 @@
 #define STATE_SESSION_NAME "luo-state"
 #define STATE_MEMFD_TOKEN 1
 
+#define MEMFD_DATA_SESSION_NAME "memfd_data_session"
+#define MEMFD_DATA_TOKEN 1
+#define MEMFD_DATA_BUFFER_SIZE SZ_1M
+#define RANDOM_DATA_FILE "luo_random_data.bin"
+
 #define LIVEUPDATE_DEV "/dev/liveupdate"
 static int luo_fd = -1, stage;
 
+/*
+ * Test that a memfd with its data is preserved across live update.
+ */
+TEST(memfd_data)
+{
+	int fd, session;
+	char *buffer;
+	struct liveupdate_session_preserve_fd preserve_arg = { .size = sizeof(preserve_arg) };
+	struct liveupdate_session_retrieve_fd retrieve_arg = { .size = sizeof(retrieve_arg) };
+
+	buffer = malloc(MEMFD_DATA_BUFFER_SIZE);
+	ASSERT_NE(buffer, NULL);
+
+	switch (stage) {
+	case 1:
+		session = luo_create_session(luo_fd, MEMFD_DATA_SESSION_NAME);
+		ASSERT_GE(session, 0);
+
+		fd = create_random_memfd("memfd_data", buffer, MEMFD_DATA_BUFFER_SIZE);
+		ASSERT_GE(fd, 0);
+
+		ASSERT_EQ(save_test_data(RANDOM_DATA_FILE, buffer, MEMFD_DATA_BUFFER_SIZE), 0);
+
+		preserve_arg.fd = fd;
+		preserve_arg.token = MEMFD_DATA_TOKEN;
+		ASSERT_GE(ioctl(session, LIVEUPDATE_SESSION_PRESERVE_FD, &preserve_arg), 0);
+
+		daemonize_and_wait();
+		break;
+	case 2:
+		session = luo_retrieve_session(luo_fd, MEMFD_DATA_SESSION_NAME);
+		ASSERT_GE(session, 0);
+
+		ASSERT_EQ(load_test_data(RANDOM_DATA_FILE, buffer, MEMFD_DATA_BUFFER_SIZE), 0);
+
+		retrieve_arg.token = MEMFD_DATA_TOKEN;
+		ASSERT_GE(ioctl(session, LIVEUPDATE_SESSION_RETRIEVE_FD, &retrieve_arg), 0);
+		fd = retrieve_arg.fd;
+		ASSERT_GE(fd, 0);
+
+		ASSERT_EQ(verify_fd_content(fd, buffer, MEMFD_DATA_BUFFER_SIZE), 0);
+
+		ASSERT_EQ(luo_session_finish(session), 0);
+		break;
+	default:
+		TH_LOG("Unknown stage %d\n", stage);
+		ASSERT_FALSE(true);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	int session, expected_stage = 0;
-- 
2.53.0.473.g4a7958ca14-goog


