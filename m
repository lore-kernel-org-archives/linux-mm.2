Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C828ED206A8
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733836B0098; Thu,  4 Dec 2025 09:13:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696A46B0099; Thu,  4 Dec 2025 09:13:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FF0B6B009B; Thu,  4 Dec 2025 09:13:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 172026B0098
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:13:17 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6160129FA
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:13:16 +0000 (UTC)
X-FDA: 84181980792.29.F73C7C4
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id C15E980006
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:13:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P3k6phPz;
	spf=pass (imf30.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764857594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xndrRWaQq8ZqeofXDWgQR27UXFeqwFVKyIppt/mk6wo=;
	b=oy+ieNl0A4ODyj6G7U/y+kR69toIxSBEKqrOm0U3DaGQYUH5tPLNNwQ9m0460UHT8xQI4l
	ZDk5P6G53HpWn3APdsOypBrpQZdXV+4mFNgG7QAnjA7NWheShwfIP5Ba2lyZ7artTTe6fI
	9WLS62pp13maWQrrH4eb9QfIG6sDPs0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764857595; a=rsa-sha256;
	cv=none;
	b=I9PLR5WYeVchb4qWjwUW2FQmJx7eoGpPVev8Zwsf6kdhu8L488P7D537qVBMtK91VWr7zC
	aCel0E4rhNBvdmJQbCKLrlxUJSLQ2DWSz7+PBdhqiMaGAJtTvBR96dmkGjPSrmXEESTVrb
	Rz6E5fcN7cR2mBCfcDa11YpH4+qCezc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P3k6phPz;
	spf=pass (imf30.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47796a837c7so8067605e9.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 06:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857593; x=1765462393; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xndrRWaQq8ZqeofXDWgQR27UXFeqwFVKyIppt/mk6wo=;
        b=P3k6phPzKzNZ7wblgbnhx+1IKe6Sn869YL9IYRnzswe0KCNu2YfFGGMGgOC+uM8v7I
         EIYRxztdXF01gss5omlYuRgKAD4s8vTiP5p9ldfSEAxRDNekDgY9fYlwJHrU2RInyosG
         c8K7TkojifSiHOQjvg2MZaXei8VMFcGj+IJLA0zeC1HcP1uNv+7+dapKX+RJLG1yvRjN
         fisSEIECDAvz/vGCiLOLOQeWp98ewHltEoeGvqytRPTO0Zwg6Sb9PIp+ahKUBgMrsxNn
         25b/K7DewU2KEcIuW35/NHvCKziBMHEBwWx3QNQEvmOkiY7MYZoMplBgBqLAVOSEOLPB
         yUKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857593; x=1765462393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xndrRWaQq8ZqeofXDWgQR27UXFeqwFVKyIppt/mk6wo=;
        b=aOtyEy6KuBQpDKPAyIGGzBh1AdYBOFaQ4FqqINj/wzvGTQ0Mjros4hiNZX8qGBDIsf
         ItmRiQwqQXZgWmaB+GbM4KiAn/3vFAyyoLWcekvzXLdzuESusiw3Ig8j5EIPETxnLE1g
         OXolOo2m+U1i7WsHVJL+yWx+trtn+028BIdHGFqmyWlQ96nSPcKFnVLbU+0+n4ou5xi7
         2moU2qNIBOqK0oiMeKgxf+QyqOd2lRY30aW0q1+AArPjTrZwXLH1heQxqjEAceVD4ccb
         EtqpS5ETdgTKaRbb7i1i/vL9MxUXVcbZnaHiECLrQfL/M+YKwV5ilfBwR8MkP8wWh2nf
         NT8A==
X-Forwarded-Encrypted: i=1; AJvYcCX7YYbW+af8QtnysAWJTk+Ph2I7lRoj+708DkdBdLKNigZ8tGt+5p/lE78U2qUsNb6uWF8OR0W+aA==@kvack.org
X-Gm-Message-State: AOJu0Yz1wlmBUDLl4G+Pd4J3k1Xkod5zJwot71Ra52d3YKqg8J/AKwjL
	LnrD4QUSJ4aWlL1Wzk4CMg0tMm+lChKoXYwseLgVyVXvqrDOwhIv3KBz
X-Gm-Gg: ASbGncs3AZHRnIx8UeNodJ03EfsKF2QK1f579UbZDBy2FvJbRcRGxUrui+Hc+TWG4mv
	e9qT6Lw/Hr2OT3hakHZAorTmP3WbE3eJgOGZqVw+Ru+94jtv4Bj6DLqQ05Oq/clDm6satXt6uhP
	pGWMEAGuoOIY5PjHwZA8PVt3UsyqgoCGj9LctNNcp+N3O0D0iY7jEEbiPN4gv83Frapmjmh8OQh
	KssW5wi9rtfp3cGsrtJNf3helGRSj/g38PLyCWzo54ie1tJU8/luvIfDKo8jC7BDQZCiyrl1zTV
	TctSJV7J8GXRCzjdZdRSOiJqhnpa/TIvwsJBXKglJBBUBKtMZD2r0bGaVeOkTfyDjtCwAFtDVlm
	wNTYwabJ009/yGFAE4jYJNEmW+YEwcVdBTCls4Qhl4wqcn0j+YNJknF0Yx/Cs6TeOMiGUNlnob4
	4uc1syUCPNAJpPIK1DxFWlogNhmpi7ogNIflhqrarNzQ7ckKeSDjlNSxNe5hS8w24QYg==
X-Google-Smtp-Source: AGHT+IFRhbDpKasWwWYApVFuMv54Qu+HdfdLgM3pZb5GDC8G6Y67aS7ROE6sKmsj8vcmza2Czs/5sA==
X-Received: by 2002:a05:600c:3588:b0:479:1348:c61e with SMTP id 5b1f17b1804b1-4792af33a39mr69461685e9.20.1764857592964;
        Thu, 04 Dec 2025 06:13:12 -0800 (PST)
Received: from ethan-tp.d.ethz.ch (2001-67c-10ec-5744-8000--626.net6.ethz.ch. [2001:67c:10ec:5744:8000::626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3605808f8f.13.2025.12.04.06.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:13:12 -0800 (PST)
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
Subject: [PATCH 06/10] kfuzztest: add ReST documentation
Date: Thu,  4 Dec 2025 15:12:45 +0100
Message-ID: <20251204141250.21114-7-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C15E980006
X-Stat-Signature: 5d84nemf34r9a1pi3adxqyyfr9pmwbge
X-Rspam-User: 
X-HE-Tag: 1764857594-639681
X-HE-Meta: U2FsdGVkX19ih61Zj60kytYSeh9NZ0R/vjnKSM8gbLUOaXtvHm2g0H7SZIg0N1Bb/9hMWvW7h6oYFhjRrxB/aY+sZgI9LdoHudZzQgCLY/Cyad1A+NezBV+cQGXMAPgmZcrifZQLOq1DMWs0+EUawiQ/TA6IU3KVz3zlkqpnykQFBFWoiQ3WfEVcNQZXZYQx5g/N5/gJlA5C6korU7r0+q/Cx/ecDPugMK3UF/WTNd3HFo6nbGyAbgnxwQadEUb6gHQnp/2I+93ZHsO0wf/w/b7uGvEIeZLPC9VqpphM8NoTlsVetcl+dDmKxXbtl6YOxWck7dtREU6+H0tkWQC+xGrJUyWejVH1l3C8MT6T05Lce9HLYb401bPu0RJO7HxmpR0pNdq9zs9DHZ7QPYpyPFkvKFrSc/u8zyiXYMXthZI9D+j4dQZcBJIdx45kW5KJl76pi6IxuPJpDaCCQzPjahkiUSvURMUMSHir2H7zPhPCXHMMDei8nSZg0sJcvso4PnAC1KfsleKZbYglP/gFRI9/YrhJQ/zf5LQrD687A1al2kCuS9Vmtp/Fsx54llcf7bsVVgEgy8w16Gcv0apW+dHNzRYSQ4kdkuAPAqpzjdJO/IJDdCzuCBHPbW8PmDynxqDEWUrXLnzmFkDHdp87M3Ch4IXvX7n7GhcmFFh6r1r0TK0NIaC24vwF61qjtbNpftuqHVvkBUCWAE19F08XpUy6Z9F2eeg8IK5P0iAR+XAa8ZgBNE3tpkiplfHX7l6TfSzZVPa2dZa2odfFFUoG35MSROBgIRMzFS4A8/B5fpDcRRBHjq8bg6Ey/uU1Jk7blqqbEVp96Ly7N0ebybl6Gkj0MkovWxPvPFmqOfEmh4y0kzP9xkM7mTuvfa1aIPHmrCv9Po1N6ttfs4o7Ee3MQAz7zSjoZcSYGx7WAba/6qiUVkEAnovu06NyR+IjuQAJoSH831AHEhslXMS+rBJ
 U6cgJMSB
 mpBa5VbFYFXXw8XV0B1698enC9h2goOXGo1Ye6e06+lv57taTqWd3jjzll0lg93606i+kYzBThLca6QMlsIDUgIiNrEz8tX/hNLaBtxHRW0JYKB2dO/Rrw7BazBek4D6vnCp82xVYzbuvSdDTVYA9mzj4zCn2XLplmx04wgchaNNShzpMxUZRaHRBab83WimkRD+NWUPqcwAjxAdyTM8+JxJMVmAZb/06jzSoasZ/JwWmrWNgjgk+ba2DaFcpOI7ybI2f3PhLP50NOoQ+afvrXDXZKUw0o84CjfGQzl0Tp4yirYAl/jBrg6ntq1reFZ14Er2U1Yd1S5JJzZ89gRpngMAKWdJWHJYysYZFHV/i2siW8M2TQciRrNlNDXwlkUhN3X6vRXh9ZKMwjSF68+Lo3bcCvsOcrJ0x/BPABB7Kav8n5CofsUlo0Seb/Q8odmpZ2Ntk0udx4je19FQdoEUO5WsXLb2heIJG3acNV9YxK6t+0AW7L3HDM/wrlO+KyYf4CbNhbmwOvrBL545KjgyrxLl7drm8cbhPlpbRQlWSslhkjDGpKbYOiqfAtoewM7fAJOkbdGxrqs90naMoiJMQqYtpMsc+mqLgm0qHKxAIPD5leR9+atzjQ8qUgQ==
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
Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
Acked-by: Alexander Potapenko <glider@google.com>

---
PR v3:
- Document newly introduced FUZZ_TEST_SIMPLE targets.
- Rework the flow in several sections.
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
 Documentation/dev-tools/kfuzztest.rst         | 491 ++++++++++++++++++
 tools/testing/kfuzztest-bridge/input_parser.c |   2 +
 3 files changed, 494 insertions(+)
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
index 000000000000..61f877e8bb10
--- /dev/null
+++ b/Documentation/dev-tools/kfuzztest.rst
@@ -0,0 +1,491 @@
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
+1.  An API, based on the ``FUZZ_TEST`` and ``FUZZ_TEST_SIMPLE`` macros, for
+    defining test targets directly in the kernel tree.
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
+KFuzzTest provides two macros for defining a target, depending on the complexity
+of the input for the function being fuzzed.
+
+- ``FUZZ_TEST`` for complex, structure-aware fuzzing of functions that take
+  pointers, nested structures, or other complex inputs.
+- ``FUZZ_TEST_SIMPLE`` for the common case of fuzzing a function that accepts
+  a simple data buffer and length.
+
+Non-trivial Fuzz Targets (``FUZZ_TEST``)
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+For functions with more complex arguments such as nested structs, multiple
+pointers, or where fine-grained control over inputs it needed, use the
+``FUZZ_TEST`` macro.
+
+Complex fuzz targets enable structure-aware fuzzing, but require more setup,
+including the definition a ``struct`` wrapping its parameters, and optional
+metadata for the fuzzer.
+
+Defining a fuzz target involves three main parts: defining an input structure,
+writing the test body using the ``FUZZ_TEST`` macro, and optionally adding
+metadata for the fuzzer.
+
+The following example illustrates the 6-step process for this macro.
+
+.. code-block:: c
+
+	/* 1. The kernel function that we want to fuzz. */
+	int func(const char *str, char *data, size_t datalen);
+
+	/*
+	 * 2. Define a struct to model the inputs for the function under test.
+	 *    Each field corresponds to an argument needed by the function.
+	 */
+	struct func_inputs {
+		const char *str;
+		char *data;
+		size_t datalen;
+	};
+
+	/*
+	 * 3. Define the fuzz target using the FUZZ_TEST macro.
+	 *    The first parameter is a unique name for the target.
+	 *    The second parameter is the input struct defined above.
+	 */
+	FUZZ_TEST(test_func, struct func_inputs)
+	{
+		/*
+		 * Within this body, the `arg` variable is a pointer to a
+		 * fully initialized `struct func_inputs`.
+		 */
+
+		/*
+		 * 4. (Optional) Add constraints to define preconditions.
+		 *    This check ensures `arg->str` and `arg->data` are non-NULL. If
+		 *    the conditions are not met, the test exits early. This also
+		 *    creates metadata to inform the fuzzing engine.
+		 */
+		KFUZZTEST_EXPECT_NOT_NULL(func_inputs, str);
+		KFUZZTEST_EXPECT_NOT_NULL(func_inputs, data);
+
+		/*
+		 * 5. (Optional) Add annotations to provide semantic hints to the
+		 *    fuzzer. These annotations inform the fuzzer that `str` is a
+		 *    null-terminated string, that `data` is a pointer to an array
+		 *    (i.e., not a pointer to a single value), and that the `len` field
+		 *    is the length of the buffer pointed to by `data`.
+		 *    Annotations do not add any runtime checks.
+		 */
+		KFUZZTEST_ANNOTATE_STRING(func_inputs, str);
+		KFUZZTEST_ANNOTATE_LEN(func_inputs, datalen, data);
+		KFUZZTEST_ANNOTATE_ARRAY(func_inputs, data);
+
+		/*
+		 * 6. Call the kernel function with the provided inputs.
+		 *    Memory errors like out-of-bounds accesses on 'arg->data' will
+		 *    be detected by KASAN or other memory error detection tools.
+		 */
+		func(arg->str, arg->data, arg->datalen);
+	}
+
+A ``FUZZ_TEST`` creates a debugfs file under
+`/sys/kernel/debug/kfuzztest/<test-name>/input` that accepts inputs from a
+fuzzing engine.
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
+A fuzzing engine that aims to effectively fuzz these targets must implement
+the following:
+
+- Serialized inputs following the format introduced in the
+  `Input Serialization`_ section.
+- ``vmlinux`` metadata parsing to become aware of domain constraints and
+  annotations.
+
+Simple Fuzz Targets (``FUZZ_TEST_SIMPLE``)
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+For the common case of defining a fuzz target for a function that accepts a
+buffer and its length (e.g., ``(const char *data, size_t datalen)``), the
+``FUZZ_TEST_SIMPLE`` macro should be used.
+
+This macro simplifies test creation by providing ``data`` and ``datalen``
+variables to the test body.
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
+A ``FUZZ_TEST_SIMPLE`` target creates two debugfs files in its directory
+(``/sys/kernel/debug/kfuzztest/<test-name>``):
+
+- ``input_simple``: A simplified interface. Writing a raw byte blob to this
+  file will invoke the fuzz target, passing the blob as ``(data, datalen)``.
+- ``input``: Accepts the serialization format described in the
+  `Input Serialization`_ section.
+
+The ``input_simple`` file makes it much easier to integrate with userspace
+fuzzers (e.g., LibFuzzer, AFL++, honggfuzz) without requiring any knowledge
+of KFuzzTest's serialization format or constraint system.
+
+A LibFuzzer harness may look like so:
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
+Note that despite it being very simple for a fuzzing engine to fuzz simple
+KFuzzTest targets, kernel coverage collection is key for the effectiveness
+of a coverage-guided fuzzer - this is outside of KFuzzTest's scope.
+
+Metadata
+--------
+
+Macros ``FUZZ_TEST``, ``FUZZ_TEST_SIMPLE``, ``KFUZZTEST_EXPECT_*`` and
+``KFUZZTEST_ANNOTATE_*`` embed metadata into several sections within the main
+``.data`` section of the final ``vmlinux`` binary; ``.kfuzztest_target``,
+``.kfuzztest_simple_target``, ``.kfuzztest_constraint`` and
+``.kfuzztest_annotation`` respectively.
+
+Note that simple targets defined with the ``FUZZ_TEST_SIMPLE`` macro implicitly
+define a ``FUZZ_TEST`` to maintain compatibility with fuzzers that assume
+structured inputs, allowing both target types to be treated as one and the same.
+
+The metadata regions serve a few purposes:
+
+1. The core module uses the ``.kfuzztest_target`` section at boot to discover
+   every ``FUZZ_TEST`` instance and create its ``debugfs`` directory and
+   ``input`` file.
+2. If a ``.kfuzztest_simple_target`` is defined for a given fuzz test, an
+   additional ``input_simple`` file is created in the target's ``debugfs``
+   directory to accept inputs that don't require complex serialization.
+3. Userspace fuzzers can read this metadata from the ``vmlinux`` binary to
+   discover targets and learn about their rules and structure in order to
+   generate correct and effective inputs.
+
+The metadata in the ``.kfuzztest_*`` sections consists of arrays of fixed-size C
+structs (e.g., ``struct kfuzztest_target``). Fields within these structs that
+are pointers, such as ``name`` or ``arg_type_name``, contain addresses that
+point to other locations in the ``vmlinux`` binary. A userspace tool that
+parses the ``vmlinux`` ELF file must resolve these pointers to read the data
+that they reference. For example, to get a target's name, a tool must:
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
+Input Serialization
+===================
+
+``FUZZ_TEST`` macros accept serialized inputs representing nested data with
+pointers. This section describes the input format for non-trivial inputs.
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
2.51.0


