Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12A76CD4F47
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79A316B0005; Sun, 17 May 2026 14:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771746B009D; Sun, 17 May 2026 14:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AEF56B009E; Sun, 17 May 2026 14:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 594846B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:37:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 22F6C1A0537
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:37:31 +0000 (UTC)
X-FDA: 84777769902.16.41EB40E
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3AF8314000F
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:37:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=YxMlzr1y;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf09.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779043049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOUkvSr2Gn8JmW0nio1LgmkdjEeAiY0SGNTncIeyo40=;
	b=B8IeseRq0MP760CPxNS/wuVbf20ZwNpDsuAnKZS2tO8pKomkPpKEkicVEpmPQ2Z2CkDT9Q
	ryDK4hvNu4wi++AUpJ/5B+oVEbd77AM4ZIirq1Jt/9iAD3ECD9D9RZJT0mmoAzHaVXHR8x
	rL7RhkhKqpOGccZ2PpzS8mNOYF++2WE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779043049; a=rsa-sha256;
	cv=none;
	b=IIUOMmnfy/W6q9XxoLX+rH4w2yerIAkUP8j/qLpJUJ+a56u0bwW40LhNNFryF2kF+OuQx/
	AQg2ib+9cplFFMIwTjwT/Uw8NIWxvWN61igPsopgHabDaoJSHMJWqvkwkG5xmSt0vWIT9/
	q+899HAjmte5Cv7HIeeJBDUwc0D3Bq8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=YxMlzr1y;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf09.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EOUkvSr2Gn8JmW0nio1LgmkdjEeAiY0SGNTncIeyo40=; b=YxMlzr1yiCTDLGXptBuFAfeJ66
	XjsFGuUOgWIYgOLTqm+BE+ZO1r6FWcQiUQQ0xFUGcHxM9wtrgLxuMsGfS2Hrov+Y4bkihsDDzzc/h
	EwUVoBbm0MieEY5918taB0Wt/FjpA5RVIGYv0JwrqjJvhN1Sl/4GmMrrSnFumMpYfYnCwxF4ZQ71D
	jjX/LxSEB9GawNVgAGpgtViIk8GqKSM9YzCZJaMk6bSPWB1xIVrL0iDL6ItOS4iT7j8o71hFnnZTb
	maq+TuRY0OGQsxx5Yt6zIwYjfb40XeWbgrWtOIphV9tdc1CZF+oZbGDTbvtzNbEPSURvl34I4SQFs
	6Jxmx+6g==;
Received: from [179.193.2.40] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wOgMZ-001cLz-Ae; Sun, 17 May 2026 20:37:19 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 17 May 2026 15:36:16 -0300
Subject: [PATCH 6/6] selftests: prctl: Add test for long thread names
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260517-tonyk-long_name-v1-6-3c282eaa91e2@igalia.com>
References: <20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com>
In-Reply-To: <20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AF8314000F
X-Rspamd-Server: rspam04
X-Stat-Signature: ej8k8a6efgbjpkmu3cr9o6zr13nk4q9g
X-HE-Tag: 1779043048-472366
X-HE-Meta: U2FsdGVkX18/u5nIjJ5F/sJk8UwOj3iW/PcfSPZhQFaVhA8/jzlrpHX2F8+3GMw2egr6zKsGrOKfAb9Y94gPGAaanid2SGEVOxRN4RdFZ7wFscrbBoxCIUisBMGzh6E6XcCtQjhczZymqxOWBaA7PcGKfnPADPstFgTyzyyrP03tBvYsxKtDJD46tw5eeyg/pgxDmGK/wHtaNkmzZ1PKDt+0lxQBcehwSStHIS3/PlpG3dkNB5JQnWJIszoG32k4i8Bekw+gdacafS6w91CWxf3+8ZrL4YwRoZgedXy1ozA1SkDo3dg0QMSsdrciW+YNzy2uYnzaFDsoWpQyj59PjM7d0lsUvHHXvegPfe++R/sLTwRR8XkU1tji/SySK2HbWRBQ2fYq7zQiLPuOe+YUOmhhQIQQjQZCxlD1Wj+3i+/cjGCfFBVNCtNv/cS87U66opOyj+6yhrarbivzNDvtjOZ+5kIp8VG6RDvHkq96KYyYTOUl/TQ3c66Cz4o/fVwQDqcZu6Rc8AFsm8I6riEKAYDKbzPJDhqlEqttRmVIjf/wV7wk8xOXbwWRdcJVv51pnEzfRjSSajFuPKoM/hv/Hpe7CiNrhUqEIAIEYL/tw39OSs6/FTHSCFrBdlZbIVD+SGBogjnXeborpkoGB7HD0V/280/W7F5jVYShu3Docoe3FI5s3tb94wMFUx+/7t9tRWZ5xH7GEpRlE74vPvFfDu9gbX7MaiCIL2TPIfrbGxT+biNzc53aGww8ncGNC4GoiYiDspnuRTLV/V89blMEPuqi3Vwk9jr5jFsXxyb5N231uJBSCBB6NoxaocBNeNFm3mQY/tRp7Vog8gpgNTBFVedkxwTVxZ+UMEJuatEMaTvNiJX+0hcLrRQHNolD6J8dvI5jyqnDXbzG4B7PX+ITyrNoezNlB2IF7Jd31nwOOX3eVr/2N+sLYEnOsqy7yZ669aoQoFvrIYxdJ1AL/1A
 GbT+mXDI
 y8tTxlluZ3sdQXq50wbzyutetqQe0bg1Sp20WLikRxp0arTIiQnxj7cbzwGiO6e6mQxXEWrBt7Gr5GwEsK6iYdbHJyTRCoIh8/l/9/8wo+Ux79UbOJ9f/aEVIyDpMdrdnLTj0jlwmCe/KHUWD7IjTuPlYB7/fOwHc/0yIl3p8IunflB80HM8y2fQ5Y3ATpygn1SkYfUyi0je5DeScs7DgunnhU3tXsmGhFB6BX0VgRIOU9k+Quhicfy4Yg4PQZqlcpC6MlzwMnzABb6j+Ju1P+qcgQkNpGglnZuQzmc+EfONPS2lehPr0eqxJ/+IZOa0C5qMZKqWOpjXDjwLX56QWapWd4oQZa0EYJ/Ba0SC5jeqHaPlf+WslCO+uYhv4sNBizzzjdpjkrjz96O8/SHMMoXt9zw==
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


