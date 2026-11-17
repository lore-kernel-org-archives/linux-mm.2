Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8FF7606A883
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=NG2k+6pH
Received: by kanga.kvack.org (Postfix)
	id B12FB6B05C5; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEC7E6B05C6; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A956B05C7; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 69A206B05C5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E68D4A04D0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:26 +0000 (UTC)
X-FDA: 85445116092.25.4361C6E
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5F123100012
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=NG2k+6pH;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf14.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBBX73vanCN3RJV6WAoz27bue4rtrM6PSqgvAc6MDVc=;
	b=CskbKeB6SJMgIh693F+r3V7sozbnnJwQCltl+ARyqs8du30jZfzlvDol6Aoes5FyvAB+mr
	t1r5bnGCvLEedoOFG+qF4xHSFHQND4nYU4oDTaxK7OrhS4/LML4XzFvDblrIkruE4v3oc5
	diKvmPbaLYewR6e+fq5wEjGG+IyMZoo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932245;
	b=S9tre/gEHSwUVpQkFH67e44DjyaliqMht2DQoKOYatJq/mlIpgtCCI+/pt3+2XjpBJ1RhM
	RexZuvocoT92RIzKzT0vrQLhTL3n1EzwOlktrt5uylP3W3Dsi5ihT3IcmOJsdWPhX4YNvN
	rogX4ExLkrmxGjDqSZrLq++2Vc6Jw6I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=NG2k+6pH;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf14.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794932243;
	bh=KBBX73vanCN3RJV6WAoz27bue4rtrM6PSqgvAc6MDVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NG2k+6pHGLmiJ1pROyhiRO9WtCXmNEspfqVYKoAs261FAXvbWSi4VCeVJuEmdUBAy
	 TG4PUt02A/nI8SQ8wJ0CVc7vNApcGNlUuvKAJAhBpjJCd754C6IbyWzpoD7/swECRa
	 nxhQi+wEiL8VC7dwuds1SLH/JdM30G2B+ShtwJL/4g+HVtME2yoUFd0bkuWfm7dqD3
	 7OfkMuRPZoMdTmucTQwCtTvsd6xheq1sLRrrPbFGdNDPgvwO81pyDrvm9gtVXiWN53
	 HU12V14+HItceAh8TZv0/1k1bZCZs2s1N6Adp/iNzC92pODB96DOKCLcsR2NCKS7Cq
	 FEzsGNbePradg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTVHl593zzRZZ;
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
Subject: [PATCH 14/17] selftests/rseq: Test the concurrency IDs after the affinity is widened
Date: Tue, 17 Nov 2026 11:17:14 -0500
Message-Id: <05781fc46cb63b548588e58b356ab08b10619aac.1794932121.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5F123100012
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 9xiuiq4ywefpukn838x51f34x6wa7wu9
X-Rspam-User: 
X-HE-Tag: 1794932245-135029
X-HE-Meta: U2FsdGVkX1/O6AGlAApno67GmZxzv7WLxEWnGTI2jmLs6vu7Nsp2G/fR9vUqLy/IiS+/xIpHFnxorsG5FZf3QP1qa6h4PGXrGbS0CsFxWfu5G5QOl6uDk2UCDmAdLQpPKntVc9XvcwS/wiKF5ttuZkE6bhRMfl6VmMCPuP01awUniV13bnIsyATfZb0IQLHx5sVfC6bONfKENrSNL1wpeHR20tnQ0jacnK9JsaP1gCwGOejKKszT65SU7iDTrbydwFzmuR4kW50NcXr2UFD3SWhEKrXcQgzG9e3Dk8YTR5VfCSID3pjJBV7COxu4WGhvXGBNOppUf5DJ1stEUC9RH3ZLfVExQDekUQrd7ilTTOoNQLe1Wixsz+iGPsNCRb98/OTSkCZ9+LwnX3gUXMAdg+e/Mj1jyjBOERsezF5dyWAgGDNtWGwEpCuAj5k+LSla5eY7CZMs/JuFV1ceUZ8Ci/HaodPs1aH8twOIHt91sQAC4Ut8ZnBYtxDASUj9rR1ajY6OkgjR1eHBkPaLo9Qlo7/DGT4RTIa+96cX0O9cNXjFEcMH8320e1lhD4PItrSbDhjdQUeZzp8CnkqgEMLnW2MSD7BsYn1Iie4fRyOVTXHIql+UNCO5fGfKFrrZgDuhouYFR5Cv9ZNA174elSj/fry7vXN94DSIvce0rItzf9Uw/IHpnOOoU5zuafjywwjFNlyRexaZL67186QJ9GeL3muFOiiORFgtKBt0ibJ3aQskz95HC9GMGZbSZO9bLCKs+tUjs94k8GJGKnNFfkAViBo/e4Bn8KSyq5+vSbBFbua5HMRmXa9jzsIPyVd7cBRbj9c/cPCyrAt6JVpe+vBJhI+lmzk9CoCLVusk7v6+io87IM0GV3MYtegC5KsidLCE7QmVK4QTZP+EW42sOBAeoIAcdeQWwti1wUVOV+IufRL81wrifC1GG7EZde/p56+56DAtr5r4k/YFd0DUigM
 e/Q0LJPG
 qCmxv7Bqk2DCOG3BEnDT2rDPw/nosj1LQ033xZ16vS6KhmxNVrsw1OFD/jH/px7P9gJsxBG99gQEHp95efsNwzgeXIQzhp2iRmxkgsoeCNtGR+ErgInmxXFfTq17Uvc9lePIXiDmerLujBdDPeSVJHYio4hNiWQT9vlSLMf13wzT5VMyQHeh5Q34FMJ5sHVlXC8qrSjyzns59DiND60ZYzPqeiewgIDIcH9tP4Nr7QVLHI1VDHb6vltFB5zyzVIZdqdf6i++5YwBu8R4X8BiV+xY0djxOvU0kb4t7VZyhenMOYd9MKbSVLuf8GQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When the allowed CPUs of an mm grow, the kernel can give the
