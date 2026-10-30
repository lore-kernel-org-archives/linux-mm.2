Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C785D606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=XElzl0Gp
Received: by kanga.kvack.org (Postfix)
	id CA8FC6B05C5; Fri, 30 Oct 2026 17:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80F36B05C6; Fri, 30 Oct 2026 17:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B967B6B05C7; Fri, 30 Oct 2026 17:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A59A6B05C5
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:39:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E887140735
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:39:25 +0000 (UTC)
X-FDA: 85380609090.22.09F658B
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf24.hostedemail.com (Postfix) with ESMTP id 87E00180009
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:39:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=XElzl0Gp;
	spf=pass (imf24.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793396363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/YaOoZYDy/D7DrvfmZL+IRrQH3JuFSO6JeoJL7dP+U=;
	b=A3Unbq7NFMh2s7oS4F4tj6Xml733/DwDVrJJSEFXs/FK3x/obmPywoQKrIqbGzLlNYxnWw
	5BLw+5ZHzFOYdWcsGay4DNYgKVgSSrc/rSWcvnfsDRY/2S8/THrO8tMv0qv/F99ylzWgYI
	fXbQXAXVyBRZQNTMWTCtomu4od9OCFs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793396363;
	b=tOfKJ4M4rbPLqjvwfEf1V0vTsi/NIug8zN5kJX9kUZoxiOP/489OZ9UIu+IbtRGwjnmr7k
	leVzZvG7/Wz4745vjdcaunalVJSZ+FQ4Ir2i8tutxOySEmu8JPR6WVu5j32P2/cSFT/1xW
	zAisTzkZrBDF54x2/LXvhmYqndpV0T4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=XElzl0Gp;
	spf=pass (imf24.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=M/YaOoZYDy/D7DrvfmZL+IRrQH3JuFSO6JeoJL7dP+U=; b=XElzl0Gp4duscp1RUvZlqVcSjF
	Nw3D/akHRi/B6HFUyZjNiRwc4szLtE7YSE//AMF7Wc37xZspBiUSwtEY4nJwLsYnpRBroseu1LRXi
	gEDRnqRk16CA3Q06TV0OR9XjDlUDXKM8JB3XBCWq8brIj2Ih0YNSkF5fVvz2uDeDyPQ2DBKO4rSy0
	WYo9fL2rkNOC80tasEMBKgp3H2lTExT8CrGLySMOnI3aqcl4oAajPDEYROlybtpIOChKvHCKPKJfi
	HOYGrMYjBQ7AX8fsG1YJLciMRl9tmoqEKehwAv6JnR65r+mPD/Ets2oa+L5YvxOuLTfNluj3QQx8d
	6YHjgyFg==;
Received: from [177.172.124.63] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xMuJZ-00FNmU-OU; Fri, 30 Oct 2026 22:39:09 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 30 Oct 2026 18:38:36 -0300
Subject: [PATCH v8 5/6] prctl: Add support for long user thread names
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261030-tonyk-long_name-v8-5-c9b030332254@igalia.com>
References: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
In-Reply-To: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 87E00180009
X-Stat-Signature: zxetocsyng93fh8r4yqif5o11cjagxma
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793396363-682103
X-HE-Meta: U2FsdGVkX1/aJm9DBzrIcbaEF4JtSw/sSC5zpVoKSMdYNeQstf2dyEhu8A2HFb1yaGUvJWQ/RdSRLueHNijoOaRI226LmzjPxSDKoDfqhfh+YpP5Zof4Il8B6GtcqGfhiBWeeJvXLeKOAqQpLEHgL9g2QF3fBwOGz5gztClDQq1tXEiR3PNNcKNbAzi5JZstKVGS2RRPMBNEGURtSeClhWiiRpzWGDbnlC9qRVqhDb2M6tG3ch9IG8PZBNqiYQde5SdSlHO4pX2RcD+lYEUnQeTfW0WH28kHs6fWLVloGb5+GldKhI/uEn4GeGqIplLwghD/47ePfYFInQYu0JNEjZYX77bGyQmU0scw10VQ5/1vL0pR8EAVaPJh0Xn60vFbAUWrL2BhkMEOT0N+CQKoADBn3ns2peycMzKb6Pg1hmJG0G0pGGmFWfRkxVDbZkS96u5Tr22wB3V1w6Cre3zE+txh8eApVcbPJVDbNGEThyuIi4Jofa5NDCHXIllFY2oiYveNhweu7ImmMHsROC7JKzW30EuLXjtpKQZMhZo0q5twhipcE2XbsddXrPhbtjmdUWmZWHaQAm4ukAsqVIPX7WkEFSLsmpvqF3laxBxmkIriBNisQkdS18GIxSffCwmIOBKTpjgXtDVjS4mglqvPLHDMkEMvg+r647MXeCf7vUkkKHWMtgNL0oJGB0W6/ziAQcDdWmxHshUnW7huoN1c2t+pQmVS7Iu3/ogj3PCsKEpLQeRlHT7FGXWF2kEcjh9G6TLn1S5wMEOPttsVWkHUr9HO31gLTZic84zdRr2+ltwGjUbMMwKYqKPhioHKAnZcVsN9iAto4gDfNv7QRowAGUeYH+A6xnOY7ENMPpDG1DGshcCNzvvNgJ730EdtsYGnN5le1Ci4I77fIUJhTr0OTP5GIZOeq7HDa3cBpD9TidaADQA/jmC+e8aFF5xNeBvGV0gr3OgHqxnDwKWK0I7
 boZZOJfV
 X+xU4vhOWq0jlCDZFVUJds3zveVfViau1uusuNWkBjur2ecl1yFi9jhcWsLV0ak5wzeUDwBl8iwwg1hZD86X1XmXj9rI8zlmJkcwHaH5C/0kz6IcnapQCj3sYKKrGlE2kuq99mrGpVptiWEmyHaOFEbOOc4V3+WOwxHfEBmuBSwspVVlMQIrONhMVqcC1QswdyTdO9jSuZ2PHa7MPAja6mct3CoYJVIEltXRCtj+nJ0fOcxbZJm37pleiiYuEDgO1yHO5YFHOF0uP7WdOGMO4ZVtSWYKriECRv9OILVQ4+aXLYaWYsovmiIFVy+B0Br8zLRqWKdaxqJyJlaXfgL3h8IepOy9dFQlle7bY778Qhyd4irwAuxj2LfToIYMovU+bpDWyUW4k9nt9twz8DL3Zj8EUnvz3gkQ8vyZW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add support for getting and setting long user thread names with
PR_{SET,GET}_EXT_NAME.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 include/linux/sched.h      |  2 +-
 include/uapi/linux/prctl.h |  3 +++
 kernel/sys.c               | 15 ++++++++++++++-
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e02bce749b8..c9477ba674f1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2039,7 +2039,7 @@ extern void kick_process(struct task_struct *tsk);
 
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
index 6a72c7e644e7..fc9e3c5a9135 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2538,7 +2538,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
 	struct task_struct *me = current;
-	unsigned char comm[TASK_COMM_LEN];
+	unsigned char comm[TASK_COMM_EXT_LEN];
 	long error;
 
 	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
@@ -2616,6 +2616,19 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
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
2.56.0


