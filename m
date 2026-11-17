Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 973F8606A339
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PzkrUsoz
Received: by kanga.kvack.org (Postfix)
	id D83646B05C2; Tue, 17 Nov 2026 11:17:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D34226B05BB; Tue, 17 Nov 2026 11:17:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9B876B05C1; Tue, 17 Nov 2026 11:17:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8876B05BB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:17:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F190380523
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:25 +0000 (UTC)
X-FDA: 85445116050.11.DD98911
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id 66B311C0005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=PzkrUsoz;
	spf=pass (imf20.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932244;
	b=dzeN6m22/OY8jm3ISJSouqg+OJf2DlSIx7sDovAbqLL6FUmjQAlwCzzToGxwWmwv98hpXr
	w5BrZxZ7lDcJHweVR+uRSRP2IEiQcIj3Hx6skvmg57azy/hC7JsmYUgUgyfN7sxZgPRY3v
	pAiNscELpBZixYZ3L1z1vFAPxavy/WU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GxH5z0G5yROybZJpqVlzWquPDPjWyRyfwbPD4i1MLtc=;
	b=vMDarKB7AALsCDIMjpvaGEA6SYppeCo1MvyFVD4sChhIJPzIv8OJqcwA7fUDAKXXdZVB18
	mQr8Ojx+kh2JITRDEP/CxZwb9KWquZjPnJP/vmMSHad5d31qrU2j4MWiJeB2LiL7l3qtYj
	c/DNMF4LaavtocTeLzTqrycedpdJLdo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=PzkrUsoz;
	spf=pass (imf20.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794932242;
	bh=GxH5z0G5yROybZJpqVlzWquPDPjWyRyfwbPD4i1MLtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzkrUsozHGIwgODINxTGvh5HExn119z9otQOfZ98T5Wh0WL1L4eXM8IJCciwBZYdh
	 YnUjjF5gWrHYaQhVfulaSsd+AsTXgrbj+il7wuLFzG4U5LuWhciIEpFknYTkOPdkKV
	 BC2U7UnNDO/fb5rxRtplDY3k+iwX2dh4rHligGqhLWpnrdqr/LfGDcl9YtiMFXVBgM
	 fIfAKqKFK2U/B5kF5nQP7gSM/BcfvpM79uf8oYWJKoedDkI8TECXTbaYqYkxIiftab
	 TCXYF/F7QcyBPYvGWK9Hwkl8m4WKpeqxCl1FRuS37+C2L5tsBkCEd9tscaQIV5qliu
	 z2K+Ng7eCyj/g==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTVHk4QMzzRms;
	Tue, 17 Nov 2026 11:17:22 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: tglx@kernel.org,
	peterz@infradead.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	paulmck@kernel.org,
	boqun@kernel.org,
	shuah@kernel.org,
	kees@kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	oleg@redhat.com,
	bestswngs@gmail.com,
	xmei5@asu.edu,
	xujiakai24@mails.ucas.ac.cn,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 07/17] selftests/rseq: Test the concurrency ID after a failed execve
Date: Tue, 17 Nov 2026 11:17:07 -0500
Message-Id: <f40b86d70fc4537592a71be725ad03aa3dae7b4e.1794932121.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 66B311C0005
X-Rspam-User:
X-Stat-Signature: mx1nxuezmfr5qdxh6sus8qu8pkg5qain
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794932244-798457
X-HE-Meta: U2FsdGVkX185UUzOJB4fHRRh5vMu7t62fZ4svddonmVreR1Zr+1hQeloH1uYfWd3U5san0YkcQoa4HNSK9KIugWtf0ULLTihPQE4arnw65gqmAByqEMHYou6Vzi+26ROOJSm03mLx/j5S8nESqmK095t0dbCZ+rw6bpi2USkNUkBCYz3528Z1JqV++OoSNMDNTcvBfcM02dilw5SCU9wU+A6KHSTMy9uFwj8N43mzA4KOi+dgM+SBGk1Z46iddtpMqB9x2j6jEiVU/v0F87p7IQJzIbR+J65B2ANC+fG3bv8W2rc5CGwBGblvWUoI4KNzOFjWb9D40qwV7wFlhWSEJBcnBErnIl+NOmbDNMsDFMs2/CanxrajXuoj5sfwkI1ElJzYQMfAH6rnN6vnKrjmveQmYDXJfnGR+B2CDHJwx2Vt4p/cR/wHKCfNMmBaSqjxOjbfrDbBnDBT0G01OBrS7sSWiNxh/hN2alOM05nwROjbtvBR6GA1Uu09aSa1oe687TPzGhxZKahgUGq7Ttc+GyrLZo1lKo2syKQXzA3Nq0/Edv+/LcNCwi0+ESfdSXgg4g02mCkIVvOuDFF93VrY+y7Lp3Qzw9MQHzg6fopncXevK9b05ifvN7uybkYD3V+oTy2x0jfVAtXgouZG0Ku4VTzR1tPT85sFPRbbooB2uhNNS0WI4O/MEKuENjw4DCt/9pYpfPsh7Id+FiuVukiypMr0AcZ7gVTOd4nC6MLwf3DRRuFzPSSx2HdDGXk7JLvLpeG3KetSYxmFvBAG80vrXACSZRDwenP65x2OteWiRm3wiYps5znOt5n7kP7D1FiDq9wIYmRuJPaHXoZVybHGEhSUToElKYDVOzxgVvVHbbhGTtHh1KSjvpZn8VgKqwEYkGeKhA75l12103GTbI6B+DM/xyENHvaViiAAcLjQMHW4kg0zxD5SlsxIF8ibPv/QH34CvblbbxXCpkAR52
 BX7vl4Wq
 1ynt3TekKLQjt0SDbwCWsaPIfQSg/1rHIjq4G5v+T9UOvB+0fGVgjRRejrUutUwg+S60ke1miUauNxQQLPdlK3hQkVkyak56Qw1x+jCYJA2jjz2zYesxENmp5GKWBKTCv/pkDLKSLccfIQMnIi6whnMbNFyoDOPnrssTMreHgf1rLpoOt3D4D7Myb7lXj0DvRynFv0aghCvzSQxXyEKSbkIq5m4O9wGW+3tOozKT+LvO9b2LCQ8ky9Qi70JvoXBsXKTujWhoM4AyyZ1m/iee09FF4vwNWtGTBiYGA7MeiHsDBQPbA1J9Zpx/HTmhXJkxXi49mjiX1O6uLtnWVAutjz8PNAGKKQ3YzUTINFhoL14nyuMRbStRcpUm89IErapjbzmy17P8hyH9FFlNDZSDRGOkplcvqGmBov68zOX/YEQgGzRzju56D02SFliRrOAL6Plz9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A failed execve() leaves its mm and rejoins it while the task is
running. If the other threads are still alive, the mm can be in per CPU
mode. There a new user gets no CID at the join, so the task would
return to user space with MM_CID_UNSET.

Add mm_cid_execve_test. A process with more threads than CIDs calls
execve() on a file that no binfmt handler recognises. That fails with
ENOEXEC before the other threads are killed. The process reads its
mm_cid after each call. The value must stay below the number of CPUs
the process is allowed on.

Per CPU mode needs more threads than the mm has CIDs. The number of
CIDs follows the union of the allowed CPUs of the threads, which only
grows. The test therefore narrows its affinity before the fork() that
creates the process under test. Five threads on two CPUs are then
enough on any machine.

Without "sched/mmcid: Give a CID to a task that joins its mm while
running", on a kernel with 8 possible CPUs:

  mm_cid 2147483648 (0x80000000) after a failed execve, round 0 of 100
  not ok 1 mm_cid after a failed execve

With it:

  5 threads, 100 failed execve, largest mm_cid 0, below 2
  ok 1 mm_cid after a failed execve

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 tools/testing/selftests/rseq/.gitignore       |   1 +
 tools/testing/selftests/rseq/Makefile         |   3 +-
 .../selftests/rseq/mm_cid_execve_test.c       | 276 ++++++++++++++++++
 3 files changed, 279 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/rseq/mm_cid_execve_test.c

diff --git a/tools/testing/selftests/rseq/.gitignore b/tools/testing/selftests/rseq/.gitignore
index 9b6eb6c3922f..1d94aaf15f4e 100644
--- a/tools/testing/selftests/rseq/.gitignore
+++ b/tools/testing/selftests/rseq/.gitignore
@@ -9,6 +9,7 @@ param_test_compare_twice
 param_test_mm_cid
 param_test_mm_cid_benchmark
 param_test_mm_cid_compare_twice
+mm_cid_execve_test
 syscall_errors_test
 slice_test
 legacy_check
diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
index aba6317f6cb8..ee40f80c079c 100644
--- a/tools/testing/selftests/rseq/Makefile
+++ b/tools/testing/selftests/rseq/Makefile
@@ -19,7 +19,8 @@ LDLIBS += -lpthread -ldl
 OVERRIDE_TARGETS = 1
 
 TEST_GEN_PROGS = basic_test basic_percpu_ops_test basic_percpu_ops_mm_cid_test \
-		 param_test_benchmark param_test_mm_cid_benchmark
+		 param_test_benchmark param_test_mm_cid_benchmark \
+		 mm_cid_execve_test
 
 TEST_GEN_PROGS_EXTENDED = librseq.so \
 	param_test \
diff --git a/tools/testing/selftests/rseq/mm_cid_execve_test.c b/tools/testing/selftests/rseq/mm_cid_execve_test.c
new file mode 100644
index 000000000000..3d8b9365ce91
--- /dev/null
+++ b/tools/testing/selftests/rseq/mm_cid_execve_test.c
@@ -0,0 +1,276 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * The concurrency ID a thread reports after a failed execve(2).
+ *
+ * sched_mm_cid_fork() makes a task a user of the CIDs of its mm. In per
+ * CPU mode a new user gets no CID there. It takes the CID of its CPU when
+ * it is scheduled in. A failed execve(2) rejoins its mm while the task is
+ * running and the other threads are still users. The task returns to user
+ * space before any schedule in, so the join has to give it a CID.
+ *
+ * Per CPU mode needs more threads than the mm has CIDs. The number of CIDs
+ * follows the union of the allowed CPUs of the threads, which only grows.
+ * The affinity is therefore narrowed before the fork(2) that creates the
+ * process under test. A few threads are then enough on any machine.
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <limits.h>
+#include <pthread.h>
+#include <sched.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "rseq.h"
+#include "kselftest.h"
+
+#define NARROW_CPUS	2
+#define THREADS		4
+#define ROUNDS		100
+
+/* Exit status of the process under test. */
+#define CHILD_PASS	0
+#define CHILD_FAIL	1
+#define CHILD_SKIP	2
+#define CHILD_ERROR	3
+
+static int stop;
+
+/*
+ * Stay alive as a user of the CIDs of the mm while the execve(2) below
+ * leaves the mm and rejoins it. A thread needs no rseq area for that.
+ */
+static void *waiter(void *arg)
+{
+	while (!RSEQ_READ_ONCE(stop))
+		(void)sched_yield();
+	return NULL;
+}
+
+/* Join @t. Return 0, or the error number after reporting it. */
+static int join_thread(pthread_t t)
+{
+	int err = pthread_join(t, NULL);
+
+	if (err)
+		fprintf(stderr, "pthread_join: %s\n", strerror(err));
+	return err;
+}
+
+/* Remove @path. Return 0, or -1 after reporting the error. */
+static int remove_file(const char *path)
+{
+	if (unlink(path)) {
+		fprintf(stderr, "unlink %s: %s\n", path, strerror(errno));
+		return -1;
+	}
+	return 0;
+}
+
+/* The directory of the test's executable, "." when it cannot be read. */
+static const char *test_dir(char *buf, size_t len)
+{
+	ssize_t n = readlink("/proc/self/exe", buf, len - 1);
+	char *slash;
+
+	if (n <= 0)
+		return ".";
+	buf[n] = '\0';
+	slash = strrchr(buf, '/');
+	if (!slash)
+		return ".";
+	*slash = '\0';
+	return slash == buf ? "/" : buf;
+}
+
+/*
+ * Create a file that no binfmt handler recognises and leave its path in
+ * @path. execve(2) on it reaches sched_mm_cid_before_execve(). It then
+ * fails with ENOEXEC before begin_new_exec() kills the other threads. A
+ * path that does not exist would fail before bprm_execve().
+ *
+ * The directory must allow execution. Try the directory of the test first,
+ * then /tmp. Return 0 on success. One execve(2) is done as a check.
+ */
+static int make_unknown_format_file(char *path, size_t len)
+{
+	char self[PATH_MAX];
+	const char *const dirs[] = { test_dir(self, sizeof(self)), "/tmp" };
+	static const char junk[] = "not a binary of any known format\n";
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(dirs); i++) {
+		char *const av[] = { path, NULL };
+		bool written;
+		int fd;
+
+		snprintf(path, len, "%s/mm_cid_execve_test.XXXXXX", dirs[i]);
+		fd = mkstemp(path);
+		if (fd < 0)
+			continue;
+		written = write(fd, junk, sizeof(junk) - 1) == (ssize_t)sizeof(junk) - 1 &&
+			  !fchmod(fd, 0755);
+		/* An open file would make execve(2) fail with ETXTBSY. */
+		if (close(fd) || !written) {
+			remove_file(path);
+			continue;
+		}
+		if (execve(path, av, NULL) == -1 && errno == ENOEXEC)
+			return 0;
+		remove_file(path);
+	}
+	return -1;
+}
+
+/*
+ * The process under test. Start THREADS threads on a narrow set of CPUs.
+ * Then fail execve(2) in a loop and read the mm_cid after each call.
+ * Return a CHILD_* status.
+ */
+static int run_child(void)
+{
+	pthread_t thread[THREADS];
+	char path[PATH_MAX];
+	unsigned int nr_cids, worst = 0;
+	cpu_set_t mask;
+	int i, err = 0, started = 0, ret = CHILD_PASS;
+
+	/* The mm has no more IDs than CPUs its threads may run on. */
+	if (sched_getaffinity(0, sizeof(mask), &mask)) {
+		fprintf(stderr, "sched_getaffinity: %s\n", strerror(errno));
+		return CHILD_ERROR;
+	}
+	nr_cids = CPU_COUNT(&mask);
+
+	if (make_unknown_format_file(path, sizeof(path))) {
+		fprintf(stderr, "no directory to run an unknown format file from: %s\n",
+			strerror(errno));
+		return CHILD_SKIP;
+	}
+
+	for (i = 0; i < THREADS; i++) {
+		err = pthread_create(&thread[i], NULL, waiter, NULL);
+		if (err)
+			break;
+		started++;
+	}
+	if (started < THREADS) {
+		fprintf(stderr, "pthread_create: %s\n", strerror(err));
+		ret = CHILD_ERROR;
+		goto out;
+	}
+
+	for (i = 0; i < ROUNDS; i++) {
+		char *const av[] = { path, NULL };
+		unsigned int cid;
+
+		if (!execve(path, av, NULL)) {
+			fprintf(stderr, "execve(%s) succeeded, expected ENOEXEC\n", path);
+			ret = CHILD_ERROR;
+			goto out;
+		}
+		if (errno != ENOEXEC) {
+			fprintf(stderr, "execve(%s): %s, expected ENOEXEC\n",
+				path, strerror(errno));
+			ret = CHILD_ERROR;
+			goto out;
+		}
+		cid = rseq_current_mm_cid();
+		if (cid > worst)
+			worst = cid;
+		if (cid >= nr_cids) {
+			fprintf(stderr, "mm_cid %u (0x%x) after a failed execve, round %d of %d\n",
+				cid, cid, i, ROUNDS);
+			ret = CHILD_FAIL;
+			goto out;
+		}
+	}
+	fprintf(stderr, "%d threads, %d failed execve, largest mm_cid %u, below %u\n",
+		started + 1, ROUNDS, worst, nr_cids);
+out:
+	RSEQ_WRITE_ONCE(stop, 1);
+	for (i = 0; i < started; i++) {
+		if (join_thread(thread[i]) && ret == CHILD_PASS)
+			ret = CHILD_ERROR;
+	}
+	if (remove_file(path) && ret == CHILD_PASS)
+		ret = CHILD_ERROR;
+	return ret;
+}
+
+/* Keep the first @nr CPUs of @src in @dst. */
+static int narrow_cpus(cpu_set_t *dst, const cpu_set_t *src, int nr)
+{
+	int cpu, taken = 0;
+
+	CPU_ZERO(dst);
+	for (cpu = 0; cpu < CPU_SETSIZE && taken < nr; cpu++) {
+		if (!CPU_ISSET(cpu, src))
+			continue;
+		CPU_SET(cpu, dst);
+		taken++;
+	}
+	return taken;
+}
+
+int main(void)
+{
+	cpu_set_t allowed, narrow;
+	int status = 0;
+	pid_t child;
+
+	ksft_print_header();
+	ksft_set_plan(1);
+
+	if (!rseq_available())
+		ksft_exit_skip("rseq is unavailable\n");
+	/* glibc before 2.35 registers no rseq area. */
+	if (rseq_register_current_thread())
+		ksft_exit_fail_msg("rseq_register_current_thread: %s\n", strerror(errno));
+	if (!rseq_mm_cid_available())
+		ksft_exit_skip("the rseq mm_cid field is unavailable\n");
+	if (sched_getaffinity(0, sizeof(allowed), &allowed))
+		ksft_exit_fail_msg("sched_getaffinity: %s\n", strerror(errno));
+	if (!narrow_cpus(&narrow, &allowed, NARROW_CPUS))
+		ksft_exit_skip("no CPU to run on\n");
+
+	/*
+	 * Narrow before the fork(2). The mm of the child starts with these
+	 * allowed CPUs, and a later narrowing does not shrink them.
+	 */
+	if (sched_setaffinity(0, sizeof(narrow), &narrow))
+		ksft_exit_skip("sched_setaffinity: %s\n", strerror(errno));
+	child = fork();
+	if (!child)
+		_exit(run_child());
+	if (child < 0)
+		ksft_exit_fail_msg("fork: %s\n", strerror(errno));
+	if (sched_setaffinity(0, sizeof(allowed), &allowed))
+		ksft_exit_fail_msg("sched_setaffinity: %s\n", strerror(errno));
+	if (waitpid(child, &status, 0) != child)
+		ksft_exit_fail_msg("waitpid: %s\n", strerror(errno));
+	if (!WIFEXITED(status))
+		ksft_exit_fail_msg("the process under test was killed by signal %d\n",
+				   WTERMSIG(status));
+
+	switch (WEXITSTATUS(status)) {
+	case CHILD_PASS:
+		ksft_test_result_pass("mm_cid after a failed execve\n");
+		break;
+	case CHILD_SKIP:
+		ksft_test_result_skip("mm_cid after a failed execve\n");
+		break;
+	case CHILD_FAIL:
+		ksft_test_result_fail("mm_cid after a failed execve\n");
+		break;
+	default:
+		ksft_exit_fail_msg("the process under test failed to run\n");
+	}
+	ksft_finished();
+}
-- 
2.47.3


