Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C695606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=NqsimjG6
Received: by kanga.kvack.org (Postfix)
	id 6F7896B05BD; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656696B05C4; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5930F6B05C5; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FD896B05BD
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 987AF80508
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:26 +0000 (UTC)
X-FDA: 85445116092.14.BF93981
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0D83940007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=NqsimjG6;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf12.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CREz4BtGzSVwVl79tOXEQVEzt5xSqBMaf51OCNp4CUM=;
	b=trY0MsD2dfRvuwmp7a8/SOE/FBpX1iFogyCJfdq0oELUECuVfhI3INks0tVOV5PgB9M21q
	3EjJYdf6ZpjmcdRBkZjzbNhzfNKz+/s4qnJWp7aCcTZnHc3dsXfEqmWVYZL6UtoQLFTxlp
	QeBal1eTMcLTw3w+QSHq+dPmcg8MF7c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=NqsimjG6;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf12.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932245;
	b=jCxzQLcMYjv53kN9m+j18OdBlka9cGVjYob/t+VTtDN3H8wx0eaefsWk/jnBXuTaTRPpDe
	HxNxqHYoEaE1sJ7WppWYNfdCLdAPgm+UZZr/pw1d5qa+eFtNuJ7wdsYM+PKvkgxbCjtVrj
	TLMJYb0BNA6gAsl40khnkHOWnoAmipE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794932243;
	bh=CREz4BtGzSVwVl79tOXEQVEzt5xSqBMaf51OCNp4CUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqsimjG61T+sm2k+Y1EiM9ElrNotuEK/OHtpkgl6wJ9AhbVWGIaWDAqJ19Kpio0Kk
	 bZJfWcKrlWIZi4j+55TKBzifg9AH6Em1dkx2vEJ/uvVqdq4PgfOmr0espdZC0cxB29
	 jQjZ7IKUmn3GE8qexAty4x148dgdi1daPk6O6Qoi9lpA/Wh2sQiYzq0NdGKgRM5N8M
	 ITKjNdJJBqovEsBV0voY5RY99fj+YndVtORVvbc0zUGTATrKaoXLZuwu2P2SJN9rZC
	 oaEnuVKXtesTsNxuhsOTpbpdrIE20a/lQU3x4lIBrqlzsS3hWVRWfmBRSX4vg63y+b
	 OkMlmAel3a+Tg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTVHl3zkzzRZY;
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
Subject: [PATCH 13/17] selftests/rseq: Test concurrent thread creation and forced migration
Date: Tue, 17 Nov 2026 11:17:13 -0500
Message-Id: <d4aabd0faed808d6acd1a2a59e88ec98546a17f8.1794932121.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y7txmasj1fxnc3fhwshchd6jspbrbsgt
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0D83940007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794932244-350542
X-HE-Meta: U2FsdGVkX1+9WhaB/sqDdj6VuhIeSAcZyE5wvLIGbbCuJQ1iA2q0bfT81zuYu/rCIMcaLeilX6500iV1FPAMjpheZuwjl0UK2sjre5uMz9elDreRio1Jqjqi3iFUkq3CetijesnKJh6Ec3N1ryKpVXL/mlL2Sg+mjoEo3GVlGwwyky5Y90QG2VF44NpVuz6z66afTOzhD7ANfttTL5zete2LOyybVgeegfTaZh/IXRzqco7oWHwX0zNj9hf2dMWkzIk21T8AmDNOwkwdHTUK4fHcc4WXXNsoeJkI2FOhUSAu8daPK8/PdnSA1BaI41wIKqNys0hi0ZvAThZPwmrQv2hPToaImpM4ZfSAj1vdjicKxOD3CWSJeErCQkzz94u2JSfjB6ndC6Xgo/TOap+btoJgA5Bjbt/5340jSVc117d8ledK6jXjKEFlejF215RrhZYCv9TOtGzd967p+2c8WpkJCgAhe3R1Bheqk0KoY0kshYSqL3lwnc05exegkkrsorLpvdbODej782nIyC5FpMw7h7tFb1v8IfIiQhgNGfwF2Nwv3KsucsdAkSkmRWwXevee1j0ER978ajIlpyhp+M9A5v6CB9ktee/IRySGtG930kUxCDeNHzGGb60w7H7fr/s94jdigyQGHOgqhpDN1uy5KHlkSBCYdpbTL5XF63BJV06rCyI0qELHMKrZhoVZFkdDHLkMLSTRzv438sd9JXmzFyTcLAEj0MmuzdNt0vBkUAzyqbUF1/m6y1STAugQ6q625ERGE/eKDPxuZYfPr+UfbsLwUTElfh2STGlfg1KfQybBaQFPbcX7b1oVaiV2dWON0FKWSZsOrlBJkDgeXa6WD+uGQxrQYEHMJ9bZjEB/7ItHPqdAJtd+2SvavKr5n3qsaUqJRZFL6AQaQwsI8ssQVIkTlr7yQ6BpLQ0LWc8h1YS5vgREcHh3Ncd1QOZkTPMi9OuPXzo1/MyosHQ
 j5XoY01i
 yC1FJFNNAs7HK+uMdJzctOKb2VpAGkIck2cxnFwNuc2amICiXXOeGM7YUcpbmk4nxaFqpW4oTDyw4dfcsmEKe+o+sXQrazQ0kql+3z7i8EirbwXB03gKxCnmpyv4PfGk7ACnLAMONq8/F13DzLmd/o3aAiP2J/2ZkCGypkUcb50KxV307Y9JYYGaYrFRBjlA8KMS4S3+yCfovPN4WEXWFitcx8avGqoFM0kAhHB1dOHptmYsl4BA8cSdMtKpXweKzcaxBKpQ8KIeMLCgrEBXm/C5MIRzy4iVi1Rn2NJBzYkh/yxVu7E5lfLjPNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Two fixes that followed the rework of the concurrency IDs point at cases
