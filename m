Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E6F7C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:43:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3976B00BD; Mon, 17 Aug 2026 08:43:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB306B00C2; Mon, 17 Aug 2026 08:43:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 099DC6B00C1; Mon, 17 Aug 2026 08:43:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C36DC6B00BC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:43:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 33FDC1C19BD
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:05 +0000 (UTC)
X-FDA: 85110726330.30.E1C618A
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 372E3100002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OdUDDBhL;
	spf=pass (imf14.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786970583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aDMHj0ZBA+aTTncLNP9FPQM+fONDBWUSp9I8gtN+JHE=;
	b=Go9XX/0FevET7ExXQAat3ZJZ9powIX7x6Z8jw/vIT/dymIjkZhwcDLQMEfureDeXxQLc0Q
	nzbTuqjxlryHYZUtiqe5DK56/2+n83ncVv2pGiokrNoHTzref2b3CUewVWBKWjUCJrL5ez
	aB+yDePgjLs2REK+M2oXd7qhNBDAUiU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OdUDDBhL;
	spf=pass (imf14.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786970583;
	b=AI4mkuT+2GHCk0tB6gavcAFpsKycEjy05Bx24PJjTrW+MYfODun8xmYgWfb0JiqUefQM1K
	Cni+UIuhnFWieORjfulOaj3r8yu7jBeW2hhfF+CqLOG9kEMpzlZZe8lHgslsoGSYGp7GAA
	C2tmTTtxZNJp/PREEGoJednTGFgvka4=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a1a546a6bbso4921339a12.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786970582; x=1787575382; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aDMHj0ZBA+aTTncLNP9FPQM+fONDBWUSp9I8gtN+JHE=;
        b=OdUDDBhLz7kuR3PJmystGa8wQMiWpCAS0RhD1jqKaH8Lw5Ep8oXQ0fC5m3In/L2dy2
         XRZC8lVQTKkTpzbHhsSIPbizxxD6K02BmPG4Yj/dse5GhQUyifgImHhv/PAM6zJprioC
         wwqUU58I9k+ES464mMJaug6vlPBkQnhCXT1O+KCHHayj8O6nmRbtRxl8eLvHEv7PxXvT
         owJanm3bajkG96/8zs9aHhAUe3+vyqsGeDZ4Zgr89hwW3tMWjTaASeBEvdly27s2K16n
         NrQL5RmfzkaUEyCex+XwxTrgjGz0i0iDH/zz+Je0feigXdGsSCRysUQWjxgGuI/GWhj/
         /cKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786970582; x=1787575382;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aDMHj0ZBA+aTTncLNP9FPQM+fONDBWUSp9I8gtN+JHE=;
        b=jXESJwN36CxodLxuBdlCZBqE1s8dCUfz3XyqXKUx6rAcv38TC7nSAB7tm9rDcWxBQ0
         JIynOS1A6MuPyh7OuBQDdbr+YkT4qcqMNHP9/stZxh6co4U833uxgjDXPIK+O7aDs664
         p83DTy0URZlhuEErMV4cujMMvFa8mDrXc3uSpUyxoB5JK9MWGF3ImDfy8oASeZrqpLk0
         Xx3uPqeBMjccgeINRTMLW+pDkNVSrHSn/s7iZBsm8hkgjQFOnizkIUKY3k3iB/lOGpjn
         laukt8YKcm6fKrkh8b1xSGFqqxE6Swxow6pBCoqLQJkzPjA3Nc3TU1clVWW+74K4evcF
         dBhg==
X-Gm-Message-State: AOJu0Yz56218Wb5k3l4pd/Wn61JhNByoseYhDI4UKM1n2MaNm9V9DxwO
	dpCUSFnilr5l4VQXU3i/4xY1+9684cdnII/9HlVPg//prVoAzfv969sq
X-Gm-Gg: AR+sD133bCfYIEUAZ/EkOUwQkuAtGg9PpWc8oDAuHtSgO4wBVo8rFZ0v5Aoodp0yTRy
	VlaQ3PfsLwAkBNj1X/XPMzozAYJGeXVfaCbKTnhkL1YqtbT3XyYuMgEpQ8Sfu+3d9M9dIo1sR4r
	5Ur9rSC8lEQlGvCnripEaxtHpoLnAFtjJ1v9/yN/8MDtc2GJwpg+aRG0IHwLSF/N2Op4soHpwrC
	xIbnV+/KK/uDS+fatZ8TZCIK+Px0yrRYtL/8gOnTe2aZI46g4/fGTx8O/bDGZ7uQTZ6Zn9PRDNy
	7H1YXkcz8NMzJ8wlzOicRN+6sK36NL2bDKJSt910Ak0edZ+X2m90bhoym9WMktLLOj3/0KCiZBR
	0f8MoY+4OhMr42OuxQhHLG+0IVQPn2MnNwWqAdMptaqiRQG/S7aZFXnl9DQB1/rOG6j+xb+ljhk
	DA7yvP+O70S5etr2GPW6Crg99xARLM6UtJeTNnW7/+xGYowzsOMo2Q2XM0TVuJAA==
X-Received: by 2002:a17:907:d27:b0:c16:7414:4c29 with SMTP id a640c23a62f3a-c212a256f7bmr1029455566b.25.1786970581136;
        Mon, 17 Aug 2026 05:43:01 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:3861:1e5a::306:a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c217feb99d4sm52626266b.22.2026.08.17.05.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 05:43:00 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Mon, 17 Aug 2026 13:42:41 +0100
Subject: [PATCH RFC 1/9] stackdepot: share persistent stack prefixes with
 trie storage
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-stackdepot-trie-v1-1-53870ca1651b@cloudflare.com>
References: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
In-Reply-To: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 372E3100002
X-Stat-Signature: 7ztumaq1eg38fn5g65p4ah5modqeda3h
X-Rspam-User: 
X-HE-Tag: 1786970583-356707
X-HE-Meta: U2FsdGVkX18zcsss4bzXfZhmvZoKjWlZ0ykwRx5rLUZz+OZ/+upCCHYhfYbMbtBjU8Sb0oQTV41BmfE/8gJE+0WQE2O7A2j1Lp2VNiRSrLh+hpeCQUVFr+kXth2NWIATVU9mLy31KVAQIV4LvQ/zpXVJZeijmMUBeIXeJGbV0v8IlNilEGex3H8s1XhlHTH+bYgpq7M03gPcMtFD8NljvU4jKmA2DmdW+Zn+2JgZPNBZd6/Mc2WMZTbyfDTvL9yiEMErgpZokSlh8pXVcrcv6gDkQe8rciYMnRsiTbzKh0yZQ+skMz6zIFrwDuVSFP6xUw1G+ByGUspthJHFpVq99x/mWmS5yw5QYtF4AeVGOU10j4eKUefEoFtwAHpljWzsfQi8tWDks39MMyDmnJEOdFP8tXSN6Ejyjzp3AXI/K4X+HztxSkb3GUR870pDerigo7d5jwzTBSW0y6YCTlDcu3QVuVIFc7x55S9IUdQcAdTXT0Zxtb8K85gHNilApSZikouRIoOb+7Q+J0oxiU9d0zLjsUKflNCKzOlJdqSPaPBFLpLrqHfP9740zh4zu0gpDSnqV2rrOt4dARJl4KQ09ccAoSaTnyao2WkQCAnSS858I9a1DRFDqe4EhFiTuACpR7qokXl0TqHEYj+OPMh2kHLaX1+cCqyAVkzaKP2BhQeglZrFx8Tz4zvrqCcdncIn+pbWHJzUMVChS3C57JvE0EESIotzB7BZqwXRWMeTlIrk9Ep2c2NASK3itm/T8OO+8zDxe+7wt2puMlX2+K1bDoy3n7sqGRFPYwv8f1R90HCJebgZXliCcPzj+mz/uCmOb49zT84ncTslS64jIhey5yuGjJzuTzgqS+6Qeru7Ww/TdPRVhxpj+ZdMjEMEUeZ5drVA6T3pD2mPAlvReiR1aVLZfp4MJwcfe6OWB/hFfTb7LOJd3G4BX6hpsoMB2VYGJcnXiq3iLTSb+XShnQQ
 0tKNZFVi
 FLVW+xIvT51xwbjPDl/TTT8RDf/JHygqzPBGGnJMe1ZKpjbnpLeXQczDvsIk/8W9X+XIoya9eGaVykH7A074U+cbw5FOhY1GXTELYm3pDfMqU8UuVFZnMjUGbacNcjnufpL7GFHi0VhJ6WtpcKm5G7jUyB7mCJrww3MozKh0Ao2RjvHqnEOvk8xPTQ6u2fHeQL45uJCyhQLsN2EY0qni9bH8oXg4rAtFCZ5oSYg+0QCgOGhZbz1wnqQdc4XljbrCXc5Si7JkT1IN/3fJr2izaMXpZbY3H8xUGarbDDVSsCErXckb/zoJ3syql7o7fDjWsdQx1hH+/7a25Nn9kN5KpNDjqb6WdTlGIMip7nhEwPefilmmA805hpWdm3kndLoAQL/rR5f9Q9T60z+au/+i7HoPri6GjTNm8k6UyeNzkt4Y3X0CmCzeH/sGaFvh6leJ/cGRRqPCX00uS9gr6Ato3M8jkVfglcxBD8csAje/vL45xC6cdhN15OaDH0P5TxzAWZLStncJ70VisrwgAPxiNDs77hA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Caleb Kan <ckan@cloudflare.com>

Stack depot's hash backend deduplicates only identical stored traces.
Persistent, non-refcounted users do not evict records, so distinct traces
consume full records even when they share long frame sequences. After pool
storage is exhausted, a persistent save of a previously unseen trace
returns 0.

Add a path-compressed trie as a second backend for these records. Store a
run of frames in each node, keep children sorted by their first frame, and
support insertion by descending through matches, splitting partial matches,
promoting an internal node to a terminal node, or attaching a new suffix.

Use otherwise invalid pool-index values in the existing 32-bit handle
layout to encode dense stack IDs. Map each ID to its terminal node through
a sparse side table so fetch can reconstruct the trace by following parent
links. Saved stacks and IDs remain stable and are not recycled.

Add architecture hooks for compact frame storage. arm64 uses an exactly
round-trippable signed 32-bit offset from _text. Native x86-64 stores the
low 32 bits when the upper 32 bits are all set. Keep frames raw when
compression would not round trip, and provide a generic implementation that
always uses raw frames.

Allocate trie nodes and child containers from contiguous runs of 16-byte
slots in the existing order-2 stack depot pools. Release unpublished
reservations immediately. Retire replaced published storage with RCU
grace-period cookies and make its slots available to later insertions only
after the grace period completes.

Share stack_pools and the configured physical pool limit with the hash
backend. Mark pools assigned to trie slots unavailable for hash record
allocation, so total stack depot capacity remains bounded by the existing
pool budget.

Bound insertion to three attempts: another writer may consume the cached
new_pool after the lockless check, while a maximum-depth insertion can
require two newly registered pools.

Serialize writers with a raw spinlock and publish topology through RCU.
Complete fallible reservations before publishing a stack. Publish
side-table mappings before topology exposes their nodes, and replace child
containers for non-tail updates. Allow sorted appends to publish into
unused tail capacity before increasing the visible child count.

Add stack_depot_fetch_into() to materialize either backend in caller-owned
storage. Keep stack_depot_fetch() hash-only because its pointer-returning
interface requires contiguous depot-owned records. Make
stack_depot_print() and stack_depot_snprint() support both backends.

Keep STACK_DEPOT_FLAG_GET records on the hash backend. A trie-eligible
save that is not allowed to allocate performs a single lockless lookup and
returns 0 on a miss. Trie insertion failures do not fall back to hash
storage.

Live KASAN observations from the complete series yielded directional
estimates of 31.5% lower backend-specific storage per record on arm64 and
42.6% lower on x86-64 with trie storage enabled. One collection in each
comparison raced, and the machines saw different stack populations. These
are approximate observations, not a matched memory comparison. Misses for
traces seen only by non-allocating saves are unobservable, so the
measurements do not establish equivalent diagnostic coverage.

Do not initialize or enable trie storage in this patch. Existing
consumers continue to receive hash handles while later patches make their
access paths backend-independent, keep them explicitly hash-backed, or
reject trie handles. The final patch adds boot-time activation.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
 arch/arm64/include/asm/stackdepot.h |   42 ++
 arch/um/include/asm/Kbuild          |    1 +
 arch/x86/include/asm/stackdepot.h   |   37 +
 include/asm-generic/Kbuild          |    1 +
 include/asm-generic/stackdepot.h    |   19 +
 include/linux/stackdepot.h          |   67 +-
 lib/stackdepot.c                    | 1368 ++++++++++++++++++++++++++++++++++-
 7 files changed, 1521 insertions(+), 14 deletions(-)

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
index 15df9dcb42a5..ac178162fa11 100644
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
diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
index 2cc21ffcdaf9..96544fc684a5 100644
--- a/include/linux/stackdepot.h
+++ b/include/linux/stackdepot.h
@@ -144,6 +144,10 @@ static inline int stack_depot_early_init(void)	{ return 0; }
  * Users of this flag must also call stack_depot_put() when keeping the stack
  * trace is no longer required to avoid overflowing the refcount.
  *
+ * When trie storage is enabled, persistent non-refcounted saves use trie
+ * storage. Constrained callers only look up existing stacks; they do not insert
+ * a missing stack. Trie failures do not fall back to hash storage.
+ *
  * If the provided stack trace comes from the interrupt context, only the part
  * up to the interrupt entry is saved.
  *
@@ -152,7 +156,7 @@ static inline int stack_depot_early_init(void)	{ return 0; }
  *          this is the case for contexts where neither %GFP_ATOMIC nor
  *          %GFP_NOWAIT can be used (NMI, raw_spin_lock).
  *
- * Return: Handle of the stack struct stored in depot, 0 on failure
+ * Return: Handle of the stack trace stored in depot, 0 on failure
  */
 depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
 					    unsigned int nr_entries,
@@ -169,6 +173,10 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
  * Does not increment the refcount on the saved stack trace; see
  * stack_depot_save_flags() for more details.
  *
+ * When trie storage is enabled, this can return trie-backed handles. Use
+ * stack_depot_fetch_into(), stack_depot_print(), or stack_depot_snprint() for
+ * backend-independent access to the stack contents.
+ *
  * Context: Contexts where allocations via alloc_pages() are allowed;
  *          see stack_depot_save_flags() for more details.
  *
@@ -178,7 +186,7 @@ depot_stack_handle_t stack_depot_save(unsigned long *entries,
 				      unsigned int nr_entries, gfp_t alloc_flags);
 
 /**
- * __stack_depot_get_stack_record - Get a pointer to a stack_record struct
+ * __stack_depot_get_stack_record - Get a hash-backed stack record
  *
  * @handle: Stack depot handle
  *
@@ -191,14 +199,55 @@ struct stack_record *__stack_depot_get_stack_record(depot_stack_handle_t handle)
 /**
  * stack_depot_fetch - Fetch a stack trace from stack depot
  *
- * @handle:	Stack depot handle returned from stack_depot_save()
+ * @handle:	Hash-backed stack depot handle
  * @entries:	Pointer to store the address of the stack trace
  *
+ * This helper returns a pointer to stackdepot-owned contiguous storage for
+ * legacy hash-backed handles. Callers that need backend-independent access to
+ * stack contents should use stack_depot_fetch_into(), stack_depot_print(), or
+ * stack_depot_snprint(). Passing a trie-backed handle is invalid and may WARN.
+ *
  * Return: Number of frames for the fetched stack
  */
 unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 			       unsigned long **entries);
 
+/**
+ * stack_depot_fetch_into - Fetch a stack trace into caller-owned storage
+ *
+ * @handle:	Stack depot handle
+ * @entries:	Caller-owned buffer to copy the stack trace into
+ * @max_entries:	Number of frames that fit in @entries
+ *
+ * Copies the stored frames into caller-owned @entries. If fewer frames are
+ * stored than @max_entries, only the stored frames are written and their count
+ * is returned. If more frames are stored than @max_entries, the copy is skipped
+ * entirely and 0 is returned.
+ *
+ * Passing a NULL @entries buffer or zero @max_entries for a valid @handle is
+ * invalid. Callers must provide storage for @max_entries frames.
+ *
+ * Callers should size @entries to match the save-side stack depth cap (for
+ * example, %CONFIG_STACKDEPOT_MAX_FRAMES or the local stack_trace_save() limit)
+ * when losing diagnostics on an undersized buffer would be surprising.
+ *
+ * A non-zero invalid @handle, including a post-put handle, may WARN. Its return
+ * value and copied contents are undefined because the record may have been
+ * reused for another stack.
+ *
+ * Callers must ensure @handle remains valid for the duration of this call.
+ * Persistent handles saved without %STACK_DEPOT_FLAG_GET require no extra
+ * reference; handles saved with %STACK_DEPOT_FLAG_GET require a held reference.
+ * Callers must not call stack_depot_put() on persistent handles.
+ * Racing this helper with stack_depot_put() on the same handle is invalid.
+ *
+ * Return: Number of frames copied, 0 if @handle is 0, stack depot is disabled,
+ * or @max_entries is less than the number of stored frames.
+ */
+unsigned int stack_depot_fetch_into(depot_stack_handle_t handle,
+				    unsigned long *entries,
+				    unsigned int max_entries);
+
 /**
  * stack_depot_print - Print a stack trace from stack depot
  *
@@ -224,10 +273,14 @@ int stack_depot_snprint(depot_stack_handle_t handle, char *buf, size_t size,
  *
  * @handle:	Stack depot handle returned from stack_depot_save()
  *
- * The stack trace is evicted from stack depot once all references to it have
- * been dropped (once the number of stack_depot_evict() calls matches the
- * number of stack_depot_save_flags() calls with STACK_DEPOT_FLAG_GET set for
- * this stack trace).
+ * Drop a reference acquired by stack_depot_save_flags() with
+ * %STACK_DEPOT_FLAG_GET. Calling this for a handle saved without
+ * %STACK_DEPOT_FLAG_GET is invalid; persistent handles, including trie-backed
+ * handles, are owned by stack depot for the lifetime of the system.
+ *
+ * The stack trace is evicted once the number of stack_depot_put() calls matches
+ * the number of successful stack_depot_save_flags() calls with
+ * %STACK_DEPOT_FLAG_GET for this stack trace.
  */
 void stack_depot_put(depot_stack_handle_t handle);
 
diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index dd2717ff94bf..0278b7a013f1 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -2,9 +2,10 @@
 /*
  * Stack depot - a stack trace storage that avoids duplication.
  *
- * Internally, stack depot maintains a hash table of unique stacktraces. The
- * stack traces themselves are stored contiguously one after another in a set
- * of separate page allocations.
+ * Internally, stack depot has two storage backends. Refcounted entries use the
+ * legacy hash table with contiguous stack records in stack pools. Persistent
+ * non-refcounted entries can use trie storage when enabled; trie nodes share
+ * common frame prefixes and are published through RCU children containers.
  *
  * Author: Alexander Potapenko <glider@google.com>
  * Copyright (C) 2016 Google, Inc.
@@ -14,10 +15,15 @@
 
 #define pr_fmt(fmt) "stackdepot: " fmt
 
+#include <linux/bitmap.h>
+#include <linux/build_bug.h>
 #include <linux/debugfs.h>
+#include <linux/errno.h>
 #include <linux/gfp.h>
 #include <linux/jhash.h>
+#include <linux/jump_label.h>
 #include <linux/kernel.h>
+#include <linux/log2.h>
 #include <linux/kmsan.h>
 #include <linux/list.h>
 #include <linux/mm.h>
@@ -36,9 +42,12 @@
 #include <linux/memblock.h>
 #include <linux/kasan-enabled.h>
 
+#include <asm/stackdepot.h>
+
 /*
  * The pool_index is offset by 1 so the first record does not have a 0 handle.
  */
+/* Parsed before mm_core_init(); trie handle decoding assumes this is then fixed. */
 static unsigned int stack_max_pools __read_mostly =
 	MIN((1LL << DEPOT_POOL_INDEX_BITS) - 1, 8192);
 
@@ -63,18 +72,18 @@ static unsigned int stack_hash_mask;
 
 /* The lock must be held when performing pool or freelist modifications. */
 static DEFINE_RAW_SPINLOCK(pool_lock);
-/* Array of memory regions that store stack records. */
+/* Array of memory regions used by both stack depot backends. */
 static void **stack_pools __pt_guarded_by(&pool_lock);
 /* Newly allocated pool that is not yet added to stack_pools. */
 static void *new_pool;
 /* Number of pools in stack_pools. */
 static int pools_num;
-/* Offset to the unused space in the currently used pool. */
+/* Offset to unused hash storage in the current pool. */
 static size_t pool_offset __guarded_by(&pool_lock) = DEPOT_POOL_SIZE;
 /* Freelist of stack records within stack_pools. */
 static __guarded_by(&pool_lock) LIST_HEAD(free_stacks);
 
-/* Statistics counters for debugfs. */
+/* Hash-backend statistics counters for debugfs. */
 enum depot_counter_id {
 	DEPOT_COUNTER_REFD_ALLOCS,
 	DEPOT_COUNTER_REFD_FREES,
@@ -95,6 +104,552 @@ static const char *const counter_names[] = {
 };
 static_assert(ARRAY_SIZE(counter_names) == DEPOT_COUNTER_COUNT);
 
+enum stack_depot_frame_mode {
+	STACK_DEPOT_FRAME_RAW,
+	STACK_DEPOT_FRAME_COMPRESSED,
+};
+
+/*
+ * A trie node stores one run of frames that all use the same payload format.
+ * Architectures may compress some frames to 32-bit payloads; mixed raw and
+ * compressed input is split across multiple trie nodes so each node has one
+ * decoding mode.
+ */
+struct stack_depot_frame_run {
+	u16 nr_entries;
+	u8 mode;
+};
+
+static_assert(CONFIG_STACKDEPOT_MAX_FRAMES <= U16_MAX);
+
+struct stack_depot_trie_children;
+
+struct stack_depot_trie_node {
+	/* Parent links let fetch rebuild a full stack from a node to the root. */
+	const struct stack_depot_trie_node __rcu *parent;
+	/* Children are RCU-published containers. */
+	const struct stack_depot_trie_children __rcu *children;
+	/* Non-zero when a stored stack ends at this node. */
+	u32 stack_id;
+	struct stack_depot_frame_run run;
+	unsigned char data[];
+};
+
+/*
+ * Child nodes are sorted by first frame and searched by insertion position.
+ * Existing child pointers are immutable. Writers may publish into unused tail
+ * capacity; other updates publish a replacement container.
+ */
+struct stack_depot_trie_children {
+	unsigned int nr_children;
+	unsigned int capacity;
+	const struct stack_depot_trie_node __rcu *nodes[];
+};
+
+/* Retired children carry an optional node through their RCU grace period. */
+struct stack_depot_trie_retired_children {
+	struct list_head list;
+	unsigned long rcu_state;
+	const struct stack_depot_trie_node *pending_node;
+	unsigned char data[];
+};
+
+static_assert(IS_ALIGNED(offsetof(struct stack_depot_trie_retired_children, data),
+			 1UL << DEPOT_STACK_ALIGN));
+
+#define STACK_DEPOT_TRIE_SLOT_SIZE BIT(DEPOT_STACK_ALIGN)
+#define STACK_DEPOT_TRIE_POOL_SLOTS \
+	(DEPOT_POOL_SIZE / STACK_DEPOT_TRIE_SLOT_SIZE)
+
+struct stack_depot_trie_pool {
+	struct list_head list;
+	unsigned int free_slots;
+	DECLARE_BITMAP(used, STACK_DEPOT_TRIE_POOL_SLOTS);
+};
+
+#define STACK_DEPOT_TRIE_POOL_FIRST_SLOT \
+	DIV_ROUND_UP(sizeof(struct stack_depot_trie_pool), \
+		     STACK_DEPOT_TRIE_SLOT_SIZE)
+#define STACK_DEPOT_TRIE_POOL_USABLE_SIZE \
+	((STACK_DEPOT_TRIE_POOL_SLOTS - STACK_DEPOT_TRIE_POOL_FIRST_SLOT) * \
+	 STACK_DEPOT_TRIE_SLOT_SIZE)
+
+static_assert(STACK_DEPOT_TRIE_POOL_FIRST_SLOT < STACK_DEPOT_TRIE_POOL_SLOTS);
+
+static DEFINE_STATIC_KEY_FALSE(stack_depot_trie_enabled);
+static const struct stack_depot_trie_children __rcu *stack_depot_trie_root;
+static DEFINE_RAW_SPINLOCK(stack_depot_trie_writer_lock);
+
+#define DEPOT_POOL_INDEX_MASK ((1U << DEPOT_POOL_INDEX_BITS) - 1)
+#define DEPOT_OFFSET_MASK ((1U << DEPOT_OFFSET_BITS) - 1)
+
+/* Retired fixed-size slots remain reserved until their RCU grace period ends. */
+static LIST_HEAD(stack_depot_trie_pools);
+static LIST_HEAD(pending_trie_children);
+
+/*
+ * stack_max_pools is the split point between hash and trie handle encodings.
+ * A handle with pool_index_plus_1 in 1..stack_max_pools names a hash-backed
+ * stack pool. Larger pool-index values cannot refer to hash pools, so trie
+ * storage uses that handle space to encode a dense stack ID. The side table
+ * maps each stack ID to its trie node.
+ */
+static inline u32 trie_max_stack_id(void)
+{
+	return (DEPOT_POOL_INDEX_MASK - stack_max_pools) <<
+		DEPOT_OFFSET_BITS;
+}
+
+static depot_stack_handle_t trie_handle(u32 stack_id)
+{
+	union handle_parts parts = {};
+	u64 pool_index_plus_1;
+	u32 pool_delta;
+	u32 index;
+
+	index = stack_id - 1;
+	pool_delta = index >> DEPOT_OFFSET_BITS;
+	pool_index_plus_1 = (u64)stack_max_pools + 1 + pool_delta;
+
+	parts.pool_index_plus_1 = pool_index_plus_1;
+	parts.offset = index & DEPOT_OFFSET_MASK;
+	return parts.handle;
+}
+
+static inline bool stack_depot_handle_is_trie(depot_stack_handle_t handle)
+{
+	union handle_parts parts = { .handle = handle };
+
+	return parts.pool_index_plus_1 > stack_max_pools;
+}
+
+static u32 trie_stack_id(depot_stack_handle_t handle)
+{
+	union handle_parts parts = { .handle = handle };
+	u32 pool_delta;
+
+	pool_delta = parts.pool_index_plus_1 - stack_max_pools - 1;
+	return (pool_delta << DEPOT_OFFSET_BITS) + parts.offset + 1;
+}
+
+/*
+ * Trie handles encode a dense stack ID. The side table maps that ID to a node
+ * pointer for lockless fetch and print paths, which can run from diagnostic
+ * contexts where taking a lock would be unsafe. Additional directories and
+ * chunks are published lazily as stack IDs grow.
+ */
+#define STACK_DEPOT_TRIE_SIDE_TABLE_CHUNK_SIZE \
+	(PAGE_SIZE / sizeof(struct stack_depot_trie_node *))
+#define STACK_DEPOT_TRIE_SIDE_TABLE_DIR_SIZE \
+	(PAGE_SIZE / sizeof(struct stack_depot_trie_node **))
+
+struct stack_depot_trie_side_dir {
+	/* Both the chunk pointer and each node pointer in it are RCU-published. */
+	const struct stack_depot_trie_node __rcu * __rcu *
+		chunks[STACK_DEPOT_TRIE_SIDE_TABLE_DIR_SIZE];
+};
+
+struct stack_depot_trie_side_root {
+	unsigned int dir_capacity;
+	struct stack_depot_trie_side_dir __rcu *dirs[];
+};
+
+struct stack_depot_trie_side_prealloc {
+	/* Preallocated side-table directory page for sparse growth. */
+	struct stack_depot_trie_side_dir *dir;
+	/* Preallocated side-table pointer chunk for sparse growth. */
+	const struct stack_depot_trie_node __rcu **chunk;
+};
+
+static struct stack_depot_trie_side_root *trie_side_table_root;
+static DEFINE_RAW_SPINLOCK(trie_side_table_cache_lock);
+/* Zeroed unpublished pages; get/put transfer ownership under the cache lock. */
+static struct stack_depot_trie_side_prealloc trie_side_table_cache;
+static u32 trie_side_table_last_stack_id;
+
+/* Lock order: writer_lock -> pool_lock. The cache lock is never nested. */
+
+static inline size_t stack_depot_frame_run_entry_bytes(enum stack_depot_frame_mode mode)
+{
+	if (mode == STACK_DEPOT_FRAME_COMPRESSED)
+		return sizeof(u32);
+	return sizeof(unsigned long);
+}
+
+static inline size_t stack_depot_frame_run_bytes(const struct stack_depot_frame_run *run)
+{
+	return run->nr_entries * stack_depot_frame_run_entry_bytes(run->mode);
+}
+
+static inline size_t trie_node_bytes(const struct stack_depot_frame_run *run)
+{
+	return ALIGN(offsetof(struct stack_depot_trie_node, data) +
+		     stack_depot_frame_run_bytes(run), sizeof(unsigned long));
+}
+
+static size_t trie_children_alloc_size(unsigned int capacity)
+{
+	size_t size;
+
+	size = struct_size_t(struct stack_depot_trie_children, nodes,
+			     capacity);
+	return offsetof(struct stack_depot_trie_retired_children, data) +
+		ALIGN(size, sizeof(unsigned long));
+}
+
+static inline unsigned int trie_side_table_root_index(u32 id)
+{
+	return ((id - 1) / STACK_DEPOT_TRIE_SIDE_TABLE_CHUNK_SIZE) /
+		STACK_DEPOT_TRIE_SIDE_TABLE_DIR_SIZE;
+}
+
+static inline unsigned int trie_side_table_dir_index(u32 id)
+{
+	return ((id - 1) / STACK_DEPOT_TRIE_SIDE_TABLE_CHUNK_SIZE) %
+		STACK_DEPOT_TRIE_SIDE_TABLE_DIR_SIZE;
+}
+
+static inline unsigned int trie_side_table_slot_index(u32 id)
+{
+	return (id - 1) % STACK_DEPOT_TRIE_SIDE_TABLE_CHUNK_SIZE;
+}
+
+static struct stack_depot_trie_side_dir *trie_side_table_load_dir(unsigned int root)
+{
+	struct stack_depot_trie_side_root *root_vec;
+
+	root_vec = trie_side_table_root;
+	if (!root_vec || root >= root_vec->dir_capacity)
+		return NULL;
+	/* Pairs with side-table directory rcu_assign_pointer(). */
+	return rcu_dereference_check(root_vec->dirs[root],
+				     lockdep_is_held(&stack_depot_trie_writer_lock) ||
+				     rcu_read_lock_sched_held());
+}
+
+static inline const struct stack_depot_trie_node __rcu **
+trie_side_table_dir_load_chunk(struct stack_depot_trie_side_dir *dir,
+			       unsigned int idx)
+{
+	/* Pairs with the chunk rcu_assign_pointer() in stack ID preparation. */
+	return rcu_dereference_check(dir->chunks[idx],
+				     lockdep_is_held(&stack_depot_trie_writer_lock) ||
+				     rcu_read_lock_sched_held());
+}
+
+static u32
+trie_side_table_prepare_stack_slot(struct stack_depot_trie_side_prealloc *prealloc)
+{
+	const struct stack_depot_trie_node __rcu **chunk;
+	struct stack_depot_trie_side_dir *dir;
+	struct stack_depot_trie_side_root *root_vec;
+	unsigned int root;
+	unsigned int idx;
+	u32 id;
+
+	lockdep_assert_held(&stack_depot_trie_writer_lock);
+
+	id = trie_side_table_last_stack_id + 1;
+	if (id > trie_max_stack_id())
+		return 0;
+
+	root_vec = trie_side_table_root;
+	root = trie_side_table_root_index(id);
+	dir = trie_side_table_load_dir(root);
+	if (!dir) {
+		dir = prealloc->dir;
+		prealloc->dir = NULL;
+		/* Publish the zeroed directory before readers can load it locklessly. */
+		rcu_assign_pointer(root_vec->dirs[root], dir);
+	}
+
+	idx = trie_side_table_dir_index(id);
+	chunk = trie_side_table_dir_load_chunk(dir, idx);
+	if (!chunk) {
+		chunk = prealloc->chunk;
+		prealloc->chunk = NULL;
+		rcu_assign_pointer(dir->chunks[idx], chunk);
+	}
+
+	return id;
+}
+
+static int trie_side_table_get_prealloc(gfp_t gfp_flags,
+					struct stack_depot_trie_side_prealloc *prealloc)
+{
+	unsigned long flags;
+
+	gfp_flags = gfp_nested_mask(gfp_flags);
+	raw_spin_lock_irqsave(&trie_side_table_cache_lock, flags);
+	prealloc->dir = trie_side_table_cache.dir;
+	prealloc->chunk = trie_side_table_cache.chunk;
+	trie_side_table_cache.dir = NULL;
+	trie_side_table_cache.chunk = NULL;
+	raw_spin_unlock_irqrestore(&trie_side_table_cache_lock, flags);
+
+	if (!prealloc->dir) {
+		prealloc->dir = (void *)get_zeroed_page(gfp_flags);
+		if (!prealloc->dir)
+			return -ENOMEM;
+	}
+	if (!prealloc->chunk) {
+		prealloc->chunk = (void *)get_zeroed_page(gfp_flags);
+		if (!prealloc->chunk)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void trie_side_table_put_prealloc(struct stack_depot_trie_side_prealloc *prealloc)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&trie_side_table_cache_lock, flags);
+	if (!trie_side_table_cache.dir) {
+		trie_side_table_cache.dir = prealloc->dir;
+		prealloc->dir = NULL;
+	}
+	if (!trie_side_table_cache.chunk) {
+		trie_side_table_cache.chunk = prealloc->chunk;
+		prealloc->chunk = NULL;
+	}
+	raw_spin_unlock_irqrestore(&trie_side_table_cache_lock, flags);
+
+	if (prealloc->dir)
+		free_page((unsigned long)prealloc->dir);
+	if (prealloc->chunk)
+		free_page((unsigned long)prealloc->chunk);
+}
+
+static const struct stack_depot_trie_node *trie_side_table_lookup(u32 id)
+{
+	const struct stack_depot_trie_node __rcu **chunk;
+	struct stack_depot_trie_side_dir *dir;
+	unsigned int root;
+
+	root = trie_side_table_root_index(id);
+	dir = trie_side_table_load_dir(root);
+	if (!dir)
+		return NULL;
+	chunk = trie_side_table_dir_load_chunk(dir, trie_side_table_dir_index(id));
+	if (!chunk)
+		return NULL;
+
+	/* Pairs with side-table node publication. */
+	return rcu_dereference_check(chunk[trie_side_table_slot_index(id)],
+				     lockdep_is_held(&stack_depot_trie_writer_lock) ||
+				     rcu_read_lock_sched_held());
+}
+
+static inline struct stack_depot_trie_retired_children *
+trie_retired_children(const void *ptr)
+{
+	return container_of(ptr, struct stack_depot_trie_retired_children, data);
+}
+
+static bool depot_init_pool(void **prealloc);
+
+static unsigned int trie_pool_reserve_slots(struct stack_depot_trie_pool *pool,
+					    unsigned int nr_slots)
+{
+	unsigned int run = 0;
+	unsigned int i;
+	unsigned int slot;
+
+	if (pool->free_slots < nr_slots)
+		return STACK_DEPOT_TRIE_POOL_SLOTS;
+
+	/* A free run can cross any previous allocation position. */
+	for (slot = STACK_DEPOT_TRIE_POOL_FIRST_SLOT;
+	     slot < STACK_DEPOT_TRIE_POOL_SLOTS; slot++) {
+		if (pool->used[slot / BITS_PER_LONG] &
+		    BIT(slot % BITS_PER_LONG)) {
+			run = 0;
+			continue;
+		}
+		if (++run != nr_slots)
+			continue;
+
+		for (i = slot + 1 - nr_slots; i <= slot; i++)
+			pool->used[i / BITS_PER_LONG] |= BIT(i % BITS_PER_LONG);
+		pool->free_slots -= nr_slots;
+		return slot + 1 - nr_slots;
+	}
+
+	return STACK_DEPOT_TRIE_POOL_SLOTS;
+}
+
+/* Allocate at least @size bytes from one contiguous trie-pool slot run. */
+static void *trie_pool_alloc(size_t size, void **prealloc)
+{
+	struct stack_depot_trie_pool *pool;
+	unsigned int nr_slots;
+	unsigned int slot;
+
+	lockdep_assert_held(&pool_lock);
+
+	if (size > STACK_DEPOT_TRIE_POOL_USABLE_SIZE)
+		return NULL;
+	nr_slots = DIV_ROUND_UP(size, STACK_DEPOT_TRIE_SLOT_SIZE);
+	list_for_each_entry_reverse(pool, &stack_depot_trie_pools, list) {
+		slot = trie_pool_reserve_slots(pool, nr_slots);
+		if (slot != STACK_DEPOT_TRIE_POOL_SLOTS)
+			return (char *)pool + slot * STACK_DEPOT_TRIE_SLOT_SIZE;
+	}
+
+	if (!depot_init_pool(prealloc))
+		return NULL;
+	pool = stack_pools[pools_num - 1];
+	/* Keep hash records out of this bitmap-owned pool. */
+	pool_offset = DEPOT_POOL_SIZE;
+	memset(pool, 0, sizeof(*pool));
+	pool->free_slots = STACK_DEPOT_TRIE_POOL_SLOTS -
+			   STACK_DEPOT_TRIE_POOL_FIRST_SLOT;
+	list_add_tail(&pool->list, &stack_depot_trie_pools);
+
+	slot = trie_pool_reserve_slots(pool, nr_slots);
+	return (char *)pool + slot * STACK_DEPOT_TRIE_SLOT_SIZE;
+}
+
+/* Release the slots for the byte count originally passed to allocation. */
+static void trie_pool_release(const void *ptr, size_t size)
+{
+	struct stack_depot_trie_pool *pool;
+	unsigned long pfn;
+	unsigned int nr_slots;
+	unsigned int slot;
+	unsigned int i;
+
+	lockdep_assert_held(&pool_lock);
+
+	pfn = page_to_pfn(virt_to_page(ptr));
+	pfn &= ~(BIT(DEPOT_POOL_ORDER) - 1);
+	pool = page_address(pfn_to_page(pfn));
+	slot = ((unsigned long)ptr - (unsigned long)pool) >> DEPOT_STACK_ALIGN;
+	nr_slots = DIV_ROUND_UP(size, STACK_DEPOT_TRIE_SLOT_SIZE);
+	for (i = slot; i < slot + nr_slots; i++)
+		pool->used[i / BITS_PER_LONG] &= ~BIT(i % BITS_PER_LONG);
+	pool->free_slots += nr_slots;
+}
+
+static struct stack_depot_trie_children *
+trie_pool_alloc_children(unsigned int capacity, void **prealloc)
+{
+	struct stack_depot_trie_retired_children *retired;
+	struct stack_depot_trie_children *children;
+
+	/* Capacity counts child-pointer entries; allocation includes RCU metadata. */
+	retired = trie_pool_alloc(trie_children_alloc_size(capacity), prealloc);
+	if (!retired)
+		return NULL;
+
+	children = (void *)retired->data;
+	children->nr_children = 0;
+	children->capacity = capacity;
+	return children;
+}
+
+static void
+trie_pool_release_children(const struct stack_depot_trie_children *children)
+{
+	/* Capacity is immutable and therefore recovers the allocation byte size. */
+	trie_pool_release(trie_retired_children(children),
+			  trie_children_alloc_size(children->capacity));
+}
+
+/*
+ * Return RCU-ready objects before allocating. Pending children are FIFO, so
+ * stop at the first incomplete grace period. A replaced node shares the same
+ * retirement cookie and is released with its former children container.
+ */
+static void trie_drain_pending_children(void)
+{
+	struct stack_depot_trie_retired_children *retired;
+	struct stack_depot_trie_retired_children *tmp;
+	struct stack_depot_trie_children *children;
+
+	lockdep_assert_held(&pool_lock);
+
+	list_for_each_entry_safe(retired, tmp, &pending_trie_children, list) {
+		if (!poll_state_synchronize_rcu(retired->rcu_state))
+			break;
+		children = (void *)retired->data;
+		list_del(&retired->list);
+		if (retired->pending_node)
+			trie_pool_release(retired->pending_node,
+					  trie_node_bytes(&retired->pending_node->run));
+		trie_pool_release_children(children);
+	}
+}
+
+static void trie_retire_children(const struct stack_depot_trie_children *children)
+{
+	struct stack_depot_trie_retired_children *retired;
+
+	lockdep_assert_held(&pool_lock);
+
+	retired = trie_retired_children(children);
+	retired->pending_node = NULL;
+	retired->rcu_state = get_state_synchronize_rcu();
+	list_add_tail(&retired->list, &pending_trie_children);
+}
+
+static void
+trie_retire_children_with_node(const struct stack_depot_trie_children *children,
+			       const struct stack_depot_trie_node *node)
+{
+	struct stack_depot_trie_retired_children *retired;
+
+	lockdep_assert_held(&stack_depot_trie_writer_lock);
+	raw_spin_lock(&pool_lock);
+	trie_retire_children(children);
+	retired = trie_retired_children(children);
+	retired->pending_node = node;
+	raw_spin_unlock(&pool_lock);
+}
+
+static const struct stack_depot_trie_node *
+stack_depot_trie_lookup(const unsigned long *entries, unsigned int nr_entries);
+
+static depot_stack_handle_t
+trie_find_handle(const unsigned long *entries, unsigned int nr_entries)
+{
+	depot_stack_handle_t handle = 0;
+	const struct stack_depot_trie_node *node;
+
+	rcu_read_lock_sched_notrace();
+	node = stack_depot_trie_lookup(entries, nr_entries);
+	if (node)
+		handle = trie_handle(node->stack_id);
+	rcu_read_unlock_sched_notrace();
+
+	return handle;
+}
+
+/*
+ * Publish only after the node and its path are fully initialized and all
+ * fallible allocation is complete. Publication commits the path, so it cannot
+ * then be rolled back. Side-table mappings must precede trie topology
+ * publication that makes new or remapped nodes reachable from lookup.
+ * Published storage remains valid until RCU retirement; only descendant parent
+ * links may change meanwhile.
+ */
+static void trie_side_table_publish(const struct stack_depot_trie_node *node)
+{
+	const struct stack_depot_trie_node __rcu **chunk;
+	struct stack_depot_trie_side_dir *dir;
+	u32 stack_id = node->stack_id;
+
+	lockdep_assert_held(&stack_depot_trie_writer_lock);
+
+	dir = trie_side_table_load_dir(trie_side_table_root_index(stack_id));
+	chunk = trie_side_table_dir_load_chunk(dir,
+					       trie_side_table_dir_index(stack_id));
+	/* Pairs with trie_side_table_lookup(). */
+	rcu_assign_pointer(chunk[trie_side_table_slot_index(stack_id)], node);
+}
+
 static int __init disable_stack_depot(char *str)
 {
 	return kstrtobool(str, &stack_depot_disabled);
@@ -323,7 +878,7 @@ static bool depot_init_pool(void **prealloc)
 	 * NULL; do not reset to NULL if we have reached the maximum number of
 	 * pools.
 	 */
-	if (pools_num < stack_max_pools)
+	if (pools_num + 1 < stack_max_pools)
 		WRITE_ONCE(new_pool, NULL);
 	else
 		WRITE_ONCE(new_pool, STACK_DEPOT_POISON);
@@ -638,6 +1193,63 @@ static inline struct stack_record *find_stack(struct list_head *bucket,
 	return ret;
 }
 
+static u32
+stack_depot_trie_insert(const unsigned long *entries,
+			unsigned int nr_entries, void **pool_prealloc,
+			struct stack_depot_trie_side_prealloc *side_prealloc);
+
+static depot_stack_handle_t
+stack_depot_trie_save(unsigned long *entries, unsigned int nr_entries,
+		      gfp_t alloc_flags)
+{
+	unsigned int attempt;
+
+	/* Allow one stale pool hint before the two pools a largest insert needs. */
+	for (attempt = 0; attempt < 3; attempt++) {
+		struct stack_depot_trie_side_prealloc side_prealloc = {};
+		void *pool_prealloc = NULL;
+		depot_stack_handle_t handle;
+		unsigned long flags;
+		struct page *page;
+		u32 stack_id = 0;
+
+		handle = trie_find_handle(entries, nr_entries);
+		if (handle)
+			return handle;
+
+		if (trie_side_table_get_prealloc(alloc_flags, &side_prealloc)) {
+			trie_side_table_put_prealloc(&side_prealloc);
+			return 0;
+		}
+
+		/* The hint may race; a missing page is recovered by the retry. */
+		if (!READ_ONCE(new_pool)) {
+			page = alloc_pages(gfp_nested_mask(alloc_flags),
+					   DEPOT_POOL_ORDER);
+			if (page)
+				pool_prealloc = page_address(page);
+		}
+
+		raw_spin_lock_irqsave(&stack_depot_trie_writer_lock, flags);
+		stack_id = stack_depot_trie_insert(entries, nr_entries,
+						   &pool_prealloc, &side_prealloc);
+		raw_spin_unlock_irqrestore(&stack_depot_trie_writer_lock, flags);
+
+		if (pool_prealloc) {
+			raw_spin_lock_irqsave(&pool_lock, flags);
+			depot_keep_new_pool(&pool_prealloc);
+			raw_spin_unlock_irqrestore(&pool_lock, flags);
+		}
+		if (pool_prealloc)
+			free_pages((unsigned long)pool_prealloc, DEPOT_POOL_ORDER);
+		trie_side_table_put_prealloc(&side_prealloc);
+		if (stack_id)
+			return trie_handle(stack_id);
+	}
+
+	return 0;
+}
+
 depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
 					    unsigned int nr_entries,
 					    gfp_t alloc_flags,
@@ -669,6 +1281,17 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
 	if (unlikely(nr_entries == 0) || stack_depot_disabled)
 		return 0;
 
+	if (!(depot_flags & STACK_DEPOT_FLAG_GET) &&
+	    static_branch_unlikely(&stack_depot_trie_enabled)) {
+		if (nr_entries > CONFIG_STACKDEPOT_MAX_FRAMES)
+			nr_entries = CONFIG_STACKDEPOT_MAX_FRAMES;
+		if (in_nmi() || !can_alloc) {
+			WARN_ON_ONCE(can_alloc);
+			return trie_find_handle(entries, nr_entries);
+		}
+		return stack_depot_trie_save(entries, nr_entries, alloc_flags);
+	}
+
 	hash = hash_stack(entries, nr_entries);
 	bucket = &stack_table[hash & stack_hash_mask];
 
@@ -753,10 +1376,689 @@ struct stack_record *__stack_depot_get_stack_record(depot_stack_handle_t handle)
 {
 	if (!handle)
 		return NULL;
+	if (WARN_ON_ONCE(stack_depot_handle_is_trie(handle)))
+		return NULL;
 
 	return depot_fetch_stack(handle);
 }
 
+static void frame_run_init(const unsigned long *entries,
+			   unsigned int nr_entries,
+			   struct stack_depot_frame_run *run)
+{
+	u32 payload;
+	unsigned int i;
+	bool compressed;
+
+	compressed = arch_stack_depot_frame_try_compress(entries[0], &payload);
+	for (i = 1; i < nr_entries; i++) {
+		bool next;
+
+		next = arch_stack_depot_frame_try_compress(entries[i], &payload);
+		if (next != compressed)
+			break;
+	}
+
+	/* @i is the first non-matching frame, or @nr_entries if all matched. */
+	run->mode = compressed ? STACK_DEPOT_FRAME_COMPRESSED : STACK_DEPOT_FRAME_RAW;
+	run->nr_entries = i;
+}
+
+static void
+stack_depot_trie_node_frame(const struct stack_depot_trie_node *node,
+			    unsigned int index, unsigned long *frame)
+{
+	u32 payload;
+
+	if (node->run.mode == STACK_DEPOT_FRAME_RAW) {
+		memcpy(frame, node->data + index * sizeof(*frame),
+		       sizeof(*frame));
+		return;
+	}
+
+	memcpy(&payload, node->data + index * sizeof(payload), sizeof(payload));
+	arch_stack_depot_frame_decompress(payload, frame);
+}
+
+static void trie_node_init(struct stack_depot_trie_node *node,
+			   const struct stack_depot_trie_node *parent, u32 stack_id,
+			   const unsigned long *entries,
+			   const struct stack_depot_frame_run *run)
+{
+	if (run->mode == STACK_DEPOT_FRAME_COMPRESSED) {
+		unsigned int i;
+
+		for (i = 0; i < run->nr_entries; i++) {
+			u32 payload;
+
+			arch_stack_depot_frame_try_compress(entries[i], &payload);
+			memcpy(node->data + i * sizeof(payload), &payload,
+			       sizeof(payload));
+		}
+	} else {
+		memcpy(node->data, entries, stack_depot_frame_run_bytes(run));
+	}
+
+	RCU_INIT_POINTER(node->parent, parent);
+	RCU_INIT_POINTER(node->children, NULL);
+	node->stack_id = stack_id;
+	node->run = *run;
+}
+
+static void trie_node_init_slice(struct stack_depot_trie_node *node,
+				 const struct stack_depot_trie_node *parent, u32 stack_id,
+				 const struct stack_depot_trie_node *src_node,
+				 unsigned int start, unsigned int nr_entries)
+{
+	struct stack_depot_frame_run run;
+	size_t entry_bytes;
+
+	run = src_node->run;
+	run.nr_entries = nr_entries;
+
+	entry_bytes = stack_depot_frame_run_entry_bytes(src_node->run.mode);
+	memcpy(node->data, src_node->data + start * entry_bytes,
+	       stack_depot_frame_run_bytes(&run));
+	RCU_INIT_POINTER(node->parent, parent);
+	RCU_INIT_POINTER(node->children, NULL);
+	node->stack_id = stack_id;
+	node->run = run;
+}
+
+static unsigned int trie_node_match(const struct stack_depot_trie_node *node,
+				    const unsigned long *entries,
+				    unsigned int nr_entries)
+{
+	unsigned int limit;
+	unsigned int i;
+
+	limit = min(node->run.nr_entries, nr_entries);
+	if (node->run.mode == STACK_DEPOT_FRAME_RAW) {
+		for (i = 0; i < limit; i++) {
+			unsigned long frame;
+
+			memcpy(&frame, node->data + i * sizeof(frame), sizeof(frame));
+			if (frame != entries[i])
+				break;
+		}
+
+		return i;
+	}
+
+	for (i = 0; i < limit; i++) {
+		unsigned long frame;
+
+		stack_depot_trie_node_frame(node, i, &frame);
+		if (frame != entries[i])
+			break;
+	}
+
+	return i;
+}
+
+static inline const struct stack_depot_trie_node *
+trie_load_parent(const struct stack_depot_trie_node *node)
+{
+	return rcu_dereference_check(node->parent,
+				     lockdep_is_held(&stack_depot_trie_writer_lock) ||
+				     rcu_read_lock_sched_held());
+}
+
+static inline const struct stack_depot_trie_children *
+trie_load_children(const struct stack_depot_trie_children __rcu * const *slot)
+{
+	return rcu_dereference_check(*slot,
+				     lockdep_is_held(&stack_depot_trie_writer_lock) ||
+				     rcu_read_lock_sched_held());
+}
+
+static inline const struct stack_depot_trie_node *
+trie_children_load_child(const struct stack_depot_trie_children *children,
+			 unsigned int pos)
+{
+	return rcu_dereference_check(children->nodes[pos],
+				     lockdep_is_held(&stack_depot_trie_writer_lock) ||
+				     rcu_read_lock_sched_held());
+}
+
+static bool
+trie_children_find_position(const struct stack_depot_trie_children *children,
+			    unsigned long frame, unsigned int *pos)
+{
+	unsigned int left = 0;
+	unsigned int right;
+
+	right = READ_ONCE(children->nr_children);
+	while (left < right) {
+		unsigned int mid = left + (right - left) / 2;
+		const struct stack_depot_trie_node *node;
+		unsigned long mid_frame;
+
+		node = trie_children_load_child(children, mid);
+		if (!node) {
+			/* Tail append may produce a transient lockless lookup miss. */
+			right = mid;
+			continue;
+		}
+		stack_depot_trie_node_frame(node, 0, &mid_frame);
+		if (mid_frame < frame) {
+			left = mid + 1;
+		} else if (mid_frame > frame) {
+			right = mid;
+		} else {
+			*pos = mid;
+			return true;
+		}
+	}
+
+	*pos = left;
+	return false;
+}
+
+/* Initialize an unpublished container from a stable published prefix. */
+static void trie_children_init(const struct stack_depot_trie_children *old,
+			       struct stack_depot_trie_children *new)
+{
+	unsigned int nr_old = old->nr_children;
+	unsigned int i;
+
+	new->nr_children = nr_old;
+	for (i = 0; i < nr_old; i++)
+		RCU_INIT_POINTER(new->nodes[i], trie_children_load_child(old, i));
+	for (i = nr_old; i < new->capacity; i++)
+		RCU_INIT_POINTER(new->nodes[i], NULL);
+}
+
+static void trie_children_insert(struct stack_depot_trie_children *children,
+				 const struct stack_depot_trie_node *node,
+				 unsigned int pos)
+{
+	unsigned int i;
+
+	for (i = children->nr_children; i > pos; i--)
+		RCU_INIT_POINTER(children->nodes[i],
+				 trie_children_load_child(children, i - 1));
+	RCU_INIT_POINTER(children->nodes[pos], node);
+	children->nr_children++;
+}
+
+static void trie_reparent_children(struct stack_depot_trie_node *parent)
+{
+	const struct stack_depot_trie_children *children;
+	unsigned int i;
+
+	lockdep_assert_held(&stack_depot_trie_writer_lock);
+
+	children = trie_load_children(&parent->children);
+	if (!children)
+		return;
+	/*
+	 * Replacement nodes reuse unchanged descendant subtrees. Repoint their
+	 * parent links before retiring the old parent so fetch never follows a freed
+	 * node. Lockless fetches may see the new parent before publication, but the
+	 * old and new parent chains contain the same frames and remain RCU-live.
+	 */
+	for (i = 0; i < children->nr_children; i++) {
+		struct stack_depot_trie_node *child;
+
+		child = (struct stack_depot_trie_node *)trie_children_load_child(children, i);
+		rcu_assign_pointer(child->parent, parent);
+	}
+}
+
+/*
+ * Split entries into runs, allocate and initialize each node once, and link
+ * adjacent nodes through singleton children. Both trie locks must be held.
+ * Failure walks the unpublished parent chain and releases local ownership.
+ */
+static const struct stack_depot_trie_node *
+trie_path_alloc(const struct stack_depot_trie_node *parent, u32 stack_id,
+		const unsigned long *entries, unsigned int nr_entries,
+		void **pool_prealloc,
+		const struct stack_depot_trie_node **node_out)
+{
+	struct stack_depot_trie_children *path_children = NULL;
+	const struct stack_depot_trie_node *path_root = NULL;
+	const struct stack_depot_trie_node *last_node = parent;
+	unsigned int entry = 0;
+
+	lockdep_assert_held(&pool_lock);
+	lockdep_assert_held(&stack_depot_trie_writer_lock);
+
+	while (entry < nr_entries) {
+		struct stack_depot_frame_run run;
+		struct stack_depot_trie_node *node;
+
+		frame_run_init(&entries[entry], nr_entries - entry, &run);
+		node = trie_pool_alloc(trie_node_bytes(&run), pool_prealloc);
+		if (!node)
+			goto err_release;
+
+		trie_node_init(node, last_node,
+			       entry + run.nr_entries == nr_entries ? stack_id : 0,
+			       &entries[entry], &run);
+		entry += run.nr_entries;
+		last_node = node;
+		if (!path_root)
+			path_root = node;
+
+		if (path_children)
+			trie_children_insert(path_children, last_node, 0);
+		if (entry < nr_entries) {
+			path_children = trie_pool_alloc_children(1, pool_prealloc);
+			if (!path_children)
+				goto err_release;
+			RCU_INIT_POINTER(node->children, path_children);
+		}
+	}
+
+	*node_out = last_node;
+	return path_root;
+
+err_release:
+	while (last_node != parent) {
+		const struct stack_depot_trie_children *node_children;
+		const struct stack_depot_trie_node *node = last_node;
+
+		last_node = trie_load_parent(node);
+		node_children = trie_load_children(&node->children);
+		if (node_children)
+			trie_pool_release_children(node_children);
+		trie_pool_release(node, trie_node_bytes(&node->run));
+	}
+	return NULL;
+}
+
+static const struct stack_depot_trie_node *
+stack_depot_trie_lookup(const unsigned long *entries, unsigned int nr_entries)
+{
+	const struct stack_depot_trie_children *children;
+	unsigned int entry = 0;
+
+	children = trie_load_children(&stack_depot_trie_root);
+
+	while (entry < nr_entries) {
+		const struct stack_depot_trie_node *node;
+		unsigned int remaining = nr_entries - entry;
+		unsigned int matched;
+		unsigned int pos;
+
+		if (!children)
+			return NULL;
+		if (!trie_children_find_position(children, entries[entry], &pos))
+			return NULL;
+
+		node = trie_children_load_child(children, pos);
+		matched = trie_node_match(node, &entries[entry], remaining);
+		if (matched < node->run.nr_entries)
+			return NULL;
+		entry += matched;
+		if (entry == nr_entries)
+			return node->stack_id ? node : NULL;
+
+		children = trie_load_children(&node->children);
+	}
+
+	return NULL;
+}
+
+static u32
+trie_insert_path(const struct stack_depot_trie_children __rcu **slot,
+		 struct stack_depot_trie_node *parent,
+		 const struct stack_depot_trie_children *children,
+		 unsigned int pos, const unsigned long *entries,
+		 unsigned int nr_entries, void **pool_prealloc,
+		 struct stack_depot_trie_side_prealloc *side_prealloc)
+{
+	struct stack_depot_trie_children *new_children = NULL;
+	const struct stack_depot_trie_node *path_root;
+	const struct stack_depot_trie_node *node;
+	unsigned int capacity = 1;
+	u32 new_stack_id;
+	bool tail_append = false;
+
+	/*
+	 * Reuse spare capacity only for a sorted tail append. Other insertions
+	 * replace the children container without modifying visible pointers.
+	 */
+	if (children) {
+		capacity = roundup_pow_of_two(children->nr_children + 1);
+		tail_append = pos == children->nr_children &&
+			children->nr_children < children->capacity;
+	}
+	if (!tail_append && trie_children_alloc_size(capacity) >
+	    STACK_DEPOT_TRIE_POOL_USABLE_SIZE)
+		return 0;
+
+	new_stack_id = trie_side_table_prepare_stack_slot(side_prealloc);
+	if (!new_stack_id)
+		return 0;
+
+	raw_spin_lock(&pool_lock);
+	printk_deferred_enter();
+	trie_drain_pending_children();
+
+	/* Reserve replacement topology before the path, the final fallible step. */
+	if (!tail_append) {
+		new_children = trie_pool_alloc_children(capacity, pool_prealloc);
+		if (!new_children)
+			goto err_release;
+	}
+	path_root = trie_path_alloc(parent, new_stack_id, entries, nr_entries,
+				    pool_prealloc, &node);
+	if (!path_root)
+		goto err_release;
+
+	/* Commit the stack ID before making the path reachable from the trie. */
+	trie_side_table_publish(node);
+	if (tail_append) {
+		struct stack_depot_trie_children *tail_children =
+			(struct stack_depot_trie_children *)children;
+
+		/*
+		 * Publish the node before the visible count. Readers may transiently
+		 * see NULL and miss; the writer-lock recheck prevents duplicates.
+		 */
+		rcu_assign_pointer(tail_children->nodes[pos], path_root);
+		WRITE_ONCE(tail_children->nr_children, pos + 1);
+	} else {
+		if (children)
+			trie_children_init(children, new_children);
+		trie_children_insert(new_children, path_root, pos);
+		rcu_assign_pointer(*slot, new_children);
+		if (children)
+			trie_retire_children(children);
+	}
+
+	printk_deferred_exit();
+	raw_spin_unlock(&pool_lock);
+	return new_stack_id;
+
+err_release:
+	if (new_children)
+		trie_pool_release_children(new_children);
+	printk_deferred_exit();
+	raw_spin_unlock(&pool_lock);
+	return 0;
+}
+
+static u32
+trie_split_child(const struct stack_depot_trie_children __rcu **slot,
+		 const struct stack_depot_trie_children *children,
+		 const struct stack_depot_trie_node *child,
+		 unsigned int pos, unsigned int matched,
+		 const unsigned long *entries, unsigned int nr_entries,
+		 void **pool_prealloc,
+		 struct stack_depot_trie_side_prealloc *side_prealloc)
+{
+	struct stack_depot_trie_children *prefix_children = NULL;
+	struct stack_depot_trie_children *new_children = NULL;
+	const struct stack_depot_trie_node *new_node;
+	const struct stack_depot_trie_node *suffix_roots[2];
+	struct stack_depot_frame_run run;
+	struct stack_depot_trie_node *split_prefix = NULL;
+	struct stack_depot_trie_node *old_suffix = NULL;
+	unsigned int nr_suffix_roots;
+	unsigned int old_suffix_len;
+	unsigned int i;
+	size_t split_prefix_size;
+	size_t old_suffix_size;
+	u32 new_stack_id;
+	bool has_new_suffix;
+
+	new_stack_id = trie_side_table_prepare_stack_slot(side_prealloc);
+	if (!new_stack_id)
+		return 0;
+
+	/* Rebuild the child's run as newly allocated prefix and old suffix nodes. */
+	run = child->run;
+	run.nr_entries = matched;
+	split_prefix_size = trie_node_bytes(&run);
+	old_suffix_len = child->run.nr_entries - matched;
+	run.nr_entries = old_suffix_len;
+	old_suffix_size = trie_node_bytes(&run);
+	has_new_suffix = matched < nr_entries;
+	nr_suffix_roots = has_new_suffix ? 2 : 1;
+
+	raw_spin_lock(&pool_lock);
+	printk_deferred_enter();
+	trie_drain_pending_children();
+
+	/* Reserve fixed split topology before the optional new suffix path. */
+	split_prefix = trie_pool_alloc(split_prefix_size, pool_prealloc);
+	if (!split_prefix)
+		goto err_release;
+	old_suffix = trie_pool_alloc(old_suffix_size, pool_prealloc);
+	if (!old_suffix)
+		goto err_release;
+	new_children = trie_pool_alloc_children(children->capacity, pool_prealloc);
+	if (!new_children)
+		goto err_release;
+	prefix_children = trie_pool_alloc_children(nr_suffix_roots, pool_prealloc);
+	if (!prefix_children)
+		goto err_release;
+
+	if (has_new_suffix) {
+		const struct stack_depot_trie_node *new_suffix;
+		unsigned long old_suffix_frame;
+
+		new_suffix = trie_path_alloc(split_prefix, new_stack_id,
+					     &entries[matched], nr_entries - matched,
+					     pool_prealloc, &new_node);
+		if (!new_suffix)
+			goto err_release;
+		stack_depot_trie_node_frame(child, matched, &old_suffix_frame);
+		/* Children remain sorted by the first frame of each suffix. */
+		if (old_suffix_frame < entries[matched]) {
+			suffix_roots[0] = old_suffix;
+			suffix_roots[1] = new_suffix;
+		} else {
+			suffix_roots[0] = new_suffix;
+			suffix_roots[1] = old_suffix;
+		}
+	} else {
+		new_node = split_prefix;
+		suffix_roots[0] = old_suffix;
+	}
+
+	printk_deferred_exit();
+	raw_spin_unlock(&pool_lock);
+
+	/* Rebuild the old path as prefix -> old suffix and attach suffix roots. */
+	trie_node_init_slice(split_prefix, trie_load_parent(child),
+			     has_new_suffix ? 0 : new_stack_id, child, 0, matched);
+	trie_node_init_slice(old_suffix, split_prefix, child->stack_id, child,
+			     matched, old_suffix_len);
+	for (i = 0; i < nr_suffix_roots; i++)
+		trie_children_insert(prefix_children, suffix_roots[i], i);
+	RCU_INIT_POINTER(old_suffix->children,
+			 trie_load_children(&child->children));
+	RCU_INIT_POINTER(split_prefix->children, prefix_children);
+
+	/* Publish IDs, reparent descendants, then replace and retire topology. */
+	if (child->stack_id)
+		trie_side_table_publish(old_suffix);
+	trie_side_table_publish(new_node);
+	/* Old and replacement chains contain identical frames during transition. */
+	trie_children_init(children, new_children);
+	RCU_INIT_POINTER(new_children->nodes[pos], split_prefix);
+	trie_reparent_children(old_suffix);
+	rcu_assign_pointer(*slot, new_children);
+	trie_retire_children_with_node(children, child);
+
+	return new_stack_id;
+
+err_release:
+	if (split_prefix)
+		trie_pool_release(split_prefix, split_prefix_size);
+	if (old_suffix)
+		trie_pool_release(old_suffix, old_suffix_size);
+	if (prefix_children)
+		trie_pool_release_children(prefix_children);
+	if (new_children)
+		trie_pool_release_children(new_children);
+	printk_deferred_exit();
+	raw_spin_unlock(&pool_lock);
+	return 0;
+}
+
+static u32
+trie_promote_child(const struct stack_depot_trie_children __rcu **slot,
+		   const struct stack_depot_trie_children *children,
+		   const struct stack_depot_trie_node *child,
+		   unsigned int pos, void **pool_prealloc,
+		   struct stack_depot_trie_side_prealloc *side_prealloc)
+{
+	struct stack_depot_trie_children *new_children;
+	struct stack_depot_trie_node *promoted_node;
+	size_t node_size;
+	u32 new_stack_id;
+
+	new_stack_id = trie_side_table_prepare_stack_slot(side_prealloc);
+	if (!new_stack_id)
+		return 0;
+	node_size = trie_node_bytes(&child->run);
+
+	/* Reserve a clone and replacement children container before publication. */
+	raw_spin_lock(&pool_lock);
+	printk_deferred_enter();
+	trie_drain_pending_children();
+	promoted_node = trie_pool_alloc(node_size, pool_prealloc);
+	if (!promoted_node)
+		goto out_unlock;
+	new_children = trie_pool_alloc_children(children->capacity, pool_prealloc);
+	if (!new_children)
+		goto out_release_node;
+	printk_deferred_exit();
+	raw_spin_unlock(&pool_lock);
+
+	/* Add the stack ID through a clone, then reparent before retirement. */
+	memcpy(promoted_node, child, node_size);
+	promoted_node->stack_id = new_stack_id;
+	trie_side_table_publish(promoted_node);
+	trie_children_init(children, new_children);
+	RCU_INIT_POINTER(new_children->nodes[pos], promoted_node);
+	trie_reparent_children(promoted_node);
+	rcu_assign_pointer(*slot, new_children);
+	trie_retire_children_with_node(children, child);
+
+	return new_stack_id;
+
+out_release_node:
+	trie_pool_release(promoted_node, node_size);
+out_unlock:
+	printk_deferred_exit();
+	raw_spin_unlock(&pool_lock);
+	return 0;
+}
+
+static u32
+stack_depot_trie_insert(const unsigned long *entries,
+			unsigned int nr_entries, void **pool_prealloc,
+			struct stack_depot_trie_side_prealloc *side_prealloc)
+{
+	const struct stack_depot_trie_children *children;
+	const struct stack_depot_trie_children __rcu **slot =
+		&stack_depot_trie_root;
+	const struct stack_depot_trie_node *child;
+	struct stack_depot_trie_node *parent = NULL;
+	unsigned int matched;
+	unsigned int pos;
+	u32 stack_id;
+
+	lockdep_assert_held(&stack_depot_trie_writer_lock);
+
+	for (;;) {
+		pos = 0;
+		children = trie_load_children(slot);
+		/* No matching child: attach the remaining path. */
+		if (!children ||
+		    !trie_children_find_position(children, entries[0], &pos)) {
+			stack_id = trie_insert_path(slot, parent, children, pos,
+						    entries, nr_entries, pool_prealloc,
+						    side_prealloc);
+			break;
+		}
+
+		child = trie_children_load_child(children, pos);
+		matched = trie_node_match(child, entries, nr_entries);
+		/* A partial child match requires a prefix/suffix split. */
+		if (matched < child->run.nr_entries) {
+			stack_id = trie_split_child(slot, children, child, pos,
+						    matched, entries, nr_entries,
+						    pool_prealloc, side_prealloc);
+			break;
+		}
+
+		/* The input ends here: reuse a stack node or promote an internal one. */
+		if (matched == nr_entries) {
+			if (child->stack_id)
+				return child->stack_id;
+			stack_id = trie_promote_child(slot, children, child, pos,
+						      pool_prealloc, side_prealloc);
+			break;
+		}
+
+		/* The child matched completely; continue with the remaining frames. */
+		parent = (struct stack_depot_trie_node *)child;
+		slot = &parent->children;
+		entries += matched;
+		nr_entries -= matched;
+	}
+
+	if (stack_id)
+		trie_side_table_last_stack_id = stack_id;
+	return stack_id;
+}
+
+static unsigned int trie_fetch_into(const struct stack_depot_trie_node *node,
+				    unsigned long *entries,
+				    unsigned int max_entries)
+{
+	const struct stack_depot_trie_node *cur;
+	unsigned int total;
+	unsigned int pos;
+	unsigned int i;
+
+	total = 0;
+	for (cur = node; cur; cur = trie_load_parent(cur))
+		total += cur->run.nr_entries;
+	if (max_entries < total)
+		return 0;
+
+	pos = total;
+	for (cur = node; cur; cur = trie_load_parent(cur)) {
+		pos -= cur->run.nr_entries;
+		for (i = 0; i < cur->run.nr_entries; i++)
+			stack_depot_trie_node_frame(cur, i, &entries[pos + i]);
+	}
+
+	return total;
+}
+
+static unsigned int trie_fetch_handle_into(depot_stack_handle_t handle,
+					   unsigned long *entries,
+					   unsigned int max_entries)
+{
+	const struct stack_depot_trie_node *node;
+	u32 stack_id;
+	unsigned int nr_entries;
+
+	stack_id = trie_stack_id(handle);
+	rcu_read_lock_sched_notrace();
+	node = trie_side_table_lookup(stack_id);
+	if (WARN_ONCE(!node, "corrupt trie handle %08x\n", handle)) {
+		rcu_read_unlock_sched_notrace();
+		return 0;
+	}
+	nr_entries = trie_fetch_into(node, entries, max_entries);
+	rcu_read_unlock_sched_notrace();
+	if (nr_entries)
+		kmsan_unpoison_memory(entries, nr_entries * sizeof(*entries));
+
+	return nr_entries;
+}
+
 unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 			       unsigned long **entries)
 {
@@ -771,6 +2073,8 @@ unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 
 	if (!handle || stack_depot_disabled)
 		return 0;
+	if (WARN_ON_ONCE(stack_depot_handle_is_trie(handle)))
+		return 0;
 
 	stack = depot_fetch_stack(handle);
 	/*
@@ -785,12 +2089,44 @@ unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 }
 EXPORT_SYMBOL_GPL(stack_depot_fetch);
 
+unsigned int stack_depot_fetch_into(depot_stack_handle_t handle,
+				    unsigned long *entries,
+				    unsigned int max_entries)
+{
+	struct stack_record *stack;
+	unsigned int nr_entries;
+
+	if (!handle)
+		return 0;
+	if (stack_depot_disabled)
+		return 0;
+	WARN_ON_ONCE(!entries || !max_entries);
+	if (stack_depot_handle_is_trie(handle))
+		return trie_fetch_handle_into(handle, entries, max_entries);
+
+	stack = depot_fetch_stack(handle);
+	if (!stack)
+		return 0;
+	nr_entries = stack->size;
+	if (WARN_ON_ONCE(!nr_entries))
+		return 0;
+	if (nr_entries > max_entries)
+		return 0;
+
+	memcpy(entries, stack->entries, nr_entries * sizeof(*entries));
+	kmsan_unpoison_memory(entries, nr_entries * sizeof(*entries));
+	return nr_entries;
+}
+EXPORT_SYMBOL_GPL(stack_depot_fetch_into);
+
 void stack_depot_put(depot_stack_handle_t handle)
 {
 	struct stack_record *stack;
 
 	if (!handle || stack_depot_disabled)
 		return;
+	if (WARN_ON_ONCE(stack_depot_handle_is_trie(handle)))
+		return;
 
 	stack = depot_fetch_stack(handle);
 	/*
@@ -810,6 +2146,15 @@ void stack_depot_print(depot_stack_handle_t stack)
 	unsigned long *entries;
 	unsigned int nr_entries;
 
+	if (stack_depot_handle_is_trie(stack)) {
+		unsigned long trie_entries[CONFIG_STACKDEPOT_MAX_FRAMES];
+
+		nr_entries = trie_fetch_handle_into(stack, trie_entries,
+						    ARRAY_SIZE(trie_entries));
+		stack_trace_print(trie_entries, nr_entries, 0);
+		return;
+	}
+
 	nr_entries = stack_depot_fetch(stack, &entries);
 	if (nr_entries > 0)
 		stack_trace_print(entries, nr_entries, 0);
@@ -822,6 +2167,15 @@ int stack_depot_snprint(depot_stack_handle_t handle, char *buf, size_t size,
 	unsigned long *entries;
 	unsigned int nr_entries;
 
+	if (stack_depot_handle_is_trie(handle)) {
+		unsigned long trie_entries[CONFIG_STACKDEPOT_MAX_FRAMES];
+
+		nr_entries = trie_fetch_handle_into(handle, trie_entries,
+						    ARRAY_SIZE(trie_entries));
+		return stack_trace_snprint(buf, size, trie_entries, nr_entries,
+					   spaces);
+	}
+
 	nr_entries = stack_depot_fetch(handle, &entries);
 	return nr_entries ? stack_trace_snprint(buf, size, entries, nr_entries,
 						spaces) : 0;

-- 
Git-155)


