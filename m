Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66AE9C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 898E46B00A6; Thu, 17 Sep 2026 05:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8713E6B00A7; Thu, 17 Sep 2026 05:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C3366B00A9; Thu, 17 Sep 2026 05:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBC576B00A6
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:18:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C182140292
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:18:11 +0000 (UTC)
X-FDA: 85222702782.02.8DB36EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 798B340002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:18:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=APv1pnKF;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789636689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FUrlkvpu/Nf0o2935ZPXruW9+9ifRNjvMUcRqNTb/II=;
	b=gi1FLxWXMCIoZ6yJ+BGPK9FszlTD4jRC0+hzsACB+KJReaAmrKd+V+Zc8HADeGTQco96em
	7HNXzphBqVj2YiwQP+3DPwsWYS1ajx4o7Ev/seNBIdlxxrzgkqQqc4wysTFJ2wh+aQ85Yl
	FgB/aNRdtNR6POeAFr7n2MDkhl8iCm8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=APv1pnKF;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789636689;
	b=XhQXrMuDdBJMeCL0psOnsy+yD0Zt/Qz3Df3ziNwNbe2Lqz6+qdkNuIu1r9HMeXELrf2zNQ
	Ifzu9VMOACG8rQDFn5EWPQM9Xeg4yrSO5bFEH9L+0YBd0CQkFiDxsJYxrQv2R2P0bcjVDV
	2h746M5rGbsBBu5lLRA3wTeiTKU5Nts=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2362260210;
	Thu, 17 Sep 2026 09:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200E21F00893;
	Thu, 17 Sep 2026 09:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636688;
	bh=FUrlkvpu/Nf0o2935ZPXruW9+9ifRNjvMUcRqNTb/II=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=APv1pnKFZYBdgK6fudPlsT5VdSrVFX8DrbxLWQxaDiIhUR32H8H5z1e7kZ/e/7Z5m
	 OAD1tmaogpKO9S+d96pdQo6VJr4qNTrP1LcYu60+PuOXj3au8f6C0vrMydhjCzvrcf
	 /vCi4uhQh55JKS7anbYcHCksLgt7vILzChmjqLdn2h8PIwQo6aRJcLkG6xDBSR7Fgw
	 txEOcloSxFV2d+k0qVEuPxvLzMC73VeAg9Pzg2wHTYYX0YulYn4oHjmZ3hAx6LEMe/
	 9nTVS4QmwbXX8fv5ZUKlRLpKhOHXd68V90fBZLFh+Wr4TKDgQGVNbRG3oh7pnu+vh7
	 PI8+bPF/jdkAQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 17 Sep 2026 11:17:34 +0200
Subject: [PATCH v2 7/7] selftests/coredump: test shared signal retargeting
 during a dump
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-work-coredump-fixes-v2-7-f3787fcda051@kernel.org>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
In-Reply-To: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
 linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
 io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=8719; i=brauner@kernel.org;
 h=from:subject:message-id; bh=sNwBchyr0+67z59O/cph18409VT+YCwXJeYiT5NbMnQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt3mAyrVN7dtS0ObXnjvz6feDI9pNB3LNlV6j2NjIu/
 mATue+iTEcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEZk1l+KcxRWS5id32ks8y
 C1c9Ul737+Zvppr5ndaqP+8W8E943/OF4Z+ZY8Pr1u5XzNtMTZ/HfWG77uzD0fbuhWBZ+koBFU2
 hizwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 798B340002
