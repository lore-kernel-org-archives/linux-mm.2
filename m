Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCCF4606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=Qi3NBuWX
Received: by kanga.kvack.org (Postfix)
	id D6BD76B05C8; Fri, 30 Oct 2026 17:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5966B05C9; Fri, 30 Oct 2026 17:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B225D6B05CA; Fri, 30 Oct 2026 17:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89B366B05C8
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:39:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 195BC1405BA
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:39:32 +0000 (UTC)
X-FDA: 85380609384.26.A555F3B
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7666040003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:39:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Qi3NBuWX;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf07.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793396370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PjseVdMtk+B6zIYS1/KaMNbcsZ1JXjao9cOufgyE16k=;
	b=AJ7wF8AhMdZcRI5R8+MjTd+vD4B50QzaebhTCHuOY4V+wKMVrjrBZ89yM7F9MzvkbkyM/U
	cFkFrSOdhmXc+yTnyhT7Z5Cde5yt4eZa3zEHbL8TApb+0k/o2Av7LnyRzwikrIEnX648mh
	wo5YieDYCVSOuz/rBXMnFA5KGiVbgSg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Qi3NBuWX;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf07.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793396370;
	b=mzuFmnSIkMPCXSJVibqBF/xW3ukdIadY7nNV0JHn5XZkjKtkPhoc/6NmDyOJn3n5/fMnKC
	iZKt5dlzGYJjgb3I/BgYyGJ4tNfMQb5jWP41f8n+2xyTfB6tiruMuA8PB32OE2dvZsIVC/
	m3IkexZ0P1cP6rBDSdXp/1dBejZunqg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=PjseVdMtk+B6zIYS1/KaMNbcsZ1JXjao9cOufgyE16k=; b=Qi3NBuWXzihQxtfrBDxtn/7hA6
	TuR2NO8xApdjO/9KXFbZMzfynJ4C3uFKBaEjT7YQwpWQ4DoJadSomUg+4u23eH0pdmPgyhElABozd
	scNPpuEdTwAIRHYeiHPmDDiwx05EVIzBNSD4Lxqe+aY7aLLom0o+fFA6aW0tYgVzHJ6MgUx+IaO2F
	OD0V435PAsZJkGZysN95NHllhisZEyFbfi8uZgZG8OQV5ArN7hUxlfL/JPTKUKdP9tC4O9D2jj5pb
	OZ4vlWi1FDnOO4sBcNpzi7qctnaLPr89jAY6u9Yfv61joZvdLzyr7GtJkmg8W5QIE9fZ7e/9L2bnX
	lFVIEGcw==;
Received: from [177.172.124.63] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xMuJf-00FNmU-2c; Fri, 30 Oct 2026 22:39:15 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 30 Oct 2026 18:38:37 -0300
Subject: [PATCH v8 6/6] selftests: prctl: Add test for long thread names
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261030-tonyk-long_name-v8-6-c9b030332254@igalia.com>
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
X-Rspamd-Queue-Id: 7666040003
X-Rspam-User: 
X-Stat-Signature: 19mdz4x1f1ghptqbwc1z1r1eqeahbrty
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793396370-15854
X-HE-Meta: U2FsdGVkX19Y3GN1jezWK4xrSO7sgg3p5oe46u/Z0X1EDu/SRxIqsYYTguW/Cn9Qd853sA4eah70GM3S3ApQkBv+/eCNMFjFvv8MiJRopajzbwzpEw7yLcwWN/wvlUaZgCXeVLKX8jsijPmV4gnz+le39a8WdzxskZoS9gIrHczM4dV8CYxuVIU6N5i9b5GKkADlnQHMg20Hpf0zTmONbZENnueigApkOpnnWLmdD97pNvRBjwaxUpZu15xxc7rq9dFsafPhFPiUnDI1MwXYzFXnh4YsC0Njq+ZRnFxMx7GLML3wX1Nqr+NVqTuEDi4VwvyamvrlHwvEgbUm1CXAP63ns/v7Y248NrNQ8M900J/y1/dYzm0ynMgH82UdAvXeaOUVF98Osaxhxny+cDMJcmCZdM2mMoSB5vDarXxI7MIlqIY+zStOhXuBte+V3LODTemGdxQH6XwF5f4VazZdYWZ8OwUY5pxnxJzaWZyg1lo5BYHVObheMYf5qoUrbz0g6nlPVP7DCImiAdEkIIk3mxo1HXnT2bRGPMD5avwRVGvCvW7f2LPmH1+ycdBmukBzsUj13adcOcEu5I1Atn4leKotTdMOqls6uG3l/aCd6tat6APOJWBtkWFfShXCiq1mLCFupFdRs0nkyXgGRlNO9vaAm/An9ceUrwXgahViq5I3E0QbCFBbUc4svmFZTw52IWxAuehllKWbUaPWt3RHNuvxG/M6Ws4XeNu/LFuPdEG+t6XVSDfW3a1zFyFmpqgE6aaQ1ey0nk7cmOS3Z9Dagt6Iuc6u1nT5IHh1H4eM29oe80kMBvvh8CZcZrjKAgeNPcjIj0nOscSush1s3sAe8DIetJIuk/ckO72zLKwe3C9FuAF6lKHnE9DFQ02cmmUJ7gSD+0uJqpSjqpS83TBATPcryDsuizpLY95CzmM6lFxI3wACl4vfNKJ58B8KP0yko7zoBMI5ENosR4aCVDZ
 ngBhtFop
 ZDaEBhM8cwO95XtdlHg//tKY8+6Q7nXbJqHgvJAPSZWWoX35PrXXxZolhigwoXARxbIPBtMCw3t9JEpIy9GNxXcN/n0kR4IvAJJHX0ET8W8vBasLh/bRDsrEVIB9IJqU14mhsCj4jaYUQ5zj1GKmnIcc6d3VChZxOiAUkZFLnK+1bjHKAJTB5iwt+SWiLlViRQPMKxAZC8OC7Qcaq7wXO4S4MTMQWFtbwm3Dd6w6zpzzWaCesBSU+9pf9CUPT5rN9asvT5bX0Zy9l+lUcONaPL8omG+ffTle6KiLkAM03aALUAULjnycj/pN1w+r0YdevOOtfB6JLxUQahiUUoUxqdvDhUa1qjp05RqXUf1+hDar/oNvUVgnF3QzNKmuT79ONkUXDPpBGQjGdssm9yYDPY9hPfMJeARMRKaRC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add tests for the new interface to set and get long thread names. The
