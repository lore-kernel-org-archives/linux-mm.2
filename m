Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE95A606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Ld6kYFGN
Received: by kanga.kvack.org (Postfix)
	id CFDF66B05C9; Tue, 17 Nov 2026 11:17:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBEE76B05CC; Tue, 17 Nov 2026 11:17:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEA866B05CA; Tue, 17 Nov 2026 11:17:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE4C6B05C7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:17:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E0CA1C3CF8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:28 +0000 (UTC)
X-FDA: 85445116176.19.F47DC66
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7CAA114000F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=Ld6kYFGN;
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932246;
	b=JMe90MD2XcedvjqF4ry6iyfLo7/RSvd3m0LmG4PfQQ0xs4EPaHSwBsBaaMiac086zI0KAF
	uZpZzcVIlv3d11DddVpBgCDjClYRKyayvIHYcQNp0fbzZIaI/DgzRl6/l0ZbAnEWoN4+CM
	uzWZAhsxXwWFAXgJWikqMlwDWnkt23A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=Ld6kYFGN;
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMaH7ncXgUaF/SAZyIEJ09F0d1AAXdXj0Fwfw45wOkw=;
	b=52eAfB63pPQhQzmgCva2KrPnGzw1BQ2k+ZTzKWyW/wxUZqVnTmBFy0Yn9+RmtIPp2TG5fs
	6OP8oQG1yMl6KCX6T0mElZPSOXl/PU3PKrlv3B2woM823PS0V9U3c4/eHHptylmdyN9gX0
	DTMKY12fORTew7Nvf46M4JWlTHtak6M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794932244;
	bh=VMaH7ncXgUaF/SAZyIEJ09F0d1AAXdXj0Fwfw45wOkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ld6kYFGN8+9i+Ta9EVeDmC2GfyAhOREeF712IrrqiO3lTzxC6eXf3cw9nW3GqA6NI
	 rsCZefon6yKn1y9b9gFON1Zavzgc7i1q2+ULlexCyFB2iyrgx3Yg0BO4gPO+FXwzej
	 3dKHvpD/QRwtqAAU75rp8Tfpi9lk6VkcT6bRgDZOoqq02Pr7LROXoamlCkIZsfV06T
	 YBSeSV0Q5mlQrloHyA/t2RJNtbpN5PFbZPZC40rjErEUxv5WvY/Zvua0Ggkrk44tkY
	 OL+FCjJecOJeUgGThZLs36opaONu3AYFeLYfbZQDYxhYZxZsQVmrqtbj4zPMwYxQJy
	 OklliLYXiEhVg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTVHm1gcmzQvX;
	Tue, 17 Nov 2026 11:17:24 -0500 (EST)
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
Subject: [PATCH 17/17] selftests/rseq: Test the last user after an affinity change during execve
Date: Tue, 17 Nov 2026 11:17:17 -0500
Message-Id: <860cb09b164607f1be056ef688f5cec80eea3782.1794932121.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7CAA114000F
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6maeapk56qjnt6tdox18yzrowibhw5u5
X-Rspam-User: 
X-HE-Tag: 1794932246-967791
X-HE-Meta: U2FsdGVkX1+E6zqC2HuNMYzd6a8ixXabcXlmcnzlWANYWKpxYcGMsFg2kAsgmjybNb/QksAPw3wngd0ZPdXWPX2nVJFOcC/0mohLNJZoUh+/y/HI8uREUoG7Hct+Qo9rQ03shwEUbbOQNjGSyBw364QZBXRDEV/n3hP3oEyNOlguQVRqOl9c9bqfyV9QX04/a1tKGPiCi4Ri3Ow3gW2gMbaJAncknIYwi0RpIJr4oxheubo5ZAFnUnp++aWXx6T2iDFzZ2MVaRsArvKuyLlGzUzlOKXDSKxjJmzqp7jYAsve/1Epgq8qFe7hPxDuIBwmqr8lr420Y+mBZ4rejRhd+BBpOo2kmA2yidmTMqNW52nggbhlYey11PPF8cWAj+dY1lMXD091bcsZ49OmbDGQrokDCh8ScCivtXgXkoYh8K9whGZOKMxScEZPp68bq+sdu05Yjxo+4KMMamBkncP3xngjWdQC6pFeMwEe7fwL0g0nuc4h6MssQbfX+fxrlJ4M+8jzmHbvw8xE8Nm8QSyiXIiNaDLWnVtFn0vugzJv+B/87738N53hSEyGf+vw2kqqQdWpLmUkqK+COGKnb7nEplehnB6CgteZpOCaqcMGPWH5ZmLj1tRHOA/7ywf0dFTt9dh3xVrnTg74hEHI2SKWsTitYitXDMg13aji5kHnuXzEYXeRYLpNGar6nMhyDiLtnP4D/BkCFZgotjqFwGVXFXep9EIOXDwIWsL2yLAsVRD3Y1EorocJzsNA6P1fEk9xvHQ3WeHnok9mQQXT/t1FDCxhZSi34KwvZOg1qvPipj3KblS/Wr2IMFmB310giV0TCKv+xNaIiVcnuods3Okl3VaN7oPkSauSVYJH2zk+7rgJ9eQlJ5mGkkZ8/Ibqsw1YDE1Mvhblv5sQbdCk1fPucZmE7rEHQ0JF1wEE7kO6S5B9UZLeeK0X3Vs9y29zxfrtvGuWXbKTikDFdQJ2xIp
 F6Lr2wst
 dF8KHGDjPziTGSCrqU6vNSB+r3SrRP5ELVxF4rSPTPz22wSO5erOoTip6SsGdv7VVYcgk0363uQaxDzTygwyJ38QMoW2/JT66E7gubkt9k26r6/MJKbDjbelFl7Lx5/yGyq7tY7iwLCKdJ9K3Say0fi+E6cZJ6y/36ETfc6Qo5Q12TSLPW4fB2BNhjBVDCIaUzcbAiBU8vvE16El4108QHVHHLxzCYsZaRupAf6OFW09O6UlH3nvkzUAz6z4CwS79wLSGP75BmenPH5yMueD0WHSeK43r+YkTZv+qcSGJzKmzz4D4ql7hfs8awQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The last user case of mm_cid_execve_test needs per CPU mode to last down
