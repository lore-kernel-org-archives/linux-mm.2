Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D201DD206A9
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B5E56B009D; Thu,  4 Dec 2025 09:13:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18D686B009F; Thu,  4 Dec 2025 09:13:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 053F36B00A0; Thu,  4 Dec 2025 09:13:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E58DF6B009D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:13:20 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 425A8568B6
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:13:18 +0000 (UTC)
X-FDA: 84181980876.16.A1F430E
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3149E18000E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:13:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dEPDIh8L;
	spf=pass (imf06.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764857596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYb/yPra/VQ92UPtHr69bchv45pj9r5YmHZ7p3XU5gk=;
	b=pEBC18PTg1or64CuFViEETnuyEPsnRw4Q348xs0J3kWCLyMbXEYlf2hK/5p4mtSeC8+A7x
	YzJggygtdWd1goEs5+st0soeqOTimTnYb1ED9fX5nAEa4WuOSe1/WHLygW42Sql6LWNdJU
	plFaoLniQZGYWmCbWmTdJjukKZTnakU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dEPDIh8L;
	spf=pass (imf06.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764857596; a=rsa-sha256;
	cv=none;
	b=Lvw0xSq3TS6jAMM4GpA584bA8Y5MWXxpUtLAOALdgt2fPYoN540AkG+2YzB1vrr4wYTthA
	uhFyNtlFnmmrMc6e35scxrFZGU7Xaiy0Dy+gZZYOZGmXfhVXgPNEs8ypBcNKd5Ai0szRrr
	NOx3qerNv+5H9ECjsLG5TD0gaANKIWs=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42e2b78d45bso491652f8f.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 06:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857595; x=1765462395; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JYb/yPra/VQ92UPtHr69bchv45pj9r5YmHZ7p3XU5gk=;
        b=dEPDIh8L6dR18S0goL/MUtzAKHvQudZSLn2CaHVTkg28BSOgrQ9FcozhRxvWrt7Aog
         fPODnKn41fvrfzuOSwTXBsZ61ZBjtix2C9fkFBNFT03TeAI5tpmXZB8s7v9x+o2ZQqrZ
         h5lohw4n3HJHCRM8IAyTN7DaG/6jy/JwLGF/vCwvs+znJ7ZMSjQn6P8AtztqMKb6ZJsY
         iRg0qb9HJudRxaVbC3IGuFK/uJonUAeJb2OkRrRXvUAn+iRcm4DZibCdiFS9VqPE/co9
         r6TJzaEX0Fj2ZSE6rVAOjD3JNpKN9wyzWHeQcGqSnafvuCKZpaPYbKK7CVXQ4dpVWdCg
         wFGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857595; x=1765462395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JYb/yPra/VQ92UPtHr69bchv45pj9r5YmHZ7p3XU5gk=;
        b=F7GZt1r7u3vU7c3HUaVusQUNhw5S5z4N+btkK3B2fP/ULrS6mzGrQ8KDMx2rGmsr7J
         xMFJcuzi8c/Fbl55KiBEAVtS2TVRIgzYXsjJnxZt7VGta9tx0LyOPqrUe8FHic2aLSgN
         uJW/yFY+mu3+ADuADdzm3/2CAlCo2ToOwNwRO6z5xj3YZlG6KYnT/eOPr43Ru3SaTg4w
         tc+X9DbuG4P+lIyNE2oFsao6ytzfc4IGoXiq2HIwSFFPBQTE5hqvOhu0rfBabjHR11KU
         xAArQ5ytlY1WT1jmcG9cmCoiYPMr6R0GxG0Ymqy0zWsMqD3Yh7bNrjEChRbo4Hrgm2Hv
         rWBQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5iu15vedwN/k3NZSvVqFsJII1azNOEMKUJ3Z+vW+uU0gG+8KIfzmSA2g8pA3G+a2gjNyJsKEaIQ==@kvack.org
X-Gm-Message-State: AOJu0YxOqQJGyQpz4e4qNlCc2awkDXBaPMH2UM+o6TCsGY3/kWXuhJa3
	QY3NL32HxTwhwMKXwuGOaUmC1yRen2PacXKCHUKe5ZYxfeRqoR0mjjZb
X-Gm-Gg: ASbGncslpanSguZF0mE1awARddxZ0jpjTTEqF7i6X3ZuK4wxVkGSvvKcjj6qJ+jQw33
	a5MGzbJWA6bXAdg/xs0q5hW20pcQqoWwGyaskqnOK95DkGgxjFrvtW29zVxu4K9dsXsfM7N2mt0
	Z6OPomQqlFiBoWQ6rPNLB+g3pnK5VQ3Vzx/VMa1HBnuIopQVuIQ7vQi3QuKlmG4RS5hHuNIsnSr
	W+tgAxDC1q0II0d2nnFENmNpqg9TzJZRxnMySNXFJPmjPT9Ci3L+AnLZ018H8PJzJi/c8Ny3DRI
	/cqVY8Xwq0GHcQZurPmq5zZ7LXkui7ts+OnZO4gIwFzbuXSt5bOUJ+/OxhqjMAh5zzWrig3JSnB
	ofzzv1CP80t3l5K72pbDq/6cJx0va6VrskA1QzoyD04EpsxALRo2yVOZehhgP80ysKlpkkwHjyf
	C5p/6OfCVf0Tm+yNpzLZZxCLYdrTyFrse/eUGGNTo2BgV96QeTC6vXozA4cUTcaJvHHySi/0ktN
	3nq
X-Google-Smtp-Source: AGHT+IFaN2iuHh8JgUwoVZzKMyn/tcQMjt8qJkVwY5tRzh0K3jG6s9pjH/nYgcBl1jHrMCivejQ75w==
X-Received: by 2002:a05:6000:290e:b0:42b:411b:e487 with SMTP id ffacd0b85a97d-42f73174091mr6010345f8f.2.1764857594380;
        Thu, 04 Dec 2025 06:13:14 -0800 (PST)
Received: from ethan-tp.d.ethz.ch (2001-67c-10ec-5744-8000--626.net6.ethz.ch. [2001:67c:10ec:5744:8000::626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3605808f8f.13.2025.12.04.06.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:13:13 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
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
	tarasmadan@google.com,
	Ethan Graham <ethangraham@google.com>
Subject: [PATCH 07/10] kfuzztest: add KFuzzTest sample fuzz targets
Date: Thu,  4 Dec 2025 15:12:46 +0100
Message-ID: <20251204141250.21114-8-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3149E18000E
X-Stat-Signature: 6ify9pcruayw67eh34zbxnjgrrdw3z9c
X-Rspam-User: 
X-HE-Tag: 1764857595-936752
X-HE-Meta: U2FsdGVkX1/bMDT+5LDVECwDQsp77/9Wt08KffW65IeWb5s1qZPwz/YCSpK6arssqKQ6sUcWs2kPJ9VI7QfA78a/Q/WK8FN83fIP9bcHVGBAJLHQB94x6ObSfna1D4pfAgc5DLqqei2zpSRaaZq4caxPkQcdEYYyI1YvjyN5pOswL0jsTI9lWlL8/9ZSQYPpyobz7BU/hfQOkeG9paxXG5ZDkVFP205YN/NK0sO6FvFU9hRIuU1RRnlo3EeSjfrTVqJIQ3fpinzvOyb78n59aXu27grkWUnQn2zDwlkw7okWK5HxaVaBWJv939fTW0tWFA9c4wW/P+i3ShKRi6BLmA3kxeTIay9oKQNxPFlns0h8SQd+IHxtG8TAqq9snaZALEA9A2ghkqICB8jvhODNbghlTDlVAeph/paQmvVsHC0Hk7SYdszxrvUP6YkR6vknOZSzSVEhMMErDMuteVYAI5MsE0rDUi/vfhoof4J4RbzC9fzDLezRi4hpfdf9puGONtpqR8NuoXsJiFN9hdReVZAU5q0c1jYwrczveAV/qUbM/4unfjGR3plcuGQRs0UzWxqUU4zKtYyhOyeGGJ6z70AQ2AY9oRzIRTIZtbCJehgMY1nI76gS6d/ytdVssRN6aMI822Z4HevrC7/wIW4GK0bevvZxQihtF6zzvR2vPwTQtSTPJZInxvnbjX9Yo6ylqnBQBtiwsq8isP9hzyykZ0WgQhyqVSl4M/hDS+hpC6+0McDDcbGfubCa6IxDPmoBYyX715tP/jA1I10LPuylugyNemY8B06AwD4HpDvPzpVP1G0KpXOp+3K+x7dcioFUzxskjJmR9WKT7Qz9zM77tlRoObPZhAU+iOIYe1FnWL0kM02plcUrBjbLugIsmy97KMHRjEOnuhvW5GBQ2LUXGIIEZpBUFUfzJABRi3X/m6GGTMgJcfnYpMyZwYhbEL3crQmS4r/I9rInAGH6um7
 NRfLIivP
 HkjaLYkpJpiLDO8D/XBqKwD0k0y1JgSMwosxSiRZJdjocV859dq0iQcSXidBn1oJPju08X15ZKtxT9JXmEKvat3+ounnQYyvtEzywHdHthzI3+dd8vZ1kZUMKI2W3FgDN2MYGl3t2xtPVw9SDcUxK+yOM+5W03abKl/fldlW8VIllUuqMmoJrzhvbTRXB4LAL7sM8KvPjyPI2c+6a1H3mI59GF5/ov1oOP5XyRubBRvDz9IRs5m7iJomMLUbkv3Qvb4FChidf5qLB+xaXcUt3s2tWm3mWXr7hySBtrxhIspQS2yk1rMYY79+m4OHn/vgaEHIGCfrWjuwyFxEAGdIr+vBE1CwEM4GBPun1fIOgbhBJIyQSh6ZlQ2QbBlq8vwsyt9/ZFoFhhv3LlfBN0iArCG2BKUalsV1AZUvNazwsFRb1s2ZVSbXKMNCE7t25qcnOD/VzhdJigu0keqsm+3irgwrOZZGd+TQBLGnV3Xbk3jpPHN9oJGbhhmAaNQYUWRDcWGu2k7ctCnb6YHPFDUjUrvt09MV4gjb7uKNeGqDH2EiIeTnKHpR/D8NKOzlt/AuSpNri
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
Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
Acked-by: Alexander Potapenko <glider@google.com>

---
PR v3:
- Use the FUZZ_TEST_SIMPLE macro in the `underflow_on_buffer` sample
  fuzz target instead of FUZZ_TEST.
PR v2:
- Fix build issues pointed out by the kernel test robot <lkp@intel.com>.
---
---
 samples/Kconfig                               |  7 ++
 samples/Makefile                              |  1 +
 samples/kfuzztest/Makefile                    |  3 +
 samples/kfuzztest/overflow_on_nested_buffer.c | 71 +++++++++++++++++++
 samples/kfuzztest/underflow_on_buffer.c       | 51 +++++++++++++
 5 files changed, 133 insertions(+)
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
index 000000000000..b2f5ff467334
--- /dev/null
+++ b/samples/kfuzztest/underflow_on_buffer.c
@@ -0,0 +1,51 @@
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
+/**
+ * Tests that the region between struct some_buffer and the expanded *buf field
+ * is correctly poisoned by accessing the first byte before *buf.
+ */
+FUZZ_TEST_SIMPLE(test_underflow_on_buffer)
+{
+	underflow_on_buffer(data, datalen);
+}
-- 
2.51.0


