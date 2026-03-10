Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 500E7FD4F08
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 17:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835D56B008C; Tue, 10 Mar 2026 13:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9866B0095; Tue, 10 Mar 2026 13:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 709276B0096; Tue, 10 Mar 2026 13:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 496426B008C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:53:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DDADB1C2B3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:53:39 +0000 (UTC)
X-FDA: 84530900958.23.7EFA5F5
Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	by imf15.hostedemail.com (Postfix) with ESMTP id 105ABA001B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:53:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=ZOT7FhAC;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf15.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.17 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773165218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hW8Xl7auJ7eZebzUdWboADWoFiE8jqbtwE71lz2jc9s=;
	b=RCwzTfO3WQB6qUYbKoSBTzaJ1Eg4hHknKSUblcKqMralv1IkFw10JX+LOb5RCjNNRpX8fz
	+YkIwtrjEfy//EurZ5y1NdT0cC16O3aLZ1smdfk88Al2ae0ERIptzGmSDdUhFo+U8sJRlg
	deUFHKef3ph5EAnXWmsXmgPQcUiJS5c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773165218; a=rsa-sha256;
	cv=none;
	b=J5Z1VLdiyb0f4nI49rnOyyE78QjH6oNugXtoHGV1dxeKJvUrM8HosvzvqMyjA2w5DOUNJM
	9/KRyBtf805Kevu/5hB9HTWes+Y1B5WAosPVJF/JqDmtme1GLLfXIrD7YMreJgvv4iXrJk
	l0yRUDBm+cKJX9H9mXPXZ0TM6eOZdnQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=ZOT7FhAC;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf15.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.17 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1773165215; x=1773424415;
	bh=hW8Xl7auJ7eZebzUdWboADWoFiE8jqbtwE71lz2jc9s=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=ZOT7FhACkCBo8FHvyVNgtIcuTXogFaYpgBckqk6Bpd+GG6PkXObvvNrlWoXWySU+g
	 t7nERdRqcmEwEAVzdl5YIZw1QnN255m3wynl7fDQu4mAbnVFLMkg3ezvgTB4GgufVe
	 ZRguwVk3ArZj0a7mwHkh41bVkr8gYXVREzO0WWLvwQB9dTRx25TPjGVH9cbq6ItmC5
	 e+nV+hm778RpnUxMSQl0Li2Eheu6nr9dogx/kERF1eIKYr9ILP56xp3499fsqpChNq
	 qlqrAwVfHKHIoOKSnISDRNDFYi8rJoQcv4k9Wm1QPwelpTPzng/UwZSwtlF+KDVFEr
	 InxJohmrLvfGA==
