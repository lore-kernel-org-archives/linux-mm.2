Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB2B5CCD18F
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B732A8E00A8; Mon, 13 Oct 2025 17:56:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23158E00A2; Mon, 13 Oct 2025 17:56:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5738E00A8; Mon, 13 Oct 2025 17:56:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6598E00A2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 433AF8836B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:53 +0000 (UTC)
X-FDA: 83994451506.07.6D86F43
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4D96F18000E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=dRcRl1i8;
	spf=pass (imf06.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8k5T56kkRu9YK1F4LXF8NdMzANSX1RtLRjBKJZN/CnI=;
	b=lC03P4DKcPVlnDXa0cb4Rcq7BoMIp4Q0gYk8fCopYCdEOte7uV6NxUHzPWAHb7sDMoqzup
	jsLeMckBfNEv41fmMRSD2kfE0/RnL0Xr0oskUfjtX8eqD7x4hsPwnmcCmsZXlVfOWEV7xO
	rkVG2iGv+M8dlkkdLpROLEvt+dWVXqI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=dRcRl1i8;
	spf=pass (imf06.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392611; a=rsa-sha256;
	cv=none;
	b=dvWojCTByU2Fq7KGa9E05Zg5TRGeja+wL9DEdos9GlWs6HN22OVKE9GI09WwkDTLaH8Ra2
	Pn+G3snnN9Zo5HgPxopQo76Cz56NgfbeoCAylnQ25XrAYTj/WCN/jAEcoXs+XwompiIHzD
	F7ab8yBJSmM+9z0Z8VyHniVuZogCmGw=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-33082aed31dso4846128a91.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392610; x=1760997410; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8k5T56kkRu9YK1F4LXF8NdMzANSX1RtLRjBKJZN/CnI=;
        b=dRcRl1i8OZN5eLYEDALQkfnzLYoAn0Ml7M/jpM+J4ev47pmVPMptA9lHpOhkO01D0C
         Vx91/wlsL3SgGrAc+JBvO5Iu9yAKa0wH1LwxZLfiXv4syfqis6U9K9+rARoDAV1JtF4H
         /eUw9Xh3PCqtgstdX5S+oNZe0/Huomr/ocIYcCgtjGBeS+a7mdujzjdY7hzxHivwQOoc
         wFu9fEGFEKl93eQFR3bwCo2OP2mW/t1ipX6L4D1FvCGXR3JcO1Uwf+nOzoAijTlmmSuy
         o3ohg1jwHdcchXexSqyCB0mMppIe71Lawq+V/+27M4OcrAXRavyLwcBhU47CbrBd3Uy1
         Grhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392610; x=1760997410;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8k5T56kkRu9YK1F4LXF8NdMzANSX1RtLRjBKJZN/CnI=;
        b=m5sQ1SFJduSUv3xKx/KmkW9rNl22CM4+bSnq9tdDVUCr0Zi9Ye1do42kalkMmRv5qt
         +vNrM31599eaN8bEtg67Dge4SFDOC2MESBkIxCR/J4T8VR+7UyZyUMG/lGjmulB/++Yz
         zLEjaAjxruRJSRC+3gKRF563wFTSBS53lNolamphN0f286NGYQQ0QMzsWrWiYrH9npps
         090VINQoKQ9fkwuOxdXv3DDQquw+DTkQ8HMsGpXSwlXwicpT8ifNah8tw8em/leRpdX9
         ryzvbX9CusU/OZ7TXSQ4CRcuRW/5u16aCjHPDhGxMv7gQawDiYsznEEYjDnhZIpr0FcM
         a87g==
X-Forwarded-Encrypted: i=1; AJvYcCVTGXCHRf8ymW54RYiCF9ytfE6mVJx9XLRA8zp5gnkXxHkruajfO6mZTOvuG7dzgsCd88DBLnW0sQ==@kvack.org
X-Gm-Message-State: AOJu0YzdlwBQ74nvlUbWFdxndisConm0LRyQHHhsqYD51rD4jVdKxvj6
	+TKS03Sei7EzNAIDksMH0ReWi9mj2oX6wSB32oXC6FNX/lfgM1DGOhdFXiF/EYE7OYs=
X-Gm-Gg: ASbGncsnq/B+BWdhR/kCS+yMunDXYhCY4rUlQ5b7QI7bDbyjf0KT6DZ8QgK9DFLqv0r
	qrq0la9ybLiLxARe2UTftO1aTpaBl5JsKuDaETu2Mm2uH6voxUHCByYX9fd9PTBg4lVroJxGUVS
	knKdDNyJ5EEI0My0BFNcsotdWTnPMpg7VV3HxiItEozeSQK/HBUFK3ePnNHGwpYOzvCrd81Jahg
	p5N+57MiakWCwuwvb0x8Bge0p6qYtNBrfZzJEVf7vTpUjwoLdbl/vtbWTKVH2G6cF7LF+E7uYIY
	wCOFSvNDlHDlej7uwIJfy1YCsDVyFepNRhRd6JFMf/wDp1GLY6yxJj7IiNKBQOb9ZMyoshyuLVR
	WwvGqYs3yeStU1oR/q5eD4hzIZEfE+/J0QVyjXXeI7vN5R3YgtfatidflLiHSCQ0AYwo60OSs
X-Google-Smtp-Source: AGHT+IHx3a984qNbcecxDM8tVy5qsQNA+DsZCzcmJeg6orbmDi7Dfo4tPQo42WPR/bdU+cKZkJ8YLg==
X-Received: by 2002:a17:90b:3ec6:b0:32e:749d:fcb4 with SMTP id 98e67ed59e1d1-33b51105b46mr32691244a91.6.1760392610102;
        Mon, 13 Oct 2025 14:56:50 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:49 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:15 -0700
Subject: [PATCH v20 23/28] arch/riscv: compile vdso with landing pad and
 shadow stack note
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-23-b9de4be9912e@rivosinc.com>
References: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
In-Reply-To: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
 Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
 Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com, 
 andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com, 
 atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
 alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 4D96F18000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 661g3qcu76wp55ci9unt9w8xb5t6g31o
X-HE-Tag: 1760392611-477935
X-HE-Meta: U2FsdGVkX1+XxJp0bh2VivQT9Nhso2hkVbk9JvtmYDhQU6uNftyvSVEZEFlM7RJIpZm52p37mxEyj6u8K1QvCetZG4QmT/M7p/hFG1uMKSCsiLzJe3wdHiRVE4uBR6/Fft/EpRnrxtsh1lsnkmznV15T4i7mZPHQrBiVOEDkZ/3eGt9rbp80E7OkOiHaWS3iHGo7ByEI/WX65KBILttwRt7lMd6JlMxgRplx/eAw1xobp3tqc5hFnXZ8vkSgbrt7Uoj+5ZlF9K8xev4ewPgHqvkcXjzRyR4CXq5W9xUZ9Bi9zXlVPCCX4s6260y2PBAS8W+W2nKW4J1f3FJJDd+gqINqcQiA7FQWu8cj9Ta2ohBywkNM28ri8JCznkKh/KsmufzntScJ9K3q4fVm3z2BCVLnPnEvpyzOc0CTINZGoAoycH/68plt/RccjJr/ZnIAGJMsRQNnEEagl3nbJ3i0AqKqxQ74pJs3gCVLY7n9tJZp+tObl2+RQe1rUa5v9wZ+JWWdKychwLypYVld4o058ksONfUlMRN+SKnQAagTwti9PZeMrbU+N2lBmumaJjnmGQbDmiDOnWyV4NiZTZ3l5i+IdDNBoUztnjJlY3ZAFDQ7XSQVyI7qm4jJyTntGuGLZostVPqymyYGuHegglJl2lhBKmoJlz8JQJTMs+4kDzCM1PNfwWnvR9UvmEGcls3Dr07/1aNsY1zV4FITat1N8pwAWHcqAJ7YFYmMYoG1ZDxyFIE2VIW6UC1iUtvQeDDWlyUAzwWYOAHy8LrkhxozRoTEGuS9S4ovHUWJf63v5oxRWFGDVF5y4iuCRqdlQGLcJCfygJ+gbncRgHXlpKYV0MHvJws7pb4Dc5QmQtHBPxUTsHndexSrsdLh32P81EowgRifTuwjQ+78DrWc9rH7lgVdSaLpf1mGe4AkyjVTjEx4HtSP61zBkIzga3jDjjDU60NFIB5LfU/uE7lHBaB
 4wKZFlYF
 mbaC0iqUkyx2DaPzWMv75CZSsrpC7rZ7QyDpqiy/WX5Gm8IT2POIyJrzAtd73p4hFzEMGOgrMVTkat3aflUT7pSsilrdlOoa5z4wCCtnmlcfBbMB+7NegMS/mp6OT3stWGhUgEODr9IqQRKHtlAdn2xc8kAhJ2nEL4UvTkVFHmosEjhfz17GztmK5VTn53I2ewqPC5bRaDFkk4D8ce+b61m3FJEPdKTEgJ6sbtVNo3i2I+0Ga/QZilhpGoXduBjLE2Y/pGR6Tl/aENCHPg9NlDpca75GEgKcYVsNn67aHEPxY4BnO5dd4+gIz4fyR2k+Yj6BQrwXVMPsvEcXCPRiBcKtjiuDFAIxbHRwwPjy4p2K6WU2qwn3tm8BO2tl5l6O+fdfdp8nvIxt1DOfNd/YkzOdSbZyNmXmkaTfbXW66wr0isADdy0kGRcHaBcilr6I+LZZVzr2/ZW/pkE1LtFdnaYJs/5zeqlENPOF2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jim Shu <jim.shu@sifive.com>

user mode tasks compiled with zicfilp may call indirectly into vdso (like
hwprobe indirect calls). Add landing pad compile support in vdso. vdso
with landing pad in it will be nop for tasks which have not enabled
landing pad. Furthermore, adding support for C sources of vdso to be
compiled with shadow stack and landing pad enabled as well.

Landing pad and shadow stack instructions are emitted only when VDSO_CFI
cflags option is defined during compile.

Signed-off-by: Jim Shu <jim.shu@sifive.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/Makefile                        |  5 +++-
 arch/riscv/include/asm/assembler.h         | 44 ++++++++++++++++++++++++++++++
 arch/riscv/kernel/vdso/Makefile            | 11 +++++++-
 arch/riscv/kernel/vdso/flush_icache.S      |  4 +++
 arch/riscv/kernel/vdso/getcpu.S            |  4 +++
 arch/riscv/kernel/vdso/note.S              |  3 ++
 arch/riscv/kernel/vdso/rt_sigreturn.S      |  4 +++
 arch/riscv/kernel/vdso/sys_hwprobe.S       |  4 +++
 arch/riscv/kernel/vdso/vgetrandom-chacha.S |  5 +++-
 9 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index ecf2fcce2d92..f60c2de0ca08 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -81,9 +81,12 @@ riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZACAS) := $(riscv-march-y)_zacas
 # Check if the toolchain supports Zabha
 riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZABHA) := $(riscv-march-y)_zabha
 
