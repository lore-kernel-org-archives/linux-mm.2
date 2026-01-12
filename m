Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61758CF45C9
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:28:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE206B0092; Mon, 12 Jan 2026 14:28:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31056B0093; Mon, 12 Jan 2026 14:28:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989FE6B0095; Mon, 12 Jan 2026 14:28:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 849AE6B0092
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:28:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34D1CD1DEA
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:28:48 +0000 (UTC)
X-FDA: 84324299136.07.2802D04
Received: from mail-ej1-f65.google.com (mail-ej1-f65.google.com [209.85.218.65])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4800440012
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:28:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OpwmXKeO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.218.65 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768246126; a=rsa-sha256;
	cv=none;
	b=xntBWYRMEjzyGM3KbRzDo8nWlFjSGSZ4+nm7ZUhh6WP1jpU7pmq3EGrQiVhzin54of5M9b
	g3mjASyZBEkSVvT60ZftPn62v2IXg71/vAJsPbU6B/9zi06vQ5mXJv6Fq6e0OFwAn1QE63
	4+99+Kw7bXALEC3UMaZJC6zG7bwUMJk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OpwmXKeO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.218.65 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768246126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTAiuUIttCbMVHuYgOxGCwhf3npydnD/rY6k0kTCwMc=;
	b=uG+knUgyG4MsjAB1oxhP6aI1fBQiQusuNr5vzEPYBetfqvGTkZ9PSyxhWD0sb+ImeO+fDN
	qF2SP4VfNmkbf7HH4D2qy/AS7+l0j7BbOENsotQ048jxCi928wRGbZj72ZFoyVyvJs9pdT
	AzSR29XFAXKwGXnR4h4wvGI/DIbEwak=
Received: by mail-ej1-f65.google.com with SMTP id a640c23a62f3a-b871ba73f49so190263566b.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768246125; x=1768850925; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CTAiuUIttCbMVHuYgOxGCwhf3npydnD/rY6k0kTCwMc=;
        b=OpwmXKeO//K9mA8zyyJTjTm/qfhdoPEjg1Ai2rlgOtS+xl69uNgBiY0ARRjBakFbCt
         WlEqcgGnH3LLLZ0HdpoQve287yj3zrWogS0JJEYWSQE23tUSoS7YGzqjCJIi/Kp/vs3j
         lHDawJz9qZQ63SF+t1VtPt1Kzvxgou4MM1/OG2swKdhIgSbt4vZ5Li0HSQjFq1FSLdrF
         8dd8WlZ4YyoGAr/e2Z7o/e9Fy8OTa/M7az1gEuV5VkzpL1/Sqbot7RZihCYAROI9oRLj
         qp9SmyBjViEOTdn0Oi1mVw9lLU9DwqnEU9WP8k5xEXzroinuCgM2vXJrDSNPgOvVop56
         FJxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768246125; x=1768850925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CTAiuUIttCbMVHuYgOxGCwhf3npydnD/rY6k0kTCwMc=;
        b=HylnkW2Cb7/I+Pq5cFB9jLAhMNX+jLnLRmLNw/sMKXbf0tUGbH2GbPDwaMHZaxLAN8
         XzMtdLIB2p2hHSDX+aikEf9k5Vt/8oIxvcu56wKwQ7HlQPpLumXTWvJ5HRnHle/CdZkh
         tFsCJF8DhL3rxYipiD2vuD/EqfDgMK6bnwlfgHPUq1gvmZXJLCYMffK8iw4BzywJTYq+
         NWhKr7PqzBAGwN+hPtVR2Eu88ujWgRSJAMLYgOY8XLAVKyFt/mhfurpUX+a9O/5MHzy3
         WK4RAPvzMrsyTfr6bgJb4LAet39hWJEKLNghwZbUfH2xv4EEdq/ofyw2asiCUyFvQ1Td
         XbQA==
