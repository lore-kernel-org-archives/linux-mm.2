Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60C3ECAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5612A8E0015; Tue, 16 Sep 2025 05:01:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C34F8E0001; Tue, 16 Sep 2025 05:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33E6F8E0015; Tue, 16 Sep 2025 05:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1277E8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:01:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC62E1DFC38
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:27 +0000 (UTC)
X-FDA: 83894519814.19.AFB83EE
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id C2919140013
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DstBVxvV;
	spf=pass (imf23.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758013285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gp0wKR4UFIJ4rSEY85b8LtOArZzZXgf5YyWmJJ8KcKg=;
	b=uyQfFPzRl4dH9+lUnyi5M0FN6/PcalUmpCr6s77GdapQNDkgfLUQGmP4zM4wq+CeQPrzyH
	w+DZ6bOPYt4OPZaFhV612il7pbQDJ5cDz3nQdSWvp4XtCAh2oQy7KHbgHiicEquPDCJQ8M
	hFI1jsTvPgVdnrAGcPpGmmYg/sIqmGg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DstBVxvV;
	spf=pass (imf23.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758013286; a=rsa-sha256;
	cv=none;
	b=NLLXDeQYmTGEa3Rbjuov+5ZV416BHm41IXqAL5HDsHDO9Vl59Hz8xHTvTGTizKCle34trs
	6YmziE4c+QOFLFfMRS6IvvzA9cgZbYRf7EgdDxmiZZeKeMS61AV6LdOeb9sSCXcDoF1wC4
	9DRrcL4D44qIK77HIYAT0ng6WisKLxo=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3c6abcfd142so2527614f8f.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758013284; x=1758618084; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gp0wKR4UFIJ4rSEY85b8LtOArZzZXgf5YyWmJJ8KcKg=;
        b=DstBVxvV779hfmwJ5b8JBpeiuhxCUt6hxVwd2pEXkoZFH9FI6iIFnvfsjhS7lCFchU
         jKcmbv9zknzZjA8h9RyScwU/db0DR9nNC1WehIU7GhdcyTtGv0FgFlnjeSWhITft3vaM
         t+Aksg8ItIeqZ2NBDl7q39OizpCtT/DKk4t7Ax647MNI8ewh0AW1lLBfVdlwLXud0o6N
         aaPTrz5gMQJp4qCSJR228lkX6rLQv/ckTrJPHBSeJstqQGorXXq/v7uYjRRGYv2kP1wf
         nt8b3rUJXOyqGStvm9gAAvLrdGY8ZaCiORp7qNkftycqaC/ulAAxEQ/Ftyz5nb6uM5HR
         6vxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758013284; x=1758618084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gp0wKR4UFIJ4rSEY85b8LtOArZzZXgf5YyWmJJ8KcKg=;
        b=nELhXFtLoo4lIF/WlsxymjkwUHJoX47FXvIGjNXeMNZaABTBt2ozWYyDMFbgJ2cVXD
         R3chfDT8LZEyuuY5Lz7bl2emgXa4Pp3eCF9sDk7Kj+Q95z4fFddh92w3g2TIAZCmcYaQ
         04fwTzWEurSljjb2uhftNa5z1fYbSUG6epq0RGVN6PwxDudUACmJ4AvRuTO27yknRNaJ
         0oMRsw1xh8Ny4PelgngXbT8n3+pYBDTY+6d4lNBrdxtpfTc1Oxwuu9ExnLV7MMW1+Xow
         U1Ld3XNRoYqfyd+7ShrvDgcFX+CCc/02ElwatQ16fFiVSi7QOoDJ3/ir6wCQzd2JasbZ
         /8Vw==
X-Forwarded-Encrypted: i=1; AJvYcCUJHSr5HDUfVqQN/dEzgUVJ7VLQasQzVhjOvNPIz0Kx5kCWvcGoFYcNenJIodfK3hcEnlUJ1achaA==@kvack.org
X-Gm-Message-State: AOJu0YxR+/RPWtmxn+fda/Yhw/h5tmE3VlcAQihDE6C3AeAgN0FjYWfr
	rmoq1AGwhPNjIyRPcHPLsntLd4Mw0XoNsC4lQaDj9HFE2KH6u/lAONC9
X-Gm-Gg: ASbGncvxo+BCTp+gZXHHkFhmi2uKs+vZw2umfFGhGINtmQ0jiPPu4NNh2W2AZTNIeXo
	9Iz4jOt/wmTxX0Z02e8d9a32vbqL7D0HQ0YQlyNzRbBdUb9Cf/tjS9MFMOaq1eAJ2Dc5pqNGpqF
	pLD6tNnkmtPv88jOJro/fcPBADBvo83WWNQLpb81iS7VwsWR/U5aOBlPINiAGh4DPmj8iNSh7Za
	xCTlbo57ezgjCoEWHHnZiMNGevgMoEAaWu1FZAdFmc8eRsMOVlwPepJbPOi3ovu5HBwmBUl6mTK
	oLzp3NCVqYWwRr2Zf9LVKCArMHOyBMVFd53RWYxNfObXKHnsmvRUdDIIDRzS+AK+itWjfQul4jm
	ut5fnLs5sV3sPqjA3qTk+4Nn8ps/Osh7Vnq3814TH5MvDJwglcJZV1xgKOjRk4wSqqAod4sZY2I
	Xuh74w+0Ov76NIXzpV308Vdvo=
X-Google-Smtp-Source: AGHT+IECYEVT+4NUMePnPgixjF27SaVvTspbPgjy11IykssMepW6K3zQTMZ+/tQgCpK6vho4jpgLTw==
X-Received: by 2002:a5d:4105:0:b0:3e9:d54:199f with SMTP id ffacd0b85a97d-3e90d541c27mr4925951f8f.32.1758013283923;
        Tue, 16 Sep 2025 02:01:23 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (42.16.79.34.bc.googleusercontent.com. [34.79.16.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037186e5sm212975035e9.5.2025.09.16.02.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:01:23 -0700 (PDT)
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
Subject: [PATCH v1 05/10] kfuzztest: add ReST documentation
Date: Tue, 16 Sep 2025 09:01:04 +0000
Message-ID: <20250916090109.91132-6-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C2919140013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: mi3sz8gs3mtjfhnnzkg434iemwnahocd
X-HE-Tag: 1758013285-661303
X-HE-Meta: U2FsdGVkX1+CQVw/1n8rJsGM9/wcf0GtBfMFddSF1SMkX4ngGXIkMxmj3TuGEvyAhBTvqxwwMYdwRUCsNQCNbCggg0oYj5UqMK2ci/BxNsL6tdHiaCLUAN2SQWTx7JsLoQWnTThLmyQmErbHTLuQ9RLRv6gP1Jzl8E1LT+lLM3y8XR00c+lBKVmYLdocAD1IjwuRAaBbByy7MA7T+j8DZeMCPx165Fi+wUafPYnA7895L3OGYU9DHpm8UR1TN/xMQj9rfCxbnnh+QNBi5TAJpj30cDPajR1Ri68STV/DSD98N0RdswMeumN7rcpCkEWYrBz7YlrZ8bU7S/KXZ/kO1ElLrbc6/JTBBvPOKzbYDEC61kaSLqJp5qQaCoMSNrWzJ91ZRmEqTIC7GN6gU9iOJ5O3hYzpnIpgGi/87ExqNZmoyjV7m4Ck/lAqY97+a8tHjcO7VDY4iH0qk9w3CWJdwIKBJlq23mhMqmZ+frZutwzsATwcrHUQrlAtlVRBs6BT2RkF1jBnSt+U2CZJOdWKLkTSPHIl3T+SJK3skPaA0bqsqNty8OWUxRwUXHXpl/HlCipVspNxKpBis80CHGpcmMm7eEvH074XN9NbGHqQAh9jvVdOvgyXDKS4iE0yi6Q1vs7L89q1Py0UFIJHMaZhDo+/80iOAIan+HlTJpsqcZT5UYyY6AcW9wiyrGklAdjhyjppg4XD6gr77bhLQxnVXqdIOGKaUKUbmD0snVYRvX77KurUAghKPobehk4Ex7vSsDrxUrkPpIXUm5x2nv+h3ZWSAvHltED7gJdLuHwFUjjmKy3V7vRHWv3/loZNHxLoE0XHcdejJWwSnvx61J1dav9HzkhA7RU+pQQBdFHSMMQAkg5oXJ5m0guj/oQBS6vhKtJ/p1ALNnTeZJmrlDbf1HmY+Tnw7aQka6FV5e+iWdr+Tf1nOLuKYUcNWfHZQMF+2qwj/ADkMpL3Hv/aTcL
 MvyU6T2i
 IblQD3dTg+GwUNqteqGzgWL7n8VIswAreh4LUXXw/VACZekJvf6HKZ7IbnP/0upFCS8kpJq0kb51g3+GFFnR3nKkfSMosFZ6ma+rhLzpFM0bEbCUd9jFrsNmq4yZe5jhPkpEF7LSH6Giw6QGtswrnlYPQ7n0SJiiIfW0mnYP4Y3RYXitPzbX2BAHRLPugu260PZe8qIJQuB4sbkmBYcc7lO2SQwe3u4SMia1wVqDXsjQxchvo9qtWxwaInK40LuYpbgWjPNYrKLdzL/JTvvLlHj0nZ4jU9/AzcJfp/PSaK5peYJxDxy0n4kJvRDi+LGcaMoZ6HAnMVP8sgjDtlDHuyxE0orAoBkF2lYGVn8ltGX/QBJQ5Jb5WkWE5j6lLkx0iLdRUgYHR4M11PjEp0Z9C6YPTRJkjmMWd9b6TY+cp6G0iwaHkkR4wal97GA==
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
Acked-by: Alexander Potapenko <glider@google.com>

---
v3:
- Fix some typos and reword some sections.
- Correct kfuzztest-bridge grammar description.
- Reference documentation in kfuzztest-bridge/input_parser.c header
  comment.
v2:
- Add documentation for kfuzztest-bridge tool introduced in patch 4.
---
---
 Documentation/dev-tools/index.rst     |   1 +
 Documentation/dev-tools/kfuzztest.rst | 385 ++++++++++++++++++++++++++
 tools/kfuzztest-bridge/input_parser.c |   2 +
 3 files changed, 388 insertions(+)
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
index 000000000000..2dfa50f35a01
--- /dev/null
+++ b/Documentation/dev-tools/kfuzztest.rst
@@ -0,0 +1,385 @@
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
+section during startup. Furthermore, constraints and annotations emit metadata
+that can be scanned from a ``vmlinux`` binary by a userspace fuzzing engine.
+
+Declaring a KFuzzTest target
+----------------------------
+
+A fuzz target should be defined in a .c file. The recommended place to define
+this is under the subsystem's ``/tests`` directory in a ``<file-name>_kfuzz.c``
+file, following the convention used by KUnit. The only strict requirement is
+that the function being fuzzed is visible to the fuzz target.
+
+Defining a fuzz target involves three main parts: defining an input structure,
+writing the test body using the ``FUZZ_TEST`` macro, and optionally adding
+metadata for the fuzzer.
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
+		 * 4. (Optional) Add annotations to provide semantic hints to the
+		 *    fuzzer. This annotation informs the fuzzer that the 'len' field is
+		 *    the length of the buffer pointed to by 'data'. Annotations do not
+		 *    add any runtime checks.
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
+Macros ``FUZZ_TEST``, ``KFUZZTEST_EXPECT_*`` and ``KFUZZTEST_ANNOTATE_*`` embed
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
+debugfs file ``/sys/kernel/debug/kfuzztest/<test-name>/input``.
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
+as the arg variable to the ``FUZZ_TEST`` body. Subsequent regions typically
+represent data buffers or structs pointed to by fields within that struct.
+Region array entries must be ordered by ascending offset, and must not overlap
+with one another.
+
+Relocation Table
+^^^^^^^^^^^^^^^^
+
+The relocation table contains the instructions for the kernel to "hydrate" the
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
+- Region specific alignment: The data for each individual region must start at
+  an offset that is aligned to its own C type's requirements. For example, a
+  ``uint64_t`` must begin on an 8-byte boundary.
+
+- Minimum alignment: The offset of each region, as well as the beginning of the
+  payload, must also be a multiple of the overall minimum alignment value. This
+  value is determined by the greater of ``ARCH_KMALLOC_MINALIGN`` and
+  ``KASAN_GRANULE_SIZE`` (which is represented by ``KFUZZTEST_POISON_SIZE`` in
+  ``/include/linux/kfuzztest.h``). This minimum alignment ensures that all
+  function inputs respect C calling conventions.
+
+- Padding: The space between the end of one region's data and the beginning of
+  the next must be sufficient for padding. The padding must also be at least
+  the same minimum alignment value mentioned above. This is crucial for KASAN
+  builds, as it allows KFuzzTest to poison this unused space enabling precise
+  detection of out-of-bounds memory accesses between adjacent buffers.
+
+The minimum alignment value is architecture-dependent and is exposed to
+userspace via the read-only file
+``/sys/kernel/debug/kfuzztest/_config/minalign``. The framework relies on
+userspace tooling to construct the payload correctly, adhering to all three of
+these rules for every region.
+
+KFuzzTest Bridge Tool
+=====================
+
+The ``kfuzztest-bridge`` program is a userspace utility that encodes a random
+byte stream into the structured binary format expected by a KFuzzTest harness.
+It allows users to describe the target's input structure textually, making it
+easy to perform smoke tests or connect harnesses to blob-based fuzzing engines.
+
+This tool is intended to be simple, both in usage and implementation. Its
+structure and DSL are sufficient for simpler use-cases. For more advanced
+coverage-guided fuzzing it is recommended to use
+`syzkaller <https://github.com/google/syzkaller>` which implements deeper
+support for KFuzzTest targets.
+
+Usage
+-----
+
+The tool can be built with ``make tools/kfuzztest-bridge``. In the case of libc
+incompatibilities, the tool will have to be linked statically or built on the
+target system.
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
+	region     ::= identifier "{" type ( " " type )* "}"
+	type       ::= primitive | pointer | array | length | string
+	primitive  ::= "u8" | "u16" | "u32" | "u64"
+	pointer    ::= "ptr" "[" identifier "]"
+	array      ::= "arr" "[" primitive "," integer "]"
+	length     ::= "len" "[" identifier "," primitive "]"
+	string     ::= "str" "[" integer "]"
+	identifier ::= [a-zA-Z_][a-zA-Z1-9_]*
+	integer    ::= [0-9]+
+
+Pointers must reference a named region.
+
+To fuzz a raw buffer, the buffer must be defined in its own region, as shown
+below:
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
+Here, ``n`` is some integer value defining the size of the byte array inside of
+the ``buf`` region.
diff --git a/tools/kfuzztest-bridge/input_parser.c b/tools/kfuzztest-bridge/input_parser.c
index 61d324b9dc0e..e07dcb4d21cc 100644
--- a/tools/kfuzztest-bridge/input_parser.c
+++ b/tools/kfuzztest-bridge/input_parser.c
@@ -16,6 +16,8 @@
  * and its corresponding length encoded over 8 bytes, where `buf` itself
  * contains a 42-byte array.
  *
+ * The full grammar is documented in Documentation/dev-tools/kfuzztest.rst.
+ *
  * Copyright 2025 Google LLC
  */
 #include <errno.h>
-- 
2.51.0.384.g4c02a37b29-goog


