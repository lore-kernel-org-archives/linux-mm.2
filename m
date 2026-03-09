Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EF46EFCD9D
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79EDB6B008A; Mon,  9 Mar 2026 07:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776726B008C; Mon,  9 Mar 2026 07:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6656B0092; Mon,  9 Mar 2026 07:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5299B6B008A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:54:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D73481B66F9
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:54:57 +0000 (UTC)
X-FDA: 84526368234.06.987F8AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 48E4E1C0011
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:54:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TNUsru5j;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773057296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MxMHvmM3RaY2aDUFswGaKWurRtoA2jCjR358sU+4osg=;
	b=gsMjEPJ/1qcZLVmsco+SG0fGHV/o3tMMqpGInVQJm3lvmA59YdoT8GRAFCaaZEg8fAbNkP
	y3XG02eOnZfdCufz4yPvfbSrtOQLWgqamVgF4/yWdyJOrPtCPbuqeZl1DAo/kYNEc9eLWh
	6PkS7yXrxzl2WNqEcdcv+VEnHadc/S4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TNUsru5j;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773057296; a=rsa-sha256;
	cv=none;
	b=Ux636uChyzM4Xd2ovjOvO3Go+56QNuBH2kXHRk8H0zsVf8JKgG+5EhrLwGiLRHiKFGyovZ
	sELP/gYQ8EiQwRz+iG5QVjNU9OOg8muBeNryL/xCMre6cHbUzQz3j15RFyvJymy/8BFVEL
	DF3Po8lScZ0lhtT0vfScY0JW/Cul3I4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FA4260133;
	Mon,  9 Mar 2026 11:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941C6C2BC9E;
	Mon,  9 Mar 2026 11:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773057295;
	bh=PghrAoUWQBw2NUIGa/NJWkd6SAFY/nFx+VVc64+OWJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNUsru5jubWi2MbJKJBuu3usla6/Z1udHfgghCkcSPNQPkz7iUVrHtG3JgprG2w+D
	 a9KONyqqvjdcrsjH4N3Ulg80eqb5X6+2AFZotV2egl2jzV/qaHBGMfm+2vdPWZRXmN
	 e3Hg91eeplQkzr5L1XtSYd+bHogb7SZfHcsoXLD0zXHhV2hqLuX+n9p1A77p6Imasa
	 V+HqEqiAkvyUVN25DP0hP+bso+5VZGiLNkC4jVO8vtgOu+Kuiq512MCw2M9Hn+27+i
	 kfzQa7S6sRGIIJ8KIBj+pT5VqxXsFH8mHZx6VM2AE6ohvd120npMtjV6IBjvRssl0b
	 yKqT3B0U4pSpQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/6] selftests/liveupdate: add helper functions for memfd tests
