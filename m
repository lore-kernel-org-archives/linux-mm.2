Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE2BAE88D98
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 10:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563EC6B008A; Sat,  4 Apr 2026 06:25:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53B6E6B008C; Sat,  4 Apr 2026 06:25:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B6A66B0092; Sat,  4 Apr 2026 06:25:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 295326B008A
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 06:25:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1FB21407B8
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 10:25:09 +0000 (UTC)
X-FDA: 84620490738.21.19F742B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 41E731C0007
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 10:25:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iRW6hSC5;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775298308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCg04bl5mxRcvV5IdOOP91mjco94f1ODPqDoMH1MiSI=;
	b=yi/dhvqf9J96Mhp7coFZbxVf9DXqNCQyvr9Uf5BSuXQ+CehFPu6FC07760Ad5v0Y7VhB0/
	t7ofCr7ejkffjz7DHTqSjkCskgn7HKQgV1/KeFSFBsGAoxXbXWbvGI952VgDmpQsrP31Be
	STB+lFe+fh59FzQCd6xEaoK5OcwSYyc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iRW6hSC5;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775298308; a=rsa-sha256;
	cv=none;
	b=PaCBosrRdI6VucLfrSwhllN8SO9LXp61rhgaXrE6sEFc/fazuiE8mh6a2LXl7qU2BY9mCF
	pTGlkFqflk+2qpUkw34F0yADNinFbHrV4Zhczn/xsfiaKWDafrXNZ+qFoYLM0NO5n3cUEp
	RtLo9z36oJeJWRKQJqKq4ff6yB/wfuI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A52F60131;
	Sat,  4 Apr 2026 10:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821CEC2BCB3;
	Sat,  4 Apr 2026 10:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775298307;
	bh=4wUqlSk5F6JPXlOV4nO49t1axV7aX2mPAkRXPiBcSU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRW6hSC5CY+es5Pz7Wk3TJeZUOI0x46U73T6qNo+XSobA8Up1tzhuDhurEq37oMlG
	 EkCTyNJhMK0O1w20IYtoyDl/Bttv6DqIP5knyo9gGXFNF6azYe9rB1kBo2zv0/Hst8
	 8fBgtGHqGFU88oiH70jUrekPj+Sr013diNBm5OqqLx31daCba1UHcp4pqgaRRPGnwZ
	 TNlkE7vPNeVd2cw2LiRzbwYZ7x6Y1nAocXNPV+UgMO7SVCa6fbBjCtV5r2L11ifPX4
	 geSMcZAifHECsMVI04oUcbgwuQueTMFDBpIaPE4IVf3Tfvvg3SlomEQwLBCaN2e1ko
	 pz4tEX2p2pbag==
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
Subject: [PATCH v3 2/6] selftests/liveupdate: add helper functions for memfd tests
Date: Sat,  4 Apr 2026 10:24:45 +0000
Message-ID: <20260404102452.4091740-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260404102452.4091740-1-pratyush@kernel.org>
References: <20260404102452.4091740-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 41E731C0007
X-Stat-Signature: trudj9y1x4j6r4pog8fusf4f6imihtd7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775298308-403446
X-HE-Meta: U2FsdGVkX18ZE3/C9ipg2hZ3kku2u5MQXL7CGcQ4Ec+hLonQBYCEJKow8+TCbWnzuCyTBYY0BwSZEk68I+4dzSLQfo2HLAVWrWsU4lHYaDUcC7exhqjv+hFGDnh82tfoQ9tQ3U+9Rt4gRNRgDEWArnhMbUrC76pG/gDf3ynOwO1YrlGAy3vqCtsajh3B22TBn/KGo05TnE/1y39O7ngQa+1G2h4Z6hefPkBzOQlUqOXcVnPqItWP163DnYA7xmYSvEwRtRHkPFWMokb5mKteBVSHqLkoOe47rea+Nm0+E/6+STI0KhgE1VO2/3TXmJAg+xuHYW+DGWWH/HEI1YnD31O3K1NHINBhg/UiCTXQp0FLA2ED+QbnNpCtNKDlQGs8ePgytrvGJ7i5jxoyUmtrHtGEap6ImEc590SZxlXWFktYYbZLFm6VCLvex37/gp1HRcDsSoNmsUrDBMG4kjXWWtBI/De6TNM2VAhbuJmx6NMRGw6o+Z0wLPuG5W/gErG9DVRMUVzMiIjfGoScQjfd/F452jb7qcfjOfAYNoqJbtnjXFNhTjx0Yan75N5npuqOmVGQJcKcX7MgFy/tIBRYVsfljx5A8sdHYaTkbaGcu7gObCxrfc6DXRcCRggk9VG56+Fx3fRYGs+fL8M5+o6uULGPtaqh+d4cznKwrJicmRbGJHm9PitqRecqpRj7pu/6BiUw17F58MUEzUvlnbES3A4izBs+WU4uHII+0Yoyga67ANDYrithj6WiBEJU8eKHmvTsvA7ywFOqiAcau8ACi4endlo2pCmOoPgAUQLAw6ctHk+iCTX3lSio686bVKxusf2k2LJmAxG9mrTazaixJdUF3orFOoKsWOn+BMsS2ClJyV1/+5A9sqc7hW6LSvHjXDKrYbChgVqXI7wvtPfT9TxUUfO29NeFYuMvuhDhVQK4HkoPYgFXrBmTgAVsxKIw6LflqXcCkrhL8tJ6BdE
 Squ9pLPn
 j66EiiTbEpF2k3qlX51dESDdLJ4UtJV4aX3HFXDVSS1YhsXazwpAgUDq8DhedCG625fMJH8uer+A6tYp8dTJKxsnge9YXHqZDNlPwmmCc+Fz4JNmQb+mib/oEa6bmh1PmW0PWRw/159RPzMYW7k/GsbI1KxiD1/OhMBusHQA/dUJI0YLI0UjADM4bRm+QCaGWIGBJE8XJrdAEIiKaMh374XROw6DK7GzzW/iXUQhxPItZ3xAu7DLdKPtSwL640kVGk2jry8E+meDDSicsBUBB8wYGdE8iKZqdbqTSiL5f96tjcifpef5QeGO4vA==
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

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 .../selftests/liveupdate/luo_test_utils.c     | 191 +++++++++++++++++-
 .../selftests/liveupdate/luo_test_utils.h     |  10 +
 2 files changed, 200 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
