Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D56BCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1012E900071; Wed, 13 Aug 2025 09:38:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08AFA900044; Wed, 13 Aug 2025 09:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF8CF900071; Wed, 13 Aug 2025 09:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF277900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:38:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F371C03BD
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:38:44 +0000 (UTC)
X-FDA: 83771839368.28.C7C786B
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5F83420006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:38:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ga3ubQc+;
	spf=pass (imf13.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755092322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JExl73RPYAos6cnZfl//XMbBahCTNDsylfHPobCls2o=;
	b=0xvtRCK6ZuaICfFPimG0DN19GReof0USQrdgGGozXR0DIZbFyIDQUREOAvpaohIfBknq8I
	fIiZYyPTKSsNiNNrLs2W5i9QIjDCqOq7ndMK6IhWvKweyB+X2OzVo7W2AIu1UuMAXa+ZPN
	Tby3KsrrdXYG1jLWz8xBwMDR0pD35io=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755092322; a=rsa-sha256;
	cv=none;
	b=3aXF3in6/Ew/jvthwHtajRgJhEAHharlv7RHM/ZZ8lvNeLRrk16akxdOKak2XHwb7crvFW
	MSLkbnoVtPB5zUqJXlaFM/d9LSmGnXDriR2pHMJfwkVSBksedEjjV1kL2igXjkHGnj47em
	G+jToHeavxapmv8asYGAnVkbM5ZZ6C4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ga3ubQc+;
	spf=pass (imf13.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3b79bdc9a7dso4030761f8f.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755092321; x=1755697121; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JExl73RPYAos6cnZfl//XMbBahCTNDsylfHPobCls2o=;
        b=Ga3ubQc+cjssTku4oVJqPpqNRRbGnUEC6LSopL4FGERyIBsGeX0Z6TCzjrxkjnqLj0
         kQtN+GZEAZ+P2MzRWMg15jxZqmt7yXKhYa+cDVkAq8+Ph8Ab9c1HQ2QPqoAbDXV3nRFV
         vyBBmDoYzseo/yGAgKcpFrs7471DwHHJHJxfEHR/fzwCXWFqVjaMfhjTtgmh+iJST7LH
         QKz1oM2vzFTAY+wcg4HKHJq4uhxwiXwxMFr31nbLdLdAM6NuQVqZa8RNOCcvLnMQk9uv
         WVQ89tXkSuHZP6ltdaPtgTG+1LTDvgMsMDa3gzfqFziv4/RvGsIo1GH0Yk7oevSWREQB
         isfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755092321; x=1755697121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JExl73RPYAos6cnZfl//XMbBahCTNDsylfHPobCls2o=;
        b=CErsK9IqeEVOGtHIYLYtBAU5yJCXGyQ0jNDYw5FBRqpQeI09N9rKXteguSD4aVH7bx
         2/rRq4I/8uUylIFmfc4+xjb9OFGHhp2TEVmzB+9fsO4EZH2QelXquN7C4IY+zi2SbfQO
         Jb90srR5EijV8UpQaKQmGJP3wNZtYwyQDzHc1odxDMXU6WCIDrQdGlB5HHc1urujJhSs
         3mo3Ifh+BnwND53msPuNAo8vm0f6lLIAyiCEED50COUlsGhj2nXOsJ3YsUXWDlGo++ue
         181doxgtSZJkuLyIP92cRpjpJ2lKwyhG9YVD6pkFAceqrZubhyez88tsCS/xHILdCAAS
         3B6A==
X-Forwarded-Encrypted: i=1; AJvYcCVmW8aZ+5ZdfANq+6ZG0Tbl2NzmsOEIb05Gv2M2pH9xOP55BNAlih9ee5PnaA1Ouqi7qx1kLZ/SWg==@kvack.org
X-Gm-Message-State: AOJu0YzLpbAUbcG4Z2gcpp2CfVQrDr0mUXwDhW+pndycBvCI5NUHP2HO
	6xzMASaQnztkByiM68wL5wnsmmH5Pv46g3m/opT1sdKNOhwTSs5vXkQ2
X-Gm-Gg: ASbGncugCJ69OxnrPpRDW5IggDMHJE6T7cEaO/i9WkMqipEtOWX+Q6gBqp7oXdugHMq
	QICWPSpQ9ebdyAt6yjCo8XH2rq3MKlW35Ajw240gmVvG7JB14G/0jSt5ErDr08kILpY3qe8xmrF
	DzpAS4RLvDWEx7S9A+Od9egET2BKrJeH46Bu242ogiiXzaL6k7DQwW2Uh0T4YPZffu3YGo2tnZT
	MSdihpt0gXXT7DTF+y6Ajkj2aMNv+mTnUefHAgj/ZMpw1VPhdP98I9U9+FEqFuaxfV9MHykvkzq
	Q2KXAbIPmBD8ZIHVQvJy37sGAewEY2WhXjb23nnobzkyhgkKP3/feRk/xBouaFRR51Q0WoLRYd/
	+Pp3hRqSqFSmAXdtk1lBLkp+tg7oIi4HhkQJjvJ0PSdLBz4flFtsPBDQdV6pt65TdKoB6TcJOp+
	NwPLj1GIcRucx9VP3xpALuCqWDTQ==
X-Google-Smtp-Source: AGHT+IGJwkKDbGpMWQMiOKMltg00rXXiYABXq4gACAbBRvEZ1E2AKRdOicYy65GkIAL55+xxn3c6zw==
X-Received: by 2002:a05:6000:2087:b0:3b7:9546:a0e8 with SMTP id ffacd0b85a97d-3b917f15122mr2306669f8f.41.1755092320576;
        Wed, 13 Aug 2025 06:38:40 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (87.220.76.34.bc.googleusercontent.com. [34.76.220.87])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8f8b1bc81sm25677444f8f.69.2025.08.13.06.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:38:39 -0700 (PDT)
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
Subject: [PATCH v1 RFC 2/6] kfuzztest: add user-facing API and data structures
Date: Wed, 13 Aug 2025 13:38:08 +0000
Message-ID: <20250813133812.926145-3-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
In-Reply-To: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5F83420006
X-Stat-Signature: mk9odgbu5tawobfmtx1zqyb6rqrceeak
X-HE-Tag: 1755092322-760281
X-HE-Meta: U2FsdGVkX19ArhIhfrZajWH/vib4hK+i2JRlPxwgGlB7HO6k1Lqmu86dXHbxiqpqhrRkk4iO6SHeawMxYvCWUtTy8wyt5MChGCfZNGkkKUqLD93Lh8SP5+2vCz+rS73D+xG4n1LAsIOJM7exRj+B+M6iX6D0zVx2UnFzR++yrLWa2rmGdWg99kQS5ATGIHnk4m9QpNXP2swGiUoaawc56GaVzKnKFBcKl1fHwk9mMXftGWyM3I6O8/VPZIdOHCJ75JsKf6tUKOioP+eNkkaYU3uP5vv5vu/LVMv6l1vVLuWJ1KfM6+Ul7XtMk15gLM/xxSoHzkhkKClUx5Ob2zmxPpVc11XkSywWiefNSb044DOQhvdkRD2C3JlbFOZH3vjEdw+QLGRI7aOc2lTuZFQ/XTW2dApT5q67KmrpcvIszv6izm0i0Ro9u06MP0aEWuD24PpcR22yF6dsuo/kZronLNl48b5HDsNJ5yknggzaCmXYywekEqS1T5ALH1xywxjMbrMYJoGHO0yCCVJ0G/7aatFSGLF0zO7aF9DD+Nk8LzWHHb6hPlcSWrh8jvcwNM37k+xA+S+xDa6AYrmYBElgr6Q3cerXolNtFA24yMv87OKiugypQY40kJ0dDu+ZdH/kraIo5AhnTKIpeyAaqWSowhTJyS4p/rEhOvW+37Eew8w79J+zF+sUADc3JgGAP6Cw2YFRJb7vgAoR9loGpIk+AZBJtHpPtNAtltBkPO88YfF171dj2dZhHm8DZD6LbAA6mEmHFF+f5EGGVT/g0bEvVDXQmYrIup7cHfVYaEb0naASt3F1yvapJBUIkdUlgwNZMn/SwdaLmMp1UXlyC/UC8TYdHIKVH8OLoYLGZtXJeeq8n4Pogsid6sqk8Za2AvMm0NDsDkM5V+ziqFW9ED2z3mBdNy5fIByIinC38z2yWZ4M1qIGBo7zg0BCaoOrRKVXb6YfeAi2LuCfrue2rwW
 ZGiXAc5b
 wXe4N9dCN12lU0qdq3a1fXG3bBJIZuxQmgyKCbylrAVnWtMBd4hWdHplYe6EP4wI81BT1VzT3gpfrIKYH4I+orj2NIsZ8H2tAZH0aMQNO0upbDZPYlbn6JORUdKYhEVPvZH55JPKN3Nqk4cq4aCcdQoltqFZ0THmad7OaPFKzsgYLT7Zcv8aH8I3vdJVYHHyG47C99H6FFngnPNy+Cb0H+kqA75u9D2qKPCyUT2y9n9ZC+s546Ra8hJiwAfNzLrUMVvAvBq9cBOdRz+RHt2APwOG1gUI74MPrdNRoLkZ9mUnYnBUxhsdQ5LsQhXaCkJ9A1vS0LWffAR0jURf0zJRxOh9lQ7Kv4bRyCMJ5FK+KLpqCXFUr3tauadcnmLC/Kz26mOaV27dOBvEJbTh45BbpaP0JFLxyH4A1O3HCdG1hZ84emU7ETImlcTarqMV0+bC3EqCdSAGh9MUzuw8YZXSRKhT6dagau3ranTy7
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
  which are placed in dedicated ELF sections (.kfuzztest_*) for discovery.

This patch only adds the public interface and build integration; no
runtime logic is included.

Signed-off-by: Ethan Graham <ethangraham@google.com>
---
 arch/x86/kernel/vmlinux.lds.S |  22 ++
 include/linux/kfuzztest.h     | 508 ++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug             |   1 +
 lib/kfuzztest/Kconfig         |  20 ++
 4 files changed, 551 insertions(+)
 create mode 100644 include/linux/kfuzztest.h
 create mode 100644 lib/kfuzztest/Kconfig

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 4fa0be732af1..484e3e1ffb9f 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -112,6 +112,26 @@ ASSERT(__relocate_kernel_end - __relocate_kernel_start <= KEXEC_CONTROL_CODE_MAX
 #else
 #define KEXEC_RELOCATE_KERNEL
 #endif
+
+#ifdef CONFIG_KFUZZTEST
+#define KFUZZTEST_TABLE							\
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
+#define KFUZZTEST_TABLE
+#endif /* CONFIG_KFUZZTEST */
+
 PHDRS {
 	text PT_LOAD FLAGS(5);          /* R_E */
 	data PT_LOAD FLAGS(6);          /* RW_ */
@@ -199,6 +219,8 @@ SECTIONS
 		CONSTRUCTORS
 		KEXEC_RELOCATE_KERNEL
 
+		KFUZZTEST_TABLE
+
 		/* rarely changed data like cpu maps */
 		READ_MOSTLY_DATA(INTERNODE_CACHE_BYTES)
 
diff --git a/include/linux/kfuzztest.h b/include/linux/kfuzztest.h
new file mode 100644
index 000000000000..11a647c1d925
--- /dev/null
+++ b/include/linux/kfuzztest.h
@@ -0,0 +1,508 @@
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
+ * requires only a single copy from userspace into a kenrel buffer, and no
+ * further kernel allocations. Pointers are patched internally using a "region"
+ * system where each region corresponds to some pointed-to data.
+ *
+ * Regions should be padded to respect alignment constraints of their underlying
+ * types, and should be followed by at least 8 bytes of padding. These padded
+ * regions are poisoned by KFuzzTest to ensure that KASAN catches OOB accesses.
+ *
+ * The format consists of a prefix and three main components:
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
+ * 4. A Payload: The raw binary data for the structure and its associated
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
+ * provides the following variables:
+ *
+ * - `arg`: A pointer of type `@test_arg_type *` to the fully hydrated input
+ * structure. All pointer fields within this struct have been relocated
+ * and are valid kernel pointers. This is the primary variable to use
+ * for accessing fuzzing inputs.
+ *
+ * - `regions`: A pointer of type `struct reloc_region_array *`. This is an
+ * advanced feature that allows access to the raw region metadata, which
+ * can be useful for checking the actual allocated size of a buffer via
+ * `KFUZZTEST_REGION_SIZE(n)`.
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
+#define FUZZ_TEST(test_name, test_arg_type)                                                                  \
+	static ssize_t kfuzztest_write_cb_##test_name(struct file *filp, const char __user *buf, size_t len, \
+						      loff_t *off);                                          \
+	static void kfuzztest_logic_##test_name(test_arg_type *arg);                                         \
+	const struct kfuzztest_target __fuzz_test__##test_name __section(".kfuzztest_target") __used = {     \
+		.name = #test_name,                                                                          \
+		.arg_type_name = #test_arg_type,                                                             \
+		.write_input_cb = kfuzztest_write_cb_##test_name,                                            \
+	};                                                                                                   \
+	static ssize_t kfuzztest_write_cb_##test_name(struct file *filp, const char __user *buf, size_t len, \
+						      loff_t *off)                                           \
+	{                                                                                                    \
+		test_arg_type *arg;                                                                          \
+		void *buffer;                                                                                \
+		int ret;                                                                                     \
+                                                                                                             \
+		buffer = kmalloc(len, GFP_KERNEL);                                                           \
+		if (!buffer)                                                                                 \
+			return -ENOMEM;                                                                      \
+		ret = simple_write_to_buffer(buffer, len, off, buf, len);                                    \
+		if (ret < 0)                                                                                 \
+			goto out;                                                                            \
+		ret = kfuzztest_parse_and_relocate(buffer, len, (void **)&arg);                              \
+		if (ret < 0)                                                                                 \
+			goto out;                                                                            \
+		kfuzztest_logic_##test_name(arg);                                                            \
+		ret = len;                                                                                   \
+out:                                                                                                         \
+		kfree(buffer);                                                                               \
+		return ret;                                                                                  \
+	}                                                                                                    \
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
+#define __KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val1, val2, tpe)                                         \
+	static struct kfuzztest_constraint __constraint_##arg_type##_##field __section(".kfuzztest_constraint") \
+		__used = {                                                                                      \
+			.input_type = "struct " #arg_type,                                                      \
+			.field_name = #field,                                                                   \
+			.value1 = (uintptr_t)val1,                                                              \
+			.value2 = (uintptr_t)val2,                                                              \
+			.type = tpe,                                                                            \
+		}
+
+/**
+ * KFUZZTEST_EXPECT_EQ - constrain a field to be equal to a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable
+ * @val: a value of the same type as @arg_type.@field
+ */
+#define KFUZZTEST_EXPECT_EQ(arg_type, field, val)                                    \
+	do {                                                                         \
+		if (arg->field != val)                                               \
+			return;                                                      \
+		__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_EQ); \
+	} while (0)
+
+/**
+ * KFUZZTEST_EXPECT_NE - constrain a field to be not equal to a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @val: a value of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_NE(arg_type, field, val)                                    \
+	do {                                                                         \
+		if (arg->field == val)                                               \
+			return;                                                      \
+		__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_NE); \
+	} while (0)
+
+/**
+ * KFUZZTEST_EXPECT_LT - constrain a field to be less than a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @val: a value of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_LT(arg_type, field, val)                                    \
+	do {                                                                         \
+		if (arg->field >= val)                                               \
+			return;                                                      \
+		__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_LT); \
+	} while (0)
+
+/**
+ * KFUZZTEST_EXPECT_LE - constrain a field to be less than or equal to a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @val: a value of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_LE(arg_type, field, val)                                    \
+	do {                                                                         \
+		if (arg->field > val)                                                \
+			return;                                                      \
+		__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_LE); \
+	} while (0)
+
+/**
+ * KFUZZTEST_EXPECT_GT - constrain a field to be greater than a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @val: a value of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_GT(arg_type, field, val)                                   \
+	do {                                                                        \
+		if (arg->field <= val)                                              \
+			return;                                                     \
+		__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_GT) \
+	} while (0)
+
+/**
+ * KFUZZTEST_EXPECT_GE - constrain a field to be greater than or equal to a value
+ *
+ * @arg_type: name of the input structure, without the leading "struct ".
+ * @field: some field that is comparable.
+ * @val: a value of the same type as @arg_type.@field.
+ */
+#define KFUZZTEST_EXPECT_GE(arg_type, field, val)                                   \
+	do {                                                                        \
+		if (arg->field < val)                                               \
+			return;                                                     \
+		__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, val, 0x0, EXPECT_GE)` \
+	} while (0)
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
+#define KFUZZTEST_EXPECT_IN_RANGE(arg_type, field, lower_bound, upper_bound)                              \
+	do {                                                                                              \
+		if (arg->field < lower_bound || arg->field > upper_bound)                                 \
+			return;                                                                           \
+		__KFUZZTEST_DEFINE_CONSTRAINT(arg_type, field, lower_bound, upper_bound, EXPECT_IN_RANGE) \
+	} while (0)
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
+enum kfuzztest_annotation_attribute : uint8_t {
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
+#define __KFUZZTEST_ANNOTATE(arg_type, field, linked_field, attribute)                                          \
+	static struct kfuzztest_annotation __annotation_##arg_type##_##field __section(".kfuzztest_annotation") \
+		__used = {                                                                                      \
+			.input_type = "struct " #arg_type,                                                      \
+			.field_name = #field,                                                                   \
+			.linked_field_name = #linked_field,                                                     \
+			.attrib = attribute,                                                                    \
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
index ebe33181b6e6..3542e94204c8 100644
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
2.51.0.rc0.205.g4a044479a3-goog


