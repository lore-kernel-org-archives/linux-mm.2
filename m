Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E996EE8538E
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 19:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626636B008A; Fri,  3 Apr 2026 15:40:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FE066B008C; Fri,  3 Apr 2026 15:40:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53CC76B0092; Fri,  3 Apr 2026 15:40:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 469896B008A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 15:40:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D48BB160267
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:40:32 +0000 (UTC)
X-FDA: 84618261504.28.57C890E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4F5D41C0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:40:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qnlOGk11;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775245231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4MiSfeQsd9Kmu+aYrSL8fk2+8BUgNEaEt/sTVGoM+bs=;
	b=hRyGl7nq8Lw8kS6gLUfephAJD11/HtRVB7i4bC7fZCaKY50vH0rEkvci536mZluzzd4Cue
	1wrEfdosvwaHN5aylg4yNMOVfA13e39H2FvuTj1ZfW0VkhnTLS8XEgpWasGou56xHHevyS
	BHrKSK2e5TtSRhBTlzb3gnyCylUkZJQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775245231; a=rsa-sha256;
	cv=none;
	b=7XA3w1TNdoFoP3WPLFrVLsl6rhEMI5iZMWfrMjqUikbYDd4eu4fmiOBaFlHHvHjEj7qYwc
	8tFyc6/AxZNPLT0QBsqEl4Ex1xoqxcvaAb24DF7pnaPZvWPHqvzca2CXEnXvurujGvv3ew
	n+TUwl8ia1j+NlpObn9DJf9c9h70plg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qnlOGk11;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C3DCB6012B;
	Fri,  3 Apr 2026 19:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6F5C4CEF7;
	Fri,  3 Apr 2026 19:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775245230;
	bh=ewW/SXYu+Y2DgtLtkPP3OYPb7SH30gYzCUlOzRzYtZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qnlOGk11o5AS6MsumHXaD8u37mQ9YU0Zd+bZcK/NLVLf4k6QhzvOgOuuBKj06f4Bh
	 HUpfkcFnLTpgNWZeZFc8fleEiuDx8ZdLBJk1tDgykW47T+pscombNbOhGUSjPAJILD
	 vsru0LfvsEB+6bnjIlSbBb/qer7wlMEEsjI3rzLmrTJbNVuqIVecURE9ThBWRPwxGX
	 Yvdpi7sy8WKU56ukloUUpQRV2sRkuUWMhL+cYBod79vvI0627n8XIGgSAm8xTVzrCs
	 tpDfbeRNaQgZnafwgWOEK702D3pWf3Xiy0tBpAcO62+hssN9wVAgwZA3jhwNOK+ZfL
	 PbjOM3ZpHd12g==
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
Subject: [PATCH v2 2/6] selftests/liveupdate: add helper functions for memfd tests
Date: Fri,  3 Apr 2026 19:40:08 +0000
Message-ID: <20260403194014.3704180-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260403194014.3704180-1-pratyush@kernel.org>
References: <20260403194014.3704180-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F5D41C0005
X-Stat-Signature: 41rdn8cb7p997yjsowuhzirhqjstu1tk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775245231-417426
X-HE-Meta: U2FsdGVkX1+mK37CHJMB2dK4i1CMNn0VR9Mlbiz95ST3qknRvr6+rFjtZa3eLLsG9yWFicPY9A0TzHCBW573OKkKhLx/vA+KdgLKayhQ8369mr1tnKaYPM7mCOVS73N4DxGYe7OgxkW2vLHNgrFSaft4bJNP0lzptrp9OsetWs58RnMf0iDf0wpB4cJy7WJgkCvvOnc0ryhZK+w1uJfAYi7yaUYma5Eeh7cXf/00mrc+okigGMdH8+dssocCp6Dj0ewf5ugDJMyMpzA3ccJ8aBqUieDXj21i+sfAuH8h1cqBDNC/IUc+jK27pDbGVX6rnnb6gsKxtwzjrJfkDS10/aeIR+8fBQ9jytR/WAOXIGgjBTSBpEEPDi6mbccsHyjZdReGvcp6N1CycyGYd7HoX066jxifMgs3K8x0zq1ZWr2JPFWi+P7G+4JnwFBhZr31qx1M09Exv6Sk4LtXncRjKQKQw7x6e/031jz/Diz2jBB8KTOdx50ba7kRrFQn7k6GhoWAcYdMIZbkb0dh0yKUVK/bi9D31zTct6QYfIzMKybfvF9vmrMRgO/4JgF2/Mf/IF+WYqdSrqMQd51AI9rNi/V6mnm7WZj7w/ehcs1uu/VYuZkVZxNW6OHvM8BgiunCt4AzzE+YswK7JNACmHB4JPfDMSSojAG5DePbwT9wzd5fqBcWW1qIp6klODu5ADDAU717BugazL7oZIiNA0jwq6qevK21Y+H6xjwtxz95HwcK59jnUDp/ldC5ko9eUvUBeBWUkRHyUSBOPS9xk0cSwUMRpUkHFxPO32OJct3bntMPWJIvulMQcc/no8VtLe+zTUOSI7fdiu0uM6JCexdo2NaZgCoaP708xymcIO6h/YsY+wwYsGb3omtsWOM3EHSbBzJiaAjFHX2hMnxmCkhJ+F10JJTUs+RikoZejI2yJeQQr2xV7CWcVlFBMS+z/1azpPszHrpQEGUHc4wBwPv
 v8xtKwk0
 tGTu3Cd3JY9ERBpBjaBXg4JIOk4WOINRw9l2HUzFncVdQYIzetKl8LDdzuKMR5DvjtDusUUIjLaRo1hkqMjbP5my+4MoTc7UXGp3vDAVgmoxkYgp9Lhpa4N9k+EEK/7MAoGmHYlwmOH4angwkZiSEfKS1G+9rdsXwot+fke5rroUVX2Q+RkZ9G3UwloMeuhQw8XDzSuXJ3+T/YaB4EkEeV90lRlmC0K71HrI0KMM4QG5DkgSLQOi9xobX/UpPdCLccLQk8HckqvpMs4a9IJRhGtdpk2xXZFh4JP4mcUjhBmf3OZRlpk9U4D6gXA==
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
 .../selftests/liveupdate/luo_test_utils.c     | 189 +++++++++++++++++-
 .../selftests/liveupdate/luo_test_utils.h     |  10 +
 2 files changed, 198 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
index 3c8721c505df..585add102ac2 100644
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
@@ -20,9 +24,192 @@
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
+		if (bytes_read < 0)
+			return -errno;
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
+		if (written < 0)
+			return -errno;
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


