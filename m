Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B393BC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A4966B00A1; Mon, 21 Sep 2026 09:45:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17C976B00A4; Mon, 21 Sep 2026 09:45:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043F16B00E7; Mon, 21 Sep 2026 09:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA4CA6B00E5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:45:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 33E61A4182
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:45 +0000 (UTC)
X-FDA: 85237892250.23.DF74945
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 75B631C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjTZJINT;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998343;
	b=7F7RdLM2wiS8OVgHPq5cAiOCmYwHWkAKygrNyJkMcNW0Uqaec0RUE+dws/LqcMV8hPJg7h
	0pnNTsOkJd+WpUO/7iqVwhxKc6Gy3Mebfyk6h6lzcp1v7roWWl5Ls1BOsEoQq8rmvOZOxV
	QP6loT6ukTxY2PYqiyBUc2+6X0PifuQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjTZJINT;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ifn8NbvGUZMkm87ijwC59e2fPDE4y1g0YRcYcAJljyY=;
	b=T0c4JH1bZX+LSZm9mXWkQ0iAh0M0rWVFbs/lqeFUb/23OMVSZBnVyb/RW/JQ5p5yy8OaC7
	iLfpvf8KGiF61YYuLLiKa1NnPcPwdV2gPSg51V2qBiPagkN8wxhcCMgSRWLKzGsyWakZf5
	wsBWBFjdDLbm9LM5Wo6RVoJwYuLD6R4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0905C601F0;
	Mon, 21 Sep 2026 13:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8D81F0089C;
	Mon, 21 Sep 2026 13:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998342;
	bh=Ifn8NbvGUZMkm87ijwC59e2fPDE4y1g0YRcYcAJljyY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mjTZJINTvfIrccswx+Vb4wZBTHHhss3fSC8NIiQk+uHGrE+eRTiiE+pNiX8WpGBBf
	 BPfAmJNAgZT4+w0U2Q5LD03wutcTywpG6DlyjMcMafVCSgWoONAPJtcFKD/IZUBI4J
	 qy9Vpd4/9w+gEXpn8p0qe4A6xNQ/uz16yhQxqHic6ccVtyfQvt6qVnosWx4hfeYfGp
	 nrCf9fkSGU2itLv4mJ7hriz0TTxPWCi7Hz1jMKTc8viWuN679hg5MRMHMLGahe0Ca0
	 UO3ToI357TucVmaymH7KUfxwDOlbPUC04nj5CLUrVJg0JF1NO9DfUF7+9ryIlfrR5+
	 R2aQDRAgkq6gQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 21 Sep 2026 15:44:59 +0200
Subject: [PATCH v3 10/17] selftests/coredump: test a user worker as the
 coredumping thread
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-work-coredump-fixes-v3-10-8e4adb1619e6@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=14230; i=brauner@kernel.org;
 h=from:subject:message-id; bh=AK8dwx+NdHIKi8Muh2oRCTY0hxajPnpohYEVs7RoaNA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtNLmz03eNfEVR34MPtkpsr1atZpy8Wb7l4KVlx8z/T
 UyNd03S7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjILXuGv/K8c4oOBWbsP+7X
 wOrzefGqkJ8rfkn2vz6fdMqPUXNyXjrD/6LmFanae++++qF7OqO1u3nGfJ692zqYlReJPuC49Nj
 CiwsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 75B631C0002
