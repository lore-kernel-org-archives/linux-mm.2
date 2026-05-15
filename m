Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 983CECD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 08:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08EE46B00CA; Fri, 15 May 2026 04:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066FF6B00CC; Fri, 15 May 2026 04:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE57D6B00CD; Fri, 15 May 2026 04:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBE496B00CA
	for <linux-mm@kvack.org>; Fri, 15 May 2026 04:22:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 885FB14067D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:22:12 +0000 (UTC)
X-FDA: 84768961704.18.0CA06EC
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf18.hostedemail.com (Postfix) with ESMTP id A6F191C0003
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:22:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=NY+3dFg0;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778833330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/I1RhJJRl8LgLDwnRBLNgWvi4qB5F9lPUEH3scBIO9U=;
	b=fCQ/LvjZvwYI1ShKB2DFE7kga2ip6D9VgDUXdpgtdiF3ai9kBQ+Lw0F80QRnkBJlXQkTiR
	m2qK5huRNeAt9S9EKC3kVV7kMYWM8vNEnG4ljETr3BUhBmuATqZ7ZBNI+XuuKYmN0oAKpF
	vqa6G78MTkQ5/ABoakbzZ/9BQkp1UBk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=NY+3dFg0;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778833330; a=rsa-sha256;
	cv=none;
	b=lDtgaEYxUs5MLUyy4+h0gNUwMJ2qKUJZgStT/83eVNo0OU7LPkONbneOPrdN6OOr99tnBQ
	1FWT0Uad5/79sCEdmhHHdtLdhEeIQpgSGV1exzKnZWoW0dHRv89vIZWEffynfX0Nq4H2j9
	sYWy0Wlt0IYRtWB/JnqSM/2tViKnKsk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1778833326; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=/I1RhJJRl8LgLDwnRBLNgWvi4qB5F9lPUEH3scBIO9U=;
 b=NY+3dFg0p8H2udAxtk6wpcAH+UoszAVNuC79nSIc13C69Ck3iXoU2t+4s4uC0/6nuJ+2rS
 RZRasBqBp2iDgP0spE59BCmJw5quYEfyCnfcTGkn4q9q3KjUOxBT4t0+0XX4FxKFaz9Nts
 zgGMnZsoU59Ru6Zcgk6rw1tjKLvNiSefOAEC7fXLkofsVMGoIbMek8iWCczatn2/y+pGDe
 xPy0hy6Gtsv2Kjlp+8XrtA6py+m7/k0KpVEgffYIGQEVUEk7m18Rxbwu5TY0GxdMEUyXR5
 PzFKvPew7ORgwDcRsvDx+s8XYifDGgnlh9Nvtl5N3Cl0eVJ8pjDmUvguQQpmgQ==
X-Mailer: git-send-email 2.45.2
Mime-Version: 1.0
In-Reply-To: <20260515082045.63029-1-lizhe.67@bytedance.com>
Date: Fri, 15 May 2026 16:20:45 +0800
Message-Id: <20260515082045.63029-5-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260515082045.63029-1-lizhe.67@bytedance.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <arnd@arndb.de>, <rppt@kernel.org>, 
	<akpm@linux-foundation.org>, <david@kernel.org>
