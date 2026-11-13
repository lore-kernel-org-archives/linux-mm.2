Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE6EE606F2CC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=es6pIa0a
Received: by kanga.kvack.org (Postfix)
	id DE4256B05DD; Fri, 13 Nov 2026 13:57:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6DDF6B05DF; Fri, 13 Nov 2026 13:57:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBF966B05E0; Fri, 13 Nov 2026 13:57:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 916516B05DD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:57:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31CC61402E2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:22 +0000 (UTC)
X-FDA: 85431003924.16.0B511AF
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5B47F140007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=es6pIa0a
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596240;
	b=EuwBukwKJak5evuiqH5qjCM0+tG5u1DqiaF34AyNp9ykpjl0fCzvqNSE9voj+bSqPVmGPh
	DKpKZkBEaFko1u+36AtEYm2iWv0t6i8BCbUtXYXeIbRkMDFtSvcpftAaUhkuVU9eH22QxS
	fl7u91FMgF/QYCt9oJl59AYn2AUfveY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=es6pIa0a;
	spf=none (imf26.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.44) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMf8yUDJzGPEGi0squc2iKfzOrQ0w86CHit/17hkkFQ=;
	b=CLgPoPwcDKaVn7uYSQcN0OM+5uu0fJ/DL81YD7bo5RYcEwoiIUi5l6WNvO8l6aAC/W/UkQ
	Tj7j7LM9OEyuEi0AEryW8IUjw/pIxK7/l8vCUStOeYCPszYpxPy7KvZ6+u8CIJVHRzkZkq
	I4bOw+59wTBtqk6wyKXIqQQvomE15xs=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-490a0e72588so580502f8f.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1794596239; x=1795201039; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gMf8yUDJzGPEGi0squc2iKfzOrQ0w86CHit/17hkkFQ=;
        b=es6pIa0aOXhkykrY4MFGkbh7z4ZrZIuLSI5k/AD2TtCjqkf0iOh7Atew3rm9e9XI4i
         igOd4QNAPJRO1SopC9OOoa8DxwDbTZHhCXDGKh7NFylAVU1bpGwT4JDP3Lc0jtwP3b2V
         /4IuPWqqiJrF8PrbLruIn5l18nO0Z7fUpBwlfNadDj6Zr0wUUEuxe9lTTjAxbZ93nKNZ
         9iy6yTVw5beiiEvzYZ005YI9/AMOSON1JiLNCPACjmYuHlV5CEJlNjg7TdGht81BCgp9
         z+4DN3UxtscdIoJgpb65BUSPV7endYrF5D+yywTSTBu0I68JSz81lsiUkI8TroxfdU6I
         RyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794596239; x=1795201039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gMf8yUDJzGPEGi0squc2iKfzOrQ0w86CHit/17hkkFQ=;
        b=WQOyOLSP7EcqkAenIek6DX6bRGSyQ+8xE5ii2Ua7zHq0Kxo1ppXYdYC+Z5IVHXI7UN
         lhJrPKl2HHdD1cJHa1nCstpume5Cvw0Pgw72zQ6J+wG5VxVG3xeI/R7AK+gHM37gK2su
         i4fG7g/iX8nKasXMzpBTr6a8ZSoDlPNFdSnECuXN6/bfaY92qUNW8IZmuAB4Isqqt2px
         1BB68FDNsxJr+g31ku1W1V9VGrj/9lZGe+3GVStvL5qYl5wDr7fd6yWVV94tWDPktkz+
         KQWCvY/GDLgN0ZJ4fyeqNwubbKPneLSJNhlN2gSVwo03rb5Q/U3gNdsZJh2cNR05Mvow
         k2cg==
X-Forwarded-Encrypted: i=1; AL+hErH4n3PAD+1VANNH4mpw6V+SV/qV+e+E/UpL3Onue7LemRSQDO6VTaN1ul9f8nKJNGI0SEh9S+4k0g==@kvack.org
X-Gm-Message-State: APuU4Z+5BsWlZl26LMJycKnu9nk0GjgHkY+TXNsEjftby+dgDDvOvcaI
	RvXyEOgoSFX2xRJUSHnP2f8oCZ1BptEuTG2rbYszL1xXkJf1FJSmttnAK9GHM1yfp0c=
