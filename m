Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBACEE7BDB4
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 13:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BCE26B00AA; Mon, 16 Feb 2026 08:33:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470F86B00AD; Mon, 16 Feb 2026 08:33:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AB2B6B00AE; Mon, 16 Feb 2026 08:33:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2424B6B00AA
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:33:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D839D160D6C
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:33:12 +0000 (UTC)
X-FDA: 84450411024.23.2234A39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 36B86180013
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:33:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ksVRT/TC";
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771248791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kN1kH2lNapgZmlKK5ZIvZDOF5FiQsc3dZfAjMS752w8=;
	b=b0VzbsAU+H3DpEIewxbvYxR0eDM+kIngOAPHofe8jd3MRFbWSZmdB5MYUxWHVj13dHJq3h
	7lV+9clBwrAjzzg5r0sZNPHHfvSKugHsyI453lzeb9b5umW3xs7bjfvAEsw7VIZwPD4J8s
	nUHCD5oixaWANPChDQkfuZJG3YAj5bM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ksVRT/TC";
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771248791; a=rsa-sha256;
	cv=none;
	b=TNRFQkfi598iG/hSEhB6oYV5cTGIU71SVH/jBrzU9eBzsl1R9bvVnr/N5WEvzptM0otfNN
	Fx3Y56lh4GQMp2E87pq0z0H6J9Izzg9Phogt/S78j9jsM26GRndCYcLiNkQ6XEZ7YQDGD4
	mjXdjUkAbAkMukyC053uQqYWYT1dwi4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 60C1342AC1;
	Mon, 16 Feb 2026 13:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EADC19423;
	Mon, 16 Feb 2026 13:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771248790;
	bh=hvRp6kqMtP01OL7JzalGLx5e4r/2rC/9MUn7FHvN4XY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ksVRT/TC3Qs/BDIBZ4Xwz+odoJUU6U4EIeZ15q9gpGsQphl0RvHMnhrcx00O/o44L
	 u8TStq3seKruuRWTCAfpzOHfvucMwPSX/C97ZOFdF4/BgJ2k5CasvzjAlBlIz8PnGE
	 xM/FeirGoDXBN6jq/9WeT3f3VLf/NQ0Pd1cSjE8XARMfC5mF+5PbhiRTClUXTLwL+M
	 Y0hFvkeZF34qG+L0Xjh4pF4S+FZRbyYI0oSk4PwJRBtMWT/ASvV16Mf/NyHc0GNp0V
	 3GVIfwPUoEmJwb3gr4GnWFSDE/pu+9wKia7m2g/O1iqCXPDbyd8Qe0i+qw3gapxDEA
	 xbK4hkdbLLewQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Feb 2026 14:32:10 +0100
Subject: [PATCH 14/14] selftests/xattr: test xattrs on various socket
 families
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-work-xattr-socket-v1-14-c2efa4f74cb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6636; i=brauner@kernel.org;
 h=from:subject:message-id; bh=hvRp6kqMtP01OL7JzalGLx5e4r/2rC/9MUn7FHvN4XY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWROlokr042WWq769uIti0fds8S7VFz8zzcGv+fTK5kk1
 xG/XdC1o5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCJCHIwML3UXZu86bHnFwruo
 6I2KarM716f/Dv4mfcYbKyuezPq8h+GvdEPpDo5JyQ9slPgXCLvfeSyufcV+SvqkGXd2ZKy1YH/
 LCAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Stat-Signature: hir9t9ff7hixfig4rxb1cgcrnbz4ywrd
