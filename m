Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE41606D817
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=sBNvnRDU
Received: by kanga.kvack.org (Postfix)
	id 212D96B05BB; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14DE46B05C0; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBAD96B05BB; Tue, 17 Nov 2026 11:17:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF93E6B05C0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:17:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30F46A044A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:26 +0000 (UTC)
X-FDA: 85445116092.21.5196596
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf16.hostedemail.com (Postfix) with ESMTP id 873D3180006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=sBNvnRDU;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zA50NO8diNXtmj/QR5ldq+XzZ/uf0YOZF4/8yLEzJ8M=;
	b=PL3XYBmSBkdoolAe1zmRjxfYpltppkNRcfZmLOYdytkQ/UY6T2WXIRcqsi/js8jyBvaRWT
	Dd9ky1vVG9f+1OfkKTUaIfEiS6MXIEt5/3O2JZkx4rDoP3GBFFlD0FfxStfJSkWerfBR3i
	AVYL8FdYH5x0rf57e8twdFQIltTvJ6g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=sBNvnRDU;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932244;
	b=nn2wLAvrmuwJln6/c6ESf8nfeoXj/c+SWleXA7YipHGiIKcEl8r5BdbeIDgNSZ/OKBJwi5
	OhUKRnJPRknyoN8jwwz+W6ubImud9+O2+q/DFp4h3WL0NjxE4Ue9MrXngqO4H2T7BJQYhx
	pBSaldynOSQEjv2/c4o9JVgLZHGQJS4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794932243;
	bh=zA50NO8diNXtmj/QR5ldq+XzZ/uf0YOZF4/8yLEzJ8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBNvnRDU06WkIOqmxy7jtew9RdDZJEy6Akbsb+p3GCzQmq8rxsTBKAdTGjCAytGHK
	 uA6nhPLtRAozxGGsRqFHxruljeyWUHL+qLOKv0B953/moT8oYutYu0TLY5Ok/TiYAw
	 dGZGMaVsZfQqLFeKGYRK46wEe/7RFZIFAvIphpxug5wHywVulXe1Rze43IS64+OKow
	 6t5YtlOSBUz1YCvV/8dAKkdcpDjomqK1R45SvIndOtAmntKrPzCvbt122m0605UE2b
	 x6S8yFZUh2eIzFJMqdlbM/2aS4q+0bEpY5mwlrGhEes0CGVJZOkkoA8T9PeQkmb+K7
	 a/R6QU3refw3Q==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTVHl0fdqzRZW;
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
Subject: [PATCH 10/17] selftests/rseq: Test the upper bound of the concurrency IDs
Date: Tue, 17 Nov 2026 11:17:10 -0500
Message-Id: <39f43aa9adf605d2ce187ff2af504dcffe3ff9c7.1794932121.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 873D3180006
X-Rspam-User: 
X-Stat-Signature: 96ihy8o7i96s35pq9kf8apidqa9t7fif
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794932244-132840
X-HE-Meta: U2FsdGVkX1+ceMIaO7lksDeEUw0IB3wvTmQTY2sI9DXgEvF7BEd+LuTQhiWkBEjX2yMOf7/ksaszMe05WJcL5y6dKKdjaZ0amZx7dJWETqRMy+liEdSUST9nk1AWgO+xQXr4+CLAywGu6yve86Xv9huV3spcJDPU7b9BOeMoVO3xsFWX+62q0QQu8t/ucVi8EskAScyLi76+3M5PsaKIKvraU690ll9UYPpqff9t+iJu7bU1E+zKTE5Mp8y2pEKawEITqtjFVS+cCS5nTFhKWWcIzBWE9BA6o5UnNBN5w7G0uZJ45iH2CHLGcjRut7XsaAy650JBCV3W90nbnDgp5EePPg9Tz3ho46Lj635NzJ2chWzbGwO+4crXiV4xcKjOzPIcd9UR7SlvM1KUvB4snwUm3mBsFb/x266xcAiVS7ODVXof3IG/VyEzCjVdfxhVVw884QI9cV7tJcJypf0Rdi/R5PFLE3ao8PQjN/SLuSECPHZ8kkssqjP1CVTiF1vbMR69jMjEUYIY70N1CuiVQhRXA77U+EIBgP5Kn//k1qBLOx5o95xVZ2T8mNcriAotMs4fg67kwgiS1+r3WW/O0RYSNVerRUjR4vAh7scAmnI3xeUyTFbKkq90oPFMfS3w/jy50a3LwwWQwVwWczQJGY4QW9AJytuT9BcHAxaVkNMrKmzjxuWHNX1pLOZ7RfOZeV5XXBDjOzWbrtkEq7eoafGWmpr1PtggvRfABwPlBQJ8fdqEe8MHl8A7LGp7N7ctcorNiE99cbkXR+sf3tvXpAJrK7FPKsqXlCAtEkH6P+0EwCVZLhd3PK/yspMnLW3OaSUGJISu0MxHXx3RsQT6u1xY2k0vO8suWVv1zX760/dF9dfWbKTMs4VioSJnJwBRVATJL/zs4PRvPRc1MeD0q86jKR3+0IiXSLuEyqpBHG3NUmw2xOoz+ASjnTCt9Vl1R/8ECNLMBr8accgsoOG
 qRqIRMoW
 6QRzr0fkoDkWZdN+gcpyqnGUQJ6FjVb94gkJXtBgKUnHocgDdBbmqSfIC4npfGW4iflrbKcZ7gecgwlxBPF4naTZE7ABlp4HEOAL2SjFJeAlwGLfeoy+C1rBuuuXIempfgnvwiGVuwgC4ma5yemrfM2iKqxByM1ZV/4OAs90kvbexHtNTNVu6eA5OlcP5x+jCsToRc5VeR1jzUfvK0x4wtZl9w0PoiF48+uhrxj7d209fvOzaWM7YK/ztqwghApAbc3pO53bc299WQzhzOUmxDhIQ7k9NIScN6+he1qLJ1kV60T0V73aS/M9IOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