kernel should accept the LONG_NAME and returning it accordingly. For the
old PR_GET_NAME interface, the kernel should truncate the name up to 16
chars. /proc/<task>/comm should return the same string ad PR_GET_NAME.

While here, fix the check_is_name_correct() logic. It currently returns 1
for success, or a negative number for error. EXPECT_TRUE() evaluates any
non-zero value as true, so the error will be evaluated as a success. Make
the logic more robust and straightforward by returning the results of
strcmp() and expecting zero as success.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
Changes in v5:
 - fix check_is_name_correct() return logic
---
 tools/testing/selftests/prctl/set-process-name.c | 57 +++++++++++++++++++++---
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/prctl/set-process-name.c b/tools/testing/selftests/prctl/set-process-name.c
index 3f7b146d36df..f05053aaba85 100644
--- a/tools/testing/selftests/prctl/set-process-name.c
+++ b/tools/testing/selftests/prctl/set-process-name.c
@@ -9,9 +9,17 @@
 
 #include "kselftest_harness.h"
 
+#ifndef PR_SET_EXT_NAME
+# define PR_SET_EXT_NAME 17
+# define PR_GET_EXT_NAME 18
+#endif
+
 #define CHANGE_NAME "changename"
+#define LONG_NAME	"change_to_very_long_extended_name"
+#define LONG_NAME_CAP	"change_to_very_"
 #define EMPTY_NAME ""
 #define TASK_COMM_LEN 16
+#define TASK_COMM_EXT_LEN 64
 #define MAX_PATH_LEN 50
 
 int set_name(char *name)
@@ -25,6 +33,20 @@ int set_name(char *name)
 	return res;
 }
 
+int set_ext_name(char *name)
+{
+	int res;
+
+	res = prctl(PR_SET_EXT_NAME, name, NULL, NULL, NULL);
+
+	if (res < 0)
+		return -errno;
+	return res;
+}
+
+/*
+ * Return 0 if strings match
+ */
 int check_is_name_correct(char *check_name)
 {
 	char name[TASK_COMM_LEN];
@@ -35,7 +57,23 @@ int check_is_name_correct(char *check_name)
 	if (res < 0)
 		return -errno;
 
-	return !strcmp(name, check_name);
+	return strcmp(name, check_name);
+}
+
+/*
+ * Return 0 if strings match
+ */
+int check_is_ext_name_correct(char *check_name)
+{
+	char name[TASK_COMM_EXT_LEN];
+	int res;
+
+	res = prctl(PR_GET_EXT_NAME, name, NULL, NULL, NULL);
+
+	if (res < 0)
+		return -errno;
+
+	return strcmp(name, check_name);
 }
 
 int check_null_pointer(char *check_name)
@@ -56,8 +94,8 @@ int check_name(void)
 	pid = getpid();
 	FILE *fptr = NULL;
 	char path[MAX_PATH_LEN] = {};
-	char name[TASK_COMM_LEN] = {};
-	char output[TASK_COMM_LEN] = {};
+	char name[TASK_COMM_EXT_LEN] = {};
+	char output[TASK_COMM_EXT_LEN] = {};
 	int j;
 
 	j = snprintf(path, MAX_PATH_LEN, "/proc/self/task/%d/comm", pid);
@@ -74,21 +112,26 @@ int check_name(void)
 	if (res < 0)
 		return -errno;
 
-	return !strcmp(output, name);
+	return strcmp(output, name);
 }
 
 TEST(rename_process) {
 
 	EXPECT_GE(set_name(CHANGE_NAME), 0);
-	EXPECT_TRUE(check_is_name_correct(CHANGE_NAME));
+	EXPECT_FALSE(check_is_name_correct(CHANGE_NAME));
+
+	EXPECT_GE(set_ext_name(LONG_NAME), 0);
+	EXPECT_FALSE(check_is_ext_name_correct(LONG_NAME));
+	EXPECT_FALSE(check_is_name_correct(LONG_NAME_CAP));
+	EXPECT_FALSE(check_name());
 
 	EXPECT_GE(set_name(EMPTY_NAME), 0);
-	EXPECT_TRUE(check_is_name_correct(EMPTY_NAME));
+	EXPECT_FALSE(check_is_name_correct(EMPTY_NAME));
 
 	EXPECT_GE(set_name(CHANGE_NAME), 0);
 	EXPECT_LT(check_null_pointer(CHANGE_NAME), 0);
 
-	EXPECT_TRUE(check_name());
+	EXPECT_FALSE(check_name());
 }
 
 TEST_HARNESS_MAIN

-- 
2.56.0


