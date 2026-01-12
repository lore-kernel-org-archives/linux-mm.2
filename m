Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FFDBCF45C8
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:28:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863626B0089; Mon, 12 Jan 2026 14:28:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84B6E6B008C; Mon, 12 Jan 2026 14:28:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68CF76B0092; Mon, 12 Jan 2026 14:28:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8AC6B0089
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:28:45 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF5E21AEC27
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:28:44 +0000 (UTC)
X-FDA: 84324298968.12.1F83C17
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id 20E6E40004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:28:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UBDkfkM+;
	spf=pass (imf17.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768246123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6pmlmleIFnHYbLcLeHzqqQV2depV+HvaEyub6pwhNU=;
	b=nTn/IxgP5UIdLsEA2aCCYx+/iEfHNxCprURK1u82Kw8pQFzfzLqIHpwRP8gKJdrH+s/Oqf
	W4uL8cZ/Pxt3EAiSHcR0ACPoWZEOYww1krtYX2A8zEx2Bg8O0dwf8kMEyrmmcQmF3/XTnC
	dXpiAJW/G5oSnXjvUv91hZTOqg+lzKk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UBDkfkM+;
	spf=pass (imf17.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768246123; a=rsa-sha256;
	cv=none;
	b=Kw9eyguVXMLRBf//eW8skjO1B0unPs7/qx29+9SSK41i9L0azwY0+OyqjrToreoGKnurtK
	MkcSVdx7JXCTVT1ujTXh7Bv00maxQBRKmU+X8NSklnsj8SCrtheylOcnXnKPGv4pI1mi8p
	yUm+pFKDKJbb28DRgJPmMWNz03Cf0gg=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64d0d41404cso11108426a12.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768246122; x=1768850922; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6pmlmleIFnHYbLcLeHzqqQV2depV+HvaEyub6pwhNU=;
        b=UBDkfkM+xZHNLLDeYl568ZMUAThizDkHfo3WapcBvoc7iilEd2xPxyydJvrJpVvTM7
         a32oxvgAUqhsa6kpXzDck4lvJzjjyQpQ2Jw4lTtWQPyNPatsORypu+1jS/h7mgUCLv/B
         0lTMacYULFxPL7P+sV4ezfD1N2b9lbtPNnaSXCJUn3+eu8pRwmcCyNHsz8QRHMFiRbv7
         afYAyWgnVJTuNpqItAfZz8YBKplQkjSySk8q34rHP+8C7yctz9yudXcFpK15PdC2vQYq
         KbnGVNG/++f9AjYobNqvPbLJBpxNby2xDnJLjHYYqHbLGWiVyZD6oWtkObk9yRhQzHIm
         9evA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768246122; x=1768850922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F6pmlmleIFnHYbLcLeHzqqQV2depV+HvaEyub6pwhNU=;
        b=jt1ovm2GnzvwLLvlxVNXrhXqiwQCUsNhdlPSPkSeLW6UNwphYAJNYZgqHK6HmGdxi6
         IrcO4lSLN1JupONeV2W/CsmuSMhEQWH9YuaOm/ocEGoN1dBoorkXeYXrOEGQo8Dkf6D0
         I15ngxpnvVu6pkKjXluWA2sXh7LNzT1xZeGtf3BDviLe/BZhtHkKDP/SBAFhN9dd9+l7
         Z/Sc4DVSE76PToOQOlvKlpM9h6Atfmec5zKFnKEy4qkaHSGuu6ymPxS7aBuvta+vRdRF
         LM9WdB6O48yNAUt76jz1CEWZjQqplI6VR0+XgqZKzPWAsmqhY33wIQckfu62WF9RdK2b
         0pCg==
X-Forwarded-Encrypted: i=1; AJvYcCVNGzw65t6eazQAqpLidNhOkfpLLcWiyEvlSUyLD/ALqJp6FQzIw9MYgjVEtbMsHWGqjNA0m4KrrA==@kvack.org
X-Gm-Message-State: AOJu0YzTg7TvTevyQKTmqtgXdfnd/ksq/eQOQzzoWy2n5Y7QZtFGE+b3
	iP4HFRxWDKNX+Gt5i4P38aUYjxx4hNVuwGUEM1v6x26X5HwybzLJ1lpN
X-Gm-Gg: AY/fxX7VD5Q5Td9FqOPp0RCSYL2yu3M64hM4Ja8dREY/zWkD7GpiBYpDczZA6TBvqP8
	/MeCeY7hc0UD0978LG517bVuTOF5fnqHx4I8XHEpO8ahFQXuzhp3vsvOpuYKutZAqym+nuuA6Tt
	WPtPPOQ8YcjpRsCsBaHdoliCDCNyB5KDmE1WVSn8QftxlHwBQDnwksnGJKFiAIv+wvM539CrDoH
	r14ni2SOqWeQ06MHvy+34oc2QP0BcMQ7IwKgBYPRnUhmN0iDL7fT1CJTqAtpKOzNMQjHImk7KF/
	g14GIFMw5kGzkSdOr1gfhity1NK8imLTh710SRKd4NLkhT3ldBUl651HcBq0SDBzK0fOX84Qd5O
	NxiBsOM/J4zqFwltdcT8wFEpKlTlpT7UbGINRtx95OavugRebVLgMhSHV+tQlWzgZ3rabkQhd9J
	XYqP5mdgY31hSeoVCN6LK1aM3iX1rBdpvrIqJFoJWS3k/Njrx72A==
X-Google-Smtp-Source: AGHT+IGy522OXBlgiFW3lPd749jJAYgvouP4QS9c8yndvmWTKnryLyWxg/YRj13+vMvBUdmHcTA0tA==
X-Received: by 2002:a05:6402:42d3:b0:64b:6dfc:dd34 with SMTP id 4fb4d7f45d1cf-65097cde534mr16779217a12.0.1768246121349;
        Mon, 12 Jan 2026 11:28:41 -0800 (PST)
Received: from ethan-tp (xdsl-31-164-106-179.adslplus.ch. [31.164.106.179])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf667fcsm18108959a12.29.2026.01.12.11.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:28:40 -0800 (PST)
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
Subject: [PATCH v4 1/6] kfuzztest: add user-facing API and data structures
Date: Mon, 12 Jan 2026 20:28:22 +0100
Message-ID: <20260112192827.25989-2-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 20E6E40004
X-Stat-Signature: mfh8cu7ykgbu5oci7cgjyn1bd114gzem
X-HE-Tag: 1768246122-74938
X-HE-Meta: U2FsdGVkX1/uyyX84F6YXRd+IKGIPjnB4tWhUIpRjZ/ArUt9e4qI1Vf+B0KnBSc2MubTWndnAlJdFkmac7vaXm0NH/31yTKTuBperxvyY725IIcf6cyRijN9DckKoCrKsXpJQ/B0+apfVQ4aFyRBY5LSHySIF8QS8lipbkgPz7OBma1l3LJsyfY6xZrTiDbghV13pL8cpxAfEI3wloCtRW6rRgw9qQK/vZ7ZQt7Zyo0XbMJwSNEjJrBehq3SjdkXyKWsketHo4PYFhOThAOZ8lchGTWNTxfK81IAqRv0narcz890KH7e38YD9skJHoVU1XHWUJmaR1uR5K0PrIvF1WwBtuTOspBU+y6A/sQqlzqAsN9GJ7lX0lNTLkhFHpabxe1lHwsFvTxAHStGEHnrwngWaslP7i7RDvjWdmZldkBjHwxrNcVaZhwOpX/t/jvqiZTwfuf3/TkFROPGJf9PX0fVeeLFLmFRImeff7AglptYiPrG3FGq1zHw8ZJhuDdb6cOa4b8BmUQaymrjv00O3mTPTd/Z83vzcP0Sbjefp6hfG23/LFJSnA/q2WxU7ElQlIvwgxnWneNW/GYDLOl/l4LoGxKBQGVbbgXLwJvTVGYPoIo77BLIzi24KEzPNrfIu4ujzkgdIm/lPvfu5npdHoG20cVjhu5/qGmOrN9vWWPt0xxwzOoJsf6e4hSnirtiAKa3boz5mhUQ7Hj1+4lf9Z4Vz/3QlHsABeyDQANyBi8fKrj3jx+HXU3ZnouHwt9zoitF9dcBOf1offpMhVdVR7fkOYFgnXR3yjrp6IoWNpy7LdHaIkboEgGkkyDV+llmxtn9OTZ+nWJj2qjWr8vFqk6qpqRH00pCZl/qIFk1sPf8jNLrmkLCTfNg368bAZ7LXG28iajmYeA6b+I70zZ+ZfbYp9WTQOaeEky0XL4/tRBA7sFRZOLBo+sMFQ3xNRz8rY3sJCtx4v5Mw9U096l
 P9Hi8nZG
 8lKumKGk9TKLiAbcb/t7cZwXZ5a9P+58pZ4A3QfxJZA4D9EWoxVy/s59n+ljvbpJfGuc1RJ0nfY+E7VJ5rykRB7mIiCOcJXM6i6S3O3r8E/LOxCj/vxJmdtsc0QXODwT6aRzbgoOGoTqCegA7DLxffwqP2RuOTBaF78il6Ty+f1agq0lYXsZW6zB+/uNRsRYZghM6lFLi/2K/oQ/rq6BrTYnrThNIaTQKHBXONwbXgPODeStEaNg2cj8dVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the foundational user-facing components for the KFuzzTest framework.
This includes the main API header <linux/kfuzztest.h>, the Kconfig
option to enable the feature, and the required linker script changes
which introduce a new ELF section in vmlinux.

Note that KFuzzTest is intended strictly for debug builds only, and
should never be enabled in a production build. The fact that it exposes
internal kernel functions and state directly to userspace may constitute
a serious security vulnerability if used for any reason other than
testing.

The header defines:
- The FUZZ_TEST_SIMPLE() macro for creating test targets.
- The `struct kfuzztest_simple_target` structure used to register tests.
- The linker section (.kfuzztest_simple_target) where test metadata is
  stored for discovery by the framework.

This patch only adds the public interface and build integration; no
runtime logic is included.

Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>

---
PR v4:
- Remove the complex FUZZ_TEST macro and associated dependencies,
  including domain constraints, annotations, and de-serialization,
  dramatically simplifying the flow.
- Drop unused ELF sections (.kfuzztest_constraint, etc...) from the
  linker script, keeping only .kfuzztest_simple_target.
PR v3:
- Reorder definitions in kfuzztest.h for better flow and readability.
- Introduce __KFUZZTEST_CONSTRAINT macro in preparation for the
  introduction of the FUZZ_TEST_SIMPLE macro in the following patch,
  which uses it for manually emitting constraint metadata.
PR v1:
- Move KFuzzTest metadata definitions to generic vmlinux linkage so that
  the framework isn't bound to x86_64.
- Return -EFAULT when simple_write_to_buffer returns a value not equal
  to the input length in the main FUZZ_TEST macro.
- Enforce a maximum input size of 64KiB in the main FUZZ_TEST macro,
  returning -EINVAL when it isn't respected.
- Refactor KFUZZTEST_ANNOTATION_* macros.
- Taint the kernel with TAINT_TEST inside the FUZZ_TEST macro when a
  fuzz target is invoked for the first time.
---
---
 include/asm-generic/vmlinux.lds.h | 14 ++++-
 include/linux/kfuzztest.h         | 88 +++++++++++++++++++++++++++++++
 lib/Kconfig.debug                 |  1 +
 lib/kfuzztest/Kconfig             | 16 ++++++
 4 files changed, 118 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/kfuzztest.h
 create mode 100644 lib/kfuzztest/Kconfig

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index ae2d2359b79e..5aa46dbbc9b2 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -373,7 +373,8 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 	TRACE_PRINTKS()							\
 	BPF_RAW_TP()							\
 	TRACEPOINT_STR()						\
-	KUNIT_TABLE()
+	KUNIT_TABLE()							\
+	KFUZZTEST_TABLE()
 
 /*
  * Data section helpers
@@ -966,6 +967,17 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 		BOUNDED_SECTION_POST_LABEL(.kunit_init_test_suites, \
 				__kunit_init_suites, _start, _end)
 
+#ifdef CONFIG_KFUZZTEST
+#define KFUZZTEST_TABLE()						\
+	. = ALIGN(PAGE_SIZE);						\
+	__kfuzztest_simple_targets_start = .;				\
+	KEEP(*(.kfuzztest_simple_target));				\
+	__kfuzztest_simple_targets_end = .;				\
+
+#else /* CONFIG_KFUZZTEST */
+#define KFUZZTEST_TABLE()
+#endif /* CONFIG_KFUZZTEST */
+
 #ifdef CONFIG_BLK_DEV_INITRD
 #define INIT_RAM_FS							\
 	. = ALIGN(4);							\
diff --git a/include/linux/kfuzztest.h b/include/linux/kfuzztest.h
new file mode 100644
index 000000000000..62fce9267761
--- /dev/null
+++ b/include/linux/kfuzztest.h
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * The Kernel Fuzz Testing Framework (KFuzzTest) API for defining fuzz targets
+ * for internal kernel functions.
+ *
+ * Copyright 2025 Google LLC
+ */
+#ifndef KFUZZTEST_H
+#define KFUZZTEST_H
+
+#include <linux/fs.h>
+#include <linux/printk.h>
+#include <linux/types.h>
+
+#define KFUZZTEST_MAX_INPUT_SIZE (PAGE_SIZE * 16)
+
+/* Common code for receiving inputs from userspace. */
+int kfuzztest_write_cb_common(struct file *filp, const char __user *buf, size_t len, loff_t *off, void **test_buffer);
+
+struct kfuzztest_simple_target {
+	const char *name;
+	ssize_t (*write_input_cb)(struct file *filp, const char __user *buf, size_t len, loff_t *off);
+};
+
+/**
+ * FUZZ_TEST_SIMPLE - defines a KFuzzTest target
+ *
+ * @test_name: the unique identifier for the fuzz test, which is used to name
+ *             the debugfs entry.
+ *
+ * This macro defines a fuzz target entry point that accepts raw byte buffers
+ * from userspace. It registers a struct kfuzztest_simple_target which the
+ * framework exposes via debugfs.
+ *
+ * When userspace writes to the corresponding debugfs file, the framework
+ * allocates a kernel buffer, copies the user data, and passes it to the
+ * logic defined in the macro body.
+ *
+ * User-provided Logic:
+ * The developer must provide the body of the fuzz test logic within the curly
+ * braces following the macro invocation. Within this scope, the framework
+ * implicitly defines the following variables:
+ *
+ * - `char *data`: A pointer to the raw input data.
+ * - `size_t datalen`: The length of the input data.
+ *
+ * Example Usage:
+ *
+ * // 1. The kernel function that we want to fuzz.
+ * int process_data(const char *data, size_t datalen);
+ *
+ * // 2. Define a fuzz target using the FUZZ_TEST_SIMPLE macro.
+ * FUZZ_TEST_SIMPLE(test_process_data)
+ * {
+ *	// Call the function under test using the `data` and `datalen`
+ *	// variables.
+ *	process_data(data, datalen);
+ * }
+ *
+ */
+#define FUZZ_TEST_SIMPLE(test_name)											\
+	static ssize_t kfuzztest_simple_write_cb_##test_name(struct file *filp, const char __user *buf, size_t len,	\
+							     loff_t *off);						\
+	static ssize_t kfuzztest_simple_logic_##test_name(char *data, size_t datalen);					\
+	static const struct kfuzztest_simple_target __fuzz_test_simple__##test_name __section(				\
+		".kfuzztest_simple_target") __used = {									\
+		.name = #test_name,											\
+		.write_input_cb = kfuzztest_simple_write_cb_##test_name,						\
+	};														\
+	static ssize_t kfuzztest_simple_write_cb_##test_name(struct file *filp, const char __user *buf, size_t len,	\
+							     loff_t *off)						\
+	{														\
+		void *buffer;												\
+		int ret;												\
+															\
+		ret = kfuzztest_write_cb_common(filp, buf, len, off, &buffer);						\
+		if (ret < 0)												\
+			goto out;											\
+		ret = kfuzztest_simple_logic_##test_name(buffer, len);							\
+		if (ret == 0)												\
+			ret = len;											\
+		kfree(buffer);												\
+out:															\
+		return ret;												\
+	}														\
+	static ssize_t kfuzztest_simple_logic_##test_name(char *data, size_t datalen)
+
+#endif /* KFUZZTEST_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dc0e0c6ed075..49a1748b9f24 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1947,6 +1947,7 @@ endmenu
 menu "Kernel Testing and Coverage"
 
 source "lib/kunit/Kconfig"
+source "lib/kfuzztest/Kconfig"
 
 config NOTIFIER_ERROR_INJECTION
 	tristate "Notifier error injection"
diff --git a/lib/kfuzztest/Kconfig b/lib/kfuzztest/Kconfig
new file mode 100644
index 000000000000..d8e9caaac108
--- /dev/null
+++ b/lib/kfuzztest/Kconfig
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config KFUZZTEST
+	bool "KFuzzTest - enable support for internal fuzz targets"
+	depends on DEBUG_FS && DEBUG_KERNEL
+	help
+	  Enables support for the kernel fuzz testing framework (KFuzzTest), an
+	  interface for exposing internal kernel functions to a userspace fuzzing
+	  engine. KFuzzTest targets are exposed via a debugfs interface that
+	  accepts raw binary inputs from userspace, and is designed to make it
+	  easier to fuzz deeply nested kernel code that is hard to reach from
+	  the system call boundary. Using a simple macro-based API, developers
+	  can add a new fuzz target with minimal boilerplate code.
+
+	  WARNING: This exposes internal kernel functions directly to userspace
+	  and must NEVER be enabled in production builds.
-- 
2.51.0


