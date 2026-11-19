Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528C460A2604
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=J67TUHT9
Received: by kanga.kvack.org (Postfix)
	id 217F36B068F; Thu, 19 Nov 2026 10:32:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F06B6B0690; Thu, 19 Nov 2026 10:32:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE336B0691; Thu, 19 Nov 2026 10:32:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C50486B068F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:32:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31EB4140B0F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:16 +0000 (UTC)
X-FDA: 85452259872.30.CA7371C
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 587681C0015
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=J67TUHT9
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795102334;
	b=DgW6gsbVZ+s20hXZUcCHa6IG8OKABmmDpwDEdz/zN2Yze89BnCzDp2VLmvxARfaodDo0qk
	Cw2jVNrhj/MtSd9P/sX4vGPiPZJg43Q0mL3D2GfXFdNFPUrPABVE7SLlsGzyxlLrx3fTf5
	OhRfr2kESjdyLS9LtfRLLxIrTR3qkSA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=J67TUHT9;
	spf=none (imf20.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.218.43) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795102334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCP/7rY2NKQ2ZzvQeDCJsA8s2DqcI1dNIAw5F9lcUBY=;
	b=chRMeb/VmBhmHmZM1wP9LEAlAHaC+v3c/8tEqcHFNssUofC6r2GGetfJ11XnynoA41cEhQ
	J3yKjVPhHNBgt/CtYM+t5ucP9jv4XJOQPBmkRvO8Bf6rd73B7Egu4tK3DtPYe8bk5hKdAB
	nQixovUjGceol8JzgppyKb7WfYVPcUQ=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c50cc7540b7so346157966b.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1795102333; x=1795707133; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lCP/7rY2NKQ2ZzvQeDCJsA8s2DqcI1dNIAw5F9lcUBY=;
        b=J67TUHT97zsLw349ZqMOiqJrx2YB1+jAB6d+VcWX4F69Pjasqk7ucxeAIuqYVVKbcM
         5sx4lQ8Vb3zv2Znz3XKV54YmiddQSSr8U2UnVeaNtvK/E9WW5/ShwPv+0OAjDhNtEtp/
         7+RTsug54jL+ioHbb92NWUJqgznAzgwgijJd3Qcqs3G0Dhlf/IIX4PFUaOZL5MTsXDmz
         bNISIlpa8pHluEUhfhozpm0QYpnqP0Ts5jw4Ih/dDcb4YwSiz++7YHiIO0pkmy/7Cma8
         fNMZCcnT6ysBFy8XaFbiDCqrH0r/jqjVNX3/SFowLSBm4/w65U4GtEVieVxQ8voYl+aC
         u+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795102333; x=1795707133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lCP/7rY2NKQ2ZzvQeDCJsA8s2DqcI1dNIAw5F9lcUBY=;
        b=i3efQ4fdURTJuT8gC33XUiQVzsNxfz+tpG6LoPTWxbpKHi43jVEUkTNLaxdjwEZKLD
         O5eGjzwyLHQszujWDEfw9bCSinXSmIPU0yewljfxIzaHDL3+FRiOAr8acCuiyQo4CvaT
         5CZHjZ9u1zoUQE/xksyGbJCrAiqkRq3f0aqZm0VZbNFZP47FT7PZmYG1JKJ3nqYEKdU+
         /hEVA5pHTPp2n82PIDYyqYZWgBmXyyzNwZCnRIzDB8QhO3dAagwaD2j3aC96coJ737tr
         mYOninXWrdbvRWdq44h5ZGQ2BZnhWyie9Bmrxrh41gd8Ah0+cgEl9k2jfurqsSRoh+Ie
         iK2g==
X-Forwarded-Encrypted: i=1; AL+hErG0yJST04YU5Z33535Q4+z/y99YufuWb45IxQVKXo070OypnZCZuEPICvefCD2i2/mc43h3OTL7Yg==@kvack.org
X-Gm-Message-State: APuU4Z+MMJwwcqqfNAuCMVS55Z4TVn2odj+0uVsG3ikkcY/lxqRKGT0e
	KoWXPav7X16r8IdPZEVQC1hNkqUlbB2SwFXCousPgwcS+ctP8cWSUUzrrk40OpVAg3k=
X-Gm-Gg: AYBFou1pup8e96oC1Jv2DgBybeaUtDtTjdWgvfrVqKrRGkQ5WXcZG3nInC0zLLcxUWl
	WyWxFt9FMo0Y20Um0kXuIiRN36Nfx8SNrkIQ0lCcZDdEd3e9K/hX/nHsflvGDRgG6iY/wnN6mKG
	uGLf6Vod8xlVGOrwObboGvzZKLBz1789njXVEIyph0fJcdqNBdVxN40RfMhG++7rX6R1qEPhkb5
	OSEhgoKyhK19HGFq2A3Vx3BQYU6zbc6bxSE2RihECZrDt+m+TDC/ZWKZRWwXLQErLF1tP+ZW98w
	p9PQaQzgZIBEoAUnYCvIBmf56cTBtbLFTxsywqlOLcepcJFiLc1NNY94bm3gYrc850gThG9CSxp
	/YfLEJmsIYspMssIsAb8kVk+qTV2kRm/ULz4lcFjI789er2u2489/pTrJkGBYTOEf6eu6gGwAq7
	Boiafv5ndmta0Zb1gSA5I2WC5aVX0JFTGmRMrzS6U0+MZ0r11FN9JT5hoDSepmOVOLXMUmw4TWH
	YyhQUFc6cqqhokLs5ovstYxba11pydpgZgb1QN6iIWF4TWn3VKPU4g1J69Y35UiIW3ivZq6tU7+
	Kj10uP3YYKd314lCVRHA6kcp4Yq/O+c=