Date: Mon,  9 Mar 2026 11:54:35 +0000
Message-ID: <20260309115441.266805-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260309115441.266805-1-pratyush@kernel.org>
References: <20260309115441.266805-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1nkupc5uanerc4a58jj3gktgacxudbt3
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 48E4E1C0011
X-HE-Tag: 1773057296-154269
X-HE-Meta: U2FsdGVkX1/Y0Tvmiw40jchwipYE5MqOOaLcLA4a7/5dYkqANTAi7pPpSvIZsIl9tyaT57IJnZ17pIKaN6EkEaQwm5Lg9JP1ynCI0BKVCGaIMmp9VEKGu0pbm+FJBqrEKGFCWr4hbjRzPqnZ2BBFN5fSp5ZZbm2d6BWo0vRuIYEPGPavQXktHWRWRyX1D5VGwLw65Pc1sB4gDHLzYd2YkeAP2TdYmg1wVitxdCk0mNgX2Nh5MM3b5OjYHXXLXv40hUmdYJa2lihiGiaMRCT9yZf2LMh6ymBMSWn6rOR0PIl4WcfTHTu5DDL8yUuW4VeewSaaKFz6C6LvQs0vByM1mfEin8DevIKZ4sdZQRXicT4hldeGYsj0Q/C0nqCxyH0xTlbkwH0DgaibPVUxrrlyKzgECqPtNXa+pg243Ja1C80sf33Xehd/1IaBnbo5vcQLeEJ1WRwbQ6+H3wcoQv8FBWnjktMokRZ7Ie1Z3z+469wegWkffy/OGnlehUbbux8s244aab/WjuB7RSMWNvHOjEhavHfU6SIeV4hfB3ZdEyqkrMLiV6Dz8GlncxNF+/hSVN/SkIOpyGVTAHkkeIK8rwUgpYnugs9XWMGMhn6Rd95N3NPCeJ+eps2HFK3IhiE/Ps4P/sc6MQkNxkG+Ysnj/OvoLRMDyzXyy9TpPMt6UalRh9N/eTZoN5Azr62Egi+Kid+4jGBsfsJXn3eUP6nxtfzFvWE3v2VHhUX0H8eBbB7Vdf5qxGwxA+ApXwGlVG+ueLyIsqEQbI8Tq5G7xA3cPfPfh7CIh2DLe86gQ+nouxYpkM5wpkqBWf08abYG52NY4NcVWg3IDpxH/FwVhH5Lvek0Ao7ixkX/0T9xcRG8jCFI+qrOxnKwQYiW4ohYunK/mRNfQJlotpQFvzpHZXgMAvTynJQIDZbW2fKk9c3lBtM8TL0RC0YahbdW66iu5tV3y4TaJGVOYDN39/skj/j
 m+vuaZNA
 G1gkfv1Pz9/pjcedLPpSRavO2oq2lk8WCbwG/xQJuWTEvlAbBUKS2zxe28MBACiRZkf2efiHDg+yyAAnLGoPY8/8Tc4+Sr73dbhWGcKOFGd2YL2kJyOXBTXXqVoZldo5N6Vr2ehJrmEMsAmfbJ+RV4yhyclRXhgOCTtdxSiGNY80ENeqbY47yeTKlDxarzBz0NVKjAJU+CFTehNs5E3I6LXmYb//ykunMCLK8bUZV6S3Ayc3aGmcJMLFwyE1XjiimGJJlQVI8PSVdrneeleK24Sv/tIuROPfJn1OLF655hFj8S5rFsbkm3mjWtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Add some helper functions that will be used by memfd tests. This moves
some of the complexity out of the test itself, which results in better
test readability and less code duplication.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 .../selftests/liveupdate/luo_test_utils.c     | 175 +++++++++++++++++-
 .../selftests/liveupdate/luo_test_utils.h     |   9 +
 2 files changed, 183 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
index 3c8721c505df..45ace3697ee6 100644
--- a/tools/testing/selftests/liveupdate/luo_test_utils.c
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
@@ -1,8 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 /*
- * Copyright (c) 2025, Google LLC.
+ * Copyright (c) 2025-2026, Google LLC.
  * Pasha Tatashin <pasha.tatashin@soleen.com>
+ * Pratyush Yadav (Google) <pratyush@kernel.org>
+ *
+ * Copyright (C) 2025 Amazon.com Inc. or its affiliates.
+ * Pratyush Yadav <ptyadav@amazon.de>
  */
 
 #define _GNU_SOURCE
@@ -23,6 +27,175 @@
 
 #include "luo_test_utils.h"
 