X-Forwarded-Encrypted: i=1; AJvYcCVSZYXy38CVfw/xHsngig0hd3DY2MCNoGW0xOqGBwDGp6FuFIr7ZjOrn84tv3dMMs2fHKmayGxJ+w==@kvack.org
X-Gm-Message-State: AOJu0YzlJzOItD3b1f4YOj22LGqWCqLzK/dFRACP15OOXJ1Rx9YHhO4Y
	3gQ/Z5s17TCFVxcaJYyhAKoNPZtmHbfHg7uEqUABpuWbvUJzoG/ovmEi
X-Gm-Gg: AY/fxX4qPqmK2TQGFhvLWn0TWpDkPkKnynxleAzxUVHnEp+d7vHerEX8/J5e4JhWQsX
	xO+2VZGItiQOXXUL8nCrWPFmmjbX20jKw39ssgHTrvAAlqMVFwmv6IFC/CATWIJ5J65pDJGWL3M
	/X1A6E3sPwq+Y4iXwaf4r4mSgBgSktrgf1kY1aRORElAt15jDMvlXFY7Cgm8DYR4V+ZlDNWDBZH
	fYhUavTjIf9rZgxhyHGrH5CysbtcuLuo8qPhOr3t+vBXBuO0vdy64aLz5hQ4iztbLygOtEc5M3o
	pdpbFgXamZSJTF/mWfGxEQSTGOGet4NoIzgqCsOcDpXmRPyWyNKkCUO9vFcpawNBYTfKJNMujVh
	bgoQDWObQGB/A6ESrLu99RMCRyOJXCGO1sHTH5z4biJT0Y8Qiit/x5xAhEGtWYd53DfhsRLjwsc
	BSHLL5nXYdkRWavY+R+1lrPEdFeDJ+dBgIfl4jBqTf618wYct8iQ==
X-Google-Smtp-Source: AGHT+IFg3EfHyzwE3s5+1CIr8vfZlNWItuYnwllGRGRLiahyarhLhMPRBnC81D17BfEIAlYLna4bQw==
X-Received: by 2002:a17:906:c141:b0:b87:1c74:a8c6 with SMTP id a640c23a62f3a-b871c74ab49mr405692366b.57.1768246124624;
        Mon, 12 Jan 2026 11:28:44 -0800 (PST)