to one thread. With two allowed CPUs, the kernel only does that with two
or three possible CPUs. The case is skipped on larger machines.

The kernel also keeps per CPU mode down to one thread when the mm counts
one allowed CPU, on any machine. Only one CPU then owns a CID, unless
the thread runs on a CPU that the mm does not count. That happens when
another process changes its affinity during an execve(): the mm has no
user then, and mm_update_cpus_allowed() ignores it.

Add a case that builds this state and then fails execve() as the last
user on one CPU, to rejoin on another. The comment above
run_child_widened() has the sequence as a diagram. The single thread
must read mm_cid 0 on both CPUs at the end.

Without "sched/mmcid: Reset stale state when the first user joins an
mm", on guests with 4, 8 and 64 CPUs:

  single thread, mm_cid 1 on CPU 0 after a move from CPU 1 to CPU 0
  not ok 3 mm_cid of a single thread after its affinity was widened during execve

The thread still reads 1 one second later. With that commit, the case
passes on guests with 2 to 64 CPUs.

The failing kernel also lacked "sched/mmcid: Take the allowed CPUs of
the first user when it joins". That commit records the affinity change
when the task rejoins, so the state is not reached with it. With that
commit and without the reset, the case passes on guests with 2 to 64
CPUs.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../selftests/rseq/mm_cid_execve_test.c       | 235 +++++++++++++++++-
 1 file changed, 232 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/rseq/mm_cid_execve_test.c b/tools/testing/selftests/rseq/mm_cid_execve_test.c
index baf06af574bd..8e357d255747 100644
--- a/tools/testing/selftests/rseq/mm_cid_execve_test.c
+++ b/tools/testing/selftests/rseq/mm_cid_execve_test.c
@@ -17,6 +17,11 @@
  * CPUs. The case is skipped when a single thread reads 0 on both CPUs
  * before the execve(2).
  *
+ * A third case covers the last user on a machine of any size. The kernel
+ * also keeps per CPU mode down to one thread when the mm counts one
+ * allowed CPU. The case makes such a thread run on a second CPU. The
+ * diagram above run_child_widened() has the sequence.
+ *
  * Per CPU mode needs more threads than the mm has CIDs. The number of CIDs
  * follows the union of the allowed CPUs of the threads, which only grows.
  * The affinity is therefore narrowed before the fork(2) that creates the
@@ -33,8 +38,10 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
+#include <time.h>
 #include <unistd.h>
 
 #include "rseq.h"
@@ -357,6 +364,209 @@ static int run_child_moved(int delay_us)
 	return ret;
 }
 