Date: Tue, 10 Mar 2026 17:53:30 +0000
To: akpm@linux-foundation.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Samuel Holland <samuel.holland@sifive.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: [PATCH v11 02/15] kasan: arm64: x86: Make special tags arch specific
Message-ID: <35fe9ee0bfe99bfa72ac8c1dc5581c850d11c8ed.1773164688.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1773164688.git.m.wieczorretman@pm.me>
References: <cover.1773164688.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 046023e6163b6d6ade86f621b8452c4b2e6e74f6
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 105ABA001B
X-Stat-Signature: cfq8cj384pknp5k8rsnh56qgrnsmmqi4
X-Rspam-User: 
X-HE-Tag: 1773165217-537732
X-HE-Meta: U2FsdGVkX18u2CXClXly33gWEslWvhiqUYOZc3SQaDza8WNSwUBFgKz7LekzOAi1oh7zZ3FN3RkRyNk66dzsaEoNnM+F3n4O0UFEsXpqp/Mh/bGIo5WHHBWhH7WnGxVNEqBa+ibFgcPSHHCbH2rCzAUSDQGydeP68g23CBsaWfMrCJMDleTSeMF4u/rS7QVbsohiYPTXWAukHXN8vGFTIkqhMtLWgYQTK6wxwWBPWxM3dJ1WyAriMpXGTaAMz3CG/+w+8KzF3cRdIynyK0UniHiMWwHv+6c+auxE+Sgs8HfKuyfZFwywbPuwT+qf3ylbW9WXmINzTBb7k9TVNqwdx2WemdHgN+ltNNaiyHvwgvlVQjeUvgUDC08lEX6GRzJT3mFNXtCk/hnfSpvGiCsJ6z3FXhQmM+lVBfG2VpU9oQy/NEFiIxOnlUNMNMieqUZ27apExIAvomxGMlJq40sqmxfMJUYzuIp9Tzb/gudmZ5cqb4Al9oznZ2ZY2xkqMALB5ShcAbZOdJ2nd55hbwdzDV/VQcOIHfXy5+vHe+OMGTStlwcpvgZjEYCdhPNq2QbrUJ/UMqjVG29KChoe1PTPJGD57M4Ce3abxtGngUZJ0i34XcdhVTy2GjbhvqMxfSbvQUg0sXjn1NmlkR1jHIu2XY/Itzk7F6v9JKdky8uVuE/qkvispcEhwlktuvJGcAmBZJuHjui3gxNRC79PuTmnWthD5dyI3UAOh6hAN9G2gjZTcEBJrK9I9OIGTelBCigT7B0x3U/yhkqGyfx890E8AipN7KkvA5gVkXoZn4t5NaR98pE5SUt97KgJWPz/QdiGz/2ylcnYNTAJ/yL2W6gX+QWLcGgG/Cq+khPyJMX8sRZTDsbqHzu7NBWrF64XHFB+SI8wSsFo5VJeBBW78MBfHJDkeESn4kDVjPr0JNHjMj5bMNapalVn850xaSXfBnSrisXSXWzeE0gZ5qG0wCG
 hpPblsNx
 VuMI2Nm4DCJCdsmFI1agLG1z4drR0S0ezRgtHsSGowD6fby/v6CrCBxGjb4Mh48M8/q7S+o4zdAHjzYF1HthVQMoi4CTB2myjRHNV+KD3ciH6bNK5RYLXR21KCczE3oV5H6AfK5H6mL0Qbr7Xhh0oBHo+kBkuXvTf4uWHjcqbc/Lsy0eTrpY3HwneqEVzzT6f0tZdFLwHuiytk2lnhj3Ps1KTdM0iontqbFoof+S5syQvjNG6GPwzUouKqs/uYHELg30G04am8kDIt8LCOOYagmdCrDTxm9+QJxJZ1OCxM2Pk7PGG1VVbhq2AvgDIR9rCIU1FF8hLTbn8/BTPTtSDFhPTWZAHkr6uCRHVFclHD6FWALbnLKhP0f3fbPuHnBfzp4DVGTdETQWBeWEWMpCaWe3vDi6ueuBt6osz3sCpA2an5dyyIC77vWBJKxPNBABNpIPr7LrxZl8A+xRp6F4whuf4FA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Samuel Holland <samuel.holland@sifive.com>

KASAN's tag-based mode defines multiple special tag values. They're
reserved for:
- Native kernel value. On arm64 it's 0xFF and it causes an early return
  in the tag checking function.
- Invalid value. 0xFE marks an area as freed / unallocated. It's also
  the value that is used to initialize regions of shadow memory.
- Min and max values. 0xFD is the highest value that can be randomly
  generated for a new tag. 0 is the minimal value with the exception of
  arm64's hardware mode where it is equal to 0xF0.

Metadata macro is also defined:
- Tag width equal to 8.

Tag-based mode on x86 is going to use 4 bit wide tags so all the above
values need to be changed accordingly.

Make tag width and native kernel tag arch specific for x86 and arm64.

Base the invalid tag value and the max value on the native kernel tag
since they follow the same pattern on both mentioned architectures.

Also generalize KASAN_SHADOW_INIT and 0xff used in various
page_kasan_tag* helpers.

Give KASAN_TAG_MIN the default value of zero, and move the special value
for hw_tags arm64 to its arch specific kasan-tags.h.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Co-developed-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Acked-by: Will Deacon <will@kernel.org> (for the arm part)
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
Changelog v9:
- Add Andrey Ryabinin's Reviewed-by tag.
- Add Andrey Konovalov's Reviewed-by tag.

Changelog v8:
- Add Will's Acked-by tag.

Changelog v7:
- Reorder defines of arm64 tag width to prevent redefinition warnings.
- Remove KASAN_TAG_MASK so it's only defined in mmzone.h (Andrey
  Konovalov)
- Merge the 'support tag widths less than 8 bits' with this patch since
  they do similar things and overwrite each other. (Alexander)

