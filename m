Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCFC0CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38C148E0012; Tue, 16 Sep 2025 05:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D858E0001; Tue, 16 Sep 2025 05:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168CF8E0012; Tue, 16 Sep 2025 05:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 004698E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:01:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B118711B09D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:24 +0000 (UTC)
X-FDA: 83894519688.17.0B03348
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8F78340011
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zto4LaNt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758013282; a=rsa-sha256;
	cv=none;
	b=R0QnHpFoRZXe3cbt7xtlQ1+d/i0wiE/PtQsbrJR0w2CRLpKePPDOnybmL19QStW7MxU1yt
	eOZZ/xAGxUMiiFS+YI32zxT+wUVm9vFGX5CmiUxu27n2z+T7e+fd6QPMutFAwLW8kL35TN
	i50OkuKCdo+LMBzqHh3hzAQhRJXC5bE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zto4LaNt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758013282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fs/Mkvp1THxRdctoJn4ZALLS8uDDfar/BAPXGx8Q6Zo=;
	b=Lamni8DtfRX27EHUXtjaDiKy1WtSmlKwFYB50p4fnvUQyFuG9LNz87/01xF3gO6zeTX6dA
	kX+7/HvHIczzxCCY2AmBkCNbyIgLONAOdqzb891+lD92ADJOG22Gf1fWobt4f70F1sDvAh
	vuNZLT3pUhTu8EWaJ8806S9ZRWZxrvc=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45dde353b47so31202685e9.3
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758013281; x=1758618081; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fs/Mkvp1THxRdctoJn4ZALLS8uDDfar/BAPXGx8Q6Zo=;
        b=Zto4LaNte4ZVR8SGrf5kHflf8SJtixSfyBNKGjOX5GbaEI6t+fhZ1TPk+7Y73UTIFi
         llMw95uvg0sXJxMtXvFzZIBxDNjaPpozyu7u1KAiomJyl3yO2jbQBLslU0D1rRC++FUn
         05KJiexc3bzKaEyi2RVZssAihhsw2sSyRJUnsbbiP+wcTVh9UA+Qc3X811IG2XviaE/0
         2beS8685wLskMWJNVr8vJc/nnxgFsYnvmuDtevHKCIgkqPyrvXvub+onzp8M+RA1vnSR
         7h3MVX+iXh+/flBlJP+nzMQkezhdCLXfw7aWqMi2sFg7kvLOB3/9IVSEwSzq6gRFA1Rl
         GXzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758013281; x=1758618081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fs/Mkvp1THxRdctoJn4ZALLS8uDDfar/BAPXGx8Q6Zo=;
        b=iclgEkhqQD3aAaLJtqOhWEV+yUHzPzqHjnqsidkXW9hcdBnRBz23KwVGVh1flQHqIo
         vPRqOG+sx2ZZYHskh4hk++wrCuvbUqnQTbeuqJjjXnm0VOqZsC2Gl1qnQAFlomZng01y
         Zf8vP0fzTOsysU5lIlasy+O+vL0A5/RLva8XWSmTMj7CSwsCI9KQrZazdGmEe6m+ffXf
         EW6brg8CSHppCjHC5V2ZZWZ/S1er5kj8+sEq3JML5/BSRkCRlJKCN3YsAk/QC9a3BVaD
         4IuYsxFpDUgn6BjYeC/xFgQIyrUCRMryn4MpVkTHWK32P0o0Wlp8dgwhiCqePhSoado1
         W/Mg==
X-Forwarded-Encrypted: i=1; AJvYcCV6ByQno+c6y4e4N07mFbpbzOQEfYTm3ojsIvSA6sKWvxQ4P/6/pQcEsnDTy96wBD7sbHTbUCQidQ==@kvack.org
X-Gm-Message-State: AOJu0YxB0FGm8LTGkZ0oQ9TDNIr0FW732Vao8duHEoSoLTwn9LyAHndw
	KaoRkqjHqElr1FU4sYRU/YGhNxQ2oVI+fphHnBMdS05setsvxfYZ6YAY