Received: from ethan-tp (xdsl-31-164-106-179.adslplus.ch. [31.164.106.179])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf667fcsm18108959a12.29.2026.01.12.11.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:28:44 -0800 (PST)
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
Subject: [PATCH v4 3/6] kfuzztest: add ReST documentation
Date: Mon, 12 Jan 2026 20:28:24 +0100
Message-ID: <20260112192827.25989-4-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4800440012
X-Stat-Signature: 8rhjrto57nx4ecqg34h9qcddhzkgtgc1
X-Rspam-User: 
X-HE-Tag: 1768246126-315198
X-HE-Meta: U2FsdGVkX1/slimmzAXtwYEGWO4nFoOG3+yZO6aWpdTlcbnyDkX0RcdOnRAZp5YoKA76aRHL043hEEhdDLqnJRHXD0IJR8cwbWC2FnyuROUeAgLuaGHvhUVBkEX/ezmtWTJVhIU1R+V8vVJn4HdrKO9nuytLXbQyPAap4iZJMnw8hE7R1bI5hLCUQrZshfiAg4G43oVdzbDKZxF8xptlgbQcJv9GXa9u5ZH3W209rzWCTRO71HeVvOrc7zv6qNWrfe6A0NZQe7B+/1ZQ1SJWVaJtJ1gVR/k2HZxkIPLj1e2GNmY4qsDJP02Vt2a0NVb9ju4Fo+0laNCapIkN1zZ9sILJuKShY1QfnMfitKqd3CFE+8wcPYXxYmkLJRTqo5vm5/W+TqVEQP9Ac2bbMNSRR3tOoAV6veFlg10T7pGBDOEtCKKGbD7SQtLIybYq7D0SXL33DW/8l2MHKjsrBFuPLjzeTXpwLXuvD4NeV6imKVjqCk2uUlGgg9CLFQKL4FqTw24IjjYyOvTRKM5zjteSnB6Y01ALauoH2mr7FEcLlv2G3nGQLJRPnmTGZLs7fi33m2UNHGQArAIpr+7DSG2qzMk+k48C+l7VF68mA6ErXt3RONa3wINvbHMhhWPucCQPgW0Asdxf72b/H1YmFDl43NfquqLwyYanIGSgRfmQwWvDIPoxjEA97NstBuz8yruHDa7VyBTF4C3ZPgevTsGq4BF69fkpOOiqFFrz87I+dVnDIcPOqzW+DRO805mIFXvdTN/sJds21MM0whPyBFnabjT/PlwwhAXXxoHZJqpxLfVONXL20BKgfMmVtDYrUrYZF7JQAdTJ5gaUBq+nMuLlYfUyX97ym4EMN62IYw/Ls/czcfnw4gr0eWqyPKjyDp+0RxN9X9u+1rIKxM1WoEdMB3H9SyrWHXVcO1Je/XD/LcS6pqLv6B4wLaSDsPw8ZAid22874srOOmyFbibdPWv
 dLIJOYlP
 I19svcii3lnaBedWN7xRtJ0e34XgdemVA89Nwcg/M1//lLbKCPd8LsIR0hjvbF7ImIzv0A5G3WrClawN9V/Nj37FziIitqbq+qT+IvJYVBpHlVkDC7jHYLYey+gTkx0Gkzbdt+VjptX7Gxzd6GHGAJfLUoqSGLhLAN4DIZ3JzNYRHUUbxt4XIeycYe15eq1uuneWR1vyepScb48pIjm3lqHgBJetSercTWaVeadb/BTmJyeR3J3mLNe4nOUWYZDKJSHAmSw3BL+1N+40RkNZbkcawzyGN1scc5qUM22X/jZnniZ9HEh6kZLGxEkAQZXeeYsuJMcM/Gi1I4yafP8aHW2UNh2KlJRfxfa18DIy8ipQT+lTwno9CA9DGKf4tBvXKPWF3spFQV7a5dpKUx/PDMCeDdUNx/8bUEBf2xqJJEp2QDEVBNtlan2GkgIRUfMKA0sVM0N98StrkWqvsCLt7EkI+KYdd93MrC+yVyvP2OwdXt9LluNJq+7wDElk273pKvDBa+6xxA1O7lROMSftSV7QGcfxdPprqht0eB7FXjignxUg6aQ9bBXRx6HsreZkpMG50vFACw4gokZJANIEI275LMNtw/kekmEUd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add Documentation/dev-tools/kfuzztest.rst and reference it in the
dev-tools index.

Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>

---
PR v4:
- Rework documentation to focus exclusively on the `FUZZ_TEST_SIMPLE`
  macro, removing all references to the legacy complex targets and
  serialization format.
- Remove obsolete sections describing DWARF constraints, annotations,
  and the userspace bridge tool.
- Add examples demonstrating basic usage with standard command-line
  tools.
