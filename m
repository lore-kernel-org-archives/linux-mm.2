Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9E7CC79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 16:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876BD6B0099; Thu, 10 Sep 2026 12:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8686B009B; Thu, 10 Sep 2026 12:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7876B009D; Thu, 10 Sep 2026 12:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 301516B0099
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:50:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95A401405AA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:50:01 +0000 (UTC)
X-FDA: 85198439802.12.74D2F2F
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id E627F8000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:49:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=NOS02qo5;
	spf=pass (imf30.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789058999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NPPKZAStI7N6lxDqkkzLK3v+X0s+kCzQt7K1E1LT7Z8=;
	b=JRaorJMnVebYeAbe6pAOBPCRdyn5w1uvZOag9mg8ffJ6UQdRR0gvnUMPlJEVNUeIzTXue9
	lh+FmXjeU0USJJvMCwBSYPjb1NH09PVpoDhOBRQ7nKnirUVSS3qVxQyfm5tMjstAhxlIHQ
	8+3RavHvkyHdmqeaQ4MS/+RCi1xNZRM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789058999;
	b=NjJsFzdP/DX2hTmCQyLO1QsSTgt1YZ0Hry1U/XH1v2E8vZt3ziju9HrqsYW/GwDMFa1zAM
	j9k7ncIDoCzAFswGtZVUtlZcIPIz7aJd1ASelbj3m3iXWwkQ8QcAbg54h2k1R8QE4ujo37
	IFMbcZ36opRcj3M1hzL3x+mEg5r4YoI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=NOS02qo5;
	spf=pass (imf30.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=NPPKZAStI7N6lxDqkkzLK3v+X0s+kCzQt7K1E1LT7Z8=; b=NOS02qo5QoJ2/caZC+vrUIs2JQ
	wybjBGhaqXXHawkEH2ysTp0aKM1CNs6PKbZaIQPAoW58s7WEIu73mwrYy1lmKg3IhvoPsNjLrKQSN
	Of4UVkBJli7fxLOtnG+ojslanmfsLVTnaDi1Ed2FHCkQczJ1/L9tmvhFgfDzeKPwwQZMcus0lr0Ex
	LCtkev9jotmG0Y5tItHSiDE6X0akwZaXwQ19XN7FH/wt1A1cwDu0S6eRVlr1jk557quKJaeRS9xmm
	Beuhq7GtmGcpqPU60QV701d/K++akGAdqkdp/SM7UYlsCSoC2n5rBn4WfQH3FjHR47WZtFLTzmsol
	34M7L4jQ==;
Received: from [177.172.123.122] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x4hyI-000GV1-CL; Thu, 10 Sep 2026 18:49:58 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Thu, 10 Sep 2026 13:49:27 -0300
Subject: [PATCH v6 5/6] prctl: Add support for long user thread names
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260910-tonyk-long_name-v6-5-d70afbf194c5@igalia.com>
References: <20260910-tonyk-long_name-v6-0-d70afbf194c5@igalia.com>
In-Reply-To: <20260910-tonyk-long_name-v6-0-d70afbf194c5@igalia.com>
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
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: gffur3zzio3qm45mjeytjt1qj6na7zgp
X-Rspamd-Queue-Id: E627F8000A
X-HE-Tag: 1789058999-392727
X-HE-Meta: U2FsdGVkX18FterWVXZon+ldngqGPPzUOSKXe2GbzoaTkjN2QpyOWiAaJrhFqojj+XnsUoJT80ghbJfBUCAkNOx1G7eDt70sFHuOMfEkuz6Kpxa0ff8+ld2o6D3FiTCiO83BAnWSLa7dgIwYOWV9FTHhsLognQ7AQhepKioOK38kVQHJ06Wj624EBIUOV6waQLJsEPA3SmHfNzEvp1OqIkhbxlyz1svkod2JmO1JpPTRTkuiXdo+/ew5lC4adOJzoSMKQbGEx0VO5tx0FZAKCl7votNy4JiDanE10JEw90UtXV2XZHVy0v0RS3RuLEnt+M5qWMqm6HMac3dIemtee78/HPq7LWzlbH86HtF7hCUX/wGwE7q5M7Jsd5qc+v1p90nvzEk1sMZoW5B8pIUjt5bONC51Lb14XLRFRKCjOvYjAP92x07b3YmRObHAeh4gBP8Fs5ZLAi/ZwSC/tMnwKTyMPV4y2q0rZPzSAl4y9V5uzoCJxpaE4avH6mTgpK9N77WQc0E9zYhqBcvfEYjVAqytWcXPsyiVkZNJnt5IMdWHfdjUhwqJYXM9j9uJkgnWgAVjjXo03We8K5QhkwL48Cmfy9y4zBn9b21I3TEb+IvT5Y0Hiu7P7QKtDIAfleObWMI80ykUntmXJsYWFn/GDqf8hF0H3A/976w+NKHIQWy3KYtSQBUKMuI+D3UXIVotoEI5m0b/PuM3BRepaxVfARxhuM/t9QvbcHzHX0I7iWeKqoqrTjJX4UUBiFPlMY9EOGm1hQu01Moq2+7F36pjGzxgfbwSWka0wAHY3qogwEp9E5qYyHXZdpFDiY6le1rGv8gZJf3nN2ZjMfI9fTLfTrpd46l5Udij2nQRi8J4+fLpstv3ZFf/y8FK2Sx6nMgOnn4OBvyorYeGe4R1Cg1en6zxCt0ruA3roqWBu/LwYEw73qaWPu0frwuAiY0+EKm68QkD7cJ91SkecziMG8g
 NaucuHeh
 OdR/Z/xbqyx4IrxrMJqjuNWQ3R2FjrwGNSKIX+e0L2C9vpMQuHr7+la6Y/v3q9voXz4Qc6uALkFP5NTilTnO/rgfsR34s24fPUewq2VbAZxD5W69abAR4BE722uNqhMlUgU4rvQOhW/ZBcBoyQIJvPgJfevRX5OrIyd6oHZKnrU0sxfvm0o1opdPz3aZiD3mV8lO2+a8as7qH4gSCCk+msPRZSqRHGYXjE4JDnsX5qhIdtrAIC0oXUy+ygBf8vrcmGYkiSpiEhFVBixap1Fybx949AK4b+CvxMMMchtlO1H6sZqCTsgP5ZIl0sWHcrlpEaIx0zdVcp7/plsVmpFG/c0N/jmN4HEdIj6teC7usqONhtLsbhPPLbNCG86xZ98Q00W8aarDKf2PqRs3sqjW1TgDrRlSnvsNTbNNy
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