X-Gm-Gg: ASbGncumSzi2NoEKP+iBDaoPmWX0anwtTZ0tGuFdLRiOiE177jzXZtceJRA8kIVk/cW
	uAEwtBdvJJUAKa12s9iQZvQW8DEnsYkJaQUd7umAdsvYk8OjnS4T3VumGJjW9zSq5y6n0q3DpYR
	viXohJWgPDoQdNS941QSAIK+A8PoIiU5j2eE1k2jpLzhSzC0G/3boD+U0j8zu/2j06+Bi0YJFGc
	90MtgbfPgyuTI5jJ6slShe0IPtPUwt8+cybuJIpsDRo+Tb7vmsxIitM7qhg231bme+Ch4sNhwca
	Nq55NNQj3lQpdl94aFWZwnkqzmdTllZYSQVdtK+qLfwPdJGi0rxLRNld8QmP1ir2T1Img3cxMFc
	/Ot4/tdvpvGddf1bD4qOt30MrFc1x7aq1yx3WKa7YAwyCUnglYgQvMpCek7FdiTvQ7eU/DKae/P
	LFnt997Lt0Lo0s4PkHvCQVFPM=
X-Google-Smtp-Source: AGHT+IHwQoGXKySunnNfE/yk4Lj1m+tend1dwCc17kn/aqDyL3pKFJsdM1voo4KacgQC1QzpZx8uDQ==
X-Received: by 2002:a7b:c04b:0:b0:456:43c:dcdc with SMTP id 5b1f17b1804b1-45f212050femr102155175e9.33.1758013280425;
        Tue, 16 Sep 2025 02:01:20 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (42.16.79.34.bc.googleusercontent.com. [34.79.16.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037186e5sm212975035e9.5.2025.09.16.02.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:01:19 -0700 (PDT)
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
Subject: [PATCH v1 02/10] kfuzztest: add user-facing API and data structures
Date: Tue, 16 Sep 2025 09:01:01 +0000
Message-ID: <20250916090109.91132-3-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8F78340011
X-Stat-Signature: e4ydjkyshfinntrrn65ydridrzxdjqgi
X-Rspam-User: 
X-HE-Tag: 1758013282-616951
X-HE-Meta: U2FsdGVkX1+gls/jHw03gWOQUPf00VTRBoG3yZ1gZxbl4HuiUB2OE4BP6eX0F16+OG99s0bFg1y9tBTTxMEAw0OYG41FPqCaDnhkSKyPq/+0m7OUhIzEZRqTwebA7QK4YnsNLtaObMHn4H5eGvP4bADhuZMGsl/BrmaEpozJQyWENaOh2Xh/GQvfHOMKc0ZmdrZpZ1cUCKQP54AcqFkDRtVurIlJehdpd5FcGUVF4qDmxsiXys1TKQbE69qtOl9OlkpDOLAY0W2IJemIy/RSrDBz8KpKKmihJ3usp1w8lEb/d2t/+gmpbJQAA09xBaT8KEL0vLykedBJS9fWlCCBc/EpKkUx61oCsFg56JXXV5P0QFfLSDeephT5AQbW6N5CNq6G0Ih0qz/zunGNEuKabmOi3lm0MZpDzXeypxZRd2e/49YgtlwQsnPZlQwWvutPWj45BPPWTPQTgIBwwi4Tu5hdp2ZAbFAaFb6VpX/rK9+kO3Qg2adRPiNZxkiieISnVMGCqV6g4APF5WCXLRQHngaOwv5V7jPSMYzneel53lCGa9hpoKcNsbpC0tDJpGTTZr+DchUFnaBgszEtrgArSD4kr4FRsBvod45pM/L1laykSeiL4sTWDIoKzSesf0Tz5n8gfpjWRkxanaDLiXF1a+u4CwmUMjo8JyTyc39nZSbCV4tAh0c+s4+mqkZWA2ywuSBDVoRzIjtkd7xNeAH4tbmrDDsrDmZnV6dTyjMcPBFNWDTTTLVHr7BX4pFBM5udntGtPkHDo36Uep/3R59qkKKdA/Vm2CgnIucFo3LyKCv/I5VxUAQ70t8EGVOFu4kObQTT3jzBrGiuXxx+7mehVFoofkdGVE7IsfucyHZmRga2rlN9t8vGU9Zs4BLXhL4oW8AJLq10Xr8yKd7ouXnATj6eKV0LOI8xDUodFjQtzIfOE2RAq+pf1aVxT2y3deESA5dAcCbxoq2YqEab7QK
 2sOo9jcf
 4Si5sNjxum4vhBl+h3M7zWU6EK9Keqhc+KT8D7Ts4DyK04fRqF1V9KAZuuROrHrzpiwaBLlw0CSuUTvw+vyLmKtP2dEDMtsiNXqhGGN/3YBxu3/LcS15sZeX3dq8HBHblKvHBYcKNG3qj0U/1udP+48WSdZb79zvsWFHTup+ooh1CqpnmDFylXeyY+9KBEa8fykkJAr4daOy9CuIDSx7KpV3WfZexuqHjzDMLP8d+c35u9+NpkleAFg1FnU5vGxmyae32cnu0vbJTmafUHgXrWwxWyZqIC8vF/tR7e+UstjtMzdcVNDy14tXx4pBh8uB7X3fJjl/hEfzh1mQqoxjDwZggbMSdB067+vDzGDQWtYwFpv+tNrKK1s42WKTvHASWfGQndrxy4hJWexchRdCPC8QC3O+9z7hlv60B81M7Ljrvr7IULCysNWlvVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

Add the foundational user-facing components for the KFuzzTest framework.
This includes the main API header <linux/kfuzztest.h>, the Kconfig
option to enable the feature, and the required linker script changes
which introduce three new ELF sections in vmlinux.

Note that KFuzzTest is intended strictly for debug builds only, and
should never be enabled in a production build. The fact that it exposes
internal kernel functions and state directly to userspace may constitute
a serious security vulnerability if used for any reason other than
testing.

The header defines:
- The FUZZ_TEST() macro for creating test targets.
- The data structures required for the binary serialization format,
  which allows passing complex inputs from userspace.
- The metadata structures for test targets, constraints and annotations,
  which are placed in dedicated ELF sections (.kfuzztest_*) for
  discovery.

This patch only adds the public interface and build integration; no
runtime logic is included.

---
v3:
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

Signed-off-by: Ethan Graham <ethangraham@google.com>
---
 include/asm-generic/vmlinux.lds.h |  22 +-
 include/linux/kfuzztest.h         | 494 ++++++++++++++++++++++++++++++
 lib/Kconfig.debug                 |   1 +
 lib/kfuzztest/Kconfig             |  20 ++
 4 files changed, 536 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/kfuzztest.h
 create mode 100644 lib/kfuzztest/Kconfig

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index ae2d2359b79e..9afe569d013b 100644
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
@@ -966,6 +967,25 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 		BOUNDED_SECTION_POST_LABEL(.kunit_init_test_suites, \
 				__kunit_init_suites, _start, _end)
 
+#ifdef CONFIG_KFUZZTEST
+#define KFUZZTEST_TABLE()						\
+	. = ALIGN(PAGE_SIZE);						\
+	__kfuzztest_targets_start = .;					\
+	KEEP(*(.kfuzztest_target));					\
+	__kfuzztest_targets_end = .;					\
+	. = ALIGN(PAGE_SIZE);						\
+	__kfuzztest_constraints_start = .;				\
+	KEEP(*(.kfuzztest_constraint));					\
+	__kfuzztest_constraints_end = .;				\
+	. = ALIGN(PAGE_SIZE);						\
+	__kfuzztest_annotations_start = .;				\
+	KEEP(*(.kfuzztest_annotation));					\
+	__kfuzztest_annotations_end = .;
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
index 000000000000..1e5ed517f291
--- /dev/null
+++ b/include/linux/kfuzztest.h
@@ -0,0 +1,494 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * The Kernel Fuzz Testing Framework (KFuzzTest) API for defining fuzz targets
+ * for internal kernel functions.
+ *
+ * For more information please see Documentation/dev-tools/kfuzztest.rst.
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
+#define KFUZZTEST_HEADER_MAGIC (0xBFACE)
+#define KFUZZTEST_V0 (0)
+
+/**
+ * @brief The KFuzzTest Input Serialization Format
+ *
+ * KFuzzTest receives its input from userspace as a single binary blob. This
+ * format allows for the serialization of complex, pointer-rich C structures
+ * into a flat buffer that can be safely passed into the kernel. This format
+ * requires only a single copy from userspace into a kernel buffer, and no
+ * further kernel allocations. Pointers are patched internally using a "region"
+ * system where each region corresponds to some pointed-to data.
+ *
+ * Regions should be padded to respect alignment constraints of their underlying
+ * types, and should be followed by at least 8 bytes of padding. These padded
+ * regions are poisoned by KFuzzTest to ensure that KASAN catches OOB accesses.
+ *
+ * The format consists of a header and three main components:
+ * 1. An 8-byte header: Contains KFUZZTEST_MAGIC in the first 4 bytes, and the
+ *	version number in the subsequent 4 bytes. This ensures backwards
+ *	compatibility in the event of future format changes.
+ * 2. A reloc_region_array: Defines the memory layout of the target structure
+ *	by partitioning the payload into logical regions. Each logical region
+ *	should contain the byte representation of the type that it represents,
+ *	including any necessary padding. The region descriptors should be
+ *	ordered by offset ascending.
+ * 3. A reloc_table: Provides "linking" instructions that tell the kernel how
+ *	to patch pointer fields to point to the correct regions. By design,
+ *	the first region (index 0) is passed as input into a FUZZ_TEST.
+ * 4. A Payload: The raw binary data for the target structure and its associated
+ *	buffers. This should be aligned to the maximum alignment of all
+ *	regions to satisfy alignment requirements of the input types, but this
+ *	isn't checked by the parser.
+ *
+ * For a detailed specification of the binary layout see the full documentation
+ * at: Documentation/dev-tools/kfuzztest.rst
+ */
+
+/**
+ * struct reloc_region - single contiguous memory region in the payload
+ *
+ * @offset: The byte offset of this region from the start of the payload, which
+ *	should be aligned to the alignment requirements of the region's
+ *	underlying type.
+ * @size: The size of this region in bytes.
+ */
+struct reloc_region {
+	uint32_t offset;
+	uint32_t size;
+};
+
+/**
+ * struct reloc_region_array - array of regions in an input
+ *
+ * @num_regions: The total number of regions defined.
+ * @regions: A flexible array of `num_regions` region descriptors.
+ */
+struct reloc_region_array {
+	uint32_t num_regions;
+	struct reloc_region regions[];
+};
+
+/**
+ * struct reloc_entry - a single pointer to be patched in an input
+ *
+ * @region_id: The index of the region in the `reloc_region_array` that
+ *	contains the pointer.
+ * @region_offset: The start offset of the pointer inside of the region.
+ * @value: contains the index of the pointee region, or KFUZZTEST_REGIONID_NULL
+ *	if the pointer is NULL.
+ */
+struct reloc_entry {
+	uint32_t region_id;
+	uint32_t region_offset;
+	uint32_t value;
+};
+
+/**
+ * struct reloc_entry - array of relocations required by an input
+ *
+ * @num_entries: the number of pointer relocations.
+ * @padding_size: the number of padded bytes between the last relocation in
+ *	entries, and the start of the payload data. This should be at least
+ *	8 bytes, as it is used for poisoning.
+ * @entries: array of relocations.
+ */
+struct reloc_table {
+	uint32_t num_entries;
+	uint32_t padding_size;
+	struct reloc_entry entries[];
+};
+
+/**
+ * kfuzztest_parse_and_relocate - validate and relocate a KFuzzTest input
+ *
+ * @input: A buffer containing the serialized input for a fuzz target.
+ * @input_size: the size in bytes of the @input buffer.
+ * @arg_ret: return pointer for the test case's input structure.
+ */
+int kfuzztest_parse_and_relocate(void *input, size_t input_size, void **arg_ret);
+
+/*
+ * Dump some information on the parsed headers and payload. Can be useful for
+ * debugging inputs when writing an encoder for the KFuzzTest input format.
+ */
+__attribute__((unused)) static inline void kfuzztest_debug_header(struct reloc_region_array *regions,
+								  struct reloc_table *rt, void *payload_start,
+								  void *payload_end)
+{
+	uint32_t i;
+
+	pr_info("regions: { num_regions = %u } @ %px", regions->num_regions, regions);
+	for (i = 0; i < regions->num_regions; i++) {
+		pr_info("  region_%u: { start: 0x%x, size: 0x%x }", i, regions->regions[i].offset,
+			regions->regions[i].size);
+	}
+
+	pr_info("reloc_table: { num_entries = %u, padding = %u } @ offset 0x%lx", rt->num_entries, rt->padding_size,
+		(char *)rt - (char *)regions);
+	for (i = 0; i < rt->num_entries; i++) {
+		pr_info("  reloc_%u: { src: %u, offset: 0x%x, dst: %u }", i, rt->entries[i].region_id,
+			rt->entries[i].region_offset, rt->entries[i].value);
+	}
+
+	pr_info("payload: [0x%lx, 0x%lx)", (char *)payload_start - (char *)regions,
+		(char *)payload_end - (char *)regions);
+}
+
+struct kfuzztest_target {
+	const char *name;
+	const char *arg_type_name;
+	ssize_t (*write_input_cb)(struct file *filp, const char __user *buf, size_t len, loff_t *off);
+} __aligned(32);
+
+#define KFUZZTEST_MAX_INPUT_SIZE (PAGE_SIZE * 16)
+
+/**
+ * FUZZ_TEST - defines a KFuzzTest target
+ *
+ * @test_name: The unique identifier for the fuzz test, which is used to name
+ *	the debugfs entry, e.g., /sys/kernel/debug/kfuzztest/@test_name.
+ * @test_arg_type: The struct type that defines the inputs for the test. This
+ *	must be the full struct type (e.g., "struct my_inputs"), not a typedef.
+ *
+ * Context:
+ * This macro is the primary entry point for the KFuzzTest framework. It
+ * generates all the necessary boilerplate for a fuzz test, including:
+ *   - A static `struct kfuzztest_target` instance that is placed in a
+ *	dedicated ELF section for discovery by userspace tools.
+ *   - A `debugfs` write callback that handles receiving serialized data from
+ *	a fuzzer, parsing it, and "hydrating" it into a valid C struct.
+ *   - A function stub where the developer places the test logic.
+ *
+ * User-Provided Logic:
+ * The developer must provide the body of the fuzz test logic within the curly
+ * braces following the macro invocation. Within this scope, the framework
+ * provides the `arg` variable, which is a pointer of type `@test_arg_type *` 
+ * to the fully hydrated input structure. All pointer fields within this struct
+ * have been relocated and are valid kernel pointers. This is the primary
+ * variable to use for accessing fuzzing inputs.
+ *
+ * Example Usage:
+ *
+ * // 1. The kernel function we want to fuzz.
+ * int process_data(const char *data, size_t len);
+ *
+ * // 2. Define a struct to hold all inputs for the function.
+ * struct process_data_inputs {
+ *	const char *data;
+ *	size_t len;
+ * };
+ *
+ * // 3. Define the fuzz test using the FUZZ_TEST macro.
+ * FUZZ_TEST(process_data_fuzzer, struct process_data_inputs)
+ * {
+ *	int ret;
+ *	// Use KFUZZTEST_EXPECT_* to enforce preconditions.
+ *	// The test will exit early if data is NULL.
+ *	KFUZZTEST_EXPECT_NOT_NULL(process_data_inputs, data);
+ *
+ *	// Use KFUZZTEST_ANNOTATE_* to provide hints to the fuzzer.
+ *	// This links the 'len' field to the 'data' buffer.
+ *	KFUZZTEST_ANNOTATE_LEN(process_data_inputs, len, data);
+ *
+ *	// Call the function under test using the 'arg' variable. OOB memory
+ *	// accesses will be caught by KASAN, but the user can also choose to
+ *	// validate the return value and log any failures.
+ *	ret = process_data(arg->data, arg->len);
+ * }
+ */
+#define FUZZ_TEST(test_name, test_arg_type)									\
+	static ssize_t kfuzztest_write_cb_##test_name(struct file *filp, const char __user *buf, size_t len,	\
+						      loff_t *off);						\
+	static void kfuzztest_logic_##test_name(test_arg_type *arg);						\
+	const struct kfuzztest_target __fuzz_test__##test_name __section(".kfuzztest_target") __used = {	\
+		.name = #test_name,										\
+		.arg_type_name = #test_arg_type,								\
+		.write_input_cb = kfuzztest_write_cb_##test_name,						\
+	};													\
+	static ssize_t kfuzztest_write_cb_##test_name(struct file *filp, const char __user *buf, size_t len,	\
+						      loff_t *off)						\
+	{													\
+		test_arg_type *arg;										\
+		void *buffer;											\
+		int ret;											\
+														\
+		/*
+		 * Taint the kernel on the first fuzzing invocation. The debugfs
+		 * interface provides a high-risk entry point for userspace to
+		 * call kernel functions with untrusted input.
+		 */												\
+		if (!test_taint(TAINT_TEST))									\
+			add_taint(TAINT_TEST, LOCKDEP_STILL_OK);						\
+		if (len >= KFUZZTEST_MAX_INPUT_SIZE) {								\
+			pr_warn(#test_name ": user input of size %zu is too large", len);			\
+			return -EINVAL;										\
+		}												\
+		buffer = kmalloc(len, GFP_KERNEL);								\
+		if (!buffer)											\
+			return -ENOMEM;										\
+		ret = simple_write_to_buffer(buffer, len, off, buf, len);					\
+		if (ret != len){										\
+			ret = -EFAULT;										\
+			goto out;										\
+		};												\
+		ret = kfuzztest_parse_and_relocate(buffer, len, (void **)&arg);					\
+		if (ret < 0)											\
+			goto out;										\
+		kfuzztest_logic_##test_name(arg);								\
+		ret = len;											\
+out:														\
+		kfree(buffer);											\
+		return ret;											\
+	}													\
+	static void kfuzztest_logic_##test_name(test_arg_type *arg)
+
+enum kfuzztest_constraint_type {
+	EXPECT_EQ,
+	EXPECT_NE,
+	EXPECT_LT,
+	EXPECT_LE,
+	EXPECT_GT,
+	EXPECT_GE,
+	EXPECT_IN_RANGE,
+};
+
+/**
+ * struct kfuzztest_constraint - a metadata record for a domain constraint
+ *
+ * Domain constraints are rules about the input data that must be satisfied for
+ * a fuzz test to proceed. While they are enforced in the kernel with a runtime
+ * check, they are primarily intended as a discoverable contract for userspace
+ * fuzzers.
+ *
+ * Instances of this struct are generated by the KFUZZTEST_EXPECT_* macros
+ * and placed into the read-only ".kfuzztest_constraint" ELF section of the
+ * vmlinux binary. A fuzzer can parse this section to learn about the
+ * constraints and generate valid inputs more intelligently.
+ *
+ * For an example of how these constraints are used within a fuzz test, see the
+ * documentation for the FUZZ_TEST() macro.
+ *
+ * @input_type: The name of the input struct type, without the leading
+ *	"struct ".
+ * @field_name: The name of the field within the struct that this constraint
+ *	applies to.
+ * @value1: The primary value used in the comparison (e.g., the upper
+ *	bound for EXPECT_LE).
+ * @value2: The secondary value, used only for multi-value comparisons
+ *	(e.g., the upper bound for EXPECT_IN_RANGE).
+ * @type: The type of the constraint.
+ */
+struct kfuzztest_constraint {
+	const char *input_type;
+	const char *field_name;
+	uintptr_t value1;
+	uintptr_t value2;
+	enum kfuzztest_constraint_type type;
+} __aligned(64);
+
+#define __KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val1, val2, tpe, predicate)				\
+	do {													\
+		static struct kfuzztest_constraint __constraint_##arg_type##_##field				\
+			__section(".kfuzztest_constraint") __used = {						\
+				.input_type = "struct " #arg_type,						\
+				.field_name = #field,								\
+				.value1 = (uintptr_t)val1,							\
+				.value2 = (uintptr_t)val2,							\
+				.type = tpe,									\
+			};											\
+		if (!(predicate))										\
+			return;											\
+	} while (0)
+
+/**
+ * KFUZZTEST_EXPECT_EQ - constrain a field to be equal to a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable
+ * @val: a value of the same type as @arg_type.@field
+ */
+#define KFUZZTEST_EXPECT_EQ(arg_type, field, val)	\
+	__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_EQ, arg->field == val);
+
+/**
+ * KFUZZTEST_EXPECT_NE - constrain a field to be not equal to a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @val: a value of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_NE(arg_type, field, val)	\
+	__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_NE, arg->field != val);
+
+/**
+ * KFUZZTEST_EXPECT_LT - constrain a field to be less than a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @val: a value of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_LT(arg_type, field, val)	\
+	__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_LT, arg->field < val);
+
+/**
+ * KFUZZTEST_EXPECT_LE - constrain a field to be less than or equal to a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @val: a value of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_LE(arg_type, field, val)	\
+		__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_LE, arg->field <= val);
+
+/**
+ * KFUZZTEST_EXPECT_GT - constrain a field to be greater than a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @val: a value of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_GT(arg_type, field, val)	\
+	__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_GT, arg->field > val);
+
+/**
+ * KFUZZTEST_EXPECT_GE - constrain a field to be greater than or equal to a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @val: a value of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_GE(arg_type, field, val)	\
+	__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_GE, arg->field >= val);
+
+/**
+ * KFUZZTEST_EXPECT_GE - constrain a pointer field to be non-NULL
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @val: a value of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_NOT_NULL(arg_type, field) KFUZZTEST_EXPECT_NE(arg_type, field, NULL)
+
+/**
+ * KFUZZTEST_EXPECT_IN_RANGE - constrain a field to be within a range
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @lower_bound: a lower bound of the same type as @arg_type.@field.
+ * @upper_bound: an upper bound of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_IN_RANGE(arg_type, field, lower_bound, upper_bound)		\
+	__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, lower_bound, upper_bound,	\
+			EXPECT_IN_RANGE, arg->field >= lower_bound && arg->field <= upper_bound);
+
+/**
+ * Annotations express attributes about structure fields that can't be easily
+ * or safely verified at runtime. They are intended as hints to the fuzzing
+ * engine to help it generate more semantically correct and effective inputs.
+ * Unlike constraints, annotations do not add any runtime checks and do not
+ * cause a test to exit early.
+ *
+ * For example, a `char *` field could be a raw byte buffer or a C-style
+ * null-terminated string. A fuzzer that is aware of this distinction can avoid
+ * creating inputs that would cause trivial, uninteresting crashes from reading
+ * past the end of a non-null-terminated buffer.
+ */
+enum kfuzztest_annotation_attribute {
+	ATTRIBUTE_LEN,
+	ATTRIBUTE_STRING,
+	ATTRIBUTE_ARRAY,
+};
+
+/**
+ * struct kfuzztest_annotation - a metadata record for a fuzzer hint
+ *
+ * This struct captures a single hint about a field in the input structure.
+ * Instances are generated by the KFUZZTEST_ANNOTATE_* macros and are placed
+ * into the read-only ".kfuzztest_annotation" ELF section of the vmlinux binary.
+ *
+ * A userspace fuzzer can parse this section to understand the semantic
+ * relationships between fields (e.g., which field is a length for which
+ * buffer) and the expected format of the data (e.g., a null-terminated
+ * string). This allows the fuzzer to be much more intelligent during input
+ * generation and mutation.
+ *
+ * For an example of how annotations are used within a fuzz test, see the
+ * documentation for the FUZZ_TEST() macro.
+ *
+ * @input_type: The name of the input struct type.
+ * @field_name: The name of the field being annotated (e.g., the data
+ *	buffer field).
+ * @linked_field_name: For annotations that link two fields (like
+ *	ATTRIBUTE_LEN), this is the name of the related field (e.g., the
+ *	length field). For others, this may be unused.
+ * @attrib: The type of the annotation hint.
+ */
+struct kfuzztest_annotation {
+	const char *input_type;
+	const char *field_name;
+	const char *linked_field_name;
+	enum kfuzztest_annotation_attribute attrib;
+} __aligned(32);
+
+#define __KFUZZTEST_ANNOTATE(arg_type, field, linked_field, attribute)						\
+	static struct kfuzztest_annotation __annotation_##arg_type##_##field __section(".kfuzztest_annotation")	\
+		__used = {											\
+			.input_type = "struct " #arg_type,							\
+			.field_name = #field,									\
+			.linked_field_name = #linked_field,							\
+			.attrib = attribute,									\
+		}
+
+/**
+ * KFUZZTEST_ANNOTATE_STRING - annotate a char* field as a C string
+ *
+ * We define a C string as a sequence of non-zero characters followed by exactly
+ * one null terminator.
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: the name of the field to annotate.
+ */
+#define KFUZZTEST_ANNOTATE_STRING(arg_type, field) __KFUZZTEST_ANNOTATE(arg_type, field, NULL, ATTRIBUTE_STRING)
+
+/**
+ * KFUZZTEST_ANNOTATE_ARRAY - annotate a pointer as an array
+ *
+ * We define an array as a contiguous memory region containing zero or more
+ * elements of the same type.
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: the name of the field to annotate.
+ */
+#define KFUZZTEST_ANNOTATE_ARRAY(arg_type, field) __KFUZZTEST_ANNOTATE(arg_type, field, NULL, ATTRIBUTE_ARRAY)
+
+/**
+ * KFUZZTEST_ANNOTATE_LEN - annotate a field as the length of another
+ *
+ * This expresses the relationship `arg_type.field == len(linked_field)`, where
+ * `linked_field` is an array.
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: the name of the field to annotate.
+ * @linked_field: the name of an array field with length @field.
+ */
+#define KFUZZTEST_ANNOTATE_LEN(arg_type, field, linked_field) \
+	__KFUZZTEST_ANNOTATE(arg_type, field, linked_field, ATTRIBUTE_LEN)
+
+#define KFUZZTEST_REGIONID_NULL U32_MAX
+
+/**
+ * The end of the input should be padded by at least this number of bytes as
+ * it is poisoned to detect out of bounds accesses at the end of the last
+ * region.
+ */
+#define KFUZZTEST_POISON_SIZE 0x8
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
index 000000000000..f9fb5abf8d27
--- /dev/null
+++ b/lib/kfuzztest/Kconfig
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config KFUZZTEST
+	bool "KFuzzTest - enable support for internal fuzz targets"
+	depends on DEBUG_FS && DEBUG_KERNEL
+	help
+	  Enables support for the kernel fuzz testing framework (KFuzzTest), an
+	  interface for exposing internal kernel functions to a userspace fuzzing
+	  engine. KFuzzTest targets are exposed via a debugfs interface that
+	  accepts serialized userspace inputs, and is designed to make it easier
+	  to fuzz deeply nested kernel code that is hard to reach from the system
+	  call boundary. Using a simple macro-based API, developers can add a new
+	  fuzz target with minimal boilerplate code.
+
+	  It is strongly recommended to also enable CONFIG_KASAN for byte-accurate
+	  out-of-bounds detection, as KFuzzTest was designed with this in mind. It
+	  is also recommended to enable CONFIG_KCOV for coverage guided fuzzing.
+
+	  WARNING: This exposes internal kernel functions directly to userspace
+	  and must NEVER be enabled in production builds.
-- 
2.51.0.384.g4c02a37b29-goog


