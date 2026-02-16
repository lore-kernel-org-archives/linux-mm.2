Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4316FE7BDAC
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 13:33:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10836B0005; Mon, 16 Feb 2026 08:33:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8526B00AA; Mon, 16 Feb 2026 08:33:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B2BF6B00AC; Mon, 16 Feb 2026 08:33:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70CDA6B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:33:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2BE7A8D1F9
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:33:09 +0000 (UTC)
X-FDA: 84450410898.10.1B03847
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5E5EA40008
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:33:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fV3IfwRb;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771248787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXXzIop3txZRgd52kTespu7XyOHu3Aiq/YFFWfh1tEM=;
	b=3YeGWo5lBhs5mowU8LCqSRbwEQJmhE+RMR+3ZPP0TW68p6J/XEOaJKSBE7SCxsYFgh8AUM
	Ppp0O3aSyxBRU3GuFBlOm2dpTWlfqvb32WHX7mvE0FAHi5gHhHSwwQoN9XYlRBy1JBZA4D
	ML59piwJPY2eYdZW4jGiNodZSGg0P9I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fV3IfwRb;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771248787; a=rsa-sha256;
	cv=none;
	b=yBn1GGi6EB05waT+1Bjhlita9M5JGqeGrFpajH47s1eGdXv4YQDuL8JugcSsG2vlwjfY1o
	KQrRTYbT6p1sqb8/CiWd5B4kLIT/Fgq7eWGdnnBBa+7oejPXianR/iRI1PId7pKSpP4Ru3
	VQGQnSIL4Z5P2SLm/iC74CuGZuu7Wvc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C06A5600B0;
	Mon, 16 Feb 2026 13:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3F0C19424;
	Mon, 16 Feb 2026 13:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771248786;
	bh=nPMJv52b+iIBwowiKMG1azbuD44a7hHTFx5KxGAnUcM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fV3IfwRb6d1jbCeVxB6PkY4ivmmysujLKj5ZaqrrLALmNYk69zYkUmiEfRnRa/mId
	 3j7LS24QsNw/0iJw00yIbgRDay6BnIDtm1hDog0u59LIepmOpHXIOHgd0hwgJdmuBI
	 Gwv3jGYuusBrG09DxkEP5aGHuPIPubuExRnHGNBJmMmMSAOOBoqwPwguqTuDyCyOEP
	 JA6Uwh2JGG+M1W0htA8dJuD14svtgiVc3eisNOWTOlzMzO2DY5EXyC+E8aqi3APCdh
	 MoBRaQKtGlVLJe89KgL6zvGkdqu1ATNCTkjNN4/Hnq1sO5m+xjOE26iyIRRMeL27hQ
	 uGqoXobd83WiA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Feb 2026 14:32:09 +0100
Subject: [PATCH 13/14] selftests/xattr: sockfs socket xattr tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-work-xattr-socket-v1-13-c2efa4f74cb7@kernel.org>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
In-Reply-To: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jeff Layton <jlayton@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
 linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, 
 netdev@vger.kernel.org, Christian Brauner <brauner@kernel.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=11906; i=brauner@kernel.org;
 h=from:subject:message-id; bh=nPMJv52b+iIBwowiKMG1azbuD44a7hHTFx5KxGAnUcM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWROlom79bXAWlx6913rXc5Xu2ODZtUmyDdtfFe12Nyea
 fLD3tl7O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACby/hYjwxf7EEm9LVJ/X35n
 +L9P7uvcI5Hr5L4l5erenHumOF7/Wy7D/6CpC/VyEy2+NSqndjE+2zFVbP+pSWsMF1joT48oKyi
 L4QEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5E5EA40008