+KBUILD_BASE_ISA = -march=$(shell echo $(riscv-march-y) | sed -E 's/(rv32ima|rv64ima)fd([^v_]*)v?/\1\2/')
+export KBUILD_BASE_ISA
+
 # Remove F,D,V from isa string for all. Keep extensions between "fd" and "v" by
 # matching non-v and non-multi-letter extensions out with the filter ([^v_]*)
-KBUILD_CFLAGS += -march=$(shell echo $(riscv-march-y) | sed -E 's/(rv32ima|rv64ima)fd([^v_]*)v?/\1\2/')
+KBUILD_CFLAGS += $(KBUILD_BASE_ISA)
 
 KBUILD_AFLAGS += -march=$(riscv-march-y)
 
diff --git a/arch/riscv/include/asm/assembler.h b/arch/riscv/include/asm/assembler.h
index 16931712beab..f449c4392c29 100644
--- a/arch/riscv/include/asm/assembler.h
+++ b/arch/riscv/include/asm/assembler.h
@@ -80,3 +80,47 @@
 	.endm
 
 #endif	/* __ASM_ASSEMBLER_H */
+
+#if defined(VDSO_CFI) && (__riscv_xlen == 64)
+.macro vdso_lpad, label = 0
+lpad \label
+.endm
+#else
+.macro vdso_lpad, label = 0
+.endm
+#endif
+
+/*
+ * This macro emits a program property note section identifying
+ * architecture features which require special handling, mainly for
+ * use in assembly files included in the VDSO.
+ */
+#define NT_GNU_PROPERTY_TYPE_0  5
+#define GNU_PROPERTY_RISCV_FEATURE_1_AND 0xc0000000
+
+#define GNU_PROPERTY_RISCV_FEATURE_1_ZICFILP      (1U << 0)
+#define GNU_PROPERTY_RISCV_FEATURE_1_ZICFISS      (1U << 1)
+
+#if defined(VDSO_CFI) && (__riscv_xlen == 64)
+#define GNU_PROPERTY_RISCV_FEATURE_1_DEFAULT \
+	(GNU_PROPERTY_RISCV_FEATURE_1_ZICFILP | GNU_PROPERTY_RISCV_FEATURE_1_ZICFISS)
+#endif
+
+#ifdef GNU_PROPERTY_RISCV_FEATURE_1_DEFAULT
+.macro emit_riscv_feature_1_and, feat = GNU_PROPERTY_RISCV_FEATURE_1_DEFAULT
+	.pushsection .note.gnu.property, "a"
+	.p2align        3
+	.word           4
+	.word           16
+	.word           NT_GNU_PROPERTY_TYPE_0
+	.asciz          "GNU"
+	.word           GNU_PROPERTY_RISCV_FEATURE_1_AND
+	.word           4
+	.word           \feat
+	.word           0
+	.popsection
+.endm
+#else
+.macro emit_riscv_feature_1_and, feat = 0
+.endm
+#endif
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 9ebb5e590f93..272f1d837a80 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -17,6 +17,11 @@ ifdef CONFIG_VDSO_GETRANDOM
 vdso-syms += getrandom
 endif
 