+/* Read exactly specified size from fd. Any less results in error. */
+int read_size(int fd, char *buffer, size_t size)
+{
+	size_t remain = size;
+	ssize_t bytes_read;
+
+	while (remain) {
+		bytes_read = read(fd, buffer, remain);
+		if (bytes_read == 0)
+			return -ENODATA;
+		if (bytes_read < 0)
+			return -errno;
+
+		remain -= bytes_read;
+	}
+
+	return 0;
+}
+
+/* Write exactly specified size from fd. Any less results in error. */
+int write_size(int fd, const char *buffer, size_t size)
+{
+	size_t remain = size;
+	ssize_t written;
+
+	while (remain) {
+		written = write(fd, buffer, remain);
+		if (written == 0)
+			return -EIO;
+		if (written < 0)
+			return -errno;
+
+		remain -= written;
+	}
+
+	return 0;
+}
+
+int generate_random_data(char *buffer, size_t size)
+{
+	int fd, ret;
+
+	fd = open("/dev/urandom", O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	ret = read_size(fd, buffer, size);
+	close(fd);
+	return ret;
+}
+
+int save_test_data(const char *filename, const char *buffer, size_t size)
+{
+	int fd, ret;
+
+	fd = open(filename, O_RDWR | O_CREAT, 0666);
+	if (fd < 0)
+		return -errno;
+
+	ret = write_size(fd, buffer, size);
+	fsync(fd);
+	close(fd);
+	return ret;
+}
+
+int load_test_data(const char *filename, char *buffer, size_t size)
+{
+	int fd, ret;
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	ret = read_size(fd, buffer, size);
+	close(fd);
+	return ret;
+}
+
+/* Create and initialize a memfd with random data. */
+int create_random_memfd(const char *memfd_name, char *buffer, size_t size)
+{
+	int fd;
+	int ret;
+
+	fd = memfd_create(memfd_name, 0);
+	if (fd < 0)
+		return -errno;
+
+	ret = generate_random_data(buffer, size);
+	if (ret < 0) {
+		close(fd);
+		return ret;
+	}
+
+	if (write_size(fd, buffer, size) < 0) {
+		close(fd);
+		return -errno;
+	}
+
+	/* Reset file position to beginning */
+	if (lseek(fd, 0, SEEK_SET) < 0) {
+		close(fd);
+		return -errno;
+	}
+
+	return fd;
+}
+
+/*
+ * Make sure fd contains expected data up to size. Returns 0 on success, 1 on
+ * data mismatch, -errno on error.
+ */
+int verify_fd_content(int fd, const char *expected_data, size_t size)
+{
+	char *buffer;
+	int ret;
+
+	buffer = malloc(size);
+	if (!buffer)
+		return -ENOMEM;
+
+	/* Reset file position to beginning */
+	if (lseek(fd, 0, SEEK_SET) < 0) {
+		ret = -errno;
+		goto out;
+	}
+
+	ret = read_size(fd, buffer, size);
+	if (ret < 0)
+		goto out;
+
+	if (memcmp(buffer, expected_data, size) != 0) {
+		ret = 1;
+		goto out;
+	}
+
+	ret = 0;
+
+out:
+	free(buffer);
+	return ret;
+}
+
+/*
+ * Verify fd content using mmap. Returns 0 on success, 1 on data mismatch,
+ * -errno on error.
+ */
+int verify_fd_content_mmap(int fd, const char *expected_data, size_t size)
+{
+	char *mapped_mem;
+	int ret;
+
+	mapped_mem = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, 0);
+	if (mapped_mem == MAP_FAILED)
+		return -errno;
+
+	/* ret = memcmp(mapped_mem, expected_data, size) ? 1 : 0; */
+	ret = 0;
+	for (size_t i = 0; i < size; i++) {
+		if (mapped_mem[i] != expected_data[i]) {
+			ret = 1;
+			break;
+		}
+	}
+
+	munmap(mapped_mem, size);
+	return ret;
+}
+
 int luo_open_device(void)
 {
 	return open(LUO_DEVICE, O_RDWR);
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.h b/tools/testing/selftests/liveupdate/luo_test_utils.h
index 90099bf49577..d1b85703708b 100644
--- a/tools/testing/selftests/liveupdate/luo_test_utils.h
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.h
@@ -35,6 +35,15 @@ void restore_and_read_stage(int state_session_fd, int token, int *stage);
 
 void daemonize_and_wait(void);
 
+int read_size(int fd, char *buffer, size_t size);
+int write_size(int fd, const char *buffer, size_t size);
+int generate_random_data(char *buffer, size_t size);
+int save_test_data(const char *filename, const char *buffer, size_t size);
+int load_test_data(const char *filename, char *buffer, size_t size);
+int create_random_memfd(const char *memfd_name, char *buffer, size_t size);
+int verify_fd_content(int fd, const char *expected_data, size_t size);
+int verify_fd_content_mmap(int fd, const char *expected_data, size_t size);
+
 typedef void (*luo_test_stage1_fn)(int luo_fd);
 typedef void (*luo_test_stage2_fn)(int luo_fd, int state_session_fd);
 
-- 
2.53.0.473.g4a7958ca14-goog