X-Stat-Signature: 8naodu1cgkpeusrw5cuarjfhjmhwjr7d
X-Rspam-User: 
X-HE-Tag: 1771248787-443278
X-HE-Meta: U2FsdGVkX19ixUhQEcyL2H95TnESuJ1/fJnDd18KZyH2Qzur3TjPslvuB/5GEl+hGjgGrj5s2yYGj5VvXpg9SQNIhE4RqZLvyzZz9qYbV95nEhIgQ9K7juo8JzXzSFZaMyrTzdJabreaU3EfR6//e4DuAn9PUGRrnZzZxN3n2KCrKXn3SLWy6IBUnKyzk3iYQVb/kk9n6dyxDu6zBQQPNWTL7U+YqU94mbz1tEEjoCr6/Xo5NCV+tzQ9kLeE8vQrzY/b2RugQYY9hytQt3N0SEBwZ4k9dUzat5gy2q478SdTALvUgfCtHDF5tQ/J+j/BpIFs0zAk/Yu0/RvedyU76U8htPyXaE+i9xreEnfx5D8UiBWNcqzyaHC7rNjMSVKGMoKs9UYuA0fV+Mj9rgJKYSSzQicRjKZyLHhxeYqXiyv7URX5a/FhTSPgBCn3mjKW+ZX0RzXLXJ+nNMR9uq1jhrxOIAqJDFJXhZ1a0XWlkjNqnnMmgTJLOCa0/x5cIBunKrxXP6Bc85o5GioTEl4tIgTfGqiabKfvm7wU+Brw0IH3iTqC/4zZFr9hKmtRFJZpKkCx+LeJm7lAPaEsQbkLZg3UAKwwVjgbxTElpvTtTSdZMnETFwehR0plmYwNqZ5YxQYNMx93oqTqh2GlmF+sBAjnWgHNgpMhyjUj0jo72RMIf3aa2+3pdVJBYUlXIrACEfQsG91C5Vv6TZFalvufdhyVJu2JF1dnugAskk9zJ777EfXLAiqCJtZRTvrf+jKKoSi1tKH7WugDpuIPKAyXEsuZuliCUjwxADGAP4yMPDPXo//1AlNxSvCVS63ABlJYl9kYC7J4pr/hUBJ0fpJjducN/vIBc/w2m6IpFpb3dDIWxgA4shPjbLmCa8Ak1r+Ei4w7xe3JLomv0PxAEeZG21kEqAegP5qV8g5IpAsgxyh74qHfAhYxuLwOXVd1b6OOSlcgWey6655h3+GI3Vz
 lILFHEmY
 ljy2v/BuRsadu6gS0LCIzp5C8TfwwqjKCZIW0dJsdiEbVlMRdTyET3ZcSfJ4HCLLbljqn9BSiNF/kJJQQwjBm5gapI06f8AOJ39vMOOe/na+nB72x44atNiQ5HplFOIBGiq4LgORgSc4rmQvwgSzGm6p2tuoZlJwwDgCf3Pjx1fAAaxYHOW+IzsURrNFagsCJ1t0vleYCgLNu3G0SDFdQlR4EqODnwKpq7voFAFSGEYBO0VJyVgWYUYtsEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test user.* extended attribute operations on sockfs sockets. Sockets
created via socket() have their inodes in sockfs, which now supports
user.* xattrs with per-inode limits.

Tests fsetxattr/fgetxattr/flistxattr/fremovexattr operations including
set/get, listing (verifies system.sockprotoname presence), remove,
update, XATTR_CREATE/XATTR_REPLACE flags, empty values, size queries,
and buffer-too-small errors.

Also tests per-inode limit enforcement: maximum 128 xattrs, maximum
128KB total value size, limit recovery after removal, and independent
limits across different sockets.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 .../testing/selftests/filesystems/xattr/.gitignore |   1 +
 tools/testing/selftests/filesystems/xattr/Makefile |   2 +-
 .../filesystems/xattr/xattr_sockfs_test.c          | 363 +++++++++++++++++++++
 3 files changed, 365 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/filesystems/xattr/.gitignore b/tools/testing/selftests/filesystems/xattr/.gitignore
index 5fd015d2257a..00a59c89efab 100644
--- a/tools/testing/selftests/filesystems/xattr/.gitignore
+++ b/tools/testing/selftests/filesystems/xattr/.gitignore
@@ -1 +1,2 @@
 xattr_socket_test
