Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F7C6C88E50
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 01:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB3116B00A0; Fri, 11 Sep 2026 21:25:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8BE86B00A1; Fri, 11 Sep 2026 21:25:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9306B00A2; Fri, 11 Sep 2026 21:25:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B89B06B00A0
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:25:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E635B80204
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:25:08 +0000 (UTC)
X-FDA: 85203366696.12.CF62D17
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id 465661C0005
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:25:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=G4PjwZTd;
	spf=pass (imf20.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789176307;
	b=MNQ4FKnryx2HhlyxamsBgQaDKSCH0FM5EP5g2IOjRWWHWozmMi0+LS+SUW1ajdM7CpTOz9
	u/EotQZCMzyuQufzKVcEXkeEaMjvz12heqYq9fot40UPzOelkYDKN/7m9RTP1l4F+24l4g
	2HV4t0af7Ug1C+OzG7LzyRfWDMeCW+8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=G4PjwZTd;
	spf=pass (imf20.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789176307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jkk2aKfOtQ1sfSPZp1MlJc6YMLBpwH+7BNfIjU4i5Cc=;
	b=ffCU0AzKVB1pcHeBqXIlsz4jlsyUqbVv8T+VlfbHSGdMfLVvg2LJh7TflzOvLq+H49eQzb
	W1Cn+f43vhvOLcUafTNIZw5ZK/9MPCzh9zyUaF4cxsO7umV6KlacKMbZYbRQh0lDqdKv5u
	Bbuq4PlIx8s/V8hkznddtHWGJdEg7XE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=jkk2aKfOtQ1sfSPZp1MlJc6YMLBpwH+7BNfIjU4i5Cc=; b=G4PjwZTdz6s2Wj0Xvl+D4VheFF
	zQiHRINyszkW3OC64vIaXCjQdeFXZEVvtpeHig8Vuyh7Y30Te+pNAr0BsoPMLk3nMVpthMlIXiROU
	K+uFqpIc6jbPP7wTEGUIPsuI83iMrB3oJU6BrQ5fNJFl+1OTspXENlGjPlsrTx/SMVJymYqVuFJJe
	sG/1jiGflCJAOrley8Ih6rtcERIobfEl0uF3ILjRSFSSamujg7Pu2JQFKBao07roSfx1Xo0k7QpTy
	xbVVUpvzJjNUOAbkS7u7rL6yRWYfXkpeq0INz50r2u0TUxdrBliP7l2WElXGpA8MY77nGrBPx7hTs
	VOhuuxxQ==;
Received: from [177.172.123.122] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x5CU5-000xjI-3T; Sat, 12 Sep 2026 03:24:49 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 11 Sep 2026 22:24:03 -0300
Subject: [PATCH v7 6/6] selftests: prctl: Add test for long thread names
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260911-tonyk-long_name-v7-6-34e1ee1564ae@igalia.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 465661C0005
X-Stat-Signature: wbxtxemhea1p79d6z6m3i1gyp1zi8jft
X-HE-Tag: 1789176307-675254
X-HE-Meta: U2FsdGVkX19zves67iUAmtzSN/YS5j383/A7mgBzQ+Ea/zPqXfYvY+MICYEqoQ773HblZYo6Sn0+w23SFj9DT14QMHGItzEC2eM0HNEBojAvmw7GSOPdpFPIwxF/EtyjjsSHSLPZUv8n9ToQA021ptJFf9CLKS2MpaDmL/sBk6mfWUEpRrPEruyV7z1JN/ckFPAIQ0CxFlY91x/m9uXsvNFq/rjALLzLj9gWAYKykvkhxKypnLZOL51ZZjDAN1qPVD39J2t0sZa/olfMw0VjpRTKIRp4QIv5+TRVxRopr7/OqEGyQVG6vhxtxjMdtNwAaAX9Wa/KqAeGBabkjvj9FnF/xjE77SpzWIqg/UTqyP5gVJHOHk8KJ2t76fGYJi+CPsnvq7HhNH0hbTgPM+pgzhGdF9Ebq6Tl4aOYy6Ld7/wASGRWHATLuVLzqwFUX4PWdrmRf+Y7IMaeZXNI36artClpoFilimUUuNfkJs6lO9c/vwlOJwgtp7RiJi5V6mWbt9Z7NKQwbm9LCyZPZpdrqEsLAIZIIEBWrHAj/9LRiw/tk4kIswwp7B8x1+q6709UiN0llcJ4idAAqXXUVI0bY7UIltpLej4wqqL12Di44jkyJvv8c2C9yRFzfAcdZaUiRnIbnUS33tEmDUTV2MOUARw9Qs/OiWKFs2XBEog0+6tgGBsfEoDKif916+zixXDwjpeRimr1I+Mb4/srIvU2ow6AoCwNX9oaGZqDZv/OBvyiudtZ9EpSFSJud1NMLQJnmRU109d44pfs48zzB5i8uTSyGxSRl6yNdSAPmQIB8Hhsc5/Yr1jLZ1l7wBTMYwDMXuBtaeHEaWVFOMGNVbcjgG3GrpCZunHuMdqJvp5phFK7v+IH4w6zpvb/REqyrLkk5fuJOMoOW5VEKlcBWGAoQqzCJLejcCI0WEV7fibgEGepFyVvI6SGQ+YRc0baatXaABIx6cVSk47cjDLgepE
 Aypu2qOL
 bFrIJjR9GDHpj/IBcAey9kuRqhrmNtwHK6pOMugSwaSKzZgRU82p3pwDqiLdvkpvqo20jiASTPUu+um9YqLh1/Bsfz5M9OMeaH80uDyaQC+BfuhD1p2T2LpWZmuDkh+/LLgdWTs1+K2YxzF9X6G7YkTGkf1UmpHblGTN8tKEKxUGAaFYfd3ux7P/r8aSX28TvUPdAyZgfkU0hNk/MzYm4oOHo0+cu08GRIsxz4Uf35+y9NoHU9IML4Bt6PQOc8DQPvgkmLP4BVGupLvo64Iz3a9PsVwCUWFYd7v13ljH9bzcUMxvr8cE2qC6/yy01lJd2LCkbqe/uixWfxaIjJ5gkcryASMzt5vuz4m7mzKPShSfZGcEO4Hal2D5X/XtS84hxj+QUypYvDseqBWDfT8KV6Z5qtfJJGYsM9jb7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
2.55.0


