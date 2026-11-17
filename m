Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C7A606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=Vaijihsd
Received: by kanga.kvack.org (Postfix)
	id 965296B05C1; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 915C06B05C4; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5566B05C7; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6816B05C1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B6E31604E6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:26 +0000 (UTC)
X-FDA: 85445116092.05.C65C6B9
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7FA4F8000E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=Vaijihsd;
	spf=pass (imf02.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+eRx1E6OH5BWB9d5HcLPoxdra5i7n/GKknl+XwKvzvo=;
	b=6uZ2c5tGocYyhPS1PW8u44E1OiJbaSkAdoBwVropbuSAuWTiowbZSa6PenyVsVJs/ozmAh
	/mnU2wWkUz5TXtCrcURko5gWlocudz/nfvNwZdr5MgjlMhvJvSDmMkJfaszQtr24xtigU3
	ctv37c2/qVoB8LQkmQxslFH314Ho1pA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932244;
	b=p4L0ZVZdA/MJ9TiRt+qcf1gqysUBoK6BPxUnWuKenLmX5YCxvbzcqEb34+R1fajjLhsDTH
	1ufUkmAVMNdx8XY8d4ezjGtCnUEetAxxzadXEZQjd+LFvr7gBZVfwDE0te2ZelGKuEkx4H
	wWDVUt8c4ar0Rt8pvOSK4IDChAe+NB0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=Vaijihsd;
	spf=pass (imf02.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794932242;
	bh=+eRx1E6OH5BWB9d5HcLPoxdra5i7n/GKknl+XwKvzvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VaijihsdwJaRa3EvSnvIUEnozhcyghOQX54nWMDjeOq21qx5YlTxvH7DuenVqGtMc
	 wHBqvaw3a9PNAv1zyJatMiqCvhf2hilK/B9dlbZyWYqgnN7orv7Kl0fBfhM4xIJJHc
	 hhdp/r8ArlKocaYxtSTNZn30uyVXVz+7FSrUz5L2YQORjKsHXHKWj6g4Tg8379VDsR
	 wW16RNsgg52yVWkNHPQvtfYrn4G7C5OIx+LQPa6rxFk1PmqZXiB8Nlwpq5VEFmbaTG
	 u3cniGwtTk2Uao2D8vU0ydFmfekv3KXo4SZ59j3F9QlybLCfGec+bGD112FUmvX3yC
	 4ArXra86KkKcQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTVHk5bqrzRmt;
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
Subject: [PATCH 08/17] selftests/rseq: Test the concurrency ID after the last user fails execve
Date: Tue, 17 Nov 2026 11:17:08 -0500
Message-Id: <5c5ce3c68394929160f30955037c0ba642a66d34.1794932121.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7FA4F8000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 613nk5wwspy96zyihkimu7baz5iw3rhs
X-HE-Tag: 1794932244-715729
X-HE-Meta: U2FsdGVkX19QxldoolFpIDjkPv76y6fYG44aB45VBWRmeb0F9l1A3qjlTb+AffLVWMh9GOjv9NOItjrwQDBsLI1KZIlTEgd04S+rUiD66QaPSTAkqh910rt4ScIw8ApLKZ66bgfBr34Aqe9nsDu+lcR85Ki9wLZbIpF4dNT0GBMsNCtzdsfR5uzPtsYXguabmKYIpyiRNaIcYL8XvGCqScylsNd4Phr5Ax9OR/OMS0GblQc9MOAEsEY51pRSGSqwEZC07WxTxl2bhUxcHtISjEaLGXK7DqWFGiLmHKePETp+0slH+bhAlNoZo3BQ0Da+ScpNRnXlPItjGAMIz1rtzHmLnRzD/Z4s+NHI5TSyoAoR4Ez6QQRfpoJgqzbvgpMQPBCLh0xteqQmTK9sGC3C3iCXUlS/dDnICBSOo3vlRQUB4vI02+XgTP9YbqxV2EELGnzGs1L9v7TaxUqC6yOM7YPKnbfDqRPl3TR4QToSUg8UkGQZ8Mgl4/Ps5YvHnVfEkYG5xKagBvDRu7Brr1691hBZsPrd0BtYVZrM2RjQZUqPPalvElvrWlp5YwvEoCm6TncZEA1HE8tmpB0zorD2nkRJI6JW52qDqgD1Wx3RxPqcTr/iRa4vs6PXHxsMXBpXOGcyQsoeEHVtSpaI9NToEQK59rof42TC1TVCyCK/7DkdfRIDg/QvNmE20ve3v+j5UzdZkuox/6NQGY50F+8ppXpy3GEDxhsuJQswuwapydgMzJI+EmCOJnjJxT1yOxZOj/Ci/OiupAFVTeN9mP9S+45levwZqQ4bwg3jzOda5k8ebmpKxCp6SdI4tzbzKtwqqqhDKBfFdtBKSJ5x8w/v/aTRIhtflxa4PgAtIJlBGQF95zSPEPxyHYTxQ0yNKp5NGcTNyZ0AQhlApEgiSz+FKMqZdPl7y3EfLJd7FJrz+bPUA81pDr6G38yMWnPgSlArjak743YKu/eo3SaKY38
 E9DIDo3M
 6roXSOMpOZBYvFJwF3qJrnVnZ8/mRg2Myl0Dl86cF+FdEwqH70sNpOeyjctjslJcuaArmXHwLhxmK6W1t11eOweMVOX22FtX4F8zj/KnxHIyYsfDJKUreGMPepP9TeOTW44JFS7SWr38Zq2ivstxxmxM3Vodw5PPneHkq7fmU57p/zsfcYkUxcmt3zT8YxyL04ioY7GLUjG4f1YNgfEWdMabDVAJL8J8VQ3jrL77vXFxtQWV6COXwZZ2euSiM+D4kUjzcdGFamAP54YyjnCuDizrTPRY53oV6Pv9lr80E+O2jKc06pCLZuOAtiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A failed execve() leaves the mm and rejoins it. When the caller is the
only thread left, it leaves as the last user and rejoins as the first
one. The kernel must not keep state of the previous users across that.

Add a case to mm_cid_execve_test. Four threads make the mm switch to per
CPU mode on two CPUs, then exit. The remaining thread fails execve() in
a loop on one CPU while a helper process moves it to the other CPU. It
then visits both CPUs and must read mm_cid 0 on each.

The move has to land inside an execve(), so the case runs 50 times with
a different delay each time.

With two allowed CPUs, the kernel keeps per CPU mode down to one thread
only on a machine with two or three possible CPUs. Elsewhere the single
thread reads mm_cid 0 on both CPUs before the execve(), and the case is
skipped.

Without "sched/mmcid: Reset stale state when the first user joins an
mm", on guests with two and three CPUs (six runs out of six):

  single thread, mm_cid 1 on CPU 0 after a failed execve moved from CPU 0 to CPU 1
  not ok 2 mm_cid of a single thread after a failed execve on another CPU

With it (six runs out of six):

  ok 2 mm_cid of a single thread after a failed execve on another CPU

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../selftests/rseq/mm_cid_execve_test.c       | 236 +++++++++++++++---
 1 file changed, 208 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/rseq/mm_cid_execve_test.c b/tools/testing/selftests/rseq/mm_cid_execve_test.c
index 3d8b9365ce91..baf06af574bd 100644
--- a/tools/testing/selftests/rseq/mm_cid_execve_test.c
+++ b/tools/testing/selftests/rseq/mm_cid_execve_test.c
@@ -8,6 +8,15 @@
  * running and the other threads are still users. The task returns to user
  * space before any schedule in, so the join has to give it a CID.
  *
+ * A second case covers the last user. A process that is back to a single
+ * thread fails execve(2) while another process moves it to another CPU.
+ * It leaves its mm as the last user on one CPU and rejoins it as the first
+ * user on the other. A single thread must read 0 afterwards. That case
+ * needs per CPU mode to last down to one thread. With the two allowed CPUs
+ * of the test, the kernel only does that with at most three possible
+ * CPUs. The case is skipped when a single thread reads 0 on both CPUs
+ * before the execve(2).
+ *
  * Per CPU mode needs more threads than the mm has CIDs. The number of CIDs
  * follows the union of the allowed CPUs of the threads, which only grows.
  * The affinity is therefore narrowed before the fork(2) that creates the
@@ -19,6 +28,7 @@
 #include <limits.h>
 #include <pthread.h>
 #include <sched.h>
+#include <signal.h>
 #include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -33,6 +43,8 @@
 #define NARROW_CPUS	2
 #define THREADS		4
 #define ROUNDS		100
+#define ATTEMPTS	50
+#define MOVE_EXECS	300
 
 /* Exit status of the process under test. */
 #define CHILD_PASS	0
@@ -204,6 +216,147 @@ static int run_child(void)
 	return ret;
 }
 
+/* Run on @cpu and return the mm_cid read there. */
+static unsigned int cid_on_cpu(int cpu)
+{
+	cpu_set_t one;
+
+	CPU_ZERO(&one);
+	CPU_SET(cpu, &one);
+	if (sched_setaffinity(0, sizeof(one), &one))
+		return UINT_MAX;
+	return rseq_current_mm_cid();
+}
+
+/*
+ * The second process under test. Its threads make the mm switch to per
+ * CPU mode and exit. The last thread then fails execve(2) in a loop on the
+ * CPU @from. A helper process moves it to the CPU @to, @delay_us after the
+ * start of the loop. The thread then visits both CPUs and must read 0 on
+ * each.
+ * Return a CHILD_* status.
+ */
+static int run_child_moved(int delay_us)
+{
+	pthread_t thread[THREADS];
+	char path[PATH_MAX];
+	int cpus[NARROW_CPUS], nr = 0, cpu, i, started = 0, ret = CHILD_PASS;
+	int from, to, go[2], status;
+	unsigned int cid0, cid1;
+	cpu_set_t mask, one;
+	pid_t helper, self = getpid();
+	char c = 0;
+
+	if (sched_getaffinity(0, sizeof(mask), &mask))
+		return CHILD_ERROR;
+	for (cpu = 0; cpu < CPU_SETSIZE && nr < NARROW_CPUS; cpu++) {
+		if (CPU_ISSET(cpu, &mask))
+			cpus[nr++] = cpu;
+	}
+	if (nr < NARROW_CPUS) {
+		fprintf(stderr, "fewer than %d allowed CPUs\n", NARROW_CPUS);
+		return CHILD_SKIP;
+	}
+	if (make_unknown_format_file(path, sizeof(path))) {
+		fprintf(stderr, "no directory to run an unknown format file from\n");
+		return CHILD_SKIP;
+	}
+
+	for (i = 0; i < THREADS; i++) {
+		if (pthread_create(&thread[i], NULL, waiter, NULL))
+			break;
+		started++;
+	}
+	/* Run on both CPUs while the threads exist: each CPU takes a CID. */
+	for (i = 0; i < 2 * NARROW_CPUS; i++)
+		cid_on_cpu(cpus[i % NARROW_CPUS]);
+	RSEQ_WRITE_ONCE(stop, 1);
+	for (i = 0; i < started; i++) {
+		if (join_thread(thread[i]))
+			ret = CHILD_ERROR;
+	}
+	if (ret != CHILD_PASS || started < THREADS) {
+		ret = CHILD_ERROR;
+		goto out;
+	}
+
+	cid0 = cid_on_cpu(cpus[0]);
+	cid1 = cid_on_cpu(cpus[1]);
+	if (cid0 == UINT_MAX || cid1 == UINT_MAX) {
+		ret = CHILD_ERROR;
+		goto out;
+	}
+	/* The CPUs own the CIDs only if one of them reads above 0. */
+	if (!cid0 && !cid1) {
+		fprintf(stderr, "the mm is not in per CPU mode with a single thread\n");
+		ret = CHILD_SKIP;
+		goto out;
+	}
+	/* Leave from the CPU that does not hold CID 0, rejoin on the other. */
+	from = cid0 ? cpus[0] : cpus[1];
+	to = from == cpus[0] ? cpus[1] : cpus[0];
+	cid_on_cpu(from);
+
+	if (pipe(go)) {
+		ret = CHILD_ERROR;
+		goto out;
+	}
+	helper = fork();
+	if (helper < 0) {
+		close(go[0]);
+		close(go[1]);
+		ret = CHILD_ERROR;
+		goto out;
+	}
+	if (!helper) {
+		/* Run beside the process under test, not on its CPU. */
+		CPU_ZERO(&one);
+		CPU_SET(to, &one);
+		if (sched_setaffinity(0, sizeof(one), &one) || read(go[0], &c, 1) != 1)
+			_exit(1);
+		usleep(delay_us);
+		_exit(!!sched_setaffinity(self, sizeof(one), &one));
+	}
+	if (write(go[1], &c, 1) != 1) {
+		/* The helper waits for that byte. */
+		kill(helper, SIGKILL);
+		ret = CHILD_ERROR;
+	}
+	for (i = 0; i < MOVE_EXECS; i++) {
+		char *const av[] = { path, NULL };
+
+		if (execve(path, av, NULL) == -1 && errno != ENOEXEC) {
+			fprintf(stderr, "execve(%s): %s, expected ENOEXEC\n",
+				path, strerror(errno));
+			ret = CHILD_ERROR;
+			break;
+		}
+	}
+	if (waitpid(helper, &status, 0) != helper || !WIFEXITED(status) ||
+	    WEXITSTATUS(status))
+		ret = CHILD_ERROR;
+	close(go[0]);
+	close(go[1]);
+
+	/* The first visit lets the kernel settle, the second one is judged. */
+	for (i = 0; i < 2 * NARROW_CPUS && ret == CHILD_PASS; i++) {
+		unsigned int cid = cid_on_cpu(cpus[i % NARROW_CPUS]);
+
+		if (cid == UINT_MAX) {
+			ret = CHILD_ERROR;
+		} else if (i >= NARROW_CPUS && cid) {
+			fprintf(stderr,
+				"single thread, mm_cid %u on CPU %d after a failed execve moved from CPU %d to CPU %d\n",
+				cid, cpus[i % NARROW_CPUS], from, to);
+			ret = CHILD_FAIL;
+		}
+	}
+out:
+	if (remove_file(path) && ret == CHILD_PASS)
+		ret = CHILD_ERROR;
+	return ret;
+}
+
 /* Keep the first @nr CPUs of @src in @dst. */
 static int narrow_cpus(cpu_set_t *dst, const cpu_set_t *src, int nr)
 {
@@ -219,58 +372,85 @@ static int narrow_cpus(cpu_set_t *dst, const cpu_set_t *src, int nr)
 	return taken;
 }
 
-int main(void)
+/*
+ * Run @fn(@arg) in a new process and return its exit status. The affinity
+ * is @narrow when its mm is created. The union of allowed CPUs of an mm
+ * starts there and only grows.
+ */
+static int run_under_test(int (*fn)(int), int arg, const cpu_set_t *narrow,
+			  const cpu_set_t *allowed)
 {
-	cpu_set_t allowed, narrow;
 	int status = 0;
 	pid_t child;
 
-	ksft_print_header();
-	ksft_set_plan(1);
-
-	if (!rseq_available())
-		ksft_exit_skip("rseq is unavailable\n");
-	/* glibc before 2.35 registers no rseq area. */
-	if (rseq_register_current_thread())
-		ksft_exit_fail_msg("rseq_register_current_thread: %s\n", strerror(errno));
-	if (!rseq_mm_cid_available())
-		ksft_exit_skip("the rseq mm_cid field is unavailable\n");
-	if (sched_getaffinity(0, sizeof(allowed), &allowed))
-		ksft_exit_fail_msg("sched_getaffinity: %s\n", strerror(errno));
-	if (!narrow_cpus(&narrow, &allowed, NARROW_CPUS))
-		ksft_exit_skip("no CPU to run on\n");
-
-	/*
-	 * Narrow before the fork(2). The mm of the child starts with these
-	 * allowed CPUs, and a later narrowing does not shrink them.
-	 */
-	if (sched_setaffinity(0, sizeof(narrow), &narrow))
+	if (sched_setaffinity(0, sizeof(*narrow), narrow))
 		ksft_exit_skip("sched_setaffinity: %s\n", strerror(errno));
 	child = fork();
 	if (!child)
-		_exit(run_child());
+		_exit(fn(arg));
 	if (child < 0)
 		ksft_exit_fail_msg("fork: %s\n", strerror(errno));
-	if (sched_setaffinity(0, sizeof(allowed), &allowed))
+	if (sched_setaffinity(0, sizeof(*allowed), allowed))
 		ksft_exit_fail_msg("sched_setaffinity: %s\n", strerror(errno));
 	if (waitpid(child, &status, 0) != child)
 		ksft_exit_fail_msg("waitpid: %s\n", strerror(errno));
 	if (!WIFEXITED(status))
 		ksft_exit_fail_msg("the process under test was killed by signal %d\n",
 				   WTERMSIG(status));
+	return WEXITSTATUS(status);
+}
 
-	switch (WEXITSTATUS(status)) {
+static void report(int status, const char *name)
+{
+	switch (status) {
 	case CHILD_PASS:
-		ksft_test_result_pass("mm_cid after a failed execve\n");
+		ksft_test_result_pass("%s\n", name);
 		break;
 	case CHILD_SKIP:
-		ksft_test_result_skip("mm_cid after a failed execve\n");
+		ksft_test_result_skip("%s\n", name);
 		break;
 	case CHILD_FAIL:
-		ksft_test_result_fail("mm_cid after a failed execve\n");
+		ksft_test_result_fail("%s\n", name);
 		break;
 	default:
 		ksft_exit_fail_msg("the process under test failed to run\n");
 	}
+}
+
+static int run_child_threads(int unused)
+{
+	return run_child();
+}
+
+int main(void)
+{
+	cpu_set_t allowed, narrow;
+	int status, i;
+
+	ksft_print_header();
+	ksft_set_plan(2);
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
+	status = run_under_test(run_child_threads, 0, &narrow, &allowed);
+	report(status, "mm_cid after a failed execve");
+
+	/* The helper's move has to land inside an execve: spread its delay. */
+	for (i = 0; i < ATTEMPTS; i++) {
+		status = run_under_test(run_child_moved, (i * 37) % 1000, &narrow, &allowed);
+		if (status != CHILD_PASS)
+			break;
+	}
+	report(status, "mm_cid of a single thread after a failed execve on another CPU");
 	ksft_finished();
 }
-- 
2.47.3


