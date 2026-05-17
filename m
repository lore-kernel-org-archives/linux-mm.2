Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B24CD4F4A
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:37:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54F8B6B0098; Sun, 17 May 2026 14:37:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500586B0099; Sun, 17 May 2026 14:37:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43CF76B009B; Sun, 17 May 2026 14:37:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 33FD66B0098
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:37:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C13751C050A
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:37:20 +0000 (UTC)
X-FDA: 84777769440.26.0FC2D3E
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id EDB0AA000A
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:37:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=jYvt3RcS;
	spf=pass (imf25.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779043039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mTm1itVUL5+eVJJJDMx7jNDUCkEzXL7A51fiJoig9I0=;
	b=Ex0tIx5lbyjlOdF5Qs86s2aKPLCfj5DmfNXH5dnmnRhmG2auOtqldehalnk7CHm1rh0r3D
	TE6SyPtAStjthUYZRv3clJUGCF4j3zHa0BiKCoKWOsTcAmIq7WNUJPsX5xdInTNZ34Ahyl
	t3MENb712+/RuTPM1hOqRc58ircJiJk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779043039; a=rsa-sha256;
	cv=none;
	b=fP1aB4g1uEor1wfAeals6uOYJ8hdkrCgpa2iT8vhS8TP5YVOl4mprdyaJvnpdUF2l7rOyw
	ryeOls7oLzMMxqYlMKD/hbGQmPD9Uz1M9aqVjVh+gDOKpUDUlF8E7SF2niMoYrtQ/15LOH
	Wvv1fzC60x1sqvM2FwDbvbWEEKUcRcw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=jYvt3RcS;
	spf=pass (imf25.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=mTm1itVUL5+eVJJJDMx7jNDUCkEzXL7A51fiJoig9I0=; b=jYvt3RcSvTnOoaO46YZIWqLtZF
	Jcaxk+Y3HCUWarNvWwQkb8inBe04XwyaEGiIfRRWaixV2Dx3bB1jMlqZ9U51R0GMy34P+je5ttt1K
	VeJfYi+cko+AAe3cf0tyRHwknRu/DoL0gkfGbJETg5b0uY6UK+YS77bswwr8MHXhBmYLMh32NJ0Hg
	fzg+1dHm0WfdsBWDjKvKNUlodpVKNPmBy35FgnxDAdU2dkIJ49doxNfgZrS0/drvfaAVqw/qq5uUs
	7kcAV2HUdxLB5bIWuk2olWe+etvVOG2We+PCCQ+1OoOHjsRzOsFkSIinTPmLfJRlga5TSwI24TG4n
	LOUus7LQ==;
Received: from [179.193.2.40] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wOgMP-001cLz-0b; Sun, 17 May 2026 20:37:09 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 17 May 2026 15:36:14 -0300
Subject: [PATCH 4/6] sched: Extend task command name to 64 bytes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260517-tonyk-long_name-v1-4-3c282eaa91e2@igalia.com>
References: <20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com>
In-Reply-To: <20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com>
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
 linux-api@vger.kernel.org, Bhupesh <bhupesh@igalia.com>, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EDB0AA000A
X-Stat-Signature: kng643uohycec38g7hi8jzbj1i8bfhz6
X-Rspam-User: 
X-HE-Tag: 1779043038-721313
X-HE-Meta: U2FsdGVkX1/F+mVzN/7I2FBuwqaQRlqr4LQ6gvbYLxCiqy/ofo4lJ0imi55LqJe0x+zSjG5lNciRMOrPu9YBfcaDlIf3I6pFWXGKFOaJ8bqX77NSm3J0RJhaWwa4SQtHrOJD06vC9D+FdZKhB3BQ3xD7UQATHGRqE+UEMX2ad3VJl99aLUiEEUPYTdbGFIfKQCcJftOeIdUrJmplSztR0FXg7M3ZYqaLDYnOzPwjx6NH4xTak/PN3xOYbIJ6OAjR3xNrLV/HI/+XST+XBXqq/lfjZ19diWKmrnzs9AtnsvVdXV0ji9ji0Ty4PO3BFr3w26F24PObic5zw2dowfNfBn2kG2UuHIQke3+MAuJEO7sJH4RfDOjIOXfMkXTKARbXT9hmFuAY9OQz8Q8DI3reVEivhGjNQzfgY3Nemd0pH2MG/YXxGP8x18tJFVCM0yfcE+yK6xTgs5dzBP8HAB3JgRWUxlE9Bd6Ty6Cs8ubls0P9MWttCiI6hvs4CGcqCPXbyilAVZyjAdlq438MB/qNTFvtZqiNaPn5Rb45wVrekQqJYCSpQrBsJVbrDde+8HGASrNm029WUjWW0oAUsUdggMbovAuzR6DRwjKojhzTBHY9NAF0ykQ20wSOalL+0Z/czI7jgF55Q7m76Jabyp6/lyEK2/qbdYXLVHngSNYMkmyutu4pyopHqgNBIiz+EKpdA3D6cruBNMlGf70s3RDiO9Tlruz0I0dMCkzDrenzDqI4WU0uxOzm6u+oxLKPJ7bX4F9RTDr8OQLcL2RNTeA56lELNETF1XtN+dEzfg97n75vknN08K//ycprCoY9owwvy+qyHhP7H7A0sLs7MgnW7XZXZ7uUki0knUDy7XE1qRHBqvQPL4kboGvTis4tSpqUo8f/M8QkXoXorn0d/sxg1OAdEXsrC9/wZU7+8C4ZpQo6+equAKff+AJeulOLrbGCU78N0uBHvtZraX6QKKh
 4rHT411I
 iyt0+rwp87i2y0Tc7mE7DXt0HaSLKeD8VD8CcrD+WU+ZQgYP+cFwtcBM/6lGr23yvvbaODaUZe8cfV/yHSdPNrDKrzWYTkFcjyFVvTXWBrm0Z37WutkeKn89LRRP8vmhe+exh0vRWrfjhPPk7kmqwepgjoxcuN5LqkXGr1byry2pkb30RYKlDX+B9uKSsdV/lmhxEoDUNk/Lz256wgRHGGqANwSr6i/na5kJTEnib80zJOBR5KJTSE5AziKeWUdHmQeeJ4ZZJTeuyBZa3aNUTHnyzFE0aLOwVuNYILQ3iSV1IOZIE3IIvBVq/igTv/gdHh+3P0O/7xWptV+PeF/vukUpZ2/D8aTURjQ7QKd1Oz+FBQ82aL1tQD/LDDvYK5KPr0SVy5CDAF0VQsDBKQ5ZFzK5nOE8NifjREY52S3L1h/Gn3T7biHdGNdE6AQ==
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

Co-developed-by: Bhupesh <bhupesh@igalia.com>
Signed-off-by: Bhupesh <bhupesh@igalia.com>
Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 fs/proc/array.c       |  2 +-
 include/linux/sched.h |  3 ++-
 kernel/sys.c          | 10 +++++-----
 3 files changed, 8 insertions(+), 7 deletions(-)

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
index b6de742b1155..f7fd2b7d131d 100644
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

-- 
2.54.0


