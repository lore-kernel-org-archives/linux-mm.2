Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7187BC55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 18:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEF076B0093; Sun,  2 Aug 2026 14:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6906B0095; Sun,  2 Aug 2026 14:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8ECF6B0096; Sun,  2 Aug 2026 14:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4506B0093
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 14:01:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6ABD81C0E50
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:01:06 +0000 (UTC)
X-FDA: 85057095732.15.155FF0B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9AC2E14000C
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:01:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nJZ/Zhqp";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785693664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gsGb3DyU1rE+X3NhCHX1jw/pkRSQtfiqt69SPUGhWe8=;
	b=uUrMN8kvLuAO4FjQBIwomeqKSbLGCqLcHlr3qupAnIQOS0y5kxorV5xwd5S15X+CU9H7NR
	SrNNyAGzqJhEmagkfKeJCEZfL6vCGup9+O0V7FiUHD1MqR5rXoxjGJES1w+sXykT2bH2v9
	Hqc4tUvRTfu7iIcbT+aV2q8Supzpz5k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nJZ/Zhqp";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785693664;
	b=tBme7xuz3/DO0LbcMSHkvGK9rCILMZdwxH6/1h+y8ttwV9qJ/jKXMUrJMcRER2Teq2pKEH
	jUKY2RR4tyTFHqZPce2Ok3cSf0Fm/zdRGYAaKgDNxlAvfIiC3deL1/08qq37LlP4wbHdbf
	cC+rZYEfYvx4T7Kt4kj48u4Qb8XMCs8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B247E6001A;
	Sun,  2 Aug 2026 18:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66D21F00A3D;
	Sun,  2 Aug 2026 18:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785693663;
	bh=gsGb3DyU1rE+X3NhCHX1jw/pkRSQtfiqt69SPUGhWe8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nJZ/ZhqpFyFfyz8MrzX5b+8t3wdFraUa0ZagbVtqyn7Aqc9BO8fuivRYsQJ5nZwo7
	 SmAGSGyd8QwBOs9Uae9MXrUY2iiWvVxzKPyUM/A7PxjqMdwY/bxJljwFdrTzbD8/e8
	 WEa7Jo2x4CFtJrzJ0jo5xI9y8SjmnaMEx6LLd24nvpNZVNF9LY9oJq13Q/TplAi35w
	 QW1cQvcEpgQirrosUznTOwi7pVdM7Zh22TZRfpDvr1bmP5PAdJm1Kzya78ioj6KeeX
	 mFk1FLkQL7kOPQQLonfGI80Qe4EPMbqbaIYgbRWNrjUXdPyEokPtMP3egs7JSRnO1w
	 94my4wCHCyjDg==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 02 Aug 2026 20:00:45 +0200
Subject: [PATCH 3/3] selftests/filesystems: test completing a context from
 another user namespace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260802-work-fill_super-warn-v1-3-4e987911a39a@kernel.org>
References: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
In-Reply-To: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, Laurent Vivier <laurent@vivier.eu>, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f2f85
X-Developer-Signature: v=1; a=openpgp-sha256; l=8360; i=brauner@kernel.org;
 h=from:subject:message-id; bh=qDRJ7E22DEznk9+Q2R6uF7IWUA4oDIXitLC6nj5xlLI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTlt15er8WwZ6UJ2/sLMfyrDSNV7np0eXy13tFdGqW7Y
 e0W2fmVHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPp1WL475vxwneK/vT19g9f
 LJhkstFHakLX2orPm/ye83j5ZP7qjmdkWCthey0+t6v3aHdxmc8JSZkD5WdFJvV/0tG9dC8qJj+
 IEQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9AC2E14000C
