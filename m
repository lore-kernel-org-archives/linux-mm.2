Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 547B6606D80A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=EuwAcriO
Received: by kanga.kvack.org (Postfix)
	id 070746B05BA; Tue, 17 Nov 2026 11:17:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD00F6B05C1; Tue, 17 Nov 2026 11:17:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70966B05C3; Tue, 17 Nov 2026 11:17:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9DB236B05BA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:17:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29275C04B7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:26 +0000 (UTC)
X-FDA: 85445116092.12.31D61DE
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8389418000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=EuwAcriO;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf24.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJ76wTh0nV/KNDIqsdDhRhZTY6RdEm7WDdLDbxCKA1Q=;
	b=NIIe9NeZG5+KA6pX0UtBUwMQnNDpw7nfQTGMz/WJyJqcDRNZKmdPdi4b5aCe6lSvu5alwj
	GqbRfRLqDi1TaIGfo3EJfKKQ00jbtBjgelP9DLuN6Cfi5gZmwvuLtykAQBRtnJ1vRsE3/8
	ApFEw9uLd4i5+msi2zY8MN+ky9w7cdg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=EuwAcriO;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf24.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932244;
	b=N0nDO9rhaUAg1VFiOj/qph8KvkWKXurTtWIId2O5l09rEBGtyDFd90rI8bgtEacwIF/y3O
	bako2rB4AI3ZaBBlGT9IPRfgO97+uLdQDUBrnNuEZJg9DiPxbLfJ5QjqZ2msvssNlQ+MQ/
	/B+yJWiBgrCmlsIHWspPXwC/1Hz+t+w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794932243;
	bh=RJ76wTh0nV/KNDIqsdDhRhZTY6RdEm7WDdLDbxCKA1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuwAcriO1rqDQcG9xsHqdsGXc2nmiOZyqsiHdXZI4N7kJLZXp8czY0rz+lElXiQAO
	 rSoNgxC3m2Mr3iXRSsNVVrIzo28cxH40DP4Xqctd1KknC7dAaie7HdIRqGLgYI/F2Z
	 OaGkG7s0LbesOi7BKWFbBC9bgQX6EDBgYHeHMpE9wUJuqko6BxpD3yEudh8Gdw7llB
	 fAYAKxK51P6vdFi2f3YuI0y3SkefSYZWREwBpWTMDFok5AlkXCo0EtzFsvLiu/Q92W
	 4zn7EbZNMene/Nj6tbupmx6xpzLTWMWHlyRMEBAhK+sbt1B+wyVnL/c2PPaY4Gu0W4
	 KBVvy5A+DpHog==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTVHl1nqhzRZX;
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
Subject: [PATCH 11/17] selftests/rseq: Test affinity changes made by another process
Date: Tue, 17 Nov 2026 11:17:11 -0500
Message-Id: <926187ef9c1ed8c1b197cb7fa854339c01ee5e6b.1794932121.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8389418000A
X-Stat-Signature: dfn4p3g7db5947scgf9owdo1xofks4by
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794932244-691523
X-HE-Meta: U2FsdGVkX1+xT+WdlHqIdrcKJCso7iq0Pda2q3ks2YW5RF7BqPKPz3iuUtku5pM8ODmCiZO7HGQxWXsJBQCuwAD119HZ66lB1U+ousegD7OIln3/M4LLxVMPG3g5BcS62KyOxhqC0mvQI5uskIbAlt0TWZIjMQqeDkbiBULaV6g7lpgaPwZ+/VA92cczwQnHoaGYgkgVnvGavP06D/zuZXFZIkeLCEEaKQSq4NMMW34bRh0re835zlaxUeh8J6N31f4DXZOtTjsBLrMs+AA8u166mBz2ym+u70qk+ufjBHeTvPknFOx4lrEU5X35OFe8dh+NFT/NJViTprgiWK46FeeZRKOI9TQVc30ebSe3sL8UBSNMF0r/gQnm2+5aeOsZ+EKB7MjyXyQdcvOTMcTlZSZ0HxbITbVcfWN3tsAD2P9XDcZzYzCR11vWv5J6EeHTVZIiw1xGsrXzKehpLRBZ/c24BIQ2G63g0ioqhjfue3JsL670Dm4x5LPnjzZSxgVGAc0ck4oeBgqMlkwsLrPxrgI4jam7CuDkjvpHYQTdB5d6e5TQlYEyIjgS3iP9UCi4hUSPEXLbk0yE4XjA15YX5O9X2INq0DCZuRID+ieUVy8xIvGh2kj/KTI1Eut16Lu4vxoMdXG5iR5j34srDPssiTkd+C0VrITVfSXjBiPoEf2rxO+zK8uaFNJ0etZU8GOCJyZgT6YzqjKynzzH2Au0NxLk8gTCcxtMgFCyqlXnuxM6AOT7X9jgMcgEe+V6RDgQW/zD8EByBB+kiu7EkfRV160ZV+/NNsgbK0XunDh5APj3AGO7zCxa7W3vjHLey2psfESoXJ+PA6Ki/KW+Qd87DfyJ27g6GuXhjykwiIDzdoO82iJgkTYmv/7TaK+64pQ3WvchoHJvycXK3RxK87jmSnfSrLblZb11aRHMuRWP7QFAP7NIoU0j35J4MBcTv99PlENQ11RwCEEk/3VoHbP
 jHRynl8N
 fhB8s/oVXXzarPMUZ51U1Om7/XPZM38HBSsqhs1KWI975tDsfUARvJzDJWZKXDqiDE6khtmKZjSL+141sUNDybHb9DZ9YyJNHGD9514beUC5Zz/hN+qR/deQgz/y4DiGbQuLIhlJlgL714unDwx88yoROqy0fWQCHyRtU1sM7tJtGb3dDtTO9gtVhRXB5OVgUicgzn1sFqsYaWUq8/KnXfBMEmRngqidt01qpPTToeHphSIC9KsO0jTFt++HQvN5x/iwsqZ4a+CF5a5p9erTUK1immsQQNboNh0oaUYOVw/fY7FNh+hJVGH3SZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The mm_cid tests change the affinity of a thread from inside its own
