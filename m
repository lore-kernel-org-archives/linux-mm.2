Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3B18CF45C5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AE9F6B0093; Mon, 12 Jan 2026 14:28:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61ADD6B0095; Mon, 12 Jan 2026 14:28:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5AC6B0096; Mon, 12 Jan 2026 14:28:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4F96B0093
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:28:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 008101AEC30
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:28:49 +0000 (UTC)
X-FDA: 84324299178.22.EE4BF7E
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1279E40003
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:28:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cZUKDrBY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768246128; a=rsa-sha256;
	cv=none;
	b=FY4ks6iwBa70nK7x/VrVE//fOvD4MD2aBiY0+ZEtEw+wGogR/Zlb/NkDsn5OQTMlM2TwXK
	MOYG8SFWJrnppHUIt2QjNignLobOUdHZ4kKn4xQFyd6ZFYuTQutLBvH8X1l+zhs+uRtkXw
	Z/RZebBpCvY8NHeVl9XEeGU1HaaZ3Vo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cZUKDrBY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768246128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYn/cfzIUiLg8O0jmeN0oIUjcH6e7FhIiA9EkVEqfyc=;
	b=HKCqXIWgpBoiG/TQftoA7EYxKrue2tx/hLWGRaI+01Hkyv72mgkOot+c/Bxbszn9JA425Z
	5LkAXCt+InHBSeZZC0sGzUX7tifv1WdmBK6uM1mqwr0NzZdFhiNJgodQP+8Xlswo8awwaz
	cyCsOjD+HjeWZnB6bOtcs37NePjcBjs=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b86f69bbe60so244009066b.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768246127; x=1768850927; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lYn/cfzIUiLg8O0jmeN0oIUjcH6e7FhIiA9EkVEqfyc=;
        b=cZUKDrBYZ4351ZPGHumUlrdDupmNHo18Uo1+/szF+d7AY55AkF6Jlr25GOJdJvIfR8
         43/08A8uvFtVBHRkuSCAJzIqLDWSiEEjtGgJIJil1CyU0u9PrRWw5CgO1C8fctHn+/DT
         5VQ+D7eahgcT4Nf+QWrGAR6Z9h+/V/qrisA0gerFX9lfVmU0zZwf3Suxzc0AayBvFm6Z
         sss8FMVrCkb2OuQ9pdyyoKLynLdN+nidCydFhw6ePmNKdhRh7A7k+OReuEwyTH6VnV1z
         EwvJfamIQPzvlPdZzej+F/mAYkOUFtYcV8Eg0EanHsrinFb/6mqavyr9PNii8H6I0cJ+
         9bsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768246127; x=1768850927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lYn/cfzIUiLg8O0jmeN0oIUjcH6e7FhIiA9EkVEqfyc=;
        b=bJPuvCfY1s7/xN6Ff60QY/4ghALG5rlCHSIb15QwBVJmLRmsEvpKAYxqJ7ZynV0fyI
         HIQL1m9IoTaT6+d4JK09yVxkoe81cz1apBCeCw0rZcyQyOe+zll60atMq21OwJ/uDhHT
         0ykQ0rNMgQdgpYXSCsA6XBsv7RCqsrmCrbFgvdcI8qS+iOH3clf9ULbUiqeNaN8JCf6L
         Btw9biZOGr43qRWvoAlUhjrFndUSzuj4xaHvXnEPLFjG/vcV0GjHy7OhZxBug9YEmVna
         2GNsSpk8DqE7Lmv0f48oXmzmMd5s3nqolLKnX15qVRb+/ZYWNp1D+Z9tYjEYbEK4n/z4
         wQ/g==
X-Forwarded-Encrypted: i=1; AJvYcCW8tKK9Bm+SUal0OQ9PnJTKDBf1bmYJZN+9ei5jfOh55E5bEQrzYAo9vcqge8TJl31sGN6N4AEP8Q==@kvack.org
X-Gm-Message-State: AOJu0Yy2pWc3AYicg4xaiN8w18ug4hfAD1Ax+HaxoPfiU2ijbjM3lgza
	VxdFUYdEKjzn679aqKRjKx0i3emOIINBunLdsF1JsZjliHLU4xooEYxG
X-Gm-Gg: AY/fxX45voSGuzSVGvh4MWWtUb5fXCODjooppVt4Mv0mtbM1OxA4hOBrGCVfAjajbA/
	Zhti/AUMs/DRAA7RIQaA+BkYZNLGhh7sfSnW/2rZD7pq5WbIFqKr8xSSH111JtLqjB7bPK+IT8Y
	huYrwhT9hF0QOmE9fsPjS473UgPFqU36GbyTOedKWWiTZF9L53bKJuB+L4PgJYh4TrLo4n1woJk
	7bGZ3kSfq2FDHcFLQXfh8YROh3jIbatEVk8aQSJUPr0Cwr+a00+Xjj5AOqJHTuRZNYw++ZZkX9d
	r4F8PMTq/YpAsW5U3XeoWgUFt9+OIkC8+QVHE3izVTikQIvQ0WhTz0Z4RlaUZ3apZQ8YiCvuOtB
	g03bxr5mBdM3BCzZJdRjcZupno1flscSfHbRJZBbwB5wUQyEeq5n3tGySOdTQr3SZUbI9Iv7PvG
	ltwQT6Y+XvFKMsNoHbBnYANI4mRs7RfyBhGOXt5jEtkYw7IPLiTA==
