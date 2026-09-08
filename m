Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5215DC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3276B00A0; Tue,  8 Sep 2026 09:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294576B00A1; Tue,  8 Sep 2026 09:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D926B00A2; Tue,  8 Sep 2026 09:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D55D06B00A0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:14:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 771B2A503C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:14:04 +0000 (UTC)
X-FDA: 85190638008.09.214D521
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id A578E18000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:14:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lPw/po6N";
	spf=pass (imf06.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788873242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=whtEbb8/XqGjTBPOJjMO+bu+KwkFFXfQbBIPnf5a/B4=;
	b=VJON2dPz/JUAJaXAfs6pXymJ4aA2UctfRY9PS/nQZeLa4/z9yoi75dXNiwen6oI13oxa/J
	UJtrNP15UPOT4a8Pf1BH9ZHQ9zwhb5pFUJlTtbJDPvdUajYX9FSmoF8kdJvMXOWbqavz1W
	VVpCsPv1C5CjOGaZM0rqEUtAqM3bF+c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lPw/po6N";
	spf=pass (imf06.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788873242;
	b=hfyUZkjNDww6VCKQ8LTAby6MUKdtrI3YyZMx7LQ+Yh7hOGUBYPaSH8Ni03n2/kGxhHMu5a
	QduBIoF1xP3OuWPldtNOsncY3PzSxWj+B+dsrBkElzwu4wSKj+A1Ze/A3r6nbLbxLoTgb1
	bAaD4gYB8hEW5OXeSqR1J+TJDMQCXBU=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c250c6a6a9aso762660466b.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788873241; x=1789478041; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=whtEbb8/XqGjTBPOJjMO+bu+KwkFFXfQbBIPnf5a/B4=;
        b=lPw/po6N6OT4x/tYBPDhf+LAsOJ2eXzcX9T6gBxNXtHhx5HURwufml3EGP4aRK+/CO
         pipfLNLTJqn+dEvkuRKgSjJHSb+4XhD9vEIApkkirkPdeEnxFOSFIBd79oxZt+sgOWqU
         HBVLv/nFfTIOtSrN/gwg6m4e3kXGV+brRu2PmKHkuMV0zAlqS50c/m9bBDsmi1u7AWTP
         6naF06D8lV8gynWAMPCw/G/2LYifPAy4alcKnsAgDKXeCwG1dFzztR3XPPYS5jLcq54P
         fG1Hiy7xqBs4cNFaR1w/wZwRn/n0Z78kXqwY84K++CoJVIX9/2tRxpFkx90wAd6EbVB7
         lreQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788873241; x=1789478041;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=whtEbb8/XqGjTBPOJjMO+bu+KwkFFXfQbBIPnf5a/B4=;
        b=iQIDKwNwNvy2N08lHZJ5RPKDCE8m5MvanK5/rGpiz69OYQRbT47yVEIYI6aGdFADz2
         7bomiTzeNGaBDevp+mSOR3moN5akeEcdNJqn2Ti0cTbXLltcf8HrH/TNKzyymfOa8AMo
         n8yNaRQldU89SWYu5bZ4x0j8/7n05pZCT0Ho6xGLXGfUZqc/1hZQ12dFw86MBMQ3GThS
         tAcz/KS4DLql2IieQ8PU2npCUR7VqeTaNgMCAFD21YQ2c+6zkx9WpX9XRpNWVdXAPJ2l
         OIQFSzpzlWBH/tdfrLepApUHBLoIJJa9KbfmvDVTlA6s1sSA0vFwFo/O5WDkOqAR1NkY
         vc8A==
X-Gm-Message-State: AFuF++m33WMpPox0N5j5jIHfkzq1VcLIQGkJjme7W+2O31DXhN4U6ICi
	P+jBqzf/ErssWp7xYXmN4dnLxXbMRk55NV90WikP6gS2r8h4KjXNo4uU
X-Gm-Gg: AYBFou1Gkg/AWVe5vIVJCx4HDFfGdRVWmbIMSNtsyh+BiHE0F10wbotTFUuG7kO4wR2
	BcxdS0JXqnqfYa4WMVt8qcMyFaO3kOdx9eC1Srpq4vVcEv6geVH/6v3/DcvbywDYINHzlt5VtnC
	FS5zfs1AJ9pFcwRz0Zd+p9lPPFn6GU38+QceCV6wPhDKb2O5AP7i+dR2KkP05SpQJn4mbFvlWaw
	HDdtShXVZ8RHTNXH9hzCsuPXGyWS6LXxvP/ecIMSOnFg8Xyljn8ctKoPTWITngA3EgnzD09s5P4
	/hg/uh7SlmVsOiPx/PFOiWjSERRdffuK46f4YhIdEABQ8ouI98FGZfnQ84Q/wFRjSnrzMfGHUdK
	7IQASKBRtJuo32RhdFVlWwY2p+WokUtyCeu2A9skwwemY6KclUUXw7FkXaoSCANARVxi97iNulM
	U5XRDm4t+Dw6Wi8qD9gM0JLF0Qc+aZlhqHHA8BssAgww3Oic1u/Q==
X-Received: by 2002:a17:907:7b8c:b0:c19:49ee:19b9 with SMTP id a640c23a62f3a-c260cbfa1a6mr2202057266b.15.1788873241205;
        Tue, 08 Sep 2026 06:14:01 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:37a9:1e5a::306:1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d6e1c93sm625170866b.63.2026.09.08.06.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:14:00 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Tue, 08 Sep 2026 14:13:42 +0100
Subject: [PATCH RFC v2 09/11] stackdepot: add architecture hooks for
 compact frame storage
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-stackdepot-trie-v2-9-1996d5cef732@cloudflare.com>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
In-Reply-To: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A578E18000B
X-Stat-Signature: wtz7crqty1euikbboawhqkr6w5zitfwg
X-Rspam-User: 
X-HE-Tag: 1788873242-52867
X-HE-Meta: U2FsdGVkX1/yMiLyHczIMgXvBb6OuKEy8A+75BUqfgIUGBsMUDTomE6jAskiKVt4zJ/nfWoSfBe+8J5XBeKmzHI/baWyDpNOMUObuLaHMgy1Im+MCZhxWX04idsQN3Ug+0I8vm31YqMOdBMd8gBrWaX9wxC674RcyTLG/IEjYj0WisDJXkST8atmiJz6vfzpObatmRPseGJ4CsPj4mnda2Yqkgj2H0e3CLCcVHOP/tOR7sTU2zt4WNeIU7Pr7K2/KWtxybO9fbtsENdDRn+AgxYr/KreYeuh8OY1jec2SMPLIlK2oEDsA3gfeVsIyVdwdANou8GJeE5WsHaN7wYL0NM432NogPiogCXE61sqZrB5eCkBq4YiQHMUhj2mg7Zd3sMr7+pfSNVOUL89M/l6JnzbHFqRl2z8o/jp7x1dKhptMxC3YqKnEe6IxJaMeMOWKbrcfDfTghQTZ5hi/1kDsfVorxfG0ZGaeS6TDfT5cyjb/eH0zBhBPtZ6858bGB/gdMOsye/unfF2BD+kwJGW8GlJrMNR1Bh0IjiF9h75iUkNRZp/kl8Cjj+D4rG86amlElaX6iYiEoEAAKAaK81qYxDt4Eq2SpMBhOdsxLrTFZc0ryoexA8EyoV26R+WvVRP0M2pczZPyAEIRviiozWyoHTUR6HjuXhdzicUhquTvTUtSkyB88LA/Ok7p4VVBOpZbX3hLQYQN4i5CHRcguNepHsxtIcut5A0mwyWEvv+Rq3Mofwr3jQGo8FskJ7yZxeIDKzwc6qjW9rYYhIXOuqKumW5Uchg351rVoivRAd2wz+yns1wS8il6JgDMAXmpd/ga03/I0TS39lZHuXU3LJ9r6XPQaWy4LjvXGh+5BWFd63rP/MeEhQYORPLF3M/KVJ7DfSVynUladkjmiCbu6ZDB7ij/Y9faQ4Xe5i7wIbFLDAeoXmgksxAzoh72+kBgJYicFB18d5Tru6d0r1Glef
 WqCkbeYI
 2drcNdzLOh/eHNYBiqtQIbHN+cDyeVG81zpELwl6JBg9k7Ri/6zGUKunVeq+enRyAimVoyX3pv3GZmhqMGJjm/0J93QngMghmNlcm13HC1iq/6Wqr8r9nqTuJ7DZHftceQ4P1FA3lJ21ylxBcahjHL1IGRNApUrGc+8I1GzSk4Jh7P0xHaiYwbKJ4yDZQp19JIzPdLm7iH7MpStweIKcV1FUQvuYUm3rBjrLqPoJ84e8nIlhaAdKyf41ntHKjMM90Ka7wLYgBM9cQmGiJBxYKy3Gdi5HAirHbMi65KChPMy7O1zaMb3D0BlzwakxEpjz0ZUrUcndNe4CGMgC78KfQqhLJ0spmZKJuwF33lqTMZnKvkjPibG4IwvB6UlG3Dp+cOWJun6gQBB7wW+n8pQO9d7x8rJ8Ip20ItDnv1OL42Huos9B9DzwQjKNJTQiogfN1GjMGxLd50hlDNDUS+uNVzQAzJp2/v4/JCfnX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Caleb Kan <ckan@cloudflare.com>

Path-compressed trie nodes can reduce their frame storage further when an
architecture can represent kernel text and module addresses in 32 bits.
Add architecture hooks that compress a frame only when decompression
reproduces the original address exactly.

Store arm64 frames as signed 32-bit offsets from _text. This covers the
2 GB module relocation window without depending on a 4 GB high-bit
boundary. On x86-64, store the low 32 bits when the upper 32 bits are all
set. Keep other frames full-width, and provide a generic implementation
that always rejects compression.

Make the generic header available to architectures without a specialized
implementation and wire it explicitly for UML. Add KUnit coverage for raw
fallback, arm64 boundary round trips, and native x86-64 prefix compression.

These hooks do not change stack depot behavior until a later patch adds
trie storage.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
 arch/arm64/include/asm/stackdepot.h | 42 ++++++++++++++++++
 arch/um/include/asm/Kbuild          |  1 +
 arch/x86/include/asm/stackdepot.h   | 37 ++++++++++++++++
 include/asm-generic/Kbuild          |  1 +
 include/asm-generic/stackdepot.h    | 19 ++++++++
 lib/tests/stackdepot_kunit.c        | 86 +++++++++++++++++++++++++++++++++++++
 6 files changed, 186 insertions(+)

diff --git a/arch/arm64/include/asm/stackdepot.h b/arch/arm64/include/asm/stackdepot.h
new file mode 100644
index 000000000000..df8959d59336
--- /dev/null
+++ b/arch/arm64/include/asm/stackdepot.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_STACKDEPOT_H
+#define __ASM_STACKDEPOT_H
+
+#include <linux/types.h>
+#include <asm/sections.h>
+
+/*
+ * Modules are allocated inside a 2 GB relocation window containing the
+ * kernel image. Store a signed 32-bit offset from _text so compression is
+ * independent of 4 GB high-bit boundaries crossed by that window.
+ */
+static inline unsigned long arch_stack_depot_frame_from_payload(u32 payload)
+{
+	long offset;
+
+	offset = (s32)payload;
+	if (offset < 0)
+		return (unsigned long)_text - (unsigned long)(-offset);
+	return (unsigned long)_text + (unsigned long)offset;
+}
+
+static inline bool
+arch_stack_depot_frame_try_compress(unsigned long frame, u32 *payload)
+{
+	u32 candidate;
+
+	candidate = (u32)(frame - (unsigned long)_text);
+	if (arch_stack_depot_frame_from_payload(candidate) != frame)
+		return false;
+
+	*payload = candidate;
+	return true;
+}
+
+static inline void
+arch_stack_depot_frame_decompress(u32 payload, unsigned long *frame)
+{
+	*frame = arch_stack_depot_frame_from_payload(payload);
+}
+
+#endif /* __ASM_STACKDEPOT_H */
diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index 8fdc0bd9ab6f..14778d2457d7 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -21,6 +21,7 @@ generic-y += preempt.h
 generic-y += ring_buffer.h
 generic-y += runtime-const.h
 generic-y += softirq_stack.h
+generic-y += stackdepot.h
 generic-y += switch_to.h
 generic-y += topology.h
 generic-y += trace_clock.h
diff --git a/arch/x86/include/asm/stackdepot.h b/arch/x86/include/asm/stackdepot.h
new file mode 100644
index 000000000000..9a8d04fa8c1c
--- /dev/null
+++ b/arch/x86/include/asm/stackdepot.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_STACKDEPOT_H
+#define _ASM_X86_STACKDEPOT_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_X86_64
+/*
+ * Compress canonical kernel text/module addresses whose upper 32 bits are all
+ * ones. Other kernel virtual addresses stay raw, so decompression reconstructs
+ * the original frame by restoring this prefix.
+ */
+#define STACK_DEPOT_X86_64_FRAME_PREFIX	0xffffffff00000000UL
+#define STACK_DEPOT_X86_64_FRAME_LOW_MASK	0x00000000ffffffffUL
+
+static inline bool
+arch_stack_depot_frame_try_compress(unsigned long frame, u32 *low)
+{
+	if ((frame & ~STACK_DEPOT_X86_64_FRAME_LOW_MASK) !=
+	    STACK_DEPOT_X86_64_FRAME_PREFIX)
+		return false;
+
+	*low = (u32)frame;
+	return true;
+}
+
+static inline void
+arch_stack_depot_frame_decompress(u32 low, unsigned long *frame)
+{
+	*frame = STACK_DEPOT_X86_64_FRAME_PREFIX | low;
+}
+
+#else
+#include <asm-generic/stackdepot.h>
+#endif /* CONFIG_X86_64 */
+
+#endif /* _ASM_X86_STACKDEPOT_H */
diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index 2bc00c67dc54..d8402a6afc70 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -55,6 +55,7 @@ mandatory-y += serial.h
 mandatory-y += shmparam.h
 mandatory-y += simd.h
 mandatory-y += softirq_stack.h
+mandatory-y += stackdepot.h
 mandatory-y += switch_to.h
 mandatory-y += timex.h
 mandatory-y += tlbflush.h
diff --git a/include/asm-generic/stackdepot.h b/include/asm-generic/stackdepot.h
new file mode 100644
index 000000000000..846975767bdd
--- /dev/null
+++ b/include/asm-generic/stackdepot.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_GENERIC_STACKDEPOT_H
+#define __ASM_GENERIC_STACKDEPOT_H
+
+#include <linux/types.h>
+
+static inline bool
+arch_stack_depot_frame_try_compress(unsigned long frame, u32 *low)
+{
+	return false;
+}
+
+static inline void
+arch_stack_depot_frame_decompress(u32 low, unsigned long *frame)
+{
+	/* Generic code never compresses frames, so this hook is unreachable. */
+}
+
+#endif /* __ASM_GENERIC_STACKDEPOT_H */
diff --git a/lib/tests/stackdepot_kunit.c b/lib/tests/stackdepot_kunit.c
index 3c526791ef93..e4a7f1c83457 100644
--- a/lib/tests/stackdepot_kunit.c
+++ b/lib/tests/stackdepot_kunit.c
@@ -3,9 +3,21 @@
 #include <kunit/test.h>
 #include <linux/array_size.h>
 #include <linux/gfp.h>
+#include <linux/limits.h>
 #include <linux/stackdepot.h>
 #include <linux/string.h>
 
+#include <asm/stackdepot.h>
+
+#ifdef CONFIG_ARM64
+#include <asm/sections.h>
+
+static inline unsigned long stackdepot_arm64_frame(long offset)
+{
+	return (unsigned long)((long)_text + offset);
+}
+#endif
+
 static void stackdepot_countable_public(struct kunit *test)
 {
 	unsigned long plain_entries[] = {
@@ -125,10 +137,84 @@ static void stackdepot_fetch_into_rejects_missing_or_short_stack(struct kunit *t
 	KUNIT_EXPECT_MEMEQ(test, fetched, expected, sizeof(expected));
 }
 
+static void stackdepot_frame_raw_fallback(struct kunit *test)
+{
+	unsigned long frame = 0x1000UL;
+	bool compressed;
+	u32 payload;
+
+#ifdef CONFIG_ARM64
+	frame = (unsigned long)_text + (unsigned long)S32_MAX + 1UL;
+#endif
+
+	compressed = arch_stack_depot_frame_try_compress(frame, &payload);
+	KUNIT_EXPECT_FALSE(test, compressed);
+}
+
+#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
+static void stackdepot_frame_x86_64(struct kunit *test)
+{
+	unsigned long direct_map = 0xffff888000001000UL;
+	unsigned long frame = 0xffffffff81234567UL;
+	unsigned long out;
+	bool compressed;
+	u32 low;
+
+	compressed = arch_stack_depot_frame_try_compress(frame, &low);
+	KUNIT_EXPECT_TRUE(test, compressed);
+	KUNIT_EXPECT_EQ(test, low, (u32)0x81234567);
+	arch_stack_depot_frame_decompress(low, &out);
+	KUNIT_EXPECT_EQ(test, out, frame);
+
+	compressed = arch_stack_depot_frame_try_compress(direct_map, &low);
+	KUNIT_EXPECT_FALSE(test, compressed);
+}
+#endif /* CONFIG_X86_64 && !CONFIG_UML */
+
+#ifdef CONFIG_ARM64
+static void stackdepot_frame_arm64(struct kunit *test)
+{
+	long negative_offset = S32_MIN;
+	long positive_offset = S32_MAX;
+	long offset = 0x123456;
+	unsigned long frame = stackdepot_arm64_frame(offset);
+	unsigned long out;
+	bool compressed;
+	u32 payload;
+
+	compressed = arch_stack_depot_frame_try_compress(frame, &payload);
+	KUNIT_EXPECT_TRUE(test, compressed);
+	KUNIT_EXPECT_EQ(test, payload, (u32)(s32)offset);
+	arch_stack_depot_frame_decompress(payload, &out);
+	KUNIT_EXPECT_EQ(test, out, frame);
+
+	frame = stackdepot_arm64_frame(negative_offset);
+	compressed = arch_stack_depot_frame_try_compress(frame, &payload);
+	KUNIT_EXPECT_TRUE(test, compressed);
+	KUNIT_EXPECT_EQ(test, payload, (u32)(s32)negative_offset);
+	arch_stack_depot_frame_decompress(payload, &out);
+	KUNIT_EXPECT_EQ(test, out, frame);
+
+	frame = stackdepot_arm64_frame(positive_offset);
+	compressed = arch_stack_depot_frame_try_compress(frame, &payload);
+	KUNIT_EXPECT_TRUE(test, compressed);
+	KUNIT_EXPECT_EQ(test, payload, (u32)(s32)positive_offset);
+	arch_stack_depot_frame_decompress(payload, &out);
+	KUNIT_EXPECT_EQ(test, out, frame);
+}
+#endif /* CONFIG_ARM64 */
+
 static struct kunit_case stackdepot_test_cases[] = {
 	KUNIT_CASE(stackdepot_countable_public),
 	KUNIT_CASE(stackdepot_fetch_into_roundtrip),
 	KUNIT_CASE(stackdepot_fetch_into_rejects_missing_or_short_stack),
+	KUNIT_CASE(stackdepot_frame_raw_fallback),
+#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
+	KUNIT_CASE(stackdepot_frame_x86_64),
+#endif
+#ifdef CONFIG_ARM64
+	KUNIT_CASE(stackdepot_frame_arm64),
+#endif
 	{}
 };
 

-- 
Git-155)


