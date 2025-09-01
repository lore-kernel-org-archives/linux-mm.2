Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672D1CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 16:43:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 696418E0038; Mon,  1 Sep 2025 12:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64D188E0016; Mon,  1 Sep 2025 12:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7748E0038; Mon,  1 Sep 2025 12:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 293698E0016
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:43:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E16E114097A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:43:16 +0000 (UTC)
X-FDA: 83841251592.24.0DA765B
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id DD9CF40008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:43:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B8/roHhq";
	spf=pass (imf07.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756744995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Q+lnz5hfxAJyxjEQHB9/QTS15Vi2TY+Ow6yqCRyLm4=;
	b=4k8Z/cafMw8veeauDs+nBukA8jj+UjF/3DLyQCNy0LDfKdB8Id+c/z7HVM7Zm/TejHgeM3
	OWdUPjYHooTTaNBSgQJhtjtAuwTd8ONMuVJCR3+g/3HZfAbcxAwXu2V84y0YKpZlgxN++s
	BN27UlHJVNr97Lm7WlEt1GWEjUNub6I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B8/roHhq";
	spf=pass (imf07.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756744995; a=rsa-sha256;
	cv=none;
	b=PKONfZu0uJPck/6xHpMukaFI3+lbdqJgJYKQi6J7le7Dj7E8kz1wPKKtK3H29ZqIQbt7wp
	5rvvWCgjAA6cqgVWJr0zua2tjIe4FFqrgcIc4B0ntqDMTMXc2aIKh12HzNp9/Lyy0v0ZEg
	Wc6uukEdZTA92hPLp8xdEMQR7Kpr/uE=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3cbb3ff70a0so2831134f8f.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 09:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756744993; x=1757349793; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Q+lnz5hfxAJyxjEQHB9/QTS15Vi2TY+Ow6yqCRyLm4=;
        b=B8/roHhqySUsO7U3LjXrMUu2vKhwJ4AMzLzPVJdSUx0iZPsAdJBhazhwJdvhs6jmE3
         79YXwpd/9bh+zeyvLz63vR8JewhrMxHYX6RmQJ/u8qhXebp/CUbSq2q/SCqSFK1rEX1L
         wssbhBeak6dXqPdoxZi7HyjY/HoN4eZOiBOWHVVOrfAls1aie6VgiYfV84slTqO4moci
         L9+Fih8fDGbR5ZC3FCvuEDNDdec584ncBUElG3ii+3quc0S4YGiMlqHOomzYOLsX9AI/
         OEUokJ2z0/XGD+z4RVDd0quGNjjdkZp0cZhDWTzEX1BNuJiDwNJLwNDoZysnTts0G594
         D8lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756744993; x=1757349793;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Q+lnz5hfxAJyxjEQHB9/QTS15Vi2TY+Ow6yqCRyLm4=;
        b=pawMf+gzHvWc7F2qrz/GzIDRfpB9y+QloFASsxDA6hd+7VlgA0/rfSphccU3w1DJNn
         t3FTWAWCBUMMjFAazElz3eUWyTjAIrJnRAQCb+x5MqRpffN8Wi58t/vgaU+m+RGbr9Mw
         GYaDOoGj56BtZ8qyWNMHWlKqrQHfKURHyJ3bmme7XqShioqB3YOPqlMhrmGHo5N3N3Us
         sCQu4sM4+7pw/0agUKl2DHpNaj6PkDjdyXcIxoEBT/hgEJFZIdEfCRuCqekCIUkbtBD/
         JBPDpqAfgrWvqNSf1pCDpBiKz1APmKiCcNv2Aq+JWbOeJBz22Gllzr2LkTRBqnq32U3U
         /dEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVhBM5PjVPud7YyVdXd4hWfdZahow1hEfIk0FZL2ipuT9pnPg9eiaspw+XNYEUCbk+hZPqdIYfng==@kvack.org
X-Gm-Message-State: AOJu0YyoAwEghRW2KXqLBXcEy4najzFRucFsdbl4a9kOm/K9MdUOJw/d
	nzV4Rux+ZT1BW7BSmNG4B+RVDj8w9/gj8+Vd8ndxxWR5coShHvW03+pl
X-Gm-Gg: ASbGncvrmOZh21bOpMZPRawewdOp+ZSaN2txY01VSZFqsC0TT2D4QX85SW71qyAUI/o
	TUpKdVF26Cb0NCRzS5HN6dAYUJ2OmMeV5debthOMoZUK+vrob43upiG+6uYgzwti/HinFJ55WjR
	geW1xgMYIbKHexw4IQtfcnySugeV5911GUB7RErCuGG7uE8llFsG0WU6LjAE56FGUyQnDfg8+hI
	aXZOsttb5N7GsnD2Foh6eHNoeCEVTq71nBv2aHg34fOyTJUCC6SOnXksVm7mIgxkQCHv4ox0+2S
	nM5zne3TSkzoCfDWR0UgrWUQpG+XudOf6KNo3fQzONKjVPSTTQhjdywj7QaHBBWQ7TRcLSsd3oF
	rHYwGDFvVZAeCqqM1f234EuzIbVpccVpmHY7u5R4XkLb3YITX+Gs9me5ZX57JHaXpjvk4jTPaVK
	SmwXAHqdAR26jAFOF2YQ==
X-Google-Smtp-Source: AGHT+IGdy+tOobQ6/cEnCP2LLYhWSoZQQ7yDGg9ljMT50J/2P7kmgHLbMeThCGXjBEyDpbxW4zO7HA==
X-Received: by 2002:a5d:5886:0:b0:3d1:bb77:9119 with SMTP id ffacd0b85a97d-3d1e0a953a3mr6820630f8f.61.1756744993046;
        Mon, 01 Sep 2025 09:43:13 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (140.225.77.34.bc.googleusercontent.com. [34.77.225.140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf274dde69sm15955362f8f.14.2025.09.01.09.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:43:12 -0700 (PDT)
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
Subject: [PATCH v2 RFC 5/7] kfuzztest: add ReST documentation
Date: Mon,  1 Sep 2025 16:42:10 +0000
Message-ID: <20250901164212.460229-6-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
In-Reply-To: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD9CF40008
X-Stat-Signature: n74xy4icoqu4rmw5kaqqhkdxhm3shkfb
X-Rspam-User: 
X-HE-Tag: 1756744994-648021
X-HE-Meta: U2FsdGVkX1+nm7TBZLyTttovYx+qmZymDLFUYXGlPdEj+CxJWP0l0KjppydxsPaFKJT5eB49LNf9fdeVCoksTu9oiRzFN4e+D7W31HkJWw5dytDEr9dNPVnkfk7pJVy+DFI1+Ll2wPKS5YnKd/C2EVBrrAsJl+l+g/Sdv1gjK8xiu1BSD2QWqPeDIFO5KEkY/4ZBhgcOea1PRzC9RT+FERLuRFk5FfZW2lae22TuTROU2+iBBxNjtjVJ6b2PKBMW9tIjQ2FT7xnnnnbesovtNjGBCvYMsy0Y2NOQslFs7u72LRi8JHjBNOU9yZKMxxlPBgWwgtz1ihvJyH37oYD1+vQsH68/A1E7+NqvZgbiHL/iwkfRMnBqYYmQcmI5JRy4xDAYtC2sszgnuV3SG1XDADkrOS/0E4lnMIUtvkrdq2pV5fyWXf6wZklqawi9TFkb/3hHPkBGGmYvAxQJVk2rioEiPT/oeUwOO89ZhRiBDHt3OZ3ApMU/POix5zvptRAxda/jk4bHG532SIGq6HbHCimG+TZVn+7JHMlfnsXLqfSGzJsHB8nUHOC0tPIRaVTj5umBFri9fK9Ry+JEICK3sL4rOS4dMXZRQmPpUS8mDGVC1/BWY12uWIrPrxVFgRjXjgqb/wMZ1u2GD6qrABx0CjGvji1zdBgQVR+BjJTXiVjLl98LZAH7Uo3KhDyhJT9Jh6ZibRrqDPAXqT4yz5ZoUjTgDrFVHB9wrS2xt+djU2u3KEIGKC8AIi/JD7DCVVdnrSttIB+WQElXovT3n9+qD3MUw6wxJNvAwHvHmfr5g81GrgBjZ1rkXj1b6ePUjENRPYbGPj6LNpeTYOL+iIkZTRZG58TX/4xRP3dctWjLiH/ka9uVzWKQIXiG32SwoPV4ekxfQWmaP7tcNHrWdW+NChWaoalCWB+ysLAstQAM4sIKxQGpdOunkwnJEHhz55uiZYXMrXu82xRPf4csawY
 HbWesuDG
 2RHKrqGtpUSFvZG8th2cGH4e8lXc1tGMFvZ8zFSly5DI8bCbpCcAJcxKkxZFvPfJgbZfiZF+6YQZXUMt+uST7lnWIn6E3BC4GrxuyozM4AQFelVqiOr1iS6WIEdnofjmbKdaL9gE4FkeOA1ZrD7fEs7bzkHme+77GIotb1newNVFwaGmExYonFGUYpxojcCEkDIerqh3KXqoEbIvFr9J01LtfcfkXnrmLZPwvUBFONDHUd8ndSrRS+b3VfQEhkJX2oLfX34MXgHd0pQ6FYhc70eBXqEr5WR8YkwE0HbAftwlGka0kGMvUQMC637wkJ9H/r94/efNQw8JLPl2iuDAZi49021S+bwk37pmpO4GzQRoUF6sEMms3RJvpS9ZIfChiYU09456BfdYsG01v1/Lew9sURw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

Add Documentation/dev-tools/kfuzztest.rst and reference it in the
dev-tools index.

Signed-off-by: Ethan Graham <ethangraham@google.com>

---
v2:
- Add documentation for kfuzztest-bridge tool introduced in patch 4.
---
---
 Documentation/dev-tools/index.rst     |   1 +
 Documentation/dev-tools/kfuzztest.rst | 371 ++++++++++++++++++++++++++
 2 files changed, 372 insertions(+)
 create mode 100644 Documentation/dev-tools/kfuzztest.rst

diff --git a/Documentation/dev-tools/index.rst b/Documentation/dev-tools/index.rst
index 65c54b27a60b..00ccc4da003b 100644
--- a/Documentation/dev-tools/index.rst
+++ b/Documentation/dev-tools/index.rst
@@ -32,6 +32,7 @@ Documentation/process/debugging/index.rst
    kfence
    kselftest
    kunit/index
+   kfuzztest
    ktap
    checkuapi
    gpio-sloppy-logic-analyzer
diff --git a/Documentation/dev-tools/kfuzztest.rst b/Documentation/dev-tools/kfuzztest.rst
new file mode 100644
index 000000000000..aeaf433a320e
--- /dev/null
+++ b/Documentation/dev-tools/kfuzztest.rst
@@ -0,0 +1,371 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. Copyright 2025 Google LLC
+
+=========================================
+Kernel Fuzz Testing Framework (KFuzzTest)
+=========================================
+
+Overview
+========
+
+The Kernel Fuzz Testing Framework (KFuzzTest) is a framework designed to expose
+internal kernel functions to a userspace fuzzing engine.
+
+It is intended for testing stateless or low-state functions that are difficult
+to reach from the system call interface, such as routines involved in file
+format parsing or complex data transformations. This provides a method for
+in-situ fuzzing of kernel code without requiring that it be built as a separate
+userspace library or that its dependencies be stubbed out.
+
+The framework consists of four main components:
+
+1.  An API, based on the ``FUZZ_TEST`` macro, for defining test targets
+    directly in the kernel tree.
+2.  A binary serialization format for passing complex, pointer-rich data
+    structures from userspace to the kernel.
+3.  A ``debugfs`` interface through which a userspace fuzzer submits
+    serialized test inputs.
+4.  Metadata embedded in dedicated ELF sections of the ``vmlinux`` binary to
+    allow for the discovery of available fuzz targets by external tooling.
+
+.. warning::
+   KFuzzTest is a debugging and testing tool. It exposes internal kernel
+   functions to userspace with minimal sanitization and is designed for
+   use in controlled test environments only. It must **NEVER** be enabled
+   in production kernels.
+
+Supported Architectures
+=======================
+
+KFuzzTest is currently only supported for x86_64.
+
+Usage
+=====
+
+To enable KFuzzTest, configure the kernel with::
+
+	CONFIG_KFUZZTEST=y
+
+which depends on ``CONFIG_DEBUGFS`` for receiving userspace inputs, and
+``CONFIG_DEBUG_KERNEL`` as an additional guardrail for preventing KFuzzTest
+from finding its way into a production build accidentally.
+
+The KFuzzTest sample fuzz targets can be built in with
+``CONFIG_SAMPLE_KFUZZTEST``.
+
+KFuzzTest currently only supports code that is built into the kernel, as the
+core module's startup process discovers fuzz targets, constraints, and
+annotations from a dedicated ELF section during startup.
+
+Declaring a KFuzzTest target
+----------------------------
+
+A fuzz target is defined directly in a .c file, typically alongside the function
+being tested. This process involves three main parts: defining an input
+structure, writing the test body using the ``FUZZ_TEST`` macro, and optionally
+adding metadata for the fuzzer.
+
+The following example illustrates how to create a fuzz target for a function
+``int process_data(const char *data, size_t len)``.
+
+.. code-block:: c
+
+	/*
+	 * 1. Define a struct to model the inputs for the function under test.
+	 *    Each field corresponds to an argument needed by the function.
+	 */
+	struct process_data_inputs {
+		const char *data;
+		size_t len;
+	};
+
+	/*
+	 * 2. Define the fuzz target using the FUZZ_TEST macro.
+	 *    The first parameter is a unique name for the target.
+	 *    The second parameter is the input struct defined above.
+	 */
+	FUZZ_TEST(test_process_data, struct process_data_inputs)
+	{
+		/*
+		 * Within this body, the 'arg' variable is a pointer to a
+		 * fully initialized 'struct process_data_inputs'.
+		 */
+
+		/*
+		 * 3. (Optional) Add constraints to define preconditions.
+		 *    This check ensures 'arg->data' is not NULL. If the condition
+		 *    is not met, the test exits early. This also creates metadata
+		 *    to inform the fuzzer.
+		 */
+		KFUZZTEST_EXPECT_NOT_NULL(process_data_inputs, data);
+
+		/*
+		 * 4. (Optional) Add annotations to provide semantic hints.
+		 *    This annotation informs the fuzzer that the 'len' field
+		 *    is the length of the buffer pointed to by 'data'.
+		 *    Annotations do not add any runtime checks.
+		 */
+		KFUZZTEST_ANNOTATE_LEN(process_data_inputs, len, data);
+
+		/*
+		 * 5. Call the kernel function with the provided inputs.
+		 *    Memory errors like out-of-bounds accesses on 'arg->data' will
+		 *    be detected by KASAN or other memory error detection tools.
+		 */
+		process_data(arg->data, arg->len);
+	}
+
+KFuzzTest provides two families of macros to improve the quality of fuzzing:
+
+- ``KFUZZTEST_EXPECT_*``: These macros define constraints, which are
+  preconditions that must be true for the test to proceed. They are enforced
+  with a runtime check in the kernel. If a check fails, the current test run is
+  aborted. This metadata helps the userspace fuzzer avoid generating invalid
+  inputs.
+
+- ``KFUZZTEST_ANNOTATE_*``: These macros define annotations, which are purely
+  semantic hints for the fuzzer. They do not add any runtime checks and exist
+  only to help the fuzzer generate more intelligent and structurally correct
+  inputs. For example, KFUZZTEST_ANNOTATE_LEN links a size field to a pointer
+  field, which is a common pattern in C APIs.
+
+Metadata
+--------
+
+Macros ``FUZZ_TEST``, `KFUZZTEST_EXPECT_*`` and ``KFUZZTEST_ANNOTATE_*`` embed
+metadata into several sections within the main ``.data`` section of the final
+``vmlinux`` binary; ``.kfuzztest_target``, ``.kfuzztest_constraint`` and
+``.kfuzztest_annotation`` respectively.
+
+This serves two purposes:
+
+1. The core module uses the ``.kfuzztest_target`` section at boot to discover
+   every ``FUZZ_TEST`` instance and create its ``debugfs`` directory and
+   ``input`` file.
+2. Userspace fuzzers can read this metadata from the ``vmlinux`` binary to
+   discover targets and learn about their rules and structure in order to
+   generate correct and effective inputs.
+
+The metadata in the ``.kfuzztest_*`` sections consists of arrays of fixed-size C
+structs (e.g., ``struct kfuzztest_target``). Fields within these structs that
+are pointers, such as ``name`` or ``arg_type_name``, contain addresses that
+point to other locations in the ``vmlinux`` binary. A userspace tool that
+parsing the ELF file must resolve these pointers to read the data that they
+reference. For example, to get a target's name, a tool must:
+
+1. Read the ``struct kfuzztest_target`` from the ``.kfuzztest_target`` section.
+2. Read the address in the ``.name`` field.
+3. Use that address to locate and read null-terminated string from its position
+   elsewhere in the binary (e.g., ``.rodata``).
+
+Tooling Dependencies
+--------------------
+
+For userspace tools to parse the ``vmlinux`` binary and make use of emitted
+KFuzzTest metadata, the kernel must be compiled with DWARF debug information.
+This is required for tools to understand the layout of C structs, resolve type
+information, and correctly interpret constraints and annotations.
+
+When using KFuzzTest with automated fuzzing tools, either
+``CONFIG_DEBUG_INFO_DWARF4`` or ``CONFIG_DEBUG_INFO_DWARF5`` should be enabled.
+
+Input Format
+============
+
+KFuzzTest targets receive their inputs from userspace via a write to a dedicated
+debugfs ``/sys/kernel/debug/kfuzztest/<test-name>/input``.
+
+The data written to this file must be a single binary blob that follows a
+specific serialization format. This format is designed to allow complex,
+pointer-rich C structures to be represented in a flat buffer, requiring only a
+single kernel allocation and copy from userspace.
+
+An input is first prefixed by an 8-byte header containing a magic value in the
+first four bytes, defined as ``KFUZZTEST_HEADER_MAGIC`` in
+`<include/linux/kfuzztest.h>``, and a version number in the subsequent four
+bytes.
+
+Version 0
+---------
+
+In version 0 (i.e., when the version number in the 8-byte header is equal to 0),
+the input format consists of three main parts laid out sequentially: a region
+array, a relocation table, and the payload.::
+
+    +----------------+---------------------+-----------+----------------+
+    |  region array  |  relocation table   |  padding  |    payload     |
+    +----------------+---------------------+-----------+----------------+
+
+Region Array
+^^^^^^^^^^^^
+
+This component is a header that describes how the raw data in the Payload is
+partitioned into logical memory regions. It consists of a count of regions
+followed by an array of ``struct reloc_region``, where each entry defines a
+single region with its size and offset from the start of the payload.
+
+.. code-block:: c
+
+	struct reloc_region {
+		uint32_t offset;
+		uint32_t size;
+	};
+
+	struct reloc_region_array {
+		uint32_t num_regions;
+		struct reloc_region regions[];
+	};
+
+By convention, region 0 represents the top-level input struct that is passed
+as the arg variable to the FUZZ_TEST body. Subsequent regions typically
+represent data buffers pointed to by fields within that struct. Region array
+entries must be ordered by offset ascending, and must not overlap with one
+another.
+
+To satisfy C language alignment requirements and prevent potential hardware
+faults, the memory address of each region's data must be correctly aligned for
+the type it represents. The framework allocates a base buffer that is suitably
+aligned for any C type. Therefore, the userspace tool that generates the input
+is responsible for calculating each region's offset within the payload to ensure
+this alignment is maintained.
+
+Relocation Table
+^^^^^^^^^^^^^^^^
+
+The relocation table provides the instructions for the kernel to "hydrate" the
+payload by patching pointer fields. It contains an array of
+``struct reloc_entry`` items. Each entry acts as a linking instruction,
+specifying:
+
+- The location of a pointer that needs to be patched (identified by a region
+  ID and an offset within that region).
+
+- The target region that the pointer should point to (identified by the
+  target's region ID) or ``KFUZZTEST_REGIONID_NULL`` if the pointer is ``NULL``.
+
+This table also specifies the amount of padding between its end and the start
+of the payload, which should be at least 8 bytes.
+
+.. code-block:: c
+
+	struct reloc_entry {
+		uint32_t region_id;
+		uint32_t region_offset;
+		uint32_t value;
+	};
+
+	struct reloc_table {
+		uint32_t num_entries;
+		uint32_t padding_size;
+		struct reloc_entry entries[];
+    };
+
+Payload
+^^^^^^^
+
+The payload contains the raw binary data for all regions, concatenated together
+according to their specified offsets.
+
+- Alignment: The start of the payload must be aligned to the most restrictive
+  alignment requirement of all its constituent regions. The framework ensures
+  that each region within the payload is then placed at an offset that respects
+  its own type's alignment.
+
+- Padding and Poisoning: The space between the end of one region's data and the
+  beginning of the next must be sufficient for padding. In KASAN builds,
+  KFuzzTest poisons this unused padding, allowing for precise detection of
+  out-of-bounds memory accesses between adjacent buffers. This padding should
+  be at least ``KFUZZTEST_POISON_SIZE`` bytes as defined in
+  `include/linux/kfuzztest.h``.
+
+KFuzzTest Bridge Tool
+=====================
+
+The kfuzztest-bridge program is a userspace utility that encodes a random byte
+stream into the structured binary format expected by a KFuzzTest harness. It
+allows users to describe the target's input structure textually, making it easy
+to perform smoke tests or connect harnesses to blob-based fuzzing engines.
+
+This tool is intended to be simple, both in usage and implementation. Its
+structure and DSL are sufficient for simpler use-cases. For more advanced
+coverage-guided fuzzing it is recommended to use syzkaller which implements
+deeper support for KFuzzTest targets.
+
+Usage
+-----
+
+The tool can be built with ``make tools/kfuzztest-bridge``. In the case of libc
+incompatibilities, the tool may have to be built on the target system.
+
+Example:
+
+.. code-block:: sh
+
+    ./kfuzztest-bridge \
+        "foo { u32 ptr[bar] }; bar { ptr[data] len[data, u64]}; data { arr[u8, 42] };" \
+        "my-fuzz-target" /dev/urandom
+
+The command takes three arguments
+
+1.  A string describing the input structure (see `Textual Format`_ sub-section).
+2.  The name of the target test, which corresponds to its directory in
+    ``/sys/kernel/debug/kfuzztest/``.
+3.  A path to a file providing a stream of random data, such as
+    ``/dev/urandom``.
+
+The structure string in the example corresponds to the following C data
+structures:
+
+.. code-block:: c
+
+	struct foo {
+		u32 a;
+		struct bar *b;
+	};
+
+	struct bar {
+		struct data *d;
+		u64 data_len; /* Equals 42. */
+	};
+
+	struct data {
+		char arr[42];
+	};
+
+Textual Format
+--------------
+
+The textual format is a human-readable representation of the region-based binary
+format used by KFuzzTest. It is described by the following grammar:
+
+.. code-block:: text
+
+	schema     ::= region ( ";" region )* [";"]
+	region     ::= identifier "{" type+ "}"
+	type       ::= primitive | pointer | array | length | string
+	primitive  ::= "u8" | "u16" | "u32" | "u64"
+	pointer    ::= "ptr" "[" identifier "]"
+	array      ::= "arr" "[" primitive "," integer "]"
+	length     ::= "len" "[" identifier "," primitive "]"
+	string     ::= "str" "[" integer "]"
+	identifier ::= [a-zA-Z_][a-zA-Z1-9_]*
+	integer    ::= [0-9]+
+
+Pointers must reference a named region. To fuzz a raw buffer, the buffer must be
+defined in its own region, as shown below:
+
+.. code-block:: c
+
+	struct my_struct {
+		char *buf;
+		size_t buflen;
+	};
+
+This would correspond to the following textual description:
+
+.. code-block:: text
+
+	my_struct { ptr[buf] len[buf, u64] }; buf { arr[u8, n] };
+
+Where ``n`` is some integer value defining the size of the byte array inside of
+the ``buf`` region.
-- 
2.51.0.318.gd7df087d1a-goog


