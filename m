Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D60E7BDB4
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 13:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EF7D6B00A8; Mon, 16 Feb 2026 08:33:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A7D16B00AA; Mon, 16 Feb 2026 08:33:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BC506B00AB; Mon, 16 Feb 2026 08:33:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1224C6B00A8
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:33:06 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D7BE13C2B4
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:33:05 +0000 (UTC)
X-FDA: 84450410730.28.7C1C258
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A3AE714000C
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:33:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YBTOjDn2;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771248783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AbZW6/m1vdVVk2KGUN6YQ/bqDAuWg/PRdpTU31+rPZ8=;
	b=6Fyve8pR0v4bMh/mjk5DlhsEIAA+KaDH4aJI0w5fhVpfJR6BgI5zETv3qtWRNr3jLVt9bZ
	EwoUwThiH+GsoE0i8XATiHYVx03ZEo3QRIum8joKEeyGDBoZcdOObleVdj0SlaeiTQOih8
	OgAghk/eEvyB1hyXm4rM4iYD9e6RBEw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YBTOjDn2;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771248783; a=rsa-sha256;
	cv=none;
	b=fqsld3834jb4C1NvnXXjP5TaIgNMMHE/dHPxP98kR3sg39AF2f52PnEqQEjI9vmNGC9A3W
	dJ46ALuGBwcfpvRnw+j6w7y+KF6uvtK3pPdC6KoMwHieBhEdcjgCyT8n/sgV/q9mPl7ESw
	yC271iGH83kRMqCxUvlWfzRrUxdiyD0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 22326600B0;
	Mon, 16 Feb 2026 13:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2665C19424;
	Mon, 16 Feb 2026 13:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771248782;
	bh=attc5XwzII0O55hshNdwieE9+UGv31LLE3x0ZMxZ0sg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=YBTOjDn21sBBW/YsxL8mwueUP2kHkVGWc4DCx9NVGJ8F7EZiCr+1Bfl+ElOJNhZjp
	 j7vRSgIbZc4/CMAR+kST4GNnLNHVlQ/dY+4l1LbQDWFBogKhX7IhvgjyVc47o8vEDL
	 WSxmIPn0TA+bqg3zXOyWt4kwO5asjKt+O/BbykvpE3vybbxThDH0pciMmD7KnwMsws
	 3iqSzXVZnqskyWFs2RzNPxjUWCkkRGZ7kb8BNrPqMDKUmrWbNR6c2BnTBxps5lgvTV
	 kCPy7MBtiIU9j11HUmxlPNu81l+xB/2vTxP35VDFU6DfH016/Rgl3G3CyU0Md5ZN5z
	 aXEb3aZhhWeGQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Feb 2026 14:32:08 +0100
Subject: [PATCH 12/14] selftests/xattr: path-based AF_UNIX socket xattr
 tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-work-xattr-socket-v1-12-c2efa4f74cb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=14115; i=brauner@kernel.org;
 h=from:subject:message-id; bh=attc5XwzII0O55hshNdwieE9+UGv31LLE3x0ZMxZ0sg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWROlolbPeHC9KnFa1/Ktj9/ZHsl6qOFcuR+y9nrCiL4e
 70mnT7d1lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRNVkM/4Pr43eFLesvNPax
 EZrzcmJyVP9FjlBvpS2mmx6lzzHW/8nwv0z3JNOijkdqd2/NOy2vGut8jE/vz3Oe58u2fZsiK/j
 OiR8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A3AE714000C