X-Rspam-User: 
X-Stat-Signature: bx5bkbf5s768mf61o8eznn491xrqyu3p
X-HE-Tag: 1789998343-355812
X-HE-Meta: U2FsdGVkX1+Z+1OKFPCIQuMsyo7vTDvKdqyQX71oXyhH+YsjMgYjynNQ7CW5QfHQC8Z57+4fJyMVLYDq6uwEmM4q8Z0s0nqFMxrmP7i45q1sAN+uPlhhuDxI9JVFbNaM5HT/Y30nCTlNuGBv2KTn+XxUEFa9CUQ3Ll4VSPc3kC5BqjWy/qYPZcSUgPWhP8J6pC95PGbAAnfHHx97+uB84grvM6Q2O74dgHuW9Bq2rq2h8FNYpxqOdE37cLggrbrMnOEg79N8lOb5lWA1o31kO0cQtsfbSKsm/wOmXbWIyta2y/6BZyN3vflCpql854ehxWMephwqeglYpawBTuxp8YRKK2R+zzYH6Bc9uMfpEiCWjtuCRDHpPWQTvE4dCYcpUvCwYgG8bgCc5ixFAbG0fPsqhIecfR9XklqxpEzbFKoBIzOooWU57JCgiBWiJ9J5HDzu9E+Dc1MnvPi/4MYNjQsda/g75cCsJymPTJFpPHacMFC3Dai2fL2aFogiaeb/EPiGmL5vqgl6A5qO9ZPSUKB026gbfrxne801VamH3KQBZPMFlB+z+D7s8r+j9/A7Rx8jJrt53LLzgL7FSiZeNGE5bjcFrxlIxvQKJ2U9zCpYq8+kbVo/ZEi8fQO2bC28gSftwHNdltYTTcFmtT1pUTW9duDv4OEcCqMS8KiJDcpBEFbIU94ZlaGqnw/XH0/JnmC8EgKy3Kfe2qI6m8GKdu+l1qTrvEQX3dgYM63mKPiSEGTCzf+RP35f1NUHpr2I+CBlcDJ3btCI1P8hBvP4kujCvvBLsBRGWyovrzRLhs8apeA2a7ZoSYeC0JrFM5TO49SsZTGkTHT7DCO4lWpK2FN/eYN8La8CvjL24CXpo66y2dzJDuN72LoV2Ic/j8OtQk1HirPRANJ7T7KuDN4KIK4WC5Noa7zT6MKmQ5X1pdluVQg0YXoCiampKK9Hilx88ZHfUmOj5mqe4rfEOt8
 BWMNL+0J
 KsO5BRnG6oFLXOv4N24wG4/V5NRQGEPuWPp975PMgf+FNpbF5/L7738kwMvPt6ytHCVk+mXjtDQ8C+UjnE7flm8Q+oc7APaEXhAspMFQ4DsHrThGN7xwH/RQp0JmTFbCf1ARhwRFHfNYVitc1Meu0Kx7FyPt1udhuEF+XMTStKSskR4SAmtxIcXlMyz+53hJVHla7XQ/mhYlmhKFYI1ZjjIiTP8f//X5miaVFARgYu1BEeTixkE2Fh+J21A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A tracer can clear the signal mask of an io-wq worker or an SQPOLL
thread with PTRACE_SETSIGMASK and inject a coredump signal. The worker
then runs vfs_coredump() itself. Cover that:

- a child keeps a ring, an idle io-wq worker and with SQPOLL the SQPOLL
  thread alive

- seize the chosen thread, stop it with SIGSTOP, clear its mask and
  detach with SIGSEGV

- require the thread group to be gone in bounded time, by the dump or
  by SIGKILL

The io-wq worker of an SQPOLL ring fails: the SQPOLL thread waits for
its workers to exit before it parks, the dumping worker waits for the
SQPOLL thread to park and the group is stuck in D state.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/coredump/.gitignore        |   1 +
 tools/testing/selftests/coredump/Makefile          |   4 +-
 .../selftests/coredump/coredump_worker_test.c      | 427 +++++++++++++++++++++
 3 files changed, 431 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/coredump/.gitignore b/tools/testing/selftests/coredump/.gitignore
index c198f2ca5872..e32f6e9006f6 100644
--- a/tools/testing/selftests/coredump/.gitignore
+++ b/tools/testing/selftests/coredump/.gitignore
@@ -3,3 +3,4 @@ stackdump_test
 coredump_socket_test
 coredump_socket_protocol_test
 coredump_signal_test