X-Stat-Signature: om35m8bsj4safnfo7m3ikziroe4pedw7
X-Rspam-User: 
X-HE-Tag: 1789636689-445392
X-HE-Meta: U2FsdGVkX19aPuWsdJJOQ2xdkxgR+oHozc5gyOzwlW5p3ra8traZeTTxIwJy2D6TOPFMMkxa9K4y6dymOtmW3txJ4StZAY7F2V4zFGiCyoJhW0bm6GcIpaWGoekKrS+SixdFEY0H2IATvx4ussGeaiBkqWkgvq06VGpzi5WaUwhgHO+++3VxNL7gApNHF1LTgJ7CcQ282DLmaPIZbDsKhm+oYBfcv9bFpb4bYQI2TTsvvsaFeBBQM+/W3yvhXEFPoCzSxLfr1zcAs+1N1Wvw7pwl3k1nE4uWlPk9xOiO8EiwCQVPsxRhuL3ooflYcRnrhHm6U5TmTiVAEIlFf2M6QyC3FFGQ3Kz1G51UGgUg/r7pBt03mLqm2WmIK6EaPUQVQB/TGTAczke8VF9dOgtPBI5FgWmxfi7Sdsesj7JXdY4gXh7EpXcS4Lh9OAe7JLSWkl04Zbkrii1lDsq0Nhh5h4YWtUgiAo3G7eqP1jURz8eYOvKFIsHpTlDfN44FJC7tABqex/2Ra4W7CJV5+YmyjEmMkdllj65UXJluqsC9v0A51/kjm/kMEe2DJjUof7JORZoRITy+yMYM4nbiviUp/otoj5Ng6+5ckAcpae69B7oe/xUMWufoFvO3bPxvCn4WW7DnlxcqUrcj2Oz8J8BPsbPuP3DMk8tG7TddQBTSHraUfg/3i0YqWAomJBo61Zku44FJeQO3cwzXZNdEqx0PwplGXCwmHqYlUykBdBUlfQAXw9P/NAJSaQpCXCMYPQV+588HdfeV6fT9X91uQSEyGg5MHKjXb2R+mXyQ2U/ilF+R4lF4gp/fa8IyOGPkN+cpegOEsg08jnbHqRwtG4u8iPG43n8G2clFmbj+8t8ZfGDatlw2GoDjG5r6N8Kfd9OMwlNG59qNYodH4uG+9xDtjOBdmTzgoidTDFmET7OFuRzGcRZCYHTzyakCDiKl9ZGZC3JlYf+YHKEhdrEcEKO
 pxoepms5
 4PGCEh8C+HbRKjwKV5yXweZfBPrDK66xk7oZI9Zcdj29ZaTGrojuAWzdIp1CVDqMG2GvWPbPjeO95WMxE1QYtNdrzt+3Td5IIzcm4Z09GSDot27JY011VRVTDMHAO9Q0Z8hA4KteWH6Z2b87+hnPypfhSWomDl6CD/3vCkBrshMsT2hVNx3sBw0LTzQYtXpDDlRXatIQrwFJVSqGcBHJM/UxxdmdFso118AJU9UPP+p8ySMwXwubE5yNbqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A shared signal that is still queued when a thread crashes gets
retargeted to the dumper when a zapped sibling restores its signal mask
on the way out of sigtimedwait(). That sets TIF_SIGPENDING on the dumper
and cuts the core short at the next full pipe or socket buffer. Cover
that:

- one sibling sleeps in sigtimedwait() for SIGUSR1

- a vfork() child queues SIGUSR1 for the main thread while it sleeps
  killably and then the SIGSEGV that is dequeued first

- the coredump server holds its read back so the dumper blocks on the
  full socket buffer

Check that the core covers every segment with and without the queued
signal.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/coredump/.gitignore        |   1 +
 tools/testing/selftests/coredump/Makefile          |   4 +-
 .../selftests/coredump/coredump_signal_test.c      | 238 +++++++++++++++++++++
 3 files changed, 242 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/coredump/.gitignore b/tools/testing/selftests/coredump/.gitignore
index 097f52db0be9..c198f2ca5872 100644
--- a/tools/testing/selftests/coredump/.gitignore
+++ b/tools/testing/selftests/coredump/.gitignore
@@ -2,3 +2,4 @@
 stackdump_test
 coredump_socket_test
 coredump_socket_protocol_test
+coredump_signal_test
diff --git a/tools/testing/selftests/coredump/Makefile b/tools/testing/selftests/coredump/Makefile
index dc8489d40618..bfb53f512d8e 100644
--- a/tools/testing/selftests/coredump/Makefile
+++ b/tools/testing/selftests/coredump/Makefile
@@ -4,7 +4,8 @@ CFLAGS += -Wall -O0 -g $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
 TEST_GEN_PROGS := stackdump_test \
 		  coredump_socket_test \
 		  coredump_socket_protocol_test \
-		  coredump_close_files_test
+		  coredump_close_files_test \
+		  coredump_signal_test
 TEST_FILES := stackdump
 
 include ../lib.mk