Subject: [PATCH 4/4] mm: use arch store helpers in zone-device template copies
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a06d7ab+374e7a+kvack.org+lizhe.67@bytedance.com>
Cc: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A6F191C0003
X-Rspam-User: 
X-Stat-Signature: picgu93ram3zjsdofjgia9wu7y9jm4kd
X-HE-Tag: 1778833330-207805
X-HE-Meta: U2FsdGVkX1+uvh20iocp9Z7QotX0F3QGiSGfm1hHFUZ3EViIfj8k42iMEWyhARLW2nX1BWsqOLuHz3WERHBSiQ+3uhb9xWcLBHndPuqxuvs2ol1t4afHOsuiHRKq/WBvElA9BTjhuVRC5/9ymK9wlyrGq7Y9uEJBNwe3/4F4e2DOv9AAfROMPSyalaybRG9X/8zcoL+6fL3uPUkbDm0HGyiozeXa10O8u9inbqAETHCpZZs9cJxiRGyE4Bkp7NJp0TLGpEIpHkg1Pp4tjb87lWpBtLWXbalLRJ1t+eYeDAEDB1+sVahEJRQlLW7oE9xVJSP3ISuqdDt0H26XODy8q6AdHalzkNBtdv4hO6po8aa9GTksuDbQAfTAXVe7FlMvfAb1HiK4OSsnJB9ITfGqZsw9smaJlSsGdmv5FnISjoA8aMQ6MzBxW1DDWfq6c07zI1PAxFnR14YztbpaFxqCLRanAnKRWj4VspNcDA9rwbnpWzjrj0LqmCKR30hB8l8PE0+9i60xCqpbt1zWVfjubSVltWxMTs69H6I4mn3loikUNYoBS9VYs5v7K47aJdG/7gcOtX1k4IZopC6kLyL8WzwCncWERl6+kBUlia6auQlXVGWsybVADNdNU6kGcKuVaE+lwZEL8gr6TEJ5wXc9LqCAwRrPsnmjKR5o+uUMha2EsUJRiEKAZ2iCC2UzLcRBLbKIGWghXJ2YydLQgvyVYI78vXddStYJyaG8J+rHwra/nM9CI3w4rBxFpsKffGszNKSEoDzk+96fgORj0fSXArbxBc5PXil/3rO6fz2jnzEySrH9pdCQtu9B4VEWi0gFXtv30yeAe4St9ji7+Ol3S7lKmEzFyLSH/YydufDTetyOhB5ClmsJJ/sLg/UfwDRPRrDGhXXwP+EiIS5r022itTumv/OXJQFu4E1AbcN4xBW1MNHAtekOAphHLMdEGTqddp2cxEf1T/sswEWt+N2
 8Ould5gL
 NYmfHFc/P/wmMX68B+Ou+lvtp57dE84/NzTquDhQ2AbjZ3LheNkDHFXWY7x1qIILch7+mR4MC9YMKc5TCP/sRVZrNJs3KXvAKwjpL22dFiWk5iaNUG5SBvRULNVL2+YANbN0/qd13Fx50yX64MRA6upflHk/vr/twQe9N5x7XP8akJqIDzcitCGTU5x6ZJMffJi24114Vhtt/+ZgEMSZvrssvS3j8zifTcOu1JCZzK+0ld7L54EijA7maBzHkW7EsJ3si
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The template-based fast path still leaves the actual copy sequence up to
the compiler. On x86-64 that can easily degrade back into a runtime copy
loop in the hot path, which leaves performance on the table.

Introduce arch_optimize_store_u64() and arch_optimize_store_drain(),
with a generic fallback and an x86-64 MOVNTI/SFENCE implementation, and
use them in the template copy path. Also open-code the word-at-a-time
copy so the compiler emits fixed-offset stores for the hot path instead
of a runtime loop.

On x86-64, MOVNTI is a better fit for this write-once, streaming
initialization pattern than normal cached stores. It reduces the
write-allocate traffic and cache pollution that a regular store sequence
would otherwise generate while filling large ranges of struct page.

Refresh the PFN-dependent section bits and page->virtual state in the
reusable template before each copy, instead of patching the destination
page afterwards. This keeps the hot path as a fixed-offset store
sequence and avoids post-copy normal stores to cachelines that were
just written with non-temporal stores.

Because non-temporal stores are not ordered against later normal stores,
drain outstanding stores before memmap_init_compound() updates compound
heads and before memmap_init_zone_device() returns.

Disable the x86-64 override under KASAN or KMSAN so those builds keep
their instrumented stores through the generic fallback.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
server.

Test procedure:
Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.1-rc3):
  First binding for nd_pmem driver: 1486 ms
  Average of subsequent rebinds: 273.52 ms

  First binding for dax_pmem driver: 1515 ms
  Average of subsequent rebinds: 313.45 ms

With this patch:
  First binding for nd_pmem driver: 1272 ms
  Average of subsequent rebinds: 104.59 ms

  First binding for dax_pmem driver: 1286 ms
  Average of subsequent rebinds: 116.93 ms

