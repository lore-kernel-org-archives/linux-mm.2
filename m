Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1DD1CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 16:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 312DD8E003C; Mon,  1 Sep 2025 12:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2568E0016; Mon,  1 Sep 2025 12:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C798E003C; Mon,  1 Sep 2025 12:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E8A6D8E0016
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:43:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8DD3F16095C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:43:17 +0000 (UTC)
X-FDA: 83841251634.16.097221C
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8E68D1C000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:43:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gx4iWFyh;
	spf=pass (imf21.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756744995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ApDGjF4qZlhoSmK2tdSzupo+2mRrDnKfGsOkf1zOwN4=;
	b=btqFQJkksU8KFWNZywf824HW4ZLiKGJ7tJVmA2gXi0fAeTzlwm7/EW41xIeXmMRaW+dewv
	Naof77KYYHT02kX4PnT04IqzGQGmtBVkUqzzOau5qk1u0MSZ/2X3R9fNVjamYfFoFjTEOz
	OZu3KXIIKsoelcGZ11KDecGtH6W7UDE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gx4iWFyh;
	spf=pass (imf21.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756744995; a=rsa-sha256;
	cv=none;
	b=b5NbW028NxXq+qgNL0HGXMAgfLiUy9qgOISJN0ivfYHUAdXuU++RSX3YHGTXPl2exVi4ac
	2twsg0UBPYy4akvk408oJ28GZV+Wy0R/IqvwtQU+DZBzKLS96lZbJZgD30IbEbk9VCZDHe
	ppzy5ei3zxaVgHIzoRSMLkvOLyQvtSg=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3d0dd9c9381so3105315f8f.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 09:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756744994; x=1757349794; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ApDGjF4qZlhoSmK2tdSzupo+2mRrDnKfGsOkf1zOwN4=;
        b=gx4iWFyht6LSQ+6xvKNufCmoBGZ8xjnmk90OiVy08WpyEssHnpHzmOyn2MNlf3iG8u
         cMwNkBSQsbBXU6AUCpnXztJ+Ug9KifqztzCFlijozf5Ds/neh621KfaWYNoQcj4Wp6es
         oym+THTQt2mK3yDLtNnu+p8Y9w2vHggswkjYe/4lX65neo8cQHK0wzgtlMKv48w6BUTS
         ThZ7R3jO9mYHJ6BfDGIv69Cip/MS6ENnBEtACW7rlOzchgfLC2sTKKCnRdrjNjpstO2g
         +V0O0ghSxQ7/l0Q6r1mmrqprvQbSrvVY8QCINtMdmEDYwNihp8JlYTnXl6FEAEerijMw
         CYKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756744994; x=1757349794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ApDGjF4qZlhoSmK2tdSzupo+2mRrDnKfGsOkf1zOwN4=;
        b=oGzct91Gyy+GP4cIHSufWlIhqS2k5J2RH8qYH/qBb8nsnIewxznvwO/bJcSCH0riIt
         R3w7ELtwERS6w2GN5DF+kfT53qOVjCUn7Bh3nzUuiUMMQjUlOS7oVxdF4Afi0pZWSLNA
         GQzFhqQhWFU/g0U2uYHPTrQd/IiFplv17pp/e2dcnoJno36VYDl/lwRMIJU0vaTXulhk
         3y7h3xIPtLqWxvxlUY54poQrABu6QnQ1I+E4bbGEwN+e/zsxpZy8JiXEBGpVIRJT3nxT
         cOv9vDaQCtNagB3jocn/dvrHbx00S5HEMQQcWfGSoUqMf6gIPaGmpHrC6njhhBz8YJyN
         sW6g==
X-Forwarded-Encrypted: i=1; AJvYcCVJ2ZhL7+NLQ/inG5OhWkG+5+ozuzEyn+S64cbd6Z5yFsHe/eUH8lG+7duwkcBOXiQlWviNAD4nrg==@kvack.org
X-Gm-Message-State: AOJu0Yxxdu/f7bfi9k4gIWQOkFwBJlMEExPNDu37HvBNBCHdDoBdMf8X
	uqROvqR9JQ0uQrlxaaAUPAJhN1ZL+yqq9Kr6jLHxDWrYCd0OvMVCDw4e
X-Gm-Gg: ASbGnctZE3hpeUv/MUxgRaBkHWE9IR4CcM1vZLwniedz6sq71yL3ucYccglsi6FJM+4
	4wdyhPH/Wuj/4vWZeBOCy8QXFV8kUdryOUfcgO4UQWN1VzZ1wsHR6w6E4GyALu3NStkzHFVSDz6
	IsUtw/Qk5nizcQWwJEMoPtiwxkUqgVPsnOWp4p+Ucc33GgkZc8Urc1USTNJT6baqmWFbSTQSgA8
	s+a9p6qkMuqTQDKN5Fr9usQcd7iHmFgfTTDF5MRLaFqPwTAPlI767Q9+d7RZ7Avrc+YxBlrhZEW
	V7bZUQm9z5T/osozYxn6NS27E0UAZf6l9hN2wdxRT2GhMkYKzVKwlA2rCh9FootJPTLe6cQFMn2
	7Fie0Ovcx2zblyAxgSoQBc5h3xnfD1iq9wT0LYMNmDCW838Txf4Y20PjSoA8CeBCZlVxWJpuitv
	WUyss4d86iKbt661nNwzIycddMZJnU
X-Google-Smtp-Source: AGHT+IGObzEWmAWMvVVCO+qu5XzxIJd7dvBXszVP90qakpw859cAfnGGaYfjxJR6FILuoiBJKV7+Qg==
X-Received: by 2002:a05:6000:25ca:b0:3b7:9629:ac9e with SMTP id ffacd0b85a97d-3d1df34d63dmr5448037f8f.50.1756744993978;
        Mon, 01 Sep 2025 09:43:13 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (140.225.77.34.bc.googleusercontent.com. [34.77.225.140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf274dde69sm15955362f8f.14.2025.09.01.09.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:43:13 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	brendan.higgins@linux.dev,
	davidgow@google.com,
	dvyukov@google.com,
	jannh@google.com,
	elver@google.com,
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com,
	kasan-dev@googlegroups.com,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	dhowells@redhat.com,
	lukas@wunner.de,
	ignat@cloudflare.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 RFC 6/7] kfuzztest: add KFuzzTest sample fuzz targets
Date: Mon,  1 Sep 2025 16:42:11 +0000
Message-ID: <20250901164212.460229-7-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
In-Reply-To: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8E68D1C000B
X-Stat-Signature: hdd1xfjryfgpkse9kqb91zk1o84gmmyc
X-Rspam-User: 
X-HE-Tag: 1756744995-687273
X-HE-Meta: U2FsdGVkX18z/IiP1p6+uLmDuBSltc2mo7GEzeeg7NGsGgmsJcYY1+sbXktXscjY68DuU6aF9Q2IMQpPauUfjoXBmiO7KlmxRfNmKCn98VIUjJKfznzc3+nR2BcoJMtFuUlv5hZSKnVhbRv1V/AxO+dh1qeGxmrIiU5GN5z6sH8WxICCSGnJjtwOjUWpxMBGCoJx0pIsXqKQB77GPCgzAbSRrFR1sLC2Xge7dUa86yrd76gYvTetdeUtLAbBjBAhIJvVv/uPdAkEclmf96uJDa/0k2fCcHsTY/ebj32PXM9HRWTSF0iCqvkzkB1hZNFlVRV2FjKl4YlI8E6W81/7PpR+kesqxM5AV9SsT1GE1f8GNsA+sXXGuvlIWgpac0pvBKsI95fmc1aDIAjrwd9U4/g1wdgyW7Pmbs3dlI94LkCR40zEczKXJu2MweLdr+mHxmEwXJuC64E5ujGMmOqag1OfXmtMN1NNjOOU+FBwWnG/KzkrZQlG7rmLBlG7luJ79obwISTpXW2s591kgNUE9FmdtBds9Ni899wgcXRXm38dxKjp2RU4kUYOV8b47P3ieh5E1ivCr0JDFt5dclIWh33w1oCK8I9AUtvIcSeFYjy+EATL25MyTckc7vzeI249Ie4XUYuasL3doqnZ22oealQRGTn3YWxaMo4ji+/O36KL5BCwj6CO7tHvtStVQQRK42zSP8SfxyMNrZdZeyqJ0W5LiNaLJOVoqmA3ncSZjg1lgpUQVonvLKMBfxkqkYpt/qb3wW+zG2mX2uvg+09CzUTKQnJiyQQy3gQi+tEwzeCqPerdz5XMCySR6yxO8aL5EwdCv/sLFPEsv12W4UH0eZc+Y6a+H4B9TZOD80Q/KveklBWTJJg0KdaDc08TfrAlR+Olz3ZYhHt9xq8wfMmJSMBvK5exebXlMoWaMTr0hxBeM6jEqj/QAio2hnmBJzm/tUyhz7HQ+fmX4jETPYR
 Q9LHQOf9
 dsYnxc9G8SQsIW77BzTepEVHBzzx0UF4KBEt41J0OIVRJxHSqIW8v/U1P7RMavdBbTRXebvuf/Z0b+Ie5d2/5ux/Gg1e3iNwDlFUGB5GWFvNCI0BelX0UfTtoR0ct5oM4p5gdX/L9XiITni0y4zzsnJRJlXN3If2YgdPtLp/Bx+sqdZK6RPvv+D/Tpa346KglYI/YfgrLihcoyJnN9Cj7FXROycSbBuuX479eqQYsT0wBTc5cSkFdTTDA1dzEpsDLcs9LxHmf41opY5DeFsofLjZhA8lzUOs38pMiRgTXdg/51pFHqmCp88gs5+G08DbEHgF2y7w9PDJrEnMpM0cEwyX/mQbrjWsxskhxv+/Gujq+37KRqy16pUBVtCPvHskREPrmYGOhx5WPc4h3uT3tku8vMJIV8GMy2xgVX2xGZV8HsYTJxRS4xHjMvBBhK/rMVJvN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

Add two simple fuzz target samples to demonstrate the KFuzzTest API and
provide basic self-tests for the framework.

These examples showcase how a developer can define a fuzz target using
the FUZZ_TEST(), constraint, and annotation macros, and serve as runtime
sanity checks for the core logic. For example, they test that out-of-bounds
memory accesses into poisoned padding regions are correctly detected in a
KASAN build.

These have been tested by writing syzkaller-generated inputs into their
debugfs 'input' files and verifying that the correct KASAN reports were
triggered.

Signed-off-by: Ethan Graham <ethangraham@google.com>
---
 samples/Kconfig                               |  7 +++
 samples/Makefile                              |  1 +
 samples/kfuzztest/Makefile                    |  3 ++
 samples/kfuzztest/overflow_on_nested_buffer.c | 52 +++++++++++++++++++
 samples/kfuzztest/underflow_on_buffer.c       | 41 +++++++++++++++
 5 files changed, 104 insertions(+)
 create mode 100644 samples/kfuzztest/Makefile
 create mode 100644 samples/kfuzztest/overflow_on_nested_buffer.c
 create mode 100644 samples/kfuzztest/underflow_on_buffer.c

diff --git a/samples/Kconfig b/samples/Kconfig
index ffef99950206..4be51a21d010 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -321,6 +321,13 @@ config SAMPLE_HUNG_TASK
 	  if 2 or more processes read the same file concurrently, it will
 	  be detected by the hung_task watchdog.
 
+config SAMPLE_KFUZZTEST
+	bool "Build KFuzzTest sample targets"
+	depends on KFUZZTEST
+	help
+	  Build KFuzzTest sample targets that serve as selftests for input
+	  deserialization and inter-region redzone poisoning logic.
+
 source "samples/rust/Kconfig"
 
 source "samples/damon/Kconfig"
diff --git a/samples/Makefile b/samples/Makefile
index 07641e177bd8..3a0e7f744f44 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -44,4 +44,5 @@ obj-$(CONFIG_SAMPLE_DAMON_WSSE)		+= damon/
 obj-$(CONFIG_SAMPLE_DAMON_PRCL)		+= damon/
 obj-$(CONFIG_SAMPLE_DAMON_MTIER)	+= damon/
 obj-$(CONFIG_SAMPLE_HUNG_TASK)		+= hung_task/
+obj-$(CONFIG_SAMPLE_KFUZZTEST)		+= kfuzztest/
 obj-$(CONFIG_SAMPLE_TSM_MR)		+= tsm-mr/
diff --git a/samples/kfuzztest/Makefile b/samples/kfuzztest/Makefile
new file mode 100644
index 000000000000..4f8709876c9e
--- /dev/null
+++ b/samples/kfuzztest/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-$(CONFIG_SAMPLE_KFUZZTEST) += overflow_on_nested_buffer.o underflow_on_buffer.o
diff --git a/samples/kfuzztest/overflow_on_nested_buffer.c b/samples/kfuzztest/overflow_on_nested_buffer.c
new file mode 100644
index 000000000000..8b4bab1d6d4a
--- /dev/null
+++ b/samples/kfuzztest/overflow_on_nested_buffer.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This file contains a KFuzzTest example target that ensures that a buffer
+ * overflow on a nested region triggers a KASAN OOB access report.
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/kfuzztest.h>
+
+static void overflow_on_nested_buffer(const char *a, size_t a_len, const char *b, size_t b_len)
+{
+	size_t i;
+	pr_info("a = [%px, %px)", a, a + a_len);
+	pr_info("b = [%px, %px)", b, b + b_len);
+
+	/* Ensure that all bytes in arg->b are accessible. */
+	for (i = 0; i < b_len; i++)
+		READ_ONCE(b[i]);
+	/*
+	 * Check that all bytes in arg->a are accessible, and provoke an OOB on
+	 * the first byte to the right of the buffer which will trigger a KASAN
+	 * report.
+	 */
+	for (i = 0; i <= a_len; i++)
+		READ_ONCE(a[i]);
+}
+
+struct nested_buffers {
+	const char *a;
+	size_t a_len;
+	const char *b;
+	size_t b_len;
+};
+
+/**
+ * The KFuzzTest input format specifies that struct nested buffers should
+ * be expanded as:
+ *
+ * | a | b | pad[8] | *a | pad[8] | *b |
+ *
+ * where the padded regions are poisoned. We expect to trigger a KASAN report by
+ * overflowing one byte into the `a` buffer.
+ */
+FUZZ_TEST(test_overflow_on_nested_buffer, struct nested_buffers)
+{
+	KFUZZTEST_EXPECT_NOT_NULL(nested_buffers, a);
+	KFUZZTEST_EXPECT_NOT_NULL(nested_buffers, b);
+	KFUZZTEST_ANNOTATE_LEN(nested_buffers, a_len, a);
+	KFUZZTEST_ANNOTATE_LEN(nested_buffers, b_len, b);
+
+	overflow_on_nested_buffer(arg->a, arg->a_len, arg->b, arg->b_len);
+}
diff --git a/samples/kfuzztest/underflow_on_buffer.c b/samples/kfuzztest/underflow_on_buffer.c
new file mode 100644
index 000000000000..fbe214274037
--- /dev/null
+++ b/samples/kfuzztest/underflow_on_buffer.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This file contains a KFuzzTest example target that ensures that a buffer
+ * underflow on a region triggers a KASAN OOB access report.
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/kfuzztest.h>
+
+static void underflow_on_buffer(char *buf, size_t buflen)
+{
+	size_t i;
+
+	pr_info("buf = [%px, %px)", buf, buf + buflen);
+
+	/* First ensure that all bytes in arg->b are accessible. */
+	for (i = 0; i < buflen; i++)
+		READ_ONCE(buf[i]);
+	/*
+	 * Provoke a buffer overflow on the first byte preceding b, triggering
+	 * a KASAN report.
+	 */
+	READ_ONCE(*((char *)buf - 1));
+}
+
+struct some_buffer {
+	char *buf;
+	size_t buflen;
+};
+
+/**
+ * Tests that the region between struct some_buffer and the expanded *buf field
+ * is correctly poisoned by accessing the first byte before *buf.
+ */
+FUZZ_TEST(test_underflow_on_buffer, struct some_buffer)
+{
+	KFUZZTEST_EXPECT_NOT_NULL(some_buffer, buf);
+	KFUZZTEST_ANNOTATE_LEN(some_buffer, buflen, buf);
+
+	underflow_on_buffer(arg->buf, arg->buflen);
+}
-- 
2.51.0.318.gd7df087d1a-goog