+ifdef VDSO_CFI_BUILD
+CFI_MARCH = _zicfilp_zicfiss
+CFI_FULL = -fcf-protection=full
+endif
+
 # Files to link into the vdso
 obj-vdso = $(patsubst %, %.o, $(vdso-syms)) note.o
 
@@ -27,6 +32,10 @@ endif
 ccflags-y := -fno-stack-protector
 ccflags-y += -DDISABLE_BRANCH_PROFILING
 ccflags-y += -fno-builtin
+ccflags-y += $(KBUILD_BASE_ISA)$(CFI_MARCH)
+ccflags-y += $(CFI_FULL)
+asflags-y += $(KBUILD_BASE_ISA)$(CFI_MARCH)
+asflags-y += $(CFI_FULL)
 
 ifneq ($(c-gettimeofday-y),)
   CFLAGS_vgettimeofday.o += -fPIC -include $(c-gettimeofday-y)
@@ -79,7 +88,7 @@ include/generated/vdso-offsets.h: $(obj)/vdso.so.dbg FORCE
 # The DSO images are built using a special linker script
 # Make sure only to export the intended __vdso_xxx symbol offsets.
 quiet_cmd_vdsold_and_check = VDSOLD  $@
-      cmd_vdsold_and_check = $(LD) $(ld_flags) -T $(filter-out FORCE,$^) -o $@.tmp && \
+      cmd_vdsold_and_check = $(LD) $(CFI_FULL) $(ld_flags) -T $(filter-out FORCE,$^) -o $@.tmp && \
                    $(OBJCOPY) $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
                    rm $@.tmp && \
                    $(cmd_vdso_check)