@@ -13,3 +14,4 @@ $(OUTPUT)/stackdump_test: coredump_test_helpers.c
 $(OUTPUT)/coredump_socket_test: coredump_test_helpers.c
 $(OUTPUT)/coredump_socket_protocol_test: coredump_test_helpers.c
 $(OUTPUT)/coredump_close_files_test: coredump_test_helpers.c
+$(OUTPUT)/coredump_signal_test: coredump_test_helpers.c
diff --git a/tools/testing/selftests/coredump/coredump_signal_test.c b/tools/testing/selftests/coredump/coredump_signal_test.c
new file mode 100644
index 000000000000..fdf48b144781
--- /dev/null
+++ b/tools/testing/selftests/coredump/coredump_signal_test.c
@@ -0,0 +1,238 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <fcntl.h>
+#include <pthread.h>
+#include <signal.h>
+#include <sys/mman.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/un.h>
+#include <unistd.h>
+
+#include "coredump_test.h"
+
+/* Big enough to fill the socket buffer many times over. */
+#define CRASH_MAPPING_SIZE (32 * 1024 * 1024)
+
+FIXTURE_SETUP(coredump)
+{
+	FILE *file;
+	int ret;
+
+	self->pid_coredump_server = -ESRCH;
+	self->fd_tmpfs_detached = -1;
+	file = fopen("/proc/sys/kernel/core_pattern", "r");
+	ASSERT_NE(NULL, file);
+
+	ret = fread(self->original_core_pattern, 1, sizeof(self->original_core_pattern), file);
+	ASSERT_TRUE(ret || feof(file));
+	ASSERT_LT(ret, sizeof(self->original_core_pattern));
+
+	self->original_core_pattern[ret] = '\0';
+
+	ret = fclose(file);
+	ASSERT_EQ(0, ret);
+}
+
+FIXTURE_TEARDOWN(coredump)
+{
+	const char *reason;
+	FILE *file;
+	int ret, status;
+
+	if (self->pid_coredump_server > 0) {
+		kill(self->pid_coredump_server, SIGTERM);
+		waitpid(self->pid_coredump_server, &status, 0);
+	}
+	unlink("/tmp/coredump.file");
+	unlink("/tmp/coredump.socket");
+
+	file = fopen("/proc/sys/kernel/core_pattern", "w");
+	if (!file) {
+		reason = "Unable to open core_pattern";
+		goto fail;
+	}
+
+	ret = fprintf(file, "%s", self->original_core_pattern);
+	if (ret < 0) {
+		reason = "Unable to write to core_pattern";
+		goto fail;
+	}
+
+	ret = fclose(file);
+	if (ret) {
+		reason = "Unable to close core_pattern";
+		goto fail;
+	}
+
+	return;
+fail:
+	/* This should never happen */
+	fprintf(stderr, "Failed to cleanup coredump test: %s\n", reason);
+}
+
+static volatile int waiter_ready;
+
+static void usr1_handler(int sig)
+{
+}
+
+/* Sleeps in sigtimedwait() with SIGUSR1 unblocked only inside the kernel. */
+static void *sigwaiter(void *arg)
+{
+	sigset_t set;
+	siginfo_t info;
+
+	sigemptyset(&set);
+	sigaddset(&set, SIGUSR1);
+	__atomic_store_n(&waiter_ready, 1, __ATOMIC_RELEASE);
+	for (;;)
+		sigtimedwait(&set, &info, NULL);
+	return NULL;
+}
+
+/*
+ * Crash with a shared SIGUSR1 still queued for this thread. The vfork()
+ * child queues it while we sleep killably and then the SIGSEGV that is
+ * dequeued first. The zap wakes the sibling out of sigtimedwait() and its
+ * mask restore retargets SIGUSR1 to the dumper.
+ */
+static void crashing_child_retarget(bool queue_shared)
+{
+	sigset_t all, old;
+	pthread_t thread;
+	pid_t pid, tid;
+	char *p;
+
+	p = mmap(NULL, CRASH_MAPPING_SIZE, PROT_READ | PROT_WRITE,
+		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (p == MAP_FAILED)
+		_exit(EXIT_FAILURE);
+	memset(p, 0x5a, CRASH_MAPPING_SIZE);
+
+	signal(SIGUSR1, usr1_handler);
+	sigfillset(&all);
+	pthread_sigmask(SIG_BLOCK, &all, &old);
+	/* One waiter only, retarget stops at the first thread not blocking it. */
+	if (pthread_create(&thread, NULL, sigwaiter, NULL))
+		_exit(EXIT_FAILURE);
+	pthread_sigmask(SIG_SETMASK, &old, NULL);
+	while (!__atomic_load_n(&waiter_ready, __ATOMIC_ACQUIRE))
+		usleep(1000);
+	usleep(50 * 1000);
+
+	pid = getpid();
+	tid = syscall(SYS_gettid);
+	if (vfork() == 0) {
+		if (queue_shared)
+			syscall(SYS_kill, pid, SIGUSR1);
+		syscall(SYS_tgkill, pid, tid, SIGSEGV);
+		syscall(SYS_exit, 0);
+	}
+
+	/* Not reached, the pending SIGSEGV dumps core. */
+	for (;;)
+		pause();
+}
+
+/*
+ * Dump the crashing child into /tmp/coredump.file through a server that
+ * holds the read back so the dumper blocks on the full socket buffer.
+ */
+static void run_coredump(struct __test_metadata *const _metadata,
+			 FIXTURE_DATA(coredump) *self, bool queue_shared)
+{
+	pid_t pid, pid_coredump_server;
+	int ipc_sockets[2];
+	int status;
+	char c;
+
+	unlink("/tmp/coredump.file");
+	unlink("/tmp/coredump.socket");
+	ASSERT_TRUE(set_core_pattern("@/tmp/coredump.socket"));
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, ipc_sockets), 0);
+
+	pid_coredump_server = fork();
+	ASSERT_GE(pid_coredump_server, 0);
+	if (pid_coredump_server == 0) {
+		int fd_server = -1, fd_coredump = -1, fd_core_file = -1;
+		int exit_code = EXIT_FAILURE;
+
+		close(ipc_sockets[0]);
+
+		fd_server = create_and_listen_unix_socket("/tmp/coredump.socket");
+		if (fd_server < 0)
+			goto out;
+
+		if (write_nointr(ipc_sockets[1], "1", 1) < 0)
+			goto out;
+		close(ipc_sockets[1]);
+
+		fd_coredump = accept4(fd_server, NULL, NULL, SOCK_CLOEXEC);
+		if (fd_coredump < 0) {
+			fprintf(stderr, "%s: accept4 failed: %m\n", __func__);
+			goto out;
+		}
+
+		/* Let the dumper run into the full socket buffer first. */
+		sleep(1);
+
+		fd_core_file = creat("/tmp/coredump.file", 0644);
+		if (fd_core_file < 0) {
+			fprintf(stderr, "%s: creat failed: %m\n", __func__);
+			goto out;
+		}
+
+		if (recv_coredump_bytes(fd_coredump, fd_core_file) < 0)
+			goto out;
+
+		exit_code = EXIT_SUCCESS;
+out:
+		if (fd_core_file >= 0)
+			close(fd_core_file);
+		if (fd_coredump >= 0)
+			close(fd_coredump);
+		if (fd_server >= 0)
+			close(fd_server);
+		_exit(exit_code);
+	}
+	self->pid_coredump_server = pid_coredump_server;
+
+	EXPECT_EQ(close(ipc_sockets[1]), 0);
+	ASSERT_EQ(read_nointr(ipc_sockets[0], &c, 1), 1);
+	EXPECT_EQ(close(ipc_sockets[0]), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0)
+		crashing_child_retarget(queue_shared);
+
+	waitpid(pid, &status, 0);
+	ASSERT_TRUE(WIFSIGNALED(status));
+	ASSERT_EQ(WTERMSIG(status), SIGSEGV);
+	ASSERT_TRUE(WCOREDUMP(status));
+
+	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
+}
+
+static void check_coredump_complete(struct __test_metadata *const _metadata)
+{
+	int fd;
+
+	fd = open("/tmp/coredump.file", O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(fd, 0);
+	ASSERT_TRUE(check_coredump_extent(fd));
+	close(fd);
+}
+
+TEST_F(coredump, retarget_shared_pending)
+{
+	run_coredump(_metadata, self, false);
+	check_coredump_complete(_metadata);
+
+	run_coredump(_metadata, self, true);
+	check_coredump_complete(_metadata);
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0