X-Rspam-User: 
X-Stat-Signature: 53rfr544ghqnohh758xbznm79mraw5kx
X-HE-Tag: 1785693664-501966
X-HE-Meta: U2FsdGVkX19FWG8HgXKiLXa8t9l0ZeIPwSrhIIl420DlMvdoX7ejVUJKTp3bgFOrIx7l4ohD6tVxPQOXFCoqp38JrdOOBZnKaAkYmH4lh7AAAmfBVMlT+gV7bTruZqtEXdaICXyekYEsx9PR9lXiB7iVEeHd6NgJ/gM4FqRhr+unnJlIll0hcUj2Q9voDn3tUQyprq57c5ijDIIQSWJyKP5Xhd7lmyL2kFsCQcnOWqFnWB8RwkDNXgqUkiFHAaoWdQtrUDE+y0N3ZdndRLY6tKwRGj+wGFwunZhugwM6afrO03hYOxjsX2iDYErr/Qdg7g3C8zB0EcgEDqiC5MhJw9qPcdI9Ei7XYnhIyLER9TIftbpNTITSYlhMu/djhHYnnmBmFHp0W+wuUSlrBGe+ozYs/+jovL880j2l/si91Iy8c9m2Kk7M9ZrWbu/Nka+BJieYCl7OXZZYUMYOkC94W5RLPgPvHLnSZMVOxfVHGMCRH3WOTJquPs9SfZtxD7GwVtz1z8im99nyjnL3j/yXm2ev3cVQ104OnUqRRPnv9OggHphFQczFvGAFEQPJhwMsgFYLIa5f6Z4+Mi7bgxlxN3bNEgVnyopyb6MHqM+alRaWXlZCiDY98yTpAkFON06OULnkmi+BIl7DcYfzt3MgQEHd/EHY6vePkM7ov48L+YliFo+EgD0yDrqPdmc1LyBL7m0Kt59K7O/cv+bB/S3miYa8tBZ7ZePuPRlN95TY9mUL9Ey0o+DuP1fRTCNH1YO602MLiXTEXooMfT5Yu+lUsQ7ufIXW2e9n42c1oqjWzamhi3aoQZaZu+SIo4BS7pHdh7iey8pjxnWdKulK3q5onBQ3ksyb7uF1icW9NNQxI8XODTig1v/5tQJ0iCQC8efPus4vgiGz4B/5SUXunRdWZONpvBIKl6VgkeTEpJLQlwC/5Y7B21ZU8ec00gwJ8m4Nmbwm4bAcLWsn8FQz+a1
 vW6k/kJ1
 BXqGi2/wi53qK4xkvoF61okZ3yVRTjA0gfhstnAVx8fBge1xHg+/HLpWtCXLCkKIT7/+RFAYFH9lQ/MCehD2Fvj+hzJJawmpsFV6pGgjtzGU6t7Nz3qzDfgLs8vDg+6qy6XtGbT2iZD0xjRgP3VMP7wBnOi/UNHkoOE79MnwhincZCXpph90MnfHg8nUeNfCuyda77z0AZMc1SmujDaW+4ieL9L6vVtnB0VfjwvuzblgAs0hPsJ86n/nWLyQdhRVMlgZn/SBb6gBMEHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fsopen() records the caller's user namespace in fc->user_ns and hands
back an ordinary file descriptor, so the task that issues
FSCONFIG_CMD_CREATE need not be the one that created the context.
mount_capable() authorizes that for a caller holding CAP_SYS_ADMIN in an
ancestor of fc->user_ns, which any unprivileged user has over a user
namespace it just created.

binfmt_misc and overlayfs used to WARN_ON() the mismatch. Add a test for
both. Also cover the handover within one user namespace. That is a
supported thing to do and has to keep working.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/Makefile                   |   1 +
 .../selftests/filesystems/fscontext_ns/Makefile    |  10 +
 .../filesystems/fscontext_ns/fscontext_ns_test.c   | 239 +++++++++++++++++++++
 3 files changed, 250 insertions(+)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 8d4db2241cc2..b622052ec3e9 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -42,6 +42,7 @@ TARGETS += filesystems/fuse
 TARGETS += filesystems/move_mount
 TARGETS += filesystems/empty_mntns
 TARGETS += filesystems/fsmount_ns
+TARGETS += filesystems/fscontext_ns
 TARGETS += firmware
 TARGETS += fpu
 TARGETS += ftrace