+coredump_worker_test
diff --git a/tools/testing/selftests/coredump/Makefile b/tools/testing/selftests/coredump/Makefile
index d6cd9a7e9ac0..57ec331f03a7 100644
--- a/tools/testing/selftests/coredump/Makefile
+++ b/tools/testing/selftests/coredump/Makefile
@@ -4,7 +4,8 @@ CFLAGS += -Wall -O0 -g $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
 TEST_GEN_PROGS := stackdump_test \
 		  coredump_socket_test \
 		  coredump_socket_protocol_test \
-		  coredump_signal_test
+		  coredump_signal_test \
+		  coredump_worker_test
 TEST_FILES := stackdump
 
 include ../lib.mk
@@ -13,3 +14,4 @@ $(OUTPUT)/stackdump_test: coredump_test_helpers.c
 $(OUTPUT)/coredump_socket_test: coredump_test_helpers.c
 $(OUTPUT)/coredump_socket_protocol_test: coredump_test_helpers.c
 $(OUTPUT)/coredump_signal_test: coredump_test_helpers.c
+$(OUTPUT)/coredump_worker_test: coredump_test_helpers.c
diff --git a/tools/testing/selftests/coredump/coredump_worker_test.c b/tools/testing/selftests/coredump/coredump_worker_test.c
new file mode 100644
index 000000000000..81cadde0e752
--- /dev/null
+++ b/tools/testing/selftests/coredump/coredump_worker_test.c
@@ -0,0 +1,427 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * A user worker as the coredumping thread.
+ *
+ * io-wq workers and SQPOLL threads are threads of the process that never
+ * return to userspace. They block every signal but SIGKILL and SIGSTOP,
+ * but a tracer can replace that mask with PTRACE_SETSIGMASK and inject a
+ * coredump signal. get_signal() then runs vfs_coredump() in the worker.
+ * The worker's own exit bookkeeping runs only after the dump, so a
+ * zapped sibling that waits for it in its exit path deadlocks with the
+ * dumper and the whole thread group is stuck in D state.
+ *
+ * Inject SIGSEGV into a chosen thread and require that the thread group
+ * is gone in bounded time, either because the dump completed or because
+ * SIGKILL still works. A failure leaves the stuck process behind.
+ */
+#include <ctype.h>
+#include <dirent.h>
+#include <fcntl.h>
+#include <sys/mman.h>
+#include <sys/ptrace.h>
+#include <sys/resource.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/wait.h>
+#include <unistd.h>
+#include <linux/io_uring.h>
+
+#include "coredump_test.h"
+
+#ifndef PTRACE_SETSIGMASK
+#define PTRACE_SETSIGMASK 0x420b
+#endif
+
+/* The dump of the tiny child takes well under a second. */
+#define EXIT_TIMEOUT_MS 5000
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
+	int ret;
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
+/* A raw ring, no liburing. */
+struct uring {
+	int fd;
+	struct io_uring_params params;
+	void *sq;
+	size_t sq_len;
+	struct io_uring_sqe *sqes;
+	size_t sqes_len;
+	unsigned int *sq_tail, *sq_mask, *sq_array;
+	unsigned int *cq_head, *cq_tail, *cq_mask;
+	struct io_uring_cqe *cqes;
+};
+
+static int uring_setup(struct uring *r, unsigned int flags)
+{
+	size_t cq_len;
+
+	memset(r, 0, sizeof(*r));
+	r->params.flags = flags;
+	if (flags & IORING_SETUP_SQPOLL)
+		r->params.sq_thread_idle = 2000;
+	r->fd = syscall(__NR_io_uring_setup, 8, &r->params);
+	if (r->fd < 0)
+		return -1;
+	if (!(r->params.features & IORING_FEAT_SINGLE_MMAP))
+		return -1;
+
+	r->sq_len = r->params.sq_off.array + r->params.sq_entries * sizeof(unsigned int);
+	cq_len = r->params.cq_off.cqes + r->params.cq_entries * sizeof(struct io_uring_cqe);
+	if (cq_len > r->sq_len)
+		r->sq_len = cq_len;
+	r->sq = mmap(NULL, r->sq_len, PROT_READ | PROT_WRITE,
+		     MAP_SHARED | MAP_POPULATE, r->fd, IORING_OFF_SQ_RING);
+	if (r->sq == MAP_FAILED)
+		return -1;
+	r->sqes_len = r->params.sq_entries * sizeof(struct io_uring_sqe);
+	r->sqes = mmap(NULL, r->sqes_len, PROT_READ | PROT_WRITE,
+		       MAP_SHARED | MAP_POPULATE, r->fd, IORING_OFF_SQES);
+	if (r->sqes == MAP_FAILED)
+		return -1;
+
+	r->sq_tail = r->sq + r->params.sq_off.tail;
+	r->sq_mask = r->sq + r->params.sq_off.ring_mask;
+	r->sq_array = r->sq + r->params.sq_off.array;
+	r->cq_head = r->sq + r->params.cq_off.head;
+	r->cq_tail = r->sq + r->params.cq_off.tail;
+	r->cq_mask = r->sq + r->params.cq_off.ring_mask;
+	r->cqes = r->sq + r->params.cq_off.cqes;
+	return 0;
+}
+
+/* Submit one sqe, wait for its completion and return the result. */
+static int uring_submit_wait(struct uring *r, const struct io_uring_sqe *sqe)
+{
+	unsigned int tail = *r->sq_tail, idx = tail & *r->sq_mask;
+	unsigned int flags = IORING_ENTER_GETEVENTS;
+	int i;
+
+	r->sqes[idx] = *sqe;
+	r->sq_array[idx] = idx;
+	__atomic_store_n(r->sq_tail, tail + 1, __ATOMIC_RELEASE);
+
+	if (r->params.flags & IORING_SETUP_SQPOLL)
+		flags |= IORING_ENTER_SQ_WAKEUP;
+
+	for (i = 0; i < 100; i++) {
+		if (syscall(__NR_io_uring_enter, r->fd, 1, 1, flags, NULL, 0) < 0 &&
+		    errno != EINTR)
+			return -1;
+		if (__atomic_load_n(r->cq_tail, __ATOMIC_ACQUIRE) != *r->cq_head) {
+			unsigned int head = *r->cq_head;
+			int res = r->cqes[head & *r->cq_mask].res;
+
+			__atomic_store_n(r->cq_head, head + 1, __ATOMIC_RELEASE);
+			return res;
+		}
+		flags &= ~IORING_ENTER_SQ_WAKEUP;
+		usleep(10 * 1000);
+	}
+	return -1;
+}
+
+static bool uring_available(unsigned int flags)
+{
+	struct io_uring_params params = { .flags = flags };
+	int fd;
+
+	fd = syscall(__NR_io_uring_setup, 2, &params);
+	if (fd < 0)
+		return false;
+	close(fd);
+	return true;
+}
+
+/*
+ * Keep a ring, an idle io-wq worker and with SQPOLL an SQPOLL thread
+ * alive. The last worker of a ring never exits on its idle timeout.
+ */
+static void worker_child(bool sqpoll, int fd_ipc)
+{
+	struct rlimit rl = { RLIM_INFINITY, RLIM_INFINITY };
+	struct io_uring_sqe sqe = {};
+	static char buf[64];
+	struct uring ring;
+	int memfd;
+
+	if (setrlimit(RLIMIT_CORE, &rl))
+		_exit(EXIT_FAILURE);
+
+	memfd = memfd_create("coredump_worker", 0);
+	if (memfd < 0 || write(memfd, "hello", 5) != 5)
+		_exit(EXIT_FAILURE);
+
+	if (uring_setup(&ring, sqpoll ? IORING_SETUP_SQPOLL : 0))
+		_exit(EXIT_FAILURE);
+
+	/* IOSQE_ASYNC forces the read through io-wq so a worker appears. */
+	sqe.opcode = IORING_OP_READ;
+	sqe.fd = memfd;
+	sqe.addr = (__u64)(uintptr_t)buf;
+	sqe.len = sizeof(buf);
+	sqe.flags = IOSQE_ASYNC;
+	if (uring_submit_wait(&ring, &sqe) != 5)
+		_exit(EXIT_FAILURE);
+
+	if (write_nointr(fd_ipc, "1", 1) != 1)
+		_exit(EXIT_FAILURE);
+	close(fd_ipc);
+
+	for (;;)
+		pause();
+}
+
+/* Find the thread of @pid whose comm starts with @prefix. */
+static pid_t find_thread(pid_t pid, const char *prefix)
+{
+	char path[64], comm[64];
+	pid_t tid = -1;
+	struct dirent *de;
+	ssize_t bytes;
+	DIR *dir;
+	int fd;
+
+	snprintf(path, sizeof(path), "/proc/%d/task", pid);
+	dir = opendir(path);
+	if (!dir)
+		return -1;
+
+	while (tid < 0 && (de = readdir(dir))) {
+		if (!isdigit(de->d_name[0]))
+			continue;
+		snprintf(path, sizeof(path), "/proc/%d/task/%s/comm", pid, de->d_name);
+		fd = open(path, O_RDONLY | O_CLOEXEC);
+		if (fd < 0)
+			continue;
+		bytes = read(fd, comm, sizeof(comm) - 1);
+		close(fd);
+		if (bytes <= 0)
+			continue;
+		comm[bytes] = '\0';
+		if (!strncmp(comm, prefix, strlen(prefix)))
+			tid = atoi(de->d_name);
+	}
+	closedir(dir);
+	return tid;
+}
+
+/*
+ * Attach, stop the thread with SIGSTOP, drop the signal mask that
+ * copy_process() gave it and resume it with SIGSEGV instead.
+ */
+static bool inject_coredump_signal(pid_t pid, pid_t tid)
+{
+	__u64 mask = 0;
+	int status;
+
+	if (ptrace(PTRACE_SEIZE, tid, NULL, NULL))
+		return false;
+	if (syscall(SYS_tgkill, pid, tid, SIGSTOP))
+		return false;
+	if (waitpid(tid, &status, __WALL) != tid)
+		return false;
+	if (!WIFSTOPPED(status) || WSTOPSIG(status) != SIGSTOP)
+		return false;
+	if (ptrace(PTRACE_SETSIGMASK, tid, sizeof(mask), &mask))
+		return false;
+	return !ptrace(PTRACE_DETACH, tid, NULL, (void *)(long)SIGSEGV);
+}
+
+/* Reap @pid within @timeout_ms, -1 when it is still there. */
+static int wait_exit(pid_t pid, int *status, int timeout_ms)
+{
+	int i;
+
+	for (i = 0; i < timeout_ms / 10; i++) {
+		pid_t ret = waitpid(pid, status, WNOHANG);
+
+		if (ret == pid)
+			return 0;
+		if (ret < 0)
+			return -1;
+		usleep(10 * 1000);
+	}
+	return -1;
+}
+
+static void log_threads(struct __test_metadata *const _metadata, pid_t pid)
+{
+	char path[64], line[256], comm[64] = {};
+	struct dirent *de;
+	DIR *dir;
+	FILE *f;
+
+	snprintf(path, sizeof(path), "/proc/%d/task", pid);
+	dir = opendir(path);
+	if (!dir)
+		return;
+	while ((de = readdir(dir))) {
+		if (!isdigit(de->d_name[0]))
+			continue;
+		snprintf(path, sizeof(path), "/proc/%d/task/%s/status", pid, de->d_name);
+		f = fopen(path, "r");
+		if (!f)
+			continue;
+		while (fgets(line, sizeof(line), f)) {
+			line[strcspn(line, "\n")] = '\0';
+			if (!strncmp(line, "Name:", 5))
+				snprintf(comm, sizeof(comm), "%s", line + 6);
+			else if (!strncmp(line, "State:", 6))
+				TH_LOG("tid %s (%s) %s", de->d_name, comm, line + 7);
+		}
+		fclose(f);
+	}
+	closedir(dir);
+}
+
+enum dumper {
+	DUMPER_MAIN,
+	DUMPER_WORKER,
+	DUMPER_SQPOLL,
+};
+
+static void run_dumper(struct __test_metadata *const _metadata, bool sqpoll,
+		       enum dumper dumper)
+{
+	bool killed = false;
+	char path[64], c;
+	int ipc[2], status, fd;
+	pid_t pid, tid;
+
+	ASSERT_TRUE(set_core_pattern("/tmp/coredump.file.%p"));
+	ASSERT_EQ(pipe2(ipc, O_CLOEXEC), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		close(ipc[0]);
+		worker_child(sqpoll, ipc[1]);
+	}
+	close(ipc[1]);
+	ASSERT_EQ(read_nointr(ipc[0], &c, 1), 1);
+	close(ipc[0]);
+
+	switch (dumper) {
+	case DUMPER_MAIN:
+		tid = pid;
+		break;
+	case DUMPER_WORKER:
+		tid = find_thread(pid, "iou-wrk-");
+		break;
+	case DUMPER_SQPOLL:
+		tid = find_thread(pid, "iou-sqp-");
+		break;
+	}
+	ASSERT_GT(tid, 0);
+	ASSERT_TRUE(inject_coredump_signal(pid, tid));
+
+	if (wait_exit(pid, &status, EXIT_TIMEOUT_MS)) {
+		/* No dump. Whatever happened, SIGKILL must still work. */
+		log_threads(_metadata, pid);
+		kill(pid, SIGKILL);
+		killed = true;
+		ASSERT_EQ(wait_exit(pid, &status, EXIT_TIMEOUT_MS), 0) {
+			TH_LOG("thread group %d is stuck after SIGSEGV to tid %d",
+			       pid, tid);
+		}
+	}
+
+	ASSERT_TRUE(WIFSIGNALED(status));
+	if (killed) {
+		TH_LOG("tid %d did not dump, the group was killed instead", tid);
+		ASSERT_EQ(WTERMSIG(status), SIGKILL);
+		return;
+	}
+	ASSERT_EQ(WTERMSIG(status), SIGSEGV);
+	ASSERT_TRUE(WCOREDUMP(status));
+
+	snprintf(path, sizeof(path), "/tmp/coredump.file.%d", pid);
+	fd = open(path, O_RDONLY | O_CLOEXEC);
+	unlink(path);
+	ASSERT_GE(fd, 0);
+	ASSERT_TRUE(check_coredump_extent(fd));
+	close(fd);
+}
+
+/* The mechanics: an injected SIGSEGV into a normal thread dumps core. */
+TEST_F(coredump, main_thread_dumper)
+{
+	if (!uring_available(0))
+		SKIP(return, "io_uring is not available");
+	run_dumper(_metadata, false, DUMPER_MAIN);
+}
+
+TEST_F(coredump, plain_worker_dumper)
+{
+	if (!uring_available(0))
+		SKIP(return, "io_uring is not available");
+	run_dumper(_metadata, false, DUMPER_WORKER);
+}
+
+TEST_F(coredump, sqpoll_thread_dumper)
+{
+	if (!uring_available(IORING_SETUP_SQPOLL))
+		SKIP(return, "io_uring SQPOLL is not available");
+	run_dumper(_metadata, true, DUMPER_SQPOLL);
+}
+
+/*
+ * The SQPOLL thread leaves its loop on the zap and waits for its io-wq
+ * workers to exit before it parks. The dumping worker never does.
+ */
+TEST_F(coredump, sqpoll_worker_dumper)
+{
+	if (!uring_available(IORING_SETUP_SQPOLL))
+		SKIP(return, "io_uring SQPOLL is not available");
+	run_dumper(_metadata, true, DUMPER_WORKER);
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0


