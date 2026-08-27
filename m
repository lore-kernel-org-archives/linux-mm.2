Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F383C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 18:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90C96B0095; Thu, 27 Aug 2026 14:23:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A296B0098; Thu, 27 Aug 2026 14:23:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09056B0096; Thu, 27 Aug 2026 14:23:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 846276B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:23:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E26ED40183
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:23:41 +0000 (UTC)
X-FDA: 85147872642.21.64F35CA
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4ADF7A000E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:23:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=VUd8o07O;
	spf=pass (imf25.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787855020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2rgfO1UNR9r853HcMuUsDdAX5avvibvW0mwFAGglu70=;
	b=go59DKO9OknzqiULx7xCMHIwePuOqPtGb/W9kNjsz1Eikoy5lhg9z9tiIEXS/FUGmUYQAS
	7+KOsnMnqYHQ52UB3ghDoUQD7mw+V+RgMC9Hx30HtbnWDFBs0XDmT6S2rh4ns51/En8AW4
	5VR6NgwZef3qjOBI3XA41/mZgWBQwCw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787855020;
	b=x3RZJWDQ1jLwo5pgzBLEsYum9Yjv8fqZzlM3cqKetWvV+7SuS5nKEkoeZe9jjw3UklYipw
	aDb6kJ7/NAQjXFABL3pC3HfTwUR6TQVAU1sfuWd58UVWN9xopmHyV7oUijmaobgURQtCKP
	lKfogifMa1xt5Bo2h3eEzE4zFezbX7o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=VUd8o07O;
	spf=pass (imf25.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=2rgfO1UNR9r853HcMuUsDdAX5avvibvW0mwFAGglu70=; b=VUd8o07OUMJhrByGHDlGLnxHqB
	E+tOG2MFjru/Fg3ZySyBLs+1ugnEnHIs87WW+xUtAltCYkqzC5ZBjELEgX+YuVv2Yk66+q9z3VsMU
	0xTeK4VixtehlJU/aUJKSR712yjiLQsCDbOPTgEIYSsD8jn0SOvV+zGW7+jDSmk6nQ7E5fiEJvWle
	fUDfm1E5VflpvdRo2GZGH1QunD3O+nh87GHjPGEoQ+N3dv7qylPP/AT99wN5wsN206WD7UXIAPbJj
	7W1BuZU6MqSJOjCFqGCAjAXODzWHsA0X8ME9Ak9n+RwXi0MBl8ySpHzGS/gyeuVKgfTAP26HlFWZX
	GgIi4rNQ==;
Received: from [187.57.78.212] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wzelC-00AOUg-AY; Thu, 27 Aug 2026 20:23:34 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Thu, 27 Aug 2026 15:23:02 -0300
Subject: [PATCH v5 3/6] lib/string_kunit: Add test for copy_task_comm()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260827-tonyk-long_name-v5-3-5fa843782a00@igalia.com>
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4ADF7A000E
X-Stat-Signature: hueii1x3j6hgqt8piewdhs9dw34tdap3
X-HE-Tag: 1787855020-906243
X-HE-Meta: U2FsdGVkX1+xUWqImOxSffF3KtZ+1AOhIUGwCwjdc/sLQpnvZvTbtyezqLsx+unvh76OAlhc+gLR35IoMcbt24VGpAqAFjKFFzlsC/7kwzMmYwR7y3+X4yuZPqHcQxtplah37mGR24zzNahqRHk8dcD5dbhXSJ8m+kN6ObpAEtxdcgcTi35yA/9NsuFjPHsP/IT1NpF1GIiubTpOCksKboJtv8TVQvcHyRC5VzOMOB85Mmz1/wnHckH4blGA6mOi+QrBy8Ru74bREGzhISW4te8L4NBoFCoahr72576WNY3q+NAgC1K+rLpu8BQXr757yZrGL9zz+yzyq8GQzEM0NpKxYA58jDE9YvR0au082++5uQFy8JOI5tWvWzdtJYyTzP+3JppAfrNd/cDsybg050HyS+BJUKWiXo80xeTkkmJlLvBFD79/DBjlMU+KqkcI0OQsCh1GmN2eptZsFChxSeZP6RFidfrM8og4iQ8gPM0kdZh19Is5JqAwxQRjpT9elmldrR1uNfqW9/bv4wyBflJCBu8l5TBCPxFRYZ0Kb+nLjy3T4Fnii1bC9ujdFR1s9zTeTvR3D9ov4NQ59erSN/MDEuv9bfavnJDjAH07K96xkGv17itDLx/fFUCF/cpbGe9l1tUSI3n8d6RWugVm5U6/5NyI+t4ApfIiIAmWitudjfMr5AcimQeYkGm/nlMv9Y0N7PBH26/eZMYOsUeAX04M6jI/RxM2KmMcEnnE6braGMDyVgQs9d6P/5OLyry4jMOabi5+6E1vlFUIqhLxDefFuFSENRSSY9fBNWB9+cfIsCj2L4bDZz/KVA8BJWQLcwISuV9PwzksrD5UmAYigp//HBGcrNODVgkNDMuGgUUf99kjivf9UklvREHrdinS8znpSR1WZOmAQ2EhCz0ActmHDYCXvlu/Q6JnsWuHIyP03Rv5p/2WhhBGvbw9Cqr8XQBpZM+xVsljjfXtiZH
 zeLbofE/
 Wi2bQhMG3S/sWrSFEab1AwVMQg9/cThhXWj12rnVv7MR/0ODFZVGxPQwvoY+9gB8U34Xho8MTgnMRfIPuGvQuA+zmBf0wh/tfMXaUGXQe4eXZfaQboZ0gNwFN+TnxEk3PlvPNGbiT824571Ol6jdxGWe10ja1VIUDaefV8Wx6cnHp/S/Klsz54SHU+AyXZnrKOHlZqgQGlxnwtE2EjShr8IbAeaoP8Sp6SsbcjDuwc0YjLFxSI3EQKJAcNursf4BUibYGBK52plmeULp5YGlihqCxQtBvLERSIaT5qDyTTJdW9uj65LBG6LtTGGWZojo/FKvATTXFUgBsufMqufd5nIPvWPlp+8oUzonE8KGv6SwtoBFfbdtAtwSXemLIzPc/ocmHk2puPPublVy6O2z283D+YbRzqQbVfp8Sfn6VGg5oerNqJGdXYiEM3M7PE711mxNhswmH8kGAXys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new test for copy_task_comm(). Check if a copy from a task_struct
works, and special cases when the size of source and destination buffer
mismatches.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 lib/tests/string_kunit.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/lib/tests/string_kunit.c b/lib/tests/string_kunit.c
index 0819ace5b027..27a27ab13254 100644
--- a/lib/tests/string_kunit.c
+++ b/lib/tests/string_kunit.c
@@ -881,6 +881,43 @@ static void string_bench_strrchr(struct kunit *test)
 	STRING_BENCH_BUF(test, buf, len, strrchr, buf, '\0');
 }
 
+#define TASK_NAME "task_name"
+#define TASK_NAME_LEN 9
+#define TASK_MAX_LEN TASK_COMM_LEN
+#define SMALLER_LEN (TASK_NAME_LEN - 3)
+#define BIGGER_LEN (TASK_MAX_LEN + 3)
+
+static void string_copy_task_comm(struct kunit *test)
+{
+	char str[TASK_MAX_LEN] = TASK_NAME, copy[TASK_MAX_LEN],
+	     smaller_buf[SMALLER_LEN], bigger_buf[BIGGER_LEN];
+	static struct task_struct task, *tsk = &task;
+	int len1, len2, i;
+
+	/* set and get task name */
+	set_task_comm(tsk, str);
+	copy_task_comm(copy, tsk, TASK_COMM_LEN);
+
+	len1 = strlen(str);
+	len2 = strlen(copy);
+
+	KUNIT_ASSERT_EQ(test, len1, len2);
+	KUNIT_ASSERT_EQ(test, len2, TASK_NAME_LEN);
+	KUNIT_ASSERT_EQ(test, copy[len2], '\0');
+	KUNIT_ASSERT_TRUE(test, !strcmp(str, copy));
+
+	/* copy to a smaller dst buffer */
+	copy_task_comm(smaller_buf, tsk, sizeof(smaller_buf));
+	KUNIT_ASSERT_TRUE(test, !strncmp(str, smaller_buf, SMALLER_LEN - 1));
+	KUNIT_ASSERT_EQ(test, smaller_buf[SMALLER_LEN - 1], '\0');
+
+	/* copy to a bigger dst buffer */
+	copy_task_comm(bigger_buf, tsk, sizeof(bigger_buf));
+	KUNIT_ASSERT_TRUE(test, !strncmp(str, bigger_buf, TASK_NAME_LEN));
+	for (i = TASK_NAME_LEN; i < BIGGER_LEN; i++)
+		KUNIT_ASSERT_EQ(test, bigger_buf[i], '\0');
+}
+
 static struct kunit_case string_test_cases[] = {
 	KUNIT_CASE(string_test_memset16),
 	KUNIT_CASE(string_test_memset32),
@@ -910,6 +947,7 @@ static struct kunit_case string_test_cases[] = {
 	KUNIT_CASE(string_bench_strnlen),
 	KUNIT_CASE(string_bench_strchr),
 	KUNIT_CASE(string_bench_strrchr),
+	KUNIT_CASE(string_copy_task_comm),
 	{}
 };
 

-- 
2.55.0