no test covers:

  - commit b2e48c429ec5 ("sched/mmcid: Prevent CID stalls due to
    concurrent forks") fixed two tasks that join an mm at the same
    time;
  - commit 4327fb13fa47 ("sched/mmcid: Prevent live lock on task to CPU
    mode transition") fixed a task that migrates while the mm switches
    to per CPU mode.

In mm_cid_transition_test only the main thread creates threads, and no
thread is moved to another CPU while the thread count changes.

Add two cases. Both repeat the rounds of 1 to 16 threads on at most
four CPUs:

  - In the first one, most threads create a thread of their own when
    they start. Several threads then join the mm at the same time.
  - In the second one, another process pins every thread to one CPU
    after another in a loop. The threads migrate while the mode
    switches in both directions.

Both cases pass on guests with 2 to 64 CPUs, with and without the
previous fixes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../selftests/rseq/mm_cid_transition_test.c   | 173 ++++++++++++------
 1 file changed, 121 insertions(+), 52 deletions(-)

diff --git a/tools/testing/selftests/rseq/mm_cid_transition_test.c b/tools/testing/selftests/rseq/mm_cid_transition_test.c
index fa26be14950c..ccedec71fd6d 100644
--- a/tools/testing/selftests/rseq/mm_cid_transition_test.c
+++ b/tools/testing/selftests/rseq/mm_cid_transition_test.c
@@ -24,6 +24,11 @@
  * and widens every thread in a loop, while the threads count, call
  * vfork(2) and then exit with their process.
  *
+ * Two more cases repeat the rounds. In one, most threads create a thread
+ * of their own, so that several threads join the mm at the same time. In
+ * the other, another process moves every thread from CPU to CPU, so that
+ * threads migrate while the mode switches.
+ *
  * The test fails when counts are lost, or when an mm_cid is not below the
  * number of possible CPUs. A kernel that loops looking for a free ID
  * shows as a timeout.
@@ -55,6 +60,7 @@
 #define WIDEN_RUNS	100
 #define ROUND_US	500
 #define MAX_TRIES	1000000
+#define MAX_SETS	4
 
 #define CHILD_PASS	0
 #define CHILD_FAIL	1
@@ -66,10 +72,16 @@ struct worker {
 	unsigned int	bad_cid;
 	bool		execs;
 	bool		vforks;
+	struct worker	*buddy;
 };
 
+/* run_child_rounds() flags */
+#define NESTED		1
+#define MIGRATED	2
+
 static intptr_t counts[MAX_CIDS];
-static struct worker workers[MAX_WORKERS];
+static struct worker workers[2 * MAX_WORKERS];
+static bool nested;
 static int stop;
 static int nr_possible;
 static cpu_set_t all_cpus;
@@ -115,14 +127,34 @@ static int remove_file(const char *path)
 	return 0;
 }
 
+static void *worker_fn(void *arg);
+
+/* Start the thread of @w. Return 0 or an error number. */
+static int create_worker(struct worker *w)
+{
+	int err, tries = 0;
+
+	/* clone(CLONE_FS) fails with EAGAIN while a thread is in execve. */
+	do {
+		err = pthread_create(&w->thread, NULL, worker_fn, w);
+		if (err == EAGAIN)
+			sched_yield();
+	} while (err == EAGAIN && ++tries < MAX_TRIES);
+	return err;
+}
+
 static void *worker_fn(void *arg)
 {
 	struct worker *w = arg;
 	char *const av[] = { exec_path, NULL };
+	bool has_buddy = false;
 	int i;
 
 	if (rseq_register_current_thread())
 		abort();
+	/* Other workers do the same now: several threads join at once. */
+	if (w->buddy)
+		has_buddy = !create_worker(w->buddy);
 	while (!RSEQ_READ_ONCE(stop) && w->bad_cid == UINT_MAX) {
 		for (i = 0; i < 100; i++)
 			count_one(w);
@@ -141,6 +173,8 @@ static void *worker_fn(void *arg)
 			}
 		}
 	}