This reduces the average rebind time by about 61.8% for nd_pmem and
62.7% for dax_pmem.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 arch/x86/include/asm/struct_page_init.h | 28 ++++++++
 include/asm-generic/Kbuild              |  1 +
 include/asm-generic/struct_page_init.h  | 17 +++++
 mm/mm_init.c                            | 89 +++++++++++++++++++++----
 4 files changed, 122 insertions(+), 13 deletions(-)
 create mode 100644 arch/x86/include/asm/struct_page_init.h
 create mode 100644 include/asm-generic/struct_page_init.h

diff --git a/arch/x86/include/asm/struct_page_init.h b/arch/x86/include/asm/struct_page_init.h
new file mode 100644
index 000000000000..de8b4eab44de
--- /dev/null
+++ b/arch/x86/include/asm/struct_page_init.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_STRUCT_PAGE_INIT_H
+#define _ASM_X86_STRUCT_PAGE_INIT_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+/*
+ * x86-64 guarantees SSE2, so MOVNTI and SFENCE are always available there.
+ *
+ * KASAN/KMSAN rely on compiler-instrumented stores. Keep the x86 override
+ * disabled for those configs and fall back to plain stores instead.
+ */
+#if defined(CONFIG_X86_64) && !defined(CONFIG_KASAN) && !defined(CONFIG_KMSAN)
+static __always_inline void arch_optimize_store_u64(u64 *dst, u64 val)
+{
+	asm volatile("movnti %1, %0" : "=m"(*dst) : "r"(val));
+}
+
+static __always_inline void arch_optimize_store_drain(void)
+{
+	asm volatile("sfence" : : : "memory");
+}
+#else
+#include <asm-generic/struct_page_init.h>
+#endif
+
+#endif /* _ASM_X86_STRUCT_PAGE_INIT_H */
diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index 2c53a1e0b760..3a493fed6803 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -65,3 +65,4 @@ mandatory-y += vermagic.h
 mandatory-y += vga.h
 mandatory-y += video.h
 mandatory-y += word-at-a-time.h
+mandatory-y += struct_page_init.h
diff --git a/include/asm-generic/struct_page_init.h b/include/asm-generic/struct_page_init.h
new file mode 100644
index 000000000000..45a722103a51
--- /dev/null
+++ b/include/asm-generic/struct_page_init.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_GENERIC_STRUCT_PAGE_INIT_H
+#define _ASM_GENERIC_STRUCT_PAGE_INIT_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+static __always_inline void arch_optimize_store_u64(u64 *dst, u64 val)
+{
+	*dst = val;
+}
+
+static __always_inline void arch_optimize_store_drain(void)
+{
+}
+
+#endif /* _ASM_GENERIC_STRUCT_PAGE_INIT_H */
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5a9e6ecfa894..a3211666ccd4 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -37,6 +37,7 @@
 #include "shuffle.h"
 
 #include <asm/setup.h>
+#include <asm/struct_page_init.h>
 
 #ifndef CONFIG_NUMA
 unsigned long max_mapnr;
@@ -1078,9 +1079,21 @@ static inline bool zone_device_page_init_optimization_enabled(void)
 	return !page_ref_tracepoint_active(page_ref_set);
 }
 