Changelog v6:
- Add hardware tags KASAN_TAG_WIDTH value to the arm64 arch file.
- Keep KASAN_TAG_MASK in the mmzone.h.
- Remove ifndef from KASAN_SHADOW_INIT.

Changelog v5:
- Move KASAN_TAG_MIN to the arm64 kasan-tags.h for the hardware KASAN
  mode case.

Changelog v4:
- Move KASAN_TAG_MASK to kasan-tags.h.

Changelog v2:
- Remove risc-v from the patch.

 MAINTAINERS                         |  2 +-
 arch/arm64/include/asm/kasan-tags.h | 14 ++++++++++++++
 arch/arm64/include/asm/kasan.h      |  2 --
 arch/arm64/include/asm/uaccess.h    |  1 +
 arch/x86/include/asm/kasan-tags.h   |  9 +++++++++
 include/linux/kasan-tags.h          | 19 ++++++++++++++-----
 include/linux/kasan.h               |  3 +--
 include/linux/mm.h                  |  6 +++---
 include/linux/page-flags-layout.h   |  9 +--------
 9 files changed, 44 insertions(+), 21 deletions(-)
 create mode 100644 arch/arm64/include/asm/kasan-tags.h
 create mode 100644 arch/x86/include/asm/kasan-tags.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 39987895bcfc..29586c316ca4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13739,7 +13739,7 @@ L:=09kasan-dev@googlegroups.com
 S:=09Maintained
 B:=09https://bugzilla.kernel.org/buglist.cgi?component=3DSanitizers&produc=
t=3DMemory%20Management
 F:=09Documentation/dev-tools/kasan.rst
-F:=09arch/*/include/asm/*kasan.h
+F:=09arch/*/include/asm/*kasan*.h
 F:=09arch/*/mm/kasan_init*
 F:=09include/linux/kasan*.h
 F:=09lib/Kconfig.kasan
diff --git a/arch/arm64/include/asm/kasan-tags.h b/arch/arm64/include/asm/k=
asan-tags.h
new file mode 100644
index 000000000000..259952677443
--- /dev/null
+++ b/arch/arm64/include/asm/kasan-tags.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_KASAN_TAGS_H
+#define __ASM_KASAN_TAGS_H
+
+#define KASAN_TAG_KERNEL=090xFF /* native kernel pointers tag */
+
+#ifdef CONFIG_KASAN_HW_TAGS
+#define KASAN_TAG_MIN=09=090xF0 /* minimum value for random tags */
+#define KASAN_TAG_WIDTH=09=094
+#else
+#define KASAN_TAG_WIDTH=09=098
+#endif
+
+#endif /* ASM_KASAN_TAGS_H */
diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasan.=
h
index b167e9d3da91..fd4a8557d736 100644
--- a/arch/arm64/include/asm/kasan.h
+++ b/arch/arm64/include/asm/kasan.h
@@ -6,8 +6,6 @@
=20
 #include <linux/linkage.h>
 #include <asm/memory.h>
-#include <asm/mte-kasan.h>
-#include <asm/pgtable-types.h>
=20
 #define arch_kasan_set_tag(addr, tag)=09__tag_set(addr, tag)
 #define arch_kasan_reset_tag(addr)=09__tag_reset(addr)
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uacc=
ess.h
index 9810106a3f66..5465bc97ccdd 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -22,6 +22,7 @@
 #include <asm/cpufeature.h>
 #include <asm/mmu.h>
 #include <asm/mte.h>
+#include <asm/mte-kasan.h>
 #include <asm/ptrace.h>
 #include <asm/memory.h>
 #include <asm/extable.h>
diff --git a/arch/x86/include/asm/kasan-tags.h b/arch/x86/include/asm/kasan=
-tags.h
new file mode 100644
index 000000000000..68ba385bc75c
--- /dev/null
+++ b/arch/x86/include/asm/kasan-tags.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_KASAN_TAGS_H
+#define __ASM_KASAN_TAGS_H
+
+#define KASAN_TAG_KERNEL=090xF /* native kernel pointers tag */
+
+#define KASAN_TAG_WIDTH=09=094
+
+#endif /* ASM_KASAN_TAGS_H */
diff --git a/include/linux/kasan-tags.h b/include/linux/kasan-tags.h
index 4f85f562512c..ad5c11950233 100644
--- a/include/linux/kasan-tags.h
+++ b/include/linux/kasan-tags.h
@@ -2,13 +2,22 @@
 #ifndef _LINUX_KASAN_TAGS_H
 #define _LINUX_KASAN_TAGS_H