concurrency IDs back to the tasks. Commit 7dbc307b6c72 ("sched/mmcid:
Fix affinity-triggered switch back to per-task mode") fixed a threshold
that kept the CPUs as owners. No test shows it: the tests that widen
the affinity only check that the IDs are unique and in range.

Add a case to mm_cid_bound_test. Three threads start on two CPUs, so
the CPUs own the IDs. The threads are then allowed on all CPUs and
visit each of them. The kernel aims at an mm_cid below 3 for them. That
is a target, not a bound. The case prints when the target is missed. It
fails only when an mm_cid is not below the possible CPUs. The case needs
8 CPUs: with fewer, the kernel keeps the CPUs as owners.

The target is met on guests with 8, 16 and 64 CPUs:

  3 threads widened to 64 CPUs: largest mm_cid 2 on CPU 63

A v7.1.8 kernel with 384 CPUs, which does not have the commit above,
misses it:

  3 threads widened to 384 CPUs: largest mm_cid 383 on CPU 383, above the thread count target

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../selftests/rseq/mm_cid_bound_test.c        | 88 ++++++++++++++++++-
 1 file changed, 87 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rseq/mm_cid_bound_test.c b/tools/testing/selftests/rseq/mm_cid_bound_test.c
index 11332b9ff24b..a751d8929138 100644
--- a/tools/testing/selftests/rseq/mm_cid_bound_test.c
+++ b/tools/testing/selftests/rseq/mm_cid_bound_test.c
@@ -28,6 +28,11 @@
  * The number of IDs follows the union of the allowed CPUs of the threads,
  * which only grows. The affinity is therefore narrowed before the fork(2)
  * that creates the process under test.
+ *
+ * A last case widens the affinity. Three threads start on two CPUs, so the
+ * CPUs own the IDs. The threads are then allowed on all CPUs. The kernel
+ * aims at giving the IDs back to the tasks, so that three threads read an
+ * mm_cid below 3. That is a target too: the case prints when it is missed.
  */
 
 #define _GNU_SOURCE
@@ -46,6 +51,9 @@
 
 #define MAX_THREADS	1024
 #define MAX_STEPS	64
+#define WIDEN_THREADS	3
+#define WIDEN_MIN_CPUS	8
+#define WIDEN_SETTLE_US	20000
 
 /*
  * Exit status of the process under test: a mask of the bound and of the
@@ -67,6 +75,7 @@ struct worker {
 static struct worker workers[MAX_THREADS];
 static unsigned int epoch;
 static cpu_set_t allowed;
+static cpu_set_t all_cpus;
 static int nr_allowed;
 static int nr_possible;
 
@@ -228,6 +237,49 @@ static int run_child(const int *steps, int nr_steps)
 	return ret;
 }
 
+/*
+ * The process under test of the widening case. It starts on two CPUs.
+ * Return a mask of the OVER_* values.
+ */
+static int run_child_widen(void)
+{
+	int nr_workers = 0, ret = 0, cpu, err;
+	unsigned int cid;
+
+	if (sched_getaffinity(0, sizeof(allowed), &allowed))
+		return CHILD_ERROR;
+	nr_allowed = CPU_COUNT(&allowed);
+
+	err = set_workers(&nr_workers, WIDEN_THREADS - 1);
+	if (err)
+		return CHILD_ERROR;
+	measure(nr_workers, &cpu);
+	cid = measure(nr_workers, &cpu);
+	ksft_print_msg("%4d threads on %d CPUs: largest mm_cid %u on CPU %d\n",
+		       WIDEN_THREADS, nr_allowed, cid, cpu);
+
+	/* Each thread widens its own affinity at the end of its next tour. */
+	allowed = all_cpus;
+	nr_allowed = CPU_COUNT(&allowed);
+	if (sched_setaffinity(0, sizeof(allowed), &allowed))
+		ret |= CHILD_ERROR;
+	measure(nr_workers, &cpu);
+	/* The kernel changes the owners of the IDs from a work item. */
+	usleep(WIDEN_SETTLE_US);
+	measure(nr_workers, &cpu);
+	cid = measure(nr_workers, &cpu);
+	if (cid >= (unsigned int)nr_possible)
+		ret |= OVER_POSSIBLE;
+	if (cid >= WIDEN_THREADS)
+		ret |= OVER_STRICT;
+	ksft_print_msg("%4d threads widened to %d CPUs: largest mm_cid %u on CPU %d%s\n",
+		       WIDEN_THREADS, nr_allowed, cid, cpu,
+		       ret & OVER_STRICT ? ", above the thread count target" : "");
+	if (set_workers(&nr_workers, 0))
+		ret |= CHILD_ERROR;
+	return ret;
+}
+
 /* Keep the first @nr CPUs of @src in @dst. */
 static int narrow_cpus(cpu_set_t *dst, const cpu_set_t *src, int nr)
 {
@@ -326,13 +378,46 @@ static void test_ramp(const cpu_set_t *all, int cpus, const char *name)
 			 "%s: below the possible CPUs\n", name);
 }
 