X-Stat-Signature: ut7t7omioeecgod6h4bep45amcoqz7ak
X-Rspam-User: 
X-HE-Tag: 1771248783-938360
X-HE-Meta: U2FsdGVkX1/UCHgkh0SaIKpAw49O0siamGEKiHXMCOaQRDrXGqCDqEXGuBEwnOpPy0CR22VLv5XT1WgNvFI9u9CHfzxzuh+Y3wuE6uyGoCzfMuJ4xnMBh0t3wM1MbWMKzSu7OYePgsVCMEn8m+vcmvuOhFq3HEdvLiNXNS4WcoYe3Mfhwpn1tTHIXa7Bvc3o56DBM2fLnuJopyR1hDs9I7DYLRsNU/l3DJULy+wttUyeBFHFQvCRF+LwInoyLapUa7L/TDlMw31ty5JC0xfDtFa33jLyRwTvCLis875a2AshWuvNmXpXaarWx12Hiz/I4s1S08oX+8IqDpVI//xggWBI12BaxzwR2altHE8ZB5Y4RJhJZSUiEoRMEkzKbGVvrdz48IQlHapvdsYFOreFOuzJnwUqqxodkVHdatZbfUFFBdgOTKiND3EjQ5o49JVIDrW2tN97Qo02FgWK5F/HgU0dfu4rmrbU/6xmC6bGugJG/gm4H8ZcL1K2AQECNHHQDxNNHVJLeOIE9JsutPvE1SefnDH+hUoYPBQKsu+xKEEikvBgxOurxhUNwyJyR7X0Jv30EA2gX2fwKdbngZnbaLqR+QxbcaipU/yDMbApOY8Es/kqZY+TJb+tJiCrkMNSn3V/LUdhX1nKENoPw+lqBWrAI9oTj39yQx7GBmx5laWvQ+sS1+yi8D03Aa5/k2k7Q+MXZIPCEF4xdO4oC5luWPrIkpi85SBsXJoiCunDzqqfQO3UOOjiJ73cs3xttruf593cFnzedMvDdRq81usn3kWt3xeyD5fqe0oQkZJdxS3f0lfGidWWb8MZszHtZRLaF4d2d4HYLI/fPcpxdf0May89l930vpx6HNFl5PpYIbd5uuwdTCEMJPzE1sCFWVoTFkMTSjDDXe/fdhymM5ezPo7V8aEbK39HcKQlCirrv+U0MrqkM5hqcESXUkNF5Rd2R3rLaA0Qt6ekGVi5OFO
 pv6wv3qh
 9m/oCMB7g6qFyFEdwZL7H62jBN19LWwjVvkO7zbNT9ZS6h2vMaJw31UK9bqFWwuuFy4MZAu5nUgrtePGCymZBDc5xDLLyj8Q9Fj77o/MjePqrao+o6C1RGhUxHwtnYVpiUm1AuBAKUc89hQjvHI52nzfVB/mUfmZ8ravBZOowHrp+/2ewb2fDESRxOwMlmp7ZSzYG8DvyBTF7YVSCchG60AkIC4fvZzZxrwumIe4UftLvbLOU9Kc/DJFer+tc2bdNZvV+jkXL4vEQ5Q3EZvGg1fN9s9zkmbLa1CDL0NHcyVCYGVo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test user.* extended attribute operations on path-based Unix domain
sockets (SOCK_STREAM, SOCK_DGRAM, SOCK_SEQPACKET). Path-based sockets
are bound to a filesystem path and their inodes live on the underlying
filesystem (e.g. tmpfs).

Covers set/get/list/remove, persistence, XATTR_CREATE/XATTR_REPLACE
flags, empty values, size queries, buffer-too-small errors, O_PATH fd
operations, and trusted.* xattr handling.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 .../testing/selftests/filesystems/xattr/.gitignore |   1 +
 tools/testing/selftests/filesystems/xattr/Makefile |   6 +
 .../filesystems/xattr/xattr_socket_test.c          | 470 +++++++++++++++++++++
 3 files changed, 477 insertions(+)

