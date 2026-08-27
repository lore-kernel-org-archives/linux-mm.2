Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57C84C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 18:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69D976B0099; Thu, 27 Aug 2026 14:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626FF6B009B; Thu, 27 Aug 2026 14:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EF166B009D; Thu, 27 Aug 2026 14:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 236366B0099
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:23:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B04B9A0185
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:23:51 +0000 (UTC)
X-FDA: 85147873062.09.AD1413C
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id 026F840010
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:23:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=rQUtyokI;
	spf=pass (imf27.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787855030;
	b=KiXksmx5sqEn/AHMgEDl+9jZ4BF6ftO4nMHKyCLjZ5P1SAsy9HZicUrf2u34CnPzPRlLXZ
	4TNB1R76zOzmEnpwxsfnBtThoHw/+DI4zRc9bbmO7AVxHKoazKMmgwWOIn54aEfjSCSin2
	4jY6NyVobnvE9dmumCmsGlFV9XRsFMY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=rQUtyokI;
	spf=pass (imf27.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787855030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HO/5xE4JJZ1CCxn8HlprPB8vAIdq2WQK98oz1e8eTqk=;
	b=8c1QeT+L2JscNOkGwoGVb5Nz8da6xklnio/UUdifvsPZ6H1gBMy0ydTi9SPMaN+pGRosnk
	uD2imVGdwYpXpSTpU5vMqLF+t/GjjilnV0mRnbtVA3CxBrVgifh63gBxqwdsfNo007FIqE
	3c1XUdUhvrWkMCvMCCABLudphwPg4dE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=HO/5xE4JJZ1CCxn8HlprPB8vAIdq2WQK98oz1e8eTqk=; b=rQUtyokI1+jdIsJPy83y+Fg5Yl
	Ykdlki6QcbiItfEuyFBe3MFOrNjpg8SmMHtqy4n3rHT/GB4Uf7zlPQQR9G8V2QeLoyzLECF2IpJJ5
	TAaVZHOwz/Qd4UaT2u8Aeu6HxDfwc75H7UoQvHAhGlYsrdRPSIW1puQRu4jtrPBRwMT08rrdVUJ6D
	TUA5o5K55J2OqHiH/yl37NoHMarjazIsWehaEVEWW1UOC7aRIAZqA2M+V0ErctgEAGXtGq1JpIvSd
	84AxqBF9/cOrr/+t4sTQyffhDB9N/s4TH+T72yXmv+Oe2hTrJfPfe9BDjLxGEuMamETTdAPBgdPhU
	aukUHCsw==;
Received: from [187.57.78.212] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wzelM-00AOUg-Bn; Thu, 27 Aug 2026 20:23:44 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Thu, 27 Aug 2026 15:23:04 -0300
Subject: [PATCH v5 5/6] prctl: Add support for long user thread names
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260827-tonyk-long_name-v5-5-5fa843782a00@igalia.com>
References: <20260827-tonyk-long_name-v5-0-5fa843782a00@igalia.com>
In-Reply-To: <20260827-tonyk-long_name-v5-0-5fa843782a00@igalia.com>
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
X-Rspam-User: 
X-Stat-Signature: 9ksb3iz1ictsnw6zj57zfwhr7qi59hy4
X-Rspamd-Queue-Id: 026F840010
X-Rspamd-Server: rspam06
X-HE-Tag: 1787855029-116375
X-HE-Meta: U2FsdGVkX19sNzOW1JauT9cbc4BcPs1N2JFAewkNHE/l4BmXVCL0ow2WREzx9mm4JxHlyPDCeUEBuzvz9lY03AXNMfdY7/gX26jrKed0EKc/bEGGhPtlFwHD46b/sewSvL8QBkLwXeFVBiiLZ/fbleXvRjk56H1zi95DsLX6Vy/50rpzfoLZuCYUBnhndw/PXmcdO/UX1pi3CSR8pySlYnaWAt1CPCN1vslklYVbRlgAUCI14XeBrtf1MitV9d4DI33cytTxe0lBC71YP55TjjtakkIx/rtfsJo9PaZfefgLZ3q094Hx+O1+xtRYtED6tiVnvPVyMSG0/zi2xGF0N6VIOxpbKpMwlusRvyVg1DKPq6bqh4HM763MXliBO5iNuI1O9aUGoQFbRjmtz/azl0z0VHtff9bYAzkF7c1qxHHK+hdFzZ8qKD197eeMnP+iKgjReYcayRVBhyjfQqk5InDVJOs4Z5aFBFSpYCpMY5VgKcleCdqtvGQgFkrOYESvUNbR+U4FIXUgk8gTgcJKeUtd5PywWzV0aA5iO67qsCAHYQbfql+dAqTzSZVgMNp7mtMKNQkjnnKP8AYeYWyBVRKnFlXsbBeiJrR5e/RFY3qQGjK+rJVlLAkYMs6GkLGAAp63YBWhO+1h9eFOy1za71vtFLfcL8j/pe3Q5b6LtD2d+5mGIPygffBf/JIj23B3NBCUoFsgRNb1Goc6lsOvV1yC6xfzmOsepNOWjFwIsm+5xeeAwswD5P/bbLqkiZSUwHDWWfL9+GwHm0CsVIhPZsqqesLX9osMxTkHRGYC/69YcnAreOB7uiN3ZQvrzEr6RN1h+DMOobbCTt5BBUZGw1IaA6Q7UT2s2sTjpaESA8yiUq7tMd67K/Y3l0/6aHhdpW24MCVRCDOeq8DKAfoW+UXnHItOaEfgeCRcUd3BslrYYZn6wTLqmdw7XsNlgHgBbRo+EJ7eHogDCrhDUo/
 qZNnoNX5
 pfkQIxacm54mgMSaamjVZQV+S6AB957eVcG76h9U0LBm6QFWYacEnQOpMzvEeReBucMhoXMHOMS8dCQujskq54Zp7Vio0uG9ZV+idKXhjgldaepDdDeLJKptY2z8W8R+V69z4uWHVeCDYX2g+Ta9zAjKgJB33ippka/23s4llgJrd8LtJ7OGkjR+iGW1wbXfXxFwXNc2IvorHSTgrQhNFYBaIj2rSJ6TRrl01Ziq1moH3RHjgjwMF8u5q8rp7gcP/Iqqsd7k55hq1V3dNVU4pLXqAm6ZxjxvL7VVgpyjXuQjTmE6ughRFLudWBUzh+r07KzwdBrI/KcxrdnGfj4XEcXZljn+kc5r0PcrTeioOcBG/HpBxhNDboRMRdd1Srrcsj8X0PxzIUFxfD4ENkBlI9eq0tU2agMkW77Us
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
index c41d61e9babf..4f2cd802f172 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2032,7 +2032,7 @@ extern void kick_process(struct task_struct *tsk);
 
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


