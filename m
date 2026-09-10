Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B71C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 16:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D086B009D; Thu, 10 Sep 2026 12:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 826A66B009E; Thu, 10 Sep 2026 12:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69FBD6B009F; Thu, 10 Sep 2026 12:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 359606B009D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:50:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4129AA4EF9
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:50:07 +0000 (UTC)
X-FDA: 85198440054.23.A8687D1
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 834D5140006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:50:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=XgKzfBTS;
	spf=pass (imf09.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789059005;
	b=Ezy29UUqtZBTg7Y73lWMMLxooVIuecrRSJVmfD0ygcL5J4RvZEW4rzdw1iihnPW5rfSJzY
	uowyGY67TGEY5w3n1jRO9gJVjdpj8kL5tBfZ+iq+2ppxhLQ/ecRADGxobtNQUFB2wvCKYY
	tf1SL6jYp3BEr34+JPOuhnNQT1P7BrQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=XgKzfBTS;
	spf=pass (imf09.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789059005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yEhMQLJIbP2So5XydAfHqKEdD7p0FcLEoTOB/mDNo2A=;
	b=GpT3azyHTGLXGTgTSnXKOU+AWI7mbN0AYklrqJbtRrZP1n48YIKzPZcWfons3nRoObeYq+
	qrHouygrsZ4zTVFiUbVTi2AJJ6WaHDn6jIbGBt8mRUl9U65FuamZspAmQw9kNje2Dm14Ko
	gHeYNBqA08wYWedV38pO9TWvoLzP/hc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=yEhMQLJIbP2So5XydAfHqKEdD7p0FcLEoTOB/mDNo2A=; b=XgKzfBTStCdsvTd4feuEEWqHBK
	c/YwChzbakcux2jWKS3mVcP+hlWrxBcSNl/EVcm00WoyINZpyl/SeI4nEuyx5DsmOucg1tMizMSGb
	LBeMHFiIOYEr2CiZzoZ7PzWHVf5oPqHZl0aOFd57yS85eZnXBtuatz2Nfp8hWrat3q6gWSDANou5I
	I7jg8gh6x+fMNGt/JCcDsE0v2O9PqD6qzkcQbGVpGMw6vs7e4BOC/Rzln9WoQnu6rRaCfgsTFp0rB
	L4l6ALJSYgBKN8NlGgKV2scyyU7lyMVA9T7XGnOFCeGJFMGh1OR/J2GGuk17HZnzW6vfSddk0a49r
	DdETPr0w==;
Received: from [177.172.123.122] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x4hyO-000GV1-5R; Thu, 10 Sep 2026 18:50:04 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Thu, 10 Sep 2026 13:49:28 -0300
Subject: [PATCH v6 6/6] selftests: prctl: Add test for long thread names
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260910-tonyk-long_name-v6-6-d70afbf194c5@igalia.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 834D5140006
X-Stat-Signature: umjj8y3hkwkcoe7m3ogoaykog1dg6cuu
X-HE-Tag: 1789059005-587295
X-HE-Meta: U2FsdGVkX18RYBK+2iBNexNmkl0fHTcK3XNhTnunDFs4LLMDxQw1rzpIV9Raj1F4Nkke63CWVKRiVYnSixUDnJvHIWYZClfqt/U/PC6850lP7aCYHEvWJKesVBhxUJRi6DZfl335AOl4Kc8DSQl+jnu7flY/KinloXep8KK5fySGOTLv1AV+ibg24KS0wMJoAgc+R9oht40lmTQihBo2y0Y26k4KE9bsH7bE49FxCkE+qJ3OLooui/xULEV2+omFL904uoqBw4BikE2XYqAX5m5GFJJe1aR06D2SB0+sYAfQdc0NMZ4DYj9u+6mveHsj9PP0kl6fcs4VF44heTPuO/1rQuH6D7BRtZorY1QTN1FgOqNhYAsC9d4zf+NUZZX8wPXOzJx8cPxuDh8J+2/cA3uYviVZdqsArXm+kGT1T2co87atbt0k3rm6TjOjK07g/AdGnARmaOKAkMeoW4CKqYQkanmvQ72t31Pk7e7mgX0+iodjS+VHKs8Ub9xnsSfqs0YooCNUd4pAjekFddNpr/+UbUZ2rTGRMp/A1GhI/8HyDSKHWI5eD8995wjGjf9Udh9tKu+QuSQxDd7yaKfZnHrzsAb9BtYFyOvjaln15dF+8FHxgB55JR4lBuPnf6RNBgY5Zq6f2TkuYVleT3u0/SpPT4s1UnEHX2/eJbUTtXQv/c4HIeG7jeaqvhThZ8UmRun1TVo80nAxhOnnCiEWLfMs3Tf7s04gomx2AMVONixn2nTFhntvSf1/taC4etHqzu4AXh/pp912nhQ83h64uZ2MlkTsnVv1Ya+LxY8j2ec+OIHreSkyGhJIoVrGsIJb1TJ3O7hSYS243/QdBNOidOD9kX3sdQv/1ZJBSdwQikjmvuc/BlGvx/JMaXtvKUZ/xzu1EN2O/VcGSK1z+EOZFawC/cC/3KRozRDAV55/8ONmCp+PqOL/11SoR8JTJGeL3UBfe9p6rD7hXuZLDZu
 2jTTmwZe
 JOaAPTvkKFUFOyq5H5dgEpp63G4ILqW9wI9yAwfdVmu3QGKTMzvUy9egMgYwehgg4ZHkiU9ljHcsq3GycowjzyDAe/nuAbKYkHHSqE2B6UjroxU5cwfwLeNpzyTRILFyhnsZikJBuauUtGp0ak/Z0xftfs21PikK87BXuCseaHWZUolbwhkBBLcbJ2b/qbXA5bwAyQe0RRrK5+evHW2CVu/t9VOnLasXHXhrOwwGdn/y4aKc2U+dJAioHc/CXCBqtICCdZ5Czz1VD/J8KmOB+DLP1J1T3Wt/ehywoBEsoAMdvnLyzeOM5r9FvuI+a0dhcr2qJZYjSS5rawjksKtEUEO2s7oIoiDfSlEeucB4O1qOBeqd5eMul1yPUpfFuOw+NOVk4SZAY+e1Q1FR/5dvgQNzJ5arBJ4bp0gNv
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
 tools/testing/selftests/prctl/set-process-name.c | 53 +++++++++++++++++++++---
 1 file changed, 48 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/prctl/set-process-name.c b/tools/testing/selftests/prctl/set-process-name.c
index 3f7b146d36df..27a0dbbce4db 100644
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
@@ -80,10 +118,15 @@ int check_name(void)
 TEST(rename_process) {
 
 	EXPECT_GE(set_name(CHANGE_NAME), 0);
-	EXPECT_TRUE(check_is_name_correct(CHANGE_NAME));
+	EXPECT_FALSE(check_is_name_correct(CHANGE_NAME));
+
+	EXPECT_GE(set_ext_name(LONG_NAME), 0);
+	EXPECT_FALSE(check_is_ext_name_correct(LONG_NAME));
+	EXPECT_FALSE(check_is_name_correct(LONG_NAME_CAP));
+	EXPECT_TRUE(check_name());
 
 	EXPECT_GE(set_name(EMPTY_NAME), 0);
-	EXPECT_TRUE(check_is_name_correct(EMPTY_NAME));
+	EXPECT_FALSE(check_is_name_correct(EMPTY_NAME));
 
 	EXPECT_GE(set_name(CHANGE_NAME), 0);
 	EXPECT_LT(check_null_pointer(CHANGE_NAME), 0);

-- 
2.55.0


