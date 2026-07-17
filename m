Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2071C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 947286B00B9; Fri, 17 Jul 2026 12:24:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91F196B00BB; Fri, 17 Jul 2026 12:24:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80EB46B00BC; Fri, 17 Jul 2026 12:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A17C6B00B9
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:24:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BED180157
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:55:20 +0000 (UTC)
X-FDA: 84998415600.20.45B8297
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id D2DD040007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:55:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=clxcydvO;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf07.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784296518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+nITUmfFeuxDcsBxqonSvN6M3nbUKMVsHgaHsRNa0hg=;
	b=WiHK2p9jxUIEaEUJYOPlr+nJov9upCrN+Bq7c3vOohZBodq5q6g6cu/aW39wKlC1nJMDDi
	IhYW0vgmvAk97m2tY7oNizskcr+6Y8PgZjqriuNDAW1ZHqbqCYv3QTRpOFbk4qKObdtqu1
	HbR+c8feCQAMo15m8Tx4JKtU3MLtp9w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=clxcydvO;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf07.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784296518;
	b=Ni06u0CbpaqC88cxkSKY2LOOhiwdpBU9HGPwAJKuviit7C7hGx7uZxrUGNSEz+qxoYHvWX
	mHXhIHDx62xQlF8fM1JExpk6rMRxOuHQbRc9bv/bOxUFUsIYSV89Ama2lD9OVY7x5yOXSL
	lMSS2BQc8u6JXF1XDCsqN+F/c+ETtIE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=+nITUmfFeuxDcsBxqonSvN6M3nbUKMVsHgaHsRNa0hg=; b=clxcydvOyh1Ta3inAHvqnRFhW1
	RjJ/MXQggOY2gQI0rebzTYXTTzZyPq4uN6Ls2GigOy63FEK5ZbAyGkKyrkoIsi0UVFiOhD+MqFNet
	EC4LNod1WDv9COkw1mz/Omn+pk8QZijLNLc68zuwHqtUAU8FGKwkQZSwvz+eN18QlS9ZFdPPRcTOD
	uElFFzzlsdoAYw0kNHI9n0aDbdsriat9giyzQ+6ba8bnKjK8delY2JLa+2KboA5xF1a8NUq9fKSoO
	rsSq7TROTft+nVd3msWU6H/FRK15ULoerqvcran9OYB1C7O+Qfe/UhBGLBNT4gnf+eXaDQIY9xOEk
	IzQl764g==;
Received: from [179.118.191.219] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wkj20-00GXeM-EK; Fri, 17 Jul 2026 15:55:12 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 17 Jul 2026 10:54:36 -0300
Subject: [PATCH v4 3/6] lib/string_kunit: Add test for copy_task_comm()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260717-tonyk-long_name-v4-3-1fedfc870d21@igalia.com>
References: <20260717-tonyk-long_name-v4-0-1fedfc870d21@igalia.com>
In-Reply-To: <20260717-tonyk-long_name-v4-0-1fedfc870d21@igalia.com>
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
X-Rspamd-Queue-Id: D2DD040007
X-Stat-Signature: 9797axyg8jg87ja7mhx5j8f7yz6nfy6p
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784296518-584669
X-HE-Meta: U2FsdGVkX1+wLAygv/5Kr8OoFQHVTUAlIUlnEY/1MdnWzX+Y4wpIt2/vroKfnG6uFNg7ClGtYKsrgR6BOOiyG/zSm7kZwCR278WiIZD/qNxp2WU2HzIvJ/I4sZOv9rvM99BqlnYqjQQMPP9MO1knwB5hA929su3q5Wo+RNX6lgj4iv8046WjToXSiFumcvWd2abNG4zz/QGpeFLB5gtWvxF45cv2Bu+mkE/imZeUiFbt9kjeKI4zRIeq5FM5Yh1mpp+XDN3qixKX+GpuKGzhkCxQM8rVFNaHFQS9ild6VmWevo1B3/ovnr+oRGOhHB1vm1bKErTRnFVtUnT4oS/9Z2fwMzZOknFmlI5XHYxGmX3Rr6q7D6rfVFXNSt1G2QxYwkK6mRDHYxTgNWaKjyCLhcNZXth9/aqeqgXDvgCoUIEFdK/0URB8VrC4u6Psxhl27DDyfNQRNUR1Y7DOKxbk/er+ssZa5O7/UWOy3xgJU0YBOPYmmEhBSiT+8OuOR4EGjXsOpl3H53TljuxZhftsxYrxBfb2b2tuVByY3XRWtkHmmK2pTs5oUGRxH0WUUiT7HDDyqYgiyVf6OSzuEuLELC76boNYYsg5pW2HoJ1PAAm6ofmM25NeMUSLD7r9ChDPveYV+tEy1PYJlaVFCAsxJDYjva+1weIpevB46zcLLTu0HjDHZKGBqoZ7H7CoGRlbO7jtMlOm11tCBNk7RFRtAcYmp6C3Qnb1m7MC3uEOgN+kmxmmystrObMkVzrmJRBtNr+Ps9cZHNf4xWURU3937qlWU2nwfOENnAfAbVNpxHTsnLEwPKJnZFF8mdGZAxoyCf62hINLvv/WGTHVP25OwzFXtA2xVbNCEVpenUDN1h7uBNyf09qb8Ei7FZhDf6YnE5//7CE0T6Sl5U5Q0IxSDPHDwxEa2ElxuXYJx877MhvSeUMb50WDL6PlG2NDvA9/pCL8WuucNaBYpymVa05
 bx7f9M5l
 leo8XQ+h6meJgABL5agLCiKQEnh5iamR0MhG0/Jk4fKXe50Dgn1yDunIUyIDPHFiWVL8z75umdPEqiypHBGcPpu0TDG6ZINIaGorxgAQt+rHTVVqv2VJy+PlFVZr5YbqqwLlFhEFHXc57YIMeVZWPJG3+xj9H4M5KDbL7rSvw8qu9e5qAgWsh4tDY/erDCdW9FJA4Dg63C9BBeSH2DopuH2sJZa4tesICy2W28mv4IdjuTqGe0YH88OLiUagy8wWG9zZKmXwtdNmAhpOVeP7DwusDWn/GXlhtU5+gHmzX+le3fCYUSfdZquK4+J8oJUp/hGWWUkYYgL/agD0DHSvWmv41DUKfZZKwTNbxeg93+Zqv6BDihDUFchDr+4eTziVTAicAhQQ49tC4K7L7nr2m1WjGrwiLiudIleEWso9iIgjANOyGNi/H4OlM0t0jlymwii4tfsmaKT80TqE=
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
2.55.0