X-Received: by 2002:a17:906:bccf:b0:c4d:2888:f373 with SMTP id a640c23a62f3a-c513aac3edfmr19947166b.41.1795102332799;
        Thu, 19 Nov 2026 07:32:12 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:294b::41d:4e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab65cb41f4sm237463f8f.7.2026.11.19.07.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 07:32:12 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Caleb Kan <ckan@cloudflare.com>,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v4 08/10] stackdepot: add architecture hooks for compact frame storage
Date: Thu, 19 Nov 2026 15:31:41 +0000
Message-ID: <20261119153143.4099483-9-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119153143.4099483-1-matt@readmodwrite.com>
References: <20261119153143.4099483-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 587681C0015
X-Stat-Signature: ogjmj19exdofetjn5zpo6g9p5aipwy8k
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795102334-462473
X-HE-Meta: U2FsdGVkX1//H5GnauKNzGdeUmfva0k+27ZG99jR787QFFNKowpXLND9d5aHa5hPhW+7CXiUFOA3OGnFTvhjgTB1KP8Zw+NEu4WL7PkVVb403q2vEogcOq3Dnw2gxJnNuETeJ3sD/swTpELHt83phDMfKvLU7llfo5+CqEfqq1DvEl7QQ7ZUkdQ34rqtz4ihbE6j1NBeJYqmNOaRwirMcCu2Q3ZGBqMJsrJ+k24fq8sGqUWTf/mh/9IontbYxrAcpgy4VISjm5QERbDx59VxWrPc9PM9SsS16TO6/2YW83tjRz70ukOf2RTdeZtb0C+ae3r0iWtnz2oWR1q6krkCWHV20YWe4etUjU7BNejmyTeKNSP9tk1gpI7Eo5xum0E4TA9HF1gwkNbnVeAt3Dmts/+UDvCCKmFh1pDn+xuXf42Ks+kc3lWGsyb7RWe/4juVd/a100j5rozZM7/exM4GSsyERonUX3nPeE710TTIjXjh8uV3Bi9fhSJWQsZOWA+UinuFRrWXfyKnZaPiQgIYAmz1nF1n3VQg/8W3bEQrxgWeenKdAi1eRLRDwaREbCMdIJzjD/Ci9hXXTpOIv9V4RQEQ7hCL+4Jf9xp45/VlrVg1uzdZ5o9bLevw/HKdfX18wzxG0Na7BsFXbX9r6kozVaDzkOPuCqRd8uDbQB8UjNUeMI9/XCi0rXZMbBh38hmsl2v630X9vFOVMXcp52nizmt59qNbDNo6iekyR8V95rYRUu1OvrSWHi8p9R7u0ta/fV5xHeiPLKC0GEV3GILcUeWwXwuz6lyR1CmLipM2MuqeEJP6JPHyIZRI1CCpMAVFOeDmeXgwPvL7VIZJHH0F009qhPSA0P8uZl/6pWoiz0sk/Y7/psgGlsmxQdrX2iCtGICy6d+7uGozKMwOVqCqP1ZwHF4Fk64pwrdKkTJzk/DSLLXgtXo7tng9RlipcrveR4V97HxHMNRSHrFkB0m
 xS9IpRbB
 uBYcaJPRgj6CCdIauiJyUUKcDYIi9h6m1x3Cvb9mq3wumUDijp6+KvpQBkY4UfL3QyYM3SSQ0b9xURCCoXjtogL5BdH5aHt9mfT5bQCufK6Ioc8kexuwkpeZlnXsQUbK08H9d8YxzvPK/YEdQTy7Yxqf6QHu5y3ynfODkuuDKvgeCbmtvlH5NdOcR7MQZMDO2nkdNoyHzj9pRgrV3eXZJSglOGq7xltAs8A1wm6MpTx5paOIwS+vvLHbYmM8SeD6NEX7+6Ys/84eTADFO+Jn8D5za7ne/qkEopwgs5VHNVTv9pHhHuLDuMH0xD+kAVBaFgt8mqJtlvguo6d0YBH7zihZHV2p9yHVhn5WzCHRC/7Aj5+6ZJtXX84olowZUNYq0GAg6YP5c2s7UUxqw5LEsoSp2OA==
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
[mfleming: Address sashiko feedback and zero *frame in generic hook]
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 arch/arm64/include/asm/stackdepot.h | 37 +++++++++++++
 arch/um/include/asm/Kbuild          |  1 +
 arch/x86/include/asm/stackdepot.h   | 37 +++++++++++++
 include/asm-generic/Kbuild          |  1 +
 include/asm-generic/stackdepot.h    | 20 +++++++
 lib/tests/stackdepot_kunit.c        | 86 +++++++++++++++++++++++++++++
 6 files changed, 182 insertions(+)
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
index 000000000000..9246d9c8cdd4
--- /dev/null
+++ b/include/asm-generic/stackdepot.h
@@ -0,0 +1,20 @@
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
+	*frame = 0;
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


