Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19474C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CFDF6B0095; Mon, 21 Sep 2026 09:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880B76B00C2; Mon, 21 Sep 2026 09:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749406B00E1; Mon, 21 Sep 2026 09:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3906D6B0095
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:45:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A951A140189
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:31 +0000 (UTC)
X-FDA: 85237891662.16.1C5E9F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id C209DA0004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h/rFH8Zs";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h/rFH8Zs";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998329;
	b=dEukNDVp8HqlVe3zHoUbGX7H5cMYBLd0RkpqtTUpC7Xo9aYEFkxs0FKIgiKAKwwKKDFcCo
	2TvoSAawFKu6paEsSCX/haxFssjpnWvZc819M5eYxDR4MvjjPqV7KIPghsQaIvDZIzIxtw
	sQzye5buVVpMtLWe78MChxiksnySnC0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KLvfkpS23JCn2CXYfQOmk6fEd8FSOSIuJs6EdAaAT6Q=;
	b=RWW7d722xdknEh51wKVE5LDzq5qU1I2h/+yJBoEyVI0Wsttat7udM/w+o58GAYybSSoXtB
	swQvHzcW+XD+6lV5p7QjhM9dMTwtLz0HpyFOJpDTpIl/YQ8KWlDVVA6yC3AbBG4rhKhPoV
	DWwXCVN0NEnA5KlCUBYt9rkUP3ZinxQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1884A40A5A;
	Mon, 21 Sep 2026 13:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FB51F00893;
	Mon, 21 Sep 2026 13:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998329;
	bh=KLvfkpS23JCn2CXYfQOmk6fEd8FSOSIuJs6EdAaAT6Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h/rFH8ZsupCO+swxIB1x5v+6Ozf1ytidKeByd6wOFVgOLCyKF3L0VwEeRSdtnLqEd
	 HY/R6MaBqxvaFA9kffm8j8phg1g0woBX3ypvMRbjIMU/t/1QYkYVZ+RPlXulQSBvMn
	 HMnApiB+t7qLxnoeu6KLzWzvh2eCDenARI2eV97nxlPrVroaAzfdTvDNprJzVKmLPB
	 I1FGCDOubt88fUPJsRzGxTtW8SsPA+mSWsw+Fn6icQZbomKnya1QDBfZFeqsKsleeh
	 8Rky0Omhe2npwvAioi5QmGHC5cQmHwIEddgW/VneZCHIFRNxo+fiKFGPmVsUviXeAz
	 OLK+QEtLnKlmQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 21 Sep 2026 15:44:55 +0200
Subject: [PATCH v3 06/17] selftests/coredump: test shared signal
 retargeting during a dump
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-work-coredump-fixes-v3-6-8e4adb1619e6@kernel.org>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
In-Reply-To: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Chris Mason <mason@kernel.org>, 
 linux-fsdevel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 linux-mm@kvack.org, io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=8649; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/dKxqrUBxOfXQKOPdr3qWxNvgJBTGWmD/msznfje9uc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtNLnzZ4ul2dz8Ew0snTd8Ze9UznFIdOlaqF2q6Vy6l
 bnec+v5jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkoPGP4w5dm8L4naVHmxp4l
 +1ydE9cWMga67/maZuA9/XqDYYbVLUaG9UFuhSZ/E6/XLSlYkBtk9C9izZdFUUevuntenc533DC
 FFwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: C209DA0004
X-Stat-Signature: wez7kckkr7zcrhnzftd9f6p6pkjsijqq
X-Rspamd-Server: rspam01
X-HE-Tag: 1789998329-511154
X-HE-Meta: U2FsdGVkX1+vG2nD5fy00L8vgWOWa8tEnVYmusmXkTIWts06yscE5/STHMqG5q4a+VXPWsCj3QtMBft6Fks8Be0SKvVgiSFABAg66Nf1LcB0aPvUUHYRRnkJ6Ta42NcIqRzdL9HFvgB1BALsk3AXRPgWfBY7F+x6HJyH1lq8kkKlAQXftdHgc740VMrMgYf9lQLl/UshrRPhAWsnN46jnktwsf3gpA00sELHBlnKOUWWyZKqacu3srmkTsWU0fWV8W1U/jvJqLj0PfaMP4aO5KJXYkJBi5ANdQvLX2SEytX2IaXnSElbl8Qf8voHBheIik41lDzXQxfiIHZ1VnpxBx2DQx4aPKIvFpOPEjWqww+GXgYWCvYmFyjWU94jZT/3cZ8cv7I9oedah9ymuQrVsixiAcVPYI2lAPJhK6cSj5tlloaA0GmKwakb0vmL1U2Nw1l4bgVB6Tk3qoXCT5xssUaHPKYMvsGcH6peO9+sREKpMJMVwc/Z2IqBti/r/x9T2766VMx7Bb5dXqeUbtNEyj0WEQUEajytDjU7tjxOEOsbqtb0ur/GTt+EkLhNEhS4TrRL57djYFra7T3g+Kt0bYK9B7Amd5sLxfm8Zq/KSYF4uWbQXYbLTtOfxwk4S2QpWX2EJHHw/iHi/3t6eapKHSZmzjXE7c8VM6GMqFgtUKObU1+mJ0dtglSY7X6JpogjrEu8kgG2oMYfKXC6saaxQ4OwkcgvN8U9qISiKYiZv9jXlctarubiMTQXEjRaR4/vEIPL7p6Ecfgr1aUa/hVs9NqqSlira0h0gLyqNk5j73erHbda1riaHtIOpqNfoD/AWrPsKdcBEcXT1Z3BnA2VU2i14FkM2WU4xcb7zHZxXoDOFw0ANiEpK6hYlIALimSxAJgPVBOXZjWSBoq00Cv/coV+RvQfphQxYOCEQnk90Iz1O1lGsUW4mm0DlCrvVa/FFu0IrrplFSC0R1Rwfte
 cLpDWzcQ
 Kmgb/WqB1vVuxa8wrqO8mXcgSUvj/is7bwrc1Aa8BUhMSnucXI1/QcpuSRsIFFhfHn3mA2lo0oT5iFyvnOas/p/IOtR1GiESWS2L2Qp4T/AksRSRkhgTZtj3KZ4u2KkyOIQXxojH0Tt19vvC4vO1hLfGmLUoCKlCP8YqFb8UZs06Ix2DMFjrA6M6ig4OVNG6CDh1or1/WvcTCrfdMN8/OokpXgwIUKELu7pY/yuFVeyw2am/FC27VnaIbYw==
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
index dece1a31d561..d6cd9a7e9ac0 100644
--- a/tools/testing/selftests/coredump/Makefile
+++ b/tools/testing/selftests/coredump/Makefile
@@ -3,7 +3,8 @@ CFLAGS += -Wall -O0 -g $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
 
 TEST_GEN_PROGS := stackdump_test \
 		  coredump_socket_test \
-		  coredump_socket_protocol_test
+		  coredump_socket_protocol_test \
+		  coredump_signal_test
 TEST_FILES := stackdump
 
 include ../lib.mk
@@ -11,3 +12,4 @@ include ../lib.mk
 $(OUTPUT)/stackdump_test: coredump_test_helpers.c
 $(OUTPUT)/coredump_socket_test: coredump_test_helpers.c
 $(OUTPUT)/coredump_socket_protocol_test: coredump_test_helpers.c
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


