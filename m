Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E3AECD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D6386B009B; Fri, 12 Jun 2026 12:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE816B009D; Fri, 12 Jun 2026 12:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB3F6B009E; Fri, 12 Jun 2026 12:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43AD26B009B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:21:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 079BF1C0CD5
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:21:25 +0000 (UTC)
X-FDA: 84871775730.19.F9A1406
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 68606140005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:21:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=nxgcXRoK;
	spf=pass (imf09.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781281283;
	b=I96xoQhWmuiY2Bixc98dzn6AKrsNlWIUZPhD+V5BINo30B+iNHqGPaY55mF+xHlslnHXbI
	XJB5EnlQO1E+uiuAaAGBqliloiSaytJwM0n8r1uml38oQ5JHU6GWJybGZOGZGCiCSLHoNI
	RYoGYB0FQozGoacfiYRtd2SA0b71WAU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=nxgcXRoK;
	spf=pass (imf09.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781281283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOUkvSr2Gn8JmW0nio1LgmkdjEeAiY0SGNTncIeyo40=;
	b=toB7nkGyFnPJDEzYlTkShqKXx6INxBD9SrZ8nuqAsWzpFvrqm4EPudX8IPFb6C8bh7l0vx
	H6n6gYmVbQkyHPD9mMzajIn7XUr4EbniX8UsGvXEghynLBRrTAWMAPb/ttVsDBlSUxt9qn
	h91ar5oRP50dj/6ROy5cox2BEczur50=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EOUkvSr2Gn8JmW0nio1LgmkdjEeAiY0SGNTncIeyo40=; b=nxgcXRoKu7qdZklZlsuvOJA97/
	vcAYycAQ9Kv5wgl5ZvuXa5vUEdh1TjK913+ngRL4O5K7pha3ONAivVIksQN96WElQHilWBKq+vCdv
	K3syL2vPfWrnVAd7LQeZiTxo2H1X1W0u0Md6dr8khOuNootnwrf+SlFbjn80mfvqCS5LQTWO00VdS
	TB+KR6pJSa3oM8WjogsUh77JrsbalxJQNAllBAF6/fNGbxEI1JWF1/nF/prqCXcgvspbwhRMXeWcJ
	/R4aIBFNgajVvQVS5aj1omhnClCSfC61i29LyBlEP9EFDn8hZvHEjEgR543H7kM9FtHJrFhSTOHPx
	sPBG5Aqw==;
Received: from [189.78.222.70] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wY4d6-00GgP4-Ow; Fri, 12 Jun 2026 18:21:12 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 12 Jun 2026 13:20:20 -0300
Subject: [PATCH v3 7/7] selftests: prctl: Add test for long thread names
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260612-tonyk-long_name-v3-7-7989b66e8a99@igalia.com>
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
X-Rspamd-Queue-Id: 68606140005
X-Stat-Signature: z5hynfuffen4iswp1ibpbx1zophdg3bs
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781281283-81767
X-HE-Meta: U2FsdGVkX18d7gCuj8m7PTzfRCSe4762iuyQovZAGfj1+xAMxiZVjiIdQYew2AoJYqnKixhCIdBSUzQfQZZOqPOFxLIyzF7q0XPd5KDLP4JupsRVOL/0QPZJTiqkod9rije8IY7aK8UdxjgGjNa1yWMGL4MDX66PcqXOywM2akV6EzWbfwNKbEz2kIMfk5Da8rugCQkTExqDdEarXLS2TdLa8O21B08eSacnHcLkymgXuhwWZU+c2l2PxX9E8j8csIEcfNbasNibpk8cXF6tZuvdf4xzzJ+9aVRndHbEnBykyVz2Vk0B2SH5DWCiTNU0Tuyzg4O09a4oIlWsQuaRwg59z19xkuNXj/ZxogrAbPX+AfQMWZlrz8QD/CcytRQm9vkNzZ7ROk3Yy/QYoRatLhGIdqCgiM1jLes5SA+AyKDodQqy1uDjSEpPD7uxQ1HtE31FAgdK/SbfjZGZH+zdIJGtuXoGY+tiQC5V1vxqkAecmjSej3Ta9juApqZzJ65g1FC1AHyMgE9r2PBvwY4SdIy9An1N2FUXgDFKcQZeQXxHbvSfEPq1955EzRq+PYnr6ysyBd0u31hDPX9x5GL2/1BuOA64EDXfOJuyuUTPKsKcHRHbvRYqsznVu+veJ8PT8Ig9u4fLcaPBuPkngvJUg6RdL05s+Tv6bHsXk/RdsmTVAMAgrKCpSMY+GDS4XyHfAo2XtyEsVyriGkkUYLopRzuSWyv8Q2hjRr1j9uE22gK+X2pqmTIMXO4drqSUFD48FvO4ZSiOXWdhuEYd11Gyj4yZWYNYVEj5MpjFYiVsRWxRAYr/m+kJZXexEqL5mIE+/2KswnQEpv56moTy5P2j+xOHov7SZy0n43QLGn8G8MsO3XHtvYvGbT4cckQUE4f4ERnvrQmDZLcnWAGxtWyFfN1sTUDR/yFh6BYUqwS+KCj7nJXuDoIV1ruuwZJGqPQeI/FnKzugoZ8OaNQtFMI
 WpES3OAE
 MFrgPRKbIxeOgl4+7CJ4w609h6hq6cDd//g0fUWZbgEWPI13l24BM9+kTlnMTZ8vBC/fC1l1XmBv/iYNTOWvpu3zMBIfCJtPocAaXLMJkca3TTnIUQJpwhkQsb1l9YIftqDTcvcls7ypYcbQJjnhlYdZPRXlCl9DTquFdQIrkh3+fTStzsxrrFkiCC/oAIlLCU2qAeLA1ifaYVeONkDmlkvBUUbvE5KJY5G3Om/WZcjTIhPqMSy6gCdOQJVqE6c1qhfcxh1L9A4Ozup8GqcKupMWGA95AU8/9ByAIZNqU+yOwMP3WcjVzDf5BfY+An10QSFXIbPuucjngbtiHh++OU8Rrz/a10oNJZyjB7cJin32Plagq0j6DqM/a1fij30EJVOWx3QcPc7JpnP3Gs4u9CCK+MjsEdVhHHvID
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

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 tools/testing/selftests/prctl/set-process-name.c | 36 ++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/prctl/set-process-name.c b/tools/testing/selftests/prctl/set-process-name.c
index 3f7b146d36df..0f20f7deac67 100644
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
@@ -25,6 +33,16 @@ int set_name(char *name)
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
+}
+
 int check_is_name_correct(char *check_name)
 {
 	char name[TASK_COMM_LEN];
@@ -38,6 +56,19 @@ int check_is_name_correct(char *check_name)
 	return !strcmp(name, check_name);
 }
 
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
+	return !strcmp(name, check_name);
+}
+
 int check_null_pointer(char *check_name)
 {
 	char *name = NULL;
@@ -82,6 +113,11 @@ TEST(rename_process) {
 	EXPECT_GE(set_name(CHANGE_NAME), 0);
 	EXPECT_TRUE(check_is_name_correct(CHANGE_NAME));
 
+	EXPECT_GE(set_ext_name(LONG_NAME), 0);
+	EXPECT_TRUE(check_is_ext_name_correct(LONG_NAME));
+	EXPECT_TRUE(check_is_name_correct(LONG_NAME_CAP));
+	EXPECT_TRUE(check_name());
+
 	EXPECT_GE(set_name(EMPTY_NAME), 0);
 	EXPECT_TRUE(check_is_name_correct(EMPTY_NAME));
 

-- 
2.54.0


