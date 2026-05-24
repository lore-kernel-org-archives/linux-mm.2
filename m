Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2927DCD4F54
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 22:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90AEC6B009B; Sun, 24 May 2026 18:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BBFF6B009D; Sun, 24 May 2026 18:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AAD16B009E; Sun, 24 May 2026 18:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63C126B009B
	for <linux-mm@kvack.org>; Sun, 24 May 2026 18:40:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2738F161F1E
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:40:21 +0000 (UTC)
X-FDA: 84803783442.18.D5C5CC5
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 996D14000D
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:40:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=iA049rNy;
	spf=pass (imf01.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779662419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgKKOAKtBLHbCbNFX0Fho8kvN0dZzv79V8RbAyegXZw=;
	b=ETpToARreMtWM7ddvs+MtHmf98SFdr+mHt5nvK/vm1Mj2ft1BfQCwAu96OK1v5jIHsmDhg
	2BCTY+vCQ8jOE104lyb9zSH2E3NF9wepCJkFE+uZQi8XH1jhAEqSmgwt9aM1PKtzJXygZ0
	vDUMjpECLSBmCgincf4SeQ6/kmwzzs4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779662419; a=rsa-sha256;
	cv=none;
	b=Ds3k4lCU7i/VI4thfK9SfDEgozfuisdOoZVj5c9sdhApR7vvHHsZO9D0usidrPOyVVze+G
	45wHhkvvVsWARUtMR9ZgoyYB1iVMH9ZwXahReDRzxthOyvA4Ky6Hjvxii2I7a2MncJUeLs
	KNgfX6qAPskbnj1pyLLxH6qYnQv/FLg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=iA049rNy;
	spf=pass (imf01.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=lgKKOAKtBLHbCbNFX0Fho8kvN0dZzv79V8RbAyegXZw=; b=iA049rNyxgdGc4JzorywwzByyw
	G4rzoaKzT2/eclyzFrIS4en2gTJIhnjH0G5BqbQFptI4ia182/75r05W9fzy65tp2UKArtfpruehz
	sgoPq4/RuDM6xAXUXlFvQIOsNSME07q1/LmDEveQXupqOpG8MaZ3xoEUSeqS/m+y4a2zSSchG8ttY
	OMFZuzR2cSH3SvUSWmk9YLgLUwU+RejDyYBIkC3D1tgkUcfCfRDAykpg2Xn/JI9LVDeWDaKP0+Ky7
	iYQN8mKM5+6aD5xRtLRKLUjX4Ty87CLXkZcK1+ZizSPV2oaRpBa/VKUha5K/BYRiHKoS3vBTicX6x
	aQXE184Q==;
Received: from [179.118.191.12] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wRHUN-007fJn-9p; Mon, 25 May 2026 00:40:07 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 24 May 2026 19:38:55 -0300
Subject: [PATCH v2 5/6] prctl: Add support for long user thread names
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260524-tonyk-long_name-v2-5-332f6bd041c4@igalia.com>
References: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
In-Reply-To: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
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
X-Rspamd-Server: rspam11
X-Stat-Signature: i9iom3j9ps447j45gqrcosj4whdfi5s4
X-Rspamd-Queue-Id: 996D14000D
X-Rspam-User: 
X-HE-Tag: 1779662419-735466
X-HE-Meta: U2FsdGVkX1/31EZBN4OJnuBRgLPgjV+hhA9zWCtDIzSP78Y1JPoR5vj8cOoQ4EIrYWco92jdGHM/HQGaN8JfiJNIFkj0Z+eK1lSRu1dK+RvHiPrwxOHAxn9II6g1M49XvdJFFUEQ1EiCSW7dbQ7/XybqbDwoQ0br1GvFrEaWSV9k14JCvsotDQwHNEz7TwAS1lz0BuY8OwNR+jWt79TzJyv/g6I2jwTWQ6F0verVqQFIB7Kudi4syHCWCKSvCxqh59SRw6HzWM3wuzwesds0uuL81lLp1DVM/g5v0XLPlCib2OQN/zdkCD0OcELC7cUKXMnV3cusqD4PjU7V4vtbHjO11zJX3xnSYCBVXtcmWW8tXU7yqALJGWoYMDIMinnWihvr3WXeV0HezWd8nTbVc/AltMb5FWCpBssgfRBMD4k/QFMme7UP2oV+18dECUVUtf5J31iqlp2MEKgn/3BMJynn3s00LDVJutn0TnP0V2NmYJ0fpwyAbHbh1v8ywp0JzwOW6imV3YsoIrDCC1b1hU58HlJjH0K8psaLiJFN4K5MaYBlSkbH5Qtmnzsp9HEv9cJKoncZKzeLTtS2GGVKW0f/ZJmZNATXG4As8tftLBWvU6BjD+XlVKv/sinQPED8lRkmB3Ajv4grOITCwiyaz3bEwwOj5fwr37qoy0jYUyIADWkvyahk+NJPEj/zRpdkk/79xd3qej2ngditYVJkw+6OKmEGVTEDXaj4p9npGCzJwJ05fGqhwKW2ZeDxkdnUY3UewDrFqNmMs7vDOcoC2sN/261LQEPKzerCptaVfnlU6OlGF6zbUvTcO60OHaa4D1MObuKXlxJqd1LpaUNV6WkKtXA8jiF3hiI0DqZ/EijpNAivVxIeM8Gdt2iVit/f6ymVy3HFFiuEOrFft9T9qVlwE1YRFhGoZ2cEG12WhJtfC/xMax3LmvbuK8aNP9pBI0bOSXFhhUevKOPpeHq
 2hvxsV0i
 xp3SPeKHAZ7W1XO6lgXhR4gWzVNoIbCpAvublM3X2DqQfKNPW2WCh3F09qdAzsSD5oCoirrsz5nGZ85kR2apURARTsfcgQWqZxKPmNXMrOndYDE/hnK1yVn1uO5uy2LKalU+xTM+eeYltK/VVNhkQvu4bqtTQBrFvw1kKmi4AeyrgVksT1c0cVU/nag3flIPZUx0Wda1HW9ETiQxAfUkvlKSNnjaAApqlmhzDmQB/VPbr3ltmi07+eov3zYP4Jyl89zMFhrZuFntC6hY8UpVsKKW4AHppD1607t0+swK7KX56EAN4AxQmrTZeSGN4jXy2aKPqW2D1J99ry8VMSIzOKI4c19XGK7hJbvQxTils+KVVlKkVkI51bqgohFgFg8K/OJhpT9R3RqTSoysgci04S9wneatbqALu9aNEeacY+WmXqYMoswqz1wpqog==
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