X-Rspam-User: 
X-Rspamd-Queue-Id: 36B86180013
X-HE-Tag: 1771248791-77922
X-HE-Meta: U2FsdGVkX19GdG3JAtE0a2tuJoBZsm/wzetqt71kLdFb1jygbfmY/JpAu2wi3/xPamZV6uycErPsOuF+MRiWm2Hf+E4+bHvKT1uXG2Fld8tmiL/U2MjTwavlWmElaml7Fm3vnj49fqstJw4i0nv243Th731+mQp9yLCF0YjGFuxPCyksAA9IMUEcr8rvwQ55fU0MqVr53QN8wtue3GhqRoCr7Q8tAlQXJXazzbEvdUTUvMqB54YBaRf60pfm5zTYJjRX4/P7FrKsTvcZX9lZQv1AICzI+/bQyd7sPLgeHmxJEkxSiLFpIE53ouKwCyWiw557EduENvi8epSPWw/eZOE4MQyhwI2tNs6N4keb7avneEMElGVD1ldVYsL/mNjKcRb5O1F95TPvblXijTycP1ZdHh6H5QrPfmk7yzWK+++FNsEUlgR1Uf8ynWTf8zRIkG4NWP+Bp/0NXnb0rup4YKjjKFH84znbsTot4zq+O35nuY3dUZm8L6AdFHsFNuoIcmP5TMUMSOBp+97gS/W4YfKb7rMtasYF9C3NYyDoQ9Chw4MSIBWTpJpqOZuvg9IH5Ytq6FRCqRFGF5Mu7bz+937i2t3Gr0OD//Fg8sTtM/ZBmRG95mR8p3WxXt9PFFAyYNpw+Ep2vcXvMQMeFAGqw7nP1bDNcj5h6C9+4Kd8rcZ2/eSBj+BOI0G74jyz5oobbKqJbk4c92gL9QbBRXHhmxdDUkEpObfaRXEX7hK4mLoItmDIQr/NGowhJLE3DKtyFMKr+mn2VrbRrs4kFlFdbq4cXhNNFL0jCuVONWvlnLn86mc7rzW/TiqEx3IDVHEOtLsZCFe7C9XFd9LLVVtf5ky+e/bOqQ+Cj/VaALJ8b22FDY3J9uLueuixHoIWfAz28JTV9GGYiYUIwcGHt+lFsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test user.* xattr operations on sockets from different address families:
AF_INET, AF_INET6, AF_NETLINK, and AF_PACKET. All socket types use
sockfs for their inodes, so user.* xattrs should work regardless of
address family.

Each fixture creates a socket (no bind needed) and verifies the full
fsetxattr/fgetxattr/flistxattr/fremovexattr cycle. AF_INET6 skips if
not supported; AF_PACKET skips if CAP_NET_RAW is unavailable.

Also tests abstract namespace AF_UNIX sockets, which live in sockfs
(not on a filesystem) and should support user.* xattrs.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 .../testing/selftests/filesystems/xattr/.gitignore |   1 +
 tools/testing/selftests/filesystems/xattr/Makefile |   2 +-
 .../filesystems/xattr/xattr_socket_types_test.c    | 177 +++++++++++++++++++++
 3 files changed, 179 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/filesystems/xattr/.gitignore b/tools/testing/selftests/filesystems/xattr/.gitignore
index 00a59c89efab..092d14094c0f 100644
--- a/tools/testing/selftests/filesystems/xattr/.gitignore
+++ b/tools/testing/selftests/filesystems/xattr/.gitignore
@@ -1,2 +1,3 @@
 xattr_socket_test
 xattr_sockfs_test
+xattr_socket_types_test
diff --git a/tools/testing/selftests/filesystems/xattr/Makefile b/tools/testing/selftests/filesystems/xattr/Makefile
index 2cd722dba47b..95364ffb10e9 100644
--- a/tools/testing/selftests/filesystems/xattr/Makefile
+++ b/tools/testing/selftests/filesystems/xattr/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
 CFLAGS += $(KHDR_INCLUDES)
-TEST_GEN_PROGS := xattr_socket_test xattr_sockfs_test
+TEST_GEN_PROGS := xattr_socket_test xattr_sockfs_test xattr_socket_types_test
 
 include ../../lib.mk
