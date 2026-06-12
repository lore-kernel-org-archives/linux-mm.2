Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC87CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11B506B0099; Fri, 12 Jun 2026 12:21:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F3AC6B009B; Fri, 12 Jun 2026 12:21:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0097A6B009D; Fri, 12 Jun 2026 12:21:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7E3B6B0099
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:21:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AAFA8163E5F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:21:18 +0000 (UTC)
X-FDA: 84871775436.04.10938EE
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9DFA9C000F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:21:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=lH7OBkoF;
	spf=pass (imf22.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781281276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCddDmgd7eKFHxOU+gGkLiMWpKP/CXyHYadGUBnbgDc=;
	b=3PAs/Ie9WBeYHmOdoiYmPUoU+yhvaxLuMwU+0lsQPTFcyN0vtX2mjPzJxeGev00oIlcwd6
	RyONzBsNZPe544BxX10xSK3UgsPsjYezzJWPt8q+XPV88eHigAJJJIgJ9bXWysGHU7o2g5
	bs9/1mvavqlrTBWGWPqI8L8K2sL3EL4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=lH7OBkoF;
	spf=pass (imf22.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781281276;
	b=3Cg7DwxuN2zxnEMazbLrD2dOFrCcCI9fMcO3BxNXWroqXwfGv7ekfbAGfxikcB1cZc5LFJ
	ZAxWeZjoDcm93BOX3CYLms24l6R1LWdeij+Y3wja3q1ZpPtEPg4QTa+9emIqGXDWUfUxj+
	Mlr91U0Ax4ezDgIRREiH26sfZ5jrYKM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=RCddDmgd7eKFHxOU+gGkLiMWpKP/CXyHYadGUBnbgDc=; b=lH7OBkoFezBTIbiZ4lBQYtBZZG
	VDG6Vt4vZv0nBOXZHUh9ccIW7afgI/OCu5JfZ04fAx6WmoURNjBzHH2dTqliAp+Z6ndbbSqIVR560
	2oZXxn4j3dQjOBsHryau9UGU9ULniy9GSueDDdLcIvEet1A5urdQame+fE2SGuFGATDU6QLNeo59k
	aV9BvLLrfCFxQSW7z8AJYxO0KLnR+zYUmah5SewUU4DCj+/WEQoFAHIu16hzXH9iJ9DuLS40Y9F6c
	epnyGajFpAQJLU0KR4LZTCd7+1EDOR/sbMtxcPeRPUAMkBq2OW7b/F+fafoK8+4nFMUJjxvFFqSLg
	Y/gWD9Jg==;
Received: from [189.78.222.70] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wY4d1-00GgP4-E2; Fri, 12 Jun 2026 18:21:07 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 12 Jun 2026 13:20:19 -0300
Subject: [PATCH v3 6/7] prctl: Add support for long user thread names
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260612-tonyk-long_name-v3-6-7989b66e8a99@igalia.com>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9DFA9C000F
X-Stat-Signature: auowiosfn46yzt5kg6jm5578h4ckqcj3
X-Rspam-User: 
X-HE-Tag: 1781281276-428007
X-HE-Meta: U2FsdGVkX1+JSbmqSA9kk/+j1yI4tWVSAxdvGbtUGNpxpYiDMnbuWOEy6etzEg5dpIrXLQ/z7DSOQMRmFM6r8QBwN1z+t94ATDvMLokALuZdRFm9o9KLFMCzsqyF+p7TJzuhsh5PW+E168e6DuoCucB+rJeP0SbTkfUV8NWHmQ1wNmd9tLdyTYydIeW2fHKCgF3pvjQdQI1foCydJ+zBDw6V4IKYifRnuFOT9wt/aYGn0LQ92hbSu7WVqZ2nIl6aqD7+SlOlBtL8h2CjnGOEIgxeuVN3sRscUzgDCH006rn2doWflPjO+8rWd+tNUi+f2Iy3nZ40atlwSFzeSkiuX/C/jTrF0ihJzxqOZyGgR0TunMSZoB+h07Ol14aw/A/UwsHJtQzc2RJ/tRkAQLEUej+8vv1xsi/SuKbxp5XnywYx4ukXA35fzBPLr0K9A5Ag65pzZYHfmjlWDsI5Cjn4EFTJSgYjxhI5EQcvsl0GIkQtO9M43mdrGxLzwDEuQsrbC5Px/HFPrb+3MNYq4NIrPlWf8wjmod4WELWQR89VBmJvp/xWZbka2YsFCLuA+X2K9zRQFmKFuriR+kF0iCe5SSOJ3ujARr9cImo/4hqH4wPNZ2/ARgHINTxF65o1QfrS/9qUNphaNLUS6f/EY79gx8iqcByFS546HB0CW/vLPPwArVgwhJDmBPMSXCENWCfVMFnesV4MtLjxNUaDFhdMpELNBSli5XVsEwfNzKBn4ZrmKi4PMkHeqGiX6yoZqvGEFtgrQfi/LPuM6w90Sl7o63hfIWdpdg/C7qcLQ2KzVKsKHaY134dOHRyxAd9Ws68Dvg3bI1xwkHWmJz5qL/ZyyZhUFe0KwZ6bo4XI4RchZGJL/7FRVK61UrR9zIO+fif4JNf0d4g4NEO/TuUw0IqUUGe0xQesIu0qpDrc3I9YlolFPc//S8V5jcnDg6H88jwio0Tz51wCwnkNRNtdY3x
 Iyva82kL
 bdbyh3WKjxOK9ggeVm07W6/LlgkcdrNpM5R82LqjRvIn7WDW9XC9AWLwgQrp3ZpAZWrpihX2klRnWq03SuAfwgzHIjcYi4IiudjT3bPoTbEkRjflBA5oXfYxGOklvtVJOjKluQSmYf2/on7cJmHIWq4cVCnmRMI5Dqw7Pxcb5Iqnw4z3TlR5kOWOA84FEcPOXq9StVtdxJxj4hnEs1GOqgYJlK+kEEqIsSogH853kLLoJRyNaXkL3vg57FhzeFdVtoGO+zpT8hXbNYIQordDozIqkMt/f3DrlL2z3MN39JEjrsi/s/2cyH/dkhMRtik/lL4jL41xGkbS53EoGNcMn/TjNY35Ntmii8vWvDv1nDfvZc4sh1OqzHCWHaiWnjPTMk4Sp69gMiaI0eC3aK6I+UxzOseIP8W9xuXV9
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
index a5dc0f4e7975..5e167023fb81 100644
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


