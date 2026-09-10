Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42A16C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 16:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D97E6B0095; Thu, 10 Sep 2026 12:49:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B0246B0096; Thu, 10 Sep 2026 12:49:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69FA56B0098; Thu, 10 Sep 2026 12:49:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 382886B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:49:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CED14A4658
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:49:50 +0000 (UTC)
X-FDA: 85198439340.06.021227D
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3A3D640006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:49:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=a2D6raGc;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf17.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789058989;
	b=pIPEY6YdAOyCH/M48TvBLLp8+3/xNsP3E69EdF3B19Rj3lJ4TYuG6SvN6wwSQHUgZPF69g
	L2vY5RXFPMNooSPDF1yX48BG/qJW10D7fhu+c4+6RKWy6hZO+xlgsrPu64QbvrxB4X3scB
	VPCOsq/oGVe4c4ncrdnNyTE4ik+wVyI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=a2D6raGc;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf17.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789058989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoYcCAglewCWVwj2AVy806Wq+FVmxIJYd36pevZhoXY=;
	b=nqAl+SbbuXA5ZZMCqZI0wppFWrxnHd2alJUD/JGSFUOvMbCyewwx36QORyOcfMBfkaqk1q
	jLm2jOLDop+hJvkpFBlaIE/3Xkwxb3f5yiLU1nwe2ZyaO6gW2ai5/s9jd9QyOg8yGSlJNq
	d00NvLuQqXQ4yCPvrxD+ceCi1YAyQHw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=eoYcCAglewCWVwj2AVy806Wq+FVmxIJYd36pevZhoXY=; b=a2D6raGcP0RCTpXl67nSvb7R2V
	WFSa5ujCHs+5dcnspyYfejXwX3G7uZ8rNxsr6Mix0RGlxLGLPAArBNxVk52pKrj7wR0Rlxrr5iYuw
	QNf3W75SxuKSxCHEWANzBEWi9d2vs85lUo2YTf3I57UEIBg+Fd/i/jNxzQT7TqY4AKS58lanYXX8K
	b64TzEvq58AA+nBv+eSDmHUY1uewglcotnI9aZG6z9MqvqGSVoOlVBs/JRO5pIeXnI1otx4xKX88d
	a1egSIaIIiC3736hlO/wHdOX43P6i7MMbnPE6hKQ0R7IC0QrbTdAg5p/5Usi/HgT0Yr1yZjhHmkBj
	FlLdxsmg==;
Received: from [177.172.123.122] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x4hy7-000GV1-LH; Thu, 10 Sep 2026 18:49:47 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Thu, 10 Sep 2026 13:49:25 -0300
Subject: [PATCH v6 3/6] lib/string_kunit: Add test for copy_task_comm()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260910-tonyk-long_name-v6-3-d70afbf194c5@igalia.com>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3A3D640006
X-Stat-Signature: bd861apnihtjqxrqhj1u1wskppfq1uc7
X-HE-Tag: 1789058989-659999
X-HE-Meta: U2FsdGVkX1+bI4j7AKGKKlVI0iwIZo1efqhFR4gBTAxIJQs9X5oMZzqbvxnKPFrZTmDf3agRr3JDlrtlyqc6mKXBaRVhvTsYrnWRYO9LG2dOr9ctY7MsXr5d6DGi57cQVSETboowe62ny1Y5LR1djvXsFix3MjCFReHU1pQ1LSsGJXIEMMJUKFKpjPCWbQFeacz49f88Q0twIrxYVbYQ81rvs3dX1d5VhCBKAWjTg1GMoLDCSByXqWR27aEKSi9lLJ58qABfT0HhZ3UB0SMZkm/CeL89oA8CAA+13/EQ7S0OZjfgdjFrN3+EX8atgQPAUofuHqzEomu+Y39H1yNVqui+g1zHn8cJjSvGIvdnuS8Mhn0beBgT6diTvaJHdKMkyLu3rxXDQGyds3k92mwVAT2RfTRKtvPscg3ie+hrkPkt6VdIILwqhJ4rYP4bHuk9iiT3xKFQnQCcIkvFiSUGEqFdnuJf4ozeiRKYD4CFpcSQPEyHm38tPoUV/uLyR0AdYWH7fshyAbghXhftHb7OVNkYTbqXIwJDt3FDBG0cKPnEvLeS5IT3wL6ky2Axb8qZf23UAcFenswZk9c0D4M7Z8mEsWSNrJz98fG2TDrYYccV1A6fkp3fOaFZp7In5z0/E1u/fYL5Pcty89cwTjGDtiHU5lYlzWdvdAg99jRu1klsEGTmfatmUF7AWBU7ZdlYk9t9bNDR3kIGqcplF4WpzBk1Sn5Kmiy2KQfvVB6vTC/Etvph6JmRSDS4m6nicmRqf2pt7cLnVrm47VyfNe6uwRZrtO7iUYkM4cpsB+qEzp6uDZVFb6n8iAW/rkvZh4pDBF5OKZOlbUlZ26Ay5KQWRNf0IkuDPhc+5xw6ViN3SYtXy91LrVLeLy97KbJMLM9uotk4EH/nGPQS9A5/45JIoIinf4hmDbSKoV/EdfX9G52baO4Pj2saLMOwjZf1u5lGbINfRis6s6MdQ+pRiE6
 noBPhp7k
 QRUN8/4nv3AUHeHEr4jBx79spBK7+Rg3WSQ4y280B5vhplGgSZTSCsQPjNXjdoWYwB825XtZ5S7Lr/9DjNxGWxv1Xom061ctUSDkgAj/qYS2jWkxyf4RtcOVjhOcuu8ve7glpBwxws+CQxU48izGpiNTlBvfNNIbsJIiZCoI3ewCw48L3uZZ0+etBNAYvjC/MqcXYLRp/dM2QJbQhSboPb3dqr+/vh9f1dKgzBxftiYC0ABwubfvdjeASRT78qStLYtTcAv4d0O2eB705zE+2iWmyWAKHOKhiEx96FLWJl0cRTdvkJanrN5Y+lAVmEPlo+9dm/MTwP3Q8c7L+MJKwzHhPAZ4vy3Jcb/t/lacXFu7JRutSw48C+eJOsiOvehjYL2gNTbDEK2ALm1W4MxIxUxXlzAVReE8AIBccePv0wpOrbo0eGHruukdFSbQ8pI5FGH3RnUCvSNa7ZT4=
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
index 0819ace5b027..66c3398f2317 100644
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
+	strscpy_pad(tsk->comm, str);
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


