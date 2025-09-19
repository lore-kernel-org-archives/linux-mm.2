Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F0FECAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 14:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54DCA8E0014; Fri, 19 Sep 2025 10:58:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE2B8E0001; Fri, 19 Sep 2025 10:58:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32CCA8E0016; Fri, 19 Sep 2025 10:58:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0ACB98E0014
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:58:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D14025A43F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:58:06 +0000 (UTC)
X-FDA: 83906304972.21.F5EF283
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id BF40AC0002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:58:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W4e5ibau;
	spf=pass (imf22.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758293884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zunbl6fvIHEqkfAd29udw7Y98ixve3unSQwmEkkt7GA=;
	b=D1h3VuE2V9YflY9JnFEdyZBsoOw7gSyzE+4TBe7QEb5ynwvhfZ/6pkjablJY61Q+EnvfUJ
	V2bJ/96s1q8hAqJdARAQqO6J3QUfwi3uKs3YrPS5HdUtFXt1yhXCq71kRjm79od91zgaty
	ftRuVynjLXzthYuuPZOB3XBbOUIdtqU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W4e5ibau;
	spf=pass (imf22.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758293884; a=rsa-sha256;
	cv=none;
	b=iL4LP5dPEes0nL9vjvFzK3max3JQeAcPDxGLxbgw8kuAb99X0aP8Fr9N/IKdbfRP1sibMC
	OPrg3zRLTUn8l/WnshjYMzbpMhA4pqlgsMD23G6//yJfmd+yGjBV7Q7oPXuxicd1KIOjQ7
	/GUoEiwq0NmS6vAGF/6PKrFSJ0SGli4=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3ee15b5435bso915080f8f.0
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758293883; x=1758898683; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zunbl6fvIHEqkfAd29udw7Y98ixve3unSQwmEkkt7GA=;
        b=W4e5ibauMtsI3f7gauAXUj/xYGwR7DNB2nCuusDCtzN7IkTcuMAO382bLp+wsOhMgI
         owHdNTTo598AHVX1WJvLZXsedgh2A11gtLbeEQ/5je+a6gYfCuyqi10Hgq8miVf6q0hc
         WRCWWJ182zmRkd1IV+46vQhZvctERuX7eG+3NELW/j+M2lMp2dAppg15+cqA6QwFzKlH
         F49j0JLa/gptRfCsayWQ1aur4GDterOkBzujti7aQODvuR76rMGytspnLLfyYogHAyfc
         B1pW2ILw564c2M4GZR4JirnZA/4G2GqNHZ0TKulWjFo9emdLtWtn4RVZdlIh/OlwVTLZ
         pVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758293883; x=1758898683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zunbl6fvIHEqkfAd29udw7Y98ixve3unSQwmEkkt7GA=;
        b=kAH0+nbXTrcpM5eFHelzSBNokHR7HNCZ2pzBSnUCnVJKFdyEM109afhgIHLs8AHrqb
         YxsZKiImGphW59M7eeXylaHSmhR20Q11fk1SurVHufjDrYQ3x4xBf7BQ6rVjC8Ryjjfi
         WxZvNqWbpOap1sKVfCcaq2RN4aUEfZCRIyEVsq6VofODg/lZUWlEVp3N2Lt4krkBYl2g
         4B0upEKXBvke5yhHQYGX992618hx60I1Q6Sv/ec1/6OoQDZ0eQ64qGg5/tLrT+87+bFG
         7tYP1mdyi5Fcr4hygc6jHXEUSoVD9Rjr/68qeo+636MbkOI+geCvx4weQPWFFL79RuiL
         aGFw==
X-Forwarded-Encrypted: i=1; AJvYcCWhNV38v53cX7MrhfebvS8Bv5zl04tnJF8rwD5cPW+q6XRwSVZGaDRfhmhotyiHU61QJ7RqLcUllw==@kvack.org
X-Gm-Message-State: AOJu0Yw+OtUaUb83yVhJe3WHsOew7K0ij1FkVFzmY/eSooRlUiwkSIr1
	6tY1avRgknkQRx7Efcfy26pf6TbqZqJPRaL6ItWWbbqeo3asfo/Xo0g5
X-Gm-Gg: ASbGncv+PQs4+X+h3LJ3oW5pg2uE/YwusLjdCJGnnIAE4q3kiUTx8fBtEEptRvivNNi
	xkOHwmqOaU6vg5s9wTJHFC+NRIQ26+3fPmO0Rm5dpNXxvCCqaEYeH55SlBU3PakVwQ4INSqPxxS
	xLG3pp/bUyKLXfEsjGIoP2cn50JQ3DurWpgWZJR7R82+Vzm2R2SpCGEPz10l+iWK6blei8YU5HT
	rhzY9sjLWGSsI2oaziysNWLsjyJGD4lNTYTiCKrLz39jQLv4ld3Wc1zMczuHcvd2/0y84vocQvK
	JImYTN+KrISaFK/PAlxTkpF1cZweib87Tvt86nQXGssc30B+AeJ4zgbf6GH97qWzsF7t5TarAn9
	xXMNS62wyn3fg4Js2vqOefweNUcujAJdEXmUjZAzjqACKO7eCovz+gNtVuGOf89t+MIMSIfZfCY
	hFfMul03pT7gZ3Sao=
X-Google-Smtp-Source: AGHT+IHDjt8O9vYKO4IAKnSZVCkSqLzYQnMnHfcy6YqHFSDHgfMy0UALYGdy8mo3Zt+AM86r0DMwnw==
X-Received: by 2002:a05:6000:2408:b0:3ee:15b4:846c with SMTP id ffacd0b85a97d-3ee7f606f17mr3174553f8f.28.1758293882976;
        Fri, 19 Sep 2025 07:58:02 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (124.62.78.34.bc.googleusercontent.com. [34.78.62.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7188sm8551386f8f.37.2025.09.19.07.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 07:58:02 -0700 (PDT)
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
Subject: [PATCH v2 05/10] kfuzztest: add ReST documentation
Date: Fri, 19 Sep 2025 14:57:45 +0000
Message-ID: <20250919145750.3448393-6-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
In-Reply-To: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BF40AC0002
X-Rspamd-Server: rspam05
X-Stat-Signature: q7kho6qbjxg5u6uxrrchy8wndngtzuba
X-Rspam-User: 
X-HE-Tag: 1758293884-602241
X-HE-Meta: U2FsdGVkX19B3+gOGhFhmsiptYwyw0KS6reRptur5pgX8WZMGL5uj4nvc6Vhu1qD/AQi6Rcywqh7r8arUYM5Hg7WHeFQ4XUL1N3kYDJHchEz/UvsxB0S7TMaE+q2KR2F8UN8P32pNFKt4NDeO/10Svc7vkd1NqIMviq5AggYOpwx/mcXmE5WniEtZdCXAsaoFcIqXw5czQoUsZ8A3QCu6+l3SVrroG4SW9KrPeGcZHthLMMjatEYjxsYOduIv2wOqHznRgahTPC46ahvFzbqGp80dzqKVSlkiI61yEr3rMzsPqlKFx0AtX5u/dmEd7tVl5I/YXwFXS47l/RYLCVFrpJRFO6h1Df31Tnj1/I5CJ5FmUZzFuOnPLBXKCMo2+nWIXrFJOy8pYtcAzbOAIcG65XNJBDS60AhH4Hhs+qpsNKJveDV/tXvuTD2f32AUStPmwkX3Ja5ULHz5aQ1PBLUXW+FyZIXCjcxApGEWesP1ItvcIoVZ4n38H8fH5XPyxlGdhuFob6OJusvDPvu4ZyDUGDgVXrZD+hKpqPn9Mhqp3zzV+6KQWI30sgwHqoPROBndk7iQbThKtS2KF7Js2LI16GJN77HEdk807vc/hdmAvsSJSsaZJTHKPa89tZlXyNXshZh0jx3SkSZoQVrMGgQ+XOPx/pojG6GuaKwwP+LU4/5Xd5nZjjtGnWJQ8IZShnEGGBgBZgs/BkMDsBqRwOPxtZlF5HnWn7mDzpthcrdgHh5+aZcKBadlcUZhRH0iaaiQL4FrBEAJ7/d7vcLbhAVFb1gSK+As+S9YQogwrPadDaTzW6XwWxX9dcH35k2qJjscHsvlZCSoiPhF5RKqMaIieUadRW8rBIfrQ+Pk5eGPfUtrBmNjc2gfXfZ0UyB78tQb/B35YjOwL1xT9l+nhCmOOk1dEVIrMfJ+Jay6eCR1Lrsvs4MBsbkJtVb8PwUBAcy+qslE02d2s6Oe0Gpyre
 sjsCTDAm
 kX/OlZ03K/pAFQbDsYFQV7WSWy9zE/jUjmFApCf11GyYpLckew9jle+Y465JscSU+M/MdIsA0htZUx6+WHAPVQolmyBB7HK96KC/DGOtFst6bhjPz871DgTv0BDq5++dQDDI9hvfhYFM9jt30strvzjFfuor41jPSrH6pKYLOe5vGl+xiIm+MtzDZfJEkxGRwmbWgJAGt9mWwZibvPSWtRU5m3HNYz0qyl3gi9czF3Vk4rb+xM7s5pqFLbOjUIHZHNIP+/x5GrWlGKu2colYMe+g1UN+R+haCDHjJNFtnKoEzNvJHjep/WhWwQjblhkFcBeJMV64EZxR+tV4yiAw3QjVLBqe4IU6Su4NhvW6u3+t1jmjWp/r5aK3H0E7kEUU8b9gjuq3buhkqbIDXyk1ZCXs1cH38DA1cYKuA4GX/KIFE7n1bjSmOY0Md6NL43351iVz8AKVRoMRjg/VsnJWf/ICd+Q==
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
PR v2:
- Update documentation to reflect new location of kfuzztest-bridge,
  under tools/testing.
PR v1:
- Fix some typos and reword some sections.
- Correct kfuzztest-bridge grammar description.
- Reference documentation in kfuzztest-bridge/input_parser.c header
  comment.
RFC v2:
- Add documentation for kfuzztest-bridge tool introduced in patch 4.
---
---
 Documentation/dev-tools/index.rst             |   1 +
 Documentation/dev-tools/kfuzztest.rst         | 385 ++++++++++++++++++
 tools/testing/kfuzztest-bridge/input_parser.c |   2 +
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
index 000000000000..0c74732ecf21
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
+The tool can be built with ``make tools/testing/kfuzztest-bridge``. In the case
+of libc incompatibilities, the tool will have to be linked statically or built
+on the target system.
+
+Example:
+
+.. code-block:: sh
+
+    ./tools/testing/kfuzztest-bridge \
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
diff --git a/tools/testing/kfuzztest-bridge/input_parser.c b/tools/testing/kfuzztest-bridge/input_parser.c
index b1fd8ba5217e..feaa59de49d7 100644
--- a/tools/testing/kfuzztest-bridge/input_parser.c
+++ b/tools/testing/kfuzztest-bridge/input_parser.c
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
2.51.0.470.ga7dc726c21-goog