+/* What the process under test and its helper share in run_child_widened(). */
+struct widen_shared {
+	int phase;
+	int widened;
+};
+
+static int widen_cpu[NARROW_CPUS];
+
+static uint64_t now_ms(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+	return (uint64_t)ts.tv_sec * 1000 + ts.tv_nsec / 1000000;
+}
+
+/* Spin until @sh->phase reaches @phase. Return false after two seconds. */
+static bool widen_wait(struct widen_shared *sh, int phase)
+{
+	uint64_t end = now_ms() + 2000;
+
+	while (RSEQ_READ_ONCE(sh->phase) < phase) {
+		if (now_ms() > end)
+			return false;
+	}
+	return true;
+}
+
+/*
+ * The helper of run_child_widened(). @pid is the process under test, which
+ * starts on the CPU @a.
+ * - Phase 1: widen the affinity of @pid to @a and @b, @delay_us after the
+ *   start of its first execve(2) loop.
+ * - Phase 2: keep the CPU @a busy, so that the scheduler moves @pid to @b.
+ * - Phase 3: move @pid back to @a, @delay_us after the start of its second
+ *   execve(2) loop.
+ * Return the exit status of the helper.
+ */
+static int widen_helper(struct widen_shared *sh, pid_t pid, int a, int b, int delay_us)
+{
+	cpu_set_t set;
+
+	/* Run beside the process under test, not on its CPU. */
+	CPU_ZERO(&set);
+	CPU_SET(b, &set);
+	if (sched_setaffinity(0, sizeof(set), &set) || !widen_wait(sh, 1))
+		return 1;
+	usleep(delay_us);
+	CPU_SET(a, &set);
+	if (sched_setaffinity(pid, sizeof(set), &set))
+		return 1;
+	RSEQ_WRITE_ONCE(sh->widened, 1);
+
+	if (!widen_wait(sh, 2))
+		return 1;
+	CPU_ZERO(&set);
+	CPU_SET(a, &set);
+	if (sched_setaffinity(0, sizeof(set), &set) || !widen_wait(sh, 3))
+		return 1;
+	usleep(delay_us);
+	return !!sched_setaffinity(pid, sizeof(set), &set);
+}
+
+/*
+ * Fail execve(2) on @path MOVE_EXECS times. Return 0, or -1 after reporting
+ * an error other than ENOEXEC.
+ */
+static int fail_execs(char *path)
+{
+	int i;
+
+	for (i = 0; i < MOVE_EXECS; i++) {
+		char *const av[] = { path, NULL };
+
+		if (execve(path, av, NULL) == -1 && errno != ENOEXEC) {
+			fprintf(stderr, "execve(%s): %s, expected ENOEXEC\n",
+				path, strerror(errno));
+			return -1;
+		}
+	}
+	return 0;
+}
+
+/*
+ * The third process under test, P. A and B are two CPUs. P starts with A
+ * as its only allowed CPU. H is a helper process. It makes the affinity
+ * changes: a change made by P itself would reach the mm.
+ *
+ *   P                                     H
+ *
+ *   execve() fails, in a loop
+ *     leaves the mm: no user left
+ *                                         sched_setaffinity(P, {A, B})
+ *                                           the mm has no user: its count
+ *                                           of allowed CPUs stays 1
+ *     rejoins the mm
+ *   creates a thread
+ *     the mm switches to per CPU mode
+ *   joins the thread
+ *     one user left, still per CPU mode
+ *                                         keeps A busy
+ *   is moved to B by the scheduler
+ *     A and B each own a CID
+ *   execve() fails, in a loop
+ *     leaves the mm on B: no user left
+ *                                         sched_setaffinity(P, {A})
+ *     rejoins the mm on A
+ *   visits A and B
+ *
+ * P must read 0 on both CPUs at the end. Each change of H has to land
+ * while P is inside an execve(), so the case runs many times with a
+ * different delay.
+ * Return a CHILD_* status.
+ */
+static int run_child_widened(int delay_us)
+{
+	int a = widen_cpu[0], b = widen_cpu[1], i, status, ret = CHILD_PASS;
+	struct widen_shared *sh;
+	pid_t helper, self = getpid();
+	char path[PATH_MAX];
+	pthread_t thread;
+	uint64_t end;
+
+	sh = mmap(NULL, sizeof(*sh), PROT_READ | PROT_WRITE,
+		  MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	if (sh == MAP_FAILED)
+		return CHILD_ERROR;
+	if (make_unknown_format_file(path, sizeof(path))) {
+		fprintf(stderr, "no directory to run an unknown format file from\n");
+		return CHILD_SKIP;
+	}
+	helper = fork();
+	if (helper < 0) {
+		remove_file(path);
+		return CHILD_ERROR;
+	}
+	if (!helper)
+		_exit(widen_helper(sh, self, a, b, delay_us));
+
+	RSEQ_WRITE_ONCE(sh->phase, 1);
+	if (fail_execs(path)) {
+		ret = CHILD_ERROR;
+		goto out;
+	}
+	end = now_ms() + 2000;
+	while (!RSEQ_READ_ONCE(sh->widened) && now_ms() < end)
+		;
+	if (!RSEQ_READ_ONCE(sh->widened)) {
+		ret = CHILD_ERROR;
+		goto out;
+	}
+
+	if (pthread_create(&thread, NULL, waiter, NULL)) {
+		ret = CHILD_ERROR;
+		goto out;
+	}
+	RSEQ_WRITE_ONCE(stop, 1);
+	if (join_thread(thread)) {
+		ret = CHILD_ERROR;
+		goto out;
+	}
+
+	/* No affinity change by this process: it would reach the mm. */
+	RSEQ_WRITE_ONCE(sh->phase, 2);
+	end = now_ms() + 2000;
+	while (sched_getcpu() != b && now_ms() < end)
+		;
+	if (sched_getcpu() != b) {
+		fprintf(stderr, "the scheduler did not move the process to CPU %d\n", b);
+		ret = CHILD_SKIP;
+		goto out;
+	}
+
+	RSEQ_WRITE_ONCE(sh->phase, 3);
+	if (fail_execs(path)) {
+		ret = CHILD_ERROR;
+		goto out;
+	}
+out:
+	if (ret != CHILD_PASS)
+		kill(helper, SIGKILL);
+	if (waitpid(helper, &status, 0) != helper ||
+	    (ret == CHILD_PASS && (!WIFEXITED(status) || WEXITSTATUS(status))))
+		ret = CHILD_ERROR;
+	if (remove_file(path) && ret == CHILD_PASS)
+		ret = CHILD_ERROR;
+
+	/* The first visit lets the kernel settle, the second one is judged. */
+	for (i = 0; i < 2 * NARROW_CPUS && ret == CHILD_PASS; i++) {
+		unsigned int cid = cid_on_cpu(widen_cpu[i % NARROW_CPUS]);
+
+		if (cid == UINT_MAX) {
+			ret = CHILD_ERROR;
+		} else if (i >= NARROW_CPUS && cid) {
+			fprintf(stderr,
+				"single thread, mm_cid %u on CPU %d after a move from CPU %d to CPU %d\n",
+				cid, widen_cpu[i % NARROW_CPUS], b, a);
+			ret = CHILD_FAIL;
+		}
+	}
+	return ret;
+}
+
 /* Keep the first @nr CPUs of @src in @dst. */
 static int narrow_cpus(cpu_set_t *dst, const cpu_set_t *src, int nr)
 {
@@ -424,11 +634,13 @@ static int run_child_threads(int unused)
 
 int main(void)
 {
-	cpu_set_t allowed, narrow;
-	int status, i;
+	static const char widened[] =
+		"mm_cid of a single thread after its affinity was widened during execve";
+	cpu_set_t allowed, narrow, one;
+	int status, i, cpu, nr = 0;
 
 	ksft_print_header();
-	ksft_set_plan(2);
+	ksft_set_plan(3);
 
 	if (!rseq_available())
 		ksft_exit_skip("rseq is unavailable\n");
@@ -452,5 +664,22 @@ int main(void)
 			break;
 	}
 	report(status, "mm_cid of a single thread after a failed execve on another CPU");
+
+	for (cpu = 0; cpu < CPU_SETSIZE && nr < NARROW_CPUS; cpu++) {
+		if (CPU_ISSET(cpu, &narrow))
+			widen_cpu[nr++] = cpu;
+	}
+	if (nr < NARROW_CPUS) {
+		ksft_test_result_skip("%s: fewer than %d CPUs\n", widened, NARROW_CPUS);
+		ksft_finished();
+	}
+	narrow_cpus(&one, &allowed, 1);
+	/* Both changes of the helper have to land inside an execve. */
+	for (i = 0; i < 2 * ATTEMPTS; i++) {
+		status = run_under_test(run_child_widened, (i * 37) % 1000, &one, &allowed);
+		if (status != CHILD_PASS)
+			break;
+	}
+	report(status, widened);
 	ksft_finished();
 }
-- 
2.47.3