No test checks how large an mm_cid gets when the thread count of a
process changes.

The upper bound of an mm_cid is the number of possible CPUs. The kernel
also aims at compact IDs. Its target is max_cids:

  opt_cids = min(threads, allowed CPUs)
  max_cids = min(opt_cids + opt_cids / 4, possible CPUs)

The slack above opt_cids gives the switch between per task and per CPU
mode some hysteresis. Threads that come and go near the limit then do
not cause a costly mode switch each time.

Add mm_cid_bound_test. A process grows from one thread to twice its
CPUs plus two, then shrinks back to one. After each step every thread
visits every allowed CPU and reads its mm_cid there. The largest value
must stay below the number of possible CPUs.

The test also prints the steps where the largest value is above
max_cids, or above min(threads, allowed CPUs). These steps do not make
it fail.

The test runs on 2 CPUs, on 4 CPUs and on all the allowed CPUs. It
passes on every guest tried, from 2 to 64 CPUs.

The printed steps show how far the IDs go above the target. In per CPU
mode each CPU keeps the ID it owns. The mode is left only when the
thread count drops below mm_cid_calc_pcpu_thrs(): three quarters of the
allowed CPUs, capped at half the possible ones. On a 64-CPU guest, on
the way down:

  35 threads on 64 CPUs: largest mm_cid 63 on CPU 62, max_cids 43

In per task mode the allowance of max_cids shows:

  20 threads on 64 CPUs: largest mm_cid 24 on CPU 63, max_cids 25

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 tools/testing/selftests/rseq/.gitignore       |   1 +
 tools/testing/selftests/rseq/Makefile         |   3 +-
 .../selftests/rseq/mm_cid_bound_test.c        | 355 ++++++++++++++++++
 3 files changed, 358 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/rseq/mm_cid_bound_test.c

diff --git a/tools/testing/selftests/rseq/.gitignore b/tools/testing/selftests/rseq/.gitignore
index e8afb37121d7..ff63ada38d5f 100644
--- a/tools/testing/selftests/rseq/.gitignore
+++ b/tools/testing/selftests/rseq/.gitignore
@@ -9,6 +9,7 @@ param_test_compare_twice
 param_test_mm_cid
 param_test_mm_cid_benchmark
 param_test_mm_cid_compare_twice
