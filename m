Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2BDBCD4F54
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 22:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33F586B009D; Sun, 24 May 2026 18:40:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C8716B009E; Sun, 24 May 2026 18:40:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190B46B009F; Sun, 24 May 2026 18:40:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F37F56B009D
	for <linux-mm@kvack.org>; Sun, 24 May 2026 18:40:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C11B31C23E2
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:40:25 +0000 (UTC)
X-FDA: 84803783610.23.7649558
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id 41A64A0005
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:40:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=JKc+yfVN;
	spf=pass (imf15.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779662424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOUkvSr2Gn8JmW0nio1LgmkdjEeAiY0SGNTncIeyo40=;
	b=fG9F2C9L5WXgkJ65YsMoWXtloz8BdZY3yEWdvXwLMrqtkjFJBgADPEMFW4XET2AD6aQ1E2
	NifPFtTqtuauRqJjXHq8bfn/+Kzw1e9o/ZV9mRVN0eHO6Atzr4oCdWv2taSu5xWGK67rr9
	k9UoDo01sbLkSOXoCT9NjbaA4XNLj2E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=JKc+yfVN;
	spf=pass (imf15.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779662424; a=rsa-sha256;
	cv=none;
	b=fLTXideXevMWnbETiBBeqg5YXAlqz62zy3VVVRwa8OM90NZm8bSpA14J1G4dg+vT7DyuxV
	pQaw27mGxmpqoE2bABLUN7S71XGUXT5Kykc1PUuy58juqwYHDNz4mFsEp2xPrhOVNmO9BP
	hubfk+IShCQCDScQgSzx3il5a7JNQd8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EOUkvSr2Gn8JmW0nio1LgmkdjEeAiY0SGNTncIeyo40=; b=JKc+yfVNPzg20F87X0yBLl4od/
	g/xh9TN0qQcd4NKy4yth7wDfFVLfncjV0XLxPqmHwpsp/dT/3MpRorCmdag/M88YtenRHwsYE6IfS
	1KyTMdAzBdVZToBHEDmuy2fvhiUQiB6Py/pypvdLnb9LVjpHJdCbKowFkhxXTlr0vbrOdnkzmU0Y8
	5IpgTwBhndyT4DUPxI7/YybW9D8WTDyMJLaIiGUWuzQuKAFtoT48i9CBEgsa0vuOm4nB+jMtxN+Ie
	eX/axlMHojHthroo/OWCOdGaQzq8qHNAEUGEh//lPJue/PBOuqru7SIg/iKR4dGosPtMANKnpsQrQ
	23o8TOBg==;
Received: from [179.118.191.12] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wRHUS-007fJn-CP; Mon, 25 May 2026 00:40:12 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 24 May 2026 19:38:56 -0300
Subject: [PATCH v2 6/6] selftests: prctl: Add test for long thread names
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260524-tonyk-long_name-v2-6-332f6bd041c4@igalia.com>
References: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
In-Reply-To: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
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
X-Stat-Signature: 55og5j6w5y9har9ti6pxaxishnijxekw
X-Rspamd-Queue-Id: 41A64A0005
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779662424-161103
X-HE-Meta: U2FsdGVkX1+5HwlLwR8GXlx6vuVsgzDA4+q5+hOxL/rZG6bNTxU2TqatqRgHt+PB/8B0uf18mzaE2ctUWnk0K1mOKnw0HMZhJRu7ingl7Ecpkbit+rb4GP0Tn/V6owZRToj6VOJvy5ikUSRbIXfldcA4fcC5L4fuz23CLMDmit79KofMRZ8UEUX14ZJ8Oz6yHLE0V6UAW2Pyg9P8OHPeVqiplTA0tf8OrKgViaY+6nLt85qhKaFaoraWG1LNFbG2oSapz230HtRupEPfGdIAD3uMhmU9lokAq4ON4853NMwK1mpFi0GaY2RZspXnJOioaPsbYZByOhBYM5+/2Jle7vjBeNwL10oUXXqIMQ3ZlYDbNY/G0sM6kKA7fuCW6/JYa9h6RKQAlmIamyf5wrBqVqSq34TWfJ7nQuqgymnBqio6OpLKbEIroCclU5fvrdh4TK5T39tudoVaVIDraO5fhJD9x+83NI3j/pqqs/t0TGsc2BVVOzQvORnFXmuAklibv9xDJ+c2hwt9eKQ2fZZRG0vWtmA2cvu03Q2WR4e06PuB7gSuqmsUJZzR4xIWcTNTLVR2E4bFs6UTkgrrllsLfgFQopIOq+aYaeD8GQJM2EAtL/qYEhPLPkaIPVODaCIlm9DvN6m21kJ+V5atfqqrd0pojFn+/Zz57wXMV5yRHLWWKY5rLLPXudRvK4NFk63Qks+xW72OdOLlG43nzHH2McgH2o810cjq8nkZMnsebOSONNh0A0AE/Mq/5sjZztfAiIMaKVZtjE0UX8eV3LxAVPYZZrClGUAtv5rZEKX09EzmWJQzgGQ3/OYfTkvfDUFGjm2MgsivUzuGa3PfxgmrHio+dw6KQpbO9Uzpr4yQcJPGkmDNeDwJGvOjORXHLIBTUo2qQB2Bq2g/u9th+GPwyf5UMr6Wj0FEUEI9E7p5gZXPb3VsI+5df8WOsaBwnGkFpb2PR4SgJ8Me6a232gS
 +9iASk7i
 3mxeix+Jn9RkCwcfEEMmSWS7uZ7D3AnV/J8Ij7sITn660DQPKbS4jWIdXSo/9o+xxuTl8zR9UVb+SnVnzOc2bcQYg8MqP0XpI4MvrJ6EIY0wzOkGGVzeml2smiL0XE+2mNC0kBUj3kjYxg5JB9A2G+LbO4ksufizb/DUiW8E7fPsT7b7sMj+VuIrjJJLhZ79I5AN1rwrx8+Y9ePeTp/Gd6c8PNFlOMA8lBF+Yfs3o4up6Jo0Vbiyiltda5d9bW5qllTyKveBhsVehcnGfJiTC0IapmkKCaa7ncAvEjrdZeUbpmCdthqtqX6qrD7hBTAiyrraQMevTQjtKX04g8WhYAl31wnIIf19K7QjYPYh6PQ2eNEvMIzXOKxiPmpePv/VKwOaYae1rCcaekNW3P4JXPS9ulw==
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


