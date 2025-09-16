Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58054CAC59A
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2DE68E0016; Tue, 16 Sep 2025 05:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADE1F8E0001; Tue, 16 Sep 2025 05:01:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5A28E0016; Tue, 16 Sep 2025 05:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86CC98E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:01:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 54AD21A0903
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:29 +0000 (UTC)
X-FDA: 83894519898.11.98AB3E0
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id 55A1640010
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YOPLX4wf;
	spf=pass (imf27.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758013287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdmcBIJJ/dIrmboz2dj1USPN5mnOnIS9n3oFxB4eaBc=;
	b=ajqtwooKe8MKrtL1bePPYEUMBm2Vx1a24/BiNHclXW58hatT0lZX2jYisZwf7Axfsdd7Ns
	x7FWr/E/k/OfdnCVjwGFFLdFx2+tMDb5Z7R2DwiEkBkJUsRqnvoQwd3R5pYYHqIZ27OX1v
	rkhgYQr7iORuUsrj/PUhLbgK+2oalEI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YOPLX4wf;
	spf=pass (imf27.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758013287; a=rsa-sha256;
	cv=none;
	b=AlsAICA227Hq5/ULtIqUStWe5pk4B/8JvYc5wzFKZ+iyI9RZmt1MMBSzD0LpnuIeAZdhyV
	Cs+2j5ZU/lvJQqZjts7nB8pi1BBsgtu0xU4HfVl7elK7YphfjN6N62NhF98jF7X1U6AtZw
	nLIW6EtFlG6YfYY5rQgDEW5umc9jF2I=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45f2c9799a3so13442125e9.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758013286; x=1758618086; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xdmcBIJJ/dIrmboz2dj1USPN5mnOnIS9n3oFxB4eaBc=;
        b=YOPLX4wfGLh+tORSoF5VTkBU7HNxgFYb93zovwlm9BBLB2LaEaa6f/pJu1+GHZDjOi
         EcfajVpnwVRpU2fcdier8rr2WDDfZ1ozgVYLHJZKtdeaz6yvYYrY+hEyVWhwHZ2RVZCs
         rK/CxvhndDGDsVefLtGf3hn5J7CsLmcZeT2m1wYSmgOHGR/5UNFLIQcKcgdcZsgT0vG6
         qaf3cxPVZ1SZGiN3vemZldiYfc+D+Fa7Zhu2wD5K14iTqq5QaGYecYD+9s8dkEy0S4jm
         qaiGyyEqpqGO5Hzm9OPiPWVGuE6alqe9yio2pN6xFWzyqPHiLo6uKH23rviDB0r9g8y+
         qGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758013286; x=1758618086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xdmcBIJJ/dIrmboz2dj1USPN5mnOnIS9n3oFxB4eaBc=;
        b=emln1jEJ0LJKHaNrzfOvU6D/cMQUY8ICfGE0s1jF5kil1lZX1e05e155boX7SuqUBl
         vvfXYS4XVkQ5duqJG3tmwQrWsPoSNMOpIE63+XukTGtw9fKsFIDcoPBD1Of8ltuv/c6e
         0CEf0ZCvNvS7sVETpz8Dlr9Ukxk9w8kmYtWxfoa4LQtszSi3Wr7OzStdlmjDhKCU8+et
         tvRE6wYhXOS4C0dippaX44S/TGCQVmtWd8OljES0S1Ljk8rfZRH9n7oVHgDGfg0uvR5d
         yIz0BhlNzEeqA843GVGe1tb5Q7FyoXFTrTsP9cTKdMb8kWnDzKO5v/rnqKPmBOYZA/2x
         VtUA==
X-Forwarded-Encrypted: i=1; AJvYcCUNbuVPpK4v9hYoaCvsrtWs8KqVBMbirTxtmJB6zryhGowFSQ1CTIAkwLpmGJ7K4dlNqKHWszl3rA==@kvack.org
X-Gm-Message-State: AOJu0YxdlHOJt46dj8NUx7TxCWEtQSL+jUk4vzWPLB36Va+sOQ2pV31I
	3IDxAxr/smfZNkuXlrkfA4HBjfCY4qXytW/oTJH8dOiNh3rtEXNjQkfy
X-Gm-Gg: ASbGncttLlYK0+TnRsy0YEEatT5QrJD3uhh2cBnzVlKr9jBTeobaNG6fuM3FPOqiym1
	hz109UOWPD1i7ie0CowoFuJV1k4V6ILmq9T4ScFeFWWq7kJQ2Uoh78nfUVeBY8foZWxW3C/wvym
	IY4l3yKuP/X3ptMNedKplzeQeFvY295VYjddU6jzaUqhw6wf2SYu6y9GUpdlmdihsPLrjIl8v8C
	QK9ID9rwW4vhEyIWl24TPrGBH9MnOPPsZJisOiZtJq2WfcQV6HntMre5Wu11bZtYkQiSz8QmRrU
	QffIaq+fNbBIrOQ3Bxb5dA4pySKzX3oWyDn9WCnvrqkygUFVlkWpU+HWLpmp1Iiz8l3BrEhdStb
	UdVun1JzI6ctVqTZsGupZDx3IAZ/InHIzVRhHk2dSC/81VLFgECfXhSJ71o/c/i8ozR7S5OZyUQ
	WcOSWUgVfvhXle
X-Google-Smtp-Source: AGHT+IEadfbP3jNYyOIN5QPnIDkgoE5rEixgqXRhdDXaUoboFgkfVk5OQ6KluvW7vDOuiRH8ZlKDbQ==
X-Received: by 2002:a05:600c:12c8:b0:459:d645:bff7 with SMTP id 5b1f17b1804b1-45f211d075emr98840705e9.12.1758013285667;
        Tue, 16 Sep 2025 02:01:25 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (42.16.79.34.bc.googleusercontent.com. [34.79.16.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037186e5sm212975035e9.5.2025.09.16.02.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:01:24 -0700 (PDT)
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
	tarasmadan@google.com
Subject: [PATCH v1 06/10] kfuzztest: add KFuzzTest sample fuzz targets
Date: Tue, 16 Sep 2025 09:01:05 +0000
Message-ID: <20250916090109.91132-7-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 55A1640010
X-Rspamd-Server: rspam05
X-Stat-Signature: pw9xro7pwpqgs4yd54wmddh94jjt7j7t
X-Rspam-User: 
X-HE-Tag: 1758013287-28147
X-HE-Meta: U2FsdGVkX19gEb04EfNzXaEwbQdEDF8xw6vx28kuYUp71y+PbRItwblhidQX1kUawk32/RxsoHc9zfPz68yQP9YCe9H3+r+4RJZmzy31KVrJZoRO65ubYSeiLURqsp4sVPCdnePOyKnOC5sZctTTzjcFD5HX7rXE4+1dpHtFKtLsaT6NlL/ylmaHSAIAWfgN0CxCu+NpeezRMVKCUtxVLfRklqMiFtWevsXYJaYTah8Yu7kE5JPnaPi91yJVeknGg5n4+XJEOK+nYxScAZoJSlncHQodHYV71xzsCy/tWagIZ0TsUx8VLNBCfBDGZ1txsTJf8/wVlyfM9nZFL2uAABnQ8saNbCSc+yCs2KhbxfM/z144QFX0UykWsTbZ8O/dSj92eoTycpaBMN2N9aor+r2yp/DhCsR6lSc6y1liAFZTsjIprR+Ga5eO9O636jj3u/HxzKuqMzSGBCM4vR2L0MS6JmEUbyolL3UhQTkiw0H1TbSDBkPjDnw3Hm95fk9qj7lu3W9QmugHjL7NBiCXEmy8BcQ1tjLeA5TDR07c5ziJIcbWJZ62tiVQPrUhLOQMrt3H2JFB9+8qHBLvqJX4XactNkPRmB5zR8IyCwk3A4ol21UJv3ZXJNQ7Vjp52fNozKsVUVHdtDqzye2fRSGcX3P2PJxXPhmlpLpQ3G7nOvYIxz4EhkvHG4stungt9k45i6EfvEq4AYPCehpRYWKHcTkd7mgPPay7KrIg/azUBfXjYTAoX5aWfzY8sH1+ouEV13Fa0rLKgNcjmp6QMNm3udn+b+7rHUoutfI8Bdb+nJ9LhIOuzmN6CM0br74wfwvy6oLTC7utNA4QSWyA54VkazNKOSOECaT558FkmISTu9Fm9EAILrj9tO4oI0ZF7dxUFFITSA4VhAazKCZmE3WmhbybF3N3JalTDQej3Hj0VtXKjypoYjWAZpvey13q0rV0o0CXvyBKGfHcaAHWMiL
 z/f59ndD
 TRv2xApVpNp/rpH+RT02s1RhKxlT8MzToTZCPrQ4vZ7zK0onzvWv0+qLl0qKPudu+35iYoC1/HcTT73IS/mmdkV0eUI0It18zJS993IBG/n3qXnCsrN7HSr2dW+dp0/pJUGlOIhdcxyBu3HMDoso4oI/LsgHLPeneVWF4sOO73JzRJyG005ksdCY0djgLX1rBAG+BCGTFO5BFJm1mT3TbFFSu7qUWJ1h4s6ItUFkH8a0JEK36YsWLy6W2plPrnuA+15lqKRUrpMyN5kdwVw/WdwWpHZ82uNyc9ySPgQ0w9f5OXztqyP/w+tgIBxMtRu9Yty0cINU4PlcDfFPeN5hW8qdblb1UDFW5fj2x+jFuhhewEzhDXOE2O+zUU/fhZ0VBT2TKOpzHDDyAGW6dWVVGRZ87dzNqK+VVlwF7yzLZO+sxWNC4jEIpKfCovsw63P9BBXU4
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
2.51.0.384.g4c02a37b29-goog