index 3c8721c505df..ceb918ef9813 100644
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
@@ -20,9 +24,194 @@
 #include <sys/stat.h>
 #include <errno.h>
 #include <stdarg.h>
+#include <sys/vfs.h>
+#include <linux/magic.h>
 
 #include "luo_test_utils.h"
 
+int cwd_is_tmpfs(void)
+{
+	struct statfs buf;
+
+	if (statfs(".", &buf) < 0)
+		return -errno;
+
+	return buf.f_type == TMPFS_MAGIC;
+}
+
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
+		if (bytes_read < 0) {
+			if (errno == EINTR)
+				continue;
+			else
+				return -errno;
+		}
+
+		remain -= bytes_read;
+		buffer += bytes_read;
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
+		if (written < 0) {
+			if (errno == EINTR)
+				continue;
+			else
+				return -errno;
+		}
+
+		remain -= written;
+		buffer += written;
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
+	fd = open(filename, O_RDWR | O_CREAT | O_TRUNC, 0666);
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
+	ret = write_size(fd, buffer, size);
+	if (ret < 0) {
+		close(fd);
+		return ret;
+	}
+
+	/* Reset file position to beginning */
+	if (lseek(fd, 0, SEEK_SET) < 0) {
+		ret = -errno;
+		close(fd);
+		return ret;
+	}
+
+	return fd;
+}
+
+/*
+ * Make sure fd contains expected data up to size. Returns 0 on success, 1 on
+ * data mismatch, -errno on error.
+ */
+int verify_fd_content_read(int fd, const char *expected_data, size_t size)
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
+	ret = memcmp(mapped_mem, expected_data, size) ? 1 : 0;
+	munmap(mapped_mem, size);
+	return ret;
+}
+
 int luo_open_device(void)
 {
 	return open(LUO_DEVICE, O_RDWR);
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.h b/tools/testing/selftests/liveupdate/luo_test_utils.h
index 90099bf49577..a69dce2649b0 100644
--- a/tools/testing/selftests/liveupdate/luo_test_utils.h
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.h
@@ -35,6 +35,16 @@ void restore_and_read_stage(int state_session_fd, int token, int *stage);
 
 void daemonize_and_wait(void);
 
+int cwd_is_tmpfs(void);
+int read_size(int fd, char *buffer, size_t size);
+int write_size(int fd, const char *buffer, size_t size);
+int generate_random_data(char *buffer, size_t size);
+int save_test_data(const char *filename, const char *buffer, size_t size);
+int load_test_data(const char *filename, char *buffer, size_t size);
+int create_random_memfd(const char *memfd_name, char *buffer, size_t size);
+int verify_fd_content_read(int fd, const char *expected_data, size_t size);
+int verify_fd_content_mmap(int fd, const char *expected_data, size_t size);
+
 typedef void (*luo_test_stage1_fn)(int luo_fd);
 typedef void (*luo_test_stage2_fn)(int luo_fd, int state_session_fd);
 
-- 
2.53.0.1213.gd9a14994de-goog


