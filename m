Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D501C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFEF46B00A4; Fri, 17 Jul 2026 12:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD7946B00A6; Fri, 17 Jul 2026 12:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEDE36B00A9; Fri, 17 Jul 2026 12:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DEF06B00A4
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:22:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5007112013B
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:55:30 +0000 (UTC)
X-FDA: 84998416020.25.42030D2
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8FC28180004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:55:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=hfZpahlN;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf06.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784296528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/bFXJZ9TbqnXOB/wEeuVhQRXWqExLMAdmFSe0YD6uSs=;
	b=3o6IDlSf9Qoy8hlgoCYk0hFtoGTDQJl/xYEVP3EuWOOhWw6izOkwNrM1hBEDV33k1BHI5L
	5xZbsoO5BMk9/bxiMJrQPVxSALalHQBTpAK8B9C9aaN4CZKr4oLU2l94B003AajDgfp+Fp
	XRnfAdpd31gpSlVBuvY6d7Vok5ySKKg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=hfZpahlN;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf06.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784296528;
	b=Tcds1LYZB3SIhhBYX9l0UlxWcY8WwI3fsjfyQ0N/ht8nQ07rF4dgcfhT0ahE3eZeU9JWP/
	Vhdivus4XKZ2xadUMhabILOsIxU+J9p7WkQc+1qLZzdBpPxaoT73f9DZBNlJO4P+2K4RQK
	bBYY/8obABkSz/whbeSNHeQdyN0hk88=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=/bFXJZ9TbqnXOB/wEeuVhQRXWqExLMAdmFSe0YD6uSs=; b=hfZpahlNheXPpD1BnW36M62VAu
	rlrN6TofIZGqChRkq8GHsiMDC3OH3T+wT3w7Ce8bNz87+aWL0bLpsz9G3weDGCCTZhx1AuPYcJMgn
	KHxRksvOG8PXh3YN+pgkn9bbYBCnxo199BWc1hAU1MtokQz+fQBXl9borjB5evYC6M6AsA6is9EK+
	MbkH559dmzkFbf/FIe800RQcjr2nvRwXGorLBG1BgCcMndnCK3hHFUZOoK879sAgUk1rPuN7gSlMM
	Hi5oJjpPffKStBVWJw1X0ql5yOpPy+nj0dF7pbyamLXDuJrT+zVSXmOVqnAqocgb7KrtjWSXcrn20
	5bCcZCBg==;
Received: from [179.118.191.219] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wkj2A-00GXeM-JU; Fri, 17 Jul 2026 15:55:22 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 17 Jul 2026 10:54:38 -0300
Subject: [PATCH v4 5/6] prctl: Add support for long user thread names
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260717-tonyk-long_name-v4-5-1fedfc870d21@igalia.com>
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
X-Rspamd-Queue-Id: 8FC28180004
X-Stat-Signature: 3mw7wst3uzuw5jswyw4hsh3az8k3zn4b
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784296528-743271
X-HE-Meta: U2FsdGVkX19gLvi+sYpzKwY28kRn7/zgSO3uCNYW+jHiVbRv+yp5gqytdFjUt7/q1H8VgdUK452NUiEMtPW5q1InC8sx7P4usclfQO7JQLATIkzHipo7nd8epTUyZZKEWa/E77NgXKED1PQ/cpc5oQ4jtaFgMBBC3be9gMOe49OQk7pefN5xT3LFx5zUjJfO9NhyKUfHvYQLpU7sCwP27PqI2RoTl27AGkBgDr7jiMt3uJ0XaReOMf+4ef73IbRbg+1BvIB2eNg8zmp+Kg9qx4x+ACliwhysHyuuafGcFroSGv6546MGw+mDDgjhqhOQE3BBuUW6r807gxcdGykQi14139ubsJEfqjrEaRGL1fF77rUAnl137eMkaYqpnEyv9xuL5qd3j0xDG4FO1QPTL0mM/A+Bhx5OBlZT4A0ljM57+xWQ/BlFy2zknca4zgD6N27hJXvgd2ivMpmdJBguiAwqvM5A8GC0+kIgQICJ1fPgF7CeiWkj1B2rrK290n9K1ymr6di6HBesvoblURmXHEKDtGatGD5iQUt06+UZY2dM1eC2BcPR9IeMv3y0G/NhOW3di2EoDiV6ea+QqdO26tLO5GdgWoPLl0TZRr5fQmfeOthFvPaqkCxNS9mi/GgLL1IE+f632fiP487kp5XXyMCVUNOJPsbUsM0DH7ArS1RS/wAMIn4CHy7SZaUWvkKdP0KjtKJFD8QIn56zxk9wk33pAz+oEtlkSTnJWl34IeCkrgDoXemKQMI7oiir7vHHSQOvzHXiqB0gm382IcvO4KSiZW+aYxi/dFkaGf8cPpS4fqASDh5v/XPQi+tVnjel6aBeZE7DWvfFUw6ISYwzeCU08xvZz0Re8NbcogCGrrnRQCQ1QLxOoNDy4kIAbWB5CfNPFuafQ3EV15wxIpmLaI5dtpajPiypglDP5m0QLfyurB6L5dJZ6U63YgkCh3NLFXD5HH2NPqKbSRJBYFu
 p/FVxty3
 Ww+F70UiNQth6oeoEMfBLtQrJ1FPYdmtM36zVAsDTTBuJt8gDqS7Mi9fBiclrIQb24A4qvkkO0HUFPUJ0WSZERoR9LLyy5gqvLSBhHzgZvmxzwm6MSjK9mlQRYdPGzphFtF+NApGBrPR1CQ/gFvmPQtWQ2YvnHb0a/YX/VMkeFobkMZxQOktBvjlygWVoxl1o46ilKTGH0z/tVzxklDyj9QmSnBNR9w0+sCzlOSNqPGml1d4jJQm/CscZmRQCtlXTCRLjc2rbpa6BKjXshUytIqcfCDbIKodXdeFgEmyZDN3YkGpipPRHqdboFM013ttyO2JNJfsMrwXVcwFEu7Cum6cQWDnlp/0MC0BQ2nXYGMJa90h09nDNpXMfdiy+eNoQA3bA9dIUCSKFYjFdjARNxslvQ3qzmi/vkw2n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for getting and setting long user thread names with
