Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 863E4E7DEEE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 14:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECD186B00B5; Mon,  2 Feb 2026 09:38:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E642D6B00B6; Mon,  2 Feb 2026 09:38:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4FF96B00B7; Mon,  2 Feb 2026 09:38:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C664E6B00B5
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:38:16 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6228C8730D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:38:16 +0000 (UTC)
X-FDA: 84399771792.16.7490818
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 46155C0004
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:38:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JfS3nwmJ;
	spf=pass (imf28.hostedemail.com: domain of aris@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aris@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770043094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LLPSi3nvHTn4l+eMte4lOVK2lLpRjSH202e/Dy3d0DM=;
	b=qLUt30CtzUhTNK0ifLN7URvHfH4sATpVDHgQtCs5nFz6Twml1myZD4js+R1lz+J5Le9fj6
	P0rnzbWZVESul9ZTeU2yRlHsyim0Pu912FUn9OWo6ivv3gfOA+fYKENCbgfocIk3V5zusu
	T5BRoIIR7LphwBLY7oLowGPr6g1QeQE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JfS3nwmJ;
	spf=pass (imf28.hostedemail.com: domain of aris@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aris@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770043094; a=rsa-sha256;
	cv=none;
	b=F1zGfu1WmIB+d8jwxEcbjdOAK+DPcL9Fle7mHGP1Ev8MRnzY6MDR+S7Uoux7dGAAnF+JOK
	O1Q7aDDbHvsjv8PGUezpv0IXd24QpvHY8Rm6xykbcwpEBGIIKIIMWlLMPjBW+XfV4iLC5b
	L21FFxyh+wtmeAMYQUCC+OFif8hOCVc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770043093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LLPSi3nvHTn4l+eMte4lOVK2lLpRjSH202e/Dy3d0DM=;
	b=JfS3nwmJR1jWsbcU5dV7pNOb3vpeoBM1U5grgbktLWgB0y7eoKJN1yxWpL2NE1uhE9eBCo
	YwdAaaGUl0yJ2tIbOnWmSQ71Lf8BQF5EYAvenEn4A9ejcxWZ7AFUKcsnEIvPn3xVx9Nm8i
	SaPtY+dNxvsBQwLSGkR3XeeyQD9/ea4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-523-cm_R2a_KNMOfV1SOjTvf4g-1; Mon,
 02 Feb 2026 09:38:09 -0500
X-MC-Unique: cm_R2a_KNMOfV1SOjTvf4g-1
X-Mimecast-MFC-AGG-ID: cm_R2a_KNMOfV1SOjTvf4g_1770043087
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DA2B1800371;
	Mon,  2 Feb 2026 14:38:07 +0000 (UTC)
Received: from napanee.usersys.redhat.com (unknown [10.22.66.39])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6752030001A7;
	Mon,  2 Feb 2026 14:38:06 +0000 (UTC)
Received: by napanee.usersys.redhat.com (Postfix, from userid 1000)
	id C9644C197F; Mon,  2 Feb 2026 09:38:05 -0500 (EST)
Date: Mon, 2 Feb 2026 09:38:05 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kselftest@vger.kernel.org
Cc: Aleksa Sarai <cyphar@cyphar.com>, Shuah Khan <shuah@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, liuye <liuye@kylinos.cn>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Subject: [PATCH] selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT
Message-ID: <a7776389-b3d6-4b18-b438-0b0e3ed1fd3b@work>
References: <7888ed77-da89-41b2-a73e-09038b7c9285@work>
 <20260131132315.62b0b029dc1dd03febe97481@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260131132315.62b0b029dc1dd03febe97481@linux-foundation.org>
User-Agent: NeoMutt/20241114-35-62db1e
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam12
X-Stat-Signature: tddxmqkwnjnruic5ihbwry3ipt1ez5zp
X-Rspamd-Queue-Id: 46155C0004
X-Rspam-User: 
X-HE-Tag: 1770043094-483951
X-HE-Meta: U2FsdGVkX19lHknz71AmPeGEqwq43yxUVaXiwAmf8DP4FBjB5kSAHjN9bHqXHXrfZu0cO5zjx+d4mS9XRbHKCmVXyvs6FaToUfsAjRrtFa4EB9VFtx1V2exobdf1Bz0C//RG5l08u1ZPuZ0OZ/pV3K1I73kMumQw+LQdpsOotZNLYMkjxcG5cxxDL3Bjj1Qa66QGcVwerwgNsA2Tftalffie8vphLHWYTevAttSyQNI/ML5Kqil9VBPdlDi/QMD1qwijmL9n0E/6dhwD39jfc+XfGv/p0kw3J70bHiW89F2Ps89J0Jor70SXBD0N7KKTtcmnGYMPI2WZbFNaMbmxPRsetqsS2wF2TxN9fleSaMwKMhZR7OefxBF1VqBuIzMCbgkZeM8mQ4sHuEepx4raxxJqT3Kp1jFFEz2bt0zQnuZtc1H0CJV4r2kNGAjhES9XnQpp4UZ3ElSN/H3F2Y/cDgHlzoxvFBM28aT5U9JHakNoNlBUpAZA0DA2BhFEghAO60AQjzGHJAZb5Gs9lvGDwHUdQgE6p3Qxqd11Kt3QuQRiXu1Z6NKeBSPlNHLMoGic66sdfE+qwJx4RPWHbVRssOOJQlTyzevCVjo2ec7sga26nBD+vqeYo6wY78LQoptUC3oN//rulxXxf+kGuiuc5f3jg9VafBS/7no+ywxvMqpkZfuHz3Q4zo+EX96pjzHZCzOyTOuWfip0/flQA2GbUoEQoyD+mJGj86z0ePOY9IIGXItGsxF4joCkNeydtM16nJHxtH3l7upxb94a2+u+oButaJEGPsJgqnN5g93pUs0V1l+BLuocH70dPl9vHxaObw3u8qkK0WYkzZ7wqriZz8pz6TWZjkKpHHcRHc1Friz64KyP6P3jslGwHfY++yuZmZv1oKohg5Wjd4pVMQNn30EqedqBT3AQhiu3vkfSpf0hi4EC2quDCt2tk2KY8yL+Nv7VZXjS7ktqQK9UpvA
 SyNyi5SO
 nb7VpOnKvYaA2izYI8837JSEEjQjZQo37rg73hCp2h6U9Z8oGh/Qvf9v/lhsYhnxwLSJYrHMHlHEov56+7uuWJ1HPbafa4/J04gJvB55R3fg/p/WrcTdvZd24hg+ZWCOmjhFmJC1BMGK47m1AuqGxeLoUfH3uBjeQzqJjpXrn8YTUEKAUVL765x5DRhBdExf/bHmOeCEn+O9ltY937iqH++wxG/1lJc0TwNM30AHkrlDGBYK1RXGuP+9cBvqQEr7Odznx4oFj/w/dX6ax52mDa8PhL1497ctB8i3OpX9x1/TrXcYyz/mgrv/w6uIWrsZwXukLRKAyhrKDNv1D0Wnfpb4+3U18CeGeEbIhlNU/isafxte8AxIgO+TTSa6fGiVh8mHlNCcXWfh0SifZyHEJNxzbYgMCEC37eKGZ+/RVsmivAHotj/HZidxmZ7W43otbdlbqmXuVcLFWA+XD9C067l/RUPbNUVfYJaBcE8Pg1Zhy3cWirfvjkE/jUmHUTwZa0rxpkXZ5ySnIK5pXMfGCmX2ZAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT

In order to synchronize new processes to test inheritance of
memfd_noexec sysctl, memfd_test sets up the sysctl with a value before
creating the new process. The new process then sends itself a SIGSTOP
in order to wait for the parent to flip the sysctl value and send a
SIGCONT signal.

This would work as intended if it wasn't the fact that the new process
is being created with CLONE_NEWPID, which creates a new PID namespace and
the new process has PID 1 in this namespace. There're restrictions on
sending signals to PID 1 and, although it's relaxed for other than root
PID namespace, it's biting us here. In this specific case the SIGSTOP sent
by the new process is ignored (no error to kill() is returned) and it never
stops its execution. This is usually not noticiable as the parent usually
manages to set the new sysctl value before the child has a chance to run
and the test succeeds. But if you run the test in a loop, it eventually
reproduces:

	while [ 1 ]; do ./memfd_test >log 2>&1 || break; done; cat log

So this patch replaces the SIGSTOP/SIGCONT synchronization with IPC
semaphore.

Fixes: 6469b66e3f5a3 (selftests: improve vm.memfd_noexec sysctl tests, 2023-08-14)
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: liuye <liuye@kylinos.cn>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Aristeu Rozanski <aris@redhat.com>
---
 tools/testing/selftests/memfd/memfd_test.c |  113 ++++++++++++++++++++++++++---
 1 file changed, 105 insertions(+), 8 deletions(-)

--- linus-2.6.orig/tools/testing/selftests/memfd/memfd_test.c	2026-01-29 16:22:56.094182500 -0500
+++ linus-2.6/tools/testing/selftests/memfd/memfd_test.c	2026-02-02 09:35:04.887782294 -0500
@@ -18,6 +18,9 @@ // SPDX-License-Identifier: GPL-2.0
 #include <sys/stat.h>
 #include <sys/syscall.h>
 #include <sys/wait.h>
+#include <sys/types.h>
+#include <sys/ipc.h>
+#include <sys/sem.h>
 #include <unistd.h>
 #include <ctype.h>
 
@@ -39,6 +42,20 @@ #define F_SEAL_EXEC	0x0020
 		    F_SEAL_EXEC)
 
 #define MFD_NOEXEC_SEAL	0x0008U
+union semun {
+	int val;
+	struct semid_ds *buf;
+	unsigned short int *array;
+	struct seminfo *__buf;
+};
+
+/*
+ * we use semaphores on nested wait tasks due the use of CLONE_NEWPID: the
+ * child will be PID 1 and can't send SIGSTOP to themselves due special
+ * treatment of the init task, so the SIGSTOP/SIGCONT synchronization
+ * approach can't be used here.
+ */
+#define SEM_KEY 0xdeadbeef
 
 /*
  * Default is not to test hugetlbfs
@@ -1333,8 +1350,22 @@ return 0;
 
 static int sysctl_nested_wait(void *arg)
 {
-	/* Wait for a SIGCONT. */
-	kill(getpid(), SIGSTOP);
+	int sem = semget(SEM_KEY, 1, 0600);
+	struct sembuf sembuf;
+
+	if (sem < 0) {
+		perror("semget:");
+		abort();
+	}
+	sembuf.sem_num = 0;
+	sembuf.sem_flg = 0;
+	sembuf.sem_op = 0;
+
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		abort();
+	}
+
 	return sysctl_nested(arg);
 }
 