process. Another process can change it too, with sched_setaffinity() on
a thread ID. The kernel then updates the allowed CPUs of an mm that is
not the mm of the caller. The threads of that mm can exit or call
vfork() at the same time, and the whole process can exit. No test
covers this.

Add a case to mm_cid_transition_test. A process starts on two CPUs with
three counting threads. Another process narrows and widens the affinity
of each of these threads in a loop. It goes on while the process under
test exits. The case runs 100 times, and the changes start after a
different delay each time.

The case passes on guests with 2 to 64 CPUs. It adds coverage: it
found no bug.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 .../selftests/rseq/mm_cid_transition_test.c   | 69 ++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rseq/mm_cid_transition_test.c b/tools/testing/selftests/rseq/mm_cid_transition_test.c
index 7c80c222bd96..fa26be14950c 100644
--- a/tools/testing/selftests/rseq/mm_cid_transition_test.c
+++ b/tools/testing/selftests/rseq/mm_cid_transition_test.c
@@ -20,21 +20,28 @@
  * A second case starts on two CPUs and widens the affinity of a thread
  * while the others count.
  *
+ * A third case leaves the affinity changes to another process. It narrows
+ * and widens every thread in a loop, while the threads count, call
+ * vfork(2) and then exit with their process.
+ *
  * The test fails when counts are lost, or when an mm_cid is not below the
  * number of possible CPUs. A kernel that loops looking for a free ID
  * shows as a timeout.
  */
 
 #define _GNU_SOURCE
+#include <dirent.h>
 #include <errno.h>
 #include <limits.h>
 #include <pthread.h>
 #include <sched.h>
+#include <signal.h>
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/prctl.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
 #include <unistd.h>
@@ -266,6 +273,59 @@ static int run_child_widen(int delay_us)
 	return check_counts("affinity change");
 }
 
+/*
+ * Narrow and widen the affinity of every thread of @pid in a loop, from
+ * another process. Start after @delay_us and run until @pid exits.
+ */
+static void remote_setter(pid_t pid, int delay_us, const cpu_set_t *narrow)
+{
+	bool widen = true;
+	char path[64];
+
+	/* Die with the process under test, not before its exit. */
+	prctl(PR_SET_PDEATHSIG, SIGKILL);
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
+			if (tid > 0)
+				sched_setaffinity(tid, sizeof(all_cpus),
+						  widen ? &all_cpus : narrow);
+		}
+		closedir(dir);
+		widen = !widen;
+	}
+	_exit(0);
+}
+
+/* Run one round while another process changes the affinity of the threads. */
+static int run_child_remote(int delay_us)
+{
+	pid_t self = getpid(), setter;
+	cpu_set_t narrow;
+
+	if (sched_getaffinity(0, sizeof(narrow), &narrow))
+		return CHILD_ERROR;
+	init_workers();
+	setter = fork();
+	if (setter < 0)
+		return CHILD_ERROR;
+	if (!setter)
+		remote_setter(self, delay_us, &narrow);
+	if (run_round(3, -1))
+		return CHILD_ERROR;
+	/* The setter keeps running while this process exits. */
+	return check_counts("affinity change by another process");
+}
+
 static int read_nr_possible(void)
 {
 	int first, last, total = 0;
@@ -343,7 +403,7 @@ int main(void)
 	int status, i;
 
 	ksft_print_header();
-	ksft_set_plan(3);
+	ksft_set_plan(4);
 
 	if (!rseq_available())
 		ksft_exit_skip("rseq is unavailable\n");
@@ -371,5 +431,12 @@ int main(void)
 			break;
 	}
 	ksft_test_result(status == CHILD_PASS, "affinity change widens the allowed CPUs\n");
+
+	for (i = 0; i < WIDEN_RUNS; i++) {
+		status = run_under_test(run_child_remote, (i * 13) % ROUND_US, &narrow);
+		if (status != CHILD_PASS)
+			break;
+	}
+	ksft_test_result(status == CHILD_PASS, "affinity changed by another process\n");
 	ksft_finished();
 }
-- 
2.47.3


