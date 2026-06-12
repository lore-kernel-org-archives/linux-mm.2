Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF12FCD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9315B6B0096; Fri, 12 Jun 2026 12:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9089D6B0098; Fri, 12 Jun 2026 12:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9DF6B0099; Fri, 12 Jun 2026 12:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8F86B0096
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:21:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 09A03401A8
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:21:08 +0000 (UTC)
X-FDA: 84871775016.22.63A19F8
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5580B2000D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:21:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=TfMOnipb;
	spf=pass (imf03.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781281266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VSSjA1e2ihuYKKvGbBvJZXau5qhO8MXM5c+dt4k1Oiw=;
	b=0gNFEHlUytA9VXm6SfG52XwLUYyjBKAzFm3QjRzpGSb0VRQa9j2fGl3XOR8AUnFISUTb3h
	zdurK3OXa/Xhui78Njih5ok+T6Wx/UAYR1zhea877CS8uHQDxEEqnWjnxjlMxOe4qQUzb+
	1P6uCvHemRPjUrZgTMz77Ar3fnDBxBk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=TfMOnipb;
	spf=pass (imf03.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781281266;
	b=w3hT0MmCEe/E48cSoxsd1vDIbGrtjKh1EmTQkcw95dOsQQA3XPqDX7P1sN0iYMg+c008Lj
	+YjfLhzc17ATow06qxRnsD0igurtcBa1Wlibk939zthUVllkSzQxFxjd9ef6YEYq+ge0yT
	846lB4jurpwwQpt6tWBGl2wr+/Sq+DM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=VSSjA1e2ihuYKKvGbBvJZXau5qhO8MXM5c+dt4k1Oiw=; b=TfMOnipbCra0jF35oiuYAIqHpy
	p3uA4YddgEQ5DegPf9CIbAKUYUM5EhCsX6+0EhUHola45xVsdavV+j/SbuzzfRYVBIczV42RpVMMl
	b8Ifa2UbayeeGCtqbCB0Xq1V5bvF2XMz6HP7+RssAb0diXIyluYS54UspI3bIXqKUKRz5e/fM1DBl
	5MQB+pJqjbGUUYYlHcKQPPJQnMIkD5SpbK/FcA+QaD7JagxMMD3AB2V78cmKWC3WqvI+X+Wmn2j4C
	JmEsWq1EFIU3cw4BBERtTjd1+kNT+Ji5h0pYC4ncTizHYR041zOjXwfyn/Dg8cuRLhSVbMz/Akk/K
	92cT2O9Q==;
Received: from [189.78.222.70] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wY4cq-00GgP4-OX; Fri, 12 Jun 2026 18:20:56 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 12 Jun 2026 13:20:17 -0300
Subject: [PATCH v3 4/7] lib/string_kunit: Add test for copy_task_comm()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260612-tonyk-long_name-v3-4-7989b66e8a99@igalia.com>
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
X-Rspamd-Queue-Id: 5580B2000D
X-Stat-Signature: 7o84fd4cgxur5fun7fs1knnj53bgw9kz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781281266-482865
X-HE-Meta: U2FsdGVkX1/2WzSjDI5kk4pBUjiNlOddy85prEftEqIkgr4IXjZJ37H3s4UwEgevWDIcTN5MoqJ2Lz+gNW7QKTVRLBaB7qal1rUSX3YO0IIT70KCNwLpOW5qXANKrwGnLI9a80DSbNUYalPuq7VerC8gmY5xN3C4vlfc9JSbVB4mdJT4QFy1Fh09dAKYWd7yZKf1D8/ztOJgHTkyHT1kwZP6pBnRM7cw1F6rmANmTanYIzTUPEvGC9a3m7I5szzhWtOmYgbVRhKlFqpKGU1rHbO8TvRT5JPn9fo1T6PE/IeEWdGoBMP12WyfThm1z3Lkb/1E4GVlhaaA4GDFdNnXb2CT30VIIXJwEua527unFgL7sxW9Lecr5Dy5oa4PtWHOvKCOY3kYTPaIs3NEKWGloNUpPIS1Wz57LU0fhKG0S6owtg1V1/ExOY9wLBt8wiMCr7/HoedNw/WpqHgFUNs7clhJ6qz6yLlaKN4ku3kOh4fYNxHCZKdgD39KYERm5hZVR48ECslABhk6V/Bu0rsXAqoq6Rk0gAJIIw5ax/3dpJFHa9GuSCtp+SQejkMf0uSyNNq90HqeaRs2KdDWgAYb5M790BZ/tXQR6HD8chb5W9XJXhsqcT8sy6gVXsAiSYokN5fhlh7OC7DpktekOaINWSSIjErw2p/qQNz74RE61PcwW9ZStLLmtBe9XIE27W487ScS9M9rZGJNUNcmllVsE46EfbLBC6mS95ov+XjsXREWrgSVT5NGhzXzdActjR7dYtC7HZPdso+fHumoQO/VGuRe8QA2SUWpjSbvMNPbh3LoOnKMzGwihuHzxWplNqHzSMjOiVU0VNwzHc3zB/fPF91vwLK4Kws6+bws8yRzoYC8Rqwb2QFNVmd0hs29aj5HscndW4rZ1WqdMtWkwcQZqFbdhk5GgSwDvbqL9rgSqENdflVXECV4gm1bLpWJbu02ZPr1MhNzwCeSQAvfpoI
 8zn+UCOu
 ODSCvw7o00a0E6ofhvgYW3A3nu6Dagl2OwSEXAtUz8X4HjXFK02IyRmHJ78qK7mfH8uarV/5s7AYYHP0Ke2E/60EggrQ80LJxI7li3P3JoLAeeSwbtztYKtxwn0k1WmHAUYa925MlIyhkzcBynEoc7Tc/n4imPR4R9FZv7jUiuGpQprgTEx5WE3pY6TPc5f2j7AqpI+VxGaNW3Jw617VlbZ1Iv1esH3v+pHo94kzcKDxR0KgYBxyIExX07/bEWKMBCRBmwN9J9A6lIh8P/njsjlxONK3PEWQEnTPmDjDvB9S/JAzKmiFMJO+8XUeS1fwIPrFUlyz7rpP5j5zKwHeCbg0kAc1HfL5RolboRZLF5rebT6vv3oku92SmIU23ztHg4g13zFzT7NAcQ67355hcChcGcMr7NJvTCzaRXj2HV3yOBcZPk8Y0cVSN5+jE1Q+f2Y73qTobONBsow4=
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
index 0819ace5b027..b64d7f0e54a3 100644
--- a/lib/tests/string_kunit.c
+++ b/lib/tests/string_kunit.c
@@ -881,6 +881,43 @@ static void string_bench_strrchr(struct kunit *test)
 	STRING_BENCH_BUF(test, buf, len, strrchr, buf, '\0');
 }
 
+#define TASK_NAME "task_name"
+#define TASK_NAME_LEN 9
+#define TASK_MAX_LEN TASK_COMM_LEN
+#define SMALLER_LEN TASK_NAME_LEN - 3
+#define BIGGER_LEN TASK_MAX_LEN + 3
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
2.54.0


