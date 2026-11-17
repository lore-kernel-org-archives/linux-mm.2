Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA24606A334
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=eLmxZxGm
Received: by kanga.kvack.org (Postfix)
	id 67CE56B05C6; Tue, 17 Nov 2026 11:17:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B9EE6B05C7; Tue, 17 Nov 2026 11:17:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 481876B05C8; Tue, 17 Nov 2026 11:17:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3896B05C6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:17:28 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD3821604AB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:27 +0000 (UTC)
X-FDA: 85445116134.13.AA8E773
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2898840006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=eLmxZxGm;
	spf=pass (imf11.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bC0UW9RXqE2Do0R71IXSsbINxfcS+ry3qm6yhfg8vx4=;
	b=rMXMCtazDu0Ufc6bizp5XrR3wVoGOUIo9R9m0loNtP0+3ERrtMykNSEYj93i4+8sZjERZK
	jpyaLNqSNsZSgG5j/W0A8npHNrY7rkd8D3Dt4D62Rbl2CCcikNWCztXrczokC5AL3uEKCH
	s+vE4DjwkfbK1XsKV2+scbMR2Z4L11k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932246;
	b=mNXis3yj5+mC/T0TLt6bAwPI0FoGktGvS8KUSr2w+qXaLt6EWR5F9MAhCgE94cKVkCZlpT
	iJNKaYu0tiI5yGun+3r5d89vVvjY8iS339saA7asdSEz9hqstd1sGg6ATj9W3d79ehM2Ht
	9H8pDNdixMMyqLUXCIlfn/KlteRzsZc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=eLmxZxGm;
	spf=pass (imf11.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794932243;
	bh=bC0UW9RXqE2Do0R71IXSsbINxfcS+ry3qm6yhfg8vx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLmxZxGmd+Tr0KBxipbWeBL9DdWdjLRBFufpDwE6lHsP1f6el5mmmyWbRDry4pWtl
	 zbUCsy9Q62puQfee8XMeDn8q88r/r+SI2s5Etsw765ubPbka6tpTh7jj5pWlR2L9i8
	 77K9CA9u9IIdK7XfcAaOtW5drf06r3WF1Ej9G7nPOICBt7NogMFSsg8YHJJNHjnpoz
	 n+Q4wdBAqgaB51WuTbkbi8IzMDPSDQmusyz7Op/TfRAk5CcpuUsWKLJpi+fOHUjQ+W
	 iMxrwatLS3+WsjKZfaOhKnK1OHLjs+PM0acxpCL6MIcZviZPqQ1UfQHuGwW2FcR7iE
	 yETaj+qQmGjBw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTVHl6NQgzRZb;
	Tue, 17 Nov 2026 11:17:23 -0500 (EST)
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
Subject: [PATCH 15/17] selftests/rseq: Test two race windows of the concurrency ID mode switches
Date: Tue, 17 Nov 2026 11:17:15 -0500
Message-Id: <53817cdac6cc520ec66232071a5153f5f2bb50c6.1794932121.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2898840006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: i61mqkx33rsrknhtudu57c9hgyxe54y8
X-HE-Tag: 1794932246-439634
X-HE-Meta: U2FsdGVkX18R1mybzv0XG3WqI2wXxV907yoRdueQ+M3QWDrBQ+OA/wiPCveUMqDjg3XKbtI5p2Ry0/vyBaA14pQez2ToKgyGyMQxfbc8/kPJHH92ZjLk1NTlBJAMql9kMO6msFLMYagFP4UfoAKlV8mSnt1KvyqR57nSjn8O9PvMAFFA/+roYYyD+vqqDZTcbRiovoh2TcwP7bM06TVjO9vHdpjYt+8acPX6s7SevVxoxDHsJJa38wr721c7fQiVd9bEAJmJfwDxRr7QB5xudz+6WD8A9Q6OMUaBwhjdJ/E6Lpab3sPdaBAY1dSauQ6gG5E9BXltYz80FBZcaHeAM6rIsTmncB4AS6SH6o3spDFLYD/o3gy3+6/peVuOQK2BldPA9EE69PpJdCrYa0Xzb4HghL9+hQCfgbIzfrl1dCGUPcFtDWxgEnBKtNn7Nfs/roMiWWkVwoqBL8PLbYYFP4lGEjgBjBU8gkPe6UlN5kUqHjm7RHO7Mmox/hz4jzXy3Ho82RDkoqOvDA1RHYrokEJyN4oj+QPAt7HhsrmB/36qJVWsngnrkLbZLag1btmb7UZZ8lsywlXUQDP3oOVxjpJBCwourbOQMaXEN0k/rs5otvjctt2vdz/zLM/2jdBxwAFa0Aac0HhFX/Wn+pJgiejbjgK3DyVz521rLlY+VPacNYnLO1XupWqDKRg7syGsocfb1DmWF4/wrBguSewvmT7IRe9pgQvP+LFVVAfNtrUpF3CZfjFaOfOXIWUcPEOtLhL7IdjxE/ldAFfhURuWFif7xOWyq3Zft4fYlUJCtnmuU96sNtQgHuDSXLdFUx3mZemcFCD3qZsBg3IyHd59dbklxXoLnFTie88KOTqat6h/U3ZfJsq8eLGHhLPqtOOlDbeGo7yiMTpe24cyy3qvJqNF1Pu3Vd1ei4O7b0dyTHeAKzJmnhkLlaa7UCuDY+0NkLSjWJbMT+W/mmmiP2P
 E5W7KFR0
 qsDVD2HVgTRuDfmv4vXWH3OwTDRCwcVXbiZNO1/GSMEtvRi67KzMKfqbJ0R40A/1wssVbFki4xePLzBcBMGPtU0B82SPOvq4fa0Yqs+EejMm5ShG3aZYRjy6khWy7kjpWp3WidnQsAOTMS4OwWEafIxn5tbCMzmCLknIE1CEi7eLWreao6BHWefa0XCNRw4+mH3u9iwwYbdSBiZgdi5kip11J0rjI6c5kQN+h8qpdlrTVeuKZLC0NeIYFTypaY759ip5LPz4Zr9784eWI2hblUlsugD7i8xsVgJN9gJSSZMQqn9aEDrkWFIuc2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Two bugs of the concurrency ID mode switches needed a task to schedule
inside a window that is a few instructions wide:

  - A failed execve() makes the mm switch to per CPU mode. It then
    schedules before it has handed the IDs over. Fixed earlier in this
    series by "sched/mmcid: Let a running joiner take its CID after the
    fixups".
  - A thread migrates after the mm switched to per CPU mode and before
    its ID is handed over. Fixed by commit 4327fb13fa47 ("sched/mmcid:
    Prevent live lock on task to CPU mode transition").

The other tests only reach these windows by chance.

Add mm_cid_window_test, with one case for each sequence, in that
order. Each case runs 40 attempts with a different timing. On an
unmodified kernel the sequences miss the windows: both cases pass with
either fix removed.

To hit a window every time, the kernel has to make one chosen thread
sleep in it. The test marks with "Delay injection" comments where that
thread would ask for the sleep. No kernel code is added for it. The
matching places in kernel/sched/core.c are:

  - in sched_mm_cid_fork(), after the block that changes the mode and
    before mm_cid_fixup_tasks_to_cpus() (both cases);
  - in sched_mm_cid_after_execve(), before sched_mm_cid_fork() (first
    case).

The results below were measured with a 3ms sleep, fsleep(3000), at
these places. Only a task that asked for it took the sleep, through a
debug prctl():

  - Without "sched/mmcid: Let a running joiner take its CID after the
    fixups", the first case fails on every guest. A guest with 2 CPUs
    hangs. Guests with 3, 4 and 8 CPUs report "mm_cid 2 after a failed
    execve, 2 CPUs allowed".
  - Commit 4327fb13fa47 ("sched/mmcid: Prevent live lock on task to CPU
    mode transition") added the transit mode. With it removed, the
    second case hangs guests with 3, 4 and 8 CPUs. That case needs 3
    CPUs.
  - With both fixes, both cases pass on guests with 2 to 8 CPUs.

The process under test dies with the test (PR_SET_PDEATHSIG). A
thread which cannot pin itself sets a flag. The case then ends with an
error. It does not wait for that thread, and it does not report a pass
for a sequence which did not run.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 tools/testing/selftests/rseq/.gitignore       |   1 +
 tools/testing/selftests/rseq/Makefile         |   3 +-
 .../selftests/rseq/mm_cid_window_test.c       | 485 ++++++++++++++++++
 3 files changed, 488 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/rseq/mm_cid_window_test.c

diff --git a/tools/testing/selftests/rseq/.gitignore b/tools/testing/selftests/rseq/.gitignore
index 4c02ff8dccca..0065f51f53ab 100644
--- a/tools/testing/selftests/rseq/.gitignore
+++ b/tools/testing/selftests/rseq/.gitignore
@@ -13,6 +13,7 @@ mm_cid_bound_test
 mm_cid_execve_test
 mm_cid_transition_test
 mm_cid_exec_affinity_test
+mm_cid_window_test
 syscall_errors_test
 slice_test
 legacy_check
diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
index 006e2e281ca8..d72502fc7652 100644
--- a/tools/testing/selftests/rseq/Makefile
+++ b/tools/testing/selftests/rseq/Makefile
@@ -21,7 +21,8 @@ OVERRIDE_TARGETS = 1
 TEST_GEN_PROGS = basic_test basic_percpu_ops_test basic_percpu_ops_mm_cid_test \
 		 param_test_benchmark param_test_mm_cid_benchmark \
 		 mm_cid_execve_test mm_cid_transition_test \
-		 mm_cid_bound_test mm_cid_exec_affinity_test
+		 mm_cid_bound_test mm_cid_exec_affinity_test \
+		 mm_cid_window_test
 
 TEST_GEN_PROGS_EXTENDED = librseq.so \
 	param_test \
diff --git a/tools/testing/selftests/rseq/mm_cid_window_test.c b/tools/testing/selftests/rseq/mm_cid_window_test.c
new file mode 100644
index 000000000000..9e1770236628
--- /dev/null
+++ b/tools/testing/selftests/rseq/mm_cid_window_test.c
@@ -0,0 +1,485 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Two race windows of the concurrency ID mode switches.
+ *
+ * Each case drives its threads through one sequence that a fix closed.
+ * The window is a few instructions wide in the kernel, so the sequence
+ * rarely lands in it. The cases vary their timing on each attempt, and
+ * pass when the sequence misses the window.
+ *
+ * A kernel that can make a chosen task sleep inside the window hits it on
+ * every attempt. The comments that start with "Delay injection" mark where
+ * a thread would ask for that. The commit that adds this test names the
+ * matching places in the kernel.
+ *
+ * Case 1: a failed execve(2) makes the mm switch to per CPU mode. A and B
+ * are the two threads of a process on two CPUs. C is the vfork(2) child
+ * of B.
+ *
+ *   CPU 0                                CPU 1
+ *
+ *   A: execve(2)
+ *      leaves the mm
+ *                                        B: vfork(2), and waits for C
+ *                                        C: joins the mm, takes the last ID
+ *                                        C: spins, and never schedules
+ *   A: execve(2) fails
+ *      rejoins the mm as its third user
+ *      the mm switches to per CPU mode
+ *   A: is scheduled out, and in again
+ *   A: hands the IDs over
+ *
+ * A must not need an ID when it is scheduled in. B and C hold both, and
+ * only A can free one.
+ *
+ * Case 2: a thread migrates while the mm switches to per CPU mode. M is
+ * the main thread. One thread spins on each other CPU, so every ID is
+ * taken. T1 and T2 are two of these threads.
+ *
+ *   CPU 0                         CPU 1                    CPU 2
+ *
+ *                                 T1: spins                T2: spins, and never
+ *                                                              schedules
+ *   M: creates one more thread
+ *      the mm switches to per
+ *      CPU mode
+ *                                 T1: sleeps, and is
+ *                                     scheduled in again
+ *                                 T1: moves to CPU 2
+ *                                                          T1: is scheduled in,
+ *                                                              beside T2
+ *   M: hands the IDs over
+ *
+ * T1 needs an ID on CPU 2 before M has handed them over. CPU 2 owns none
+ * yet, since T2 still holds its own. T1 must find a free one.
+ *
+ * A kernel that loops looking for a free ID shows as a timeout.
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <limits.h>
+#include <pthread.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/prctl.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <time.h>
+#include <unistd.h>
+
+#include "rseq.h"
+#include "kselftest.h"
+
+#define ATTEMPTS	40
+#define MAX_DELAY_US	400
+#define SPIN_MS		300
+#define SLOW_MS		100
+#define MAX_SPINNERS	256
+#define MOVE_WAIT_MS	2000
+
+#define CHILD_PASS	0
+#define CHILD_FAIL	1
+#define CHILD_SKIP	2
+#define CHILD_ERROR	3
+
+static int go, done, moved, ready, stop;
+static int pin_failed;
+static int delay_us;
+static int cpus[MAX_SPINNERS], nr_cpus;
+static char exec_path[PATH_MAX];
+
+static long long now_us(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+	return ts.tv_sec * 1000000LL + ts.tv_nsec / 1000;
+}
+
+static void busy_wait_us(int us)
+{
+	long long end = now_us() + us;
+
+	while (now_us() < end)
+		;
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
+static int pin(int cpu)
+{
+	cpu_set_t set;
+
+	CPU_ZERO(&set);
+	CPU_SET(cpu, &set);
+	return sched_setaffinity(0, sizeof(set), &set);
+}
+
+/* Fill @cpus with the allowed CPUs. Return their number. */
+static int read_allowed_cpus(void)
+{
+	cpu_set_t set;
+	int cpu;
+
+	if (sched_getaffinity(0, sizeof(set), &set))
+		return -1;
+	nr_cpus = 0;
+	for (cpu = 0; cpu < CPU_SETSIZE && nr_cpus < MAX_SPINNERS; cpu++) {
+		if (CPU_ISSET(cpu, &set))
+			cpus[nr_cpus++] = cpu;
+	}
+	return CPU_COUNT(&set);
+}
+
+/*
+ * Create a script that names itself as its interpreter. execve(2) on it
+ * leaves the mm, follows the interpreter a few times and fails with ELOOP.
+ * That keeps the task out of its mm longer than a file of unknown format.
+ */
+static int make_loop_script(void)
+{
+	char *const av[] = { exec_path, NULL };
+	FILE *f;
+
+	snprintf(exec_path, sizeof(exec_path), "/tmp/mm_cid_window_test.%d", getpid());
+	f = fopen(exec_path, "w");
+	if (!f)
+		return -1;
+	fprintf(f, "#!%s\n", exec_path);
+	if (fclose(f) || chmod(exec_path, 0755))
+		goto unlink;
+	if (execve(exec_path, av, NULL) == -1 && errno == ELOOP)
+		return 0;
+unlink:
+	remove_file(exec_path);
+	return -1;
+}
+
+/* Run thread B of case 1: call vfork(2) after a delay and wait for C. */
+static void *vfork_thread(void *arg)
+{
+	pid_t pid;
+
+	if (pin(cpus[1])) {
+		RSEQ_WRITE_ONCE(pin_failed, 1);
+		return NULL;
+	}
+	while (!RSEQ_READ_ONCE(go))
+		;
+	busy_wait_us(delay_us);
+	pid = vfork();
+	if (!pid) {
+		long long end = now_us() + SPIN_MS * 1000;
+
+		/* Hold an ID on this CPU without scheduling. */
+		while (!RSEQ_READ_ONCE(done) && now_us() < end)
+			;
+		_exit(0);
+	}
+	if (pid < 0 || waitpid(pid, NULL, 0) != pid) {
+		fprintf(stderr, "vfork: %s\n", strerror(errno));
+		abort();
+	}
+	return NULL;
+}
+
+/*
+ * Run one attempt of case 1 in a new mm on two CPUs. Return a CHILD_*
+ * status.
+ */
+static int run_child_join(int us)
+{
+	char *const av[] = { exec_path, NULL };
+	long long start, end;
+	unsigned int cid;
+	pthread_t b;
+	int err, exec_errno;
+
+	delay_us = us;
+	if (read_allowed_cpus() != 2 || pin(cpus[0]))
+		return CHILD_ERROR;
+	if (make_loop_script()) {
+		fprintf(stderr, "cannot run a script from /tmp\n");
+		return CHILD_SKIP;
+	}
+	if (pthread_create(&b, NULL, vfork_thread, NULL)) {
+		remove_file(exec_path);
+		return CHILD_ERROR;
+	}
+	/*
+	 * Delay injection: this thread would ask here for two sleeps. One
+	 * in execve(2), between leaving the mm and rejoining it. One when
+	 * it has changed the mode, before it hands the IDs over. B is
+	 * created above, so that it does not inherit the request.
+	 */
+	usleep(200);
+	start = now_us();
+	RSEQ_WRITE_ONCE(go, 1);
+	execve(exec_path, av, NULL);
+	exec_errno = errno;
+	end = now_us();
+	cid = rseq_current_mm_cid();
+	RSEQ_WRITE_ONCE(done, 1);
+	err = join_thread(b);
+	if (remove_file(exec_path) || err)
+		return CHILD_ERROR;
+	if (exec_errno != ELOOP) {
+		fprintf(stderr, "execve(%s): %s, expected ELOOP\n",
+			exec_path, strerror(exec_errno));
+		return CHILD_ERROR;
+	}
+
+	/* B did not run its part if it could not pin itself. */
+	if (pin_failed) {
+		fprintf(stderr, "a thread could not pin itself\n");
+		return CHILD_ERROR;
+	}
+	if (cid >= 2) {
+		fprintf(stderr, "mm_cid %u after a failed execve, 2 CPUs allowed\n", cid);
+		return CHILD_FAIL;
+	}
+	if (end - start > SLOW_MS * 1000) {
+		fprintf(stderr, "the failed execve took %lld ms\n", (end - start) / 1000);
+		return CHILD_FAIL;
+	}
+	return CHILD_PASS;
+}
+
+/* Spin on the CPU cpus[@arg], as a thread of case 2. Thread 1 also moves. */
+static void *spinner(void *arg)
+{
+	int nr = (long)arg;
+
+	if (pin(cpus[nr])) {
+		RSEQ_WRITE_ONCE(pin_failed, 1);
+		return NULL;
+	}
+	__atomic_add_fetch(&ready, 1, __ATOMIC_RELAXED);
+	while (!RSEQ_READ_ONCE(stop)) {
+		if (nr != 1 || !RSEQ_READ_ONCE(go) || RSEQ_READ_ONCE(moved))
+			continue;
+		busy_wait_us(delay_us);
+		/* Schedule out and in on this CPU, with the new mode set. */
+		usleep(1000);
+		/* Move to the CPU of thread 2. It has not scheduled since. */
+		if (pin(cpus[2]))
+			RSEQ_WRITE_ONCE(pin_failed, 1);
+		RSEQ_WRITE_ONCE(moved, 1);
+	}
+	return NULL;
+}
+
+static void *idler(void *arg)
+{
+	while (!RSEQ_READ_ONCE(stop))
+		usleep(1000);
+	return NULL;
+}
+
+/*
+ * Run one attempt of case 2 in a new mm on all CPUs. Return a CHILD_*
+ * status.
+ */
+static int run_child_migrate(int us)
+{
+	static pthread_t threads[MAX_SPINNERS];
+	int i, started = 0, waited = 0, ret = CHILD_PASS;
+	pthread_t extra;
+
+	delay_us = us;
+	if (read_allowed_cpus() < 3 || pin(cpus[0]))
+		return CHILD_ERROR;
+	for (i = 1; i < nr_cpus; i++) {
+		if (pthread_create(&threads[i], NULL, spinner, (void *)(long)i))
+			break;
+		started++;
+	}
+	if (started < nr_cpus - 1) {
+		ret = CHILD_ERROR;
+		goto out;
+	}
+	/*
+	 * Wait until every thread runs on its CPU and holds an ID. A thread
+	 * whose pin failed sets pin_failed and never gets ready.
+	 */
+	while (RSEQ_READ_ONCE(ready) < started && !RSEQ_READ_ONCE(pin_failed))
+		usleep(100);
+	if (RSEQ_READ_ONCE(pin_failed))
+		goto out;
+	usleep(1000);
+	/*
+	 * Delay injection: this thread would ask here for a sleep when it
+	 * has changed the mode to per CPU, before it hands the IDs over.
+	 */
+	RSEQ_WRITE_ONCE(go, 1);
+	if (pthread_create(&extra, NULL, idler, NULL)) {
+		ret = CHILD_ERROR;
+		goto out;
+	}
+	while (!RSEQ_READ_ONCE(moved) && waited++ < MOVE_WAIT_MS)
+		usleep(1000);
+	if (!RSEQ_READ_ONCE(moved)) {
+		fprintf(stderr, "the moving thread did not move\n");
+		ret = CHILD_FAIL;
+	}
+	RSEQ_WRITE_ONCE(stop, 1);
+	if (join_thread(extra) && ret == CHILD_PASS)
+		ret = CHILD_ERROR;
+out:
+	RSEQ_WRITE_ONCE(stop, 1);
+	for (i = 1; i <= started; i++) {
+		if (join_thread(threads[i]) && ret == CHILD_PASS)
+			ret = CHILD_ERROR;
+	}
+	/* The sequence did not run as written if a thread could not pin itself. */
+	if (pin_failed) {
+		fprintf(stderr, "a thread could not pin itself\n");
+		ret = CHILD_ERROR;
+	}
+	return ret;
+}
+
+static int read_nr_possible(void)
+{
+	int first, last, total = 0;
+	char sep;
+	FILE *f;
+
+	f = fopen("/sys/devices/system/cpu/possible", "r");
+	if (!f)
+		return -1;
+	/* A list of ranges: "0-63" or "0,2-5". */
+	while (fscanf(f, "%d", &first) == 1) {
+		last = first;
+		sep = '\n';
+		if (fscanf(f, "%c", &sep) == 1 && sep == '-') {
+			if (fscanf(f, "%d", &last) != 1)
+				break;
+			if (fscanf(f, "%c", &sep) != 1)
+				sep = '\n';
+		}
+		total += last - first + 1;
+		if (sep != ',')
+			break;
+	}
+	fclose(f);
+	return total;
+}
+
+/*
+ * Run @fn(@arg) in a new process that starts on the CPUs in @start, and
+ * return its exit status. The new process dies with this one.
+ */
+static int run_under_test(int (*fn)(int), int arg, const cpu_set_t *start,
+			  const cpu_set_t *all)
+{
+	int status = 0;
+	pid_t child;
+
+	if (sched_setaffinity(0, sizeof(*start), start))
+		ksft_exit_fail_msg("sched_setaffinity: %s\n", strerror(errno));
+	child = fork();
+	if (!child) {
+		if (prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0)) {
+			fprintf(stderr, "prctl(PR_SET_PDEATHSIG): %s\n", strerror(errno));
+			_exit(CHILD_ERROR);
+		}
+		_exit(fn(arg));
+	}
+	if (child < 0)
+		ksft_exit_fail_msg("fork: %s\n", strerror(errno));
+	if (sched_setaffinity(0, sizeof(*all), all))
+		ksft_exit_fail_msg("sched_setaffinity: %s\n", strerror(errno));
+	if (waitpid(child, &status, 0) != child)
+		ksft_exit_fail_msg("waitpid: %s\n", strerror(errno));
+	if (!WIFEXITED(status))
+		ksft_exit_fail_msg("the process under test was killed by signal %d\n",
+				   WTERMSIG(status));
+	if (WEXITSTATUS(status) == CHILD_ERROR)
+		ksft_exit_fail_msg("the process under test failed to run\n");
+	return WEXITSTATUS(status);
+}
+
+static void report(int status, const char *name)
+{
+	if (status == CHILD_SKIP)
+		ksft_test_result_skip("%s\n", name);
+	else
+		ksft_test_result(status == CHILD_PASS, "%s\n", name);
+}
+
+int main(void)
+{
+	const char *join = "failed execve switches to per CPU mode";
+	const char *migrate = "thread migrates during the switch to per CPU mode";
+	cpu_set_t all, two;
+	int status, i, cpu, nr_all;
+
+	ksft_print_header();
+	ksft_set_plan(2);
+
+	if (!rseq_available())
+		ksft_exit_skip("rseq is unavailable\n");
+	if (rseq_register_current_thread())
+		ksft_exit_fail_msg("rseq_register_current_thread: %s\n", strerror(errno));
+	if (!rseq_mm_cid_available())
+		ksft_exit_skip("the rseq mm_cid field is unavailable\n");
+	if (sched_getaffinity(0, sizeof(all), &all))
+		ksft_exit_fail_msg("sched_getaffinity: %s\n", strerror(errno));
+	nr_all = CPU_COUNT(&all);
+
+	if (nr_all < 2) {
+		ksft_test_result_skip("%s: fewer than 2 CPUs\n", join);
+	} else {
+		CPU_ZERO(&two);
+		for (cpu = 0; cpu < CPU_SETSIZE && CPU_COUNT(&two) < 2; cpu++) {
+			if (CPU_ISSET(cpu, &all))
+				CPU_SET(cpu, &two);
+		}
+		for (i = 0; i < ATTEMPTS; i++) {
+			status = run_under_test(run_child_join, (i * 37) % MAX_DELAY_US,
+						&two, &all);
+			if (status != CHILD_PASS)
+				break;
+		}
+		report(status, join);
+	}
+
+	/* Every ID is taken only when one thread spins on each possible CPU. */
+	if (nr_all < 3 || nr_all > MAX_SPINNERS || nr_all != read_nr_possible()) {
+		ksft_test_result_skip("%s: needs 3 to %d CPUs, all of them allowed\n",
+				      migrate, MAX_SPINNERS);
+	} else {
+		for (i = 0; i < ATTEMPTS; i++) {
+			status = run_under_test(run_child_migrate, (i * 37) % MAX_DELAY_US,
+						&all, &all);
+			if (status != CHILD_PASS)
+				break;
+		}
+		report(status, migrate);
+	}
+	ksft_finished();
+}
-- 
2.47.3


