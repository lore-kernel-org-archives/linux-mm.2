Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69F4F606D82D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ipxbn/9D
Received: by kanga.kvack.org (Postfix)
	id 3011D6B05C0; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2375E6B05C1; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03C4D6B05C4; Tue, 17 Nov 2026 11:17:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9C366B05BA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:17:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 55EF11404BF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:26 +0000 (UTC)
X-FDA: 85445116092.17.18CDB2D
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf03.hostedemail.com (Postfix) with ESMTP id 825B12000C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="ipxbn/9D";
	spf=pass (imf03.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932244;
	b=KBxC2GLrVJVKLIJ5bgWZfb/BSxxEL2rdEIxGbnmWcvD3HrTA+sRrTS6qKYalaiofUfeGG3
	SglTuFJf914KBxsA89jn0u3uYNDep0ZupmID+i5XgISDYXymv5nb3hIhy61IG84yY/c0eW
	s9ejH1vGaBpc1MiSSFocz4jGVtSr504=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="ipxbn/9D";
	spf=pass (imf03.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJ2xcjdkYXWnSKRSnvXZ4inHX8fzRA3So6dM2SQggqE=;
	b=7GN9EWI7qhbQNzWFQScBNcGhDbcMN4IgOARM7I+n9vFLHK/iv51pPnIHR3U1NPDsvy6X6r
	ml4bNFAKUPRwMEuPsIzglpW03mx80EMNF3hSj8whmg9wMc1ad9/emYy+JHysoPWlFxTuSj
	i/6ZC98uSlVbRvWWse8FUCevhsj8wNw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794932243;
	bh=GJ2xcjdkYXWnSKRSnvXZ4inHX8fzRA3So6dM2SQggqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipxbn/9DQjg4v5fQp5pJ3/JZNuVBjTT0h5c0A8Kqd9dd+lkKmgEX3JcLBU0Uik3dl
	 U4ZPxkxZwQ/zyBU3o/nbafyn/Cu+Q0WuGsDCA4yBbn63k+B3ntJqVQ77xxt/YQEPMT
	 yoOphaVdFYZ3jM6u2m8SKFQBnGP2ayRt9SkTSRZnov63KBJKxwlAo24DBeXw7R5+oQ
	 +lnceExbdO+xoNlaNqTtO79D3Cdvtzki165NSw5zOG0EdcOcHTzpHbnKDNYCO9L4i4
	 YhhbFcwNsQxzexdRw804pr8iIppe9NLKs14gzvjqpY/B744IyT8JHiD/6oSs+bP6TM
	 KRr//zMtK8YtQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTVHk6fYxzRmv;
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
Subject: [PATCH 09/17] selftests/rseq: Test the concurrency IDs across ownership mode switches
Date: Tue, 17 Nov 2026 11:17:09 -0500
Message-Id: <ec371dca311a8d1b059f2ee99c7b41dc049bfac6.1794932121.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tetdzouqdp4fxc3gt5qq1bboqm9x7mjn
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 825B12000C
X-HE-Tag: 1794932244-75308
X-HE-Meta: U2FsdGVkX1/+1cEX+Gqw7EXeX2xJKdNmiS0SWdmibCPJzwHu4+KR4q7efqQ0Gh4qxeHnluQhYBD7LJHmuyOtrz3BJAotK5pczxorJAO3dfHkLc7pIV87rv88RmB5MJ5/wFUgQVMPi3CLFKiWFNFUrgQRYik2GEVFKuwpyahlUvxSUudK709c8NuHOachUx8TEhuHx+Ge0GCqlsu2rQFWBM3WWmRaPWdxigx0XsPE0ViRya+icjW4We83zNUgZy5HWT3sbEIR56jUyRN6ZDJmNLNG6hOdx/fEo4z4guOy3looVrKKNPMOkqg0iy2DPM9ayfkoW3xULHikXSkDB3+SmvE8FX+mT4+dmEmFJiznM6EsNOSxmLdUY4j4p7g6e7c3RvjNn7Dk1npK3FNj3j4GSkVvl3vkmhpBtBeQqDX9ddDdjGbi1ziNiVGoUWqqGN8Bwyo7jHHkR0Qr6ZhuidpFRCch3fbod2n+geHWtsy5IkBOLs3mC7qfV/fuQYa9e8/uZ5gB3MMqGpennrfGSMfGYeIHyqkEbi7eagy7sFAG6+rgBlZF8/NxFfbCMwZ1E6v2u4XE2DxpY7BBPGL6Wn7/Ofte0ulMYj2AOGdtkvnfuoMckwF4uI2jEicLd9ktq18++wCn/jTN2mZlXVrlgPCsKrxxgygiVHTnF5YGl5+V1mmukWUclNF6JhB2Iavd3rkF2ZwLrgcPQqfn9fB+n3ZK5dAsAf0yZrSeVxS9gz6NrCLfT7A5Mn4+n2dQEfJqmEIj6LrApzkUrYEN/fKj73DzFuM8zui9sFtfEo0j9PPssU6TURvE4ppvjXs75TGiGNlGH9TkSYJk8t2qUCltvj1zcKGX6aa4QAPP761QNYOIbPwurIMjn36glDKmkrCMqodx15jFf12CUAPrc8/S9nK6sfgVSmbm2H6ncp+cFgeRkRzpdA59qH1wUg2fp1nxB5yGeOiKNSY+yJ1xlJdPyAx
 DxUUmRqf
 caTA02JilyzjZ/oS+DCH8qb46lZbdyGf+WiEDOsReYaFmc8CinkQda8QAV+Ve3mebHc7dtWoauwEyNqfyfSZLH3YkazbiEkUfMGzwY/1PUsmC+LPv0RnAsUp27+Da8EYhKd5h8Wj+5gOcsUo/+TXrQ/cxqWpv6xaZcsohyt4TeudTCmPnGUczm2fbL4aEa6Ow1aufZH7gPDouz+3Vj/5SaqsimNzgTMAjxL1w5rQaDBn1PJabuQKdWbe17TuywjLfETQcMqO5U5wDHOd8MS+4Fn8SUw7TsgHydlc8WSoF7tMO1DWESQJL377O6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Either the tasks or the CPUs own the concurrency IDs of an mm. The
kernel switches between both when the thread count crosses a threshold.
It also does when an affinity change widens the allowed CPUs. No test
changes the thread count while the IDs are in use.

Add mm_cid_transition_test. Each round creates 1 to 16 threads and
joins them, so the thread count crosses both thresholds. A round has
three kinds of threads:
- Most threads count in an array indexed by their mm_cid, in an rseq
  critical section with no lock. Two threads that run with the same
  mm_cid at the same time lose counts.
- One thread fails execve() in a loop, so it leaves the mm and rejoins
  it.
- One thread calls vfork() in a loop. Its child is a user of the mm,
  and can join while the thread above is out.

A last case starts on two CPUs and widens the affinity of a thread
while three others count.

The test fails when counts are lost, or when an mm_cid is not below the
number of possible CPUs.

It passes with this series on guests with 2 to 64 CPUs. On a v7.1.8
kernel with 384 CPUs, it reports the ID a failed execve() gets in per
CPU mode:

  thread count changes: mm_cid 2147483648 (0x80000000), 384 possible CPUs
  not ok 1 thread count changes on at most 4 CPUs

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 tools/testing/selftests/rseq/.gitignore       |   1 +
 tools/testing/selftests/rseq/Makefile         |   2 +-
 .../selftests/rseq/mm_cid_transition_test.c   | 375 ++++++++++++++++++
 3 files changed, 377 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/rseq/mm_cid_transition_test.c

diff --git a/tools/testing/selftests/rseq/.gitignore b/tools/testing/selftests/rseq/.gitignore
index 1d94aaf15f4e..e8afb37121d7 100644
--- a/tools/testing/selftests/rseq/.gitignore
+++ b/tools/testing/selftests/rseq/.gitignore
@@ -10,6 +10,7 @@ param_test_mm_cid
 param_test_mm_cid_benchmark
 param_test_mm_cid_compare_twice
 mm_cid_execve_test
+mm_cid_transition_test
 syscall_errors_test
 slice_test
 legacy_check
diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
index ee40f80c079c..ac32d6af3b99 100644
--- a/tools/testing/selftests/rseq/Makefile
+++ b/tools/testing/selftests/rseq/Makefile
@@ -20,7 +20,7 @@ OVERRIDE_TARGETS = 1
 
 TEST_GEN_PROGS = basic_test basic_percpu_ops_test basic_percpu_ops_mm_cid_test \
 		 param_test_benchmark param_test_mm_cid_benchmark \
-		 mm_cid_execve_test
+		 mm_cid_execve_test mm_cid_transition_test
 
 TEST_GEN_PROGS_EXTENDED = librseq.so \
 	param_test \
diff --git a/tools/testing/selftests/rseq/mm_cid_transition_test.c b/tools/testing/selftests/rseq/mm_cid_transition_test.c
new file mode 100644
index 000000000000..7c80c222bd96
--- /dev/null
+++ b/tools/testing/selftests/rseq/mm_cid_transition_test.c
@@ -0,0 +1,375 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * The concurrency IDs while the kernel switches their ownership mode.
+ *
+ * The kernel lets the tasks own the IDs of an mm while there are few
+ * threads. The CPUs own them once there are more threads than IDs. The
+ * kernel switches mode when the thread count crosses a threshold. It also
+ * does when an affinity change widens the allowed CPUs.
+ *
+ * Each round creates a few threads and joins them, so the thread count
+ * crosses both thresholds. A round has three kinds of threads:
+ * - Most threads count in an array indexed by their mm_cid, with an rseq
+ *   critical section and no lock. Two threads that run with the same
+ *   mm_cid at the same time lose counts.
+ * - One thread fails execve(2) in a loop. It leaves the mm and rejoins
+ *   it.
+ * - One thread calls vfork(2) in a loop. The child is a user of the mm
+ *   until it exits. It can join while the thread above is out.
+ *
+ * A second case starts on two CPUs and widens the affinity of a thread
+ * while the others count.
+ *
+ * The test fails when counts are lost, or when an mm_cid is not below the
+ * number of possible CPUs. A kernel that loops looking for a free ID
+ * shows as a timeout.
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <limits.h>
+#include <pthread.h>
+#include <sched.h>
+#include <stdbool.h>
+#include <stdint.h>
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
+#define MAX_CIDS	CPU_SETSIZE
+#define MAX_WORKERS	16
+#define ROUNDS		200
+#define WIDEN_RUNS	100
+#define ROUND_US	500
+#define MAX_TRIES	1000000
+
+#define CHILD_PASS	0
+#define CHILD_FAIL	1
+#define CHILD_ERROR	2
+
+struct worker {
+	pthread_t	thread;
+	intptr_t	counted;
+	unsigned int	bad_cid;
+	bool		execs;
+	bool		vforks;
+};
+
+static intptr_t counts[MAX_CIDS];
+static struct worker workers[MAX_WORKERS];
+static int stop;
+static int nr_possible;
+static cpu_set_t all_cpus;
+static char exec_path[PATH_MAX];
+
+/* Add one to the count of the current mm_cid. */
+static void count_one(struct worker *w)
+{
+	for (;;) {
+		unsigned int cid = rseq_current_mm_cid();
+
+		if (cid >= (unsigned int)nr_possible || cid >= MAX_CIDS) {
+			w->bad_cid = cid;
+			return;
+		}
+		if (!rseq_addv(RSEQ_MO_RELAXED, RSEQ_PERCPU_MM_CID, &counts[cid], 1, cid)) {
+			w->counted++;
+			return;
+		}
+	}
+}
+
+static int join_failed;
+
+/* Join @t. Report an error and set join_failed if that fails. */
+static void join_thread(pthread_t t)
+{
+	int err = pthread_join(t, NULL);
+
+	if (err) {
+		fprintf(stderr, "pthread_join: %s\n", strerror(err));
+		RSEQ_WRITE_ONCE(join_failed, 1);
+	}
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
+static void *worker_fn(void *arg)
+{
+	struct worker *w = arg;
+	char *const av[] = { exec_path, NULL };
+	int i;
+
+	if (rseq_register_current_thread())
+		abort();
+	while (!RSEQ_READ_ONCE(stop) && w->bad_cid == UINT_MAX) {
+		for (i = 0; i < 100; i++)
+			count_one(w);
+		if (w->execs && execve(exec_path, av, NULL) == -1 && errno != ENOEXEC) {
+			fprintf(stderr, "execve: %s, expected ENOEXEC\n", strerror(errno));
+			abort();
+		}
+		if (w->vforks) {
+			pid_t pid = vfork();
+
+			if (!pid)
+				_exit(0);
+			if (pid < 0 || waitpid(pid, NULL, 0) != pid) {
+				fprintf(stderr, "vfork: %s\n", strerror(errno));
+				abort();
+			}
+		}
+	}
+	rseq_unregister_current_thread();
+	return NULL;
+}
+
+/* Run @nr workers for a while, one of them failing execve(2). */
+static int run_round(int nr, int widen_us)
+{
+	int i, started = 0, widened = 1;
+
+	RSEQ_WRITE_ONCE(stop, 0);
+	for (i = 0; i < nr; i++) {
+		int err, tries = 0;
+
+		workers[i].execs = i == 0 && exec_path[0];
+		workers[i].vforks = i == 1;
+		/* clone(CLONE_FS) fails with EAGAIN while a thread is in execve. */
+		do {
+			err = pthread_create(&workers[i].thread, NULL, worker_fn, &workers[i]);
+			if (err == EAGAIN)
+				sched_yield();
+		} while (err == EAGAIN && ++tries < MAX_TRIES);
+		if (err)
+			break;
+		started++;
+	}
+	if (widen_us >= 0) {
+		usleep(widen_us);
+		/* The union of allowed CPUs of the mm grows. */
+		if (sched_setaffinity(0, sizeof(all_cpus), &all_cpus)) {
+			fprintf(stderr, "sched_setaffinity: %s\n", strerror(errno));
+			widened = 0;
+		}
+	}
+	usleep(ROUND_US);
+	RSEQ_WRITE_ONCE(stop, 1);
+	for (i = 0; i < started; i++)
+		join_thread(workers[i].thread);
+	return started == nr && widened && !RSEQ_READ_ONCE(join_failed) ? 0 : -1;
+}
+
+/* Compare the counts of the array with the counts of the workers. */
+static int check_counts(const char *what)
+{
+	intptr_t counted = 0, total = 0;
+	int i, ret = CHILD_PASS;
+
+	for (i = 0; i < MAX_WORKERS; i++) {
+		counted += workers[i].counted;
+		if (workers[i].bad_cid != UINT_MAX) {
+			fprintf(stderr, "%s: mm_cid %u (0x%x), %d possible CPUs\n",
+				what, workers[i].bad_cid, workers[i].bad_cid, nr_possible);
+			ret = CHILD_FAIL;
+		}
+	}
+	for (i = 0; i < MAX_CIDS; i++)
+		total += counts[i];
+	if (total != counted) {
+		fprintf(stderr, "%s: %ld counts lost out of %ld: two threads ran with one mm_cid\n",
+			what, (long)(counted - total), (long)counted);
+		ret = CHILD_FAIL;
+	}
+	return ret;
+}
+
+static void init_workers(void)
+{
+	int i;
+
+	for (i = 0; i < MAX_WORKERS; i++)
+		workers[i].bad_cid = UINT_MAX;
+}
+
+/*
+ * A file no binfmt handler recognises, in @dir. execve(2) on it fails with
+ * ENOEXEC after sched_mm_cid_before_execve() and before the other threads
+ * are killed.
+ */
+static int make_unknown_format_file(const char *dir)
+{
+	static const char junk[] = "not a binary of any known format\n";
+	char *const av[] = { exec_path, NULL };
+	bool written;
+	int fd;
+
+	snprintf(exec_path, sizeof(exec_path), "%s/mm_cid_transition_test.XXXXXX", dir);
+	fd = mkstemp(exec_path);
+	if (fd < 0)
+		goto fail;
+	written = write(fd, junk, sizeof(junk) - 1) == (ssize_t)sizeof(junk) - 1 &&
+		  !fchmod(fd, 0755);
+	if (close(fd) || !written)
+		goto unlink;
+	if (execve(exec_path, av, NULL) == -1 && errno == ENOEXEC)
+		return 0;
+unlink:
+	remove_file(exec_path);
+fail:
+	exec_path[0] = '\0';
+	return -1;
+}
+
+/* Rounds of 1 to MAX_WORKERS threads: the count crosses both thresholds. */
+static int run_child_rounds(int unused)
+{
+	int round, ret;
+
+	init_workers();
+	/* Without the file the rounds run with no execve. */
+	if (make_unknown_format_file("/tmp") && make_unknown_format_file("."))
+		fprintf(stderr, "no unknown format file: the rounds run without execve\n");
+	for (round = 0; round < ROUNDS; round++) {
+		if (run_round(1 + (round * 7) % MAX_WORKERS, -1)) {
+			ret = CHILD_ERROR;
+			goto out;
+		}
+	}
+	ret = check_counts("thread count changes");
+out:
+	if (exec_path[0] && remove_file(exec_path) && ret == CHILD_PASS)
+		ret = CHILD_ERROR;
+	return ret;
+}
+
+/* Run one round that widens the allowed CPUs @delay_us after its start. */
+static int run_child_widen(int delay_us)
+{
+	init_workers();
+	if (run_round(3, delay_us))
+		return CHILD_ERROR;
+	return check_counts("affinity change");
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
+/*
+ * Run @fn(@arg) in a new process and return its exit status. The affinity
+ * is @narrow when its mm is created. The union of allowed CPUs of an mm
+ * starts there and only grows.
+ */
+static int run_under_test(int (*fn)(int), int arg, const cpu_set_t *narrow)
+{
+	int status = 0;
+	pid_t child;
+
+	if (sched_setaffinity(0, sizeof(*narrow), narrow))
+		ksft_exit_skip("sched_setaffinity: %s\n", strerror(errno));
+	child = fork();
+	if (!child)
+		_exit(fn(arg));
+	if (child < 0)
+		ksft_exit_fail_msg("fork: %s\n", strerror(errno));
+	if (sched_setaffinity(0, sizeof(all_cpus), &all_cpus))
+		ksft_exit_fail_msg("sched_setaffinity: %s\n", strerror(errno));
+	if (waitpid(child, &status, 0) != child)
+		ksft_exit_fail_msg("waitpid: %s\n", strerror(errno));
+	if (!WIFEXITED(status))
+		ksft_exit_fail_msg("the process under test was killed by signal %d\n",
+				   WTERMSIG(status));
+	if (WEXITSTATUS(status) > CHILD_FAIL)
+		ksft_exit_fail_msg("the process under test failed to run\n");
+	return WEXITSTATUS(status);
+}
+
+int main(void)
+{
+	cpu_set_t narrow;
+	int status, i;
+
+	ksft_print_header();
+	ksft_set_plan(3);
+
+	if (!rseq_available())
+		ksft_exit_skip("rseq is unavailable\n");
+	if (rseq_register_current_thread())
+		ksft_exit_fail_msg("rseq_register_current_thread: %s\n", strerror(errno));
+	if (!rseq_mm_cid_available())
+		ksft_exit_skip("the rseq mm_cid field is unavailable\n");
+	if (sched_getaffinity(0, sizeof(all_cpus), &all_cpus))
+		ksft_exit_fail_msg("sched_getaffinity: %s\n", strerror(errno));
+	nr_possible = read_nr_possible();
+	if (nr_possible <= 0)
+		ksft_exit_skip("cannot read the possible CPUs\n");
+
+	narrow_cpus(&narrow, &all_cpus, 4);
+	status = run_under_test(run_child_rounds, 0, &narrow);
+	ksft_test_result(status == CHILD_PASS, "thread count changes on at most 4 CPUs\n");
+
+	status = run_under_test(run_child_rounds, 0, &all_cpus);
+	ksft_test_result(status == CHILD_PASS, "thread count changes on all CPUs\n");
+
+	narrow_cpus(&narrow, &all_cpus, 2);
+	for (i = 0; i < WIDEN_RUNS; i++) {
+		status = run_under_test(run_child_widen, (i * 13) % ROUND_US, &narrow);
+		if (status != CHILD_PASS)
+			break;
+	}
+	ksft_test_result(status == CHILD_PASS, "affinity change widens the allowed CPUs\n");
+	ksft_finished();
+}
-- 
2.47.3