@@ -1355,7 +1386,9 @@ sysctl_fail_write("0");
 
 static int sysctl_nested_child(void *arg)
 {
-	int pid;
+	int pid, sem;
+	union semun semun;
+	struct sembuf sembuf;
 
 	printf("%s nested sysctl 0\n", memfd_str);
 	sysctl_assert_write("0");
@@ -1389,23 +1422,53 @@ sysctl_assert_write("0");
 			   test_sysctl_sysctl2_failset);
 	join_thread(pid);
 
+	sem = semget(SEM_KEY, 1, IPC_CREAT | 0600);
+	if (sem < 0) {
+		perror("semget:");
+		return 1;
+	}
+	semun.val = 1;
+	sembuf.sem_op = -1;
+	sembuf.sem_flg = 0;
+	sembuf.sem_num = 0;
+
 	/* Verify that the rules are actually inherited after fork. */
 	printf("%s nested sysctl 0 -> 1 after fork\n", memfd_str);
 	sysctl_assert_write("0");
 
+	if (semctl(sem, 0, SETVAL, semun) < 0) {
+		perror("semctl:");
+		return 1;
+	}
+
 	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
 			   test_sysctl_sysctl1_failset);
 	sysctl_assert_write("1");
-	kill(pid, SIGCONT);
+
+	/* Allow child to continue */
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		return 1;
+	}
 	join_thread(pid);
 
 	printf("%s nested sysctl 0 -> 2 after fork\n", memfd_str);
 	sysctl_assert_write("0");
 
