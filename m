Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B9B6606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=ZKsJnMyW
Received: by kanga.kvack.org (Postfix)
	id A103C6B05C0; Fri, 30 Oct 2026 17:39:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8786B05C1; Fri, 30 Oct 2026 17:39:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 927B76B05C2; Fri, 30 Oct 2026 17:39:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 684656B05C0
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:39:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF8DEA8514
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:39:14 +0000 (UTC)
X-FDA: 85380608628.08.764D03C
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 358562000A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:39:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=ZKsJnMyW;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf03.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793396353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HoBK3yzUb8KR/d8wKu2ZFmNGfQsrmKROFIVbAAGrpFY=;
	b=FdOe3rrUocqtU0H5Z9vIem0+BMmUP1wzQ62ZviHjS25bbpEUDBlWyVFL0se9sKNKYuuiIA
	j5iBh70foCJd5YZ9KJ0JiYTpgg9Gbtb+ZnG3fvMEF3IzyqXnS6UrU6bRHM5LGE50kUDQJI
	NTjcguRX/9L8z7IxKu6M3WxA1Pq0VNM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=ZKsJnMyW;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf03.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793396353;
	b=Aimeoscks3ue1PwWJBEREqcsapQ20DPpJAkhjv5XQbJhtG7CtwCThta2BzI+OjhzAlxiEq
	Lq08yioBT0hsr0Mdxa5jI9YMo+aHIqirdTK0hLY72qBhul5/D608iy4ZJpi0r39KbxNhNg
	ZaLxGkR3PmUjGyPprh/TK63YEAQChaM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=HoBK3yzUb8KR/d8wKu2ZFmNGfQsrmKROFIVbAAGrpFY=; b=ZKsJnMyWWwGI81fm2Uq+72vmls
	H2b3VWT2jcu2Y9GjUxFf1FS0D5G3ms7c2jO4osL+RmCFGHdXB3Meqw0s0vIJUPbnA79X0dk0vpnEO
	+5J+Bxl0Oxfrs80xeaentLDxu/iLObZtGMLz0m9uz69U2AQpwqwHqQRm2E9lAfr/XhgB95Fj716Kq
	m8woh1Ixm5Sa8OzyKdQXqfKaPKuOLAVQ2KYtC8FtiT1P1DkBNb/OscTmJpIabpJC4/7b0TZw7YkbP
	bu3gj/Tk8FQnIfcnc+sZXeeZdCGVxYP3essp7hUn8rWxcRibTXBaZaqAa9QC0SNASLrXXH+uNrqoW
	AiYK3QLg==;
Received: from [177.172.124.63] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xMuJP-00FNmU-3c; Fri, 30 Oct 2026 22:38:59 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 30 Oct 2026 18:38:34 -0300
Subject: [PATCH v8 3/6] lib/string_kunit: Add test for copy_task_comm()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261030-tonyk-long_name-v8-3-c9b030332254@igalia.com>
References: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
In-Reply-To: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
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
X-Rspamd-Queue-Id: 358562000A
X-Stat-Signature: 11e3tyffodbj5gbuhedn5pu78nisinte
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793396353-268840
X-HE-Meta: U2FsdGVkX1/HbuqGFHrjV8MQRvh34EapuCH8LEGQDoW5IDA5CCaMvtR3sR2nHAuhkvxSAZLih6BLWe8kJwPrgL4ISjtS2ar8Jc1QHQs2WpRD2ElpXlWzUwxVNMgVWBE8FjMhjFCQTZESrzB6XCL+6eDXiweW6bUgYUi1s24f5B6DxsXB4/YIGbjyAV3L/59ucpvNLt7svHYBGWOw400jPCvyfbmiSfh5eavYjr9rhLmwLId2891+HwZydCELEXYB4NUVPb+R8z7RiGSSHRB4w1SCSVI08etyFTZ7PAwA+angnJnP/g/QcCEKzQrtzntALEYHoAw0kLvK0klkhZ02G2IfT5gnQGnQqR+4G1nw8d3RT+bDOOPa45n3P5I5AZhgIzQn9JdPS9M7jwR5N85b63tO39hFkLaKnkcAm28HdgO4BjRs4gaYqNvblwJvvlDOZgQF8A/ptsmHX2NT5muhyz34D2iibT2s9euxnIeR4cKDS8C921v8W7xZm6fY3SjWoCTfR3trq78GBXYULpjH148yNghJRtqjskfrMYhKJ8qkYsOr5UnvtuB82SyzzzD4h0RK4b1OSEb6Rtw4tWfSWFpa5ApdLik8H7GyuEi2uB5DXtwdH6Qrb9Hz/DN8PWzAx1cJfZZBWuPQqel4FMVWJVZuZpLd4XAN1fpNgfTqqVdmlFG1KRtTUi4JwBYKUFqnM+23/dzY3a71nRA3rcXqZnIYNAzdIKGU+7cQ5EHowV23ZsKQ84WGuXbAhoR08h8qZMb8+ikN2BUfHByPhfuSQIi11PhOisPdQaNOBvbPdg2JBK3LT83qJ6kjJ9mtPNFuDA/ukIubpPaNeu3QImgBfNT7Mcr9wDTYM4Urrx5kAY12QPPMiL/W8pxLjS9fS3XZio19bfEgIB6jQaDtuBKZHwh7aG3oava/BZRdGL2YVzLKq9aJYTDb/buNw5QzPwjRKdg5Zb/Z4+npP+8VWBd
 pRB1H5lP
 1KvnY2N+sBJn93Gk99FC5jaQ7hirxCdavix27mv1Xr8lKCqkPMcoCACP30y/9ABZO7GqO7hMWhjiFXkC17M8xfW8Ba+b5BHpjBO4kWtNhiSmd6MHzrRL3PiTj4iFNk7isl8nQzUFJB63ESNqpaiFzXE2cjNCMUmtC57oqcay5/wUSTqQ4K8z7rp2xAHhiaZl4AYkaPfY2NKOGE1RNI8r/D5IY6g6gek06XeWfEkF8FGADdOmF7zZEo2w8g3JgqLl5Ry77oVK8gE5a6kKHehdifMWXefXzKTeeyVs89qUHeTfqBUhyID2S7sRDJLSipXM12kQj8oaM+sALKS0tqtNLmBbZYf0MbHQ8iGGvtyn9fL//vY9QR3U2ue2SN1JOGhHFN6e9rsfyk3PWeCdPGCbhLHRPZMZdTe3KygvlnEzK9dgRDj3ztUh4m6tJ8KfbLYqLzz6lKEHqvYJEUnY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
2.56.0


