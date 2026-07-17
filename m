Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DBD1C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE836B0099; Fri, 17 Jul 2026 12:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D64F6B009B; Fri, 17 Jul 2026 12:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EB866B00A9; Fri, 17 Jul 2026 12:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0F1C6B0099
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:22:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4CCEF1A0146
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:55:25 +0000 (UTC)
X-FDA: 84998415810.28.9662015
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 90A1312000A
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:55:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=S838Ccto;
	spf=pass (imf29.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784296523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=npwCtp/b+xCXE/6K8LMFhJD3vd/LJ/ptWlLY3x80Hbs=;
	b=CWExMq497Rce6DeScfVt/0Qui1ozM42k2hJ8AE/U9jPdkQiNKXSiFxBhR+qawihbWi6WkC
	DwL5saZUa24+Miaj/vZ5or5bi9lqZ7RXAziggyTJvzgv6hbKQEDSF7lllXxOFEJZxIi366
	y9pZOHLfJLGbe5rrmka/TATztkCnZpA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=S838Ccto;
	spf=pass (imf29.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784296523;
	b=Yml+XjdaZ5BujmB3x+bXbFLrofJ4yqF/t3tmzKU9AxsyXiQN7eFFX3/RAFBL6fOlZYYY/3
	J3TfrtAtFUpIOQZ9NbY2ovjC7l9VsWl8vKFjYxY0ZzJpgLFwAlse9Vi95aP7D34HvUKbF0
	MnJkkErkUDO8LWMjRvEtENp+W4/dms8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=npwCtp/b+xCXE/6K8LMFhJD3vd/LJ/ptWlLY3x80Hbs=; b=S838CctoEfAe6RVXtXUp6bV6BP
	B4X8wEMhDQDbgPgSDvzdxRt5gAOeE5DkhZnLnsH8e0qQhMa33dUD2LzZVqv+HJvBaWZU/K7tQ2M+z
	S2fonEjbQjT5kkae6IhrdowOHhg4fcyLvDEqPfBLMxaG4b7H8PRkCHFPdQ3N7OI+HDg3Yhbas2iI9
	c3VH7ZLwBAJGV5l+f/vcgoUnveRRBluPqq+IHAy9rQ1PhrXFByiedwMbK62eBu2pFuILe5uTKjg7a
	19ngUTN16RCYAwQjymRuSxX35Kxcjc8lflX9WuMXQe+LYsc13oLZdNGv0z1382XE5YgN7X/5fvs4z
	p732RU1Q==;
Received: from [179.118.191.219] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wkj25-00GXeM-Gq; Fri, 17 Jul 2026 15:55:17 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 17 Jul 2026 10:54:37 -0300
Subject: [PATCH v4 4/6] sched: Extend task command name with
 TASK_COMM_EXT_LEN
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260717-tonyk-long_name-v4-4-1fedfc870d21@igalia.com>
References: <20260717-tonyk-long_name-v4-0-1fedfc870d21@igalia.com>
In-Reply-To: <20260717-tonyk-long_name-v4-0-1fedfc870d21@igalia.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 90A1312000A
X-Stat-Signature: hrf1c45cy5njgf8pbcoe6swqjynunnj9
X-HE-Tag: 1784296523-460089
X-HE-Meta: U2FsdGVkX1+oZXppoFseGh53BULg7AT8M9xGPBE7yH3+sS9IFxB2XKN9oxWgRVdS8e/ioAMDIZD6sxq/8Ve42qiLFUV0ZxQRqBocd3WOoQ4dtmMkZgubRuhKV49m+i2w1pm/6Np52cC5F5MeCRsEX/Agg/HgmFn4+GLXAMtd0lPowd+LlLSaaDRz9qBOb5BV3IFwENBjXmk5QNfwmh1BO4BdVHrCb5PdBkUCU5GfMEg7SKNkzdewkPJksVuRl0Ja/hD8wt3fne8hYCJqi/EQc8yngBGuOmMp/n0v4D/uXj8+0N4jqqF5tN1ScNFGNYPKCYfesNIByKIdZagh+Gvr3YlqKkK2VmNDhsX3D6QXdm5l8QC8nbL3H2sfSSi0uH61YDeJWbWlaUqBhGxTPol7wK4z5IW64PpXbJvsIX+UCpRhN87iIJ3M5GZ5bIdiHE/9bwee0ZP2qLmhiIl39OVgnyR7JUB/Plr4uF71nS37qppSwUmaM1lGhpR8fRgzJCEpakrYPlq3hZWqGSSgvjM96sQw2Xh2kaPniZAULVxUaN+pxtzilO42Oh+oW7AW4cFG8LLX4tILqreKQbBCcgFAb33eyrCNhjPKgu+1qpCFDPN3SPqKm3QUhFW9LTM6NqB1siro2u1YCMfHvvXeLfA2BMpgCt+vFVXtu+fZsgxbc0lVOAMlrzmam+oq8qab14sTjdzkq9S4nlrEo/59TEIYoOg607Qjo14u0XMZXlA8WpM7u2pHXMuOkWW1jDbLeIFjUOwofvg1DpIB8Dr84e5tEH6G4wsO7R3oi0XfAsAeXDj1KCSn5FFXbqad3uoo+hoH38gA3sRtMY1jdxflJtsPOQosOd4SIB8wEvegYp5wBYjO5JHqlBTojmOivdUl/fUT1moVbthCCH4jY/hIbZEk5u9jL4zzyMT+0iBKPAGJai+kRCR8QtlCwLIApO43PM8itX/CjSyeiPwYljI3NHc
 dtI7N3iB
 1TYu9AHq7jJ+gvbTKk5PZZV2oFpLAs7cCw6C6yAKF/X8nK1mlQwNLddMEybIkB6i6LftU/IsKyBFpLA/lmczLj8RgIEAPTr3d+PLK437wVh+yorjH0fCykvFH2270vFkSY6FI3QXtbjVAQQIxPu71IYIJabarOsoOMUj4ie9kEUKH5sIlQveHF+RPzoKYcENQgMfgsSukw7gL/BQCebvF//OUs25Gt9YeRP0BMPROeEiwtvV+YAQbB6tGXj3hEUFLPsFeHcR3IU61oZS2ZpmS+8+Sjmcifb2rGSO2hC1tgMd60XJEPgMhVI0ZxFHtx0N9/ioL4zoxjnkgcmtvVKOtQ6iALiULllmeyEYMKTw1NqV7ILomgszsemScJ9MaaGCBHjCCubpceFonBT+zP+YWjm5lXKBYjgct6e+BZs7gKbDS+ZXr3yJIQniXCZNk/tOuLBJHyE/6bfIxt38=
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
index 905d910b598f..0490b9ef2788 100644
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
index 9b6a413f6618..6a48517f01cc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -323,6 +323,7 @@ struct user_event_mm;
  */
 enum {
 	TASK_COMM_LEN = 16,
+	TASK_COMM_EXT_LEN = 64,
 };
 
 extern void sched_tick(void);
@@ -1178,7 +1179,7 @@ struct task_struct {
 	 * - set it with set_task_comm() to ensure it is always
 	 *   NUL-terminated and zero-padded
 	 */
-	char				comm[TASK_COMM_LEN];
+	char				comm[TASK_COMM_EXT_LEN];
 
 	struct nameidata		*nameidata;
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 74c22d6dded0..3c37b5c1c072 100644
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
2.55.0