---
---
 Documentation/dev-tools/index.rst     |   1 +
 Documentation/dev-tools/kfuzztest.rst | 152 ++++++++++++++++++++++++++
 include/linux/kfuzztest.h             |   2 +
 3 files changed, 155 insertions(+)
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
index 000000000000..f5ccf545d45d
--- /dev/null
+++ b/Documentation/dev-tools/kfuzztest.rst
@@ -0,0 +1,152 @@
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
+The framework consists of two main components:
+
+1.  An API, based on the ``FUZZ_TEST_SIMPLE`` macro, for defining test targets
+    directly in the kernel tree.
+2.  A ``debugfs`` interface through which a userspace fuzzer submits raw
+    binary test inputs.
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
+KFuzzTest is designed for generic architecture support. It has only been
+explicitly tested on x86_64.
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
+KFuzzTest currently only supports targets that are built into the kernel, as the
+core module's startup process discovers fuzz targets from a dedicated ELF
+section during startup.
+
+Defining a KFuzzTest target
+---------------------------
+
+A fuzz target should be defined in a .c file. The recommended place to define
+this is under the subsystem's ``/tests`` directory in a ``<file-name>_kfuzz.c``
+file, following the convention used by KUnit. The only strict requirement is
+that the function being fuzzed is visible to the fuzz target.
+
+Use the ``FUZZ_TEST_SIMPLE`` macro to define a fuzz target. This macro is
+designed for functions that accept a buffer and its length (e.g.,
+``(const char *data, size_t datalen)``).
+
+This macro provides ``data`` and ``datalen`` variables implicitly to the test
+body.
+
+.. code-block:: c
+
+	/* 1. The kernel function that we want to fuzz. */
+	int process_data(const char *data, size_t len);
+
+	/* 2. Define the fuzz target with the FUZZ_TEST_SIMPLE macro. */
+	FUZZ_TEST_SIMPLE(test_process_data)
+	{
+		/* 3. Call the kernel function with the provided input. */
+		process_data(data, datalen);
+	}
+
+A ``FUZZ_TEST_SIMPLE`` target creates a debugfs directory
+(``/sys/kernel/debug/kfuzztest/<test-name>``) containing a single write-only
+file ``input_simple``: writing a raw blob to this file will invoke the fuzz
+target, passing the blob as ``(data, datalen)``.
+
+Basic Usage
+^^^^^^^^^^^
+
+Because the interface accepts raw binary data, targets can be smoke-tested or
+fuzzed naively using standard command-line tools without any external
+dependencies.
+
+For example, to feed 128 bytes of random data to the target defined above:
+
+.. code-block:: sh
+
+   head -c 128 /dev/urandom > \
+       /sys/kernel/debug/kfuzztest/test_process_data/input_simple
+
+Integration with Fuzzers
+^^^^^^^^^^^^^^^^^^^^^^^^
+
+The simple interface makes it easy to integrate with userspace fuzzers (e.g.,
+LibFuzzer, AFL++, honggfuzz). A LibFuzzer, for example, harness may look like
+so:
+
+.. code-block:: c
+
+    /* Path to the simple target's input file */
+    const char *filepath = "/sys/kernel/debug/kfuzztest/test_process_data/input_simple";
+
+    extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
+        FILE *f = fopen(filepath, "w");
+        if (!f) {
+            return 0; /* Fuzzer should not stop. */
+        }
+        /* Write the raw fuzzer input directly. */
+        fwrite(Data, 1, Size, f);
+        fclose(f);
+        return 0;
+    }
+
+Note that while it is simple to feed inputs to KFuzzTest targets, kernel
+coverage collection is key for the effectiveness of a coverage-guided fuzzer;
+setup of KCOV or other coverage mechanisms is outside of KFuzzTest's scope.
+
+Metadata
+--------
+
+The ``FUZZ_TEST_SIMPLE`` macro embeds metadata into a dedicated section within
+the main ``.data`` section of the final ``vmlinux`` binary:
+``.kfuzztest_simple_target``, delimited by ``__kfuzztest_simple_targets_start``
+and ``__kfuzztest_simple_targets_end``.
+
+The metadata serves two purposes:
+
+1. The core module uses the ``.kfuzztest_simple_target`` section at boot to
+   discover every test instance and create its ``debugfs`` directory and
+   ``input_simple`` file.
+2. Tooling can use this section for offline discovery. While available fuzz
+   targets can be trivially enumerated at runtime by listing the directories
+   under ``/sys/kernel/debug/kfuzztest``, the metadata allows fuzzing
+   orchestrators to index available fuzz targets directly from the ``vmlinux``
+   binary without needing to boot the kernel.
+
+This metadata consists of an array of ``struct kfuzztest_simple_target``. The
+``name`` field within this struct references data in other locations of the
+``vmlinux`` binary, and therefore a userspace tool that parses the ELF must
+resolve these pointers to read the underlying data.
diff --git a/include/linux/kfuzztest.h b/include/linux/kfuzztest.h
index 62fce9267761..4f210c5ec919 100644
--- a/include/linux/kfuzztest.h
+++ b/include/linux/kfuzztest.h
@@ -3,6 +3,8 @@
  * The Kernel Fuzz Testing Framework (KFuzzTest) API for defining fuzz targets
  * for internal kernel functions.
  *
+ * For more information please see Documentation/dev-tools/kfuzztest.rst.
+ *
  * Copyright 2025 Google LLC
  */
 #ifndef KFUZZTEST_H
-- 
2.51.0