X-Gm-Gg: AYBFou2kcHjSW+e8ATzDXZUDdrWWQ3t1bp7iGTa1OtcvGObgh3EcyKVnrZsWiBKdWpd
	L41C3uzR0T/nMiqKFEwGbedI1+FEauznbbjANDB173sMTSq3uhg0T0ytl1lipD5DJkzNHVgpzcK
	WEEsDbyG2yW4OC9fU5Oy1CKMPxY24HnaeLB4KJc10R9P7QdqOQXR0W50QLmU9NHpeCbPzbTiuK8
	IDiqy4unfh2nsw5AsJEm9/r1K/rKwJuvNgymwmpLbFFM/LU5JXbzzCcJe+ZLyRVgLTyjI9wFY5O
	ILQdMSKeSj57T3dPkdwLMJngKuR0XsKx12HYS+tdN7KNdAJl+KRvgeNocci0bwuvhOL20YdpXjl
	fTmcx9jf9u/Xr9cx+L2Yoxsu6CFsMwCGbiDWyBTb0jmdH2FE66c70FA8xO/DwDDfRsQ1XITK4AF
	06QfQmX0iOGDnJdEPMYCaOlkiHZdj05Oo45iSOLjiEoOjQ6EOaBZ4jm8Sm7A+slE0hP1vr4sBCw
	4kWw4HzH7U8Ijg7jWAZIXO0QPqLZc2qQdbtjTMw6VspxWA8FTlV2Dm/zIVERbwdeQdi7Q5d/b+P
	s3xByN5xGG+b3wdzmyWjREAA1Y3VoQ==
X-Received: by 2002:a5d:59ca:0:b0:487:13f:f612 with SMTP id ffacd0b85a97d-49c723fb77dmr7422413f8f.37.1794596239000;
        Fri, 13 Nov 2026 10:57:19 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:ec8::179:1b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f5972a7sm6417589f8f.21.2026.11.13.10.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 10:57:18 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <ckan@cloudflare.com>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v3 08/10] stackdepot: add architecture hooks for compact frame storage
Date: Fri, 13 Nov 2026 18:57:00 +0000
Message-ID: <20261113185702.1332171-9-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113185702.1332171-1-matt@readmodwrite.com>
References: <20261113185702.1332171-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5B47F140007
X-Stat-Signature: sz75jdws7r7ec49fmpty3ydyo8ych7wj
X-Rspam-User: 
X-HE-Tag: 1794596240-323923
X-HE-Meta: U2FsdGVkX19BtyNToWE7R1VaOlFl+hAMla7CFDw8ZmtFqlEKliCfVEmcKN6+6BpeYoRt/IChw0CixgvC/b9aeZRRts6paw8l+Cd8LXIPwgcD2yHcymU4pfpyZydBzGfhGkn2gL0d/mSQw+eTwsJUjEh+7rePBniDaVuPNqOEaqWOa3LszwXPp9aOHhYVGYnjBwv/P84pFVP0scheL+v5Kzf7RIrDYxNIapA+3ALnIMaAbY4IfcqlbjcozCDjhUB+9tX3A3/FN0yJYowvDfUwK8P6CYjsZxUvygjpZ9EKZMsBqkjBvVxfXn2/YMMn7gJmD2DTgKoM7tX1vVWf5ogJXfO/QqgrfZg0uQZ5b3wrDNKtcpRQ7ehfMnIvij5U/MQPn4qPiZjZ7ihXu2TCRklye8PluRg0zq7haKDlb0xcinb+t5vm1UklkV4grNFQGEnsDMp7ZsikaNvGHeMZjYmCURnngOuF81UXaSmmLPUVZAQdNvmtj+0+xiZmoFmkpstxSxp9xY6iN/9vpU61IRzHZH1IKmVlDP0aRYkohBmCBURxft2lbJjWcEXMyU3Ehjyldn8dq71iwVIvoOfGzZ3NBxun5IV9NdTLMXSxRuCALBLQydL1sDkbx+hEkV3EU80iyrdinT+yMqmF85foBDkF7aorLK+VNMaSyqFoGobrSn81PEV2KQvu118asOFjOPnBxD4ormpGk7rIS/5CwzB3H+8j/9BgPTI/ebcVCpVPJ+Lwz3gGECD2VPRiQYWKjCRzbxtyltF+b/dWDEby1Bd2kvSC1UTzXYlTfbdUnePri7xGNlNILltEOI1LCF9HjNnsXflA/Uys+c/Z+szc04jx5NiGQThLt+wD3vfyG0liQOnrFh/YrXE8Sblt35VlMFDLx2h4O5UZ0fFXETpURqmi2Xy23wNgGz2BM35K1Lts/0i6cOfDHGo+ttMCVMYjMCMTh4EjmpQJRf/f7/ugLxC
 d2CkGLUx
 ckhSTCS5JuKY3zraoplCba8nuVgfGFqYFW9fdKuxYYmEp1EMxFFjDiAloj4eatrWAXpAAl++z03PIv2dnr42ahEFE52D8bnGRZrgdDY0d0WFIkflP2A88SRbEZsnZ7OUW+NQ+/Lv2GNBr3daDuz1SGkgdYjjezCx+dMKl9QK5FgFnGvjMri4c9sf25K6aRFxJNN0u8c7/LBxmglXMPv89iKE72bwiwzRoN6cNuM6JXWj6SZ/C5rAZ8ch0siOmFLbfXLYEdmPVYJf3Z9WmArT2NaJLpIcMXZU6BZzmY+v5qwgaYmEbO3qKybCcwcJMowMJADH33hGpzSMUtv52pvqRJoihks4TO4WH1NYhL7ZtX+BIzOsrqZOH4QIIzM/H8NM6GGc+hwF1h1dlrTwunVA2qF5Xbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Caleb Kan <ckan@cloudflare.com>

