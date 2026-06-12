Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7713BCD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E139D6B0098; Fri, 12 Jun 2026 12:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBAC6B0099; Fri, 12 Jun 2026 12:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28F96B009B; Fri, 12 Jun 2026 12:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C369E6B0098
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:21:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9128AA01A9
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:21:15 +0000 (UTC)
X-FDA: 84871775310.05.C091E9C
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id DFF98140005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:21:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=b+FGMirv;
	spf=pass (imf09.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781281273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2P29qc+6UPDY7W0A1wdk8G93G2x2BCG+qxADi0fmd1k=;
	b=xZ9+ZlgxeWljaHJtkWseNgmoU+WEPtJLO/yruLKb1SAiCSRJw+SMlRtDXa495QTXkbWmip
	p54y7IsBrTC5a1i8PSJvmA1tXSV6RVKFis+EGK4TXDojshdRsUN6rkeozI104ie1ehh3Yb
	dnsZ+jlw8oaRC70S9mBxu8Z/NxgdoH0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781281273;
	b=oj5lsKz4C3K0Rm776+zgk+IHSE36jMDwagCr60wben/vGbXtR+njTGfIUfOsJsUCOOJT5W
	5QSY52c0lPUOn+zcZcPpx1RH3vm1UwOFvKiDe7XaPd4HWdkeipwH34dNjQQ2iJfhrsTCly
	s9vfTlLq5egjmnzEVLPxKlezinHNf6c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=b+FGMirv;
	spf=pass (imf09.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2P29qc+6UPDY7W0A1wdk8G93G2x2BCG+qxADi0fmd1k=; b=b+FGMirvnScizBjA5g1/q6jNlK
	lU74NYQq6p4zvp57oHXMebImcwOfBpVNfBGiTCEEQPY4naav1k8rPeVGz43k1sXGo6KlV37f6Fpc6
	R1CByTE7g+iIi6Ui3rpYGpKgXYm9UaUOIt8pq58mFshwXaK+mUxTV0gqBSj3Zf3sjVFAvVAOTtUeP
	CPQbu5//AKReZ6hA4jHBCQj90QbHonkcwHa2U41uC7AACCU0ODAggKpKzy4dxZmmtmZUziXkNqUyr
	SMz6anwcmdP1SW6Z9IpuB5qh+cJkTpzCVhq+NxWNhW9QnLHoI/H3bxPl1ezwFxsT1dziMhPEYHZuP
	sKyqfIeQ==;
Received: from [189.78.222.70] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wY4cw-00GgP4-3P; Fri, 12 Jun 2026 18:21:02 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 12 Jun 2026 13:20:18 -0300
Subject: [PATCH v3 5/7] sched: Extend task command name with
 TASK_COMM_EXT_LEN
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260612-tonyk-long_name-v3-5-7989b66e8a99@igalia.com>
References: <20260612-tonyk-long_name-v3-0-7989b66e8a99@igalia.com>
In-Reply-To: <20260612-tonyk-long_name-v3-0-7989b66e8a99@igalia.com>
To: Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, willy@infradead.org, 
 mathieu.desnoyers@efficios.com, David Laight <david.laight.linux@gmail.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org, 
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, 
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>
Cc: linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org, 
 linux-api@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: DFF98140005
X-Rspam-User: 
X-Stat-Signature: 6f55igbp3i6cfqzhwbew69ab4aehqx5j
X-Rspamd-Server: rspam08
X-HE-Tag: 1781281273-637412
X-HE-Meta: U2FsdGVkX19bsJ4gX0MkA0t7HkZZDGCJNbaR7bBMaIRTWH4zRAdmHeztgDgtyKGbAXl9OeEuihSLFvyQF8v6YaRyx5MaVXE1co2KnWyEXfYOidUDvrrHWGK2V6NuVqlwZ9pmA/9OD2pSEg3WJNMOLPLHnaprqiMZjjhNWg3gywktORgzyPn96C73yMaT4mv2IILv3xCifN9qTldBns6ucV02WvxLkMj5+3c1AdofzZqHALe3OMJLSfQyOCH3cQtdEa5myYSMpIzdmDOIxDTbLPnwWOt97hy1dLkNS8MSYTV/Gb/LdrEnkIT9ZqPaHV/dlbQx1lbRYjJ1o2ABjc0WyUwOzd+Zkh+Z4gUSh5gu81RqN52ZOd7cHnBOoFXjq0HMeE30TMcY/NkiaJb3eaocMIZQAwHd/KxwgJ7JX8J4RHV24axUEZ+JHJz7mIJgA9vH4TUK3dcrfUb1knMxe4lbQQHIS+1t7VR/nERWQkII6IJ0WNKWqZJysSHAVtoPAK/mWBa3A0ydMLh4dUqaRdNq9ccmbbG9gt7p4n7SgmX+JmIqAsBNXRCG6tylkK5IVfRqUmd/5+IQjkm4lWp5MhBTjW/2f8uFp7WMUt00K/EQ87BZ0nvKFzd7mL6O9QkHaruUi+nXpXIfFpOggpsPk5kU5DYSm5zVacnfhznWFsA5kLaw0fJ7UVkwHBjijByt++N8u5Z4b3oyK3Mv1f3E1SXu/hf5Tdm86v5jZ7TcnmfivrtX3ndNOIBEh8y9uPx3pLwksUlj576H95yOJEA4dVEdjyYOAp8sEI9Ef9EYNOVfa44GEGo/H7h02IGZTTAh+T4Noz4D0tcinOCXf4dWBQU9e6m3XcEfWGfLCNU4666ou9kmE7mbtCkojjCdqxmt9gH15/r4ARwj6z+yl0DG0a3r/1w+goCnW+uiCZCxFHCg0IvUWgsBT4ZvX3ZbhcDFE5KXsmImPtS4vKdy98yFQ/R
 /sLvXBX+
 XTtN+i4vzx92aW3DqdFFXFdhQhAf3tEyvraGAWiCP74XlBAOHBu9kC45sSxJ2tgJRL5dRJCH/ZoKzlbEZ2MLWrZSHxtR7VKpt2IeJBu0pDlKEvZrKWJxqZY+6cQml4DJutGkJoMoI3eZA6h7zcJfLLuth04UPjrD1cZ675udgDkSxFRWZ5QW0HcOVBJEtIb7LsY3w7wVgd7y9QY+o+Dse8flUS1emSPsDhAM8Fqz015yWA5XE/YM/oE7bgNz/w9Qh1GSza/asISk1RNrOkM318VeREOAmYYnJAV46AmERpGQfrMTSmqf5DAsceKzsUJHTnZ6nIV6VdJhVmNvRINjEyOKnvDYWOjCGIe0DLYgIMbqB32zxgez4SDY4m/cFqrPecdHhfiOal8TIjHVL9NpVWQLY0gj+BrflzvxHkF0ycpa6hcIwaPrFFUixA149Sb1op0KzcQzcwbzqQpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Command name has been restrict to only 16 bytes, which is too limiting,
specially when debugging and tracing complex software with thousands of
threads and the need to differentiate them.

Just as it was done with kthreads in commit 6b59808bfe48 ("workqueue:
Show the latest workqueue name in /proc/PID/{comm,stat,status}"), support
long names for userspace threads as well.

To avoid buffer overflows, cap all existing userspace APIs to
TASK_COMM_LEN, and leave the full extended name for a new interface.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 fs/proc/array.c          |  2 +-
 include/linux/sched.h    |  3 ++-
 kernel/sys.c             | 10 +++++-----
 lib/tests/string_kunit.c |  2 +-
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index c8c3fbd9bfa9..312371eddc7f 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -110,7 +110,7 @@ void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
 	else if (p->flags & PF_KTHREAD)
 		get_kthread_comm(tcomm, sizeof(tcomm), p);
 	else
-		strscpy_pad(tcomm, p->comm);
+		strscpy_pad(tcomm, p->comm, TASK_COMM_LEN);
 
 	if (escape)
 		seq_escape_str(m, tcomm, ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6b9408128fef..a5dc0f4e7975 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -323,6 +323,7 @@ struct user_event_mm;
  */
 enum {
 	TASK_COMM_LEN = 16,
+	TASK_COMM_EXT_LEN = 64,
 };
 
 extern void sched_tick(void);
@@ -1167,7 +1168,7 @@ struct task_struct {
 	 * - set it with set_task_comm() to ensure it is always
 	 *   NUL-terminated and zero-padded
 	 */
-	char				comm[TASK_COMM_LEN];
+	char				comm[TASK_COMM_EXT_LEN];
 
 	struct nameidata		*nameidata;
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 1d5152d2395e..76d77218ab19 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2535,7 +2535,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
 	struct task_struct *me = current;
-	unsigned char comm[sizeof(me->comm)];
+	unsigned char comm[TASK_COMM_LEN];
 	long error;
 
 	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
@@ -2601,16 +2601,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			error = -EINVAL;
 		break;
 	case PR_SET_NAME:
-		comm[sizeof(me->comm) - 1] = 0;
+		comm[TASK_COMM_LEN - 1] = 0;
 		if (strncpy_from_user(comm, (char __user *)arg2,
-				      sizeof(me->comm) - 1) < 0)
+				      TASK_COMM_LEN - 1) < 0)
 			return -EFAULT;
 		set_task_comm(me, comm);
 		proc_comm_connector(me);
 		break;
 	case PR_GET_NAME:
-		strscpy_pad(comm, me->comm);
-		if (copy_to_user((char __user *)arg2, comm, sizeof(comm)))
+		strscpy_pad(comm, me->comm, TASK_COMM_LEN);
+		if (copy_to_user((char __user *)arg2, comm, TASK_COMM_LEN))
 			return -EFAULT;
 		break;
 	case PR_GET_ENDIAN:
diff --git a/lib/tests/string_kunit.c b/lib/tests/string_kunit.c
index b64d7f0e54a3..5d26029d2d01 100644
--- a/lib/tests/string_kunit.c
+++ b/lib/tests/string_kunit.c
@@ -883,7 +883,7 @@ static void string_bench_strrchr(struct kunit *test)
 
 #define TASK_NAME "task_name"
 #define TASK_NAME_LEN 9
-#define TASK_MAX_LEN TASK_COMM_LEN
+#define TASK_MAX_LEN TASK_COMM_EXT_LEN
 #define SMALLER_LEN TASK_NAME_LEN - 3
 #define BIGGER_LEN TASK_MAX_LEN + 3
 

-- 
2.54.0