diff --git a/arch/riscv/kernel/vdso/flush_icache.S b/arch/riscv/kernel/vdso/flush_icache.S
index 8f884227e8bc..e4c56970905e 100644
--- a/arch/riscv/kernel/vdso/flush_icache.S
+++ b/arch/riscv/kernel/vdso/flush_icache.S
@@ -5,11 +5,13 @@
 
 #include <linux/linkage.h>
 #include <asm/unistd.h>
+#include <asm/assembler.h>
 
 	.text
 /* int __vdso_flush_icache(void *start, void *end, unsigned long flags); */
 SYM_FUNC_START(__vdso_flush_icache)
 	.cfi_startproc
+	vdso_lpad
 #ifdef CONFIG_SMP
 	li a7, __NR_riscv_flush_icache
 	ecall
@@ -20,3 +22,5 @@ SYM_FUNC_START(__vdso_flush_icache)
 	ret
 	.cfi_endproc
 SYM_FUNC_END(__vdso_flush_icache)
+
+emit_riscv_feature_1_and
diff --git a/arch/riscv/kernel/vdso/getcpu.S b/arch/riscv/kernel/vdso/getcpu.S
index 9c1bd531907f..5c1ecc4e1465 100644
--- a/arch/riscv/kernel/vdso/getcpu.S
+++ b/arch/riscv/kernel/vdso/getcpu.S
@@ -5,14 +5,18 @@
 
 #include <linux/linkage.h>
 #include <asm/unistd.h>