+	if (has_buddy)
+		join_thread(w->buddy->thread);
 	rseq_unregister_current_thread();
 	return NULL;
 }
@@ -152,17 +186,11 @@ static int run_round(int nr, int widen_us)
 
 	RSEQ_WRITE_ONCE(stop, 0);
 	for (i = 0; i < nr; i++) {
-		int err, tries = 0;
-
 		workers[i].execs = i == 0 && exec_path[0];
 		workers[i].vforks = i == 1;
-		/* clone(CLONE_FS) fails with EAGAIN while a thread is in execve. */
-		do {
-			err = pthread_create(&workers[i].thread, NULL, worker_fn, &workers[i]);
-			if (err == EAGAIN)
-				sched_yield();
-		} while (err == EAGAIN && ++tries < MAX_TRIES);
-		if (err)
+		/* The two workers above keep to their own loop. */
+		workers[i].buddy = nested && i > 1 ? &workers[MAX_WORKERS + i] : NULL;
+		if (create_worker(&workers[i]))
 			break;
 		started++;
 	}
@@ -187,7 +215,7 @@ static int check_counts(const char *what)
 	intptr_t counted = 0, total = 0;
 	int i, ret = CHILD_PASS;
 
-	for (i = 0; i < MAX_WORKERS; i++) {
+	for (i = 0; i < 2 * MAX_WORKERS; i++) {
 		counted += workers[i].counted;
 		if (workers[i].bad_cid != UINT_MAX) {
 			fprintf(stderr, "%s: mm_cid %u (0x%x), %d possible CPUs\n",
@@ -209,7 +237,7 @@ static void init_workers(void)
 {
 	int i;
 
-	for (i = 0; i < MAX_WORKERS; i++)
+	for (i = 0; i < 2 * MAX_WORKERS; i++)
 		workers[i].bad_cid = UINT_MAX;
 }
 
@@ -242,12 +270,76 @@ static int make_unknown_format_file(const char *dir)
 	return -1;
 }
 
-/* Rounds of 1 to MAX_WORKERS threads: the count crosses both thresholds. */
-static int run_child_rounds(int unused)
+/*
+ * Change the affinity of every thread of @pid in a loop, from another
+ * process. Each change takes the next of the @nr_sets CPU sets in @sets.
+ * Start after @delay_us and run until @pid exits.
+ */
+static void remote_setter(pid_t pid, int delay_us, const cpu_set_t *sets, int nr_sets)
 {
-	int round, ret;
+	unsigned int next = 0;
+	char path[64];
+
+	/* Die with the process under test, not before its exit. */
+	if (prctl(PR_SET_PDEATHSIG, SIGKILL)) {
+		fprintf(stderr, "prctl(PR_SET_PDEATHSIG): %s\n", strerror(errno));
+		_exit(1);
+	}
+	snprintf(path, sizeof(path), "/proc/%d/task", pid);
+	usleep(delay_us);
+	while (getppid() == pid) {
+		DIR *dir = opendir(path);
+		struct dirent *de;
+
+		if (!dir)
+			break;
+		while ((de = readdir(dir))) {
+			pid_t tid = atoi(de->d_name);
+
+			/* A thread can exit first: ESRCH is expected. */
+			if (tid > 0 &&
+			    sched_setaffinity(tid, sizeof(sets[0]),
+					      &sets[next++ % nr_sets]) &&
+			    errno != ESRCH) {
+				fprintf(stderr, "sched_setaffinity: %s\n", strerror(errno));
+				_exit(1);
+			}
+		}
+		closedir(dir);
+	}
+	_exit(0);
+}
+
+/*
+ * Rounds of 1 to MAX_WORKERS threads: the count crosses both thresholds.
+ * With NESTED in @flags, most threads create one more thread. With
+ * MIGRATED, another process moves the threads between the allowed CPUs.
+ */
+static int run_child_rounds(int flags)
+{
+	static cpu_set_t sets[MAX_SETS];
+	int round, ret, cpu, nr_sets = 0;
+	pid_t self = getpid(), setter;
+	cpu_set_t allowed;
 
 	init_workers();
+	nested = flags & NESTED;
+	if (flags & MIGRATED) {
+		if (sched_getaffinity(0, sizeof(allowed), &allowed))
+			return CHILD_ERROR;
+		/* One set per allowed CPU: the allowed CPUs of the mm stay. */
+		for (cpu = 0; cpu < CPU_SETSIZE && nr_sets < MAX_SETS; cpu++) {
+			if (!CPU_ISSET(cpu, &allowed))
+				continue;
+			CPU_ZERO(&sets[nr_sets]);
+			CPU_SET(cpu, &sets[nr_sets++]);
+		}
+		setter = fork();
+		if (setter < 0)
+			return CHILD_ERROR;
+		if (!setter)
+			remote_setter(self, 0, sets, nr_sets);
+	}
 	/* Without the file the rounds run with no execve. */
 	if (make_unknown_format_file("/tmp") && make_unknown_format_file("."))
 		fprintf(stderr, "no unknown format file: the rounds run without execve\n");
@@ -273,53 +365,23 @@ static int run_child_widen(int delay_us)
 	return check_counts("affinity change");
 }
 
-/*
- * Narrow and widen the affinity of every thread of @pid in a loop, from
- * another process. Start after @delay_us and run until @pid exits.
- */
-static void remote_setter(pid_t pid, int delay_us, const cpu_set_t *narrow)
-{
-	bool widen = true;
-	char path[64];
-
-	/* Die with the process under test, not before its exit. */
-	prctl(PR_SET_PDEATHSIG, SIGKILL);
-	snprintf(path, sizeof(path), "/proc/%d/task", pid);
-	usleep(delay_us);
-	while (getppid() == pid) {
-		DIR *dir = opendir(path);
-		struct dirent *de;
-
-		if (!dir)
-			break;
-		while ((de = readdir(dir))) {
-			pid_t tid = atoi(de->d_name);
-
-			/* A thread can exit first: ESRCH is expected. */
-			if (tid > 0)
-				sched_setaffinity(tid, sizeof(all_cpus),
-						  widen ? &all_cpus : narrow);
-		}
-		closedir(dir);
-		widen = !widen;
-	}
-	_exit(0);
-}
-
 /* Run one round while another process changes the affinity of the threads. */
 static int run_child_remote(int delay_us)
 {
 	pid_t self = getpid(), setter;
-	cpu_set_t narrow;
+	cpu_set_t sets[3];
 
-	if (sched_getaffinity(0, sizeof(narrow), &narrow))
+	/* Two wide changes for a narrow one, so that each thread gets both. */
+	if (sched_getaffinity(0, sizeof(sets[0]), &sets[0]))
 		return CHILD_ERROR;
+	sets[1] = all_cpus;
+	sets[2] = all_cpus;
 	init_workers();
 	setter = fork();
 	if (setter < 0)
 		return CHILD_ERROR;
 	if (!setter)
-		remote_setter(self, delay_us, &narrow);
+		remote_setter(self, delay_us, sets, 3);
 	if (run_round(3, -1))
 		return CHILD_ERROR;
 	/* The setter keeps running while this process exits. */
@@ -403,7 +465,7 @@ int main(void)
 	int status, i;
 
 	ksft_print_header();
-	ksft_set_plan(4);
+	ksft_set_plan(6);
 
 	if (!rseq_available())
 		ksft_exit_skip("rseq is unavailable\n");
@@ -438,5 +500,12 @@ int main(void)
 			break;
 	}
 	ksft_test_result(status == CHILD_PASS, "affinity changed by another process\n");
+
+	narrow_cpus(&narrow, &all_cpus, MAX_SETS);
+	status = run_under_test(run_child_rounds, NESTED, &narrow);
+	ksft_test_result(status == CHILD_PASS, "threads created by several threads at once\n");
+
+	status = run_under_test(run_child_rounds, MIGRATED, &narrow);
+	ksft_test_result(status == CHILD_PASS, "threads migrated by another process\n");
 	ksft_finished();
 }
-- 
2.47.3