+xattr_sockfs_test
diff --git a/tools/testing/selftests/filesystems/xattr/Makefile b/tools/testing/selftests/filesystems/xattr/Makefile
index e3d8dca80faa..2cd722dba47b 100644
--- a/tools/testing/selftests/filesystems/xattr/Makefile
+++ b/tools/testing/selftests/filesystems/xattr/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
 CFLAGS += $(KHDR_INCLUDES)
-TEST_GEN_PROGS := xattr_socket_test
+TEST_GEN_PROGS := xattr_socket_test xattr_sockfs_test
 
 include ../../lib.mk
diff --git a/tools/testing/selftests/filesystems/xattr/xattr_sockfs_test.c b/tools/testing/selftests/filesystems/xattr/xattr_sockfs_test.c
new file mode 100644
index 000000000000..b4824b01a86d
--- /dev/null
+++ b/tools/testing/selftests/filesystems/xattr/xattr_sockfs_test.c
@@ -0,0 +1,363 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2026 Christian Brauner <brauner@kernel.org>
+/*
+ * Test extended attributes on sockfs sockets.
+ *
+ * Sockets created via socket() have their inodes in sockfs, which supports
+ * user.* xattrs with per-inode limits: up to 128 xattrs and 128KB total
+ * value size. These tests verify xattr operations via fsetxattr/fgetxattr/
+ * flistxattr/fremovexattr on the socket fd, as well as limit enforcement.
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <sys/types.h>
+#include <sys/xattr.h>
+#include <unistd.h>
+
+#include "../../kselftest_harness.h"
+
+#define TEST_XATTR_NAME		"user.testattr"
+#define TEST_XATTR_VALUE	"testvalue"
+#define TEST_XATTR_VALUE2	"newvalue"
+
+/* Per-inode limits for user.* xattrs on sockfs (from include/linux/xattr.h) */
+#define SIMPLE_XATTR_MAX_NR	128
+#define SIMPLE_XATTR_MAX_SIZE	(128 << 10)	/* 128 KB */
+
+#ifndef XATTR_SIZE_MAX
+#define XATTR_SIZE_MAX 65536
+#endif
+
+/*
+ * Fixture for sockfs socket xattr tests.
+ * Creates an AF_UNIX socket (lives in sockfs, not bound to any path).
+ */
+FIXTURE(xattr_sockfs)
+{
+	int sockfd;
+};
+
+FIXTURE_SETUP(xattr_sockfs)
+{
+	self->sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
+	ASSERT_GE(self->sockfd, 0) {
+		TH_LOG("Failed to create socket: %s", strerror(errno));
+	}
+}
+
+FIXTURE_TEARDOWN(xattr_sockfs)
+{
+	if (self->sockfd >= 0)
+		close(self->sockfd);
+}
+
+TEST_F(xattr_sockfs, set_get_user_xattr)
+{
+	char buf[256];
+	ssize_t ret;
+
+	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
+			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("fsetxattr failed: %s", strerror(errno));
+	}
+
+	memset(buf, 0, sizeof(buf));
+	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, buf, sizeof(buf));
+	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE)) {
+		TH_LOG("fgetxattr returned %zd: %s", ret, strerror(errno));
+	}
+	ASSERT_STREQ(buf, TEST_XATTR_VALUE);
+}
+
+/*
+ * Test listing xattrs on a sockfs socket.
+ * Should include user.* xattrs and system.sockprotoname.
+ */
+TEST_F(xattr_sockfs, list_user_xattr)
+{
+	char list[4096];
+	ssize_t ret;
+	char *ptr;
+	bool found_user = false;
+	bool found_proto = false;
+
+	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
+			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("fsetxattr failed: %s", strerror(errno));
+	}
+
+	memset(list, 0, sizeof(list));
+	ret = flistxattr(self->sockfd, list, sizeof(list));
+	ASSERT_GT(ret, 0) {
+		TH_LOG("flistxattr failed: %s", strerror(errno));
+	}
+
+	for (ptr = list; ptr < list + ret; ptr += strlen(ptr) + 1) {
+		if (strcmp(ptr, TEST_XATTR_NAME) == 0)
+			found_user = true;
+		if (strcmp(ptr, "system.sockprotoname") == 0)
+			found_proto = true;
+	}
+	ASSERT_TRUE(found_user) {
+		TH_LOG("user xattr not found in list");
+	}
+	ASSERT_TRUE(found_proto) {
+		TH_LOG("system.sockprotoname not found in list");
+	}
+}
+
+TEST_F(xattr_sockfs, remove_user_xattr)
+{
+	char buf[256];
+	ssize_t ret;
+
+	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
+			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0);
+
+	ret = fremovexattr(self->sockfd, TEST_XATTR_NAME);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("fremovexattr failed: %s", strerror(errno));
+	}
+
+	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, buf, sizeof(buf));
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ENODATA);
+}
+
+TEST_F(xattr_sockfs, update_user_xattr)
+{
+	char buf[256];
+	ssize_t ret;
+
+	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
+			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0);
+
+	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
+			TEST_XATTR_VALUE2, strlen(TEST_XATTR_VALUE2), 0);
+	ASSERT_EQ(ret, 0);
+
+	memset(buf, 0, sizeof(buf));
+	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, buf, sizeof(buf));
+	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE2));
+	ASSERT_STREQ(buf, TEST_XATTR_VALUE2);
+}
+
+TEST_F(xattr_sockfs, xattr_create_flag)
+{
+	int ret;
+
+	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
+			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0);
+
+	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
+			TEST_XATTR_VALUE2, strlen(TEST_XATTR_VALUE2),
+			XATTR_CREATE);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EEXIST);
+}
+
+TEST_F(xattr_sockfs, xattr_replace_flag)
+{
+	int ret;
+
+	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
+			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE),
+			XATTR_REPLACE);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ENODATA);
+}
+
+TEST_F(xattr_sockfs, get_nonexistent)
+{
+	char buf[256];
+	ssize_t ret;
+
+	ret = fgetxattr(self->sockfd, "user.nonexistent", buf, sizeof(buf));
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ENODATA);
+}
+
+TEST_F(xattr_sockfs, empty_value)
+{
+	ssize_t ret;
+
+	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME, "", 0, 0);
+	ASSERT_EQ(ret, 0);
+
+	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, NULL, 0);
+	ASSERT_EQ(ret, 0);
+}
+
+TEST_F(xattr_sockfs, get_size)
+{
+	ssize_t ret;
+
+	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
+			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0);
+
+	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, NULL, 0);
+	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE));
+}
+
+TEST_F(xattr_sockfs, buffer_too_small)
+{
+	char buf[2];
+	ssize_t ret;
+
+	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
+			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0);
+
+	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, buf, sizeof(buf));
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ERANGE);
+}
+
+/*
+ * Test maximum number of user.* xattrs per socket.
+ * The kernel enforces SIMPLE_XATTR_MAX_NR (128), so the 129th should
+ * fail with ENOSPC.
+ */
+TEST_F(xattr_sockfs, max_nr_xattrs)
+{
+	char name[32];
+	int i, ret;
+
+	for (i = 0; i < SIMPLE_XATTR_MAX_NR; i++) {
+		snprintf(name, sizeof(name), "user.test%03d", i);
+		ret = fsetxattr(self->sockfd, name, "v", 1, 0);
+		ASSERT_EQ(ret, 0) {
+			TH_LOG("fsetxattr %s failed at i=%d: %s",
+			       name, i, strerror(errno));
+		}
+	}
+
+	ret = fsetxattr(self->sockfd, "user.overflow", "v", 1, 0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ENOSPC) {
+		TH_LOG("Expected ENOSPC for xattr %d, got %s",
+		       SIMPLE_XATTR_MAX_NR + 1, strerror(errno));
+	}
+}
+
+/*
+ * Test maximum total value size for user.* xattrs.
+ * The kernel enforces SIMPLE_XATTR_MAX_SIZE (128KB). Individual xattr
+ * values are limited to XATTR_SIZE_MAX (64KB) by the VFS, so we need
+ * at least two xattrs to hit the total limit.
+ */
+TEST_F(xattr_sockfs, max_xattr_size)
+{
+	char *value;
+	int ret;
+
+	value = malloc(XATTR_SIZE_MAX);
+	ASSERT_NE(value, NULL);
+	memset(value, 'A', XATTR_SIZE_MAX);
+
+	/* First 64KB xattr - total = 64KB */
+	ret = fsetxattr(self->sockfd, "user.big1", value, XATTR_SIZE_MAX, 0);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("first large xattr failed: %s", strerror(errno));
+	}
+
+	/* Second 64KB xattr - total = 128KB (exactly at limit) */
+	ret = fsetxattr(self->sockfd, "user.big2", value, XATTR_SIZE_MAX, 0);
+	free(value);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("second large xattr failed: %s", strerror(errno));
+	}
+
+	/* Third xattr with 1 byte - total > 128KB, should fail */
+	ret = fsetxattr(self->sockfd, "user.big3", "v", 1, 0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ENOSPC) {
+		TH_LOG("Expected ENOSPC when exceeding size limit, got %s",
+		       strerror(errno));
+	}
+}
+
+/*
+ * Test that removing an xattr frees limit space, allowing re-addition.
+ */
+TEST_F(xattr_sockfs, limit_remove_readd)
+{
+	char name[32];
+	int i, ret;
+
+	/* Fill up to the maximum count */
+	for (i = 0; i < SIMPLE_XATTR_MAX_NR; i++) {
+		snprintf(name, sizeof(name), "user.test%03d", i);
+		ret = fsetxattr(self->sockfd, name, "v", 1, 0);
+		ASSERT_EQ(ret, 0);
+	}
+
+	/* Verify we're at the limit */
+	ret = fsetxattr(self->sockfd, "user.overflow", "v", 1, 0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ENOSPC);
+
+	/* Remove one xattr */
+	ret = fremovexattr(self->sockfd, "user.test000");
+	ASSERT_EQ(ret, 0);
+
+	/* Now we should be able to add one more */
+	ret = fsetxattr(self->sockfd, "user.newattr", "v", 1, 0);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("re-add after remove failed: %s", strerror(errno));
+	}
+}
+
+/*
+ * Test that two different sockets have independent xattr limits.
+ */
+TEST_F(xattr_sockfs, limits_per_inode)
+{
+	char buf[256];
+	int sock2;
+	ssize_t ret;
+
+	sock2 = socket(AF_UNIX, SOCK_STREAM, 0);
+	ASSERT_GE(sock2, 0);
+
+	/* Set xattr on first socket */
+	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
+			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0);
+
+	/* First socket's xattr should not be visible on second socket */
+	ret = fgetxattr(sock2, TEST_XATTR_NAME, NULL, 0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ENODATA);
+
+	/* Second socket should independently accept xattrs */
+	ret = fsetxattr(sock2, TEST_XATTR_NAME,
+			TEST_XATTR_VALUE2, strlen(TEST_XATTR_VALUE2), 0);
+	ASSERT_EQ(ret, 0);
+
+	/* Verify each socket has its own value */
+	memset(buf, 0, sizeof(buf));
+	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, buf, sizeof(buf));
+	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE));
+	ASSERT_STREQ(buf, TEST_XATTR_VALUE);
+
+	memset(buf, 0, sizeof(buf));
+	ret = fgetxattr(sock2, TEST_XATTR_NAME, buf, sizeof(buf));
+	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE2));
+	ASSERT_STREQ(buf, TEST_XATTR_VALUE2);
+
+	close(sock2);
+}
+
+TEST_HARNESS_MAIN

-- 
2.47.3