+/*
+ * The fast path copies struct page with fixed-offset u64 stores instead of
+ * a runtime loop. Keep that copy sequence in sync with the struct page
+ * layouts supported by this build.
+ *
+ * The sequence below requires struct page to be u64-aligned and currently
+ * handles layouts from 7 to 12 u64 words (56 to 96 bytes). If a future
+ * layout falls outside that range, fail the build so the store sequence is
+ * updated together with the layout change.
+ */
 static inline void struct_page_layout_check(void)
 {
 	BUILD_BUG_ON(sizeof(struct page) & (sizeof(u64) - 1));
+	BUILD_BUG_ON(sizeof(struct page) < 56);
+	BUILD_BUG_ON(sizeof(struct page) > 96);
 }
 
 static inline void init_template_head_page(struct page *template,
@@ -1108,30 +1121,67 @@ static inline void init_template_tail_page(struct page *template,
 }
 
 /*
- * Initialize parts that differ from the template
+ * 'template' is a reusable page prototype rather than a strictly immutable
+ * object. Most ZONE_DEVICE fields stay constant across the pages covered by
+ * the current template, but section bits and page->virtual may still depend
+ * on the PFN. Refresh those PFN-dependent fields in the template before
+ * copying it into @page.
  */
-static inline void generic_init_zone_device_page_finish(struct page *page,
-							unsigned long pfn)
+static inline void zone_device_page_update_template(struct page *template,
+						    unsigned long pfn)
 {
 #ifdef SECTION_IN_PAGE_FLAGS
-	set_page_section(page, pfn_to_section_nr(pfn));
+	set_page_section(template, pfn_to_section_nr(pfn));
 #endif
 #ifdef WANT_PAGE_VIRTUAL
 	if (!is_highmem_idx(ZONE_DEVICE))
-		set_page_address(page, __va(pfn << PAGE_SHIFT));
+		set_page_address(template, __va(pfn << PAGE_SHIFT));
 #endif
 }
 
 static void init_zone_device_page_from_template(struct page *page,
-		unsigned long pfn, const struct page *template)
+		unsigned long pfn, struct page *template)
 {
 	const u64 *src = (const u64 *)template;
 	u64 *dst = (u64 *)page;
-	unsigned int i;
 
-	for (i = 0; i < sizeof(struct page) / sizeof(u64); i++)
-		dst[i] = src[i];
-	generic_init_zone_device_page_finish(page, pfn);
+	/*
+	 * 'template' carries the invariant portion of a ZONE_DEVICE struct
+	 * page. Update the PFN-dependent fields in place before copying it
+	 * to the destination page.
+	 */
+	zone_device_page_update_template(template, pfn);
+
+	/*
+	 * Keep the copy open-coded so the compiler emits fixed-offset stores
+	 * for the hot path instead of a runtime copy loop.
+	 */
+	switch (sizeof(struct page)) {
+	case 96:
+		arch_optimize_store_u64(&dst[11], src[11]);
+		fallthrough;
+	case 88:
+		arch_optimize_store_u64(&dst[10], src[10]);
+		fallthrough;
+	case 80:
+		arch_optimize_store_u64(&dst[9], src[9]);
+		fallthrough;
+	case 72:
+		arch_optimize_store_u64(&dst[8], src[8]);
+		fallthrough;
+	case 64:
+		arch_optimize_store_u64(&dst[7], src[7]);
+		fallthrough;
+	case 56:
+		arch_optimize_store_u64(&dst[6], src[6]);
+		arch_optimize_store_u64(&dst[5], src[5]);
+		arch_optimize_store_u64(&dst[4], src[4]);
+		arch_optimize_store_u64(&dst[3], src[3]);
+		arch_optimize_store_u64(&dst[2], src[2]);
+		arch_optimize_store_u64(&dst[1], src[1]);
+		arch_optimize_store_u64(&dst[0], src[0]);
+	}
+
 	zone_device_page_init_pageblock(page, pfn);
 }
 #else
@@ -1201,9 +1251,10 @@ static void __ref memmap_init_compound(struct page *head,
 	__SetPageHead(head);
 
 	/*
-	 * A tail template can be reused for all tail pages in the same compound page
-	 * because shared state for compound tails is pre-set by prep_compound_tail().
-	 * The per-page page->virtual and section in flags are fixed up after copying.
+	 * All tails of the same compound page share the state established by
+	 * prep_compound_tail(). Reuse one tail template for the whole range
+	 * and refresh only the PFN-dependent fields in that template before
+	 * each copy.
 	 */
 	if (use_template)
 		init_template_tail_page(&template, head_pfn + 1, zone_idx, nid,
@@ -1269,10 +1320,22 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		if (pfns_per_compound == 1)
 			continue;
 
+		/*
+		 * Compound-head setup immediately updates head->flags, so make
+		 * the template copy visible before entering memmap_init_compound().
+		 */
+		if (use_template)
+			arch_optimize_store_drain();
+
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
 				     compound_nr_pages(altmap, pgmap),
 				     use_template);
 	}
+	/*
+	 * Drain any remaining non-temporal stores before returning.
+	 */
+	if (use_template)
+		arch_optimize_store_drain();
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
-- 
2.20.1

