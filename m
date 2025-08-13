Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4DDCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03D0D900074; Wed, 13 Aug 2025 09:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1CD900044; Wed, 13 Aug 2025 09:38:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8285900074; Wed, 13 Aug 2025 09:38:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3EC7900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:38:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 98C551A03BA
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:38:46 +0000 (UTC)
X-FDA: 83771839452.23.03F1525
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id CCDF2C001A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:38:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CU0xqy/n";
	spf=pass (imf28.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755092324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=08hbUSvRcagfemg83g47pFkXwfN5ra3fR8Zxn3xb4d4=;
	b=G3NuDYwZ5vo0UUb34ToJfHSQ2VFiV1XLyHTnRDjVFNOGFEAHtj1N9/YCw04XAjYZfNUEm7
	cypoAFyMK6c8icqPvin/+o0IEL0U2IqDHrJiiJA+lbprUJfSWo1INCLzi9SNb5HSb6s3zG
	nIgQXfm8FaMZK0FaJJtfydck8/gvRWQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CU0xqy/n";
	spf=pass (imf28.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755092324; a=rsa-sha256;
	cv=none;
	b=71q0N6SLS7uMzDVWx/HIjPVuMKTUrdfkxZ/jkxepmXOzQ3HxpMl92aQy2Q1OsfK4GVq5+N
	jkkzSS6/a1+gKf1V6PRjmHDh9GyVz0knTErkaEob7DnXoDnmqJhc0s/RrEmvLqohXtaJBC
	d4vEzvmEP9iNMiGB/Z95kGwrL7CUZYY=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-459e39ee7ccso63882375e9.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755092323; x=1755697123; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=08hbUSvRcagfemg83g47pFkXwfN5ra3fR8Zxn3xb4d4=;
        b=CU0xqy/nf8xMFSPlFJycf2cKm4plC5XG9CttxhQ4Veqo/dNjezuih6xJGMkM1PCfGg
         sigS2XRiOFLbWWQbr01kQgtpNGZO93jFfac6J5WnDGB6LdCxMS/lg4fAn2m5b4EAk/uu
         PHWNvs9IEb16ntZHHOR7HbWwQ2PVYGmPNXhskCAEI/pKaauJXw0K53wHf0hUyxWjANcs
         PgKwUh0d8oLCoVnc1uDUVgDhsGYpwRQVJx+s1gTINtszXzFGelc3aV807tr6q3+QI+D9
         Vie4jiVDmk79OFB+nw/OenM0WELSiwvDhmDPnmhjnd/TEh+HSZ3G3vookdxwkdXFALuV
         EqTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755092323; x=1755697123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=08hbUSvRcagfemg83g47pFkXwfN5ra3fR8Zxn3xb4d4=;
        b=DjsidZkORN3Ft3ASOLsaU4EDtaEZQ65Su7sGgyf1Amnh9erHKM2a6PT8686Z/OksqJ
         364y2L7U8cajCjZAh2NX5+YV2s7c+TpO65jU+ospNFwvU62VeAPTl8mD6+26YDW8q1bG
         snSfxVnVI3IckLl9/JyB0tKuBY2yiRz26NQCegXu7XKQdPHYYBrIUBMmRYDTJKw2hYXV
         XEz3FXMb7JVKIFQ62Jk1phVUBbL4BgFUy1g+34rLNB6zYZgPREeDtVvzofsbaVIzRUr9
         ICzLVj+yqhlWltakCk9t/OLOwtanx44mox0Ig2MOr1bTBZtHzoMe9sY9ipclLwfXIE9J
         lyiw==
X-Forwarded-Encrypted: i=1; AJvYcCVWR2TzT5E+TGMLGbRDwry4nPC5Yn8lg1ay0e8P8ywzB4smxiuno+eU1GSQzPCBfWIYlLNKI6b70w==@kvack.org
X-Gm-Message-State: AOJu0YwNqz9bunCnNtPHgTf4qTzd62t/Os3wXzFMWNDOKdF/zvGnioOF
	a6Gl7/lPMXB5BPGmGgrzzvM6/FPv/5tpa770yOE3pdgLU3ijMoz0b6Es
X-Gm-Gg: ASbGncvDEygMxExoF64ql6n5mAzjXi88pYU3Qzrwytw4Ylf2rpmNAF9HWllr2KbVl7V
	vFr/i1RDaMm78Tein0qt4d2b7ESBju23qU75XNwvOS36voJHfoFrnAaLsn9ICzh50PAtDON0S2N
	fs2NGhOezkWJb9xUFzUeld6oZZcI7rDmqFKupa1HczTrq97DjqD2eEAuyphHakf5MATr55Yiylf
	mqReDaIA1sSjhDqRnbDan9L/tmC8A8E2T5EuwzQ9p8TCKKn4hs5/dSBZB6DJGVWpwvJ++iQytiQ
	sYSIbeV+u9QBIGFBGXO7BIbeZ+LkWGii82FYNPo0GiN+2MD+05gOdvo6nH6S7a9kI9xz4KMAc0d
	w+MyuNmG6dfaEsEtP9nLDS7+Xy+74JXzlxc/SqvSgghhdMujYp0JgwbDO2D0dDCw3dVhwys6pUg
	n7cIkOPHjSiSffsBXW0GPoc2eBZA==
X-Google-Smtp-Source: AGHT+IH/vHQLEUqCTkHELdcv4FlcQ/pK5AuwNwJHyQdHRE3adkmaZLxp5+wlXgNH0eI9cVeElhHRKg==
X-Received: by 2002:a05:600c:1c86:b0:458:b01c:8f with SMTP id 5b1f17b1804b1-45a1a80e6femr1190105e9.8.1755092323030;
        Wed, 13 Aug 2025 06:38:43 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (87.220.76.34.bc.googleusercontent.com. [34.76.220.87])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8f8b1bc81sm25677444f8f.69.2025.08.13.06.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:38:42 -0700 (PDT)
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
	linux-mm@kvack.org
Subject: [PATCH v1 RFC 5/6] kfuzztest: add KFuzzTest sample fuzz targets
Date: Wed, 13 Aug 2025 13:38:11 +0000
Message-ID: <20250813133812.926145-6-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
In-Reply-To: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CCDF2C001A
X-Stat-Signature: 8jd7mt69s5xmfhexwf9dqwgpcf4d36qr
X-Rspam-User: 
X-HE-Tag: 1755092324-3602
X-HE-Meta: U2FsdGVkX18YVgF5MnVIsnGJie/RHltY28Lf2u7ljvL1GMA2eVeEURaZ4Dm0OpyLYM1YlwUSnbw1LYuBt/UqY8gDXZ15KeSqFWYkOlsA1M52N2b+fxDtx785jfa0BoldwIYL40CjNQzLDVMvL+8SXabwIC3OZQwk3H85olUpuufoRV04BBh+pMKp2cwLflzThNL6LenYD5Zar8HZqYnlvexat66U29yKl9CvNjI/qORuvGv8RrWRseTptyWmNeVjCmubmrN++Fjqd/nqf4eVQIVJELtKWDiS7QjXaPj8UDyl7x6V4UF7TQPpmxYhSt6m4KA8gIquSqaTO4/KpaB0XqB/gRJeSt3NbzmKgfB5vJIlVvApf3HPm4mjawHdfsLrtRjJn2Zs3QFkgHEoyCd7P1jOE+/wp6hPosJSXHtuf9+6mxJE7joRAv5J7by5mrZ/3aXqzr2jlckJbWHpVjZPRuG/Uwsi9Nfb5RCHrk9wOdeeocNa9lNAOxpIX3CKEfOrmc/kIfBBvYPeJE+aWRwyp+WzTiJd9Bd6zsY0lz+NAHA29uZnJy2VQiaUxdHytWh2rwHgusnuudIvWwIcSBGmxMmZQU1Y7ZzC86wMbTvPDUMUhNuWx6ZuZMjYwoz+JYo2c/jP6TSPmUVvAjOnl/tvOLn1QTMYljq47njj4EbrSRi1JdaBDtgxIIYFwwpHOxSAbB9yYRFzUBPbfHXkDMt/d6Y+MR786HbWAErrikeGYHE4MeUqmFR0vG97fV/z+FUxMvb/vXMk6UWFEcPKpMoHes3tk9PpHUDJi/8M0ObjICrQcev624cP1CpX6N5QQRv3kpp4KN4zY7dCvgurgJIFU1/RpmqD36jQDP+GUU8XZg78zeOsd7g69wJtdJW9v+c+d6WIdTeAxMmbKlzEPTFzMyLRyYN7YlC40d2mWR6jSLGFXWUtwe+/93MEtUrG4VaEoS0B1/FV0WgSG83hv72
 YwrQlLDB
 lX59+kf6mOSLc5uTMAIfeMtf/AdLF3mQjtnriYbsbwnCEl6sKplVgr4KbKBCC57DsexB/8f2j3vymKOcLun8sIUjg4Q==
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
2.51.0.rc0.205.g4a044479a3-goog


