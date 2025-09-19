Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73970CAC5A8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 14:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993C58E0001; Fri, 19 Sep 2025 10:58:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91CCE8E0016; Fri, 19 Sep 2025 10:58:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5158E0001; Fri, 19 Sep 2025 10:58:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5EA958E0016
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:58:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F846C05AE
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:58:07 +0000 (UTC)
X-FDA: 83906305014.06.6B1157A
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 34239A001C
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:58:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P+6Q94YP;
	spf=pass (imf15.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758293885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eBXsJ3eFBRBXMY0OnOP/8+Wo598xHcjcSo7yO9rMMTI=;
	b=TqsQ2xiBhe+1yLsh3JlgJ++KF/y2MwrcvngSVYH57kX0tZqPVQA9slTQCiFimEKPYeUAPj
	Tds8lRz+wYOEX36pDSuef4WYUbHLEr/xiIGFaOBz+yDS0mw5Q5/fSw+pVnG80EgiYI5sxV
	pNZdY5umjSmhy/AaVtJ9FrsTfNgrE9M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P+6Q94YP;
	spf=pass (imf15.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758293885; a=rsa-sha256;
	cv=none;
	b=C8WmwikjAv/92IwuzpNPmbnONrNnQUOr2sXd6oAv77sssllz2G8q9X7K5+scPGpHAOpioa
	6Blp78lmMZO79/sDlpoMDiPQXxAX8BKUfEIu7d0rn+1tOgG8sMnVjPbWxCQvRFlUZwioTj
	TV0qB12nhLa84nOccXds1SovkeQvdQI=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3ece0e4c5faso2682654f8f.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758293884; x=1758898684; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eBXsJ3eFBRBXMY0OnOP/8+Wo598xHcjcSo7yO9rMMTI=;
        b=P+6Q94YPQGfjlRuH0jMTtDx+QuaZ4YEKUE+eqLV5cTL2lrSAbf0BXXMjQWLxwkTAQc
         4MLON861m74MkWoOPtOsiqSmrnPnBl0hqD2qTHf3rQi4tXF9y6HDyPmLusW7uuYNEFqp
         OxdAF8PtdDKctEn3fpHrH4M7qSrQu2RGyRqywFaFOYGF82qS9YLC7FunHPdZHCXzNGXx
         xixDWfRgC0/6G8UgPrg/b5EnwZVmJAzl4wYa9gVTMHZAbrz+kgVl5W/4nNi2zBYuiMLA
         ueJP8+VQB3wi4JlZO7TEzXFvpzFnBJ6re51eBUEYNyGrhKrNWfjtAPq8MXPY2PNIeN+S
         bPeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758293884; x=1758898684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eBXsJ3eFBRBXMY0OnOP/8+Wo598xHcjcSo7yO9rMMTI=;
        b=vWv11b744nRY0ZWIeuW28EJ2/R9dJPwFzhLjIZBcwFFS52u9ykdMiR40PX71ednT0x
         rn794QXWS9Kwj2A/3bQLM+sfI9Lp9PWiQT7WYmI/gs1tfUmspzQYfs/Efr4T9d2YJoxt
         inQ7vv6JpsPRhGB2jJQtdBOVdQz+wlCMSst6A/AkjKWGipOPRIlmzivUUMj66V4B7kdr
         083GwqDQchy83c2+R+XjqO8cWWgaqFVf/6AESjrEf0uPQrsZf79rT/ZJ+nbdFeWs83QF
         VHE58y1WfazbftYZuEQgC9trUIdX86nd0oZbD0UkkA5queKFdNEDOeO5ryOXpkCJnkkp
         Agbw==
X-Forwarded-Encrypted: i=1; AJvYcCVhyRpN0f1jnjD+saQSSUkvCiE7cqqDyDlt+U5Wdfdyf5PMom2NniknATR0kT1kYyLjFEIXuFzf9A==@kvack.org
X-Gm-Message-State: AOJu0YzSwmpP8QnTcIF9aVrgKlP9Ub+6Bm0DxtrS8gMn+6f47Cbuaz5G
	fIInxTZwUlbYjaTpvXsDIHT7ZsZ+sdavI9G6gkiH8iEdB4uYPF8LKoHB
X-Gm-Gg: ASbGncuJo6UP9FC691tbztR5S2Z3xCiywEGVW0HcLxMz45yEgSxRQvaWE0GE/sG91xH
	/nr41Eeho7slPSIvTu1kF2+BX4paAIzt5BbNJX0rL3+Hgl2TV+fmMIqQKhDR0ylE/rrXvQzobeJ
	636sj52AUUcHgBimTUSwXnWhlzDqCLui7Wsf7jqXhG4u6D6JqE3UhdYuf8l/aFmZvSMIWH337nt
	5MiqJw679pcxRDbt7Uvs0EwZ0zBtUiIRiQhuEhOJcrKV1AB0WLE+NoJNoUyt7o/JzU7Jh+FUwul
	ZJDuFGjRl+cKea8Ee1M9Ul81cZEiSIGioz//zAfgee/mTlS4i1eKmzXuC+P/w2W3v2O7Jn/lqPH
	6CyOzvHU85bkiotxXv5Ewvfh/OJXiJ/bWD7ZUnj/fYKkqfO8Qu1EUOqVj6bLrE/n8QkGrihWXNT
	auRRoH2CeajMsXhfk=
X-Google-Smtp-Source: AGHT+IEbUl2JCzptHoApCryobfgPX9okNUcS7jfuNyAQmqaUFFRa2xXzjiLnSNK61qJ4zpujJuNB3w==
X-Received: by 2002:a5d:524d:0:b0:3f2:97a6:db6b with SMTP id ffacd0b85a97d-3f297a70589mr290499f8f.3.1758293883676;
        Fri, 19 Sep 2025 07:58:03 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (124.62.78.34.bc.googleusercontent.com. [34.78.62.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7188sm8551386f8f.37.2025.09.19.07.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 07:58:03 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	tarasmadan@google.com
Subject: [PATCH v2 06/10] kfuzztest: add KFuzzTest sample fuzz targets
Date: Fri, 19 Sep 2025 14:57:46 +0000
Message-ID: <20250919145750.3448393-7-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
In-Reply-To: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 34239A001C
X-Stat-Signature: nd46fw9ji5rrkt4tgmsz3wnmfrqpdcat
X-HE-Tag: 1758293885-935403
X-HE-Meta: U2FsdGVkX1839ecRnclOaz/b2XNjWhlTDZYiZHjzqIPSihf/QmXHJJWzLOOEwkYw1zibi2FoTAaOQMM4IaTOYrNIpW09Q7vRkeJFYGHaiPIhuKB0eTctKMe5cl/MQVdU1O5yMz/0Z2KDqR7jHjE0ysc3cM0GoTeT8lolFS/9BFDJSyFaFVubo8kBoNkyQcdw3tMw4WA7Vv+YaForUSLkK5p5aSoUWeKaBGIjGymkkEttLzMLZvJfzWMwjwzGr4RQWWHz5IJsBfR8m15MJ9nVg4/Yl3rLNX/k/EGqHaNjcOfb9abFEaZQFHhShQ1+yO/FoIbH4CueQ/vZc8L2H6AI0eIiexfVg4hBTFwko+wCaouIdJArIMSi2M1lRuNSFGw7jq6eekRNWTMksmJtZ5/BPXGjzp6mBI6GlAyucRtshPXOb6sSXQp5qEL+PNlbt9UlRipePtyQoQVbhq1b8cUTk5rHiicRc7UzSc1jzSGh5WP9xP2JM8UfKw0YMklxyMqx16HOqHsJsV/fJGc7Ea9J1wb9ifvnUIxJLMd/633zvxIvnhvqOZFltiucYUehIedc2rt5NM3AJ2lRXRfvIQ76YHqSslvHu4LWhPkSsggkjDzjLQ64XL+nASJ54TF6OlcFwHj1G+XUvIUmgOgNnpTdc5tY/xti5QIUfJYCz92aNyGhKuAjwtz3fY8hofcDkTJvMdIly9JCVE6HjROCsrqYW4p/YwvrYnICoPSRhnSKGAIGqhm/NWm0AM4foBR9ClFRXYeir50UaQ9V9LAuO4u7lsaHzh5Xv/B8/9CCpfZ6C+w6oHskIUqBoU6waoidPFyBQe7WVVJlQElpLZxFpQJCXB2rosHr7VoN40mhVfoERBvj2ITz6nZjxQEMYhuvVZZ96xVOYFGzyVApV64xr9gTNSVBGWLKF9G/wgO+dMUboW/08sUZdiBCINhpM5p10B8dPtkuSStmH50SzWG2AqT
 AzY5cqam
 sRxfpiHnJmYiJPT7MSpDnEp+td9R/exegvoXDXuUvwSut3C1sV5booCtZx6c0c9RDME/ingPghRCkF1Oy9OUd4UrN11QVGBw2L510egPz6RlB1hAK2pAi/uRMlvHf50XwtyfBQ+jvH+MsPkGnxZyvHizOtRb9TXd3HqD5gQSAvQ17OQCdHm+A1zgSEmI7maiAvMa7JM9pYKi2QrB7WN6y19jTxKx0qSPInD2klJR1nBggFJ7YTE0qwg2NXT3QehFg6XBXax2dKmo9Hwo+sPqQINqpe3SVn76U43/NVfAuQW3xImD+xptt+edPcoEaZUhbJ+G3BG/71qGtnQbxjKSRjdaGlKjquprSie3ChgaRhPiALFrRy6F9/Nhq9sC5zgWVWd2XiWUeeuqxS1tyfRx7ug5Cp5Yg9KOcTtVYLqHew6Y7dpXccmKHoIZ+fSyS8UUO0DMl1XRd4vkik7STSEYwbcEcow==
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
sanity checks for the core logic. For example, they test that
out-of-bounds memory accesses into poisoned padding regions are
correctly detected in a KASAN build.

These have been tested by writing syzkaller-generated inputs into their
debugfs 'input' files and verifying that the correct KASAN reports were
triggered.

Signed-off-by: Ethan Graham <ethangraham@google.com>
Acked-by: Alexander Potapenko <glider@google.com>

---
PR v2:
- Fix build issues pointed out by the kernel test robot <lkp@intel.com>.
---
---
 samples/Kconfig                               |  7 ++
 samples/Makefile                              |  1 +
 samples/kfuzztest/Makefile                    |  3 +
 samples/kfuzztest/overflow_on_nested_buffer.c | 71 +++++++++++++++++++
 samples/kfuzztest/underflow_on_buffer.c       | 59 +++++++++++++++
 5 files changed, 141 insertions(+)
 create mode 100644 samples/kfuzztest/Makefile
 create mode 100644 samples/kfuzztest/overflow_on_nested_buffer.c
 create mode 100644 samples/kfuzztest/underflow_on_buffer.c

diff --git a/samples/Kconfig b/samples/Kconfig
index 6e072a5f1ed8..5209dd9d7a5c 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -320,6 +320,13 @@ config SAMPLE_HUNG_TASK
 	  Reading these files with multiple processes triggers hung task
 	  detection by holding locks for a long time (256 seconds).
 
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
index 000000000000..2f1c3ff9f750
--- /dev/null
+++ b/samples/kfuzztest/overflow_on_nested_buffer.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This file contains a KFuzzTest example target that ensures that a buffer
+ * overflow on a nested region triggers a KASAN OOB access report.
+ *
+ * Copyright 2025 Google LLC
+ */
+
+/**
+ * DOC: test_overflow_on_nested_buffer
+ *
+ * This test uses a struct with two distinct dynamically allocated buffers.
+ * It checks that KFuzzTest's memory layout correctly poisons the memory
+ * regions and that KASAN can detect an overflow when reading one byte past the
+ * end of the first buffer (`a`).
+ *
+ * It can be invoked with kfuzztest-bridge using the following command:
+ *
+ * ./kfuzztest-bridge \
+ *   "nested_buffers { ptr[a] len[a, u64] ptr[b] len[b, u64] }; \
+ *   a { arr[u8, 64] }; b { arr[u8, 64] };" \
+ *   "test_overflow_on_nested_buffer" /dev/urandom
+ *
+ * The first argument describes the C struct `nested_buffers` and specifies that
+ * both `a` and `b` are pointers to arrays of 64 bytes.
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
index 000000000000..02704a1bfebb
--- /dev/null
+++ b/samples/kfuzztest/underflow_on_buffer.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This file contains a KFuzzTest example target that ensures that a buffer
+ * underflow on a region triggers a KASAN OOB access report.
+ *
+ * Copyright 2025 Google LLC
+ */
+
+/**
+ * DOC: test_underflow_on_buffer
+ *
+ * This test ensures that the region between the metadata struct and the
+ * dynamically allocated buffer is poisoned. It provokes a one-byte underflow
+ * on the buffer, which should be caught by KASAN.
+ *
+ * It can be invoked with kfuzztest-bridge using the following command:
+ *
+ * ./kfuzztest-bridge \
+ *   "some_buffer { ptr[buf] len[buf, u64]}; buf { arr[u8, 128] };" \
+ *   "test_underflow_on_buffer" /dev/urandom
+ *
+ * The first argument describes the C struct `some_buffer` and specifies that
+ * `buf` is a pointer to an array of 128 bytes. The second argument is the test
+ * name, and the third is a seed file.
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
2.51.0.470.ga7dc726c21-goog