X-Google-Smtp-Source: AGHT+IF4pPwfnNX2FK6K6VgQD0pVFZdgZJNgLaaNTxNX+cYNIN/F+0YErplY46SPSS0fwiEVEMONCQ==
X-Received: by 2002:a17:906:9f87:b0:b73:2b08:ac70 with SMTP id a640c23a62f3a-b844539fc4fmr1937923066b.49.1768246126219;
        Mon, 12 Jan 2026 11:28:46 -0800 (PST)
Received: from ethan-tp (xdsl-31-164-106-179.adslplus.ch. [31.164.106.179])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf667fcsm18108959a12.29.2026.01.12.11.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:28:45 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: akpm@linux-foundation.org,
	andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	ebiggers@kernel.org,
	elver@google.com,
	gregkh@linuxfoundation.org,
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
	mcgrof@kernel.org,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	skhan@linuxfoundation.org,
	tarasmadan@google.com,
	wentaoz5@illinois.edu
Subject: [PATCH v4 4/6] kfuzztest: add KFuzzTest sample fuzz targets
Date: Mon, 12 Jan 2026 20:28:25 +0100
Message-ID: <20260112192827.25989-5-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1279E40003
X-Rspamd-Server: rspam06
X-Stat-Signature: rhyz6w8qg5wtnu55k65qnb7kdqnqy1mz
X-Rspam-User: 
X-HE-Tag: 1768246127-623861
X-HE-Meta: U2FsdGVkX1+7O5giDqPT5PHgvLrcabAGDGhRcoK0eFTjhFKKBt+nuPrcHxvCCRq/BldLIUpLDvYrdiu9hxvyBR+Wltmp4MlSgW+JKOlQf46MicucHJDl0/uw3ANNNbpii0B3T1ztYia+HgCuZbcbCUi8p1XWQArQyxIba7xEMLqf2/C0abwM9dd4jrPrWWXRUyIv2RFWI1RUDnpzNYoEeDubW/B41bR586udA+ckx9BubLpqlfNQTYI+gmgT5w5+pmV+093xML9Y3idEoakP53gAQQnd0Vhb4cZPAN2cFuPrXjJFIMibBOxz+345++bkTRJBvU/TGFXwpnzt5HVpaur9egZ0LfXB7fgeH6HiDujei5gKB3MFyIZEyg0f4gVbhdl7wDo27mPZ254DP70Vf9YNNOvrfJn5DvMI+ck7wVch5aivvUQsqDbNCoRYL96CsNW19BQbsO3l1xvXJDEhGQ4fHWG/olZBm/723DndG2yAkffyrwY5zkydYO49u1nDCPzxE22wWBjMiB5+aX2YjCVA5VqkkH7fhRq6l8I0VPkb2Jyv/rCXR5TwgbVFWKpLOXh4ksJhcd+w0hxQp2ODczbTNaBW+bZ4Ap/NK/cCLjAaQji7B6ZwF0VHS0+i1tXZhIB0XvXVdOpacjdx/l7hcykoUk6/0ei1OieZJwueMt9vfrQTThIp8OaVMc0XwVuYiEOrdbhE12W7YAIc60K6ZAIHKX9XUiu1XGEEsLiMG44cw2GbBLw4FpaoHye1FV50FIbjRS0tfY+Fg8P7f2cxjF3qzhNVX0T1cWuqSmZIQ8b7uGNRSC6mHBoIWoZZS/t5svlmVS2A5hqpCMV2XMM/1vrMkrtXKxa2XlzamnTjJwddf41zl22jK09U9AhAGcQ6P/6VBWRaMdXOHZLKateAkra7CD/LSOphEIwQUEsKbgBfqq4WwMxaY+5a4KxbT/Jf+Tw9tNE7LGzyQ9XMAyw
 WAtZCjzw
 e+cetE0+IcaZ5t6aCeIj2eFD8ROzsiXkzgOm3p1k1yNDR52eofC2vzMOT5UZmgD0vrj+mtq/zbidYLfphO9xZdCGsQvADl8kRu/nM/coC4kwVdYHR/iHZRK4bGyu5QFAOrwsr4BGEtdIL7ODM77Ce6QeGrKCi9oQsQ8aukudNDVOHkDqYHHNQz/SmlrZ/STgwevXN0ltvAxv0AwOg6VR8229CIYrdRaW5KNkez64N+c9xynqWjReiL/cf7IrhaGueggO94nxQJrAT/bWUfZgl8I/4WwVzGlngm3i7Rk4mG1dp/1DeiTZEqZ3nvpKW5eG7AUxD+w8oE9prz6sXMALA3kUJfGUSwZFKKUhadQkn8LdiNFNYTfJl5Y0MAgbPZsw+hTRbrBHyDNBXyPHvG3D2z4AnfkU9F2CppDFsLWfx3X++WUeSAfqh88TzYNDbv/MElXFI1huLVMSDMPECfjhxSps5swmIc4CCeHKJ0IWuB3UEZZz+39x3/klrn2ZLhVtX5fNSjPRgoFz0NBbubqZ4GXfIWk3Tq8PXl+V+W9Vwr3BF0ml++959fFbLAxB7CIi0d1LQ4uv6QJzBxQzahFzB7GCRrafJ7/AvIgNDc7Z8yOppFn0/SADlWkwqQr28X9vyrslUQfb42qdZCzn1nQA/QTK4UQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add two simple fuzz target samples to demonstrate the KFuzzTest API and