+#include <asm/assembler.h>
 
 	.text
 /* int __vdso_getcpu(unsigned *cpu, unsigned *node, void *unused); */
 SYM_FUNC_START(__vdso_getcpu)
 	.cfi_startproc
+	vdso_lpad
 	/* For now, just do the syscall. */
 	li a7, __NR_getcpu
 	ecall
 	ret
 	.cfi_endproc
 SYM_FUNC_END(__vdso_getcpu)
+
+emit_riscv_feature_1_and
diff --git a/arch/riscv/kernel/vdso/note.S b/arch/riscv/kernel/vdso/note.S
index 2a956c942211..3d92cc956b95 100644
--- a/arch/riscv/kernel/vdso/note.S
+++ b/arch/riscv/kernel/vdso/note.S
@@ -6,7 +6,10 @@
 
 #include <linux/elfnote.h>
 #include <linux/version.h>
+#include <asm/assembler.h>
 
 ELFNOTE_START(Linux, 0, "a")
 	.long LINUX_VERSION_CODE
 ELFNOTE_END
+
+emit_riscv_feature_1_and
diff --git a/arch/riscv/kernel/vdso/rt_sigreturn.S b/arch/riscv/kernel/vdso/rt_sigreturn.S
index 3dc022aa8931..e82987dc3739 100644
--- a/arch/riscv/kernel/vdso/rt_sigreturn.S
+++ b/arch/riscv/kernel/vdso/rt_sigreturn.S
@@ -5,12 +5,16 @@
 
 #include <linux/linkage.h>
 #include <asm/unistd.h>
+#include <asm/assembler.h>
 
 	.text
 SYM_FUNC_START(__vdso_rt_sigreturn)
 	.cfi_startproc
 	.cfi_signal_frame
+	vdso_lpad
 	li a7, __NR_rt_sigreturn
 	ecall
 	.cfi_endproc
 SYM_FUNC_END(__vdso_rt_sigreturn)
+
+emit_riscv_feature_1_and
diff --git a/arch/riscv/kernel/vdso/sys_hwprobe.S b/arch/riscv/kernel/vdso/sys_hwprobe.S
index 77e57f830521..f1694451a60c 100644
--- a/arch/riscv/kernel/vdso/sys_hwprobe.S
+++ b/arch/riscv/kernel/vdso/sys_hwprobe.S
@@ -3,13 +3,17 @@
 
 #include <linux/linkage.h>
 #include <asm/unistd.h>
+#include <asm/assembler.h>
 
 .text
 SYM_FUNC_START(riscv_hwprobe)
 	.cfi_startproc
+	vdso_lpad
 	li a7, __NR_riscv_hwprobe
 	ecall
 	ret
 
 	.cfi_endproc
 SYM_FUNC_END(riscv_hwprobe)
+
+emit_riscv_feature_1_and
diff --git a/arch/riscv/kernel/vdso/vgetrandom-chacha.S b/arch/riscv/kernel/vdso/vgetrandom-chacha.S
index 5f0dad8f2373..916ab30a88f7 100644
--- a/arch/riscv/kernel/vdso/vgetrandom-chacha.S
+++ b/arch/riscv/kernel/vdso/vgetrandom-chacha.S
@@ -7,6 +7,7 @@
 
 #include <asm/asm.h>
 #include <linux/linkage.h>
+#include <asm/assembler.h>
 
 .text
 
@@ -74,7 +75,7 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 #define _20		20, 20, 20, 20
 #define _24		24, 24, 24, 24
 #define _25		25, 25, 25, 25
-
+	vdso_lpad
 	/*
 	 * The ABI requires s0-s9 saved.
 	 * This does not violate the stack-less requirement: no sensitive data
@@ -247,3 +248,5 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 
 	ret
 SYM_FUNC_END(__arch_chacha20_blocks_nostack)
+
+emit_riscv_feature_1_and

-- 
2.43.0