+mm_cid_bound_test
 mm_cid_execve_test
 mm_cid_transition_test
 syscall_errors_test
diff --git a/tools/testing/selftests/rseq/Makefile b/tools/testing/selftests/rseq/Makefile
index ac32d6af3b99..b643ce9cb585 100644
--- a/tools/testing/selftests/rseq/Makefile
+++ b/tools/testing/selftests/rseq/Makefile
@@ -20,7 +20,8 @@ OVERRIDE_TARGETS = 1
 
 TEST_GEN_PROGS = basic_test basic_percpu_ops_test basic_percpu_ops_mm_cid_test \
 		 param_test_benchmark param_test_mm_cid_benchmark \
-		 mm_cid_execve_test mm_cid_transition_test
+		 mm_cid_execve_test mm_cid_transition_test \
+		 mm_cid_bound_test
 
 TEST_GEN_PROGS_EXTENDED = librseq.so \
 	param_test \
diff --git a/tools/testing/selftests/rseq/mm_cid_bound_test.c b/tools/testing/selftests/rseq/mm_cid_bound_test.c
new file mode 100644
index 000000000000..11332b9ff24b
--- /dev/null
+++ b/tools/testing/selftests/rseq/mm_cid_bound_test.c
@@ -0,0 +1,355 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * The upper bound of the concurrency IDs while the thread count changes.
+ *
+ * A process grows to more threads than it has CPUs, then shrinks back to
+ * one thread. After each step every thread visits every allowed CPU and
+ * reads its mm_cid there. The largest value must stay below the number of
+ * possible CPUs. That is the upper bound of an mm_cid, and it sizes the
+ * per-CID data of user space.
+ *
+ * The kernel also aims at compact IDs. Its target is max_cids:
+ *
+ *     opt_cids = min(threads, allowed CPUs)
+ *     max_cids = min(opt_cids + opt_cids / 4, possible CPUs)
+ *
+ * The slack above opt_cids gives the switch between the two ownership
+ * modes some hysteresis. Threads that come and go near the limit then do
+ * not cause a costly mode switch each time.
+ *
+ * The test prints the steps where the largest mm_cid is above max_cids,
+ * or above min(threads, allowed CPUs). They do not make it fail.
+ *
+ * The steps cross both ownership modes of the kernel. The tasks own the
+ * IDs at first. The CPUs own them once there are more threads than
+ * max_cids. The tasks own them again once the thread count drops below a
+ * threshold.
+ *
+ * The number of IDs follows the union of the allowed CPUs of the threads,
+ * which only grows. The affinity is therefore narrowed before the fork(2)
+ * that creates the process under test.
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <pthread.h>
+#include <sched.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "rseq.h"
+#include "kselftest.h"
+
+#define MAX_THREADS	1024
+#define MAX_STEPS	64
+
+/*
+ * Exit status of the process under test: a mask of the bound and of the
+ * targets exceeded.
+ */
+#define OVER_POSSIBLE	1
+#define OVER_MAX_CIDS	2
+#define OVER_STRICT	4
+#define CHILD_ERROR	64
+
+struct worker {
+	pthread_t	thread;
+	int		stop;
+	unsigned int	ack;
+	unsigned int	max_cid;
+	int		max_cpu;
+};
+
+static struct worker workers[MAX_THREADS];
+static unsigned int epoch;
+static cpu_set_t allowed;
+static int nr_allowed;
+static int nr_possible;
+
+/* Visit each allowed CPU and record the largest mm_cid read there. */
+static void tour(struct worker *w)
+{
+	cpu_set_t one;
+	int cpu;
+
+	w->max_cid = 0;
+	w->max_cpu = -1;
+	for (cpu = 0; cpu < CPU_SETSIZE; cpu++) {
+		unsigned int cid;
+
+		if (!CPU_ISSET(cpu, &allowed))
+			continue;
+		CPU_ZERO(&one);
+		CPU_SET(cpu, &one);
+		if (sched_setaffinity(0, sizeof(one), &one))
+			continue;
+		cid = rseq_current_mm_cid();
+		if (cid >= w->max_cid) {
+			w->max_cid = cid;
+			w->max_cpu = cpu;
+		}
+	}
+	if (sched_setaffinity(0, sizeof(allowed), &allowed)) {
+		fprintf(stderr, "sched_setaffinity: %s\n", strerror(errno));
+		abort();
+	}
+}
+
+static void *worker_fn(void *arg)
+{
+	struct worker *w = arg;
+	unsigned int seen = RSEQ_READ_ONCE(w->ack);
+
+	if (rseq_register_current_thread())
+		abort();
+	while (!RSEQ_READ_ONCE(w->stop)) {
+		unsigned int e = RSEQ_READ_ONCE(epoch);
+
+		if (e == seen) {
+			usleep(200);
+			continue;
+		}
+		tour(w);
+		seen = e;
+		/* Publish max_cid and max_cpu to measure(). */
+		rseq_smp_store_release(&w->ack, e);
+	}
+	rseq_unregister_current_thread();
+	return NULL;
+}
+
+/* Run one tour on every thread. Return the largest mm_cid, and its CPU. */
+static unsigned int measure(int nr_workers, int *cpu)
+{
+	unsigned int e = RSEQ_READ_ONCE(epoch) + 1;
+	unsigned int max_cid;
+	struct worker self;
+	int i;
+
+	RSEQ_WRITE_ONCE(epoch, e);
+	tour(&self);
+	max_cid = self.max_cid;
+	*cpu = self.max_cpu;
+	for (i = 0; i < nr_workers; i++) {
+		while (rseq_smp_load_acquire(&workers[i].ack) != e)
+			usleep(200);
+		if (workers[i].max_cid > max_cid) {
+			max_cid = workers[i].max_cid;
+			*cpu = workers[i].max_cpu;
+		}
+	}
+	return max_cid;
+}
+
+/*
+ * Create or join threads to reach @target. Return 0, or the error number
+ * after reporting it.
+ */
+static int set_workers(int *nr_workers, int target)
+{
+	int err;
+
+	while (*nr_workers < target) {
+		struct worker *w = &workers[*nr_workers];
+
+		w->stop = 0;
+		w->ack = RSEQ_READ_ONCE(epoch);
+		err = pthread_create(&w->thread, NULL, worker_fn, w);
+		if (err) {
+			fprintf(stderr, "pthread_create: %s\n", strerror(err));
+			return err;
+		}
+		(*nr_workers)++;
+	}
+	while (*nr_workers > target) {
+		struct worker *w = &workers[*nr_workers - 1];
+
+		RSEQ_WRITE_ONCE(w->stop, 1);
+		err = pthread_join(w->thread, NULL);
+		if (err) {
+			fprintf(stderr, "pthread_join: %s\n", strerror(err));
+			return err;
+		}
+		(*nr_workers)--;
+	}
+	return 0;
+}
+
+static unsigned int min_u(unsigned int a, unsigned int b)
+{
+	return a < b ? a : b;
+}
+
+/* The process under test. Return a mask of the OVER_* values. */
+static int run_child(const int *steps, int nr_steps)
+{
+	int nr_workers = 0, ret = 0, i;
+
+	if (sched_getaffinity(0, sizeof(allowed), &allowed))
+		return CHILD_ERROR;
+	nr_allowed = CPU_COUNT(&allowed);
+
+	for (i = 0; i < nr_steps; i++) {
+		unsigned int threads = steps[i], opt, max_cids, strict, cid;
+		int cpu, over = 0, err;
+
+		err = set_workers(&nr_workers, threads - 1);
+		if (err) {
+			ret |= CHILD_ERROR;
+			break;
+		}
+		/* The first tour lets every thread schedule on every CPU. */
+		measure(nr_workers, &cpu);
+		cid = measure(nr_workers, &cpu);
+
+		opt = min_u(threads, nr_allowed);
+		strict = opt;
+		max_cids = min_u(opt + opt / 4, nr_possible);
+		if (cid >= (unsigned int)nr_possible)
+			over |= OVER_POSSIBLE;
+		if (cid >= max_cids)
+			over |= OVER_MAX_CIDS;
+		if (cid >= strict)
+			over |= OVER_STRICT;
+		ksft_print_msg(
+			"%4u threads on %d CPUs: largest mm_cid %u on CPU %d, max_cids %u, min(threads, CPUs) %u%s%s%s\n",
+			       threads, nr_allowed, cid, cpu, max_cids, strict,
+			       over & OVER_STRICT ? ", above the min(threads, CPUs) target" : "",
+			       over & OVER_MAX_CIDS ? ", above the max_cids target" : "",
+			       over & OVER_POSSIBLE ? ", at or above the possible CPUs" : "");
+		ret |= over;
+	}
+	if (set_workers(&nr_workers, 0))
+		ret |= CHILD_ERROR;
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
+/* Thread counts from 1 up to twice the CPUs plus two, and back to 1. */
+static int make_steps(int *steps, int cpus)
+{
+	int top = 2 * cpus + 2, stride = 1, n = 0, t;
+
+	if (top > MAX_THREADS)
+		top = MAX_THREADS;
+	/* Every count on a small set of CPUs, a fraction on a large one. */
+	while (2 * (top / stride) + 1 > MAX_STEPS)
+		stride++;
+	for (t = 1; t < top; t += stride)
+		steps[n++] = t;
+	steps[n++] = top;
+	for (t = top - stride; t > 1; t -= stride)
+		steps[n++] = t;
+	steps[n++] = 1;
+	return n;
+}
+
+static void test_ramp(const cpu_set_t *all, int cpus, const char *name)
+{
+	int steps[MAX_STEPS + 2], nr_steps, status = 0;
+	cpu_set_t narrow;
+	pid_t child;
+
+	if (narrow_cpus(&narrow, all, cpus) < cpus) {
+		ksft_test_result_skip("%s: below the possible CPUs\n", name);
+		return;
+	}
+	nr_steps = make_steps(steps, cpus);
+
+	/* Narrowed before the fork(2): the union of allowed CPUs only grows. */
+	if (sched_setaffinity(0, sizeof(narrow), &narrow))
+		ksft_exit_fail_msg("sched_setaffinity: %s\n", strerror(errno));
+	child = fork();
+	if (!child)
+		_exit(run_child(steps, nr_steps));
+	if (child < 0)
+		ksft_exit_fail_msg("fork: %s\n", strerror(errno));
+	if (sched_setaffinity(0, sizeof(*all), all))
+		ksft_exit_fail_msg("sched_setaffinity: %s\n", strerror(errno));
+	if (waitpid(child, &status, 0) != child)
+		ksft_exit_fail_msg("waitpid: %s\n", strerror(errno));
+	if (!WIFEXITED(status) || (WEXITSTATUS(status) & CHILD_ERROR))
+		ksft_exit_fail_msg("the process under test failed to run\n");
+
+	status = WEXITSTATUS(status);
+	/* The targets are reported. Only the bound decides the result. */
+	if (status & OVER_MAX_CIDS)
+		ksft_print_msg("%s: some steps are above the max_cids target\n", name);
+	if (status & OVER_STRICT)
+		ksft_print_msg("%s: some steps are above min(threads, CPUs)\n", name);
+	ksft_test_result(!(status & OVER_POSSIBLE),
+			 "%s: below the possible CPUs\n", name);
+}
+
+int main(void)
+{
+	cpu_set_t all;
+	int nr_all;
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
+	if (sched_getaffinity(0, sizeof(all), &all))
+		ksft_exit_fail_msg("sched_getaffinity: %s\n", strerror(errno));
+	nr_possible = read_nr_possible();
+	if (nr_possible <= 0)
+		ksft_exit_skip("cannot read the possible CPUs\n");
+	nr_all = CPU_COUNT(&all);
+	ksft_print_msg("%d possible CPUs, %d allowed\n", nr_possible, nr_all);
+
+	test_ramp(&all, 2, "2 CPUs");
+	test_ramp(&all, 4, "4 CPUs");
+	test_ramp(&all, nr_all, "all CPUs");
+	ksft_finished();
+}
-- 
2.47.3