=20
+#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
+#include <asm/kasan-tags.h>
+#endif
+
+#ifndef KASAN_TAG_WIDTH
+#define KASAN_TAG_WIDTH=09=090
+#endif
+
+#ifndef KASAN_TAG_KERNEL
 #define KASAN_TAG_KERNEL=090xFF /* native kernel pointers tag */
-#define KASAN_TAG_INVALID=090xFE /* inaccessible memory tag */
-#define KASAN_TAG_MAX=09=090xFD /* maximum value for random tags */
+#endif
+
+#define KASAN_TAG_INVALID=09(KASAN_TAG_KERNEL - 1) /* inaccessible memory =
tag */
+#define KASAN_TAG_MAX=09=09(KASAN_TAG_KERNEL - 2) /* maximum value for ran=
dom tags */
=20
-#ifdef CONFIG_KASAN_HW_TAGS
-#define KASAN_TAG_MIN=09=090xF0 /* minimum value for random tags */
-#else
+#ifndef KASAN_TAG_MIN
 #define KASAN_TAG_MIN=09=090x00 /* minimum value for random tags */
 #endif
=20
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 81c83dcfcebe..c6febd1362e8 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -40,8 +40,7 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
 /* Software KASAN implementations use shadow memory. */
=20
 #ifdef CONFIG_KASAN_SW_TAGS
-/* This matches KASAN_TAG_INVALID. */
-#define KASAN_SHADOW_INIT 0xFE
+#define KASAN_SHADOW_INIT KASAN_TAG_INVALID
 #else
 #define KASAN_SHADOW_INIT 0
 #endif
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 25d5c2395b40..b2245b1a25d8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2210,7 +2210,7 @@ static inline u8 page_kasan_tag(const struct page *pa=
ge)
=20
 =09if (kasan_enabled()) {
 =09=09tag =3D (page->flags.f >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
-=09=09tag ^=3D 0xff;
+=09=09tag ^=3D KASAN_TAG_KERNEL;
 =09}
=20
 =09return tag;
@@ -2223,7 +2223,7 @@ static inline void page_kasan_tag_set(struct page *pa=
ge, u8 tag)
 =09if (!kasan_enabled())
 =09=09return;
=20
-=09tag ^=3D 0xff;
+=09tag ^=3D KASAN_TAG_KERNEL;
 =09old_flags =3D READ_ONCE(page->flags.f);
 =09do {
 =09=09flags =3D old_flags;
@@ -2242,7 +2242,7 @@ static inline void page_kasan_tag_reset(struct page *=
page)
=20
 static inline u8 page_kasan_tag(const struct page *page)
 {
-=09return 0xff;
+=09return KASAN_TAG_KERNEL;
 }
=20
 static inline void page_kasan_tag_set(struct page *page, u8 tag) { }
diff --git a/include/linux/page-flags-layout.h b/include/linux/page-flags-l=
ayout.h
index 760006b1c480..b2cc4cb870e0 100644
--- a/include/linux/page-flags-layout.h
+++ b/include/linux/page-flags-layout.h
@@ -3,6 +3,7 @@
 #define PAGE_FLAGS_LAYOUT_H
=20
 #include <linux/numa.h>
+#include <linux/kasan-tags.h>
 #include <generated/bounds.h>
=20
 /*
@@ -72,14 +73,6 @@
 #define NODE_NOT_IN_PAGE_FLAGS=091
 #endif
=20
-#if defined(CONFIG_KASAN_SW_TAGS)
-#define KASAN_TAG_WIDTH 8
-#elif defined(CONFIG_KASAN_HW_TAGS)
-#define KASAN_TAG_WIDTH 4
-#else
-#define KASAN_TAG_WIDTH 0
-#endif
-
 #ifdef CONFIG_NUMA_BALANCING
 #define LAST__PID_SHIFT 8
 #define LAST__PID_MASK  ((1 << LAST__PID_SHIFT)-1)
--=20
2.53.0



