Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 776C0606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 07:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e7XZKBhe
Received: by kanga.kvack.org (Postfix)
	id 995DF6B05B4; Sat,  7 Nov 2026 02:40:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 946556B05B7; Sat,  7 Nov 2026 02:40:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85C646B05B8; Sat,  7 Nov 2026 02:40:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 672686B05B4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:40:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EDF851A0253
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:40:52 +0000 (UTC)
X-FDA: 85407526344.22.A692382
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6B2FB1A0002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:40:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7XZKBhe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794037251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mb6zscB9xA65zKWgADOGhrqsQ/nGHmGTb9eOGjPV3Qo=;
	b=7kGgsxp60DCn/R7H7dYqVwjwfCDRmCRASgB7oqKqz4oXYsPXe0rlR+SKLkU257fFX4tAPF
	dYFlTW0yvwNwr2mlfpESkBQku3Fw4m8+qUD9pcPUTEqNLDaCFmTgtJJ++KMaSupI2YDJzu
	zsryU/p2M/yu3021GqVoOW5ONgmVhkY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7XZKBhe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794037251;
	b=XrjVLfwZ3Q307NCZGChMEifjJcMb4C8zGUzCK0Ruq9AEmzOv8bFORXBxhBpN3ll1KTXdrv
	aNXT6UnODS/FHBXj54hKn1/Y1XHYbt1F4qIiU5RGV0IJA/P3VsBO02yiFsfTcIxsk0vs8V
	TcU6alKiqzjWluGayb6UtM9PQFwWx4k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1742160F6B;
	Sat,  7 Nov 2026 07:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6821F0089F;
	Sat,  7 Nov 2026 07:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794036847;
	bh=mb6zscB9xA65zKWgADOGhrqsQ/nGHmGTb9eOGjPV3Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7XZKBheSrKbie5VnFexSeQbIOTBncXvr7lTKpAFdHOkLHTyzufBqIEvQc9/QUiZ8
	 bL0NQ6orZouqNfUCKfpZ93GbXCDENZP3lgZx7PEYSf5lLFHd5Bq9UYCUbBfFHXQg+x
	 OsAnvXdsQb7OPApbsT+etftmAEHezMs1DTCkZNlGpuF8bwSR7PFW/NFSpZ03yzXh6y
	 1KHmLi06/f4BWOxmc2z1ozGzpCSYF1c5a6f309R7NTf0wba/KhbLzfqP7cnjE828pi
	 RKrj7UhzORA2cvJwgMKPTkt0PKzzUB37T0ehen5rlXy5L2w/Gr8ikx2vFSsL8eQTMh
	 QyeG/kAuci3Ag==
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
Subject: [PATCH 4/4] arm64: alternatives: Make branch and ADRP offset helpers noinst
Date: Sat,  7 Nov 2026 15:13:39 +0800
Message-ID: <20261107071339.17467-5-jszhang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261107071339.17467-1-jszhang@kernel.org>
References: <20261107071339.17467-1-jszhang@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6B2FB1A0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: h18nksdyw5nszsbjupkqk8jtfqdrpgut
X-HE-Tag: 1794037251-985971
X-HE-Meta: U2FsdGVkX1+sYr0evtkpEdPVaDZ9ryMggCVDzskKlEGTz8b5prPZDQmluCyXWOhWmOLWNUuf/YUcaoErfMQb/8USR1GwGNO9UrMAqN8VcQquT5H6pW8stIBKOV73eevjsXE6Tz2ZYwXvdUVX1UvkJwPv3IbCVIlI/JZuUGQm4gYgzycirkeOSJ1SKIfoMLO49pzatUjtMmavMXXV3gXkTkbt6o0yECdKz537B47HlFKqvC9rVef0mjqLQ2fOEOjDnwrccFRiLtPhywSm6Rh8R65coaahH4Hob3hFFMlFKfE7Ob2nP2nI9HdrGLO3S/+DkyD9XRqSTNUHAxG8oznhtIzFtq5kqcFOAwbHdoQHZfWWOpIZVgMmH/gbvtc/LqQBp/kfwpAsiSm3ljWAcVPQT7aYpfLHluPb/PQvYyj3iXxRHUOF3AISxNjQwgWX4+iW/9noSwX2VRrDHPAUBARGBsgDA35t+zvKGN5tfUu2VDZC/vRipdiN5x5GqhlYs6u2ZZu2RLF2PIFOBqWqjHQF558mKiQSp+2NpvgHRfuW0nUrp7BuFHtEBdx0kieBZhM/ihVW+JBQNe3DRGX1Em42dtQYxmRMjBQF1FPo19Pc7TAeY3spJrCJbkOWCB0Y1OtXAk3b5KDgJAJs3TXKSTfYTR/mZiSJH1CijHrKj9i4RYmtK5J9vhB5YmU8zFWg8BkxaPYJhHZQIXMZH4Fo7KUs4j/ZH2PjLTPsjrLD3Qha+3DO7GMHwDmN35v1gnz0g5jXYcczSHbuzKKlHblnYPaK3WVwwFq94IdhbnCN+PsZd3bvQ3AfqIMCj0StxQWcmV3fKZbHXk/unoQw0chKs/gN96cOYxSJgnvtEAlDWZQqaVhdSOYKQcam4+Ov32qOIZZOkgukJaMEWlmpiMbY3C0k+k8x63lSbmp0fxF3AIDe9gCU4xevADAEWR3ZvlnX97w8jVxU+5+kgwYUIKJfphC
 /V1r97aG
 QQlppZ9rjhBh7VJUSB5E3cYgDLKy3nh3J5rJR2qOgP+YzIWHl9McYKiv8IIgVkHOh9rMIpmre/ou43FWIZ8VwHoNFGzp1THZ1sr469HfHNpi6smIy2bBwCh2Qb7OJXNluXc/8Y5ur3t1MmZER1TVM1KSC9NKz3YBgDydvIvXdpGnHY8+3Xm19qNGUZe+Ws10vQ5Xo5+PQ9QhXcaLu4DyCwd6m8BXu7Sv/DiNiaA64lZmafh0XrpG7bXHrbJDpJkfkRG1MIdyGdiByQjroFP+/Jc2EWkULQs2JBl1g3YCRQN8ggPL7nfQkOR6PZw==
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