diff --git a/tools/testing/selftests/filesystems/fscontext_ns/Makefile b/tools/testing/selftests/filesystems/fscontext_ns/Makefile
new file mode 100644
index 000000000000..7e3506294757
--- /dev/null
+++ b/tools/testing/selftests/filesystems/fscontext_ns/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+TEST_GEN_PROGS := fscontext_ns_test
+
+CFLAGS += -Wall -O0 -g $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
+LDLIBS := -lcap
+
+include ../../lib.mk
+
+$(OUTPUT)/fscontext_ns_test: fscontext_ns_test.c ../utils.c
+	$(CC) $(CFLAGS) -o $@ $^ $(LDLIBS)
diff --git a/tools/testing/selftests/filesystems/fscontext_ns/fscontext_ns_test.c b/tools/testing/selftests/filesystems/fscontext_ns/fscontext_ns_test.c
new file mode 100644
index 000000000000..0f30a3e6e197
--- /dev/null
+++ b/tools/testing/selftests/filesystems/fscontext_ns/fscontext_ns_test.c
@@ -0,0 +1,239 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 Christian Brauner <brauner@kernel.org>
+ *
+ * Test that completing a filesystem context from another user namespace
+ * doesn't warn.
+ *
+ * fsopen() records the caller's user namespace in fc->user_ns and hands
+ * back an ordinary file descriptor. The task that issues
+ * FSCONFIG_CMD_CREATE need not be the one that created the context: the fd
+ * is inherited across fork() and exec() and it can be passed over a unix
+ * socket. vfs_cmd_create() authorizes the create with mount_capable(),
+ * which for FS_USERNS_MOUNT checks ns_capable(fc->user_ns, CAP_SYS_ADMIN),
+ * and that succeeds for a task holding CAP_SYS_ADMIN in an ancestor of
+ * fc->user_ns.
+ *
+ * binfmt_misc and overlayfs used to WARN_ON() that mismatch, which let an
+ * unprivileged user taint the kernel, flood the log and panic a kernel
+ * booted with panic_on_warn. The mount must still be refused, but it must
+ * not warn.
+ */
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "../wrappers.h"
+#include "../utils.h"
+#include "../../kselftest_harness.h"
+
+#ifndef FSCONFIG_CMD_CREATE
+#define FSCONFIG_CMD_CREATE	6
+#endif
+
+/* TAINT_WARN, i.e. bit 9 of /proc/sys/kernel/tainted. */
+#define TAINT_WARN_BIT		9
+
+static bool taint_warn_set(void)
+{
+	unsigned long taint = 0;
+	FILE *f;
+
+	f = fopen("/proc/sys/kernel/tainted", "r");
+	if (!f)
+		return false;
+	if (fscanf(f, "%lu", &taint) != 1)
+		taint = 0;
+	fclose(f);
+
+	return taint & (1UL << TAINT_WARN_BIT);
+}
+
+static int send_fd(int sock, int fd)
+{
+	char cmsgbuf[CMSG_SPACE(sizeof(int))] = {};
+	char b[1] = { 'x' };
+	struct iovec iov = { .iov_base = b, .iov_len = sizeof(b) };
+	struct msghdr msg = {
+		.msg_iov	= &iov,
+		.msg_iovlen	= 1,
+		.msg_control	= cmsgbuf,
+		.msg_controllen	= sizeof(cmsgbuf),
+	};
+	struct cmsghdr *cmsg;
+
+	cmsg = CMSG_FIRSTHDR(&msg);
+	cmsg->cmsg_level = SOL_SOCKET;
+	cmsg->cmsg_type = SCM_RIGHTS;
+	cmsg->cmsg_len = CMSG_LEN(sizeof(int));
+	memcpy(CMSG_DATA(cmsg), &fd, sizeof(int));
+
+	return sendmsg(sock, &msg, 0) < 0 ? -1 : 0;
+}
+
+static int recv_fd(int sock)
+{
+	char cmsgbuf[CMSG_SPACE(sizeof(int))] = {};
+	char b[1];
+	struct iovec iov = { .iov_base = b, .iov_len = sizeof(b) };
+	struct msghdr msg = {
+		.msg_iov	= &iov,
+		.msg_iovlen	= 1,
+		.msg_control	= cmsgbuf,
+		.msg_controllen	= sizeof(cmsgbuf),
+	};
+	struct cmsghdr *cmsg;
+	int fd = -1;
+
+	if (recvmsg(sock, &msg, 0) <= 0)
+		return -1;
+
+	cmsg = CMSG_FIRSTHDR(&msg);
+	if (!cmsg || cmsg->cmsg_type != SCM_RIGHTS)
+		return -1;
+	memcpy(&fd, CMSG_DATA(cmsg), sizeof(int));
+
+	return fd;
+}
+
+/*
+ * Create a context for @fsname in a child and complete it here. With @nest
+ * the child first creates its own user namespace, so that the context is
+ * created in a descendant of the namespace completing it. The child needs a
+ * mount namespace of its own as well: fsopen() gates on may_mount(), which
+ * asks for CAP_SYS_ADMIN in the user namespace owning the caller's mount
+ * namespace.
+ *
+ * Returns the result of FSCONFIG_CMD_CREATE with errno set, or -ENODATA if
+ * the child could not create the context at all.
+ */
+static int create_from_child(const char *fsname, bool nest)
+{
+	int sock[2], fd, ret, status;
+	pid_t pid;
+
+	if (socketpair(AF_UNIX, SOCK_STREAM, 0, sock))
+		return -ENODATA;
+
+	pid = fork();
+	if (pid < 0) {
+		close(sock[0]);
+		close(sock[1]);
+		return -ENODATA;
+	}
+
+	if (pid == 0) {
+		close(sock[0]);
+
+		if (nest && unshare(CLONE_NEWUSER | CLONE_NEWNS))
+			_exit(1);
+
+		fd = sys_fsopen(fsname, 0);
+		if (fd < 0)
+			_exit(1);
+		if (send_fd(sock[1], fd))
+			_exit(1);
+		_exit(0);
+	}
+
+	close(sock[1]);
+	fd = recv_fd(sock[0]);
+	close(sock[0]);
+	wait_for_pid(pid);
+	waitpid(pid, &status, WNOHANG);
+
+	if (fd < 0)
+		return -ENODATA;
+
+	errno = 0;
+	ret = sys_fsconfig(fd, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
+	status = errno;
+	close(fd);
+	errno = status;
+
+	return ret;
+}
+
+FIXTURE(fscontext_ns) {
+	bool warn_before;
+};
+
+FIXTURE_SETUP(fscontext_ns)
+{
+	self->warn_before = taint_warn_set();
+
+	if (setup_userns() != 0)
+		SKIP(return, "setup_userns failed");
+}
+
+FIXTURE_TEARDOWN(fscontext_ns)
+{
+}
+
+/*
+ * The condition the kernel used to WARN about. It has to be refused, and it
+ * has to be refused quietly: an unprivileged task reaches this.
+ */
+FIXTURE_VARIANT(fscontext_ns) {
+	const char *fsname;
+	int expected_errno;
+};
+
+FIXTURE_VARIANT_ADD(fscontext_ns, binfmt_misc) {
+	.fsname = "binfmt_misc",
+	.expected_errno = EINVAL,
+};
+
+FIXTURE_VARIANT_ADD(fscontext_ns, overlay) {
+	.fsname = "overlay",
+	.expected_errno = EIO,
+};
+
+TEST_F(fscontext_ns, create_from_descendant_userns)
+{
+	int ret;
+
+	ret = create_from_child(variant->fsname, true);
+	if (ret == -ENODATA)
+		SKIP(return, "%s unavailable", variant->fsname);
+
+	ASSERT_EQ(-1, ret);
+	ASSERT_EQ(variant->expected_errno, errno);
+
+	/*
+	 * Only meaningful if nothing had warned before us. Note that an
+	 * unrelated warning racing this test would look like a failure.
+	 */
+	if (self->warn_before)
+		TH_LOG("TAINT_WARN already set, not checking for a new warning");
+	else
+		ASSERT_FALSE(taint_warn_set());
+}
+
+/*
+ * The same handover within one user namespace is a supported thing to do and
+ * has to keep working. binfmt_misc takes no options, so the create succeeds
+ * outright and this also shows the test really drives the create path.
+ */
+TEST(create_from_same_userns)
+{
+	int ret;
+
+	if (setup_userns() != 0)
+		SKIP(return, "setup_userns failed");
+
+	ret = create_from_child("binfmt_misc", false);
+	if (ret == -ENODATA)
+		SKIP(return, "binfmt_misc unavailable");
+
+	ASSERT_EQ(0, ret);
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0


