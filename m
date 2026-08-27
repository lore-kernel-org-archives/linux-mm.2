Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F91CC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 18:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8D9F6B009B; Thu, 27 Aug 2026 14:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3E2B6B009D; Thu, 27 Aug 2026 14:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8816B009E; Thu, 27 Aug 2026 14:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E5FF6B009B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:23:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38D6AA2ADB
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:23:55 +0000 (UTC)
X-FDA: 85147873230.13.BB4D782
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id 90CEB4000D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:23:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=oLFQXfLA;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf27.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787855033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXqZsmU2q6vi2HhgyJCccmn6k7A/eS01jTDJneNS7NY=;
	b=IgAswgOfwgzYoUP8HuwhVa914o/NLEgEI3vYYVfc931N6Sl9W6ClfDyusB/2GORvcLl/m4
	3Mli6osQl3yRgShMLMybEdPnd+mr3srewPpkHHWsVSv/CbssaYRQexBZ4AFOJUb4mPVRK8
	AHp1cAwD3sKmBwS6SgMyqlpGqrQoALg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=oLFQXfLA;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf27.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787855033;
	b=WtMe3ch/kxW2TxZDWQXJqTSsQD/ivxDn/SfVgtgwQ0lDnQ877TB4j/ki+zk8uOmMcTfpT0
	sfNxhpdgXC4GTdxXII1HNYpAjQKsYWWwu/41eIFPUbgknHLsD+5IRMZVwqeZ9XhwzuE53G
	IwQLYjvCXnkzTOLZBiGOwzn4OY4dg1c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=RXqZsmU2q6vi2HhgyJCccmn6k7A/eS01jTDJneNS7NY=; b=oLFQXfLAwpus3wRWgG1Md03M9j
	0c4lE9YuawfHYRGb/ucAqRnVoxg4puOyN4BkF4bqa0QsZR3ChgvTtuqS4k7/mGVjEJfLzu+GzbH2V
	8W0PRr4rQfVpq/tRQ42dLa04sjqPeUeo0+QsTVHWYbN2o1tKn64UDbkiBWkvU2M87mvRUNbgRgKKH
	paj0emLYvPzetoCTOVNypuqMJL5Hi7JoCiKZBMQxtt4GOBibHFp3Yyb53Hb9HTQfq8rNz/dKL1oJp
	Pz5oc9gVhGpHJpyapPXQKr8FxVsgfTt/WPwBzwba0WtyU2nVUzC9bmeVKIjNExYdFwc0eZR3YjQGu
	OuDUTE+g==;
Received: from [187.57.78.212] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wzelR-00AOUg-Cp; Thu, 27 Aug 2026 20:23:49 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Thu, 27 Aug 2026 15:23:05 -0300
Subject: [PATCH v5 6/6] selftests: prctl: Add test for long thread names
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260827-tonyk-long_name-v5-6-5fa843782a00@igalia.com>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 90CEB4000D
X-Stat-Signature: 8n8ptjg6su6he3t5wbftawx6ppmbgis8
X-Rspam-User: 
X-HE-Tag: 1787855033-693424
X-HE-Meta: U2FsdGVkX1+RYJBBRlVH8imDjAUXSUyQiyXwwr8SQRnMNjYCrhVvy+X2VpQBI22gEAphuHDSN8O63iGj5RO/0rz0vIURgVeyjWTCgMd6Em1sYDIuYKdQ9KtE6ha8YIpy8I89yAFjQa1Tl2TaI0J1hj/737FiN/8MWQIzw3CjJAmK51C/kg/iVQhw8ePjTLvqkuSY7JEW9V6TLwKFkC9Jni5A1nDofKyW9M3nj0q7Iol7afA968i2S7CXw8IHqITQTA7/I9WxpBJj5R1xel1MJPdRi8z+oKKViLyMXXcLXlAA0bX74mHqje9rf41hfVimNTWfOm5myIEQC3HTYZPMMJ2BvwGn4I/03mLVd4/iFASyivAHrduCaQK+krWEZbtF9s7wgqWQjjaPj9DMI33c51MP3CwjU3AVwHHFUX2WmA+0eG2FPgOyUbbjP1WacIrB0qjtaKXAlX3Vg1GmcUInouOPT/Y2PsxyZ68f2oxrkTStkZaKIwFc1jlMJOu7MLao4fFYpzh/qtUW9Rtu9E3px8pcfkzFn+g31+2qOeCIIQBlbwuhL6BN2tjbeBrhrw5I1LQJrv4QopYZhDZs3tTA0XAKzqP+oN+RocAjJGclntny2Af6eoN4fYb+2UDu+i/8fYDDEAsqtJvDA5SpSRJxd7e+H+Mb8s0Zrtu+BQ3U881S99+AxCcZVFxfhQIcBCJRfqO6bU8yZbTGlXCpbAhJ0/pklfi2u4AiJef+f3JkKVAtpK+cLxiZpCyA0jPVzyYgaFpfL9yRfgoYu+xONZyyKrXmDlpIM33iOcbUsQbV99oSoYdl73yzzJdDjqcrFvUvJDCKhWunLIRnSa580frissZxnpCbNt7yXMg0oz/ZXY58zO7L3vTajhzl1169WoUFFsT8Qq9bjXxSu1pELWZ1SXqx4TlMIgr4GcRyaYbPAZVyzukbEvCHc8YXWbei8oaqJEz7xpF0xAG0ZeOb7CN
 bKVfT4Ig
 VvUpQrDn157H56u8AMkfqV0dNmEddCPzpyv5ysbcaGO7za/o9KxQhHCrrSI6JNHL1jJI5U2cn4qjbJvNrFKX8u3I/+DtjZ+j6BNL9l66qEiYaZtoTnjnVGFJZMZC52+9EDkxkMT7JYzkECRZjowNFrb7yz8yHuu5pZCae0xB32bA4IpsuCnuLa1C1TtkAOBKrycrMIhLidcAeVYun+hXUm5koikxEUBP2eQwmnmF2LxajEjU9Ye0Im5tXCFY76xuNgmOEfau48OhF7AawJFVD3AfRcBWdUTTGuoCT2C3D7lqTzcfQ1B6XbV3pF+KVU3dAs2YmV90bH5jvpMrI2vJVg256b330Rt3CdKEEDEhlIDhcjGjZUQKd5nzHqYb02DZq6b3fri9VnCFs4NGxHFAf6FoMihwuKNgQ9+JR
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
 tools/testing/selftests/prctl/set-process-name.c | 37 ++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tools/testing/selftests/prctl/set-process-name.c b/tools/testing/selftests/prctl/set-process-name.c
index 3f7b146d36df..951319d60656 100644
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
@@ -25,6 +33,17 @@ int set_name(char *name)
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
 int check_is_name_correct(char *check_name)
 {
 	char name[TASK_COMM_LEN];
@@ -38,6 +57,19 @@ int check_is_name_correct(char *check_name)
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
@@ -82,6 +114,11 @@ TEST(rename_process) {
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
2.55.0