+	if (semctl(sem, 0, SETVAL, semun) < 0) {
+		perror("semctl:");
+		return 1;
+	}
+
 	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
 			   test_sysctl_sysctl2_failset);
 	sysctl_assert_write("2");
-	kill(pid, SIGCONT);
+
+	/* Allow child to continue */
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		return 1;
+	}
 	join_thread(pid);
 
 	/*
@@ -1415,28 +1478,62 @@ sysctl_assert_write("0");
 	 */
 	printf("%s nested sysctl 2 -> 1 after fork\n", memfd_str);
 	sysctl_assert_write("2");
+
+	if (semctl(sem, 0, SETVAL, semun) < 0) {
+		perror("semctl:");
+		return 1;
+	}
+
 	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
 			   test_sysctl_sysctl2);
 	sysctl_assert_write("1");
-	kill(pid, SIGCONT);
+
+	/* Allow child to continue */
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		return 1;
+	}
 	join_thread(pid);
 
 	printf("%s nested sysctl 2 -> 0 after fork\n", memfd_str);
 	sysctl_assert_write("2");
+
+	if (semctl(sem, 0, SETVAL, semun) < 0) {
+		perror("semctl:");
+		return 1;
+	}
+
 	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
 			   test_sysctl_sysctl2);
 	sysctl_assert_write("0");
-	kill(pid, SIGCONT);
+
+	/* Allow child to continue */
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		return 1;
+	}
 	join_thread(pid);
 
 	printf("%s nested sysctl 1 -> 0 after fork\n", memfd_str);
 	sysctl_assert_write("1");
+
+	if (semctl(sem, 0, SETVAL, semun) < 0) {
+		perror("semctl:");
+		return 1;
+	}
+
 	pid = spawn_thread(CLONE_NEWPID, sysctl_nested_wait,
 			   test_sysctl_sysctl1);
 	sysctl_assert_write("0");
-	kill(pid, SIGCONT);
+	/* Allow child to continue */
+	if (semop(sem, &sembuf, 1) < 0) {
+		perror("semop:");
+		return 1;
+	}
 	join_thread(pid);
 
+	semctl(sem, 0, IPC_RMID);
+
 	return 0;
 }
 


