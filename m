Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E22BC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DB30900073; Wed, 13 Aug 2025 09:38:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93C95900044; Wed, 13 Aug 2025 09:38:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DDF1900073; Wed, 13 Aug 2025 09:38:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B2CE900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:38:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DBF7A137C02
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:38:45 +0000 (UTC)
X-FDA: 83771839410.28.340CA50
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id D9A9014000B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:38:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bmmyDXJW;
	spf=pass (imf23.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755092324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fT8XtIdCS6vk3GGdGM60wvLV9ckvUvGKm1mza8YtIpw=;
	b=h8suKsSyjONpmLOAqep4y3hZ80sObJKUQf2HRAhATeN5Yprodcp8LRhrEvEBDaQf9QSgEe
	V0DdIA2WZ3We8K0mCQZ86QSZ768aclGMMzZoUK95jjQ2tf0p9oPoC0lmdzmK5nHEmGJjgT
	WI2CRoFR6nMQu55ujBvO3+pQD6caSN0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755092324; a=rsa-sha256;
	cv=none;
	b=sf/YHT5X2s8DrUHzk/8yKZROzJZpzjTikgSRXeGe5dx2ehZaGFQUaYesRWTs8eevVNMXi3
	SpyWB7eQd5KKgD52wNajphJB4sAgKai3StGaNko8CiWK10/Un6rI8+FplYVQ+i+4nfB5Pw
	NauZL1RuS1RAnuh2WYRkQwvHNhbl29I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bmmyDXJW;
	spf=pass (imf23.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3b7886bee77so4720178f8f.0
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755092322; x=1755697122; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fT8XtIdCS6vk3GGdGM60wvLV9ckvUvGKm1mza8YtIpw=;
        b=bmmyDXJW1P3SMd6KAevOvOALcDbCyRTeTapBYVr0W1UbrI0bOv7W57U8knKxy8god4
         IMim4wzETSB4HhzVX5fDEcT32gmnAGj2mZmE0ZuzBDwmXs7QHOk2KbBqR/dd9TYPj6O3
         TJ7Oj3yp93uB1W0Rmjp7yJNYZBAW1DlF6l0nMDnVr1k8Lg14NtDZv1QqCvm9qfblzPx7
         LJxovwj5IvMNQL+PwmZJ39OUUHID4JlIatCVZARNoCn2/Y97cgQeH8TlHu+8QqmbOSIE
         a9ohPunjSoxSv7VfSQU+ATkZKdJuVZ/WqkA0Hi1h98KXFuQSFjvIB2d8WvcdKB5AJGOv
         IvYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755092322; x=1755697122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fT8XtIdCS6vk3GGdGM60wvLV9ckvUvGKm1mza8YtIpw=;
        b=bNCUQwhPCUz7ai24CQtnF5WmQOdXMeVCtU5kc0cTaxfKnvs2Syf1gaT3Dkf34Dt5Z5
         vVzQtgntL4aG9fsxKrECZneIwih3dzL7o29hpiEDj9WfeS8calqUdNfvuSe5w+tA0G6n
         kXf6DmTIxjtcxwKX5sB1LgYaU5FalnaVSMD9SVSdMWE5Qs/q/11ZEctjfm+fhSWMU9I0
         4iOvAJPJRE2ITBcbGvJkRm0Z4fA4YfonKuEXbMkXySOBoIwstrtcc7dN7mv/+p3/t3NA
         UtN8o2pKTq+N1JaEfugUmkWdx4dYJYnsRNn07AQbNOhG/GqnfyVs8jyuNYDpvLTXvYOr
         5xzQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5sAglRxaPOdympShTsN53AWHcdxU1XSQs3ziYEYLIClDJFj6P/jDhw7oq7WSXu4ZEE/38bzQ4vA==@kvack.org
X-Gm-Message-State: AOJu0Yzu7GhqIkodHL4EMwPzFW/FTDWOLU+xoHEjrLBhkq/wbPzTe1gD
	5tg22QOctfnEC4NXM3zaHmrp90vnPxfB8cVZbISudSERrff3a2Nt3RkE
X-Gm-Gg: ASbGncsPj+Rl8ozPzDOIS4YYNeXAhW3KYdWS+cGXl4+QB7DEsxWUL/q06UEsx6Dpt21
	LToiGXDTgEiiycVgWYpO6n3mbkV5tnPryk9fPbmINIbvsGIy4Y5LYczSVoYGHPJ4lXlfZ3cZEG2
	Q+WPlJP4dGtXwyrftl8vTa06CoLu4IJBU7zNVE3q5lqzwhx74TrOvl9vihj9wETMicfXoH0479V
	vWNraKfwRRO4x8z0RPOt5frpKjrB6LENr62fDHc6gCVBbVa59boT2WmL7uk7wknHGt1toRtEUu2
	Eh4oMW5Uh4Q8YcXOT2SxIcnF6Q/Ut6eZNVe9N1X+7h4rpQGw2+JgzwfDAucbbwYqZbCRJPr9ElO
	7wjUEZsHoCM2GpShx8SQv16vEXbiNrmDKnxg11yGTnbIgBmlRRpchuu2P6VzNGo2L6WbrE51HLl
	t/s1a9My1qvUl5whU=
X-Google-Smtp-Source: AGHT+IG3CJoU5aNy+ncGbe3vgt9XmR0hiIDWH1GBUd5ER+QfQEnq5bQhyK7xzwpgftq1Sivqu1Fxdw==
X-Received: by 2002:a05:6000:26c9:b0:3b8:d6ae:6705 with SMTP id ffacd0b85a97d-3b917ea1577mr2096491f8f.30.1755092322216;
        Wed, 13 Aug 2025 06:38:42 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (87.220.76.34.bc.googleusercontent.com. [34.76.220.87])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8f8b1bc81sm25677444f8f.69.2025.08.13.06.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:38:41 -0700 (PDT)
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
Subject: [PATCH v1 RFC 4/6] kfuzztest: add ReST documentation
Date: Wed, 13 Aug 2025 13:38:10 +0000
Message-ID: <20250813133812.926145-5-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
In-Reply-To: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D9A9014000B
X-Stat-Signature: tgyu9fhny9uq6yugj96fcaa84z3a91zr
X-HE-Tag: 1755092323-330230
X-HE-Meta: U2FsdGVkX1/IHt4R0TkRplbu8LXiTVHhP+FvNdlkcMc1/+KqSWQM6zfZ2Fkrgbi6WJxZ7pDZfarjdKZ/UwXXUZQpSiLNJZPItWF4gPTjyTtzI5wi+H4AEEfssEwIJaZPDTTunDI/FFk2jhioy5iq9IRf9Qf75lDjsHEEyXB5paVO+3aKF/gbKaDHdEa5aSxnmjRMNbk65FdnyIDzRMfPPlJrHdulsV0YBXifIkCGgCbCYnOI9ZdW2CrGbfrOqRw3Wpkzwl/E0wjXI1grb2FfWaWtMeHldIkRo7HoiH3nmse3MUWkKvTueVsNP6i2AC/IvLfSxC5nAyDvTpw18p4k150pqWxGofyR2AWpwfxJRTIzXjIWUgkHmvU4g3ukT9HisFj7Lblb0LLdpui0ctjJnPYVpTWFrEPmm0CYgpwDQZlFtJ75Xu9dHxFLZRCZBQ2g84xOlkXwasX2uTBurvwmFtQrWnbOk7AfrNBlSF5z6KCkuJ1zGCY57uAahPSw22gom2jY5w3v7OP3m7BPZxVrC6KAA1C+ix6p9SBs9bLPezSehl+GCZ25+HvtuGFKlavJsaqkSIXWZDRLuG4n+J4NUWlzMynZ8Vp6F8wWSpj/RiJuM3jFqPZK90I7WoCWXgZ9tWSzNXSWPhCgJp+3sSSP1u4Bip0/eGL0Dzjvc++JMY1e2X5rp/YGbwjU3Ozua0y//UuEkLVhEr9n2uD+mVBQRZ/6GvECUbPgilsHENF9a/z2GyBdFU8sxHyiD1ULlEf1rVd9DgAjgdXuv4SfAp/SLHg+RAsthjXi6zIfQ1VznDbEQSMFqipeQmzOrtvnpCc30NUmJ6yKuOn+bdH3y2v0kI1+VR82UztNgIuGN7gPJVvkzhXp6rtNpK9nCpVFKf/NpIaSWxmEvfiHOf1aqKsRwoxdGtl4rxHmCngtfePgsFE6N+pq3t4/7TM68nb+CTM3kJcr3EpcLmsZQw35oXj
 09zgWuy5
 gmReFNaDLS+rHWEqjdsncEYfvpwN9Y6eLKMRx1hVCcbj0rWG4+mDUoAekVePTXWCI6jXZpd1CJIVH/hO4QwKIhX2oIGRrkDPwm7+smLcAW1cqDgQ1tF1H/D5xbDcBuOoOJuUmmo2AF/2t92hazkliu0Jvn/S/ZNwlkeMdHF+r1E6rXcmimU5ixSpAlVrhTO5hE7BhUhlook8GjPFvjjWjW0Mvnu8i2ns6YHCEd/cQvjjzH/3rLgPZrUbsQQiMuhfN091kzkJuA1mumO8KBmRvHqNZ4sTlaijKKOBUYyVE+TdVM0Wgg6Wj5ByRLwc3mSxk195s8v4RHPp3E11/AJR/q5iQEQFTzRDcAScCezYiyQrS1xMtUrIaFvj6MY12BrYZzIEJbALCpwsWLaUioDIiwLyY8EcjnFwvCiXLylNE1BsOeNFYtnRehi0mOnjye8fRE8JR
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
 Documentation/dev-tools/index.rst     |   1 +
 Documentation/dev-tools/kfuzztest.rst | 279 ++++++++++++++++++++++++++
 2 files changed, 280 insertions(+)
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
index 000000000000..7fdc4914b966
--- /dev/null
+++ b/Documentation/dev-tools/kfuzztest.rst
@@ -0,0 +1,279 @@
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
-- 
2.51.0.rc0.205.g4a044479a3-goog


