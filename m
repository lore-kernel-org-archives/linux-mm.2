Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C73BCC88E45
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 01:25:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CD9E6B009D; Fri, 11 Sep 2026 21:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255DE6B009E; Fri, 11 Sep 2026 21:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1932A6B009F; Fri, 11 Sep 2026 21:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC5B26B009D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:25:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 415D51603BF
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:25:01 +0000 (UTC)
X-FDA: 85203366402.26.7F33C8E
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id A057540005
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:24:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=P3f3o761;
	spf=pass (imf01.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789176299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NPPKZAStI7N6lxDqkkzLK3v+X0s+kCzQt7K1E1LT7Z8=;
	b=xkgPbhG83T+WI/p+moLvfg5QHggHJL9cxYf3brR19Wo7CjqEUVcp311eALQSXcmfnEt8d4
	WBjbj0O+W44QRzYaZ5OBKWP3YiUwvLI9OFoo52OMQuqKJEA+EgkPkyOgRVCNqwdNmMGMJO
	VUDHyrvUaSbfQAPF8J87U8JJ/kOLbzg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789176299;
	b=Eyc73ATCtVw2Pz1gxG2h2qis6n9Wus5yHQr0vXQyLcWE6H4agw6uZGAE/iG4ovIKxNbaXZ
	UyfvvrXArlfcS8WkP3dxyL87YNs9RyxE5xREzumzEsYdMgFbzFJa58wVp2tNjToscTgVH4
	aLPI7/2BmmCtY2JUKANVj4kyggnlFCo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=P3f3o761;
	spf=pass (imf01.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=NPPKZAStI7N6lxDqkkzLK3v+X0s+kCzQt7K1E1LT7Z8=; b=P3f3o761WI0uDfzHUOSMRa82RX
	8cPAOewU4S0jezVJJWf6WcMvH8ZpJAIAA6tUiHnEZFnAPzE7aPPqCorzf1iTvhSjYNC/xBywMIAEE
	4nfv4pzC7QsD8TnqjS+UwNjJi4hN6t09npZ7k7jxJOJZD/YDpuZteUAkE3kWCVG294KC7CWjK7vaY
	Z/mGE0CYNoX8+jC/slr8o6HxUIL0EhJ/4nJHGB/U4e+SKhjfoha9ydob+Ize7o05v7XKedVz57V5W
	XUviyLY2/j5dXuRiUnzoZ/4cFZ8rufXMmtWi3KSAoUmwUzvOeg9qdIkMrvP9jffVWofORVMTOpv6e
	MnYTa/YA==;
Received: from [177.172.123.122] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x5CTz-000xjI-PZ; Sat, 12 Sep 2026 03:24:43 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 11 Sep 2026 22:24:02 -0300
Subject: [PATCH v7 5/6] prctl: Add support for long user thread names
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260911-tonyk-long_name-v7-5-34e1ee1564ae@igalia.com>
References: <20260911-tonyk-long_name-v7-0-34e1ee1564ae@igalia.com>
In-Reply-To: <20260911-tonyk-long_name-v7-0-34e1ee1564ae@igalia.com>
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
 linux-api@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2
X-Stat-Signature: gtyzq5cw8xgzmeb1mcx1xh6ztos89x3p
X-Rspam-User: 
X-Rspamd-Queue-Id: A057540005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789176299-729660
X-HE-Meta: U2FsdGVkX188TUlmLD88NvzSeiuxYQsrSh/USBLt43mHGg0GYlpHe/UOoTEtRn81t/yJrgiWSopvLZ26k+FMxugMt0k0fM/n8LQQZbBUyufnVwLo03mcEeW7AFuJo5jPzuEi5wFBHEWnO+x1bOgU7JpoUh1me+7W2z8lkGKByDNFSzb+nrZyJ2KlsquJLyhemqCG1HiUYe9ehN0/OLz8HjoP3dxWxAtTlHsnU9Y+mmLyfm7ejyaoppBE3or0WzE0NMxHvpwOS6X1TvZ1t8qUzwznqSaCZ+tIavhHs7BZSxKHlrBX1WxXFNDcVQHL6zT6B2czCeM6YSDZN7LmoR4OA3EuxRVxdy6kshV0C1aEV0vQ4LuOMGge0sg7aQeNtOwlgSPDzZ9eEFW4C49/DY9iISNXfmylDtXEXQfa3XVrGL9S0yGwDVBnoD6krDgkjbLa53JjN7RGr4y4QBbvkC++yXyLgA/f79ZrZYSu94N/bZTCujhF/4YfLI/cWTckIKpumlH+nwKpxcJKLN7Zyq3CJecGHv9LVgkwWub75BAPaT7hrM60vFfkZUTadaTkZigj4fHwh4wX9jPDqtXrTX37b0XCIb7snsiBfTuwGHS82sO5PLFcRTvtfipVDG8DmotkjiTGm4zvSlm6tsYPtl3wFvUokVl+pvS6NWwico4pqBD0HddU8Os3tNBmOg1xkyBMhzLCNF2JSDEbh4sWAq3nF/IuYcdEC1w42HxgqdmcT2GpEEgO00N1Kh4dw48jPTS63DNZTfGGiKr7aORLVFXIgOUdOqe/75c6cZHFwDCfUnUdmbQBhfsTyint8vVfDAwxLxd1gtmKRIvmeLYVkvZtJiAgSk+fkDIAVvrGwjbg7cKGlbM/LUYWEa5DsLPbi4azZr9LgatY0v3FaUyusWDuFmLlwwTKtyRl3FrEk2WDQX/xpO2t8+BQFmGwkPd7uuwD7/Y5eyYCUdQJsY3N9Da
 jEwntRxp
 qKwFwJDB1N0xxPeIZOEIreYVu6kOXAZeUOQXujbrGaWGKIXa0kuq3gSfntDKv10wXqc3bj57V/G7uOsa0EW4hSm2C41USsoqCQ7szln05hSclerfLcyBHCZbVLiXJDiicZsZVG5GLWFdE8ZZm75czE2ZUsgCy8WchMTp/jEUDn8LVnF1v7xqOUMZnRegWviLizhNKOLrPU9AHLTgwjOGqcUB839pupJPxKReSpOG+nFcHQum4VuE0wmk/Oo50Ib861qYEDz3ebfME4xTRicy41g5X8eagE5y58W1yHWWvp1J+TVmjRNjh/w9vqErfrHkJ4cqe5xhkx9EYPd2bUWpKa2KN+mB/wJbOAlBA+ziTeMoFmNVFID3j3e51Tc5xjJOFJIh2QYA+CUHIggQK0gJPOCqkhPONSHDp5fhA
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
index c4e0104e7ae9..0736b6a32dcf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2033,7 +2033,7 @@ extern void kick_process(struct task_struct *tsk);
 
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
index 5ebd3c1dfddf..4caf6ef836f1 100644
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