PR_{SET,GET}_EXT_NAME.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 include/linux/sched.h      |  2 +-
 include/uapi/linux/prctl.h |  3 +++
 kernel/sys.c               | 15 ++++++++++++++-
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6a48517f01cc..0f1b40a5dbc6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2018,7 +2018,7 @@ extern void kick_process(struct task_struct *tsk);
 
 extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec);
 #define set_task_comm(tsk, from) ({			\
-	BUILD_BUG_ON(sizeof(from) != TASK_COMM_LEN);	\
+	BUILD_BUG_ON(sizeof(from) < TASK_COMM_LEN);	\
 	__set_task_comm(tsk, from, false);		\
 })
 
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index b6ec6f693719..a07f8edadd65 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -56,6 +56,9 @@
 #define PR_SET_NAME    15		/* Set process name */
 #define PR_GET_NAME    16		/* Get process name */
 
+#define PR_SET_EXT_NAME    17		/* Set extended process name */
+#define PR_GET_EXT_NAME    18		/* Get extended process name */
+
 /* Get/set process endian */
 #define PR_GET_ENDIAN	19
 #define PR_SET_ENDIAN	20
diff --git a/kernel/sys.c b/kernel/sys.c
index 3c37b5c1c072..26d5026f9590 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2535,7 +2535,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
 	struct task_struct *me = current;
-	unsigned char comm[TASK_COMM_LEN];
+	unsigned char comm[TASK_COMM_EXT_LEN];
 	long error;
 
 	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
@@ -2613,6 +2613,19 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		if (copy_to_user((char __user *)arg2, comm, TASK_COMM_LEN))
 			return -EFAULT;
 		break;
+	case PR_SET_EXT_NAME:
+		comm[TASK_COMM_EXT_LEN - 1] = 0;
+		if (strncpy_from_user(comm, (char __user *)arg2,
+				      TASK_COMM_EXT_LEN - 1) < 0)
+			return -EFAULT;
+		set_task_comm(me, comm);
+		proc_comm_connector(me);
+		break;
+	case PR_GET_EXT_NAME:
+		strscpy_pad(comm, me->comm, TASK_COMM_EXT_LEN);
+		if (copy_to_user((char __user *)arg2, comm, TASK_COMM_EXT_LEN))
+			return -EFAULT;
+		break;
 	case PR_GET_ENDIAN:
 		error = GET_ENDIAN(me, arg2);
 		break;

-- 
2.55.0


