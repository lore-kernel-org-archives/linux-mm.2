Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8D67606A332
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RfxHncTq
Received: by kanga.kvack.org (Postfix)
	id 7292F6B05C1; Mon,  9 Nov 2026 07:05:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 701466B05C2; Mon,  9 Nov 2026 07:05:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A17F6B05C3; Mon,  9 Nov 2026 07:05:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3BC6B05C1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:05:39 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C334B1405F7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:05:38 +0000 (UTC)
X-FDA: 85415451156.30.C070485
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 28ECFC0009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:05:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RfxHncTq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794225937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mb6zscB9xA65zKWgADOGhrqsQ/nGHmGTb9eOGjPV3Qo=;
	b=moi2MNv1NCuTSznL9HRrov9q/Z45ZpzRpcoPNnRi6dhC1PbXn71IcalNK4X4b8//rfYmVE
	dhXRI7vsfrrAV5dtY/n+ZDWcE1A5Ne4g7dOIDv5INtPOq7XTlV8Oq7/ZdkVeAr8To66WiG
	Duz4I8yvkCP9qFj0HMGfTq9NAlfcyk8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794225937;
	b=HGSPcxeIF9+3ovl/6pGnPORXDvI0WOk/j+sToXW98JmMEv8xVUBZxp1PwKRz5JbDPBoT6G
	H5uaVantBxOmp9v8fmYuJ8gf0fKp6If+AacnFLYzADag4pXZdbiaHNUY9zHAQ4YXDRdNqv
	trgUzuc0SOtXfKFkSHE+pmnDQk0KlfE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RfxHncTq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 820BD4588D;
	Mon,  9 Nov 2026 12:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BA01F008A3;
	Mon,  9 Nov 2026 12:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794225936;
	bh=mb6zscB9xA65zKWgADOGhrqsQ/nGHmGTb9eOGjPV3Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RfxHncTqGmZ8TCef+6tWTgry+fmHYOt1r113jnwW6tvWLT75/HuVzVwwM0rnYytjo
	 YPyJowg1fiHxzT8NeyDJYnOgIvo9zkbN16X/iwJFDxb9lkdl2UXbNfnJw7CsxuLAhO
	 6itAed9ea0+YQtKEGy/bcDnpws+CE01M/oVcdNG7IW4QzRZeB9b32E30RnzaeAy374
	 34I+0+Hf4xVLb7QfnBaxFyVBHwynjfKxOpio5H/vyMD4IrX5cBHysT5Oxprv0cPb0G
	 tFmSopTnbOnb8IkL5sezYF0q18gOBkkkrTFV04DBcvb1lzGRBJEo09Nwql+8wY4Nmt
	 Ogrx3vqVJ1xhQ==
From: Jisheng Zhang <jszhang@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Tejun Heo <tj@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: [PATCH v2 6/6] arm64: alternatives: Make branch and ADRP offset helpers noinst
Date: Mon,  9 Nov 2026 19:44:59 +0800
Message-ID: <20261109114500.20298-7-jszhang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261109114500.20298-1-jszhang@kernel.org>
References: <20261109114500.20298-1-jszhang@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nwwsibjuyd17cfhoawomu1454m7o7mh4
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 28ECFC0009
X-HE-Tag: 1794225937-979903
X-HE-Meta: U2FsdGVkX18VSB5I7YN6mIPZYBQ0TwCqecabN8Wh+KNjbRCEywtawTaFhjUYsXiJDK2ICEpT+Y7fY+2Slohsscs/n3nHa9y4HvSDS0WS3QrBCH9kS/9U1TOGQZs4RcxPZsFrLNPAQkvKdHqgQAj3adfYFWTtd6v99AX8rw54LDBhuNY9c/h8DpUOsarOXhZ8jQDtO4wxMPyG+/R4bYkPHIyfoXysfHHfxhNF46sygA4eabR4upPrS6qgUcztq5tD1ChvcDDCrPaPEUZmcrdrJHYTrUVJlf9scv53nvqq39SoB9O4jh9IHNHvNQewekFFtSm+sE8i1JDOvudo2bB/b9onZUMVWDgdcvh+RcfRSrgCvbR+7BWmpUo59+hZ7Ibss/26TUd6tuJvN5O6GNqJTPWkAG/+Q5fQJypKAdUfJBKdSkh09aqwJ/Tc/Ld/UJ9qB1pUkbxhlKJBfMSCB0sHAGzhMpAyyFYvfPMOPeXoLIXt+CrtQX1FqXRDlUeSFV50uJnKO2dTgQyIBUCUCxWw6ww9trdqnGi9M75hidXzWCJz6Vs2IPyEAnqGh3ZMqgCO+mlhWmxe696q5J+DMBBPT8G+SWyIkgS8lb4JQEjasnqJlapTFPT+m2oQ8lAmYm6tk38M75mGGw2nct9O7kFW9pVwf1fYCmsILshVOkptx0CG703xDeDCEd16YHbdD0+Ce8Sw1WJMrS9BFlRDM8446XjalQmP2KSodX64m5GJ2AmAVjyFZVWKeuWgxrnX5c7HR3SbuIcTJARCoq1V+27vyJIr978zVTGMqe2AZCVZqJXebPGmnrg7Ku5DEb4vtWUl1Bt2JBpxT2u6pqcotNYUSz8K9seSGNiyEq5DD2dJmOQtVqUZLxeXM2MrTXbNXNYU1sy7/uGM/1ViRoEUyI5b83gqfLS63Szpz4AzGbUtePlWSeK88EWT2WlyUe1xF7fp9XIOT7f8BPni+fn8WDb
 bOvHC3jq
 vGTXZGkxY1RxuBQxmTuQ6EXh+YJLgjMFUyexXSEsh3HX8XAc53jS5YPC/dLEPuoU17Twq8zxpY/AVnunvQ5RaDGZQ+/ZfEaZok0alln74EuE1w57M1Km9OXCIqDp/5waYj60gs13bRhNWWdXK42ixYTpRbERO9Iqa/P9HTB1/ls67Ln3HMYLRgP02WTqL7L5z3LAI9iJNE7xnG75P8UmvhEcluk/EMsVuDAyB5S6fNsAxEXdppNzvgImRqn8fBtkqNOyg9ZeIhIvlfYQt6tajlkF6IQptdtkTw9En9NHUntylOntDHAfyQOBt/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