Stack depot records can reduce their frame storage when an
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

These hooks do not change stack depot behavior until a later patch uses
them to store compressed frames.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
[mfleming: simplify arm64 decode, reworded]
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 arch/arm64/include/asm/stackdepot.h | 37 +++++++++++++
 arch/um/include/asm/Kbuild          |  1 +
 arch/x86/include/asm/stackdepot.h   | 37 +++++++++++++
 include/asm-generic/Kbuild          |  1 +
 include/asm-generic/stackdepot.h    | 19 +++++++
 lib/tests/stackdepot_kunit.c        | 86 +++++++++++++++++++++++++++++
 6 files changed, 181 insertions(+)
 create mode 100644 arch/arm64/include/asm/stackdepot.h
 create mode 100644 arch/x86/include/asm/stackdepot.h
 create mode 100644 include/asm-generic/stackdepot.h

diff --git a/arch/arm64/include/asm/stackdepot.h b/arch/arm64/include/asm/stackdepot.h
new file mode 100644
index 000000000000..72053527ab21
--- /dev/null
+++ b/arch/arm64/include/asm/stackdepot.h
@@ -0,0 +1,37 @@
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
+	return (unsigned long)_text + (s64)(s32)payload;
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
index b7a388bef6ea..76d4792a325a 100644
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
index ae4f7661a48f..dc3f8e207bdd 100644
--- a/lib/tests/stackdepot_kunit.c
+++ b/lib/tests/stackdepot_kunit.c
@@ -3,11 +3,23 @@
 #include <kunit/test.h>
 #include <linux/array_size.h>
 #include <linux/gfp.h>
+#include <linux/limits.h>
 #include <linux/minmax.h>
 #include <linux/stacktrace.h>
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
 static void stackdepot_fetch_into_roundtrip(struct kunit *test)
 {
 	unsigned long entries[] = {
@@ -73,6 +85,73 @@ static void stackdepot_fetch_into_rejects_missing_or_short_stack(struct kunit *t
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
 /* stack_depot_snprint() must match stack_trace_snprint(), with truncation. */
 static void stackdepot_snprint_matches_stack_trace(struct kunit *test)
 {
@@ -110,6 +189,13 @@ static struct kunit_case stackdepot_test_cases[] = {
 	KUNIT_CASE(stackdepot_fetch_into_roundtrip),
 	KUNIT_CASE(stackdepot_fetch_into_rejects_missing_or_short_stack),
 	KUNIT_CASE(stackdepot_snprint_matches_stack_trace),
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
2.43.0