diff --git a/tools/testing/selftests/filesystems/xattr/xattr_socket_types_test.c b/tools/testing/selftests/filesystems/xattr/xattr_socket_types_test.c
new file mode 100644
index 000000000000..bfabe91b2ed1
--- /dev/null
+++ b/tools/testing/selftests/filesystems/xattr/xattr_socket_types_test.c
@@ -0,0 +1,177 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2026 Christian Brauner <brauner@kernel.org>
+/*
+ * Test user.* xattrs on various socket families.
+ *
+ * All socket types use sockfs for their inodes, so user.* xattrs should
+ * work on any socket regardless of address family. This tests AF_INET,
+ * AF_INET6, AF_NETLINK, AF_PACKET, and abstract namespace AF_UNIX sockets.
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <sys/types.h>
+#include <sys/un.h>
+#include <sys/xattr.h>
+#include <linux/netlink.h>
+#include <unistd.h>
+
+#include "../../kselftest_harness.h"
+
+#define TEST_XATTR_NAME		"user.testattr"
+#define TEST_XATTR_VALUE	"testvalue"
+
+FIXTURE(xattr_socket_types)
+{
+	int sockfd;
+};
+
+FIXTURE_VARIANT(xattr_socket_types)
+{
+	int family;
+	int type;
+	int protocol;
+};
+
+FIXTURE_VARIANT_ADD(xattr_socket_types, inet) {
+	.family = AF_INET,
+	.type = SOCK_STREAM,
+	.protocol = 0,
+};
+
+FIXTURE_VARIANT_ADD(xattr_socket_types, inet6) {
+	.family = AF_INET6,
+	.type = SOCK_STREAM,
+	.protocol = 0,
+};
+
+FIXTURE_VARIANT_ADD(xattr_socket_types, netlink) {
+	.family = AF_NETLINK,
+	.type = SOCK_RAW,
+	.protocol = NETLINK_USERSOCK,
+};
+
+FIXTURE_VARIANT_ADD(xattr_socket_types, packet) {
+	.family = AF_PACKET,
+	.type = SOCK_DGRAM,
+	.protocol = 0,
+};
+
+FIXTURE_SETUP(xattr_socket_types)
+{
+	self->sockfd = socket(variant->family, variant->type,
+			      variant->protocol);
+	if (self->sockfd < 0 &&
+	    (errno == EAFNOSUPPORT || errno == EPERM || errno == EACCES))
+		SKIP(return, "socket(%d, %d, %d) not available: %s",
+		     variant->family, variant->type, variant->protocol,
+		     strerror(errno));
+	ASSERT_GE(self->sockfd, 0) {
+		TH_LOG("Failed to create socket(%d, %d, %d): %s",
+		       variant->family, variant->type, variant->protocol,
+		       strerror(errno));
+	}
+}
+
+FIXTURE_TEARDOWN(xattr_socket_types)
+{
+	if (self->sockfd >= 0)
+		close(self->sockfd);
+}
+
+TEST_F(xattr_socket_types, set_get_list_remove)
+{
+	char buf[256], list[4096], *ptr;
+	ssize_t ret;
+	bool found;
+
+	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
+			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("fsetxattr failed: %s", strerror(errno));
+	}
+
+	memset(buf, 0, sizeof(buf));
+	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, buf, sizeof(buf));
+	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE));
+	ASSERT_STREQ(buf, TEST_XATTR_VALUE);
+
+	memset(list, 0, sizeof(list));
+	ret = flistxattr(self->sockfd, list, sizeof(list));
+	ASSERT_GT(ret, 0);
+	found = false;
+	for (ptr = list; ptr < list + ret; ptr += strlen(ptr) + 1) {
+		if (strcmp(ptr, TEST_XATTR_NAME) == 0)
+			found = true;
+	}
+	ASSERT_TRUE(found);
+
+	ret = fremovexattr(self->sockfd, TEST_XATTR_NAME);
+	ASSERT_EQ(ret, 0);
+
+	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, buf, sizeof(buf));
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ENODATA);
+}
+
+/*
+ * Test abstract namespace AF_UNIX socket.
+ * Abstract sockets don't have a filesystem path; their inodes live in
+ * sockfs so user.* xattrs should work via fsetxattr/fgetxattr.
+ */
+FIXTURE(xattr_abstract)
+{
+	int sockfd;
+};
+
+FIXTURE_SETUP(xattr_abstract)
+{
+	struct sockaddr_un addr;
+	char name[64];
+	int ret, len;
+
+	self->sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
+	ASSERT_GE(self->sockfd, 0);
+
+	len = snprintf(name, sizeof(name), "xattr_test_abstract_%d", getpid());
+
+	memset(&addr, 0, sizeof(addr));
+	addr.sun_family = AF_UNIX;
+	addr.sun_path[0] = '\0';
+	memcpy(&addr.sun_path[1], name, len);
+
+	ret = bind(self->sockfd, (struct sockaddr *)&addr,
+		   offsetof(struct sockaddr_un, sun_path) + 1 + len);
+	ASSERT_EQ(ret, 0);
+}
+
+FIXTURE_TEARDOWN(xattr_abstract)
+{
+	if (self->sockfd >= 0)
+		close(self->sockfd);
+}
+
+TEST_F(xattr_abstract, set_get)
+{
+	char buf[256];
+	ssize_t ret;
+
+	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
+			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("fsetxattr on abstract socket failed: %s",
+		       strerror(errno));
+	}
+
+	memset(buf, 0, sizeof(buf));
+	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, buf, sizeof(buf));
+	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE));
+	ASSERT_STREQ(buf, TEST_XATTR_VALUE);
+}
+
+TEST_HARNESS_MAIN

-- 
2.47.3