patch_alternative() must avoid instrumented code while alternatives
are being modified, before cache maintenance completes. However, its
branch and ADRP offset helpers are instrumentable. A GCC build with
function tracing enabled emitted ftrace patchable entries for these
helpers.

Mark the four offset helpers noinstr. Introduce private
__always_inline immediate encoding and decoding implementations for
their use, and force inline the immediate mask helper.

The offset helpers pass constant encoding types, allowing the compiler
to eliminate invalid-type diagnostic paths. Keep the public immediate
helpers as wrappers to preserve diagnostics for other callers.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Assisted-by: LLM
---
 arch/arm64/lib/insn.c | 57 ++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/lib/insn.c b/arch/arm64/lib/insn.c
index e70ac0238515..b98610fcab32 100644
--- a/arch/arm64/lib/insn.c
+++ b/arch/arm64/lib/insn.c
@@ -21,7 +21,7 @@
 #define AARCH64_INSN_N_BIT	BIT(22)
 #define AARCH64_INSN_LSL_12	BIT(22)
 
-static int __kprobes aarch64_get_imm_shift_mask(enum aarch64_insn_imm_type type,
+static __always_inline int aarch64_get_imm_shift_mask(enum aarch64_insn_imm_type type,
 						u32 *maskp, int *shiftp)
 {
 	u32 mask;
@@ -86,7 +86,12 @@ static int __kprobes aarch64_get_imm_shift_mask(enum aarch64_insn_imm_type type,
 #define ADR_IMM_LOSHIFT		29
 #define ADR_IMM_HISHIFT		5
 
-u64 aarch64_insn_decode_immediate(enum aarch64_insn_imm_type type, u32 insn)
+/*
+ * Keep the immediate helpers inline so noinstr callers using constant encoding
+ * types do not call instrumentable code, including the invalid-type diagnostics.
+ */
+static __always_inline u64
+__aarch64_insn_decode_immediate(enum aarch64_insn_imm_type type, u32 insn)
 {
 	u32 immlo, immhi, mask;
 	int shift;
@@ -101,8 +106,8 @@ u64 aarch64_insn_decode_immediate(enum aarch64_insn_imm_type type, u32 insn)
 		break;
 	default:
 		if (aarch64_get_imm_shift_mask(type, &mask, &shift) < 0) {
-			pr_err("%s: unknown immediate encoding %d\n", __func__,
-			       type);
+			pr_err("%s: unknown immediate encoding %d\n",
+			       "aarch64_insn_decode_immediate", type);
 			return 0;
 		}
 	}
@@ -110,8 +115,14 @@ u64 aarch64_insn_decode_immediate(enum aarch64_insn_imm_type type, u32 insn)
 	return (insn >> shift) & mask;
 }
 
-u32 __kprobes aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
-				  u32 insn, u64 imm)
+u64 aarch64_insn_decode_immediate(enum aarch64_insn_imm_type type, u32 insn)
+{
+	return __aarch64_insn_decode_immediate(type, insn);
+}
+
+static __always_inline u32
+__aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
+			      u32 insn, u64 imm)
 {
 	u32 immlo, immhi, mask;
 	int shift;
@@ -131,8 +142,8 @@ u32 __kprobes aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
 		break;
 	default:
 		if (aarch64_get_imm_shift_mask(type, &mask, &shift) < 0) {
-			pr_err("%s: unknown immediate encoding %d\n", __func__,
-			       type);
+			pr_err("%s: unknown immediate encoding %d\n",
+			       "aarch64_insn_encode_immediate", type);
 			return AARCH64_BREAK_FAULT;
 		}
 	}
