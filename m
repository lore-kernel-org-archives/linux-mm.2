Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28027E88D66
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 10:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B1F86B0092; Sat,  4 Apr 2026 06:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5896C6B0093; Sat,  4 Apr 2026 06:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4798E6B0095; Sat,  4 Apr 2026 06:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 288A36B0092
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 06:25:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C25495B23E
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 10:25:11 +0000 (UTC)
X-FDA: 84620490822.22.2AB46C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3A1EA1C0004
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 10:25:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fkrLgO58;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775298310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sfd47gJP9PGgb0qwd5zw2/DbcGUcI4J4fP+mToocOpA=;
	b=PS5REkNF0Ztbv9VWFd+2g6wgbdVrko/FweJWOVfvdi8XggBLkqN4UI8nHY+7Bp6BZkuHyr
	AA/rAU5M5KoeOGwrkQ4V9mbH+SfSq0HUfmEv4OWtbeJaNR7s8n1xsv98WIFgxIzfVecgSv
	He8oQpj25UcAkHoeqMsWFlVCFPS+k5w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775298310; a=rsa-sha256;
	cv=none;
	b=NTQ+C5LV+AeJyB6DEEemInzLvsiVJmV9s8Akc2FM4HREissz1WcEDyVsON3EnM4yZsz8w1
	Lt5pQpDR7EbKw/+SgzM9egGv9M0Gs9Ycdey9LRdxq5vKexHXY6hFxcRR6yeZXY7fXgq8iK
	MekVUIY2E4FcLG2NCALHsov/+EDg+FM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fkrLgO58;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C1C416012A;
	Sat,  4 Apr 2026 10:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF7BC19421;
	Sat,  4 Apr 2026 10:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775298309;
	bh=jO6gii86DPoGXE2I2GMdnsjc79+Mrmki6SEokudViyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkrLgO58PB06qWQQJ4nhbCHIYS3eol7n2ImQc8zSS7GL1MFFSi/ShO+dzK3Ea+dCw
	 XgOxyYoC35yO6hdYUdkndpKG6JcbD9eU8Jdg4IinA7vGzwxh7dk+qWzFo8NxM4E03P
	 mOZtX6UjGrASHvgbsdeiTJZjbwgeZnGQ9smw4ErGAXJbrCQlPXvqcPuRj0Sd9tvIkU
	 M2Kd1BVwOCDPV1mMS0GC47dCdboiHehCwwKWcq0ykc93iBPTmeZ219FmQtEu5DZe0L
	 9SyelQOQrCZMVtwsn3Wemrfb0K06JIcoJG5mvHtHcMRbmtM+2cjLaHZihLUfom61vh
	 k7k1qp1zFK+0w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 3/6] selftests/liveupdate: add test for memfd content preservation
Date: Sat,  4 Apr 2026 10:24:46 +0000
Message-ID: <20260404102452.4091740-4-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260404102452.4091740-1-pratyush@kernel.org>
References: <20260404102452.4091740-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3A1EA1C0004
X-Stat-Signature: bh3fniq8xqzbi4kd9su4xbkxf1mqt3cg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775298310-472567
X-HE-Meta: U2FsdGVkX18j+x0YOz1j0CVIN8VZi3uBhb7a/zHvfVQBe87jxSekeAUn95N47iN7fMrlSlhqSNcl/ZhjCQP/kq1TQx28gVntF/2rbtfrw4SiQsQHlYxVJ00df6rnyWV2dnOiS3hbWSz1JY1VhjjOm0VMw0TfhnmLLrLaOR+BShliCXHkSfDH8xQb0ycoChVzXMoErjAFWHcjW+Jx4UHEHi+ftCx46036IyH5W0Sn55E4q+3BDnERl7jU+A9OB+zuLdHJyP4lV5wbapnTXCInM00rQS/TioIWIL1NSaSKU8QEsLG4Q24ynztiNcPoISY13VKJGZsHiECDNCK06MAibqzcyO0kgF5eKO3YUima2P+buk6fnrgY8kkpB8bfUt1hHWoLi3dcyPC2J5yVRSv9GLPUsPh3KFlHUKFGPu2t9pSEtmiDIZLovbuNLBb65oBaK3xvQb1SpvsgpBFuxDvkmPw9OREh4NYpmtz6xQlp0msp5EXH6W8oGA3GNe9EiZM/S6CphoGx2CKvmhAQwkNh0Zl+OXKGxJ78JMtmpymsHJmkKyzDFcs2QO5w5d5xG8QsdcbZtdmolrUo0yUjzkJaFtrCzi7dsI981gig7QfKGcvn0fqi4d+MkE3BhDpG6Hmjx+3n2TtG5wlYsMIjQnIQ8nlO4KGVxlFtaZ+yl3/Tm41FPJEX/GCw/duCwCgqkH9a2vqrXeb7VSNPGfO3F8Bif1V5W0A6q2UEYKp8qJwQeZHNkmqLZ4mU7f7MJYUJyH9SILvo6gAjPP7YHEJquS4eCjKdgzFM193KOLrPw+cQPMVgwxMuS7SE/cRw5QICz4ix1agkGsNYD0PjSwLlBprjQNjWg8FlAkYynXUYkOgHJs5GwFm9XG+SMJJRQEm1ziM58EOFwcEMsKxBwx5eSKwZeDN0T809ksT1mVzz8YtQlvUo9YUYdRNEqut+1p2uWy0+uZZgzWnjTEfXU5QKBi3
 PdpRkR7M
 KNGFRETadwJwD3BGVx/Y5NKx++9hZHN39jxDGOtM/rwDbFjFf0ZES6wkHfjh+ZvG1IBwMF9h1zl77TjTVs7x/pl2PRUXM5TU+ikog/dyIWUaqg6QCoKQZUEr1yYeepfEZXYDEdae6Nd4F2kEokOpPpbp2U1T/h2zN5TjTbj/v72qUuHESy+73b5MdYDXuyvsCjYupim/8ZNoUPeCHE3L4zHtcN8DfANYNNSpEtK+8hPvfl0iXIFv9EwUi3XnBvXommume
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
index c1f3275963dc..068c7f30c4de 100644
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