diff --git a/tools/testing/selftests/filesystems/xattr/.gitignore b/tools/testing/selftests/filesystems/xattr/.gitignore
new file mode 100644
index 000000000000..5fd015d2257a
--- /dev/null
+++ b/tools/testing/selftests/filesystems/xattr/.gitignore
@@ -0,0 +1 @@
+xattr_socket_test
diff --git a/tools/testing/selftests/filesystems/xattr/Makefile b/tools/testing/selftests/filesystems/xattr/Makefile
new file mode 100644
index 000000000000..e3d8dca80faa
--- /dev/null
+++ b/tools/testing/selftests/filesystems/xattr/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+
+CFLAGS += $(KHDR_INCLUDES)
+TEST_GEN_PROGS := xattr_socket_test
+
+include ../../lib.mk
diff --git a/tools/testing/selftests/filesystems/xattr/xattr_socket_test.c b/tools/testing/selftests/filesystems/xattr/xattr_socket_test.c
new file mode 100644
index 000000000000..fac0a4c6bc05
--- /dev/null
+++ b/tools/testing/selftests/filesystems/xattr/xattr_socket_test.c
@@ -0,0 +1,470 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2026 Christian Brauner <brauner@kernel.org>
+/*
+ * Test extended attributes on path-based Unix domain sockets.
+ *
+ * Path-based Unix domain sockets are bound to a filesystem path and their
+ * inodes live on the underlying filesystem (e.g. tmpfs). These tests verify
+ * that user.* and trusted.* xattr operations work correctly on them using
+ * path-based syscalls (setxattr, getxattr, etc.).
+ *
+ * Covers SOCK_STREAM, SOCK_DGRAM, and SOCK_SEQPACKET socket types.
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <limits.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/un.h>
+#include <sys/xattr.h>
+#include <unistd.h>
+
+#include "../../kselftest_harness.h"
+
+#define TEST_XATTR_NAME		"user.testattr"
+#define TEST_XATTR_VALUE	"testvalue"
+#define TEST_XATTR_VALUE2	"newvalue"
+
+/*
+ * Fixture for path-based Unix domain socket tests.
+ * Creates a SOCK_STREAM socket bound to a path in /tmp (typically tmpfs).
+ */
+FIXTURE(xattr_socket)
+{
+	char socket_path[PATH_MAX];
+	int sockfd;
+};
+
+FIXTURE_VARIANT(xattr_socket)
+{
+	int sock_type;
+	const char *name;
+};
+
+FIXTURE_VARIANT_ADD(xattr_socket, stream) {
+	.sock_type = SOCK_STREAM,
+	.name = "stream",
+};
+
+FIXTURE_VARIANT_ADD(xattr_socket, dgram) {
+	.sock_type = SOCK_DGRAM,
+	.name = "dgram",
+};
+
+FIXTURE_VARIANT_ADD(xattr_socket, seqpacket) {
+	.sock_type = SOCK_SEQPACKET,
+	.name = "seqpacket",
+};
+
+FIXTURE_SETUP(xattr_socket)
+{
+	struct sockaddr_un addr;
+	int ret;
+
+	self->sockfd = -1;
+
+	snprintf(self->socket_path, sizeof(self->socket_path),
+		 "/tmp/xattr_socket_test_%s.%d", variant->name, getpid());
+	unlink(self->socket_path);
+
+	self->sockfd = socket(AF_UNIX, variant->sock_type, 0);
+	ASSERT_GE(self->sockfd, 0) {
+		TH_LOG("Failed to create socket: %s", strerror(errno));
+	}
+
+	memset(&addr, 0, sizeof(addr));
+	addr.sun_family = AF_UNIX;
+	strncpy(addr.sun_path, self->socket_path, sizeof(addr.sun_path) - 1);
+
+	ret = bind(self->sockfd, (struct sockaddr *)&addr, sizeof(addr));
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("Failed to bind socket to %s: %s",
+		       self->socket_path, strerror(errno));
+	}
+}
+
+FIXTURE_TEARDOWN(xattr_socket)
+{
+	if (self->sockfd >= 0)
+		close(self->sockfd);
+	unlink(self->socket_path);
+}
+
+TEST_F(xattr_socket, set_user_xattr)
+{
+	int ret;
+
+	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
+		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("setxattr failed: %s (errno=%d)", strerror(errno), errno);
+	}
+}
+
+TEST_F(xattr_socket, get_user_xattr)
+{
+	char buf[256];
+	ssize_t ret;
+
+	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
+		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("setxattr failed: %s", strerror(errno));
+	}
+
+	memset(buf, 0, sizeof(buf));
+	ret = getxattr(self->socket_path, TEST_XATTR_NAME, buf, sizeof(buf));
+	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE)) {
+		TH_LOG("getxattr returned %zd, expected %zu: %s",
+		       ret, strlen(TEST_XATTR_VALUE), strerror(errno));
+	}
+	ASSERT_STREQ(buf, TEST_XATTR_VALUE);
+}
+
+TEST_F(xattr_socket, list_user_xattr)
+{
+	char list[1024];
+	ssize_t ret;
+	bool found = false;
+	char *ptr;
+
+	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
+		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("setxattr failed: %s", strerror(errno));
+	}
+
+	memset(list, 0, sizeof(list));
+	ret = listxattr(self->socket_path, list, sizeof(list));
+	ASSERT_GT(ret, 0) {
+		TH_LOG("listxattr failed: %s", strerror(errno));
+	}
+
+	for (ptr = list; ptr < list + ret; ptr += strlen(ptr) + 1) {
+		if (strcmp(ptr, TEST_XATTR_NAME) == 0) {
+			found = true;
+			break;
+		}
+	}
+	ASSERT_TRUE(found) {
+		TH_LOG("xattr %s not found in list", TEST_XATTR_NAME);
+	}
+}
+
+TEST_F(xattr_socket, remove_user_xattr)
+{
+	char buf[256];
+	ssize_t ret;
+
+	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
+		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("setxattr failed: %s", strerror(errno));
+	}
+
+	ret = removexattr(self->socket_path, TEST_XATTR_NAME);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("removexattr failed: %s", strerror(errno));
+	}
+
+	ret = getxattr(self->socket_path, TEST_XATTR_NAME, buf, sizeof(buf));
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ENODATA) {
+		TH_LOG("Expected ENODATA, got %s", strerror(errno));
+	}
+}
+
+/*
+ * Test that xattrs persist across socket close and reopen.
+ * The xattr is on the filesystem inode, not the socket fd.
+ */
+TEST_F(xattr_socket, xattr_persistence)
+{
+	char buf[256];
+	ssize_t ret;
+
+	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
+		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("setxattr failed: %s", strerror(errno));
+	}
+
+	close(self->sockfd);
+	self->sockfd = -1;
+
+	memset(buf, 0, sizeof(buf));
+	ret = getxattr(self->socket_path, TEST_XATTR_NAME, buf, sizeof(buf));
+	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE)) {
+		TH_LOG("getxattr after close failed: %s", strerror(errno));
+	}
+	ASSERT_STREQ(buf, TEST_XATTR_VALUE);
+}
+
+TEST_F(xattr_socket, update_user_xattr)
+{
+	char buf[256];
+	ssize_t ret;
+
+	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
+		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0);
+
+	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
+		       TEST_XATTR_VALUE2, strlen(TEST_XATTR_VALUE2), 0);
+	ASSERT_EQ(ret, 0);
+
+	memset(buf, 0, sizeof(buf));
+	ret = getxattr(self->socket_path, TEST_XATTR_NAME, buf, sizeof(buf));
+	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE2));
+	ASSERT_STREQ(buf, TEST_XATTR_VALUE2);
+}
+
+TEST_F(xattr_socket, xattr_create_flag)
+{
+	int ret;
+
+	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
+		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0);
+
+	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
+		       TEST_XATTR_VALUE2, strlen(TEST_XATTR_VALUE2), XATTR_CREATE);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EEXIST);
+}
+
+TEST_F(xattr_socket, xattr_replace_flag)
+{
+	int ret;
+
+	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
+		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), XATTR_REPLACE);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ENODATA);
+}
+
+TEST_F(xattr_socket, multiple_xattrs)
+{
+	char buf[256];
+	ssize_t ret;
+	int i;
+	char name[64], value[64];
+	const int num_xattrs = 5;
+
+	for (i = 0; i < num_xattrs; i++) {
+		snprintf(name, sizeof(name), "user.test%d", i);
+		snprintf(value, sizeof(value), "value%d", i);
+		ret = setxattr(self->socket_path, name, value, strlen(value), 0);
+		ASSERT_EQ(ret, 0) {
+			TH_LOG("setxattr %s failed: %s", name, strerror(errno));
+		}
+	}
+
+	for (i = 0; i < num_xattrs; i++) {
+		snprintf(name, sizeof(name), "user.test%d", i);
+		snprintf(value, sizeof(value), "value%d", i);
+		memset(buf, 0, sizeof(buf));
+		ret = getxattr(self->socket_path, name, buf, sizeof(buf));
+		ASSERT_EQ(ret, (ssize_t)strlen(value));
+		ASSERT_STREQ(buf, value);
+	}
+}
+
+TEST_F(xattr_socket, xattr_empty_value)
+{
+	char buf[256];
+	ssize_t ret;
+
+	ret = setxattr(self->socket_path, TEST_XATTR_NAME, "", 0, 0);
+	ASSERT_EQ(ret, 0);
+
+	ret = getxattr(self->socket_path, TEST_XATTR_NAME, buf, sizeof(buf));
+	ASSERT_EQ(ret, 0);
+}
+
+TEST_F(xattr_socket, xattr_get_size)
+{
+	ssize_t ret;
+
+	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
+		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0);
+
+	ret = getxattr(self->socket_path, TEST_XATTR_NAME, NULL, 0);
+	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE));
+}
+
+TEST_F(xattr_socket, xattr_buffer_too_small)
+{
+	char buf[2];
+	ssize_t ret;
+
+	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
+		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0);
+
+	ret = getxattr(self->socket_path, TEST_XATTR_NAME, buf, sizeof(buf));
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ERANGE);
+}
+
+TEST_F(xattr_socket, xattr_nonexistent)
+{
+	char buf[256];
+	ssize_t ret;
+
+	ret = getxattr(self->socket_path, "user.nonexistent", buf, sizeof(buf));
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ENODATA);
+}
+
+TEST_F(xattr_socket, remove_nonexistent_xattr)
+{
+	int ret;
+
+	ret = removexattr(self->socket_path, "user.nonexistent");
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ENODATA);
+}
+
+TEST_F(xattr_socket, large_xattr_value)
+{
+	char large_value[4096];
+	char read_buf[4096];
+	ssize_t ret;
+
+	memset(large_value, 'A', sizeof(large_value));
+
+	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
+		       large_value, sizeof(large_value), 0);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("setxattr with large value failed: %s", strerror(errno));
+	}
+
+	memset(read_buf, 0, sizeof(read_buf));
+	ret = getxattr(self->socket_path, TEST_XATTR_NAME,
+		       read_buf, sizeof(read_buf));
+	ASSERT_EQ(ret, (ssize_t)sizeof(large_value));
+	ASSERT_EQ(memcmp(large_value, read_buf, sizeof(large_value)), 0);
+}
+
+/*
+ * Test lsetxattr/lgetxattr (don't follow symlinks).
+ * Socket files aren't symlinks, so this should work the same.
+ */
+TEST_F(xattr_socket, lsetxattr_lgetxattr)
+{
+	char buf[256];
+	ssize_t ret;
+
+	ret = lsetxattr(self->socket_path, TEST_XATTR_NAME,
+			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("lsetxattr failed: %s", strerror(errno));
+	}
+
+	memset(buf, 0, sizeof(buf));
+	ret = lgetxattr(self->socket_path, TEST_XATTR_NAME, buf, sizeof(buf));
+	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE));
+	ASSERT_STREQ(buf, TEST_XATTR_VALUE);
+}
+
+/*
+ * Fixture for trusted.* xattr tests.
+ * These require CAP_SYS_ADMIN.
+ */
+FIXTURE(xattr_socket_trusted)
+{
+	char socket_path[PATH_MAX];
+	int sockfd;
+};
+
+FIXTURE_VARIANT(xattr_socket_trusted)
+{
+	int sock_type;
+	const char *name;
+};
+
+FIXTURE_VARIANT_ADD(xattr_socket_trusted, stream) {
+	.sock_type = SOCK_STREAM,
+	.name = "stream",
+};
+
+FIXTURE_VARIANT_ADD(xattr_socket_trusted, dgram) {
+	.sock_type = SOCK_DGRAM,
+	.name = "dgram",
+};
+
+FIXTURE_VARIANT_ADD(xattr_socket_trusted, seqpacket) {
+	.sock_type = SOCK_SEQPACKET,
+	.name = "seqpacket",
+};
+
+FIXTURE_SETUP(xattr_socket_trusted)
+{
+	struct sockaddr_un addr;
+	int ret;
+
+	self->sockfd = -1;
+
+	snprintf(self->socket_path, sizeof(self->socket_path),
+		 "/tmp/xattr_socket_trusted_%s.%d", variant->name, getpid());
+	unlink(self->socket_path);
+
+	self->sockfd = socket(AF_UNIX, variant->sock_type, 0);
+	ASSERT_GE(self->sockfd, 0);
+
+	memset(&addr, 0, sizeof(addr));
+	addr.sun_family = AF_UNIX;
+	strncpy(addr.sun_path, self->socket_path, sizeof(addr.sun_path) - 1);
+
+	ret = bind(self->sockfd, (struct sockaddr *)&addr, sizeof(addr));
+	ASSERT_EQ(ret, 0);
+}
+
+FIXTURE_TEARDOWN(xattr_socket_trusted)
+{
+	if (self->sockfd >= 0)
+		close(self->sockfd);
+	unlink(self->socket_path);
+}
+
+TEST_F(xattr_socket_trusted, set_trusted_xattr)
+{
+	char buf[256];
+	ssize_t len;
+	int ret;
+
+	ret = setxattr(self->socket_path, "trusted.testattr",
+		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	if (ret == -1 && errno == EPERM)
+		SKIP(return, "Need CAP_SYS_ADMIN for trusted.* xattrs");
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("setxattr trusted.testattr failed: %s", strerror(errno));
+	}
+
+	memset(buf, 0, sizeof(buf));
+	len = getxattr(self->socket_path, "trusted.testattr",
+		       buf, sizeof(buf));
+	ASSERT_EQ(len, (ssize_t)strlen(TEST_XATTR_VALUE));
+	ASSERT_STREQ(buf, TEST_XATTR_VALUE);
+}
+
+TEST_F(xattr_socket_trusted, get_trusted_xattr_unprivileged)
+{
+	char buf[256];
+	ssize_t ret;
+
+	ret = getxattr(self->socket_path, "trusted.testattr", buf, sizeof(buf));
+	ASSERT_EQ(ret, -1);
+	ASSERT_TRUE(errno == ENODATA || errno == EPERM) {
+		TH_LOG("Expected ENODATA or EPERM, got %s", strerror(errno));
+	}
+}
+
+TEST_HARNESS_MAIN

-- 
2.47.3