@@ -144,6 +155,12 @@ u32 __kprobes aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
 	return insn;
 }
 
+u32 __kprobes aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
+					  u32 insn, u64 imm)
+{
+	return __aarch64_insn_encode_immediate(type, insn, imm);
+}
+
 u32 aarch64_insn_decode_register(enum aarch64_insn_register_type type,
 					u32 insn)
 {
@@ -1299,23 +1316,23 @@ u32 aarch64_insn_gen_adr(unsigned long pc, unsigned long addr,
  * signed value (so it can be used when computing a new branch
  * target).
  */
-s32 aarch64_get_branch_offset(u32 insn)
+s32 noinstr aarch64_get_branch_offset(u32 insn)
 {
 	s32 imm;
 
 	if (aarch64_insn_is_b(insn) || aarch64_insn_is_bl(insn)) {
-		imm = aarch64_insn_decode_immediate(AARCH64_INSN_IMM_26, insn);
+		imm = __aarch64_insn_decode_immediate(AARCH64_INSN_IMM_26, insn);
 		return (imm << 6) >> 4;
 	}
 
 	if (aarch64_insn_is_cbz(insn) || aarch64_insn_is_cbnz(insn) ||
 	    aarch64_insn_is_bcond(insn)) {
-		imm = aarch64_insn_decode_immediate(AARCH64_INSN_IMM_19, insn);
+		imm = __aarch64_insn_decode_immediate(AARCH64_INSN_IMM_19, insn);
 		return (imm << 13) >> 11;
 	}
 
 	if (aarch64_insn_is_tbz(insn) || aarch64_insn_is_tbnz(insn)) {
-		imm = aarch64_insn_decode_immediate(AARCH64_INSN_IMM_14, insn);
+		imm = __aarch64_insn_decode_immediate(AARCH64_INSN_IMM_14, insn);
 		return (imm << 18) >> 16;
 	}
 
@@ -1327,35 +1344,35 @@ s32 aarch64_get_branch_offset(u32 insn)
  * Encode the displacement of a branch in the imm field and return the
  * updated instruction.
  */
-u32 aarch64_set_branch_offset(u32 insn, s32 offset)
+u32 noinstr aarch64_set_branch_offset(u32 insn, s32 offset)
 {
 	if (aarch64_insn_is_b(insn) || aarch64_insn_is_bl(insn))
-		return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_26, insn,
+		return __aarch64_insn_encode_immediate(AARCH64_INSN_IMM_26, insn,
 						     offset >> 2);
 
 	if (aarch64_insn_is_cbz(insn) || aarch64_insn_is_cbnz(insn) ||
 	    aarch64_insn_is_bcond(insn))
-		return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_19, insn,
+		return __aarch64_insn_encode_immediate(AARCH64_INSN_IMM_19, insn,
 						     offset >> 2);
 
 	if (aarch64_insn_is_tbz(insn) || aarch64_insn_is_tbnz(insn))
-		return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_14, insn,
+		return __aarch64_insn_encode_immediate(AARCH64_INSN_IMM_14, insn,
 						     offset >> 2);
 
 	/* Unhandled instruction */
 	BUG();
 }
 
-s32 aarch64_insn_adrp_get_offset(u32 insn)
+s32 noinstr aarch64_insn_adrp_get_offset(u32 insn)
 {
 	BUG_ON(!aarch64_insn_is_adrp(insn));
-	return aarch64_insn_decode_immediate(AARCH64_INSN_IMM_ADR, insn) << 12;
+	return __aarch64_insn_decode_immediate(AARCH64_INSN_IMM_ADR, insn) << 12;
 }
 
-u32 aarch64_insn_adrp_set_offset(u32 insn, s32 offset)
+u32 noinstr aarch64_insn_adrp_set_offset(u32 insn, s32 offset)
 {
 	BUG_ON(!aarch64_insn_is_adrp(insn));
-	return aarch64_insn_encode_immediate(AARCH64_INSN_IMM_ADR, insn,
+	return __aarch64_insn_encode_immediate(AARCH64_INSN_IMM_ADR, insn,
 						offset >> 12);
 }
 
-- 
2.55.0