provide basic self-tests for the framework.

These examples showcase how a developer can define a fuzz target using
the FUZZ_TEST_SIMPLE() macro. It also serves as a runtime sanity check,
ensuring that the framework correctly passes the input buffer and that
KASAN correctly detects out-of-bounds memory accesses (in this case, a
buffer underflow) on the allocated test data.

This target can be fuzzed naively by writing random data into the
debugfs 'input_simple' file and verifying that the KASAN report is
triggered.

Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
Acked-by: Alexander Potapenko <glider@google.com>

---
PR v4:
- Remove the `test_underflow_on_nested_buffer` sample target which
  relied on the now removed `FUZZ_TEST` macro.
- Update the sample comment to demonstrate naive fuzzing (using `head`)
  instead of the removed bridge tool.
- Fix stale comments referencing internal layout structures.
PR v3:
- Use the FUZZ_TEST_SIMPLE macro in the `underflow_on_buffer` sample
  fuzz target instead of FUZZ_TEST.
PR v2:
- Fix build issues pointed out by the kernel test robot <lkp@intel.com>.
---
---
 samples/Kconfig                         |  7 ++++
 samples/Makefile                        |  1 +
 samples/kfuzztest/Makefile              |  3 ++
 samples/kfuzztest/underflow_on_buffer.c | 52 +++++++++++++++++++++++++
 4 files changed, 63 insertions(+)
 create mode 100644 samples/kfuzztest/Makefile
 create mode 100644 samples/kfuzztest/underflow_on_buffer.c

diff --git a/samples/Kconfig b/samples/Kconfig
index 6e072a5f1ed8..303a9831d404 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -320,6 +320,13 @@ config SAMPLE_HUNG_TASK
 	  Reading these files with multiple processes triggers hung task
 	  detection by holding locks for a long time (256 seconds).
 
+config SAMPLE_KFUZZTEST
+	bool "Build KFuzzTest sample targets"
+	depends on KFUZZTEST
+	help
+	  Build KFuzzTest sample targets that serve as selftests for raw input
+	  delivery and KASAN out-of-bounds detection.
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
index 000000000000..2dc5d424824d
--- /dev/null
+++ b/samples/kfuzztest/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-$(CONFIG_SAMPLE_KFUZZTEST) += underflow_on_buffer.o
diff --git a/samples/kfuzztest/underflow_on_buffer.c b/samples/kfuzztest/underflow_on_buffer.c
new file mode 100644
index 000000000000..5568c5e6be7a
--- /dev/null
+++ b/samples/kfuzztest/underflow_on_buffer.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This file contains a KFuzzTest example target that ensures that a buffer
+ * underflow on a region triggers a KASAN OOB access report.
+ *
+ * Copyright 2025 Google LLC
+ */
+
+/**
+ * test_underflow_on_buffer - a sample fuzz target
+ *
+ * This sample fuzz target serves to illustrate the usage of the
+ * FUZZ_TEST_SIMPLE macro, as well as provide a sort of self-test that KFuzzTest
+ * functions correctly for trivial fuzz targets. In KASAN builds, fuzzing this
+ * harness should trigger a report for every input (provided that its length is
+ * greater than 0 and less than KFUZZTEST_MAX_INPUT_SIZE).
+ *
+ * This harness can be invoked (naively) like so:
+ * head -c 128 /dev/urandom > \
+ *	/sys/kernel/debug/kfuzztest/test_underflow_on_buffer/input_simple
+ */
+#include <linux/kfuzztest.h>
+
+static void underflow_on_buffer(char *buf, size_t buflen)
+{
+	size_t i;
+
+	/*
+	 * Print the address range of `buf` to allow correlation with the
+	 * subsequent KASAN report.
+	 */
+	pr_info("buf = [%px, %px)", buf, buf + buflen);
+
+	/* First ensure that all bytes in `buf` are accessible. */
+	for (i = 0; i < buflen; i++)
+		READ_ONCE(buf[i]);
+	/*
+	 * Provoke a buffer underflow on the first byte preceding `buf`,
+	 * triggering a KASAN report.
+	 */
+	READ_ONCE(*((char *)buf - 1));
+}
+
+/**
+ * Define the fuzz target. This wrapper ensures that the `underflow_on_buffer`
+ * function is invoked with the data provided from userspace.
+ */
+FUZZ_TEST_SIMPLE(test_underflow_on_buffer)
+{
+	underflow_on_buffer(data, datalen);
+	return 0;
+}
-- 
2.51.0


