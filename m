Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CF43C88E50
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 01:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 033DC6B0092; Fri, 11 Sep 2026 21:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00AF16B0093; Fri, 11 Sep 2026 21:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A836B0095; Fri, 11 Sep 2026 21:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB3BD6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:24:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 366131A03F4
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:24:44 +0000 (UTC)
X-FDA: 85203365688.06.662CFDF
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id AD915180004
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:24:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=rQG6WHZ6;
	spf=pass (imf16.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789176282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoYcCAglewCWVwj2AVy806Wq+FVmxIJYd36pevZhoXY=;
	b=pN+EOQDVMSrlwXU/cJRi4gjtTj8xO/UF0ZXU+n4jTd25YErRIlji5sUaQ4t6GR7GSdGSNr
	FAw7Ld5+r8C/nkQgTSKadgkawRPIi9iVjjgvsIBKyDQKoWk43gHnAGqsF9funFiV/Ks5fl
	GObY5mFQyXHLFwkpAaHVTPsDsUBseY8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789176282;
	b=qCpQ0OHKB+8fSLnxtEmLpd9IAyca+7NVcCsN4/o3yHjGzYJzGolJt/q0Gf+c07c+9fWLtW
	+jcUMU4ybXj0mybSnBAZ2e555kAEkxqomwZvizlDJyYSOa9IiSH4/rZl6Em5hrrGQqD3kf
	fzLmA1vuOteXYrGk4kq+W0bY8McayX8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=rQG6WHZ6;
	spf=pass (imf16.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=eoYcCAglewCWVwj2AVy806Wq+FVmxIJYd36pevZhoXY=; b=rQG6WHZ6qXo9Zdjq0lEQY+CbDm
	2pi5Cq0EtuoSFy2tX4TyMR1TeBotdcHd0C8aQWfTeJ64suhLM7iMq5gUo0XF0Ubfrk9/DU6og7VHU
	3Q1fmmuIGuyiPpYaPK8nujMDfphVZwrV5Fu5kQvfV/SOBw9O+J9FL+/Qzr6tQKaPn1LdLKg49qWOF
	+zGFiAzW6/QBS4/3JHEeBhRBKsdDC2g8toXeCE68TApriQozzb3helJCQUUDdlNCMm90k6cyUXqsb
	bDbWk9tcqaDSfWhw79XM22KaCv9pkycm9SzuhSoTO7o6iSWytTkW74jIr8346AI0yggV42hRwXuZR
	fczEEM+A==;
Received: from [177.172.123.122] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x5CTp-000xjI-5O; Sat, 12 Sep 2026 03:24:33 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 11 Sep 2026 22:24:00 -0300
Subject: [PATCH v7 3/6] lib/string_kunit: Add test for copy_task_comm()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260911-tonyk-long_name-v7-3-34e1ee1564ae@igalia.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AD915180004
X-Stat-Signature: oufk1kf3djty84859cwmdn8q675oexxq
X-Rspam-User: 
X-HE-Tag: 1789176282-892423
X-HE-Meta: U2FsdGVkX19SR6LcYTELSRXzzgbR6AftUMyg9Me11tShmZ9qmQVAd7f81tlAsBGp4xKMmWgsfz+NnUgBBwya+ADe0ZU4JulSg3f4aOYlX5EvyFOiMcMW8qSySAttXsAW4u4k6ykIASl+4BAhecCrxr3GDJGzyps1FPf8hpm5R4XLksQk+2MJy0N5fJ1/HLmue2I7l6vh27hRUeyKwqy5Fz7FnXxRruq8OB6zFNeL/RJelXU3VuWYZljf6IlsZW6cGbLaUvoR8UbMn826fRBJteoTDrB5AzcPWxbz80cXuzhw7Bu7c1ZyGXqfDWjOTIAQfyYYbykgYFqFi5w/Ybt7wHwczu0DdQE410JJze5MwIXmIix4rsUwaYkVCU3ju9SbeO9775GbCE78SFZiwfKxc35RC2uGPLn5ccWeL5p2M5/4+q/lLR306FqvP3RhFaQ0AzkLS6sLUEcHs1TwhEhrWKYWNlSp6F2SuSKrI6JBaAp5jgtTtaD3Miy7pcAVwqLrz7QBQfpZmHNcPbe5oQmB/+EZN9jL9cTWYIocn6Hc/l1npayPLAQfB2Wdpa9DOC+fbD7BfTNbrl/NQNpynk5t3Id8ns2xcwDTINr6VVhYZOFE2Nmy50wLqsyQtp4+8MbbSdjcUxFEyolxht6JZta3PaTQeIAn9tKzAo99F3k6PLEd5G58PwlA5RkRBkojSQFY3Y+jnMKZkMpLSHAf+kZwTPmE/2AO/IWSFi//7EKt2iXpBuFzU8Px0jKMu1UUrEiyBCUpj2RPn+7/g1l3GX5l5BAeeNCIStPei8MNyATzGf58hlgSQAuU9CLaWZzSatasqbfANs9kikG67DO483RB/xjHdriIUAfEmu/gmLE/4G9a2pyw0PyZqlyvpOrYkqBCdTfpLiT6VtLW6xYosnOb7SlthjCm58wZdJVXINbCtgfbx0rbs1KTVzZiP9xKkeT03IeQDElbkE22ykv87/+
 l8HMe2x+
 gvqaF/si7tNjI44RYxAQ+AxDNp7TkQ4G1PcXMSXyf6k00zcdVX4ffZv8sBtg0d3vqfTTrZviHuvaLuBEKAkFf+fYyHl8Pnkrdj4Y77CxK5m+j7OcGDxNwJZXnYAClWyEkyhfOydMNYfRZn+OGR2llAmO9EfC2x6+5pqpbTHS9P7xmW5+gs339zHR4OFth222ueFwPSza4LcA4Wurf0fBAc52MbErmaCjhBO84GNtOOMsXdGQH8muEeb41pEVYqXgfqMJAlyhlhkHEaiObI/BPhUanjv16dO51+RqgsAnoVb2iMg/GaTZaOfjjP8kP9jdWJwa6WWh7jvY9OdUsPchXJzPdz5kBTIAJ9IW6UDJBvwND2L5pCf8ciNOb9QzwHNx59fiXcHoYi2fxP3yNSEvdWYOjpie7JEFE5GKBmEeK4jvMaKQHtoY6nELFt1TGSlFZMeoNne76Iv+Ysds=
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


