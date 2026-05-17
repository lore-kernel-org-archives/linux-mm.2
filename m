Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92BCECD4F4B
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 092726B009B; Sun, 17 May 2026 14:37:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB596B009D; Sun, 17 May 2026 14:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29206B009E; Sun, 17 May 2026 14:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD5EA6B009B
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:37:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 748C212052A
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:37:25 +0000 (UTC)
X-FDA: 84777769650.15.C23DB4A
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id B47124000B
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:37:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Iebe6Qz7;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf07.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779043043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgKKOAKtBLHbCbNFX0Fho8kvN0dZzv79V8RbAyegXZw=;
	b=EYeBBBCw5VsEG8sNoYQO42XSV0qgDK9UyBiPJOYQVOifnIc3Ct13eaorZOny8WOtaUfh49
	iGnUa4pYbnjCh5bxzXfjin0++pxke/tNrdN7x1GpB8ygG+yb/QFXoIIHg+14XejAgUfDif
	jFcTtfAC3bwKXCtD6hAgPaoWG2g471s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779043043; a=rsa-sha256;
	cv=none;
	b=5+xlKSRwRYVYuzJh36E4/U3ymElCSqY7EtEzlptvXXe1otNiPylFfh5QMFDfgK5vXNlemk
	LNunQ1wKqXoId17veohEW4DRvVih/vtPu0XteUPhyw0OII23tCuCprhOhh4uClVp1DjVg8
	FaE4YLRoc0Dw8j726yEPpwYs9/fO0OI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Iebe6Qz7;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf07.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=lgKKOAKtBLHbCbNFX0Fho8kvN0dZzv79V8RbAyegXZw=; b=Iebe6Qz7co4TTXTHE6u55ZMsqi
	nz+6V71obbR9JQjbaVz6iUoGis1PHIB9/M9+AjovPfIzhzmZTeZ/GKw3PRSrZ/nNk4/Tjbn6X/Vz3
	RJOfprpK9lp7UCkMK6VkoLQV+uw0iZlC/yDCA+NHdVzUlD3ZnjrLwsaaQv+8MbfCtZS7skvAGXyzj
	TnV2sn8gRBZJP79ROEnw4/h2kRpdTpCcjbVlDZ/7MGOGXhNiqDNIIyLXDTroRCfMv9EUkXT9NbjZq
	CzBuinbHpuUhbkNVYl+9wqViLvK+OjlkTbzbZ939b4BMvjjzX09Tl64br4rWy71lFKXiFt+SxFsS4
	Z8AuH2kA==;
Received: from [179.193.2.40] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wOgMU-001cLz-5c; Sun, 17 May 2026 20:37:14 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 17 May 2026 15:36:15 -0300
Subject: [PATCH 5/6] prctl: Add support for long user thread names
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260517-tonyk-long_name-v1-5-3c282eaa91e2@igalia.com>
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
 linux-api@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B47124000B
X-Stat-Signature: jbrie3mfizmz4yuaksonceonjezw8s98
X-Rspam-User: 
X-HE-Tag: 1779043043-128116
X-HE-Meta: U2FsdGVkX19vRAa5Eh9R96kHeoUq/d65ciCsnHL+zPL4yKBvBYcE4fEgT8K/w/woByj9bvi8G27CT6Lrgo4KYfmXkpyGfVC2e2gvmpOtK6poXmu1bNGOv8/8HsLbZ9LGhdw656VUOkX+j3pNetG98wkXNdyEe59kA0Gym9+IXwDeqy28WIGIOEpDjQ8RDkvD+pS7cyqpDNlMV07WU4GIUMTiQ/zl75y3cuDieTGybWIgg44D7hQSBcfMhLlxTmyIfEeXjDoKm8JcNLONd8LhQBLcyDMcyH79tVgWJkGdD3aFu6Ht/NuHs9gvMhpP2/ld4/i5hIQApSQqCbCUEYsCDfbSj4Vg3cMEVpy+HRRgvERbcnn5CZ9GzaCG0fkHaaytZnZTM58KgMXqbvlCPCtVynMMurtCSSChJJjOOhBiK+rduajzXeOEYloJAhuUccb/XXpMVDeUP2MQjXCR1ULyOam8AHqDeTCsRgb4ihcWALPq+IFjnMsHX+fwvRIshlOn8e/875O2nIgG/M434kHju27NQHAVYH7pqn+dhPqx7o3b5wN6SMXgGHtPvLFOtsT80pMzXfiDYW9P9zYgrYSrUe2srrrPI4tC9xi3LNE7JCOUpcsmdgBfd108GJveGFQ83/C/FRWrDD5HW/m0LuyywnbnuiLEO3sDX68N6IgaQ+fYczd4zrixPdsy2CBJN1i1OuXNeC8UwxPTka9nSTD6vaDpmSKKoYGOt/hSKAdBoiAI7yXAOVBJdh3XnI/2CObAyKLXv9kjsyGaniHjprayoESdX06p+lzmLlmvf3hJHdj3qvfcgaSYM1BJwGFZJcxQbzVXjavXsYoZdnZ55NNtGkEdwJW0G0dofgqGhiB2FfnOsBHQzIG0vM6ymT6nsWo+dJ/iZ6TfWHKylpx0TCM4WQBQQZXm0LHG2aeVtZ3pD6Nb3AtQyWI/JizxJUWMC6UUVfwil6UMiPdsVxiHIBJ
 KOYUPZoI
 mzsUkkC/g0X+Yr9bh5PUCH9P8p+knCWBo5IIRN8HuS+AT8DxSl4IUWuwjte4zMsbWmTSxyuMzxpgxEfj0kIV0iCVuOp6YqkQBRG/gk7F0UzcXPJp3dZ902jaGXcBFV2I5NVzeFSmNKf2CHF7rSMvxbmD0/DTVA9aP5TQwrNIzEZUhaPWxfcqIvQGCvQqCn5dVxz5Y/RcS5GJxUNIKWi3GcUMtyeAUbIWZnoOAni8z0ldNI/WzMRnqoBGBFwhz2/md2cjfJ9K9wIZYmUYR0GttXGCj/Se/2hnlB18hEfvOZwXLGRKd2HsjwgeYiJbhhPY3vuzejhfeYTfOChTftD7K/VUGLXa86AgAq+mQH51q4RYKxUEOZt6NBJlKiRkvsrBHa1n20Y7L6rIYvB33N4bf9ao2uDIt9a90dERwaI3x6rPTZ2bYHs8RYvDS+w==
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
index f7fd2b7d131d..fd4256c8627b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1997,7 +1997,7 @@ extern void kick_process(struct task_struct *tsk);
 
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
index 76d77218ab19..1b70d53da998 100644
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
2.54.0