+static void test_widen(const cpu_set_t *all)
+{
+	const char *name = "widened from 2 CPUs: below the possible CPUs";
+	cpu_set_t narrow;
+	int status = 0;
+	pid_t child;
+
+	/* With fewer CPUs the kernel keeps the CPUs as owners of the IDs. */
+	if (CPU_COUNT(all) < WIDEN_MIN_CPUS || nr_possible < WIDEN_MIN_CPUS) {
+		ksft_test_result_skip("%s: fewer than %d CPUs\n", name, WIDEN_MIN_CPUS);
+		return;
+	}
+	narrow_cpus(&narrow, all, 2);
+	all_cpus = *all;
+	if (sched_setaffinity(0, sizeof(narrow), &narrow))
+		ksft_exit_fail_msg("sched_setaffinity: %s\n", strerror(errno));
+	child = fork();
+	if (!child)
+		_exit(run_child_widen());
+	if (child < 0)
+		ksft_exit_fail_msg("fork: %s\n", strerror(errno));
+	if (sched_setaffinity(0, sizeof(*all), all))
+		ksft_exit_fail_msg("sched_setaffinity: %s\n", strerror(errno));
+	if (waitpid(child, &status, 0) != child)
+		ksft_exit_fail_msg("waitpid: %s\n", strerror(errno));
+	if (!WIFEXITED(status) || (WEXITSTATUS(status) & CHILD_ERROR))
+		ksft_exit_fail_msg("the process under test failed to run\n");
+	/* The thread count is a target. Only the bound decides the result. */
+	if (WEXITSTATUS(status) & OVER_STRICT)
+		ksft_print_msg("widened from 2 CPUs: above the thread count target\n");
+	ksft_test_result(!(WEXITSTATUS(status) & OVER_POSSIBLE), "%s\n", name);
+}
+
 int main(void)
 {
 	cpu_set_t all;
 	int nr_all;
 
 	ksft_print_header();
-	ksft_set_plan(3);
+	ksft_set_plan(4);
 
 	if (!rseq_available())
 		ksft_exit_skip("rseq is unavailable\n");
@@ -351,5 +436,6 @@ int main(void)
 	test_ramp(&all, 2, "2 CPUs");
 	test_ramp(&all, 4, "4 CPUs");
 	test_ramp(&all, nr_all, "all CPUs");
+	test_widen(&all);
 	ksft_finished();
 }
-- 
2.47.3


